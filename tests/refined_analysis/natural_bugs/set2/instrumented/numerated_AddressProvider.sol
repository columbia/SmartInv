1 // SPDX-License-Identifier: GPL-3.0-or-later
2 pragma solidity 0.8.9;
3 
4 import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
5 
6 import "../interfaces/IGasBank.sol";
7 import "../interfaces/IAddressProvider.sol";
8 import "../interfaces/IStakerVault.sol";
9 import "../interfaces/oracles/IOracleProvider.sol";
10 
11 import "../libraries/EnumerableExtensions.sol";
12 import "../libraries/EnumerableMapping.sol";
13 import "../libraries/AddressProviderKeys.sol";
14 import "../libraries/AddressProviderMeta.sol";
15 import "../libraries/Roles.sol";
16 
17 import "./access/AuthorizationBase.sol";
18 import "./utils/Preparable.sol";
19 
20 // solhint-disable ordering
21 
22 contract AddressProvider is IAddressProvider, AuthorizationBase, Initializable, Preparable {
23     using EnumerableMapping for EnumerableMapping.AddressToAddressMap;
24     using EnumerableMapping for EnumerableMapping.Bytes32ToUIntMap;
25     using EnumerableSet for EnumerableSet.AddressSet;
26     using EnumerableSet for EnumerableSet.Bytes32Set;
27     using EnumerableExtensions for EnumerableSet.AddressSet;
28     using EnumerableExtensions for EnumerableSet.Bytes32Set;
29     using EnumerableExtensions for EnumerableMapping.AddressToAddressMap;
30     using EnumerableExtensions for EnumerableMapping.Bytes32ToUIntMap;
31     using AddressProviderMeta for AddressProviderMeta.Meta;
32 
33     // LpToken -> stakerVault
34     EnumerableMapping.AddressToAddressMap internal _stakerVaults;
35 
36     EnumerableSet.AddressSet internal _whiteListedFeeHandlers;
37 
38     // value is encoded as (bool freezable, bool frozen)
39     EnumerableMapping.Bytes32ToUIntMap internal _addressKeyMetas;
40 
41     EnumerableSet.AddressSet internal _actions; // list of all actions ever registered
42 
43     EnumerableSet.AddressSet internal _vaults; // list of all active vaults
44 
45     EnumerableMapping.AddressToAddressMap internal _tokenToPools;
46 
47     constructor(address treasury) {
48         AddressProviderMeta.Meta memory meta = AddressProviderMeta.Meta(true, false);
49         _addressKeyMetas.set(AddressProviderKeys._TREASURY_KEY, meta.toUInt());
50         _setConfig(AddressProviderKeys._TREASURY_KEY, treasury);
51     }
52 
53     function initialize(address roleManager) external initializer {
54         AddressProviderMeta.Meta memory meta = AddressProviderMeta.Meta(true, true);
55         _addressKeyMetas.set(AddressProviderKeys._ROLE_MANAGER_KEY, meta.toUInt());
56         _setConfig(AddressProviderKeys._ROLE_MANAGER_KEY, roleManager);
57     }
58 
59     function getKnownAddressKeys() external view returns (bytes32[] memory) {
60         return _addressKeyMetas.keysArray();
61     }
62 
63     function addFeeHandler(address feeHandler) external onlyGovernance returns (bool) {
64         require(!_whiteListedFeeHandlers.contains(feeHandler), Error.ADDRESS_WHITELISTED);
65         _whiteListedFeeHandlers.add(feeHandler);
66         return true;
67     }
68 
69     function removeFeeHandler(address feeHandler) external onlyGovernance returns (bool) {
70         require(_whiteListedFeeHandlers.contains(feeHandler), Error.ADDRESS_NOT_WHITELISTED);
71         _whiteListedFeeHandlers.remove(feeHandler);
72         return true;
73     }
74 
75     /**
76      * @notice Adds action.
77      * @param action Address of action to add.
78      */
79     function addAction(address action) external onlyGovernance returns (bool) {
80         bool result = _actions.add(action);
81         if (result) {
82             emit ActionListed(action);
83         }
84         return result;
85     }
86 
87     /**
88      * @notice Adds pool.
89      * @param pool Address of pool to add.
90      */
91     function addPool(address pool)
92         external
93         override
94         onlyRoles2(Roles.POOL_FACTORY, Roles.GOVERNANCE)
95     {
96         require(pool != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
97 
98         ILiquidityPool ipool = ILiquidityPool(pool);
99         address poolToken = ipool.getLpToken();
100         require(poolToken != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
101         if (_tokenToPools.set(poolToken, pool)) {
102             address vault = address(ipool.getVault());
103             if (vault != address(0)) {
104                 _vaults.add(vault);
105             }
106             emit PoolListed(pool);
107         }
108     }
109 
110     /**
111      * @notice Delists pool.
112      * @param pool Address of pool to delist.
113      * @return `true` if successful.
114      */
115     function removePool(address pool) external override onlyRole(Roles.CONTROLLER) returns (bool) {
116         address lpToken = ILiquidityPool(pool).getLpToken();
117         bool removed = _tokenToPools.remove(lpToken);
118         if (removed) {
119             address vault = address(ILiquidityPool(pool).getVault());
120             if (vault != address(0)) {
121                 _vaults.remove(vault);
122             }
123             emit PoolDelisted(pool);
124         }
125 
126         return removed;
127     }
128 
129     /** Vault functions  */
130 
131     /**
132      * @notice returns all the registered vaults
133      */
134     function allVaults() external view returns (address[] memory) {
135         return _vaults.toArray();
136     }
137 
138     /**
139      * @notice returns the vault at the given index
140      */
141     function getVaultAtIndex(uint256 index) external view returns (address) {
142         return _vaults.at(index);
143     }
144 
145     /**
146      * @notice returns the number of vaults
147      */
148     function vaultsCount() external view returns (uint256) {
149         return _vaults.length();
150     }
151 
152     function isVault(address vault) external view returns (bool) {
153         return _vaults.contains(vault);
154     }
155 
156     function updateVault(address previousVault, address newVault) external onlyRole(Roles.POOL) {
157         if (previousVault != address(0)) {
158             _vaults.remove(previousVault);
159         }
160         if (newVault != address(0)) {
161             _vaults.add(newVault);
162         }
163         emit VaultUpdated(previousVault, newVault);
164     }
165 
166     /**
167      * @notice Returns the address for the given key
168      */
169     function getAddress(bytes32 key) public view returns (address) {
170         require(_addressKeyMetas.contains(key), Error.ADDRESS_DOES_NOT_EXIST);
171         return currentAddresses[key];
172     }
173 
174     /**
175      * @notice Returns the address for the given key
176      * @dev if `checkExists` is true, it will fail if the key does not exist
177      */
178     function getAddress(bytes32 key, bool checkExists) public view returns (address) {
179         require(!checkExists || _addressKeyMetas.contains(key), Error.ADDRESS_DOES_NOT_EXIST);
180         return currentAddresses[key];
181     }
182 
183     /**
184      * @notice returns the address metadata for the given key
185      */
186     function getAddressMeta(bytes32 key) public view returns (AddressProviderMeta.Meta memory) {
187         (bool exists, uint256 metadata) = _addressKeyMetas.tryGet(key);
188         require(exists, Error.ADDRESS_DOES_NOT_EXIST);
189         return AddressProviderMeta.fromUInt(metadata);
190     }
191 
192     function initializeAddress(bytes32 key, address initialAddress) external {
193         initializeAddress(key, initialAddress, false);
194     }
195 
196     /**
197      * @notice Initializes an address
198      * @param key Key to initialize
199      * @param initialAddress Address for `key`
200      */
201     function initializeAddress(
202         bytes32 key,
203         address initialAddress,
204         bool freezable
205     ) public override onlyGovernance {
206         AddressProviderMeta.Meta memory meta = AddressProviderMeta.Meta(freezable, false);
207         _initializeAddress(key, initialAddress, meta);
208     }
209 
210     /**
211      * @notice Initializes and freezes address
212      * @param key Key to initialize
213      * @param initialAddress Address for `key`
214      */
215     function initializeAndFreezeAddress(bytes32 key, address initialAddress)
216         external
217         override
218         onlyGovernance
219     {
220         AddressProviderMeta.Meta memory meta = AddressProviderMeta.Meta(true, true);
221         _initializeAddress(key, initialAddress, meta);
222     }
223 
224     /**
225      * @notice Freezes a configuration key, making it immutable
226      * @param key Key to feeze
227      */
228     function freezeAddress(bytes32 key) external override onlyGovernance {
229         AddressProviderMeta.Meta memory meta = getAddressMeta(key);
230         require(!meta.frozen, Error.ADDRESS_FROZEN);
231         require(meta.freezable, Error.INVALID_ARGUMENT);
232         meta.frozen = true;
233         _addressKeyMetas.set(key, meta.toUInt());
234     }
235 
236     /**
237      * @notice Prepare update of an address
238      * @param key Key to update
239      * @param newAddress New address for `key`
240      * @return `true` if successful.
241      */
242     function prepareAddress(bytes32 key, address newAddress)
243         external
244         override
245         onlyGovernance
246         returns (bool)
247     {
248         AddressProviderMeta.Meta memory meta = getAddressMeta(key);
249         require(!meta.frozen, Error.ADDRESS_FROZEN);
250         return _prepare(key, newAddress);
251     }
252 
253     /**
254      * @notice Execute update of `key`
255      * @return New address.
256      */
257     function executeAddress(bytes32 key) external override returns (address) {
258         AddressProviderMeta.Meta memory meta = getAddressMeta(key);
259         require(!meta.frozen, Error.ADDRESS_FROZEN);
260         return _executeAddress(key);
261     }
262 
263     /**
264      * @notice Reset `key`
265      * @return true if it was reset
266      */
267     function resetAddress(bytes32 key) external onlyGovernance returns (bool) {
268         return _resetAddressConfig(key);
269     }
270 
271     /**
272      * @notice Add a new staker vault and add it's lpGauge if set in vault.
273      * @dev This fails if the token of the staker vault is the token of an existing staker vault.
274      * @param stakerVault Vault to add.
275      * @return `true` if successful.
276      */
277     function addStakerVault(address stakerVault)
278         external
279         override
280         onlyRole(Roles.CONTROLLER)
281         returns (bool)
282     {
283         address token = IStakerVault(stakerVault).getToken();
284         require(token != address(0), Error.ZERO_ADDRESS_NOT_ALLOWED);
285         require(!_stakerVaults.contains(token), Error.STAKER_VAULT_EXISTS);
286         _stakerVaults.set(token, stakerVault);
287         emit StakerVaultListed(stakerVault);
288         return true;
289     }
290 
291     function isWhiteListedFeeHandler(address feeHandler) external view override returns (bool) {
292         return _whiteListedFeeHandlers.contains(feeHandler);
293     }
294 
295     /**
296      * @notice Get the liquidity pool for a given token
297      * @dev Does not revert if the pool deos not exist
298      * @param token Token for which to get the pool.
299      * @return Pool address.
300      */
301     function safeGetPoolForToken(address token) external view override returns (address) {
302         (, address poolAddress) = _tokenToPools.tryGet(token);
303         return poolAddress;
304     }
305 
306     /**
307      * @notice Get the liquidity pool for a given token
308      * @dev Reverts if the pool deos not exist
309      * @param token Token for which to get the pool.
310      * @return Pool address.
311      */
312     function getPoolForToken(address token) external view override returns (ILiquidityPool) {
313         (bool exists, address poolAddress) = _tokenToPools.tryGet(token);
314         require(exists, Error.ADDRESS_NOT_FOUND);
315         return ILiquidityPool(poolAddress);
316     }
317 
318     /**
319      * @notice Get list of all action addresses.
320      * @return Array with action addresses.
321      */
322     function allActions() external view override returns (address[] memory) {
323         return _actions.toArray();
324     }
325 
326     /**
327      * @notice Check whether an address is an action.
328      * @param action Address to check whether it is action.
329      * @return True if address is an action.
330      */
331     function isAction(address action) external view override returns (bool) {
332         return _actions.contains(action);
333     }
334 
335     /**
336      * @notice Check whether an address is an pool.
337      * @param pool Address to check whether it is a pool.
338      * @return True if address is a pool.
339      */
340     function isPool(address pool) external view returns (bool) {
341         address lpToken = ILiquidityPool(pool).getLpToken();
342         (bool exists, address poolAddress) = _tokenToPools.tryGet(lpToken);
343         return exists && pool == poolAddress;
344     }
345 
346     /**
347      * @notice Get list of all pool addresses.
348      * @return Array with pool addresses.
349      */
350     function allPools() external view override returns (address[] memory) {
351         return _tokenToPools.valuesArray();
352     }
353 
354     /**
355      * @notice returns the pool at the given index
356      */
357     function getPoolAtIndex(uint256 index) external view returns (address) {
358         return _tokenToPools.valueAt(index);
359     }
360 
361     /**
362      * @notice returns the number of pools
363      */
364     function poolsCount() external view returns (uint256) {
365         return _tokenToPools.length();
366     }
367 
368     /**
369      * @notice Returns all the staker vaults.
370      */
371     function allStakerVaults() external view override returns (address[] memory) {
372         return _stakerVaults.valuesArray();
373     }
374 
375     /**
376      * @notice Get the staker vault for a given token
377      * @dev There can only exist one staker vault per unique token.
378      * @param token Token for which to get the vault.
379      * @return Vault address.
380      */
381     function getStakerVault(address token) external view override returns (address) {
382         return _stakerVaults.get(token);
383     }
384 
385     /**
386      * @notice Tries to get the staker vault for a given token but does not throw if it does not exist
387      * @return A boolean set to true if the vault exists and the vault address.
388      */
389     function tryGetStakerVault(address token) external view override returns (bool, address) {
390         return _stakerVaults.tryGet(token);
391     }
392 
393     /**
394      * @notice Check if a vault is registered (exists).
395      * @param stakerVault Address of staker vault to check.
396      * @return `true` if registered, `false` if not.
397      */
398     function isStakerVaultRegistered(address stakerVault) external view override returns (bool) {
399         address token = IStakerVault(stakerVault).getToken();
400         return isStakerVault(stakerVault, token);
401     }
402 
403     function isStakerVault(address stakerVault, address token) public view override returns (bool) {
404         (bool exists, address vault) = _stakerVaults.tryGet(token);
405         return exists && vault == stakerVault;
406     }
407 
408     function _roleManager() internal view override returns (IRoleManager) {
409         return IRoleManager(getAddress(AddressProviderKeys._ROLE_MANAGER_KEY));
410     }
411 
412     function _initializeAddress(
413         bytes32 key,
414         address initialAddress,
415         AddressProviderMeta.Meta memory meta
416     ) internal {
417         require(!_addressKeyMetas.contains(key), Error.INVALID_ARGUMENT);
418         _addKnownAddressKey(key, meta);
419         _setConfig(key, initialAddress);
420     }
421 
422     function _addKnownAddressKey(bytes32 key, AddressProviderMeta.Meta memory meta) internal {
423         require(_addressKeyMetas.set(key, meta.toUInt()), Error.INVALID_ARGUMENT);
424         emit KnownAddressKeyAdded(key);
425     }
426 }
