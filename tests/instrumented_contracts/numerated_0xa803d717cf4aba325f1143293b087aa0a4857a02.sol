1 // This is the Alethena Share Dispenser. 
2 // To learn more, visit https://dispenser.alethena.com
3 // Or contact us at contact@alethena.com
4 
5 
6 pragma solidity ^0.5.0;
7 
8 /**
9  * @title Ownable
10  * @dev The Ownable contract has an owner address, and provides basic authorization control
11  * functions, this simplifies the implementation of "user permissions".
12  */
13 contract Ownable {
14     address private _owner;
15 
16     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18     /**
19      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
20      * account.
21      */
22     constructor () internal {
23         _owner = msg.sender;
24         emit OwnershipTransferred(address(0), _owner);
25     }
26 
27     /**
28      * @return the address of the owner.
29      */
30     function owner() public view returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(isOwner());
39         _;
40     }
41 
42     /**
43      * @return true if `msg.sender` is the owner of the contract.
44      */
45     function isOwner() public view returns (bool) {
46         return msg.sender == _owner;
47     }
48 
49     /**
50      * @dev Allows the current owner to relinquish control of the contract.
51      * @notice Renouncing to ownership will leave the contract without an owner.
52      * It will not be possible to call the functions with the `onlyOwner`
53      * modifier anymore.
54      */
55     function renounceOwnership() public onlyOwner {
56         emit OwnershipTransferred(_owner, address(0));
57         _owner = address(0);
58     }
59 
60     /**
61      * @dev Allows the current owner to transfer control of the contract to a newOwner.
62      * @param newOwner The address to transfer ownership to.
63      */
64     function transferOwnership(address newOwner) public onlyOwner {
65         _transferOwnership(newOwner);
66     }
67 
68     /**
69      * @dev Transfers control of the contract to a newOwner.
70      * @param newOwner The address to transfer ownership to.
71      */
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0));
74         emit OwnershipTransferred(_owner, newOwner);
75         _owner = newOwner;
76     }
77 }
78 
79 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
80 
81 pragma solidity ^0.5.0;
82 
83 /**
84  * @title SafeMath
85  * @dev Unsigned math operations with safety checks that revert on error
86  */
87 library SafeMath {
88     /**
89     * @dev Multiplies two unsigned integers, reverts on overflow.
90     */
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         uint256 c = a * b;
100         require(c / a == b);
101 
102         return c;
103     }
104 
105     /**
106     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
107     */
108     function div(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Solidity only automatically asserts when dividing by 0
110         require(b > 0);
111         uint256 c = a / b;
112         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113 
114         return c;
115     }
116 
117     /**
118     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
119     */
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b <= a);
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128     * @dev Adds two unsigned integers, reverts on overflow.
129     */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a);
133 
134         return c;
135     }
136 
137     /**
138     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
139     * reverts when dividing by zero.
140     */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         require(b != 0);
143         return a % b;
144     }
145 }
146 
147 // File: openzeppelin-solidity/contracts/access/Roles.sol
148 
149 pragma solidity ^0.5.0;
150 
151 /**
152  * @title Roles
153  * @dev Library for managing addresses assigned to a Role.
154  */
155 library Roles {
156     struct Role {
157         mapping (address => bool) bearer;
158     }
159 
160     /**
161      * @dev give an account access to this role
162      */
163     function add(Role storage role, address account) internal {
164         require(account != address(0));
165         require(!has(role, account));
166 
167         role.bearer[account] = true;
168     }
169 
170     /**
171      * @dev remove an account's access to this role
172      */
173     function remove(Role storage role, address account) internal {
174         require(account != address(0));
175         require(has(role, account));
176 
177         role.bearer[account] = false;
178     }
179 
180     /**
181      * @dev check if an account has this role
182      * @return bool
183      */
184     function has(Role storage role, address account) internal view returns (bool) {
185         require(account != address(0));
186         return role.bearer[account];
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/access/roles/PauserRole.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 contract PauserRole {
196     using Roles for Roles.Role;
197 
198     event PauserAdded(address indexed account);
199     event PauserRemoved(address indexed account);
200 
201     Roles.Role private _pausers;
202 
203     constructor () internal {
204         _addPauser(msg.sender);
205     }
206 
207     modifier onlyPauser() {
208         require(isPauser(msg.sender));
209         _;
210     }
211 
212     function isPauser(address account) public view returns (bool) {
213         return _pausers.has(account);
214     }
215 
216     function addPauser(address account) public onlyPauser {
217         _addPauser(account);
218     }
219 
220     function renouncePauser() public {
221         _removePauser(msg.sender);
222     }
223 
224     function _addPauser(address account) internal {
225         _pausers.add(account);
226         emit PauserAdded(account);
227     }
228 
229     function _removePauser(address account) internal {
230         _pausers.remove(account);
231         emit PauserRemoved(account);
232     }
233 }
234 
235 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
236 
237 pragma solidity ^0.5.0;
238 
239 
240 /**
241  * @title Pausable
242  * @dev Base contract which allows children to implement an emergency stop mechanism.
243  */
244 contract Pausable is PauserRole {
245     event Paused(address account);
246     event Unpaused(address account);
247 
248     bool private _paused;
249 
250     constructor () internal {
251         _paused = false;
252     }
253 
254     /**
255      * @return true if the contract is paused, false otherwise.
256      */
257     function paused() public view returns (bool) {
258         return _paused;
259     }
260 
261     /**
262      * @dev Modifier to make a function callable only when the contract is not paused.
263      */
264     modifier whenNotPaused() {
265         require(!_paused);
266         _;
267     }
268 
269     /**
270      * @dev Modifier to make a function callable only when the contract is paused.
271      */
272     modifier whenPaused() {
273         require(_paused);
274         _;
275     }
276 
277     /**
278      * @dev called by the owner to pause, triggers stopped state
279      */
280     function pause() public onlyPauser whenNotPaused {
281         _paused = true;
282         emit Paused(msg.sender);
283     }
284 
285     /**
286      * @dev called by the owner to unpause, returns to normal state
287      */
288     function unpause() public onlyPauser whenPaused {
289         _paused = false;
290         emit Unpaused(msg.sender);
291     }
292 }
293 
294 // File: contracts/ShareDispenser.sol
295 
296 pragma solidity 0.5.0;
297 
298 
299 
300 
301 /**
302  * @title Alethena Share Dispenser
303  * @author Benjamin Rickenbacher, benjamin@alethena.com
304  * @dev This contract uses the open-zeppelin library.
305  *
306  * This smart contract is intended to serve as a tool that companies can use to provide liquidity in the context of 
307  * shares not traded on an exchange. This concrete instance is used to by Alethena for the tokenised shares of the 
308  * underlying Equility AG (https://etherscan.io/token/0xf40c5e190a608b6f8c0bf2b38c9506b327941402).
309  *
310  * The currency used for payment is the Crypto Franc XCHF (https://www.swisscryptotokens.ch/) which makes it possible
311  * to quote share prices directly in Swiss Francs.
312  *
313  * A company can allocate a certain number of shares (and optionally also some XCHF) to the share dispenser 
314  * and defines a linear price dependency.
315  **/
316 
317 interface ERC20 {
318     function totalSupply() external view returns (uint256);
319     function transfer(address to, uint tokens) external returns (bool success);
320     function transferFrom(address from, address to, uint256 value) external returns (bool success);
321     function totalShares() external view returns (uint256);
322     function allowance(address owner, address spender) external view returns (uint256);
323     function balanceOf(address owner) external view returns (uint256 balance);
324 }
325 
326 contract ShareDispenser is Ownable, Pausable {
327     constructor(
328         address initialXCHFContractAddress, 
329         address initialALEQContractAddress, 
330         address initialusageFeeAddress
331         ) public {
332             
333         require(initialXCHFContractAddress != address(0), "XCHF does not reside at address 0!");
334         require(initialALEQContractAddress != address(0), "ALEQ does not reside at address 0!");
335         require(initialusageFeeAddress != address(0), "Usage fee address cannot be 0!");
336 
337         XCHFContractAddress = initialXCHFContractAddress;
338         ALEQContractAddress = initialALEQContractAddress;
339         usageFeeAddress = initialusageFeeAddress;
340     }
341 
342     /* 
343      * Fallback function to prevent accidentally sending Ether to the contract
344      * It is still possible to force Ether into the contract as this cannot be prevented fully.
345      * Sending Ether to this contract does not create any problems for the contract, but the Ether will be lost.
346     */ 
347 
348     function () external payable {
349         revert("This contract does not accept Ether."); 
350     }   
351 
352     using SafeMath for uint256;
353 
354     // Variables
355 
356     address public XCHFContractAddress;     // Address where XCHF is deployed
357     address public ALEQContractAddress;     // Address where ALEQ is deployed
358     address public usageFeeAddress;         // Address where usage fee is collected
359 
360     // Buy and sell always refer to the end-user view.
361     // 10000 basis points = 100%
362 
363     uint256 public usageFeeBSP  = 0;       // In basis points. 0 = no usage fee
364     uint256 public minVolume = 20;          // Minimum number of shares to buy/sell
365 
366     uint256 public minPriceInXCHF = 6*10**18;
367     uint256 public maxPriceInXCHF = 65*10**17;
368     uint256 public initialNumberOfShares = 2000;
369 
370     bool public buyEnabled = true;
371     bool public sellEnabled = false;
372 
373     // Events 
374 
375     event XCHFContractAddressSet(address newXCHFContractAddress);
376     event ALEQContractAddressSet(address newALEQContractAddress);
377     event UsageFeeAddressSet(address newUsageFeeAddress);
378 
379     event SharesPurchased(address indexed buyer, uint256 amount, uint256 totalPrice, uint256 nextPrice);
380     event SharesSold(address indexed seller, uint256 amount, uint256 buyBackPrice, uint256 nextPrice);
381     
382     event TokensRetrieved(address contractAddress, address indexed to, uint256 amount);
383 
384     event UsageFeeSet(uint256 usageFee);
385     event MinVolumeSet(uint256 minVolume);
386     event MinPriceSet(uint256 minPrice);
387     event MaxPriceSet(uint256 maxPrice);
388     event InitialNumberOfSharesSet(uint256 initialNumberOfShares);
389 
390     event BuyStatusChanged(bool newStatus);
391     event SellStatusChanged(bool newStatus);
392     
393 
394     // Function for buying shares
395 
396     function buyShares(uint256 numberOfSharesToBuy) public whenNotPaused() returns (bool) {
397 
398         // Check that buying is enabled
399         require(buyEnabled, "Buying is currenty disabled");
400         require(numberOfSharesToBuy >= minVolume, "Volume too low");
401 
402         // Fetch the total price
403         address buyer = msg.sender;
404         uint256 sharesAvailable = getERC20Balance(ALEQContractAddress);
405         uint256 totalPrice = getCumulatedPrice(numberOfSharesToBuy, sharesAvailable);
406 
407         // Check that there are enough shares
408         require(sharesAvailable >= numberOfSharesToBuy, "Not enough shares available");
409 
410         //Check that XCHF balance is sufficient and allowance is set
411         require(getERC20Available(XCHFContractAddress, buyer) >= totalPrice, "Payment not authorized or funds insufficient");
412 
413         // Compute usage fee and final payment amount
414         uint256 usageFee = totalPrice.mul(usageFeeBSP).div(10000);
415         uint256 paymentAmount = totalPrice.sub(usageFee);
416 
417         // Instantiate contracts
418         ERC20 ALEQ = ERC20(ALEQContractAddress);
419         ERC20 XCHF = ERC20(XCHFContractAddress);
420 
421         // Transfer usage fee and payment amount
422         require(XCHF.transferFrom(buyer, usageFeeAddress, usageFee), "Usage fee transfer failed");
423         require(XCHF.transferFrom(buyer, address(this), paymentAmount), "XCHF payment failed");
424 
425         // Transfer the shares
426         require(ALEQ.transfer(buyer, numberOfSharesToBuy), "Share transfer failed");
427         uint256 nextPrice = getCumulatedPrice(1, sharesAvailable.sub(numberOfSharesToBuy));
428         emit SharesPurchased(buyer, numberOfSharesToBuy, totalPrice, nextPrice);
429         return true;
430     }
431 
432     // Function for selling shares
433 
434     function sellShares(uint256 numberOfSharesToSell, uint256 limitInXCHF) public whenNotPaused() returns (bool) {
435 
436         // Check that selling is enabled
437         require(sellEnabled, "Selling is currenty disabled");
438         require(numberOfSharesToSell >= minVolume, "Volume too low");
439 
440         // Fetch buyback price
441         address seller = msg.sender;
442         uint256 XCHFAvailable = getERC20Balance(XCHFContractAddress);
443         uint256 sharesAvailable = getERC20Balance(ALEQContractAddress);
444 
445         uint256 buyBackPrice = getCumulatedBuyBackPrice(numberOfSharesToSell, sharesAvailable);
446         require(limitInXCHF <= buyBackPrice, "Price too low");
447 
448         // Check that XCHF reserve is sufficient
449         require(XCHFAvailable >= buyBackPrice, "Reserves to small to buy back this amount of shares");
450 
451         // Check that seller has sufficient shares and allowance is set
452         require(getERC20Available(ALEQContractAddress, seller) >= numberOfSharesToSell, "Seller doesn't have enough shares");
453 
454         // Compute usage fee and final payment amount
455         uint256 usageFee = buyBackPrice.mul(usageFeeBSP).div(10000);
456         uint256 paymentAmount = buyBackPrice.sub(usageFee);
457 
458         // Instantiate contracts
459         ERC20 ALEQ = ERC20(ALEQContractAddress);
460         ERC20 XCHF = ERC20(XCHFContractAddress);
461 
462         // Transfer the shares
463         require(ALEQ.transferFrom(seller, address(this), numberOfSharesToSell), "Share transfer failed");
464 
465         // Transfer usage fee and payment amount
466         require(XCHF.transfer(usageFeeAddress, usageFee), "Usage fee transfer failed");
467         require(XCHF.transfer(seller, paymentAmount), "XCHF payment failed");
468         uint256 nextPrice = getCumulatedBuyBackPrice(1, sharesAvailable.add(numberOfSharesToSell));
469         emit SharesSold(seller, numberOfSharesToSell, buyBackPrice, nextPrice);
470         return true;
471     }
472 
473     // Getters for ERC20 balances (for convenience)
474 
475     function getERC20Balance(address contractAddress) public view returns (uint256) {
476         ERC20 contractInstance = ERC20(contractAddress);
477         return contractInstance.balanceOf(address(this));
478     }
479 
480     function getERC20Available(address contractAddress, address owner) public view returns (uint256) {
481         ERC20 contractInstance = ERC20(contractAddress);
482         uint256 allowed = contractInstance.allowance(owner, address(this));
483         uint256 bal = contractInstance.balanceOf(owner);
484         return (allowed <= bal) ? allowed : bal;
485     }
486 
487     // Price getters
488 
489     function getCumulatedPrice(uint256 amount, uint256 supply) public view returns (uint256){
490         uint256 cumulatedPrice = 0;
491         if (supply <= initialNumberOfShares) {
492             uint256 first = initialNumberOfShares.add(1).sub(supply);
493             uint256 last = first.add(amount).sub(1);
494             cumulatedPrice = helper(first, last);
495         }
496 
497         else if (supply.sub(amount) >= initialNumberOfShares) {
498             cumulatedPrice = minPriceInXCHF.mul(amount);
499         }
500 
501         else {
502             cumulatedPrice = supply.sub(initialNumberOfShares).mul(minPriceInXCHF);
503             uint256 first = 1;
504             uint256 last = amount.sub(supply.sub(initialNumberOfShares));
505             cumulatedPrice = cumulatedPrice.add(helper(first,last));
506         }
507         
508         return cumulatedPrice;
509     }
510 
511     function getCumulatedBuyBackPrice(uint256 amount, uint256 supply) public view returns (uint256){
512         return getCumulatedPrice(amount, supply.add(amount)); // For symmetry reasons
513     }
514 
515     // Function to retrieve ALEQ or XCHF from contract
516     // This can also be used to retrieve any other ERC-20 token sent to the smart contract by accident
517 
518     function retrieveERC20(address contractAddress, address to, uint256 amount) public onlyOwner() returns(bool) {
519         ERC20 contractInstance = ERC20(contractAddress);
520         require(contractInstance.transfer(to, amount), "Transfer failed");
521         emit TokensRetrieved(contractAddress, to, amount);
522         return true;
523     }
524 
525     // Setters for addresses
526 
527     function setXCHFContractAddress(address newXCHFContractAddress) public onlyOwner() {
528         require(newXCHFContractAddress != address(0), "XCHF does not reside at address 0");
529         XCHFContractAddress = newXCHFContractAddress;
530         emit XCHFContractAddressSet(XCHFContractAddress);
531     }
532 
533     function setALEQContractAddress(address newALEQContractAddress) public onlyOwner() {
534         require(newALEQContractAddress != address(0), "ALEQ does not reside at address 0");
535         ALEQContractAddress = newALEQContractAddress;
536         emit ALEQContractAddressSet(ALEQContractAddress);
537     }
538 
539     function setUsageFeeAddress(address newUsageFeeAddress) public onlyOwner() {
540         require(newUsageFeeAddress != address(0), "ALEQ does not reside at address 0");
541         usageFeeAddress = newUsageFeeAddress;
542         emit UsageFeeAddressSet(usageFeeAddress);
543     }
544 
545     // Setters for constants
546     
547     function setUsageFee(uint256 newUsageFeeInBSP) public onlyOwner() {
548         require(newUsageFeeInBSP <= 10000, "Usage fee must be given in basis points");
549         usageFeeBSP = newUsageFeeInBSP;
550         emit UsageFeeSet(usageFeeBSP);
551     }
552 
553     function setMinVolume(uint256 newMinVolume) public onlyOwner() {
554         require(newMinVolume > 0, "Minimum volume can't be zero");
555         minVolume = newMinVolume;
556         emit MinVolumeSet(minVolume);
557     }
558 
559     function setminPriceInXCHF(uint256 newMinPriceInRappen) public onlyOwner() {
560         require(newMinPriceInRappen > 0, "Price must be positive number");
561         minPriceInXCHF = newMinPriceInRappen.mul(10**16);
562         require(minPriceInXCHF <= maxPriceInXCHF, "Minimum price cannot exceed maximum price");
563         emit MinPriceSet(minPriceInXCHF);
564     }
565 
566     function setmaxPriceInXCHF(uint256 newMaxPriceInRappen) public onlyOwner() {
567         require(newMaxPriceInRappen > 0, "Price must be positive number");
568         maxPriceInXCHF = newMaxPriceInRappen.mul(10**16);
569         require(minPriceInXCHF <= maxPriceInXCHF, "Minimum price cannot exceed maximum price");
570         emit MaxPriceSet(maxPriceInXCHF);
571     }
572 
573     function setInitialNumberOfShares(uint256 newInitialNumberOfShares) public onlyOwner() {
574         require(newInitialNumberOfShares > 0, "Initial number of shares must be positive");
575         initialNumberOfShares = newInitialNumberOfShares;
576         emit InitialNumberOfSharesSet(initialNumberOfShares);
577     }
578 
579     // Enable buy and sell separately
580 
581     function buyStatus(bool newStatus) public onlyOwner() {
582         buyEnabled = newStatus;
583         emit BuyStatusChanged(newStatus);
584     }
585 
586     function sellStatus(bool newStatus) public onlyOwner() {
587         sellEnabled = newStatus;
588         emit SellStatusChanged(newStatus);
589     }
590 
591     // Helper functions
592 
593     function helper(uint256 first, uint256 last) internal view returns (uint256) {
594         uint256 tempa = last.sub(first).add(1).mul(minPriceInXCHF);                                   // (l-m+1)*p_min
595         uint256 tempb = maxPriceInXCHF.sub(minPriceInXCHF).div(initialNumberOfShares.sub(1)).div(2);  // (p_max-p_min)/(2(N-1))
596         uint256 tempc = last.mul(last).add(first.mul(3)).sub(last).sub(first.mul(first)).sub(2);      // l*l+3*m-l-m*m-2)
597         return tempb.mul(tempc).add(tempa);
598     }
599 
600 }