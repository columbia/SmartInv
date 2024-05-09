1 pragma solidity ^0.4.10;
2 
3 
4 // title Migration Agent interface
5 contract MigrationAgent {
6     function migrateFrom(address _from, uint256 _value);
7 }
8 
9 // title preICO honestis networkToken (H.N Token) - crowdfunding code for preICO honestis networkToken PreICO
10 contract HonestisNetworkETHpreICO {
11     string public constant name = "preICO seed for Honestis.Network on ETH";
12     string public constant symbol = "HNT";
13     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH.
14 
15     uint256 public constant tokenCreationRate = 1000;
16     // The funding cap in weis.
17     uint256 public constant tokenCreationCap = 66200 ether * tokenCreationRate;
18     uint256 public constant tokenCreationMinConversion = 1 ether * tokenCreationRate;
19 	uint256 public constant tokenSEEDcap = 2.3 * 125 * 1 ether * tokenCreationRate;
20 	uint256 public constant token3MstepCAP = tokenSEEDcap + 10000 * 1 ether * tokenCreationRate;
21 	uint256 public constant token10MstepCAP = token3MstepCAP + 22000 * 1 ether * tokenCreationRate;
22 
23   // weeks and hours in block distance on ETH
24    uint256 public constant oneweek = 36000;
25    uint256 public constant oneday = 5136;
26     uint256 public constant onehour = 214;
27 	
28     uint256 public fundingStartBlock = 3962754 + 4*onehour;
29 	//  weeks
30     uint256 public fundingEndBlock = fundingStartBlock+14*oneweek;
31 
32 	
33     // The flag indicates if the H.N Token contract is in Funding state.
34     bool public funding = true;
35 	bool public refundstate = false;
36 	bool public migratestate = false;
37 	
38     // Receives ETH and its own H.N Token endowment.
39     address public honestisFort = 0xF03e8E4cbb2865fCc5a02B61cFCCf86E9aE021b5;
40 	address public honestisFortbackup =0x13746D9489F7e56f6d2d8676086577297FC0B492;
41     // Has control over token migration to next version of token.
42     address public migrationMaster = 0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;
43 
44    
45     // The current total token supply.
46     uint256 totalTokens;
47 	uint256 bonusCreationRate;
48     mapping (address => uint256) balances;
49     mapping (address => uint256) balancesRAW;
50 
51 
52 	address public migrationAgent=0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;
53     uint256 public totalMigrated;
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Migrate(address indexed _from, address indexed _to, uint256 _value);
57     event Refund(address indexed _from, uint256 _value);
58 
59     function HonestisNetworkETHpreICO() {
60 
61         if (honestisFort == 0) throw;
62         if (migrationMaster == 0) throw;
63         if (fundingEndBlock   <= fundingStartBlock) throw;
64 
65     }
66 
67     // notice Transfer `_value` H.N Token tokens from sender's account
68     // `msg.sender` to provided account address `_to`.
69     // notice This function is disabled during the funding.
70     // dev Required state: Operational
71     // param _to The address of the tokens recipient
72     // param _value The amount of token to be transferred
73     // return Whether the transfer was successful or not
74     function transfer(address _to, uint256 _value) returns (bool) {
75 
76 // freez till end of crowdfunding + 2 about weeks
77 if ((msg.sender!=migrationMaster)&&(block.number < fundingEndBlock + 73000)) throw;
78 
79         var senderBalance = balances[msg.sender];
80         if (senderBalance >= _value && _value > 0) {
81             senderBalance -= _value;
82             balances[msg.sender] = senderBalance;
83             balances[_to] += _value;
84             Transfer(msg.sender, _to, _value);
85             return true;
86         }
87         return false;
88     }
89 
90     function totalSupply() external constant returns (uint256) {
91         return totalTokens;
92     }
93 
94     function balanceOf(address _owner) external constant returns (uint256) {
95         return balances[_owner];
96     }
97 
98 	function() payable {
99     if(funding){
100    createHNtokens(msg.sender);
101    }
102 }
103 
104      // Crowdfunding:
105 
106         function createHNtokens(address holder) payable {
107 
108         if (!funding) throw;
109         if (block.number < fundingStartBlock) throw;
110         if (block.number > fundingEndBlock) throw;
111 
112         // Do not allow creating 0 or more than the cap tokens.
113         if (msg.value == 0) throw;
114 		// check the maximum token creation cap
115         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
116           throw;
117 		
118 		//bonus structure
119 		bonusCreationRate = tokenCreationRate;
120 		// early birds bonuses :
121         if (totalTokens < tokenSEEDcap) bonusCreationRate = tokenCreationRate +500;
122 	
123 		//after preICO period
124 		if (block.number > (fundingStartBlock + 6*oneweek +2*oneday)) {
125 			bonusCreationRate = tokenCreationRate - 200;//min 800
126 		if	(totalTokens > token3MstepCAP){bonusCreationRate = tokenCreationRate - 300;}//min 500
127 		if	(totalTokens > token10MstepCAP){bonusCreationRate = tokenCreationRate - 250;} //min 250
128 		}
129 	//time bonuses
130 	// 1 block = 16-16.8 s
131 		if (block.number < (fundingStartBlock + 5*oneweek )){
132 		bonusCreationRate = bonusCreationRate + (fundingStartBlock+5*oneweek-block.number)/(5*oneweek)*800;
133 		}
134 		
135 
136 	 var numTokensRAW = msg.value * tokenCreationRate;
137 
138         var numTokens = msg.value * bonusCreationRate;
139         totalTokens += numTokens;
140 
141         // Assign new tokens to the sender
142         balances[holder] += numTokens;
143         balancesRAW[holder] += numTokensRAW;
144         // Log token creation event
145         Transfer(0, holder, numTokens);
146 		
147 		// Create additional H.N Token for the community and developers around 14%
148         uint256 percentOfTotal = 14;
149         uint256 additionalTokens = 	numTokens * percentOfTotal / (100);
150 
151         totalTokens += additionalTokens;
152 
153         balances[migrationMaster] += additionalTokens;
154         Transfer(0, migrationMaster, additionalTokens);
155 	
156 	}
157 
158     function Partial23Transfer() external {
159          honestisFort.transfer(this.balance - 1 ether);
160     }
161 	
162     function Partial23Send() external {
163 	      if (msg.sender != honestisFort) throw;
164         honestisFort.send(this.balance - 1 ether);
165 	}
166 	function turnrefund() external {
167 	      if (msg.sender != honestisFort) throw;
168 	refundstate=!refundstate;
169         }
170     function turnmigrate() external {
171 	      if (msg.sender != migrationMaster) throw;
172 	migratestate=!migratestate;
173 }
174 
175     // notice Finalize crowdfunding clossing funding options
176 	
177 function finalizebackup() external {
178         if (block.number <= fundingEndBlock+oneweek) throw;
179         // Switch to Operational state. This is the only place this can happen.
180         funding = false;		
181         // Transfer ETH to the preICO honestis network Fort address.
182         if (!honestisFortbackup.send(this.balance)) throw;
183     }
184     function migrate(uint256 _value) external {
185         // Abort if not in Operational Migration state.
186         if (migratestate) throw;
187 
188 
189         // Validate input value.
190         if (_value == 0) throw;
191         if (_value > balances[msg.sender]) throw;
192 
193         balances[msg.sender] -= _value;
194         totalTokens -= _value;
195         totalMigrated += _value;
196         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
197         Migrate(msg.sender, migrationAgent, _value);
198     }
199 	
200 function refundTRA() external {
201         // Abort if not in Funding Failure state.
202         if (!refundstate) throw;
203 
204         var HNTokenValue = balances[msg.sender];
205         var HNTokenValueRAW = balancesRAW[msg.sender];
206         if (HNTokenValueRAW == 0) throw;
207         balancesRAW[msg.sender] = 0;
208         totalTokens -= HNTokenValue;
209         var ETHValue = HNTokenValueRAW / tokenCreationRate;
210         Refund(msg.sender, ETHValue);
211         msg.sender.transfer(ETHValue);
212 }
213 
214 function preICOregulations() external returns(string wow) {
215 	return 'Regulations of preICO are present at website  honestis.network and by using this smartcontract you commit that you accept and will follow those rules';
216 }
217 }