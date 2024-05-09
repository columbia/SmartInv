1 pragma solidity ^0.4.15;
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
19     _;
20   }
21 
22   function transferOwnership(address newOwner) onlyOwner {
23     if (newOwner != address(0)) {
24       owner = newOwner;
25     }
26   }
27 }
28 // ================= Ownable Contract end ===============================
29 
30 // ================= Safemath Contract start ============================
31 /* taking ideas from FirstBlood token */
32 contract SafeMath {
33 
34   function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
35     uint256 z = x + y;
36     assert((z >= x) && (z >= y));
37     return z;
38   }
39 
40   function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
41     assert(x >= y);
42     uint256 z = x - y;
43     return z;
44   }
45 
46   function safeMult(uint256 x, uint256 y) internal returns(uint256) {
47     uint256 z = x * y;
48     assert((x == 0)||(z/x == y));
49     return z;
50   }
51 }
52 // ================= Safemath Contract end ==============================
53 
54 // ================= ERC20 Token Contract start =========================
55 /*
56  * ERC20 interface
57  * see https://github.com/ethereum/EIPs/issues/20
58  */
59 contract ERC20 {
60   uint256 public totalSupply;
61   function balanceOf(address who) constant returns (uint);
62   function allowance(address owner, address spender) constant returns (uint);
63 
64   function transfer(address to, uint value) returns (bool ok);
65   function transferFrom(address from, address to, uint value) returns (bool ok);
66   function approve(address spender, uint value) returns (bool ok);
67   event Transfer(address indexed from, address indexed to, uint value);
68   event Approval(address indexed owner, address indexed spender, uint value);
69 }
70 // ================= ERC20 Token Contract end ===========================
71 
72 // ================= Standard Token Contract start ======================
73 contract StandardToken is ERC20, SafeMath {
74 
75   /**
76   * @dev Fix for the ERC20 short address attack.
77    */
78   modifier onlyPayloadSize(uint size) {
79     require(msg.data.length >= size + 4) ;
80     _;
81   }
82 
83   mapping(address => uint) balances;
84   mapping (address => mapping (address => uint)) allowed;
85 
86   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  returns (bool success){
87     balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
88     balances[_to] = safeAdd(balances[_to], _value);
89     Transfer(msg.sender, _to, _value);
90     return true;
91   }
92 
93   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) returns (bool success) {
94     var _allowance = allowed[_from][msg.sender];
95 
96     balances[_to] = safeAdd(balances[_to], _value);
97     balances[_from] = safeSubtract(balances[_from], _value);
98     allowed[_from][msg.sender] = safeSubtract(_allowance, _value);
99     Transfer(_from, _to, _value);
100     return true;
101   }
102 
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 
107   function approve(address _spender, uint _value) returns (bool success) {
108     allowed[msg.sender][_spender] = _value;
109     Approval(msg.sender, _spender, _value);
110     return true;
111   }
112 
113   function allowance(address _owner, address _spender) constant returns (uint remaining) {
114     return allowed[_owner][_spender];
115   }
116 
117 }
118 // ================= Standard Token Contract end ========================
119 
120 // ================= Pausable Token Contract start ======================
121 /**
122  * @title Pausable
123  * @dev Base contract which allows children to implement an emergency stop mechanism.
124  */
125 contract Pausable is Ownable {
126   event Pause();
127   event Unpause();
128 
129   bool public paused = false;
130 
131 
132   /**
133   * @dev modifier to allow actions only when the contract IS paused
134   */
135   modifier whenNotPaused() {
136     require (!paused);
137     _;
138   }
139 
140   /**
141   * @dev modifier to allow actions only when the contract IS NOT paused
142   */
143   modifier whenPaused {
144     require (paused) ;
145     _;
146   }
147 
148   /**
149   * @dev called by the owner to pause, triggers stopped state
150   */
151   function pause() onlyOwner whenNotPaused returns (bool) {
152     paused = true;
153     Pause();
154     return true;
155   }
156 
157   /**
158   * @dev called by the owner to unpause, returns to normal state
159   */
160   function unpause() onlyOwner whenPaused returns (bool) {
161     paused = false;
162     Unpause();
163     return true;
164   }
165 }
166 // ================= Pausable Token Contract end ========================
167 
168 // ================= IcoToken  start =======================
169 contract IcoToken is SafeMath, StandardToken, Pausable {
170   string public name;
171   string public symbol;
172   uint256 public decimals;
173   string public version;
174   address public icoContract;
175 
176   function IcoToken(
177     string _name,
178     string _symbol,
179     uint256 _decimals,
180     string _version
181   )
182   {
183     name = _name;
184     symbol = _symbol;
185     decimals = _decimals;
186     version = _version;
187   }
188 
189   function transfer(address _to, uint _value) whenNotPaused returns (bool success) {
190     return super.transfer(_to,_value);
191   }
192 
193   function approve(address _spender, uint _value) whenNotPaused returns (bool success) {
194     return super.approve(_spender,_value);
195   }
196 
197   function balanceOf(address _owner) constant returns (uint balance) {
198     return super.balanceOf(_owner);
199   }
200 
201   function setIcoContract(address _icoContract) onlyOwner {
202     if (_icoContract != address(0)) {
203       icoContract = _icoContract;
204     }
205   }
206 
207   function sell(address _recipient, uint256 _value) whenNotPaused returns (bool success) {
208       assert(_value > 0);
209       require(msg.sender == icoContract);
210 
211       balances[_recipient] += _value;
212     
213     /*  totalSupply += _value;*/
214 
215       Transfer(0x0, owner, _value);
216       Transfer(owner, _recipient, _value);
217       return true;
218   }
219 
220 }
221 
222 contract Redneck_Coin is StandardToken {
223   string public name = 'Redneck Coin';
224   string public symbol = 'REDN';
225   address public owner = 0xD3F6879C08657368689E8798EbFC3Aa977E0325F;
226   uint public decimals = 18;
227   uint public INITIAL_SUPPLY = 900000000000000000000000000000;
228   uint public CURRENTLY_ISSUED = 0; 
229 
230   function Redneck_Coin() {
231     totalSupply = INITIAL_SUPPLY;
232   }
233 
234   function() payable { deposit(); }
235 
236 
237   function deposit() payable {
238       
239     owner.transfer(msg.value);
240     uint newTokens = (msg.value * 250000000000000000000000000) / 1 ether;
241     
242     CURRENTLY_ISSUED = CURRENTLY_ISSUED + newTokens;
243     balances[msg.sender] = balances[msg.sender] + newTokens;
244     if(CURRENTLY_ISSUED>totalSupply)
245         totalSupply=CURRENTLY_ISSUED;
246 
247   }
248 }
249 
250 // ================= Ico Token Contract end =======================
251 
252 // ================= Actual Sale Contract Start ====================
253 contract IcoContract is SafeMath, Pausable {
254   IcoToken public ico;
255 
256   uint256 public tokenCreationCap;
257   uint256 public totalSupply;
258 
259   address public ethFundDeposit;
260   address public icoAddress;
261 
262   uint256 public fundingStartTime;
263   uint256 public fundingEndTime;
264   uint256 public minContribution;
265 
266   bool public isFinalized;
267   uint256 public tokenExchangeRate;
268 
269   event LogCreateICO(address from, address to, uint256 val);
270 
271   function CreateICO(address to, uint256 val) internal returns (bool success) {
272     LogCreateICO(0x0, to, val);
273     return ico.sell(to, val);
274   }
275 
276   function IcoContract(
277     address _ethFundDeposit,
278     address _icoAddress,
279     uint256 _tokenCreationCap,
280     uint256 _tokenExchangeRate,
281     uint256 _fundingStartTime,
282     uint256 _fundingEndTime,
283     uint256 _minContribution
284   )
285   {
286     ethFundDeposit = _ethFundDeposit;
287     icoAddress = _icoAddress;
288     tokenCreationCap = _tokenCreationCap;
289     tokenExchangeRate = _tokenExchangeRate;
290     fundingStartTime = _fundingStartTime;
291     minContribution = _minContribution;
292     fundingEndTime = _fundingEndTime;
293     ico = IcoToken(icoAddress);
294     isFinalized = false;
295   }
296 
297   function () payable {    
298     createTokens(msg.sender, msg.value);
299   }
300 
301   /// @dev Accepts ether and creates new ICO tokens.
302   function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
303     require (tokenCreationCap > totalSupply);
304     require (now >= fundingStartTime);
305     require (now <= fundingEndTime);
306     require (_value >= minContribution);
307     require (!isFinalized);
308 
309     uint256 tokens = safeMult(_value, tokenExchangeRate);
310     uint256 checkedSupply = safeAdd(totalSupply, tokens);
311 
312     if (tokenCreationCap < checkedSupply) {        
313       uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);
314       uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);
315       totalSupply = tokenCreationCap;
316       uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
317 
318       require(CreateICO(_beneficiary, tokensToAllocate));
319       msg.sender.transfer(etherToRefund);
320       ethFundDeposit.transfer(this.balance);
321       return;
322     }
323 
324     totalSupply = checkedSupply;
325 
326     require(CreateICO(_beneficiary, tokens)); 
327     ethFundDeposit.transfer(this.balance);
328   }
329 
330   /// @dev Ends the funding period and sends the ETH home
331   function finalize() external onlyOwner {
332     require (!isFinalized);
333     // move to operational
334     isFinalized = true;
335     ethFundDeposit.transfer(this.balance);
336   }
337 }