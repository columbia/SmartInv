1 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20Basic.sol
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\ERC20.sol
19 
20 pragma solidity ^0.4.21;
21 
22 
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender) public view returns (uint256);
30   function transferFrom(address from, address to, uint256 value) public returns (bool);
31   function approve(address spender, uint256 value) public returns (bool);
32   event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\SafeERC20.sol
36 
37 pragma solidity ^0.4.21;
38 
39 
40 
41 
42 /**
43  * @title SafeERC20
44  * @dev Wrappers around ERC20 operations that throw on failure.
45  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
46  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
47  */
48 library SafeERC20 {
49   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
50     assert(token.transfer(to, value));
51   }
52 
53   function safeTransferFrom(
54     ERC20 token,
55     address from,
56     address to,
57     uint256 value
58   )
59     internal
60   {
61     assert(token.transferFrom(from, to, value));
62   }
63 
64   function safeApprove(ERC20 token, address spender, uint256 value) internal {
65     assert(token.approve(spender, value));
66   }
67 }
68 
69 // File: node_modules\openzeppelin-solidity\contracts\math\SafeMath.sol
70 
71 pragma solidity ^0.4.21;
72 
73 
74 /**
75  * @title SafeMath
76  * @dev Math operations with safety checks that throw on error
77  */
78 library SafeMath {
79 
80   /**
81   * @dev Multiplies two numbers, throws on overflow.
82   */
83   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
84     if (a == 0) {
85       return 0;
86     }
87     c = a * b;
88     assert(c / a == b);
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers, truncating the quotient.
94   */
95   function div(uint256 a, uint256 b) internal pure returns (uint256) {
96     // assert(b > 0); // Solidity automatically throws when dividing by 0
97     // uint256 c = a / b;
98     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
99     return a / b;
100   }
101 
102   /**
103   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
104   */
105   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106     assert(b <= a);
107     return a - b;
108   }
109 
110   /**
111   * @dev Adds two numbers, throws on overflow.
112   */
113   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
114     c = a + b;
115     assert(c >= a);
116     return c;
117   }
118 }
119 
120 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\BasicToken.sol
121 
122 pragma solidity ^0.4.21;
123 
124 
125 
126 
127 /**
128  * @title Basic token
129  * @dev Basic version of StandardToken, with no allowances.
130  */
131 contract BasicToken is ERC20Basic {
132   using SafeMath for uint256;
133 
134   mapping(address => uint256) balances;
135 
136   uint256 totalSupply_;
137 
138   /**
139   * @dev total number of tokens in existence
140   */
141   function totalSupply() public view returns (uint256) {
142     return totalSupply_;
143   }
144 
145   /**
146   * @dev transfer token for a specified address
147   * @param _to The address to transfer to.
148   * @param _value The amount to be transferred.
149   */
150   function transfer(address _to, uint256 _value) public returns (bool) {
151     require(_to != address(0));
152     require(_value <= balances[msg.sender]);
153 
154     balances[msg.sender] = balances[msg.sender].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     emit Transfer(msg.sender, _to, _value);
157     return true;
158   }
159 
160   /**
161   * @dev Gets the balance of the specified address.
162   * @param _owner The address to query the the balance of.
163   * @return An uint256 representing the amount owned by the passed address.
164   */
165   function balanceOf(address _owner) public view returns (uint256) {
166     return balances[_owner];
167   }
168 
169 }
170 
171 // File: node_modules\openzeppelin-solidity\contracts\token\ERC20\StandardToken.sol
172 
173 pragma solidity ^0.4.21;
174 
175 
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) internal allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198     require(_value <= balances[_from]);
199     require(_value <= allowed[_from][msg.sender]);
200 
201     balances[_from] = balances[_from].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
204     emit Transfer(_from, _to, _value);
205     return true;
206   }
207 
208   /**
209    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
210    *
211    * Beware that changing an allowance with this method brings the risk that someone may use both the old
212    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
213    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
214    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215    * @param _spender The address which will spend the funds.
216    * @param _value The amount of tokens to be spent.
217    */
218   function approve(address _spender, uint256 _value) public returns (bool) {
219     allowed[msg.sender][_spender] = _value;
220     emit Approval(msg.sender, _spender, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Function to check the amount of tokens that an owner allowed to a spender.
226    * @param _owner address The address which owns the funds.
227    * @param _spender address The address which will spend the funds.
228    * @return A uint256 specifying the amount of tokens still available for the spender.
229    */
230   function allowance(address _owner, address _spender) public view returns (uint256) {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    *
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
245     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
246     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
247     return true;
248   }
249 
250   /**
251    * @dev Decrease the amount of tokens that an owner allowed to a spender.
252    *
253    * approve should be called when allowed[_spender] == 0. To decrement
254    * allowed value is better to use this function to avoid 2 calls (and wait until
255    * the first transaction is mined)
256    * From MonolithDAO Token.sol
257    * @param _spender The address which will spend the funds.
258    * @param _subtractedValue The amount of tokens to decrease the allowance by.
259    */
260   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
261     uint oldValue = allowed[msg.sender][_spender];
262     if (_subtractedValue > oldValue) {
263       allowed[msg.sender][_spender] = 0;
264     } else {
265       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
266     }
267     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
268     return true;
269   }
270 
271 }
272 
273 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Basic.sol
274 
275 pragma solidity ^0.4.21;
276 
277 
278 /**
279  * @title ERC721 Non-Fungible Token Standard basic interface
280  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
281  */
282 contract ERC721Basic {
283   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
284   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
285   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
286 
287   function balanceOf(address _owner) public view returns (uint256 _balance);
288   function ownerOf(uint256 _tokenId) public view returns (address _owner);
289   function exists(uint256 _tokenId) public view returns (bool _exists);
290 
291   function approve(address _to, uint256 _tokenId) public;
292   function getApproved(uint256 _tokenId) public view returns (address _operator);
293 
294   function setApprovalForAll(address _operator, bool _approved) public;
295   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
296 
297   function transferFrom(address _from, address _to, uint256 _tokenId) public;
298   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
299   function safeTransferFrom(
300     address _from,
301     address _to,
302     uint256 _tokenId,
303     bytes _data
304   )
305     public;
306 }
307 
308 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721Receiver.sol
309 
310 pragma solidity ^0.4.21;
311 
312 
313 /**
314  * @title ERC721 token receiver interface
315  * @dev Interface for any contract that wants to support safeTransfers
316  *  from ERC721 asset contracts.
317  */
318 contract ERC721Receiver {
319   /**
320    * @dev Magic value to be returned upon successful reception of an NFT
321    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
322    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
323    */
324   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
325 
326   /**
327    * @notice Handle the receipt of an NFT
328    * @dev The ERC721 smart contract calls this function on the recipient
329    *  after a `safetransfer`. This function MAY throw to revert and reject the
330    *  transfer. This function MUST use 50,000 gas or less. Return of other
331    *  than the magic value MUST result in the transaction being reverted.
332    *  Note: the contract address is always the message sender.
333    * @param _from The sending address
334    * @param _tokenId The NFT identifier which is being transfered
335    * @param _data Additional data with no specified format
336    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
337    */
338   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
339 }
340 
341 // File: node_modules\openzeppelin-solidity\contracts\AddressUtils.sol
342 
343 pragma solidity ^0.4.21;
344 
345 
346 /**
347  * Utility library of inline functions on addresses
348  */
349 library AddressUtils {
350 
351   /**
352    * Returns whether the target address is a contract
353    * @dev This function will return false if invoked during the constructor of a contract,
354    *  as the code is not actually created until after the constructor finishes.
355    * @param addr address to check
356    * @return whether the target address is a contract
357    */
358   function isContract(address addr) internal view returns (bool) {
359     uint256 size;
360     // XXX Currently there is no better way to check if there is a contract in an address
361     // than to check the size of the code at that address.
362     // See https://ethereum.stackexchange.com/a/14016/36603
363     // for more details about how this works.
364     // TODO Check this again before the Serenity release, because all addresses will be
365     // contracts then.
366     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
367     return size > 0;
368   }
369 
370 }
371 
372 // File: node_modules\openzeppelin-solidity\contracts\token\ERC721\ERC721BasicToken.sol
373 
374 pragma solidity ^0.4.21;
375 
376 
377 
378 
379 
380 
381 /**
382  * @title ERC721 Non-Fungible Token Standard basic implementation
383  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
384  */
385 contract ERC721BasicToken is ERC721Basic {
386   using SafeMath for uint256;
387   using AddressUtils for address;
388 
389   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
390   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
391   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
392 
393   // Mapping from token ID to owner
394   mapping (uint256 => address) internal tokenOwner;
395 
396   // Mapping from token ID to approved address
397   mapping (uint256 => address) internal tokenApprovals;
398 
399   // Mapping from owner to number of owned token
400   mapping (address => uint256) internal ownedTokensCount;
401 
402   // Mapping from owner to operator approvals
403   mapping (address => mapping (address => bool)) internal operatorApprovals;
404 
405   /**
406    * @dev Guarantees msg.sender is owner of the given token
407    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
408    */
409   modifier onlyOwnerOf(uint256 _tokenId) {
410     require(ownerOf(_tokenId) == msg.sender);
411     _;
412   }
413 
414   /**
415    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
416    * @param _tokenId uint256 ID of the token to validate
417    */
418   modifier canTransfer(uint256 _tokenId) {
419     require(isApprovedOrOwner(msg.sender, _tokenId));
420     _;
421   }
422 
423   /**
424    * @dev Gets the balance of the specified address
425    * @param _owner address to query the balance of
426    * @return uint256 representing the amount owned by the passed address
427    */
428   function balanceOf(address _owner) public view returns (uint256) {
429     require(_owner != address(0));
430     return ownedTokensCount[_owner];
431   }
432 
433   /**
434    * @dev Gets the owner of the specified token ID
435    * @param _tokenId uint256 ID of the token to query the owner of
436    * @return owner address currently marked as the owner of the given token ID
437    */
438   function ownerOf(uint256 _tokenId) public view returns (address) {
439     address owner = tokenOwner[_tokenId];
440     require(owner != address(0));
441     return owner;
442   }
443 
444   /**
445    * @dev Returns whether the specified token exists
446    * @param _tokenId uint256 ID of the token to query the existance of
447    * @return whether the token exists
448    */
449   function exists(uint256 _tokenId) public view returns (bool) {
450     address owner = tokenOwner[_tokenId];
451     return owner != address(0);
452   }
453 
454   /**
455    * @dev Approves another address to transfer the given token ID
456    * @dev The zero address indicates there is no approved address.
457    * @dev There can only be one approved address per token at a given time.
458    * @dev Can only be called by the token owner or an approved operator.
459    * @param _to address to be approved for the given token ID
460    * @param _tokenId uint256 ID of the token to be approved
461    */
462   function approve(address _to, uint256 _tokenId) public {
463     address owner = ownerOf(_tokenId);
464     require(_to != owner);
465     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
466 
467     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
468       tokenApprovals[_tokenId] = _to;
469       emit Approval(owner, _to, _tokenId);
470     }
471   }
472 
473   /**
474    * @dev Gets the approved address for a token ID, or zero if no address set
475    * @param _tokenId uint256 ID of the token to query the approval of
476    * @return address currently approved for a the given token ID
477    */
478   function getApproved(uint256 _tokenId) public view returns (address) {
479     return tokenApprovals[_tokenId];
480   }
481 
482   /**
483    * @dev Sets or unsets the approval of a given operator
484    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
485    * @param _to operator address to set the approval
486    * @param _approved representing the status of the approval to be set
487    */
488   function setApprovalForAll(address _to, bool _approved) public {
489     require(_to != msg.sender);
490     operatorApprovals[msg.sender][_to] = _approved;
491     emit ApprovalForAll(msg.sender, _to, _approved);
492   }
493 
494   /**
495    * @dev Tells whether an operator is approved by a given owner
496    * @param _owner owner address which you want to query the approval of
497    * @param _operator operator address which you want to query the approval of
498    * @return bool whether the given operator is approved by the given owner
499    */
500   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
501     return operatorApprovals[_owner][_operator];
502   }
503 
504   /**
505    * @dev Transfers the ownership of a given token ID to another address
506    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
507    * @dev Requires the msg sender to be the owner, approved, or operator
508    * @param _from current owner of the token
509    * @param _to address to receive the ownership of the given token ID
510    * @param _tokenId uint256 ID of the token to be transferred
511   */
512   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
513     require(_from != address(0));
514     require(_to != address(0));
515 
516     clearApproval(_from, _tokenId);
517     removeTokenFrom(_from, _tokenId);
518     addTokenTo(_to, _tokenId);
519 
520     emit Transfer(_from, _to, _tokenId);
521   }
522 
523   /**
524    * @dev Safely transfers the ownership of a given token ID to another address
525    * @dev If the target address is a contract, it must implement `onERC721Received`,
526    *  which is called upon a safe transfer, and return the magic value
527    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
528    *  the transfer is reverted.
529    * @dev Requires the msg sender to be the owner, approved, or operator
530    * @param _from current owner of the token
531    * @param _to address to receive the ownership of the given token ID
532    * @param _tokenId uint256 ID of the token to be transferred
533   */
534   function safeTransferFrom(
535     address _from,
536     address _to,
537     uint256 _tokenId
538   )
539     public
540     canTransfer(_tokenId)
541   {
542     // solium-disable-next-line arg-overflow
543     safeTransferFrom(_from, _to, _tokenId, "");
544   }
545 
546   /**
547    * @dev Safely transfers the ownership of a given token ID to another address
548    * @dev If the target address is a contract, it must implement `onERC721Received`,
549    *  which is called upon a safe transfer, and return the magic value
550    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
551    *  the transfer is reverted.
552    * @dev Requires the msg sender to be the owner, approved, or operator
553    * @param _from current owner of the token
554    * @param _to address to receive the ownership of the given token ID
555    * @param _tokenId uint256 ID of the token to be transferred
556    * @param _data bytes data to send along with a safe transfer check
557    */
558   function safeTransferFrom(
559     address _from,
560     address _to,
561     uint256 _tokenId,
562     bytes _data
563   )
564     public
565     canTransfer(_tokenId)
566   {
567     transferFrom(_from, _to, _tokenId);
568     // solium-disable-next-line arg-overflow
569     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
570   }
571 
572   /**
573    * @dev Returns whether the given spender can transfer a given token ID
574    * @param _spender address of the spender to query
575    * @param _tokenId uint256 ID of the token to be transferred
576    * @return bool whether the msg.sender is approved for the given token ID,
577    *  is an operator of the owner, or is the owner of the token
578    */
579   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
580     address owner = ownerOf(_tokenId);
581     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
582   }
583 
584   /**
585    * @dev Internal function to mint a new token
586    * @dev Reverts if the given token ID already exists
587    * @param _to The address that will own the minted token
588    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
589    */
590   function _mint(address _to, uint256 _tokenId) internal {
591     require(_to != address(0));
592     addTokenTo(_to, _tokenId);
593     emit Transfer(address(0), _to, _tokenId);
594   }
595 
596   /**
597    * @dev Internal function to burn a specific token
598    * @dev Reverts if the token does not exist
599    * @param _tokenId uint256 ID of the token being burned by the msg.sender
600    */
601   function _burn(address _owner, uint256 _tokenId) internal {
602     clearApproval(_owner, _tokenId);
603     removeTokenFrom(_owner, _tokenId);
604     emit Transfer(_owner, address(0), _tokenId);
605   }
606 
607   /**
608    * @dev Internal function to clear current approval of a given token ID
609    * @dev Reverts if the given address is not indeed the owner of the token
610    * @param _owner owner of the token
611    * @param _tokenId uint256 ID of the token to be transferred
612    */
613   function clearApproval(address _owner, uint256 _tokenId) internal {
614     require(ownerOf(_tokenId) == _owner);
615     if (tokenApprovals[_tokenId] != address(0)) {
616       tokenApprovals[_tokenId] = address(0);
617       emit Approval(_owner, address(0), _tokenId);
618     }
619   }
620 
621   /**
622    * @dev Internal function to add a token ID to the list of a given address
623    * @param _to address representing the new owner of the given token ID
624    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
625    */
626   function addTokenTo(address _to, uint256 _tokenId) internal {
627     require(tokenOwner[_tokenId] == address(0));
628     tokenOwner[_tokenId] = _to;
629     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
630   }
631 
632   /**
633    * @dev Internal function to remove a token ID from the list of a given address
634    * @param _from address representing the previous owner of the given token ID
635    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
636    */
637   function removeTokenFrom(address _from, uint256 _tokenId) internal {
638     require(ownerOf(_tokenId) == _from);
639     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
640     tokenOwner[_tokenId] = address(0);
641   }
642 
643   /**
644    * @dev Internal function to invoke `onERC721Received` on a target address
645    * @dev The call is not executed if the target address is not a contract
646    * @param _from address representing the previous owner of the given token ID
647    * @param _to target address that will receive the tokens
648    * @param _tokenId uint256 ID of the token to be transferred
649    * @param _data bytes optional data to send along with the call
650    * @return whether the call correctly returned the expected magic value
651    */
652   function checkAndCallSafeTransfer(
653     address _from,
654     address _to,
655     uint256 _tokenId,
656     bytes _data
657   )
658     internal
659     returns (bool)
660   {
661     if (!_to.isContract()) {
662       return true;
663     }
664     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
665     return (retval == ERC721_RECEIVED);
666   }
667 }
668 
669 // File: contracts\Strings.sol
670 
671 pragma solidity ^0.4.23;
672 
673 library Strings {
674   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
675   function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
676     bytes memory _ba = bytes(_a);
677     bytes memory _bb = bytes(_b);
678     bytes memory _bc = bytes(_c);
679     bytes memory _bd = bytes(_d);
680     bytes memory _be = bytes(_e);
681     string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
682     bytes memory babcde = bytes(abcde);
683     uint k = 0;
684     for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
685     for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
686     for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
687     for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
688     for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
689     return string(babcde);
690   }
691 
692   function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
693     return strConcat(_a, _b, _c, _d, "");
694   }
695 
696   function strConcat(string _a, string _b, string _c) internal pure returns (string) {
697     return strConcat(_a, _b, _c, "", "");
698   }
699 
700   function strConcat(string _a, string _b) internal pure returns (string) {
701     return strConcat(_a, _b, "", "", "");
702   }
703 
704   function uint2str(uint i) internal pure returns (string) {
705     if (i == 0) return "0";
706     uint j = i;
707     uint len;
708     while (j != 0){
709       len++;
710       j /= 10;
711     }
712     bytes memory bstr = new bytes(len);
713     uint k = len - 1;
714     while (i != 0){
715       bstr[k--] = byte(48 + i % 10);
716       i /= 10;
717     }
718     return string(bstr);
719   }
720 }
721 
722 // File: contracts\DefinerBasicLoan.sol
723 
724 pragma solidity ^0.4.23;
725 
726 
727 
728 
729 
730 
731 interface ERC721Metadata /* is ERC721 */ {
732   /// @notice A descriptive name for a collection of NFTs in this contract
733   function name() external view returns (string _name);
734 
735   /// @notice An abbreviated name for NFTs in this contract
736   function symbol() external view returns (string _symbol);
737 
738   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
739   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
740   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
741   ///  Metadata JSON Schema".
742   function tokenURI(uint256 _tokenId) external view returns (string);
743 }
744 
745 contract DefinerBasicLoan is ERC721BasicToken, ERC721Metadata {
746   using SafeERC20 for ERC20;
747   using SafeMath for uint;
748 
749   enum States {
750     Init,                 //0
751     WaitingForLender,     //1
752     WaitingForBorrower,   //2
753     WaitingForCollateral, //3
754     WaitingForFunds,      //4
755     Funded,               //5
756     Finished,             //6
757     Closed,               //7
758     Default,              //8
759     Cancelled             //9
760   }
761 
762   address public ownerAddress;
763   address public borrowerAddress;
764   address public lenderAddress;
765   string public loanId;
766   uint public endTime;  // use to check default
767   uint public nextPaymentDateTime; // use to check default
768   uint public daysPerInstallment; // use to calculate next payment date
769   uint public totalLoanTerm; // in days
770   uint public borrowAmount; // total borrowed amount
771   uint public collateralAmount; // total collateral amount
772   uint public installmentAmount; // amount of each installment
773   uint public remainingInstallment; // total installment left
774 
775   States public currentState = States.Init;
776 
777   /**
778    * TODO: change address below to actual factory address after deployment
779    *       address constant private factoryContract = 0x...
780    */
781   address internal factoryContract; // = 0x38Bddc3793DbFb3dE178E3dE74cae2E223c02B85;
782   modifier onlyFactoryContract() {
783       require(factoryContract == 0 || msg.sender == factoryContract, "not factory contract");
784       _;
785   }
786 
787   modifier atState(States state) {
788     require(state == currentState, "Invalid State");
789     _;
790   }
791 
792   modifier onlyOwner() {
793     require(msg.sender == ownerAddress, "Invalid Owner Address");
794     _;
795   }
796 
797   modifier onlyLender() {
798     require(msg.sender == lenderAddress || msg.sender == factoryContract, "Invalid Lender Address");
799     _;
800   }
801 
802   modifier onlyBorrower() {
803     require(msg.sender == borrowerAddress || msg.sender == factoryContract, "Invalid Borrower Address");
804     _;
805   }
806 
807   modifier notDefault() {
808     require(now < nextPaymentDateTime, "This Contract has not yet default");
809     require(now < endTime, "This Contract has not yet default");
810     _;
811   }
812 
813   /**
814    * ERC721 Interface
815    */
816 
817   function name() public view returns (string _name)
818   {
819     return "DeFiner Contract";
820   }
821 
822   function symbol() public view returns (string _symbol)
823   {
824     return "DFINC";
825   }
826 
827   function tokenURI(uint256) public view returns (string)
828   {
829     return Strings.strConcat(
830       "https://api.definer.org/OKh4I2yYpKU8S2af/definer/api/v1.0/opensea/",
831       loanId
832     );
833   }
834 
835   function transferFrom(address _from, address _to, uint256 _tokenId) public {
836     require(_from != address(0));
837     require(_to != address(0));
838 
839     super.transferFrom(_from, _to, _tokenId);
840     lenderAddress = tokenOwner[_tokenId];
841   }
842 
843   function safeTransferFrom(
844     address _from,
845     address _to,
846     uint256 _tokenId
847   )
848   public
849   {
850     // solium-disable-next-line arg-overflow
851     safeTransferFrom(_from, _to, _tokenId, "");
852     lenderAddress = tokenOwner[_tokenId];
853   }
854 
855   function safeTransferFrom(
856     address _from,
857     address _to,
858     uint256 _tokenId,
859     bytes _data
860   )
861   public
862   {
863     transferFrom(_from, _to, _tokenId);
864     // solium-disable-next-line arg-overflow
865     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
866     lenderAddress = tokenOwner[_tokenId];
867   }
868 
869 
870   /**
871    * Borrower transfer ETH to contract
872    */
873   function transferCollateral() public payable /*atState(States.WaitingForCollateral)*/;
874 
875   /**
876    * Check if borrower transferred correct amount of Token
877    */
878   function checkCollateral() public /*atState(States.WaitingForCollateral)*/;
879 
880   /**
881   *  Borrower cancel the transaction is Default
882   */
883   function borrowerCancel() public /*onlyLender atState(States.WaitingForLender)*/;
884 
885   /**
886   *  Lender cancel the transaction is Default
887   */
888   function lenderCancel() public /*onlyLender atState(States.WaitingForBorrower)*/;
889 
890   /**
891    * Lender transfer ETH to contract
892    */
893   function transferFunds() public payable /*atState(States.WaitingForFunds)*/;
894 
895   /**
896    * Check if lender transferred correct amount of Token
897    */
898   function checkFunds() public /*atState(States.WaitingForFunds)*/;
899 
900   /**
901    *  Borrower pay back ETH or Token
902    */
903   function borrowerMakePayment() public payable /*onlyBorrower atState(States.Funded) notDefault*/;
904 
905   /**
906    *  Borrower gets collateral back
907    */
908   function borrowerReclaimCollateral() public /*onlyBorrower atState(States.Finished)*/;
909 
910   /**
911    *  Lender gets collateral when contract state is Default
912    */
913   function lenderReclaimCollateral() public /*onlyLender atState(States.Default)*/;
914 
915 
916   /**
917   * Borrower accept loan
918   */
919   function borrowerAcceptLoan() public atState(States.WaitingForBorrower) {
920     require(msg.sender != address(0), "Invalid address.");
921     borrowerAddress = msg.sender;
922     currentState = States.WaitingForCollateral;
923   }
924 
925   /**
926    * Lender accept loan
927    */
928   function lenderAcceptLoan() public atState(States.WaitingForLender) {
929     require(msg.sender != address(0), "Invalid address.");
930     lenderAddress = msg.sender;
931     currentState = States.WaitingForFunds;
932   }
933 
934   function transferETHToBorrowerAndStartLoan() internal {
935     borrowerAddress.transfer(borrowAmount);
936     endTime = now.add(totalLoanTerm.mul(1 days));
937     nextPaymentDateTime = now.add(daysPerInstallment.mul(1 days));
938     currentState = States.Funded;
939   }
940 
941   function transferTokenToBorrowerAndStartLoan(StandardToken token) internal {
942     require(token.transfer(borrowerAddress, borrowAmount), "Token transfer failed");
943     endTime = now.add(totalLoanTerm.mul(1 days));
944     nextPaymentDateTime = now.add(daysPerInstallment.mul(1 days));
945     currentState = States.Funded;
946   }
947 
948   //TODO not in use yet
949   function checkDefault() public onlyLender atState(States.Funded) returns (bool) {
950     if (now > endTime || now > nextPaymentDateTime) {
951       currentState = States.Default;
952       return true;
953     } else {
954       return false;
955     }
956   }
957 
958   // For testing
959   function forceDefault() public onlyOwner {
960     currentState = States.Default;
961   }
962 
963   function getLoanDetails() public view returns (address,address,address,string,uint,uint,uint,uint,uint,uint,uint,uint,uint) {
964 //    address public ownerAddress;
965 //    address public borrowerAddress;
966 //    address public lenderAddress;
967 //    string public loanId;
968 //    uint public endTime;  // use to check default
969 //    uint public nextPaymentDateTime; // use to check default
970 //    uint public daysPerInstallment; // use to calculate next payment date
971 //    uint public totalLoanTerm; // in days
972 //    uint public borrowAmount; // total borrowed amount
973 //    uint public collateralAmount; // total collateral amount
974 //    uint public installmentAmount; // amount of each installment
975 //    uint public remainingInstallment; // total installment left
976 //    States public currentState = States.Init;
977 //
978 //    return (
979 //      nextPaymentDateTime,
980 //      remainingInstallment,
981 //      uint(currentState),
982 //      loanId,
983 //      borrowerAddress,
984 //      lenderAddress
985 //    );
986     return (
987       ownerAddress,
988       borrowerAddress,
989       lenderAddress,
990       loanId,
991       endTime,
992       nextPaymentDateTime,
993       daysPerInstallment,
994       totalLoanTerm,
995       borrowAmount,
996       collateralAmount,
997       installmentAmount,
998       remainingInstallment,
999       uint(currentState)
1000     );
1001   }
1002 }
1003 
1004 // File: contracts\ERC20ETHLoan.sol
1005 
1006 pragma solidity ^0.4.23;
1007 
1008 
1009 /**
1010  * Collateral: ERC20 Token
1011  * Borrowed: ETH
1012  */
1013 contract ERC20ETHLoan is DefinerBasicLoan {
1014 
1015   StandardToken token;
1016   address public collateralTokenAddress;
1017 
1018   /**
1019    * NOT IN USE
1020    * WHEN COLLATERAL IS TOKEN, TRANSFER IS DONE IN FRONT END
1021    */
1022   function transferCollateral() public payable {
1023     revert();
1024   }
1025 
1026   function establishContract() public {
1027 
1028     // ERC20 as collateral
1029     uint amount = token.balanceOf(address(this));
1030     require(amount >= collateralAmount, "Insufficient collateral amount");
1031 
1032     // Ether as Fund
1033     require(address(this).balance >= borrowAmount, "Insufficient fund amount");
1034 
1035     // Transit to Funded state
1036     transferETHToBorrowerAndStartLoan();
1037   }
1038 
1039   /**
1040    * NOT IN USE
1041    * WHEN FUND IS ETH, CHECK IS DONE IN transferFunds()
1042    */
1043   function checkFunds() onlyLender atState(States.WaitingForFunds) public {
1044     return establishContract();
1045   }
1046 
1047   /**
1048    * Check if borrower transferred correct amount of token to this contract
1049    */
1050   function checkCollateral() public onlyBorrower atState(States.WaitingForCollateral) {
1051     uint amount = token.balanceOf(address(this));
1052     require(amount >= collateralAmount, "Insufficient collateral amount");
1053     currentState = States.WaitingForLender;
1054   }
1055 
1056   /**
1057    *  Lender transfer ETH to fund this contract
1058    */
1059   function transferFunds() public payable onlyLender atState(States.WaitingForFunds) {
1060     if (address(this).balance >= borrowAmount) {
1061       establishContract();
1062     }
1063   }
1064 
1065   /*
1066    *  Borrower pay back ETH
1067    */
1068   function borrowerMakePayment() public payable onlyBorrower atState(States.Funded) notDefault {
1069     require(msg.value >= installmentAmount);
1070     remainingInstallment--;
1071     lenderAddress.transfer(installmentAmount);
1072     if (remainingInstallment == 0) {
1073       currentState = States.Finished;
1074     } else {
1075       nextPaymentDateTime = nextPaymentDateTime.add(daysPerInstallment.mul(1 days));
1076     }
1077   }
1078 
1079   /*
1080    *  Borrower gets collateral token back when contract completed
1081    */
1082   function borrowerReclaimCollateral() public onlyBorrower atState(States.Finished) {
1083     uint amount = token.balanceOf(address(this));
1084     token.transfer(borrowerAddress, amount);
1085     currentState = States.Closed;
1086   }
1087 
1088   /*
1089    *  Lender gets collateral token when contract defaulted
1090    */
1091   function lenderReclaimCollateral() public onlyLender atState(States.Default) {
1092     uint amount = token.balanceOf(address(this));
1093     token.transfer(lenderAddress, amount);
1094     currentState = States.Closed;
1095   }
1096 }
1097 
1098 // File: contracts\ERC20ETHLoanBorrower.sol
1099 
1100 pragma solidity ^0.4.23;
1101 
1102 
1103 /**
1104  * Collateral: ERC20 Token
1105  * Borrowed: ETH
1106  */
1107 contract ERC20ETHLoanBorrower is ERC20ETHLoan {
1108   function init (
1109     address _ownerAddress,
1110     address _borrowerAddress,
1111     address _lenderAddress,
1112     address _collateralTokenAddress,
1113     uint _borrowAmount,
1114     uint _paybackAmount,
1115     uint _collateralAmount,
1116     uint _daysPerInstallment,
1117     uint _remainingInstallment,
1118     string _loanId
1119   ) public onlyFactoryContract {
1120     require(_collateralTokenAddress != address(0), "Invalid token address");
1121     require(_borrowerAddress != address(0), "Invalid lender address");
1122     require(_lenderAddress != address(0), "Invalid lender address");
1123     require(_remainingInstallment > 0, "Invalid number of installments");
1124     require(_borrowAmount > 0, "Borrow amount must not be 0");
1125     require(_paybackAmount > 0, "Payback amount must not be 0");
1126     require(_collateralAmount > 0, "Collateral amount must not be 0");
1127     super._mint(_lenderAddress, 1);
1128     factoryContract = msg.sender;
1129     ownerAddress = _ownerAddress;
1130     loanId = _loanId;
1131     collateralTokenAddress = _collateralTokenAddress;
1132     borrowAmount = _borrowAmount;
1133     collateralAmount = _collateralAmount;
1134     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1135     daysPerInstallment = _daysPerInstallment;
1136     remainingInstallment = _remainingInstallment;
1137     installmentAmount = _paybackAmount / _remainingInstallment;
1138     token = StandardToken(_collateralTokenAddress);
1139     borrowerAddress = _borrowerAddress;
1140     lenderAddress = _lenderAddress;
1141 
1142     // initialial state for borrower initiated ERC20 flow
1143     currentState = States.WaitingForCollateral;
1144   }
1145 
1146   /**
1147    * NOT IN USE
1148    * WHEN FUND IS ETH, CHECK IS DONE IN transferFunds()
1149    */
1150   function checkFunds() onlyLender atState(States.WaitingForFunds) public {
1151     return establishContract();
1152   }
1153 
1154   /**
1155    * Check if borrower transferred correct amount of token to this contract
1156    */
1157   function checkCollateral() public onlyBorrower atState(States.WaitingForCollateral) {
1158     uint amount = token.balanceOf(address(this));
1159     require(amount >= collateralAmount, "Insufficient collateral amount");
1160     currentState = States.WaitingForFunds;
1161   }
1162 
1163   /**
1164    *  Lender transfer ETH to fund this contract
1165    */
1166   function transferFunds() public payable onlyLender atState(States.WaitingForFunds) {
1167     if (address(this).balance >= borrowAmount) {
1168       establishContract();
1169     }
1170   }
1171 
1172   /*
1173    *  Borrower gets collateral token back when contract completed
1174    */
1175   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1176     uint amount = token.balanceOf(address(this));
1177     token.transfer(borrowerAddress, amount);
1178     currentState = States.Cancelled;
1179   }
1180 
1181   /*
1182    *  Lender gets funds token back when contract is cancelled
1183    */
1184   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1185     // For ETH leader, no way to cancel
1186     revert();
1187   }
1188 }
1189 
1190 // File: contracts\ERC20ETHLoanLender.sol
1191 
1192 pragma solidity ^0.4.23;
1193 
1194 
1195 /**
1196  * Collateral: ERC20 Token
1197  * Borrowed: ETH
1198  */
1199 contract ERC20ETHLoanLender is ERC20ETHLoan {
1200   function init (
1201     address _ownerAddress,
1202     address _borrowerAddress,
1203     address _lenderAddress,
1204     address _collateralTokenAddress,
1205     uint _borrowAmount,
1206     uint _paybackAmount,
1207     uint _collateralAmount,
1208     uint _daysPerInstallment,
1209     uint _remainingInstallment,
1210     string _loanId
1211   ) public onlyFactoryContract {
1212     require(_collateralTokenAddress != address(0), "Invalid token address");
1213     require(_borrowerAddress != address(0), "Invalid lender address");
1214     require(_lenderAddress != address(0), "Invalid lender address");
1215     require(_remainingInstallment > 0, "Invalid number of installments");
1216     require(_borrowAmount > 0, "Borrow amount must not be 0");
1217     require(_paybackAmount > 0, "Payback amount must not be 0");
1218     require(_collateralAmount > 0, "Collateral amount must not be 0");
1219     super._mint(_lenderAddress, 1);
1220     factoryContract = msg.sender;
1221     ownerAddress = _ownerAddress;
1222     loanId = _loanId;
1223     collateralTokenAddress = _collateralTokenAddress;
1224     borrowAmount = _borrowAmount;
1225     collateralAmount = _collateralAmount;
1226     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1227     daysPerInstallment = _daysPerInstallment;
1228     remainingInstallment = _remainingInstallment;
1229     installmentAmount = _paybackAmount / _remainingInstallment;
1230     token = StandardToken(_collateralTokenAddress);
1231     borrowerAddress = _borrowerAddress;
1232     lenderAddress = _lenderAddress;
1233 
1234     // initialial state for borrower initiated ERC20 flow
1235     currentState = States.WaitingForFunds;
1236   }
1237 
1238   /**
1239    * Check if borrower transferred correct amount of token to this contract
1240    */
1241   function checkCollateral() public onlyBorrower atState(States.WaitingForCollateral) {
1242     return establishContract();
1243   }
1244 
1245   /**
1246    *  Lender transfer ETH to fund this contract
1247    */
1248   function transferFunds() public payable onlyLender atState(States.WaitingForFunds) {
1249     if (address(this).balance >= borrowAmount) {
1250       currentState = States.WaitingForCollateral;
1251     }
1252   }
1253 
1254 
1255   /*
1256    *  Borrower gets collateral token back when contract completed
1257    */
1258   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1259     revert();
1260   }
1261 
1262   /*
1263    *  Lender gets funds token back when contract is cancelled
1264    */
1265   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1266     lenderAddress.transfer(address(this).balance);
1267     currentState = States.Cancelled;
1268   }
1269 }
1270 
1271 // File: contracts\ETHERC20Loan.sol
1272 
1273 pragma solidity ^0.4.23;
1274 
1275 
1276 /**
1277  * Collateral: ETH
1278  * Borrowed: ERC20 Token
1279  */
1280 contract ETHERC20Loan is DefinerBasicLoan {
1281 
1282   StandardToken token;
1283   address public borrowedTokenAddress;
1284 
1285   function establishContract() public {
1286 
1287     // ERC20 as collateral
1288     uint amount = token.balanceOf(address(this));
1289     require(amount >= collateralAmount, "Insufficient collateral amount");
1290 
1291     // Ether as Fund
1292     require(address(this).balance >= borrowAmount, "Insufficient fund amount");
1293 
1294     // Transit to Funded state
1295     transferETHToBorrowerAndStartLoan();
1296   }
1297 
1298   /*
1299    *  Borrower pay back ERC20 Token
1300    */
1301   function borrowerMakePayment() public payable onlyBorrower atState(States.Funded) notDefault {
1302     require(remainingInstallment > 0, "No remaining installments");
1303     require(installmentAmount > 0, "Installment amount must be non zero");
1304     token.transfer(lenderAddress, installmentAmount);
1305     remainingInstallment--;
1306     if (remainingInstallment == 0) {
1307       currentState = States.Finished;
1308     } else {
1309       nextPaymentDateTime = nextPaymentDateTime.add(daysPerInstallment.mul(1 days));
1310     }
1311   }
1312 
1313   /*
1314    *  Borrower gets collateral ETH back when contract completed
1315    */
1316   function borrowerReclaimCollateral() public onlyBorrower atState(States.Finished) {
1317     borrowerAddress.transfer(address(this).balance);
1318     currentState = States.Closed;
1319   }
1320 
1321   /*
1322    *  Lender gets collateral ETH when contract defaulted
1323    */
1324   function lenderReclaimCollateral() public onlyLender atState(States.Default) {
1325     lenderAddress.transfer(address(this).balance);
1326     currentState = States.Closed;
1327   }
1328 }
1329 
1330 // File: contracts\ETHERC20LoanBorrower.sol
1331 
1332 pragma solidity ^0.4.23;
1333 
1334 
1335 /**
1336  * Collateral: ETH
1337  * Borrowed: ERC20 Token
1338  */
1339 contract ETHERC20LoanBorrower is ETHERC20Loan {
1340   function init (
1341     address _ownerAddress,
1342     address _borrowerAddress,
1343     address _lenderAddress,
1344     address _borrowedTokenAddress,
1345     uint _borrowAmount,
1346     uint _paybackAmount,
1347     uint _collateralAmount,
1348     uint _daysPerInstallment,
1349     uint _remainingInstallment,
1350     string _loanId
1351   ) public onlyFactoryContract {
1352     require(_borrowedTokenAddress != address(0), "Invalid token address");
1353     require(_borrowerAddress != address(0), "Invalid lender address");
1354     require(_lenderAddress != address(0), "Invalid lender address");
1355     require(_remainingInstallment > 0, "Invalid number of installments");
1356     require(_borrowAmount > 0, "Borrow amount must not be 0");
1357     require(_paybackAmount > 0, "Payback amount must not be 0");
1358     require(_collateralAmount > 0, "Collateral amount must not be 0");
1359     super._mint(_lenderAddress, 1);
1360     factoryContract = msg.sender;
1361     ownerAddress = _ownerAddress;
1362     loanId = _loanId;
1363     borrowedTokenAddress = _borrowedTokenAddress;
1364     borrowAmount = _borrowAmount;
1365     collateralAmount = _collateralAmount;
1366     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1367     daysPerInstallment = _daysPerInstallment;
1368     remainingInstallment = _remainingInstallment;
1369     installmentAmount = _paybackAmount / _remainingInstallment;
1370     token = StandardToken(_borrowedTokenAddress);
1371     borrowerAddress = _borrowerAddress;
1372     lenderAddress = _lenderAddress;
1373 
1374     currentState = States.WaitingForCollateral;
1375   }
1376 
1377   /**
1378    * Borrower transfer ETH to contract
1379    */
1380   function transferCollateral() public payable atState(States.WaitingForCollateral) {
1381     if (address(this).balance >= collateralAmount) {
1382       currentState = States.WaitingForFunds;
1383     }
1384   }
1385 
1386   /**
1387    *
1388    */
1389   function checkFunds() public onlyLender atState(States.WaitingForFunds) {
1390     uint amount = token.balanceOf(address(this));
1391     require(amount >= borrowAmount, "Insufficient borrowed amount");
1392     transferTokenToBorrowerAndStartLoan(token);
1393   }
1394 
1395   /**
1396    * NOT IN USE
1397    * WHEN COLLATERAL IS ETH, CHECK IS DONE IN transferCollateral()
1398    */
1399   function checkCollateral() public {
1400     revert();
1401   }
1402 
1403   /**
1404    * NOT IN USE
1405    * WHEN FUND IS TOKEN, TRANSFER IS DONE IN FRONT END
1406    */
1407   function transferFunds() public payable {
1408     revert();
1409   }
1410 
1411   /*
1412  *  Borrower gets collateral ETH back when contract completed
1413  */
1414   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1415     borrowerAddress.transfer(address(this).balance);
1416     currentState = States.Cancelled;
1417   }
1418 
1419   /*
1420 *  Borrower gets collateral ETH back when contract completed
1421 */
1422   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1423     revert();
1424   }
1425 }
1426 
1427 // File: contracts\ETHERC20LoanLender.sol
1428 
1429 pragma solidity ^0.4.23;
1430 
1431 
1432 /**
1433  * Collateral: ETH
1434  * Borrowed: ERC20 Token
1435  */
1436 contract ETHERC20LoanLender is ETHERC20Loan {
1437 
1438   function init (
1439     address _ownerAddress,
1440     address _borrowerAddress,
1441     address _lenderAddress,
1442     address _borrowedTokenAddress,
1443     uint _borrowAmount,
1444     uint _paybackAmount,
1445     uint _collateralAmount,
1446     uint _daysPerInstallment,
1447     uint _remainingInstallment,
1448     string _loanId
1449   ) public onlyFactoryContract {
1450     require(_borrowedTokenAddress != address(0), "Invalid token address");
1451     require(_borrowerAddress != address(0), "Invalid lender address");
1452     require(_lenderAddress != address(0), "Invalid lender address");
1453     require(_remainingInstallment > 0, "Invalid number of installments");
1454     require(_borrowAmount > 0, "Borrow amount must not be 0");
1455     require(_paybackAmount > 0, "Payback amount must not be 0");
1456     require(_collateralAmount > 0, "Collateral amount must not be 0");
1457     super._mint(_lenderAddress, 1);
1458     factoryContract = msg.sender;
1459     ownerAddress = _ownerAddress;
1460     loanId = _loanId;
1461     borrowedTokenAddress = _borrowedTokenAddress;
1462     borrowAmount = _borrowAmount;
1463     collateralAmount = _collateralAmount;
1464     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1465     daysPerInstallment = _daysPerInstallment;
1466     remainingInstallment = _remainingInstallment;
1467     installmentAmount = _paybackAmount / _remainingInstallment;
1468     token = StandardToken(_borrowedTokenAddress);
1469     borrowerAddress = _borrowerAddress;
1470     lenderAddress = _lenderAddress;
1471 
1472     currentState = States.WaitingForFunds;
1473   }
1474 
1475   /**
1476    * Borrower transfer ETH to contract
1477    */
1478   function transferCollateral() public payable atState(States.WaitingForCollateral) {
1479     require(address(this).balance >= collateralAmount, "Insufficient ETH collateral amount");
1480     transferTokenToBorrowerAndStartLoan(token);
1481   }
1482 
1483   /**
1484    *
1485    */
1486   function checkFunds() public onlyLender atState(States.WaitingForFunds) {
1487     uint amount = token.balanceOf(address(this));
1488     require(amount >= borrowAmount, "Insufficient fund amount");
1489     currentState = States.WaitingForCollateral;
1490   }
1491 
1492   /**
1493    * NOT IN USE
1494    * WHEN COLLATERAL IS ETH, CHECK IS DONE IN transferCollateral()
1495    */
1496   function checkCollateral() public {
1497     revert();
1498   }
1499 
1500   /**
1501    * NOT IN USE
1502    * WHEN FUND IS TOKEN, TRANSFER IS DONE IN FRONT END
1503    */
1504   function transferFunds() public payable {
1505     revert();
1506   }
1507 
1508   /*
1509  *  Borrower gets collateral ETH back when contract completed
1510  */
1511   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1512     revert();
1513   }
1514 
1515   /*
1516 *  Borrower gets collateral ETH back when contract completed
1517 */
1518   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1519     uint amount = token.balanceOf(address(this));
1520     token.transfer(lenderAddress, amount);
1521     currentState = States.Cancelled;
1522   }
1523 }
1524 
1525 // File: contracts\ERC20ERC20Loan.sol
1526 
1527 pragma solidity ^0.4.23;
1528 
1529 
1530 /**
1531  * Collateral: ERC20 Token
1532  * Borrowed: ERC20 Token
1533  */
1534 contract ERC20ERC20Loan is DefinerBasicLoan {
1535 
1536   StandardToken collateralToken;
1537   StandardToken borrowedToken;
1538   address public collateralTokenAddress;
1539   address public borrowedTokenAddress;
1540 
1541   /*
1542    *  Borrower pay back Token
1543    */
1544   function borrowerMakePayment() public payable onlyBorrower atState(States.Funded) notDefault {
1545     require(remainingInstallment > 0, "No remaining installments");
1546     require(installmentAmount > 0, "Installment amount must be non zero");
1547     borrowedToken.transfer(lenderAddress, installmentAmount);
1548     remainingInstallment--;
1549     if (remainingInstallment == 0) {
1550       currentState = States.Finished;
1551     } else {
1552       nextPaymentDateTime = nextPaymentDateTime.add(daysPerInstallment.mul(1 days));
1553     }
1554   }
1555 
1556   /*
1557    *  Borrower gets collateral token back when contract completed
1558    */
1559   function borrowerReclaimCollateral() public onlyBorrower atState(States.Finished) {
1560     uint amount = collateralToken.balanceOf(address(this));
1561     collateralToken.transfer(borrowerAddress, amount);
1562     currentState = States.Closed;
1563   }
1564 
1565   /*
1566    *  Lender gets collateral token when contract defaulted
1567    */
1568   function lenderReclaimCollateral() public onlyLender atState(States.Default) {
1569     uint amount = collateralToken.balanceOf(address(this));
1570     collateralToken.transfer(lenderAddress, amount);
1571     currentState = States.Closed;
1572   }
1573 }
1574 
1575 // File: contracts\ERC20ERC20LoanBorrower.sol
1576 
1577 pragma solidity ^0.4.23;
1578 
1579 
1580 /**
1581  * Collateral: ERC20 Token
1582  * Borrowed: ERC20 Token
1583  */
1584 contract ERC20ERC20LoanBorrower is ERC20ERC20Loan {
1585 
1586   function init (
1587     address _ownerAddress,
1588     address _borrowerAddress,
1589     address _lenderAddress,
1590     address _collateralTokenAddress,
1591     address _borrowedTokenAddress,
1592     uint _borrowAmount,
1593     uint _paybackAmount,
1594     uint _collateralAmount,
1595     uint _daysPerInstallment,
1596     uint _remainingInstallment,
1597     string _loanId
1598   ) public onlyFactoryContract {
1599     require(_collateralTokenAddress != _borrowedTokenAddress);
1600     require(_collateralTokenAddress != address(0), "Invalid token address");
1601     require(_borrowedTokenAddress != address(0), "Invalid token address");
1602     require(_borrowerAddress != address(0), "Invalid lender address");
1603     require(_lenderAddress != address(0), "Invalid lender address");
1604     require(_remainingInstallment > 0, "Invalid number of installments");
1605     require(_borrowAmount > 0, "Borrow amount must not be 0");
1606     require(_paybackAmount > 0, "Payback amount must not be 0");
1607     require(_collateralAmount > 0, "Collateral amount must not be 0");
1608     super._mint(_lenderAddress, 1);
1609     factoryContract = msg.sender;
1610     ownerAddress = _ownerAddress;
1611     loanId = _loanId;
1612     collateralTokenAddress = _collateralTokenAddress;
1613     borrowedTokenAddress = _borrowedTokenAddress;
1614     borrowAmount = _borrowAmount;
1615     collateralAmount = _collateralAmount;
1616     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1617     daysPerInstallment = _daysPerInstallment;
1618     remainingInstallment = _remainingInstallment;
1619     installmentAmount = _paybackAmount / _remainingInstallment;
1620     collateralToken = StandardToken(_collateralTokenAddress);
1621     borrowedToken = StandardToken(_borrowedTokenAddress);
1622 
1623     borrowerAddress = _borrowerAddress;
1624     lenderAddress = _lenderAddress;
1625     currentState = States.WaitingForCollateral;
1626   }
1627 
1628   /**
1629    * NOT IN USE
1630    * WHEN COLLATERAL IS TOKEN, TRANSFER IS DONE IN FRONT END
1631    */
1632   function transferCollateral() public payable {
1633     revert();
1634   }
1635 
1636   /**
1637    * NOT IN USE
1638    * WHEN FUND IS TOKEN, TRANSFER IS DONE IN FRONT END
1639    */
1640   function transferFunds() public payable {
1641     revert();
1642   }
1643 
1644   /**
1645    *
1646    */
1647   function checkFunds() public onlyLender atState(States.WaitingForFunds) {
1648     uint amount = borrowedToken.balanceOf(address(this));
1649     require(amount >= borrowAmount, "Insufficient borrowed amount");
1650     transferTokenToBorrowerAndStartLoan(borrowedToken);
1651   }
1652 
1653   /**
1654    * Check if borrower transferred correct amount of token to this contract
1655    */
1656   function checkCollateral() public onlyBorrower atState(States.WaitingForCollateral) {
1657     uint amount = collateralToken.balanceOf(address(this));
1658     require(amount >= collateralAmount, "Insufficient Collateral Token amount");
1659     currentState = States.WaitingForFunds;
1660   }
1661 
1662   /*
1663    *  Borrower gets collateral token back when contract cancelled
1664    */
1665   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1666     uint amount = collateralToken.balanceOf(address(this));
1667     collateralToken.transfer(borrowerAddress, amount);
1668     currentState = States.Cancelled;
1669   }
1670 
1671   /*
1672    *  Lender gets fund token back when contract cancelled
1673    */
1674   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1675     revert();
1676   }
1677 }
1678 
1679 // File: contracts\ERC20ERC20LoanLender.sol
1680 
1681 pragma solidity ^0.4.23;
1682 
1683 
1684 /**
1685  * Collateral: ERC20 Token
1686  * Borrowed: ERC20 Token
1687  */
1688 contract ERC20ERC20LoanLender is ERC20ERC20Loan {
1689 
1690   function init (
1691     address _ownerAddress,
1692     address _borrowerAddress,
1693     address _lenderAddress,
1694     address _collateralTokenAddress,
1695     address _borrowedTokenAddress,
1696     uint _borrowAmount,
1697     uint _paybackAmount,
1698     uint _collateralAmount,
1699     uint _daysPerInstallment,
1700     uint _remainingInstallment,
1701     string _loanId
1702   ) public onlyFactoryContract {
1703     require(_collateralTokenAddress != _borrowedTokenAddress);
1704     require(_collateralTokenAddress != address(0), "Invalid token address");
1705     require(_borrowedTokenAddress != address(0), "Invalid token address");
1706     require(_borrowerAddress != address(0), "Invalid lender address");
1707     require(_lenderAddress != address(0), "Invalid lender address");
1708     require(_remainingInstallment > 0, "Invalid number of installments");
1709     require(_borrowAmount > 0, "Borrow amount must not be 0");
1710     require(_paybackAmount > 0, "Payback amount must not be 0");
1711     require(_collateralAmount > 0, "Collateral amount must not be 0");
1712     super._mint(_lenderAddress, 1);
1713     factoryContract = msg.sender;
1714     ownerAddress = _ownerAddress;
1715     loanId = _loanId;
1716     collateralTokenAddress = _collateralTokenAddress;
1717     borrowedTokenAddress = _borrowedTokenAddress;
1718     borrowAmount = _borrowAmount;
1719     collateralAmount = _collateralAmount;
1720     totalLoanTerm = _remainingInstallment * _daysPerInstallment;
1721     daysPerInstallment = _daysPerInstallment;
1722     remainingInstallment = _remainingInstallment;
1723     installmentAmount = _paybackAmount / _remainingInstallment;
1724     collateralToken = StandardToken(_collateralTokenAddress);
1725     borrowedToken = StandardToken(_borrowedTokenAddress);
1726 
1727     borrowerAddress = _borrowerAddress;
1728     lenderAddress = _lenderAddress;
1729     currentState = States.WaitingForFunds;
1730   }
1731 
1732   /**
1733    * NOT IN USE
1734    * WHEN COLLATERAL IS TOKEN, TRANSFER IS DONE IN FRONT END
1735    */
1736   function transferCollateral() public payable {
1737     revert();
1738   }
1739 
1740   /**
1741    * NOT IN USE
1742    * WHEN FUND IS TOKEN, TRANSFER IS DONE IN FRONT END
1743    */
1744   function transferFunds() public payable {
1745     revert();
1746   }
1747 
1748   /**
1749    *
1750    */
1751   function checkFunds() public onlyLender atState(States.WaitingForFunds) {
1752     uint amount = borrowedToken.balanceOf(address(this));
1753     require(amount >= borrowAmount, "Insufficient fund amount");
1754     currentState = States.WaitingForCollateral;
1755   }
1756 
1757   /**
1758    * Check if borrower transferred correct amount of token to this contract
1759    */
1760   function checkCollateral() public onlyBorrower atState(States.WaitingForCollateral) {
1761     uint amount = collateralToken.balanceOf(address(this));
1762     require(amount >= collateralAmount, "Insufficient Collateral Token amount");
1763     transferTokenToBorrowerAndStartLoan(borrowedToken);
1764   }
1765 
1766   /*
1767    *  Borrower gets collateral token back when contract cancelled
1768    */
1769   function borrowerCancel() public onlyBorrower atState(States.WaitingForFunds) {
1770     revert();
1771   }
1772 
1773   /*
1774    *  Lender gets fund token back when contract cancelled
1775    */
1776   function lenderCancel() public onlyLender atState(States.WaitingForCollateral) {
1777     uint amount = borrowedToken.balanceOf(address(this));
1778     borrowedToken.transfer(lenderAddress, amount);
1779     currentState = States.Cancelled;
1780   }
1781 }
1782 
1783 // File: contracts\DefinerLoanFactory.sol
1784 
1785 pragma solidity ^0.4.23;
1786 
1787 
1788 
1789 
1790 
1791 
1792 
1793 library Library {
1794   struct contractAddress {
1795     address value;
1796     bool exists;
1797   }
1798 }
1799 
1800 contract CloneFactory {
1801   event CloneCreated(address indexed target, address clone);
1802 
1803   function createClone(address target) internal returns (address result) {
1804     bytes memory clone = hex"3d602d80600a3d3981f3363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3";
1805     bytes20 targetBytes = bytes20(target);
1806     for (uint i = 0; i < 20; i++) {
1807       clone[20 + i] = targetBytes[i];
1808     }
1809     assembly {
1810       let len := mload(clone)
1811       let data := add(clone, 0x20)
1812       result := create(0, data, len)
1813     }
1814   }
1815 }
1816 
1817 contract DefinerLoanFactory is CloneFactory {
1818 
1819   using Library for Library.contractAddress;
1820 
1821   address public owner = msg.sender;
1822   address public ERC20ETHLoanBorrowerMasterContractAddress;
1823   address public ERC20ETHLoanLenderMasterContractAddress;
1824 
1825   address public ETHERC20LoanBorrowerMasterContractAddress;
1826   address public ETHERC20LoanLenderMasterContractAddress;
1827 
1828   address public ERC20ERC20LoanBorrowerMasterContractAddress;
1829   address public ERC20ERC20LoanLenderMasterContractAddress;
1830 
1831   mapping(address => address[]) contractMap;
1832   mapping(string => Library.contractAddress) contractById;
1833 
1834   modifier onlyOwner() {
1835     require(msg.sender == owner, "Invalid Owner Address");
1836     _;
1837   }
1838 
1839   constructor (
1840     address _ERC20ETHLoanBorrowerMasterContractAddress,
1841     address _ERC20ETHLoanLenderMasterContractAddress,
1842     address _ETHERC20LoanBorrowerMasterContractAddress,
1843     address _ETHERC20LoanLenderMasterContractAddress,
1844     address _ERC20ERC20LoanBorrowerMasterContractAddress,
1845     address _ERC20ERC20LoanLenderMasterContractAddress
1846   ) public {
1847     owner = msg.sender;
1848     ERC20ETHLoanBorrowerMasterContractAddress = _ERC20ETHLoanBorrowerMasterContractAddress;
1849     ERC20ETHLoanLenderMasterContractAddress = _ERC20ETHLoanLenderMasterContractAddress;
1850     ETHERC20LoanBorrowerMasterContractAddress = _ETHERC20LoanBorrowerMasterContractAddress;
1851     ETHERC20LoanLenderMasterContractAddress = _ETHERC20LoanLenderMasterContractAddress;
1852     ERC20ERC20LoanBorrowerMasterContractAddress = _ERC20ERC20LoanBorrowerMasterContractAddress;
1853     ERC20ERC20LoanLenderMasterContractAddress = _ERC20ERC20LoanLenderMasterContractAddress;
1854   }
1855 
1856   function getUserContracts(address userAddress) public view returns (address[]) {
1857     return contractMap[userAddress];
1858   }
1859 
1860   function getContractByLoanId(string _loanId) public view returns (address) {
1861     return contractById[_loanId].value;
1862   }
1863 
1864   function createERC20ETHLoanBorrowerClone(
1865     address _collateralTokenAddress,
1866     uint _borrowAmount,
1867     uint _paybackAmount,
1868     uint _collateralAmount,
1869     uint _daysPerInstallment,
1870     uint _remainingInstallment,
1871     string _loanId,
1872     address _lenderAddress
1873   ) public payable returns (address) {
1874     require(!contractById[_loanId].exists, "contract already exists");
1875 
1876     address clone = createClone(ERC20ETHLoanBorrowerMasterContractAddress);
1877     ERC20ETHLoanBorrower(clone).init({
1878       _ownerAddress : owner,
1879       _borrowerAddress : msg.sender,
1880       _lenderAddress : _lenderAddress,
1881       _collateralTokenAddress : _collateralTokenAddress,
1882       _borrowAmount : _borrowAmount,
1883       _paybackAmount : _paybackAmount,
1884       _collateralAmount : _collateralAmount,
1885       _daysPerInstallment : _daysPerInstallment,
1886       _remainingInstallment : _remainingInstallment,
1887       _loanId : _loanId});
1888 
1889     contractMap[msg.sender].push(clone);
1890     contractById[_loanId] = Library.contractAddress(clone, true);
1891     return clone;
1892   }
1893 
1894 
1895   function createERC20ETHLoanLenderClone(
1896     address _collateralTokenAddress,
1897     uint _borrowAmount,
1898     uint _paybackAmount,
1899     uint _collateralAmount,
1900     uint _daysPerInstallment,
1901     uint _remainingInstallment,
1902     string _loanId,
1903     address _borrowerAddress
1904   ) public payable returns (address) {
1905     require(!contractById[_loanId].exists, "contract already exists");
1906 
1907     address clone = createClone(ERC20ETHLoanLenderMasterContractAddress);
1908     ERC20ETHLoanLender(clone).init({
1909       _ownerAddress : owner,
1910       _borrowerAddress : _borrowerAddress,
1911       _lenderAddress : msg.sender,
1912       _collateralTokenAddress : _collateralTokenAddress,
1913       _borrowAmount : _borrowAmount,
1914       _paybackAmount : _paybackAmount,
1915       _collateralAmount : _collateralAmount,
1916       _daysPerInstallment : _daysPerInstallment,
1917       _remainingInstallment : _remainingInstallment,
1918       _loanId : _loanId});
1919 
1920     if (msg.value > 0) {
1921       ERC20ETHLoanLender(clone).transferFunds.value(msg.value)();
1922     }
1923     contractMap[msg.sender].push(clone);
1924     contractById[_loanId] = Library.contractAddress(clone, true);
1925     return clone;
1926   }
1927 
1928   function createETHERC20LoanBorrowerClone(
1929     address _borrowedTokenAddress,
1930     uint _borrowAmount,
1931     uint _paybackAmount,
1932     uint _collateralAmount,
1933     uint _daysPerInstallment,
1934     uint _remainingInstallment,
1935     string _loanId,
1936     address _lenderAddress
1937   ) public payable returns (address) {
1938     require(!contractById[_loanId].exists, "contract already exists");
1939 
1940     address clone = createClone(ETHERC20LoanBorrowerMasterContractAddress);
1941     ETHERC20LoanBorrower(clone).init({
1942       _ownerAddress : owner,
1943       _borrowerAddress : msg.sender,
1944       _lenderAddress : _lenderAddress,
1945       _borrowedTokenAddress : _borrowedTokenAddress,
1946       _borrowAmount : _borrowAmount,
1947       _paybackAmount : _paybackAmount,
1948       _collateralAmount : _collateralAmount,
1949       _daysPerInstallment : _daysPerInstallment,
1950       _remainingInstallment : _remainingInstallment,
1951       _loanId : _loanId});
1952 
1953     if (msg.value >= _collateralAmount) {
1954       ETHERC20LoanBorrower(clone).transferCollateral.value(msg.value)();
1955     }
1956 
1957     contractMap[msg.sender].push(clone);
1958     contractById[_loanId] = Library.contractAddress(clone, true);
1959     return clone;
1960   }
1961 
1962   function createETHERC20LoanLenderClone(
1963     address _borrowedTokenAddress,
1964     uint _borrowAmount,
1965     uint _paybackAmount,
1966     uint _collateralAmount,
1967     uint _daysPerInstallment,
1968     uint _remainingInstallment,
1969     string _loanId,
1970     address _borrowerAddress
1971   ) public payable returns (address) {
1972     require(!contractById[_loanId].exists, "contract already exists");
1973 
1974     address clone = createClone(ETHERC20LoanLenderMasterContractAddress);
1975     ETHERC20LoanLender(clone).init({
1976       _ownerAddress : owner,
1977       _borrowerAddress : _borrowerAddress,
1978       _lenderAddress : msg.sender,
1979       _borrowedTokenAddress : _borrowedTokenAddress,
1980       _borrowAmount : _borrowAmount,
1981       _paybackAmount : _paybackAmount,
1982       _collateralAmount : _collateralAmount,
1983       _daysPerInstallment : _daysPerInstallment,
1984       _remainingInstallment : _remainingInstallment,
1985       _loanId : _loanId});
1986 
1987     contractMap[msg.sender].push(clone);
1988     contractById[_loanId] = Library.contractAddress(clone, true);
1989     return clone;
1990   }
1991 
1992   function createERC20ERC20LoanBorrowerClone(
1993     address _collateralTokenAddress,
1994     address _borrowedTokenAddress,
1995     uint _borrowAmount,
1996     uint _paybackAmount,
1997     uint _collateralAmount,
1998     uint _daysPerInstallment,
1999     uint _remainingInstallment,
2000     string _loanId,
2001     address _lenderAddress
2002   ) public returns (address) {
2003     require(!contractById[_loanId].exists, "contract already exists");
2004 
2005     address clone = createClone(ERC20ERC20LoanBorrowerMasterContractAddress);
2006     ERC20ERC20LoanBorrower(clone).init({
2007       _ownerAddress : owner,
2008       _borrowerAddress : msg.sender,
2009       _lenderAddress : _lenderAddress,
2010       _collateralTokenAddress : _collateralTokenAddress,
2011       _borrowedTokenAddress : _borrowedTokenAddress,
2012       _borrowAmount : _borrowAmount,
2013       _paybackAmount : _paybackAmount,
2014       _collateralAmount : _collateralAmount,
2015       _daysPerInstallment : _daysPerInstallment,
2016       _remainingInstallment : _remainingInstallment,
2017       _loanId : _loanId});
2018     contractMap[msg.sender].push(clone);
2019     contractById[_loanId] = Library.contractAddress(clone, true);
2020     return clone;
2021   }
2022 
2023   function createERC20ERC20LoanLenderClone(
2024     address _collateralTokenAddress,
2025     address _borrowedTokenAddress,
2026     uint _borrowAmount,
2027     uint _paybackAmount,
2028     uint _collateralAmount,
2029     uint _daysPerInstallment,
2030     uint _remainingInstallment,
2031     string _loanId,
2032     address _borrowerAddress
2033   ) public returns (address) {
2034     require(!contractById[_loanId].exists, "contract already exists");
2035 
2036     address clone = createClone(ERC20ERC20LoanLenderMasterContractAddress);
2037     ERC20ERC20LoanLender(clone).init({
2038       _ownerAddress : owner,
2039       _borrowerAddress : _borrowerAddress,
2040       _lenderAddress : msg.sender,
2041       _collateralTokenAddress : _collateralTokenAddress,
2042       _borrowedTokenAddress : _borrowedTokenAddress,
2043       _borrowAmount : _borrowAmount,
2044       _paybackAmount : _paybackAmount,
2045       _collateralAmount : _collateralAmount,
2046       _daysPerInstallment : _daysPerInstallment,
2047       _remainingInstallment : _remainingInstallment,
2048       _loanId : _loanId});
2049     contractMap[msg.sender].push(clone);
2050     contractById[_loanId] = Library.contractAddress(clone, true);
2051     return clone;
2052   }
2053 
2054   function changeOwner(address newOwner) public onlyOwner {
2055     owner = newOwner;
2056   }
2057 }