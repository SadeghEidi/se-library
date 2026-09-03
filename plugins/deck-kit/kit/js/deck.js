/* ============================================================
   DECK KIT · runtime
   ------------------------------------------------------------
   Everything a slide file should not have to repeat: reveal
   configuration, page furniture, the progress rule, number
   count-ups, and the two query-string modes that matter.

   Modes
     ?qa        every fragment shown, all motion frozen. This is
                what the screenshot pass and the PDF export use, so
                a slide is never captured mid-animation.
     ?print-pdf reveal's own paged layout, for chromium --print-to-pdf.

   Read the config off the <body> data attributes so one runtime
   serves every deck: data-deck-title, data-deck-footer,
   data-deck-logo.
   ============================================================ */
(function () {
  'use strict';

  var params = new URLSearchParams(location.search);
  var QA = params.has('qa');
  var PRINT = params.has('print-pdf');
  var STATIC = QA || PRINT || window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (QA) document.documentElement.classList.add('qa');
  // reveal.css carries a "printed on paper" stylesheet under
  // html:not(.print-pdf) that unpins every absolutely positioned slide, and
  // ours are absolutely positioned. Claiming the class opts out of it.
  //
  // It is not enough on its own: measured 2026-09-03, neither
  // chromium --print-to-pdf nor a CDP Page.printToPDF with an explicit
  // 1920x1080 paper size gets reveal 5 to paginate this layout past two
  // pages. The PDF is therefore built from per-slide captures instead, in
  // bin/deck.sh, and this only keeps the browser's own Print command honest.
  if (PRINT) document.documentElement.classList.add('print-pdf');

  var body = document.body;
  var FOOTER = body.getAttribute('data-deck-footer') || '';
  var LOGO = body.getAttribute('data-deck-logo') || '';

  /* ---- page furniture -----------------------------------
     Written in here rather than in every slide, because the one
     thing that always drifts in a hand-built deck is the footer:
     one slide ends up with last month's date on it and nobody
     notices until it is on the screen. */
  function chrome() {
    var slides = [].slice.call(document.querySelectorAll('.reveal .slides section.slide'));
    slides.forEach(function (s, i) {
      if (s.querySelector('.foot')) return;
      var foot = document.createElement('div');
      foot.className = 'foot';
      var bits = [];
      if (LOGO) bits.push('<img src="' + LOGO + '" alt="">');
      if (LOGO && FOOTER) bits.push('<span class="sep"></span>');
      if (FOOTER) bits.push('<span class="pg">' + FOOTER + '</span>');
      foot.innerHTML = bits.join('');
      s.appendChild(foot);

      // Page number, right side. The cover is page 0 and shows none.
      if (i > 0) {
        var r = document.createElement('div');
        r.className = 'foot-r';
        r.textContent = String(i).padStart(2, '0') + ' / ' + String(slides.length - 1).padStart(2, '0');
        s.appendChild(r);
      }
    });
  }

  /* ---- count-up -----------------------------------------
     Any element with data-count="1240" counts from 0 to that value
     when its slide arrives, once. The value is only ever set from
     the attribute, so the printed and QA states show the true
     number rather than a zero.

     Duration is fixed at 900ms regardless of magnitude: a count-up
     whose length varies with the number reads as a progress bar,
     not as an effect. Eased with the same decelerate curve as
     everything else, so the last digits settle rather than snap. */
  function countUp(el) {
    if (el.dataset.counted === '1') return;
    el.dataset.counted = '1';
    var target = parseFloat(el.getAttribute('data-count'));
    if (isNaN(target)) return;
    var decimals = parseInt(el.getAttribute('data-decimals') || '0', 10);
    var prefix = el.getAttribute('data-prefix') || '';
    var suffix = el.getAttribute('data-suffix') || '';
    var render = function (v) {
      el.firstChild && el.firstChild.nodeType === 3
        ? (el.firstChild.nodeValue = prefix + v + suffix)
        : (el.textContent = prefix + v + suffix);
    };
    if (STATIC) { render(target.toFixed(decimals)); return; }

    var dur = 900, t0 = null;
    function frame(t) {
      if (t0 === null) t0 = t;
      var p = Math.min(1, (t - t0) / dur);
      var eased = 1 - Math.pow(1 - p, 3);   // matches cubic-bezier(0.16,1,0.3,1) closely enough
      render((target * eased).toFixed(decimals));
      if (p < 1) requestAnimationFrame(frame);
    }
    requestAnimationFrame(frame);
  }

  function countSlide(slide) {
    if (!slide) return;
    [].slice.call(slide.querySelectorAll('[data-count]')).forEach(countUp);
  }

  /* ---- progress rule ------------------------------------ */
  var bar;
  function progress() {
    if (PRINT) return;
    if (!bar) {
      bar = document.createElement('div');
      bar.className = 'deck-progress';
      document.body.appendChild(bar);
    }
    var i = Reveal.getIndices().h;
    var n = Reveal.getTotalSlides() - 1;
    bar.style.width = (n > 0 ? (i / n) * 100 : 0) + '%';
  }

  /* ---- keyboard extras ----------------------------------
     G toggles the 12-column grid, which is the check that catches
     a card that is 6px off the column and looks merely "a bit
     wrong" without anyone being able to say why. */
  function grid() {
    var g = document.getElementById('deck-grid');
    if (g) { g.remove(); return; }
    g = document.createElement('div');
    g.id = 'deck-grid';
    g.style.cssText = 'position:fixed;inset:0;z-index:60;pointer-events:none;' +
      'padding:96px 110px;box-sizing:border-box;display:grid;' +
      'grid-template-columns:repeat(12,1fr);gap:32px;';
    for (var i = 0; i < 12; i++) {
      var c = document.createElement('div');
      c.style.cssText = 'background:rgba(255,0,80,.08);border-left:1px solid rgba(255,0,80,.35);' +
        'border-right:1px solid rgba(255,0,80,.35);';
      g.appendChild(c);
    }
    document.body.appendChild(g);
  }

  chrome();

  Reveal.initialize({
    width: 1920,
    height: 1080,
    margin: 0,
    minScale: 0.2,
    maxScale: 2.0,
    hash: true,
    controls: false,
    progress: false,          // the kit draws its own, thinner
    slideNumber: false,       // the kit draws its own, in the frame
    transition: STATIC ? 'none' : 'fade',
    transitionSpeed: 'fast',
    backgroundTransition: 'fade',
    fragments: !QA,
    fragmentInURL: false,
    overview: true,
    center: false,
    disableLayout: false,
    pdfSeparateFragments: false,   // one page per slide, fragments flattened
    pdfMaxPagesPerSlide: 1,
    keyboard: {
      71: grid,   // G
    },
  });

  Reveal.on('ready', function (e) { progress(); countSlide(e.currentSlide); });
  Reveal.on('slidechanged', function (e) { progress(); countSlide(e.currentSlide); });

  // QA and print want every counter resolved immediately, on every
  // slide, not only the one on screen.
  if (STATIC) {
    Reveal.on('ready', function () {
      [].slice.call(document.querySelectorAll('[data-count]')).forEach(countUp);
    });
  }
})();
