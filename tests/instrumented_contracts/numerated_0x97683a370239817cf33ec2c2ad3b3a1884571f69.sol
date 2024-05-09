1 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address private _owner;
12 
13     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor () internal {
20         _owner = msg.sender;
21         emit OwnershipTransferred(address(0), _owner);
22     }
23 
24     /**
25      * @return the address of the owner.
26      */
27     function owner() public view returns (address) {
28         return _owner;
29     }
30 
31     /**
32      * @dev Throws if called by any account other than the owner.
33      */
34     modifier onlyOwner() {
35         require(isOwner());
36         _;
37     }
38 
39     /**
40      * @return true if `msg.sender` is the owner of the contract.
41      */
42     function isOwner() public view returns (bool) {
43         return msg.sender == _owner;
44     }
45 
46     /**
47      * @dev Allows the current owner to relinquish control of the contract.
48      * It will not be possible to call the functions with the `onlyOwner`
49      * modifier anymore.
50      * @notice Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58     /**
59      * @dev Allows the current owner to transfer control of the contract to a newOwner.
60      * @param newOwner The address to transfer ownership to.
61      */
62     function transferOwnership(address newOwner) public onlyOwner {
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers control of the contract to a newOwner.
68      * @param newOwner The address to transfer ownership to.
69      */
70     function _transferOwnership(address newOwner) internal {
71         require(newOwner != address(0));
72         emit OwnershipTransferred(_owner, newOwner);
73         _owner = newOwner;
74     }
75 }
76 
77 // File: contracts/ResolverBase.sol
78 
79 pragma solidity ^0.5.0;
80 
81 contract ResolverBase {
82     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
83 
84     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
85         return interfaceID == INTERFACE_META_ID;
86     }
87 
88     function isAuthorised(bytes32 node) internal view returns(bool);
89 
90     modifier authorised(bytes32 node) {
91         require(isAuthorised(node));
92         _;
93     }
94 }
95 
96 // File: contracts/profiles/ABIResolver.sol
97 
98 pragma solidity ^0.5.0;
99 
100 
101 contract ABIResolver is ResolverBase {
102     bytes4 constant private ABI_INTERFACE_ID = 0x2203ab56;
103 
104     event ABIChanged(bytes32 indexed node, uint256 indexed contentType);
105 
106     mapping(bytes32=>mapping(uint256=>bytes)) abis;
107 
108     /**
109      * Sets the ABI associated with an ENS node.
110      * Nodes may have one ABI of each content type. To remove an ABI, set it to
111      * the empty string.
112      * @param node The node to update.
113      * @param contentType The content type of the ABI
114      * @param data The ABI data.
115      */
116     function setABI(bytes32 node, uint256 contentType, bytes calldata data) external authorised(node) {
117         // Content types must be powers of 2
118         require(((contentType - 1) & contentType) == 0);
119 
120         abis[node][contentType] = data;
121         emit ABIChanged(node, contentType);
122     }
123 
124     /**
125      * Returns the ABI associated with an ENS node.
126      * Defined in EIP205.
127      * @param node The ENS node to query
128      * @param contentTypes A bitwise OR of the ABI formats accepted by the caller.
129      * @return contentType The content type of the return value
130      * @return data The ABI data
131      */
132     function ABI(bytes32 node, uint256 contentTypes) external view returns (uint256, bytes memory) {
133         mapping(uint256=>bytes) storage abiset = abis[node];
134 
135         for (uint256 contentType = 1; contentType <= contentTypes; contentType <<= 1) {
136             if ((contentType & contentTypes) != 0 && abiset[contentType].length > 0) {
137                 return (contentType, abiset[contentType]);
138             }
139         }
140 
141         return (0, bytes(""));
142     }
143 
144     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
145         return interfaceID == ABI_INTERFACE_ID || super.supportsInterface(interfaceID);
146     }
147 }
148 
149 // File: contracts/profiles/AddrResolver.sol
150 
151 pragma solidity ^0.5.0;
152 
153 
154 contract AddrResolver is ResolverBase {
155     bytes4 constant private ADDR_INTERFACE_ID = 0x3b3b57de;
156 
157     event AddrChanged(bytes32 indexed node, address a);
158 
159     mapping(bytes32=>address) addresses;
160 
161     /**
162      * Sets the address associated with an ENS node.
163      * May only be called by the owner of that node in the ENS registry.
164      * @param node The node to update.
165      * @param addr The address to set.
166      */
167     function setAddr(bytes32 node, address addr) external authorised(node) {
168         addresses[node] = addr;
169         emit AddrChanged(node, addr);
170     }
171 
172     /**
173      * Returns the address associated with an ENS node.
174      * @param node The ENS node to query.
175      * @return The associated address.
176      */
177     function addr(bytes32 node) public view returns (address) {
178         return addresses[node];
179     }
180 
181     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
182         return interfaceID == ADDR_INTERFACE_ID || super.supportsInterface(interfaceID);
183     }
184 }
185 
186 // File: contracts/profiles/ContentHashResolver.sol
187 
188 pragma solidity ^0.5.0;
189 
190 
191 contract ContentHashResolver is ResolverBase {
192     bytes4 constant private CONTENT_HASH_INTERFACE_ID = 0xbc1c58d1;
193 
194     event ContenthashChanged(bytes32 indexed node, bytes hash);
195 
196     mapping(bytes32=>bytes) hashes;
197 
198     /**
199      * Sets the contenthash associated with an ENS node.
200      * May only be called by the owner of that node in the ENS registry.
201      * @param node The node to update.
202      * @param hash The contenthash to set
203      */
204     function setContenthash(bytes32 node, bytes calldata hash) external authorised(node) {
205         hashes[node] = hash;
206         emit ContenthashChanged(node, hash);
207     }
208 
209     /**
210      * Returns the contenthash associated with an ENS node.
211      * @param node The ENS node to query.
212      * @return The associated contenthash.
213      */
214     function contenthash(bytes32 node) external view returns (bytes memory) {
215         return hashes[node];
216     }
217 
218     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
219         return interfaceID == CONTENT_HASH_INTERFACE_ID || super.supportsInterface(interfaceID);
220     }
221 }
222 
223 // File: contracts/profiles/InterfaceResolver.sol
224 
225 pragma solidity ^0.5.0;
226 
227 
228 
229 contract InterfaceResolver is ResolverBase, AddrResolver {
230     bytes4 constant private INTERFACE_INTERFACE_ID = bytes4(keccak256("interfaceImplementer(bytes32,bytes4)"));
231     bytes4 private constant INTERFACE_META_ID = 0x01ffc9a7;
232 
233     event InterfaceChanged(bytes32 indexed node, bytes4 indexed interfaceID, address implementer);
234 
235     mapping(bytes32=>mapping(bytes4=>address)) interfaces;
236 
237     /**
238      * Sets an interface associated with a name.
239      * Setting the address to 0 restores the default behaviour of querying the contract at `addr()` for interface support.
240      * @param node The node to update.
241      * @param interfaceID The EIP 168 interface ID.
242      * @param implementer The address of a contract that implements this interface for this node.
243      */
244     function setInterface(bytes32 node, bytes4 interfaceID, address implementer) external authorised(node) {
245         interfaces[node][interfaceID] = implementer;
246         emit InterfaceChanged(node, interfaceID, implementer);
247     }
248 
249     /**
250      * Returns the address of a contract that implements the specified interface for this name.
251      * If an implementer has not been set for this interfaceID and name, the resolver will query
252      * the contract at `addr()`. If `addr()` is set, a contract exists at that address, and that
253      * contract implements EIP168 and returns `true` for the specified interfaceID, its address
254      * will be returned.
255      * @param node The ENS node to query.
256      * @param interfaceID The EIP 168 interface ID to check for.
257      * @return The address that implements this interface, or 0 if the interface is unsupported.
258      */
259     function interfaceImplementer(bytes32 node, bytes4 interfaceID) external view returns (address) {
260         address implementer = interfaces[node][interfaceID];
261         if(implementer != address(0)) {
262             return implementer;
263         }
264 
265         address a = addr(node);
266         if(a == address(0)) {
267             return address(0);
268         }
269 
270         (bool success, bytes memory returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", INTERFACE_META_ID));
271         if(!success || returnData.length < 32 || returnData[31] == 0) {
272             // EIP 168 not supported by target
273             return address(0);
274         }
275 
276         (success, returnData) = a.staticcall(abi.encodeWithSignature("supportsInterface(bytes4)", interfaceID));
277         if(!success || returnData.length < 32 || returnData[31] == 0) {
278             // Specified interface not supported by target
279             return address(0);
280         }
281 
282         return a;
283     }
284 
285     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
286         return interfaceID == INTERFACE_INTERFACE_ID || super.supportsInterface(interfaceID);
287     }
288 }
289 
290 // File: contracts/profiles/NameResolver.sol
291 
292 pragma solidity ^0.5.0;
293 
294 
295 contract NameResolver is ResolverBase {
296     bytes4 constant private NAME_INTERFACE_ID = 0x691f3431;
297 
298     event NameChanged(bytes32 indexed node, string name);
299 
300     mapping(bytes32=>string) names;
301 
302     /**
303      * Sets the name associated with an ENS node, for reverse records.
304      * May only be called by the owner of that node in the ENS registry.
305      * @param node The node to update.
306      * @param name The name to set.
307      */
308     function setName(bytes32 node, string calldata name) external authorised(node) {
309         names[node] = name;
310         emit NameChanged(node, name);
311     }
312 
313     /**
314      * Returns the name associated with an ENS node, for reverse records.
315      * Defined in EIP181.
316      * @param node The ENS node to query.
317      * @return The associated name.
318      */
319     function name(bytes32 node) external view returns (string memory) {
320         return names[node];
321     }
322 
323     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
324         return interfaceID == NAME_INTERFACE_ID || super.supportsInterface(interfaceID);
325     }
326 }
327 
328 // File: contracts/profiles/PubkeyResolver.sol
329 
330 pragma solidity ^0.5.0;
331 
332 
333 contract PubkeyResolver is ResolverBase {
334     bytes4 constant private PUBKEY_INTERFACE_ID = 0xc8690233;
335 
336     event PubkeyChanged(bytes32 indexed node, bytes32 x, bytes32 y);
337 
338     struct PublicKey {
339         bytes32 x;
340         bytes32 y;
341     }
342 
343     mapping(bytes32=>PublicKey) pubkeys;
344 
345     /**
346      * Sets the SECP256k1 public key associated with an ENS node.
347      * @param node The ENS node to query
348      * @param x the X coordinate of the curve point for the public key.
349      * @param y the Y coordinate of the curve point for the public key.
350      */
351     function setPubkey(bytes32 node, bytes32 x, bytes32 y) external authorised(node) {
352         pubkeys[node] = PublicKey(x, y);
353         emit PubkeyChanged(node, x, y);
354     }
355 
356     /**
357      * Returns the SECP256k1 public key associated with an ENS node.
358      * Defined in EIP 619.
359      * @param node The ENS node to query
360      * @return x, y the X and Y coordinates of the curve point for the public key.
361      */
362     function pubkey(bytes32 node) external view returns (bytes32 x, bytes32 y) {
363         return (pubkeys[node].x, pubkeys[node].y);
364     }
365 
366     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
367         return interfaceID == PUBKEY_INTERFACE_ID || super.supportsInterface(interfaceID);
368     }
369 }
370 
371 // File: contracts/profiles/TextResolver.sol
372 
373 pragma solidity ^0.5.0;
374 
375 
376 contract TextResolver is ResolverBase {
377     bytes4 constant private TEXT_INTERFACE_ID = 0x59d1d43c;
378 
379     event TextChanged(bytes32 indexed node, string indexedKey, string key);
380 
381     mapping(bytes32=>mapping(string=>string)) texts;
382 
383     /**
384      * Sets the text data associated with an ENS node and key.
385      * May only be called by the owner of that node in the ENS registry.
386      * @param node The node to update.
387      * @param key The key to set.
388      * @param value The text data value to set.
389      */
390     function setText(bytes32 node, string calldata key, string calldata value) external authorised(node) {
391         texts[node][key] = value;
392         emit TextChanged(node, key, key);
393     }
394 
395     /**
396      * Returns the text data associated with an ENS node and key.
397      * @param node The ENS node to query.
398      * @param key The text data key to query.
399      * @return The associated text data.
400      */
401     function text(bytes32 node, string calldata key) external view returns (string memory) {
402         return texts[node][key];
403     }
404 
405     function supportsInterface(bytes4 interfaceID) public pure returns(bool) {
406         return interfaceID == TEXT_INTERFACE_ID || super.supportsInterface(interfaceID);
407     }
408 }
409 
410 // File: contracts/OwnedResolver.sol
411 
412 pragma solidity ^0.5.0;
413 
414 
415 
416 
417 
418 
419 
420 
421 
422 /**
423  * A simple resolver anyone can use; only allows the owner of a node to set its
424  * address.
425  */
426 contract OwnedResolver is Ownable, ABIResolver, AddrResolver, ContentHashResolver, InterfaceResolver, NameResolver, PubkeyResolver, TextResolver {
427     function isAuthorised(bytes32 node) internal view returns(bool) {
428         return msg.sender == owner();
429     }
430 }