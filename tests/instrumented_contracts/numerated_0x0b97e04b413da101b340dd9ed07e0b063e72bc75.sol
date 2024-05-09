1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (a == 0) {
18       return 0;
19     }
20 
21     c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return a / b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
48     c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipRenounced(address indexed previousOwner);
65   event OwnershipTransferred(
66     address indexed previousOwner,
67     address indexed newOwner
68   );
69 
70 
71   /**
72    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
73    * account.
74    */
75   constructor() public {
76     owner = msg.sender;
77   }
78 
79   /**
80    * @dev Throws if called by any account other than the owner.
81    */
82   modifier onlyOwner() {
83     require(msg.sender == owner);
84     _;
85   }
86 
87   /**
88    * @dev Allows the current owner to relinquish control of the contract.
89    */
90   function renounceOwnership() public onlyOwner {
91     emit OwnershipRenounced(owner);
92     owner = address(0);
93   }
94 
95   /**
96    * @dev Allows the current owner to transfer control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function transferOwnership(address _newOwner) public onlyOwner {
100     _transferOwnership(_newOwner);
101   }
102 
103   /**
104    * @dev Transfers control of the contract to a newOwner.
105    * @param _newOwner The address to transfer ownership to.
106    */
107   function _transferOwnership(address _newOwner) internal {
108     require(_newOwner != address(0));
109     emit OwnershipTransferred(owner, _newOwner);
110     owner = _newOwner;
111   }
112 }
113 
114 
115 /**
116  * @title ERC20Basic
117  * @dev Simpler version of ERC20 interface
118  * @dev see https://github.com/ethereum/EIPs/issues/179
119  */
120 contract ERC20Basic {
121   function totalSupply() public view returns (uint256);
122   function balanceOf(address who) public view returns (uint256);
123   function transfer(address to, uint256 value) public returns (bool);
124   event Transfer(address indexed from, address indexed to, uint256 value);
125 }
126 
127 
128 /**
129  * @title ERC20 interface
130  * @dev see https://github.com/ethereum/EIPs/issues/20
131  */
132 contract ERC20 is ERC20Basic {
133   function allowance(address owner, address spender)
134     public view returns (uint256);
135 
136   function transferFrom(address from, address to, uint256 value)
137     public returns (bool);
138 
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(
141     address indexed owner,
142     address indexed spender,
143     uint256 value
144   );
145 }
146 
147 
148 /**
149  * @title SafeERC20
150  * @dev Wrappers around ERC20 operations that throw on failure.
151  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
152  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
153  */
154 library SafeERC20 {
155   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
156     require(token.transfer(to, value));
157   }
158 
159   function safeTransferFrom(
160     ERC20 token,
161     address from,
162     address to,
163     uint256 value
164   )
165     internal
166   {
167     require(token.transferFrom(from, to, value));
168   }
169 
170   function safeApprove(ERC20 token, address spender, uint256 value) internal {
171     require(token.approve(spender, value));
172   }
173 }
174 
175 
176 /**
177  * @title Locker
178  * @notice Locker holds tokens and releases them at a certain time.
179  */
180 contract Locker is Ownable {
181   using SafeMath for uint;
182   using SafeERC20 for ERC20Basic;
183 
184   /**
185    * It is init state only when adding release info is possible.
186    * beneficiary only can release tokens when Locker is active.
187    * After all tokens are released, locker is drawn.
188    */
189   enum State { Init, Ready, Active, Drawn }
190 
191   struct Beneficiary {
192     uint ratio;             // ratio based on Locker's initial balance.
193     uint withdrawAmount;    // accumulated tokens beneficiary released
194     bool releaseAllTokens;
195   }
196 
197   /**
198    * @notice Release has info to release tokens.
199    * If lock type is straight, only two release infos is required.
200    *
201    *     |
202    * 100 |                _______________
203    *     |              _/
204    *  50 |            _/
205    *     |         . |
206    *     |       .   |
207    *     |     .     |
208    *     +===+=======+----*----------> time
209    *     Locker  First    Last
210    *  Activated  Release  Release
211    *
212    *
213    * If lock type is variable, the release graph will be
214    *
215    *     |
216    * 100 |                                 _________
217    *     |                                |
218    *  70 |                      __________|
219    *     |                     |
220    *  30 |            _________|
221    *     |           |
222    *     +===+=======+---------+----------*------> time
223    *     Locker   First        Second     Last
224    *  Activated   Release      Release    Release
225    *
226    *
227    *
228    * For the first straight release graph, parameters would be
229    *   coeff: 100
230    *   releaseTimes: [
231    *     first release time,
232    *     second release time
233    *   ]
234    *   releaseRatios: [
235    *     50,
236    *     100,
237    *   ]
238    *
239    * For the second variable release graph, parameters would be
240    *   coeff: 100
241    *   releaseTimes: [
242    *     first release time,
243    *     second release time,
244    *     last release time
245    *   ]
246    *   releaseRatios: [
247    *     30,
248    *     70,
249    *     100,
250    *   ]
251    *
252    */
253   struct Release {
254     bool isStraight;        // lock type : straight or variable
255     uint[] releaseTimes;    //
256     uint[] releaseRatios;   //
257   }
258 
259   uint public activeTime;
260 
261   // ERC20 basic token contract being held
262   ERC20Basic public token;
263 
264   uint public coeff;
265   uint public initialBalance;
266   uint public withdrawAmount; // total amount of tokens released
267 
268   mapping (address => Beneficiary) public beneficiaries;
269   mapping (address => Release) public releases;  // beneficiary's lock
270   mapping (address => bool) public locked; // whether beneficiary's lock is instantiated
271 
272   uint public numBeneficiaries;
273   uint public numLocks;
274 
275   State public state;
276 
277   modifier onlyState(State v) {
278     require(state == v);
279     _;
280   }
281 
282   modifier onlyBeneficiary(address _addr) {
283     require(beneficiaries[_addr].ratio > 0);
284     _;
285   }
286 
287   event StateChanged(State _state);
288   event Locked(address indexed _beneficiary, bool _isStraight);
289   event Released(address indexed _beneficiary, uint256 _amount);
290 
291   function Locker(address _token, uint _coeff, address[] _beneficiaries, uint[] _ratios) public {
292     require(_token != address(0));
293     require(_beneficiaries.length == _ratios.length);
294 
295     token = ERC20Basic(_token);
296     coeff = _coeff;
297     numBeneficiaries = _beneficiaries.length;
298 
299     uint accRatio;
300 
301     for(uint i = 0; i < numBeneficiaries; i++) {
302       require(_ratios[i] > 0);
303       beneficiaries[_beneficiaries[i]].ratio = _ratios[i];
304 
305       accRatio = accRatio.add(_ratios[i]);
306     }
307 
308     require(coeff == accRatio);
309   }
310 
311   /**
312    * @notice beneficiary can release their tokens after activated
313    */
314   function activate() external onlyOwner onlyState(State.Ready) {
315     require(numLocks == numBeneficiaries); // double check : assert all releases are recorded
316 
317     initialBalance = token.balanceOf(this);
318     require(initialBalance > 0);
319 
320     activeTime = now; // solium-disable-line security/no-block-members
321 
322     // set locker as active state
323     state = State.Active;
324     emit StateChanged(state);
325   }
326 
327   function getReleaseType(address _beneficiary)
328     public
329     view
330     onlyBeneficiary(_beneficiary)
331     returns (bool)
332   {
333     return releases[_beneficiary].isStraight;
334   }
335 
336   function getTotalLockedAmounts(address _beneficiary)
337     public
338     view
339     onlyBeneficiary(_beneficiary)
340     returns (uint)
341   {
342     return getPartialAmount(beneficiaries[_beneficiary].ratio, coeff, initialBalance);
343   }
344 
345   function getReleaseTimes(address _beneficiary)
346     public
347     view
348     onlyBeneficiary(_beneficiary)
349     returns (uint[])
350   {
351     return releases[_beneficiary].releaseTimes;
352   }
353 
354   function getReleaseRatios(address _beneficiary)
355     public
356     view
357     onlyBeneficiary(_beneficiary)
358     returns (uint[])
359   {
360     return releases[_beneficiary].releaseRatios;
361   }
362 
363   /**
364    * @notice add new release record for beneficiary
365    */
366   function lock(address _beneficiary, bool _isStraight, uint[] _releaseTimes, uint[] _releaseRatios)
367     external
368     onlyOwner
369     onlyState(State.Init)
370     onlyBeneficiary(_beneficiary)
371   {
372     require(!locked[_beneficiary]);
373     require(_releaseRatios.length != 0);
374     require(_releaseRatios.length == _releaseTimes.length);
375 
376     uint i;
377     uint len = _releaseRatios.length;
378 
379     // finally should release all tokens
380     require(_releaseRatios[len - 1] == coeff);
381 
382     // check two array are ascending sorted
383     for(i = 0; i < len - 1; i++) {
384       require(_releaseTimes[i] < _releaseTimes[i + 1]);
385       require(_releaseRatios[i] < _releaseRatios[i + 1]);
386     }
387 
388     // 2 release times for straight locking type
389     if (_isStraight) {
390       require(len == 2);
391     }
392 
393     numLocks = numLocks.add(1);
394 
395     // create Release for the beneficiary
396     releases[_beneficiary].isStraight = _isStraight;
397 
398     // copy array of uint
399     releases[_beneficiary].releaseTimes = _releaseTimes;
400     releases[_beneficiary].releaseRatios = _releaseRatios;
401 
402     // lock beneficiary
403     locked[_beneficiary] = true;
404     emit Locked(_beneficiary, _isStraight);
405 
406     //  if all beneficiaries locked, change Locker state to change
407     if (numLocks == numBeneficiaries) {
408       state = State.Ready;
409       emit StateChanged(state);
410     }
411   }
412 
413   /**
414    * @notice transfer releasable tokens for beneficiary wrt the release graph
415    */
416   function release() external onlyState(State.Active) onlyBeneficiary(msg.sender) {
417     require(!beneficiaries[msg.sender].releaseAllTokens);
418 
419     uint releasableAmount = getReleasableAmount(msg.sender);
420     beneficiaries[msg.sender].withdrawAmount = beneficiaries[msg.sender].withdrawAmount.add(releasableAmount);
421 
422     beneficiaries[msg.sender].releaseAllTokens = beneficiaries[msg.sender].withdrawAmount == getPartialAmount(
423       beneficiaries[msg.sender].ratio,
424       coeff,
425       initialBalance);
426 
427     withdrawAmount = withdrawAmount.add(releasableAmount);
428 
429     if (withdrawAmount == initialBalance) {
430       state = State.Drawn;
431       emit StateChanged(state);
432     }
433 
434     token.transfer(msg.sender, releasableAmount);
435     emit Released(msg.sender, releasableAmount);
436   }
437 
438   function getReleasableAmount(address _beneficiary) internal view returns (uint) {
439     if (releases[_beneficiary].isStraight) {
440       return getStraightReleasableAmount(_beneficiary);
441     } else {
442       return getVariableReleasableAmount(_beneficiary);
443     }
444   }
445 
446   /**
447    * @notice return releaseable amount for beneficiary in case of straight type of release
448    */
449   function getStraightReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
450     Beneficiary memory _b = beneficiaries[_beneficiary];
451     Release memory _r = releases[_beneficiary];
452 
453     // total amount of tokens beneficiary can release
454     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
455 
456     uint firstTime = _r.releaseTimes[0];
457     uint lastTime = _r.releaseTimes[1];
458 
459     // solium-disable security/no-block-members
460     require(now >= firstTime); // pass if can release
461     // solium-enable security/no-block-members
462 
463     if(now >= lastTime) { // inclusive to reduce calculation
464       releasableAmount = totalReleasableAmount;
465     } else {
466       // releasable amount at first time
467       uint firstAmount = getPartialAmount(
468         _r.releaseRatios[0],
469         coeff,
470         totalReleasableAmount);
471 
472       // partial amount without first amount
473       releasableAmount = getPartialAmount(
474         now.sub(firstTime),
475         lastTime.sub(firstTime),
476         totalReleasableAmount.sub(firstAmount));
477       releasableAmount = releasableAmount.add(firstAmount);
478     }
479 
480     // subtract already withdrawn amounts
481     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
482   }
483 
484   /**
485    * @notice return releaseable amount for beneficiary in case of variable type of release
486    */
487   function getVariableReleasableAmount(address _beneficiary) internal view returns (uint releasableAmount) {
488     Beneficiary memory _b = beneficiaries[_beneficiary];
489     Release memory _r = releases[_beneficiary];
490 
491     // total amount of tokens beneficiary will receive
492     uint totalReleasableAmount = getTotalLockedAmounts(_beneficiary);
493 
494     uint releaseRatio;
495 
496     // reverse order for short curcit
497     for(uint i = _r.releaseTimes.length - 1; i >= 0; i--) {
498       if (now >= _r.releaseTimes[i]) {
499         releaseRatio = _r.releaseRatios[i];
500         break;
501       }
502     }
503 
504     require(releaseRatio > 0);
505 
506     releasableAmount = getPartialAmount(
507       releaseRatio,
508       coeff,
509       totalReleasableAmount);
510     releasableAmount = releasableAmount.sub(_b.withdrawAmount);
511   }
512 
513   /// https://github.com/0xProject/0x.js/blob/05aae368132a81ddb9fd6a04ac5b0ff1cbb24691/packages/contracts/src/current/protocol/Exchange/Exchange.sol#L497
514   /// @notice Calculates partial value given a numerator and denominator.
515   /// @param numerator Numerator.
516   /// @param denominator Denominator.
517   /// @param target Value to calculate partial of.
518   /// @return Partial value of target.
519   function getPartialAmount(uint numerator, uint denominator, uint target) public pure returns (uint) {
520     return numerator.mul(target).div(denominator);
521   }
522 }