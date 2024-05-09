1 pragma solidity 0.4.24;
2 
3 contract safeSend {
4     bool private txMutex3847834;
5 
6     // we want to be able to call outside contracts (e.g. the admin proxy contract)
7     // but reentrency is bad, so here's a mutex.
8     function doSafeSend(address toAddr, uint amount) internal {
9         doSafeSendWData(toAddr, "", amount);
10     }
11 
12     function doSafeSendWData(address toAddr, bytes data, uint amount) internal {
13         require(txMutex3847834 == false, "ss-guard");
14         txMutex3847834 = true;
15         // we need to use address.call.value(v)() because we want
16         // to be able to send to other contracts, even with no data,
17         // which might use more than 2300 gas in their fallback function.
18         require(toAddr.call.value(amount)(data), "ss-failed");
19         txMutex3847834 = false;
20     }
21 }
22 
23 contract payoutAllC is safeSend {
24     address private _payTo;
25 
26     event PayoutAll(address payTo, uint value);
27 
28     constructor(address initPayTo) public {
29         // DEV NOTE: you can overwrite _getPayTo if you want to reuse other storage vars
30         assert(initPayTo != address(0));
31         _payTo = initPayTo;
32     }
33 
34     function _getPayTo() internal view returns (address) {
35         return _payTo;
36     }
37 
38     function _setPayTo(address newPayTo) internal {
39         _payTo = newPayTo;
40     }
41 
42     function payoutAll() external {
43         address a = _getPayTo();
44         uint bal = address(this).balance;
45         doSafeSend(a, bal);
46         emit PayoutAll(a, bal);
47     }
48 }
49 
50 contract payoutAllCSettable is payoutAllC {
51     constructor (address initPayTo) payoutAllC(initPayTo) public {
52     }
53 
54     function setPayTo(address) external;
55     function getPayTo() external view returns (address) {
56         return _getPayTo();
57     }
58 }
59 
60 contract owned {
61     address public owner;
62 
63     event OwnerChanged(address newOwner);
64 
65     modifier only_owner() {
66         require(msg.sender == owner, "only_owner: forbidden");
67         _;
68     }
69 
70     modifier owner_or(address addr) {
71         require(msg.sender == addr || msg.sender == owner, "!owner-or");
72         _;
73     }
74 
75     constructor() public {
76         owner = msg.sender;
77     }
78 
79     function setOwner(address newOwner) only_owner() external {
80         owner = newOwner;
81         emit OwnerChanged(newOwner);
82     }
83 }
84 
85 contract controlledIface {
86     function controller() external view returns (address);
87 }
88 
89 contract hasAdmins is owned {
90     mapping (uint => mapping (address => bool)) admins;
91     uint public currAdminEpoch = 0;
92     bool public adminsDisabledForever = false;
93     address[] adminLog;
94 
95     event AdminAdded(address indexed newAdmin);
96     event AdminRemoved(address indexed oldAdmin);
97     event AdminEpochInc();
98     event AdminDisabledForever();
99 
100     modifier only_admin() {
101         require(adminsDisabledForever == false, "admins must not be disabled");
102         require(isAdmin(msg.sender), "only_admin: forbidden");
103         _;
104     }
105 
106     constructor() public {
107         _setAdmin(msg.sender, true);
108     }
109 
110     function isAdmin(address a) view public returns (bool) {
111         return admins[currAdminEpoch][a];
112     }
113 
114     function getAdminLogN() view external returns (uint) {
115         return adminLog.length;
116     }
117 
118     function getAdminLog(uint n) view external returns (address) {
119         return adminLog[n];
120     }
121 
122     function upgradeMeAdmin(address newAdmin) only_admin() external {
123         // note: already checked msg.sender has admin with `only_admin` modifier
124         require(msg.sender != owner, "owner cannot upgrade self");
125         _setAdmin(msg.sender, false);
126         _setAdmin(newAdmin, true);
127     }
128 
129     function setAdmin(address a, bool _givePerms) only_admin() external {
130         require(a != msg.sender && a != owner, "cannot change your own (or owner's) permissions");
131         _setAdmin(a, _givePerms);
132     }
133 
134     function _setAdmin(address a, bool _givePerms) internal {
135         admins[currAdminEpoch][a] = _givePerms;
136         if (_givePerms) {
137             emit AdminAdded(a);
138             adminLog.push(a);
139         } else {
140             emit AdminRemoved(a);
141         }
142     }
143 
144     // safety feature if admins go bad or something
145     function incAdminEpoch() only_owner() external {
146         currAdminEpoch++;
147         admins[currAdminEpoch][msg.sender] = true;
148         emit AdminEpochInc();
149     }
150 
151     // this is internal so contracts can all it, but not exposed anywhere in this
152     // contract.
153     function disableAdminForever() internal {
154         currAdminEpoch++;
155         adminsDisabledForever = true;
156         emit AdminDisabledForever();
157     }
158 }
159 
160 contract EnsOwnerProxy is hasAdmins {
161     bytes32 public ensNode;
162     ENSIface public ens;
163     PublicResolver public resolver;
164 
165     /**
166      * @param _ensNode The node to administer
167      * @param _ens The ENS Registrar
168      * @param _resolver The ENS Resolver
169      */
170     constructor(bytes32 _ensNode, ENSIface _ens, PublicResolver _resolver) public {
171         ensNode = _ensNode;
172         ens = _ens;
173         resolver = _resolver;
174     }
175 
176     function setAddr(address addr) only_admin() external {
177         _setAddr(addr);
178     }
179 
180     function _setAddr(address addr) internal {
181         resolver.setAddr(ensNode, addr);
182     }
183 
184     function returnToOwner() only_owner() external {
185         ens.setOwner(ensNode, owner);
186     }
187 
188     function fwdToENS(bytes data) only_owner() external {
189         require(address(ens).call(data), "fwding to ens failed");
190     }
191 
192     function fwdToResolver(bytes data) only_owner() external {
193         require(address(resolver).call(data), "fwding to resolver failed");
194     }
195 }
196 
197 contract permissioned is owned, hasAdmins {
198     mapping (address => bool) editAllowed;
199     bool public adminLockdown = false;
200 
201     event PermissionError(address editAddr);
202     event PermissionGranted(address editAddr);
203     event PermissionRevoked(address editAddr);
204     event PermissionsUpgraded(address oldSC, address newSC);
205     event SelfUpgrade(address oldSC, address newSC);
206     event AdminLockdown();
207 
208     modifier only_editors() {
209         require(editAllowed[msg.sender], "only_editors: forbidden");
210         _;
211     }
212 
213     modifier no_lockdown() {
214         require(adminLockdown == false, "no_lockdown: check failed");
215         _;
216     }
217 
218 
219     constructor() owned() hasAdmins() public {
220     }
221 
222 
223     function setPermissions(address e, bool _editPerms) no_lockdown() only_admin() external {
224         editAllowed[e] = _editPerms;
225         if (_editPerms)
226             emit PermissionGranted(e);
227         else
228             emit PermissionRevoked(e);
229     }
230 
231     function upgradePermissionedSC(address oldSC, address newSC) no_lockdown() only_admin() external {
232         editAllowed[oldSC] = false;
233         editAllowed[newSC] = true;
234         emit PermissionsUpgraded(oldSC, newSC);
235     }
236 
237     // always allow SCs to upgrade themselves, even after lockdown
238     function upgradeMe(address newSC) only_editors() external {
239         editAllowed[msg.sender] = false;
240         editAllowed[newSC] = true;
241         emit SelfUpgrade(msg.sender, newSC);
242     }
243 
244     function hasPermissions(address a) public view returns (bool) {
245         return editAllowed[a];
246     }
247 
248     function doLockdown() external only_owner() no_lockdown() {
249         disableAdminForever();
250         adminLockdown = true;
251         emit AdminLockdown();
252     }
253 }
254 
255 contract upgradePtr {
256     address ptr = address(0);
257 
258     modifier not_upgraded() {
259         require(ptr == address(0), "upgrade pointer is non-zero");
260         _;
261     }
262 
263     function getUpgradePointer() view external returns (address) {
264         return ptr;
265     }
266 
267     function doUpgradeInternal(address nextSC) internal {
268         ptr = nextSC;
269     }
270 }
271 
272 interface ERC20Interface {
273     // Get the total token supply
274     function totalSupply() constant external returns (uint256 _totalSupply);
275 
276     // Get the account balance of another account with address _owner
277     function balanceOf(address _owner) constant external returns (uint256 balance);
278 
279     // Send _value amount of tokens to address _to
280     function transfer(address _to, uint256 _value) external returns (bool success);
281 
282     // Send _value amount of tokens from address _from to address _to
283     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
284 
285     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
286     // If this function is called again it overwrites the current allowance with _value.
287     // this function is required for some DEX functionality
288     function approve(address _spender, uint256 _value) external returns (bool success);
289 
290     // Returns the amount which _spender is still allowed to withdraw from _owner
291     function allowance(address _owner, address _spender) constant external returns (uint256 remaining);
292 
293     // Triggered when tokens are transferred.
294     event Transfer(address indexed _from, address indexed _to, uint256 _value);
295 
296     // Triggered whenever approve(address _spender, uint256 _value) is called.
297     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
298 }
299 
300 interface SvEnsIface {
301     // Logged when the owner of a node assigns a new owner to a subnode.
302     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
303 
304     // Logged when the owner of a node transfers ownership to a new account.
305     event Transfer(bytes32 indexed node, address owner);
306 
307     // Logged when the resolver for a node changes.
308     event NewResolver(bytes32 indexed node, address resolver);
309 
310     // Logged when the TTL of a node changes
311     event NewTTL(bytes32 indexed node, uint64 ttl);
312 
313 
314     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external returns (bytes32);
315     function setResolver(bytes32 node, address resolver) external;
316     function setOwner(bytes32 node, address owner) external;
317     function setTTL(bytes32 node, uint64 ttl) external;
318     function owner(bytes32 node) external view returns (address);
319     function resolver(bytes32 node) external view returns (address);
320     function ttl(bytes32 node) external view returns (uint64);
321 }
322 
323 interface ENSIface {
324     // Logged when the owner of a node assigns a new owner to a subnode.
325     event NewOwner(bytes32 indexed node, bytes32 indexed label, address owner);
326 
327     // Logged when the owner of a node transfers ownership to a new account.
328     event Transfer(bytes32 indexed node, address owner);
329 
330     // Logged when the resolver for a node changes.
331     event NewResolver(bytes32 indexed node, address resolver);
332 
333     // Logged when the TTL of a node changes
334     event NewTTL(bytes32 indexed node, uint64 ttl);
335 
336 
337     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) external;
338     function setResolver(bytes32 node, address resolver) external;
339     function setOwner(bytes32 node, address owner) external;
340     function setTTL(bytes32 node, uint64 ttl) external;
341     function owner(bytes32 node) external view returns (address);
342     function resolver(bytes32 node) external view returns (address);
343     function ttl(bytes32 node) external view returns (uint64);
344 }
345 
346 contract PublicResolver {
347 
348     bytes4 constant INTERFACE_META_ID = 0x01ffc9a7;
349     bytes4 constant ADDR_INTERFACE_ID = 0x3b3b57de;
350     bytes4 constant CONTENT_INTERFACE_ID = 0xd8389dc5;
351     bytes4 constant NAME_INTERFACE_ID = 0x691f3431;
352     bytes4 constant ABI_INTERFACE_ID = 0x2203ab56;
353     bytes4 constant PUBKEY_INTERFACE_ID = 0xc8690233;
354     bytes4 constant TEXT_INTERFACE_ID = 0x59d1d43c;
355 
356     event AddrChanged(bytes32 indexed node, address a);
357     event ContentChanged(bytes32 indexed node, bytes32 hash);
358     event NameChanged(bytes32 indexed node, string name);
359     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
360     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
361     event TextChanged(bytes32 indexed node, string indexedKey, string key);
362 
363     struct PublicKey {
364         bytes32 x;
365         bytes32 y;
366     }
367 
368     struct Record {
369         address addr;
370         bytes32 content;
371         string name;
372         PublicKey pubkey;
373         mapping(string=>string) text;
374         mapping(uint256=>bytes) abis;
375     }
376 
377     ENSIface ens;
378 
379     mapping (bytes32 => Record) records;
380 
381     modifier only_owner(bytes32 node) {
382         require(ens.owner(node) == msg.sender);
383         _;
384     }
385 
386     /**
387      * Constructor.
388      * @param ensAddr The ENS registrar contract.
389      */
390     constructor(ENSIface ensAddr) public {
391         ens = ensAddr;
392     }
393 
394     /**
395      * Sets the address associated with an ENS node.
396      * May only be called by the owner of that node in the ENS registry.
397      * @param node The node to update.
398      * @param addr The address to set.
399      */
400     function setAddr(bytes32 node, address addr) public only_owner(node) {
401         records[node].addr = addr;
402         emit AddrChanged(node, addr);
403     }
404 
405     /**
406      * Sets the content hash associated with an ENS node.
407      * May only be called by the owner of that node in the ENS registry.
408      * Note that this resource type is not standardized, and will likely change
409      * in future to a resource type based on multihash.
410      * @param node The node to update.
411      * @param hash The content hash to set
412      */
413     function setContent(bytes32 node, bytes32 hash) public only_owner(node) {
414         records[node].content = hash;
415         emit ContentChanged(node, hash);
416     }
417 
418     /**
419      * Sets the name associated with an ENS node, for reverse records.
420      * May only be called by the owner of that node in the ENS registry.
421      * @param node The node to update.
422      * @param name The name to set.
423      */
424     function setName(bytes32 node, string name) public only_owner(node) {
425         records[node].name = name;
426         emit NameChanged(node, name);
427     }
428 
429     /**
430      * Sets the ABI associated with an ENS node.
431      * Nodes may have one ABI of each content type. To remove an ABI, set it to
432      * the empty string.
433      * @param node The node to update.
434      * @param contentType The content type of the ABI
435      * @param data The ABI data.
436      */
437     function setABI(bytes32 node, uint256 contentType, bytes data) public only_owner(node) {
438         // Content types must be powers of 2
439         require(((contentType - 1) & contentType) == 0);
440 
441         records[node].abis[contentType] = data;
442         emit ABIChanged(node, contentType);
443     }
444 
445     /**
446      * Sets the SECP256k1 public key associated with an ENS node.
447      * @param node The ENS node to query
448      * @param x the X coordinate of the curve point for the public key.
449      * @param y the Y coordinate of the curve point for the public key.
450      */
451     function setPubkey(bytes32 node, bytes32 x, bytes32 y) public only_owner(node) {
452         records[node].pubkey = PublicKey(x, y);
453         emit PubkeyChanged(node, x, y);
454     }
455 
456     /**
457      * Sets the text data associated with an ENS node and key.
458      * May only be called by the owner of that node in the ENS registry.
459      * @param node The node to update.
460      * @param key The key to set.
461      * @param value The text data value to set.
462      */
463     function setText(bytes32 node, string key, string value) public only_owner(node) {
464         records[node].text[key] = value;
465         emit TextChanged(node, key, key);
466     }
467 
468     /**
469      * Returns the text data associated with an ENS node and key.
470      * @param node The ENS node to query.
471      * @param key The text data key to query.
472      * @return The associated text data.
473      */
474     function text(bytes32 node, string key) public view returns (string) {
475         return records[node].text[key];
476     }
477 
478     /**
479      * Returns the SECP256k1 public key associated with an ENS node.
480      * Defined in EIP 619.
481      * @param node The ENS node to query
482      * @return x, y the X and Y coordinates of the curve point for the public key.
483      */
484     function pubkey(bytes32 node) public view returns (bytes32 x, bytes32 y) {
485         return (records[node].pubkey.x, records[node].pubkey.y);
486     }
487 
488     /**
489      * Returns the ABI associated with an ENS node.
490      * Defined in EIP205.
491      * @param node The ENS node to query
492      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
493      * @return contentType The content type of the return value
494      * @return data The ABI data
495      */
496     function ABI(bytes32 node, uint256 contentTypes) public view returns (uint256 contentType, bytes data) {
497         Record storage record = records[node];
498         for (contentType = 1; contentType <= contentTypes; contentType <<= 1) {
499             if ((contentType & contentTypes) != 0 && record.abis[contentType].length > 0) {
500                 data = record.abis[contentType];
501                 return;
502             }
503         }
504         contentType = 0;
505     }
506 
507     /**
508      * Returns the name associated with an ENS node, for reverse records.
509      * Defined in EIP181.
510      * @param node The ENS node to query.
511      * @return The associated name.
512      */
513     function name(bytes32 node) public view returns (string) {
514         return records[node].name;
515     }
516 
517     /**
518      * Returns the content hash associated with an ENS node.
519      * Note that this resource type is not standardized, and will likely change
520      * in future to a resource type based on multihash.
521      * @param node The ENS node to query.
522      * @return The associated content hash.
523      */
524     function content(bytes32 node) public view returns (bytes32) {
525         return records[node].content;
526     }
527 
528     /**
529      * Returns the address associated with an ENS node.
530      * @param node The ENS node to query.
531      * @return The associated address.
532      */
533     function addr(bytes32 node) public view returns (address) {
534         return records[node].addr;
535     }
536 
537     /**
538      * Returns true if the resolver implements the interface specified by the provided hash.
539      * @param interfaceID The ID of the interface to check for.
540      * @return True if the contract implements the requested interface.
541      */
542     function supportsInterface(bytes4 interfaceID) public pure returns (bool) {
543         return interfaceID == ADDR_INTERFACE_ID ||
544         interfaceID == CONTENT_INTERFACE_ID ||
545         interfaceID == NAME_INTERFACE_ID ||
546         interfaceID == ABI_INTERFACE_ID ||
547         interfaceID == PUBKEY_INTERFACE_ID ||
548         interfaceID == TEXT_INTERFACE_ID ||
549         interfaceID == INTERFACE_META_ID;
550     }
551 }