1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 /**
73  * @title Pausable
74  * @dev Base contract which allows children to implement an emergency stop mechanism.
75  */
76 contract Pausable is Ownable {
77   event Pause();
78   event Unpause();
79   event PauseRefund();
80   event UnpauseRefund();
81 
82   bool public paused = true;
83   bool public refundPaused = true;
84 
85   /**
86    * @dev modifier to allow actions only when the contract IS NOT paused
87    */
88   modifier whenNotPaused() {
89     require(!paused);
90     _;
91   }
92 
93   /**
94    * @dev modifier to allow actions only when the refund IS NOT paused
95    */
96   modifier whenRefundNotPaused() {
97     require(!refundPaused);
98     _;
99   }
100 
101   /**
102    * @dev modifier to allow actions only when the contract IS paused
103    */
104   modifier whenPaused {
105     require(paused);
106     _;
107   }
108   
109   /**
110    * @dev modifier to allow actions only when the refund IS paused
111    */
112   modifier whenRefundPaused {
113     require(refundPaused);
114     _;
115   }
116 
117   /**
118    * @dev called by the owner to pause, triggers stopped state
119    */
120   function pause() onlyOwner whenNotPaused returns (bool) {
121     paused = true;
122     Pause();
123     return true;
124   }
125   
126   /**
127    * @dev called by the owner to pause, triggers stopped state
128    */
129   function pauseRefund() onlyOwner whenRefundNotPaused returns (bool) {
130     refundPaused = true;
131     PauseRefund();
132     return true;
133   }
134 
135   /**
136    * @dev called by the owner to unpause, returns to normal state
137    */
138   function unpause() onlyOwner whenPaused returns (bool) {
139     paused = false;
140     Unpause();
141     return true;
142   }
143   
144   /**
145    * @dev called by the owner to unpause, returns to normal state
146    */
147   function unpauseRefund() onlyOwner whenRefundPaused returns (bool) {
148     refundPaused = false;
149     UnpauseRefund();
150     return true;
151   }
152 }
153 
154 /**
155  * @title ERC20Basic
156  * @dev Simpler version of ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/179
158  */
159 contract ERC20Basic {
160   uint256 public totalSupply;
161   function balanceOf(address who) constant returns (uint256);
162   function transfer(address to, uint256 value) returns (bool);
163   event Transfer(address indexed from, address indexed to, uint256 value);
164 }
165 
166 /**
167  * @title Basic token
168  * @dev Basic version of StandardToken, with no allowances.
169  */
170 contract BasicToken is ERC20Basic {
171   using SafeMath for uint256;
172 
173   mapping(address => uint256) balances;
174 
175   /**
176   * @dev transfer token for a specified address
177   * @param _to The address to transfer to.
178   * @param _value The amount to be transferred.
179   */
180   function transfer(address _to, uint256 _value) returns (bool) {
181     balances[msg.sender] = balances[msg.sender].sub(_value);
182     balances[_to] = balances[_to].add(_value);
183     Transfer(msg.sender, _to, _value);
184     return true;
185   }
186 
187   /**
188   * @dev Gets the balance of the specified address.
189   * @param _owner The address to query the the balance of.
190   * @return An uint256 representing the amount owned by the passed address.
191   */
192   function balanceOf(address _owner) constant returns (uint256 balance) {
193     return balances[_owner];
194   }
195 
196 }
197 
198 /**
199  * @title ERC20 interface
200  * @dev see https://github.com/ethereum/EIPs/issues/20
201  */
202 contract ERC20 is ERC20Basic {
203   function allowance(address owner, address spender) constant returns (uint256);
204   function transferFrom(address from, address to, uint256 value) returns (bool);
205   function approve(address spender, uint256 value) returns (bool);
206   event Approval(address indexed owner, address indexed spender, uint256 value);
207 }
208 
209 /**
210  * @title Standard ERC20 token
211  *
212  * @dev Implementation of the basic standard token.
213  * @dev https://github.com/ethereum/EIPs/issues/20
214  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  */
216 contract StandardToken is ERC20, BasicToken {
217 
218   mapping (address => mapping (address => uint256)) allowed;
219 
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amout of tokens to be transfered
226    */
227   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
228     var _allowance = allowed[_from][msg.sender];
229 
230     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
231     // require (_value <= _allowance);
232 
233     balances[_to] = balances[_to].add(_value);
234     balances[_from] = balances[_from].sub(_value);
235     allowed[_from][msg.sender] = _allowance.sub(_value);
236     Transfer(_from, _to, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
242    * @param _spender The address which will spend the funds.
243    * @param _value The amount of tokens to be spent.
244    */
245   function approve(address _spender, uint256 _value) returns (bool) {
246 
247     // To change the approve amount you first have to reduce the addresses`
248     //  allowance to zero by calling `approve(_spender, 0)` if it is not
249     //  already 0 to mitigate the race condition described here:
250     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
251     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
252 
253     allowed[msg.sender][_spender] = _value;
254     Approval(msg.sender, _spender, _value);
255     return true;
256   }
257 
258   /**
259    * @dev Function to check the amount of tokens that an owner allowed to a spender.
260    * @param _owner address The address which owns the funds.
261    * @param _spender address The address which will spend the funds.
262    * @return A uint256 specifing the amount of tokens still available for the spender.
263    */
264   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
265     return allowed[_owner][_spender];
266   }
267 
268 }
269 
270 /**
271  * @title SimpleToken
272  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
273  * Note they can later distribute these tokens as they wish using `transfer` and other
274  * `StandardToken` functions.
275  */
276 contract AssetToken is Pausable, StandardToken {
277 
278   using SafeMath for uint256;
279 
280   address public treasurer = 0x0;
281 
282   uint256 public purchasableTokens = 0;
283 
284   string public name = "Asset Token";
285   string public symbol = "AST";
286   uint256 public decimals = 18;
287   uint256 public INITIAL_SUPPLY = 1000000000 * 10**18;
288 
289   uint256 public RATE = 200;
290   uint256 public REFUND_RATE = 200;
291 
292   /**
293    * @dev Contructor that gives msg.sender all of existing tokens.
294    */
295   function AssetToken() {
296     totalSupply = INITIAL_SUPPLY;
297     balances[msg.sender] = INITIAL_SUPPLY;
298   }
299 
300   /**
301    * @dev Allows the current owner to transfer control of the contract to a newOwner.
302    * @param newOwner The address to transfer ownership to.
303    */
304   function transferOwnership(address newOwner) onlyOwner {
305     address oldOwner = owner;
306     super.transferOwnership(newOwner);
307     balances[newOwner] = balances[oldOwner];
308     balances[oldOwner] = 0;
309   }
310 
311   /**
312    * @dev Allows the current owner to transfer treasurership of the contract to a newTreasurer.
313    * @param newTreasurer The address to transfer treasurership to.
314    */
315   function transferTreasurership(address newTreasurer) onlyOwner {
316     if (newTreasurer != address(0)) {
317       treasurer = newTreasurer;
318     }
319   }
320 
321   /**
322    * @dev Allows owner to release tokens for purchase
323    * @param amount The number of tokens to release
324    */
325   function setPurchasable(uint256 amount) onlyOwner {
326     require(amount > 0);
327     require(balances[owner] >= amount);
328     purchasableTokens = amount.mul(10**18);
329   }
330   
331   /**
332    * @dev Allows owner to change the rate Tokens per 1 Ether
333    * @param rate The number of tokens to release
334    */
335   function setRate(uint256 rate) onlyOwner {
336       RATE = rate;
337   }
338   
339   /**
340    * @dev Allows owner to change the refund rate Tokens per 1 Ether
341    * @param rate The number of tokens to release
342    */
343   function setRefundRate(uint256 rate) onlyOwner {
344       REFUND_RATE = rate;
345   }
346 
347   /**
348    * @dev fallback function
349    */
350   function () payable {
351     buyTokens(msg.sender);
352   }
353 
354   /**
355    * @dev function that sells available tokens
356    */
357   function buyTokens(address addr) payable whenNotPaused {
358     require(treasurer != 0x0); // Must have a treasurer
359 
360     // Calculate tokens to sell and check that they are purchasable
361     uint256 weiAmount = msg.value;
362     uint256 tokens = weiAmount.mul(RATE);
363     require(purchasableTokens >= tokens);
364 
365     // Send tokens to buyer
366     purchasableTokens = purchasableTokens.sub(tokens);
367     balances[owner] = balances[owner].sub(tokens);
368     balances[addr] = balances[addr].add(tokens);
369 
370     Transfer(owner, addr, tokens);
371 
372     // Send money to the treasurer
373     treasurer.transfer(msg.value);
374   }
375   
376   function fund() payable {}
377 
378   function defund() onlyOwner {
379       treasurer.transfer(this.balance);
380   }
381   
382   function refund(uint256 _amount) whenRefundNotPaused {
383       require(balances[msg.sender] >= _amount);
384       
385       // Calculate refund
386       uint256 refundAmount = _amount.div(REFUND_RATE);
387       require(this.balance >= refundAmount);
388       
389       balances[msg.sender] = balances[msg.sender].sub(_amount);
390       balances[owner] = balances[owner].add(_amount);
391       
392       msg.sender.transfer(refundAmount);
393   }
394 }