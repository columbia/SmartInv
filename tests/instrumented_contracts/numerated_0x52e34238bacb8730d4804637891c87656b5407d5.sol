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
60   uint public totalSupply;
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
116 }
117 // ================= Standard Token Contract end ========================
118 
119 // ================= Pausable Token Contract start ======================
120 /**
121  * @title Pausable
122  * @dev Base contract which allows children to implement an emergency stop mechanism.
123  */
124 contract Pausable is Ownable {
125   event Pause();
126   event Unpause();
127 
128   bool public paused = false;
129 
130 
131   /**
132   * @dev modifier to allow actions only when the contract IS paused
133   */
134   modifier whenNotPaused() {
135     require (!paused);
136     _;
137   }
138 
139   /**
140   * @dev modifier to allow actions only when the contract IS NOT paused
141   */
142   modifier whenPaused {
143     require (paused) ;
144     _;
145   }
146 
147   /**
148   * @dev called by the owner to pause, triggers stopped state
149   */
150   function pause() onlyOwner whenNotPaused returns (bool) {
151     paused = true;
152     Pause();
153     return true;
154   }
155 
156   /**
157   * @dev called by the owner to unpause, returns to normal state
158   */
159   function unpause() onlyOwner whenPaused returns (bool) {
160     paused = false;
161     Unpause();
162     return true;
163   }
164 }
165 // ================= Pausable Token Contract end ========================
166 
167 // ================= IcoToken  start =======================
168 contract IcoToken is SafeMath, StandardToken, Pausable {
169   string public name;
170   string public symbol;
171   uint256 public decimals;
172   string public version;
173   address public icoContract;
174 
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
212       totalSupply += _value;
213 
214       Transfer(0x0, owner, _value);
215       Transfer(owner, _recipient, _value);
216       return true;
217   }
218 
219   function issue(address _recipient, uint256 _value) whenNotPaused onlyOwner returns (bool success) {
220       assert(_value > 0);
221       _value = _value * 10**decimals;
222 
223       balances[_recipient] += _value;
224       totalSupply += _value;
225 
226       Transfer(0x0, owner, _value);
227       Transfer(owner, _recipient, _value);
228       return true;
229   }
230 
231 }
232 // ================= Ico Token Contract end =======================
233 
234 // ================= Actual Sale Contract Start ====================
235 contract IcoContract is SafeMath, Pausable {
236   IcoToken public ico;
237 
238   address public ethFundDeposit;
239   address public icoAddress;
240 
241   uint256 public fundingStartTime;
242   uint256 public minContribution;
243 
244   uint256 public tokenCreationCap;
245   uint256 public totalSupply;
246 
247   bool public isFinalized;
248   uint256 public tokenExchangeRate;
249 
250   event MintICO(address from, address to, uint256 val);
251 
252   function CreateICO(address to, uint256 val) internal returns (bool success) {
253     MintICO(0x0, to, val);
254     return ico.sell(to, val);
255   }
256 
257   function IcoContract(
258     address _ethFundDeposit,
259     address _icoAddress,
260     uint256 _fundingStartTime,
261     uint256 _tokenExchangeRate,
262     uint256 _tokenCreationCap,
263     uint256 _minContribution
264   )
265   {
266     ethFundDeposit = _ethFundDeposit;
267     icoAddress = _icoAddress;
268     fundingStartTime = _fundingStartTime;
269     tokenExchangeRate = _tokenExchangeRate;
270     tokenCreationCap = _tokenCreationCap;
271     minContribution = _minContribution;
272     ico = IcoToken(icoAddress);
273     isFinalized = false;
274   }
275 
276   function () payable {    
277     createTokens(msg.sender, msg.value);
278   }
279 
280   /// @dev Accepts ether and creates new ICO tokens.
281   function createTokens(address _beneficiary, uint256 _value) internal whenNotPaused {
282     require (tokenCreationCap > totalSupply);
283     require (now >= fundingStartTime);
284     require (_value >= minContribution);
285     require (!isFinalized);
286 
287     uint256 tokens = safeMult(_value, tokenExchangeRate);
288     uint256 checkedSupply = safeAdd(totalSupply, tokens);
289 
290     if (tokenCreationCap < checkedSupply) {        
291       uint256 tokensToAllocate = safeSubtract(tokenCreationCap, totalSupply);
292       uint256 tokensToRefund   = safeSubtract(tokens, tokensToAllocate);
293       totalSupply = tokenCreationCap;
294       uint256 etherToRefund = tokensToRefund / tokenExchangeRate;
295 
296       require(CreateICO(_beneficiary, tokensToAllocate));
297       msg.sender.transfer(etherToRefund);
298       ethFundDeposit.transfer(this.balance);
299       return;
300     }
301 
302     totalSupply = checkedSupply;
303 
304     require(CreateICO(_beneficiary, tokens)); 
305     ethFundDeposit.transfer(this.balance);
306   }
307 
308   /// @dev Ends the funding period and sends the ETH home
309   function finalize() external onlyOwner {
310     require (!isFinalized);
311     // move to operational
312     isFinalized = true;
313     ethFundDeposit.transfer(this.balance);
314   }
315 }