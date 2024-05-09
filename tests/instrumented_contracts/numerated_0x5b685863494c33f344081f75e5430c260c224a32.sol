1 pragma solidity 0.8.1; /*
2 
3 ======================= Quick Stats ===================
4     => Name        : CORE MultiChain Token
5     => Symbol      : CMCX
6     => Total supply: 20,000,000,000 (20 Billion)
7     => Decimals    : 18
8 ============= Independant Audit of the code ============
9     => Community Audit by Bug Bounty program
10 ----------------------------------------------------------------------------
11  SPDX-License-Identifier: MIT
12  Copyright (c) 2021 CORE. ( https://www.coremultichain.com/ )
13 -----------------------------------------------------------------------------
14 */ 
15 
16 //*******************************************************************//
17 //------------------------ SafeMath Library -------------------------//
18 //*******************************************************************//
19 /**
20     * @title SafeMath
21     * @dev Math operations with safety checks that throw on error
22     */
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26         return 0;
27     }
28     uint256 c = a * b;
29     require(c / a == b, 'SafeMath mul failed');
30     return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a, 'SafeMath sub failed');
42     return a - b;
43     }
44 
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     require(c >= a, 'SafeMath add failed');
48     return c;
49     }
50 }
51 
52 
53 //*******************************************************************//
54 //------------------ Contract to Manage Ownership -------------------//
55 //*******************************************************************//
56     
57 contract owned {
58     address payable public owner;
59     address payable internal newOwner;
60 
61     event OwnershipTransferred(address indexed _from, address indexed _to);
62 
63     constructor() {
64         owner = payable(msg.sender);
65         emit OwnershipTransferred(address(0), owner);
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address payable _newOwner) external onlyOwner {
74         newOwner = _newOwner;
75     }
76 
77     //this flow is to prevent transferring ownership to wrong wallet by mistake
78     function acceptOwnership() external {
79         require(msg.sender == newOwner);
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82         newOwner = payable(address(0));
83     }
84 }
85 
86 
87 interface IERC1363Spender {
88     /*
89      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
90      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
91      */
92 
93     /**
94      * @notice Handle the approval of ERC1363 tokens
95      * @dev Any ERC1363 smart contract calls this function on the recipient
96      * after an `approve`. This function MAY throw to revert and reject the
97      * approval. Return of other than the magic value MUST result in the
98      * transaction being reverted.
99      * Note: the token contract address is always the message sender.
100      * @param sender address The address which called `approveAndCall` function
101      * @param amount uint256 The amount of tokens to be spent
102      * @param data bytes Additional data with no specified format
103      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))` unless throwing
104      */
105     function onApprovalReceived(address sender, uint256 amount, bytes calldata data) external returns (bytes4);
106 }
107 
108 interface IERC1363Receiver {
109     /*
110      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
111      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
112      */
113 
114     /**
115      * @notice Handle the receipt of ERC1363 tokens
116      * @dev Any ERC1363 smart contract calls this function on the recipient
117      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
118      * transfer. Return of other than the magic value MUST result in the
119      * transaction being reverted.
120      * Note: the token contract address is always the message sender.
121      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
122      * @param sender address The address which are token transferred from
123      * @param amount uint256 The amount of tokens transferred
124      * @param data bytes Additional data with no specified format
125      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))` unless throwing
126      */
127     function onTransferReceived(address operator, address sender, uint256 amount, bytes calldata data) external returns (bytes4);
128 }
129 
130 interface IERC165 {
131     /**
132      * @dev Returns true if this contract implements the interface defined by
133      * `interfaceId`. See the corresponding
134      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
135      * to learn more about how these ids are created.
136      *
137      * This function call must use less than 30 000 gas.
138      */
139     function supportsInterface(bytes4 interfaceId) external view returns (bool);
140 }
141 
142 
143 /**
144  * @dev Implementation of the {IERC165} interface.
145  *
146  * Contracts may inherit from this and call {_registerInterface} to declare
147  * their support of an interface.
148  */
149 abstract contract ERC165 is IERC165 {
150     /**
151      * @dev Mapping of interface ids to whether or not it's supported.
152      */
153     mapping(bytes4 => bool) private _supportedInterfaces;
154 
155     constructor () {
156         // Derived contracts need only register support for their own interfaces,
157         // we register support for ERC165 itself here
158         _registerInterface(type(IERC165).interfaceId);
159     }
160 
161     /**
162      * @dev See {IERC165-supportsInterface}.
163      *
164      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
165      */
166     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
167         return _supportedInterfaces[interfaceId];
168     }
169 
170     /**
171      * @dev Registers the contract as an implementer of the interface defined by
172      * `interfaceId`. Support of the actual ERC165 interface is automatic and
173      * registering its interface id is not required.
174      *
175      * See {IERC165-supportsInterface}.
176      *
177      * Requirements:
178      *
179      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
180      */
181     function _registerInterface(bytes4 interfaceId) internal virtual {
182         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
183         _supportedInterfaces[interfaceId] = true;
184     }
185 }
186  
187 
188     
189 //****************************************************************************//
190 //---------------------        MAIN CODE STARTS HERE     ---------------------//
191 //****************************************************************************//
192     
193 contract CMCXToken is owned, ERC165 {
194     
195 
196     /*===============================
197     =         DATA STORAGE          =
198     ===============================*/
199 
200     // Public variables of the token
201     using SafeMath for uint256;
202     string constant private _name = "CORE MultiChain Token";
203     string constant private _symbol = "CMCX";
204     uint256 constant private _decimals = 18;
205     uint256 private _totalSupply = 20000000000 * (10**_decimals);         //20 billion tokens
206     uint256 constant public maxSupply = 20000000000 * (10**_decimals);    //20 billion tokens
207     bool public safeguard;  //putting safeguard on will halt all non-owner functions
208 
209     // This creates a mapping with all data storage
210     mapping (address => uint256) private _balanceOf;
211     mapping (address => mapping (address => uint256)) private _allowance;
212 
213 
214     /*===============================
215     =         PUBLIC EVENTS         =
216     ===============================*/
217 
218     // This generates a public event of token transfer
219     event Transfer(address indexed from, address indexed to, uint256 value);
220 
221     // This notifies clients about the amount burnt
222     event Burn(address indexed from, uint256 value);
223         
224     // This generates a public event for frozen (blacklisting) accounts
225     event FrozenAccounts(address target, bool frozen);
226     
227     // This will log approval of token Transfer
228     event Approval(address indexed from, address indexed spender, uint256 value);
229 
230 
231 
232     /*======================================
233     =       STANDARD ERC20 FUNCTIONS       =
234     ======================================*/
235     
236     /**
237      * Returns name of token 
238      */
239     function name() external pure returns(string memory){
240         return _name;
241     }
242     
243     /**
244      * Returns symbol of token 
245      */
246     function symbol() external pure returns(string memory){
247         return _symbol;
248     }
249     
250     /**
251      * Returns decimals of token 
252      */
253     function decimals() external pure returns(uint256){
254         return _decimals;
255     }
256     
257     /**
258      * Returns totalSupply of token.
259      */
260     function totalSupply() external view returns (uint256) {
261         return _totalSupply;
262     }
263     
264     /**
265      * Returns balance of token 
266      */
267     function balanceOf(address user) external view returns(uint256){
268         return _balanceOf[user];
269     }
270     
271     /**
272      * Returns allowance of token 
273      */
274     function allowance(address owner, address spender) external view returns (uint256) {
275         return _allowance[owner][spender];
276     }
277     
278     /**
279      * Internal transfer, only can be called by this contract 
280      */
281     function _transfer(address _from, address _to, uint _value) internal {
282         
283         //checking conditions
284         require(!safeguard);
285         require (_to != address(0));                      // Prevent transfer to 0x0 address. Use burn() instead
286         
287         // overflow and undeflow checked by SafeMath Library
288         _balanceOf[_from] = _balanceOf[_from].sub(_value);    // Subtract from the sender
289         _balanceOf[_to] = _balanceOf[_to].add(_value);        // Add the same to the recipient
290         
291         // emit Transfer event
292         emit Transfer(_from, _to, _value);
293     }
294 
295     /**
296         * Transfer tokens
297         *
298         * Send `_value` tokens to `_to` from your account
299         *
300         * @param _to The address of the recipient
301         * @param _value the amount to send
302         */
303     function transfer(address _to, uint256 _value) public returns (bool success) {
304         //no need to check for input validations, as that is ruled by SafeMath
305         _transfer(msg.sender, _to, _value);
306         return true;
307     }
308 
309     /**
310         * Transfer tokens from other address
311         *
312         * Send `_value` tokens to `_to` in behalf of `_from`
313         *
314         * @param _from The address of the sender
315         * @param _to The address of the recipient
316         * @param _value the amount to send
317         */
318     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
319         //checking of allowance and token value is done by SafeMath
320         _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(_value);
321         _transfer(_from, _to, _value);
322         return true;
323     }
324 
325     /**
326         * Set allowance for other address
327         *
328         * Allows `_spender` to spend no more than `_value` tokens in your behalf
329         *
330         * @param _spender The address authorized to spend
331         * @param _value the max amount they can spend
332         */
333     function approve(address _spender, uint256 _value) public returns (bool success) {
334         require(!safeguard);
335         /* AUDITOR NOTE:
336             Many dex and dapps pre-approve large amount of tokens to save gas for subsequent transaction. This is good use case.
337             On flip-side, some malicious dapp, may pre-approve large amount and then drain all token balance from user.
338             So following condition is kept in commented. It can be be kept that way or not based on client's consent.
339         */
340         //require(_balanceOf[msg.sender] >= _value, "Balance does not have enough tokens");
341         _allowance[msg.sender][_spender] = _value;
342         emit Approval(msg.sender, _spender, _value);
343         return true;
344     }
345     
346     /**
347      * @dev Increase the amount of tokens that an owner allowed to a spender.
348      * approve should be called when allowed_[_spender] == 0. To increment
349      * allowed value is better to use this function to avoid 2 calls (and wait until
350      * the first transaction is mined)
351      * Emits an Approval event.
352      * @param spender The address which will spend the funds.
353      * @param value The amount of tokens to increase the allowance by.
354      */
355     function increase_allowance(address spender, uint256 value) external returns (bool) {
356         require(spender != address(0));
357         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].add(value);
358         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
359         return true;
360     }
361 
362     /**
363      * @dev Decrease the amount of tokens that an owner allowed to a spender.
364      * approve should be called when allowed_[_spender] == 0. To decrement
365      * allowed value is better to use this function to avoid 2 calls (and wait until
366      * the first transaction is mined)
367      * Emits an Approval event.
368      * @param spender The address which will spend the funds.
369      * @param value The amount of tokens to decrease the allowance by.
370      */
371     function decrease_allowance(address spender, uint256 value) external returns (bool) {
372         require(spender != address(0));
373         _allowance[msg.sender][spender] = _allowance[msg.sender][spender].sub(value);
374         emit Approval(msg.sender, spender, _allowance[msg.sender][spender]);
375         return true;
376     }
377 
378 
379     /*=====================================
380     =       CUSTOM PUBLIC FUNCTIONS       =
381     ======================================*/
382     
383     constructor(){
384         //sending all the tokens to Owner
385         _balanceOf[owner] = _totalSupply;
386         
387         //firing event which logs this transaction
388         emit Transfer(address(0), owner, _totalSupply);
389         
390         // register the supported interfaces to conform to ERC1363 via ERC165
391         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
392         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
393     }
394     
395     receive () external payable {  }
396 
397     /**
398         * Destroy tokens
399         *
400         * Remove `_value` tokens from the system irreversibly
401         *
402         * @param _value the amount of money to burn
403         */
404     function burn(uint256 _value) external returns (bool success) {
405         require(!safeguard);
406         //checking of enough token balance is done by SafeMath
407         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);  // Subtract from the sender
408         _totalSupply = _totalSupply.sub(_value);                      // Updates totalSupply
409         emit Burn(msg.sender, _value);
410         emit Transfer(msg.sender, address(0), _value);
411         return true;
412     }
413 
414 
415     
416     /** 
417         * @notice Create `mintedAmount` tokens and send it to `target`
418         * @param target Address to receive the tokens
419         * @param mintedAmount the amount of tokens it will receive
420         */
421     function mintToken(address target, uint256 mintedAmount) onlyOwner external {
422         require(_totalSupply.add(mintedAmount) <= maxSupply, "Cannot Mint more than maximum supply");
423         _balanceOf[target] = _balanceOf[target].add(mintedAmount);
424         _totalSupply = _totalSupply.add(mintedAmount);
425         emit Transfer(address(0), target, mintedAmount);
426     }
427 
428         
429 
430     /**
431         * Owner can transfer tokens from contract to owner address
432         *
433         * When safeguard is true, then all the non-owner functions will stop working.
434         * When safeguard is false, then all the functions will resume working back again!
435         */
436     
437     function manualWithdrawTokens(uint256 tokenAmount) external onlyOwner{
438         // no need for overflow checking as that will be done in transfer function
439         _transfer(address(this), owner, tokenAmount);
440     }
441     
442     //Just in rare case, owner wants to transfer Ether from contract to owner address
443     function manualWithdrawEther()onlyOwner external{
444         owner.transfer(address(this).balance);
445     }
446     
447     /**
448         * Change safeguard status on or off
449         *
450         * When safeguard is true, then all the non-owner functions will stop working.
451         * When safeguard is false, then all the functions will resume working back again!
452         */
453     function changeSafeguardStatus() onlyOwner external{
454         if (safeguard == false){
455             safeguard = true;
456         }
457         else{
458             safeguard = false;    
459         }
460     }
461     
462 
463     
464     /*************************************/
465     /*    Section for User Air drop      */
466     /*************************************/
467     
468     /**
469      * Run an ACTIVE Air-Drop
470      *
471      * It requires an array of all the addresses and amount of tokens to distribute
472      * It will only process first 100 recipients. That limit is fixed to prevent gas limit
473      */
474     function airdropACTIVE(address[] memory recipients,uint256[] memory tokenAmount) external returns(bool) {
475         uint256 totalAddresses = recipients.length;
476         address msgSender = msg.sender; //make a local variable to save gas cost in loop
477         require(totalAddresses <= 100,"Too many recipients");
478         for(uint i = 0; i < totalAddresses; i++)
479         {
480           //This will loop through all the recipients and send them the specified tokens
481           //Input data validation is unncessary, as that is done by SafeMath and which also saves some gas.
482           _transfer(msgSender, recipients[i], tokenAmount[i]);
483         }
484         return true;
485     }
486    
487     /*****************************************/
488     /*  Section for ERC1363 Implementation   */
489     /*****************************************/
490     
491     
492     /*
493      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
494      * 0x4bbee2df ===
495      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
496      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
497      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
498      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
499      */
500     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
501 
502     /*
503      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
504      * 0xfb9ec8ce ===
505      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
506      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
507      */
508     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
509 
510     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
511     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
512     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
513 
514     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
515     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
516     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
517 
518 
519     /**
520      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
521      * @param recipient The address to transfer to.
522      * @param amount The amount to be transferred.
523      * @return A boolean that indicates if the operation was successful.
524      */
525     function transferAndCall(address recipient, uint256 amount) public virtual  returns (bool) {
526         return transferAndCall(recipient, amount, "");
527     }
528 
529     /**
530      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
531      * @param recipient The address to transfer to
532      * @param amount The amount to be transferred
533      * @param data Additional data with no specified format
534      * @return A boolean that indicates if the operation was successful.
535      */
536     function transferAndCall(address recipient, uint256 amount, bytes memory data) public virtual  returns (bool) {
537         transfer(recipient, amount);
538         require(_checkAndCallTransfer(_msgSender(), recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
539         return true;
540     }
541 
542     /**
543      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
544      * @param sender The address which you want to send tokens from
545      * @param recipient The address which you want to transfer to
546      * @param amount The amount of tokens to be transferred
547      * @return A boolean that indicates if the operation was successful.
548      */
549     function transferFromAndCall(address sender, address recipient, uint256 amount) public virtual  returns (bool) {
550         return transferFromAndCall(sender, recipient, amount, "");
551     }
552 
553     /**
554      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
555      * @param sender The address which you want to send tokens from
556      * @param recipient The address which you want to transfer to
557      * @param amount The amount of tokens to be transferred
558      * @param data Additional data with no specified format
559      * @return A boolean that indicates if the operation was successful.
560      */
561     function transferFromAndCall(address sender, address recipient, uint256 amount, bytes memory data) public virtual  returns (bool) {
562         transferFrom(sender, recipient, amount);
563         require(_checkAndCallTransfer(sender, recipient, amount, data), "ERC1363: _checkAndCallTransfer reverts");
564         return true;
565     }
566 
567     /**
568      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
569      * @param spender The address allowed to transfer to
570      * @param amount The amount allowed to be transferred
571      * @return A boolean that indicates if the operation was successful.
572      */
573     function approveAndCall(address spender, uint256 amount) public virtual  returns (bool) {
574         return approveAndCall(spender, amount, "");
575     }
576 
577     /**
578      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
579      * @param spender The address allowed to transfer to.
580      * @param amount The amount allowed to be transferred.
581      * @param data Additional data with no specified format.
582      * @return A boolean that indicates if the operation was successful.
583      */
584     function approveAndCall(address spender, uint256 amount, bytes memory data) public virtual  returns (bool) {
585         approve(spender, amount);
586         require(_checkAndCallApprove(spender, amount, data), "ERC1363: _checkAndCallApprove reverts");
587         return true;
588     }
589 
590     /**
591      * @dev Internal function to invoke `onTransferReceived` on a target address
592      *  The call is not executed if the target address is not a contract
593      * @param sender address Representing the previous owner of the given token value
594      * @param recipient address Target address that will receive the tokens
595      * @param amount uint256 The amount mount of tokens to be transferred
596      * @param data bytes Optional data to send along with the call
597      * @return whether the call correctly returned the expected magic value
598      */
599     function _checkAndCallTransfer(address sender, address recipient, uint256 amount, bytes memory data) internal virtual returns (bool) {
600         if (!isContract(recipient)) {
601             return false;
602         }
603         bytes4 retval = IERC1363Receiver(recipient).onTransferReceived(
604             _msgSender(), sender, amount, data
605         );
606         return (retval == _ERC1363_RECEIVED);
607     }
608 
609     /**
610      * @dev Internal function to invoke `onApprovalReceived` on a target address
611      *  The call is not executed if the target address is not a contract
612      * @param spender address The address which will spend the funds
613      * @param amount uint256 The amount of tokens to be spent
614      * @param data bytes Optional data to send along with the call
615      * @return whether the call correctly returned the expected magic value
616      */
617     function _checkAndCallApprove(address spender, uint256 amount, bytes memory data) internal virtual returns (bool) {
618         if (!isContract(spender)) {
619             return false;
620         }
621         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
622             _msgSender(), amount, data
623         );
624         return (retval == _ERC1363_APPROVED);
625     }
626     
627     
628     /**
629      * @dev Returns true if `account` is a contract.
630      *
631      * [IMPORTANT]
632      * ====
633      * It is unsafe to assume that an address for which this function returns
634      * false is an externally-owned account (EOA) and not a contract.
635      *
636      * Among others, `isContract` will return false for the following
637      * types of addresses:
638      *
639      *  - an externally-owned account
640      *  - a contract in construction
641      *  - an address where a contract will be created
642      *  - an address where a contract lived, but was destroyed
643      * ====
644      */
645     function isContract(address account) internal view returns (bool) {
646         // This method relies on extcodesize, which returns 0 for contracts in
647         // construction, since the code is only stored at the end of the
648         // constructor execution.
649 
650         uint256 size;
651         // solhint-disable-next-line no-inline-assembly
652         assembly { size := extcodesize(account) }
653         return size > 0;
654     }
655     
656     /**
657      * returns msg.sender
658      */
659     function _msgSender() internal view virtual returns (address) {
660         return msg.sender;
661     }
662     
663     
664     /**
665      * returns msg.data
666      */
667     function _msgData() internal view virtual returns (bytes calldata) {
668         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
669         return msg.data;
670     }
671 }