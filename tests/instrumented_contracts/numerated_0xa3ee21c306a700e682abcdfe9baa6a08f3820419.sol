1 pragma solidity ^0.5.1;
2 /**
3 The MIT License (MIT)
4 
5 Copyright (c) 2016 Smart Contract Solutions, Inc.
6 
7 Permission is hereby granted, free of charge, to any person obtaining
8 a copy of this software and associated documentation files (the
9 "Software"), to deal in the Software without restriction, including
10 without limitation the rights to use, copy, modify, merge, publish,
11 distribute, sublicense, and/or sell copies of the Software, and to
12 permit persons to whom the Software is furnished to do so, subject to
13 the following conditions:
14 
15 The above copyright notice and this permission notice shall be included
16 in all copies or substantial portions of the Software.
17 
18 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
19 OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
20 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
21 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
22 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
23 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
24 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
25  */
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that revert on error
31  */
32 library SafeMath {
33 
34     /**
35     * @dev Multiplies two numbers, reverts on overflow.
36     */
37     function multiply(uint256 a, uint256 b) internal pure returns (uint256)
38     {
39         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
40         // benefit is lost if 'b' is also tested.
41         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
42         if (a == 0)
43         {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b, "Multiplication overflow");
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
55     */
56     function divide(uint256 a, uint256 b) internal pure returns (uint256)
57     {
58         require(b > 0, "Division by zero"); // Solidity only automatically asserts when dividing by 0
59         uint256 c = a / b;
60 
61         return c;
62     }
63 
64     /**
65     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
66     */
67     function subtract(uint256 a, uint256 b) internal pure returns (uint256)
68     {
69         require(b <= a, "Subtraction underflow");
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two numbers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256)
79     {
80         uint256 c = a + b;
81         require(c >= a, "Addition overflow");
82 
83         return c;
84     }
85 }
86 
87 pragma solidity ^0.5.1;
88 
89 /**
90 Copyright(c) 2018 Gluwa, Inc.
91 
92 This file is part of GluwaCreditcoinVestingToken.
93 
94 GluwaCreditcoinVestingToken is free software: you can redistribute it and/or modify
95 it under the terms of the GNU Lesser General Public License as published by
96 the Free Software Foundation, either version 3 of the License, or
97 (at your option) any later version.
98 	
99 This program is distributed in the hope that it will be useful,
100 but WITHOUT ANY WARRANTY; without even the implied warranty of
101 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
102 GNU Lesser General Public License for more details.
103 	
104 You should have received a copy of the GNU Lesser General Public License
105 along with GluwaCreditcoinVestingToken. If not, see <https://www.gnu.org/licenses/>.
106  */
107 
108 contract Erc20
109 {   
110     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
111     function totalSupply() public view returns (uint256 amount);
112     function balanceOf(address owner) public view returns (uint256 balance);
113     function transfer(address to, uint256 value) public returns (bool success);
114     function transferFrom(address from, address to, uint256 value) public returns (bool success);
115     function approve(address spender, uint256 value) public returns (bool success);
116     function allowance(address owner, address spender) public view returns (uint256 remaining);
117     
118     event Transfer(address indexed from, address indexed to, uint256 value);
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 contract Erc20Plus is Erc20
124 {
125     function burn(uint256 value) public returns (bool success);
126     function burnFrom(address from, uint256 value) public returns (bool success);
127 
128     event Burnt(address indexed from, uint256 value);
129 }
130 
131 
132 contract Owned
133 {
134     address internal Owner;
135 
136     constructor() public
137     {
138         Owner = msg.sender;
139     }
140 
141     modifier onlyOwner 
142     {
143         require(msg.sender == Owner, "Only contract owner can do this.");
144         _;
145     }   
146 
147     function () external payable 
148     {
149         require(false, "eth transfer is disabled."); // throw
150     }
151 }
152 
153 
154 contract CreditcoinBase is Owned
155 {
156     //----------- ERC20 members
157     uint8 public constant decimals = 18;
158     //=========== ERC20 members
159 
160     uint256 internal constant FRAC_IN1UNIT = 10 ** uint256(decimals);
161     uint256 public constant creditcoinLimitInFrac = 2000000000 * FRAC_IN1UNIT;
162 }
163 
164 
165 contract GluwaCreditcoinVestingToken is CreditcoinBase, Erc20Plus
166 {
167     using SafeMath for uint256;
168 
169     //----------- ERC20 members
170     string public constant name = "Gluwa Creditcoin Vesting Token";
171     string public constant symbol = "G-CRE";
172     //=========== ERC20 members
173 
174     uint256 public constant creditcoinSalesLimit = creditcoinLimitInFrac * 3 / 10;
175 
176     bool public IsSalesFinalized;
177     uint256 public VestingStartDate;
178 
179     address private _creditcoinFoundation;
180 
181     uint256 private _totalSupply;
182 
183     event Exchange(address indexed from, uint256 value, string indexed sighash);
184 
185     /* 
186         Mapping of addresses to map of vesting periods (uint16) to token balance (uint256).
187         Also maps investor address to their amount of token transfer balance and amount of vesting tokens used.
188     */
189     mapping(address => mapping(uint16 => uint256)) private _balances;
190     mapping (address => mapping (address => uint256)) private _allowance;
191 
192     uint16 constant TRANSFER_TOKENS_BALANCE  = 0;
193     uint16 constant USED_VESTED_AMOUNT = 1;
194     uint16 constant SIX_MONTH_VESTING_IN_DAYS = 183;
195     uint16 constant ONE_YEAR_VESTING_IN_DAYS = 365;
196     uint16 constant TWO_YEAR_VESTING_IN_DAYS = 730;
197     uint16 constant THREE_YEAR_VESTING_IN_DAYS = 1095;
198     uint16 constant SIX_YEAR_VESTING_IN_DAYS = 2190;
199 
200     modifier salesNotFinalized()
201     {
202         require(!IsSalesFinalized, "Sales have been finalized");
203         _;
204     }
205 
206     constructor(address creditcoinFoundation, address devCost) public
207     {
208         _creditcoinFoundation = creditcoinFoundation;
209         uint256 creditcoinFoundationTokens = creditcoinLimitInFrac.multiply(5).divide(100);
210         uint256 devCostTokens = creditcoinLimitInFrac.multiply(15).divide(100);
211         
212         _balances[creditcoinFoundation][SIX_YEAR_VESTING_IN_DAYS] = creditcoinFoundationTokens;
213         _totalSupply = _totalSupply.add(creditcoinFoundationTokens);
214 
215         _balances[devCost][SIX_YEAR_VESTING_IN_DAYS] = devCostTokens;
216         _totalSupply = _totalSupply.add(devCostTokens);
217 
218         emit Transfer(address(0), creditcoinFoundation, creditcoinFoundationTokens);
219         emit Transfer(address(0), devCost, devCostTokens);
220     }
221 
222     function totalSupply() public view returns (uint256 amount)
223     {
224         return _totalSupply;
225     }
226 
227     function balanceOf(address owner) public view returns (uint256 balance)
228     {
229         uint256 vestedBalance = vestedBalanceOf(owner);
230         uint256 transferBalance = _balances[owner][TRANSFER_TOKENS_BALANCE];
231         uint256 usedVestedAmount = _balances[owner][USED_VESTED_AMOUNT];
232 
233         return vestedBalance.add(transferBalance).subtract(usedVestedAmount);
234     }
235 
236     function transfer(address to, uint256 value) public returns (bool success)
237     {
238         require(to != address(0), "Invalid to address");
239         require(to != msg.sender, "Can't transfer to self");
240         require(balanceOf(msg.sender) >= value, "Insufficient balance");
241         
242         _removeTokensFromAddress(msg.sender, value);
243         _balances[to][TRANSFER_TOKENS_BALANCE] = _balances[to][TRANSFER_TOKENS_BALANCE].add(value);
244 
245         emit Transfer(msg.sender, to, value);
246 
247         return true;
248     }
249 
250     function transferFrom(address from, address to, uint256 value) public returns (bool success)
251     {
252         require(from != address(0), "Invalid from address");
253         require(to != address(0), "Invalid recipient address");
254         require(balanceOf(from) >= value, "Insufficient balance");
255         require(_allowance[from][msg.sender] >= value, "Allowance exceeded");
256 
257         _removeTokensFromAddress(from, value);
258         _balances[to][TRANSFER_TOKENS_BALANCE] = _balances[to][TRANSFER_TOKENS_BALANCE].add(value);
259         _allowance[from][msg.sender] = _allowance[from][msg.sender].subtract(value);
260 
261         emit Transfer(from, to, value);
262 
263         return true;
264     }
265 
266     function approve(address spender, uint256 value) public returns (bool success)
267     {
268         require(spender != address(0), "Invalid spender address");
269         require(spender != msg.sender, "Can't approve allowance for yourself");
270 
271         _allowance[msg.sender][spender] = value;
272         emit Approval(msg.sender, spender, value);
273         
274         return true;
275     }
276 
277     function allowance(address owner, address spender) public view returns (uint256 remaining)
278     {
279         return _allowance[owner][spender];
280     }
281 
282     function burn(uint256 value) public returns (bool success) 
283     {
284         require(balanceOf(msg.sender) >= value, "Insufficient balance");
285 
286         _removeTokensFromAddress(msg.sender, value);
287         _totalSupply = _totalSupply.subtract(value);
288 
289         emit Burnt(msg.sender, value);
290         emit Transfer(msg.sender, address(0), value);
291 
292         return true;
293     }
294 
295     function burnFrom(address from, uint256 value) public returns (bool success)
296     {
297         require(balanceOf(from) >= value, "Insufficient balance");
298         require(_allowance[from][msg.sender] >= value, "Allowance exceeded");
299 
300         _removeTokensFromAddress(from, value);
301         _allowance[from][msg.sender] = _allowance[from][msg.sender].subtract(value);
302         _totalSupply = _totalSupply.subtract(value);
303 
304         emit Burnt(from, value);
305         emit Transfer(from, address(0), value);
306 
307         return true;
308     }
309 
310     function exchange(uint256 value, string memory sighash) public returns (bool success) 
311     {
312         require(balanceOf(msg.sender) >= value, "Insufficient balance");
313         require(bytes(sighash).length == 60, "Invalid sighash length");
314 
315         _removeTokensFromAddress(msg.sender, value);
316         _totalSupply = _totalSupply.subtract(value);
317 
318         emit Exchange(msg.sender, value, sighash);
319         emit Transfer(msg.sender, address(0), value);
320 
321         return true;
322     }
323 
324     function finalizeSales() public onlyOwner
325     {
326         require(!IsSalesFinalized, "Sales have already been finalized");
327 
328         uint256 remainingTokens = creditcoinSalesLimit.subtract(_totalSupply);
329         _balances[_creditcoinFoundation][SIX_YEAR_VESTING_IN_DAYS] = _balances[_creditcoinFoundation][SIX_YEAR_VESTING_IN_DAYS].add(remainingTokens);
330         _totalSupply = creditcoinSalesLimit;
331         
332         emit Transfer(address(0), _creditcoinFoundation, remainingTokens);
333 
334         IsSalesFinalized = true;
335     }
336 
337     function startVesting() public onlyOwner
338     {
339         require(IsSalesFinalized, "Sales must be finalized before vesting start.");
340         require(VestingStartDate == 0, "Vesting  has already started");
341 
342         VestingStartDate = now;
343     }
344 
345     function recordSale183Days(address tokenHolder, uint256 numCoins) public onlyOwner salesNotFinalized
346     {
347         _recordSale(tokenHolder, SIX_MONTH_VESTING_IN_DAYS, numCoins);
348     }
349 
350     function recordSales183Days(address[] memory tokenHolders, uint256[] memory amounts) public onlyOwner salesNotFinalized
351     {
352         require(tokenHolders.length == amounts.length, "Token holder list and values list length mismatch");
353 
354         for (uint i = 0; i < tokenHolders.length; i++)
355         {
356             recordSale183Days(tokenHolders[i], amounts[i]);
357         }
358     }
359 
360     function recordSale365Days(address tokenHolder, uint256 numCoins) public onlyOwner salesNotFinalized
361     {
362         _recordSale(tokenHolder, ONE_YEAR_VESTING_IN_DAYS, numCoins);
363     }
364 
365     function recordSales365Days(address[] memory tokenHolders, uint256[] memory amounts) public onlyOwner salesNotFinalized
366     {
367         require(tokenHolders.length == amounts.length, "Token holder list and values list length mismatch");
368 
369         for (uint i = 0; i < tokenHolders.length; i++)
370         {
371             recordSale365Days(tokenHolders[i], amounts[i]);
372         }
373     }
374 
375     function recordSale730Days(address tokenHolder, uint256 numCoins) public onlyOwner salesNotFinalized
376     {
377         _recordSale(tokenHolder, TWO_YEAR_VESTING_IN_DAYS, numCoins);
378     }
379 
380     function recordSales730Days(address[] memory tokenHolders, uint256[] memory amounts) public onlyOwner salesNotFinalized
381     {
382         require(tokenHolders.length == amounts.length, "Token holder list and values list length mismatch");
383 
384         for (uint i = 0; i < tokenHolders.length; i++)
385         {
386             recordSale730Days(tokenHolders[i], amounts[i]);
387         }
388     }
389 
390     function recordSale1095Days(address tokenHolder, uint256 numCoins) public onlyOwner salesNotFinalized
391     {
392         _recordSale(tokenHolder, THREE_YEAR_VESTING_IN_DAYS, numCoins);
393     }
394 
395     function recordSales1095Days(address[] memory tokenHolders, uint256[] memory amounts) public onlyOwner salesNotFinalized
396     {
397         require(tokenHolders.length == amounts.length, "Token holder list and values list length mismatch");
398 
399         for (uint i = 0; i < tokenHolders.length; i++)
400         {
401             recordSale1095Days(tokenHolders[i], amounts[i]);
402         }
403     }
404 
405     function recordSale2190Days(address tokenHolder, uint256 numCoins) public onlyOwner salesNotFinalized
406     {
407         _recordSale(tokenHolder, SIX_YEAR_VESTING_IN_DAYS, numCoins);
408     }
409 
410     function recordSales2190Days(address[] memory tokenHolders, uint256[] memory amounts) public onlyOwner salesNotFinalized
411     {
412         require(tokenHolders.length == amounts.length, "Token holder list and values list length mismatch");
413 
414         for (uint i = 0; i < tokenHolders.length; i++)
415         {
416             recordSale2190Days(tokenHolders[i], amounts[i]);
417         }
418     }
419 
420     function vestedBalanceOf183Days(address tokenHolder) public view returns (uint256 balance) 
421     {
422         return _calculateAvailableVestingTokensForPeriod(tokenHolder, SIX_MONTH_VESTING_IN_DAYS);
423     }
424 
425     function vestedBalanceOf365Days(address tokenHolder) public view returns (uint256 balance)
426     {
427         return _calculateAvailableVestingTokensForPeriod(tokenHolder, ONE_YEAR_VESTING_IN_DAYS);
428     }
429 
430     function vestedBalanceOf730Days(address tokenHolder) public view returns (uint256 balance)
431     {
432         return _calculateAvailableVestingTokensForPeriod(tokenHolder, TWO_YEAR_VESTING_IN_DAYS);
433     }
434 
435     function vestedBalanceOf1095Days(address tokenHolder) public view returns (uint256 balance)
436     {
437         return _calculateAvailableVestingTokensForPeriod(tokenHolder, THREE_YEAR_VESTING_IN_DAYS);
438     }
439 
440     function vestedBalanceOf2190Days(address tokenHolder) public view returns (uint256 balance)
441     {
442         return _calculateAvailableVestingTokensForPeriod(tokenHolder, SIX_YEAR_VESTING_IN_DAYS);
443     }
444 
445     function vestedBalanceOf(address tokenHolder) public view returns (uint256 balance)
446     {
447         if (VestingStartDate == 0)
448         {
449             return 0;
450         }
451 
452         uint256 vestedBalance183Days = vestedBalanceOf183Days(tokenHolder);
453         uint256 vestedBalance365Days = vestedBalanceOf365Days(tokenHolder);
454         uint256 vestedBalance730Days = vestedBalanceOf730Days(tokenHolder);
455         uint256 vestedBalance1095Days = vestedBalanceOf1095Days(tokenHolder);
456         uint256 vestedBalance2190Days = vestedBalanceOf2190Days(tokenHolder);
457         
458         return vestedBalance183Days.add(vestedBalance365Days).add(vestedBalance730Days).add(vestedBalance1095Days).add(vestedBalance2190Days);
459     }
460 
461     function purchasedBalanceOf183Days(address tokenHolder) public view returns (uint256 balance)
462     {
463         return _balances[tokenHolder][SIX_MONTH_VESTING_IN_DAYS];
464     }
465 
466     function purchasedBalanceOf365Days(address tokenHolder) public view returns (uint256 balance)
467     {
468         return _balances[tokenHolder][ONE_YEAR_VESTING_IN_DAYS];
469     }
470 
471     function purchasedBalanceOf730Days(address tokenHolder) public view returns (uint256 balance)
472     {
473         return _balances[tokenHolder][TWO_YEAR_VESTING_IN_DAYS];
474     }
475 
476     function purchasedBalanceOf1095Days(address tokenHolder) public view returns (uint256 balance)
477     {
478         return _balances[tokenHolder][THREE_YEAR_VESTING_IN_DAYS];
479     }
480 
481     function purchasedBalanceOf2190Days(address tokenHolder) public view returns (uint256 balance)
482     {
483         return _balances[tokenHolder][SIX_YEAR_VESTING_IN_DAYS];
484     }
485 
486     function purchasedBalanceOf(address tokenHolder) public view returns (uint256 balance)
487     {
488         uint256 purchasedBalance183Days = purchasedBalanceOf183Days(tokenHolder);
489         uint256 purchasedBalance365Days = purchasedBalanceOf365Days(tokenHolder);
490         uint256 purchasedBalance730Days = purchasedBalanceOf730Days(tokenHolder);
491         uint256 purchasedBalance1095Days = purchasedBalanceOf1095Days(tokenHolder);
492         uint256 purchasedBalance2190Days = purchasedBalanceOf2190Days(tokenHolder);
493 
494         return purchasedBalance183Days
495             .add(purchasedBalance365Days)
496             .add(purchasedBalance730Days)
497             .add(purchasedBalance1095Days)
498             .add(purchasedBalance2190Days);
499     }
500 
501     function _calculateAvailableVestingTokensForPeriod(address tokenHolder, uint16 vestingPeriod) private view returns (uint256)
502     {
503         if (VestingStartDate == 0)
504         {
505             return 0;
506         }
507 
508         uint256 numDaysSinceVesting = now.subtract(VestingStartDate).divide(1 days);
509         uint256 totalVestingTokens = _balances[tokenHolder][vestingPeriod];
510 
511         if (numDaysSinceVesting >= vestingPeriod)
512         {
513             return totalVestingTokens;
514         }
515         
516         return totalVestingTokens.multiply(numDaysSinceVesting).divide(vestingPeriod);
517     }
518 
519     function _recordSale(address tokenHolder, uint16 vestingPeriod, uint256 numCoins) private
520     {
521         require(_balances[tokenHolder][vestingPeriod] == 0, "Sales have already been recorded for this address and vestingPeriod");
522 
523         uint256 newTotalSupply = _totalSupply.add(numCoins);
524         require(newTotalSupply <= creditcoinSalesLimit, "Creditcoin sales limit exceeded");
525 
526         _balances[tokenHolder][vestingPeriod] = numCoins;
527         _totalSupply = newTotalSupply;
528 
529         emit Transfer(address(0), tokenHolder, numCoins);
530     }
531 
532     function _removeTokensFromAddress(address from, uint256 value) private
533     {
534         uint256 fromTransferBalance = _balances[from][TRANSFER_TOKENS_BALANCE];
535 
536         if (fromTransferBalance >= value)
537         {
538             _balances[from][TRANSFER_TOKENS_BALANCE] -= value;
539         }
540         else
541         {
542             _balances[from][USED_VESTED_AMOUNT] = _balances[from][USED_VESTED_AMOUNT].add(value - fromTransferBalance);
543             _balances[from][TRANSFER_TOKENS_BALANCE] = 0;
544         }
545     }
546 }