1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-05
3 */
4 
5 /*
6     .'''''''''''..     ..''''''''''''''''..       ..'''''''''''''''..
7     .;;;;;;;;;;;'.   .';;;;;;;;;;;;;;;;;;,.     .,;;;;;;;;;;;;;;;;;,.
8     .;;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;,.    .,;;;;;;;;;;;;;;;;;;,.
9     .;;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.   .;;;;;;;;;;;;;;;;;;;;,.
10     ';;;;;;;;'.  .';;;;;;;;;;;;;;;;;;;;;;,. .';;;;;;;;;;;;;;;;;;;;;,.
11     ';;;;;,..   .';;;;;;;;;;;;;;;;;;;;;;;,..';;;;;;;;;;;;;;;;;;;;;;,.
12     ......     .';;;;;;;;;;;;;,'''''''''''.,;;;;;;;;;;;;;,'''''''''..
13               .,;;;;;;;;;;;;;.           .,;;;;;;;;;;;;;.
14              .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.
15             .,;;;;;;;;;;;;,.           .,;;;;;;;;;;;;,.
16            .,;;;;;;;;;;;;,.           .;;;;;;;;;;;;;,.     .....
17           .;;;;;;;;;;;;;'.         ..';;;;;;;;;;;;;'.    .',;;;;,'.
18         .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.   .';;;;;;;;;;.
19        .';;;;;;;;;;;;;'.         .';;;;;;;;;;;;;;'.    .;;;;;;;;;;;,.
20       .,;;;;;;;;;;;;;'...........,;;;;;;;;;;;;;;.      .;;;;;;;;;;;,.
21      .,;;;;;;;;;;;;,..,;;;;;;;;;;;;;;;;;;;;;;;,.       ..;;;;;;;;;,.
22     .,;;;;;;;;;;;;,. .,;;;;;;;;;;;;;;;;;;;;;;,.          .',;;;,,..
23    .,;;;;;;;;;;;;,.  .,;;;;;;;;;;;;;;;;;;;;;,.              ....
24     ..',;;;;;;;;,.   .,;;;;;;;;;;;;;;;;;;;;,.
25        ..',;;;;'.    .,;;;;;;;;;;;;;;;;;;;'.
26           ...'..     .';;;;;;;;;;;;;;,,,'.
27                        ...............
28 */
29 
30 // https://github.com/trusttoken/smart-contracts
31 // SPDX-License-Identifier: MIT
32 
33 pragma solidity ^0.6.0;
34 
35 /*
36  * @dev Provides information about the current execution context, including the
37  * sender of the transaction and its data. While these are generally available
38  * via msg.sender and msg.data, they should not be accessed in such a direct
39  * manner, since when dealing with GSN meta-transactions the account sending and
40  * paying for execution may not be the actual sender (as far as an application
41  * is concerned).
42  *
43  * This contract is only required for intermediate, library-like contracts.
44  */
45 abstract contract Context {
46     function _msgSender() internal view virtual returns (address payable) {
47         return msg.sender;
48     }
49 
50     function _msgData() internal view virtual returns (bytes memory) {
51         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
52         return msg.data;
53     }
54 }
55 
56 /**
57  * @title Initializable
58  *
59  * @dev Helper contract to support initializer functions. To use it, replace
60  * the constructor with a function that has the `initializer` modifier.
61  * WARNING: Unlike constructors, initializer functions must be manually
62  * invoked. This applies both to deploying an Initializable contract, as well
63  * as extending an Initializable contract via inheritance.
64  * WARNING: When used with inheritance, manual care must be taken to not invoke
65  * a parent initializer twice, or ensure that all initializers are idempotent,
66  * because this is not dealt with automatically as with constructors.
67  */
68 contract Initializable {
69     /**
70      * @dev Indicates that the contract has been initialized.
71      */
72     bool private initialized;
73 
74     /**
75      * @dev Indicates that the contract is in the process of being initialized.
76      */
77     bool private initializing;
78 
79     /**
80      * @dev Modifier to use in the initializer function of a contract.
81      */
82     modifier initializer() {
83         require(initializing || isConstructor() || !initialized, "Contract instance has already been initialized");
84 
85         bool isTopLevelCall = !initializing;
86         if (isTopLevelCall) {
87             initializing = true;
88             initialized = true;
89         }
90 
91         _;
92 
93         if (isTopLevelCall) {
94             initializing = false;
95         }
96     }
97 
98     /// @dev Returns true if and only if the function is running in the constructor
99     function isConstructor() private view returns (bool) {
100         // extcodesize checks the size of the code stored in an address, and
101         // address returns the current address. Since the code is still not
102         // deployed when running a constructor, any checks on its code size will
103         // yield zero, making it an effective way to detect if a contract is
104         // under construction or not.
105         address self = address(this);
106         uint256 cs;
107         assembly {
108             cs := extcodesize(self)
109         }
110         return cs == 0;
111     }
112 
113     /**
114      * @dev Return true if and only if the contract has been initialized
115      * @return whether the contract has been initialized
116      */
117     function isInitialized() public view returns (bool) {
118         return initialized;
119     }
120 
121     // Reserved storage space to allow for layout changes in the future.
122     uint256[50] private ______gap;
123 }
124 
125 /**
126  * @title UpgradeableClaimable
127  * @dev Contract module which provides a basic access control mechanism, where
128  * there is an account (an owner) that can be granted exclusive access to
129  * specific functions.
130  *
131  * By default, the owner account will be the one that deploys the contract. Since
132  * this contract combines Claimable and UpgradableOwnable contracts, ownership
133  * can be later change via 2 step method {transferOwnership} and {claimOwnership}
134  *
135  * This module is used through inheritance. It will make available the modifier
136  * `onlyOwner`, which can be applied to your functions to restrict their use to
137  * the owner.
138  */
139 contract UpgradeableClaimable is Initializable, Context {
140     address private _owner;
141     address private _pendingOwner;
142 
143     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
144 
145     /**
146      * @dev Initializes the contract setting a custom initial owner of choice.
147      * @param __owner Initial owner of contract to be set.
148      */
149     function initialize(address __owner) internal initializer {
150         _owner = __owner;
151         emit OwnershipTransferred(address(0), __owner);
152     }
153 
154     /**
155      * @dev Returns the address of the current owner.
156      */
157     function owner() public view returns (address) {
158         return _owner;
159     }
160 
161     /**
162      * @dev Returns the address of the pending owner.
163      */
164     function pendingOwner() public view returns (address) {
165         return _pendingOwner;
166     }
167 
168     /**
169      * @dev Throws if called by any account other than the owner.
170      */
171     modifier onlyOwner() {
172         require(_owner == _msgSender(), "Ownable: caller is not the owner");
173         _;
174     }
175 
176     /**
177      * @dev Modifier throws if called by any account other than the pendingOwner.
178      */
179     modifier onlyPendingOwner() {
180         require(msg.sender == _pendingOwner, "Ownable: caller is not the pending owner");
181         _;
182     }
183 
184     /**
185      * @dev Allows the current owner to set the pendingOwner address.
186      * @param newOwner The address to transfer ownership to.
187      */
188     function transferOwnership(address newOwner) public onlyOwner {
189         _pendingOwner = newOwner;
190     }
191 
192     /**
193      * @dev Allows the pendingOwner address to finalize the transfer.
194      */
195     function claimOwnership() public onlyPendingOwner {
196         emit OwnershipTransferred(_owner, _pendingOwner);
197         _owner = _pendingOwner;
198         _pendingOwner = address(0);
199     }
200 }
201 
202 /**
203  * @title ImplementationReference
204  * @dev This contract is made to serve a simple purpose only.
205  * To hold the address of the implementation contract to be used by proxy.
206  * The implementation address, is changeable anytime by the owner of this contract.
207  */
208 contract ImplementationReference is UpgradeableClaimable {
209     address public implementation;
210 
211     /**
212      * @dev Event to show that implementation address has been changed
213      * @param newImplementation New address of the implementation
214      */
215     event ImplementationChanged(address newImplementation);
216 
217     /**
218      * @dev Set initial ownership and implementation address
219      * @param _implementation Initial address of the implementation
220      */
221     constructor(address _implementation) public {
222         UpgradeableClaimable.initialize(msg.sender);
223         implementation = _implementation;
224     }
225 
226     /**
227      * @dev Function to change the implementation address, which can be called only by the owner
228      * @param newImplementation New address of the implementation
229      */
230     function setImplementation(address newImplementation) external onlyOwner {
231         implementation = newImplementation;
232         emit ImplementationChanged(newImplementation);
233     }
234 }
235 
236 /**
237  * @title OwnedProxyWithReference
238  * @dev This contract combines an upgradeability proxy with basic authorization control functionalities
239  * Its structure makes it easy for a group of contracts alike, to share an implementation and to change it easily for all of them at once
240  */
241 contract OwnedProxyWithReference {
242     /**
243      * @dev Event to show ownership has been transferred
244      * @param previousOwner representing the address of the previous owner
245      * @param newOwner representing the address of the new owner
246      */
247     event ProxyOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
248 
249     /**
250      * @dev Event to show ownership transfer is pending
251      * @param currentOwner representing the address of the current owner
252      * @param pendingOwner representing the address of the pending owner
253      */
254     event NewPendingOwner(address currentOwner, address pendingOwner);
255 
256     /**
257      * @dev Event to show implementation reference has been changed
258      * @param implementationReference address of the new implementation reference contract
259      */
260     event ImplementationReferenceChanged(address implementationReference);
261 
262     // Storage position of the owner and pendingOwner and implementationReference of the contract
263     // This is made to ensure, that memory spaces do not interfere with each other
264     bytes32 private constant proxyOwnerPosition = 0x6279e8199720cf3557ecd8b58d667c8edc486bd1cf3ad59ea9ebdfcae0d0dfac; //keccak256("trueUSD.proxy.owner");
265     bytes32 private constant pendingProxyOwnerPosition = 0x8ddbac328deee8d986ec3a7b933a196f96986cb4ee030d86cc56431c728b83f4; //keccak256("trueUSD.pending.proxy.owner");
266     bytes32 private constant implementationReferencePosition = keccak256("trueFiPool.implementation.reference"); //keccak256("trueFiPool.implementation.reference");
267 
268     /**
269      * @dev the constructor sets the original owner of the contract to the sender account.
270      * @param _owner Initial owner of the proxy
271      * @param _implementationReference initial ImplementationReference address
272      */
273     constructor(address _owner, address _implementationReference) public {
274         _setUpgradeabilityOwner(_owner);
275         _changeImplementationReference(_implementationReference);
276     }
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyProxyOwner() {
282         require(msg.sender == proxyOwner(), "only Proxy Owner");
283         _;
284     }
285 
286     /**
287      * @dev Throws if called by any account other than the pending owner.
288      */
289     modifier onlyPendingProxyOwner() {
290         require(msg.sender == pendingProxyOwner(), "only pending Proxy Owner");
291         _;
292     }
293 
294     /**
295      * @dev Tells the address of the owner
296      * @return owner the address of the owner
297      */
298     function proxyOwner() public view returns (address owner) {
299         bytes32 position = proxyOwnerPosition;
300         assembly {
301             owner := sload(position)
302         }
303     }
304 
305     /**
306      * @dev Tells the address of the owner
307      * @return pendingOwner the address of the pending owner
308      */
309     function pendingProxyOwner() public view returns (address pendingOwner) {
310         bytes32 position = pendingProxyOwnerPosition;
311         assembly {
312             pendingOwner := sload(position)
313         }
314     }
315 
316     /**
317      * @dev Sets the address of the owner
318      * @param newProxyOwner New owner to be set
319      */
320     function _setUpgradeabilityOwner(address newProxyOwner) internal {
321         bytes32 position = proxyOwnerPosition;
322         assembly {
323             sstore(position, newProxyOwner)
324         }
325     }
326 
327     /**
328      * @dev Sets the address of the owner
329      * @param newPendingProxyOwner New pending owner address
330      */
331     function _setPendingUpgradeabilityOwner(address newPendingProxyOwner) internal {
332         bytes32 position = pendingProxyOwnerPosition;
333         assembly {
334             sstore(position, newPendingProxyOwner)
335         }
336     }
337 
338     /**
339      * @dev Allows the current owner to transfer control of the contract to a newOwner.
340      * changes the pending owner to newOwner. But doesn't actually transfer
341      * @param newOwner The address to transfer ownership to.
342      */
343     function transferProxyOwnership(address newOwner) external onlyProxyOwner {
344         require(newOwner != address(0));
345         _setPendingUpgradeabilityOwner(newOwner);
346         emit NewPendingOwner(proxyOwner(), newOwner);
347     }
348 
349     /**
350      * @dev Allows the pendingOwner to claim ownership of the proxy
351      */
352     function claimProxyOwnership() external onlyPendingProxyOwner {
353         emit ProxyOwnershipTransferred(proxyOwner(), pendingProxyOwner());
354         _setUpgradeabilityOwner(pendingProxyOwner());
355         _setPendingUpgradeabilityOwner(address(0));
356     }
357 
358     /**
359      * @dev Allows the proxy owner to change the contract holding address of implementation.
360      * @param _implementationReference representing the address contract, which holds implementation.
361      */
362     function changeImplementationReference(address _implementationReference) public virtual onlyProxyOwner {
363         _changeImplementationReference(_implementationReference);
364     }
365 
366     /**
367      * @dev Get the address of current implementation.
368      * @return Returns address of implementation contract
369      */
370     function implementation() public view returns (address) {
371         bytes32 position = implementationReferencePosition;
372         address implementationReference;
373         assembly {
374             implementationReference := sload(position)
375         }
376         return ImplementationReference(implementationReference).implementation();
377     }
378 
379     /**
380      * @dev Fallback functions allowing to perform a delegatecall to the given implementation.
381      * This function will return whatever the implementation call returns
382      */
383     fallback() external payable {
384         proxyCall();
385     }
386 
387     /**
388      * @dev This fallback function gets called only when this contract is called without any calldata e.g. send(), transfer()
389      * This would also trigger receive() function on called implementation
390      */
391     receive() external payable {
392         proxyCall();
393     }
394 
395     /**
396      * @dev Performs a low level call, to the contract holding all the logic, changing state on this contract at the same time
397      */
398     function proxyCall() internal {
399         address impl = implementation();
400 
401         assembly {
402             let ptr := mload(0x40)
403             calldatacopy(ptr, 0, calldatasize())
404             let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
405             returndatacopy(ptr, 0, returndatasize())
406 
407             switch result
408                 case 0 {
409                     revert(ptr, returndatasize())
410                 }
411                 default {
412                     return(ptr, returndatasize())
413                 }
414         }
415     }
416 
417     /**
418      * @dev Function to internally change the contract holding address of implementation.
419      * @param _implementationReference representing the address contract, which holds implementation.
420      */
421     function _changeImplementationReference(address _implementationReference) internal virtual {
422         bytes32 position = implementationReferencePosition;
423         assembly {
424             sstore(position, _implementationReference)
425         }
426 
427         emit ImplementationReferenceChanged(address(_implementationReference));
428     }
429 }