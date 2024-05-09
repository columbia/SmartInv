1 // File: @openzeppelin/upgrades/contracts/upgradeability/Proxy.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title Proxy
7  * @dev Implements delegation of calls to other contracts, with proper
8  * forwarding of return values and bubbling of failures.
9  * It defines a fallback function that delegates all calls to the address
10  * returned by the abstract _implementation() internal function.
11  */
12 contract Proxy {
13   /**
14    * @dev Fallback function.
15    * Implemented entirely in `_fallback`.
16    */
17   function () payable external {
18     _fallback();
19   }
20 
21   /**
22    * @return The Address of the implementation.
23    */
24   function _implementation() internal view returns (address);
25 
26   /**
27    * @dev Delegates execution to an implementation contract.
28    * This is a low level function that doesn't return to its internal call site.
29    * It will return to the external caller whatever the implementation returns.
30    * @param implementation Address to delegate.
31    */
32   function _delegate(address implementation) internal {
33     assembly {
34       // Copy msg.data. We take full control of memory in this inline assembly
35       // block because it will not return to Solidity code. We overwrite the
36       // Solidity scratch pad at memory position 0.
37       calldatacopy(0, 0, calldatasize)
38 
39       // Call the implementation.
40       // out and outsize are 0 because we don't know the size yet.
41       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
42 
43       // Copy the returned data.
44       returndatacopy(0, 0, returndatasize)
45 
46       switch result
47       // delegatecall returns 0 on error.
48       case 0 { revert(0, returndatasize) }
49       default { return(0, returndatasize) }
50     }
51   }
52 
53   /**
54    * @dev Function that is run as the first thing in the fallback function.
55    * Can be redefined in derived contracts to add functionality.
56    * Redefinitions must call super._willFallback().
57    */
58   function _willFallback() internal {
59   }
60 
61   /**
62    * @dev fallback implementation.
63    * Extracted to enable manual triggering.
64    */
65   function _fallback() internal {
66     _willFallback();
67     _delegate(_implementation());
68   }
69 }
70 
71 // File: @openzeppelin/upgrades/contracts/utils/Address.sol
72 
73 pragma solidity ^0.5.0;
74 
75 /**
76  * Utility library of inline functions on addresses
77  *
78  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/utils/Address.sol
79  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
80  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
81  * build/artifacts folder) as well as the vanilla Address implementation from an openzeppelin version.
82  */
83 library OpenZeppelinUpgradesAddress {
84     /**
85      * Returns whether the target address is a contract
86      * @dev This function will return false if invoked during the constructor of a contract,
87      * as the code is not actually created until after the constructor finishes.
88      * @param account address of the account to check
89      * @return whether the target address is a contract
90      */
91     function isContract(address account) internal view returns (bool) {
92         uint256 size;
93         // XXX Currently there is no better way to check if there is a contract in an address
94         // than to check the size of the code at that address.
95         // See https://ethereum.stackexchange.com/a/14016/36603
96         // for more details about how this works.
97         // TODO Check this again before the Serenity release, because all addresses will be
98         // contracts then.
99         // solhint-disable-next-line no-inline-assembly
100         assembly { size := extcodesize(account) }
101         return size > 0;
102     }
103 }
104 
105 // File: @openzeppelin/upgrades/contracts/ownership/Ownable.sol
106 
107 pragma solidity ^0.5.0;
108 
109 /**
110  * @title Ownable
111  * @dev The Ownable contract has an owner address, and provides basic authorization control
112  * functions, this simplifies the implementation of "user permissions".
113  *
114  * Source https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-solidity/v2.1.3/contracts/ownership/Ownable.sol
115  * This contract is copied here and renamed from the original to avoid clashes in the compiled artifacts
116  * when the user imports a zos-lib contract (that transitively causes this contract to be compiled and added to the
117  * build/artifacts folder) as well as the vanilla Ownable implementation from an openzeppelin version.
118  */
119 contract OpenZeppelinUpgradesOwnable {
120     address private _owner;
121 
122     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
123 
124     /**
125      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
126      * account.
127      */
128     constructor () internal {
129         _owner = msg.sender;
130         emit OwnershipTransferred(address(0), _owner);
131     }
132 
133     /**
134      * @return the address of the owner.
135      */
136     function owner() public view returns (address) {
137         return _owner;
138     }
139 
140     /**
141      * @dev Throws if called by any account other than the owner.
142      */
143     modifier onlyOwner() {
144         require(isOwner());
145         _;
146     }
147 
148     /**
149      * @return true if `msg.sender` is the owner of the contract.
150      */
151     function isOwner() public view returns (bool) {
152         return msg.sender == _owner;
153     }
154 
155     /**
156      * @dev Allows the current owner to relinquish control of the contract.
157      * @notice Renouncing to ownership will leave the contract without an owner.
158      * It will not be possible to call the functions with the `onlyOwner`
159      * modifier anymore.
160      */
161     function renounceOwnership() public onlyOwner {
162         emit OwnershipTransferred(_owner, address(0));
163         _owner = address(0);
164     }
165 
166     /**
167      * @dev Allows the current owner to transfer control of the contract to a newOwner.
168      * @param newOwner The address to transfer ownership to.
169      */
170     function transferOwnership(address newOwner) public onlyOwner {
171         _transferOwnership(newOwner);
172     }
173 
174     /**
175      * @dev Transfers control of the contract to a newOwner.
176      * @param newOwner The address to transfer ownership to.
177      */
178     function _transferOwnership(address newOwner) internal {
179         require(newOwner != address(0));
180         emit OwnershipTransferred(_owner, newOwner);
181         _owner = newOwner;
182     }
183 }
184 
185 // File: contracts/UAXCoinOwnable.sol
186 
187 pragma solidity ^0.5.16;
188 
189 
190 /**
191  * @dev Adds new owner approval to the Ownable implementation.
192  */
193 contract UAXCoinOwnable is OpenZeppelinUpgradesOwnable {
194     address private _newOwner;
195 
196     /**
197      * @dev Throws if called by any account other than the owner.
198      */
199     modifier onlyOwner() {
200         require(isOwner(), "Ownable: caller is not the owner");
201         _;
202     }
203 
204     /**
205      * @dev Allows the current owner to transfer control of the contract to a newOwner.
206      * @param newOwner The address to transfer ownership to.
207      */
208     function transferOwnership(address newOwner) public onlyOwner {
209         require(newOwner != address(0), "Ownable: new owner is the zero address");
210         _newOwner = newOwner;
211     }
212 
213     /**
214      * @dev Returns the address of the new owner.
215      */
216     function newOwner() public view returns (address) {
217         return _newOwner;
218     }
219 
220     /**
221      * @dev Throws if called by any account other than the owner.
222      */
223     modifier onlyNewOwner() {
224         require(msg.sender == _newOwner, "Ownable: caller is not a new owner");
225         _;
226     }
227 
228     /**
229      * @dev New owner should approve ownership to avoid transfering to an invalid address.
230      */
231     function acceptOwnership() public onlyNewOwner {
232         super._transferOwnership(_newOwner);
233         _newOwner = address(0);
234     }
235 }
236 
237 // File: contracts/UAXProxy.sol
238 
239 pragma solidity ^0.5.16;
240 
241 
242 
243 
244 /**
245  * @dev Main contract is a Proxy to the implimentation in Controller contract.
246  */
247 contract UAXProxy is UAXCoinOwnable, Proxy {
248     /**
249     * @dev Emitted when the implementation is upgraded.
250     * @param implementation Address of the new implementation.
251     */
252     event Upgraded(address indexed implementation);
253 
254     /**
255     * @dev Emitted when the administration has been transferred.
256     * @param previousAdmin Address of the previous admin.
257     * @param newAdmin Address of the new admin.
258     */
259     event AdminChanged(address previousAdmin, address newAdmin);
260 
261     /**
262     * @dev Storage slot with the address of the current implementation.
263     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
264     * validated in the constructor.
265     */
266     bytes32 internal constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
267 
268 
269     /**
270     * @dev Storage slot with the admin of the contract.
271     * This is the keccak-256 hash of "eip1967.proxy.admin" subtracted by 1, and is
272     * validated in the constructor.
273     */
274 
275     bytes32 internal constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;
276 
277     /**
278     * @dev Modifier to check whether the `msg.sender` is the admin.
279     * If it is, it will run the function. Otherwise, it will delegate the call
280     * to the implementation.
281     */
282     modifier ifAdmin() {
283         require(msg.sender == _admin(), "Caller is not a Proxy Admin");
284         _;
285     }
286 
287     /**
288      * @dev Set contract creator as admin by default
289      */
290     constructor() public {
291         _setAdmin(msg.sender);
292     }
293 
294     /**
295     * @return The address of the proxy admin.
296     */
297     function admin() public view returns (address) {
298         return _admin();
299     }
300 
301     /**
302     * @return The address of the implementation.
303     */
304     function implementation() public view returns (address) {
305         return _implementation();
306     }
307 
308     /**
309     * @dev Changes the admin of the proxy.
310     * Only the current admin can call this function.
311     * @param newAdmin Address to transfer proxy administration to.
312     */
313     function changeAdmin(address newAdmin) public ifAdmin {
314         require(newAdmin != address(0), "Cannot change the admin of a proxy to the zero address");
315         emit AdminChanged(_admin(), newAdmin);
316         _setAdmin(newAdmin);
317     }
318 
319     /**
320      * @dev Sets new controller contract address
321      */
322     function setController(address controller) public ifAdmin {
323         require(controller != _implementation(), "Implementation address is the same as it was");
324         _upgradeTo(controller);
325     }
326 
327     /**
328     * @return The admin slot.
329     */
330     function _admin() internal view returns (address adm) {
331         bytes32 slot = ADMIN_SLOT;
332         assembly {
333             adm := sload(slot)
334         }
335     }
336 
337     /**
338     * @dev Sets the address of the proxy admin.
339     * @param newAdmin Address of the new proxy admin.
340     */
341     function _setAdmin(address newAdmin) internal {
342         bytes32 slot = ADMIN_SLOT;
343 
344         assembly {
345             sstore(slot, newAdmin)
346         }
347     }
348 
349     /**
350      * @dev fallback implementation.
351      * Extracted to enable manual triggering.
352      */
353     function _fallback() internal {
354         super._willFallback();
355         super._delegate(_implementation());
356     }
357 
358 
359     /**
360     * @dev Returns the current implementation.
361     * @return Address of the current implementation
362     */
363     function _implementation() internal view returns (address impl) {
364         bytes32 slot = IMPLEMENTATION_SLOT;
365         assembly {
366             impl := sload(slot)
367         }
368     }
369 
370     /**
371     * @dev Upgrades the proxy to a new implementation.
372     * @param newImplementation Address of the new implementation.
373     */
374     function _upgradeTo(address newImplementation) internal {
375         _setImplementation(newImplementation);
376         emit Upgraded(newImplementation);
377     }
378 
379     /**
380      * @dev Checks if implementation is empty
381      */
382     function _isNullImplementation() internal view returns (bool) {
383         return _implementation() == address(0x0);
384     }
385 
386     /**
387     * @dev Sets the implementation address of the proxy.
388     * @param newImplementation Address of the new implementation.
389     */
390     function _setImplementation(address newImplementation) internal {
391         require(OpenZeppelinUpgradesAddress.isContract(newImplementation) || newImplementation == address(0x0), "Cannot set a proxy implementation to a non-contract address");
392 
393         bytes32 slot = IMPLEMENTATION_SLOT;
394 
395         assembly {
396             sstore(slot, newImplementation)
397         }
398     }
399 }
400 
401 // File: contracts/UAX.sol
402 
403 pragma solidity ^0.5.16;
404 
405 
406 /**
407  * @dev Main token contract
408  */
409 contract UAX is UAXProxy {
410     /**
411      * @dev Contract elimination method.
412      */
413     function die() public ifAdmin {
414         require(_isNullImplementation(), "Cannot destruct contract with implementation");
415         address payable admin = address(uint160(_admin()));
416         selfdestruct(admin);
417     }
418 }