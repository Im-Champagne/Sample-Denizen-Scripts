# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | The Concept: "The Instant Tidy-Upper"                           | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | Description: This script solves a classic problem in Vanilla    | #
# | Minecraft when you place a Shulker Box, you have to carefully   | #
# | empty your inventory slots into it, then break it again. This   | #
# | script makes that process automagically!                        | #
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
# #             -=*:.::.:+:-+:          11 / 07 / 25                - #
# #             +--....::.=*.    '      Version 1.07                - #
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
# | Idea: When a player sneaks (default: shift-key) while breaking  | #
# | a Shulker Box, the script will instantly swap the contents of   | #
# | the broken Shulker Box with the contents of the player's main   | #
# | inventory (everything but the hotbar and armor).                | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #
# | Result: Players can dump their main inventory into a Shulker    | #
# | Box with one key press, making instant storage and quick base   | #
# | tidying fast and easy!                                          | #
# x ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ x #

# This script makes inventory management quick and easy!
instant_tidy_upper:
  type: world
  debug: false
  events:
    # When a player breaks a block
    on player breaks block:
      # Check if the block is a shulker box AND the player is sneaking
      - if <context.block.material.name> == shulker_box && <player.is_sneaking>:

        # 1. Store the player's main inventory contents (slots 10 through 36)
        # These are the main 27 slots, excluding hotbar/armor/offhand.
        - define player_inv <player.inventory.slot[10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36]>

        # 2. Store the shulker box's full inventory contents from it's location
        - define shulker_inv <context.location.inventory.list_contents>

        # 3. Swap the contents!
        # Put the player's old inventory into the shulker box location inventory
        - inventory set destination:<context.location.inventory> origin:<[player_inv]>

        # Put the shulker box's old inventory back into the player's main slots, starting at slot 10.
        - inventory set destination:<player.inventory> origin:<[shulker_inv]> slot:10

        # 4. Give the player a little sparkle of feedback!
        - narrate "<&e>~* <&b>Champagne's Tidy-Upper! <&e>~* Inventory contents swapped!"
        - playsound <player> sound:block.amethyst_block.chime
        # Use to spawn a cloud of rainbow-colored ENTITY_EFFECT particles around yourself.
        - foreach <util.color_names> as:color:
          - playeffect effect:ENTITY_EFFECT at:<context.location> quantity:25 special_data:[color=<[color]>]

        # 5. Cancel the block break event so the box stays put with its new contents.
        - determine cancelled
