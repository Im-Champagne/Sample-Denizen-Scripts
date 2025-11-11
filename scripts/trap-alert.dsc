# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | The Concept: "Mom's Simple Security"                            | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | Description: This script prevents accidental prying eyes by     | #
# | setting a small, automagical security trigger on a Trapped      | #
# | Chest. When any player other than the owner opens it, the owner | #
# | is immediately notified!                                        | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# v                                                                 v #
# -                     *       ..     .-.   *                      - #
# -                         .  ..   .:.                      ˚      - #
# -         *             ..  ..=. . .  *        *                  - #
# -                     ...:  ....-..:..:.           +              - #
# -  ˚              o     .: . .==  ..       o             ˚        - #
# -          x          .=-+=: .  :. :. .:                          - #
# -                    .+-+:-.-*:..=*:   .-                         - #
# -                   :-*= -:.-:-*-: .:              *              - #
# -      ˚           +:*:::+.. .:.-.   .       '                    - #
# -                 +*#=+-+===*--+.                    .            - #
# #               .**#+.:.:-+:.+-     ‧₊˚✧ Made By  ₊‧✩             - #
# #              :+=*.-....--:+=.    ✩‧₊˚Champagne 🥂.₊✩*'         - #
# -              +=%.:..-...:*-    ˚                                - #
# #             -=*:.::.:+:-+:          11 / 11 / 25                - #
# #             +--....::.=*.    '      Version 1.03                - #
# -             .*=:--::===.                             o          - #
# -              *===++==.                                          - #
# -       ˚     +:==:.                                              - #
# -            .=:=.                         ˚                      - #
# -            ==-                                                  - #
# -          .+--         o                                         - #
# -         .=*.                                      x             - #
# -        :+=.                                                     - #
# -       -:#.                                                      - #
# -   -=-===+-*.                       +                            - #
# - .=*+..+.                                                        - #
# ^                                                                 ^ #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | Idea: Use Denizen's location flagging to tag a TRAPPED_CHEST    | #
# | when placed. If the chest is opened by anyone NOT the owner,    | #
# | the owner receives an instant alert if they are online.         | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | Result: A simple, non-destructive security system for high-     | #
# | value Trapped Chests, ensuring the owner gets an alert and      | #
# | maximum happiness (from knowing their stuff is watched)!        | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
trapalert_listener:
  type: world
  debug: false
  events:
    # Event 1: Flag the chest when the owner places it.
    after player places TRAPPED_CHEST:
      # Define the data map containing the owner and time.
      - definemap data:
          owner: <player>
          time: <util.time_now>
      # Flag the location with the owner and time data.
      # The flag is named 'champagne.trap-alert'
      - flag <context.location> champagne.trap-alert:<[data]>
      # Narrate a confirmation to the owner.
      - narrate "<&a>~* Trap-Alert Set! *~<&r> This chest is now protected and will notify you when opened!"
      # Give the player a little sparkle of feedback!
      - playsound <player> sound:BLOCK.AMETHYST_BLOCK.CHIME
      # Use to spawn a cloud of rainbow-colored ENTITY_EFFECT particles around yourself.
      - foreach <util.color_names> as:color:
        - playeffect effect:ENTITY_EFFECT at:<context.location.center> quantity:25 special_data:[color=<[color]>] offset:0.5


    # Event 2: Clean up the flag when the owner breaks the chest.
    after player breaks block:
      # Check if the block is a Trapped Chest
      - if <context.location.material.name> == TRAPPED_CHEST:
        # Check if the block is flagged AND the breaker is the owner
        # We need to check if the flag exists first to prevent a bork
        - if <context.location.has_flag[champagne.trap-alert]> && <context.location.flag[champagne.trap-alert.owner]> == <player>:
          # Clear the flag! Tidy-up complete!
          - flag <context.location> champagne.trap-alert:!
          - narrate "<&a>~* Tidy Sparkle! *~<&r> trap-alert cleared for that chest."
          # Give the player a little sparkle of feedback!
          - playsound <player> sound:BLOCK.AMETHYST_BLOCK.CHIME
          # Use to spawn a cloud of rainbow-colored ENTITY_EFFECT particles around yourself.
          - foreach <util.color_names> as:color:
            - playeffect effect:ENTITY_EFFECT at:<context.location.center> quantity:25 special_data:[color=<[color]>] offset:0.5

    # Event 3: Check when a player opens an inventory flagged by our script.
    # The 'location_flagged' context ensures this only fires on our placed chests.
    after player opens inventory location_flagged:champagne.trap-alert:
      # Check if the opener is NOT the chest owner
      # We use the location flag value to get the owner's PlayerTag.
      - if <context.inventory.location.flag[champagne.trap-alert.owner]> != <player>:
        # Define the chest's owner from the flag data for cleaner use
        - define chest_owner <context.inventory.location.flag[champagne.trap-alert.owner]>
        # Check if the owner is currently online
        - if <[chest_owner].is_online>:
          # Narrate the alert to the owner! (The automagical security!)
          - narrate "<&c>ALERT: <&e><player.name><&c> just opened your Trapped Chest at <&e><context.location.simple><&c>!" targets:<[chest_owner]>
          # Optional: Narrate a non-alarming message to the player opening the chest.
          # - narrate "<&7>~* This chest feels... watched... *~"
          # Tip: Don't forget to add some flare!
          # - playsound <player> sound:BLOCK.FIRE.EXTINGUISH
          # - playeffect effect:FLAME at:<context.inventory.location.center> quantity:25 offset:0.5
