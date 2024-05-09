1 pragma solidity ^0.4.24;
2 
3 /*
4   __  __                                                    _       ___   ___  __  ___  
5  |  \/  |                         /\                       | |     |__ \ / _ \/_ |/ _ \ 
6  | \  / | ___ _ __ ___   ___     /  \__      ____ _ _ __ __| |___     ) | | | || | (_) |
7  | |\/| |/ _ \ '_ ` _ \ / _ \   / /\ \ \ /\ / / _` | '__/ _` / __|   / /| | | || |> _ < 
8  | |  | |  __/ | | | | |  __/  / ____ \ V  V / (_| | | | (_| \__ \  / /_| |_| || | (_) |
9  |_|  |_|\___|_| |_| |_|\___| /_/    \_\_/\_/ \__,_|_|  \__,_|___/ |____|\___/ |_|\___/
10 
11 */
12 
13 
14 /**
15  * @title IERC165
16  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
17  */
18 contract IERC165 {
19     /**
20      * @notice Query if a contract implements an interface
21      * @param interfaceId The interface identifier, as specified in ERC-165
22      * @dev Interface identification is specified in ERC-165. This function
23      * uses less than 30,000 gas.
24      */
25     function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 
29 /**
30  * @title ERC721 Non-Fungible Token Standard basic interface
31  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
32  */
33 contract IERC721 {
34     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
35     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
36     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
37 
38     function balanceOf(address owner) public view returns (uint256 balance);
39     function ownerOf(uint256 tokenId) public view returns (address owner);
40 
41     function approve(address to, uint256 tokenId) public;
42     function getApproved(uint256 tokenId) public view returns (address operator);
43 
44     function setApprovalForAll(address operator, bool _approved) public;
45     function isApprovedForAll(address owner, address operator) public view returns (bool);
46 
47     function transferFrom(address from, address to, uint256 tokenId) public;
48     function safeTransferFrom(address from, address to, uint256 tokenId) public;
49 
50     function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) public;
51 }
52 
53 
54 /**
55  * @title ERC721 token receiver interface
56  * @dev Interface for any contract that wants to support safeTransfers
57  * from ERC721 asset contracts.
58  */
59 contract IERC721Receiver {
60     /**
61      * @notice Handle the receipt of an NFT
62      * @dev The ERC721 smart contract calls this function on the recipient
63      * after a `safeTransfer`. This function MUST return the function selector,
64      * otherwise the caller will revert the transaction. The selector to be
65      * returned can be obtained as `this.onERC721Received.selector`. This
66      * function MAY throw to revert and reject the transfer.
67      * Note: the ERC721 contract address is always the message sender.
68      * @param operator The address which called `safeTransferFrom` function
69      * @param from The address which previously owned the token
70      * @param tokenId The NFT identifier which is being transferred
71      * @param data Additional data with no specified format
72      * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
73      */
74     function onERC721Received(address operator, address from, uint256 tokenId, bytes data) public returns (bytes4);
75 }
76 
77 
78 /**
79  * @title ERC165
80  * @author Matt Condon (@shrugs)
81  * @dev Implements ERC165 using a lookup table.
82  */
83 contract ERC165 is IERC165 {
84     bytes4 private constant _InterfaceId_ERC165 = 0x01ffc9a7;
85     /**
86      * 0x01ffc9a7 ===
87      *     bytes4(keccak256('supportsInterface(bytes4)'))
88      */
89 
90     /**
91      * @dev a mapping of interface id to whether or not it's supported
92      */
93     mapping(bytes4 => bool) private _supportedInterfaces;
94 
95     /**
96      * @dev A contract implementing SupportsInterfaceWithLookup
97      * implement ERC165 itself
98      */
99     constructor () internal {
100         _registerInterface(_InterfaceId_ERC165);
101     }
102 
103     /**
104      * @dev implement supportsInterface(bytes4) using a lookup table
105      */
106     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
107         return _supportedInterfaces[interfaceId];
108     }
109 
110     /**
111      * @dev internal method for registering an interface
112      */
113     function _registerInterface(bytes4 interfaceId) internal {
114         require(interfaceId != 0xffffffff);
115         _supportedInterfaces[interfaceId] = true;
116     }
117 }
118 
119 
120 /**
121  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
122  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
123  */
124 contract IERC721Metadata {
125     function name() external view returns (string);
126     function symbol() external view returns (string);
127     function tokenURI(uint256 tokenId) external view returns (string);
128 }
129 
130 
131 /**
132  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
133  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
134  */
135 contract IERC721Enumerable {
136     function totalSupply() public view returns (uint256);
137     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
138 
139     function tokenByIndex(uint256 index) public view returns (uint256);
140 }
141 
142 
143 contract ERC20Token {
144     function balanceOf(address owner) public view returns (uint256);
145     function transfer(address to, uint256 value) public returns (bool);
146 }
147 
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155     address private _owner;
156 
157     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
158 
159     /**
160      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161      * account.
162      */
163     constructor () internal {
164         _owner = msg.sender;
165         emit OwnershipTransferred(address(0), _owner);
166     }
167 
168     /**
169      * @return the address of the owner.
170      */
171     function owner() public view returns (address) {
172         return _owner;
173     }
174 
175     /**
176      * @dev Throws if called by any account other than the owner.
177      */
178     modifier onlyOwner() {
179         require(isOwner());
180         _;
181     }
182 
183     /**
184      * @return true if `msg.sender` is the owner of the contract.
185      */
186     function isOwner() public view returns (bool) {
187         return msg.sender == _owner;
188     }
189 
190     /**
191      * @dev Allows the current owner to relinquish control of the contract.
192      * @notice Renouncing to ownership will leave the contract without an owner.
193      * It will not be possible to call the functions with the `onlyOwner`
194      * modifier anymore.
195      */
196     function renounceOwnership() public onlyOwner {
197         emit OwnershipTransferred(_owner, address(0));
198         _owner = address(0);
199     }
200 
201     /**
202      * @dev Allows the current owner to transfer control of the contract to a newOwner.
203      * @param newOwner The address to transfer ownership to.
204      */
205     function transferOwnership(address newOwner) public onlyOwner {
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers control of the contract to a newOwner.
211      * @param newOwner The address to transfer ownership to.
212      */
213     function _transferOwnership(address newOwner) internal {
214         require(newOwner != address(0));
215         emit OwnershipTransferred(_owner, newOwner);
216         _owner = newOwner;
217     }
218 }
219 
220 
221 /**
222  * @title SafeMath
223  * @dev Math operations with safety checks that revert on error
224  */
225 library SafeMath {
226     int256 constant private INT256_MIN = -2**255;
227 
228     /**
229     * @dev Multiplies two unsigned integers, reverts on overflow.
230     */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
233         // benefit is lost if 'b' is also tested.
234         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
235         if (a == 0) {
236             return 0;
237         }
238 
239         uint256 c = a * b;
240         require(c / a == b);
241 
242         return c;
243     }
244 
245     /**
246     * @dev Multiplies two signed integers, reverts on overflow.
247     */
248     function mul(int256 a, int256 b) internal pure returns (int256) {
249         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
250         // benefit is lost if 'b' is also tested.
251         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
252         if (a == 0) {
253             return 0;
254         }
255 
256         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
257 
258         int256 c = a * b;
259         require(c / a == b);
260 
261         return c;
262     }
263 
264     /**
265     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
266     */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         // Solidity only automatically asserts when dividing by 0
269         require(b > 0);
270         uint256 c = a / b;
271         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
272 
273         return c;
274     }
275 
276     /**
277     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
278     */
279     function div(int256 a, int256 b) internal pure returns (int256) {
280         require(b != 0); // Solidity only automatically asserts when dividing by 0
281         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
282 
283         int256 c = a / b;
284 
285         return c;
286     }
287 
288     /**
289     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
290     */
291     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
292         require(b <= a);
293         uint256 c = a - b;
294 
295         return c;
296     }
297 
298     /**
299     * @dev Subtracts two signed integers, reverts on overflow.
300     */
301     function sub(int256 a, int256 b) internal pure returns (int256) {
302         int256 c = a - b;
303         require((b >= 0 && c <= a) || (b < 0 && c > a));
304 
305         return c;
306     }
307 
308     /**
309     * @dev Adds two unsigned integers, reverts on overflow.
310     */
311     function add(uint256 a, uint256 b) internal pure returns (uint256) {
312         uint256 c = a + b;
313         require(c >= a);
314 
315         return c;
316     }
317 
318     /**
319     * @dev Adds two signed integers, reverts on overflow.
320     */
321     function add(int256 a, int256 b) internal pure returns (int256) {
322         int256 c = a + b;
323         require((b >= 0 && c >= a) || (b < 0 && c < a));
324 
325         return c;
326     }
327 
328     /**
329     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
330     * reverts when dividing by zero.
331     */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         require(b != 0);
334         return a % b;
335     }
336 }
337 
338 
339 /**
340  * Utility library of inline functions on addresses
341  */
342 library Address {
343     /**
344      * Returns whether the target address is a contract
345      * @dev This function will return false if invoked during the constructor of a contract,
346      * as the code is not actually created until after the constructor finishes.
347      * @param account address of the account to check
348      * @return whether the target address is a contract
349      */
350     function isContract(address account) internal view returns (bool) {
351         uint256 size;
352         // XXX Currently there is no better way to check if there is a contract in an address
353         // than to check the size of the code at that address.
354         // See https://ethereum.stackexchange.com/a/14016/36603
355         // for more details about how this works.
356         // TODO Check this again before the Serenity release, because all addresses will be
357         // contracts then.
358         // solium-disable-next-line security/no-inline-assembly
359         assembly { size := extcodesize(account) }
360         return size > 0;
361     }
362 }
363 
364 
365 /**
366  * @title ERC721 Non-Fungible Token Standard BrofistCoin custom implementation
367  * @dev Please report any issues to info@brofistcoin.io or @brofistcoin on Telegram 
368  */
369 contract MemeAwards2018 is ERC165, IERC721, IERC721Metadata, IERC721Enumerable, Ownable {
370     using SafeMath for uint256;
371     using Address for address;
372     
373     string private _name;
374     string private _symbol;
375     uint256 private releaseDate;
376     bytes4 private constant InterfaceId_ERC721Metadata = 0x5b5e139f;
377     bytes4 private constant _InterfaceId_ERC721Enumerable = 0x780e9d63;
378     bytes4 private constant _InterfaceId_ERC721 = 0x80ac58cd;
379     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
380     
381     // Mapping from token ID to owner
382     mapping (uint256 => address) private _tokenOwner;
383 
384     // Mapping from token ID to approved address
385     mapping (uint256 => address) private _tokenApprovals;
386 
387     // Mapping from owner to number of owned tokens
388     mapping (address => uint256) private _ownedTokensCount;
389 
390     // Mapping from owner to operator approvals
391     mapping (address => mapping (address => bool)) private _operatorApprovals;
392     
393     // Mapping from airdrop receiver to boolean 
394     mapping (address => bool) public hasClaimed;
395 
396     // Meme struct holds the templateId
397     struct Meme {
398         uint32 templateId;
399     }
400     
401     // Template struct holds the uris for templateIds
402     struct Template {
403         string uri;
404     }
405     
406     // All the tokens in existence 
407     Meme[] private claimedMemes;
408     
409     // Admin editable templates for each meme 
410     Template[] private memeTemplates;
411 
412     // Throws when msg.sender has already claimed the airdrop 
413     modifier hasNotClaimed() {
414         require(hasClaimed[msg.sender] == false);
415         _;
416     }
417     
418     // Throws when the 30 day airdrop period has passed 
419     modifier canClaim() {
420         require(releaseDate + 30 days >= now);
421         _;
422     }
423     
424     constructor(string name, string symbol) public {
425         // Set name
426         _name = name;
427         // Set symbol 
428         _symbol = symbol;
429         // register the supported interfaces to conform to ERC721 via ERC165
430         _registerInterface(InterfaceId_ERC721Metadata);
431         // register the supported interface to conform to ERC721 via ERC165
432         _registerInterface(_InterfaceId_ERC721Enumerable);
433         // register the supported interfaces to conform to ERC721 via ERC165
434         _registerInterface(_InterfaceId_ERC721);
435         // Set releaseDate
436         releaseDate = now;
437     }
438     
439     /* Returns a predictable and insecure pseudo random number between 0 - 9 
440     which represent the 10 MemeAwards 2018 meme templates (templateId) */
441     function _randomMeme() private view returns (uint8) {
442         return uint8(uint256(keccak256(abi.encodePacked(now, msg.sender))) % 10);
443     }
444     
445     // Function to claim the meme airdrop 
446     function claimMeme() public hasNotClaimed canClaim {
447         // Store the random number for reference 
448         uint32 randomMemeId = _randomMeme();
449         // Push new token to claimedMemes with randomMemeId as its templateId
450         uint id = claimedMemes.push(Meme(randomMemeId)) -1;
451         // Mint the token with the id from claimedMemes array 
452         _mint(msg.sender, id);
453         // Set boolean for hasClaimed
454         hasClaimed[msg.sender] = true;
455     }
456     
457     // Iterate through claimed memes and get the count based on its templateId
458     // ie. how many of Bitch Lasagna exists 
459     function getIndividualCount(uint32 _templateId) external view returns (uint) {
460         uint counter = 0;
461         for (uint i = 0; i < claimedMemes.length; i++) {
462             if (claimedMemes[i].templateId == _templateId) {
463                 counter++;
464             }
465         }
466         // Total supply of n meme
467         return counter;
468     }
469     
470     // Get all the memes by owner 
471     function getMemesByOwner(address _owner) public view returns(uint[]) {
472         uint[] memory result = new uint[](_ownedTokensCount[_owner]);
473         uint counter = 0;
474         for (uint i = 0; i < claimedMemes.length; i++) {
475             if (_tokenOwner[i] == _owner) {
476                 result[counter] = i;
477                 counter++;
478             }
479         }
480         // Array of ID's in claimedMemes that _owner owns 
481         return result;
482     }
483     
484     // Get end time
485     function getEndTime() external view returns (uint) {
486         return releaseDate + 30 days;
487     }
488 
489     // Function to withdraw any ERC20 tokens that might be sent here for whatever reasons 
490     function withdrawERC20Tokens(address _tokenContract) external onlyOwner returns (bool) {
491         ERC20Token token = ERC20Token(_tokenContract);
492         uint256 amount = token.balanceOf(address(this));
493         return token.transfer(msg.sender, amount);
494     }
495     
496     // And just in case for ETH too (shouldn't happen though)  
497     function withdraw() external onlyOwner {
498         uint256 etherBalance = address(this).balance;
499         msg.sender.transfer(etherBalance);
500     }
501     
502     // Admin function to set meme template uris
503     function setMemeTemplate(string _uri) external onlyOwner {
504         require(memeTemplates.length < 10);
505         memeTemplates.push(Template(_uri));
506     }
507     
508     // Admin function to edit meme template uris 
509     // If we wanted to host elsewhere like IPFS for example 
510     function editMemeTemplate(uint _templateId, string _newUri) external onlyOwner {
511         memeTemplates[_templateId].uri = _newUri;
512     }
513     
514     // Return the total supply
515     function totalSupply() public view returns (uint256) {
516         return claimedMemes.length;
517     }
518     
519     // Return the templateId of _index token 
520     function tokenByIndex(uint256 _index) public view returns (uint256) {
521         require(_index < totalSupply());
522         return claimedMemes[_index].templateId;
523     }
524     
525     // Return The token templateId for the index'th token assigned to owner
526     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId) {
527         require(index < balanceOf(owner));
528         return getMemesByOwner(owner)[index];
529     }
530 
531     /**
532      * @dev Gets the token name
533      * @return string representing the token name
534      */
535     function name() external view returns (string) {
536         return _name;
537     }
538 
539     /**
540      * @dev Gets the token symbol
541      * @return string representing the token symbol
542      */
543     function symbol() external view returns (string) {
544         return _symbol;
545     }
546 
547     /**
548      * @dev Returns an URI for a given token ID
549      * Throws if the token ID does not exist. May return an empty string.
550      * @param tokenId uint256 ID of the token to query
551      */
552     function tokenURI(uint256 tokenId) external view returns (string) {
553         require(_exists(tokenId));
554         uint tokenTemplateId = claimedMemes[tokenId].templateId;
555         return memeTemplates[tokenTemplateId].uri;
556     }
557 
558     /**
559      * @dev Gets the balance of the specified address
560      * @param owner address to query the balance of
561      * @return uint256 representing the amount owned by the passed address
562      */
563     function balanceOf(address owner) public view returns (uint256) {
564         require(owner != address(0));
565         return _ownedTokensCount[owner];
566     }
567 
568     /**
569      * @dev Gets the owner of the specified token ID
570      * @param tokenId uint256 ID of the token to query the owner of
571      * @return owner address currently marked as the owner of the given token ID
572      */
573     function ownerOf(uint256 tokenId) public view returns (address) {
574         address owner = _tokenOwner[tokenId];
575         require(owner != address(0));
576         return owner;
577     }
578 
579     /**
580      * @dev Approves another address to transfer the given token ID
581      * The zero address indicates there is no approved address.
582      * There can only be one approved address per token at a given time.
583      * Can only be called by the token owner or an approved operator.
584      * @param to address to be approved for the given token ID
585      * @param tokenId uint256 ID of the token to be approved
586      */
587     function approve(address to, uint256 tokenId) public {
588         address owner = ownerOf(tokenId);
589         require(to != owner);
590         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
591 
592         _tokenApprovals[tokenId] = to;
593         emit Approval(owner, to, tokenId);
594     }
595 
596     /**
597      * @dev Gets the approved address for a token ID, or zero if no address set
598      * Reverts if the token ID does not exist.
599      * @param tokenId uint256 ID of the token to query the approval of
600      * @return address currently approved for the given token ID
601      */
602     function getApproved(uint256 tokenId) public view returns (address) {
603         require(_exists(tokenId));
604         return _tokenApprovals[tokenId];
605     }
606 
607     /**
608      * @dev Sets or unsets the approval of a given operator
609      * An operator is allowed to transfer all tokens of the sender on their behalf
610      * @param to operator address to set the approval
611      * @param approved representing the status of the approval to be set
612      */
613     function setApprovalForAll(address to, bool approved) public {
614         require(to != msg.sender);
615         _operatorApprovals[msg.sender][to] = approved;
616         emit ApprovalForAll(msg.sender, to, approved);
617     }
618 
619     /**
620      * @dev Tells whether an operator is approved by a given owner
621      * @param owner owner address which you want to query the approval of
622      * @param operator operator address which you want to query the approval of
623      * @return bool whether the given operator is approved by the given owner
624      */
625     function isApprovedForAll(address owner, address operator) public view returns (bool) {
626         return _operatorApprovals[owner][operator];
627     }
628 
629     /**
630      * @dev Transfers the ownership of a given token ID to another address
631      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
632      * Requires the msg sender to be the owner, approved, or operator
633      * @param from current owner of the token
634      * @param to address to receive the ownership of the given token ID
635      * @param tokenId uint256 ID of the token to be transferred
636     */
637     function transferFrom(address from, address to, uint256 tokenId) public {
638         require(_isApprovedOrOwner(msg.sender, tokenId));
639 
640         _transferFrom(from, to, tokenId);
641     }
642 
643     /**
644      * @dev Safely transfers the ownership of a given token ID to another address
645      * If the target address is a contract, it must implement `onERC721Received`,
646      * which is called upon a safe transfer, and return the magic value
647      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
648      * the transfer is reverted.
649      *
650      * Requires the msg sender to be the owner, approved, or operator
651      * @param from current owner of the token
652      * @param to address to receive the ownership of the given token ID
653      * @param tokenId uint256 ID of the token to be transferred
654     */
655     function safeTransferFrom(address from, address to, uint256 tokenId) public {
656         // solium-disable-next-line arg-overflow
657         safeTransferFrom(from, to, tokenId, "");
658     }
659 
660     /**
661      * @dev Safely transfers the ownership of a given token ID to another address
662      * If the target address is a contract, it must implement `onERC721Received`,
663      * which is called upon a safe transfer, and return the magic value
664      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
665      * the transfer is reverted.
666      * Requires the msg sender to be the owner, approved, or operator
667      * @param from current owner of the token
668      * @param to address to receive the ownership of the given token ID
669      * @param tokenId uint256 ID of the token to be transferred
670      * @param _data bytes data to send along with a safe transfer check
671      */
672     function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public {
673         transferFrom(from, to, tokenId);
674         // solium-disable-next-line arg-overflow
675         require(_checkOnERC721Received(from, to, tokenId, _data));
676     }
677 
678     /**
679      * @dev Returns whether the specified token exists
680      * @param tokenId uint256 ID of the token to query the existence of
681      * @return whether the token exists
682      */
683     function _exists(uint256 tokenId) internal view returns (bool) {
684         address owner = _tokenOwner[tokenId];
685         return owner != address(0);
686     }
687 
688     /**
689      * @dev Returns whether the given spender can transfer a given token ID
690      * @param spender address of the spender to query
691      * @param tokenId uint256 ID of the token to be transferred
692      * @return bool whether the msg.sender is approved for the given token ID,
693      *    is an operator of the owner, or is the owner of the token
694      */
695     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
696         address owner = ownerOf(tokenId);
697         // Disable solium check because of
698         // https://github.com/duaraghav8/Solium/issues/175
699         // solium-disable-next-line operator-whitespace
700         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
701     }
702 
703     /**
704      * @dev Internal function to mint a new token
705      * Reverts if the given token ID already exists
706      * @param to The address that will own the minted token
707      * @param tokenId uint256 ID of the token to be minted
708      */
709     function _mint(address to, uint256 tokenId) internal {
710         require(to != address(0));
711         require(!_exists(tokenId));
712 
713         _tokenOwner[tokenId] = to;
714         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
715 
716         emit Transfer(address(0), to, tokenId);
717     }
718 
719     /**
720      * @dev Internal function to transfer ownership of a given token ID to another address.
721      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
722      * @param from current owner of the token
723      * @param to address to receive the ownership of the given token ID
724      * @param tokenId uint256 ID of the token to be transferred
725     */
726     function _transferFrom(address from, address to, uint256 tokenId) internal {
727         require(ownerOf(tokenId) == from);
728         require(to != address(0));
729 
730         _clearApproval(tokenId);
731 
732         _ownedTokensCount[from] = _ownedTokensCount[from].sub(1);
733         _ownedTokensCount[to] = _ownedTokensCount[to].add(1);
734 
735         _tokenOwner[tokenId] = to;
736 
737         emit Transfer(from, to, tokenId);
738     }
739 
740     /**
741      * @dev Internal function to invoke `onERC721Received` on a target address
742      * The call is not executed if the target address is not a contract
743      * @param from address representing the previous owner of the given token ID
744      * @param to target address that will receive the tokens
745      * @param tokenId uint256 ID of the token to be transferred
746      * @param _data bytes optional data to send along with the call
747      * @return whether the call correctly returned the expected magic value
748      */
749     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) internal returns (bool) {
750         if (!to.isContract()) {
751             return true;
752         }
753 
754         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
755         return (retval == _ERC721_RECEIVED);
756     }
757 
758     /**
759      * @dev Private function to clear current approval of a given token ID
760      * @param tokenId uint256 ID of the token to be transferred
761      */
762     function _clearApproval(uint256 tokenId) private {
763         if (_tokenApprovals[tokenId] != address(0)) {
764             _tokenApprovals[tokenId] = address(0);
765         }
766     }
767 }