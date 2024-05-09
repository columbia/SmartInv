1 pragma solidity 0.4.25;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13     external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18     external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21     external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Math operations with safety checks that revert on error
39  */
40 library SafeMath {
41 
42   /**
43   * @dev Multiplies two numbers, reverts on overflow.
44   */
45   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
46     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47     // benefit is lost if 'b' is also tested.
48     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
49     if (a == 0) {
50       return 0;
51     }
52 
53     uint256 c = a * b;
54     require(c / a == b);
55 
56     return c;
57   }
58 
59   /**
60   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
61   */
62   function div(uint256 a, uint256 b) internal pure returns (uint256) {
63     require(b > 0); // Solidity only automatically asserts when dividing by 0
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72   */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81   * @dev Adds two numbers, reverts on overflow.
82   */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
92   * reverts when dividing by zero.
93   */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156     return true;
157   }
158 
159   /**
160    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161    * Beware that changing an allowance with this method brings the risk that someone may use both the old
162    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165    * @param spender The address which will spend the funds.
166    * @param value The amount of tokens to be spent.
167    */
168   function approve(address spender, uint256 value) public returns (bool) {
169     require(spender != address(0));
170 
171     _allowed[msg.sender][spender] = value;
172     emit Approval(msg.sender, spender, value);
173     return true;
174   }
175 
176   /**
177    * @dev Transfer tokens from one address to another
178    * @param from address The address which you want to send tokens from
179    * @param to address The address which you want to transfer to
180    * @param value uint256 the amount of tokens to be transferred
181    */
182   function transferFrom(
183     address from,
184     address to,
185     uint256 value
186   )
187     public
188     returns (bool)
189   {
190     require(value <= _allowed[from][msg.sender]);
191 
192     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
193     _transfer(from, to, value);
194     return true;
195   }
196 
197   /**
198    * @dev Increase the amount of tokens that an owner allowed to a spender.
199    * approve should be called when allowed_[_spender] == 0. To increment
200    * allowed value is better to use this function to avoid 2 calls (and wait until
201    * the first transaction is mined)
202    * From MonolithDAO Token.sol
203    * @param spender The address which will spend the funds.
204    * @param addedValue The amount of tokens to increase the allowance by.
205    */
206   function increaseAllowance(
207     address spender,
208     uint256 addedValue
209   )
210     public
211     returns (bool)
212   {
213     require(spender != address(0));
214 
215     _allowed[msg.sender][spender] = (
216       _allowed[msg.sender][spender].add(addedValue));
217     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    * approve should be called when allowed_[_spender] == 0. To decrement
224    * allowed value is better to use this function to avoid 2 calls (and wait until
225    * the first transaction is mined)
226    * From MonolithDAO Token.sol
227    * @param spender The address which will spend the funds.
228    * @param subtractedValue The amount of tokens to decrease the allowance by.
229    */
230   function decreaseAllowance(
231     address spender,
232     uint256 subtractedValue
233   )
234     public
235     returns (bool)
236   {
237     require(spender != address(0));
238 
239     _allowed[msg.sender][spender] = (
240       _allowed[msg.sender][spender].sub(subtractedValue));
241     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
242     return true;
243   }
244 
245   /**
246   * @dev Transfer token for a specified addresses
247   * @param from The address to transfer from.
248   * @param to The address to transfer to.
249   * @param value The amount to be transferred.
250   */
251   function _transfer(address from, address to, uint256 value) internal {
252     require(value <= _balances[from]);
253     require(to != address(0));
254 
255     _balances[from] = _balances[from].sub(value);
256     _balances[to] = _balances[to].add(value);
257     emit Transfer(from, to, value);
258   }
259 
260   /**
261    * @dev Internal function that mints an amount of the token and assigns it to
262    * an account. This encapsulates the modification of balances such that the
263    * proper events are emitted.
264    * @param account The account that will receive the created tokens.
265    * @param value The amount that will be created.
266    */
267   function _mint(address account, uint256 value) internal {
268     require(account != 0);
269     _totalSupply = _totalSupply.add(value);
270     _balances[account] = _balances[account].add(value);
271     emit Transfer(address(0), account, value);
272   }
273 
274   /**
275    * @dev Internal function that burns an amount of the token of a given
276    * account.
277    * @param account The account whose tokens will be burnt.
278    * @param value The amount that will be burnt.
279    */
280   function _burn(address account, uint256 value) internal {
281     require(account != 0);
282     require(value <= _balances[account]);
283 
284     _totalSupply = _totalSupply.sub(value);
285     _balances[account] = _balances[account].sub(value);
286     emit Transfer(account, address(0), value);
287   }
288 
289   /**
290    * @dev Internal function that burns an amount of the token of a given
291    * account, deducting from the sender's allowance for said account. Uses the
292    * internal burn function.
293    * @param account The account whose tokens will be burnt.
294    * @param value The amount that will be burnt.
295    */
296   function _burnFrom(address account, uint256 value) internal {
297     require(value <= _allowed[account][msg.sender]);
298 
299     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
300     // this function needs to emit an event with the updated approval.
301     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
302       value);
303     _burn(account, value);
304   }
305 }
306 
307 /**
308  * @title Ownable
309  * @dev The Ownable contract has an owner address, and provides basic authorization control
310  * functions, this simplifies the implementation of "user permissions".
311  */
312 contract Ownable {
313   address private _owner;
314 
315   event OwnershipTransferred(
316     address indexed previousOwner,
317     address indexed newOwner
318   );
319 
320   /**
321    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
322    * account.
323    */
324   constructor() internal {
325     _owner = msg.sender;
326     emit OwnershipTransferred(address(0), _owner);
327   }
328 
329   /**
330    * @return the address of the owner.
331    */
332   function owner() public view returns(address) {
333     return _owner;
334   }
335 
336   /**
337    * @dev Throws if called by any account other than the owner.
338    */
339   modifier onlyOwner() {
340     require(isOwner());
341     _;
342   }
343 
344   /**
345    * @return true if `msg.sender` is the owner of the contract.
346    */
347   function isOwner() public view returns(bool) {
348     return msg.sender == _owner;
349   }
350 
351   /**
352    * @dev Allows the current owner to relinquish control of the contract.
353    * @notice Renouncing to ownership will leave the contract without an owner.
354    * It will not be possible to call the functions with the `onlyOwner`
355    * modifier anymore.
356    */
357   function renounceOwnership() public onlyOwner {
358     emit OwnershipTransferred(_owner, address(0));
359     _owner = address(0);
360   }
361 
362   /**
363    * @dev Allows the current owner to transfer control of the contract to a newOwner.
364    * @param newOwner The address to transfer ownership to.
365    */
366   function transferOwnership(address newOwner) public onlyOwner {
367     _transferOwnership(newOwner);
368   }
369 
370   /**
371    * @dev Transfers control of the contract to a newOwner.
372    * @param newOwner The address to transfer ownership to.
373    */
374   function _transferOwnership(address newOwner) internal {
375     require(newOwner != address(0));
376     emit OwnershipTransferred(_owner, newOwner);
377     _owner = newOwner;
378   }
379 }
380 
381 /**
382  * @title IERC165
383  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
384  */
385 interface IERC165 {
386 
387   /**
388    * @notice Query if a contract implements an interface
389    * @param interfaceId The interface identifier, as specified in ERC-165
390    * @dev Interface identification is specified in ERC-165. This function
391    * uses less than 30,000 gas.
392    */
393   function supportsInterface(bytes4 interfaceId)
394     external
395     view
396     returns (bool);
397 }
398 
399 /**
400  * @title ERC721 Non-Fungible Token Standard basic interface
401  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
402  */
403 contract IERC721 is IERC165 {
404 
405   event Transfer(
406     address indexed from,
407     address indexed to,
408     uint256 indexed tokenId
409   );
410   event Approval(
411     address indexed owner,
412     address indexed approved,
413     uint256 indexed tokenId
414   );
415   event ApprovalForAll(
416     address indexed owner,
417     address indexed operator,
418     bool approved
419   );
420 
421   function balanceOf(address owner) public view returns (uint256 balance);
422   function ownerOf(uint256 tokenId) public view returns (address owner);
423 
424   function approve(address to, uint256 tokenId) public;
425   function getApproved(uint256 tokenId)
426     public view returns (address operator);
427 
428   function setApprovalForAll(address operator, bool _approved) public;
429   function isApprovedForAll(address owner, address operator)
430     public view returns (bool);
431 
432   function transferFrom(address from, address to, uint256 tokenId) public;
433   function safeTransferFrom(address from, address to, uint256 tokenId)
434     public;
435 
436   function safeTransferFrom(
437     address from,
438     address to,
439     uint256 tokenId,
440     bytes data
441   )
442     public;
443 }
444 
445 /**
446  * @title ERC721 token receiver interface
447  * @dev Interface for any contract that wants to support safeTransfers
448  * from ERC721 asset contracts.
449  */
450 contract IERC721Receiver {
451   /**
452    * @notice Handle the receipt of an NFT
453    * @dev The ERC721 smart contract calls this function on the recipient
454    * after a `safeTransfer`. This function MUST return the function selector,
455    * otherwise the caller will revert the transaction. The selector to be
456    * returned can be obtained as `this.onERC721Received.selector`. This
457    * function MAY throw to revert and reject the transfer.
458    * Note: the ERC721 contract address is always the message sender.
459    * @param operator The address which called `safeTransferFrom` function
460    * @param from The address which previously owned the token
461    * @param tokenId The NFT identifier which is being transferred
462    * @param data Additional data with no specified format
463    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
464    */
465   function onERC721Received(
466     address operator,
467     address from,
468     uint256 tokenId,
469     bytes data
470   )
471     public
472     returns(bytes4);
473 }
474 
475 /**
476  * Utility library of inline functions on addresses
477  */
478 library Address {
479 
480   /**
481    * Returns whether the target address is a contract
482    * @dev This function will return false if invoked during the constructor of a contract,
483    * as the code is not actually created until after the constructor finishes.
484    * @param account address of the account to check
485    * @return whether the target address is a contract
486    */
487   function isContract(address account) internal view returns (bool) {
488     uint256 size;
489     // XXX Currently there is no better way to check if there is a contract in an address
490     // than to check the size of the code at that address.
491     // See https://ethereum.stackexchange.com/a/14016/36603
492     // for more details about how this works.
493     // TODO Check this again before the Serenity release, because all addresses will be
494     // contracts then.
495     // solium-disable-next-line security/no-inline-assembly
496     assembly { size := extcodesize(account) }
497     return size > 0;
498   }
499 
500 }
501 
502 /**
503  * @title ERC165
504  * @author Matt Condon (@shrugs)
505  * @dev Implements ERC165 using a lookup table.
506  */
507 contract ERC165 is IERC165 {
508 
509   bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
510   /**
511    * 0x01ffc9a7 ===
512    *   bytes4(keccak256('supportsInterface(bytes4)'))
513    */
514 
515   /**
516    * @dev a mapping of interface id to whether or not it's supported
517    */
518   mapping(bytes4 => bool) private _supportedInterfaces;
519 
520   /**
521    * @dev A contract implementing SupportsInterfaceWithLookup
522    * implement ERC165 itself
523    */
524   constructor()
525     internal
526   {
527     _registerInterface(_InterfaceId_ERC165);
528   }
529 
530   /**
531    * @dev implement supportsInterface(bytes4) using a lookup table
532    */
533   function supportsInterface(bytes4 interfaceId)
534     external
535     view
536     returns (bool)
537   {
538     return _supportedInterfaces[interfaceId];
539   }
540 
541   /**
542    * @dev internal method for registering an interface
543    */
544   function _registerInterface(bytes4 interfaceId)
545     internal
546   {
547     require(interfaceId != 0xffffffff);
548     _supportedInterfaces[interfaceId] = true;
549   }
550 }
551 
552 /**
553  * @title ERC721 Non-Fungible Token Standard basic implementation
554  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
555  */
556 contract ERC721 is ERC165, IERC721 {
557 
558   using SafeMath for uint256;
559   using Address for address;
560 
561   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
562   // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
563   bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
564 
565   // Mapping from token ID to owner
566   mapping (uint256 => address) private _tokenOwner;
567 
568   // Mapping from token ID to approved address
569   mapping (uint256 => address) private _tokenApprovals;
570 
571   // Mapping from owner to number of owned token
572   mapping (address => uint256) private _ownedTokensCount;
573 
574   // Mapping from owner to operator approvals
575   mapping (address => mapping (address => bool)) private _operatorApprovals;
576 
577   bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
578   /*
579    * 0x80ac58cd ===
580    *   bytes4(keccak256('balanceOf(address)')) ^
581    *   bytes4(keccak256('ownerOf(uint256)')) ^
582    *   bytes4(keccak256('approve(address,uint256)')) ^
583    *   bytes4(keccak256('getApproved(uint256)')) ^
584    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
585    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
586    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
587    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
588    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
589    */
590 
591   constructor()
592     public
593   {
594     // register the supported interfaces to conform to ERC721 via ERC165
595     _registerInterface(_InterfaceId_ERC721);
596   }
597 
598   /**
599    * @dev Gets the balance of the specified address
600    * @param owner address to query the balance of
601    * @return uint256 representing the amount owned by the passed address
602    */
603   function balanceOf(address owner) public view returns (uint256) {
604     require(owner != address(0));
605     return _ownedTokensCount[owner];
606   }
607 
608   /**
609    * @dev Gets the owner of the specified token ID
610    * @param tokenId uint256 ID of the token to query the owner of
611    * @return owner address currently marked as the owner of the given token ID
612    */
613   function ownerOf(uint256 tokenId) public view returns (address) {
614     address owner = _tokenOwner[tokenId];
615     require(owner != address(0));
616     return owner;
617   }
618 
619   /**
620    * @dev Approves another address to transfer the given token ID
621    * The zero address indicates there is no approved address.
622    * There can only be one approved address per token at a given time.
623    * Can only be called by the token owner or an approved operator.
624    * @param to address to be approved for the given token ID
625    * @param tokenId uint256 ID of the token to be approved
626    */
627   function approve(address to, uint256 tokenId) public {
628     address owner = ownerOf(tokenId);
629     require(to != owner);
630     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
631 
632     _tokenApprovals[tokenId] = to;
633     emit Approval(owner, to, tokenId);
634   }
635 
636   /**
637    * @dev Gets the approved address for a token ID, or zero if no address set
638    * Reverts if the token ID does not exist.
639    * @param tokenId uint256 ID of the token to query the approval of
640    * @return address currently approved for the given token ID
641    */
642   function getApproved(uint256 tokenId) public view returns (address) {
643     require(_exists(tokenId));
644     return _tokenApprovals[tokenId];
645   }
646 
647   /**
648    * @dev Sets or unsets the approval of a given operator
649    * An operator is allowed to transfer all tokens of the sender on their behalf
650    * @param to operator address to set the approval
651    * @param approved representing the status of the approval to be set
652    */
653   function setApprovalForAll(address to, bool approved) public {
654     require(to != msg.sender);
655     _operatorApprovals[msg.sender][to] = approved;
656     emit ApprovalForAll(msg.sender, to, approved);
657   }
658 
659   /**
660    * @dev Tells whether an operator is approved by a given owner
661    * @param owner owner address which you want to query the approval of
662    * @param operator operator address which you want to query the approval of
663    * @return bool whether the given operator is approved by the given owner
664    */
665   function isApprovedForAll(
666     address owner,
667     address operator
668   )
669     public
670     view
671     returns (bool)
672   {
673     return _operatorApprovals[owner][operator];
674   }
675 
676   /**
677    * @dev Transfers the ownership of a given token ID to another address
678    * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
679    * Requires the msg sender to be the owner, approved, or operator
680    * @param from current owner of the token
681    * @param to address to receive the ownership of the given token ID
682    * @param tokenId uint256 ID of the token to be transferred
683   */
684   function transferFrom(
685     address from,
686     address to,
687     uint256 tokenId
688   )
689     public
690   {
691     require(_isApprovedOrOwner(msg.sender, tokenId));
692     require(to != address(0));
693 
694     _clearApproval(from, tokenId);
695     _removeTokenFrom(from, tokenId);
696     _addTokenTo(to, tokenId);
697 
698     emit Transfer(from, to, tokenId);
699   }
700 
701   /**
702    * @dev Safely transfers the ownership of a given token ID to another address
703    * If the target address is a contract, it must implement `onERC721Received`,
704    * which is called upon a safe transfer, and return the magic value
705    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
706    * the transfer is reverted.
707    *
708    * Requires the msg sender to be the owner, approved, or operator
709    * @param from current owner of the token
710    * @param to address to receive the ownership of the given token ID
711    * @param tokenId uint256 ID of the token to be transferred
712   */
713   function safeTransferFrom(
714     address from,
715     address to,
716     uint256 tokenId
717   )
718     public
719   {
720     // solium-disable-next-line arg-overflow
721     safeTransferFrom(from, to, tokenId, "");
722   }
723 
724   /**
725    * @dev Safely transfers the ownership of a given token ID to another address
726    * If the target address is a contract, it must implement `onERC721Received`,
727    * which is called upon a safe transfer, and return the magic value
728    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
729    * the transfer is reverted.
730    * Requires the msg sender to be the owner, approved, or operator
731    * @param from current owner of the token
732    * @param to address to receive the ownership of the given token ID
733    * @param tokenId uint256 ID of the token to be transferred
734    * @param _data bytes data to send along with a safe transfer check
735    */
736   function safeTransferFrom(
737     address from,
738     address to,
739     uint256 tokenId,
740     bytes _data
741   )
742     public
743   {
744     transferFrom(from, to, tokenId);
745     // solium-disable-next-line arg-overflow
746     require(_checkOnERC721Received(from, to, tokenId, _data));
747   }
748 
749   /**
750    * @dev Returns whether the specified token exists
751    * @param tokenId uint256 ID of the token to query the existence of
752    * @return whether the token exists
753    */
754   function _exists(uint256 tokenId) internal view returns (bool) {
755     address owner = _tokenOwner[tokenId];
756     return owner != address(0);
757   }
758 
759   /**
760    * @dev Returns whether the given spender can transfer a given token ID
761    * @param spender address of the spender to query
762    * @param tokenId uint256 ID of the token to be transferred
763    * @return bool whether the msg.sender is approved for the given token ID,
764    *  is an operator of the owner, or is the owner of the token
765    */
766   function _isApprovedOrOwner(
767     address spender,
768     uint256 tokenId
769   )
770     internal
771     view
772     returns (bool)
773   {
774     address owner = ownerOf(tokenId);
775     // Disable solium check because of
776     // https://github.com/duaraghav8/Solium/issues/175
777     // solium-disable-next-line operator-whitespace
778     return (
779       spender == owner ||
780       getApproved(tokenId) == spender ||
781       isApprovedForAll(owner, spender)
782     );
783   }
784 
785   /**
786    * @dev Internal function to mint a new token
787    * Reverts if the given token ID already exists
788    * @param to The address that will own the minted token
789    * @param tokenId uint256 ID of the token to be minted by the msg.sender
790    */
791   function _mint(address to, uint256 tokenId) internal {
792     require(to != address(0));
793     _addTokenTo(to, tokenId);
794     emit Transfer(address(0), to, tokenId);
795   }
796 
797   /**
798    * @dev Internal function to burn a specific token
799    * Reverts if the token does not exist
800    * @param tokenId uint256 ID of the token being burned by the msg.sender
801    */
802   function _burn(address owner, uint256 tokenId) internal {
803     _clearApproval(owner, tokenId);
804     _removeTokenFrom(owner, tokenId);
805     emit Transfer(owner, address(0), tokenId);
806   }
807 
808   /**
809    * @dev Internal function to add a token ID to the list of a given address
810    * Note that this function is left internal to make ERC721Enumerable possible, but is not
811    * intended to be called by custom derived contracts: in particular, it emits no Transfer event.
812    * @param to address representing the new owner of the given token ID
813    * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
814    */
815   function _addTokenTo(address to, uint256 tokenId) internal {
816     require(_tokenOwner[tokenId] == address(0));
817     _tokenOwner[tokenId] = to;
818     _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
819   }
820 
821   /**
822    * @dev Internal function to remove a token ID from the list of a given address
823    * Note that this function is left internal to make ERC721Enumerable possible, but is not
824    * intended to be called by custom derived contracts: in particular, it emits no Transfer event,
825    * and doesn't clear approvals.
826    * @param from address representing the previous owner of the given token ID
827    * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
828    */
829   function _removeTokenFrom(address from, uint256 tokenId) internal {
830     require(ownerOf(tokenId) == from);
831     _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
832     _tokenOwner[tokenId] = address(0);
833   }
834 
835   /**
836    * @dev Internal function to invoke `onERC721Received` on a target address
837    * The call is not executed if the target address is not a contract
838    * @param from address representing the previous owner of the given token ID
839    * @param to target address that will receive the tokens
840    * @param tokenId uint256 ID of the token to be transferred
841    * @param _data bytes optional data to send along with the call
842    * @return whether the call correctly returned the expected magic value
843    */
844   function _checkOnERC721Received(
845     address from,
846     address to,
847     uint256 tokenId,
848     bytes _data
849   )
850     internal
851     returns (bool)
852   {
853     if (!to.isContract()) {
854       return true;
855     }
856     bytes4 retval = IERC721Receiver(to).onERC721Received(
857       msg.sender, from, tokenId, _data);
858     return (retval == _ERC721_RECEIVED);
859   }
860 
861   /**
862    * @dev Private function to clear current approval of a given token ID
863    * Reverts if the given address is not indeed the owner of the token
864    * @param owner owner of the token
865    * @param tokenId uint256 ID of the token to be transferred
866    */
867   function _clearApproval(address owner, uint256 tokenId) private {
868     require(ownerOf(tokenId) == owner);
869     if (_tokenApprovals[tokenId] != address(0)) {
870       _tokenApprovals[tokenId] = address(0);
871     }
872   }
873 }
874 
875 /**
876  * @title Roles
877  * @dev Library for managing addresses assigned to a Role.
878  */
879 library Roles {
880   struct Role {
881     mapping (address => bool) bearer;
882   }
883 
884   /**
885    * @dev give an account access to this role
886    */
887   function add(Role storage role, address account) internal {
888     require(account != address(0));
889     require(!has(role, account));
890 
891     role.bearer[account] = true;
892   }
893 
894   /**
895    * @dev remove an account's access to this role
896    */
897   function remove(Role storage role, address account) internal {
898     require(account != address(0));
899     require(has(role, account));
900 
901     role.bearer[account] = false;
902   }
903 
904   /**
905    * @dev check if an account has this role
906    * @return bool
907    */
908   function has(Role storage role, address account)
909     internal
910     view
911     returns (bool)
912   {
913     require(account != address(0));
914     return role.bearer[account];
915   }
916 }
917 
918 contract MinterRole {
919   using Roles for Roles.Role;
920 
921   event MinterAdded(address indexed account);
922   event MinterRemoved(address indexed account);
923 
924   Roles.Role private minters;
925 
926   constructor() internal {
927     _addMinter(msg.sender);
928   }
929 
930   modifier onlyMinter() {
931     require(isMinter(msg.sender));
932     _;
933   }
934 
935   function isMinter(address account) public view returns (bool) {
936     return minters.has(account);
937   }
938 
939   function addMinter(address account) public onlyMinter {
940     _addMinter(account);
941   }
942 
943   function renounceMinter() public {
944     _removeMinter(msg.sender);
945   }
946 
947   function _addMinter(address account) internal {
948     minters.add(account);
949     emit MinterAdded(account);
950   }
951 
952   function _removeMinter(address account) internal {
953     minters.remove(account);
954     emit MinterRemoved(account);
955   }
956 }
957 
958 /**
959  * @title ERC721Mintable
960  * @dev ERC721 minting logic
961  */
962 contract TokendeskToken721 is ERC721, MinterRole {
963     bool public mintingFinished = false;
964 
965     modifier canMint() {
966         require(!mintingFinished);
967         _;
968     }
969 
970     /**
971     * @dev Function to mint tokens
972     * @param to The address that will receive the minted tokens.
973     * @param tokenId The token id to mint.
974     * @return A boolean that indicates if the operation was successful.
975     */
976     function mint(address to, uint256 tokenId) public onlyMinter returns (bool) {
977         for (uint256 i = 0; i < 100; i++) {
978             if (!_exists(tokenId)) {
979                 _mint(to, tokenId);
980                 return true;
981             }
982             tokenId++;
983         }
984     }
985 }
986 
987 contract TokendeskToken is ERC20, Ownable {
988     using SafeMath for uint256;
989 
990     TokendeskToken721 public token721;
991     string public constant name = "Tokendesk Token";
992     string public constant symbol = "TDS";
993     uint8 public constant decimals = 18;
994 
995     mapping (address => uint256) private balances;
996     mapping (address => mapping (address => uint256)) internal allowed;
997 
998     event Mint(address indexed to, uint256 amount);
999     event MintFinished();
1000     event Mint721(address indexed to, uint256 tokenId);
1001 
1002     bool public mintingFinished = false;
1003     uint256 private totalSupply_;
1004 
1005     constructor(address _token721) public {
1006         token721 = TokendeskToken721(_token721);
1007     }
1008 
1009     /**
1010     * @dev total number of tokens in existence
1011     */
1012     function totalSupply() public view returns (uint256) {
1013         return totalSupply_;
1014     }
1015 
1016     /**
1017     * @dev transfer token for a specified address
1018     * @param _to The address to transfer to.
1019     * @param _value The amount to be transferred.
1020     */
1021     function transfer(address _to, uint256 _value) public returns (bool) {
1022         require(_to != address(0));
1023         require(_value <= balances[msg.sender]);
1024 
1025         // SafeMath.sub will throw if there is not enough balance.
1026         balances[msg.sender] = balances[msg.sender].sub(_value);
1027         balances[_to] = balances[_to].add(_value);
1028         emit Transfer(msg.sender, _to, _value);
1029 
1030         token721.mint(msg.sender, now);
1031         emit Mint721(msg.sender, now);
1032         return true;
1033     }
1034 
1035     /**
1036     * @dev Gets the balance of the specified address.
1037     * @param _owner The address to query the the balance of.
1038     * @return An uint256 representing the amount owned by the passed address.
1039     */
1040     function balanceOf(address _owner) public view returns (uint256 balance) {
1041         return balances[_owner];
1042     }
1043 
1044     /**
1045     * @dev Transfer tokens from one address to another
1046     * @param _from address The address which you want to send tokens from
1047     * @param _to address The address which you want to transfer to
1048     * @param _value uint256 the amount of tokens to be transferred
1049     */
1050     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1051         require(_to != address(0));
1052         require(_value <= balances[_from]);
1053         require(_value <= allowed[_from][msg.sender]);
1054 
1055         balances[_from] = balances[_from].sub(_value);
1056         balances[_to] = balances[_to].add(_value);
1057         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1058         emit Transfer(_from, _to, _value);
1059         return true;
1060     }
1061 
1062     /**
1063     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1064     *
1065     * Beware that changing an allowance with this method brings the risk that someone may use both the old
1066     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1067     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1068     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1069     * @param _spender The address which will spend the funds.
1070     * @param _value The amount of tokens to be spent.
1071     */
1072     function approve(address _spender, uint256 _value) public returns (bool) {
1073         allowed[msg.sender][_spender] = _value;
1074         emit Approval(msg.sender, _spender, _value);
1075         return true;
1076     }
1077 
1078     /**
1079     * @dev Function to check the amount of tokens that an owner allowed to a spender.
1080     * @param _owner address The address which owns the funds.
1081     * @param _spender address The address which will spend the funds.
1082     * @return A uint256 specifying the amount of tokens still available for the spender.
1083     */
1084     function allowance(address _owner, address _spender) public view returns (uint256) {
1085         return allowed[_owner][_spender];
1086     }
1087 
1088     /**
1089     * @dev Increase the amount of tokens that an owner allowed to a spender.
1090     *
1091     * approve should be called when allowed[_spender] == 0. To increment
1092     * allowed value is better to use this function to avoid 2 calls (and wait until
1093     * the first transaction is mined)
1094     * From MonolithDAO Token.sol
1095     * @param _spender The address which will spend the funds.
1096     * @param _addedValue The amount of tokens to increase the allowance by.
1097     */
1098     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
1099         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1100         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1101         return true;
1102     }
1103 
1104     /**
1105     * @dev Decrease the amount of tokens that an owner allowed to a spender.
1106     *
1107     * approve should be called when allowed[_spender] == 0. To decrement
1108     * allowed value is better to use this function to avoid 2 calls (and wait until
1109     * the first transaction is mined)
1110     * From MonolithDAO Token.sol
1111     * @param _spender The address which will spend the funds.
1112     * @param _subtractedValue The amount of tokens to decrease the allowance by.
1113     */
1114     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
1115         uint oldValue = allowed[msg.sender][_spender];
1116         if (_subtractedValue > oldValue) {
1117             allowed[msg.sender][_spender] = 0;
1118         } else {
1119             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1120         }
1121         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1122         return true;
1123     }
1124 
1125     modifier canMint() {
1126         require(!mintingFinished);
1127         _;
1128     }
1129 
1130     /**
1131     * @dev Function to mint tokens
1132     * @param _to The address that will receive the minted tokens.
1133     * @param _amount The amount of tokens to mint.
1134     * @return A boolean that indicates if the operation was successful.
1135     */
1136     function mint(address _to, uint256 _amount) public onlyOwner returns (bool) {
1137         totalSupply_ = totalSupply_.add(_amount);
1138         balances[_to] = balances[_to].add(_amount);
1139         return true;
1140     }
1141 
1142     function mintTokens(address[] _receivers, uint256[] _amounts) onlyOwner canMint external  {
1143         require(_receivers.length > 0 && _receivers.length <= 100);
1144         require(_receivers.length == _amounts.length);
1145         for (uint256 i = 0; i < _receivers.length; i++) {
1146             address receiver = _receivers[i];
1147             uint256 amount = _amounts[i];
1148 
1149             require(receiver != address(0));
1150             require(amount > 0);
1151 
1152             mint(receiver, amount);
1153             emit Mint(receiver, amount);
1154             emit Transfer(address(0), receiver, amount);
1155         }
1156     }
1157 
1158     /**
1159     * @dev Function to stop minting new tokens.
1160     * @return True if the operation was successful.
1161     */
1162     function finishMinting() public onlyOwner canMint returns (bool) {
1163         mintingFinished = true;
1164         emit MintFinished();
1165         return true;
1166     }
1167 }