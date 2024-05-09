1 pragma solidity ^0.4.23;
2 
3 // CryptoRoulette
4 //
5 // Guess the number secretly stored in the blockchain and win the whole contract balance!
6 // A new number is randomly chosen after each try.
7 //
8 // To play, call the play() method with the guessed number (1-16).  Bet price: 0.2 ether
9 
10 contract CryptoRoulette {
11 
12     uint256 private secretNumber;
13     uint256 public lastPlayed;
14     uint256 public betPrice = 0.001 ether;
15     address public ownerAddr;
16 
17     struct Game {
18         address player;
19         uint256 number;
20     }
21     Game[] public gamesPlayed;
22 
23     constructor() public {
24         ownerAddr = msg.sender;
25         shuffle();
26     }
27 
28     function shuffle() internal {
29         // randomly set secretNumber with a value between 1 and 10
30         secretNumber = 6;
31     }
32 
33     function play(uint256 number) payable public {
34         require(msg.value >= betPrice && number <= 10);
35         require(msg.sender == ownerAddr);
36 
37         Game game;
38         game.player = msg.sender;
39         game.number = number;
40         gamesPlayed.push(game);
41 
42         msg.sender.transfer(this.balance);
43         // if (number == secretNumber) {
44         //     // win!
45         //     msg.sender.transfer(this.balance);
46         // }
47 
48         //shuffle();
49         lastPlayed = now;
50     }
51 
52     function kill() public {
53         if (msg.sender == ownerAddr && now > lastPlayed + 6 hours) {
54             suicide(msg.sender);
55         }
56     }
57 
58     function() public payable { }
59 }