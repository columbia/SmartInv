1 pragma solidity ^0.4.18;
2 // File: contracts/TulipsSaleInterface.sol
3 
4 /** @title Crypto Tulips Initial Sale Interface
5 * @dev This interface sets the standard for initial sale
6 * contract. All future sale contracts should follow this.
7 */
8 interface TulipsSaleInterface {
9     function putOnInitialSale(uint256 tulipId) external;
10     function createAuction(
11         uint256 _tulipId,
12         uint256 _startingPrice,
13         uint256 _endingPrice,
14         uint256 _duration,
15         address _transferFrom
16     )external;
17 }
18 
19 // File: contracts/ERC721.sol
20 
21 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
22 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
23 contract ERC721 {
24     // Required methods
25     function totalSupply() public view returns (uint256 total);
26     function balanceOf(address _owner) public view returns (uint256 balance);
27     function ownerOf(uint256 _tokenId) external view returns (address owner);
28     function approve(address _to, uint256 _tokenId) external;
29     function transfer(address _to, uint256 _tokenId) external;
30     function transferFrom(address _from, address _to, uint256 _tokenId) external;
31 
32     // Events
33     event Transfer(address from, address to, uint256 tokenId);
34     event Approval(address owner, address approved, uint256 tokenId);
35 }
36 
37 // File: contracts/ERC721MetaData.sol
38 
39 /// @title The external contract that is responsible for generatingmetadata for the tulips,
40 /// Taken from crypto kitties source. May change with our own implementation
41 contract ERC721Metadata {
42     /// @dev Given a token Id, returns a byte array that is supposed to be converted into string.
43     function getMetadata(uint256 _tokenId, string) public view returns (bytes32[4] buffer, uint256 count) {
44         if (_tokenId == 1) {
45             buffer[0] = "Hello World! :D";
46             count = 15;
47         } else if (_tokenId == 2) {
48             buffer[0] = "I would definitely choose a medi";
49             buffer[1] = "um length string.";
50             count = 49;
51         } else if (_tokenId == 3) {
52             buffer[0] = "Lorem ipsum dolor sit amet, mi e";
53             buffer[1] = "st accumsan dapibus augue lorem,";
54             buffer[2] = " tristique vestibulum id, libero";
55             buffer[3] = " suscipit varius sapien aliquam.";
56             count = 128;
57         }
58     }
59 }
60 
61 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69   address public owner;
70 
71 
72   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() public {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) public onlyOwner {
98     require(newOwner != address(0));
99     OwnershipTransferred(owner, newOwner);
100     owner = newOwner;
101   }
102 
103 }
104 
105 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
106 
107 /**
108  * @title Pausable
109  * @dev Base contract which allows children to implement an emergency stop mechanism.
110  */
111 contract Pausable is Ownable {
112   event Pause();
113   event Unpause();
114 
115   bool public paused = false;
116 
117 
118   /**
119    * @dev Modifier to make a function callable only when the contract is not paused.
120    */
121   modifier whenNotPaused() {
122     require(!paused);
123     _;
124   }
125 
126   /**
127    * @dev Modifier to make a function callable only when the contract is paused.
128    */
129   modifier whenPaused() {
130     require(paused);
131     _;
132   }
133 
134   /**
135    * @dev called by the owner to pause, triggers stopped state
136    */
137   function pause() onlyOwner whenNotPaused public {
138     paused = true;
139     Pause();
140   }
141 
142   /**
143    * @dev called by the owner to unpause, returns to normal state
144    */
145   function unpause() onlyOwner whenPaused public {
146     paused = false;
147     Unpause();
148   }
149 }
150 
151 // File: contracts/TulipsRoles.sol
152 
153 /*
154 * @title Crypto Tulips SaleAuction
155 * @dev .
156 */
157 contract TulipsRoles is Pausable {
158 
159     modifier onlyFinancial() {
160         require(msg.sender == address(financialAccount));
161         _;
162     }
163 
164     modifier onlyOperations() {
165         require(msg.sender == address(operationsAccount));
166         _;
167     }
168 
169     function TulipsRoles() Ownable() public {
170         financialAccount = msg.sender;
171         operationsAccount = msg.sender;
172     }
173 
174     address public financialAccount;
175     address public operationsAccount;
176 
177     function transferFinancial(address newFinancial) public onlyOwner {
178         require(newFinancial != address(0));
179         financialAccount = newFinancial;
180     }
181 
182     function transferOperations(address newOperations) public onlyOwner {
183         require(newOperations != address(0));
184         operationsAccount = newOperations;
185     }
186 
187 }
188 
189 // File: contracts/TulipsStorage.sol
190 
191 contract TulipsStorage is TulipsRoles {
192 
193     //// DATA
194 
195     /*
196     * Main tulip struct.
197     * Visual Info is the dna used to create the tulip image
198     * Visual Hash hash of the image file to confirm validity if needed.
199     */
200     struct Tulip {
201         uint256 visualInfo;
202         bytes32 visualHash;
203     }
204 
205     //// STORAGE
206     /*
207     * @dev Array of all tulips created indexed with tulipID.
208     */
209     Tulip[] public tulips;
210 
211     /*
212     * @dev Maps tulipId's to owner addreses
213     */
214     mapping (uint256 => address) public tulipIdToOwner;
215 
216     /*
217     * @dev Maps owner adress to number of tulips owned.
218     * Bookkeeping for compliance with ERC20 and ERC721. Doesn't mean much in terms of
219     * value of individual unfungable assets.
220     */
221     mapping (address => uint256) tulipOwnershipCount;
222 
223     /// @dev Maps tulipId to approved reciever of a pending token transfer.
224     mapping (uint256 => address) public tulipIdToApprovedTranserAddress;
225 }
226 
227 // File: contracts/TulipsTokenInterface.sol
228 
229 /*
230 * @title Crypto Tulips Token Interface
231 * @dev This contract provides interface to ERC721 support.
232 */
233 contract TulipsTokenInterface is TulipsStorage, ERC721 {
234 
235     //// TOKEN SPECS & META DATA
236 
237     /// @notice Name and symbol of the non fungible token, as defined in ERC721.
238     string public constant name = "CryptoTulips";
239     string public constant symbol = "CT";
240 
241     /*
242     * @dev This external contract will return Tulip metadata. We are making this changable in case
243     * we need to update our current uri scheme later on.
244     */
245     ERC721Metadata public erc721Metadata;
246 
247     /// @dev Set the address of the external contract that generates the metadata.
248     function setMetadataAddress(address _contractAddress) public onlyOperations {
249         erc721Metadata = ERC721Metadata(_contractAddress);
250     }
251 
252     //// EVENTS
253 
254     /*
255     * @dev Transfer event as defined in ERC721.
256     */
257     event Transfer(address from, address to, uint256 tokenId);
258 
259     /*
260     * @dev Approval event as defined in ERC721.
261     */
262     event Approval(address owner, address approved, uint256 tokenId);
263 
264     //// TRANSFER DATA
265 
266     /*
267     * @dev Maps tulipId to approved transfer address
268     */
269     mapping (uint256 => address) public tulipIdToApproved;
270 
271 
272     //// PUBLIC FACING FUNCTIONS
273     /*
274     * @notice Returns total number of Tulips created so far.
275     */
276     function totalSupply() public view returns (uint) {
277         return tulips.length - 1;
278     }
279 
280     /*
281     * @notice Returns the number of Tulips owned by given address.
282     * @param _owner The Tulip owner.
283     */
284     function balanceOf(address _owner) public view returns (uint256 count) {
285         return tulipOwnershipCount[_owner];
286     }
287 
288     /*
289     * @notice Returns the owner of the given Tulip
290     */
291     function ownerOf(uint256 _tulipId)
292         external
293         view
294         returns (address owner)
295     {
296         owner = tulipIdToOwner[_tulipId];
297 
298         // If owner adress is empty this is still a fresh Tulip waiting for its first owner.
299         require(owner != address(0));
300     }
301 
302     /*
303     * @notice Unlocks the tulip for transfer. The reciever can calltransferFrom() to
304     * get ownership of the tulip. This is a safer method since you can revoke the transfer
305     * if you mistakenly send it to an invalid address.
306     * @param _to The reciever address. Set to address(0) to revoke the approval.
307     * @param _tulipId The tulip to be transfered
308     */
309     function approve(
310         address _to,
311         uint256 _tulipId
312     )
313         external
314         whenNotPaused
315     {
316         // Only an owner can grant transfer approval.
317         require(tulipIdToOwner[_tulipId] == msg.sender);
318 
319         // Register the approval
320         _approve(_tulipId, _to);
321 
322         // Emit approval event.
323         Approval(msg.sender, _to, _tulipId);
324     }
325 
326     /*
327     * @notice Transfers a tulip to another address without confirmation.
328     * If the reciever's address is invalid tulip may be lost! Use approve() and transferFrom() instead.
329     * @param _to The reciever address.
330     * @param _tulipId The tulip to be transfered
331     */
332     function transfer(
333         address _to,
334         uint256 _tulipId
335     )
336         external
337         whenNotPaused
338     {
339         // Safety checks for common mistakes.
340         require(_to != address(0));
341         require(_to != address(this));
342 
343         // You can only send tulips you own.
344         require(tulipIdToOwner[_tulipId] == msg.sender);
345 
346         // Do the transfer
347         _transfer(msg.sender, _to, _tulipId);
348     }
349 
350     /*
351     * @notice This method allows the caller to recieve a tulip if the caller is the approved address
352     * caller can also give another address to recieve the tulip.
353     * @param _from Current owner of the tulip.
354     * @param _to New owner of the tulip
355     * @param _tulipId The tulip to be transfered
356     */
357     function transferFrom(
358         address _from,
359         address _to,
360         uint256 _tulipId
361     )
362         external
363         whenNotPaused
364     {
365         // Safety checks for common mistakes.
366         require(_to != address(0));
367         require(_to != address(this));
368 
369         // Check for approval and valid ownership
370         require(tulipIdToApproved[_tulipId] == msg.sender);
371         require(tulipIdToOwner[_tulipId] == _from);
372 
373         // Do the transfer
374         _transfer(_from, _to, _tulipId);
375     }
376 
377     /// @notice Returns metadata for the tulip.
378     /// @param _tulipId The tulip to recieve information on
379     function tokenMetadata(uint256 _tulipId, string _preferredTransport) external view returns (string infoUrl) {
380         // We will set the meta data scheme in an external contract
381         require(erc721Metadata != address(0));
382 
383         // Contracts cannot return string to each other so we do this
384         bytes32[4] memory buffer;
385         uint256 count;
386         (buffer, count) = erc721Metadata.getMetadata(_tulipId, _preferredTransport);
387 
388         return _toString(buffer, count);
389     }
390 
391     //// INTERNAL FUNCTIONS THAT ACTUALLY DO STUFF
392     // These are called by public facing functions after sanity checks
393 
394     function _transfer(address _from, address _to, uint256 _tulipId) internal {
395         // Increase total Tulips owned by _to address
396         tulipOwnershipCount[_to]++;
397 
398         // Decrease total Tulips owned by _from address, if _from address is not empty
399         if (_from != address(0)) {
400             tulipOwnershipCount[_from]--;
401         }
402 
403         // Update mapping of tulipID -> ownerAddress
404         tulipIdToOwner[_tulipId] = _to;
405 
406         // Emit the transfer event.
407         Transfer(_from, _to, _tulipId);
408     }
409 
410     function _approve(uint256 _tulipId, address _approved) internal{
411         tulipIdToApproved[_tulipId] = _approved;
412         // Approve event is only sent on public facing function
413     }
414 
415     //// UTILITY FUNCTIONS
416 
417     /// @dev Adapted from toString(slice) by @arachnid (Nick Johnson <arachnid@notdot.net>)
418     ///  This method is licenced under the Apache License.
419     ///  Ref: https://github.com/Arachnid/solidity-stringutils/blob/2f6ca9accb48ae14c66f1437ec50ed19a0616f78/strings.sol
420     function _toString(bytes32[4] _rawBytes, uint256 _stringLength)private view returns (string) {
421         var outputString = new string(_stringLength);
422         uint256 outputPtr;
423         uint256 bytesPtr;
424 
425         assembly {
426             outputPtr := add(outputString, 32)
427             bytesPtr := _rawBytes
428         }
429 
430         _memcpy(outputPtr, bytesPtr, _stringLength);
431 
432         return outputString;
433     }
434 
435     function _memcpy(uint dest, uint src, uint len) private view {
436         // Copy word-length chunks while possible
437         for(; len >= 32; len -= 32) {
438             assembly {
439                 mstore(dest, mload(src))
440             }
441             dest += 32;
442             src += 32;
443         }
444 
445         // Copy remaining bytes
446         uint mask = 256 ** (32 - len) - 1;
447         assembly {
448             let srcpart := and(mload(src), not(mask))
449             let destpart := and(mload(dest), mask)
450             mstore(dest, or(destpart, srcpart))
451         }
452     }
453 
454 }
455 
456 // File: contracts/TulipsCreation.sol
457 
458 /*
459 * @title Crypto Tulips Creation Mechanisms & Core Contract
460 * @dev This contract provides methods in which we create new tulips.
461 */
462 contract TulipsCreation is TulipsTokenInterface {
463 
464     //// STATS & LIMITS
465     uint256 public constant TOTAL_TULIP_SUPPLY = 100000;
466     uint256 public totalTulipCount;
467 
468     //// Sale contract
469     TulipsSaleInterface public initialSaleContract;
470 
471     //// EVENTS
472 
473     /*
474     * @dev Announces creation of a new tulip.
475     */
476     event TulipCreation(uint256 tulipId, uint256 visualInfo);
477 
478     /*
479     * We have this in case we have to change the initial sale contract
480     */
481     function setSaleAuction(address _initialSaleContractAddress) external onlyOwner {
482         initialSaleContract = TulipsSaleInterface(_initialSaleContractAddress);
483     }
484 
485     function getSaleAuctionAddress() external view returns(address){
486         return address(initialSaleContract);
487     }
488 
489     //// CREATION INTERFACE
490     /*
491     * @dev This function mints a new Tulip .
492     * @param _visualInfo Visual information used to generate tulip image.
493     * @param _visualHash Keccak hash of generated image.
494     */
495     function createTulip( uint256 _visualInfo, bytes32 _visualHash )  external onlyOperations
496         returns (uint)
497     {
498         require(totalTulipCount<TOTAL_TULIP_SUPPLY);
499 
500         Tulip memory tulip = Tulip({
501             visualInfo: _visualInfo,
502             visualHash: _visualHash
503         });
504 
505         uint256 tulipId = tulips.push(tulip) - 1;
506 
507         // New created tulip is owned by initial sale auction at first
508         tulipIdToOwner[tulipId] = address(initialSaleContract);
509         initialSaleContract.putOnInitialSale(tulipId);
510 
511         totalTulipCount++;
512 
513         // Let the world know about this new tulip
514         TulipCreation(
515             tulipId, _visualInfo
516         );
517 
518         return tulipId;
519     }
520 
521     /*
522     * @dev This method authorizes for transfer and puts tulip on auction on a single call.
523     * This could be done in two seperate calls approve() and createAuction()
524     * but this way we can offer a single operation version that canbe triggered from web ui.
525     */
526     function putOnAuction(
527         uint256 _tulipId,
528         uint256 _startingPrice,
529         uint256 _endingPrice,
530         uint256 _duration
531     )
532         external
533         whenNotPaused
534     {
535 
536         require(tulipIdToOwner[_tulipId] == msg.sender);
537 
538         tulipIdToApproved[_tulipId] = address(initialSaleContract);
539 
540         initialSaleContract.createAuction(
541             _tulipId,
542             _startingPrice,
543             _endingPrice,
544             _duration,
545             msg.sender
546         );
547     }
548 
549 
550 }