{:title       "Human Perception and Cognition"
 :layout      :post
 :draft?      true
 :summary     "
              "
 :excerpt     "This is a summary of Lesson 3 on Alan Dix's course: Human-Computer Interaction - HCI."
 :description ""
 :date        "2019-08-11"
 :tags        ["research"
               "design"
               "hci"
               "ixd"]}

-------------------------------------------------------------------------------

This is a summary on [Lesson 3](https://www.interaction-design.org/courses/human-computer-interaction/lessons/3 "Cognition and Perception") of [Alan Dix](https://alandix.com)'s [HCI](https://en.wikipedia.org/wiki/Human%E2%80%93computer_interaction "Human-Computer Interaction") course of the [IDF](https://www.interaction-design.org "Interaction Design Foundation").

-------------------------------------------------------------------------------

Computational Analogy
---------------------

We can look at human [cognition](https://en.wikipedia.org/wiki/Cognition) using [computation](https://en.wikipedia.org/wiki/Computation) [analogies](https://en.wikipedia.org/wiki/Analogy) like the following:

### Flow ###

``` shell
Human    : [Perception] -> [Cognition] -> [Action]
                ^               ^            ^
                |               |            |
                v               v            v
Computer : [  Input   ] -> [ Process ] -> [Output]
```

### Analogies ###

#### Human ####

- [Perception](https://en.wikipedia.org/wiki/Perception) - ???
- [Cognition](https://en.wikipedia.org/wiki/Cognition) - ???
- [Action](https://en.wikipedia.org/wiki/Action_\(philosophy\)) - ???

### Computer ###

- [Input](https://en.wikipedia.org/wiki/Input_\(computer_science\)) - ???
- [Process](https://en.wikipedia.org/wiki/Process_\(computing\)) - ???
- [Output](https://techterms.com/definition/output) - ???


### A cycle of interaction ###

```
perception <- cognition
    |             ^
    v             |
the world  ->   action
```

-------------------------------------------------------------------------------

The Five Senses
---------------

1. Sight (eyes)
2. Hearing (ears)
3. Smell (nose)
4. Touch (hands)
5. Taste (tounge)

- sight (1) & hearing (2) distance (far)
- smell (3) distance (near)
- touch (4) contact (outside)
- taste (5) contact (inside)

- exteroception (five senses): external sensing (the world)
- interoception: internal sensing (body)
  - proprioception (awareness of position and movement of body)
  - haptic feedback (haptics, simulating sense of touch)

- sight
  - most used sense in interfaces
  - half (50%) devoted to processing visual information

-------------------------------------------------------------------------------

Eye and Vision
--------------

- sight
  - major sense
  - half of brain dedicated to vision
  - majority of computer output

- eye
  - what you can see
    - pupil (lense)
    - iris (muscles)
  - upside down image (lens inverted)
  - cells to detect light (rods and cones)
  - optic nerve - blind spot (filling in)

| Cones        | Rods        |
| :----------- | :---------- |
| central      | peripheral  |
| color (3)    | grey only   |
| detail       | movement    |
| bright light | dim light   |

- fovea
  - center of vision
  - mainly cones
  - small => need saccades

- peripheral vision
  - mainly rods
  - detect movement -> catch attention

- two eyes
  - stereo vision
  - left & right visual fields 'cross over'

- two channels
  - old - rapid reactions and primitive response
  - new - conscious vision

what we really see
- sensation (direct impact of light on retina)
- perception (what we feel we see, e.g. optical illusion)

optical illusions
- often oddd eye positions, unusual images

perception
- designed for the real world
- our brain tries to make sense of sensation

- for design?

-------------------------------------------------------------------------------

Ear and Sound
-------------

- second sense
- critically important (esp. communication, e.g. speech)
- less used in interface
  - annoying for others
  - less directional, more diffuse
  - strength and weakness
- varies
  - pitch (frequency)
  - volume
  - timbre (the shape)
  - e.g. violin vs. big bass drum
- ear
  - sensitive from ~20Hz to 20KHz
  - changing w/ age
  - balance organs in inner ear
  - two ears
    - stereo sound => left-right direction
  - pinna (visible ear)
  - directional
  - changes shape of sound => full 3d sound
- vision vs sound
  - vision: static
  - sound: cannot be static (always changing or no sound at all)
    - always about change
    - about vibration, movement, pressure waves
  - binaural hearing
    - distance between ears ~ 30 cm
    - speed of sound ~ 340 ms
    - delay left-right ~ 1 ms
  - affects propagation in spaces, resonance

- in the interface
  - simple sounds (beep, ring, buzz)
    - attention grabbing feedback
      - delays, gaps, jitter
  - ecological (thump and gurgle)
    - what is happening
  - speech and music
    - recorded (download & play)
    - live (streaming movie)
    - interactive (skype and video calls)
  - aural feedback
  - the movie soundtrack
    - may not be notice at a time (setting the mood)
  - engagement in the video games and VR
    - the sub-seat woofer
  - can focus our attention
    - the cocktail party effect
  - general sense of context
    - arkola
  - can grab attention
    - big bang or softly whispered name

-------------------------------------------------------------------------------

Sight and Sound
---------------

- Sight and Sound
  - Eyes and Vision
    - front
      - iris & pupils (lens) - adjust light level and focus
      - two of them - 3d vision - but not the only way
    - back
      - fovea - detailed and color but very small
        - peripheral vision - b&w, movement, grabs attention
    - inside
      - two pathways
          - fast, old, unconscious
          - slower, new, conscious

- Ears and Sound
  - temporal
    - no still sound (issues for media)
  - two of them & pinna
    - directional, stereo, full 3d
  - little physical focus, but
    - attention - cocktail party effect
    - background - context and grab attention

- Commonalities of Eyes and Ears

  ``` shell
  attention (focus is limited) --> construction (filling gaps)
            ^
            |
  grabbing attention
            |
  periphery (context, broader, but unconscious)
  ```

- binaural hearing

-------------------------------------------------------------------------------

Man-Machine Nightmares
----------------------

- Human error
  - knowledge-based errors (lack of knowledge)
  - slip errors (forgetting)
    - resilient strategies
  - limitations of training
- device design
- system design
