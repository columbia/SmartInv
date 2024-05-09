1 pragma solidity ^0.4.23;
2 
3 // File: contracts/interface/IArbitrage.sol
4 
5 /*
6 
7   Copyright 2018 Contra Labs Inc.
8 
9   Licensed under the Apache License, Version 2.0 (the "License");
10   you may not use this file except in compliance with the License.
11   You may obtain a copy of the License at
12 
13   http://www.apache.org/licenses/LICENSE-2.0
14 
15   Unless required by applicable law or agreed to in writing, software
16   distributed under the License is distributed on an "AS IS" BASIS,
17   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
18   See the License for the specific language governing permissions and
19   limitations under the License.
20 
21 */
22 
23 pragma solidity 0.4.24;
24  
25 
26 interface IArbitrage {
27     function executeArbitrage(
28       address token,
29       uint256 amount,
30       address dest,
31       bytes data
32     )
33       external
34       returns (bool);
35 }
36 
37 // File: contracts/interface/IBank.sol
38 
39 /*
40 
41   Copyright 2018 Contra Labs Inc.
42 
43   Licensed under the Apache License, Version 2.0 (the "License");
44   you may not use this file except in compliance with the License.
45   You may obtain a copy of the License at
46 
47   http://www.apache.org/licenses/LICENSE-2.0
48 
49   Unless required by applicable law or agreed to in writing, software
50   distributed under the License is distributed on an "AS IS" BASIS,
51   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
52   See the License for the specific language governing permissions and
53   limitations under the License.
54 
55 */
56 
57 pragma solidity 0.4.24;
58 
59 
60 contract IBank {
61     function totalSupplyOf(address token) public view returns (uint256 balance);
62     function borrowFor(address token, address borrower, uint256 amount) public;
63     function repay(address token, uint256 amount) external payable;
64 }
65 
66 // File: openzeppelin-solidity/contracts/ReentrancyGuard.sol
67 
68 /**
69  * @title Helps contracts guard agains reentrancy attacks.
70  * @author Remco Bloemen <remco@2π.com>
71  * @notice If you mark a function `nonReentrant`, you should also
72  * mark it `external`.
73  */
74 contract ReentrancyGuard {
75 
76   /**
77    * @dev We use a single lock for the whole contract.
78    */
79   bool private reentrancyLock = false;
80 
81   /**
82    * @dev Prevents a contract from calling itself, directly or indirectly.
83    * @notice If you mark a function `nonReentrant`, you should also
84    * mark it `external`. Calling one nonReentrant function from
85    * another is not supported. Instead, you can implement a
86    * `private` function doing the actual work, and a `external`
87    * wrapper marked as `nonReentrant`.
88    */
89   modifier nonReentrant() {
90     require(!reentrancyLock);
91     reentrancyLock = true;
92     _;
93     reentrancyLock = false;
94   }
95 
96 }
97 
98 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
99 
100 /**
101  * @title SafeMath
102  * @dev Math operations with safety checks that throw on error
103  */
104 library SafeMath {
105 
106   /**
107   * @dev Multiplies two numbers, throws on overflow.
108   */
109   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
110     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
111     // benefit is lost if 'b' is also tested.
112     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
113     if (a == 0) {
114       return 0;
115     }
116 
117     c = a * b;
118     assert(c / a == b);
119     return c;
120   }
121 
122   /**
123   * @dev Integer division of two numbers, truncating the quotient.
124   */
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     // uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return a / b;
130   }
131 
132   /**
133   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
134   */
135   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   /**
141   * @dev Adds two numbers, throws on overflow.
142   */
143   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
144     c = a + b;
145     assert(c >= a);
146     return c;
147   }
148 }
149 
150 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158   address public owner;
159 
160 
161   event OwnershipRenounced(address indexed previousOwner);
162   event OwnershipTransferred(
163     address indexed previousOwner,
164     address indexed newOwner
165   );
166 
167 
168   /**
169    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170    * account.
171    */
172   constructor() public {
173     owner = msg.sender;
174   }
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184   /**
185    * @dev Allows the current owner to relinquish control of the contract.
186    */
187   function renounceOwnership() public onlyOwner {
188     emit OwnershipRenounced(owner);
189     owner = address(0);
190   }
191 
192   /**
193    * @dev Allows the current owner to transfer control of the contract to a newOwner.
194    * @param _newOwner The address to transfer ownership to.
195    */
196   function transferOwnership(address _newOwner) public onlyOwner {
197     _transferOwnership(_newOwner);
198   }
199 
200   /**
201    * @dev Transfers control of the contract to a newOwner.
202    * @param _newOwner The address to transfer ownership to.
203    */
204   function _transferOwnership(address _newOwner) internal {
205     require(_newOwner != address(0));
206     emit OwnershipTransferred(owner, _newOwner);
207     owner = _newOwner;
208   }
209 }
210 
211 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
212 
213 /**
214  * @title ERC20Basic
215  * @dev Simpler version of ERC20 interface
216  * @dev see https://github.com/ethereum/EIPs/issues/179
217  */
218 contract ERC20Basic {
219   function totalSupply() public view returns (uint256);
220   function balanceOf(address who) public view returns (uint256);
221   function transfer(address to, uint256 value) public returns (bool);
222   event Transfer(address indexed from, address indexed to, uint256 value);
223 }
224 
225 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
226 
227 /**
228  * @title ERC20 interface
229  * @dev see https://github.com/ethereum/EIPs/issues/20
230  */
231 contract ERC20 is ERC20Basic {
232   function allowance(address owner, address spender)
233     public view returns (uint256);
234 
235   function transferFrom(address from, address to, uint256 value)
236     public returns (bool);
237 
238   function approve(address spender, uint256 value) public returns (bool);
239   event Approval(
240     address indexed owner,
241     address indexed spender,
242     uint256 value
243   );
244 }
245 
246 // File: contracts/FlashLender.sol
247 
248 /*
249 
250   Copyright 2018 Contra Labs Inc.
251 
252   Licensed under the Apache License, Version 2.0 (the "License");
253   you may not use this file except in compliance with the License.
254   You may obtain a copy of the License at
255 
256   http://www.apache.org/licenses/LICENSE-2.0
257 
258   Unless required by applicable law or agreed to in writing, software
259   distributed under the License is distributed on an "AS IS" BASIS,
260   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
261   See the License for the specific language governing permissions and
262   limitations under the License.
263 
264 */
265 
266 pragma solidity 0.4.24;
267 
268 
269 
270 
271 
272 
273 
274 // @title FlashLender: Borrow from the bank and enforce repayment by the end of transaction execution.
275 // @author Rich McAteer <rich@marble.org>, Max Wolff <max@marble.org>
276 contract FlashLender is ReentrancyGuard, Ownable {
277     using SafeMath for uint256;
278 
279     string public version = '0.1';
280     address public bank;
281     uint256 public fee;
282     
283     /**
284     * @dev Verify that the borrowed tokens are returned to the bank plus a fee by the end of transaction execution.
285     * @param token Address of the token to for arbitrage. 0x0 for Ether.
286     * @param amount Amount borrowed.
287     */
288     modifier isArbitrage(address token, uint256 amount) {
289         uint256 balance = IBank(bank).totalSupplyOf(token);
290         uint256 feeAmount = amount.mul(fee).div(10 ** 18); 
291         _;
292         require(IBank(bank).totalSupplyOf(token) >= (balance.add(feeAmount)));
293     }
294 
295     constructor(address _bank, uint256 _fee) public {
296         bank = _bank;
297         fee = _fee;
298     }
299 
300     /**
301     * @dev Borrow from the bank on behalf of an arbitrage contract and execute the arbitrage contract's callback function.
302     * @param token Address of the token to borrow. 0x0 for Ether.
303     * @param amount Amount to borrow.
304     * @param dest Address of the account to receive arbitrage profits.
305     * @param data The data to execute the arbitrage trade.
306     */
307     function borrow(
308         address token,
309         uint256 amount,
310         address dest,
311         bytes data
312     )
313         external
314         nonReentrant
315         isArbitrage(token, amount)
316         returns (bool)
317     {
318         // Borrow from the bank and send to the arbitrageur.
319         IBank(bank).borrowFor(token, msg.sender, amount);
320         // Call the arbitrageur's execute arbitrage method.
321         return IArbitrage(msg.sender).executeArbitrage(token, amount, dest, data);
322     }
323 
324     /**
325     * @dev Allow the owner to set the bank address.
326     * @param _bank Address of the bank.
327     */
328     function setBank(address _bank) external onlyOwner {
329         bank = _bank;
330     }
331 
332     /**
333     * @dev Allow the owner to set the fee.
334     * @param _fee Fee to borrow, as a percentage of principal borrowed. 18 decimals of precision (e.g., 10^18 = 100% fee).
335     */
336     function setFee(uint256 _fee) external onlyOwner {
337         fee = _fee;
338     }
339 
340 }
341 
342 // File: contracts/example/ExternalCall.sol
343 
344 /*
345 
346   Copyright 2018 Contra Labs Inc.
347 
348   Licensed under the Apache License, Version 2.0 (the "License");
349   you may not use this file except in compliance with the License.
350   You may obtain a copy of the License at
351 
352   http://www.apache.org/licenses/LICENSE-2.0
353 
354   Unless required by applicable law or agreed to in writing, software
355   distributed under the License is distributed on an "AS IS" BASIS,
356   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
357   See the License for the specific language governing permissions and
358   limitations under the License.
359 
360 */
361 
362 pragma solidity 0.4.24;
363 
364 contract ExternalCall {
365     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
366     // call has been separated into its own function in order to take advantage
367     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
368     function external_call(address destination, uint value, uint dataLength, bytes data) internal returns (bool) {
369         bool result;
370         assembly {
371             let x := mload(0x40)   // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
372             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
373             result := call(
374                 sub(gas, 34710),   // 34710 is the value that solidity is currently emitting
375                                    // It includes callGas (700) + callVeryLow (3, to pay for SUB) + callValueTransferGas (9000) +
376                                    // callNewAccountGas (25000, in case the destination address does not exist and needs creating)
377                 destination,
378                 value,
379                 d,
380                 dataLength,        // Size of the input (in bytes) - this is what fixes the padding problem
381                 x,
382                 0                  // Output is ignored, therefore the output size is zero
383             )
384         }
385         return result;
386     }
387 }
388 
389 // File: contracts/example/Arbitrage.sol
390 
391 /*
392 
393   Copyright 2018 Contra Labs Inc.
394 
395   Licensed under the Apache License, Version 2.0 (the "License");
396   you may not use this file except in compliance with the License.
397   You may obtain a copy of the License at
398 
399   http://www.apache.org/licenses/LICENSE-2.0
400 
401   Unless required by applicable law or agreed to in writing, software
402   distributed under the License is distributed on an "AS IS" BASIS,
403   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
404   See the License for the specific language governing permissions and
405   limitations under the License.
406 
407 */
408 
409 pragma solidity 0.4.24;
410 
411 
412 
413 
414 
415 
416 
417 
418 // @title Arbitrage: Borrow Ether or ERC20 tokens to execute an arbitrage opportunity.
419 // @author Rich McAteer <rich@marble.org>, Max Wolff <max@marble.org>
420 contract Arbitrage is IArbitrage, ExternalCall {
421     using SafeMath for uint256;
422 
423     address public lender;
424     address public tradeExecutor;
425     address constant public ETH = 0x0;
426     uint256 constant public MAX_UINT = 2 ** 256 - 1;
427 
428     modifier onlyLender() {
429         require(msg.sender == lender);
430         _;
431     }
432 
433     constructor(address _lender, address _tradeExecutor) public {
434         lender = _lender;
435         tradeExecutor = _tradeExecutor; 
436     }
437 
438     // Receive ETH from bank.
439     function () payable public {}
440 
441     /**
442     * @dev Borrow from flash lender to execute arbitrage trade. 
443     * @param token Address of the token to borrow. 0x0 for Ether.
444     * @param amount Amount to borrow.
445     * @param dest Address of the account to receive arbitrage profits.
446     * @param data The data to execute the arbitrage trade.
447     */
448     function submitTrade(address token, uint256 amount, address dest, bytes data) external {
449         FlashLender(lender).borrow(token, amount, dest, data);
450     }
451 
452     /**
453     * @dev Callback from flash lender. Executes arbitrage trade.
454     * @param token Address of the borrowed token. 0x0 for Ether.
455     * @param amount Amount borrowed.
456     * @param dest Address of the account to receive arbitrage profits.
457     * @param data The data to execute the arbitrage trade.
458     */
459     function executeArbitrage(
460         address token,
461         uint256 amount,
462         address dest,
463         bytes data
464     )
465         external
466         onlyLender 
467         returns (bool)
468     {
469         uint256 value = 0;
470         if (token == ETH) {
471             value = amount;
472         } else {
473             // Send tokens to Trade Executor
474             ERC20(token).transfer(tradeExecutor, amount);
475         }
476 
477         // Execute the trades.
478         external_call(tradeExecutor, value, data.length, data);
479 
480         // Determine the amount to repay.
481         uint256 repayAmount = getRepayAmount(amount);
482 
483         address bank = FlashLender(lender).bank();
484 
485         // Repay the bank and collect remaining profits.
486         if (token == ETH) {
487             IBank(bank).repay.value(repayAmount)(token, repayAmount);
488             dest.transfer(address(this).balance);
489         } else {
490             if (ERC20(token).allowance(this, bank) < repayAmount) {
491                 ERC20(token).approve(bank, MAX_UINT);
492             }
493             IBank(bank).repay(token, repayAmount);
494             uint256 balance = ERC20(token).balanceOf(this);
495             require(ERC20(token).transfer(dest, balance));
496         }
497 
498         return true;
499     }
500 
501     /** 
502     * @dev Calculate the amount owed after borrowing.
503     * @param amount Amount used to calculate repayment amount.
504     */ 
505     function getRepayAmount(uint256 amount) public view returns (uint256) {
506         uint256 fee = FlashLender(lender).fee();
507         uint256 feeAmount = amount.mul(fee).div(10 ** 18);
508         return amount.add(feeAmount);
509     }
510 
511 }