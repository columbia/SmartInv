1 pragma solidity ^0.4.10;
2 
3 
4 // title Migration Agent interface
5 contract MigrationAgent {
6    function migrateFrom(address _from, uint256 _value);
7 }
8 
9 // title preICO humansOnly networkToken (HON Token) - crowdfunding code for preICO humansOnly networkToken PreICO
10 contract HumansOnlyNetworkETHpreICO {
11     string public constant name = "preICO for HumansOnly.Network on ETH";
12     string public constant symbol = "HON";
13     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH.
14 
15     uint256 public constant tokenCreationRate = 1000;
16     // The funding cap in weis.
17     uint256 public constant tokenCreationCap = 283000 ether * tokenCreationRate;
18     uint256 public constant tokenCreationMinConversion = 1 ether * tokenCreationRate;
19 	uint256 public constant tokenSEEDcap = 800 * 1 ether * tokenCreationRate;
20 	uint256 public constant tokenXstepCAP = tokenSEEDcap + 5000 * 1 ether * tokenCreationRate;
21 	uint256 public constant token18KstepCAP = tokenXstepCAP + 18000 * 1 ether * tokenCreationRate;
22 
23   // weeks and hours in block distance on ETH
24    uint256 public constant oneweek = 36028;
25    uint256 public constant oneday = 5138;
26     uint256 public constant onehour = 218;
27 	
28     uint256 public fundingStartBlock = 4612439 + 2*onehour; 
29 	//  weeks
30     uint256 public blackFridayEndBlock = fundingStartBlock + oneday + 8 * onehour;
31     uint256 public fundingEndBlock = fundingStartBlock + 6*oneweek;
32 	
33     // The flag indicates if the HON Token contract is in Funding state.
34     bool public funding = true;
35 	bool public refundstate = false;
36 	bool public migratestate = false;
37 	
38     // Receives ETH and its own HON Token endowment.
39     address public hon1ninja = 0x175750aE4fBdc906A3b2Fca69f6db6bbf6c92d39;
40 	address public hon2backup =0xda075dd55826dDa29b5bf04efa399B052a1bCdbA;
41     // Has control over token migration to next version of token.
42     address public migrationMaster = 0x1cf026C3779d03c0AB8Be9E35912Bbe5F678Ff16;
43 
44    
45     // The current total token supply.
46     uint256 totalTokens;
47 	uint256 bonusCreationRate;
48     mapping (address => uint256) balances;
49     mapping (address => uint256) balancesRAW;
50 
51 
52    uint256 public totalMigrated;
53 
54     event Transfer(address indexed _from, address indexed _to, uint256 _value);
55     event Migrate(address indexed _from, address indexed _to, uint256 _value);
56     event Refund(address indexed _from, uint256 _value);
57 
58     function HumansOnlyNetworkETHpreICO() {
59 
60         if (hon1ninja == 0) throw;
61         if (migrationMaster == 0) throw;
62         if (fundingEndBlock   <= fundingStartBlock) throw;
63 
64     }
65 
66     // notice Transfer `_value` HON Token tokens from sender's account
67     // `msg.sender` to provided account address `_to`.
68     // notice This function is disabled during the funding.
69     // dev Required state: Operational
70     // param _to The address of the tokens recipient
71     // param _value The amount of token to be transferred
72     // return Whether the transfer was successful or not
73     function transfer(address _to, uint256 _value) returns (bool) {
74 
75 // freez till end of crowdfunding + 2  weeks
76 if ((msg.sender!=migrationMaster)&&(block.number < fundingEndBlock + 2*oneweek)) throw;
77 
78         var senderBalance = balances[msg.sender];
79         if (senderBalance >= _value && _value > 0) {
80             senderBalance -= _value;
81             balances[msg.sender] = senderBalance;
82             balances[_to] += _value;
83             Transfer(msg.sender, _to, _value);
84             return true;
85         }
86         return false;
87     }
88 
89     function totalSupply() external constant returns (uint256) {
90         return totalTokens;
91     }
92 
93     function balanceOf(address _owner) external constant returns (uint256) {
94         return balances[_owner];
95     }
96 
97 	function() payable {
98     if(funding){
99    createHONtokens(msg.sender);
100    }
101 }
102 
103      // Crowdfunding:
104 
105         function createHONtokens(address holder) payable {
106 
107         if (!funding) throw;
108         if (block.number < fundingStartBlock) throw;
109         if (block.number > fundingEndBlock) throw;
110 
111         // Do not allow creating 0 or more than the cap tokens.
112         if (msg.value == 0) throw;
113 		// check the maximum token creation cap
114         if (msg.value > (tokenCreationCap - totalTokens) / tokenCreationRate)
115           throw;
116 		
117 		//bonus structure
118 		bonusCreationRate = tokenCreationRate;
119 		// early birds bonuses :
120         if (totalTokens < tokenSEEDcap) bonusCreationRate = tokenCreationRate +800;
121 	
122 
123 		if	(totalTokens > tokenXstepCAP){bonusCreationRate = tokenCreationRate - 250;}// 750
124 		if	(totalTokens > token18KstepCAP){bonusCreationRate = tokenCreationRate - 250;} //500
125 		
126 	//blackFriday bonuses
127 	// 1 block = 13.7-16.8 s
128 		if (block.number < blackFridayEndBlock){
129 		bonusCreationRate = bonusCreationRate * 3;
130 		}
131 		
132 
133 	 var numTokensRAW = msg.value * tokenCreationRate;
134 
135         var numTokens = msg.value * bonusCreationRate;
136         totalTokens += numTokens;
137 
138         // Assign new tokens to the sender
139         balances[holder] += numTokens;
140         balancesRAW[holder] += numTokensRAW;
141         // Log token creation event
142         Transfer(0, holder, numTokens);
143 		
144 		// Create additional HON Token for the community around 18%
145         uint256 percentOfTotal = 18;
146         uint256 additionalTokens = 	numTokens * percentOfTotal / (100);
147 
148         totalTokens += additionalTokens;
149 
150         balances[migrationMaster] += additionalTokens;
151         Transfer(0, migrationMaster, additionalTokens);
152 	
153 	}
154 
155     function Partial8Transfer() external {
156          hon1ninja.transfer(this.balance - 0.1 ether);
157     }
158 	
159     function Partial8Send() external {
160 	      if (msg.sender != hon1ninja) throw;
161         hon1ninja.send(this.balance - 1 ether);
162 	}
163 	function turnrefund() external {
164 	      if (msg.sender != hon1ninja) throw;
165 	refundstate=!refundstate;
166         }
167     function turnmigrate() external {
168 	      if (msg.sender != migrationMaster) throw;
169 	migratestate=!migratestate;
170 }
171 
172     // notice Finalize crowdfunding clossing funding options
173 	
174 function finalize() external {
175  if ((msg.sender != migrationMaster)||(msg.sender != hon1ninja)||(msg.sender != hon2backup)) throw;
176       
177         // Switch to Operational state. This is the only place this can happen.
178         funding = false;		
179         // Transfer ETH to the preICO humansOnly network ninja address.
180         if (!hon1ninja.send(this.balance)) throw;
181 		//biz dev tokens
182 		uint256 additionalTokens=tokenCreationCap-totalTokens;
183 		totalTokens += additionalTokens;
184         balances[migrationMaster] += additionalTokens;
185         Transfer(0, migrationMaster, additionalTokens);
186  }
187 	
188 	function finalizebackup() external {
189        if (block.number <= fundingEndBlock+2*oneday) throw;
190         // Switch to Operational state. This is the only place this can happen.
191         funding = false;		
192         // Transfer ETH to the preICO humansOnly network ninja address.
193         if (!hon2backup.send(this.balance)) throw;
194     }
195 	
196 	
197     function migrate(uint256 _value) external {
198         // Abort if not in Operational Migration state.
199         if (migratestate) throw;
200 
201 
202         // Validate input value.
203         if (_value == 0) throw;
204         if (_value > balances[msg.sender]) throw;
205 
206         balances[msg.sender] -= _value;
207         totalTokens -= _value;
208         totalMigrated += _value;
209 
210     }
211 	
212 function refundTRA() external {
213         // Abort if not in Funding Failure state.
214         if (!refundstate) throw;
215 
216         var HONTokenValue = balances[msg.sender];
217         var HONTokenValueRAW = balancesRAW[msg.sender];
218         if (HONTokenValueRAW == 0) throw;
219         balancesRAW[msg.sender] = 0;
220         totalTokens -= HONTokenValue;
221         var ETHValue = HONTokenValueRAW / tokenCreationRate;
222         Refund(msg.sender, ETHValue);
223         msg.sender.transfer(ETHValue);
224 }
225 
226 function preICOregulations() external returns(string wow) {
227 	return 'Regulations of ICO and preICO and usage of this smartcontract are present at website  humansOnly.network and by using this smartcontract you commit that you accept and will follow those rules';
228 }
229 }