1 pragma solidity ^0.4.23;
2 
3 /**xxp
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 
45   function allowance(address owner, address spender) public constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   constructor() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner public {
82     require(newOwner != address(0));
83     emit OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
99 contract StandardToken is ERC20Basic {
100 
101   using SafeMath for uint256;
102 
103   mapping (address => mapping (address => uint256)) internal allowed;
104   // store tokens
105   mapping(address => uint256) balances;
106   // uint256 public totalSupply;
107 
108   /**
109   * @dev transfer token for a specified address
110   * @param _to The address to transfer to.
111   * @param _value The amount to be transferred.
112   */
113   function transfer(address _to, uint256 _value) public returns (bool) {
114     require(_to != address(0));
115     require(_value <= balances[msg.sender]);
116 
117     // SafeMath.sub will throw if there is not enough balance.
118     balances[msg.sender] = balances[msg.sender].sub(_value);
119     balances[_to] = balances[_to].add(_value);
120     emit Transfer(msg.sender, _to, _value);
121     return true;
122   }
123   
124    /**
125     *batch transfer token for a list of specified addresses
126     * @param _toList The list of addresses to transfer to.
127     * @param _tokensList The list of amount to be transferred.
128     */
129   function batchTransfer(address[] _toList, uint256[] _tokensList) public  returns (bool) {
130       require(_toList.length <= 100);
131       require(_toList.length == _tokensList.length);
132       
133       uint256 sum = 0;
134       for (uint32 index = 0; index < _tokensList.length; index++) {
135           sum = sum.add(_tokensList[index]);
136       }
137 
138       // if the sender doenst have enough balance then stop
139       require (balances[msg.sender] >= sum);
140         
141       for (uint32 i = 0; i < _toList.length; i++) {
142           transfer(_toList[i],_tokensList[i]);
143       }
144       return true;
145   }
146 
147   /**
148   * @dev Gets the balance of the specified address.
149   * @param _owner The address to query the the balance of.
150   * @return An uint256 representing the amount owned by the passed address.
151   */
152   function balanceOf(address _owner) public constant returns (uint256 balance) {
153     return balances[_owner];
154   }
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     emit Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
198     return allowed[_owner][_spender];
199   }
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is StandardToken {
207 
208     event Burn(address indexed burner, uint256 value);
209 
210     /**
211      * @dev Burns a specific amount of tokens.
212      * @param _value The amount of token to be burned.
213      */
214     function burn(uint256 _value) public {
215         require(_value > 0);
216         require(_value <= balances[msg.sender]);
217         // no need to require value <= totalSupply, since that would imply the
218         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
219 
220         address burner = msg.sender;
221         balances[burner] = balances[burner].sub(_value);
222         totalSupply = totalSupply.sub(_value);
223         emit Burn(burner, _value);
224     }
225 }
226 
227 /**
228  * @title Mintable token
229  * @dev Simple ERC20 Token example, with mintable token creation
230  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
231  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
232  */
233 
234 contract MintableToken is StandardToken, Ownable {
235   event Mint(address indexed to, uint256 amount);
236   event MintFinished();
237 
238   bool public mintingFinished = false;
239 
240 
241   modifier canMint() {
242     require(!mintingFinished);
243     _;
244   }
245 
246   /**
247    * @dev Function to mint tokens
248    * @param _to The address that will receive the minted tokens.
249    * @param _amount The amount of tokens to mint.
250    * @return A boolean that indicates if the operation was successful.
251    */
252   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     emit Mint(_to, _amount);
256     emit Transfer(0x0, _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264   function finishMinting() onlyOwner public returns (bool) {
265     mintingFinished = true;
266     emit MintFinished();
267     return true;
268   }
269 }
270 
271 /**
272  * @title Pausable
273  * @dev Base contract which allows children to implement an emergency stop mechanism.
274  */
275 contract Pausable is Ownable {
276   event Pause();
277   event Unpause();
278 
279   bool public paused = false;
280 
281 
282   /**
283    * @dev Modifier to make a function callable only when the contract is not paused.
284    */
285   modifier whenNotPaused() {
286     require(!paused);
287     _;
288   }
289 
290   /**
291    * @dev Modifier to make a function callable only when the contract is paused.
292    */
293   modifier whenPaused() {
294     require(paused);
295     _;
296   }
297 
298   /**
299    * @dev called by the owner to pause, triggers stopped state
300    */
301   function pause() onlyOwner whenNotPaused public {
302     paused = true;
303     emit Pause();
304   }
305 
306   /**
307    * @dev called by the owner to unpause, returns to normal state
308    */
309   function unpause() onlyOwner whenPaused public {
310     paused = false;
311     emit Unpause();
312   }
313 }
314 
315 
316 /**
317  * @title TokenVesting
318  * @dev A token holder contract that can release its token balance gradually like a
319  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
320  * owner.
321  */
322 contract TokenVesting is StandardToken,Ownable {
323   using SafeMath for uint256;
324 
325   event AddToVestMap(address vestcount);
326   event DelFromVestMap(address vestcount);
327 
328   event Released(address vestcount,uint256 amount);
329   event Revoked(address vestcount);
330 
331   struct tokenToVest{
332       bool  exist;
333       uint256  start;
334       uint256  cliff;
335       uint256  duration;
336       uint256  torelease;
337       uint256  released;
338   }
339 
340   //key is the account to vest
341   mapping (address=>tokenToVest) vestToMap;
342 
343 
344   /**
345    * @dev Add one account to the vest Map
346    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
347    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
348    * @param _start the time (as Unix time) at which point vesting starts 
349    * @param _duration duration in seconds of the period in which the tokens will vest
350    * @param _torelease  delc count to release
351    */
352   function addToVestMap(
353     address _beneficiary,
354     uint256 _start,
355     uint256 _cliff,
356     uint256 _duration,
357     uint256 _torelease
358   ) public onlyOwner{
359     require(_beneficiary != address(0));
360     require(_cliff <= _duration);
361     require(_start > block.timestamp);
362     require(!vestToMap[_beneficiary].exist);
363 
364     vestToMap[_beneficiary] = tokenToVest(true,_start,_start.add(_cliff),_duration,
365         _torelease,uint256(0));
366 
367     emit AddToVestMap(_beneficiary);
368   }
369 
370 
371   /**
372    * @dev del One account to the vest Map
373    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
374    */
375   function delFromVestMap(
376     address _beneficiary
377   ) public onlyOwner{
378     require(_beneficiary != address(0));
379     require(vestToMap[_beneficiary].exist);
380 
381     delete vestToMap[_beneficiary];
382 
383     emit DelFromVestMap(_beneficiary);
384   }
385 
386 
387 
388   /**
389    * @notice Transfers vested tokens to beneficiary.
390    */
391   function release(address _beneficiary) public {
392 
393     tokenToVest storage value = vestToMap[_beneficiary];
394     require(value.exist);
395     uint256 unreleased = releasableAmount(_beneficiary);
396     require(unreleased > 0);
397     require(unreleased + value.released <= value.torelease);
398 
399 
400     vestToMap[_beneficiary].released = vestToMap[_beneficiary].released.add(unreleased);
401 
402     transfer(_beneficiary, unreleased);
403 
404     emit Released(_beneficiary,unreleased);
405   }
406 
407   /**
408    * @dev Calculates the amount that has already vested but hasn't been released yet.
409    */
410   function releasableAmount(address _beneficiary) public view returns (uint256) {
411     return vestedAmount(_beneficiary).sub(vestToMap[_beneficiary].released);
412   }
413 
414   /**
415    * @dev Calculates the amount that has already vested.
416    */
417   function vestedAmount(address _beneficiary) public view returns (uint256) {
418 
419     tokenToVest storage value = vestToMap[_beneficiary];
420     //uint256 currentBalance = balanceOf(_beneficiary);
421     uint256 totalBalance = value.torelease;
422 
423     if (block.timestamp < value.cliff) {
424       return 0;
425     } else if (block.timestamp >= value.start.add(value.duration)) {
426       return totalBalance;
427     } else {
428       return totalBalance.mul(block.timestamp.sub(value.start)).div(value.duration);
429     }
430   }
431 }
432 
433 /**
434  * @title Pausable token
435  *
436  * @dev StandardToken modified with pausable transfers.
437  **/
438 
439 contract PausableToken is TokenVesting, Pausable {
440 
441   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
442     return super.transfer(_to, _value);
443   }
444   
445   function batchTransfer(address[] _toList, uint256[] _tokensList) public whenNotPaused returns (bool) {
446       return super.batchTransfer(_toList, _tokensList);
447   }
448 
449   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
450     return super.transferFrom(_from, _to, _value);
451   }
452 
453   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
454     return super.approve(_spender, _value);
455   }
456 
457   function release(address _beneficiary) public whenNotPaused{
458     super.release(_beneficiary);
459   }
460 }
461 
462 /*
463  * @title DELCToken
464  */
465 contract DELCToken is BurnableToken, MintableToken, PausableToken {
466   // Public variables of the token
467   string public name;
468   string public symbol;
469   // decimals is the strongly suggested default, avoid changing it
470   uint8 public decimals;
471 
472   constructor() public {
473     name = "DELC Relation Person Token";
474     symbol = "DELC";
475     decimals = 18;
476     totalSupply = 10000000000 * 10 ** uint256(decimals);
477 
478     // Allocate initial balance to the owner
479     balances[msg.sender] = totalSupply;
480     
481     emit Transfer(address(0), msg.sender, totalSupply);
482     
483   }
484 
485   // transfer balance to owner
486   //function withdrawEther() onlyOwner public {
487   //    owner.transfer(this.balance);
488   //}
489 
490   // can accept ether
491   //function() payable public {
492   //}
493 }