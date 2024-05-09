1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'EVE' 'Devery EVE' crowdsale and token contracts
5 //
6 // Symbol      : EVE
7 // Name        : Devery EVE
8 // Total supply: Minted
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd for Devery 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 
16 // ----------------------------------------------------------------------------
17 // ERC Token Standard #20 Interface
18 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
19 // ----------------------------------------------------------------------------
20 contract ERC20Interface {
21     function totalSupply() public constant returns (uint);
22     function balanceOf(address tokenOwner) public constant returns (uint balance);
23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24     function transfer(address to, uint tokens) public returns (bool success);
25     function approve(address spender, uint tokens) public returns (bool success);
26     function transferFrom(address from, address to, uint tokens) public returns (bool success);
27 
28     event Transfer(address indexed from, address indexed to, uint tokens);
29     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
30 }
31 
32 
33 // ----------------------------------------------------------------------------
34 // BokkyPooBah's Token Teleportation Service Interface v1.00
35 //
36 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
37 // ----------------------------------------------------------------------------
38 contract BTTSTokenInterface is ERC20Interface {
39     uint public constant bttsVersion = 100;
40 
41     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
42     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
43     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
44     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
45     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
46 
47     event OwnershipTransferred(address indexed from, address indexed to);
48     event MinterUpdated(address from, address to);
49     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
50     event MintingDisabled();
51     event TransfersEnabled();
52     event AccountUnlocked(address indexed tokenOwner);
53 
54     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
55 
56     // ------------------------------------------------------------------------
57     // signed{X} functions
58     // ------------------------------------------------------------------------
59     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
60     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
61     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
62 
63     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
64     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
65     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
66 
67     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
68     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
69     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
70 
71     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash);
72     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
73     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
74 
75     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
76     function unlockAccount(address tokenOwner) public;
77     function disableMinting() public;
78     function enableTransfers() public;
79 
80     // ------------------------------------------------------------------------
81     // signed{X}Check return status
82     // ------------------------------------------------------------------------
83     enum CheckResult {
84         Success,                           // 0 Success
85         NotTransferable,                   // 1 Tokens not transferable yet
86         AccountLocked,                     // 2 Account locked
87         SignerMismatch,                    // 3 Mismatch in signing account
88         AlreadyExecuted,                   // 4 Transfer already executed
89         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
90         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
91         InsufficientTokens,                // 7 Insufficient tokens
92         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
93         OverflowError                      // 9 Overflow error
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // Parity PICOPS Whitelist Interface
100 // ----------------------------------------------------------------------------
101 contract PICOPSCertifier {
102     function certified(address) public constant returns (bool);
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // Safe maths
108 // ----------------------------------------------------------------------------
109 library SafeMath {
110     function add(uint a, uint b) internal pure returns (uint c) {
111         c = a + b;
112         require(c >= a);
113     }
114     function sub(uint a, uint b) internal pure returns (uint c) {
115         require(b <= a);
116         c = a - b;
117     }
118     function mul(uint a, uint b) internal pure returns (uint c) {
119         c = a * b;
120         require(a == 0 || c / a == b);
121     }
122     function div(uint a, uint b) internal pure returns (uint c) {
123         require(b > 0);
124         c = a / b;
125     }
126 }
127 
128 
129 // ----------------------------------------------------------------------------
130 // Owned contract
131 // ----------------------------------------------------------------------------
132 contract Owned {
133     address public owner;
134     address public newOwner;
135 
136     event OwnershipTransferred(address indexed _from, address indexed _to);
137 
138     modifier onlyOwner {
139         require(msg.sender == owner);
140         _;
141     }
142 
143     function Owned() public {
144         owner = msg.sender;
145     }
146     function transferOwnership(address _newOwner) public onlyOwner {
147         newOwner = _newOwner;
148     }
149     function acceptOwnership() public {
150         require(msg.sender == newOwner);
151         OwnershipTransferred(owner, newOwner);
152         owner = newOwner;
153         newOwner = address(0);
154     }
155 }
156 
157 
158 // ----------------------------------------------------------------------------
159 // Devery Vesting Contract
160 // ----------------------------------------------------------------------------
161 contract DeveryVesting {
162     using SafeMath for uint;
163 
164     DeveryCrowdsale public crowdsale;
165     uint public totalProportion;
166     uint public totalTokens;
167     uint public startDate;
168 
169     struct Entry {
170         uint proportion;
171         uint periods;
172         uint periodLength;
173         uint withdrawn;
174     }
175     mapping (address => Entry) public entries;
176 
177     event NewEntry(address indexed holder, uint proportion, uint periods, uint periodLength);
178     event Withdrawn(address indexed holder, uint withdrawn);
179 
180     function DeveryVesting(address _crowdsale) public {
181         crowdsale = DeveryCrowdsale(_crowdsale);
182     }
183 
184     function addEntryInDays(address holder, uint proportion, uint periods) public {
185         addEntry(holder, proportion, periods, 1 days);
186     }
187     function addEntryInMonths(address holder, uint proportion, uint periods) public {
188         addEntry(holder, proportion, periods, 30 days);
189     }
190     function addEntryInYears(address holder, uint proportion, uint periods) public {
191         addEntry(holder, proportion, periods, 365 days);
192     }
193 
194     function addEntry(address holder, uint proportion, uint periods, uint periodLength) internal {
195         require(msg.sender == crowdsale.owner());
196         require(holder != address(0));
197         require(proportion > 0);
198         require(periods > 0);
199         require(entries[holder].proportion == 0);
200         entries[holder] = Entry({
201             proportion: proportion,
202             periods: periods,
203             periodLength: periodLength,
204             withdrawn: 0
205         });
206         totalProportion = totalProportion.add(proportion);
207         NewEntry(holder, proportion, periods, periodLength);
208     }
209 
210     function tokenShare(address holder) public view returns (uint) {
211         uint result = 0;
212         Entry memory entry = entries[holder];
213         if (entry.proportion > 0 && totalProportion > 0) {
214             result = totalTokens.mul(entry.proportion).div(totalProportion);
215         }
216         return result;
217     }
218     function vested(address holder, uint time) public view returns (uint) {
219         uint result = 0;
220         if (startDate > 0 && time > startDate) {
221             Entry memory entry = entries[holder];
222             if (entry.proportion > 0 && totalProportion > 0) {
223                 uint _tokenShare = totalTokens.mul(entry.proportion).div(totalProportion);
224                 if (time >= startDate.add(entry.periods.mul(entry.periodLength))) {
225                     result = _tokenShare;
226                 } else {
227                     uint periods = time.sub(startDate).div(entry.periodLength);
228                     result = _tokenShare.mul(periods).div(entry.periods);
229                 }
230             }
231         }
232         return result;
233     }
234     function withdrawable(address holder) public view returns (uint) {
235         uint result = 0;
236         Entry memory entry = entries[holder];
237         if (entry.proportion > 0 && totalProportion > 0) {
238             uint _vested = vested(holder, now);
239             result = _vested.sub(entry.withdrawn);
240         }
241         return result;
242     }
243     function withdraw() public {
244         Entry storage entry = entries[msg.sender];
245         require(entry.proportion > 0 && totalProportion > 0);
246         uint _vested = vested(msg.sender, now);
247         uint _withdrawn = entry.withdrawn;
248         require(_vested > _withdrawn);
249         uint _withdrawable = _vested.sub(_withdrawn);
250         entry.withdrawn = _vested;
251         require(crowdsale.bttsToken().transfer(msg.sender, _withdrawable));
252         Withdrawn(msg.sender, _withdrawable);
253     }
254     function withdrawn(address holder) public view returns (uint) {
255         Entry memory entry = entries[holder];
256         return entry.withdrawn;
257     }
258 
259     function finalise() public {
260         require(msg.sender == address(crowdsale));
261         totalTokens = crowdsale.bttsToken().balanceOf(address(this));
262         startDate = now;
263     }
264 
265 }
266 
267 
268 // ----------------------------------------------------------------------------
269 // Devery Crowdsale Contract
270 // ----------------------------------------------------------------------------
271 contract DeveryCrowdsale is Owned {
272     using SafeMath for uint;
273 
274     BTTSTokenInterface public bttsToken;
275     uint8 public constant TOKEN_DECIMALS = 18;
276 
277     ERC20Interface public presaleToken = ERC20Interface(0x8ca1d9C33c338520604044977be69a9AC19d6E54);
278     uint public presaleEthAmountsProcessed;
279     bool public presaleProcessed;
280     uint public constant PRESALE_BONUS_PERCENT = 5;
281 
282     uint public constant PER_ACCOUNT_ADDITIONAL_TOKENS = 200 * 10**uint(TOKEN_DECIMALS);
283     mapping(address => bool) bonusTokensAllocate;
284 
285     PICOPSCertifier public picopsCertifier = PICOPSCertifier(0x1e2F058C43ac8965938F6e9CA286685A3E63F24E);
286 
287     address public wallet = 0x87410eE93BDa2445339c9372b20BF25e138F858C;
288     address public reserveWallet = 0x87410eE93BDa2445339c9372b20BF25e138F858C;
289     DeveryVesting public vestingTeamWallet;
290     uint public constant TEAM_PERCENT_EVE = 15;
291     uint public constant RESERVE_PERCENT_EVE = 25;
292     uint public constant TARGET_EVE = 100000000 * 10**uint(TOKEN_DECIMALS);
293     uint public constant PRESALEPLUSCROWDSALE_EVE = TARGET_EVE * (100 - TEAM_PERCENT_EVE - RESERVE_PERCENT_EVE) / 100;
294 
295     // Start 18 Jan 2018 16:00 UTC => "Fri, 19 Jan 2018 03:00:00 AEDT"
296     // new Date(1516291200 * 1000).toUTCString() => "Thu, 18 Jan 2018 16:00:00 UTC"
297     uint public startDate = 1516291200;
298     uint public firstPeriodEndDate = startDate + 12 hours;
299     uint public endDate = startDate + 14 days;
300 
301     // ETH/USD rate used 1,000
302     uint public usdPerKEther = 1000000;
303     uint public constant CAP_USD = 10000000;
304     uint public constant MIN_CONTRIBUTION_ETH = 0.01 ether;
305     uint public firstPeriodCap = 3 ether;
306 
307     uint public contributedEth;
308     uint public contributedUsd;
309     uint public generatedEve;
310 
311     mapping(address => uint) public accountEthAmount;
312 
313     bool public finalised;
314 
315     event BTTSTokenUpdated(address indexed oldBTTSToken, address indexed newBTTSToken);
316     event PICOPSCertifierUpdated(address indexed oldPICOPSCertifier, address indexed newPICOPSCertifier);
317     event WalletUpdated(address indexed oldWallet, address indexed newWallet);
318     event ReserveWalletUpdated(address indexed oldReserveWallet, address indexed newReserveWallet);
319     event StartDateUpdated(uint oldStartDate, uint newStartDate);
320     event FirstPeriodEndDateUpdated(uint oldFirstPeriodEndDate, uint newFirstPeriodEndDate);
321     event EndDateUpdated(uint oldEndDate, uint newEndDate);
322     event UsdPerKEtherUpdated(uint oldUsdPerKEther, uint newUsdPerKEther);
323     event FirstPeriodCapUpdated(uint oldFirstPeriodCap, uint newFirstPeriodCap);
324     event Contributed(address indexed addr, uint ethAmount, uint ethRefund, uint accountEthAmount, uint usdAmount, uint bonusPercent, uint eveAmount, uint contributedEth, uint contributedUsd, uint generatedEve);
325 
326     function DeveryCrowdsale() public {
327         vestingTeamWallet = new DeveryVesting(this);
328     }
329 
330     function setBTTSToken(address _bttsToken) public onlyOwner {
331         require(now <= startDate);
332         BTTSTokenUpdated(address(bttsToken), _bttsToken);
333         bttsToken = BTTSTokenInterface(_bttsToken);
334     }
335     function setPICOPSCertifier(address _picopsCertifier) public onlyOwner {
336         require(now <= startDate);
337         PICOPSCertifierUpdated(address(picopsCertifier), _picopsCertifier);
338         picopsCertifier = PICOPSCertifier(_picopsCertifier);
339     }
340     function setWallet(address _wallet) public onlyOwner {
341         WalletUpdated(wallet, _wallet);
342         wallet = _wallet;
343     }
344     function setReserveWallet(address _reserveWallet) public onlyOwner {
345         ReserveWalletUpdated(reserveWallet, _reserveWallet);
346         reserveWallet = _reserveWallet;
347     }
348     function setStartDate(uint _startDate) public onlyOwner {
349         require(_startDate >= now);
350         StartDateUpdated(startDate, _startDate);
351         startDate = _startDate;
352     }
353     function setFirstPeriodEndDate(uint _firstPeriodEndDate) public onlyOwner {
354         require(_firstPeriodEndDate >= now);
355         require(_firstPeriodEndDate >= startDate);
356         FirstPeriodEndDateUpdated(firstPeriodEndDate, _firstPeriodEndDate);
357         firstPeriodEndDate = _firstPeriodEndDate;
358     }
359     function setEndDate(uint _endDate) public onlyOwner {
360         require(_endDate >= now);
361         require(_endDate >= firstPeriodEndDate);
362         EndDateUpdated(endDate, _endDate);
363         endDate = _endDate;
364     }
365     function setUsdPerKEther(uint _usdPerKEther) public onlyOwner {
366         require(now <= startDate);
367         UsdPerKEtherUpdated(usdPerKEther, _usdPerKEther);
368         usdPerKEther = _usdPerKEther;
369     }
370     function setFirstPeriodCap(uint _firstPeriodCap) public onlyOwner {
371         require(_firstPeriodCap >= MIN_CONTRIBUTION_ETH);
372         FirstPeriodCapUpdated(firstPeriodCap, _firstPeriodCap);
373         firstPeriodCap = _firstPeriodCap;
374     }
375 
376     // usdPerKEther = 1,000,000
377     // capEth       = USD 10,000,000 / 1,000 = 10,000
378     // presaleEth   = 4,561.764705882353
379     // crowdsaleEth = capEth - presaleEth
380     //              = 5,438.235294117647
381     // totalEve     = 100,000,000
382     // presalePlusCrowdsaleEve = 60% x totalEve = 60,000,000
383     // evePerEth x presaleEth x 1.05 + evePerEth x crowdsaleEth = presalePlusCrowdsaleEve
384     // evePerEth x (presaleEth x 1.05 + crowdsaleEth) = presalePlusCrowdsaleEve
385     // evePerEth = presalePlusCrowdsaleEve / (presaleEth x 1.05 + crowdsaleEth)
386     //           = 60,000,000/(4,561.764705882353*1.05 + 5,438.235294117647)
387     //           = 5,866.19890440108697
388     // usdPerEve = 1,000 / 5,866.19890440108697 = 0.170468137254902 
389 
390     function capEth() public view returns (uint) {
391         return CAP_USD * 10**uint(3 + 18) / usdPerKEther;
392     }
393     function presaleEth() public view returns (uint) {
394         return presaleToken.totalSupply();
395     }
396     function crowdsaleEth() public view returns (uint) {
397         return capEth().sub(presaleEth());
398     }
399     function eveFromEth(uint ethAmount, uint bonusPercent) public view returns (uint) {
400         uint adjustedEth = presaleEth().mul(100 + PRESALE_BONUS_PERCENT).add(crowdsaleEth().mul(100)).div(100);
401         return ethAmount.mul(100 + bonusPercent).mul(PRESALEPLUSCROWDSALE_EVE).div(adjustedEth).div(100);
402     }
403     function evePerEth() public view returns (uint) {
404         return eveFromEth(10**18, 0);
405     }
406     function usdPerEve() public view returns (uint) {
407         uint evePerKEth = eveFromEth(10**(18 + 3), 0);
408         return usdPerKEther.mul(10**(18 + 18)).div(evePerKEth);
409     }
410 
411     function generateTokensForPresaleAccounts(address[] accounts) public onlyOwner {
412         require(bttsToken != address(0));
413         require(!presaleProcessed);
414         for (uint i = 0; i < accounts.length; i++) {
415             address account = accounts[i];
416             uint ethAmount = presaleToken.balanceOf(account);
417             uint eveAmount = bttsToken.balanceOf(account);
418             if (eveAmount == 0 && ethAmount != 0) {
419                 presaleEthAmountsProcessed = presaleEthAmountsProcessed.add(ethAmount);
420                 accountEthAmount[account] = accountEthAmount[account].add(ethAmount);
421                 eveAmount = eveFromEth(ethAmount, PRESALE_BONUS_PERCENT);
422                 eveAmount = eveAmount.add(PER_ACCOUNT_ADDITIONAL_TOKENS);
423                 bonusTokensAllocate[account] = true;
424                 uint usdAmount = ethAmount.mul(usdPerKEther).div(10**uint(3 + 18));
425                 contributedEth = contributedEth.add(ethAmount);
426                 contributedUsd = contributedUsd.add(usdAmount);
427                 generatedEve = generatedEve.add(eveAmount);
428                 Contributed(account, ethAmount, 0, ethAmount, usdAmount, PRESALE_BONUS_PERCENT, eveAmount,
429                     contributedEth, contributedUsd, generatedEve);
430                 bttsToken.mint(account, eveAmount, false);
431             }
432         }
433         if (presaleEthAmountsProcessed == presaleToken.totalSupply()) {
434             presaleProcessed = true;
435         }
436     }
437 
438     function () public payable {
439         require(!finalised);
440         uint ethAmount = msg.value;
441         if (msg.sender == owner) {
442             require(msg.value == MIN_CONTRIBUTION_ETH);
443         } else {
444             require(now >= startDate && now <= endDate);
445             if (now <= firstPeriodEndDate) {
446                 require(accountEthAmount[msg.sender].add(ethAmount) <= firstPeriodCap);
447                 require(picopsCertifier.certified(msg.sender));
448             }
449         }
450         require(contributedEth < capEth());
451         require(msg.value >= MIN_CONTRIBUTION_ETH);
452         uint ethRefund = 0;
453         if (contributedEth.add(ethAmount) > capEth()) {
454             ethAmount = capEth().sub(contributedEth);
455             ethRefund = msg.value.sub(ethAmount);
456         }
457         uint usdAmount = ethAmount.mul(usdPerKEther).div(10**uint(3 + 18));
458         uint eveAmount = eveFromEth(ethAmount, 0);
459         if (picopsCertifier.certified(msg.sender) && !bonusTokensAllocate[msg.sender]) {
460             eveAmount = eveAmount.add(PER_ACCOUNT_ADDITIONAL_TOKENS);
461             bonusTokensAllocate[msg.sender] = true;
462         }
463         generatedEve = generatedEve.add(eveAmount);
464         contributedEth = contributedEth.add(ethAmount);
465         contributedUsd = contributedUsd.add(usdAmount);
466         accountEthAmount[msg.sender] = accountEthAmount[msg.sender].add(ethAmount);
467         bttsToken.mint(msg.sender, eveAmount, false);
468         if (ethAmount > 0) {
469             wallet.transfer(ethAmount);
470         }
471         Contributed(msg.sender, ethAmount, ethRefund, accountEthAmount[msg.sender], usdAmount, 0, eveAmount,
472             contributedEth, contributedUsd, generatedEve);
473         if (ethRefund > 0) {
474             msg.sender.transfer(ethRefund);
475         }
476     }
477 
478     function roundUp(uint a) internal pure returns (uint) {
479         uint multiple = 10**uint(TOKEN_DECIMALS);
480         uint remainder = a % multiple;
481         if (remainder > 0) {
482             return a.add(multiple).sub(remainder);
483         }
484     }
485     function finalise() public onlyOwner {
486         require(!finalised);
487         require(now > endDate || contributedEth >= capEth());
488         uint total = generatedEve.mul(100).div(uint(100).sub(TEAM_PERCENT_EVE).sub(RESERVE_PERCENT_EVE));
489         uint amountTeam = total.mul(TEAM_PERCENT_EVE).div(100);
490         uint amountReserve = total.mul(RESERVE_PERCENT_EVE).div(100);
491         generatedEve = generatedEve.add(amountTeam).add(amountReserve);
492         uint rounded = roundUp(generatedEve);
493         if (rounded > generatedEve) {
494             uint dust = rounded.sub(generatedEve);
495             generatedEve = generatedEve.add(dust);
496             amountReserve = amountReserve.add(dust);
497         }
498         if (generatedEve > TARGET_EVE) {
499             uint diff = generatedEve.sub(TARGET_EVE);
500             generatedEve = TARGET_EVE;
501             amountReserve = amountReserve.sub(diff);
502         }
503         bttsToken.mint(address(vestingTeamWallet), amountTeam, false);
504         bttsToken.mint(reserveWallet, amountReserve, false);
505         bttsToken.disableMinting();
506         vestingTeamWallet.finalise();
507         finalised = true;
508     }
509 }