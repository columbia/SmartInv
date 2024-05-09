1 pragma solidity ^0.4.19;
2 
3 // CryptoRoulette
4 //
5 // Guess the number secretly stored in the blockchain and win the whole contract balance!
6 //
7 // To play, call the play() method with the guessed number.  Bet price: 0.1 ether
8 
9 contract CryptoRoulette {
10 
11     uint256 private secretNumber;
12     uint256 public lastPlayed;
13     uint256 public betPrice = 0.1 ether;
14     address public ownerAddr;
15 
16     struct Game {
17         address player;
18         uint256 number;
19     }
20     Game[] public gamesPlayed;
21 
22     function CryptoRoulette() public {
23         ownerAddr = msg.sender;
24         shuffle();
25     }
26 
27     function shuffle() internal {
28         // initialize secretNumber with a value between 0 and 15
29         secretNumber = uint8(sha3(now, block.blockhash(block.number-1))) % 16;
30     }
31 
32     function play(uint256 number) payable public {
33         require(msg.value >= betPrice && number < 16);
34 
35         Game game;
36         game.player = msg.sender;
37         game.number = number;
38         gamesPlayed.push(game);
39 
40         if (number == secretNumber) {
41             // win!
42             msg.sender.transfer(this.balance);
43         }
44 
45         shuffle();
46         lastPlayed = now;
47     }
48 
49     function kill() public {
50         if (msg.sender == ownerAddr && now > lastPlayed + 1 days) {
51             suicide(msg.sender);
52         }
53     }
54 
55     function() public payable { }
56 }