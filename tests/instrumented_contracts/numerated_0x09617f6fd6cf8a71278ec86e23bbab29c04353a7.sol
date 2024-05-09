1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35 
36   /**
37    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
38    * account.
39    */
40   function Ownable() {
41     owner = msg.sender;
42   }
43 
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53 
54   /**
55    * @dev Allows the current owner to transfer control of the contract to a newOwner.
56    * @param newOwner The address to transfer ownership to.
57    */
58   function transferOwnership(address newOwner) onlyOwner public {
59     require(newOwner != address(0));
60     OwnershipTransferred(owner, newOwner);
61     owner = newOwner;
62   }
63 
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     Unpause();
103   }
104 }
105 
106 contract ERC20Basic {
107   uint256 public totalSupply;
108   function balanceOf(address who) public constant returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125 
126     // SafeMath.sub will throw if there is not enough balance.
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   /**
134   * @dev Gets the balance of the specified address.
135   * @param _owner The address to query the the balance of.
136   * @return An uint256 representing the amount owned by the passed address.
137   */
138   function balanceOf(address _owner) public constant returns (uint256 balance) {
139     return balances[_owner];
140   }
141 
142 }
143 
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender) public constant returns (uint256);
146   function transferFrom(address from, address to, uint256 value) public returns (bool);
147   function approve(address spender, uint256 value) public returns (bool);
148   event Approval(address indexed owner, address indexed spender, uint256 value);
149 }
150 
151 contract StandardToken is ERC20, BasicToken {
152 
153   mapping (address => mapping (address => uint256)) allowed;
154 
155 
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164 
165     uint256 _allowance = allowed[_from][msg.sender];
166 
167     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
168     // require (_value <= _allowance);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = _allowance.sub(_value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * approve should be called when allowed[_spender] == 0. To increment
205    * allowed value is better to use this function to avoid 2 calls (and wait until
206    * the first transaction is mined)
207    * From MonolithDAO Token.sol
208    */
209   function increaseApproval (address _spender, uint _addedValue)
210     returns (bool success) {
211     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   function decreaseApproval (address _spender, uint _subtractedValue)
217     returns (bool success) {
218     uint oldValue = allowed[msg.sender][_spender];
219     if (_subtractedValue > oldValue) {
220       allowed[msg.sender][_spender] = 0;
221     } else {
222       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
223     }
224     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
225     return true;
226   }
227 
228 }
229 
230 contract PausableToken is StandardToken, Pausable {
231 
232   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
233     return super.transfer(_to, _value);
234   }
235 
236   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
237     return super.transferFrom(_from, _to, _value);
238   }
239 
240   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
241     return super.approve(_spender, _value);
242   }
243 
244   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
245     return super.increaseApproval(_spender, _addedValue);
246   }
247 
248   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
249     return super.decreaseApproval(_spender, _subtractedValue);
250   }
251 }
252 
253 contract ULToken is PausableToken {
254 
255     string public name;                             // fancy name: eg Simon Bucks
256 
257     uint8 public decimals;                          // How many decimals to show.
258 
259     string public symbol;                           // An identifier: eg SBX
260 
261 
262 
263     bool public ownerBurnOccurred;                   // Changes when ownerBurn is called
264 
265     uint256 public licenseCostNumerator;            // Numerator of the %(totalSupply) cost of a license
266 
267     uint256 public licenseCostDenominator;          // Denominator of the %(totalSupply) cost of a license
268 
269     uint256 public totalLicensePurchases;           // Total number of licenses purchased
270 
271     mapping (address => bool) public ownsLicense;   // Tracks addresses that have purchased a license
272 
273 
274 
275     /**
276 
277     * Modifier to make a function callable only after ownerBurn has been called
278 
279     */
280 
281     modifier afterOwnerBurn() {
282 
283         require(ownerBurnOccurred == true);
284 
285         _;
286 
287     }
288 
289 
290 
291     // This notifies clients when ownerBurn is called
292 
293     event LogOwnerBurn(address indexed owner, uint256 value);
294 
295     // This notifies clients when a license is purchased
296 
297     event LogPurchaseLicense(address indexed purchaser, uint256 indexed license_num, uint256 value, bytes32 indexed data);
298 
299     // This notifies clients when the %(totalSupply) cost of a license has changed
300 
301     event LogChangedLicenseCost(uint256 numerator, uint256 denominator);
302 
303 
304 
305     // Override Ownable.sol fn
306 
307     function transferOwnership(address newOwner) onlyOwner public {
308 
309         revert();
310 
311     }
312 
313 
314 
315     // Constructor
316 
317     function ULToken(
318 
319         uint256 _initialAmount,
320 
321         string _tokenName,
322 
323         uint8 _decimalUnits,
324 
325         string _tokenSymbol
326 
327     ) public {
328 
329         balances[msg.sender] = _initialAmount;      // Give the creator all initial tokens
330 
331         totalSupply = _initialAmount;               // Update total supply
332 
333         name = _tokenName;                          // Set the name for display purposes
334 
335         decimals = _decimalUnits;                   // Amount of decimals for display purposes
336 
337         symbol = _tokenSymbol;                      // Set the symbol for display purposes
338 
339 
340 
341         owner = msg.sender;                         // Save the contract creators address as the owner
342 
343 
344 
345         ownerBurnOccurred = false;                   // Ensure ownerBurn has not been called
346 
347 
348 
349         licenseCostNumerator = 0;                   // Initialize license cost to 0
350 
351         licenseCostDenominator = 1;
352 
353         totalLicensePurchases = 0;
354 
355     }
356 
357 
358 
359     /**
360 
361      * Burns all remaining tokens in the owners account and sets license cost
362 
363      * Can only be called once by contract owner
364 
365      *
366 
367      * @param _numerator Numerator of the %(totalSupply) cost of a license
368 
369      * @param _denominator Denominator of the %(totalSupply) cost of a license
370 
371      */
372 
373     function ownerBurn(
374 
375         uint256 _numerator,
376 
377         uint256 _denominator
378 
379     ) public
380 
381         whenNotPaused
382 
383         onlyOwner
384 
385     returns (bool) {
386 
387         // Ensure first time
388 
389         require(ownerBurnOccurred == false);
390 
391         // Set license cost
392 
393         changeLicenseCost(_numerator, _denominator);
394 
395         // Burn remaining owner tokens
396 
397         uint256 value = balances[msg.sender];
398 
399         balances[msg.sender] -= value;
400 
401         totalSupply -= value;
402 
403         ownerBurnOccurred = true;
404 
405         LogOwnerBurn(msg.sender, value);
406 
407         return true;
408 
409     }
410 
411 
412 
413     /**
414 
415      * Change the %(totalSupply) cost of a license
416 
417      * Can only be called by contract owner
418 
419      *
420 
421      * Sets licenseCostNumerator to _numerator
422 
423      * Sets licenseCostDenominator to _denominator
424 
425      *
426 
427      * @param _numerator Numerator of the %(totalSupply) cost of a license
428 
429      * @param _denominator Denominator of the %(totalSupply) cost of a license
430 
431      */
432 
433     function changeLicenseCost(
434 
435         uint256 _numerator,
436 
437         uint256 _denominator
438 
439     ) public
440 
441         whenNotPaused
442 
443         onlyOwner
444 
445     returns (bool) {
446 
447         require(_numerator >= 0);
448 
449         require(_denominator > 0);
450 
451         require(_numerator < _denominator);
452 
453         licenseCostNumerator = _numerator;
454 
455         licenseCostDenominator = _denominator;
456 
457         LogChangedLicenseCost(licenseCostNumerator, licenseCostDenominator);
458 
459         return true;
460 
461     }
462 
463 
464 
465     /**
466 
467      * Purchase a license
468 
469      * Can only be called once per account
470 
471      *
472 
473      * Burns a percentage of tokens from the callers account
474 
475      * Sets the callers address to true in the ownsLicense mapping
476 
477      *
478 
479      */
480 
481     function purchaseLicense(bytes32 _data) public
482 
483         whenNotPaused
484 
485         afterOwnerBurn
486 
487     returns (bool) {
488 
489         require(ownsLicense[msg.sender] == false);
490 
491         // Calculate cost of license
492 
493         uint256 costNumerator = totalSupply * licenseCostNumerator;
494 
495         uint256 cost = costNumerator / licenseCostDenominator;
496 
497         require(balances[msg.sender] >= cost);
498 
499         // Burn the tokens
500 
501         balances[msg.sender] -= cost;
502 
503         totalSupply -= cost;
504 
505         // Add msg.sender to license owners
506 
507         ownsLicense[msg.sender] = true;
508 
509         totalLicensePurchases += 1;
510 
511         LogPurchaseLicense(msg.sender, totalLicensePurchases, cost, _data);
512 
513         return true;
514 
515     }
516 
517 }