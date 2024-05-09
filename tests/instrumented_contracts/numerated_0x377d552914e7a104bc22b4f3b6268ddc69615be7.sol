1 pragma solidity 0.8.1; /*
2 
3 ======================= Quick Stats ===================
4     => Name        : NEXT
5     => Symbol      : NEXT
6     => Initial     : 8,000,000 (8M)
7     => Max supply  : 30,300,000 (30,3M)
8     => Decimals    : 18
9 ============= Independant Audit of the code ============
10     => Community Audit by Bug Bounty program
11 ----------------------------------------------------------------------------
12  SPDX-License-Identifier: MIT
13  Copyright (c) 2021 NEXT. ( https://nextchain.dev/ )
14 -----------------------------------------------------------------------------
15 */
16 
17 //*******************************************************************//
18 //------------------------ SafeMath Library -------------------------//
19 //*******************************************************************//
20 /**
21     * @title SafeMath
22     * @dev Math operations with safety checks that throw on error
23     */
24 library SafeMath {
25     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26         if (a == 0) {
27             return 0;
28         }
29         uint256 c = a * b;
30         require(c / a == b, 'SafeMath mul failed');
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // assert(b > 0); // Solidity automatically throws when dividing by 0
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         require(b <= a, 'SafeMath sub failed');
43         return a - b;
44     }
45 
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b;
48         require(c >= a, 'SafeMath add failed');
49         return c;
50     }
51 }
52 
53 
54 //*******************************************************************//
55 //------------------ Contract to Manage Ownership -------------------//
56 //*******************************************************************//
57 
58 contract owned {
59     address payable public owner;
60     address payable internal newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() {
65         owner = payable(msg.sender);
66         emit OwnershipTransferred(address(0), owner);
67     }
68 
69     modifier onlyOwner {
70         require(msg.sender == owner);
71         _;
72     }
73 
74     function transferOwnership(address payable _newOwner) external onlyOwner {
75         newOwner = _newOwner;
76     }
77 
78     //this flow is to prevent transferring ownership to wrong wallet by mistake
79     function acceptOwnership() external {
80         require(msg.sender == newOwner);
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = payable(address(0));
84     }
85 }
86 
87 contract Minter is owned {
88     address payable public mintingowner;
89     address payable internal newMintingOwner;
90 
91     event MintingOwnershipTransferred(address indexed _from, address indexed _to);
92 
93     constructor() {
94         mintingowner = payable(msg.sender);
95         emit MintingOwnershipTransferred(address(0), mintingowner);
96     }
97 
98     modifier onlyMintingOwner {
99         require(msg.sender == mintingowner);
100         _;
101     }
102 
103     function transferMintingOwnership(address payable _newMintingOwner) external onlyOwner {
104         newMintingOwner = _newMintingOwner;
105     }
106 
107     //this flow is to prevent transferring ownership to wrong wallet by mistake
108     function acceptMintingOwnership() external {
109         require(msg.sender == newMintingOwner);
110         emit MintingOwnershipTransferred(mintingowner, newMintingOwner);
111         mintingowner = newMintingOwner;
112         newMintingOwner = payable(address(0));
113     }
114 }
115 
116 interface IERC1363Spender {
117     /*
118      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
119      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
120      */
121 
122     /**
123      * @notice Handle the approval of ERC1363 tokens
124      * @dev Any ERC1363 smart contract calls this function on the recipient
125      * after an `approve`. This function MAY throw to revert and reject the
126      * approval. Return of other than the magic value MUST result in the
127      * transaction being reverted.
128      * Note: the token contract address is always the message sender.
129      * @param sender address The address which called `approveAndCall` function
130      * @param amount uint256 The amount of tokens to be spent
131      * @param data bytes Additional data with no specified format
132      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
133      */
134     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
135 }
136 
137 interface IERC1363Receiver {
138     /*
139      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
140      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
141      */
142 
143     /**
144      * @notice Handle the receipt of ERC1363 tokens
145      * @dev Any ERC1363 smart contract calls this function on the recipient
146      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
147      * transfer. Return of other than the magic value MUST result in the
148      * transaction being reverted.
149      * Note: the token contract address is always the message sender.
150      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
151      * @param sender address The address which are token transferred from
152      * @param amount uint256 The amount of tokens transferred
153      * @param data bytes Additional data with no specified format
154      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
155      */
156     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
157 }
158 
159 interface IERC165 {
160     /**
161      * @dev Returns true if this contract implements the interface defined by
162      * `interfaceId`. See the corresponding
163      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
164      * to learn more about how these ids are created.
165      *
166      * This function call must use less than 30 000 gas.
167      */
168     function supportsInterface(bytes4 interfaceId) external view returns (bool);
169 }
170 
171 /**
172  * @dev Implementation of the {IERC165} interface.
173  *
174  * Contracts may inherit from this and call {_registerInterface} to declare
175  * their support of an interface.
176  */
177 abstract contract ERC165 is IERC165 {
178     /**
179      * @dev Mapping of interface ids to whether or not it's supported.
180      */
181     mapping(bytes4 => bool) private _supportedInterfaces;
182 
183     constructor () {
184         // Derived contracts need only register support for their own interfaces,
185         // we register support for ERC165 itself here
186         _registerInterface(type(IERC165).interfaceId);
187     }
188 
189     /**
190      * @dev See {IERC165-supportsInterface}.
191      *
192      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
193      */
194     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
195         return _supportedInterfaces[interfaceId];
196     }
197 
198     /**
199      * @dev Registers the contract as an implementer of the interface defined by
200      * `interfaceId`. Support of the actual ERC165 interface is automatic and
201      * registering its interface id is not required.
202      *
203      * See {IERC165-supportsInterface}.
204      *
205      * Requirements:
206      *
207      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
208      */
209     function _registerInterface(bytes4 interfaceId) internal virtual {
210         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
211         _supportedInterfaces[interfaceId] = true;
212     }
213 }
214 
215 
216 //****************************************************************************//
217 //---------------------        MAIN CODE STARTS HERE     ---------------------//
218 //****************************************************************************//
219 
220 contract NEXTToken is owned, Minter, ERC165 {
221 
222     /*===============================
223     =         DATA STORAGE          =
224     ===============================*/
225 
226     // Public variables of the token
227     using SafeMath for uint256;
228     string constant private _name = "NEXT";
229     string constant private _symbol = "NEXT";
230     uint256 constant private _decimals = 18;
231     uint256 private _totalSupply = 8000000 * (10**_decimals);         //8M
232     uint256 immutable public maxSupply = 30300000 * (10**_decimals);    //30,3M
233     bool public safeguard;  //putting safeguard on will halt all non-owner functions
234 
235     // This creates a mapping with all data storage
236     mapping (address => uint256) private _balanceOf;
237     mapping (address => mapping (address => uint256)) private _allowance;
238 
239 
240     /*===============================
241     =         PUBLIC EVENTS         =
242     ===============================*/
243 
244     // This generates a public event of token transfer
245     event Transfer(address indexed from, address indexed to, uint256 value);
246 
247     // This notifies clients about the amount burnt
248     event Burn(address indexed from, uint256 value);
249 
250     // This generates a public event for frozen (blacklisting) accounts
251     event FrozenAccounts(address target, bool frozen);
252 
253     // This will log approval of token Transfer
254     event Approval(address indexed from, address indexed spender, uint256 value);
255 
256 
257     /*======================================
258     =       STANDARD ERC20 FUNCTIONS       =
259     ======================================*/
260 
261     /**
262      * Returns name of token
263      */
264     function name() external pure returns(string memory){
265         return _name;
266     }
267 
268     /**
269      * Returns symbol of token
270      */
271     function symbol() external pure returns(string memory){
272         return _symbol;
273     }
274 
275     /**
276      * Returns decimals of token
277      */
278     function decimals() external pure returns(uint256){
279         return _decimals;
280     }
281 
282     /**
283      * Returns totalSupply of token.
284      */
285     function totalSupply() external view returns (uint256) {
286         return _totalSupply;
287     }
288 
289     /**
290      * Returns balance of token
291      */
292     function balanceOf(address user) external view returns(uint256){
293         return _balanceOf[user];
294     }
295 
296     /**
297      * Returns allowance of token
298      */
299     function allowance(address owner, address spender) external view returns (uint256) {
300         return _allowance[owner][spender];
301     }
302 
303     /**
304      * Internal transfer, only can be called by this contract
305      */
306     function _transfer(address _from, address _to, uint _value) internal {
307 
308         //checking conditions
309         require(!safeguard);
310         require (_to != address(0));                      // Prevent transfer to 0x0 address. Use burn() instead
311 
312         // overflow and undeflow checked by SafeMath Library
313         _balanceOf[_from] = _balanceOf[_from].sub(_value);    // Subtract from the sender
314         _balanceOf[_to] = _balanceOf[_to].add(_value);        // Add the same to the recipient
315 
316         // emit Transfer event
317         emit Transfer(_from, _to, _value);
318     }
319 
320     /**
321         * Transfer tokens
322         *
323         * Send `_value` tokens to `_to` from your account
324         *
325         * @param _to The address of the recipient
326         * @param _value the amount to send
327         */
328     function transfer(address _to, uint256 _value) public returns (bool success) {
329         //no need to check for input validations, as that is ruled by SafeMath
330         _transfer(msg.sender, _to, _value);
331         return true;
332     }
333 
334     /**
335         * Transfer tokens from other address
336         *
337         * Send `_value` tokens to `_to` in behalf of `_from`
338         *
339         * @param _from The address of the sender
340         * @param _to The address of the recipient
341         * @param _value the amount to send
342         */
343     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
344         //checking of allowance and token value is done by SafeMath
345         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
346         _transfer(_from, _to, _value);
347         return true;
348     }
349 
350     /**
351         * Set allowance for other address
352         *
353         * Allows `_spender` to spend no more than `_value` tokens in your behalf
354         *
355         * @param _spender The address authorized to spend
356         * @param _value the max amount they can spend
357         */
358     function approve(address _spender, uint256 _value) public returns (bool success) {
359         require(!safeguard);
360         /* AUDITOR NOTE:
361             Many dex and dapps pre-approve large amount of tokens to save gas for subsequent transaction. This is good use case.
362             On flip-side, some malicious dapp, may pre-approve large amount and then drain all token balance from user.
363             So following condition is kept in commented. It can be be kept that way or not based on client's consent.
364         */
365         //require(_balanceOf[msg.sender] >= _value, "Balance does not have enough tokens");
366         _allowance[msg.sender][_spender] = _value;
367         emit Approval(msg.sender, _spender, _value);
368         return true;
369     }
370 
371     /**
372      * @dev Increase the amount of tokens that an owner allowed to a spender.
373      * approve should be called when allowed_[_spender] == 0. To increment
374      * allowed value is better to use this function to avoid 2 calls (and wait until
375      * the first transaction is mined)
376      * Emits an Approval event.
377      * @param spender The address which will spend the funds.
378      * @param value The amount of tokens to increase the allowance by.
379      */
380     function increase_allowance(address spender, uint256 value) external returns (bool) {
381         require(spender != address(0));
382         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(value);
383         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
384         return true;
385     }
386 
387     /**
388      * @dev Decrease the amount of tokens that an owner allowed to a spender.
389      * approve should be called when allowed_[_spender] == 0. To decrement
390      * allowed value is better to use this function to avoid 2 calls (and wait until
391      * the first transaction is mined)
392      * Emits an Approval event.
393      * @param spender The address which will spend the funds.
394      * @param value The amount of tokens to decrease the allowance by.
395      */
396     function decrease_allowance(address spender, uint256 value) external returns (bool) {
397         require(spender != address(0));
398         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(value);
399         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
400         return true;
401     }
402 
403     /*=====================================
404     =       CUSTOM PUBLIC FUNCTIONS       =
405     ======================================*/
406 
407     constructor(){
408         //sending all the tokens to Owner
409         _balanceOf[owner] = _totalSupply;
410 
411         //firing event which logs this transaction
412         emit Transfer(address(0), owner, _totalSupply);
413 
414         // register the supported interfaces to conform to ERC1363 via ERC165
415         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
416         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
417     }
418 
419     receive () external payable {  }
420 
421     /**
422         * Destroy tokens
423         *
424         * Remove `_value` tokens from the system irreversibly
425         *
426         * @param _value the amount of money to burn
427         */
428     function burn(uint256 _value) external returns (bool success) {
429         require(!safeguard);
430         //checking of enough token balance is done by SafeMath
431         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);  // Subtract from the sender
432         _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
433         emit Burn(msg.sender, _value);
434         emit Transfer(msg.sender, address(0), _value);
435         return true;
436     }
437 
438     /**
439         * @notice Create `mintedAmount` tokens and send it to `target`
440         * @param target Address to receive the tokens
441         * @param mintedAmount the amount of tokens it will receive
442         */
443     function mintToken(address target, uint256 mintedAmount) onlyMintingOwner external {
444         require(_totalSupply.add(mintedAmount) <= maxSupply, "Cannot Mint more than maximum supply");
445         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
446         _totalSupply = _totalSupply.add(mintedAmount);
447         emit Transfer(address(0), target, mintedAmount);
448     }
449 
450     /**
451         * Owner can transfer tokens from contract to owner address
452         *
453         * When safeguard is true, then all the non-owner functions will stop working.
454         * When safeguard is false, then all the functions will resume working back again!
455         */
456 
457     function manualWithdrawTokens(uint256 tokenAmount) external onlyOwner{
458         // no need for overflow checking as that will be done in transfer function
459         _transfer(address(this), owner, tokenAmount);
460     }
461 
462     //Just in rare case, owner wants to transfer Ether from contract to owner address
463     function manualWithdrawEther() onlyOwner external{
464         owner.transfer(address(this).balance);
465     }
466 
467     /**
468         * Change safeguard status on or off
469         *
470         * When safeguard is true, then all the non-owner functions will stop working.
471         * When safeguard is false, then all the functions will resume working back again!
472         */
473     function changeSafeguardStatus() onlyOwner external{
474         if (safeguard == false){
475             safeguard = true;
476         }
477         else{
478             safeguard = false;
479         }
480     }
481 
482     /*****************************************/
483     /*  Section for ERC1363 Implementation   */
484     /*****************************************/
485 
486     /*
487      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
488      * 0x4bbee2df ===
489      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
490      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
491      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
492      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
493      */
494     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
495 
496     /*
497      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
498      * 0xfb9ec8ce ===
499      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
500      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
501      */
502     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
503 
504     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
505     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
506     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
507 
508     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
509     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
510     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
511 
512 
513     /**
514      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
515      * @param recipient The address to transfer to.
516      * @param amount The amount to be transferred.
517      * @return A boolean that indicates if the operation was successful.
518      */
519     function transferAndCall(address recipient, uint256 amount) public virtual  returns (bool) {
520         return transferAndCall(recipient, amount, "");
521     }
522 
523     /**
524      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
525      * @param recipient The address to transfer to
526      * @param amount The amount to be transferred
527      * @param data Additional data with no specified format
528      * @return A boolean that indicates if the operation was successful.
529      */
530     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual  returns (bool) {
531         transfer(recipient, amount);
532         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
533         return true;
534     }
535 
536     /**
537      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
538      * @param sender The address which you want to send tokens from
539      * @param recipient The address which you want to transfer to
540      * @param amount The amount of tokens to be transferred
541      * @return A boolean that indicates if the operation was successful.
542      */
543     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual  returns (bool) {
544         return transferFromAndCall(sender, recipient, amount, "");
545     }
546 
547     /**
548      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
549      * @param sender The address which you want to send tokens from
550      * @param recipient The address which you want to transfer to
551      * @param amount The amount of tokens to be transferred
552      * @param data Additional data with no specified format
553      * @return A boolean that indicates if the operation was successful.
554      */
555     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual  returns (bool) {
556         transferFrom(sender, recipient, amount);
557         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
558         return true;
559     }
560 
561     /**
562      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
563      * @param spender The address allowed to transfer to
564      * @param amount The amount allowed to be transferred
565      * @return A boolean that indicates if the operation was successful.
566      */
567     function approveAndCall(address spender, uint256 amount) public virtual  returns (bool) {
568         return approveAndCall(spender, amount, "");
569     }
570 
571     /**
572      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
573      * @param spender The address allowed to transfer to.
574      * @param amount The amount allowed to be transferred.
575      * @param data Additional data with no specified format.
576      * @return A boolean that indicates if the operation was successful.
577      */
578     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual  returns (bool) {
579         approve(spender, amount);
580         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
581         return true;
582     }
583 
584     /**
585      * @dev Internal function to invoke `onTransferReceived` on a target address
586      *  The call is not executed if the target address is not a contract
587      * @param sender address Representing the previous owner of the given token value
588      * @param recipient address Target address that will receive the tokens
589      * @param amount uint256 The amount mount of tokens to be transferred
590      * @param data bytes Optional data to send along with the call
591      * @return whether the call correctly returned the expected magic value
592      */
593     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
594         if (!isContract(recipient)) {
595             return false;
596         }
597         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
598             _msgSender(), sender, amount, data
599         );
600         return (retval == _ERC1363_RECEIVED);
601     }
602 
603     /**
604      * @dev Internal function to invoke `onApprovalReceived` on a target address
605      *  The call is not executed if the target address is not a contract
606      * @param spender address The address which will spend the funds
607      * @param amount uint256 The amount of tokens to be spent
608      * @param data bytes Optional data to send along with the call
609      * @return whether the call correctly returned the expected magic value
610      */
611     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
612         if (!isContract(spender)) {
613             return false;
614         }
615         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
616             _msgSender(), amount, data
617         );
618         return (retval == _ERC1363_APPROVED);
619     }
620 
621     /**
622      * @dev Returns true if `account` is a contract.
623      *
624      * [IMPORTANT]
625      * ====
626      * It is unsafe to assume that an address for which this function returns
627      * false is an externally-owned account (EOA) and not a contract.
628      *
629      * Among others, `isContract` will return false for the following
630      * types of addresses:
631      *
632      *  - an externally-owned account
633      *  - a contract in construction
634      *  - an address where a contract will be created
635      *  - an address where a contract lived, but was destroyed
636      * ====
637      */
638     function isContract(address account) internal view returns (bool) {
639         // This method relies on extcodesize, which returns 0 for contracts in
640         // construction, since the code is only stored at the end of the
641         // constructor execution.
642 
643         uint256 size;
644         // solhint-disable-next-line no-inline-assembly
645         assembly { size := extcodesize(account) }
646         return size > 0;
647     }
648 
649     /**
650      * returns msg.sender
651      */
652     function _msgSender() internal view virtual returns (address) {
653         return msg.sender;
654     }
655 
656     /**
657      * returns msg.data
658      */
659     function _msgData() internal view virtual returns (bytes calldata) {
660         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
661         return msg.data;
662     }
663 }