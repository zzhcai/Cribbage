# Summary

Cribbage is a very old card game, dating to early 17th century England. There are 2, 3, and 4 handed versions of the game. The object of the game is to be the first player to reach 121 points. Game play begins with the dealer dealing each player 6 cards (in a 2-player game) or 5 cards (in a 3 or 4 player game). In a 3 player game, the dealer also deals one card to a separate hand called the crib or box. Each player then chooses 1 or 2 cards to discard, keeping 4 and putting the discarded cards in the crib or box, which forms a second 4-card hand for the dealer. Next the player preceding the dealer cuts the deck to select an extra card, called the start card. If the start card is a Jack, the dealer immediately scores 2 points.

The hand then proceeds to the play, wherein the players take turns playing cards from their hands face up in front of them. The play will not be part of this project, so we will not discuss it further.

<br/>

Following the play comes the show, where each player in turn, beginning with the player after the dealer, establishes the value of her hand. For this phase, the start card is usually considered as part of each player's hand, so each player establishes the value of a 5 card hand. Points are scored for certain combinations of cards according to the following rules:

1. (15s) 2 points are scored for each distinct combinations of cards that add to 15. For this purpose, an ace is counted as 1, and a jack, queen or king are counted as 10, and other cards count as their face value. For example, a hand with a 2, 3, 5, 10, and king scores 8 points: 2 points each for 2+3+10, 2+3+king, 5+10, and 5+king.

2. (Pairs) 2 points are scored for each pair. With 3 of a kind, there are 3 different ways to make a pair, so 3 of a kind scores 6 points. Similarly, 4 of a kind scores 12 points for the 6 possible pairs.

3. (Runs) 1 point is scored for each card in a run of 3 or more consecutive cards (the suits of these cards need not be the same). For example, a 2, 6, 8, and 9, with a 7 as the start card scores 4 points for a 4 card run. It also scores a further 6 points for 15s (6+9, 7+8, and 2+6+7).

4. (Flushes) 4 points is scored if all the cards in the hand are of the same suit. 1 further point is scored if the start card is also the same suit. Note that no points are scored if 3 of the hand cards, plus the start card, are the same suit.

5. ("One for his nob") 1 point is scored if the hand contains the jack of the same suit as the start card.

<br/>

All of these points are totalled to find the value of a hand. For example (using A for ace, T for 10, J for jack, Q for queen, and K for king, and ♣, ♦, ♥, and ♠ as clubs, diamonds, hearts, and spades):

<br/>

| Hand	         | Start card | Points |
| :---           | :---       |   ---: |
| 7♣, Q♥, 2♣, J♣ | 9♥	        | 0      |
| A♠, 3♥, K♥, 7♥ | K♠         | 2      |
| A♠, 3♥, K♥, 7♥ | 2♦	        | 5      |
| 6♣, 7♣, 8♣, 9♣ | 8♠	        | 20     |
| 7♥, 9♠, 8♣, 7♣ | 8♥  	      | 24     |
| 5♥, 5♠, 5♣, J♦ | 5♦         | 29     |

<br/>

Following the show of each player's hand, the dealer counts the crib as a second hand, claiming any points therein.

Finally, the player following the dealer collects the cards, becoming dealer for the next hand. Play proceeds this way until one player reaches 121 points.


# Marks

- 13.3/15 (88.5%)

  ```
  pass Validation
  pass hand_value for a pair
  pass hand_value test 1
  pass hand_value test 2
  pass hand_value test 3
  pass hand_value test 4
  pass hand_value test 5
  pass hand_value test 6
  pass hand_value test 7
  pass hand_value test 8
  pass hand_value test 9
  pass hand_value test 10
  select_hand simple test result percentage: 100
  select_hand test 1 result percentage: 100
  select_hand test 2 result percentage: 100
  select_hand test 3 result percentage: 100
  select_hand test 4 result percentage: 100
  select_hand test 5 result percentage: 100
  select_hand test 6 result percentage: 100
  select_hand test 7 result percentage: 100
  select_hand test 8 result percentage: 100
  select_hand test 9 result percentage: 100
  select_hand test 10 result percentage: 100
  ```

- You've made some good use of Prolog, for example with maplist. But overall your code is written too much in an imperative-like style, with too much explicit use of if-then-else, which you should reserve for only those case where you can't achieve what you want through normal Prolog execution. Unclear or not very helpful summary near top of file. Little or no file-level documentation.
