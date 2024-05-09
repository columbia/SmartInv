1 pragma solidity ^0.4.25;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15     external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20     external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23     external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
39 
40 /**
41  * @title SafeMath
42  * @dev Math operations with safety checks that revert on error
43  */
44 library SafeMath {
45 
46   /**
47   * @dev Multiplies two numbers, reverts on overflow.
48   */
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51     // benefit is lost if 'b' is also tested.
52     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
53     if (a == 0) {
54       return 0;
55     }
56 
57     uint256 c = a * b;
58     require(c / a == b);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     require(b > 0); // Solidity only automatically asserts when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 
71     return c;
72   }
73 
74   /**
75   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
76   */
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     require(b <= a);
79     uint256 c = a - b;
80 
81     return c;
82   }
83 
84   /**
85   * @dev Adds two numbers, reverts on overflow.
86   */
87   function add(uint256 a, uint256 b) internal pure returns (uint256) {
88     uint256 c = a + b;
89     require(c >= a);
90 
91     return c;
92   }
93 
94   /**
95   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
96   * reverts when dividing by zero.
97   */
98   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
99     require(b != 0);
100     return a % b;
101   }
102 }
103 
104 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
105 
106 /**
107  * @title Standard ERC20 token
108  *
109  * @dev Implementation of the basic standard token.
110  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
112  */
113 contract ERC20 is IERC20 {
114   using SafeMath for uint256;
115 
116   mapping (address => uint256) private _balances;
117 
118   mapping (address => mapping (address => uint256)) private _allowed;
119 
120   uint256 private _totalSupply;
121 
122   /**
123   * @dev Total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return _totalSupply;
127   }
128 
129   /**
130   * @dev Gets the balance of the specified address.
131   * @param owner The address to query the balance of.
132   * @return An uint256 representing the amount owned by the passed address.
133   */
134   function balanceOf(address owner) public view returns (uint256) {
135     return _balances[owner];
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param owner address The address which owns the funds.
141    * @param spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(
145     address owner,
146     address spender
147    )
148     public
149     view
150     returns (uint256)
151   {
152     return _allowed[owner][spender];
153   }
154 
155   /**
156   * @dev Transfer token for a specified address
157   * @param to The address to transfer to.
158   * @param value The amount to be transferred.
159   */
160   function transfer(address to, uint256 value) public returns (bool) {
161     _transfer(msg.sender, to, value);
162     return true;
163   }
164 
165   /**
166    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
167    * Beware that changing an allowance with this method brings the risk that someone may use both the old
168    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
169    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
170    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171    * @param spender The address which will spend the funds.
172    * @param value The amount of tokens to be spent.
173    */
174   function approve(address spender, uint256 value) public returns (bool) {
175     require(spender != address(0));
176 
177     _allowed[msg.sender][spender] = value;
178     emit Approval(msg.sender, spender, value);
179     return true;
180   }
181 
182   /**
183    * @dev Transfer tokens from one address to another
184    * @param from address The address which you want to send tokens from
185    * @param to address The address which you want to transfer to
186    * @param value uint256 the amount of tokens to be transferred
187    */
188   function transferFrom(
189     address from,
190     address to,
191     uint256 value
192   )
193     public
194     returns (bool)
195   {
196     require(value <= _allowed[from][msg.sender]);
197 
198     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
199     _transfer(from, to, value);
200     return true;
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    * approve should be called when allowed_[_spender] == 0. To increment
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param spender The address which will spend the funds.
210    * @param addedValue The amount of tokens to increase the allowance by.
211    */
212   function increaseAllowance(
213     address spender,
214     uint256 addedValue
215   )
216     public
217     returns (bool)
218   {
219     require(spender != address(0));
220 
221     _allowed[msg.sender][spender] = (
222       _allowed[msg.sender][spender].add(addedValue));
223     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240     public
241     returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246       _allowed[msg.sender][spender].sub(subtractedValue));
247     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(value <= _balances[from]);
259     require(to != address(0));
260 
261     _balances[from] = _balances[from].sub(value);
262     _balances[to] = _balances[to].add(value);
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != 0);
275     _totalSupply = _totalSupply.add(value);
276     _balances[account] = _balances[account].add(value);
277     emit Transfer(address(0), account, value);
278   }
279 
280   /**
281    * @dev Internal function that burns an amount of the token of a given
282    * account.
283    * @param account The account whose tokens will be burnt.
284    * @param value The amount that will be burnt.
285    */
286   function _burn(address account, uint256 value) internal {
287     require(account != 0);
288     require(value <= _balances[account]);
289 
290     _totalSupply = _totalSupply.sub(value);
291     _balances[account] = _balances[account].sub(value);
292     emit Transfer(account, address(0), value);
293   }
294 
295   /**
296    * @dev Internal function that burns an amount of the token of a given
297    * account, deducting from the sender's allowance for said account. Uses the
298    * internal burn function.
299    * @param account The account whose tokens will be burnt.
300    * @param value The amount that will be burnt.
301    */
302   function _burnFrom(address account, uint256 value) internal {
303     require(value <= _allowed[account][msg.sender]);
304 
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
314 
315 /**
316  * @title Ownable
317  * @dev The Ownable contract has an owner address, and provides basic authorization control
318  * functions, this simplifies the implementation of "user permissions".
319  */
320 contract Ownable {
321   address private _owner;
322 
323   event OwnershipTransferred(
324     address indexed previousOwner,
325     address indexed newOwner
326   );
327 
328   /**
329    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
330    * account.
331    */
332   constructor() internal {
333     _owner = msg.sender;
334     emit OwnershipTransferred(address(0), _owner);
335   }
336 
337   /**
338    * @return the address of the owner.
339    */
340   function owner() public view returns(address) {
341     return _owner;
342   }
343 
344   /**
345    * @dev Throws if called by any account other than the owner.
346    */
347   modifier onlyOwner() {
348     require(isOwner());
349     _;
350   }
351 
352   /**
353    * @return true if `msg.sender` is the owner of the contract.
354    */
355   function isOwner() public view returns(bool) {
356     return msg.sender == _owner;
357   }
358 
359   /**
360    * @dev Allows the current owner to relinquish control of the contract.
361    * @notice Renouncing to ownership will leave the contract without an owner.
362    * It will not be possible to call the functions with the `onlyOwner`
363    * modifier anymore.
364    */
365   function renounceOwnership() public onlyOwner {
366     emit OwnershipTransferred(_owner, address(0));
367     _owner = address(0);
368   }
369 
370   /**
371    * @dev Allows the current owner to transfer control of the contract to a newOwner.
372    * @param newOwner The address to transfer ownership to.
373    */
374   function transferOwnership(address newOwner) public onlyOwner {
375     _transferOwnership(newOwner);
376   }
377 
378   /**
379    * @dev Transfers control of the contract to a newOwner.
380    * @param newOwner The address to transfer ownership to.
381    */
382   function _transferOwnership(address newOwner) internal {
383     require(newOwner != address(0));
384     emit OwnershipTransferred(_owner, newOwner);
385     _owner = newOwner;
386   }
387 }
388 
389 // File: eth-token-recover/contracts/TokenRecover.sol
390 
391 /**
392  * @title TokenRecover
393  * @author Vittorio Minacori (https://github.com/vittominacori)
394  * @dev Allow to recover any ERC20 sent into the contract for error
395  */
396 contract TokenRecover is Ownable {
397 
398   /**
399    * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
400    * @param tokenAddress The token contract address
401    * @param tokenAmount Number of tokens to be sent
402    */
403   function recoverERC20(
404     address tokenAddress,
405     uint256 tokenAmount
406   )
407     public
408     onlyOwner
409   {
410     IERC20(tokenAddress).transfer(owner(), tokenAmount);
411   }
412 }
413 
414 // File: contracts/faucet/TokenFaucet.sol
415 
416 /**
417  * @title TokenFaucet
418  * @author Vittorio Minacori (https://github.com/vittominacori)
419  * @dev Implementation of a TokenFaucet
420  */
421 contract TokenFaucet is TokenRecover {
422   using SafeMath for uint256;
423 
424   // struct representing the faucet status for an account
425   struct RecipientDetail {
426     bool exists;
427     uint256 tokens;
428     uint256 lastUpdate;
429     address referral;
430   }
431 
432   // struct representing the referral status
433   struct ReferralDetail {
434     uint256 tokens;
435     address[] recipients;
436   }
437 
438   // the time between two tokens claim
439   uint256 private _pauseTime = 1 days;
440 
441   // the token to distribute
442   ERC20 private _token;
443 
444   // the daily rate of tokens distributed
445   uint256 private _dailyRate;
446 
447   // the value earned by referral per mille
448   uint256 private _referralPerMille;
449 
450   // the sum of distributed tokens
451   uint256 private _totalDistributedTokens;
452 
453   // map of address and received token amount
454   mapping (address => RecipientDetail) private _recipientList;
455 
456   // list of addresses who received tokens
457   address[] private _recipients;
458 
459   // map of address and referred addresses
460   mapping (address => ReferralDetail) private _referralList;
461 
462   /**
463    * @param token Address of the token being distributed
464    * @param dailyRate Daily rate of tokens distributed
465    * @param referralPerMille The value earned by referral per mille
466    */
467   constructor(
468     address token,
469     uint256 dailyRate,
470     uint256 referralPerMille
471   )
472     public
473   {
474     require(token != address(0));
475     require(dailyRate > 0);
476     require(referralPerMille > 0);
477 
478     _token = ERC20(token);
479     _dailyRate = dailyRate;
480     _referralPerMille = referralPerMille;
481   }
482 
483   /**
484    * @dev fallback
485    */
486   function () external payable {
487     require(msg.value == 0);
488 
489     getTokens();
490   }
491 
492   /**
493    * @dev function to be called to receive tokens
494    */
495   function getTokens() public {
496     // distribute tokens
497     _distributeTokens(msg.sender, address(0));
498   }
499 
500   /**
501    * @dev function to be called to receive tokens
502    * @param referral Address to an account that is referring
503    */
504   function getTokensWithReferral(address referral) public {
505     require(referral != msg.sender);
506 
507     // distribute tokens
508     _distributeTokens(msg.sender, referral);
509   }
510 
511   /**
512    * @return the token to distribute
513    */
514   function token() public view returns (ERC20) {
515     return _token;
516   }
517 
518   /**
519    * @return the daily rate of tokens distributed
520    */
521   function dailyRate() public view returns (uint256) {
522     return _dailyRate;
523   }
524 
525   /**
526    * @return the value earned by referral for each recipient
527    */
528   function referralTokens() public view returns (uint256) {
529     return _dailyRate.mul(_referralPerMille).div(1000);
530   }
531 
532   /**
533    * @return the sum of distributed tokens
534    */
535   function totalDistributedTokens() public view returns (uint256) {
536     return _totalDistributedTokens;
537   }
538 
539   /**
540    * @param account The address to check
541    * @return received token amount for the given address
542    */
543   function receivedTokens(address account) public view returns (uint256) {
544     return _recipientList[account].tokens;
545   }
546 
547   /**
548    * @param account The address to check
549    * @return last tokens received timestamp
550    */
551   function lastUpdate(address account) public view returns (uint256) {
552     return _recipientList[account].lastUpdate;
553   }
554 
555   /**
556    * @param account The address to check
557    * @return time of next available claim or zero
558    */
559   function nextClaimTime(address account) public view returns (uint256) {
560     return !_recipientList[account].exists ? 0 : _recipientList[account].lastUpdate + _pauseTime;
561   }
562 
563   /**
564    * @param account The address to check
565    * @return referral for given address
566    */
567   function getReferral(address account) public view returns (address) {
568     return _recipientList[account].referral;
569   }
570 
571   /**
572    * @param account The address to check
573    * @return earned tokens by referrals
574    */
575   function earnedByReferral(address account) public view returns (uint256) {
576     return _referralList[account].tokens;
577   }
578 
579   /**
580    * @param account The address to check
581    * @return referred addresses for given address
582    */
583   function getReferredAddresses(address account) public view returns (address[]) {
584     return _referralList[account].recipients;
585   }
586 
587   /**
588    * @param account The address to check
589    * @return referred addresses for given address
590    */
591   function getReferredAddressesLength(address account) public view returns (uint) {
592     return _referralList[account].recipients.length;
593   }
594 
595   /**
596    * @dev return the number of remaining tokens to distribute
597    * @return uint256
598    */
599   function remainingTokens() public view returns (uint256) {
600     return _token.balanceOf(this);
601   }
602 
603   /**
604    * @return address of a recipient by list index
605    */
606   function getRecipientAddress(uint256 index) public view returns (address) {
607     return _recipients[index];
608   }
609 
610   /**
611    * @dev return the recipients length
612    * @return uint
613    */
614   function getRecipientsLength() public view returns (uint) {
615     return _recipients.length;
616   }
617 
618   /**
619    * @dev change daily rate and referral per mille
620    * @param newDailyRate Daily rate of tokens distributed
621    * @param newReferralPerMille The value earned by referral per mille
622    */
623   function setRates(uint256 newDailyRate, uint256 newReferralPerMille) public onlyOwner {
624     require(newDailyRate > 0);
625     require(newReferralPerMille > 0);
626 
627     _dailyRate = newDailyRate;
628     _referralPerMille = newReferralPerMille;
629   }
630 
631   /**
632    * @dev distribute tokens
633    * @param account Address being distributing
634    * @param referral Address to an account that is referring
635    */
636   function _distributeTokens(address account, address referral) internal {
637     require(nextClaimTime(account) <= block.timestamp); // solium-disable-line security/no-block-members
638 
639     // check if recipient exists
640     if (!_recipientList[account].exists) {
641       _recipients.push(account);
642       _recipientList[account].exists = true;
643 
644       // check if valid referral
645       if (referral != address(0)) {
646         _recipientList[account].referral = referral;
647         _referralList[referral].recipients.push(account);
648       }
649     }
650 
651     // update recipient status
652     _recipientList[account].lastUpdate = block.timestamp; // solium-disable-line security/no-block-members
653     _recipientList[account].tokens = _recipientList[account].tokens.add(_dailyRate);
654 
655     // update faucet status
656     _totalDistributedTokens = _totalDistributedTokens.add(_dailyRate);
657 
658     // transfer tokens to recipient
659     _token.transfer(account, _dailyRate);
660 
661     // check referral
662     if (_recipientList[account].referral != address(0)) {
663       // referral is only the first one referring
664       address firstReferral = _recipientList[account].referral;
665 
666       uint256 referralEarnedTokens = referralTokens();
667 
668       // update referral status
669       _referralList[firstReferral].tokens = _referralList[firstReferral].tokens.add(referralEarnedTokens);
670 
671       // update faucet status
672       _totalDistributedTokens = _totalDistributedTokens.add(referralEarnedTokens);
673 
674       // transfer tokens to referral
675       _token.transfer(firstReferral, referralEarnedTokens);
676     }
677   }
678 }