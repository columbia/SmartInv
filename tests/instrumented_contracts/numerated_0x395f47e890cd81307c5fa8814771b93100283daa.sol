1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
15     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
16     // benefit is lost if 'b' is also tested.
17     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
18     if (_a == 0) {
19       return 0;
20     }
21 
22     c = _a * _b;
23     assert(c / _a == _b);
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     // uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34     return _a / _b;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
41     assert(_b <= _a);
42     return _a - _b;
43   }
44 
45   /**
46   * @dev Adds two numbers, throws on overflow.
47   */
48   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
49     c = _a + _b;
50     assert(c >= _a);
51     return c;
52   }
53 }
54 
55 // File: contracts/helpers/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions". This adds two-phase
61  * ownership control to OpenZeppelin's Ownable class. In this model, the original owner 
62  * designates a new owner but does not actually transfer ownership. The new owner then accepts 
63  * ownership and completes the transfer.
64  */
65 contract Ownable {
66     address public owner;
67     address public pendingOwner;
68 
69 
70     event OwnershipTransferred(
71       address indexed previousOwner,
72       address indexed newOwner
73     );
74 
75 
76     /**
77     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
78     * account.
79     */
80     constructor() public {
81         owner = msg.sender;
82         pendingOwner = address(0);
83     }
84 
85     /**
86     * @dev Throws if called by any account other than the owner.
87     */
88     modifier onlyOwner() {
89         require(msg.sender == owner, "Account is not owner");
90         _;
91     }
92 
93     /**
94     * @dev Throws if called by any account other than the owner.
95     */
96     modifier onlyPendingOwner() {
97         require(msg.sender == pendingOwner, "Account is not pending owner");
98         _;
99     }
100 
101     /**
102     * @dev Allows the current owner to transfer control of the contract to a newOwner.
103     * @param _newOwner The address to transfer ownership to.
104     */
105     function transferOwnership(address _newOwner) public onlyOwner {
106         require(_newOwner != address(0), "Empty address");
107         pendingOwner = _newOwner;
108     }
109 
110     /**
111     * @dev Allows the pendingOwner address to finalize the transfer.
112     */
113     function claimOwnership() onlyPendingOwner public {
114         emit OwnershipTransferred(owner, pendingOwner);
115         owner = pendingOwner;
116         pendingOwner = address(0);
117     }
118 }
119 
120 // File: contracts/token/dataStorage/AllowanceSheet.sol
121 
122 /**
123 * @title AllowanceSheet
124 * @notice A wrapper around an allowance mapping. 
125 */
126 contract AllowanceSheet is Ownable {
127     using SafeMath for uint256;
128 
129     mapping (address => mapping (address => uint256)) public allowanceOf;
130 
131     function addAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
132         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].add(_value);
133     }
134 
135     function subAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
136         allowanceOf[_tokenHolder][_spender] = allowanceOf[_tokenHolder][_spender].sub(_value);
137     }
138 
139     function setAllowance(address _tokenHolder, address _spender, uint256 _value) public onlyOwner {
140         allowanceOf[_tokenHolder][_spender] = _value;
141     }
142 }
143 
144 // File: contracts/token/dataStorage/BalanceSheet.sol
145 
146 /**
147 * @title BalanceSheet
148 * @notice A wrapper around the balanceOf mapping. 
149 */
150 contract BalanceSheet is Ownable {
151     using SafeMath for uint256;
152 
153     mapping (address => uint256) public balanceOf;
154     uint256 public totalSupply;
155 
156     function addBalance(address _addr, uint256 _value) public onlyOwner {
157         balanceOf[_addr] = balanceOf[_addr].add(_value);
158     }
159 
160     function subBalance(address _addr, uint256 _value) public onlyOwner {
161         balanceOf[_addr] = balanceOf[_addr].sub(_value);
162     }
163 
164     function setBalance(address _addr, uint256 _value) public onlyOwner {
165         balanceOf[_addr] = _value;
166     }
167 
168     function addTotalSupply(uint256 _value) public onlyOwner {
169         totalSupply = totalSupply.add(_value);
170     }
171 
172     function subTotalSupply(uint256 _value) public onlyOwner {
173         totalSupply = totalSupply.sub(_value);
174     }
175 
176     function setTotalSupply(uint256 _value) public onlyOwner {
177         totalSupply = _value;
178     }
179 }
180 
181 // File: contracts/token/dataStorage/TokenStorage.sol
182 
183 /**
184 * @title TokenStorage
185 */
186 contract TokenStorage {
187     /**
188         Storage
189     */
190     BalanceSheet public balances;
191     AllowanceSheet public allowances;
192 
193 
194     string public name;   //name of Token                
195     uint8  public decimals;        //decimals of Token        
196     string public symbol;   //Symbol of Token
197 
198     /**
199     * @dev a TokenStorage consumer can set its storages only once, on construction
200     *
201     **/
202     constructor (address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) public {
203         balances = BalanceSheet(_balances);
204         allowances = AllowanceSheet(_allowances);
205 
206         name = _name;
207         decimals = _decimals;
208         symbol = _symbol;
209     }
210 
211     /**
212     * @dev claim ownership of balance sheet passed into constructor.
213     **/
214     function claimBalanceOwnership() public {
215         balances.claimOwnership();
216     }
217 
218     /**
219     * @dev claim ownership of allowance sheet passed into constructor.
220     **/
221     function claimAllowanceOwnership() public {
222         allowances.claimOwnership();
223     }
224 }
225 
226 // File: zos-lib/contracts/upgradeability/Proxy.sol
227 
228 /**
229  * @title Proxy
230  * @dev Implements delegation of calls to other contracts, with proper
231  * forwarding of return values and bubbling of failures.
232  * It defines a fallback function that delegates all calls to the address
233  * returned by the abstract _implementation() internal function.
234  */
235 contract Proxy {
236   /**
237    * @dev Fallback function.
238    * Implemented entirely in `_fallback`.
239    */
240   function () payable external {
241     _fallback();
242   }
243 
244   /**
245    * @return The Address of the implementation.
246    */
247   function _implementation() internal view returns (address);
248 
249   /**
250    * @dev Delegates execution to an implementation contract.
251    * This is a low level function that doesn't return to its internal call site.
252    * It will return to the external caller whatever the implementation returns.
253    * @param implementation Address to delegate.
254    */
255   function _delegate(address implementation) internal {
256     assembly {
257       // Copy msg.data. We take full control of memory in this inline assembly
258       // block because it will not return to Solidity code. We overwrite the
259       // Solidity scratch pad at memory position 0.
260       calldatacopy(0, 0, calldatasize)
261 
262       // Call the implementation.
263       // out and outsize are 0 because we don't know the size yet.
264       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
265 
266       // Copy the returned data.
267       returndatacopy(0, 0, returndatasize)
268 
269       switch result
270       // delegatecall returns 0 on error.
271       case 0 { revert(0, returndatasize) }
272       default { return(0, returndatasize) }
273     }
274   }
275 
276   /**
277    * @dev Function that is run as the first thing in the fallback function.
278    * Can be redefined in derived contracts to add functionality.
279    * Redefinitions must call super._willFallback().
280    */
281   function _willFallback() internal {
282   }
283 
284   /**
285    * @dev fallback implementation.
286    * Extracted to enable manual triggering.
287    */
288   function _fallback() internal {
289     _willFallback();
290     _delegate(_implementation());
291   }
292 }
293 
294 // File: openzeppelin-solidity/contracts/AddressUtils.sol
295 
296 /**
297  * Utility library of inline functions on addresses
298  */
299 library AddressUtils {
300 
301   /**
302    * Returns whether the target address is a contract
303    * @dev This function will return false if invoked during the constructor of a contract,
304    * as the code is not actually created until after the constructor finishes.
305    * @param _addr address to check
306    * @return whether the target address is a contract
307    */
308   function isContract(address _addr) internal view returns (bool) {
309     uint256 size;
310     // XXX Currently there is no better way to check if there is a contract in an address
311     // than to check the size of the code at that address.
312     // See https://ethereum.stackexchange.com/a/14016/36603
313     // for more details about how this works.
314     // TODO Check this again before the Serenity release, because all addresses will be
315     // contracts then.
316     // solium-disable-next-line security/no-inline-assembly
317     assembly { size := extcodesize(_addr) }
318     return size > 0;
319   }
320 
321 }
322 
323 // File: zos-lib/contracts/upgradeability/UpgradeabilityProxy.sol
324 
325 /**
326  * @title UpgradeabilityProxy
327  * @dev This contract implements a proxy that allows to change the
328  * implementation address to which it will delegate.
329  * Such a change is called an implementation upgrade.
330  */
331 contract UpgradeabilityProxy is Proxy {
332   /**
333    * @dev Emitted when the implementation is upgraded.
334    * @param implementation Address of the new implementation.
335    */
336   event Upgraded(address implementation);
337 
338   /**
339    * @dev Storage slot with the address of the current implementation.
340    * This is the keccak-256 hash of "org.zeppelinos.proxy.implementation", and is
341    * validated in the constructor.
342    */
343   bytes32 private constant IMPLEMENTATION_SLOT = 0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3;
344 
345   /**
346    * @dev Contract constructor.
347    * @param _implementation Address of the initial implementation.
348    */
349   constructor(address _implementation) public {
350     assert(IMPLEMENTATION_SLOT == keccak256("org.zeppelinos.proxy.implementation"));
351 
352     _setImplementation(_implementation);
353   }
354 
355   /**
356    * @dev Returns the current implementation.
357    * @return Address of the current implementation
358    */
359   function _implementation() internal view returns (address impl) {
360     bytes32 slot = IMPLEMENTATION_SLOT;
361     assembly {
362       impl := sload(slot)
363     }
364   }
365 
366   /**
367    * @dev Upgrades the proxy to a new implementation.
368    * @param newImplementation Address of the new implementation.
369    */
370   function _upgradeTo(address newImplementation) internal {
371     _setImplementation(newImplementation);
372     emit Upgraded(newImplementation);
373   }
374 
375   /**
376    * @dev Sets the implementation address of the proxy.
377    * @param newImplementation Address of the new implementation.
378    */
379   function _setImplementation(address newImplementation) private {
380     require(AddressUtils.isContract(newImplementation), "Cannot set a proxy implementation to a non-contract address");
381 
382     bytes32 slot = IMPLEMENTATION_SLOT;
383 
384     assembly {
385       sstore(slot, newImplementation)
386     }
387   }
388 }
389 
390 // File: contracts/token/TokenProxy.sol
391 
392 /**
393 * @title TokenProxy
394 * @notice A proxy contract that serves the latest implementation of TokenProxy.
395 */
396 contract TokenProxy is UpgradeabilityProxy, TokenStorage, Ownable {
397     constructor(address _implementation, address _balances, address _allowances, string _name, uint8 _decimals, string _symbol) 
398     UpgradeabilityProxy(_implementation) 
399     TokenStorage(_balances, _allowances, _name, _decimals, _symbol) public {
400     }
401 
402     /**
403     * @dev Upgrade the backing implementation of the proxy.
404     * Only the admin can call this function.
405     * @param newImplementation Address of the new implementation.
406     */
407     function upgradeTo(address newImplementation) public onlyOwner {
408         _upgradeTo(newImplementation);
409     }
410 
411     /**
412     * @return The address of the implementation.
413     */
414     function implementation() public view returns (address) {
415         return _implementation();
416     }
417 }