%% hand_value(+Hand, +Startcard, ?Value)
%  Unifies Value with the total cribbage point value of Hand and Startcard.
hand_value(Hand, Start, Value) :-
        maplist(card_rank, [Start|Hand], RList), msort(RList, RankList),
        fifteens(RankList, V1),
        runs(RankList, V2),
        freq_dict(RankList, RankDict),
        pairs(RankDict, V3),
        maplist(card_suit, Hand, SuitList), Start = card(_, S0),
        flushes(SuitList, S0, V4),
        nob(Hand, S0, V5),
        Value is V1 + V2 + V3 + V4 + V5.

%% card_rank(+Card, -Rank)
%  Count A as 1, J as 11, Q as 12, K as 13, unifies rank of a card to Rank.
card_rank(card(ace, _), 1).
card_rank(card(jack, _), 11).
card_rank(card(queen, _), 12).
card_rank(card(king, _), 13).
card_rank(card(R, _), R) :- integer(R).

%% card_suit(+Card, -Suit)
%  Unifies suit of a card to Suit.
card_suit(card(_, S), S).

%% freq_dict(+RankList, -RankDict)
%  RankDict is like a dictionary of (key=Rank, value=Freq), sorted on Rank.
%  If RankList = [1,1,11,11], then RankDict = [rankfreq(1,2), rankfreq(11,2)].
freq_dict([], []).
freq_dict([R|T1], [rankfreq(R, 1)|T2]) :-
        \+ member(R, T1),
        freq_dict(T1, T2).
freq_dict([R|T1], [rankfreq(R, N)|T2]) :-
        freq_dict(T1, [rankfreq(R, N0)|T2]),
        N is N0 + 1,
        N \= 1.

%% fifteens(+RankList, -Value)
%  2 points are scored for each distinct combinations of cards that add to 15.
%  An ace is counted as 1, and a jack, queen or king are counted as 10,
%  and other cards count as their face value.
%  RankList needs not be sorted.
fifteens(Rs, V) :-
        findall(C, (combs(Rs, C), sum15(C, 0)), Fifteens),
        length(Fifteens, L),
        V is L * 2.

%% combs(+List, -Combination)
%  Combination is a list of all possible combinations of List elements.
combs([], []).
combs([H|T1], [H|T2]) :-
        combs(T1, T2).
combs([_|T1], T2) :-
        combs(T1, T2).

%% sum15(+RankList, A)
%  Holds when the combination sums to 15. J, Q, K are counted as 10.
%  A is an accumulator.
sum15([], 15).
sum15([R|Tail], A) :-
        ( R > 10 ->
            A1 is A + 10
        ;   A1 is A + R
        ),
        sum15(Tail, A1).

%% pairs(+RankDict, -Value)
%  2 points are scored for each pair. With 3 of a kind,
%  there are 3 different ways to make a pair, so 3 of a kind scores 6 points.
%  Similarly, 4 of a kind scores 12 points for the 6 possible pairs.
pairs([], 0).
pairs([rankfreq(_, N)|Tail], V) :-
        pairs(Tail, V0),
        ( N = 1 -> V = V0
        ; N = 2 -> V is V0 + 2
        ; N = 3 -> V is V0 + 6
        ; N = 4 -> V is V0 + 12
        ).

%% runs(+RankList, -Value)
%  1 point is scored for each card in a run of 3 or more consecutive cards.
%  RankList should be sorted.
runs(Rs, V) :-
        findall(C, (combs(Rs, C), consecutive(C), length(C, L), L >= 3), Runs),
        ( Runs = [] ->  % no run
            V = 0
        ;   maplist(length, Runs, Ls), max_list(Ls, L),
            findall(L, member(L, Ls), Vs),  % longest run(s)
            sum_list(Vs, V)
        ).

%% consecutive(+List)
%  Holds when List elements are consecutive ascending integers.
%  List should be sorted.
consecutive([H1, H2|Tail]) :-
        H1 is H2 - 1,
        (Tail = [] ; consecutive([H2|Tail])).

%% flushes(+HandSuit, +S0, -Value)
%  4 points is scored if all the cards in the hand are of the same suit.
%  1 further point is scored if the start card is also the same suit.
%  HandSuit is a list of suits in hand, S0 is the suit of start card.
flushes([S1, S2, S3, S4], S0, V) :-
        ( S1 = S2, S2 = S3, S3 = S4, S4 = S0 ->
            V = 5
        ; S1 = S2, S2 = S3, S3 = S4, S4 \= S0 ->
            V = 4
        ;   V = 0
        ).

%% nob(+Hand, +S0, -Value)
%  1 point is scored if the hand contains J of the same suit as the start card.
%  Hand is a list of cards in hand, S0 is the suit of start card.
nob(Hand, S0, V) :-
        ( member(card(jack, S0), Hand) ->
            V = 1
        ;   V = 0
        ).

% ------------------------------------------------------------------------------
%% select_hand(+Cards, ?Hand, ?Cribcards)
%  Hand maximizes the expected value of Hand over all possible start cards;
%  Cribcards is the list of cards to discard.
select_hand(Cards, Hand, Crib) :-
        findall(H, (length(H, 4), combs(Cards, H)), Hs),
        maplist(exp(Cards), Hs, Vs), max_list(Vs, V),  % max expected value
        member(Hand, Hs), exp(Cards, Hand, V),
        subtract(Cards, Hand, Crib).

%% exp(+Cards, +Hand, -Value)
%  Unifies Value with the expected value of hand.
exp(Cards, Hand, V) :-
        all_cards(All), subtract(All, Cards, Starts),  % all start cards
        maplist(hand_value(Hand), Starts, Vs),
        mean(Vs, V).

%% all_cards(-Cards)
% Generates all cards excluding jokers.
all_cards(Cards) :-
        maplist(all_cards(ace), [spades, clubs, hearts, diamonds], C),
        append(C, Cards).

all_cards(R, S, [card(R, S)|Tail]) :-
        ( R = 10     ->  all_cards(jack, S, Tail)
        ; integer(R) ->  R1 is R + 1, all_cards(R1, S, Tail)
        ; R = ace    ->  all_cards(2, S, Tail)
        ; R = jack   ->  all_cards(queen, S, Tail)
        ; R = queen  ->  all_cards(king, S, Tail)
        ; R = king   ->  Tail = []
        ).

%% mean(+List, -Mean)
%  Find the expected value of List, unifies with Mean.
mean(List, Mean) :-
        sum_list(List, Sum),
        length(List, N),
        Mean is Sum / N.
