1 pragma solidity ^0.4.11;
2 
3 // ================= Ownable Contract start =============================
4 /*
5  * Ownable
6  *
7  * Base contract with an owner.
8  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
9  */
10 contract Ownable {
11   address public owner;
12 
13   function Ownable() {
14     owner = msg.sender;
15   }
16 
17   modifier onlyOwner() {
18     require(msg.sender == owner);
19     
20     _;
21   }
22 
23   function transferOwnership(address newOwner) onlyOwner {
24     if (newOwner != address(0)) {
25       owner = newOwner;
26     }
27   }
28 }
29 // ================= Ownable Contract end ===============================
30 
31 // ================= Safemath Contract start ============================
32 /* taking ideas from FirstBlood token */
33 contract SafeMath {
34 
35     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
36       uint256 z = x + y;
37       assert((z >= x) && (z >= y));
38       return z;
39     }
40 
41     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
42       assert(x >= y);
43       uint256 z = x - y;
44       return z;
45     }
46 
47     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
48       uint256 z = x * y;
49       assert((x == 0)||(z/x == y));
50       return z;
51     }
52 }
53 // ================= Safemath Contract end ==============================
54 
55 // ================= ERC20 Token Contract start =========================
56 /*
57  * ERC20 interface
58  * see https://github.com/ethereum/EIPs/issues/20
59  */
60 contract ERC20 {
61   uint public totalSupply;
62   function balanceOf(address who) constant returns (uint);
63   function allowance(address owner, address spender) constant returns (uint);
64 
65   function transfer(address to, uint value) returns (bool ok);
66   function transferFrom(address from, address to, uint value) returns (bool ok);
67   function approve(address spender, uint value) returns (bool ok);
68   event Transfer(address indexed from, address indexed to, uint value);
69   event Approval(address indexed owner, address indexed spender, uint value);
70 }
71 // ================= ERC20 Token Contract end ===========================
72 
73 // ================= Standard Token Contract start ======================
74 contract StandardToken is ERC20, SafeMath {
75 
76   /**
77    * @dev Fix for the ERC20 short address attack.
78    */
79   modifier onlyPayloadSize(uint size) {
80      require(msg.data.length >= size + 4) ;
81      _;
82   }
83 
84   mapping(address => uint) balances;
85   mapping (address => mapping (address => uint)) allowed;
86 
87   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){
88     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
89     balances[_to] = safeAdd(balances[_to], _value);
90     Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
95     var _allowance = allowed[_from][msg.sender];
96 
97     // Check is not needed because safeSub(_allowance, _value) will already throw if this condition is not met
98     // if (_value > _allowance) throw;
99 
100     balances[_to] = safeAdd(balances[_to], _value);
101     balances[_from] = safeSubtract(balances[_from], _value);
102     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
103     Transfer(_from, _to, _value);
104     return true;
105   }
106 
107   function balanceOf(address _owner) constant returns (uint balance) {
108     return balances[_owner];
109   }
110 
111   function approve(address _spender, uint _value) returns (bool success) {
112     allowed[msg.sender][_spender] = _value;
113     Approval(msg.sender, _spender, _value);
114     return true;
115   }
116 
117   function allowance(address _owner, address _spender) constant returns (uint remaining) {
118     return allowed[_owner][_spender];
119   }
120 }
121 // ================= Standard Token Contract end ========================
122 
123 // ================= Pausable Token Contract start ======================
124 /**
125  * @title Pausable
126  * @dev Base contract which allows children to implement an emergency stop mechanism.
127  */
128 contract Pausable is Ownable {
129   event Pause();
130   event Unpause();
131 
132   bool public paused = false;
133 
134 
135   /**
136    * @dev modifier to allow actions only when the contract IS paused
137    */
138   modifier whenNotPaused() {
139     require (!paused);
140     _;
141   }
142 
143   /**
144    * @dev modifier to allow actions only when the contract IS NOT paused
145    */
146   modifier whenPaused {
147     require (paused) ;
148     _;
149   }
150 
151   /**
152    * @dev called by the owner to pause, triggers stopped state
153    */
154   function pause() onlyOwner whenNotPaused returns (bool) {
155     paused = true;
156     Pause();
157     return true;
158   }
159 
160   /**
161    * @dev called by the owner to unpause, returns to normal state
162    */
163   function unpause() onlyOwner whenPaused returns (bool) {
164     paused = false;
165     Unpause();
166     return true;
167   }
168 }
169 // ================= Pausable Token Contract end ========================
170 
171 // ================= Indorse Token Contract start =======================
172 contract IndorseToken is SafeMath, StandardToken, Pausable {
173     // metadata
174     string public constant name = "Indorse Token";
175     string public constant symbol = "IND";
176     uint256 public constant decimals = 18;
177     string public version = "1.0";
178 
179     // contracts
180     address public indSaleDeposit        = 0x0053B91E38B207C97CBff06f48a0f7Ab2Dd81449;      // deposit address for Indorse Sale contract
181     address public indSeedDeposit        = 0x0083fdFB328fC8D07E2a7933e3013e181F9798Ad;      // deposit address for Indorse Seed Contributors
182     address public indPresaleDeposit     = 0x007AB99FBf023Cb41b50AE7D24621729295EdBFA;      // deposit address for Indorse Presale Contributors
183     address public indVestingDeposit     = 0x0011349f715cf59F75F0A00185e7B1c36f55C3ab;      // deposit address for Indorse Vesting for team and advisors
184     address public indCommunityDeposit   = 0x0097ec8840E682d058b24E6e19E68358d97A6E5C;      // deposit address for Indorse Marketing, etc
185     address public indFutureDeposit      = 0x00d1bCbCDE9Ca431f6dd92077dFaE98f94e446e4;      // deposit address for Indorse Future token sale
186     address public indInflationDeposit   = 0x00D31206E625F1f30039d1Fa472303E71317870A;      // deposit address for Indorse Inflation pool
187     
188     uint256 public constant indSale      = 31603785 * 10**decimals;                         
189     uint256 public constant indSeed      = 3566341  * 10**decimals; 
190     uint256 public constant indPreSale   = 22995270 * 10**decimals;                       
191     uint256 public constant indVesting   = 28079514 * 10**decimals;  
192     uint256 public constant indCommunity = 10919811 * 10**decimals;  
193     uint256 public constant indFuture    = 58832579 * 10**decimals;  
194     uint256 public constant indInflation = 14624747 * 10**decimals;  
195    
196     // constructor
197     function IndorseToken()
198     {
199       balances[indSaleDeposit]           = indSale;                                         // Deposit IND share
200       balances[indSeedDeposit]           = indSeed;                                         // Deposit IND share
201       balances[indPresaleDeposit]        = indPreSale;                                      // Deposit IND future share
202       balances[indVestingDeposit]        = indVesting;                                      // Deposit IND future share
203       balances[indCommunityDeposit]      = indCommunity;                                    // Deposit IND future share
204       balances[indFutureDeposit]         = indFuture;                                       // Deposit IND future share
205       balances[indInflationDeposit]      = indInflation;                                    // Deposit for inflation
206 
207       totalSupply = indSale + indSeed + indPreSale + indVesting + indCommunity + indFuture + indInflation;
208 
209       Transfer(0x0,indSaleDeposit,indSale);
210       Transfer(0x0,indSeedDeposit,indSeed);
211       Transfer(0x0,indPresaleDeposit,indPreSale);
212       Transfer(0x0,indVestingDeposit,indVesting);
213       Transfer(0x0,indCommunityDeposit,indCommunity);
214       Transfer(0x0,indFutureDeposit,indFuture);
215       Transfer(0x0,indInflationDeposit,indInflation);
216    }
217 
218   function transfer(address _to, uint _value) whenNotPaused returns (bool success)  {
219     return super.transfer(_to,_value);
220   }
221 
222   function approve(address _spender, uint _value) whenNotPaused returns (bool success)  {
223     return super.approve(_spender,_value);
224   }
225 }
226 // ================= Indorse Token Contract end =======================
227 
228 // ================= Actual Sale Contract Start ====================
229 contract IndorseSaleContract is  Ownable,SafeMath,Pausable {
230     IndorseToken    ind;
231 
232     // crowdsale parameters
233     uint256 public fundingStartTime = 1502193600;
234     uint256 public fundingEndTime   = 1504785600;
235     uint256 public totalSupply;
236     address public ethFundDeposit   = 0x26967201d4D1e1aA97554838dEfA4fC4d010FF6F;      // deposit address for ETH for Indorse Fund
237     address public indFundDeposit   = 0x0053B91E38B207C97CBff06f48a0f7Ab2Dd81449;      // deposit address for Indorse reserve
238     address public indAddress       = 0xf8e386EDa857484f5a12e4B5DAa9984E06E73705;
239 
240     bool public isFinalized;                                                            // switched to true in operational state
241     uint256 public constant decimals = 18;                                              // #dp in Indorse contract
242     uint256 public tokenCreationCap;
243     uint256 public constant tokenExchangeRate = 1000;                                   // 1000 IND tokens per 1 ETH
244     uint256 public constant minContribution = 0.05 ether;
245     uint256 public constant maxTokens = 1 * (10 ** 6) * 10**decimals;
246     uint256 public constant MAX_GAS_PRICE = 50000000000 wei;                            // maximum gas price for contribution transactions
247  
248     function IndorseSaleContract() {
249         ind = IndorseToken(indAddress);
250         tokenCreationCap = ind.balanceOf(indFundDeposit);
251         isFinalized = false;
252     }
253 
254     event MintIND(address from, address to, uint256 val);
255     event LogRefund(address indexed _to, uint256 _value);
256 
257     function CreateIND(address to, uint256 val) internal returns (bool success){
258         MintIND(indFundDeposit,to,val);
259         return ind.transferFrom(indFundDeposit,to,val);
260     }
261 
262     function () payable {    
263         createTokens(msg.sender,msg.value);
264     }
265 
266     /// @dev Accepts ether and creates new IND tokens.
267     function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
268       require (tokenCreationCap > totalSupply);                                         // CAP reached no more please
269       require (now >= fundingStartTime);
270       require (now <= fundingEndTime);
271       require (_value >= minContribution);                                              // To avoid spam transactions on the network    
272       require (!isFinalized);
273       require (tx.gasprice <= MAX_GAS_PRICE);
274 
275       uint256 tokens = safeMult(_value, tokenExchangeRate);                             // check that we're not over totals
276       uint256 checkedSupply = safeAdd(totalSupply, tokens);
277 
278       require (ind.balanceOf(msg.sender) + tokens <= maxTokens);
279       
280       // DA 8/6/2017 to fairly allocate the last few tokens
281       if (tokenCreationCap < checkedSupply) {        
282         uint256 tokensToAllocate = safeSubtract(tokenCreationCap,totalSupply);
283         uint256 tokensToRefund   = safeSubtract(tokens,tokensToAllocate);
284         totalSupply = tokenCreationCap;
285         uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
286 
287         require(CreateIND(_beneficiary,tokensToAllocate));                              // Create IND
288         msg.sender.transfer(etherToRefund);
289         LogRefund(msg.sender,etherToRefund);
290         ethFundDeposit.transfer(this.balance);
291         return;
292       }
293       // DA 8/6/2017 end of fair allocation code
294 
295       totalSupply = checkedSupply;
296       require(CreateIND(_beneficiary, tokens));                                         // logs token creation
297       ethFundDeposit.transfer(this.balance);
298     }
299     
300     /// @dev Ends the funding period and sends the ETH home
301     function finalize() external onlyOwner {
302       require (!isFinalized);
303       // move to operational
304       isFinalized = true;
305       ethFundDeposit.transfer(this.balance);                                            // send the eth to Indorse multi-sig
306     }
307 }