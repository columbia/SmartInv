1 pragma solidity 0.5.7;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address payable public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    * @notice Renouncing to ownership will leave the contract without an owner.
38    * It will not be possible to call the functions with the `onlyOwner`
39    * modifier anymore.
40    */
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipRenounced(owner);
43     owner = address(0);
44   }
45 
46   /**
47    * @dev Allows the current owner to transfer control of the contract to a newOwner.
48    * @param _newOwner The address to transfer ownership to.
49    */
50   function transferOwnership(address payable _newOwner) public onlyOwner {
51     _transferOwnership(_newOwner);
52   }
53 
54   /**
55    * @dev Transfers control of the contract to a newOwner.
56    * @param _newOwner The address to transfer ownership to.
57    */
58   function _transferOwnership(address payable _newOwner) internal {
59     require(_newOwner != address(0));
60     emit OwnershipTransferred(owner, _newOwner);
61     owner = _newOwner;
62   }
63 }
64 
65 /**
66  * @title SafeMath
67  * @dev Math operations with safety checks that revert on error
68  */
69 library SafeMath {
70 
71   /**
72   * @dev Multiplies two numbers, reverts on overflow.
73   */
74   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
75     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76     // benefit is lost if 'b' is also tested.
77     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78     if (_a == 0) {
79       return 0;
80     }
81 
82     uint256 c = _a * _b;
83     require(c / _a == _b);
84 
85     return c;
86   }
87 
88   /**
89   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
90   */
91   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
92     require(_b > 0); // Solidity only automatically asserts when dividing by 0
93     uint256 c = _a / _b;
94     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
95 
96     return c;
97   }
98 
99   /**
100   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
101   */
102   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
103     require(_b <= _a);
104     uint256 c = _a - _b;
105 
106     return c;
107   }
108 
109   /**
110   * @dev Adds two numbers, reverts on overflow.
111   */
112   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
113     uint256 c = _a + _b;
114     require(c >= _a);
115 
116     return c;
117   }
118 
119   /**
120   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
121   * reverts when dividing by zero.
122   */
123   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
124     require(b != 0);
125     return a % b;
126   }
127 }
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 {
134   function totalSupply() public view returns (uint256);
135 
136   function balanceOf(address _who) public view returns (uint256);
137 
138   function allowance(address _owner, address _spender)
139     public view returns (uint256);
140 
141   function transfer(address _to, uint256 _value) public returns (bool);
142 
143   function approve(address _spender, uint256 _value)
144     public returns (bool);
145 
146   function transferFrom(address _from, address _to, uint256 _value)
147     public returns (bool);
148 
149   function decimals() public view returns (uint256);
150 
151   event Transfer(
152     address indexed from,
153     address indexed to,
154     uint256 value
155   );
156 
157   event Approval(
158     address indexed owner,
159     address indexed spender,
160     uint256 value
161   );
162 }
163 
164 library ERC20SafeTransfer {
165     function safeTransfer(address _tokenAddress, address _to, uint256 _value) internal returns (bool success) {
166         (success,) = _tokenAddress.call(abi.encodeWithSignature("transfer(address,uint256)", _to, _value));
167         require(success, "Transfer failed");
168 
169         return fetchReturnData();
170     }
171 
172     function safeTransferFrom(address _tokenAddress, address _from, address _to, uint256 _value) internal returns (bool success) {
173         (success,) = _tokenAddress.call(abi.encodeWithSignature("transferFrom(address,address,uint256)", _from, _to, _value));
174         require(success, "Transfer From failed");
175 
176         return fetchReturnData();
177     }
178 
179     function safeApprove(address _tokenAddress, address _spender, uint256 _value) internal returns (bool success) {
180         (success,) = _tokenAddress.call(abi.encodeWithSignature("approve(address,uint256)", _spender, _value));
181         require(success,  "Approve failed");
182 
183         return fetchReturnData();
184     }
185 
186     function fetchReturnData() internal pure returns (bool success){
187         assembly {
188             switch returndatasize()
189             case 0 {
190                 success := 1
191             }
192             case 32 {
193                 returndatacopy(0, 0, 32)
194                 success := mload(0)
195             }
196             default {
197                 revert(0, 0)
198             }
199         }
200     }
201 
202 }
203 
204 /*
205     Modified Util contract as used by Kyber Network
206 */
207 
208 library Utils {
209 
210     uint256 constant internal PRECISION = (10**18);
211     uint256 constant internal MAX_QTY   = (10**28); // 10B tokens
212     uint256 constant internal MAX_RATE  = (PRECISION * 10**6); // up to 1M tokens per ETH
213     uint256 constant internal MAX_DECIMALS = 18;
214     uint256 constant internal ETH_DECIMALS = 18;
215     uint256 constant internal MAX_UINT = 2**256-1;
216     address constant internal ETH_ADDRESS = address(0x0);
217 
218     // Currently constants can't be accessed from other contracts, so providing functions to do that here
219     function precision() internal pure returns (uint256) { return PRECISION; }
220     function max_qty() internal pure returns (uint256) { return MAX_QTY; }
221     function max_rate() internal pure returns (uint256) { return MAX_RATE; }
222     function max_decimals() internal pure returns (uint256) { return MAX_DECIMALS; }
223     function eth_decimals() internal pure returns (uint256) { return ETH_DECIMALS; }
224     function max_uint() internal pure returns (uint256) { return MAX_UINT; }
225     function eth_address() internal pure returns (address) { return ETH_ADDRESS; }
226 
227     /// @notice Retrieve the number of decimals used for a given ERC20 token
228     /// @dev As decimals are an optional feature in ERC20, this contract uses `call` to
229     /// ensure that an exception doesn't cause transaction failure
230     /// @param token the token for which we should retrieve the decimals
231     /// @return decimals the number of decimals in the given token
232     function getDecimals(address token)
233         internal
234         returns (uint256 decimals)
235     {
236         bytes4 functionSig = bytes4(keccak256("decimals()"));
237 
238         /// @dev Using assembly due to issues with current solidity `address.call()`
239         /// implementation: https://github.com/ethereum/solidity/issues/2884
240         assembly {
241             // Pointer to next free memory slot
242             let ptr := mload(0x40)
243             // Store functionSig variable at ptr
244             mstore(ptr,functionSig)
245             let functionSigLength := 0x04
246             let wordLength := 0x20
247 
248             let success := call(
249                                 5000, // Amount of gas
250                                 token, // Address to call
251                                 0, // ether to send
252                                 ptr, // ptr to input data
253                                 functionSigLength, // size of data
254                                 ptr, // where to store output data (overwrite input)
255                                 wordLength // size of output data (32 bytes)
256                                )
257 
258             switch success
259             case 0 {
260                 decimals := 0 // If the token doesn't implement `decimals()`, return 0 as default
261             }
262             case 1 {
263                 decimals := mload(ptr) // Set decimals to return data from call
264             }
265             mstore(0x40,add(ptr,0x04)) // Reset the free memory pointer to the next known free location
266         }
267     }
268 
269     /// @dev Checks that a given address has its token allowance and balance set above the given amount
270     /// @param tokenOwner the address which should have custody of the token
271     /// @param tokenAddress the address of the token to check
272     /// @param tokenAmount the amount of the token which should be set
273     /// @param addressToAllow the address which should be allowed to transfer the token
274     /// @return bool true if the allowance and balance is set, false if not
275     function tokenAllowanceAndBalanceSet(
276         address tokenOwner,
277         address tokenAddress,
278         uint256 tokenAmount,
279         address addressToAllow
280     )
281         internal
282         view
283         returns (bool)
284     {
285         return (
286             ERC20(tokenAddress).allowance(tokenOwner, addressToAllow) >= tokenAmount &&
287             ERC20(tokenAddress).balanceOf(tokenOwner) >= tokenAmount
288         );
289     }
290 
291     function calcDstQty(uint srcQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
292         if (dstDecimals >= srcDecimals) {
293             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
294             return (srcQty * rate * (10**(dstDecimals - srcDecimals))) / PRECISION;
295         } else {
296             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
297             return (srcQty * rate) / (PRECISION * (10**(srcDecimals - dstDecimals)));
298         }
299     }
300 
301     function calcSrcQty(uint dstQty, uint srcDecimals, uint dstDecimals, uint rate) internal pure returns (uint) {
302 
303         //source quantity is rounded up. to avoid dest quantity being too low.
304         uint numerator;
305         uint denominator;
306         if (srcDecimals >= dstDecimals) {
307             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
308             numerator = (PRECISION * dstQty * (10**(srcDecimals - dstDecimals)));
309             denominator = rate;
310         } else {
311             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
312             numerator = (PRECISION * dstQty);
313             denominator = (rate * (10**(dstDecimals - srcDecimals)));
314         }
315         return (numerator + denominator - 1) / denominator; //avoid rounding down errors
316     }
317 
318     function calcDestAmount(ERC20 src, ERC20 dest, uint srcAmount, uint rate) internal returns (uint) {
319         return calcDstQty(srcAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
320     }
321 
322     function calcSrcAmount(ERC20 src, ERC20 dest, uint destAmount, uint rate) internal returns (uint) {
323         return calcSrcQty(destAmount, getDecimals(address(src)), getDecimals(address(dest)), rate);
324     }
325 
326     function calcRateFromQty(uint srcAmount, uint destAmount, uint srcDecimals, uint dstDecimals)
327         internal pure returns (uint)
328     {
329         require(srcAmount <= MAX_QTY);
330         require(destAmount <= MAX_QTY);
331 
332         if (dstDecimals >= srcDecimals) {
333             require((dstDecimals - srcDecimals) <= MAX_DECIMALS);
334             return (destAmount * PRECISION / ((10 ** (dstDecimals - srcDecimals)) * srcAmount));
335         } else {
336             require((srcDecimals - dstDecimals) <= MAX_DECIMALS);
337             return (destAmount * PRECISION * (10 ** (srcDecimals - dstDecimals)) / srcAmount);
338         }
339     }
340 
341     /// @notice Bringing this in from the Math library as we've run out of space in TotlePrimary (see EIP-170)
342     function min(uint256 a, uint256 b) internal pure returns (uint256) {
343         return a < b ? a : b;
344     }
345 }
346 
347 contract Partner {
348 
349     address payable public partnerBeneficiary;
350     uint256 public partnerPercentage; //This is out of 1 ETH, e.g. 0.5 ETH is 50% of the fee
351 
352     uint256 public companyPercentage;
353     address payable public companyBeneficiary;
354 
355     event LogPayout(
356         address token,
357         uint256 partnerAmount,
358         uint256 companyAmount
359     );
360 
361     function init(
362         address payable _companyBeneficiary,
363         uint256 _companyPercentage,
364         address payable _partnerBeneficiary,
365         uint256 _partnerPercentage
366     ) public {
367         require(companyBeneficiary == address(0x0) && partnerBeneficiary == address(0x0));
368         companyBeneficiary = _companyBeneficiary;
369         companyPercentage = _companyPercentage;
370         partnerBeneficiary = _partnerBeneficiary;
371         partnerPercentage = _partnerPercentage;
372     }
373 
374     function payout(
375         address[] memory tokens
376     ) public {
377         // Payout both the partner and the company at the same time
378         for(uint256 index = 0; index<tokens.length; index++){
379             uint256 balance = tokens[index] == Utils.eth_address()? address(this).balance : ERC20(tokens[index]).balanceOf(address(this));
380             uint256 partnerAmount = SafeMath.div(SafeMath.mul(balance, partnerPercentage), getTotalFeePercentage());
381             uint256 companyAmount = balance - partnerAmount;
382             if(tokens[index] == Utils.eth_address()){
383                 partnerBeneficiary.transfer(partnerAmount);
384                 companyBeneficiary.transfer(companyAmount);
385             } else {
386                 ERC20SafeTransfer.safeTransfer(tokens[index], partnerBeneficiary, partnerAmount);
387                 ERC20SafeTransfer.safeTransfer(tokens[index], companyBeneficiary, companyAmount);
388             }
389         }
390     }
391 
392     function getTotalFeePercentage() public view returns (uint256){
393         return partnerPercentage + companyPercentage;
394     }
395 
396     function() external payable {
397 
398     }
399 }
400 
401 contract PartnerRegistry is Ownable {
402 
403     address target;
404     mapping(address => bool) partnerContracts;
405     address payable public companyBeneficiary;
406     uint256 public companyPercentage;
407 
408     event PartnerRegistered(address indexed creator, address indexed beneficiary, address partnerContract);
409 
410 
411     constructor(address _target, address payable _companyBeneficiary, uint256 _companyPercentage) public {
412         target = _target;
413         companyBeneficiary = _companyBeneficiary;
414         companyPercentage = _companyPercentage;
415     }
416 
417     function registerPartner(address payable partnerBeneficiary, uint256 partnerPercentage) external {
418         Partner newPartner = Partner(createClone());
419         newPartner.init(companyBeneficiary, companyPercentage, partnerBeneficiary, partnerPercentage);
420         partnerContracts[address(newPartner)] = true;
421         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
422     }
423 
424     function overrideRegisterPartner(
425         address payable _companyBeneficiary,
426         uint256 _companyPercentage,
427         address payable partnerBeneficiary,
428         uint256 partnerPercentage
429     ) external onlyOwner {
430         Partner newPartner = Partner(createClone());
431         newPartner.init(_companyBeneficiary, _companyPercentage, partnerBeneficiary, partnerPercentage);
432         partnerContracts[address(newPartner)] = true;
433         emit PartnerRegistered(address(msg.sender), partnerBeneficiary, address(newPartner));
434     }
435 
436     function deletePartner(address _partnerAddress) public onlyOwner {
437         partnerContracts[_partnerAddress] = false;
438     }
439 
440     function createClone() internal returns (address payable result) {
441         bytes20 targetBytes = bytes20(target);
442         assembly {
443             let clone := mload(0x40)
444             mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
445             mstore(add(clone, 0x14), targetBytes)
446             mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
447             result := create(0, clone, 0x37)
448         }
449     }
450 
451     function isValidPartner(address partnerContract) public view returns(bool) {
452         return partnerContracts[partnerContract];
453     }
454 
455     function updateCompanyInfo(address payable newCompanyBeneficiary, uint256 newCompanyPercentage) public onlyOwner {
456         companyBeneficiary = newCompanyBeneficiary;
457         companyPercentage = newCompanyPercentage;
458     }
459 }