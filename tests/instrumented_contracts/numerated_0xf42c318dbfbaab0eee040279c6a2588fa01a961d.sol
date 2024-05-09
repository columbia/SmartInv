1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Context.sol
72 
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/access/Ownable.sol
99 
100 
101 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 
106 /**
107  * @dev Contract module which provides a basic access control mechanism, where
108  * there is an account (an owner) that can be granted exclusive access to
109  * specific functions.
110  *
111  * By default, the owner account will be the one that deploys the contract. This
112  * can later be changed with {transferOwnership}.
113  *
114  * This module is used through inheritance. It will make available the modifier
115  * `onlyOwner`, which can be applied to your functions to restrict their use to
116  * the owner.
117  */
118 abstract contract Ownable is Context {
119     address private _owner;
120 
121     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
122 
123     /**
124      * @dev Initializes the contract setting the deployer as the initial owner.
125      */
126     constructor() {
127         _transferOwnership(_msgSender());
128     }
129 
130     /**
131      * @dev Returns the address of the current owner.
132      */
133     function owner() public view virtual returns (address) {
134         return _owner;
135     }
136 
137     /**
138      * @dev Throws if called by any account other than the owner.
139      */
140     modifier onlyOwner() {
141         require(owner() == _msgSender(), "Ownable: caller is not the owner");
142         _;
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions anymore. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby removing any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 
176 // File: @openzeppelin/contracts/utils/Address.sol
177 
178 
179 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
180 
181 pragma solidity ^0.8.1;
182 
183 /**
184  * @dev Collection of functions related to the address type
185  */
186 library Address {
187     /**
188      * @dev Returns true if `account` is a contract.
189      *
190      * [IMPORTANT]
191      * ====
192      * It is unsafe to assume that an address for which this function returns
193      * false is an externally-owned account (EOA) and not a contract.
194      *
195      * Among others, `isContract` will return false for the following
196      * types of addresses:
197      *
198      *  - an externally-owned account
199      *  - a contract in construction
200      *  - an address where a contract will be created
201      *  - an address where a contract lived, but was destroyed
202      * ====
203      *
204      * [IMPORTANT]
205      * ====
206      * You shouldn't rely on `isContract` to protect against flash loan attacks!
207      *
208      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
209      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
210      * constructor.
211      * ====
212      */
213     function isContract(address account) internal view returns (bool) {
214         // This method relies on extcodesize/address.code.length, which returns 0
215         // for contracts in construction, since the code is only stored at the end
216         // of the constructor execution.
217 
218         return account.code.length > 0;
219     }
220 
221     /**
222      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
223      * `recipient`, forwarding all available gas and reverting on errors.
224      *
225      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
226      * of certain opcodes, possibly making contracts go over the 2300 gas limit
227      * imposed by `transfer`, making them unable to receive funds via
228      * `transfer`. {sendValue} removes this limitation.
229      *
230      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
231      *
232      * IMPORTANT: because control is transferred to `recipient`, care must be
233      * taken to not create reentrancy vulnerabilities. Consider using
234      * {ReentrancyGuard} or the
235      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
236      */
237     function sendValue(address payable recipient, uint256 amount) internal {
238         require(address(this).balance >= amount, "Address: insufficient balance");
239 
240         (bool success, ) = recipient.call{value: amount}("");
241         require(success, "Address: unable to send value, recipient may have reverted");
242     }
243 
244     /**
245      * @dev Performs a Solidity function call using a low level `call`. A
246      * plain `call` is an unsafe replacement for a function call: use this
247      * function instead.
248      *
249      * If `target` reverts with a revert reason, it is bubbled up by this
250      * function (like regular Solidity function calls).
251      *
252      * Returns the raw returned data. To convert to the expected return value,
253      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
254      *
255      * Requirements:
256      *
257      * - `target` must be a contract.
258      * - calling `target` with `data` must not revert.
259      *
260      * _Available since v3.1._
261      */
262     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
263         return functionCall(target, data, "Address: low-level call failed");
264     }
265 
266     /**
267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
268      * `errorMessage` as a fallback revert reason when `target` reverts.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(
273         address target,
274         bytes memory data,
275         string memory errorMessage
276     ) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, 0, errorMessage);
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
282      * but also transferring `value` wei to `target`.
283      *
284      * Requirements:
285      *
286      * - the calling contract must have an ETH balance of at least `value`.
287      * - the called Solidity function must be `payable`.
288      *
289      * _Available since v3.1._
290      */
291     function functionCallWithValue(
292         address target,
293         bytes memory data,
294         uint256 value
295     ) internal returns (bytes memory) {
296         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
301      * with `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCallWithValue(
306         address target,
307         bytes memory data,
308         uint256 value,
309         string memory errorMessage
310     ) internal returns (bytes memory) {
311         require(address(this).balance >= value, "Address: insufficient balance for call");
312         require(isContract(target), "Address: call to non-contract");
313 
314         (bool success, bytes memory returndata) = target.call{value: value}(data);
315         return verifyCallResult(success, returndata, errorMessage);
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
320      * but performing a static call.
321      *
322      * _Available since v3.3._
323      */
324     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
325         return functionStaticCall(target, data, "Address: low-level static call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(
335         address target,
336         bytes memory data,
337         string memory errorMessage
338     ) internal view returns (bytes memory) {
339         require(isContract(target), "Address: static call to non-contract");
340 
341         (bool success, bytes memory returndata) = target.staticcall(data);
342         return verifyCallResult(success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347      * but performing a delegate call.
348      *
349      * _Available since v3.4._
350      */
351     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(
362         address target,
363         bytes memory data,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(isContract(target), "Address: delegate call to non-contract");
367 
368         (bool success, bytes memory returndata) = target.delegatecall(data);
369         return verifyCallResult(success, returndata, errorMessage);
370     }
371 
372     /**
373      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
374      * revert reason using the provided one.
375      *
376      * _Available since v4.3._
377      */
378     function verifyCallResult(
379         bool success,
380         bytes memory returndata,
381         string memory errorMessage
382     ) internal pure returns (bytes memory) {
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: workspaces/default_workspace/samuraisanta.sol
402 
403 /**
404  * SPDX-License-Identifier: MIT
405  *
406  * Copyright (c) 2022 WYE Company
407  *
408  * Permission is hereby granted, free of charge, to any person obtaining a copy
409  * of this software and associated documentation files (the "Software"), to deal
410  * in the Software without restriction, including without limitation the rights
411  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
412  * copies of the Software, and to permit persons to whom the Software is
413  * furnished to do so, subject to the following conditions:
414  *
415  * The above copyright notice and this permission notice shall be included in
416  * copies or substantial portions of the Software.
417  *
418  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
419  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
420  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
421  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
422  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
423  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
424  * SOFTWARE.
425  *
426  */
427 
428 pragma solidity 0.8.13;
429 
430 
431 
432 
433 
434 interface akuNFT {
435     function airdropProgress() external view returns(uint256);
436 }
437 
438 contract AkuAuction is Ownable {
439     using Strings for uint256;
440 
441     address payable immutable project;
442 
443     uint256 public maxNFTs = 15000;
444     uint256 public totalForAuction = 5495; //529 + 2527 + 6449
445 
446     struct bids {
447         address bidder;
448         uint80 price;
449         uint8 bidsPlaced;
450         uint8 finalProcess; //0: Not processed, 1: refunded, 2: withdrawn
451     }
452 
453     uint256 private constant DURATION = 126 minutes;
454     uint256 public immutable startingPrice;
455     uint256 public immutable startAt;
456     uint256 public expiresAt;
457     uint256 public immutable discountRate;
458     mapping(address=>uint256) public mintPassOwner;
459     uint256 public constant mintPassDiscount = 0.5 ether;
460     mapping(address => uint256) public personalBids;
461     mapping(uint256 => bids) public allBids;
462     uint256 public bidIndex = 1;
463     uint256 public totalBids;
464     uint256 public totalBidValue;
465     uint256 public maxBids = 3;
466     uint256 public refundProgress = 1;
467 
468     akuNFT public akuNFTs;
469 
470     constructor(address _project, 
471         uint256 startingTime,
472         uint256 _startingPrice,
473         uint256 _discountRate)
474     {
475         project = payable(_project);
476 
477         startingPrice = _startingPrice;
478         startAt = startingTime;
479         expiresAt = startAt + DURATION;
480         discountRate = _discountRate;
481 
482         require(_startingPrice >= _discountRate * (DURATION/6 minutes), "Starting price less than minimum");
483     }
484 
485     function getPrice() public view returns (uint80) {
486         uint256 currentTime = block.timestamp;
487         if(currentTime > expiresAt) currentTime = expiresAt;
488         uint256 timeElapsed = (currentTime - startAt) / 6 minutes;
489         uint256 discount = discountRate * timeElapsed;
490         return uint80(startingPrice - discount);
491     }
492 
493     function bid(uint8 amount) external payable {
494         _bid(amount, msg.value);
495     }
496 
497     receive() external payable {
498         revert("Please use the bid function");
499     }
500 
501     function _bid(uint8 amount, uint256 value) internal {
502         require(block.timestamp > startAt, "Auction not started yet");
503         require(block.timestamp < expiresAt, "Auction expired");
504         uint80 price = getPrice();
505         uint256 totalPrice = price * amount;
506         if (value < totalPrice) {
507             revert("Bid not high enough");
508         }
509         
510         uint256 myBidIndex = personalBids[msg.sender];
511         bids memory myBids;
512         uint256 refund;
513 
514         if (myBidIndex > 0) {
515             myBids = allBids[myBidIndex];
516             refund = myBids.bidsPlaced * (myBids.price - price);
517         }
518         uint256 _totalBids = totalBids + amount;
519         myBids.bidsPlaced += amount;
520 
521         if (myBids.bidsPlaced > maxBids) {
522             revert("Bidding limits exceeded");
523         }
524 
525         if(_totalBids > totalForAuction) {
526             revert("Auction Full");
527         } else if (_totalBids == totalForAuction) {
528             expiresAt = block.timestamp; //Auction filled
529         }
530 
531         myBids.price = price;
532 
533         if (myBidIndex > 0) {
534             allBids[myBidIndex] = myBids;
535         } else {
536             myBids.bidder = msg.sender;
537             personalBids[msg.sender] = bidIndex;
538             allBids[bidIndex] = myBids;
539             bidIndex++;
540         }
541         
542         totalBids = _totalBids;
543         totalBidValue += totalPrice;
544 
545         refund += value - totalPrice;
546         if (refund > 0) {
547             (bool sent, ) = msg.sender.call{value: refund}("");
548             require(sent, "Failed to refund bidder");
549         }
550     }
551 
552     function loadMintPassOwners(address[] calldata owners, uint256[] calldata amounts) external onlyOwner {
553         for (uint256 i = 0; i < owners.length; i++) {
554             mintPassOwner[owners[i]] = amounts[i];
555         }
556     }
557 
558     function myBidCount(address user) public view returns(uint256) {
559         return allBids[personalBids[user]].bidsPlaced;
560     }
561     function myBidData(address user) external view returns(bids memory) {
562         return allBids[personalBids[user]];
563     }
564 
565     function setNFTContract(address _contract) external onlyOwner {
566         akuNFTs = akuNFT(_contract);
567     }
568 
569     function emergencyWithdraw() external {
570         require(block.timestamp > expiresAt + 3 days, "Please wait for airdrop period.");
571         
572         bids memory bidData = allBids[personalBids[msg.sender]];
573         require(bidData.bidsPlaced > 0, "No bids placed");
574         require(bidData.finalProcess == 0, "Refund already processed");
575 
576         allBids[personalBids[msg.sender]].finalProcess = 2;
577         (bool sent, ) = bidData.bidder.call{value: bidData.price * bidData.bidsPlaced}("");
578         require(sent, "Failed to refund bidder");
579     }
580 
581     function processRefunds() external {
582       require(block.timestamp > expiresAt, "Auction still in progress");
583       uint256 _refundProgress = refundProgress;
584       uint256 _bidIndex = bidIndex;
585       require(_refundProgress < _bidIndex, "Refunds already processed");
586       
587       uint256 gasUsed;
588       uint256 gasLeft = gasleft();
589       uint256 price = getPrice();
590       
591       for (uint256 i=_refundProgress; gasUsed < 5000000 && i < _bidIndex; i++) {
592           bids memory bidData = allBids[i];
593           if (bidData.finalProcess == 0) {
594             uint256 refund = (bidData.price - price) * bidData.bidsPlaced;
595             uint256 passes = mintPassOwner[bidData.bidder];
596             if (passes > 0) {
597                 refund += mintPassDiscount * (bidData.bidsPlaced < passes ? bidData.bidsPlaced : passes);
598             }
599             allBids[i].finalProcess = 1;
600             if (refund > 0) {
601                 (bool sent, ) = bidData.bidder.call{value: refund}("");
602                 require(sent, "Failed to refund bidder");
603             }
604           }
605           
606           gasUsed += gasLeft - gasleft();
607           gasLeft = gasleft();
608           _refundProgress++;
609       }
610 
611       refundProgress = _refundProgress;
612     }
613 
614     function claimProjectFunds() external onlyOwner {
615         require(block.timestamp > expiresAt, "Auction still in progress");
616         require(refundProgress >= totalBids, "Refunds not yet processed");
617         require(akuNFTs.airdropProgress() >= totalBids, "Airdrop not complete");
618 
619         (bool sent, ) = project.call{value: address(this).balance}("");
620         require(sent, "Failed to withdraw");        
621     }
622 
623     function getAuctionDetails(address user) external view returns(uint256 remainingNFTs, uint256 expires, uint256 currentPrice, uint256 userBids) {
624         remainingNFTs =  totalForAuction - totalBids;
625         expires = expiresAt;
626         currentPrice = getPrice();
627         if(user != address(0))
628             userBids = allBids[personalBids[user]].bidsPlaced;
629     }
630 }