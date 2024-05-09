1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-23
3 */
4 
5 pragma solidity 0.5.11;
6 
7 /**
8  * @title Proxy
9  * @dev Implements delegation of calls to other contracts, with proper
10  * forwarding of return values and bubbling of failures.
11  * It defines a fallback function that delegates all calls to the address
12  * returned by the abstract _implementation() internal function.
13  */
14 contract Proxy {
15   /**
16    * @dev Fallback function.
17    * Implemented entirely in `_fallback`.
18    */
19   function () payable external {
20     _fallback();
21   }
22 
23   /**
24    * @return The Address of the implementation.
25    */
26   function _implementation() internal view returns (address);
27 
28   /**
29    * @dev Delegates execution to an implementation contract.
30    * This is a low level function that doesn't return to its internal call site.
31    * It will return to the external caller whatever the implementation returns.
32    * @param implementation Address to delegate.
33    */
34   function _delegate(address implementation) internal {
35     assembly {
36       // Copy msg.data. We take full control of memory in this inline assembly
37       // block because it will not return to Solidity code. We overwrite the
38       // Solidity scratch pad at memory position 0.
39       calldatacopy(0, 0, calldatasize)
40 
41       // Call the implementation.
42       // out and outsize are 0 because we don't know the size yet.
43       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
44 
45       // Copy the returned data.
46       returndatacopy(0, 0, returndatasize)
47 
48       switch result
49       // delegatecall returns 0 on error.
50       case 0 { revert(0, returndatasize) }
51       default { return(0, returndatasize) }
52     }
53   }
54 
55   /**
56    * @dev Function that is run as the first thing in the fallback function.
57    * Can be redefined in derived contracts to add functionality.
58    * Redefinitions must call super._willFallback().
59    */
60   function _willFallback() internal {
61   }
62 
63   /**
64    * @dev fallback implementation.
65    * Extracted to enable manual triggering.
66    */
67   function _fallback() internal {
68     _willFallback();
69     _delegate(_implementation());
70   }
71 }
72 
73 
74 /**
75  * Utility library of inline functions on addresses
76  *
77  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
78  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
79  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
80  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
81  */
82 library OpenZeppelinUpgradesAddress {
83     /**
84      * Returns whether the target address is a contract
85      * @dev This function will return false if invoked during the constructor of a contract,
86      * as the code is not actually created until after the constructor finishes.
87      * @param account address of the account to check
88      * @return whether the target address is a contract
89      */
90     function isContract(address account) internal view returns (bool) {
91         uint256 size;
92         // XXX Currently there is no better way to check if there is a contract in an address
93         // than to check the size of the code at that address.
94         // See https://ethereum.stackexchange.com/a/14016/36603
95         // for more details about how this works.
96         // TODO Check this again before the Serenity release, because all addresses will be
97         // contracts then.
98         // solhint-disable-next-line no-inline-assembly
99         assembly { size := extcodesize(account) }
100         return size > 0;
101     }
102 }
103 
104 /**
105  * @title BaseUpgradeabilityProxy
106  * @dev This contract implements a proxy that allows to change the
107  * implementation address to which it will delegate.
108  * Such a change is called an implementation upgrade.
109  */
110 contract BaseUpgradeabilityProxy is Proxy {
111   /**
112    * @dev Emitted when the implementation is upgraded.
113    * @param implementation Address of the new implementation.
114    */
115   event Upgraded(address indexed implementation);
116 
117   /**
118    * @dev Storage slot with the address of the current implementation.
119    * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
120    * validated in the constructor.
121    */
122   bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
123 
124   /**
125    * @dev Returns the current implementation.
126    * @return Address of the current implementation
127    */
128   function _implementation() internal view returns (address impl) {
129     bytes32 slot = IMPLEMENTATION_SLOT;
130     assembly {
131       impl := sload(slot)
132     }
133   }
134 
135   /**
136    * @dev Upgrades the proxy to a new implementation.
137    * @param newImplementation Address of the new implementation.
138    */
139   function _upgradeTo(address newImplementation) internal {
140     _setImplementation(newImplementation);
141     emit Upgraded(newImplementation);
142   }
143 
144   /**
145    * @dev Sets the implementation address of the proxy.
146    * @param newImplementation Address of the new implementation.
147    */
148   function _setImplementation(address newImplementation) internal {
149     require(OpenZeppelinUpgradesAddress.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
150 
151     bytes32 slot = IMPLEMENTATION_SLOT;
152 
153     assembly {
154       sstore(slot, newImplementation)
155     }
156   }
157 }
158 
159 
160 /**
161  * @title OUSD Governable Contract
162  * @dev Copy of the openzeppelin Ownable.sol contract with nomenclature change
163  *      from owner to governor and renounce methods removed. Does not use
164  *      Context.sol like Ownable.sol does for simplification.
165  * @author Origin Protocol Inc
166  */
167 contract Governable {
168     // Storage position of the owner and pendingOwner of the contract
169     bytes32
170         private constant governorPosition = 0x7bea13895fa79d2831e0a9e28edede30099005a50d652d8957cf8a607ee6ca4a;
171     //keccak256("OUSD.governor");
172 
173     bytes32
174         private constant pendingGovernorPosition = 0x44c4d30b2eaad5130ad70c3ba6972730566f3e6359ab83e800d905c61b1c51db;
175     //keccak256("OUSD.pending.governor");
176 
177     event PendingGovernorshipTransfer(
178         address indexed previousGovernor,
179         address indexed newGovernor
180     );
181 
182     event GovernorshipTransferred(
183         address indexed previousGovernor,
184         address indexed newGovernor
185     );
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial Governor.
189      */
190     constructor() internal {
191         _setGovernor(msg.sender);
192         emit GovernorshipTransferred(address(0), _governor());
193     }
194 
195     /**
196      * @dev Returns the address of the current Governor.
197      */
198     function governor() public view returns (address) {
199         return _governor();
200     }
201 
202     function _governor() internal view returns (address governorOut) {
203         bytes32 position = governorPosition;
204         assembly {
205             governorOut := sload(position)
206         }
207     }
208 
209     function _pendingGovernor()
210         internal
211         view
212         returns (address pendingGovernor)
213     {
214         bytes32 position = pendingGovernorPosition;
215         assembly {
216             pendingGovernor := sload(position)
217         }
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the Governor.
222      */
223     modifier onlyGovernor() {
224         require(isGovernor(), "Caller is not the Governor");
225         _;
226     }
227 
228     /**
229      * @dev Returns true if the caller is the current Governor.
230      */
231     function isGovernor() public view returns (bool) {
232         return msg.sender == _governor();
233     }
234 
235     function _setGovernor(address newGovernor) internal {
236         bytes32 position = governorPosition;
237         assembly {
238             sstore(position, newGovernor)
239         }
240     }
241 
242     function _setPendingGovernor(address newGovernor) internal {
243         bytes32 position = pendingGovernorPosition;
244         assembly {
245             sstore(position, newGovernor)
246         }
247     }
248 
249     /**
250      * @dev Transfers Governance of the contract to a new account (`newGovernor`).
251      * Can only be called by the current Governor. Must be claimed for this to complete
252      * @param _newGovernor Address of the new Governor
253      */
254     function transferGovernance(address _newGovernor) external onlyGovernor {
255         _setPendingGovernor(_newGovernor);
256         emit PendingGovernorshipTransfer(_governor(), _newGovernor);
257     }
258 
259     /**
260      * @dev Claim Governance of the contract to a new account (`newGovernor`).
261      * Can only be called by the new Governor.
262      */
263     function claimGovernance() external {
264         require(
265             msg.sender == _pendingGovernor(),
266             "Only the pending Governor can complete the claim"
267         );
268         _changeGovernor(msg.sender);
269     }
270 
271     /**
272      * @dev Change Governance of the contract to a new account (`newGovernor`).
273      * @param _newGovernor Address of the new Governor
274      */
275     function _changeGovernor(address _newGovernor) internal {
276         require(_newGovernor != address(0), "New Governor is address(0)");
277         emit GovernorshipTransferred(_governor(), _newGovernor);
278         _setGovernor(_newGovernor);
279     }
280 }
281 
282 /**
283  * @title BaseGovernedUpgradeabilityProxy
284  * @dev This contract combines an upgradeability proxy with our governor system
285  * @author Origin Protocol Inc
286  */
287 contract InitializeGovernedUpgradeabilityProxy is
288     Governable,
289     BaseUpgradeabilityProxy
290 {
291     /**
292      * @dev Contract initializer with Governor enforcement
293      * @param _logic Address of the initial implementation.
294      * @param _initGovernor Address of the initial Governor.
295      * @param _data Data to send as msg.data to the implementation to initialize the proxied contract.
296      * It should include the signature and the parameters of the function to be called, as described in
297      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
298      * This parameter is optional, if no data is given the initialization call to proxied contract will be skipped.
299      */
300     function initialize(
301         address _logic,
302         address _initGovernor,
303         bytes memory _data
304     ) public payable onlyGovernor {
305         require(_implementation() == address(0));
306         assert(
307             IMPLEMENTATION_SLOT ==
308                 bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1)
309         );
310         _setImplementation(_logic);
311         if (_data.length > 0) {
312             (bool success, ) = _logic.delegatecall(_data);
313             require(success);
314         }
315         _changeGovernor(_initGovernor);
316     }
317 
318     /**
319      * @return The address of the proxy admin/it's also the governor.
320      */
321     function admin() external view returns (address) {
322         return _governor();
323     }
324 
325     /**
326      * @return The address of the implementation.
327      */
328     function implementation() external view returns (address) {
329         return _implementation();
330     }
331 
332     /**
333      * @dev Upgrade the backing implementation of the proxy.
334      * Only the admin can call this function.
335      * @param newImplementation Address of the new implementation.
336      */
337     function upgradeTo(address newImplementation) external onlyGovernor {
338         _upgradeTo(newImplementation);
339     }
340 
341     /**
342      * @dev Upgrade the backing implementation of the proxy and call a function
343      * on the new implementation.
344      * This is useful to initialize the proxied contract.
345      * @param newImplementation Address of the new implementation.
346      * @param data Data to send as msg.data in the low level call.
347      * It should include the signature and the parameters of the function to be called, as described in
348      * https://solidity.readthedocs.io/en/v0.4.24/abi-spec.html#function-selector-and-argument-encoding.
349      */
350     function upgradeToAndCall(address newImplementation, bytes calldata data)
351         external
352         payable
353         onlyGovernor
354     {
355         _upgradeTo(newImplementation);
356         (bool success, ) = newImplementation.delegatecall(data);
357         require(success);
358     }
359 }
360 
361 /**
362  * @notice OUSDProxy delegates calls to a OUSD implementation
363  */
364 contract OUSDProxy is InitializeGovernedUpgradeabilityProxy {
365 
366 }