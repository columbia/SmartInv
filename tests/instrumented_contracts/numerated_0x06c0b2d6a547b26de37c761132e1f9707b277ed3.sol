1 pragma solidity 0.4.21;
2 
3 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: zeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     if (a == 0) {
30       return 0;
31     }
32     c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     // uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return a / b;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59     c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
112 
113 /**
114  * @title ERC20 interface
115  * @dev see https://github.com/ethereum/EIPs/issues/20
116  */
117 contract ERC20 is ERC20Basic {
118   function allowance(address owner, address spender) public view returns (uint256);
119   function transferFrom(address from, address to, uint256 value) public returns (bool);
120   function approve(address spender, uint256 value) public returns (bool);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 }
123 
124 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
125 
126 /**
127  * @title Standard ERC20 token
128  *
129  * @dev Implementation of the basic standard token.
130  * @dev https://github.com/ethereum/EIPs/issues/20
131  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135   mapping (address => mapping (address => uint256)) internal allowed;
136 
137 
138   /**
139    * @dev Transfer tokens from one address to another
140    * @param _from address The address which you want to send tokens from
141    * @param _to address The address which you want to transfer to
142    * @param _value uint256 the amount of tokens to be transferred
143    */
144   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
145     require(_to != address(0));
146     require(_value <= balances[_from]);
147     require(_value <= allowed[_from][msg.sender]);
148 
149     balances[_from] = balances[_from].sub(_value);
150     balances[_to] = balances[_to].add(_value);
151     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
152     emit Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    *
159    * Beware that changing an allowance with this method brings the risk that someone may use both the old
160    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
161    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
162    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163    * @param _spender The address which will spend the funds.
164    * @param _value The amount of tokens to be spent.
165    */
166   function approve(address _spender, uint256 _value) public returns (bool) {
167     allowed[msg.sender][_spender] = _value;
168     emit Approval(msg.sender, _spender, _value);
169     return true;
170   }
171 
172   /**
173    * @dev Function to check the amount of tokens that an owner allowed to a spender.
174    * @param _owner address The address which owns the funds.
175    * @param _spender address The address which will spend the funds.
176    * @return A uint256 specifying the amount of tokens still available for the spender.
177    */
178   function allowance(address _owner, address _spender) public view returns (uint256) {
179     return allowed[_owner][_spender];
180   }
181 
182   /**
183    * @dev Increase the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To increment
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _addedValue The amount of tokens to increase the allowance by.
191    */
192   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
193     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
194     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
195     return true;
196   }
197 
198   /**
199    * @dev Decrease the amount of tokens that an owner allowed to a spender.
200    *
201    * approve should be called when allowed[_spender] == 0. To decrement
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param _spender The address which will spend the funds.
206    * @param _subtractedValue The amount of tokens to decrease the allowance by.
207    */
208   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
209     uint oldValue = allowed[msg.sender][_spender];
210     if (_subtractedValue > oldValue) {
211       allowed[msg.sender][_spender] = 0;
212     } else {
213       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
214     }
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219 }
220 
221 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address newOwner) public onlyOwner {
256     require(newOwner != address(0));
257     emit OwnershipTransferred(owner, newOwner);
258     owner = newOwner;
259   }
260 
261 }
262 
263 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
264 
265 /**
266  * @title ERC721 Non-Fungible Token Standard basic interface
267  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
268  */
269 contract ERC721Basic {
270   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
271   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
272   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
273 
274   function balanceOf(address _owner) public view returns (uint256 _balance);
275   function ownerOf(uint256 _tokenId) public view returns (address _owner);
276   function exists(uint256 _tokenId) public view returns (bool _exists);
277 
278   function approve(address _to, uint256 _tokenId) public;
279   function getApproved(uint256 _tokenId) public view returns (address _operator);
280 
281   function setApprovalForAll(address _operator, bool _approved) public;
282   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
283 
284   function transferFrom(address _from, address _to, uint256 _tokenId) public;
285   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
286   function safeTransferFrom(
287     address _from,
288     address _to,
289     uint256 _tokenId,
290     bytes _data
291   )
292     public;
293 }
294 
295 // File: zeppelin-solidity/contracts/token/ERC721/ERC721.sol
296 
297 /**
298  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
299  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
300  */
301 contract ERC721Enumerable is ERC721Basic {
302   function totalSupply() public view returns (uint256);
303   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
304   function tokenByIndex(uint256 _index) public view returns (uint256);
305 }
306 
307 
308 /**
309  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
310  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
311  */
312 contract ERC721Metadata is ERC721Basic {
313   function name() public view returns (string _name);
314   function symbol() public view returns (string _symbol);
315   function tokenURI(uint256 _tokenId) public view returns (string);
316 }
317 
318 
319 /**
320  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
321  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
322  */
323 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
324 }
325 
326 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
327 
328 /**
329  * @title ERC721 token receiver interface
330  * @dev Interface for any contract that wants to support safeTransfers
331  *  from ERC721 asset contracts.
332  */
333 contract ERC721Receiver {
334   /**
335    * @dev Magic value to be returned upon successful reception of an NFT
336    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
337    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
338    */
339   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
340 
341   /**
342    * @notice Handle the receipt of an NFT
343    * @dev The ERC721 smart contract calls this function on the recipient
344    *  after a `safetransfer`. This function MAY throw to revert and reject the
345    *  transfer. This function MUST use 50,000 gas or less. Return of other
346    *  than the magic value MUST result in the transaction being reverted.
347    *  Note: the contract address is always the message sender.
348    * @param _from The sending address
349    * @param _tokenId The NFT identifier which is being transfered
350    * @param _data Additional data with no specified format
351    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
352    */
353   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
354 }
355 
356 // File: zeppelin-solidity/contracts/AddressUtils.sol
357 
358 /**
359  * Utility library of inline functions on addresses
360  */
361 library AddressUtils {
362 
363   /**
364    * Returns whether the target address is a contract
365    * @dev This function will return false if invoked during the constructor of a contract,
366    *  as the code is not actually created until after the constructor finishes.
367    * @param addr address to check
368    * @return whether the target address is a contract
369    */
370   function isContract(address addr) internal view returns (bool) {
371     uint256 size;
372     // XXX Currently there is no better way to check if there is a contract in an address
373     // than to check the size of the code at that address.
374     // See https://ethereum.stackexchange.com/a/14016/36603
375     // for more details about how this works.
376     // TODO Check this again before the Serenity release, because all addresses will be
377     // contracts then.
378     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
379     return size > 0;
380   }
381 
382 }
383 
384 // File: zeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
385 
386 /**
387  * @title ERC721 Non-Fungible Token Standard basic implementation
388  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
389  */
390 contract ERC721BasicToken is ERC721Basic {
391   using SafeMath for uint256;
392   using AddressUtils for address;
393 
394   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
395   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
396   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
397 
398   // Mapping from token ID to owner
399   mapping (uint256 => address) internal tokenOwner;
400 
401   // Mapping from token ID to approved address
402   mapping (uint256 => address) internal tokenApprovals;
403 
404   // Mapping from owner to number of owned token
405   mapping (address => uint256) internal ownedTokensCount;
406 
407   // Mapping from owner to operator approvals
408   mapping (address => mapping (address => bool)) internal operatorApprovals;
409 
410   /**
411    * @dev Guarantees msg.sender is owner of the given token
412    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
413    */
414   modifier onlyOwnerOf(uint256 _tokenId) {
415     require(ownerOf(_tokenId) == msg.sender);
416     _;
417   }
418 
419   /**
420    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
421    * @param _tokenId uint256 ID of the token to validate
422    */
423   modifier canTransfer(uint256 _tokenId) {
424     require(isApprovedOrOwner(msg.sender, _tokenId));
425     _;
426   }
427 
428   /**
429    * @dev Gets the balance of the specified address
430    * @param _owner address to query the balance of
431    * @return uint256 representing the amount owned by the passed address
432    */
433   function balanceOf(address _owner) public view returns (uint256) {
434     require(_owner != address(0));
435     return ownedTokensCount[_owner];
436   }
437 
438   /**
439    * @dev Gets the owner of the specified token ID
440    * @param _tokenId uint256 ID of the token to query the owner of
441    * @return owner address currently marked as the owner of the given token ID
442    */
443   function ownerOf(uint256 _tokenId) public view returns (address) {
444     address owner = tokenOwner[_tokenId];
445     require(owner != address(0));
446     return owner;
447   }
448 
449   /**
450    * @dev Returns whether the specified token exists
451    * @param _tokenId uint256 ID of the token to query the existance of
452    * @return whether the token exists
453    */
454   function exists(uint256 _tokenId) public view returns (bool) {
455     address owner = tokenOwner[_tokenId];
456     return owner != address(0);
457   }
458 
459   /**
460    * @dev Approves another address to transfer the given token ID
461    * @dev The zero address indicates there is no approved address.
462    * @dev There can only be one approved address per token at a given time.
463    * @dev Can only be called by the token owner or an approved operator.
464    * @param _to address to be approved for the given token ID
465    * @param _tokenId uint256 ID of the token to be approved
466    */
467   function approve(address _to, uint256 _tokenId) public {
468     address owner = ownerOf(_tokenId);
469     require(_to != owner);
470     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
471 
472     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
473       tokenApprovals[_tokenId] = _to;
474       emit Approval(owner, _to, _tokenId);
475     }
476   }
477 
478   /**
479    * @dev Gets the approved address for a token ID, or zero if no address set
480    * @param _tokenId uint256 ID of the token to query the approval of
481    * @return address currently approved for a the given token ID
482    */
483   function getApproved(uint256 _tokenId) public view returns (address) {
484     return tokenApprovals[_tokenId];
485   }
486 
487   /**
488    * @dev Sets or unsets the approval of a given operator
489    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
490    * @param _to operator address to set the approval
491    * @param _approved representing the status of the approval to be set
492    */
493   function setApprovalForAll(address _to, bool _approved) public {
494     require(_to != msg.sender);
495     operatorApprovals[msg.sender][_to] = _approved;
496     emit ApprovalForAll(msg.sender, _to, _approved);
497   }
498 
499   /**
500    * @dev Tells whether an operator is approved by a given owner
501    * @param _owner owner address which you want to query the approval of
502    * @param _operator operator address which you want to query the approval of
503    * @return bool whether the given operator is approved by the given owner
504    */
505   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
506     return operatorApprovals[_owner][_operator];
507   }
508 
509   /**
510    * @dev Transfers the ownership of a given token ID to another address
511    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
512    * @dev Requires the msg sender to be the owner, approved, or operator
513    * @param _from current owner of the token
514    * @param _to address to receive the ownership of the given token ID
515    * @param _tokenId uint256 ID of the token to be transferred
516   */
517   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
518     require(_from != address(0));
519     require(_to != address(0));
520 
521     clearApproval(_from, _tokenId);
522     removeTokenFrom(_from, _tokenId);
523     addTokenTo(_to, _tokenId);
524 
525     emit Transfer(_from, _to, _tokenId);
526   }
527 
528   /**
529    * @dev Safely transfers the ownership of a given token ID to another address
530    * @dev If the target address is a contract, it must implement `onERC721Received`,
531    *  which is called upon a safe transfer, and return the magic value
532    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
533    *  the transfer is reverted.
534    * @dev Requires the msg sender to be the owner, approved, or operator
535    * @param _from current owner of the token
536    * @param _to address to receive the ownership of the given token ID
537    * @param _tokenId uint256 ID of the token to be transferred
538   */
539   function safeTransferFrom(
540     address _from,
541     address _to,
542     uint256 _tokenId
543   )
544     public
545     canTransfer(_tokenId)
546   {
547     // solium-disable-next-line arg-overflow
548     safeTransferFrom(_from, _to, _tokenId, "");
549   }
550 
551   /**
552    * @dev Safely transfers the ownership of a given token ID to another address
553    * @dev If the target address is a contract, it must implement `onERC721Received`,
554    *  which is called upon a safe transfer, and return the magic value
555    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
556    *  the transfer is reverted.
557    * @dev Requires the msg sender to be the owner, approved, or operator
558    * @param _from current owner of the token
559    * @param _to address to receive the ownership of the given token ID
560    * @param _tokenId uint256 ID of the token to be transferred
561    * @param _data bytes data to send along with a safe transfer check
562    */
563   function safeTransferFrom(
564     address _from,
565     address _to,
566     uint256 _tokenId,
567     bytes _data
568   )
569     public
570     canTransfer(_tokenId)
571   {
572     transferFrom(_from, _to, _tokenId);
573     // solium-disable-next-line arg-overflow
574     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
575   }
576 
577   /**
578    * @dev Returns whether the given spender can transfer a given token ID
579    * @param _spender address of the spender to query
580    * @param _tokenId uint256 ID of the token to be transferred
581    * @return bool whether the msg.sender is approved for the given token ID,
582    *  is an operator of the owner, or is the owner of the token
583    */
584   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
585     address owner = ownerOf(_tokenId);
586     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
587   }
588 
589   /**
590    * @dev Internal function to mint a new token
591    * @dev Reverts if the given token ID already exists
592    * @param _to The address that will own the minted token
593    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
594    */
595   function _mint(address _to, uint256 _tokenId) internal {
596     require(_to != address(0));
597     addTokenTo(_to, _tokenId);
598     emit Transfer(address(0), _to, _tokenId);
599   }
600 
601   /**
602    * @dev Internal function to burn a specific token
603    * @dev Reverts if the token does not exist
604    * @param _tokenId uint256 ID of the token being burned by the msg.sender
605    */
606   function _burn(address _owner, uint256 _tokenId) internal {
607     clearApproval(_owner, _tokenId);
608     removeTokenFrom(_owner, _tokenId);
609     emit Transfer(_owner, address(0), _tokenId);
610   }
611 
612   /**
613    * @dev Internal function to clear current approval of a given token ID
614    * @dev Reverts if the given address is not indeed the owner of the token
615    * @param _owner owner of the token
616    * @param _tokenId uint256 ID of the token to be transferred
617    */
618   function clearApproval(address _owner, uint256 _tokenId) internal {
619     require(ownerOf(_tokenId) == _owner);
620     if (tokenApprovals[_tokenId] != address(0)) {
621       tokenApprovals[_tokenId] = address(0);
622       emit Approval(_owner, address(0), _tokenId);
623     }
624   }
625 
626   /**
627    * @dev Internal function to add a token ID to the list of a given address
628    * @param _to address representing the new owner of the given token ID
629    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
630    */
631   function addTokenTo(address _to, uint256 _tokenId) internal {
632     require(tokenOwner[_tokenId] == address(0));
633     tokenOwner[_tokenId] = _to;
634     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
635   }
636 
637   /**
638    * @dev Internal function to remove a token ID from the list of a given address
639    * @param _from address representing the previous owner of the given token ID
640    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
641    */
642   function removeTokenFrom(address _from, uint256 _tokenId) internal {
643     require(ownerOf(_tokenId) == _from);
644     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
645     tokenOwner[_tokenId] = address(0);
646   }
647 
648   /**
649    * @dev Internal function to invoke `onERC721Received` on a target address
650    * @dev The call is not executed if the target address is not a contract
651    * @param _from address representing the previous owner of the given token ID
652    * @param _to target address that will receive the tokens
653    * @param _tokenId uint256 ID of the token to be transferred
654    * @param _data bytes optional data to send along with the call
655    * @return whether the call correctly returned the expected magic value
656    */
657   function checkAndCallSafeTransfer(
658     address _from,
659     address _to,
660     uint256 _tokenId,
661     bytes _data
662   )
663     internal
664     returns (bool)
665   {
666     if (!_to.isContract()) {
667       return true;
668     }
669     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
670     return (retval == ERC721_RECEIVED);
671   }
672 }
673 
674 // File: zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
675 
676 /**
677  * @title Full ERC721 Token
678  * This implementation includes all the required and some optional functionality of the ERC721 standard
679  * Moreover, it includes approve all functionality using operator terminology
680  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
681  */
682 contract ERC721Token is ERC721, ERC721BasicToken {
683   // Token name
684   string internal name_;
685 
686   // Token symbol
687   string internal symbol_;
688 
689   // Mapping from owner to list of owned token IDs
690   mapping (address => uint256[]) internal ownedTokens;
691 
692   // Mapping from token ID to index of the owner tokens list
693   mapping(uint256 => uint256) internal ownedTokensIndex;
694 
695   // Array with all token ids, used for enumeration
696   uint256[] internal allTokens;
697 
698   // Mapping from token id to position in the allTokens array
699   mapping(uint256 => uint256) internal allTokensIndex;
700 
701   // Optional mapping for token URIs
702   mapping(uint256 => string) internal tokenURIs;
703 
704   /**
705    * @dev Constructor function
706    */
707   function ERC721Token(string _name, string _symbol) public {
708     name_ = _name;
709     symbol_ = _symbol;
710   }
711 
712   /**
713    * @dev Gets the token name
714    * @return string representing the token name
715    */
716   function name() public view returns (string) {
717     return name_;
718   }
719 
720   /**
721    * @dev Gets the token symbol
722    * @return string representing the token symbol
723    */
724   function symbol() public view returns (string) {
725     return symbol_;
726   }
727 
728   /**
729    * @dev Returns an URI for a given token ID
730    * @dev Throws if the token ID does not exist. May return an empty string.
731    * @param _tokenId uint256 ID of the token to query
732    */
733   function tokenURI(uint256 _tokenId) public view returns (string) {
734     require(exists(_tokenId));
735     return tokenURIs[_tokenId];
736   }
737 
738   /**
739    * @dev Gets the token ID at a given index of the tokens list of the requested owner
740    * @param _owner address owning the tokens list to be accessed
741    * @param _index uint256 representing the index to be accessed of the requested tokens list
742    * @return uint256 token ID at the given index of the tokens list owned by the requested address
743    */
744   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
745     require(_index < balanceOf(_owner));
746     return ownedTokens[_owner][_index];
747   }
748 
749   /**
750    * @dev Gets the total amount of tokens stored by the contract
751    * @return uint256 representing the total amount of tokens
752    */
753   function totalSupply() public view returns (uint256) {
754     return allTokens.length;
755   }
756 
757   /**
758    * @dev Gets the token ID at a given index of all the tokens in this contract
759    * @dev Reverts if the index is greater or equal to the total number of tokens
760    * @param _index uint256 representing the index to be accessed of the tokens list
761    * @return uint256 token ID at the given index of the tokens list
762    */
763   function tokenByIndex(uint256 _index) public view returns (uint256) {
764     require(_index < totalSupply());
765     return allTokens[_index];
766   }
767 
768   /**
769    * @dev Internal function to set the token URI for a given token
770    * @dev Reverts if the token ID does not exist
771    * @param _tokenId uint256 ID of the token to set its URI
772    * @param _uri string URI to assign
773    */
774   function _setTokenURI(uint256 _tokenId, string _uri) internal {
775     require(exists(_tokenId));
776     tokenURIs[_tokenId] = _uri;
777   }
778 
779   /**
780    * @dev Internal function to add a token ID to the list of a given address
781    * @param _to address representing the new owner of the given token ID
782    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
783    */
784   function addTokenTo(address _to, uint256 _tokenId) internal {
785     super.addTokenTo(_to, _tokenId);
786     uint256 length = ownedTokens[_to].length;
787     ownedTokens[_to].push(_tokenId);
788     ownedTokensIndex[_tokenId] = length;
789   }
790 
791   /**
792    * @dev Internal function to remove a token ID from the list of a given address
793    * @param _from address representing the previous owner of the given token ID
794    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
795    */
796   function removeTokenFrom(address _from, uint256 _tokenId) internal {
797     super.removeTokenFrom(_from, _tokenId);
798 
799     uint256 tokenIndex = ownedTokensIndex[_tokenId];
800     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
801     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
802 
803     ownedTokens[_from][tokenIndex] = lastToken;
804     ownedTokens[_from][lastTokenIndex] = 0;
805     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
806     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
807     // the lastToken to the first position, and then dropping the element placed in the last position of the list
808 
809     ownedTokens[_from].length--;
810     ownedTokensIndex[_tokenId] = 0;
811     ownedTokensIndex[lastToken] = tokenIndex;
812   }
813 
814   /**
815    * @dev Internal function to mint a new token
816    * @dev Reverts if the given token ID already exists
817    * @param _to address the beneficiary that will own the minted token
818    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
819    */
820   function _mint(address _to, uint256 _tokenId) internal {
821     super._mint(_to, _tokenId);
822 
823     allTokensIndex[_tokenId] = allTokens.length;
824     allTokens.push(_tokenId);
825   }
826 
827   /**
828    * @dev Internal function to burn a specific token
829    * @dev Reverts if the token does not exist
830    * @param _owner owner of the token to burn
831    * @param _tokenId uint256 ID of the token being burned by the msg.sender
832    */
833   function _burn(address _owner, uint256 _tokenId) internal {
834     super._burn(_owner, _tokenId);
835 
836     // Clear metadata (if any)
837     if (bytes(tokenURIs[_tokenId]).length != 0) {
838       delete tokenURIs[_tokenId];
839     }
840 
841     // Reorg all tokens array
842     uint256 tokenIndex = allTokensIndex[_tokenId];
843     uint256 lastTokenIndex = allTokens.length.sub(1);
844     uint256 lastToken = allTokens[lastTokenIndex];
845 
846     allTokens[tokenIndex] = lastToken;
847     allTokens[lastTokenIndex] = 0;
848 
849     allTokens.length--;
850     allTokensIndex[_tokenId] = 0;
851     allTokensIndex[lastToken] = tokenIndex;
852   }
853 
854 }
855 
856 // File: contracts/IWasFirstServiceToken.sol
857 
858 contract IWasFirstServiceToken is StandardToken, Ownable {
859 
860     string public constant NAME = "IWasFirstServiceToken"; // solium-disable-line uppercase
861     string public constant SYMBOL = "IWF"; // solium-disable-line uppercase
862     uint8 public constant DECIMALS = 18; // solium-disable-line uppercase
863 
864     uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(DECIMALS));
865     address fungibleTokenAddress;
866     address shareTokenAddress;
867 
868     /**
869      * @dev Constructor that gives msg.sender all of existing tokens.
870      */
871     function IWasFirstServiceToken() public {
872         totalSupply_ = INITIAL_SUPPLY;
873         balances[msg.sender] = INITIAL_SUPPLY;
874        emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
875     }
876 
877     function getFungibleTokenAddress() public view returns (address) {
878         return fungibleTokenAddress;
879     }
880 
881     function setFungibleTokenAddress(address _address) onlyOwner() public {
882         require(fungibleTokenAddress == address(0));
883         fungibleTokenAddress = _address;
884     }
885 
886     function getShareTokenAddress() public view returns (address) {
887         return shareTokenAddress;
888     }
889 
890     function setShareTokenAddress(address _address) onlyOwner() public {
891         require(shareTokenAddress == address(0));
892         shareTokenAddress = _address;
893     }
894 
895     function transferByRelatedToken(address _from, address _to, uint256 _value) public returns (bool) {
896         require(msg.sender == fungibleTokenAddress || msg.sender == shareTokenAddress);
897         require(_to != address(0));
898         require(_value <= balances[_from]);
899 
900         balances[_from] = balances[_from].sub(_value);
901         balances[_to] = balances[_to].add(_value);
902         emit Transfer(_from, _to, _value);
903         return true;
904     }
905 }
906 
907 // File: contracts/IWasFirstFungibleToken.sol
908 
909 contract IWasFirstFungibleToken is ERC721Token("IWasFirstFungible", "IWX"), Ownable {
910 
911     struct TokenMetaData {
912         uint creationTime;
913         string creatorMetadataJson;
914     }
915     address _serviceTokenAddress;
916     address _shareTokenAddress;
917     mapping (uint256 => string) internal tokenHash;
918     mapping (string => uint256) internal tokenIdOfHash;
919     uint256 internal tokenIdSeq = 1;
920     mapping (uint256 => TokenMetaData[]) internal tokenMetaData;
921     
922     function hashExists(string hash) public view returns (bool) {
923         return tokenIdOfHash[hash] != 0;
924     }
925 
926     function mint(string hash, string creatorMetadataJson) external {
927         require(!hashExists(hash));
928         uint256 currentTokenId = tokenIdSeq;
929         tokenIdSeq = tokenIdSeq + 1;
930         IWasFirstServiceToken serviceToken = IWasFirstServiceToken(_serviceTokenAddress);
931         serviceToken.transferByRelatedToken(msg.sender, _shareTokenAddress, 10 ** uint256(serviceToken.DECIMALS()));
932         tokenHash[currentTokenId] = hash;
933         tokenIdOfHash[hash] = currentTokenId;
934         tokenMetaData[currentTokenId].push(TokenMetaData(now, creatorMetadataJson));
935         super._mint(msg.sender, currentTokenId);
936     }
937 
938     function getTokenCreationTime(string hash) public view returns(uint) {
939         require(hashExists(hash));
940         uint length = tokenMetaData[tokenIdOfHash[hash]].length;
941         return tokenMetaData[tokenIdOfHash[hash]][length-1].creationTime;
942     }
943 
944     function getCreatorMetadata(string hash) public view returns(string) {
945         require(hashExists(hash));
946         uint length = tokenMetaData[tokenIdOfHash[hash]].length;
947         return tokenMetaData[tokenIdOfHash[hash]][length-1].creatorMetadataJson;
948     }
949 
950     function getMetadataHistoryLength(string hash) public view returns(uint) {
951         if(hashExists(hash)) {
952             return tokenMetaData[tokenIdOfHash[hash]].length;
953         } else {
954             return 0;
955         }
956     }
957 
958     function getCreationDateOfHistoricalMetadata(string hash, uint index) public view returns(uint) {
959         require(hashExists(hash));
960         return tokenMetaData[tokenIdOfHash[hash]][index].creationTime;
961     }
962 
963     function getCreatorMetadataOfHistoricalMetadata(string hash, uint index) public view returns(string) {
964         require(hashExists(hash));
965         return tokenMetaData[tokenIdOfHash[hash]][index].creatorMetadataJson;
966     }
967 
968     function updateMetadata(string hash, string creatorMetadataJson) public {
969         require(hashExists(hash));
970         require(ownerOf(tokenIdOfHash[hash]) == msg.sender);
971         tokenMetaData[tokenIdOfHash[hash]].push(TokenMetaData(now, creatorMetadataJson));
972     }
973 
974     function getTokenIdByHash(string hash) public view returns(uint256) {
975         require(hashExists(hash));
976         return tokenIdOfHash[hash];
977     }
978 
979     function getHashByTokenId(uint256 tokenId) public view returns(string) {
980         require(exists(tokenId));
981         return tokenHash[tokenId];
982     }
983 
984     function getNumberOfTokens() public view returns(uint) {
985         return allTokens.length;
986     }
987 
988     function setServiceTokenAddress(address serviceTokenAdress) onlyOwner() public {
989         require(_serviceTokenAddress == address(0));
990         _serviceTokenAddress = serviceTokenAdress;
991     }
992 
993     function getServiceTokenAddress() public view returns(address) {
994         return _serviceTokenAddress;
995     }
996 
997     function setShareTokenAddress(address shareTokenAdress) onlyOwner() public {
998         require(_shareTokenAddress == address(0));
999         _shareTokenAddress = shareTokenAdress;
1000     }
1001 
1002     function getShareTokenAddress() public view returns(address) {
1003         return _shareTokenAddress;
1004     }
1005 }
1006 
1007 // File: contracts/IWasFirstShareToken.sol
1008 
1009 contract IWasFirstShareToken is StandardToken, Ownable{
1010 
1011     struct TxState {
1012         uint256 numOfServiceTokenWei;
1013         uint256 userBalance;
1014     }
1015 
1016     string public constant NAME = "IWasFirstShareToken"; // solium-disable-line uppercase
1017     string public constant SYMBOL = "XWF"; // solium-disable-line uppercase
1018     uint8 public constant DECIMALS = 12; // solium-disable-line uppercase
1019 
1020     uint256 public constant INITIAL_SUPPLY = 100000 * (10 ** uint256(DECIMALS));
1021     address fungibleTokenAddress;
1022     address _serviceTokenAddress;
1023     mapping (address => TxState[]) internal txStates;
1024     event Withdraw(address to, uint256 value);
1025 
1026 	function IWasFirstShareToken() public {
1027 		totalSupply_ = INITIAL_SUPPLY;
1028 		balances[msg.sender] = INITIAL_SUPPLY;
1029         txStates[msg.sender].push(TxState(0, INITIAL_SUPPLY));
1030 		emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
1031 	}
1032     function getFungibleTokenAddress() public view returns (address) {
1033         return fungibleTokenAddress;
1034     }
1035 
1036     function setFungibleTokenAddress(address _address) onlyOwner() public {
1037         require(fungibleTokenAddress == address(0));
1038         fungibleTokenAddress = _address;
1039     }
1040 
1041     function setServiceTokenAddress(address serviceTokenAdress) onlyOwner() public {
1042         require(_serviceTokenAddress == address(0));
1043         _serviceTokenAddress = serviceTokenAdress;
1044     }
1045 
1046     function getServiceTokenAddress() public view returns(address) {
1047         return _serviceTokenAddress;
1048     }
1049 
1050     function transfer(address _to, uint256 _value) public returns (bool) {
1051         super.transfer(_to, _value);
1052         uint serviceTokenWei = this.getCurrentNumberOfUsedServiceTokenWei();
1053         txStates[msg.sender].push(TxState(serviceTokenWei, balances[msg.sender]));
1054         txStates[_to].push(TxState(serviceTokenWei, balances[_to]));
1055         return true;
1056     }
1057 
1058     function getWithdrawAmount(address _address) public view returns(uint256) {
1059         TxState[] storage states = txStates[_address];
1060         uint256 withdrawAmount = 0;
1061         if(states.length == 0) {
1062             return 0;
1063         }
1064         for(uint i=0; i < states.length-1; i++) {
1065            withdrawAmount += (states[i+1].numOfServiceTokenWei - states[i].numOfServiceTokenWei)*states[i].userBalance/INITIAL_SUPPLY;
1066         }
1067         withdrawAmount += (this.getCurrentNumberOfUsedServiceTokenWei() - states[states.length-1].numOfServiceTokenWei)*states[states.length-1].userBalance/INITIAL_SUPPLY;
1068         return withdrawAmount;
1069     }
1070 
1071     function withdraw() external {
1072         uint256 _value = getWithdrawAmount(msg.sender);
1073         IWasFirstServiceToken serviceToken = IWasFirstServiceToken(_serviceTokenAddress);
1074         require(_value <= serviceToken.balanceOf(address(this)));
1075         
1076         delete txStates[msg.sender];
1077         serviceToken.transferByRelatedToken(address(this), msg.sender, _value);
1078 
1079         emit Withdraw(msg.sender, _value);
1080     }
1081 
1082     function getCurrentNumberOfUsedServiceTokenWei() external view returns(uint) {
1083         IWasFirstFungibleToken fToken = IWasFirstFungibleToken(fungibleTokenAddress);
1084         return fToken.getNumberOfTokens()*(10**18);
1085     }
1086 }