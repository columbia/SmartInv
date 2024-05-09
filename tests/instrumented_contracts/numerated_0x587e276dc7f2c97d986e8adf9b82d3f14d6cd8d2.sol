1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16     if (a == 0) {
17       return 0;
18     }
19     uint256 c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   /**
35   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256) {
46     uint256 c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 contract ERC20 is ERC20Basic {
53   function allowance(address owner, address spender) public view returns (uint256);
54   function transferFrom(address from, address to, uint256 value) public returns (bool);
55   function approve(address spender, uint256 value) public returns (bool);
56   event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract BasicToken is ERC20Basic {
60   using SafeMath for uint256;
61 
62   mapping(address => uint256) balances;
63 
64   uint256 totalSupply_;
65 
66   /**
67   * @dev total number of tokens in existence
68   */
69   function totalSupply() public view returns (uint256) {
70     return totalSupply_;
71   }
72 
73   /**
74   * @dev transfer token for a specified address
75   * @param _to The address to transfer to.
76   * @param _value The amount to be transferred.
77   */
78   function transfer(address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[msg.sender]);
81 
82     // SafeMath.sub will throw if there is not enough balance.
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of.
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) public view returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104 
105   /**
106    * @dev Transfer tokens from one address to another
107    * @param _from address The address which you want to send tokens from
108    * @param _to address The address which you want to transfer to
109    * @param _value uint256 the amount of tokens to be transferred
110    */
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   /**
124    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
125    *
126    * Beware that changing an allowance with this method brings the risk that someone may use both the old
127    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
128    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
129    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130    * @param _spender The address which will spend the funds.
131    * @param _value The amount of tokens to be spent.
132    */
133   function approve(address _spender, uint256 _value) public returns (bool) {
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifying the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) public view returns (uint256) {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    *
152    * approve should be called when allowed[_spender] == 0. To increment
153    * allowed value is better to use this function to avoid 2 calls (and wait until
154    * the first transaction is mined)
155    * From MonolithDAO Token.sol
156    * @param _spender The address which will spend the funds.
157    * @param _addedValue The amount of tokens to increase the allowance by.
158    */
159   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162     return true;
163   }
164 
165   /**
166    * @dev Decrease the amount of tokens that an owner allowed to a spender.
167    *
168    * approve should be called when allowed[_spender] == 0. To decrement
169    * allowed value is better to use this function to avoid 2 calls (and wait until
170    * the first transaction is mined)
171    * From MonolithDAO Token.sol
172    * @param _spender The address which will spend the funds.
173    * @param _subtractedValue The amount of tokens to decrease the allowance by.
174    */
175   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract Fysical is StandardToken {
189     using SafeMath for uint256;
190 
191     // To increase consistency and reduce the opportunity for human error, the '*sById' mappings, '*Count' values,
192     // 'get*ById' function declarations/implementations, and 'create*' function declarations/implementations have been
193     // programmatically-generated based on the each struct's name, member types/names, and the comments sharing a line
194     // with a member.
195     //
196     // This programmatic generation builds 'require' function calls based on the following rules:
197     //      - 'string' values must have length > 0
198     //      - 'bytes' and uint256[] values may have any length
199     //      - 'uint256' values representing a quantity must be > 0 (identifiers and Ethereum block numbers do not represent a quantity)
200     //
201     // The implementation of 'createProposal' contains one operation not found in the other programmatically-generated
202     // 'create*' functions, a call to 'transferTokensToEscrow'.
203     //
204     // None of the other members or functions have been programmatically generated.
205 
206     // See https://en.wikipedia.org/wiki/Uniform_Resource_Identifier.
207     // The risk of preventing support for a future addition to the URI syntax outweighs the benefit of validating URI
208     // values within this immutable smart contract, so readers of Uri values should expect values that do not conform
209     // to the formal syntax of a URI.
210     struct Uri {
211         string value;
212     }
213 
214     // A set of URIs may describe multiple methods to access a particular resource.
215     struct UriSet {
216         uint256[] uniqueUriIdsSortedAscending;    // each value must be key in 'urisById'
217     }
218 
219     // See https://en.wikipedia.org/wiki/Checksum#Algorithms. The description of the algorithm referred to by each URI
220     // in the set should give a reader enough information to interpret the 'value' member of a 'Checksum' object
221     // referring to this algorithm object.
222     struct ChecksumAlgorithm {
223         uint256 descriptionUriSetId;    // must be key in 'uriSetsById'
224     }
225 
226     // See https://en.wikipedia.org/wiki/Checksum. The 'resourceByteCount' indicates the number of bytes contained in
227     // the resource. Though this is not strictly part of most common Checksum algorithms, its validation may also be
228     // useful. The 'value' field should contain the expected output of passing the resource content to the checksum
229     // algorithm.
230     struct Checksum {
231         uint256 algorithmId; // must be key in 'checksumAlgorithmsById'
232         uint256 resourceByteCount;
233         bytes value;
234     }
235 
236     // See https://en.wikipedia.org/wiki/Encryption. The description of the algorithm referred to by each URI
237     // in the set should give a reader enough information to access the content of an encrypted resource. The algorithm
238     // may be a symmetric encryption algorithm or an asymmetric encryption algorithm
239     struct EncryptionAlgorithm {
240         uint256 descriptionUriSetId;    // must be key in 'uriSetsById'
241     }
242 
243     // For each resource, an Ethereum account may describe a checksum for the encrypted content of a resource and a
244     // checksum for the decrypted content of a resource. When the resource is encrypted with a null encryption
245     // algorithm, the resource is effectively unencrypted, so these two checksums should be identical
246     // (See https://en.wikipedia.org/wiki/Null_encryption).
247     struct ChecksumPair {
248         uint256 encryptedChecksumId; // must be key in 'checksumsById'
249         uint256 decryptedChecksumId; // must be key in 'checksumsById'
250     }
251 
252     // A 'Resource' is content accessible with each URI referenced in the 'uriSetId'. This content should be
253     // encrypted with the algorithm described by the 'EncryptionAlgorithm' referenced in 'encryptionAlgorithmId'. Each
254     // resource referenced in 'metaResourceSetId' should describe the decrypted content in some way.
255     //
256     // For example, if the decrypted content conforms to a Protocol Buffers schema, the corresponding proto definition
257     // file should be included in the meta-resources. Likewise, that proto definition resource should refer to a
258     // resource like https://en.wikipedia.org/wiki/Protocol_Buffers among its meta-resources.
259     struct Resource {
260         uint256 uriSetId;                // must be key in 'uriSetsById'
261         uint256 encryptionAlgorithmId;   // must be key in 'encryptionAlgorithmsById'
262         uint256 metaResourceSetId;       // must be key in 'resourceSetsById'
263     }
264 
265     // See https://en.wikipedia.org/wiki/Public-key_cryptography. This value should be the public key used in an
266     // asymmetric encryption operation. It should be useful for encrypting an resource destined for the holder of the
267     // corresponding private key or for decrypting a resource encrypted with the corresponding private key.
268     struct PublicKey {
269         bytes value;
270     }
271 
272     // A 'ResourceSet' groups together resources that may be part of a trade proposal involving Fysical tokens. The
273     // creator of a 'ResourceSet' must include a public key for use in the encryption operations of creating and
274     // accepting a trade proposal. The creator must also specify the encryption algorithm a proposal creator should
275     // use along with this resource set creator's public key. Just as a single resource may have meta-resources
276     // describing the content of a resource, a 'ResourceSet' may have resources describing the whole resource set.
277     //
278     // Creators should be careful to not include so many resources that an Ethereum transaction to accept a proposal
279     // might run out of gas while storing the corresponding encrypted decryption keys.
280     //
281     // While developing reasonable filters for un-useful data in this collection, developers should choose a practical
282     // maximum depth of traversal through the meta-resources, since an infinite loop is possible.
283     struct ResourceSet {
284         address creator;
285         uint256 creatorPublicKeyId;                     // must be key in 'publicKeysById'
286         uint256 proposalEncryptionAlgorithmId;          // must be key in 'encryptionAlgorithmsById'
287         uint256[] uniqueResourceIdsSortedAscending;     // each value must be key in 'resourcesById'
288         uint256 metaResourceSetId;                      // must be key in 'resourceSetsById'
289     }
290 
291     // The creator of a trade proposal may include arbitrary content to be considered part of the agreement the
292     // resource set is accepting. This may be useful for license agreements to be enforced within a jurisdiction
293     // governing the trade partners. The content available through each URI in the set should be encrypted first with
294     // the public key of a resource set's creator and then with the private key of a proposal's creator.
295     struct Agreement {
296         uint256 uriSetId;           // must be key in 'uriSetsById'
297         uint256 checksumPairId;     // must be key in 'checksumPairsById'
298     }
299 
300     // Many agreements may be grouped together in an 'AgreementSet'
301     struct AgreementSet {
302         uint256[] uniqueAgreementIdsSortedAscending; // each value must be key in 'agreementsById'
303     }
304 
305     // A 'TokenTransfer' describes a transfer of tokens to occur between two Ethereum accounts.
306     struct TokenTransfer {
307         address source;
308         address destination;
309         uint256 tokenCount;
310     }
311 
312     // Many token transfers may be grouped together in a "TokenTransferSet'
313     struct TokenTransferSet {
314         uint256[] uniqueTokenTransferIdsSortedAscending; // each value must be key in 'tokenTransfersById'
315     }
316 
317     // A 'Proposal' describes the conditions for the atomic exchange of Fysical tokens and a keys to decrypt resources
318     // in a resource set. The creator must specify the asymmetric encryption algorithm for use when accepting the
319     // proposal, along with this creator's public key. The creator may specify arbitrary agreements that should be
320     // considered a condition of the trade.
321     //
322     // During the execution of 'createProposal', the count of tokens specified in each token transfer will be transfered
323     // from the specified source account to the account with the Ethereum address of 0. When the proposal state changes
324     // to a final state, these tokens will be returned to the source accounts or tranfserred to the destination account.
325     //
326     // By including a 'minimumBlockNumberForWithdrawal' value later than the current Ethereum block, the proposal
327     // creator can give the resource set creator a rough sense of how long the proposal will remain certainly
328     // acceptable. This is particularly useful because the execution of an Ethereum transaction to accept a proposal
329     // exposes the encrypted decryption keys to the Ethereum network regardless of whether the transaction succeeds.
330     // Within the time frame that a proposal acceptance transaction will certainly succeed, the resource creator need
331     // not be concerned with the possibility that an acceptance transaction might execute after a proposal withdrawal
332     // submitted to the Ethereum network at approximately the same time.
333     struct Proposal {
334         uint256 minimumBlockNumberForWithdrawal;
335         address creator;
336         uint256 creatorPublicKeyId;                 // must be key in 'publicKeysById'
337         uint256 acceptanceEncryptionAlgorithmId;    // must be key in 'encryptionAlgorithmsById'
338         uint256 resourceSetId;                      // must be key in 'resourceSetsById'
339         uint256 agreementSetId;                     // must be key in 'agreementSetsById'
340         uint256 tokenTransferSetId;                 // must be key in 'tokenTransferSetsById'
341     }
342 
343     // When created, the proposal is in the 'Pending' state. All other states are final states, so a proposal may change
344     // state exactly one time based on a call to 'withdrawProposal', 'acceptProposal', or 'rejectProposal'.
345     enum ProposalState {
346         Pending,
347         WithdrawnByCreator,
348         RejectedByResourceSetCreator,
349         AcceptedByResourceSetCreator
350     }
351 
352     // solium would warn "Constant name 'name' doesn't follow the UPPER_CASE notation", but this public constant is
353     // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we'll disable warnings for the line.
354     //
355     /* solium-disable-next-line */
356     string public constant name = "Fysical";
357 
358     // solium would warn "Constant name 'symbol' doesn't follow the UPPER_CASE notation", but this public constant is
359     // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we'll disable warnings for the line.
360     //
361     /* solium-disable-next-line */
362     string public constant symbol = "FYS";
363 
364     // solium would warn "Constant name 'decimals' doesn't follow the UPPER_CASE notation", but this public constant is
365     // recommended by https://theethereum.wiki/w/index.php/ERC20_Token_Standard, so we'll disable warnings for the line.
366     //
367     /* solium-disable-next-line */
368     uint8 public constant decimals = 9;
369 
370     uint256 public constant ONE_BILLION = 1000000000;
371     uint256 public constant ONE_QUINTILLION = 1000000000000000000;
372 
373     // See https://en.wikipedia.org/wiki/9,223,372,036,854,775,807
374     uint256 public constant MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE = 9223372036854775807;
375 
376     uint256 public constant EMPTY_PUBLIC_KEY_ID = 0;
377     uint256 public constant NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID = 0;
378     uint256 public constant NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID = 0;
379     uint256 public constant NULL_ENCRYPTION_ALGORITHM_ID = 0;
380     uint256 public constant EMPTY_RESOURCE_SET_ID = 0;
381 
382     mapping(uint256 => Uri) internal urisById;
383     uint256 internal uriCount = 0;
384 
385     mapping(uint256 => UriSet) internal uriSetsById;
386     uint256 internal uriSetCount = 0;
387 
388     mapping(uint256 => ChecksumAlgorithm) internal checksumAlgorithmsById;
389     uint256 internal checksumAlgorithmCount = 0;
390 
391     mapping(uint256 => Checksum) internal checksumsById;
392     uint256 internal checksumCount = 0;
393 
394     mapping(uint256 => EncryptionAlgorithm) internal encryptionAlgorithmsById;
395     uint256 internal encryptionAlgorithmCount = 0;
396 
397     mapping(uint256 => ChecksumPair) internal checksumPairsById;
398     uint256 internal checksumPairCount = 0;
399 
400     mapping(uint256 => Resource) internal resourcesById;
401     uint256 internal resourceCount = 0;
402 
403     mapping(uint256 => PublicKey) internal publicKeysById;
404     uint256 internal publicKeyCount = 0;
405 
406     mapping(uint256 => ResourceSet) internal resourceSetsById;
407     uint256 internal resourceSetCount = 0;
408 
409     mapping(uint256 => Agreement) internal agreementsById;
410     uint256 internal agreementCount = 0;
411 
412     mapping(uint256 => AgreementSet) internal agreementSetsById;
413     uint256 internal agreementSetCount = 0;
414 
415     mapping(uint256 => TokenTransfer) internal tokenTransfersById;
416     uint256 internal tokenTransferCount = 0;
417 
418     mapping(uint256 => TokenTransferSet) internal tokenTransferSetsById;
419     uint256 internal tokenTransferSetCount = 0;
420 
421     mapping(uint256 => Proposal) internal proposalsById;
422     uint256 internal proposalCount = 0;
423 
424     mapping(uint256 => ProposalState) internal statesByProposalId;
425 
426     mapping(uint256 => mapping(uint256 => bytes)) internal encryptedDecryptionKeysByProposalIdAndResourceId;
427 
428     mapping(address => mapping(uint256 => bool)) internal checksumPairAssignmentsByCreatorAndResourceId;
429 
430     mapping(address => mapping(uint256 => uint256)) internal checksumPairIdsByCreatorAndResourceId;
431 
432     function Fysical() public {
433         assert(ProposalState(0) == ProposalState.Pending);
434 
435         // The total number of Fysical tokens is intended to be one billion, with the ability to express values with
436         // nine decimals places of precision. The token values passed in ERC20 functions and operations involving
437         // TokenTransfer operations must be counts of nano-Fysical tokens (one billionth of one Fysical token).
438         //
439         // See the initialization of the total supply in https://theethereum.wiki/w/index.php/ERC20_Token_Standard.
440 
441         assert(0 < ONE_BILLION);
442         assert(0 < ONE_QUINTILLION);
443         assert(MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE > ONE_BILLION);
444         assert(MAXIMUM_64_BIT_SIGNED_INTEGER_VALUE > ONE_QUINTILLION);
445         assert(ONE_BILLION == uint256(10)**decimals);
446         assert(ONE_QUINTILLION == ONE_BILLION.mul(ONE_BILLION));
447 
448         totalSupply_ = ONE_QUINTILLION;
449 
450         balances[msg.sender] = totalSupply_;
451 
452         // From "https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1" on 2018-02-08 (commit cea1db05a3444870132ec3cb7dd78a244cba1805):
453         //  "A token contract which creates new tokens SHOULD trigger a Transfer event with the _from address set to 0x0 when tokens are created."
454         Transfer(0x0, msg.sender, balances[msg.sender]);
455 
456         // This mimics the behavior of the 'createPublicKey' external function.
457         assert(EMPTY_PUBLIC_KEY_ID == publicKeyCount);
458         publicKeysById[EMPTY_PUBLIC_KEY_ID] = PublicKey(new bytes(0));
459         publicKeyCount = publicKeyCount.add(1);
460         assert(1 == publicKeyCount);
461 
462         // This mimics the behavior of the 'createUri' external function.
463         assert(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID == uriCount);
464         urisById[NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID] = Uri("https://en.wikipedia.org/wiki/Null_encryption");
465         uriCount = uriCount.add(1);
466         assert(1 == uriCount);
467 
468         // This mimics the behavior of the 'createUriSet' external function.
469         assert(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID == uriSetCount);
470         uint256[] memory uniqueIdsSortedAscending = new uint256[](1);
471         uniqueIdsSortedAscending[0] = NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_ID;
472         validateIdSet(uniqueIdsSortedAscending, uriCount);
473         uriSetsById[NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID] = UriSet(uniqueIdsSortedAscending);
474         uriSetCount = uriSetCount.add(1);
475         assert(1 == uriSetCount);
476 
477         // This mimics the behavior of the 'createEncryptionAlgorithm' external function.
478         assert(NULL_ENCRYPTION_ALGORITHM_ID == encryptionAlgorithmCount);
479         encryptionAlgorithmsById[NULL_ENCRYPTION_ALGORITHM_ID] = EncryptionAlgorithm(NULL_ENCRYPTION_ALGORITHM_DESCRIPTION_URI_SET_ID);
480         encryptionAlgorithmCount = encryptionAlgorithmCount.add(1);
481         assert(1 == encryptionAlgorithmCount);
482 
483         // This mimics the behavior of the 'createResourceSet' external function, but allows for a self-reference in
484         // the assignment of the 'metaResourceSetId' member, which the function would prohibit.
485         assert(EMPTY_RESOURCE_SET_ID == resourceSetCount);
486         resourceSetsById[EMPTY_RESOURCE_SET_ID] = ResourceSet(
487             msg.sender,
488             EMPTY_PUBLIC_KEY_ID,
489             NULL_ENCRYPTION_ALGORITHM_ID,
490             new uint256[](0),
491             EMPTY_RESOURCE_SET_ID
492         );
493         resourceSetCount = resourceSetCount.add(1);
494         assert(1 == resourceSetCount);
495     }
496 
497     function getUriCount() external view returns (uint256) {
498         return uriCount;
499     }
500 
501     function getUriById(uint256 id) external view returns (string) {
502         require(id < uriCount);
503 
504         Uri memory object = urisById[id];
505         return object.value;
506     }
507 
508     function getUriSetCount() external view returns (uint256) {
509         return uriSetCount;
510     }
511 
512     function getUriSetById(uint256 id) external view returns (uint256[]) {
513         require(id < uriSetCount);
514 
515         UriSet memory object = uriSetsById[id];
516         return object.uniqueUriIdsSortedAscending;
517     }
518 
519     function getChecksumAlgorithmCount() external view returns (uint256) {
520         return checksumAlgorithmCount;
521     }
522 
523     function getChecksumAlgorithmById(uint256 id) external view returns (uint256) {
524         require(id < checksumAlgorithmCount);
525 
526         ChecksumAlgorithm memory object = checksumAlgorithmsById[id];
527         return object.descriptionUriSetId;
528     }
529 
530     function getChecksumCount() external view returns (uint256) {
531         return checksumCount;
532     }
533 
534     function getChecksumById(uint256 id) external view returns (uint256, uint256, bytes) {
535         require(id < checksumCount);
536 
537         Checksum memory object = checksumsById[id];
538         return (object.algorithmId, object.resourceByteCount, object.value);
539     }
540 
541     function getEncryptionAlgorithmCount() external view returns (uint256) {
542         return encryptionAlgorithmCount;
543     }
544 
545     function getEncryptionAlgorithmById(uint256 id) external view returns (uint256) {
546         require(id < encryptionAlgorithmCount);
547 
548         EncryptionAlgorithm memory object = encryptionAlgorithmsById[id];
549         return object.descriptionUriSetId;
550     }
551 
552     function getChecksumPairCount() external view returns (uint256) {
553         return checksumPairCount;
554     }
555 
556     function getChecksumPairById(uint256 id) external view returns (uint256, uint256) {
557         require(id < checksumPairCount);
558 
559         ChecksumPair memory object = checksumPairsById[id];
560         return (object.encryptedChecksumId, object.decryptedChecksumId);
561     }
562 
563     function getResourceCount() external view returns (uint256) {
564         return resourceCount;
565     }
566 
567     function getResourceById(uint256 id) external view returns (uint256, uint256, uint256) {
568         require(id < resourceCount);
569 
570         Resource memory object = resourcesById[id];
571         return (object.uriSetId, object.encryptionAlgorithmId, object.metaResourceSetId);
572     }
573 
574     function getPublicKeyCount() external view returns (uint256) {
575         return publicKeyCount;
576     }
577 
578     function getPublicKeyById(uint256 id) external view returns (bytes) {
579         require(id < publicKeyCount);
580 
581         PublicKey memory object = publicKeysById[id];
582         return object.value;
583     }
584 
585     function getResourceSetCount() external view returns (uint256) {
586         return resourceSetCount;
587     }
588 
589     function getResourceSetById(uint256 id) external view returns (address, uint256, uint256, uint256[], uint256) {
590         require(id < resourceSetCount);
591 
592         ResourceSet memory object = resourceSetsById[id];
593         return (object.creator, object.creatorPublicKeyId, object.proposalEncryptionAlgorithmId, object.uniqueResourceIdsSortedAscending, object.metaResourceSetId);
594     }
595 
596     function getAgreementCount() external view returns (uint256) {
597         return agreementCount;
598     }
599 
600     function getAgreementById(uint256 id) external view returns (uint256, uint256) {
601         require(id < agreementCount);
602 
603         Agreement memory object = agreementsById[id];
604         return (object.uriSetId, object.checksumPairId);
605     }
606 
607     function getAgreementSetCount() external view returns (uint256) {
608         return agreementSetCount;
609     }
610 
611     function getAgreementSetById(uint256 id) external view returns (uint256[]) {
612         require(id < agreementSetCount);
613 
614         AgreementSet memory object = agreementSetsById[id];
615         return object.uniqueAgreementIdsSortedAscending;
616     }
617 
618     function getTokenTransferCount() external view returns (uint256) {
619         return tokenTransferCount;
620     }
621 
622     function getTokenTransferById(uint256 id) external view returns (address, address, uint256) {
623         require(id < tokenTransferCount);
624 
625         TokenTransfer memory object = tokenTransfersById[id];
626         return (object.source, object.destination, object.tokenCount);
627     }
628 
629     function getTokenTransferSetCount() external view returns (uint256) {
630         return tokenTransferSetCount;
631     }
632 
633     function getTokenTransferSetById(uint256 id) external view returns (uint256[]) {
634         require(id < tokenTransferSetCount);
635 
636         TokenTransferSet memory object = tokenTransferSetsById[id];
637         return object.uniqueTokenTransferIdsSortedAscending;
638     }
639 
640     function getProposalCount() external view returns (uint256) {
641         return proposalCount;
642     }
643 
644     function getProposalById(uint256 id) external view returns (uint256, address, uint256, uint256, uint256, uint256, uint256) {
645         require(id < proposalCount);
646 
647         Proposal memory object = proposalsById[id];
648         return (object.minimumBlockNumberForWithdrawal, object.creator, object.creatorPublicKeyId, object.acceptanceEncryptionAlgorithmId, object.resourceSetId, object.agreementSetId, object.tokenTransferSetId);
649     }
650 
651     function getStateByProposalId(uint256 proposalId) external view returns (ProposalState) {
652         require(proposalId < proposalCount);
653 
654         return statesByProposalId[proposalId];
655     }
656 
657     // Check to see if an Ethereum account has assigned a checksum for a particular resource.
658     function hasAddressAssignedResourceChecksumPair(address address_, uint256 resourceId) external view returns (bool) {
659         require(resourceId < resourceCount);
660 
661         return checksumPairAssignmentsByCreatorAndResourceId[address_][resourceId];
662     }
663 
664     // Retrieve the checksum assigned assigned to particular resource
665     function getChecksumPairIdByAssignerAndResourceId(address assigner, uint256 resourceId) external view returns (uint256) {
666         require(resourceId < resourceCount);
667         require(checksumPairAssignmentsByCreatorAndResourceId[assigner][resourceId]);
668 
669         return checksumPairIdsByCreatorAndResourceId[assigner][resourceId];
670     }
671 
672     // Retrieve the encrypted key to decrypt a resource referenced by an accepted proposal.
673     function getEncryptedResourceDecryptionKey(uint256 proposalId, uint256 resourceId) external view returns (bytes) {
674         require(proposalId < proposalCount);
675         require(ProposalState.AcceptedByResourceSetCreator == statesByProposalId[proposalId]);
676         require(resourceId < resourceCount);
677 
678         uint256[] memory validResourceIds = resourceSetsById[proposalsById[proposalId].resourceSetId].uniqueResourceIdsSortedAscending;
679         require(0 < validResourceIds.length);
680 
681         if (1 == validResourceIds.length) {
682             require(resourceId == validResourceIds[0]);
683 
684         } else {
685             uint256 lowIndex = 0;
686             uint256 highIndex = validResourceIds.length.sub(1);
687             uint256 middleIndex = lowIndex.add(highIndex).div(2);
688 
689             while (resourceId != validResourceIds[middleIndex]) {
690                 require(lowIndex <= highIndex);
691 
692                 if (validResourceIds[middleIndex] < resourceId) {
693                     lowIndex = middleIndex.add(1);
694                 } else {
695                     highIndex = middleIndex.sub(1);
696                 }
697 
698                 middleIndex = lowIndex.add(highIndex).div(2);
699             }
700         }
701 
702         return encryptedDecryptionKeysByProposalIdAndResourceId[proposalId][resourceId];
703     }
704 
705     function createUri(
706         string value
707     ) external returns (uint256)
708     {
709         require(0 < bytes(value).length);
710 
711         uint256 id = uriCount;
712         uriCount = id.add(1);
713         urisById[id] = Uri(
714             value
715         );
716 
717         return id;
718     }
719 
720     function createUriSet(
721         uint256[] uniqueUriIdsSortedAscending
722     ) external returns (uint256)
723     {
724         validateIdSet(uniqueUriIdsSortedAscending, uriCount);
725 
726         uint256 id = uriSetCount;
727         uriSetCount = id.add(1);
728         uriSetsById[id] = UriSet(
729             uniqueUriIdsSortedAscending
730         );
731 
732         return id;
733     }
734 
735     function createChecksumAlgorithm(
736         uint256 descriptionUriSetId
737     ) external returns (uint256)
738     {
739         require(descriptionUriSetId < uriSetCount);
740 
741         uint256 id = checksumAlgorithmCount;
742         checksumAlgorithmCount = id.add(1);
743         checksumAlgorithmsById[id] = ChecksumAlgorithm(
744             descriptionUriSetId
745         );
746 
747         return id;
748     }
749 
750     function createChecksum(
751         uint256 algorithmId,
752         uint256 resourceByteCount,
753         bytes value
754     ) external returns (uint256)
755     {
756         require(algorithmId < checksumAlgorithmCount);
757         require(0 < resourceByteCount);
758 
759         uint256 id = checksumCount;
760         checksumCount = id.add(1);
761         checksumsById[id] = Checksum(
762             algorithmId,
763             resourceByteCount,
764             value
765         );
766 
767         return id;
768     }
769 
770     function createEncryptionAlgorithm(
771         uint256 descriptionUriSetId
772     ) external returns (uint256)
773     {
774         require(descriptionUriSetId < uriSetCount);
775 
776         uint256 id = encryptionAlgorithmCount;
777         encryptionAlgorithmCount = id.add(1);
778         encryptionAlgorithmsById[id] = EncryptionAlgorithm(
779             descriptionUriSetId
780         );
781 
782         return id;
783     }
784 
785     function createChecksumPair(
786         uint256 encryptedChecksumId,
787         uint256 decryptedChecksumId
788     ) external returns (uint256)
789     {
790         require(encryptedChecksumId < checksumCount);
791         require(decryptedChecksumId < checksumCount);
792 
793         uint256 id = checksumPairCount;
794         checksumPairCount = id.add(1);
795         checksumPairsById[id] = ChecksumPair(
796             encryptedChecksumId,
797             decryptedChecksumId
798         );
799 
800         return id;
801     }
802 
803     function createResource(
804         uint256 uriSetId,
805         uint256 encryptionAlgorithmId,
806         uint256 metaResourceSetId
807     ) external returns (uint256)
808     {
809         require(uriSetId < uriSetCount);
810         require(encryptionAlgorithmId < encryptionAlgorithmCount);
811         require(metaResourceSetId < resourceSetCount);
812 
813         uint256 id = resourceCount;
814         resourceCount = id.add(1);
815         resourcesById[id] = Resource(
816             uriSetId,
817             encryptionAlgorithmId,
818             metaResourceSetId
819         );
820 
821         return id;
822     }
823 
824     function createPublicKey(
825         bytes value
826     ) external returns (uint256)
827     {
828         uint256 id = publicKeyCount;
829         publicKeyCount = id.add(1);
830         publicKeysById[id] = PublicKey(
831             value
832         );
833 
834         return id;
835     }
836 
837     function createResourceSet(
838         uint256 creatorPublicKeyId,
839         uint256 proposalEncryptionAlgorithmId,
840         uint256[] uniqueResourceIdsSortedAscending,
841         uint256 metaResourceSetId
842     ) external returns (uint256)
843     {
844         require(creatorPublicKeyId < publicKeyCount);
845         require(proposalEncryptionAlgorithmId < encryptionAlgorithmCount);
846         validateIdSet(uniqueResourceIdsSortedAscending, resourceCount);
847         require(metaResourceSetId < resourceSetCount);
848 
849         uint256 id = resourceSetCount;
850         resourceSetCount = id.add(1);
851         resourceSetsById[id] = ResourceSet(
852             msg.sender,
853             creatorPublicKeyId,
854             proposalEncryptionAlgorithmId,
855             uniqueResourceIdsSortedAscending,
856             metaResourceSetId
857         );
858 
859         return id;
860     }
861 
862     function createAgreement(
863         uint256 uriSetId,
864         uint256 checksumPairId
865     ) external returns (uint256)
866     {
867         require(uriSetId < uriSetCount);
868         require(checksumPairId < checksumPairCount);
869 
870         uint256 id = agreementCount;
871         agreementCount = id.add(1);
872         agreementsById[id] = Agreement(
873             uriSetId,
874             checksumPairId
875         );
876 
877         return id;
878     }
879 
880     function createAgreementSet(
881         uint256[] uniqueAgreementIdsSortedAscending
882     ) external returns (uint256)
883     {
884         validateIdSet(uniqueAgreementIdsSortedAscending, agreementCount);
885 
886         uint256 id = agreementSetCount;
887         agreementSetCount = id.add(1);
888         agreementSetsById[id] = AgreementSet(
889             uniqueAgreementIdsSortedAscending
890         );
891 
892         return id;
893     }
894 
895     function createTokenTransfer(
896         address source,
897         address destination,
898         uint256 tokenCount
899     ) external returns (uint256)
900     {
901         require(address(0) != source);
902         require(address(0) != destination);
903         require(0 < tokenCount);
904 
905         uint256 id = tokenTransferCount;
906         tokenTransferCount = id.add(1);
907         tokenTransfersById[id] = TokenTransfer(
908             source,
909             destination,
910             tokenCount
911         );
912 
913         return id;
914     }
915 
916     function createTokenTransferSet(
917         uint256[] uniqueTokenTransferIdsSortedAscending
918     ) external returns (uint256)
919     {
920         validateIdSet(uniqueTokenTransferIdsSortedAscending, tokenTransferCount);
921 
922         uint256 id = tokenTransferSetCount;
923         tokenTransferSetCount = id.add(1);
924         tokenTransferSetsById[id] = TokenTransferSet(
925             uniqueTokenTransferIdsSortedAscending
926         );
927 
928         return id;
929     }
930 
931     function createProposal(
932         uint256 minimumBlockNumberForWithdrawal,
933         uint256 creatorPublicKeyId,
934         uint256 acceptanceEncryptionAlgorithmId,
935         uint256 resourceSetId,
936         uint256 agreementSetId,
937         uint256 tokenTransferSetId
938     ) external returns (uint256)
939     {
940         require(creatorPublicKeyId < publicKeyCount);
941         require(acceptanceEncryptionAlgorithmId < encryptionAlgorithmCount);
942         require(resourceSetId < resourceSetCount);
943         require(agreementSetId < agreementSetCount);
944         require(tokenTransferSetId < tokenTransferSetCount);
945 
946         transferTokensToEscrow(msg.sender, tokenTransferSetId);
947 
948         uint256 id = proposalCount;
949         proposalCount = id.add(1);
950         proposalsById[id] = Proposal(
951             minimumBlockNumberForWithdrawal,
952             msg.sender,
953             creatorPublicKeyId,
954             acceptanceEncryptionAlgorithmId,
955             resourceSetId,
956             agreementSetId,
957             tokenTransferSetId
958         );
959 
960         return id;
961     }
962 
963     // Each Ethereum account may assign a 'ChecksumPair' to a resource exactly once. This ensures that each claim that a
964     // checksum should match a resource is attached to a particular authority. This operation is not bound to the
965     // creation of the resource because the resource's creator may not know the checksum when creating the resource.
966     function assignResourceChecksumPair(
967         uint256 resourceId,
968         uint256 checksumPairId
969     ) external
970     {
971         require(resourceId < resourceCount);
972         require(checksumPairId < checksumPairCount);
973         require(false == checksumPairAssignmentsByCreatorAndResourceId[msg.sender][resourceId]);
974 
975         checksumPairIdsByCreatorAndResourceId[msg.sender][resourceId] = checksumPairId;
976         checksumPairAssignmentsByCreatorAndResourceId[msg.sender][resourceId] = true;
977     }
978 
979     // This function moves a proposal to a final state of `WithdrawnByCreator' and returns tokens to the sources
980     // described by the proposal's transfers.
981     function withdrawProposal(
982         uint256 proposalId
983     ) external
984     {
985         require(proposalId < proposalCount);
986         require(ProposalState.Pending == statesByProposalId[proposalId]);
987 
988         Proposal memory proposal = proposalsById[proposalId];
989         require(msg.sender == proposal.creator);
990         require(block.number >= proposal.minimumBlockNumberForWithdrawal);
991 
992         returnTokensFromEscrow(proposal.creator, proposal.tokenTransferSetId);
993         statesByProposalId[proposalId] = ProposalState.WithdrawnByCreator;
994     }
995 
996     // This function moves a proposal to a final state of `RejectedByResourceSetCreator' and returns tokens to the sources
997     // described by the proposal's transfers.
998     function rejectProposal(
999         uint256 proposalId
1000     ) external
1001     {
1002         require(proposalId < proposalCount);
1003         require(ProposalState.Pending == statesByProposalId[proposalId]);
1004 
1005         Proposal memory proposal = proposalsById[proposalId];
1006         require(msg.sender == resourceSetsById[proposal.resourceSetId].creator);
1007 
1008         returnTokensFromEscrow(proposal.creator, proposal.tokenTransferSetId);
1009         statesByProposalId[proposalId] = ProposalState.RejectedByResourceSetCreator;
1010     }
1011 
1012     // This function moves a proposal to a final state of `RejectedByResourceSetCreator' and sends tokens to the
1013     // destinations described by the proposal's transfers.
1014     //
1015     // The caller should encrypt each decryption key corresponding
1016     // to each resource in the proposal's resource set first with the public key of the proposal's creator and then with
1017     // the private key assoicated with the public key referenced in the resource set. The caller should concatenate
1018     // these encrypted values and pass the resulting byte array as 'concatenatedResourceDecryptionKeys'.
1019     // The length of each encrypted decryption key should be provided in the 'concatenatedResourceDecryptionKeyLengths'.
1020     // The index of each value in 'concatenatedResourceDecryptionKeyLengths' must correspond to an index in the resource
1021     // set referenced by the proposal.
1022     function acceptProposal(
1023         uint256 proposalId,
1024         bytes concatenatedResourceDecryptionKeys,
1025         uint256[] concatenatedResourceDecryptionKeyLengths
1026     ) external
1027     {
1028         require(proposalId < proposalCount);
1029         require(ProposalState.Pending == statesByProposalId[proposalId]);
1030 
1031         Proposal memory proposal = proposalsById[proposalId];
1032         require(msg.sender == resourceSetsById[proposal.resourceSetId].creator);
1033 
1034         storeEncryptedDecryptionKeys(
1035             proposalId,
1036             concatenatedResourceDecryptionKeys,
1037             concatenatedResourceDecryptionKeyLengths
1038         );
1039 
1040         transferTokensFromEscrow(proposal.tokenTransferSetId);
1041 
1042         statesByProposalId[proposalId] = ProposalState.AcceptedByResourceSetCreator;
1043     }
1044 
1045     function validateIdSet(uint256[] uniqueIdsSortedAscending, uint256 idCount) private pure {
1046         if (0 < uniqueIdsSortedAscending.length) {
1047 
1048             uint256 id = uniqueIdsSortedAscending[0];
1049             require(id < idCount);
1050 
1051             uint256 previousId = id;
1052             for (uint256 index = 1; index < uniqueIdsSortedAscending.length; index = index.add(1)) {
1053                 id = uniqueIdsSortedAscending[index];
1054                 require(id < idCount);
1055                 require(previousId < id);
1056 
1057                 previousId = id;
1058             }
1059         }
1060     }
1061 
1062     function transferTokensToEscrow(address proposalCreator, uint256 tokenTransferSetId) private {
1063         assert(tokenTransferSetId < tokenTransferSetCount);
1064         assert(address(0) != proposalCreator);
1065 
1066         uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
1067         for (uint256 index = 0; index < tokenTransferIds.length; index = index.add(1)) {
1068             uint256 tokenTransferId = tokenTransferIds[index];
1069             assert(tokenTransferId < tokenTransferCount);
1070 
1071             TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
1072             assert(0 < tokenTransfer.tokenCount);
1073             assert(address(0) != tokenTransfer.source);
1074             assert(address(0) != tokenTransfer.destination);
1075 
1076             require(tokenTransfer.tokenCount <= balances[tokenTransfer.source]);
1077 
1078             if (tokenTransfer.source != proposalCreator) {
1079                 require(tokenTransfer.tokenCount <= allowed[tokenTransfer.source][proposalCreator]);
1080 
1081                 allowed[tokenTransfer.source][proposalCreator] = allowed[tokenTransfer.source][proposalCreator].sub(tokenTransfer.tokenCount);
1082             }
1083 
1084             balances[tokenTransfer.source] = balances[tokenTransfer.source].sub(tokenTransfer.tokenCount);
1085             balances[address(0)] = balances[address(0)].add(tokenTransfer.tokenCount);
1086 
1087             Transfer(tokenTransfer.source, address(0), tokenTransfer.tokenCount);
1088         }
1089     }
1090 
1091     function returnTokensFromEscrow(address proposalCreator, uint256 tokenTransferSetId) private {
1092         assert(tokenTransferSetId < tokenTransferSetCount);
1093         assert(address(0) != proposalCreator);
1094 
1095         uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
1096         for (uint256 index = 0; index < tokenTransferIds.length; index = index.add(1)) {
1097             uint256 tokenTransferId = tokenTransferIds[index];
1098             assert(tokenTransferId < tokenTransferCount);
1099 
1100             TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
1101             assert(0 < tokenTransfer.tokenCount);
1102             assert(address(0) != tokenTransfer.source);
1103             assert(address(0) != tokenTransfer.destination);
1104             assert(tokenTransfer.tokenCount <= balances[address(0)]);
1105 
1106             balances[tokenTransfer.source] = balances[tokenTransfer.source].add(tokenTransfer.tokenCount);
1107             balances[address(0)] = balances[address(0)].sub(tokenTransfer.tokenCount);
1108 
1109             Transfer(address(0), tokenTransfer.source, tokenTransfer.tokenCount);
1110         }
1111     }
1112 
1113     function transferTokensFromEscrow(uint256 tokenTransferSetId) private {
1114         assert(tokenTransferSetId < tokenTransferSetCount);
1115 
1116         uint256[] memory tokenTransferIds = tokenTransferSetsById[tokenTransferSetId].uniqueTokenTransferIdsSortedAscending;
1117         for (uint256 index = 0; index < tokenTransferIds.length; index = index.add(1)) {
1118             uint256 tokenTransferId = tokenTransferIds[index];
1119             assert(tokenTransferId < tokenTransferCount);
1120 
1121             TokenTransfer memory tokenTransfer = tokenTransfersById[tokenTransferId];
1122             assert(0 < tokenTransfer.tokenCount);
1123             assert(address(0) != tokenTransfer.source);
1124             assert(address(0) != tokenTransfer.destination);
1125 
1126             balances[address(0)] = balances[address(0)].sub(tokenTransfer.tokenCount);
1127             balances[tokenTransfer.destination] = balances[tokenTransfer.destination].add(tokenTransfer.tokenCount);
1128             Transfer(address(0), tokenTransfer.destination, tokenTransfer.tokenCount);
1129         }
1130     }
1131 
1132     function storeEncryptedDecryptionKeys(
1133         uint256 proposalId,
1134         bytes concatenatedEncryptedResourceDecryptionKeys,
1135         uint256[] encryptedResourceDecryptionKeyLengths
1136     ) private
1137     {
1138         assert(proposalId < proposalCount);
1139 
1140         uint256 resourceSetId = proposalsById[proposalId].resourceSetId;
1141         assert(resourceSetId < resourceSetCount);
1142 
1143         ResourceSet memory resourceSet = resourceSetsById[resourceSetId];
1144         require(resourceSet.uniqueResourceIdsSortedAscending.length == encryptedResourceDecryptionKeyLengths.length);
1145 
1146         uint256 concatenatedEncryptedResourceDecryptionKeysIndex = 0;
1147         for (uint256 resourceIndex = 0; resourceIndex < encryptedResourceDecryptionKeyLengths.length; resourceIndex = resourceIndex.add(1)) {
1148             bytes memory encryptedResourceDecryptionKey = new bytes(encryptedResourceDecryptionKeyLengths[resourceIndex]);
1149             require(0 < encryptedResourceDecryptionKey.length);
1150 
1151             for (uint256 encryptedResourceDecryptionKeyIndex = 0; encryptedResourceDecryptionKeyIndex < encryptedResourceDecryptionKey.length; encryptedResourceDecryptionKeyIndex = encryptedResourceDecryptionKeyIndex.add(1)) {
1152                 require(concatenatedEncryptedResourceDecryptionKeysIndex < concatenatedEncryptedResourceDecryptionKeys.length);
1153                 encryptedResourceDecryptionKey[encryptedResourceDecryptionKeyIndex] = concatenatedEncryptedResourceDecryptionKeys[concatenatedEncryptedResourceDecryptionKeysIndex];
1154                 concatenatedEncryptedResourceDecryptionKeysIndex = concatenatedEncryptedResourceDecryptionKeysIndex.add(1);
1155             }
1156 
1157             uint256 resourceId = resourceSet.uniqueResourceIdsSortedAscending[resourceIndex];
1158             assert(resourceId < resourceCount);
1159 
1160             encryptedDecryptionKeysByProposalIdAndResourceId[proposalId][resourceId] = encryptedResourceDecryptionKey;
1161         }
1162 
1163         require(concatenatedEncryptedResourceDecryptionKeysIndex == concatenatedEncryptedResourceDecryptionKeys.length);
1164     }
1165 }