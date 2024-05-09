1 pragma solidity ^0.4.24;
2 
3 // File: ..\node_modules\openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
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
38 // File: ..\node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
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
104 // File: ..\node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
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
389 // File: contracts\AdvisorWallet.sol
390 
391 contract AdvisorWallet {  
392 	using SafeMath for uint256;
393 
394 	struct Advisor {		
395 		uint256 tokenAmount;    
396 		uint withdrawStage;		
397 	}
398 
399   ERC20 public tokenContract;
400 	uint256 public totalToken;
401 	address public creator;
402 	bool public allocateTokenDone = false;
403 
404 	mapping(address => Advisor) public advisors;
405 
406   uint public firstUnlockDate;
407   uint public secondUnlockDate;  
408 
409   event WithdrewTokens(address _tokenContract, address _to, uint256 _amount);
410 
411 	modifier onlyCreator() {
412 		require(msg.sender == creator);
413 		_;
414 	}
415 
416   constructor() public {
417     creator = msg.sender;
418     tokenContract = ERC20(creator);
419 
420     firstUnlockDate = now + (6 * 30 days); // Allow withdraw 50% after 6 month
421     secondUnlockDate = now + (12 * 30 days); // Allow withdraw all after 12 month
422   }
423   
424   function() payable public { 
425     revert();
426   }
427 
428 	function setAllocateTokenDone() internal {
429 		require(!allocateTokenDone);
430 		allocateTokenDone = true;
431 	}
432 
433 	function addAdvisor(address _memberAddress, uint256 _tokenAmount) internal {		
434 		require(!allocateTokenDone);
435 		advisors[_memberAddress] = Advisor(_tokenAmount, 0);
436     totalToken = totalToken.add(_tokenAmount);
437 	}
438 
439   function allocateTokenForAdvisor() external onlyCreator {
440     // allocation 10M token for advisor
441     addAdvisor(0xf8E2d6a822f70c5c5788fa10f080810a8579d407, 2000000 * (10 ** 18));
442     addAdvisor(0xab74072a37e08Ff9ceA098d4E33438257589B044, 1000000 * (10 ** 18));
443     addAdvisor(0x3DFD289380Cbe25456B5973306129753c4ed3dF3, 7000000 * (10 ** 18));
444     setAllocateTokenDone();
445   }
446 	
447   // callable by advisor only, after specified time
448   function withdrawTokens() external {		
449     require(now > firstUnlockDate);
450 		Advisor storage advisor = advisors[msg.sender];
451 		require(advisor.tokenAmount > 0);
452 
453     uint256 amount = 0;
454     if(now > secondUnlockDate) {
455       // withdrew all token remain in second stage
456       amount = advisor.tokenAmount;
457     } else if(now > firstUnlockDate && advisor.withdrawStage == 0){
458       // withdrew 50% in first stage
459       amount = advisor.tokenAmount * 50 / 100;
460     }
461 
462     if(amount > 0) {
463 			advisor.tokenAmount = advisor.tokenAmount.sub(amount);      
464 			advisor.withdrawStage = advisor.withdrawStage + 1;      
465       tokenContract.transfer(msg.sender, amount);
466       emit WithdrewTokens(tokenContract, msg.sender, amount);
467       return;
468     }
469 
470     revert();
471   }
472 }
473 
474 // File: contracts\TeamWallet.sol
475 
476 contract TeamWallet {  
477 	using SafeMath for uint256;
478 
479 	struct Member {		
480     uint256 tokenAmount;
481 		uint256 tokenRemain;
482 		uint withdrawStage;		
483 		address lastRejecter;
484     bool isRejected;
485 	}
486 
487   ERC20 public tokenContract;
488 	uint256 public totalToken;
489 	address public creator;
490 	bool public allocateTokenDone = false;
491 
492 	mapping(address => Member) public members;
493 
494   uint public firstUnlockDate;
495   uint public secondUnlockDate;
496   uint public thirdUnlockDate;
497 
498   address public approver1;
499   address public approver2;
500 
501   event WithdrewTokens(address _tokenContract, address _to, uint256 _amount);  
502   event RejectedWithdrawal(address _rejecter, address _member, uint _withdrawStage);
503 
504 	modifier onlyCreator() {
505 		require(msg.sender == creator);
506 		_;
507 	}
508 
509   modifier onlyApprover() {
510     require(msg.sender == approver1 || msg.sender == approver2);
511     _;
512   }
513 
514   constructor(
515     address _approver1,
516     address _approver2
517   ) public {
518     require(_approver1 != address(0));
519     require(_approver2 != address(0));
520 
521     creator = msg.sender;
522     tokenContract = ERC20(creator);
523     
524     firstUnlockDate = now + (12 * 30 days); // Allow withdraw 20% after 12 month    
525     secondUnlockDate = now + (24 * 30 days); // Allow withdraw 30% after 24 month
526     thirdUnlockDate = now + (36 * 30 days); // Allow withdraw all after 36 month    
527 
528     approver1 = _approver1;
529     approver2 = _approver2;
530   }
531   
532   function() payable public { 
533     revert();
534   }
535 
536 	function setAllocateTokenDone() internal {
537 		require(!allocateTokenDone);
538 		allocateTokenDone = true;
539 	}
540 
541 	function addMember(address _memberAddress, uint256 _tokenAmount) internal {		
542 		require(!allocateTokenDone);
543 		members[_memberAddress] = Member(_tokenAmount, _tokenAmount, 0, address(0), false);
544     totalToken = totalToken.add(_tokenAmount);
545 	}
546   
547   function allocateTokenForTeam() external onlyApprover {
548     // allocation 20M token for team and founder
549     addMember(0x0929C384F12914Fe20dE96af934A35b8333Bbe11, 97656 * (10 ** 18));
550     addMember(0x0A0aC5949FE7Af47B566F0dC02f92DF6B6980AA5, 65104 * (10 ** 18));
551     addMember(0x0eE878D94e22Cb50A62e4D685193B35015e3eDf8, 640000 * (10 ** 18));
552     addMember(0x1A5912eEb9490B0937CD36636eEEFA82aA4Aa549, 177083 * (10 ** 18));
553     addMember(0x1b2298A5d5342452D87D6684Fe31aEe52A31433d, 130208 * (10 ** 18));
554     addMember(0x1eF0f9F6CcD2528d7038d4cEe47a417cA7f4c79d, 175781 * (10 ** 18));
555     addMember(0x23a18F3A82F9EE302a1e6350b8D9f9F3B65ED5D7, 104167 * (10 ** 18));
556     addMember(0x24F29d95a0D41a1713b67b29Bf664A1b70B5D683, 97656 * (10 ** 18));
557     addMember(0x2598aCe98c1117f72Da929441b56a26994d5b13A, 680000 * (10 ** 18));
558     addMember(0x275c667B3B372Ffb03BF05B97841C66eF1f1DF99, 480000 * (10 ** 18));
559     addMember(0x27be83EBDC7D7917e2A4247bb8286cB192b74C51, 65104 * (10 ** 18));
560     addMember(0x2847aFA0348284658A2cAFf676361A26220ccE7d, 280000 * (10 ** 18));
561     addMember(0x29904b46fb7e411654dd16b1e9680A81Aa5A472D, 240000 * (10 ** 18));
562     addMember(0x2B6f1941101c633Bbe24ce13Fd49ba14480F7242, 120000 * (10 ** 18));
563     addMember(0x2c647B2D6a5B3FFE21bebA4467937cEd24c4292B, 720000 * (10 ** 18));
564     addMember(0x2d8cdfBfc3C8Df06f70257eAca63aB742db62562, 110677 * (10 ** 18));
565     addMember(0x3289E2310108699e22c2CDF81485885a3E9d3683, 31250 * (10 ** 18));
566     addMember(0x375814a2D26A8cB1a010Db1FE8cE9Bc06e5224af, 125000 * (10 ** 18));
567     addMember(0x401438aD9584A68D5A68FA1E8a2ef716862d82d9, 149740 * (10 ** 18));
568     addMember(0x44be551E017893A0dD74e5160Ef0DB0aed2BdA54, 400000 * (10 ** 18));
569     addMember(0x451B389a9F7365B09A24481F9EB5a125F64Ae4aB, 280000 * (10 ** 18));
570     addMember(0x500D157FA3E3Ab5133ee0C7EFff3Ad5cdBCE01F3, 400000 * (10 ** 18));
571     addMember(0x577FEE18cCD840b2a41c9180bbE6412a89c1aD2C, 720000 * (10 ** 18));
572     addMember(0x58eA48c5FD9ac82e6CCb8aC67aCB48D1fb38b592, 80000 * (10 ** 18));
573     addMember(0x5DdfCd7d8FAe31014010C3877E4Bf91F2E683F2D, 130208 * (10 ** 18));
574     addMember(0x5E5Fc9f5C8B2EA3436D92dC07f621496C6E3EeC4, 800000 * (10 ** 18));
575     addMember(0x5F89F3FeeeB67B3229b17E389D8BaD28f44d08aA, 120000 * (10 ** 18));
576     addMember(0x60a09Fa998a1A6625c1161C452aAab26e6151cfA, 45573 * (10 ** 18));
577     addMember(0x63Fa2cE8C891690fF40FB197E09C72B84Ca1030e, 121094 * (10 ** 18));
578     addMember(0x66e898bA75FC329d872e61eE16fc4ea0248Eb369, 320000 * (10 ** 18));
579     addMember(0x66F212e3Ba5F44BeB014FCe2beD1b1F290b13009, 15625 * (10 ** 18));
580     addMember(0x6736ead91e4E9131262Aa033B8811071BbCa3f85, 117188 * (10 ** 18));
581     addMember(0x6B99cE47bf47D91159109506B4722c732B5d7b46, 120000 * (10 ** 18));
582     addMember(0x6f9140d408Faf111eF3D693645638B863650057d, 320000 * (10 ** 18));
583     addMember(0x7510CC3635470Bd033c94a10B0a7ed46d98EbcC7, 156250 * (10 ** 18));
584     addMember(0x7692bF394c84D3a880407E8cf4167b01007A9880, 175781 * (10 ** 18));
585     addMember(0x7726bDa7d29FC141Eb65150eA7CBB1bC985693Dd, 93750 * (10 ** 18));
586     addMember(0x7B6c1d3475974d5904c31BE4F3B9aA26F6eCAebB, 400000 * (10 ** 18));
587     addMember(0x7D0E17DEa015B5A687385116d443466B2a42c65B, 109375 * (10 ** 18));
588     addMember(0x8a0D93CF316b6Eb58aa5463533d06F18Bfa58ade, 640000 * (10 ** 18));
589     addMember(0x8F25dD569c72fB507D72D743f070273556123AED, 169271 * (10 ** 18));
590     addMember(0x908D0CF89bc46510b1B472F51905169Ad025f99F, 120000 * (10 ** 18));
591     addMember(0x99A43289E131640534E147596F05d40699214673, 160000 * (10 ** 18));
592     addMember(0x9C16FA8a4e04d67781D3d02a6b17De7a3e27e168, 600000 * (10 ** 18));
593     addMember(0x9DAeD1073C38902a9a6dD8834f8a7c7851717b86, 360000 * (10 ** 18));
594     addMember(0xa0dc24Aa838946d39d3d76f0f776BE6D26cB7b2b, 520000 * (10 ** 18));
595     addMember(0xa40b31177E908d235FDF6AE8010e135d204BE19c, 160000 * (10 ** 18));
596     addMember(0xa428FEcCc9E9F972498303d2C91982f1B6813827, 109375 * (10 ** 18));
597     addMember(0xa7951c07d25d88D75662BD68B5dF4D6D08F17600, 104167 * (10 ** 18));
598     addMember(0xA7fD89962f76233b68c33b0d9795c5899Feb11B3, 320000 * (10 ** 18));
599     addMember(0xA8B6FB38F8BeC4C331E922Eb5a842921081267ce, 156250 * (10 ** 18));
600     addMember(0xafbE656FbBC42704ef04aa6D8Ee1FEa9F3b71E7F, 136719 * (10 ** 18));
601     addMember(0xb1cf51D7e8F987d0e64bBB2e1bE277821c600778, 130208 * (10 ** 18));
602     addMember(0xB694854b6d8e6eAbDC15bE93005CCd54B841a79f, 560000 * (10 ** 18));
603     addMember(0xb6dFc3227E2dd9CA569fFCE69014539F138D1bcC, 280000 * (10 ** 18));
604     addMember(0xc230934C7610e39Ae06d4799e21b938bB44E60f2, 280000 * (10 ** 18));
605     addMember(0xc6888650Dec537dD4f056008D9d3ED171d48F1CD, 640000 * (10 ** 18));
606     addMember(0xccE1fc98815307BcDdE9596544802945a664C8b7, 440000 * (10 ** 18));
607     addMember(0xd1326c632009979713BD92855cecc04c7ebE29F0, 36458 * (10 ** 18));
608     addMember(0xD3859645cECCEFB1210567BaEB9c714272c9f61B, 149740 * (10 ** 18));
609     addMember(0xDB252f9D8Bd0Cb0bB83df4E50870977c771C6b50, 26042 * (10 ** 18));
610     addMember(0xDc87F026A5d5E37B9AD67321a19802Bb5082cC67, 400000 * (10 ** 18));
611     addMember(0xE01b721ef02A550B11DF7e0B3f55809227a4F1B4, 680000 * (10 ** 18));
612     addMember(0xe13E61A210724D50F5D39cd3f8b08955993E9309, 80000 * (10 ** 18));
613     addMember(0xe2D9a70307383072f18bf9D0eff9Cb98d1278777, 600000 * (10 ** 18));
614     addMember(0xe81CF8A8F052B6dd9dFfF452a593e5638A4097ee, 109375 * (10 ** 18));
615     addMember(0xEC80389aF763b4d141b1AD2a1E8579f8B5500fAF, 560000 * (10 ** 18));
616     addMember(0xF568705D7A1Df478CF6118420fA482B71092Ca66, 156250 * (10 ** 18));
617     addMember(0xF662482E8196Fb5e4f680964263A5bA618E295A7, 149740 * (10 ** 18));
618     addMember(0xF84FB7E6d21364B4F919Cab2A205Af70ae86f013, 800000 * (10 ** 18));
619     addMember(0xF9Cd27047e11DdDb93C5623a97b49278B1443576, 110677 * (10 ** 18));
620     addMember(0xF9d41D1409cdf2AfD629ab437760Bb41260CC81D, 20833 * (10 ** 18));
621     addMember(0xFbAEF91d25e3cfad0aDef2F9C43f9eC957615E43, 680000 * (10 ** 18));
622     addMember(0xfe5e823c967476bC4cFB8D84Dfaf6699A76062F4, 140625 * (10 ** 18));
623     setAllocateTokenDone();
624   }
625 	
626   // callable by team member only, after specified time
627   function withdrawTokens() external {		
628     require(now > firstUnlockDate);
629 		Member storage member = members[msg.sender];
630 		require(member.tokenRemain > 0 && member.isRejected == false);
631 
632     uint256 amount = 0;
633     if(now > thirdUnlockDate) {
634       // withdrew all remain token in third stage
635       amount = member.tokenRemain;      
636     } else if(now > secondUnlockDate && member.withdrawStage == 1) {
637       // withdrew 30% in second stage
638       amount = member.tokenAmount * 30 / 100;
639     } else if(now > firstUnlockDate && member.withdrawStage == 0){
640       // withdrew 20% in first stage
641       amount = member.tokenAmount * 20 / 100;
642     }
643 
644     if(amount > 0) {
645 			member.tokenRemain = member.tokenRemain.sub(amount);      
646 			member.withdrawStage = member.withdrawStage + 1;      
647       tokenContract.transfer(msg.sender, amount);
648       emit WithdrewTokens(tokenContract, msg.sender, amount);
649       return;
650     }
651 
652     revert();
653   }  
654 
655   function rejectWithdrawal(address _memberAddress) external onlyApprover {
656 		Member storage member = members[_memberAddress];
657     require(member.lastRejecter != msg.sender);
658 		require(member.tokenRemain > 0 && member.isRejected == false);
659 
660     //have a admin reject member before
661     if(member.lastRejecter != address(0)) {      
662 			member.isRejected = true;
663 		}
664 
665     member.lastRejecter = msg.sender;
666     emit RejectedWithdrawal(msg.sender, _memberAddress, member.withdrawStage);
667   }
668 
669 	function canBurn(address _memberAddress) external view returns(bool) {
670 		Member memory member = members[_memberAddress];
671 		if(member.tokenRemain > 0) return member.isRejected;
672 		return false;
673 	}
674 
675 	function getMemberTokenRemain(address _memberAddress) external view returns(uint256) {
676 		Member memory member = members[_memberAddress];
677 		if(member.tokenRemain > 0) return member.tokenRemain;
678 		return 0;
679 	}	
680 
681 	function burnMemberToken(address _memberAddress) external onlyCreator() {
682 		Member storage member = members[_memberAddress];
683 		require(member.tokenRemain > 0 && member.isRejected);
684 		member.tokenRemain = 0;
685 	}	
686 }
687 
688 // File: contracts\CoinBet.sol
689 
690 /* solium-disable */
691 pragma solidity ^0.4.24;
692 
693 
694 
695 
696 
697 library ICOData {
698   struct Bracket {
699     uint256 total;
700     uint256 remainToken;
701     uint256 tokenPerEther;
702     uint256 minAcceptedAmount;
703   }
704   
705   enum SaleStates {
706     InPrivateSale,
707     InPresale,
708     EndPresale,
709     InPublicSale,
710     EndPublicSale
711   }
712 }
713 
714 // ================= Coinbet Token =======================
715 contract Coinbet is ERC20, Ownable {
716   
717   string public constant name = "Coinbet";
718   string public constant symbol = "Z88";
719   uint256 public constant decimals = 18;
720   // 200M token will be supplied
721   uint256 public constant INITIAL_SUPPLY = 200000000 * (10 ** decimals);
722 
723   // 20M tokens allocated for founders and team
724   uint256 public constant FOUNDER_AND_TEAM_ALLOCATION = 20000000 * (10 ** decimals);
725   // 10M tokens allocated for advisors
726   uint256 public constant ADVISOR_ALLOCATION = 10000000 * (10 ** decimals);
727   // 5M tokens allocated for bounty & referral
728   uint256 public constant AIRDROP_ALLOCATION = 5000000 * (10 ** decimals);
729   // 30M tokens allocated for treasury
730   uint256 public constant TREASURY_ALLOCATION = 30000000 * (10 ** decimals);
731   // 10M tokens allocated for partner
732   uint256 public constant PARTNER_ALLOCATION = 10000000 * (10 ** decimals);
733 
734   // 40M tokens allocated for pre sale
735   uint256 public constant PRIVATE_SALE_ALLOCATION = 40000000 * (10 ** decimals);
736   // 20M tokens allocated for private sale
737   uint256 public constant PRESALE_ALLOCATION = 20000000 * (10 ** decimals);
738   // 20M tokens allocated for public sale in 1st bracket
739   uint256 public constant PUBLIC_1_ALLOCATION = 20000000 * (10 ** decimals);
740   // 40M tokens allocated for public sale in 2nd bracket
741   uint256 public constant PUBLIC_2_ALLOCATION = 40000000 * (10 ** decimals);
742   // 1.5M tokens allocated for Lotto645 jackpot
743   uint256 public constant LOTTO645_JACKPOT_ALLOCATION = 1500000 * (10 ** decimals);
744   // 3M tokens allocated for Lotto655 jackpot 1
745   uint256 public constant LOTTO655_JACKPOT_1_ALLOCATION = 3000000 * (10 ** decimals);
746   // 0.5M tokens allocated for Lotto655 jackpot 2
747   uint256 public constant LOTTO655_JACKPOT_2_ALLOCATION = 500000 * (10 ** decimals);
748 
749   // Admin role
750   address public admin;
751   // Address where funds are collected
752   address public fundWallet;
753   // Wallet is used for Bounty & Referral program
754   address public airdropWallet;
755   // Wallet for tokens keeping purpose, no sale
756   address public treasuryWallet;
757   // Wallet is used for Coinbet Partner Program
758   address public partnerWallet;
759   // Contract is used for rewarding development team
760   TeamWallet public teamWallet;
761   // Contract is used for rewarding advisor team
762   AdvisorWallet public advisorWallet;
763   // Wallet is used for paying Z88 Lotto 645's starting Jackpot
764   address public lotto645JackpotWallet;
765   // Wallet is used for paying Z88 Lotto 655's starting Jackpot 1
766   address public lotto655Jackpot1Wallet;
767   // Wallet is used for paying Z88 Lotto 655's starting Jackpot 2
768   address public lotto655Jackpot2Wallet;
769   
770   // Remain number of Z88 tokens for private sale
771   uint256 public privateSaleRemain;
772   // Info of presale bracket: total tokens, remain tokens, price
773   ICOData.Bracket public presaleBracket;
774   // Sale states: InPrivateSale, InPresale, EndPresale, InPublicSale, EndPublicSale
775   ICOData.SaleStates public saleState;
776   // The flag to specify the selling state
777   bool public isSelling;
778   // The start date for private sale
779   uint public sellingTime;
780   // The flag to specify the transferable state
781   bool public isTransferable;
782 
783   // Info of 1st & 2nd public brackets: total tokens, remain tokens, price
784   ICOData.Bracket[2] public publicBrackets;  
785   // The index of current public bracket: 0 or 1
786   uint private currentPublicBracketIndex;
787 
788   event PrivateSale(address to, uint256 tokenAmount); // Transfer token to investors in private sale
789   event PublicSale(address to, uint256 amount, uint256 tokenAmount); // Investors purchase token in public sale
790   event SetBracketPrice(uint bracketIndex, uint256 tokenPerEther); // Set bracket price in public sale  
791   event StartPublicSale(uint256 tokenPerEther); // start public sale with price
792   event EndPublicSale(); // end public sale
793   event SetPresalePrice(uint256 tokenPerEther); // Set price in presale
794   event PreSale(address to, uint256 amount, uint256 tokenAmount); // Investors purchase token in presale
795   event StartPrivateSale(uint startedTime); // start private sale
796   event StartPresale(uint256 tokenPerEther, uint startedTime); // start presale
797   event EndPresale(); // end presale
798   event ChangeBracketIndex(uint bracketIndex); // change to next bracket for sale  
799   event EnableTransfer(); // enable transfer token
800   event BurnTeamToken(address lockedWallet, address memberAddress, uint256 amount); // burn token allocated for dev team when they are inactivity
801 
802   modifier transferable() {
803     require(isTransferable == true);
804     _;
805   }
806 
807   modifier isInSale() {
808     require(isSelling == true);
809     _;
810   }
811 
812   modifier onlyAdminOrOwner() {
813     require(msg.sender == admin || msg.sender == owner());
814     _;
815   }
816 
817   constructor(
818     address _admin,
819     address _fundWallet,
820     address _airdropWallet,
821     address _treasuryWallet,
822     address _partnerWallet,
823     address _lotto645JackpotWallet,
824     address _lotto655Jackpot1Wallet,
825     address _lotto655Jackpot2Wallet,
826     address _approver1,
827     address _approver2,
828     uint _startPrivateSaleAfter
829   ) 
830     public 
831   { 
832     require(_admin != address(0) && _admin != msg.sender);
833     require(_fundWallet != address(0) && _fundWallet != msg.sender);
834     require(_airdropWallet != address(0) && _airdropWallet != msg.sender );
835     require(_treasuryWallet != address(0) && _treasuryWallet != msg.sender );
836     require(_partnerWallet != address(0) && _partnerWallet != msg.sender );
837     require(_lotto645JackpotWallet != address(0) && _lotto645JackpotWallet != msg.sender );
838     require(_lotto655Jackpot1Wallet != address(0) && _lotto655Jackpot1Wallet != msg.sender );
839     require(_lotto655Jackpot2Wallet != address(0) && _lotto655Jackpot2Wallet != msg.sender );
840 
841     admin = _admin;
842     fundWallet = _fundWallet;
843     airdropWallet = _airdropWallet;
844     treasuryWallet = _treasuryWallet;
845     partnerWallet = _partnerWallet;
846     lotto645JackpotWallet = _lotto645JackpotWallet;
847     lotto655Jackpot1Wallet = _lotto655Jackpot1Wallet;
848     lotto655Jackpot2Wallet = _lotto655Jackpot2Wallet;
849 
850     saleState = ICOData.SaleStates.InPrivateSale;
851     sellingTime = now + _startPrivateSaleAfter * 1 seconds;
852 
853     // create TeamWallet & AdvisorWallet
854     teamWallet = new TeamWallet(_approver1, _approver2);
855     advisorWallet = new AdvisorWallet();
856 
857     emit StartPrivateSale(sellingTime);
858 	  initTokenAndBrackets();
859   }
860 
861   function getSaleState() public view returns (ICOData.SaleStates state, uint time) {
862     return (saleState, sellingTime);
863   }
864 
865   function () external payable isInSale {
866     require(fundWallet != address(0));    
867 
868     if(saleState == ICOData.SaleStates.InPresale && now >= sellingTime ) {
869       return purchaseTokenInPresale();
870     } else if(saleState == ICOData.SaleStates.InPublicSale  && now >= sellingTime ) {
871       return purchaseTokenInPublicSale();
872     }
873     
874     revert();
875   }
876 
877   function getCurrentPublicBracket()
878     public 
879     view 
880     returns (
881       uint256 bracketIndex, 
882       uint256 total, 
883       uint256 remainToken, 
884       uint256 tokenPerEther,
885       uint256 minAcceptedAmount
886     ) 
887   {
888     if(saleState == ICOData.SaleStates.InPublicSale) {
889       ICOData.Bracket memory bracket = publicBrackets[currentPublicBracketIndex];
890       return (currentPublicBracketIndex, bracket.total, bracket.remainToken, bracket.tokenPerEther, bracket.minAcceptedAmount);
891     } else {
892       return (0, 0, 0, 0, 0);
893     }
894   }
895 
896   function transfer(address _to, uint256 _value) 
897     public
898     transferable 
899     returns (bool success) 
900   {
901     require(_to != address(0));
902     require(_value > 0);
903     return super.transfer(_to, _value);
904   }
905 
906   function transferFrom(address _from, address _to, uint256 _value) 
907     public 
908     transferable 
909     returns (bool success) 
910   {
911     require(_from != address(0));
912     require(_to != address(0));
913     require(_value > 0);
914     return super.transferFrom(_from, _to, _value);
915   }
916 
917   function approve(address _spender, uint256 _value) 
918     public 
919     transferable 
920     returns (bool success) 
921   {
922     require(_spender != address(0));
923     require(_value > 0);
924     return super.approve(_spender, _value);
925   }
926 
927   function changeWalletAddress(address _newAddress) external onlyOwner {
928     require(_newAddress != address(0));
929     require(fundWallet != _newAddress);
930     fundWallet = _newAddress;
931   }
932 
933   function changeAdminAddress(address _newAdmin) external onlyOwner {
934     require(_newAdmin != address(0));
935     require(admin != _newAdmin);
936     admin = _newAdmin;
937   }
938 
939   function enableTransfer() external onlyOwner {
940     require(isTransferable == false);
941     isTransferable = true;
942     emit EnableTransfer();
943   }
944   
945   function transferPrivateSale(address _to, uint256 _value) 
946     external 
947     onlyAdminOrOwner 
948     returns (bool success) 
949   {
950     require(saleState == ICOData.SaleStates.InPrivateSale);
951     require(_to != address(0));
952     require(_value > 0);
953     require(privateSaleRemain >= _value);
954 
955     privateSaleRemain = privateSaleRemain.sub(_value);
956     _transfer(owner(), _to, _value);
957     emit PrivateSale(_to, _value);
958     return true;    
959   }
960   
961   function setPublicPrice(uint _bracketIndex, uint256 _tokenPerEther) 
962     external 
963     onlyAdminOrOwner 
964     returns (bool success) 
965   {
966     require(_tokenPerEther > 0);
967     require(publicBrackets.length > _bracketIndex && _bracketIndex >= currentPublicBracketIndex);
968 
969     ICOData.Bracket storage bracket = publicBrackets[_bracketIndex];
970     require(bracket.tokenPerEther != _tokenPerEther);
971 
972     bracket.tokenPerEther = _tokenPerEther;
973     emit SetBracketPrice(_bracketIndex, _tokenPerEther);
974     return true;
975   }
976 
977   function setMinAcceptedInPublicSale(uint _bracketIndex, uint256 _minAcceptedAmount) 
978     external 
979     onlyAdminOrOwner 
980     returns (bool success)
981   {
982     require(_minAcceptedAmount > 0);
983     require(publicBrackets.length > _bracketIndex && _bracketIndex >= currentPublicBracketIndex);
984 
985     ICOData.Bracket storage bracket = publicBrackets[_bracketIndex];
986     require(bracket.minAcceptedAmount != _minAcceptedAmount);
987 
988     bracket.minAcceptedAmount = _minAcceptedAmount;
989     return true;
990   }  
991 
992   function changeToPublicSale() external onlyAdminOrOwner returns (bool success) {
993     require(saleState == ICOData.SaleStates.EndPresale);    
994     return startPublicSale();
995   }  
996 
997   function setPresalePrice(uint256 _tokenPerEther) external onlyAdminOrOwner returns (bool) {
998     require(_tokenPerEther > 0);
999     require(presaleBracket.tokenPerEther != _tokenPerEther);
1000 
1001     presaleBracket.tokenPerEther = _tokenPerEther;
1002     emit SetPresalePrice(_tokenPerEther);
1003     return true;
1004   }
1005 
1006   function startPresale(uint256 _tokenPerEther, uint _startAfter) 
1007     external 
1008     onlyAdminOrOwner 
1009     returns (bool) 
1010   {
1011     require(saleState < ICOData.SaleStates.InPresale);
1012     require(_tokenPerEther > 0);    
1013     presaleBracket.tokenPerEther = _tokenPerEther;
1014     isSelling = true;
1015     saleState = ICOData.SaleStates.InPresale;
1016     sellingTime = now + _startAfter * 1 seconds;
1017     emit StartPresale(_tokenPerEther, sellingTime);
1018     return true;
1019   }
1020 
1021   function setMinAcceptedAmountInPresale(uint256 _minAcceptedAmount) 
1022     external 
1023     onlyAdminOrOwner 
1024     returns (bool)
1025   {
1026     require(_minAcceptedAmount > 0);
1027     require(presaleBracket.minAcceptedAmount != _minAcceptedAmount);
1028 
1029     presaleBracket.minAcceptedAmount = _minAcceptedAmount;
1030     return true;
1031   }
1032 
1033   function burnMemberToken(address _member) external onlyAdminOrOwner {        
1034     require(teamWallet != address(0));
1035     bool canBurn = teamWallet.canBurn(_member);
1036     uint256 tokenRemain = teamWallet.getMemberTokenRemain(_member);
1037     require(canBurn && tokenRemain > 0);    
1038     
1039     teamWallet.burnMemberToken(_member);
1040 
1041     _burn(teamWallet, tokenRemain);
1042     emit BurnTeamToken(teamWallet, _member, tokenRemain);
1043   }
1044 
1045   function initTokenAndBrackets() private {
1046     _mint(owner(), INITIAL_SUPPLY);
1047 
1048     // allocate token for bounty, referral, treasury, partner
1049     super.transfer(airdropWallet, AIRDROP_ALLOCATION);
1050     super.transfer(treasuryWallet, TREASURY_ALLOCATION);
1051     super.transfer(partnerWallet, PARTNER_ALLOCATION);
1052 
1053     // allocate token for private sale
1054     privateSaleRemain = PRIVATE_SALE_ALLOCATION;
1055 
1056     // allocate token for presale
1057     uint256 minAcceptedAmountInPresale = 1 ether; // 1 ether for mininum ether acception in presale
1058     presaleBracket = ICOData.Bracket(PRESALE_ALLOCATION, PRESALE_ALLOCATION, 0, minAcceptedAmountInPresale);
1059     
1060     // bracket token allocation for public sale
1061     uint256 minAcceptedAmountInBracket1 = 0.5 * (1 ether); // 0.5 ether for mininum ether acception in bracket 1
1062     publicBrackets[0] = ICOData.Bracket(PUBLIC_1_ALLOCATION, PUBLIC_1_ALLOCATION, 0, minAcceptedAmountInBracket1);
1063 
1064     uint256 minAcceptedAmountInBracket2 = 0.1 * (1 ether); // 0.1 ether for mininum ether acception in bracket 2
1065     publicBrackets[1] = ICOData.Bracket(PUBLIC_2_ALLOCATION, PUBLIC_2_ALLOCATION, 0, minAcceptedAmountInBracket2);    
1066 
1067     // allocate token for Z88 Lotto Jackpot
1068     super.transfer(lotto645JackpotWallet, LOTTO645_JACKPOT_ALLOCATION);
1069     super.transfer(lotto655Jackpot1Wallet, LOTTO655_JACKPOT_1_ALLOCATION);
1070     super.transfer(lotto655Jackpot2Wallet, LOTTO655_JACKPOT_2_ALLOCATION);
1071 
1072     // allocate token for Team Wallet
1073     super.transfer(teamWallet, FOUNDER_AND_TEAM_ALLOCATION);
1074     // allocate token to Advisor Wallet
1075     super.transfer(advisorWallet, ADVISOR_ALLOCATION);
1076     advisorWallet.allocateTokenForAdvisor();
1077   }
1078 
1079   function purchaseTokenInPresale() private {
1080     require(msg.value >= presaleBracket.minAcceptedAmount);
1081     require(presaleBracket.tokenPerEther > 0 && presaleBracket.remainToken > 0);
1082 
1083     uint256 tokenPerEther = presaleBracket.tokenPerEther.mul(10 ** decimals);
1084     uint256 tokenAmount = msg.value.mul(tokenPerEther).div(1 ether);    
1085 
1086     uint256 refundAmount = 0;
1087     if(tokenAmount > presaleBracket.remainToken) {
1088       refundAmount = tokenAmount.sub(presaleBracket.remainToken).mul(1 ether).div(tokenPerEther);
1089       tokenAmount = presaleBracket.remainToken;
1090     }
1091 
1092     presaleBracket.remainToken = presaleBracket.remainToken.sub(tokenAmount);
1093     _transfer(owner(), msg.sender, tokenAmount);
1094 
1095     uint256 paymentAmount = msg.value.sub(refundAmount);
1096     fundWallet.transfer(paymentAmount);
1097     if(refundAmount > 0)      
1098       msg.sender.transfer(refundAmount);
1099 
1100     emit PreSale(msg.sender, paymentAmount, tokenAmount);
1101 
1102     if(presaleBracket.remainToken == 0) {
1103       endPresale();
1104     }    
1105   }
1106 
1107   function endPresale() private {    
1108     isSelling = false;
1109     saleState = ICOData.SaleStates.EndPresale;
1110     emit EndPresale();
1111     startPublicSale();
1112   }
1113 
1114   function startPublicSale() private returns (bool success) {    
1115     ICOData.Bracket memory bracket = publicBrackets[currentPublicBracketIndex];
1116     if(bracket.tokenPerEther == 0) return false;    
1117     isSelling = true;
1118     saleState = ICOData.SaleStates.InPublicSale;
1119     emit StartPublicSale(bracket.tokenPerEther);
1120     return true;
1121   }
1122 
1123   function purchaseTokenInPublicSale() private {
1124     ICOData.Bracket storage bracket = publicBrackets[currentPublicBracketIndex];
1125     require(msg.value >= bracket.minAcceptedAmount);
1126     require(bracket.tokenPerEther > 0 && bracket.remainToken > 0);
1127 
1128     uint256 tokenPerEther = bracket.tokenPerEther.mul(10 ** decimals);
1129     uint256 remainToken = bracket.remainToken;
1130     uint256 tokenAmount = msg.value.mul(tokenPerEther).div(1 ether);
1131     uint256 refundAmount = 0;
1132 
1133     // check remain token when end bracket
1134     if(remainToken < tokenAmount) {      
1135       refundAmount = tokenAmount.sub(remainToken).mul(1 ether).div(tokenPerEther);
1136       tokenAmount = remainToken;
1137     }
1138 
1139     bracket.remainToken = bracket.remainToken.sub(tokenAmount);
1140     _transfer(owner(), msg.sender, tokenAmount);
1141 
1142     uint256 paymentAmount = msg.value.sub(refundAmount);
1143     fundWallet.transfer(paymentAmount);
1144     if(refundAmount > 0)      
1145       msg.sender.transfer(refundAmount);
1146     
1147     emit PublicSale(msg.sender, paymentAmount, tokenAmount);
1148 
1149     // end current bracket and move to next bracket
1150     if(bracket.remainToken == 0) {      
1151       nextBracket();
1152     }
1153   }
1154 
1155   function nextBracket() private {
1156     // last bracket - end public sale
1157     if(currentPublicBracketIndex == publicBrackets.length - 1) {
1158       isSelling = false;
1159       saleState = ICOData.SaleStates.EndPublicSale;
1160       isTransferable = true;
1161       emit EnableTransfer();
1162       emit EndPublicSale();
1163     }        
1164     else {
1165       currentPublicBracketIndex = currentPublicBracketIndex + 1;
1166       emit ChangeBracketIndex(currentPublicBracketIndex);
1167     }
1168   }
1169 }