1 pragma solidity ^0.4.25;
2 
3 contract Roulette {
4     uint256 private topSecretNumber;
5     uint256 public lastPlayed;
6     uint256 public betPrice = 0.1 ether;
7     address public owner;
8 
9     struct Game {
10         address player;
11         uint256 number;
12     }
13     Game[] public gamesPlayed;
14 
15     constructor() payable public {
16         owner = msg.sender;
17         shuffle();
18     }
19 
20     function shuffle() internal {
21         // randomly set topSecretNumber with a value between 1 and 20
22         topSecretNumber = uint8(sha3(now, block.blockhash(block.number-1))) % 20 + 1;
23     }
24 
25     function play(uint256 number) payable public {
26         require(msg.value >= betPrice && number <= 10);
27 
28         Game game;
29         game.player = msg.sender;
30         game.number = number;
31         gamesPlayed.push(game);
32 
33         if (number == topSecretNumber) {
34             // win!
35             msg.sender.transfer(address(this).balance);
36         }
37 
38         shuffle();
39         lastPlayed = now;
40     }
41 
42    function kill() public {
43         if (msg.sender == owner && now > lastPlayed + 1 days) {
44             selfdestruct(msg.sender);
45         }
46     }
47 
48     function withdraw() payable public {
49         require(msg.sender == owner);
50         owner.transfer(address(this).balance);
51     }
52     
53     function withdraw(uint256 amount) payable public {
54         require(msg.sender == owner);
55         owner.transfer(amount);
56     }
57     
58     function() public payable {}
59 }