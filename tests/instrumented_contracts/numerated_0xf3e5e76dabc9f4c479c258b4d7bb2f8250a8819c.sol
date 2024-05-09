1 /**
2  *Submitted for verification at Etherscan.io on 2019-07-02
3 */
4 
5 pragma solidity 0.5.7;
6 
7 /**
8  * @title Ownable
9  * @dev The Ownable contract has an owner address, and provides basic authorization control
10  * functions, this simplifies the implementation of "user permissions".
11  */
12 contract Ownable {
13   address payable public owner;
14 
15 
16   event OwnershipRenounced(address indexed previousOwner);
17   event OwnershipTransferred(
18     address indexed previousOwner,
19     address indexed newOwner
20   );
21 
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39   /**
40    * @dev Allows the current owner to relinquish control of the contract.
41    * @notice Renouncing to ownership will leave the contract without an owner.
42    * It will not be possible to call the functions with the `onlyOwner`
43    * modifier anymore.
44    */
45   function renounceOwnership() public onlyOwner {
46     emit OwnershipRenounced(owner);
47     owner = address(0);
48   }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function transferOwnership(address payable _newOwner) public onlyOwner {
55     _transferOwnership(_newOwner);
56   }
57 
58   /**
59    * @dev Transfers control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function _transferOwnership(address payable _newOwner) internal {
63     require(_newOwner != address(0));
64     emit OwnershipTransferred(owner, _newOwner);
65     owner = _newOwner;
66   }
67 }
68 
69 /**
70  * @title SafeMath
71  * @dev Math operations with safety checks that revert on error
72  */
73 library SafeMath {
74 
75   /**
76   * @dev Multiplies two numbers, reverts on overflow.
77   */
78   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
79     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80     // benefit is lost if 'b' is also tested.
81     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
82     if (_a == 0) {
83       return 0;
84     }
85 
86     uint256 c = _a * _b;
87     require(c / _a == _b);
88 
89     return c;
90   }
91 
92   /**
93   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
94   */
95   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
96     require(_b > 0); // Solidity only automatically asserts when dividing by 0
97     uint256 c = _a / _b;
98     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
99 
100     return c;
101   }
102 
103   /**
104   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
107     require(_b <= _a);
108     uint256 c = _a - _b;
109 
110     return c;
111   }
112 
113   /**
114   * @dev Adds two numbers, reverts on overflow.
115   */
116   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
117     uint256 c = _a + _b;
118     require(c >= _a);
119 
120     return c;
121   }
122 
123   /**
124   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
125   * reverts when dividing by zero.
126   */
127   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
128     require(b != 0);
129     return a % b;
130   }
131 }
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 {
138   function totalSupply() public view returns (uint256);
139 
140   function balanceOf(address _who) public view returns (uint256);
141 
142   function allowance(address _owner, address _spender)
143     public view returns (uint256);
144 
145   function transfer(address _to, uint256 _value) public returns (bool);
146 
147   function approve(address _spender, uint256 _value)
148     public returns (bool);
149 
150   function transferFrom(address _from, address _to, uint256 _value)
151     public returns (bool);
152 
153   function decimals() public view returns (uint256);
154 
155   event Transfer(
156     address indexed from,
157     address indexed to,
158     uint256 value
159   );
160 
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 library ERC20SafeTransfer {
169     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
170         (success,) = _tokenAddress.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
171         require(success, "Transfer failed");
172 
173         return fetchReturnData();
174     }
175 
176     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
177         (success,) = _tokenAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
178         require(success, "Transfer From failed");
179 
180         return fetchReturnData();
181     }
182 
183     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
184         (success,) = _tokenAddress.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
185         require(success,  "Approve failed");
186 
187         return fetchReturnData();
188     }
189 
190     function fetchReturnData() internal pure returns (bool success){
191         assembly {
192             switch returndatasize()
193             case 0 {
194                 success := 1
195             }
196             case 32 {
197                 returndatacopy(0, 0, 32)
198                 success := mload(0)
199             }
200             default {
201                 revert(0, 0)
202             }
203         }
204     }
205 
206 }
207 
208 /*
209     Modified Util contract as used by Kyber Network
210 */
211 
212 library Utils {
213 
214     uint256 constant internal PRECISION = (10**18);
215     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
216     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
217     uint256 constant internal MAX_DECIMALS = 18;
218     uint256 constant internal ETH_DECIMALS = 18;
219     uint256 constant internal MAX_UINT = 2**256-1;
220     address constant internal ETH_ADDRESS = address(0x0);
221 
222     // Currently constants can't be accessed from other contracts, so providing functions to do that here
223     function precision() internal pure returns (uint256) { return PRECISION; }
224     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
225     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
226     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
227     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
228     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
229     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
230 
231     /// @notice Retrieve the number of decimals used for a given ERC20 token
232     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
233     /// ensure that an exception doesn't cause transaction failure
234     /// @param token the token for which we should retrieve the decimals
235     /// @return decimals the number of decimals in the given token
236     function getDecimals(address token)
237         internal
238         returns (uint256 decimals)
239     {
240         bytes4 functionSig = bytes4(keccak256("decimals()"));
241 
242         /// @dev Using assembly due to issues with current solidity `address.call()`
243         /// implementation: https://github.com/ethereum/solidity/issues/2884
244         assembly {
245             // Pointer to next free memory slot
246             let ptr := mload(0x40)
247             // Store functionSig variable at ptr
248             mstore(ptr,functionSig)
249             let functionSigLength := 0x04
250             let wordLength := 0x20
251 
252             let success := call(
253                                 5000, // Amount of gas
254                                 token, // Address to call
255                                 0, // ether to send
256                                 ptr, // ptr to input data
257                                 functionSigLength, // size of data
258                                 ptr, // where to store output data (overwrite input)
259                                 wordLength // size of output data (32 bytes)
260                                )
261 
262             switch success
263             case 0 {
264                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
265             }
266             case 1 {
267                 decimals := mload(ptr) // Set decimals to return data from call
268             }
269             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
270         }
271     }
272 
273     /// @dev Checks that a given address has its token allowance and balance set above the given amount
274     /// @param tokenOwner the address which should have custody of the token
275     /// @param tokenAddress the address of the token to check
276     /// @param tokenAmount the amount of the token which should be set
277     /// @param addressToAllow the address which should be allowed to transfer the token
278     /// @return bool true if the allowance and balance is set, false if not
279     function tokenAllowanceAndBalanceSet(
280         address tokenOwner,
281         address tokenAddress,
282         uint256 tokenAmount,
283         address addressToAllow
284     )
285         internal
286         view
287         returns (bool)
288     {
289         return (
290             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
291             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
292         );
293     }
294 
295     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
296         if (dstDecimals >= srcDecimals) {
297             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
298             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
299         } else {
300             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
301             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
302         }
303     }
304 
305     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
306 
307         //source quantity is rounded up. to avoid dest quantity being too low.
308         uint numerator;
309         uint denominator;
310         if (srcDecimals >= dstDecimals) {
311             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
312             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
313             denominator = rate;
314         } else {
315             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
316             numerator = (PRECISION * dstQty);
317             denominator = (rate * (10**(dstDecimals - srcDecimals)));
318         }
319         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
320     }
321 
322     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
323         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
324     }
325 
326     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
327         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
328     }
329 
330     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
331         internal pure returns (uint)
332     {
333         require(srcAmount <= MAX_QTY);
334         require(destAmount <= MAX_QTY);
335 
336         if (dstDecimals >= srcDecimals) {
337             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
338             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
339         } else {
340             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
341             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
342         }
343     }
344 
345     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
346     function min(uint256 a, uint256 b) internal pure returns (uint256) {
347         return a < b ? a : b;
348     }
349 }
350 
351 contract Partner {
352 
353     address payable public partnerBeneficiary;
354     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
355 
356     uint256 public companyPercentage;
357     address payable public companyBeneficiary;
358 
359     event LogPayout(
360         address token,
361         uint256 partnerAmount,
362         uint256 companyAmount
363     );
364 
365     function init(
366         address payable _companyBeneficiary,
367         uint256 _companyPercentage,
368         address payable _partnerBeneficiary,
369         uint256 _partnerPercentage
370     ) public {
371         require(companyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0));
372         companyBeneficiary = _companyBeneficiary;
373         companyPercentage = _companyPercentage;
374         partnerBeneficiary = _partnerBeneficiary;
375         partnerPercentage = _partnerPercentage;
376     }
377 
378     function payout(
379         address[] memory tokens
380     ) public {
381         // Payout both the partner and the company at the same time
382         for(uint256 index = 0; index<tokens.length; index++){
383             uint256 balance = tokens[index] == Utils.eth_address()? address(this).balance : ERC20(tokens[index]).balanceOf(address(this));
384             uint256 partnerAmount = SafeMath.div(SafeMath.mul(balance, partnerPercentage), getTotalFeePercentage());
385             uint256 companyAmount = balance - partnerAmount;
386             if(tokens[index] == Utils.eth_address()){
387                 partnerBeneficiary.transfer(partnerAmount);
388                 companyBeneficiary.transfer(companyAmount);
389             } else {
390                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
391                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
392             }
393         }
394     }
395 
396     function getTotalFeePercentage() public view returns (uint256){
397         return partnerPercentage + companyPercentage;
398     }
399 
400     function() external payable {
401 
402     }
403 }
404 
405 contract PartnerRegistry is Ownable {
406 
407     address target;
408     mapping(address => bool) partnerContracts;
409     address payable public companyBeneficiary;
410     uint256 public companyPercentage;
411 
412     event PartnerRegistered(address indexed creator, address indexed beneficiary, address partnerContract);
413 
414 
415     constructor(address _target, address payable _companyBeneficiary, uint256 _companyPercentage) public {
416         target = _target;
417         companyBeneficiary = _companyBeneficiary;
418         companyPercentage = _companyPercentage;
419     }
420 
421     function registerPartner(address payable partnerBeneficiary, uint256 partnerPercentage) external {
422         Partner newPartner = Partner(createClone());
423         newPartner.init(companyBeneficiary, companyPercentage, partnerBeneficiary, partnerPercentage);
424         partnerContracts[address(newPartner)] = true;
425         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
426     }
427 
428     function overrideRegisterPartner(
429         address payable _companyBeneficiary,
430         uint256 _companyPercentage,
431         address payable partnerBeneficiary,
432         uint256 partnerPercentage
433     ) external onlyOwner {
434         Partner newPartner = Partner(createClone());
435         newPartner.init(_companyBeneficiary, _companyPercentage, partnerBeneficiary, partnerPercentage);
436         partnerContracts[address(newPartner)] = true;
437         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
438     }
439 
440     function deletePartner(address _partnerAddress) public onlyOwner {
441         partnerContracts[_partnerAddress] = false;
442     }
443 
444     function createClone() internal returns (address payable result) {
445         bytes20 targetBytes = bytes20(target);
446         assembly {
447             let clone := mload(0x40)
448             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
449             mstore(add(clone, 0x14), targetBytes)
450             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
451             result := create(0, clone, 0x37)
452         }
453     }
454 
455     function isValidPartner(address partnerContract) public view returns(bool) {
456         return partnerContracts[partnerContract];
457     }
458 
459     function updateCompanyInfo(address payable newCompanyBeneficiary, uint256 newCompanyPercentage) public onlyOwner {
460         companyBeneficiary = newCompanyBeneficiary;
461         companyPercentage = newCompanyPercentage;
462     }
463 }