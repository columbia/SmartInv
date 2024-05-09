1 pragma solidity ^0.4.21;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31 
32   address public owner;
33 
34   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
35 
36   function Ownable() public {
37     owner = msg.sender;
38   }
39 
40   modifier onlyOwner() {
41     require(msg.sender == owner);
42     _;
43   }
44 
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 contract Payments {
54   mapping(address => uint256) public payments; 
55   
56   function getBalance() public constant returns(uint256) {
57 	 return payments[msg.sender];
58   }    
59 
60   function withdrawPayments() public {
61 	address payee = msg.sender;
62 	uint256 payment = payments[payee];
63 
64 	require(payment != 0);
65 	require(this.balance >= payment);
66 
67 	payments[payee] = 0;
68 
69 	assert(payee.send(payment));
70   }  
71     
72 }
73 
74 contract ERC721 {
75   function totalSupply() constant returns (uint256);
76   function ownerOf(uint256) constant returns (address);
77 }
78 
79 
80 contract PiranhasBattle is Ownable, Payments  {
81 
82   using SafeMath for uint256;
83   
84 
85   mapping(uint256 => mapping(uint256 => uint256)) public fightersToBattle; //unique pair of the fighters
86   mapping(uint256 => mapping(uint256 => uint256)) public battleToFighterToSize; //fighters sizes
87   mapping(uint256 => mapping(uint256 => uint256)) public battleToFighterToBet; // Bets summ in power points
88 
89   mapping(uint256 => uint256) public battleToWinner; 
90   
91   mapping(address => mapping(uint256 => mapping(uint256 => uint256))) public addressToBattleToFigterIdToBetPower;  
92   
93   uint256 public battleId;
94 
95 
96   address[][] public betsOnFighter;
97   
98 
99   
100   ERC721 piranhas = ERC721(0x2B434a1B41AFE100299e5Be39c4d5be510a6A70C); 
101   
102   function piranhasTotalSupply() constant returns (uint256)  {
103       return piranhas.totalSupply();
104   }
105 
106   function ownerOfPiranha(uint256 _piranhaId) constant returns (address)  {
107       return piranhas.ownerOf(_piranhaId);
108   }
109   
110   function theBet(uint256 _piranhaFighter1, uint256 _piranhaFighter2, uint256 _betOnFighterId) public payable {
111      
112 	  require (_piranhaFighter1 > 0 && _piranhaFighter2 > 0 && _piranhaFighter1 != _piranhaFighter2);
113 	  
114 	  uint256 curBattleId=fightersToBattle[_piranhaFighter1][_piranhaFighter2];
115       require (battleToWinner[curBattleId] == 0); //battle not finished	  
116 	  
117 	  require (msg.value >= 0.001 ether && msg.sender != address(0));
118 	  
119 	  if (curBattleId == 0) { //new battle
120  	      battleId = betsOnFighter.push([msg.sender]); //add gamer to the battle
121 		  fightersToBattle[_piranhaFighter1][_piranhaFighter2] = battleId;
122 		  battleToFighterToSize[battleId][_piranhaFighter1]=240; 
123 		  battleToFighterToSize[battleId][_piranhaFighter2]=240; 
124 	  } else {
125 	        if (addressToBattleToFigterIdToBetPower[msg.sender][battleId][_piranhaFighter1]==0 && addressToBattleToFigterIdToBetPower[msg.sender][battleId][_piranhaFighter2]==0)
126 				betsOnFighter[battleId-1].push(msg.sender); //add gamer to the battle
127 	  }
128 	  
129 	  uint256 fighter1Size = battleToFighterToSize[battleId][_piranhaFighter1];
130 	  uint256 fighter2Size = battleToFighterToSize[battleId][_piranhaFighter2];
131 	  uint256 theBetPower = SafeMath.div(msg.value,1000000000000000); 
132 	  
133 	  battleToFighterToBet[battleId][_betOnFighterId] += theBetPower;
134 	  
135 	  addressToBattleToFigterIdToBetPower[msg.sender][battleId][_betOnFighterId] += theBetPower;
136 	  
137 	  uint8 randNum = uint8(block.blockhash(block.number-1))%2;
138 	  
139 	  if (randNum==0) { //fighter1 the winner
140 
141 			if ( fighter1Size+theBetPower >= 240) 
142 				battleToFighterToSize[battleId][_piranhaFighter1] = 240;
143 			else 
144 				battleToFighterToSize[battleId][_piranhaFighter1] += theBetPower;
145 				
146 	        if ( fighter2Size <= theBetPower) {
147 				battleToFighterToSize[battleId][_piranhaFighter2] = 0;
148 				_finishTheBattle(battleId, _piranhaFighter1, _piranhaFighter2, 1);
149 				
150 			}
151 			else 
152 				battleToFighterToSize[battleId][_piranhaFighter2] -= theBetPower;	
153 				
154 	  } else { //fighter2 the winner
155 			if ( fighter2Size+theBetPower >= 240) 
156 				battleToFighterToSize[battleId][_piranhaFighter2] = 240;
157 			else 
158 				battleToFighterToSize[battleId][_piranhaFighter2] += theBetPower;
159 				
160 	        if ( fighter1Size <= theBetPower) {
161 				battleToFighterToSize[battleId][_piranhaFighter1] = 0;
162 				_finishTheBattle(battleId, _piranhaFighter1, _piranhaFighter2, 2);
163 				
164 			}
165 			else 
166 				battleToFighterToSize[battleId][_piranhaFighter1] -= theBetPower;		        
167 	  }
168 	  
169   }
170   
171   function _finishTheBattle (uint256 _battleId, uint256 _piranhaFighter1, uint256 _piranhaFighter2, uint8 _winner) private { 
172   
173 	    uint256 winnerId=_piranhaFighter1;
174 		uint256 looserId=_piranhaFighter2;
175 		if (_winner==2) {
176 			winnerId=_piranhaFighter2;
177 			looserId=_piranhaFighter1;
178 			battleToWinner[_battleId]=_piranhaFighter2;
179 		} else {
180 			battleToWinner[_battleId]=_piranhaFighter1;
181 		}
182 
183 		uint256 winPot=battleToFighterToBet[_battleId][looserId]*900000000000000; //90% in wei
184 		uint256 divsForPiranhaOwner=battleToFighterToBet[_battleId][looserId]*100000000000000; //10% in wei
185 		
186 		uint256 prizeUnit = uint256((battleToFighterToBet[_battleId][winnerId] * 1000000000000000 + winPot)  / battleToFighterToBet[_battleId][winnerId]);
187 		
188 		for (uint256 i=0; i < betsOnFighter[_battleId-1].length; i++) {
189 			if (addressToBattleToFigterIdToBetPower[betsOnFighter[_battleId-1][i]][_battleId][winnerId] != 0)
190 				payments[betsOnFighter[_battleId-1][i]] += prizeUnit * addressToBattleToFigterIdToBetPower[betsOnFighter[_battleId-1][i]][_battleId][winnerId];
191 		}
192 		
193 		if (divsForPiranhaOwner>0) {
194 			address piranhaOwner=ownerOfPiranha(winnerId);
195 			if (piranhaOwner!=address(0))
196 				piranhaOwner.send(divsForPiranhaOwner);
197 		}
198 		 
199   }
200   
201 }