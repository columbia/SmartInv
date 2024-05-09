1 pragma solidity ^0.4.25;
2 
3 contract CoinFlip {
4     address owner;
5     uint payPercentage = 90;
6 	
7 	// Maximum amount to bet in WEIs
8 	uint public MaxAmountToBet = 200000000000000000; // = 0.2 Ether
9 	
10     mapping (address => uint) private userBalances;
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
53                     userBalances[msg.sender] = address(this).balance;
54                     uint amountToWithdraw = userBalances[msg.sender];
55                     userBalances[msg.sender] = 0;
56 					msg.sender.transfer(amountToWithdraw);
57 					emit Status('Congratulations, you win! Sorry, we didn\'t have enought money, we will deposit everything we have!', msg.sender, msg.value, true);
58 					
59 					newGame = Game({
60 						addr: msg.sender,
61 						blocknumber: block.number,
62 						blocktimestamp: block.timestamp,
63 						bet: msg.value,
64 						prize: address(this).balance,
65 						winner: true
66 					});
67 					lastPlayedGames.push(newGame);
68 					
69 				} else {
70 					uint _prize = msg.value * (100 + payPercentage) / 100;
71 					emit Status('Congratulations, you win!', msg.sender, _prize, true);
72                     userBalances[msg.sender] = _prize;
73                     uint amountToWithdraw2 = userBalances[msg.sender];
74                     userBalances[msg.sender] = 0;
75 					msg.sender.transfer(amountToWithdraw2);
76 					
77 					newGame = Game({
78 						addr: msg.sender,
79 						blocknumber: block.number,
80 						blocktimestamp: block.timestamp,
81 						bet: msg.value,
82 						prize: _prize,
83 						winner: true
84 					});
85 					lastPlayedGames.push(newGame);
86 					
87 				}
88 			} else {
89 				emit Status('Sorry, you loose!', msg.sender, msg.value, false);
90 				
91 				newGame = Game({
92 					addr: msg.sender,
93 					blocknumber: block.number,
94 					blocktimestamp: block.timestamp,
95 					bet: msg.value,
96 					prize: 0,
97 					winner: false
98 				});
99 				lastPlayedGames.push(newGame);
100 				
101 			}
102 		}
103     }
104 	
105 	function getGameCount() public constant returns(uint) {
106 		return lastPlayedGames.length;
107 	}
108 
109 	function getGameEntry(uint index) public constant returns(address addr, uint blocknumber, uint blocktimestamp, uint bet, uint prize, bool winner) {
110 		return (lastPlayedGames[index].addr, lastPlayedGames[index].blocknumber, lastPlayedGames[index].blocktimestamp, lastPlayedGames[index].bet, lastPlayedGames[index].prize, lastPlayedGames[index].winner);
111 	}
112 	
113 	
114 	function depositFunds() payable public onlyOwner {}
115     
116 	function withdrawFunds(uint amount) onlyOwner public {
117 	    require(amount <= address(this).balance);
118         if (owner.send(amount)) {
119             emit Status('User withdraw some money!', msg.sender, amount, true);
120         }
121     }
122 	
123 	function setMaxAmountToBet(uint amount) onlyOwner public returns (uint) {
124 		MaxAmountToBet = amount;
125         return MaxAmountToBet;
126     }
127 	
128 	function getMaxAmountToBet() constant public returns (uint) {
129         return MaxAmountToBet;
130     }
131 	
132     
133     function Kill() onlyOwner public{
134         emit Status('Contract was killed, contract balance will be send to the owner!', msg.sender, address(this).balance, true);
135         selfdestruct(owner);
136     }
137 }