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
55 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
56 
57 /**
58  * @title Ownable
59  * @dev The Ownable contract has an owner address, and provides basic authorization control
60  * functions, this simplifies the implementation of "user permissions".
61  */
62 contract Ownable {
63   address public owner;
64 
65 
66   event OwnershipRenounced(address indexed previousOwner);
67   event OwnershipTransferred(
68     address indexed previousOwner,
69     address indexed newOwner
70   );
71 
72 
73   /**
74    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   constructor() public {
78     owner = msg.sender;
79   }
80 
81   /**
82    * @dev Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89   /**
90    * @dev Allows the current owner to relinquish control of the contract.
91    * @notice Renouncing to ownership will leave the contract without an owner.
92    * It will not be possible to call the functions with the `onlyOwner`
93    * modifier anymore.
94    */
95   function renounceOwnership() public onlyOwner {
96     emit OwnershipRenounced(owner);
97     owner = address(0);
98   }
99 
100   /**
101    * @dev Allows the current owner to transfer control of the contract to a newOwner.
102    * @param _newOwner The address to transfer ownership to.
103    */
104   function transferOwnership(address _newOwner) public onlyOwner {
105     _transferOwnership(_newOwner);
106   }
107 
108   /**
109    * @dev Transfers control of the contract to a newOwner.
110    * @param _newOwner The address to transfer ownership to.
111    */
112   function _transferOwnership(address _newOwner) internal {
113     require(_newOwner != address(0));
114     emit OwnershipTransferred(owner, _newOwner);
115     owner = _newOwner;
116   }
117 }
118 
119 // File: openzeppelin-solidity/contracts/lifecycle/Destructible.sol
120 
121 /**
122  * @title Destructible
123  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
124  */
125 contract Destructible is Ownable {
126   /**
127    * @dev Transfers the current balance to the owner and terminates the contract.
128    */
129   function destroy() public onlyOwner {
130     selfdestruct(owner);
131   }
132 
133   function destroyAndSend(address _recipient) public onlyOwner {
134     selfdestruct(_recipient);
135   }
136 }
137 
138 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
139 
140 /**
141  * @title Pausable
142  * @dev Base contract which allows children to implement an emergency stop mechanism.
143  */
144 contract Pausable is Ownable {
145   event Pause();
146   event Unpause();
147 
148   bool public paused = false;
149 
150 
151   /**
152    * @dev Modifier to make a function callable only when the contract is not paused.
153    */
154   modifier whenNotPaused() {
155     require(!paused);
156     _;
157   }
158 
159   /**
160    * @dev Modifier to make a function callable only when the contract is paused.
161    */
162   modifier whenPaused() {
163     require(paused);
164     _;
165   }
166 
167   /**
168    * @dev called by the owner to pause, triggers stopped state
169    */
170   function pause() public onlyOwner whenNotPaused {
171     paused = true;
172     emit Pause();
173   }
174 
175   /**
176    * @dev called by the owner to unpause, returns to normal state
177    */
178   function unpause() public onlyOwner whenPaused {
179     paused = false;
180     emit Unpause();
181   }
182 }
183 
184 // File: openzeppelin-solidity/contracts/ownership/Contactable.sol
185 
186 /**
187  * @title Contactable token
188  * @dev Basic version of a contactable contract, allowing the owner to provide a string with their
189  * contact information.
190  */
191 contract Contactable is Ownable {
192 
193   string public contactInformation;
194 
195   /**
196     * @dev Allows the owner to set a string with their contact information.
197     * @param _info The contact information to attach to the contract.
198     */
199   function setContactInformation(string _info) public onlyOwner {
200     contactInformation = _info;
201   }
202 }
203 
204 // File: monetha-utility-contracts/contracts/Restricted.sol
205 
206 /** @title Restricted
207  *  Exposes onlyMonetha modifier
208  */
209 contract Restricted is Ownable {
210 
211     //MonethaAddress set event
212     event MonethaAddressSet(
213         address _address,
214         bool _isMonethaAddress
215     );
216 
217     mapping (address => bool) public isMonethaAddress;
218 
219     /**
220      *  Restrict methods in such way, that they can be invoked only by monethaAddress account.
221      */
222     modifier onlyMonetha() {
223         require(isMonethaAddress[msg.sender]);
224         _;
225     }
226 
227     /**
228      *  Allows owner to set new monetha address
229      */
230     function setMonethaAddress(address _address, bool _isMonethaAddress) onlyOwner public {
231         isMonethaAddress[_address] = _isMonethaAddress;
232 
233         emit MonethaAddressSet(_address, _isMonethaAddress);
234     }
235 }
236 
237 // File: monetha-loyalty-contracts/contracts/IMonethaVoucher.sol
238 
239 interface IMonethaVoucher {
240     /**
241     * @dev Total number of vouchers in shared pool
242     */
243     function totalInSharedPool() external view returns (uint256);
244 
245     /**
246      * @dev Converts vouchers to equivalent amount of wei.
247      * @param _value amount of vouchers (vouchers) to convert to amount of wei
248      * @return A uint256 specifying the amount of wei.
249      */
250     function toWei(uint256 _value) external view returns (uint256);
251 
252     /**
253      * @dev Converts amount of wei to equivalent amount of vouchers.
254      * @param _value amount of wei to convert to vouchers (vouchers)
255      * @return A uint256 specifying the amount of vouchers.
256      */
257     function fromWei(uint256 _value) external view returns (uint256);
258 
259     /**
260      * @dev Applies discount for address by returning vouchers to shared pool and transferring funds (in wei). May be called only by Monetha.
261      * @param _for address to apply discount for
262      * @param _vouchers amount of vouchers to return to shared pool
263      * @return Actual number of vouchers returned to shared pool and amount of funds (in wei) transferred.
264      */
265     function applyDiscount(address _for, uint256 _vouchers) external returns (uint256 amountVouchers, uint256 amountWei);
266 
267     /**
268      * @dev Applies payback by transferring vouchers from the shared pool to the user.
269      * The amount of transferred vouchers is equivalent to the amount of Ether in the `_amountWei` parameter.
270      * @param _for address to apply payback for
271      * @param _amountWei amount of Ether to estimate the amount of vouchers
272      * @return The number of vouchers added
273      */
274     function applyPayback(address _for, uint256 _amountWei) external returns (uint256 amountVouchers);
275 
276     /**
277      * @dev Function to buy vouchers by transferring equivalent amount in Ether to contract. May be called only by Monetha.
278      * After the vouchers are purchased, they can be sold or released to another user. Purchased vouchers are stored in
279      * a separate pool and may not be expired.
280      * @param _vouchers The amount of vouchers to buy. The caller must also transfer an equivalent amount of Ether.
281      */
282     function buyVouchers(uint256 _vouchers) external payable;
283 
284     /**
285      * @dev The function allows Monetha account to sell previously purchased vouchers and get Ether from the sale.
286      * The equivalent amount of Ether will be transferred to the caller. May be called only by Monetha.
287      * @param _vouchers The amount of vouchers to sell.
288      * @return A uint256 specifying the amount of Ether (in wei) transferred to the caller.
289      */
290     function sellVouchers(uint256 _vouchers) external returns(uint256 weis);
291 
292     /**
293      * @dev Function allows Monetha account to release the purchased vouchers to any address.
294      * The released voucher acquires an expiration property and should be used in Monetha ecosystem within 6 months, otherwise
295      * it will be returned to shared pool. May be called only by Monetha.
296      * @param _to address to release vouchers to.
297      * @param _value the amount of vouchers to release.
298      */
299     function releasePurchasedTo(address _to, uint256 _value) external returns (bool);
300 
301     /**
302      * @dev Function to check the amount of vouchers that an owner (Monetha account) allowed to sell or release to some user.
303      * @param owner The address which owns the funds.
304      * @return A uint256 specifying the amount of vouchers still available for the owner.
305      */
306     function purchasedBy(address owner) external view returns (uint256);
307 }
308 
309 // File: contracts/GenericERC20.sol
310 
311 /**
312 * @title GenericERC20 interface
313 */
314 contract GenericERC20 {
315     function totalSupply() public view returns (uint256);
316 
317     function decimals() public view returns(uint256);
318 
319     function balanceOf(address _who) public view returns (uint256);
320 
321     function allowance(address _owner, address _spender)
322         public view returns (uint256);
323         
324     // Return type not defined intentionally since not all ERC20 tokens return proper result type
325     function transfer(address _to, uint256 _value) public;
326 
327     function approve(address _spender, uint256 _value)
328         public returns (bool);
329 
330     function transferFrom(address _from, address _to, uint256 _value)
331         public returns (bool);
332 
333     event Transfer(
334         address indexed from,
335         address indexed to,
336         uint256 value
337     );
338 
339     event Approval(
340         address indexed owner,
341         address indexed spender,
342         uint256 value
343     );
344 }
345 
346 // File: contracts/MonethaGateway.sol
347 
348 /**
349  *  @title MonethaGateway
350  *
351  *  MonethaGateway forward funds from order payment to merchant's wallet and collects Monetha fee.
352  */
353 contract MonethaGateway is Pausable, Contactable, Destructible, Restricted {
354 
355     using SafeMath for uint256;
356 
357     string constant VERSION = "0.6";
358 
359     /**
360      *  Fee permille of Monetha fee.
361      *  1 permille (‰) = 0.1 percent (%)
362      *  15‰ = 1.5%
363      */
364     uint public constant FEE_PERMILLE = 15;
365 
366 
367     uint public constant PERMILLE_COEFFICIENT = 1000;
368 
369     /**
370      *  Address of Monetha Vault for fee collection
371      */
372     address public monethaVault;
373 
374     /**
375      *  Account for permissions managing
376      */
377     address public admin;
378 
379     /**
380      * Monetha voucher contract
381      */
382     IMonethaVoucher public monethaVoucher;
383 
384     /**
385      *  Max. discount permille.
386      *  10 permille = 1 %
387      */
388     uint public MaxDiscountPermille;
389 
390     event PaymentProcessedEther(address merchantWallet, uint merchantIncome, uint monethaIncome);
391     event PaymentProcessedToken(address tokenAddress, address merchantWallet, uint merchantIncome, uint monethaIncome);
392     event MonethaVoucherChanged(
393         address indexed previousMonethaVoucher,
394         address indexed newMonethaVoucher
395     );
396     event MaxDiscountPermilleChanged(uint prevPermilleValue, uint newPermilleValue);
397 
398     /**
399      *  @param _monethaVault Address of Monetha Vault
400      */
401     constructor(address _monethaVault, address _admin, IMonethaVoucher _monethaVoucher) public {
402         require(_monethaVault != 0x0);
403         monethaVault = _monethaVault;
404 
405         setAdmin(_admin);
406         setMonethaVoucher(_monethaVoucher);
407         setMaxDiscountPermille(700); // 70%
408     }
409 
410     /**
411      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
412      *      and collects Monetha fee.
413      *  @param _merchantWallet address of merchant's wallet for fund transfer
414      *  @param _monethaFee is a fee collected by Monetha
415      */
416     /**
417      *  acceptPayment accept payment from PaymentAcceptor, forwards it to merchant's wallet
418      *      and collects Monetha fee.
419      *  @param _merchantWallet address of merchant's wallet for fund transfer
420      *  @param _monethaFee is a fee collected by Monetha
421      */
422     function acceptPayment(address _merchantWallet,
423         uint _monethaFee,
424         address _customerAddress,
425         uint _vouchersApply,
426         uint _paybackPermille)
427     external payable onlyMonetha whenNotPaused returns (uint discountWei){
428         require(_merchantWallet != 0x0);
429         uint price = msg.value;
430         // Monetha fee cannot be greater than 1.5% of payment
431         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(price).div(1000));
432 
433         discountWei = 0;
434         if (monethaVoucher != address(0)) {
435             if (_vouchersApply > 0 && MaxDiscountPermille > 0) {
436                 uint maxDiscountWei = price.mul(MaxDiscountPermille).div(PERMILLE_COEFFICIENT);
437                 uint maxVouchers = monethaVoucher.fromWei(maxDiscountWei);
438                 // limit vouchers to apply
439                 uint vouchersApply = _vouchersApply;
440                 if (vouchersApply > maxVouchers) {
441                     vouchersApply = maxVouchers;
442                 }
443 
444                 (, discountWei) = monethaVoucher.applyDiscount(_customerAddress, vouchersApply);
445             }
446 
447             if (_paybackPermille > 0) {
448                 uint paybackWei = price.sub(discountWei).mul(_paybackPermille).div(PERMILLE_COEFFICIENT);
449                 if (paybackWei > 0) {
450                     monethaVoucher.applyPayback(_customerAddress, paybackWei);
451                 }
452             }
453         }
454 
455         uint merchantIncome = price.sub(_monethaFee);
456 
457         _merchantWallet.transfer(merchantIncome);
458         monethaVault.transfer(_monethaFee);
459 
460         emit PaymentProcessedEther(_merchantWallet, merchantIncome, _monethaFee);
461     }
462 
463     /**
464      *  acceptTokenPayment accept token payment from PaymentAcceptor, forwards it to merchant's wallet
465      *      and collects Monetha fee.
466      *  @param _merchantWallet address of merchant's wallet for fund transfer
467      *  @param _monethaFee is a fee collected by Monetha
468      *  @param _tokenAddress is the token address
469      *  @param _value is the order value
470      */
471     function acceptTokenPayment(
472         address _merchantWallet,
473         uint _monethaFee,
474         address _tokenAddress,
475         uint _value
476     )
477     external onlyMonetha whenNotPaused
478     {
479         require(_merchantWallet != 0x0);
480 
481         // Monetha fee cannot be greater than 1.5% of payment
482         require(_monethaFee >= 0 && _monethaFee <= FEE_PERMILLE.mul(_value).div(1000));
483 
484         uint merchantIncome = _value.sub(_monethaFee);
485 
486         GenericERC20(_tokenAddress).transfer(_merchantWallet, merchantIncome);
487         GenericERC20(_tokenAddress).transfer(monethaVault, _monethaFee);
488 
489         emit PaymentProcessedToken(_tokenAddress, _merchantWallet, merchantIncome, _monethaFee);
490     }
491 
492     /**
493      *  changeMonethaVault allows owner to change address of Monetha Vault.
494      *  @param newVault New address of Monetha Vault
495      */
496     function changeMonethaVault(address newVault) external onlyOwner whenNotPaused {
497         monethaVault = newVault;
498     }
499 
500     /**
501      *  Allows other monetha account or contract to set new monetha address
502      */
503     function setMonethaAddress(address _address, bool _isMonethaAddress) public {
504         require(msg.sender == admin || msg.sender == owner);
505 
506         isMonethaAddress[_address] = _isMonethaAddress;
507 
508         emit MonethaAddressSet(_address, _isMonethaAddress);
509     }
510 
511     /**
512      *  setAdmin allows owner to change address of admin.
513      *  @param _admin New address of admin
514      */
515     function setAdmin(address _admin) public onlyOwner {
516         require(_admin != address(0));
517         admin = _admin;
518     }
519 
520     /**
521      *  setAdmin allows owner to change address of Monetha voucher contract. If set to 0x0 address, discounts and paybacks are disabled.
522      *  @param _monethaVoucher New address of Monetha voucher contract
523      */
524     function setMonethaVoucher(IMonethaVoucher _monethaVoucher) public onlyOwner {
525         if (monethaVoucher != _monethaVoucher) {
526             emit MonethaVoucherChanged(monethaVoucher, _monethaVoucher);
527             monethaVoucher = _monethaVoucher;
528         }
529     }
530 
531     /**
532      *  setMaxDiscountPermille allows Monetha to change max.discount percentage
533      *  @param _maxDiscountPermille New value of max.discount (in permille)
534      */
535     function setMaxDiscountPermille(uint _maxDiscountPermille) public onlyOwner {
536         require(_maxDiscountPermille <= PERMILLE_COEFFICIENT);
537         emit MaxDiscountPermilleChanged(MaxDiscountPermille, _maxDiscountPermille);
538         MaxDiscountPermille = _maxDiscountPermille;
539     }
540 }