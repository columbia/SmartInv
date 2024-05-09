1 // File: openzeppelin-solidity/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         _owner = _msgSender();
54         emit OwnershipTransferred(address(0), _owner);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(isOwner(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Returns true if the caller is the current owner.
74      */
75     function isOwner() public view returns (bool) {
76         return _msgSender() == _owner;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91     /**
92      * @dev Transfers ownership of the contract to a new account (`newOwner`).
93      * Can only be called by the current owner.
94      */
95     function transferOwnership(address newOwner) public onlyOwner {
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      */
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 }
108 
109 // File: openzeppelin-solidity/contracts/utils/Address.sol
110 
111 pragma solidity ^0.5.5;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * This test is non-exhaustive, and there may be false-negatives: during the
121      * execution of a contract's constructor, its address will be reported as
122      * not containing a contract.
123      *
124      * IMPORTANT: It is unsafe to assume that an address for which this
125      * function returns false is an externally-owned account (EOA) and not a
126      * contract.
127      */
128     function isContract(address account) internal view returns (bool) {
129         // This method relies in extcodesize, which returns 0 for contracts in
130         // construction, since the code is only stored at the end of the
131         // constructor execution.
132 
133         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
134         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
135         // for accounts without code, i.e. `keccak256('')`
136         bytes32 codehash;
137         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
138         // solhint-disable-next-line no-inline-assembly
139         assembly { codehash := extcodehash(account) }
140         return (codehash != 0x0 && codehash != accountHash);
141     }
142 
143     /**
144      * @dev Converts an `address` into `address payable`. Note that this is
145      * simply a type cast: the actual underlying value is not changed.
146      *
147      * _Available since v2.4.0._
148      */
149     function toPayable(address account) internal pure returns (address payable) {
150         return address(uint160(account));
151     }
152 
153     /**
154      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
155      * `recipient`, forwarding all available gas and reverting on errors.
156      *
157      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
158      * of certain opcodes, possibly making contracts go over the 2300 gas limit
159      * imposed by `transfer`, making them unable to receive funds via
160      * `transfer`. {sendValue} removes this limitation.
161      *
162      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
163      *
164      * IMPORTANT: because control is transferred to `recipient`, care must be
165      * taken to not create reentrancy vulnerabilities. Consider using
166      * {ReentrancyGuard} or the
167      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
168      *
169      * _Available since v2.4.0._
170      */
171     function sendValue(address payable recipient, uint256 amount) internal {
172         require(address(this).balance >= amount, "Address: insufficient balance");
173 
174         // solhint-disable-next-line avoid-call-value
175         (bool success, ) = recipient.call.value(amount)("");
176         require(success, "Address: unable to send value, recipient may have reverted");
177     }
178 }
179 
180 // File: contracts/interfaces/IENSRegistry.sol
181 
182 pragma solidity ^0.5.15;
183 
184 /**
185  * @title EnsRegistry
186  * @dev Extract of the interface for ENS Registry
187 */
188 contract IENSRegistry {
189     function setOwner(bytes32 node, address owner) public;
190     function setSubnodeOwner(bytes32 node, bytes32 label, address owner) public;
191     function setResolver(bytes32 node, address resolver) public;
192     function owner(bytes32 node) public view returns (address);
193     function resolver(bytes32 node) public view returns (address);
194 }
195 
196 // File: contracts/interfaces/IDCLRegistrar.sol
197 
198 pragma solidity ^0.5.15;
199 
200 contract IDCLRegistrar {
201     /**
202 	 * @dev Allows to create a subdomain (e.g. "nacho.dcl.eth"), set its resolver, owner and target address
203 	 * @param _subdomain - subdomain  (e.g. "nacho")
204 	 * @param _beneficiary - address that will become owner of this new subdomain
205 	 */
206     function register(string calldata _subdomain, address _beneficiary) external;
207 
208      /**
209 	 * @dev Re-claim the ownership of a subdomain (e.g. "nacho").
210      * @notice After a subdomain is transferred by this contract, the owner in the ENS registry contract
211      * is still the old owner. Therefore, the owner should call `reclaim` to update the owner of the subdomain.
212 	 * @param _tokenId - erc721 token id which represents the node (subdomain).
213      * @param _owner - new owner.
214      */
215     function reclaim(uint256 _tokenId, address _owner) external;
216 
217     /**
218      * @dev Transfer a name to a new owner.
219      * @param _from - current owner of the node.
220      * @param _to - new owner of the node.
221      * @param _id - node id.
222      */
223     function transferFrom(address _from, address _to, uint256 _id) public;
224 
225     /**
226 	 * @dev Check whether a name is available to be registered or not
227 	 * @param _labelhash - hash of the name to check
228      * @return whether the name is available or not
229      */
230     function available(bytes32 _labelhash) public view returns (bool);
231 
232 }
233 
234 // File: openzeppelin-eth/contracts/token/ERC20/IERC20.sol
235 
236 pragma solidity ^0.5.2;
237 
238 /**
239  * @title ERC20 interface
240  * @dev see https://eips.ethereum.org/EIPS/eip-20
241  */
242 interface IERC20 {
243     function transfer(address to, uint256 value) external returns (bool);
244 
245     function approve(address spender, uint256 value) external returns (bool);
246 
247     function transferFrom(address from, address to, uint256 value) external returns (bool);
248 
249     function totalSupply() external view returns (uint256);
250 
251     function balanceOf(address who) external view returns (uint256);
252 
253     function allowance(address owner, address spender) external view returns (uint256);
254 
255     event Transfer(address indexed from, address indexed to, uint256 value);
256 
257     event Approval(address indexed owner, address indexed spender, uint256 value);
258 }
259 
260 // File: contracts/interfaces/IERC20Token.sol
261 
262 pragma solidity ^0.5.15;
263 
264 
265 contract IERC20Token is IERC20{
266     function balanceOf(address from) public view returns (uint256);
267     function transferFrom(address from, address to, uint tokens) public returns (bool);
268     function allowance(address owner, address spender) public view returns (uint256);
269     function burn(uint256 amount) public;
270 }
271 
272 // File: contracts/ens/DCLController.sol
273 
274 pragma solidity ^0.5.15;
275 
276 
277 
278 
279 
280 
281 contract DCLController is Ownable {
282     using Address for address;
283 
284     // Price of each name
285     uint256 constant public PRICE = 100 ether;
286 
287     // Accepted ERC20 token
288     IERC20Token public acceptedToken;
289     // DCL Registrar
290     IDCLRegistrar public registrar;
291 
292     // Price of each name
293     uint256 public maxGasPrice = 20000000000; // 20 gwei
294 
295     // Emitted when a name is bought
296     event NameBought(address indexed _caller, address indexed _beneficiary, uint256 _price, string _name);
297 
298     // Emitted when the max gas price is changed
299     event MaxGasPriceChanged(uint256 indexed _oldMaxGasPrice, uint256 indexed _newMaxGasPrice);
300 
301     /**
302 	 * @dev Constructor of the contract
303      * @param _acceptedToken - address of the accepted token
304      * @param _registrar - address of the DCL registrar contract
305 	 */
306     constructor(IERC20Token _acceptedToken, IDCLRegistrar _registrar) public {
307         require(address(_acceptedToken).isContract(), "Accepted token should be a contract");
308         require(address(_registrar).isContract(), "Registrar should be a contract");
309 
310         // Accepted token
311         acceptedToken = _acceptedToken;
312         // DCL registrar
313         registrar = _registrar;
314     }
315 
316     /**
317 	 * @dev Register a name
318      * @param _name - name to be registered
319 	 * @param _beneficiary - owner of the name
320 	 */
321     function register(string memory _name, address _beneficiary) public {
322         // Check gas price
323         require(tx.gasprice <= maxGasPrice, "Maximum gas price allowed exceeded");
324         // Check for valid beneficiary
325         require(_beneficiary != address(0), "Invalid beneficiary");
326 
327         // Check if the name is valid
328         _requireNameValid(_name);
329         // Check if the sender has at least `price` and the contract has allowance to use on its behalf
330         _requireBalance(msg.sender);
331 
332         // Register the name
333         registrar.register(_name, _beneficiary);
334         // Debit `price` from sender
335         acceptedToken.transferFrom(msg.sender, address(this), PRICE);
336         // Burn it
337         acceptedToken.burn(PRICE);
338         // Log
339         emit NameBought(msg.sender, _beneficiary, PRICE, _name);
340     }
341 
342     /**
343      * @dev Update max gas price
344      * @param _maxGasPrice - new max gas price to be used
345      */
346     function updateMaxGasPrice(uint256 _maxGasPrice) external onlyOwner {
347         require(_maxGasPrice != maxGasPrice, "Max gas price should be different");
348         require(
349             _maxGasPrice >= 1000000000,
350             "Max gas price should be greater than or equal to 1 gwei"
351         );
352 
353         emit MaxGasPriceChanged(maxGasPrice, _maxGasPrice);
354 
355         maxGasPrice = _maxGasPrice;
356     }
357 
358     /**
359      * @dev Validate if a user has balance and the contract has enough allowance
360      * to use user's accepted token on his belhalf
361      * @param _user - address of the user
362      */
363     function _requireBalance(address _user) internal view {
364         require(
365             acceptedToken.balanceOf(_user) >= PRICE,
366             "Insufficient funds"
367         );
368         require(
369             acceptedToken.allowance(_user, address(this)) >= PRICE,
370             "The contract is not authorized to use the accepted token on sender behalf"
371         );
372     }
373 
374     /**
375     * @dev Validate a nane
376     * @notice that only a-z is allowed
377     * @param _name - string for the name
378     */
379     function _requireNameValid(string memory _name) internal pure {
380         bytes memory tempName = bytes(_name);
381         require(
382             tempName.length >= 2 && tempName.length <= 15,
383             "Name should be greather than or equal to 2 and less than or equal to 15"
384         );
385         for(uint256 i = 0; i < tempName.length; i++) {
386             require(_isLetter(tempName[i]) || _isNumber(tempName[i]), "Invalid Character");
387         }
388     }
389 
390     function _isLetter(bytes1 _char) internal pure returns (bool) {
391         return (_char >= 0x41 && _char <= 0x5A) || (_char >= 0x61 && _char <= 0x7A);
392     }
393 
394     function _isNumber(bytes1 _char) internal pure returns (bool) {
395         return (_char >= 0x30 && _char <= 0x39);
396     }
397 
398 }