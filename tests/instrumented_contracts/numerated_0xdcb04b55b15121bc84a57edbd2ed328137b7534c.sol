1 pragma solidity ^0.4.20;
2 
3 contract ERC20Interface {
4  
5     function totalSupply() public constant returns (uint);
6     function balanceOf(address tokenOwner) public constant returns (uint balance);
7     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
8     function transfer(address to, uint tokens) public returns (bool success);
9     function approve(address spender, uint tokens) public returns (bool success);
10     function transferFrom(address from, address to, uint tokens) public returns (bool success);
11 
12     event Transfer(address indexed from, address indexed to, uint tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
14 
15 }
16 
17 // ----------------------------------------------------------------------------
18 // Safe maths
19 // ----------------------------------------------------------------------------
20 library SafeMath {
21 
22     function add(uint a, uint b) internal pure returns (uint c) {
23         c = a + b;
24         require(c >= a);
25     }
26     
27     function sub(uint a, uint b) internal pure returns (uint c) {
28         require(b <= a);
29         c = a - b;
30     }
31 
32     function mul(uint a, uint b) internal pure returns (uint c) {
33         c = a * b;
34         require(a == 0 || c / a == b);
35     }
36 
37     function div(uint a, uint b) internal pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 // ----------------------------------------------------------------------------
44 // Contract function to receive approval and execute function in one call
45 //
46 // Borrowed from MiniMeToken
47 // ----------------------------------------------------------------------------
48 contract ApproveAndCallFallBack {
49     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
50 }
51 
52 // ----------------------------------------------------------------------------
53 // Common uitility functions
54 // ----------------------------------------------------------------------------
55 contract Common {
56     
57     function Common() internal {
58 
59     }
60 
61     function getIndexOfTarget(address[] list, address addr) internal pure returns (int) {
62         for (uint i = 0; i < list.length; i++) {
63             if (list[i] == addr) {
64                 return int(i);
65             }
66         }
67         return -1;
68     }
69 }
70 
71 // ----------------------------------------------------------------------------
72 // Owned contract
73 // ----------------------------------------------------------------------------
74 contract Owned {
75     address public owner;
76     address public newOwner;
77     address public operator;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80     event OperatorTransfered(address indexed _from, address indexed _to);
81 
82     function Owned() internal {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     modifier onlyOwnerOrOperator {
92         require(msg.sender == owner || msg.sender == operator);
93         _;
94     }
95 
96     function transferOwnership(address _newOwner) public onlyOwner {
97         newOwner = _newOwner;
98     }
99 
100     function transferOperator(address _newOperator) public onlyOwner {
101         address originalOperator = operator;
102         operator = _newOperator;
103         OperatorTransfered(originalOperator, _newOperator);
104     }
105 
106     function acceptOwnership() public {
107         require(msg.sender == newOwner);
108         OwnershipTransferred(owner, newOwner);
109         owner = newOwner;
110         newOwner = address(0);
111     }
112 }
113 
114 contract TokenHeld {
115     
116     address[] public addressIndices;
117 
118     event OnPushedAddress(address addr, uint index);
119 
120     function TokenHeld() internal {
121     }
122 
123     // ------------------------------------------------------------------------
124     // Scan the addressIndices for ensuring the target address is included
125     // ------------------------------------------------------------------------
126     function scanAddresses(address addr) internal {
127         bool isAddrExist = false;
128         for (uint i = 0;i < addressIndices.length; i++) {
129             if (addressIndices[i] == addr) {
130                 isAddrExist = true;
131                 break;
132             }
133         }
134         if (isAddrExist == false) {
135             addressIndices.push(addr);
136             OnPushedAddress(addr, addressIndices.length);
137         }
138     }
139 }
140 
141 contract Restricted is Common, Owned {
142 
143     bool isChargingTokenTransferFee;
144     bool isAllocatingInterest;
145     bool isChargingManagementFee;
146     bool isTokenTransferOpen;
147 
148     address[] tokenTransferDisallowedAddresses;
149 
150     event OnIsChargingTokenTransferFeeUpdated(bool from, bool to);
151     event OnIsAllocatingInterestUpdated(bool from, bool to);
152     event OnIsChargingManagementFeeUpdated(bool from, bool to);
153     event OnIsTokenTransferOpenUpdated(bool from, bool to);
154     event OnTransferDisallowedAddressesChanged(string action, address indexed addr);
155     
156     modifier onlyWhenAllocatingInterestOpen {
157         require(isAllocatingInterest == true);
158         _;
159     }
160 
161     modifier onlyWhenChargingManagementFeeOpen {
162         require(isChargingManagementFee == true);
163         _;
164     }
165 
166     modifier onlyWhenTokenTransferOpen {
167         require(isTokenTransferOpen == true);
168         _;
169     }
170 
171     modifier shouldBeAllowed(address[] list, address addr) {
172         require(getIndexOfTarget(list, addr) == -1);
173         _;
174     }
175     
176     function Restricted() internal {
177         isChargingTokenTransferFee = false;
178         isAllocatingInterest = false;
179         isChargingManagementFee = false;
180         isTokenTransferOpen = true;
181     }
182     
183     function setIsChargingTokenTransferFee(bool onOff) public onlyOwnerOrOperator {
184         bool original = isChargingTokenTransferFee;
185         isChargingTokenTransferFee = onOff;
186         OnIsChargingTokenTransferFeeUpdated(original, onOff);
187     }
188 
189     function setIsAllocatingInterest(bool onOff) public onlyOwnerOrOperator {
190         bool original = isAllocatingInterest;
191         isAllocatingInterest = onOff;
192         OnIsAllocatingInterestUpdated(original, onOff);
193     }
194 
195     function setIsChargingManagementFee(bool onOff) public onlyOwnerOrOperator {
196         bool original = isChargingManagementFee;
197         isChargingManagementFee = onOff;
198         OnIsChargingManagementFeeUpdated(original, onOff);
199     }
200 
201     function setIsTokenTransferOpen(bool onOff) public onlyOwnerOrOperator {
202         bool original = isTokenTransferOpen;
203         isTokenTransferOpen = onOff;
204         OnIsTokenTransferOpenUpdated(original, onOff);
205     }
206 
207     function addToTokenTransferDisallowedList(address addr) public onlyOwnerOrOperator {
208         int idx = getIndexOfTarget(tokenTransferDisallowedAddresses, addr);
209         if (idx == -1) {
210             tokenTransferDisallowedAddresses.push(addr);
211             OnTransferDisallowedAddressesChanged("add", addr);
212         }
213     }
214 
215     function removeFromTokenTransferDisallowedAddresses(address addr) public onlyOwnerOrOperator {
216         int idx = getIndexOfTarget(tokenTransferDisallowedAddresses, addr);
217         if (idx >= 0) {
218             uint uidx = uint(idx);
219             delete tokenTransferDisallowedAddresses[uidx];
220             OnTransferDisallowedAddressesChanged("remove", addr);
221         }
222     }
223 }
224 
225 contract TokenTransaction is Common, Owned {
226 
227     bool isTokenTransactionOpen;
228 
229     address[] transactionDisallowedAddresses;
230 
231     uint exchangeRateFor1Eth;
232 
233     event OnIsTokenTransactionOpenUpdated(bool from, bool to);
234     event OnTransactionDisallowedAddressesChanged(string action, address indexed addr);
235     event OnExchangeRateUpdated(uint from, uint to);
236 
237     modifier onlyWhenTokenTransactionOpen {
238         require(isTokenTransactionOpen == true);
239         _;
240     }
241 
242     function TokenTransaction() internal {
243         isTokenTransactionOpen = true;
244         exchangeRateFor1Eth = 1000;
245     }
246 
247     function setIsTokenTransactionOpen(bool onOff) public onlyOwnerOrOperator {
248         bool original = isTokenTransactionOpen;
249         isTokenTransactionOpen = onOff;
250         OnIsTokenTransactionOpenUpdated(original, onOff);
251     }
252 
253     function addToTransactionDisallowedList(address addr) public constant onlyOwnerOrOperator {
254         int idx = getIndexOfTarget(transactionDisallowedAddresses, addr);
255         if (idx == -1) {
256             transactionDisallowedAddresses.push(addr);
257             OnTransactionDisallowedAddressesChanged("add", addr);
258         }
259     }
260 
261     function removeFromTransactionDisallowedList(address addr) public constant onlyOwnerOrOperator {
262         int idx = getIndexOfTarget(transactionDisallowedAddresses, addr);
263         if (idx >= 0) {
264             uint uidx = uint(idx);
265             delete transactionDisallowedAddresses[uidx];
266             OnTransactionDisallowedAddressesChanged("remove", addr);
267         }
268     }
269 
270     function updateExchangeRate(uint newExchangeRate) public onlyOwner {
271         uint originalRate = exchangeRateFor1Eth;
272         exchangeRateFor1Eth = newExchangeRate;
273         OnExchangeRateUpdated(originalRate, newExchangeRate);
274     }
275 }
276 
277 contract Distributed is Owned {
278     using SafeMath for uint;
279     
280     // Allocation related
281     uint tokenTransferPercentageNumerator;
282     uint tokenTransferPercentageDenominator;
283     uint interestAllocationPercentageNumerator;
284     uint interestAllocationPercentageDenominator;
285     uint managementFeeChargePercentageNumerator;
286     uint managementFeeChargePercentageDenominator;
287 
288     uint distCompanyPercentage;
289     uint distTeamPercentage;
290     uint distOfferPercentage;
291 
292     event OnPercentageChanged(string state, uint _m, uint _d, uint m, uint d);
293     event OnDistributionChanged(uint _c, uint _t, uint _o, uint c, uint t, uint o);
294     
295     modifier onlyWhenPercentageSettingIsValid(uint c, uint t, uint o) {
296         require((c.add(t).add(o)) == 100);
297         _;
298     }
299 
300     function Distributed() internal {
301 
302         tokenTransferPercentageNumerator = 1;
303         tokenTransferPercentageDenominator = 100;
304         interestAllocationPercentageNumerator = 1;
305         interestAllocationPercentageDenominator = 100;
306         managementFeeChargePercentageNumerator = 1;
307         managementFeeChargePercentageDenominator = 100;
308 
309         distCompanyPercentage = 20;
310         distTeamPercentage = 10;
311         distOfferPercentage = 70;
312     }
313 
314     function setTokenTransferPercentage(uint numerator, uint denominator) public onlyOwnerOrOperator {
315         uint m = tokenTransferPercentageNumerator;
316         uint d = tokenTransferPercentageDenominator;
317         tokenTransferPercentageNumerator = numerator;
318         tokenTransferPercentageDenominator = denominator;
319         OnPercentageChanged("TokenTransferFee", m, d, numerator, denominator);
320     }
321 
322     function setInterestAllocationPercentage(uint numerator, uint denominator) public onlyOwnerOrOperator {
323         uint m = interestAllocationPercentageNumerator;
324         uint d = interestAllocationPercentageDenominator;
325         interestAllocationPercentageNumerator = numerator;
326         interestAllocationPercentageDenominator = denominator;
327         OnPercentageChanged("InterestAllocation", m, d, numerator, denominator);
328     }
329 
330     function setManagementFeeChargePercentage(uint numerator, uint denominator) public onlyOwnerOrOperator {
331         uint m = managementFeeChargePercentageNumerator;
332         uint d = managementFeeChargePercentageDenominator;
333         managementFeeChargePercentageNumerator = numerator;
334         managementFeeChargePercentageDenominator = denominator;
335         OnPercentageChanged("ManagementFee", m, d, numerator, denominator);
336     }
337 
338     function setDistributionPercentage(uint c, uint t, uint o) public onlyWhenPercentageSettingIsValid(c, t, o) onlyOwner {
339         uint _c = distCompanyPercentage;
340         uint _t = distTeamPercentage;
341         uint _o = distOfferPercentage;
342         distCompanyPercentage = c;
343         distTeamPercentage = t;
344         distOfferPercentage = o;
345         OnDistributionChanged(_c, _t, _o, distCompanyPercentage, distTeamPercentage, distOfferPercentage);
346     }
347 }
348 
349 contract FeeCalculation {
350     using SafeMath for uint;
351     
352     function FeeCalculation() internal {
353 
354     }
355 
356     // ------------------------------------------------------------------------
357     // Calculate the fee tokens for transferring.
358     // ------------------------------------------------------------------------
359     function calculateTransferFee(uint tokens) internal pure returns (uint) {
360         uint calFee = 0;
361         if (tokens > 0 && tokens <= 1000)
362             calFee = 1;
363         else if (tokens > 1000 && tokens <= 5000)
364             calFee = tokens.mul(1).div(1000);
365         else if (tokens > 5000 && tokens <= 10000)
366             calFee = tokens.mul(2).div(1000);
367         else if (tokens > 10000)
368             calFee = 30;
369         return calFee;
370     }
371 }
372 
373 // ----------------------------------------------------------------------------
374 // initial fixed supply
375 // ----------------------------------------------------------------------------
376 contract FixedSupplyToken is ERC20Interface, Distributed, TokenHeld, Restricted, TokenTransaction, FeeCalculation {
377     using SafeMath for uint;
378 
379     // Token information related
380     string public symbol;
381     string public  name;
382     uint8 public decimals;
383     uint public _totalSupply;
384 
385     mapping(address => uint) balances;
386     mapping(address => mapping(address => uint)) allowed;
387 
388     event OnAllocated(address indexed addr, uint allocatedTokens);
389     event OnCharged(address indexed addr, uint chargedTokens);
390     
391     modifier onlyWhenOfferredIsLowerThanDistOfferPercentage {
392         uint expectedTokens = msg.value.mul(1000);
393         uint totalOfferredTokens = 0;
394         for (uint i = 0; i < addressIndices.length; i++) {
395             totalOfferredTokens += balances[addressIndices[i]];
396         }
397         require(_totalSupply.mul(distOfferPercentage).div(100) - expectedTokens >= 0);
398         _;
399     }
400 
401     // ------------------------------------------------------------------------
402     // Constructor
403     // ------------------------------------------------------------------------
404     function FixedSupplyToken() public {
405         symbol = "AGC";
406         name = "Agile Coin";
407         decimals = 0;
408         _totalSupply = 100000000 * 10**uint(decimals);
409 
410         balances[owner] = _totalSupply;
411         Transfer(address(0), owner, _totalSupply);
412     }
413 
414     // ------------------------------------------------------------------------
415     // Total supply
416     // ------------------------------------------------------------------------
417     function totalSupply() public constant returns (uint) {
418         uint balance = balances[address(0)];
419         return _totalSupply - balance;
420     }
421 
422     // ------------------------------------------------------------------------
423     // Get the token balance for account `tokenOwner`
424     // ------------------------------------------------------------------------
425     function balanceOf(address tokenOwner) public constant returns (uint balance) {
426         return balances[tokenOwner];
427     }
428 
429     // ------------------------------------------------------------------------
430     // Transfer the balance from token owner's account to `to` account
431     // - Owner's account must have sufficient balance to transfer
432     // - 0 value transfers are allowed
433     // ------------------------------------------------------------------------
434     function transfer(address to, uint tokens) public onlyWhenTokenTransferOpen shouldBeAllowed(transactionDisallowedAddresses, msg.sender) returns (bool success) {
435         uint calFee = isChargingTokenTransferFee ? calculateTransferFee(tokens) : 0;
436         scanAddresses(to);
437         balances[msg.sender] = balances[msg.sender].sub(tokens + calFee);
438 		balances[owner] = balances[owner].add(calFee);
439         balances[to] = balances[to].add(tokens);
440         Transfer(msg.sender, to, tokens);
441         Transfer(msg.sender, owner, calFee);
442         return true;
443     }
444 
445     // ------------------------------------------------------------------------
446     // Token owner can approve for `spender` to transferFrom(...) `tokens`
447     // from the token owner's account
448     //
449     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
450     // recommends that there are no checks for the approval double-spend attack
451     // as this should be implemented in user interfaces 
452     // ------------------------------------------------------------------------
453     function approve(address spender, uint tokens) public returns (bool success) {
454         allowed[msg.sender][spender] = tokens;
455         Approval(msg.sender, spender, tokens);
456         return true;
457     }
458 
459     // ------------------------------------------------------------------------
460     // Transfer `tokens` from the `from` account to the `to` account
461     // 
462     // The calling account must already have sufficient tokens approve(...)-d
463     // for spending from the `from` account and
464     // - From account must have sufficient balance to transfer
465     // - Spender must have sufficient allowance to transfer
466     // - 0 value transfers are allowed
467     // ------------------------------------------------------------------------
468     function transferFrom(address from, address to, uint tokens) public onlyWhenTokenTransferOpen shouldBeAllowed(tokenTransferDisallowedAddresses, msg.sender) returns (bool success) {
469         uint calFee = isChargingTokenTransferFee ? calculateTransferFee(tokens) : 0;
470         scanAddresses(to);
471         balances[from] = balances[from].sub(tokens + calFee);
472         balances[owner] = balances[owner].add(calFee);
473         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
474         balances[to] = balances[to].add(tokens);
475         Transfer(from, to, tokens);
476         Transfer(from, owner, calFee);
477         return true;
478     }
479 
480     // ------------------------------------------------------------------------
481     // Returns the amount of tokens approved by the owner that can be
482     // transferred to the spender's account
483     // ------------------------------------------------------------------------
484     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
485         return allowed[tokenOwner][spender];
486     }
487 
488     // ------------------------------------------------------------------------
489     // Token owner can approve for `spender` to transferFrom(...) `tokens`
490     // from the token owner's account. The `spender` contract function
491     // `receiveApproval(...)` is then executed
492     // ------------------------------------------------------------------------
493     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
494         allowed[msg.sender][spender] = tokens;
495         Approval(msg.sender, spender, tokens);
496         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
497         return true;
498     }
499 
500     // ------------------------------------------------------------------------
501     // Don't accept ETH
502     // ------------------------------------------------------------------------
503     function () public payable onlyWhenTokenTransactionOpen onlyWhenOfferredIsLowerThanDistOfferPercentage {
504         // Exchange: ETH --> ETTA Coin
505         revert();
506     }
507 
508     // ------------------------------------------------------------------------
509     // Owner can transfer out any accidentally sent ERC20 tokens
510     // ------------------------------------------------------------------------
511     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
512         return ERC20Interface(tokenAddress).transfer(owner, tokens);
513     }
514     
515     // ------------------------------------------------------------------------
516     // Allocate interest.
517     // ------------------------------------------------------------------------
518     function allocateTokens() public onlyOwnerOrOperator onlyWhenAllocatingInterestOpen {
519         for (uint i = 0; i < addressIndices.length; i++) {
520             address crntAddr = addressIndices[i];
521             uint balanceOfCrntAddr = balances[crntAddr];
522             uint allocatedTokens = balanceOfCrntAddr.mul(interestAllocationPercentageNumerator).div(interestAllocationPercentageDenominator);
523             balances[crntAddr] = balances[crntAddr].add(allocatedTokens);
524             balances[owner] = balances[owner].sub(allocatedTokens);
525             Transfer(owner, crntAddr, allocatedTokens);
526             OnAllocated(crntAddr, allocatedTokens);
527         }
528     }
529 
530     // ------------------------------------------------------------------------
531     // Charge investers for management fee.
532     // ------------------------------------------------------------------------
533     function chargeTokensForManagement() public onlyOwnerOrOperator onlyWhenChargingManagementFeeOpen {
534         for (uint i = 0; i < addressIndices.length; i++) {
535             address crntAddr = addressIndices[i];
536             uint balanceOfCrntAddr = balances[crntAddr];
537             uint chargedTokens = balanceOfCrntAddr.mul(managementFeeChargePercentageNumerator).div(managementFeeChargePercentageDenominator);
538             balances[crntAddr] = balances[crntAddr].sub(chargedTokens);
539             balances[owner] = balances[owner].add(chargedTokens);
540             Transfer(crntAddr,owner, chargedTokens);
541             OnCharged(crntAddr, chargedTokens);
542         }
543     }
544 
545     // ------------------------------------------------------------------------
546     // Distribute more token of contract and transfer to owner 
547     // ------------------------------------------------------------------------
548     function mintToken(uint256 mintedAmount) public onlyOwner {
549         require(mintedAmount > 0);
550         balances[owner] = balances[owner].add(mintedAmount);
551         _totalSupply = _totalSupply.add(mintedAmount);
552         Transfer(address(0), owner, mintedAmount);
553     }
554 
555     event OnTokenBurned(uint256 totalBurnedTokens);
556 
557     // ------------------------------------------------------------------------
558     // Remove `numerator / denominator` % of tokens from the system irreversibly
559     // ------------------------------------------------------------------------
560     function burnByPercentage(uint8 m, uint8 d) public onlyOwner returns (bool success) {
561         require(m > 0 && d > 0 && m <= d);
562         uint totalBurnedTokens = balances[owner].mul(m).div(d);
563         balances[owner] = balances[owner].sub(totalBurnedTokens);
564         _totalSupply = _totalSupply.sub(totalBurnedTokens);
565         Transfer(owner, address(0), totalBurnedTokens);
566         OnTokenBurned(totalBurnedTokens);
567         return true;
568     }
569 
570     // ------------------------------------------------------------------------
571     // Remove a quantity of tokens
572     // ------------------------------------------------------------------------
573     function burnByAmount(uint256 tokens) public onlyOwner returns (bool success) {
574         require(tokens > 0 && tokens <= balances[owner]);
575         balances[owner] = balances[owner].sub(tokens);
576         _totalSupply = _totalSupply.sub(tokens);
577         Transfer(owner, address(0), tokens);
578         OnTokenBurned(tokens);
579         return true;
580     }
581 }