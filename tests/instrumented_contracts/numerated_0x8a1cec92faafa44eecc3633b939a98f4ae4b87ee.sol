1 /**
2 * The OGX token contract bases on the ERC20 standard token contracts 
3 * Author : Gordon T. Arsiranawin 
4 * @ 22.22.22
5 * Orgura Inc. &
6 * Green The World Network Association for Environment of Thailand
7 */
8 
9 pragma solidity ^0.4.24;
10 
11 
12 /**
13  * Math operations with safety checks
14  */
15 library SafeMath {
16   function mul(uint a, uint b) internal returns (uint) {
17     uint c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint a, uint b) internal returns (uint) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint a, uint b) internal returns (uint) {
35     uint c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 
40   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a >= b ? a : b;
42   }
43 
44   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
45     return a < b ? a : b;
46   }
47 
48   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a >= b ? a : b;
50   }
51 
52   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
53     return a < b ? a : b;
54   }
55 
56   function assert(bool assertion) internal {
57     if (!assertion) {
58       throw;
59     }
60   }
61 }
62 
63 
64 /**
65  * @title ERC20Basic
66  * @dev Simpler version of ERC20 interface
67  * @dev see https://github.com/ethereum/EIPs/issues/20
68  */
69 contract ERC20Basic {
70   uint public totalSupply;
71   function balanceOf(address who) constant returns (uint);
72   function transfer(address to, uint value);
73   event Transfer(address indexed from, address indexed to, uint value);
74 }
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint;
83 
84   mapping(address => uint) balances;
85 
86   /**
87    * @dev Fix for the ERC20 short address attack.
88    */
89   modifier onlyPayloadSize(uint size) {
90      if(msg.data.length < size + 4) {
91        throw;
92      }
93      _;
94   }
95 
96   /**
97   * @dev transfer token for a specified address
98   * @param _to The address to transfer to.
99   * @param _value The amount to be transferred.
100   */
101   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
102     balances[msg.sender] = balances[msg.sender].sub(_value);
103     balances[_to] = balances[_to].add(_value);
104     Transfer(msg.sender, _to, _value);
105   }
106 
107   /**
108   * @dev Gets the balance of the specified address.
109   * @param _owner The address to query the the balance of.
110   * @return An uint representing the amount owned by the passed address.
111   */
112   function balanceOf(address _owner) constant returns (uint balance) {
113     return balances[_owner];
114   }
115 
116 }
117 
118 
119 /**
120  * @title ERC20 interface
121  * @dev see https://github.com/ethereum/EIPs/issues/20
122  */
123 contract ERC20 is ERC20Basic {
124   function allowance(address owner, address spender) constant returns (uint);
125   function transferFrom(address from, address to, uint value);
126   function approve(address spender, uint value);
127   event Approval(address indexed owner, address indexed spender, uint value);
128 }
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implemantation of the basic standart token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is BasicToken, ERC20 {
139 
140   mapping (address => mapping (address => uint)) allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint the amout of tokens to be transfered
148    */
149   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
150     var _allowance = allowed[_from][msg.sender];
151 
152     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
153     // if (_value > _allowance) throw;
154 
155     balances[_to] = balances[_to].add(_value);
156     balances[_from] = balances[_from].sub(_value);
157     allowed[_from][msg.sender] = _allowance.sub(_value);
158     Transfer(_from, _to, _value);
159   }
160 
161   /**
162    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint _value) {
167 
168     // To change the approve amount you first have to reduce the addresses`
169     //  allowance to zero by calling `approve(_spender, 0)` if it is not
170     //  already 0 to mitigate the race condition described here:
171     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
172     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
173 
174     allowed[msg.sender][_spender] = _value;
175     Approval(msg.sender, _spender, _value);
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens than an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint specifing the amount of tokens still avaible for the spender.
183    */
184   function allowance(address _owner, address _spender) constant returns (uint remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188 }
189 
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197   address public owner;
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   function Ownable() {
205     owner = msg.sender;
206   }
207 
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     if (msg.sender != owner) {
214       throw;
215     }
216     _;
217   }
218 
219 
220   /**
221    * @dev Allows the current owner to transfer control of the contract to a newOwner.
222    * @param newOwner The address to transfer ownership to.
223    */
224   function transferOwnership(address newOwner) onlyOwner {
225     if (newOwner != address(0)) {
226       owner = newOwner;
227     }
228   }
229 
230 }
231 
232 
233 /**
234  * @title Mintable token
235  * @dev Simple ERC20 Token example, with mintable token creation
236  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
237  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
238  */
239 
240 contract MintableToken is StandardToken, Ownable {
241   event Mint(address indexed to, uint value);
242   event MintFinished();
243 
244   bool public mintingFinished = false;
245   uint public totalSupply = 0;
246 
247 
248   modifier canMint() {
249     if(mintingFinished) throw;
250     _;
251   }
252 
253   /**
254    * @dev Function to mint tokens
255    * @param _to The address that will recieve the minted tokens.
256    * @param _amount The amount of tokens to mint.
257    * @return A boolean that indicates if the operation was successful.
258    */
259   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
260     totalSupply = totalSupply.add(_amount);
261     balances[_to] = balances[_to].add(_amount);
262     Mint(_to, _amount);
263     return true;
264   }
265 
266   /**
267    * @dev Function to stop minting new tokens.
268    * @return True if the operation was successful.
269    */
270   function finishMinting() onlyOwner returns (bool) {
271     mintingFinished = true;
272     MintFinished();
273     return true;
274   }
275 }
276 
277 
278 /**
279  * @title Pausable
280  * @dev Base contract which allows children to implement an emergency stop mechanism.
281  */
282 contract Pausable is Ownable {
283   event Pause();
284   event Unpause();
285 
286   bool public paused = false;
287 
288 
289   /**
290    * @dev modifier to allow actions only when the contract IS paused
291    */
292   modifier whenNotPaused() {
293     if (paused) throw;
294     _;
295   }
296 
297   /**
298    * @dev modifier to allow actions only when the contract IS NOT paused
299    */
300   modifier whenPaused {
301     if (!paused) throw;
302     _;
303   }
304 
305   /**
306    * @dev called by the owner to pause, triggers stopped state
307    */
308   function pause() onlyOwner whenNotPaused returns (bool) {
309     paused = true;
310     Pause();
311     return true;
312   }
313 
314   /**
315    * @dev called by the owner to unpause, returns to normal state
316    */
317   function unpause() onlyOwner whenPaused returns (bool) {
318     paused = false;
319     Unpause();
320     return true;
321   }
322 }
323 
324 
325 /**
326  * Pausable token
327  *
328  * Simple ERC20 Token example, with pausable token creation
329  **/
330 
331 contract PausableToken is StandardToken, Pausable {
332 
333   function transfer(address _to, uint _value) whenNotPaused {
334     super.transfer(_to, _value);
335   }
336 
337   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
338     super.transferFrom(_from, _to, _value);
339   }
340 }
341 
342 
343 /**
344  * @title TokenTimelock
345  * @dev TokenTimelock is a token holder contract that will allow a
346  * beneficiary to extract the tokens after a time has passed
347  */
348 contract TokenTimelock {
349 
350   // ERC20 basic token contract being held
351   ERC20Basic token;
352 
353   // beneficiary of tokens after they are released
354   address beneficiary;
355 
356   // timestamp where token release is enabled
357   uint releaseTime;
358 
359   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint _releaseTime) {
360     require(_releaseTime > now);
361     token = _token;
362     beneficiary = _beneficiary;
363     releaseTime = _releaseTime;
364   }
365 
366   /**
367    * @dev beneficiary claims tokens held by time lock
368    */
369   function claim() {
370     require(msg.sender == beneficiary);
371     require(now >= releaseTime);
372 
373     uint amount = token.balanceOf(this);
374     require(amount > 0);
375 
376     token.transfer(beneficiary, amount);
377   }
378 }
379 
380 
381 
382 /**
383  * @title Burnable Token
384  * @dev Token that can be irreversibly burned (destroyed).
385  * Based on code by OpenZeppelin: https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
386  */
387 contract BurnableToken is BasicToken {
388 
389   event Burn(address indexed burner, uint256 value);
390 
391   /**
392    * @dev Burns a specific amount of tokens.
393    * @param _value The amount of token to be burned.
394    */
395   function burn(uint256 _value) public {
396     _burn(msg.sender, _value);
397   }
398 
399   function _burn(address _who, uint256 _value) internal {
400     require(_value <= balances[_who]);
401     // no need to require value <= totalSupply, since that would imply the
402     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
403 
404     balances[_who] = balances[_who].sub(_value);
405     totalSupply = totalSupply.sub(_value);
406     emit Burn(_who, _value);
407     emit Transfer(_who, address(0), _value);
408   }
409 }
410 
411 /**
412  * @title OGX
413  * @dev OGX contract
414  */
415 contract OGX is PausableToken, MintableToken, BurnableToken {
416   using SafeMath for uint256;
417 
418   string public name = "OGX";
419   string public symbol = "OGX";
420   uint public decimals = 18;
421 
422   /// Maximum tokens to be allocated.
423   uint256 public constant HARD_CAP = 224115116  * 10**uint256(decimals);  
424   /* Initial supply is  224,115,116 OGX */
425 
426   /**
427    * @dev mint timelocked tokens
428    */
429   function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime)
430     onlyOwner canMint returns (TokenTimelock) {
431 
432     TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
433     mint(timelock, _amount);
434 
435     return timelock;
436   }
437 
438 }