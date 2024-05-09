1 pragma solidity ^0.4.21;
2 
3 
4 contract Owner {
5     address public owner;
6 
7     modifier onlyOwner() {
8         require(msg.sender == owner);
9         _;
10     }
11 
12     function Owner(address _owner) public {
13         owner = _owner;
14     }
15 
16     function changeOwner(address _newOwnerAddr) public onlyOwner {
17         require(_newOwnerAddr != address(0));
18         owner = _newOwnerAddr;
19     }
20 }
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     /**
29     * @dev Multiplies two numbers, throws on overflow.
30     */
31     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32         if (a == 0) {
33             return 0;
34         }
35         uint256 c = a * b;
36         assert(c / a == b);
37         return c;
38     }
39 
40     /**
41     * @dev Integer division of two numbers, truncating the quotient.
42     */
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         // assert(b > 0); // Solidity automatically throws when dividing by 0
45         uint256 c = a / b;
46         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
47         return c;
48     }
49 
50     /**
51     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
52     */
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         assert(b <= a);
55         return a - b;
56     }
57 
58     /**
59     * @dev Adds two numbers, throws on overflow.
60     */
61     function add(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a + b;
63         assert(c >= a);
64         return c;
65     }
66 }
67 
68 
69 contract GreenX is Owner {
70     using SafeMath for uint256;
71 
72     string public constant name = "GREENX";
73     string public constant symbol = "GEX";
74     uint public constant decimals = 18;
75     uint256 constant public totalSupply = 375000000 * 10 ** 18; // 375 mil tokens will be supplied
76   
77     mapping(address => uint256) internal balances;
78     mapping(address => mapping (address => uint256)) internal allowed;
79 
80     address public portalAddress;
81     address public adminAddress;
82     address public walletAddress;
83     address public founderAddress;
84     address public teamAddress;
85 
86     mapping(address => bool) public privateList;
87     mapping(address => bool) public whiteList;
88     mapping(address => uint256) public totalInvestedAmountOf;
89 
90     uint constant lockPeriod1 = 180 days; // 1st locked period for tokens allocation of founder and team
91     uint constant lockPeriod2 = 1 years; // 2nd locked period for tokens allocation of founder and team
92     uint constant lockPeriod3 = 2 years; // locked period for remaining sale tokens after ending ICO
93     uint constant NOT_SALE = 0; // Not in sales
94     uint constant IN_PRIVATE_SALE = 1; // In private sales
95     uint constant IN_PRESALE = 2; // In presales
96     uint constant END_PRESALE = 3; // End presales
97     uint constant IN_1ST_ICO = 4; // In ICO 1st round
98     uint constant IN_2ND_ICO = 5; // In ICO 2nd round
99     uint constant IN_3RD_ICO = 6; // In ICO 3rd round
100     uint constant END_SALE = 7; // End sales
101 
102     uint256 public constant salesAllocation = 187500000 * 10 ** 18; // 187.5 mil tokens allocated for sales
103     uint256 public constant bonusAllocation = 37500000 * 10 ** 18; // 37.5 mil tokens allocated for token sale bonuses
104     uint256 public constant reservedAllocation = 90000000 * 10 ** 18; // 90 mil tokens allocated for reserved, bounty campaigns, ICO partners, and bonus fund
105     uint256 public constant founderAllocation = 37500000 * 10 ** 18; // 37.5 mil tokens allocated for founders
106     uint256 public constant teamAllocation = 22500000 * 10 ** 18; // 22.5 mil tokens allocated for team
107     uint256 public constant minInvestedCap = 2500 * 10 ** 18; // 2500 ether for softcap 
108     uint256 public constant minInvestedAmount = 0.1 * 10 ** 18; // 0.1 ether for mininum ether contribution per transaction
109     
110     uint saleState;
111     uint256 totalInvestedAmount;
112     uint public icoStartTime;
113     uint public icoEndTime;
114     bool public inActive;
115     bool public isSelling;
116     bool public isTransferable;
117     uint public founderAllocatedTime = 1;
118     uint public teamAllocatedTime = 1;
119     uint256 public privateSalePrice;
120     uint256 public preSalePrice;
121     uint256 public icoStandardPrice;
122     uint256 public ico1stPrice;
123     uint256 public ico2ndPrice;
124     uint256 public totalRemainingTokensForSales; // Total tokens remaining for sales
125     uint256 public totalReservedAndBonusTokenAllocation; // Total tokens allocated for reserved and bonuses
126     uint256 public totalLoadedRefund; // Total ether will be loaded to contract for refund
127     uint256 public totalRefundedAmount; // Total ether refunded to investors
128 
129     event Approval(address indexed owner, address indexed spender, uint256 value); // ERC20 standard event
130     event Transfer(address indexed from, address indexed to, uint256 value); // ERC20 standard event
131 
132     event ModifyWhiteList(address investorAddress, bool isWhiteListed);  // Add or remove investor's address to or from white list
133     event ModifyPrivateList(address investorAddress, bool isPrivateListed);  // Add or remove investor's address to or from private list
134     event StartPrivateSales(uint state); // Start private sales
135     event StartPresales(uint state); // Start presales
136     event EndPresales(uint state); // End presales
137     event StartICO(uint state); // Start ICO sales
138     event EndICO(uint state); // End ICO sales
139     
140     event SetPrivateSalePrice(uint256 price); // Set private sale price
141     event SetPreSalePrice(uint256 price); // Set presale price
142     event SetICOPrice(uint256 price); // Set ICO standard price
143     
144     event IssueTokens(address investorAddress, uint256 amount, uint256 tokenAmount, uint state); // Issue tokens to investor
145     event RevokeTokens(address investorAddress, uint256 amount, uint256 tokenAmount, uint256 txFee); // Revoke tokens after ending ICO for incompleted KYC investors
146     event AllocateTokensForFounder(address founderAddress, uint256 founderAllocatedTime, uint256 tokenAmount); // Allocate tokens to founders' address
147     event AllocateTokensForTeam(address teamAddress, uint256 teamAllocatedTime, uint256 tokenAmount); // Allocate tokens to team's address
148     event AllocateReservedTokens(address reservedAddress, uint256 tokenAmount); // Allocate reserved tokens
149     event Refund(address investorAddress, uint256 etherRefundedAmount, uint256 tokensRevokedAmount); // Refund ether and revoke tokens for investors
150 
151     modifier isActive() {
152         require(inActive == false);
153         _;
154     }
155 
156     modifier isInSale() {
157         require(isSelling == true);
158         _;
159     }
160 
161     modifier transferable() {
162         require(isTransferable == true);
163         _;
164     }
165 
166     modifier onlyOwnerOrAdminOrPortal() {
167         require(msg.sender == owner || msg.sender == adminAddress || msg.sender == portalAddress);
168         _;
169     }
170 
171     modifier onlyOwnerOrAdmin() {
172         require(msg.sender == owner || msg.sender == adminAddress);
173         _;
174     }
175 
176     function GreenX(address _walletAddr, address _adminAddr, address _portalAddr) public Owner(msg.sender) {
177         require(_walletAddr != address(0));
178         require(_adminAddr != address(0));
179         require(_portalAddr != address(0));
180 		
181         walletAddress = _walletAddr;
182         adminAddress = _adminAddr;
183         portalAddress = _portalAddr;
184         inActive = true;
185         totalInvestedAmount = 0;
186         totalRemainingTokensForSales = salesAllocation;
187         totalReservedAndBonusTokenAllocation = reservedAllocation + bonusAllocation;
188     }
189 
190     // Fallback function for token purchasing  
191     function () external payable isActive isInSale {
192         uint state = getCurrentState();
193         require(state >= IN_PRIVATE_SALE && state < END_SALE);
194         require(msg.value >= minInvestedAmount);
195 
196         bool isPrivate = privateList[msg.sender];
197         if (isPrivate == true) {
198             return issueTokensForPrivateInvestor(state);
199         }
200         if (state == IN_PRESALE) {
201             return issueTokensForPresale(state);
202         }
203         if (IN_1ST_ICO <= state && state <= IN_3RD_ICO) {
204             return issueTokensForICO(state);
205         }
206         revert();
207     }
208 
209     // Load ether amount to contract for refunding or revoking
210     function loadFund() external payable {
211         require(msg.value > 0);
212 		
213         totalLoadedRefund = totalLoadedRefund.add(msg.value);
214     }
215 
216     // ERC20 standard function
217     function transfer(address _to, uint256 _value) external transferable returns (bool) {
218         require(_to != address(0));
219         require(_value > 0);
220 
221         balances[msg.sender] = balances[msg.sender].sub(_value);
222         balances[_to] = balances[_to].add(_value);
223         emit Transfer(msg.sender, _to, _value);
224         return true;
225     }
226 
227     // ERC20 standard function
228     function transferFrom(address _from, address _to, uint256 _value) external transferable returns (bool) {
229         require(_to != address(0));
230         require(_from != address(0));
231         require(_value > 0);
232 
233         balances[_from] = balances[_from].sub(_value);
234         balances[_to] = balances[_to].add(_value);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         emit Transfer(_from, _to, _value);
237         return true;
238     }
239 
240     // ERC20 standard function
241     function approve(address _spender, uint256 _value) external transferable returns (bool) {
242         require(_spender != address(0));
243         require(_value > 0);
244 		
245         allowed[msg.sender][_spender] = _value;
246         emit Approval(msg.sender, _spender, _value);
247         return true;
248     }
249 
250     // Modify white list
251     function modifyWhiteList(address[] _investorAddrs, bool _isWhiteListed) external isActive onlyOwnerOrAdminOrPortal returns(bool) {
252         for (uint256 i = 0; i < _investorAddrs.length; i++) {
253             whiteList[_investorAddrs[i]] = _isWhiteListed;
254             emit ModifyWhiteList(_investorAddrs[i], _isWhiteListed);
255         }
256         return true;
257     }
258 
259     // Modify private list
260     function modifyPrivateList(address[] _investorAddrs, bool _isPrivateListed) external isActive onlyOwnerOrAdminOrPortal returns(bool) {
261         for (uint256 i = 0; i < _investorAddrs.length; i++) {
262             privateList[_investorAddrs[i]] = _isPrivateListed;
263             emit ModifyPrivateList(_investorAddrs[i], _isPrivateListed);
264         }
265         return true;
266     }
267 
268     // Start private sales
269     function startPrivateSales() external isActive onlyOwnerOrAdmin returns (bool) {
270         require(saleState == NOT_SALE);
271         require(privateSalePrice > 0);
272 		
273         saleState = IN_PRIVATE_SALE;
274         isSelling = true;
275         emit StartPrivateSales(saleState);
276         return true;
277     }
278 
279     // Start presales
280     function startPreSales() external isActive onlyOwnerOrAdmin returns (bool) {
281         require(saleState < IN_PRESALE);
282         require(preSalePrice > 0);
283 		
284         saleState = IN_PRESALE;
285         isSelling = true;
286         emit StartPresales(saleState);
287         return true;
288     }
289 
290     // End presales
291     function endPreSales() external isActive onlyOwnerOrAdmin returns (bool) {
292         require(saleState == IN_PRESALE);
293 		
294         saleState = END_PRESALE;
295         isSelling = false;
296         emit EndPresales(saleState);
297         return true;
298     }
299 
300     // Start ICO
301     function startICO() external isActive onlyOwnerOrAdmin returns (bool) {
302         require(saleState == END_PRESALE);
303         require(icoStandardPrice > 0);
304 		
305         saleState = IN_1ST_ICO;
306         icoStartTime = now;
307         isSelling = true;
308         emit StartICO(saleState);
309         return true;
310     }
311 
312     // End ICO
313     function endICO() external isActive onlyOwnerOrAdmin returns (bool) {
314         require(getCurrentState() == IN_3RD_ICO);
315         require(icoEndTime == 0);
316 		
317         saleState = END_SALE;
318         isSelling = false;
319         icoEndTime = now;
320         emit EndICO(saleState);
321         return true;
322     }
323 
324     // Set private sales price
325     function setPrivateSalePrice(uint256 _tokenPerEther) external onlyOwnerOrAdmin returns(bool) {
326         require(_tokenPerEther > 0);
327 		
328         privateSalePrice = _tokenPerEther;
329         emit SetPrivateSalePrice(privateSalePrice);
330         return true;
331     }
332 
333     // Set presales price
334     function setPreSalePrice(uint256 _tokenPerEther) external onlyOwnerOrAdmin returns(bool) {
335         require(_tokenPerEther > 0);
336 		
337         preSalePrice = _tokenPerEther;
338         emit SetPreSalePrice(preSalePrice);
339         return true;
340     }
341 
342     // Set ICO price including ICO standard price, ICO 1st round price, ICO 2nd round price
343     function setICOPrice(uint256 _tokenPerEther) external onlyOwnerOrAdmin returns(bool) {
344         require(_tokenPerEther > 0);
345 		
346         icoStandardPrice = _tokenPerEther;
347         ico1stPrice = _tokenPerEther + _tokenPerEther * 20 / 100;
348         ico2ndPrice = _tokenPerEther + _tokenPerEther * 10 / 100;
349         emit SetICOPrice(icoStandardPrice);
350         return true;
351     }
352 
353     // Revoke tokens from incompleted KYC investors' addresses
354     function revokeTokens(address _noneKycAddr, uint256 _transactionFee) external onlyOwnerOrAdmin {
355         require(_noneKycAddr != address(0));
356         uint256 investedAmount = totalInvestedAmountOf[_noneKycAddr];
357         uint256 totalRemainingRefund = totalLoadedRefund.sub(totalRefundedAmount);
358         require(whiteList[_noneKycAddr] == false && privateList[_noneKycAddr] == false);
359         require(investedAmount > 0);
360         require(totalRemainingRefund >= investedAmount);
361         require(saleState == END_SALE);
362 		
363         uint256 refundAmount = investedAmount.sub(_transactionFee);
364         uint tokenRevoked = balances[_noneKycAddr];
365         totalInvestedAmountOf[_noneKycAddr] = 0;
366         balances[_noneKycAddr] = 0;
367         totalRemainingTokensForSales = totalRemainingTokensForSales.add(tokenRevoked);
368         totalRefundedAmount = totalRefundedAmount.add(refundAmount);
369         _noneKycAddr.transfer(refundAmount);
370         emit RevokeTokens(_noneKycAddr, refundAmount, tokenRevoked, _transactionFee);
371     }    
372 
373     // Investors can claim ether refund if total raised fund doesn't reach our softcap
374     function refund() external {
375         uint256 refundedAmount = totalInvestedAmountOf[msg.sender];
376         uint256 totalRemainingRefund = totalLoadedRefund.sub(totalRefundedAmount);
377         uint256 tokenRevoked = balances[msg.sender];
378         require(saleState == END_SALE);
379         require(!isSoftCapReached());
380         require(totalRemainingRefund >= refundedAmount && refundedAmount > 0);
381 		
382         totalInvestedAmountOf[msg.sender] = 0;
383         balances[msg.sender] = 0;
384         totalRemainingTokensForSales = totalRemainingTokensForSales.add(tokenRevoked);
385         totalRefundedAmount = totalRefundedAmount.add(refundedAmount);
386         msg.sender.transfer(refundedAmount);
387         emit Refund(msg.sender, refundedAmount, tokenRevoked);
388     }    
389 
390     // Activate token sale function
391     function activate() external onlyOwner {
392         inActive = false;
393     }
394 
395     // Deacivate token sale function
396     function deActivate() external onlyOwner {
397         inActive = true;
398     }
399 
400     // Enable transfer feature of tokens
401     function enableTokenTransfer() external isActive onlyOwner {
402         isTransferable = true;
403     }
404 
405     // Modify wallet
406     function changeWallet(address _newAddress) external onlyOwner {
407         require(_newAddress != address(0));
408         require(walletAddress != _newAddress);
409         walletAddress = _newAddress;
410     }
411 
412     // Modify admin
413     function changeAdminAddress(address _newAddress) external onlyOwner {
414         require(_newAddress != address(0));
415         require(adminAddress != _newAddress);
416         adminAddress = _newAddress;
417     }
418 
419     // Modify portal
420     function changePortalAddress(address _newAddress) external onlyOwner {
421         require(_newAddress != address(0));
422         require(portalAddress != _newAddress);
423         portalAddress = _newAddress;
424     }
425   
426     // Modify founder address to receive founder tokens allocation
427     function changeFounderAddress(address _newAddress) external onlyOwnerOrAdmin {
428         require(_newAddress != address(0));
429         require(founderAddress != _newAddress);
430         founderAddress = _newAddress;
431     }
432 
433     // Modify team address to receive team tokens allocation
434     function changeTeamAddress(address _newAddress) external onlyOwnerOrAdmin {
435         require(_newAddress != address(0));
436         require(teamAddress != _newAddress);
437         teamAddress = _newAddress;
438     }
439 
440     // Allocate tokens for founder vested gradually for 1 year
441     function allocateTokensForFounder() external isActive onlyOwnerOrAdmin {
442         require(saleState == END_SALE);
443         require(founderAddress != address(0));
444         uint256 amount;
445         if (founderAllocatedTime == 1) {
446             amount = founderAllocation * 20/100;
447             balances[founderAddress] = balances[founderAddress].add(amount);
448             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
449             founderAllocatedTime = 2;
450             return;
451         }
452         if (founderAllocatedTime == 2) {
453             require(now >= icoEndTime + lockPeriod1);
454             amount = founderAllocation * 30/100;
455             balances[founderAddress] = balances[founderAddress].add(amount);
456             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
457             founderAllocatedTime = 3;
458             return;
459         }
460         if (founderAllocatedTime == 3) {
461             require(now >= icoEndTime + lockPeriod2);
462             amount = founderAllocation * 50/100;
463             balances[founderAddress] = balances[founderAddress].add(amount);
464             emit AllocateTokensForFounder(founderAddress, founderAllocatedTime, amount);
465             founderAllocatedTime = 4;
466             return;
467         }
468         revert();
469     }
470 
471     // Allocate tokens for team vested gradually for 1 year
472     function allocateTokensForTeam() external isActive onlyOwnerOrAdmin {
473         require(saleState == END_SALE);
474         require(teamAddress != address(0));
475         uint256 amount;
476         if (teamAllocatedTime == 1) {
477             amount = teamAllocation * 20/100;
478             balances[teamAddress] = balances[teamAddress].add(amount);
479             emit AllocateTokensForTeam(teamAddress, teamAllocatedTime, amount);
480             teamAllocatedTime = 2;
481             return;
482         }
483         if (teamAllocatedTime == 2) {
484             require(now >= icoEndTime + lockPeriod1);
485             amount = teamAllocation * 30/100;
486             balances[teamAddress] = balances[teamAddress].add(amount);
487             emit AllocateTokensForTeam(teamAddress, teamAllocatedTime, amount);
488             teamAllocatedTime = 3;
489             return;
490         }
491         if (teamAllocatedTime == 3) {
492             require(now >= icoEndTime + lockPeriod2);
493             amount = teamAllocation * 50/100;
494             balances[teamAddress] = balances[teamAddress].add(amount);
495             emit AllocateTokensForTeam(teamAddress, teamAllocatedTime, amount);
496             teamAllocatedTime = 4;
497             return;
498         }
499         revert();
500     }
501 
502     // Remaining tokens for sales will be locked by contract in 2 years
503     function allocateRemainingTokens(address _addr) external isActive onlyOwnerOrAdmin {
504         require(_addr != address(0));
505         require(saleState == END_SALE);
506         require(totalRemainingTokensForSales > 0);
507         require(now >= icoEndTime + lockPeriod3);
508         balances[_addr] = balances[_addr].add(totalRemainingTokensForSales);
509         totalRemainingTokensForSales = 0;
510     }
511 
512     // Allocate reserved tokens
513     function allocateReservedTokens(address _addr, uint _amount) external isActive onlyOwnerOrAdmin {
514         require(saleState == END_SALE);
515         require(_amount > 0);
516         require(_addr != address(0));
517 		
518         balances[_addr] = balances[_addr].add(_amount);
519         totalReservedAndBonusTokenAllocation = totalReservedAndBonusTokenAllocation.sub(_amount);
520         emit AllocateReservedTokens(_addr, _amount);
521     }
522 
523     // ERC20 standard function
524     function allowance(address _owner, address _spender) external constant returns (uint256) {
525         return allowed[_owner][_spender];
526     }
527 
528     // ERC20 standard function
529     function balanceOf(address _owner) external constant returns (uint256 balance) {
530         return balances[_owner];
531     }
532 
533     // Get current sales state
534     function getCurrentState() public view returns(uint256) {
535         if (saleState == IN_1ST_ICO) {
536             if (now > icoStartTime + 30 days) {
537                 return IN_3RD_ICO;
538             }
539             if (now > icoStartTime + 15 days) {
540                 return IN_2ND_ICO;
541             }
542             return IN_1ST_ICO;
543         }
544         return saleState;
545     }
546 
547     // Get softcap reaching status
548     function isSoftCapReached() public view returns (bool) {
549         return totalInvestedAmount >= minInvestedCap;
550     }
551 
552     // Issue tokens to private investors
553     function issueTokensForPrivateInvestor(uint _state) private {
554         uint256 price = privateSalePrice;
555         issueTokens(price, _state);
556     }
557 
558     // Issue tokens to normal investors in presales
559     function issueTokensForPresale(uint _state) private {
560         uint256 price = preSalePrice;
561         issueTokens(price, _state);
562     }
563 
564     // Issue tokens to normal investors through ICO rounds
565     function issueTokensForICO(uint _state) private {
566         uint256 price = icoStandardPrice;
567         if (_state == IN_1ST_ICO) {
568             price = ico1stPrice;
569         } else if (_state == IN_2ND_ICO) {
570             price = ico2ndPrice;
571         }
572         issueTokens(price, _state);
573     }
574 
575     // Issue tokens to investors and transfer ether to wallet
576     function issueTokens(uint256 _price, uint _state) private {
577         require(walletAddress != address(0));
578 		
579         uint tokenAmount = msg.value.mul(_price).mul(10**18).div(1 ether);
580         balances[msg.sender] = balances[msg.sender].add(tokenAmount);
581         totalInvestedAmountOf[msg.sender] = totalInvestedAmountOf[msg.sender].add(msg.value);
582         totalRemainingTokensForSales = totalRemainingTokensForSales.sub(tokenAmount);
583         totalInvestedAmount = totalInvestedAmount.add(msg.value);
584         walletAddress.transfer(msg.value);
585         emit IssueTokens(msg.sender, msg.value, tokenAmount, _state);
586     }
587 }