# Motion

## The whole vocabulary

Four mechanisms. That is the entire budget for a deck.

1. **Rise on arrival.** Content translates 18px up and fades in over 420ms.
   Class `rise`.
2. **Stagger.** Grouped items arrive 70ms apart, in reading order. Class
   `stagger` on the container.
3. **Count-up.** A number counts from zero to its value over a fixed 900ms.
   `data-count="1240"`, plus `data-decimals`, `data-prefix`, `data-suffix`.
4. **Stepped reveal.** reveal.js fragments, styled `fade-in-up` to match.

One easing curve everywhere: `cubic-bezier(0.16, 1, 0.3, 1)`. It is a
decelerate: fast out, slow in, which reads as something arriving under its own
weight rather than being animated at you. Slide-to-slide transition is a fast
cross-fade, never a push, cube, or zoom.

## The rules

- **Motion directs the eye, it does not entertain.** Its only job is to say
  "this is the thing that just arrived". An audience that notices the
  transition has stopped listening.
- **Duration under 500ms** for anything the speaker is waiting on. A 700ms
  chart growth is the longest thing in the kit and it is the exception.
- **Fixed duration for the count-up, whatever the number.** A count whose
  length varies with its magnitude reads as a progress bar.
- **Tabular figures on any counting number.** Without them the digits change
  width mid-count and the number jitters sideways. This one detail is the
  difference between a count-up that looks premium and one that looks like a
  jQuery plugin.
- **Ambient motion must be slow and singular.** The dark theme's aurora drifts
  over 22 seconds. One slow thing in the background is atmosphere; two is a
  screensaver.
- **Stepped reveals are for when the order is the argument.** Never to hide a
  bullet list from a room that could have read it in three seconds.
- **`prefers-reduced-motion` turns all of it off**, and the kit already honours
  it. Someone who asked their OS to stop animating things meant it.

## What makes motion look cheap

Bounce and elastic easing. Anything entering from off-slide left or right.
Rotation. Scale-from-zero on text. Per-letter animation. Different easings on
different elements of the same slide. Any effect that plays while the speaker
is mid-sentence and cannot be skipped. Auto-advancing slides.

## Micro-interactions

The kit has one hover affordance (`hoverable`: 3px lift, 180ms) for decks that
are clicked through rather than presented, such as a product walkthrough sent as
a link. In a deck that will only ever be projected, hover states are invisible
and not worth building.

The strongest "micro-interaction" in a pitch is not an effect at all: it is a
real, working product screen embedded in the slide, stepping through its own
states.
