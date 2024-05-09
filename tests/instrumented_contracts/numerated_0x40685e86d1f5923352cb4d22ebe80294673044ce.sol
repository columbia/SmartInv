1 pragma solidity ^0.4.10;
2 
3 
4 // title Migration Agent interface
5 contract MigrationAgent {
6     function migrateFrom(address _from, uint256 _value);
7 }
8 
9 // title ICO honestis networkToken (H.N Token) - crowdfunding code for ICO honestis network Token and merging with preICO
10 contract HonestisNetworkETHmergedICO {
11     string public constant name = "ICO token Honestis.Network on ETH";
12     string public constant symbol = "HNT";
13     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH.
14 
15     uint256 public constant tokenCreationRate = 1000;
16     // The funding cap in weis.
17     uint256 public constant tokenCreationCap = 66200 ether * tokenCreationRate;
18     uint256 public constant tokenCreationMinConversion = 1 ether * tokenCreationRate;
19 
20 
21   // weeks and hours in block distance on ETH
22 
23   
24   // block avg time 	14,44	
25   uint256 public constant oneweek = 41883;
26    uint256 public constant oneday = 5983;
27     uint256 public constant onehour = 248;
28 	 uint256 public constant onemonth = 179501;
29 	 uint256 public constant fourweeks= 167534;
30     uint256 public fundingStartBlock = 4663338;// 02.12 18 UTC +2; //campaign aims 04.12 UTC 12
31 
32 	//  4 weeks
33     uint256 public fundingEndBlock = fundingStartBlock+fourweeks;
34 
35 	
36     // The flag indicates if the H.N Token contract is in Funding state.
37     bool public funding = true;
38 	bool public migratestate = false;
39 	bool public finalstate = false;
40 	
41     // Receives ETH and its own H.N Token endowment.
42     address public honestisFort = 0xF03e8E4cbb2865fCc5a02B61cFCCf86E9aE021b5;
43 	address public honestisFortbackup =0xC4e901b131cFBd90F563F0bB701AE2f8e83c5589;
44     // Has control over token migration to next version of token.
45     address public migrationMaster = 0x0f32f4b37684be8a1ce1b2ed765d2d893fa1b419;
46 
47 
48     // The current total token supply.
49 	// 92,4%
50     uint256 totalTokens =61168800 ether;
51 	uint256 bonusCreationRate;
52     mapping (address => uint256) balances;
53     mapping (address => uint256) balancesRAW;
54 
55 
56 	address public migrationAgent=0x0f32f4b37684be8a1ce1b2ed765d2d893fa1b419;
57     uint256 public totalMigrated;
58 
59     event Transfer(address indexed _from, address indexed _to, uint256 _value);
60     event Migrate(address indexed _from, address indexed _to, uint256 _value);
61     event Refund(address indexed _from, uint256 _value);
62 
63     function HonestisNetworkETHmergedICO() {
64 //early adopters community 1								
65 balances[0x2e7C01CBB983B99D41b9022776928383A02d4C1a]=351259197900000000000000;
66 //community migration master								
67 balances[0x0F32f4b37684be8A1Ce1B2Ed765d2d893fa1b419]=2000000000000000000000000;
68 //community 2								
69 balances[0xa4B61E0c28F6d0823B5D98D3c9BB3f925a5416B1]=3468820800000000000000000;
70 //community 3								
71 balances[0x5AB6e1842B5B705835820b9ab02e38b37Fac071a]=2000000000000000000000000;
72 //funders								
73 balances[0x40efcf00282B580c468BCD93B84B7CE125fA62Cc]=53348720000000000000000000;
74 //community 5 for cointel... $10500 // 22.X ETH * 250 = 								
75 balances[0xD00aA14f4E5D651f29cE27426559eC7c39b14B3e]=5588000000000000000000;
76 
77     }
78 
79     // notice Transfer `_value` H.N Token tokens from sender's account
80     // `msg.sender` to provided account address `_to`.
81     // notice This function is disabled during the funding.
82     // dev Required state: Operational
83     // param _to The address of the tokens recipient
84     // param _value The amount of token to be transferred
85     // return Whether the transfer was successful or not
86     function transfer(address _to, uint256 _value) returns (bool) {
87 
88 // freez till end of crowdfunding + about week
89 if ((msg.sender!=migrationMaster)&&(block.number < fundingEndBlock + oneweek)) throw;
90 
91         var senderBalance = balances[msg.sender];
92         if (senderBalance >= _value && _value > 0) {
93             senderBalance -= _value;
94             balances[msg.sender] = senderBalance;
95             balances[_to] += _value;
96             Transfer(msg.sender, _to, _value);
97             return true;
98         }
99         return false;
100     }
101 
102     function totalSupply() external constant returns (uint256) {
103         return totalTokens;
104     }
105 
106     function balanceOf(address _owner) external constant returns (uint256) {
107         return balances[_owner];
108     }
109 
110 	function() payable {
111     if(funding){
112    createHNtokens(msg.sender);
113    }
114 }
115 
116      // Crowdfunding:
117 
118         function createHNtokens(address holder) payable {
119 
120         if (!funding) throw;
121         if (block.number < fundingStartBlock) throw;
122  
123         // Do not allow creating 0 or more than the cap tokens.
124         if (msg.value == 0) throw;
125 		// check the maximum token creation cap
126 		// final creation rate
127 		bonusCreationRate = 250;
128         if (msg.value > (tokenCreationCap - totalTokens) / bonusCreationRate)
129           throw;
130 		
131 		//merged last about 8% ICO bonus structure
132 		bonusCreationRate = tokenCreationRate;
133 
134 
135 	 var numTokensRAW = msg.value * tokenCreationRate;
136 
137         var numTokens = msg.value * bonusCreationRate;
138         totalTokens += numTokens;
139 
140         // Assign new tokens to the sender
141         balances[holder] += numTokens;
142         balancesRAW[holder] += numTokensRAW;
143         // Log token creation event
144         Transfer(0, holder, numTokens);
145 		
146 		// Create additional H.N Token for the community and developers around 14%
147         uint256 percentOfTotal = 14;
148         uint256 additionalTokens = 	numTokens * percentOfTotal / (100);
149 
150         totalTokens += additionalTokens;
151 
152         balances[migrationMaster] += additionalTokens;
153         // Transfer(0, migrationMaster, additionalTokens);
154 	
155 	
156 		//time bonuses for weekend additional 7% (0.5 * 14%)
157 	// 1 block = 16-16.8 s
158 		if (block.number < (fundingStartBlock + 2*oneday )){
159 		 balances[migrationMaster] = balances[migrationMaster]-  additionalTokens/2;
160 		  balances[holder] +=  additionalTokens/2;
161         Transfer(0, holder, additionalTokens/2);
162 		Transfer(0, migrationMaster, additionalTokens/2);
163 		} else {
164 		
165 		  Transfer(0, migrationMaster, additionalTokens);
166 		}
167 		
168 	}
169 	
170 	   // Crowdfunding:
171 
172         
173     function shifter2HNtokens(address _to, uint256 _value) returns (bool) {
174        if (!funding) throw;
175         if (block.number < fundingStartBlock) throw;
176 // freez till end of crowdfunding + 2 about weeks
177 if (msg.sender!=migrationMaster) throw;
178 		// check the maximum token creation cap
179         // Do not allow creating more than the cap tokens.
180 
181         if (totalTokens +  _value < tokenCreationCap){
182 			totalTokens += _value;
183             balances[_to] += _value;
184             Transfer(0, _to, _value);
185 			
186 			        uint256 percentOfTotal = 14;
187         uint256 additionalTokens = 	_value * percentOfTotal / (100);
188 
189         totalTokens += additionalTokens;
190 
191         balances[migrationMaster] += additionalTokens;
192         Transfer(0, migrationMaster, additionalTokens);
193 			
194             return true;
195         }
196         return false;
197     }
198 
199 
200      
201     function part20Transfer() external {
202          if (msg.sender != honestisFort) throw;
203          honestisFort.transfer(this.balance - 0.1 ether);
204     }
205 	
206     function Partial20Send() external {
207 	      if (msg.sender != honestisFort) throw;
208         honestisFort.send(this.balance - 0.1 ether);
209 	}
210 	function funding() external {
211 	      if (msg.sender != honestisFort) throw;
212 	funding=!funding;
213         }
214     function turnmigrate() external {
215 	      if (msg.sender != migrationMaster) throw;
216 	migratestate=!migratestate;
217 }
218 
219     function just10Send() external {
220 	      if (msg.sender != honestisFort) throw;
221         honestisFort.send(10 ether);
222 	}
223 
224 	function just50Send() external {
225 	      if (msg.sender != honestisFort) throw;
226         honestisFort.send(50 ether);
227 	}
228 	
229     // notice Finalize crowdfunding clossing funding options
230 function finalize() external {
231  if ((msg.sender != honestisFort)||(msg.sender != migrationMaster)) throw;
232      
233         // Switch to Operational state. This is the only place this can happen.
234         funding = false;		
235 		finalstate= true;
236 		if (!honestisFort.send(this.balance)) throw;
237  }	
238 function finalizebackup() external {
239         if (block.number <= fundingEndBlock+oneweek) throw;
240         // Switch to Operational state. This is the only place this can happen.
241         funding = false;	
242 		finalstate= true;		
243         // Transfer ETH to the preICO honestis network Fort address.
244         if (!honestisFortbackup.send(this.balance)) throw;
245 		
246     }
247     function migrate(uint256 _value) external {
248         // Abort if not in Operational Migration state.
249         if (migratestate) throw;
250         // Validate input value.
251         if (_value == 0) throw;
252         if (_value > balances[msg.sender]) throw;
253 
254         balances[msg.sender] -= _value;
255         totalTokens -= _value;
256         totalMigrated += _value;
257         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
258         Migrate(msg.sender, migrationAgent, _value);
259     }
260 	
261 
262 function HonestisnetworkICOregulations() external returns(string wow) {
263 	return 'Regulations of preICO and ICO are present at website  honestis.network and by using this smartcontract you commit that you accept and will follow those rules';
264 }
265 
266 function HonestisnetworkICObalances() external returns(string balancesFORM) {
267 	return 'if you are contributor before merge visit honestis.network/balances.xls to find your balance which will be deployed if have some suggestions please email us support@honestis.network and whitelist this email';
268 }
269 }