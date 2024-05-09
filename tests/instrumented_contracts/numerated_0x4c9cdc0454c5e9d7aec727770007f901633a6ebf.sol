1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title MerkleProof
6  * @dev Merkle proof verification based on
7  * https://github.com/ameensol/merkle-tree-solidity/blob/master/src/MerkleProof.sol
8  */
9 library MerkleProof {
10     /**
11     * @dev Verifies a Merkle proof proving the existence of a leaf in a Merkle tree. Assumes that each pair of leaves
12     * and each pair of pre-images are sorted.
13     * @param _proof Merkle proof containing sibling hashes on the branch from the leaf to the root of the Merkle tree
14     * @param _root Merkle root
15     * @param _leaf Leaf of Merkle tree
16     */
17     function verifyProof(
18         bytes32[] _proof,
19         bytes32 _root,
20         bytes32 _leaf
21     )
22         internal
23         pure
24         returns (bool)
25     {
26         bytes32 computedHash = _leaf;
27 
28         for (uint256 i = 0; i < _proof.length; i++) {
29             bytes32 proofElement = _proof[i];
30 
31             if (computedHash < proofElement) {
32                 // Hash(current computed hash + current element of the proof)
33                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
34             } else {
35                 // Hash(current element of the proof + current computed hash)
36                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
37             }
38         }
39 
40         // Check if the computed hash (root) is equal to the provided root
41         return computedHash == _root;
42     }
43 }
44 
45 contract Controlled {
46     /// @notice The address of the controller is the only address that can call
47     ///  a function with this modifier
48     modifier onlyController { 
49         require(msg.sender == controller); 
50         _; 
51     }
52 
53     address public controller;
54 
55     constructor() internal { 
56         controller = msg.sender; 
57     }
58 
59     /// @notice Changes the controller of the contract
60     /// @param _newController The new controller of the contract
61     function changeController(address _newController) public onlyController {
62         controller = _newController;
63     }
64 }
65 
66 
67 // Abstract contract for the full ERC 20 Token standard
68 // https://github.com/ethereum/EIPs/issues/20
69 
70 interface ERC20Token {
71 
72     /**
73      * @notice send `_value` token to `_to` from `msg.sender`
74      * @param _to The address of the recipient
75      * @param _value The amount of token to be transferred
76      * @return Whether the transfer was successful or not
77      */
78     function transfer(address _to, uint256 _value) external returns (bool success);
79 
80     /**
81      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
82      * @param _spender The address of the account able to transfer the tokens
83      * @param _value The amount of tokens to be approved for transfer
84      * @return Whether the approval was successful or not
85      */
86     function approve(address _spender, uint256 _value) external returns (bool success);
87 
88     /**
89      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
90      * @param _from The address of the sender
91      * @param _to The address of the recipient
92      * @param _value The amount of token to be transferred
93      * @return Whether the transfer was successful or not
94      */
95     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
96 
97     /**
98      * @param _owner The address from which the balance will be retrieved
99      * @return The balance
100      */
101     function balanceOf(address _owner) external view returns (uint256 balance);
102 
103     /**
104      * @param _owner The address of the account owning tokens
105      * @param _spender The address of the account able to transfer the tokens
106      * @return Amount of remaining tokens allowed to spent
107      */
108     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
109 
110     /**
111      * @notice return total supply of tokens
112      */
113     function totalSupply() external view returns (uint256 supply);
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }
118 
119 contract ApproveAndCallFallBack {
120     function receiveApproval(address from, uint256 _amount, address _token, bytes _data) public;
121 }
122 
123 interface ENS {
124 
125   // Logged when the owner of a node assigns a new owner to a subnode.
126   event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
127 
128   // Logged when the owner of a node transfers ownership to a new account.
129   event Transfer(bytes32 indexed node, address owner);
130 
131   // Logged when the resolver for a node changes.
132   event NewResolver(bytes32 indexed node, address resolver);
133 
134   // Logged when the TTL of a node changes
135   event NewTTL(bytes32 indexed node, uint64 ttl);
136 
137 
138   function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
139   function setResolver(bytes32 node, address resolver) public;
140   function setOwner(bytes32 node, address owner) public;
141   function setTTL(bytes32 node, uint64 ttl) public;
142   function owner(bytes32 node) public view returns (address);
143   function resolver(bytes32 node) public view returns (address);
144   function ttl(bytes32 node) public view returns (uint64);
145 
146 }
147 
148 
149 /**
150  * A simple resolver anyone can use; only allows the owner of a node to set its
151  * address.
152  */
153 contract PublicResolver {
154 
155     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
156     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
157     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
158     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
159     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
160     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
161     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
162     bytes4 constant MULTIHASH_INTERFACE_ID = 0xe89401a1;
163 
164     event AddrChanged(bytes32 indexed node, address a);
165     event ContentChanged(bytes32 indexed node, bytes32 hash);
166     event NameChanged(bytes32 indexed node, string name);
167     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
168     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
169     event TextChanged(bytes32 indexed node, string indexedKey, string key);
170     event MultihashChanged(bytes32 indexed node, bytes hash);
171 
172     struct PublicKey {
173         bytes32 x;
174         bytes32 y;
175     }
176 
177     struct Record {
178         address addr;
179         bytes32 content;
180         string name;
181         PublicKey pubkey;
182         mapping(string=>string) text;
183         mapping(uint256=>bytes) abis;
184         bytes multihash;
185     }
186 
187     ENS ens;
188 
189     mapping (bytes32 => Record) records;
190 
191     modifier only_owner(bytes32 node) {
192         require(ens.owner(node) == msg.sender);
193         _;
194     }
195 
196     /**
197      * Constructor.
198      * @param ensAddr The ENS registrar contract.
199      */
200     constructor(ENS ensAddr) public {
201         ens = ensAddr;
202     }
203 
204     /**
205      * Sets the address associated with an ENS node.
206      * May only be called by the owner of that node in the ENS registry.
207      * @param node The node to update.
208      * @param addr The address to set.
209      */
210     function setAddr(bytes32 node, address addr) public only_owner(node) {
211         records[node].addr = addr;
212         emit AddrChanged(node, addr);
213     }
214 
215     /**
216      * Sets the content hash associated with an ENS node.
217      * May only be called by the owner of that node in the ENS registry.
218      * Note that this resource type is not standardized, and will likely change
219      * in future to a resource type based on multihash.
220      * @param node The node to update.
221      * @param hash The content hash to set
222      */
223     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
224         records[node].content = hash;
225         emit ContentChanged(node, hash);
226     }
227 
228     /**
229      * Sets the multihash associated with an ENS node.
230      * May only be called by the owner of that node in the ENS registry.
231      * @param node The node to update.
232      * @param hash The multihash to set
233      */
234     function setMultihash(bytes32 node, bytes hash) public only_owner(node) {
235         records[node].multihash = hash;
236         emit MultihashChanged(node, hash);
237     }
238     
239     /**
240      * Sets the name associated with an ENS node, for reverse records.
241      * May only be called by the owner of that node in the ENS registry.
242      * @param node The node to update.
243      * @param name The name to set.
244      */
245     function setName(bytes32 node, string name) public only_owner(node) {
246         records[node].name = name;
247         emit NameChanged(node, name);
248     }
249 
250     /**
251      * Sets the ABI associated with an ENS node.
252      * Nodes may have one ABI of each content type. To remove an ABI, set it to
253      * the empty string.
254      * @param node The node to update.
255      * @param contentType The content type of the ABI
256      * @param data The ABI data.
257      */
258     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
259         // Content types must be powers of 2
260         require(((contentType - 1) & contentType) == 0);
261         
262         records[node].abis[contentType] = data;
263         emit ABIChanged(node, contentType);
264     }
265     
266     /**
267      * Sets the SECP256k1 public key associated with an ENS node.
268      * @param node The ENS node to query
269      * @param x the X coordinate of the curve point for the public key.
270      * @param y the Y coordinate of the curve point for the public key.
271      */
272     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
273         records[node].pubkey = PublicKey(x, y);
274         emit PubkeyChanged(node, x, y);
275     }
276 
277     /**
278      * Sets the text data associated with an ENS node and key.
279      * May only be called by the owner of that node in the ENS registry.
280      * @param node The node to update.
281      * @param key The key to set.
282      * @param value The text data value to set.
283      */
284     function setText(bytes32 node, string key, string value) public only_owner(node) {
285         records[node].text[key] = value;
286         emit TextChanged(node, key, key);
287     }
288 
289     /**
290      * Returns the text data associated with an ENS node and key.
291      * @param node The ENS node to query.
292      * @param key The text data key to query.
293      * @return The associated text data.
294      */
295     function text(bytes32 node, string key) public view returns (string) {
296         return records[node].text[key];
297     }
298 
299     /**
300      * Returns the SECP256k1 public key associated with an ENS node.
301      * Defined in EIP 619.
302      * @param node The ENS node to query
303      * @return x, y the X and Y coordinates of the curve point for the public key.
304      */
305     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
306         return (records[node].pubkey.x, records[node].pubkey.y);
307     }
308 
309     /**
310      * Returns the ABI associated with an ENS node.
311      * Defined in EIP205.
312      * @param node The ENS node to query
313      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
314      * @return contentType The content type of the return value
315      * @return data The ABI data
316      */
317     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
318         Record storage record = records[node];
319         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
320             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
321                 data = record.abis[contentType];
322                 return;
323             }
324         }
325         contentType = 0;
326     }
327 
328     /**
329      * Returns the name associated with an ENS node, for reverse records.
330      * Defined in EIP181.
331      * @param node The ENS node to query.
332      * @return The associated name.
333      */
334     function name(bytes32 node) public view returns (string) {
335         return records[node].name;
336     }
337 
338     /**
339      * Returns the content hash associated with an ENS node.
340      * Note that this resource type is not standardized, and will likely change
341      * in future to a resource type based on multihash.
342      * @param node The ENS node to query.
343      * @return The associated content hash.
344      */
345     function content(bytes32 node) public view returns (bytes32) {
346         return records[node].content;
347     }
348 
349     /**
350      * Returns the multihash associated with an ENS node.
351      * @param node The ENS node to query.
352      * @return The associated multihash.
353      */
354     function multihash(bytes32 node) public view returns (bytes) {
355         return records[node].multihash;
356     }
357 
358     /**
359      * Returns the address associated with an ENS node.
360      * @param node The ENS node to query.
361      * @return The associated address.
362      */
363     function addr(bytes32 node) public view returns (address) {
364         return records[node].addr;
365     }
366 
367     /**
368      * Returns true if the resolver implements the interface specified by the provided hash.
369      * @param interfaceID The ID of the interface to check for.
370      * @return True if the contract implements the requested interface.
371      */
372     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
373         return interfaceID == ADDR_INTERFACE_ID ||
374         interfaceID == CONTENT_INTERFACE_ID ||
375         interfaceID == NAME_INTERFACE_ID ||
376         interfaceID == ABI_INTERFACE_ID ||
377         interfaceID == PUBKEY_INTERFACE_ID ||
378         interfaceID == TEXT_INTERFACE_ID ||
379         interfaceID == MULTIHASH_INTERFACE_ID ||
380         interfaceID == INTERFACE_META_ID;
381     }
382 }
383 
384 
385 /** 
386  * @author Ricardo Guilherme Schmidt (Status Research & Development GmbH) 
387  * @notice Registers usernames as ENS subnodes of the domain `ensNode`
388  */
389 contract UsernameRegistrar is Controlled, ApproveAndCallFallBack {
390     
391     ERC20Token public token;
392     ENS public ensRegistry;
393     PublicResolver public resolver;
394     address public parentRegistry;
395 
396     uint256 public constant releaseDelay = 365 days;
397     mapping (bytes32 => Account) public accounts;
398     mapping (bytes32 => SlashReserve) reservedSlashers;
399 
400     //Slashing conditions
401     uint256 public usernameMinLength;
402     bytes32 public reservedUsernamesMerkleRoot;
403     
404     event RegistryState(RegistrarState state);
405     event RegistryPrice(uint256 price);
406     event RegistryMoved(address newRegistry);
407     event UsernameOwner(bytes32 indexed nameHash, address owner);
408 
409     enum RegistrarState { Inactive, Active, Moved }
410     bytes32 public ensNode;
411     uint256 public price;
412     RegistrarState public state;
413     uint256 public reserveAmount;
414 
415     struct Account {
416         uint256 balance;
417         uint256 creationTime;
418         address owner;
419     }
420 
421     struct SlashReserve {
422         address reserver;
423         uint256 blockNumber;
424     }
425 
426     /**
427      * @notice Callable only by `parentRegistry()` to continue migration of ENSSubdomainRegistry.
428      */
429     modifier onlyParentRegistry {
430         require(msg.sender == parentRegistry, "Migration only.");
431         _;
432     }
433 
434     /** 
435      * @notice Initializes UsernameRegistrar contract. 
436      * The only parameter from this list that can be changed later is `_resolver`.
437      * Other updates require a new contract and migration of domain.
438      * @param _token ERC20 token with optional `approveAndCall(address,uint256,bytes)` for locking fee.
439      * @param _ensRegistry Ethereum Name Service root contract address.
440      * @param _resolver Public Resolver for resolving usernames.
441      * @param _ensNode ENS node (domain) being used for usernames subnodes (subdomain)
442      * @param _usernameMinLength Minimum length of usernames 
443      * @param _reservedUsernamesMerkleRoot Merkle root of reserved usernames
444      * @param _parentRegistry Address of old registry (if any) for optional account migration.
445      */
446     constructor(
447         ERC20Token _token,
448         ENS _ensRegistry,
449         PublicResolver _resolver,
450         bytes32 _ensNode,
451         uint256 _usernameMinLength,
452         bytes32 _reservedUsernamesMerkleRoot,
453         address _parentRegistry
454     ) 
455         public 
456     {
457         require(address(_token) != address(0), "No ERC20Token address defined.");
458         require(address(_ensRegistry) != address(0), "No ENS address defined.");
459         require(address(_resolver) != address(0), "No Resolver address defined.");
460         require(_ensNode != bytes32(0), "No ENS node defined.");
461         token = _token;
462         ensRegistry = _ensRegistry;
463         resolver = _resolver;
464         ensNode = _ensNode;
465         usernameMinLength = _usernameMinLength;
466         reservedUsernamesMerkleRoot = _reservedUsernamesMerkleRoot;
467         parentRegistry = _parentRegistry;
468         setState(RegistrarState.Inactive);
469     }
470 
471     /**
472      * @notice Registers `_label` username to `ensNode` setting msg.sender as owner.
473      * Terms of name registration:
474      * - SNT is deposited, not spent; the amount is locked up for 1 year.
475      * - After 1 year, the user can release the name and receive their deposit back (at any time).
476      * - User deposits are completely protected. The contract controller cannot access them.
477      * - User's address(es) will be publicly associated with the ENS name.
478      * - User must authorise the contract to transfer `price` `token.name()`  on their behalf.
479      * - Usernames registered with less then `usernameMinLength` characters can be slashed.
480      * - Usernames contained in the merkle tree of root `reservedUsernamesMerkleRoot` can be slashed.
481      * - Usernames starting with `0x` and bigger then 12 characters can be slashed.
482      * - If terms of the contract change—e.g. Status makes contract upgrades—the user has the right to release the username and get their deposit back.
483      * @param _label Choosen unowned username hash.
484      * @param _account Optional address to set at public resolver.
485      * @param _pubkeyA Optional pubkey part A to set at public resolver.
486      * @param _pubkeyB Optional pubkey part B to set at public resolver.
487      */
488     function register(
489         bytes32 _label,
490         address _account,
491         bytes32 _pubkeyA,
492         bytes32 _pubkeyB
493     ) 
494         external 
495         returns(bytes32 namehash) 
496     {
497         return registerUser(msg.sender, _label, _account, _pubkeyA, _pubkeyB);
498     }
499     
500     /** 
501      * @notice Release username and retrieve locked fee, needs to be called 
502      * after `releasePeriod` from creation time by ENS registry owner of domain 
503      * or anytime by account owner when domain migrated to a new registry.
504      * @param _label Username hash.
505      */
506     function release(
507         bytes32 _label
508     )
509         external 
510     {
511         bytes32 namehash = keccak256(abi.encodePacked(ensNode, _label));
512         Account memory account = accounts[_label];
513         require(account.creationTime > 0, "Username not registered.");
514         if (state == RegistrarState.Active) {
515             require(msg.sender == ensRegistry.owner(namehash), "Not owner of ENS node.");
516             require(block.timestamp > account.creationTime + releaseDelay, "Release period not reached.");
517         } else {
518             require(msg.sender == account.owner, "Not the former account owner.");
519         }
520         delete accounts[_label];
521         if (account.balance > 0) {
522             reserveAmount -= account.balance;
523             require(token.transfer(msg.sender, account.balance), "Transfer failed");
524         }
525         if (state == RegistrarState.Active) {
526             ensRegistry.setSubnodeOwner(ensNode, _label, address(this));
527             ensRegistry.setResolver(namehash, address(0));
528             ensRegistry.setOwner(namehash, address(0));
529         } else {
530             address newOwner = ensRegistry.owner(ensNode);
531             //Low level call, case dropUsername not implemented or failing, proceed release. 
532             //Invert (!) to supress warning, return of this call have no use.
533             !newOwner.call.gas(80000)(
534                 abi.encodeWithSignature(
535                     "dropUsername(bytes32)",
536                     _label
537                 )
538             );
539         }
540         emit UsernameOwner(namehash, address(0));   
541     }
542 
543     /** 
544      * @notice update account owner, should be called by new ens node owner 
545      * to update this contract registry, otherwise former owner can release 
546      * if domain is moved to a new registry. 
547      * @param _label Username hash.
548      **/
549     function updateAccountOwner(
550         bytes32 _label
551     ) 
552         external 
553     {
554         bytes32 namehash = keccak256(abi.encodePacked(ensNode, _label));
555         require(msg.sender == ensRegistry.owner(namehash), "Caller not owner of ENS node.");
556         require(accounts[_label].creationTime > 0, "Username not registered.");
557         require(ensRegistry.owner(ensNode) == address(this), "Registry not owner of registry.");
558         accounts[_label].owner = msg.sender;
559         emit UsernameOwner(namehash, msg.sender);
560     }  
561 
562     /**
563      * @notice secretly reserve the slashing reward to `msg.sender`
564      * @param _secret keccak256(abi.encodePacked(namehash, creationTime, reserveSecret)) 
565      */
566     function reserveSlash(bytes32 _secret) external {
567         require(reservedSlashers[_secret].blockNumber == 0, "Already Reserved");
568         reservedSlashers[_secret] = SlashReserve(msg.sender, block.number);
569     }
570 
571     /**
572      * @notice Slash username smaller then `usernameMinLength`.
573      * @param _username Raw value of offending username.
574      */
575     function slashSmallUsername(
576         string _username,
577         uint256 _reserveSecret
578     ) 
579         external 
580     {
581         bytes memory username = bytes(_username);
582         require(username.length < usernameMinLength, "Not a small username.");
583         slashUsername(username, _reserveSecret);
584     }
585 
586     /**
587      * @notice Slash username starting with "0x" and with length greater than 12.
588      * @param _username Raw value of offending username.
589      */
590     function slashAddressLikeUsername(
591         string _username,
592         uint256 _reserveSecret
593     ) 
594         external 
595     {
596         bytes memory username = bytes(_username);
597         require(username.length > 12, "Too small to look like an address.");
598         require(username[0] == byte("0"), "First character need to be 0");
599         require(username[1] == byte("x"), "Second character need to be x");
600         for(uint i = 2; i < 7; i++){
601             byte b = username[i];
602             require((b >= 48 && b <= 57) || (b >= 97 && b <= 102), "Does not look like an address");
603         }
604         slashUsername(username, _reserveSecret);
605     }  
606 
607     /**
608      * @notice Slash username that is exactly a reserved name.
609      * @param _username Raw value of offending username.
610      * @param _proof Merkle proof that name is listed on merkle tree.
611      */
612     function slashReservedUsername(
613         string _username,
614         bytes32[] _proof,
615         uint256 _reserveSecret
616     ) 
617         external 
618     {   
619         bytes memory username = bytes(_username);
620         require(
621             MerkleProof.verifyProof(
622                 _proof,
623                 reservedUsernamesMerkleRoot,
624                 keccak256(username)
625             ),
626             "Invalid Proof."
627         );
628         slashUsername(username, _reserveSecret);
629     }
630 
631     /**
632      * @notice Slash username that contains a non alphanumeric character.
633      * @param _username Raw value of offending username.
634      * @param _offendingPos Position of non alphanumeric character.
635      */
636     function slashInvalidUsername(
637         string _username,
638         uint256 _offendingPos,
639         uint256 _reserveSecret
640     ) 
641         external
642     { 
643         bytes memory username = bytes(_username);
644         require(username.length > _offendingPos, "Invalid position.");
645         byte b = username[_offendingPos];
646         
647         require(!((b >= 48 && b <= 57) || (b >= 97 && b <= 122)), "Not invalid character.");
648     
649         slashUsername(username, _reserveSecret);
650     }
651 
652     /**
653      * @notice Clear resolver and ownership of unowned subdomians.
654      * @param _labels Sequence to erase.
655      */
656     function eraseNode(
657         bytes32[] _labels
658     ) 
659         external 
660     {
661         uint len = _labels.length;
662         require(len != 0, "Nothing to erase");
663         bytes32 label = _labels[len - 1];
664         bytes32 subnode = keccak256(abi.encodePacked(ensNode, label));
665         require(ensRegistry.owner(subnode) == address(0), "First slash/release top level subdomain");
666         ensRegistry.setSubnodeOwner(ensNode, label, address(this));
667         if(len > 1) {
668             eraseNodeHierarchy(len - 2, _labels, subnode);
669         }
670         ensRegistry.setResolver(subnode, 0);
671         ensRegistry.setOwner(subnode, 0);
672     }
673 
674     /**
675      * @notice Migrate account to new registry, opt-in to new contract.
676      * @param _label Username hash.
677      **/
678     function moveAccount(
679         bytes32 _label,
680         UsernameRegistrar _newRegistry
681     ) 
682         external 
683     {
684         require(state == RegistrarState.Moved, "Wrong contract state");
685         require(msg.sender == accounts[_label].owner, "Callable only by account owner.");
686         require(ensRegistry.owner(ensNode) == address(_newRegistry), "Wrong update");
687         Account memory account = accounts[_label];
688         delete accounts[_label];
689 
690         token.approve(_newRegistry, account.balance);
691         _newRegistry.migrateUsername(
692             _label,
693             account.balance,
694             account.creationTime,
695             account.owner
696         );
697     }
698 
699     /** 
700      * @notice Activate registration.
701      * @param _price The price of registration.
702      */
703     function activate(
704         uint256 _price
705     ) 
706         external
707         onlyController
708     {
709         require(state == RegistrarState.Inactive, "Registry state is not Inactive");
710         require(ensRegistry.owner(ensNode) == address(this), "Registry does not own registry");
711         price = _price;
712         setState(RegistrarState.Active);
713         emit RegistryPrice(_price);
714     }
715 
716     /** 
717      * @notice Updates Public Resolver for resolving users.
718      * @param _resolver New PublicResolver.
719      */
720     function setResolver(
721         address _resolver
722     ) 
723         external
724         onlyController
725     {
726         resolver = PublicResolver(_resolver);
727     }
728 
729     /**
730      * @notice Updates registration price.
731      * @param _price New registration price.
732      */
733     function updateRegistryPrice(
734         uint256 _price
735     ) 
736         external
737         onlyController
738     {
739         require(state == RegistrarState.Active, "Registry not owned");
740         price = _price;
741         emit RegistryPrice(_price);
742     }
743   
744     /**
745      * @notice Transfer ownership of ensNode to `_newRegistry`.
746      * Usernames registered are not affected, but they would be able to instantly release.
747      * @param _newRegistry New UsernameRegistrar for hodling `ensNode` node.
748      */
749     function moveRegistry(
750         UsernameRegistrar _newRegistry
751     ) 
752         external
753         onlyController
754     {
755         require(_newRegistry != this, "Cannot move to self.");
756         require(ensRegistry.owner(ensNode) == address(this), "Registry not owned anymore.");
757         setState(RegistrarState.Moved);
758         ensRegistry.setOwner(ensNode, _newRegistry);
759         _newRegistry.migrateRegistry(price);
760         emit RegistryMoved(_newRegistry);
761     }
762 
763     /** 
764      * @notice Opt-out migration of username from `parentRegistry()`.
765      * Clear ENS resolver and subnode owner.
766      * @param _label Username hash.
767      */
768     function dropUsername(
769         bytes32 _label
770     ) 
771         external 
772         onlyParentRegistry
773     {
774         require(accounts[_label].creationTime == 0, "Already migrated");
775         bytes32 namehash = keccak256(abi.encodePacked(ensNode, _label));
776         ensRegistry.setSubnodeOwner(ensNode, _label, address(this));
777         ensRegistry.setResolver(namehash, address(0));
778         ensRegistry.setOwner(namehash, address(0));
779     }
780 
781     /**
782      * @notice Withdraw not reserved tokens
783      * @param _token Address of ERC20 withdrawing excess, or address(0) if want ETH.
784      * @param _beneficiary Address to send the funds.
785      **/
786     function withdrawExcessBalance(
787         address _token,
788         address _beneficiary
789     )
790         external 
791         onlyController 
792     {
793         require(_beneficiary != address(0), "Cannot burn token");
794         if (_token == address(0)) {
795             _beneficiary.transfer(address(this).balance);
796         } else {
797             ERC20Token excessToken = ERC20Token(_token);
798             uint256 amount = excessToken.balanceOf(address(this));
799             if(_token == address(token)){
800                 require(amount > reserveAmount, "Is not excess");
801                 amount -= reserveAmount;
802             } else {
803                 require(amount > 0, "No balance");
804             }
805             excessToken.transfer(_beneficiary, amount);
806         }
807     }
808 
809     /**
810      * @notice Withdraw ens nodes not belonging to this contract.
811      * @param _domainHash Ens node namehash.
812      * @param _beneficiary New owner of ens node.
813      **/
814     function withdrawWrongNode(
815         bytes32 _domainHash,
816         address _beneficiary
817     ) 
818         external
819         onlyController
820     {
821         require(_beneficiary != address(0), "Cannot burn node");
822         require(_domainHash != ensNode, "Cannot withdraw main node");   
823         require(ensRegistry.owner(_domainHash) == address(this), "Not owner of this node");   
824         ensRegistry.setOwner(_domainHash, _beneficiary);
825     }
826 
827     /**
828      * @notice Gets registration price.
829      * @return Registration price.
830      **/
831     function getPrice() 
832         external 
833         view 
834         returns(uint256 registryPrice) 
835     {
836         return price;
837     }
838     
839     /**
840      * @notice reads amount tokens locked in username 
841      * @param _label Username hash.
842      * @return Locked username balance.
843      **/
844     function getAccountBalance(bytes32 _label)
845         external
846         view
847         returns(uint256 accountBalance) 
848     {
849         accountBalance = accounts[_label].balance;
850     }
851 
852     /**
853      * @notice reads username account owner at this contract, 
854      * which can release or migrate in case of upgrade.
855      * @param _label Username hash.
856      * @return Username account owner.
857      **/
858     function getAccountOwner(bytes32 _label)
859         external
860         view
861         returns(address owner) 
862     {
863         owner = accounts[_label].owner;
864     }
865 
866     /**
867      * @notice reads when the account was registered 
868      * @param _label Username hash.
869      * @return Registration time.
870      **/
871     function getCreationTime(bytes32 _label)
872         external
873         view
874         returns(uint256 creationTime) 
875     {
876         creationTime = accounts[_label].creationTime;
877     }
878 
879     /**
880      * @notice calculate time where username can be released 
881      * @param _label Username hash.
882      * @return Exact time when username can be released.
883      **/
884     function getExpirationTime(bytes32 _label)
885         external
886         view
887         returns(uint256 releaseTime)
888     {
889         uint256 creationTime = accounts[_label].creationTime;
890         if (creationTime > 0){
891             releaseTime = creationTime + releaseDelay;
892         }
893     }
894 
895     /**
896      * @notice calculate reward part an account could payout on slash 
897      * @param _label Username hash.
898      * @return Part of reward
899      **/
900     function getSlashRewardPart(bytes32 _label)
901         external
902         view
903         returns(uint256 partReward)
904     {
905         uint256 balance = accounts[_label].balance;
906         if (balance > 0) {
907             partReward = balance / 3;
908         }
909     }
910 
911     /**
912      * @notice Support for "approveAndCall". Callable only by `token()`.  
913      * @param _from Who approved.
914      * @param _amount Amount being approved, need to be equal `getPrice()`.
915      * @param _token Token being approved, need to be equal `token()`.
916      * @param _data Abi encoded data with selector of `register(bytes32,address,bytes32,bytes32)`.
917      */
918     function receiveApproval(
919         address _from,
920         uint256 _amount,
921         address _token,
922         bytes _data
923     ) 
924         public
925     {
926         require(_amount == price, "Wrong value");
927         require(_token == address(token), "Wrong token");
928         require(_token == address(msg.sender), "Wrong call");
929         require(_data.length <= 132, "Wrong data length");
930         bytes4 sig;
931         bytes32 label;
932         address account;
933         bytes32 pubkeyA;
934         bytes32 pubkeyB;
935         (sig, label, account, pubkeyA, pubkeyB) = abiDecodeRegister(_data);
936         require(
937             sig == bytes4(0xb82fedbb), //bytes4(keccak256("register(bytes32,address,bytes32,bytes32)"))
938             "Wrong method selector"
939         );
940         registerUser(_from, label, account, pubkeyA, pubkeyB);
941     }
942    
943     /**
944      * @notice Continues migration of username to new registry.
945      * @param _label Username hash.
946      * @param _tokenBalance Amount being transfered from `parentRegistry()`.
947      * @param _creationTime Time user registrated in `parentRegistry()` is preserved. 
948      * @param _accountOwner Account owner which migrated the account.
949      **/
950     function migrateUsername(
951         bytes32 _label,
952         uint256 _tokenBalance,
953         uint256 _creationTime,
954         address _accountOwner
955     )
956         external
957         onlyParentRegistry
958     {
959         if (_tokenBalance > 0) {
960             require(
961                 token.transferFrom(
962                     parentRegistry,
963                     address(this),
964                     _tokenBalance
965                 ), 
966                 "Error moving funds from old registar."
967             );
968             reserveAmount += _tokenBalance;
969         }
970         accounts[_label] = Account(_tokenBalance, _creationTime, _accountOwner);
971     }
972 
973     /**
974      * @dev callable only by parent registry to continue migration
975      * of registry and activate registration.
976      * @param _price The price of registration.
977      **/
978     function migrateRegistry(
979         uint256 _price
980     ) 
981         external
982         onlyParentRegistry
983     {
984         require(state == RegistrarState.Inactive, "Not Inactive");
985         require(ensRegistry.owner(ensNode) == address(this), "ENS registry owner not transfered.");
986         price = _price;
987         setState(RegistrarState.Active);
988         emit RegistryPrice(_price);
989     }
990 
991     /**
992      * @notice Registers `_label` username to `ensNode` setting msg.sender as owner.
993      * @param _owner Address registering the user and paying registry price.
994      * @param _label Choosen unowned username hash.
995      * @param _account Optional address to set at public resolver.
996      * @param _pubkeyA Optional pubkey part A to set at public resolver.
997      * @param _pubkeyB Optional pubkey part B to set at public resolver.
998      */
999     function registerUser(
1000         address _owner,
1001         bytes32 _label,
1002         address _account,
1003         bytes32 _pubkeyA,
1004         bytes32 _pubkeyB
1005     ) 
1006         internal 
1007         returns(bytes32 namehash)
1008     {
1009         require(state == RegistrarState.Active, "Registry unavailable.");
1010         namehash = keccak256(abi.encodePacked(ensNode, _label));
1011         require(ensRegistry.owner(namehash) == address(0), "ENS node already owned.");
1012         require(accounts[_label].creationTime == 0, "Username already registered.");
1013         accounts[_label] = Account(price, block.timestamp, _owner);
1014         if(price > 0) {
1015             require(token.allowance(_owner, address(this)) >= price, "Unallowed to spend.");
1016             require(
1017                 token.transferFrom(
1018                     _owner,
1019                     address(this),
1020                     price
1021                 ),
1022                 "Transfer failed"
1023             );
1024             reserveAmount += price;
1025         } 
1026     
1027         bool resolvePubkey = _pubkeyA != 0 || _pubkeyB != 0;
1028         bool resolveAccount = _account != address(0);
1029         if (resolvePubkey || resolveAccount) {
1030             //set to self the ownership to setup initial resolver
1031             ensRegistry.setSubnodeOwner(ensNode, _label, address(this));
1032             ensRegistry.setResolver(namehash, resolver); //default resolver
1033             if (resolveAccount) {
1034                 resolver.setAddr(namehash, _account);
1035             }
1036             if (resolvePubkey) {
1037                 resolver.setPubkey(namehash, _pubkeyA, _pubkeyB);
1038             }
1039             ensRegistry.setOwner(namehash, _owner);
1040         } else {
1041             //transfer ownership of subdone directly to registrant
1042             ensRegistry.setSubnodeOwner(ensNode, _label, _owner);
1043         }
1044         emit UsernameOwner(namehash, _owner);
1045     }
1046     
1047     /**
1048      * @dev Removes account hash of `_username` and send account.balance to msg.sender.
1049      * @param _username Username being slashed.
1050      */
1051     function slashUsername(
1052         bytes _username,
1053         uint256 _reserveSecret
1054     ) 
1055         internal 
1056     {
1057         bytes32 label = keccak256(_username);
1058         bytes32 namehash = keccak256(abi.encodePacked(ensNode, label));
1059         uint256 amountToTransfer = 0;
1060         uint256 creationTime = accounts[label].creationTime;
1061         address owner = ensRegistry.owner(namehash);
1062         if(creationTime == 0) {
1063             require(
1064                 owner != address(0) ||
1065                 ensRegistry.resolver(namehash) != address(0),
1066                 "Nothing to slash."
1067             );
1068         } else {
1069             assert(creationTime != block.timestamp);
1070             amountToTransfer = accounts[label].balance;
1071             delete accounts[label];
1072         }
1073 
1074         ensRegistry.setSubnodeOwner(ensNode, label, address(this));
1075         ensRegistry.setResolver(namehash, address(0));
1076         ensRegistry.setOwner(namehash, address(0));
1077         
1078         if (amountToTransfer > 0) {
1079             reserveAmount -= amountToTransfer;
1080             uint256 partialDeposit = amountToTransfer / 3;
1081             amountToTransfer = partialDeposit * 2; // reserve 1/3 to network (controller)
1082             bytes32 secret = keccak256(abi.encodePacked(namehash, creationTime, _reserveSecret));
1083             SlashReserve memory reserve = reservedSlashers[secret];
1084             require(reserve.reserver != address(0), "Not reserved.");
1085             require(reserve.blockNumber < block.number, "Cannot reveal in same block");
1086             delete reservedSlashers[secret];
1087 
1088             require(token.transfer(reserve.reserver, amountToTransfer), "Error in transfer.");
1089         }
1090         emit UsernameOwner(namehash, address(0));
1091     }
1092 
1093     function setState(RegistrarState _state) private {
1094         state = _state;
1095         emit RegistryState(_state);
1096     }
1097 
1098     /**
1099      * @notice recursively erase all _labels in _subnode
1100      * @param _idx recursive position of _labels to erase
1101      * @param _labels list of subnode labes
1102      * @param _subnode subnode being erased
1103      */
1104     function eraseNodeHierarchy(
1105         uint _idx,
1106         bytes32[] _labels,
1107         bytes32 _subnode
1108     ) 
1109         private 
1110     {
1111         // Take ownership of the node
1112         ensRegistry.setSubnodeOwner(_subnode, _labels[_idx], address(this));
1113         bytes32 subnode = keccak256(abi.encodePacked(_subnode, _labels[_idx]));
1114 
1115         // Recurse if there are more labels
1116         if (_idx > 0) {
1117             eraseNodeHierarchy(_idx - 1, _labels, subnode);
1118         }
1119 
1120         // Erase the resolver and owner records
1121         ensRegistry.setResolver(subnode, 0);
1122         ensRegistry.setOwner(subnode, 0);
1123     }
1124 
1125     /**
1126      * @dev Decodes abi encoded data with selector for "register(bytes32,address,bytes32,bytes32)".
1127      * @param _data Abi encoded data.
1128      * @return Decoded registry call.
1129      */
1130     function abiDecodeRegister(
1131         bytes _data
1132     ) 
1133         private 
1134         pure 
1135         returns(
1136             bytes4 sig,
1137             bytes32 label,
1138             address account,
1139             bytes32 pubkeyA,
1140             bytes32 pubkeyB
1141         )
1142     {
1143         assembly {
1144             sig := mload(add(_data, add(0x20, 0)))
1145             label := mload(add(_data, 36))
1146             account := mload(add(_data, 68))
1147             pubkeyA := mload(add(_data, 100))
1148             pubkeyB := mload(add(_data, 132))
1149         }
1150     }
1151 }