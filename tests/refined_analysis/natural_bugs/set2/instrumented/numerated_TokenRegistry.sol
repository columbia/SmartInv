1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 // ============ Nomad Contracts ============
5 import {BridgeMessage} from "./BridgeMessage.sol";
6 import {XAppConnectionClient} from "../XAppConnectionClient.sol";
7 import {Encoding} from "./Encoding.sol";
8 import {TypeCasts} from "@nomad-xyz/nomad-core-sol/contracts/XAppConnectionManager.sol";
9 import {UpgradeBeaconProxy} from "@nomad-xyz/nomad-core-sol/contracts/upgrade/UpgradeBeaconProxy.sol";
10 // ============ Interfaces ============
11 import {ITokenRegistry} from "../../interfaces/bridge/ITokenRegistry.sol";
12 import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
13 import {IBridgeToken} from "../../interfaces/bridge/IBridgeToken.sol";
14 // ============ External Contracts ============
15 import {TypedMemView} from "@summa-tx/memview-sol/contracts/TypedMemView.sol";
16 import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
17 
18 /**
19  * @title TokenRegistry
20  * @notice manages a registry of token contracts on this chain
21  * -
22  * We sort token types as "representation token" or "locally originating token".
23  * Locally originating - a token contract that was originally deployed on the local chain
24  * Representation (repr) - a token that was originally deployed on some other chain
25  * -
26  * When the BridgeRouter handles an incoming message, it determines whether the
27  * transfer is for an asset of local origin. If not, it checks for an existing
28  * representation contract. If no such representation exists, it deploys a new
29  * representation contract. It then stores the relationship in the
30  * "reprToCanonical" and "canonicalToRepr" mappings to ensure we can always
31  * perform a lookup in either direction
32  * Note that locally originating tokens should NEVER be represented in these lookup tables.
33  */
34 contract TokenRegistry is Initializable, XAppConnectionClient, ITokenRegistry {
35     // ============ Libraries ============
36 
37     using TypedMemView for bytes;
38     using TypedMemView for bytes29;
39     using BridgeMessage for bytes29;
40 
41     // ============ Public Storage ============
42 
43     // UpgradeBeacon from which new token proxies will get their implementation
44     address public tokenBeacon;
45     // local representation token address => token ID
46     mapping(address => BridgeMessage.TokenId) public representationToCanonical;
47     // hash of the tightly-packed TokenId => local representation token address
48     // If the token is of local origin, this MUST map to address(0).
49     mapping(bytes32 => address) public canonicalToRepresentation;
50 
51     // ============ Upgrade Gap ============
52 
53     // gap for upgrade safety
54     uint256[49] private __GAP;
55 
56     // ============ Events ============
57 
58     /**
59      * @notice emitted when a representation token contract is deployed
60      * @param domain the domain of the chain where the canonical asset is deployed
61      * @param id the bytes32 address of the canonical token contract
62      * @param representation the address of the newly locally deployed representation contract
63      */
64     event TokenDeployed(
65         uint32 indexed domain,
66         bytes32 indexed id,
67         address indexed representation
68     );
69 
70     // ======== Initializer =========
71 
72     function initialize(address _tokenBeacon, address _xAppConnectionManager)
73         public
74         initializer
75     {
76         tokenBeacon = _tokenBeacon;
77         __XAppConnectionClient_initialize(_xAppConnectionManager);
78     }
79 
80     // ======== TokenId & Address Lookup for Representation Tokens =========
81 
82     /**
83      * @notice Look up the canonical token ID for a representation token
84      * @param _representation the address of the representation contract
85      * @return _domain the domain of the canonical version.
86      * @return _id the identifier of the canonical version in its domain.
87      */
88     function getCanonicalTokenId(address _representation)
89         external
90         view
91         returns (uint32 _domain, bytes32 _id)
92     {
93         BridgeMessage.TokenId memory _canonical = representationToCanonical[
94             _representation
95         ];
96         _domain = _canonical.domain;
97         _id = _canonical.id;
98     }
99 
100     /**
101      * @notice Look up the representation address for a canonical token
102      * @param _domain the domain of the canonical version.
103      * @param _id the identifier of the canonical version in its domain.
104      * @return _representation the address of the representation contract
105      */
106     function getRepresentationAddress(uint32 _domain, bytes32 _id)
107         public
108         view
109         returns (address _representation)
110     {
111         bytes29 _tokenId = BridgeMessage.formatTokenId(_domain, _id);
112         bytes32 _idHash = _tokenId.keccak();
113         _representation = canonicalToRepresentation[_idHash];
114     }
115 
116     // ======== External: Deploying Representation Tokens =========
117 
118     /**
119      * @notice Get the address of the local token for the provided tokenId;
120      * if the token is remote and no local representation exists, deploy the representation contract
121      * @param _domain the token's native domain
122      * @param _id the token's id on its native domain
123      * @return _local the address of the local token contract
124      */
125     function ensureLocalToken(uint32 _domain, bytes32 _id)
126         external
127         override
128         onlyOwner
129         returns (address _local)
130     {
131         _local = getLocalAddress(_domain, _id);
132         if (_local == address(0)) {
133             // Representation does not exist yet;
134             // deploy representation contract
135             _local = _deployToken(_domain, _id);
136         }
137     }
138 
139     // ======== External: Enrolling Representation Tokens =========
140 
141     /**
142      * @notice Enroll a custom token. This allows projects to work with
143      * governance to specify a custom representation.
144      * @dev This is done by inserting the custom representation into the token
145      * lookup tables. It is permissioned to the owner (governance) and can
146      * potentially break token representations. It must be used with extreme
147      * caution.
148      * After the token is inserted, new mint instructions will be sent to the
149      * custom token. The default representation (and old custom representations)
150      * may still be burnt. Until all users have explicitly called migrate, both
151      * representations will continue to exist.
152      * The custom representation MUST be trusted, and MUST allow the router to
153      * both mint AND burn tokens at will.
154      * @param _domain the domain of the canonical Token to enroll
155      * @param _id the bytes32 ID pf tje canonical of the Token to enroll
156      * @param _custom the address of the custom implementation to use.
157      */
158     function enrollCustom(
159         uint32 _domain,
160         bytes32 _id,
161         address _custom
162     ) external override onlyOwner {
163         // update mappings with custom token
164         _setRepresentationToCanonical(_domain, _id, _custom);
165         _setCanonicalToRepresentation(_domain, _id, _custom);
166     }
167 
168     // ======== Match Old Representation Tokens =========
169 
170     /**
171      * @notice Returns the current representation contract
172      * for the same canonical token as the old representation contract
173      * @dev If _oldRepr is not a representation, this will error.
174      * @param _oldRepr The address of the old representation token
175      * @return _currentRepr The address of the current representation token
176      */
177     function oldReprToCurrentRepr(address _oldRepr)
178         external
179         view
180         override
181         returns (address _currentRepr)
182     {
183         // get the canonical token ID for the old representation contract
184         BridgeMessage.TokenId memory _tokenId = representationToCanonical[
185             _oldRepr
186         ];
187         require(_tokenId.domain != 0, "!repr");
188         // get the current primary representation for the same canonical token ID
189         _currentRepr = getRepresentationAddress(_tokenId.domain, _tokenId.id);
190     }
191 
192     // ======== TokenId & Address Lookup for ALL Local Tokens (Representation AND Canonical) =========
193 
194     /**
195      * @notice Return tokenId for a local token address
196      * @param _local the local address of the token contract (representation or canonical)
197      * @return _domain canonical domain
198      * @return _id canonical identifier on that domain
199      */
200     function getTokenId(address _local)
201         external
202         view
203         override
204         returns (uint32 _domain, bytes32 _id)
205     {
206         BridgeMessage.TokenId memory _tokenId = representationToCanonical[
207             _local
208         ];
209         if (_tokenId.domain == 0) {
210             _domain = _localDomain();
211             _id = TypeCasts.addressToBytes32(_local);
212         } else {
213             _domain = _tokenId.domain;
214             _id = _tokenId.id;
215         }
216     }
217 
218     /**
219      * @notice Looks up the local address corresponding to a domain/id pair.
220      * @dev If the token is local, it will return the local address.
221      * If the token is non-local and no local representation exists, this
222      * will return `address(0)`.
223      * @param _domain the domain of the canonical version.
224      * @param _id the identifier of the canonical version in its domain.
225      * @return _local the local address of the token contract (representation or canonical)
226      */
227     function getLocalAddress(uint32 _domain, address _id)
228         external
229         view
230         returns (address _local)
231     {
232         _local = getLocalAddress(_domain, TypeCasts.addressToBytes32(_id));
233     }
234 
235     /**
236      * @notice Looks up the local address corresponding to a domain/id pair.
237      * @dev If the token is local, it will return the local address.
238      * If the token is non-local and no local representation exists, this
239      * will return `address(0)`.
240      * @param _domain the domain of the canonical version.
241      * @param _id the identifier of the canonical version in its domain.
242      * @return _local the local address of the token contract (representation or canonical)
243      */
244     function getLocalAddress(uint32 _domain, bytes32 _id)
245         public
246         view
247         override
248         returns (address _local)
249     {
250         if (_domain == _localDomain()) {
251             // Token is of local origin
252             _local = TypeCasts.bytes32ToAddress(_id);
253         } else {
254             // Token is a representation of a token of remote origin
255             _local = getRepresentationAddress(_domain, _id);
256         }
257     }
258 
259     /**
260      * @notice Return the local token contract for the
261      * canonical tokenId; revert if there is no local token
262      * @param _domain the token's native domain
263      * @param _id the token's id on its native domain
264      * @return the local IERC20 token contract
265      */
266     function mustHaveLocalToken(uint32 _domain, bytes32 _id)
267         external
268         view
269         override
270         returns (IERC20)
271     {
272         address _local = getLocalAddress(_domain, _id);
273         require(_local != address(0), "!token");
274         return IERC20(_local);
275     }
276 
277     /**
278      * @notice Determine if token is of local origin
279      * @return TRUE if token is locally originating
280      */
281     function isLocalOrigin(address _token) public view override returns (bool) {
282         // If the contract WAS deployed by the TokenRegistry,
283         // it will be stored in this mapping.
284         // If so, it IS NOT of local origin
285         if (representationToCanonical[_token].domain != 0) {
286             return false;
287         }
288         // If the contract WAS NOT deployed by the TokenRegistry,
289         // and the contract exists, then it IS of local origin
290         // Return true if code exists at _addr
291         uint256 _codeSize;
292         // solhint-disable-next-line no-inline-assembly
293         assembly {
294             _codeSize := extcodesize(_token)
295         }
296         return _codeSize != 0;
297     }
298 
299     // ======== Internal Functions =========
300 
301     /**
302      * @notice Set the primary representation for a given canonical
303      * @param _domain the domain of the canonical token
304      * @param _id the bytes32 ID pf the canonical of the token
305      * @param _representation the address of the representation token
306      */
307     function _setRepresentationToCanonical(
308         uint32 _domain,
309         bytes32 _id,
310         address _representation
311     ) internal {
312         representationToCanonical[_representation].domain = _domain;
313         representationToCanonical[_representation].id = _id;
314     }
315 
316     /**
317      * @notice Set the canonical token for a given representation
318      * @param _domain the domain of the canonical token
319      * @param _id the bytes32 ID pf the canonical of the token
320      * @param _representation the address of the representation token
321      */
322     function _setCanonicalToRepresentation(
323         uint32 _domain,
324         bytes32 _id,
325         address _representation
326     ) internal {
327         bytes29 _tokenId = BridgeMessage.formatTokenId(_domain, _id);
328         bytes32 _idHash = _tokenId.keccak();
329         canonicalToRepresentation[_idHash] = _representation;
330     }
331 
332     /**
333      * @notice Deploy and initialize a new token contract
334      * @dev Each token contract is a proxy which
335      * points to the token upgrade beacon
336      * @return _token the address of the token contract
337      */
338     function _deployToken(uint32 _domain, bytes32 _id)
339         internal
340         returns (address _token)
341     {
342         // deploy and initialize the token contract
343         _token = address(new UpgradeBeaconProxy(tokenBeacon, ""));
344         // initialize the token separately from the
345         IBridgeToken(_token).initialize();
346         // set the default token name & symbol
347         (string memory _name, string memory _symbol) = _defaultDetails(
348             _domain,
349             _id
350         );
351         IBridgeToken(_token).setDetails(_name, _symbol, 18);
352         // transfer ownership to bridgeRouter
353         IBridgeToken(_token).transferOwnership(owner());
354         // store token in mappings
355         _setCanonicalToRepresentation(_domain, _id, _token);
356         _setRepresentationToCanonical(_domain, _id, _token);
357         // emit event upon deploying new token
358         emit TokenDeployed(_domain, _id, _token);
359     }
360 
361     /**
362      * @notice Get default name and details for a token
363      * Sets name to "nomad.[domain].[id]"
364      * and symbol to
365      * @param _domain the domain of the canonical token
366      * @param _id the bytes32 ID pf the canonical of the token
367      */
368     function _defaultDetails(uint32 _domain, bytes32 _id)
369         internal
370         pure
371         returns (string memory _name, string memory _symbol)
372     {
373         // get the first and second half of the token ID
374         (, uint256 _secondHalfId) = Encoding.encodeHex(uint256(_id));
375         // encode the default token name: "[decimal domain].[hex 4 bytes of ID]"
376         _name = string(
377             abi.encodePacked(
378                 Encoding.decimalUint32(_domain), // 10
379                 ".", // 1
380                 uint32(_secondHalfId) // 4
381             )
382         );
383         // allocate the memory for a new 32-byte string
384         _symbol = new string(10 + 1 + 4);
385         assembly {
386             mstore(add(_symbol, 0x20), mload(add(_name, 0x20)))
387         }
388     }
389 
390     /**
391      * @dev explicit override for compiler inheritance
392      * @dev explicit override for compiler inheritance
393      * @return domain of chain on which the contract is deployed
394      */
395     function _localDomain()
396         internal
397         view
398         override(XAppConnectionClient)
399         returns (uint32)
400     {
401         return XAppConnectionClient._localDomain();
402     }
403 }
