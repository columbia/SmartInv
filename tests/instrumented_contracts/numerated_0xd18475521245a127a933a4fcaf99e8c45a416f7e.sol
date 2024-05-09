1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
288 
289 pragma solidity ^0.5.2;
290 
291 
292 /**
293  * @title ERC20Detailed token
294  * @dev The decimals are only for visualization purposes.
295  * All the operations are done using the smallest and indivisible token unit,
296  * just as on Ethereum all the operations are done in wei.
297  */
298 contract ERC20Detailed is IERC20 {
299     string private _name;
300     string private _symbol;
301     uint8 private _decimals;
302 
303     constructor (string memory name, string memory symbol, uint8 decimals) public {
304         _name = name;
305         _symbol = symbol;
306         _decimals = decimals;
307     }
308 
309     /**
310      * @return the name of the token.
311      */
312     function name() public view returns (string memory) {
313         return _name;
314     }
315 
316     /**
317      * @return the symbol of the token.
318      */
319     function symbol() public view returns (string memory) {
320         return _symbol;
321     }
322 
323     /**
324      * @return the number of decimals of the token.
325      */
326     function decimals() public view returns (uint8) {
327         return _decimals;
328     }
329 }
330 
331 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
332 
333 pragma solidity ^0.5.2;
334 
335 /**
336  * @title Ownable
337  * @dev The Ownable contract has an owner address, and provides basic authorization control
338  * functions, this simplifies the implementation of "user permissions".
339  */
340 contract Ownable {
341     address private _owner;
342 
343     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
344 
345     /**
346      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
347      * account.
348      */
349     constructor () internal {
350         _owner = msg.sender;
351         emit OwnershipTransferred(address(0), _owner);
352     }
353 
354     /**
355      * @return the address of the owner.
356      */
357     function owner() public view returns (address) {
358         return _owner;
359     }
360 
361     /**
362      * @dev Throws if called by any account other than the owner.
363      */
364     modifier onlyOwner() {
365         require(isOwner());
366         _;
367     }
368 
369     /**
370      * @return true if `msg.sender` is the owner of the contract.
371      */
372     function isOwner() public view returns (bool) {
373         return msg.sender == _owner;
374     }
375 
376     /**
377      * @dev Allows the current owner to relinquish control of the contract.
378      * It will not be possible to call the functions with the `onlyOwner`
379      * modifier anymore.
380      * @notice Renouncing ownership will leave the contract without an owner,
381      * thereby removing any functionality that is only available to the owner.
382      */
383     function renounceOwnership() public onlyOwner {
384         emit OwnershipTransferred(_owner, address(0));
385         _owner = address(0);
386     }
387 
388     /**
389      * @dev Allows the current owner to transfer control of the contract to a newOwner.
390      * @param newOwner The address to transfer ownership to.
391      */
392     function transferOwnership(address newOwner) public onlyOwner {
393         _transferOwnership(newOwner);
394     }
395 
396     /**
397      * @dev Transfers control of the contract to a newOwner.
398      * @param newOwner The address to transfer ownership to.
399      */
400     function _transferOwnership(address newOwner) internal {
401         require(newOwner != address(0));
402         emit OwnershipTransferred(_owner, newOwner);
403         _owner = newOwner;
404     }
405 }
406 
407 // File: contracts/QDT.sol
408 
409 pragma solidity 0.5.9;
410 
411 
412 
413 
414 
415 contract QDT is ERC20, ERC20Detailed, Ownable{
416     using SafeMath for uint256;
417 
418     uint8 constant LIMIT_FOR_PAYOUT = 200;
419     uint32 constant PASSWORD_REVEAL_MIN_DELAY = 2592000;
420 
421     string private _name = "Quantfury Data Token";
422     string private _symbol = "QDT";
423     uint8 private _decimals = 8;
424 
425     // Trading data of current epoch
426     struct Epoch {
427         string hash;
428         uint256 epochTime;
429         string password;
430         uint256 weiAmount;
431         uint256 tokenAmount;
432         uint256 revealTime;
433     }
434 
435     uint256 private _currentEpoch;
436 
437     // List of trading data
438     mapping(uint256 => Epoch) private listOfEpoch;
439 
440     // Amount of money in payout pool
441     uint256 private _ethPayoutPool;
442 
443     // How many token units a buyer gets per wei.
444     // The rate is the conversion between wei and the smallest and indivisible token unit.
445     uint256 private _tokenPrice;
446 
447     constructor() ERC20Detailed(_name, _symbol, _decimals) public {
448         _currentEpoch = 0;
449         _tokenPrice = 0;
450     }
451 
452     /**
453      * @dev Get balance of contract pool
454      * @return A uint256 that indicates amount Eth in contract.
455      */
456     function getBalance()
457     external
458     view
459     returns(uint256)
460     {
461         return _ethPayoutPool;
462     }
463 
464     /**
465      * @dev Get current price
466      * @return A uint256 that indicates amount Eth per one token.
467      */
468     function getPrice()
469     external
470     view
471     returns (uint256)
472     {
473         return _tokenPrice;
474     }
475 
476     /**
477      * @dev Show current epoch
478      * @return A uint256 that indicates number of epoch.
479      */
480     function getCurrentEpoch()
481     external
482     view
483     returns (uint256)
484     {
485         return _currentEpoch;
486     }
487 
488     /**
489     * @dev Show information about ipfs
490     * @param epoch index of data in list of epoch
491     * @return A bytes32 that indicates hash of ipfs.
492     * @return A string that indicates password of ipfs.
493     * @return A uint256 that indicates amount of ether in ipfs.
494     * @return A uint256 that indicates amount of tokens in ipfs.
495     * @return A uint256 that indicates time of password will show.
496     */
497     function getEpoch(uint256 epoch)
498     external
499     view
500     returns (
501         string memory,
502         uint256,
503         string memory,
504         uint256,
505         uint256,
506         uint256
507     ) {
508         return (
509                 listOfEpoch[epoch].hash,
510                 listOfEpoch[epoch].epochTime,
511                 listOfEpoch[epoch].password,
512                 listOfEpoch[epoch].weiAmount,
513                 listOfEpoch[epoch].tokenAmount,
514                 listOfEpoch[epoch].revealTime
515                );
516     }
517 
518     /**
519      * @dev Deposit into the payout pool
520      * @return A boolean that indicates if the operation was successful.
521      */
522 
523     function deposit()
524     external
525     onlyOwner
526     payable
527     returns (bool)
528     {
529         require(msg.value > 0);
530         _ethPayoutPool = _ethPayoutPool.add(msg.value);
531         emit Deposit(msg.sender, msg.value);
532         return true;
533     }
534 
535     /**
536      * @dev Withdraw wei from payout pool
537      * @param receiver Address who receive ether
538      * @param weiAmount Amount of wei
539      * @return A boolean that indicates if the operation was successful.
540      */
541     function withdraw(address payable receiver, uint256 weiAmount)
542     external
543     onlyOwner
544     returns (bool)
545     {
546         require(receiver != address(0x0));
547         _ethPayoutPool = _ethPayoutPool.sub(weiAmount);
548         address(receiver).transfer(weiAmount);
549         emit Withdraw(receiver, weiAmount);
550         return true;
551     }
552 
553     /**
554      * @dev Function create IPFS for new epoch
555      * @param ipfsHash Hash of the IPFS link
556      * @param epochTime time of creation epoch
557      * @param weiAmount Amount of wei
558      * @param tokenAmount Amount tokens will mint
559      */
560     function createEpoch(
561         string calldata ipfsHash,
562         uint256 epochTime,
563         uint256 weiAmount,
564         uint256 tokenAmount
565     )
566     external
567     onlyOwner
568     {
569         require(listOfEpoch[_currentEpoch].epochTime < epochTime);
570         uint256 _totalSupply = totalSupply();
571         uint256 tokenPriceOld = _tokenPrice;
572         _currentEpoch++;
573         listOfEpoch[_currentEpoch].hash = ipfsHash;
574         listOfEpoch[_currentEpoch].epochTime = epochTime;
575         listOfEpoch[_currentEpoch].weiAmount = weiAmount;
576         listOfEpoch[_currentEpoch].tokenAmount = tokenAmount;
577         listOfEpoch[_currentEpoch].revealTime = epochTime.add(PASSWORD_REVEAL_MIN_DELAY);
578 
579         //Change price of token
580         _tokenPrice = (weiAmount.add(_totalSupply.mul(_tokenPrice))).div(_totalSupply.add(tokenAmount));
581         require(_tokenPrice != 0);
582 
583         emit CreateEpoch(
584             _currentEpoch,
585                 weiAmount,
586                 tokenAmount,
587                 _tokenPrice,
588                 _totalSupply,
589                 tokenPriceOld,
590                 _ethPayoutPool);
591     }
592 
593     /**
594      * @dev Function calls to swap tokens to wei
595      * @param tokenAmount Number of tokens for swap
596      */
597     function sellTokens(
598         uint256 tokenAmount
599     )
600     external
601     {
602         uint256 weiAmount = _getWeiAmount(tokenAmount);
603 
604         _burn(msg.sender, tokenAmount);
605 
606         _ethPayoutPool = _ethPayoutPool.sub(weiAmount);
607 
608         address(msg.sender).transfer(weiAmount);
609 
610         emit Sell(msg.sender, tokenAmount, weiAmount, _tokenPrice, balanceOf(msg.sender));
611     }
612 
613     /**
614      * @dev Function calls to make payout in epoch
615      * @param holderAdresses The array of addresses that will receive the minted tokens.
616      * @param tokenAmounts The array of amounts of token that will send to address.
617      * @param totalTokenAmount The amount of tokens that will send to address.
618      */
619     function payout(
620         address[] calldata holderAdresses,
621         uint256[] calldata tokenAmounts,
622         uint256 totalTokenAmount
623     )
624     external
625     onlyOwner
626     {
627         require(balanceOf(msg.sender) >= totalTokenAmount);
628         require(holderAdresses.length == tokenAmounts.length);
629         require(holderAdresses.length <= LIMIT_FOR_PAYOUT);
630 
631         for (uint i = 0; i < holderAdresses.length; i++) {
632             _transfer(msg.sender, holderAdresses[i], tokenAmounts[i]);
633         }
634     }
635 
636     /**
637      * @dev Function to mint tokens
638      * @param to The address that will receive the minted tokens.
639      * @param value The amount of tokens to mint.
640      * @return A boolean that indicates if the operation was successful.
641      */
642     function mint(
643         address to,
644         uint256 value
645     )
646     external
647     onlyOwner
648     returns (bool) {
649         _mint(to, value);
650         return true;
651     }
652 
653     /**
654      * @dev Function to burn tokens
655      * @param value The amount of tokens to burn.
656      * @return A boolean that indicates if the operation was successful.
657      */
658     function burn(
659         uint256 value
660     )
661     external
662     onlyOwner
663     returns (bool) {
664         _burn(msg.sender, value);
665         return true;
666     }
667 
668     /**
669      * @dev Function save password of IPFS only after 30 days
670      * @param epoch Number of epoch
671      * @param password String is password for ipfs
672      */
673     function commitTradingPassword(
674         uint256 epoch,
675         string calldata password
676     )
677     external
678     onlyOwner
679     {
680         require(_currentEpoch >= epoch);
681         require(listOfEpoch[epoch].revealTime < now);
682         listOfEpoch[epoch].password = password;
683         emit OpenPassword(epoch, password);
684     }
685 
686     /**
687      * @dev Override to extend the way in which ether is converted to tokens.
688      * @param tokenAmount Value in token to be converted into wei
689      * @return Number of wei that can be purchased with the specified _weiAmount
690      */
691     function _getWeiAmount(uint256 tokenAmount)
692     internal
693     view
694     returns (uint256) {
695         return tokenAmount.mul(_tokenPrice);
696     }
697 
698     event CreateEpoch(
699         uint256 epoch,
700         uint256 weiAmount,
701         uint256 tokenAmount,
702         uint256 tokenPrice,
703         uint256 totalSupply,
704         uint256 tokenPriceOld,
705         uint256 ethPayoutPool);
706     event OpenPassword(uint256 epoch, string password);
707     event Sell(address indexed seller, uint256 tokenAmount, uint256 weiAmount, uint256 tokenPrice, uint256 balances);
708     event Withdraw(address indexed receiver, uint256 weiAmount);
709     event Deposit(address indexed sender, uint256 weiAmount);
710 }