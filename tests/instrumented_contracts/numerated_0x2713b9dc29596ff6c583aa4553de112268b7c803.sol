1 /*
2   Akropolis Token, https://akropolis.io
3 */
4 pragma solidity ^0.4.24;
5 
6 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (_a == 0) {
22       return 0;
23     }
24 
25     c = _a * _b;
26     assert(c / _a == _b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
34     // assert(_b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = _a / _b;
36     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
37     return _a / _b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
44     assert(_b <= _a);
45     return _a - _b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
52     c = _a + _b;
53     assert(c >= _a);
54     return c;
55   }
56 }
57 
58 // File: contracts/helpers/Ownable.sol
59 
60 /**
61  * @title Ownable
62  * @dev The Ownable contract has an owner address, and provides basic authorization control
63  * functions, this simplifies the implementation of "user permissions". This adds two-phase
64  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
65  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
66  * ownership and completes the transfer.
67  */
68 contract Ownable {
69     address public owner;
70     address public pendingOwner;
71 
72 
73     event OwnershipTransferred(
74       address indexed previousOwner,
75       address indexed newOwner
76     );
77 
78 
79     /**
80     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
81     * account.
82     */
83     constructor() public {
84         owner = msg.sender;
85         pendingOwner = address(0);
86     }
87 
88     /**
89     * @dev Throws if called by any account other than the owner.
90     */
91     modifier onlyOwner() {
92         require(msg.sender == owner, "Account is not owner");
93         _;
94     }
95 
96     /**
97     * @dev Throws if called by any account other than the owner.
98     */
99     modifier onlyPendingOwner() {
100         require(msg.sender == pendingOwner, "Account is not pending owner");
101         _;
102     }
103 
104     /**
105     * @dev Allows the current owner to transfer control of the contract to a newOwner.
106     * @param _newOwner The address to transfer ownership to.
107     */
108     function transferOwnership(address _newOwner) public onlyOwner {
109         require(_newOwner != address(0), "Empty address");
110         pendingOwner = _newOwner;
111     }
112 
113     /**
114     * @dev Allows the pendingOwner address to finalize the transfer.
115     */
116     function claimOwnership() onlyPendingOwner public {
117         emit OwnershipTransferred(owner, pendingOwner);
118         owner = pendingOwner;
119         pendingOwner = address(0);
120     }
121 }
122 
123 // File: contracts/token/dataStorage/AllowanceSheet.sol
124 
125 /**
126 * @title AllowanceSheet
127 * @notice A wrapper around an allowance mapping. 
128 */
129 contract AllowanceSheet is Ownable {
130     using SafeMath for uint256;
131 
132     mapping (address => mapping (address => uint256)) public allowanceOf;
133 
134     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
135         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
136     }
137 
138     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
139         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
140     }
141 
142     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
143         allowanceOf[_tokenHolder][_spender] = _value;
144     }
145 }
146 
147 // File: contracts/token/dataStorage/BalanceSheet.sol
148 
149 /**
150 * @title BalanceSheet
151 * @notice A wrapper around the balanceOf mapping. 
152 */
153 contract BalanceSheet is Ownable {
154     using SafeMath for uint256;
155 
156     mapping (address => uint256) public balanceOf;
157     uint256 public totalSupply;
158 
159     function addBalance(address _addr, uint256 _value) public onlyOwner {
160         balanceOf[_addr] = balanceOf[_addr].add(_value);
161     }
162 
163     function subBalance(address _addr, uint256 _value) public onlyOwner {
164         balanceOf[_addr] = balanceOf[_addr].sub(_value);
165     }
166 
167     function setBalance(address _addr, uint256 _value) public onlyOwner {
168         balanceOf[_addr] = _value;
169     }
170 
171     function addTotalSupply(uint256 _value) public onlyOwner {
172         totalSupply = totalSupply.add(_value);
173     }
174 
175     function subTotalSupply(uint256 _value) public onlyOwner {
176         totalSupply = totalSupply.sub(_value);
177     }
178 
179     function setTotalSupply(uint256 _value) public onlyOwner {
180         totalSupply = _value;
181     }
182 }
183 
184 // File: contracts/token/dataStorage/TokenStorage.sol
185 
186 /**
187 * @title TokenStorage
188 */
189 contract TokenStorage {
190     /**
191         Storage
192     */
193     BalanceSheet public balances;
194     AllowanceSheet public allowances;
195 
196 
197     string public name;   //name of Token                
198     uint8  public decimals;        //decimals of Token        
199     string public symbol;   //Symbol of Token
200 
201     /**
202     * @dev a TokenStorage consumer can set its storages only once, on construction
203     *
204     **/
205     constructor (address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) public {
206         balances = BalanceSheet(_balances);
207         allowances = AllowanceSheet(_allowances);
208 
209         name = _name;
210         decimals = _decimals;
211         symbol = _symbol;
212     }
213 
214     /**
215     * @dev claim ownership of balance sheet passed into constructor.
216     **/
217     function claimBalanceOwnership() public {
218         balances.claimOwnership();
219     }
220 
221     /**
222     * @dev claim ownership of allowance sheet passed into constructor.
223     **/
224     function claimAllowanceOwnership() public {
225         allowances.claimOwnership();
226     }
227 }
228 
229 // File: zos-lib/contracts/upgradeability/Proxy.sol
230 
231 /**
232  * @title Proxy
233  * @dev Implements delegation of calls to other contracts, with proper
234  * forwarding of return values and bubbling of failures.
235  * It defines a fallback function that delegates all calls to the address
236  * returned by the abstract _implementation() internal function.
237  */
238 contract Proxy {
239   /**
240    * @dev Fallback function.
241    * Implemented entirely in `_fallback`.
242    */
243   function () payable external {
244     _fallback();
245   }
246 
247   /**
248    * @return The Address of the implementation.
249    */
250   function _implementation() internal view returns (address);
251 
252   /**
253    * @dev Delegates execution to an implementation contract.
254    * This is a low level function that doesn't return to its internal call site.
255    * It will return to the external caller whatever the implementation returns.
256    * @param implementation Address to delegate.
257    */
258   function _delegate(address implementation) internal {
259     assembly {
260       // Copy msg.data. We take full control of memory in this inline assembly
261       // block because it will not return to Solidity code. We overwrite the
262       // Solidity scratch pad at memory position 0.
263       calldatacopy(0, 0, calldatasize)
264 
265       // Call the implementation.
266       // out and outsize are 0 because we don't know the size yet.
267       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
268 
269       // Copy the returned data.
270       returndatacopy(0, 0, returndatasize)
271 
272       switch result
273       // delegatecall returns 0 on error.
274       case 0 { revert(0, returndatasize) }
275       default { return(0, returndatasize) }
276     }
277   }
278 
279   /**
280    * @dev Function that is run as the first thing in the fallback function.
281    * Can be redefined in derived contracts to add functionality.
282    * Redefinitions must call super._willFallback().
283    */
284   function _willFallback() internal {
285   }
286 
287   /**
288    * @dev fallback implementation.
289    * Extracted to enable manual triggering.
290    */
291   function _fallback() internal {
292     _willFallback();
293     _delegate(_implementation());
294   }
295 }
296 
297 // File: openzeppelin-solidity/contracts/AddressUtils.sol
298 
299 /**
300  * Utility library of inline functions on addresses
301  */
302 library AddressUtils {
303 
304   /**
305    * Returns whether the target address is a contract
306    * @dev This function will return false if invoked during the constructor of a contract,
307    * as the code is not actually created until after the constructor finishes.
308    * @param _addr address to check
309    * @return whether the target address is a contract
310    */
311   function isContract(address _addr) internal view returns (bool) {
312     uint256 size;
313     // XXX Currently there is no better way to check if there is a contract in an address
314     // than to check the size of the code at that address.
315     // See https://ethereum.stackexchange.com/a/14016/36603
316     // for more details about how this works.
317     // TODO Check this again before the Serenity release, because all addresses will be
318     // contracts then.
319     // solium-disable-next-line security/no-inline-assembly
320     assembly { size := extcodesize(_addr) }
321     return size > 0;
322   }
323 
324 }
325 
326 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
327 
328 /**
329  * @title UpgradeabilityProxy
330  * @dev This contract implements a proxy that allows to change the
331  * implementation address to which it will delegate.
332  * Such a change is called an implementation upgrade.
333  */
334 contract UpgradeabilityProxy is Proxy {
335   /**
336    * @dev Emitted when the implementation is upgraded.
337    * @param implementation Address of the new implementation.
338    */
339   event Upgraded(address implementation);
340 
341   /**
342    * @dev Storage slot with the address of the current implementation.
343    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
344    * validated in the constructor.
345    */
346   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
347 
348   /**
349    * @dev Contract constructor.
350    * @param _implementation Address of the initial implementation.
351    */
352   constructor(address _implementation) public {
353     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
354 
355     _setImplementation(_implementation);
356   }
357 
358   /**
359    * @dev Returns the current implementation.
360    * @return Address of the current implementation
361    */
362   function _implementation() internal view returns (address impl) {
363     bytes32 slot = IMPLEMENTATION_SLOT;
364     assembly {
365       impl := sload(slot)
366     }
367   }
368 
369   /**
370    * @dev Upgrades the proxy to a new implementation.
371    * @param newImplementation Address of the new implementation.
372    */
373   function _upgradeTo(address newImplementation) internal {
374     _setImplementation(newImplementation);
375     emit Upgraded(newImplementation);
376   }
377 
378   /**
379    * @dev Sets the implementation address of the proxy.
380    * @param newImplementation Address of the new implementation.
381    */
382   function _setImplementation(address newImplementation) private {
383     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
384 
385     bytes32 slot = IMPLEMENTATION_SLOT;
386 
387     assembly {
388       sstore(slot, newImplementation)
389     }
390   }
391 }
392 
393 // File: contracts/token/TokenProxy.sol
394 
395 /**
396 * @title TokenProxy
397 * @notice A proxy contract that serves the latest implementation of TokenProxy.
398 */
399 contract TokenProxy is UpgradeabilityProxy, TokenStorage, Ownable {
400     constructor(address _implementation, address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) 
401     UpgradeabilityProxy(_implementation) 
402     TokenStorage(_balances, _allowances, _name, _decimals, _symbol) public {
403     }
404 
405     /**
406     * @dev Upgrade the backing implementation of the proxy.
407     * Only the admin can call this function.
408     * @param newImplementation Address of the new implementation.
409     */
410     function upgradeTo(address newImplementation) public onlyOwner {
411         _upgradeTo(newImplementation);
412     }
413 
414     /**
415     * @return The address of the implementation.
416     */
417     function implementation() public view returns (address) {
418         return _implementation();
419     }
420 }