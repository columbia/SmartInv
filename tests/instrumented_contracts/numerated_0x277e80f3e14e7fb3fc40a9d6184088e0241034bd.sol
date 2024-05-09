1 pragma solidity 0.5.11;
2 
3 /**
4  * @title Proxy
5  * @dev Implements delegation of calls to other contracts, with proper
6  * forwarding of return values and bubbling of failures.
7  * It defines a fallback function that delegates all calls to the address
8  * returned by the abstract _implementation() internal function.
9  */
10 contract Proxy {
11   /**
12    * @dev Fallback function.
13    * Implemented entirely in `_fallback`.
14    */
15   function () payable external {
16     _fallback();
17   }
18 
19   /**
20    * @return The Address of the implementation.
21    */
22   function _implementation() internal view returns (address);
23 
24   /**
25    * @dev Delegates execution to an implementation contract.
26    * This is a low level function that doesn't return to its internal call site.
27    * It will return to the external caller whatever the implementation returns.
28    * @param implementation Address to delegate.
29    */
30   function _delegate(address implementation) internal {
31     assembly {
32       // Copy msg.data. We take full control of memory in this inline assembly
33       // block because it will not return to Solidity code. We overwrite the
34       // Solidity scratch pad at memory position 0.
35       calldatacopy(0, 0, calldatasize)
36 
37       // Call the implementation.
38       // out and outsize are 0 because we don't know the size yet.
39       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
40 
41       // Copy the returned data.
42       returndatacopy(0, 0, returndatasize)
43 
44       switch result
45       // delegatecall returns 0 on error.
46       case 0 { revert(0, returndatasize) }
47       default { return(0, returndatasize) }
48     }
49   }
50 
51   /**
52    * @dev Function that is run as the first thing in the fallback function.
53    * Can be redefined in derived contracts to add functionality.
54    * Redefinitions must call super._willFallback().
55    */
56   function _willFallback() internal {
57   }
58 
59   /**
60    * @dev fallback implementation.
61    * Extracted to enable manual triggering.
62    */
63   function _fallback() internal {
64     _willFallback();
65     _delegate(_implementation());
66   }
67 }
68 
69 
70 /**
71  * Utility library of inline functions on addresses
72  *
73  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
74  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
75  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
76  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
77  */
78 library OpenZeppelinUpgradesAddress {
79     /**
80      * Returns whether the target address is a contract
81      * @dev This function will return false if invoked during the constructor of a contract,
82      * as the code is not actually created until after the constructor finishes.
83      * @param account address of the account to check
84      * @return whether the target address is a contract
85      */
86     function isContract(address account) internal view returns (bool) {
87         uint256 size;
88         // XXX Currently there is no better way to check if there is a contract in an address
89         // than to check the size of the code at that address.
90         // See https://ethereum.stackexchange.com/a/14016/36603
91         // for more details about how this works.
92         // TODO Check this again before the Serenity release, because all addresses will be
93         // contracts then.
94         // solhint-disable-next-line no-inline-assembly
95         assembly { size := extcodesize(account) }
96         return size > 0;
97     }
98 }
99 
100 /**
101  * @title BaseUpgradeabilityProxy
102  * @dev This contract implements a proxy that allows to change the
103  * implementation address to which it will delegate.
104  * Such a change is called an implementation upgrade.
105  */
106 contract BaseUpgradeabilityProxy is Proxy {
107   /**
108    * @dev Emitted when the implementation is upgraded.
109    * @param implementation Address of the new implementation.
110    */
111   event Upgraded(address indexed implementation);
112 
113   /**
114    * @dev Storage slot with the address of the current implementation.
115    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
116    * validated in the constructor.
117    */
118   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
119 
120   /**
121    * @dev Returns the current implementation.
122    * @return Address of the current implementation
123    */
124   function _implementation() internal view returns (address impl) {
125     bytes32 slot = IMPLEMENTATION_SLOT;
126     assembly {
127       impl := sload(slot)
128     }
129   }
130 
131   /**
132    * @dev Upgrades the proxy to a new implementation.
133    * @param newImplementation Address of the new implementation.
134    */
135   function _upgradeTo(address newImplementation) internal {
136     _setImplementation(newImplementation);
137     emit Upgraded(newImplementation);
138   }
139 
140   /**
141    * @dev Sets the implementation address of the proxy.
142    * @param newImplementation Address of the new implementation.
143    */
144   function _setImplementation(address newImplementation) internal {
145     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
146 
147     bytes32 slot = IMPLEMENTATION_SLOT;
148 
149     assembly {
150       sstore(slot, newImplementation)
151     }
152   }
153 }
154 
155 
156 /**
157  * @title OUSD Governable Contract
158  * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
159  *      from owner to governor and renounce methods removed. Does not use
160  *      Context.sol like Ownable.sol does for simplification.
161  * @author Origin Protocol Inc
162  */
163 contract Governable {
164     // Storage position of the owner and pendingOwner of the contract
165     bytes32
166         private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;
167     //keccak256("OUSD.governor");
168 
169     bytes32
170         private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;
171     //keccak256("OUSD.pending.governor");
172 
173     event PendingGovernorshipTransfer(
174         address indexed previousGovernor,
175         address indexed newGovernor
176     );
177 
178     event GovernorshipTransferred(
179         address indexed previousGovernor,
180         address indexed newGovernor
181     );
182 
183     /**
184      * @dev Initializes the contract setting the deployer as the initial Governor.
185      */
186     constructor() internal {
187         _setGovernor(msg.sender);
188         emit GovernorshipTransferred(address(0), _governor());
189     }
190 
191     /**
192      * @dev Returns the address of the current Governor.
193      */
194     function governor() public view returns (address) {
195         return _governor();
196     }
197 
198     function _governor() internal view returns (address governorOut) {
199         bytes32 position = governorPosition;
200         assembly {
201             governorOut := sload(position)
202         }
203     }
204 
205     function _pendingGovernor()
206         internal
207         view
208         returns (address pendingGovernor)
209     {
210         bytes32 position = pendingGovernorPosition;
211         assembly {
212             pendingGovernor := sload(position)
213         }
214     }
215 
216     /**
217      * @dev Throws if called by any account other than the Governor.
218      */
219     modifier onlyGovernor() {
220         require(isGovernor(), "Caller is not the Governor");
221         _;
222     }
223 
224     /**
225      * @dev Returns true if the caller is the current Governor.
226      */
227     function isGovernor() public view returns (bool) {
228         return msg.sender == _governor();
229     }
230 
231     function _setGovernor(address newGovernor) internal {
232         bytes32 position = governorPosition;
233         assembly {
234             sstore(position, newGovernor)
235         }
236     }
237 
238     function _setPendingGovernor(address newGovernor) internal {
239         bytes32 position = pendingGovernorPosition;
240         assembly {
241             sstore(position, newGovernor)
242         }
243     }
244 
245     /**
246      * @dev Transfers Governance of the contract to a new account (`newGovernor`).
247      * Can only be called by the current Governor. Must be claimed for this to complete
248      * @param _newGovernor Address of the new Governor
249      */
250     function transferGovernance(address _newGovernor) external onlyGovernor {
251         _setPendingGovernor(_newGovernor);
252         emit PendingGovernorshipTransfer(_governor(), _newGovernor);
253     }
254 
255     /**
256      * @dev Claim Governance of the contract to a new account (`newGovernor`).
257      * Can only be called by the new Governor.
258      */
259     function claimGovernance() external {
260         require(
261             msg.sender == _pendingGovernor(),
262             "Only the pending Governor can complete the claim"
263         );
264         _changeGovernor(msg.sender);
265     }
266 
267     /**
268      * @dev Change Governance of the contract to a new account (`newGovernor`).
269      * @param _newGovernor Address of the new Governor
270      */
271     function _changeGovernor(address _newGovernor) internal {
272         require(_newGovernor != address(0), "New Governor is address(0)");
273         emit GovernorshipTransferred(_governor(), _newGovernor);
274         _setGovernor(_newGovernor);
275     }
276 }
277 
278 /**
279  * @title BaseGovernedUpgradeabilityProxy
280  * @dev This contract combines an upgradeability proxy with our governor system
281  * @author Origin Protocol Inc
282  */
283 contract InitializeGovernedUpgradeabilityProxy is
284     Governable,
285     BaseUpgradeabilityProxy
286 {
287     /**
288      * @dev Contract initializer with Governor enforcement
289      * @param _logic Address of the initial implementation.
290      * @param _initGovernor Address of the initial Governor.
291      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
292      * It should include the signature and the parameters of the function to be called, as described in
293      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
294      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
295      */
296     function initialize(
297         address _logic,
298         address _initGovernor,
299         bytes memory _data
300     ) public payable onlyGovernor {
301         require(_implementation() == address(0));
302         assert(
303             IMPLEMENTATION_SLOT ==
304                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
305         );
306         _setImplementation(_logic);
307         if (_data.length > 0) {
308             (bool success, ) = _logic.delegatecall(_data);
309             require(success);
310         }
311         _changeGovernor(_initGovernor);
312     }
313 
314     /**
315      * @return The address of the proxy admin/it's also the governor.
316      */
317     function admin() external view returns (address) {
318         return _governor();
319     }
320 
321     /**
322      * @return The address of the implementation.
323      */
324     function implementation() external view returns (address) {
325         return _implementation();
326     }
327 
328     /**
329      * @dev Upgrade the backing implementation of the proxy.
330      * Only the admin can call this function.
331      * @param newImplementation Address of the new implementation.
332      */
333     function upgradeTo(address newImplementation) external onlyGovernor {
334         _upgradeTo(newImplementation);
335     }
336 
337     /**
338      * @dev Upgrade the backing implementation of the proxy and call a function
339      * on the new implementation.
340      * This is useful to initialize the proxied contract.
341      * @param newImplementation Address of the new implementation.
342      * @param data Data to send as msg.data in the low level call.
343      * It should include the signature and the parameters of the function to be called, as described in
344      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
345      */
346     function upgradeToAndCall(address newImplementation, bytes calldata data)
347         external
348         payable
349         onlyGovernor
350     {
351         _upgradeTo(newImplementation);
352         (bool success, ) = newImplementation.delegatecall(data);
353         require(success);
354     }
355 }
356 
357 /**
358  * @notice VaultProxy delegates calls to a Vault implementation
359  */
360 contract VaultProxy is InitializeGovernedUpgradeabilityProxy {
361 
362 }