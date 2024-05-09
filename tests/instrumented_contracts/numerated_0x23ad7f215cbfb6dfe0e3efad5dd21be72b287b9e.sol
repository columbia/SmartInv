1 pragma solidity ^0.4.8;
2 // ----------------------------------------------------------------------------
3 // 'The Bazeries Cylinder' token contract
4 //
5 // Symbol      : BAZ
6 // Name        : The Bazeries Cylinder
7 // Decimals    : 18
8 //
9 // Never forget: 
10 // The Times 03/Jan/2009 Chancellor on brink of second bailout for banks
11 // BTC must always thrive
12 // 
13 // ----------------------------------------------------------------------------
14 /**
15  * Math operations with safety checks
16  */
17 library SafeMath {
18   function mul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint a, uint b) internal returns (uint) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint a, uint b) internal returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint a, uint b) internal returns (uint) {
37     uint c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a >= b ? a : b;
44   }
45 
46   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
47     return a < b ? a : b;
48   }
49 
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51     return a >= b ? a : b;
52   }
53 
54   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
55     return a < b ? a : b;
56   }
57 
58   function assert(bool assertion) internal {
59     if (!assertion) {
60       throw;
61     }
62   }
63 }
64 
65 
66 /**
67  * @title ERC20Basic
68  * @dev Simpler version of ERC20 interface
69  * @dev see https://github.com/ethereum/EIPs/issues/20
70  */
71 contract ERC20Basic {
72   uint public totalSupply;
73   function balanceOf(address who) constant returns (uint);
74   function transfer(address to, uint value);
75   event Transfer(address indexed from, address indexed to, uint value);
76 }
77 
78 
79 /**
80  * @title Basic token
81  * @dev Basic version of StandardToken, with no allowances.
82  */
83 contract BasicToken is ERC20Basic {
84   using SafeMath for uint;
85 
86   mapping(address => uint) balances;
87 
88   /**
89    * @dev Fix for the ERC20 short address attack.
90    */
91   modifier onlyPayloadSize(uint size) {
92      if(msg.data.length < size + 4) {
93        throw;
94      }
95      _;
96   }
97 
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     Transfer(msg.sender, _to, _value);
107   }
108 
109   /**
110   * @dev Gets the balance of the specified address.
111   * @param _owner The address to query the the balance of.
112   * @return An uint representing the amount owned by the passed address.
113   */
114   function balanceOf(address _owner) constant returns (uint balance) {
115     return balances[_owner];
116   }
117 
118 }
119 
120 
121 /**
122  * @title ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/20
124  */
125 contract ERC20 is ERC20Basic {
126   function allowance(address owner, address spender) constant returns (uint);
127   function transferFrom(address from, address to, uint value);
128   function approve(address spender, uint value);
129   event Approval(address indexed owner, address indexed spender, uint value);
130 }
131 
132 
133 /**
134  * @title Standard ERC20 token
135  *
136  * @dev Implemantation of the basic standart token.
137  * @dev https://github.com/ethereum/EIPs/issues/20
138  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
139  */
140 contract StandardToken is BasicToken, ERC20 {
141 
142   mapping (address => mapping (address => uint)) allowed;
143 
144 
145   /**
146    * @dev Transfer tokens from one address to another
147    * @param _from address The address which you want to send tokens from
148    * @param _to address The address which you want to transfer to
149    * @param _value uint the amout of tokens to be transfered
150    */
151   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
152     var _allowance = allowed[_from][msg.sender];
153 
154     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
155     // if (_value > _allowance) throw;
156 
157     balances[_to] = balances[_to].add(_value);
158     balances[_from] = balances[_from].sub(_value);
159     allowed[_from][msg.sender] = _allowance.sub(_value);
160     Transfer(_from, _to, _value);
161   }
162 
163   /**
164    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
165    * @param _spender The address which will spend the funds.
166    * @param _value The amount of tokens to be spent.
167    */
168   function approve(address _spender, uint _value) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178   }
179 
180   /**
181    * @dev Function to check the amount of tokens than an owner allowed to a spender.
182    * @param _owner address The address which owns the funds.
183    * @param _spender address The address which will spend the funds.
184    * @return A uint specifing the amount of tokens still avaible for the spender.
185    */
186   function allowance(address _owner, address _spender) constant returns (uint remaining) {
187     return allowed[_owner][_spender];
188   }
189 
190 }
191 
192 
193 /**
194  * @title Ownable
195  * @dev The Ownable contract has an owner address, and provides basic authorization control
196  * functions, this simplifies the implementation of "user permissions".
197  */
198 contract Ownable {
199   address public owner;
200 
201 
202   /**
203    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
204    * account.
205    */
206   function Ownable() {
207     owner = msg.sender;
208   }
209 
210 
211   /**
212    * @dev Throws if called by any account other than the owner.
213    */
214   modifier onlyOwner() {
215     if (msg.sender != owner) {
216       throw;
217     }
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) onlyOwner {
227     if (newOwner != address(0)) {
228       owner = newOwner;
229     }
230   }
231 
232 }
233 
234 
235 /**
236  * @title Mintable token
237  * @dev Simple ERC20 Token example, with mintable token creation
238  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
239  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
240  */
241 
242 contract MintableToken is StandardToken, Ownable {
243   event Mint(address indexed to, uint value);
244   event MintFinished();
245 
246   bool public mintingFinished = false;
247   uint public totalSupply = 0;
248 
249 
250   modifier canMint() {
251     if(mintingFinished) throw;
252     _;
253   }
254 
255   /**
256    * @dev Function to mint tokens
257    * @param _to The address that will recieve the minted tokens.
258    * @param _amount The amount of tokens to mint.
259    * @return A boolean that indicates if the operation was successful.
260    */
261   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
262     totalSupply = totalSupply.add(_amount);
263     balances[_to] = balances[_to].add(_amount);
264     Mint(_to, _amount);
265     return true;
266   }
267 
268   /**
269    * @dev Function to stop minting new tokens.
270    * @return True if the operation was successful.
271    */
272   function finishMinting() onlyOwner returns (bool) {
273     mintingFinished = true;
274     MintFinished();
275     return true;
276   }
277 }
278 
279 
280 /**
281  * @title Pausable
282  * @dev Base contract which allows children to implement an emergency stop mechanism.
283  */
284 contract Pausable is Ownable {
285   event Pause();
286   event Unpause();
287 
288   bool public paused = false;
289 
290 
291   /**
292    * @dev modifier to allow actions only when the contract IS paused
293    */
294   modifier whenNotPaused() {
295     if (paused) throw;
296     _;
297   }
298 
299   /**
300    * @dev modifier to allow actions only when the contract IS NOT paused
301    */
302   modifier whenPaused {
303     if (!paused) throw;
304     _;
305   }
306 
307   /**
308    * @dev called by the owner to pause, triggers stopped state
309    */
310   function pause() onlyOwner whenNotPaused returns (bool) {
311     paused = true;
312     Pause();
313     return true;
314   }
315 
316   /**
317    * @dev called by the owner to unpause, returns to normal state
318    */
319   function unpause() onlyOwner whenPaused returns (bool) {
320     paused = false;
321     Unpause();
322     return true;
323   }
324 }
325 
326 
327 /**
328  * Pausable token
329  *
330  * Simple ERC20 Token example, with pausable token creation
331  **/
332 
333 contract PausableToken is StandardToken, Pausable {
334 
335   function transfer(address _to, uint _value) whenNotPaused {
336     super.transfer(_to, _value);
337   }
338 
339   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
340     super.transferFrom(_from, _to, _value);
341   }
342 }
343 
344 
345 /**
346  * @title TokenTimelock
347  * @dev TokenTimelock is a token holder contract that will allow a
348  * beneficiary to extract the tokens after a time has passed
349  */
350 contract TokenTimelock {
351 
352   // ERC20 basic token contract being held
353   ERC20Basic token;
354 
355   // beneficiary of tokens after they are released
356   address beneficiary;
357 
358   // timestamp where token release is enabled
359   uint releaseTime;
360 
361   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
362     require(_releaseTime > now);
363     token = _token;
364     beneficiary = _beneficiary;
365     releaseTime = _releaseTime;
366   }
367 
368   /**
369    * @dev beneficiary claims tokens held by time lock
370    */
371   function claim() {
372     require(msg.sender == beneficiary);
373     require(now >= releaseTime);
374 
375     uint amount = token.balanceOf(this);
376     require(amount > 0);
377 
378     token.transfer(beneficiary, amount);
379   }
380 }
381 
382 
383 /**
384  * @title The Bazeries Cylinder
385  * @dev The Bazeries Cylinder contract
386  */
387 contract Bazeries is PausableToken, MintableToken {
388   using SafeMath for uint256;
389 
390   string public name = "The Bazeries Cylinder";
391   string public symbol = "BAZ";
392   uint public decimals = 18;
393 
394   /**
395    * @dev mint timelocked tokens
396    */
397   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
398     onlyOwner canMint returns (TokenTimelock) {
399 
400     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
401     mint(timelock, _amount);
402 
403     return timelock;
404   }
405 
406 }