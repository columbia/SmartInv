1 //Honestis deployment
2 pragma solidity ^0.4.11;
3 
4 contract ERC20 {
5   uint public totalSupply;
6   function balanceOf(address who) constant returns (uint);
7   function allowance(address owner, address spender) constant returns (uint);
8 
9   function transfer(address to, uint value) returns (bool ok);
10   function transferFrom(address from, address to, uint value) returns (bool ok);
11   function approve(address spender, uint value) returns (bool ok);
12   event Transfer(address indexed from, address indexed to, uint value);
13   event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 
17 
18 /**
19  * Math operations with safety checks
20  */
21 contract SafeMath {
22   function safeMul(uint a, uint b) internal returns (uint) {
23     uint c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function safeDiv(uint a, uint b) internal returns (uint) {
29     assert(b > 0);
30     uint c = a / b;
31     assert(a == b * c + a % b);
32     return c;
33   }
34 
35   function safeSub(uint a, uint b) internal returns (uint) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function safeAdd(uint a, uint b) internal returns (uint) {
41     uint c = a + b;
42     assert(c>=a && c>=b);
43     return c;
44   }
45 
46   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a >= b ? a : b;
48   }
49 
50   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
51     return a < b ? a : b;
52   }
53 
54   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a >= b ? a : b;
56   }
57 
58   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
59     return a < b ? a : b;
60   }
61 
62   function assert(bool assertion) internal {
63     if (!assertion) {
64       throw;
65     }
66   }
67 }
68 
69 
70 
71 /**
72  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
73  *
74  * Based on code by FirstBlood:
75  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
76  */
77 contract StandardToken is ERC20, SafeMath {
78 
79   /* Token supply got increased and a new owner received these tokens */
80   event Minted(address receiver, uint amount);
81 
82   /* Actual balances of token holders */
83   mapping(address => uint) balances;
84 
85   /* approve() allowances */
86   mapping (address => mapping (address => uint)) allowed;
87 
88   /* Interface declaration */
89   function isToken() public constant returns (bool weAre) {
90     return true;
91   }
92 
93   function transfer(address _to, uint _value) returns (bool success) {
94     balances[msg.sender] = safeSub(balances[msg.sender], _value);
95     balances[_to] = safeAdd(balances[_to], _value);
96     Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
101     uint _allowance = allowed[_from][msg.sender];
102 
103     balances[_to] = safeAdd(balances[_to], _value);
104     balances[_from] = safeSub(balances[_from], _value);
105     allowed[_from][msg.sender] = safeSub(_allowance, _value);
106     Transfer(_from, _to, _value);
107     return true;
108   }
109 
110   function balanceOf(address _owner) constant returns (uint balance) {
111     return balances[_owner];
112   }
113 
114   function approve(address _spender, uint _value) returns (bool success) {
115 
116     // To change the approve amount you first have to reduce the addresses`
117     //  allowance to zero by calling `approve(_spender, 0)` if it is not
118     //  already 0 to mitigate the race condition described here:
119     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
121 
122     allowed[msg.sender][_spender] = _value;
123     Approval(msg.sender, _spender, _value);
124     return true;
125   }
126 
127   function allowance(address _owner, address _spender) constant returns (uint remaining) {
128     return allowed[_owner][_spender];
129   }
130 
131 }
132 
133 
134 //  Honestis Network Token 
135 contract HonestisNetworkTokenWire3{
136 
137     string public name = "Honestis.Network Token Version 1";
138     string public symbol = "HNT";
139     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH/HEE.
140     // The funding cap in weis.
141 // was not reached about 93% was sold    uint256 public constant tokenCreationCap = 66200 * 1000 * ether ;
142 	
143     // Receives ETH and its own H.N Token endowment.
144     address public honestisFort = 0xF03e8E4cbb2865fCc5a02B61cFCCf86E9aE021b5;
145     // NOT APPLY
146     address public migrationMaster = 0x0f32f4b37684be8a1ce1b2ed765d2d893fa1b419;
147     // The current total token supply.
148 	//totalsupply
149   //  uint256 public constant allchainstotalsupply =61172163.78335328 ether;
150 //    uint256 public constant supply on chain 1st and 2nd     =57872163.78335328 ether;
151 //	uint256 public constant supply4chains34 = 3300000.0 ether;
152 uint256 public constant supply = 3300000.0 ether;
153 		//61172163 783353280000000000
154 	// was 61168800
155 	//chains:
156 	address public firstChainHNw1 = 0x0;
157 	address public secondChainHNw2 = 0x0;
158 	address public thirdChainETH = 0x0;
159 	address public fourthChainETC = 0x0;
160 				
161 	struct sendTokenAway{
162 		StandardToken coinContract;
163 		uint amount;
164 		address recipient;
165 	}
166 	mapping(uint => sendTokenAway) transfers;
167 	uint numTransfers=0;
168 	
169   mapping (address => uint256) balances;
170 
171   mapping (address => mapping (address => uint256)) allowed;
172 
173 	event UpdatedTokenInformation(string newName, string newSymbol);	
174  
175     event Transfer(address indexed _from, address indexed _to, uint256 _value);
176 	
177   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
178 
179   function HonestisNetworkTokenWire3() {
180 // BALANCES		
181 //XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
182 // funcje transfer , fransfer from, allow, allowance , wywalic migrate i mastera , owner tylko do zmiany nazwy ??, total security check 
183 //early adopters community 1
184 //balances[0xd57908dbe0e1353771db7f953E74a7936a5aAd70]=                   61172163783353280000000000;
185 // 1st and 2nd chain balances[0xd57908dbe0e1353771db7f953E74a7936a5aAd70]=57872163783353280000000000;
186 // 3rd and 4th chain 3300000 000000000000000000;                          +3300000000000000000000000;
187  balances[0x8585d5a25b1fa2a0e6c3bcfc098195bac9789be2]=3300000000000000000000000;
188 }
189 
190   
191   function transfer(address _to, uint256 _value) returns (bool success) {
192     //Default assumes totalSupply can't be over max (2^256 - 1).
193     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
194     //Replace the if with this one instead.
195     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
196     //if (balances[msg.sender] >= _value && _value > 0) {
197       balances[msg.sender] -= _value;
198       balances[_to] += _value;
199       Transfer(msg.sender, _to, _value);
200       return true;
201     } else { return false; }
202   }
203 
204   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
205     //same as above. Replace this line with the following if you want to protect against wrapping uints.
206     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
207     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
208       balances[_to] += _value;
209       balances[_from] -= _value;
210       allowed[_from][msg.sender] -= _value;
211       Transfer(_from, _to, _value);
212       return true;
213     } else { return false; }
214   }
215 
216   function balanceOf(address _owner) constant returns (uint256 balance) {
217     return balances[_owner];
218   }
219 
220   function approve(address _spender, uint256 _value) returns (bool success) {
221     allowed[msg.sender][_spender] = _value;
222     Approval(msg.sender, _spender, _value);
223     return true;
224   }
225 
226   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
227     return allowed[_owner][_spender];
228   }
229 
230 
231 	function() payable {
232 
233    }
234 
235 
236 function justSendDonations() external {
237     if (msg.sender != honestisFort) throw;
238 	if (!honestisFort.send(this.balance)) throw;
239 }
240 	
241   function setTokenInformation(string _name, string _symbol) {
242     
243 	   if (msg.sender != honestisFort) {
244       throw;
245     }
246 	name = _name;
247     symbol = _symbol;
248 
249     UpdatedTokenInformation(name, symbol);
250   }
251 
252 function setChainsAddresses(address chainAd, int chainnumber) {
253     
254 	   if (msg.sender != honestisFort) {
255       throw;
256     }
257 	if(chainnumber==1){firstChainHNw1=chainAd;}
258 	if(chainnumber==2){secondChainHNw2=chainAd;}
259 	if(chainnumber==3){thirdChainETH=chainAd;}
260 	if(chainnumber==4){fourthChainETC=chainAd;}		
261   } 
262 
263   function HonestisnetworkICOregulations() external returns(string wow) {
264 	return 'Regulations of preICO and ICO are present at website  honestis.network and by using this smartcontract and blockchains you commit that you accept and will follow those rules';
265 }
266 // if accidentally other token was donated to Project Dev
267 
268 
269 	function sendTokenAw(address StandardTokenAddress, address receiver, uint amount){
270 		if (msg.sender != honestisFort) {
271 		throw;
272 		}
273 		sendTokenAway t = transfers[numTransfers];
274 		t.coinContract = StandardToken(StandardTokenAddress);
275 		t.amount = amount;
276 		t.recipient = receiver;
277 		t.coinContract.transfer(receiver, amount);
278 		numTransfers++;
279 	}
280 
281 
282 
283 
284 }
285 
286 
287 //------------------------------------------------------