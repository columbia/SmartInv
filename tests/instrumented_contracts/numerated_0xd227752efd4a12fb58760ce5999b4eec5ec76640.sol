1 pragma solidity ^0.4.25;
2 
3 contract CoinFlip {
4     address owner;
5     uint payPercentage = 90;
6 	
7 	// Maximum amount to bet in WEIs
8 	uint public MaxAmountToBet = 200000000000000000; // = 0.2 Ether
9 	
10 
11 	
12 	struct Game {
13 		address addr;
14 		uint blocknumber;
15 		uint blocktimestamp;
16         uint bet;
17 		uint prize;
18         bool winner;
19     }
20 	
21 	Game[] lastPlayedGames;
22 	
23 	Game newGame;
24     
25     event Status(
26 		string _msg, 
27 		address user, 
28 		uint amount,
29 		bool winner
30 	);
31     
32     constructor() public payable {
33         owner = msg.sender;
34     }
35     
36     modifier onlyOwner() {
37         if (owner != msg.sender) {
38             revert();
39         } else {
40             _;
41         }
42     }
43     
44     function Play() public payable {
45 		
46 		if (msg.value > MaxAmountToBet) {
47 			revert();
48 		} else {
49 			if ((block.timestamp % 2) == 0) {
50 				
51 				if (address(this).balance < (msg.value * ((100 + payPercentage) / 100))) {
52 					// No tenemos suficientes fondos para pagar el premio, así que transferimos todo lo que tenemos
53 					msg.sender.transfer(address(this).balance);
54 					emit Status('Congratulations, you win! Sorry, we didn\'t have enought money, we will deposit everything we have!', msg.sender, msg.value, true);
55 					
56 					newGame = Game({
57 						addr: msg.sender,
58 						blocknumber: block.number,
59 						blocktimestamp: block.timestamp,
60 						bet: msg.value,
61 						prize: address(this).balance,
62 						winner: true
63 					});
64 					lastPlayedGames.push(newGame);
65 					
66 				} else {
67 					uint _prize = msg.value * (100 + payPercentage) / 100;
68 					emit Status('Congratulations, you win!', msg.sender, _prize, true);
69 					msg.sender.transfer(_prize);
70 					
71 					newGame = Game({
72 						addr: msg.sender,
73 						blocknumber: block.number,
74 						blocktimestamp: block.timestamp,
75 						bet: msg.value,
76 						prize: _prize,
77 						winner: true
78 					});
79 					lastPlayedGames.push(newGame);
80 					
81 				}
82 			} else {
83 				emit Status('Sorry, you loose!', msg.sender, msg.value, false);
84 				
85 				newGame = Game({
86 					addr: msg.sender,
87 					blocknumber: block.number,
88 					blocktimestamp: block.timestamp,
89 					bet: msg.value,
90 					prize: 0,
91 					winner: false
92 				});
93 				lastPlayedGames.push(newGame);
94 				
95 			}
96 		}
97     }
98 	
99 	function getGameCount() public constant returns(uint) {
100 		return lastPlayedGames.length;
101 	}
102 
103 	function getGameEntry(uint index) public constant returns(address addr, uint blocknumber, uint blocktimestamp, uint bet, uint prize, bool winner) {
104 		return (lastPlayedGames[index].addr, lastPlayedGames[index].blocknumber, lastPlayedGames[index].blocktimestamp, lastPlayedGames[index].bet, lastPlayedGames[index].prize, lastPlayedGames[index].winner);
105 	}
106 	
107 	
108 	function depositFunds() payable public {}
109     
110 	function withdrawFunds(uint amount) onlyOwner public {
111 	    require(amount <= address(this).balance);
112         if (owner.send(amount)) {
113             emit Status('User withdraw some money!', msg.sender, amount, true);
114         }
115     }
116 	
117 	function setMaxAmountToBet(uint amount) onlyOwner public returns (uint) {
118 		MaxAmountToBet = amount;
119         return MaxAmountToBet;
120     }
121 	
122 	function getMaxAmountToBet() constant public returns (uint) {
123         return MaxAmountToBet;
124     }
125 	
126     
127     function Kill() onlyOwner public{
128         emit Status('Contract was killed, contract balance will be send to the owner!', msg.sender, address(this).balance, true);
129         selfdestruct(owner);
130     }
131 }