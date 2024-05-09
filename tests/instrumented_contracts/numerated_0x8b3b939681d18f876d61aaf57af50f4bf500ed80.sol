1 pragma solidity ^0.4.24;
2 
3 // File: node_modules\zeppelin-solidity\contracts\math\Math.sol
4 
5 /**
6  * @title Math
7  * @dev Assorted math operations
8  */
9 library Math {
10   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
11     return a >= b ? a : b;
12   }
13 
14   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
15     return a < b ? a : b;
16   }
17 
18   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
19     return a >= b ? a : b;
20   }
21 
22   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
23     return a < b ? a : b;
24   }
25 }
26 
27 // File: node_modules\zeppelin-solidity\contracts\ownership\Ownable.sol
28 
29 /**
30  * @title Ownable
31  * @dev The Ownable contract has an owner address, and provides basic authorization control
32  * functions, this simplifies the implementation of "user permissions".
33  */
34 contract Ownable {
35   address public owner;
36 
37 
38   event OwnershipRenounced(address indexed previousOwner);
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44 
45   /**
46    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
47    * account.
48    */
49   constructor() public {
50     owner = msg.sender;
51   }
52 
53   /**
54    * @dev Throws if called by any account other than the owner.
55    */
56   modifier onlyOwner() {
57     require(msg.sender == owner);
58     _;
59   }
60 
61   /**
62    * @dev Allows the current owner to relinquish control of the contract.
63    * @notice Renouncing to ownership will leave the contract without an owner.
64    * It will not be possible to call the functions with the `onlyOwner`
65    * modifier anymore.
66    */
67   function renounceOwnership() public onlyOwner {
68     emit OwnershipRenounced(owner);
69     owner = address(0);
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param _newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address _newOwner) public onlyOwner {
77     _transferOwnership(_newOwner);
78   }
79 
80   /**
81    * @dev Transfers control of the contract to a newOwner.
82    * @param _newOwner The address to transfer ownership to.
83    */
84   function _transferOwnership(address _newOwner) internal {
85     require(_newOwner != address(0));
86     emit OwnershipTransferred(owner, _newOwner);
87     owner = _newOwner;
88   }
89 }
90 
91 // File: node_modules\zeppelin-solidity\contracts\math\SafeMath.sol
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, throws on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
103     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     c = a * b;
111     assert(c / a == b);
112     return c;
113   }
114 
115   /**
116   * @dev Integer division of two numbers, truncating the quotient.
117   */
118   function div(uint256 a, uint256 b) internal pure returns (uint256) {
119     // assert(b > 0); // Solidity automatically throws when dividing by 0
120     // uint256 c = a / b;
121     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122     return a / b;
123   }
124 
125   /**
126   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
127   */
128   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129     assert(b <= a);
130     return a - b;
131   }
132 
133   /**
134   * @dev Adds two numbers, throws on overflow.
135   */
136   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
137     c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 // File: node_modules\zeppelin-solidity\contracts\payment\Escrow.sol
144 
145 /**
146  * @title Escrow
147  * @dev Base escrow contract, holds funds destinated to a payee until they
148  * withdraw them. The contract that uses the escrow as its payment method
149  * should be its owner, and provide public methods redirecting to the escrow's
150  * deposit and withdraw.
151  */
152 contract Escrow is Ownable {
153   using SafeMath for uint256;
154 
155   event Deposited(address indexed payee, uint256 weiAmount);
156   event Withdrawn(address indexed payee, uint256 weiAmount);
157 
158   mapping(address => uint256) private deposits;
159 
160   function depositsOf(address _payee) public view returns (uint256) {
161     return deposits[_payee];
162   }
163 
164   /**
165   * @dev Stores the sent amount as credit to be withdrawn.
166   * @param _payee The destination address of the funds.
167   */
168   function deposit(address _payee) public onlyOwner payable {
169     uint256 amount = msg.value;
170     deposits[_payee] = deposits[_payee].add(amount);
171 
172     emit Deposited(_payee, amount);
173   }
174 
175   /**
176   * @dev Withdraw accumulated balance for a payee.
177   * @param _payee The address whose funds will be withdrawn and transferred to.
178   */
179   function withdraw(address _payee) public onlyOwner {
180     uint256 payment = deposits[_payee];
181     assert(address(this).balance >= payment);
182 
183     deposits[_payee] = 0;
184 
185     _payee.transfer(payment);
186 
187     emit Withdrawn(_payee, payment);
188   }
189 }
190 
191 // File: node_modules\zeppelin-solidity\contracts\payment\ConditionalEscrow.sol
192 
193 /**
194  * @title ConditionalEscrow
195  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
196  */
197 contract ConditionalEscrow is Escrow {
198   /**
199   * @dev Returns whether an address is allowed to withdraw their funds. To be
200   * implemented by derived contracts.
201   * @param _payee The destination address of the funds.
202   */
203   function withdrawalAllowed(address _payee) public view returns (bool);
204 
205   function withdraw(address _payee) public {
206     require(withdrawalAllowed(_payee));
207     super.withdraw(_payee);
208   }
209 }
210 
211 // File: node_modules\zeppelin-solidity\contracts\payment\RefundEscrow.sol
212 
213 /**
214  * @title RefundEscrow
215  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
216  * The contract owner may close the deposit period, and allow for either withdrawal
217  * by the beneficiary, or refunds to the depositors.
218  */
219 contract RefundEscrow is Ownable, ConditionalEscrow {
220   enum State { Active, Refunding, Closed }
221 
222   event Closed();
223   event RefundsEnabled();
224 
225   State public state;
226   address public beneficiary;
227 
228   /**
229    * @dev Constructor.
230    * @param _beneficiary The beneficiary of the deposits.
231    */
232   constructor(address _beneficiary) public {
233     require(_beneficiary != address(0));
234     beneficiary = _beneficiary;
235     state = State.Active;
236   }
237 
238   /**
239    * @dev Stores funds that may later be refunded.
240    * @param _refundee The address funds will be sent to if a refund occurs.
241    */
242   function deposit(address _refundee) public payable {
243     require(state == State.Active);
244     super.deposit(_refundee);
245   }
246 
247   /**
248    * @dev Allows for the beneficiary to withdraw their funds, rejecting
249    * further deposits.
250    */
251   function close() public onlyOwner {
252     require(state == State.Active);
253     state = State.Closed;
254     emit Closed();
255   }
256 
257   /**
258    * @dev Allows for refunds to take place, rejecting further deposits.
259    */
260   function enableRefunds() public onlyOwner {
261     require(state == State.Active);
262     state = State.Refunding;
263     emit RefundsEnabled();
264   }
265 
266   /**
267    * @dev Withdraws the beneficiary's funds.
268    */
269   function beneficiaryWithdraw() public {
270     require(state == State.Closed);
271     beneficiary.transfer(address(this).balance);
272   }
273 
274   /**
275    * @dev Returns whether refundees can withdraw their deposits (be refunded).
276    */
277   function withdrawalAllowed(address _payee) public view returns (bool) {
278     return state == State.Refunding;
279   }
280 }
281 
282 // File: contracts\ClinicAllRefundEscrow.sol
283 
284 /**
285  * @title ClinicAllRefundEscrow
286  * @dev Escrow that holds funds for a beneficiary, deposited from multiple parties.
287  * The contract owner may close the deposit period, and allow for either withdrawal
288  * by the beneficiary, or refunds to the depositors.
289  */
290 contract ClinicAllRefundEscrow is RefundEscrow {
291   using Math for uint256;
292 
293   struct RefundeeRecord {
294     bool isRefunded;
295     uint256 index;
296   }
297 
298   mapping(address => RefundeeRecord) public refundees;
299   address[] internal refundeesList;
300 
301   event Deposited(address indexed payee, uint256 weiAmount);
302   event Withdrawn(address indexed payee, uint256 weiAmount);
303 
304   mapping(address => uint256) private deposits;
305   mapping(address => uint256) private beneficiaryDeposits;
306 
307   // Amount of wei deposited by beneficiary
308   uint256 public beneficiaryDepositedAmount;
309 
310   // Amount of wei deposited by investors to CrowdSale
311   uint256 public investorsDepositedToCrowdSaleAmount;
312 
313   /**
314    * @dev Constructor.
315    * @param _beneficiary The beneficiary of the deposits.
316    */
317   constructor(address _beneficiary)
318   RefundEscrow(_beneficiary)
319   public {
320   }
321 
322   function depositsOf(address _payee) public view returns (uint256) {
323     return deposits[_payee];
324   }
325 
326   function beneficiaryDepositsOf(address _payee) public view returns (uint256) {
327     return beneficiaryDeposits[_payee];
328   }
329 
330 
331 
332   /**
333    * @dev Stores funds that may later be refunded.
334    * @param _refundee The address funds will be sent to if a refund occurs.
335    */
336   function deposit(address _refundee) public payable {
337     uint256 amount = msg.value;
338     beneficiaryDeposits[_refundee] = beneficiaryDeposits[_refundee].add(amount);
339     beneficiaryDepositedAmount = beneficiaryDepositedAmount.add(amount);
340   }
341 
342   /**
343  * @dev Stores funds that may later be refunded.
344  * @param _refundee The address funds will be sent to if a refund occurs.
345  * @param _value The amount of funds will be sent to if a refund occurs.
346  */
347   function depositFunds(address _refundee, uint256 _value) public onlyOwner {
348     require(state == State.Active, "Funds deposition is possible only in the Active state.");
349 
350     uint256 amount = _value;
351     deposits[_refundee] = deposits[_refundee].add(amount);
352     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.add(amount);
353 
354     emit Deposited(_refundee, amount);
355 
356     RefundeeRecord storage _data = refundees[_refundee];
357     _data.isRefunded = false;
358 
359     if (_data.index == uint256(0)) {
360       refundeesList.push(_refundee);
361       _data.index = refundeesList.length.sub(1);
362     }
363   }
364 
365   /**
366   * @dev Allows for the beneficiary to withdraw their funds, rejecting
367   * further deposits.
368   */
369   function close() public onlyOwner {
370     super.close();
371   }
372 
373   function withdraw(address _payee) public onlyOwner {
374     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
375     require(depositsOf(_payee) > 0, "An investor should have non-negative deposit for withdrawal.");
376 
377     RefundeeRecord storage _data = refundees[_payee];
378     require(_data.isRefunded == false, "An investor should not be refunded.");
379 
380     uint256 payment = deposits[_payee];
381     assert(address(this).balance >= payment);
382 
383     deposits[_payee] = 0;
384 
385     investorsDepositedToCrowdSaleAmount = investorsDepositedToCrowdSaleAmount.sub(payment);
386 
387     _payee.transfer(payment);
388 
389     emit Withdrawn(_payee, payment);
390 
391     _data.isRefunded = true;
392 
393     removeRefundeeByIndex(_data.index);
394   }
395 
396   /**
397   @dev Owner can do manual refund here if investore has "BAD" money
398   @param _payee address of investor that needs to refund with next manual ETH sending
399   */
400   function manualRefund(address _payee) public onlyOwner {
401     require(depositsOf(_payee) > 0, "An investor should have non-negative deposit for withdrawal.");
402 
403     RefundeeRecord storage _data = refundees[_payee];
404     require(_data.isRefunded == false, "An investor should not be refunded.");
405 
406     deposits[_payee] = 0;
407     _data.isRefunded = true;
408 
409     removeRefundeeByIndex(_data.index);
410   }
411 
412   /**
413   * @dev Remove refundee referenced index from the internal list
414   * @param _indexToDelete An index in an array for deletion
415   */
416   function removeRefundeeByIndex(uint256 _indexToDelete) private {
417     if ((refundeesList.length > 0) && (_indexToDelete < refundeesList.length)) {
418       uint256 _lastIndex = refundeesList.length.sub(1);
419       refundeesList[_indexToDelete] = refundeesList[_lastIndex];
420       refundeesList.length--;
421     }
422   }
423   /**
424   * @dev Get refundee list length
425   */
426   function refundeesListLength() public onlyOwner view returns (uint256) {
427     return refundeesList.length;
428   }
429 
430   /**
431   * @dev Auto refund
432   * @param _txFee The cost of executing refund code
433   */
434   function withdrawChunk(uint256 _txFee, uint256 _chunkLength) public onlyOwner returns (uint256, address[]) {
435     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
436 
437     uint256 _refundeesCount = refundeesList.length;
438     require(_chunkLength >= _refundeesCount);
439     require(_txFee > 0, "Transaction fee should be above zero.");
440     require(_refundeesCount > 0, "List of investors should not be empty.");
441     uint256 _weiRefunded = 0;
442     require(address(this).balance > (_chunkLength.mul(_txFee)), "Account's ballance should allow to pay all tx fees.");
443     address[] memory _refundeesListCopy = new address[](_chunkLength);
444 
445     uint256 i;
446     for (i = 0; i < _chunkLength; i++) {
447       address _refundee = refundeesList[i];
448       RefundeeRecord storage _data = refundees[_refundee];
449       if (_data.isRefunded == false) {
450         if (depositsOf(_refundee) > _txFee) {
451           uint256 _deposit = depositsOf(_refundee);
452           if (_deposit > _txFee) {
453             _weiRefunded = _weiRefunded.add(_deposit);
454             uint256 _paymentWithoutTxFee = _deposit.sub(_txFee);
455             _refundee.transfer(_paymentWithoutTxFee);
456             emit Withdrawn(_refundee, _paymentWithoutTxFee);
457             _data.isRefunded = true;
458             _refundeesListCopy[i] = _refundee;
459           }
460         }
461       }
462     }
463 
464     for (i = 0; i < _chunkLength; i++) {
465       if (address(0) != _refundeesListCopy[i]) {
466         RefundeeRecord storage _dataCleanup = refundees[_refundeesListCopy[i]];
467         require(_dataCleanup.isRefunded == true, "Investors in this list should be refunded.");
468         removeRefundeeByIndex(_dataCleanup.index);
469       }
470     }
471 
472     return (_weiRefunded, _refundeesListCopy);
473   }
474 
475   /**
476   * @dev Auto refund
477   * @param _txFee The cost of executing refund code
478   */
479   function withdrawEverything(uint256 _txFee) public onlyOwner returns (uint256, address[]) {
480     require(state == State.Refunding, "Funds withdrawal is possible only in the Refunding state.");
481     return withdrawChunk(_txFee, refundeesList.length);
482   }
483 
484   /**
485   * @dev Withdraws the part of beneficiary's funds.
486   */
487   function beneficiaryWithdrawChunk(uint256 _value) public onlyOwner {
488     require(_value <= address(this).balance, "Withdraw part can not be more than current balance");
489     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
490     beneficiary.transfer(_value);
491   }
492 
493   /**
494   * @dev Withdraws all beneficiary's funds.
495   */
496   function beneficiaryWithdrawAll() public onlyOwner {
497     uint256 _value = address(this).balance;
498     beneficiaryDepositedAmount = beneficiaryDepositedAmount.sub(_value);
499     beneficiary.transfer(_value);
500   }
501 
502 }