1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // GazeCoin Crowdsale Contract
5 //
6 // Deployed to : {TBA}
7 //
8 // Note: Calculations are based on GZE having 18 decimal places
9 //
10 // Enjoy.
11 //
12 // (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2017. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
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
99 // Bonus list interface
100 // ----------------------------------------------------------------------------
101 contract BonusListInterface {
102     mapping(address => uint) public bonusList;
103 }
104 
105 
106 // ----------------------------------------------------------------------------
107 // Safe maths
108 // ----------------------------------------------------------------------------
109 contract SafeMath {
110     function safeAdd(uint a, uint b) public pure returns (uint c) {
111         c = a + b;
112         require(c >= a);
113     }
114     function safeSub(uint a, uint b) public pure returns (uint c) {
115         require(b <= a);
116         c = a - b;
117     }
118     function safeMul(uint a, uint b) public pure returns (uint c) {
119         c = a * b;
120         require(a == 0 || c / a == b);
121     }
122     function safeDiv(uint a, uint b) public pure returns (uint c) {
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
159 // GazeCoin Crowdsale Contract
160 // ----------------------------------------------------------------------------
161 contract GazeCoinCrowdsale is SafeMath, Owned {
162 
163     BTTSTokenInterface public bttsToken;
164     uint8 public constant TOKEN_DECIMALS = 18;
165 
166     address public wallet = 0x8cD8baa410E9172b949f2c4433D3b5905F8606fF;
167     address public teamWallet = 0xb4eC550893D31763C02EBDa44Dff90b7b5a62656;
168     uint public constant TEAM_PERCENT_GZE = 30;
169 
170     BonusListInterface public bonusList;
171     uint public constant TIER1_BONUS = 50;
172     uint public constant TIER2_BONUS = 20;
173     uint public constant TIER3_BONUS = 15;
174 
175     // Start 10 Dec 2017 11:00 EST => 10 Dec 2017 16:00 UTC => 11 Dec 2017 03:00 AEST
176     // new Date(1512921600 * 1000).toUTCString() => "Sun, 10 Dec 2017 16:00:00 UTC"
177     uint public constant START_DATE = 1512921600;
178     // End 21 Dec 2017 11:00 EST => 21 Dec 2017 16:00 UTC => 21 Dec 2017 03:00 AEST
179     // new Date(1513872000 * 1000).toUTCString() => "Thu, 21 Dec 2017 16:00:00 UTC"
180     uint public endDate = 1513872000;
181 
182     // ETH/USD 9 Dec 2017 11:00 EST => 9 Dec 2017 16:00 UTC => 10 Dec 2017 03:00 AEST => 489.44 from CMC
183     uint public usdPerKEther = 489440;
184     uint public constant USD_CENT_PER_GZE = 35;
185     uint public constant CAP_USD = 35000000;
186     uint public constant MIN_CONTRIBUTION_ETH = 0.01 ether;
187 
188     uint public contributedEth;
189     uint public contributedUsd;
190     uint public generatedGze;
191 
192     //  AUD 10,000 = ~ USD 7,500
193     uint public lockedAccountThresholdUsd = 7500;
194     mapping(address => uint) public accountEthAmount;
195 
196     bool public precommitmentAdjusted;
197     bool public finalised;
198 
199     event BTTSTokenUpdated(address indexed oldBTTSToken, address indexed newBTTSToken);
200     event WalletUpdated(address indexed oldWallet, address indexed newWallet);
201     event TeamWalletUpdated(address indexed oldTeamWallet, address indexed newTeamWallet);
202     event BonusListUpdated(address indexed oldBonusList, address indexed newBonusList);
203     event EndDateUpdated(uint oldEndDate, uint newEndDate);
204     event UsdPerKEtherUpdated(uint oldUsdPerKEther, uint newUsdPerKEther);
205     event LockedAccountThresholdUsdUpdated(uint oldEthLockedThreshold, uint newEthLockedThreshold);
206     event Contributed(address indexed addr, uint ethAmount, uint ethRefund, uint accountEthAmount, uint usdAmount, uint gzeAmount, uint contributedEth, uint contributedUsd, uint generatedGze, bool lockAccount);
207 
208     function GazeCoinCrowdsale() public {
209     }
210     function setBTTSToken(address _bttsToken) public onlyOwner {
211         require(now <= START_DATE);
212         BTTSTokenUpdated(address(bttsToken), _bttsToken);
213         bttsToken = BTTSTokenInterface(_bttsToken);
214     }
215     function setWallet(address _wallet) public onlyOwner {
216         WalletUpdated(wallet, _wallet);
217         wallet = _wallet;
218     }
219     function setTeamWallet(address _teamWallet) public onlyOwner {
220         TeamWalletUpdated(teamWallet, _teamWallet);
221         teamWallet = _teamWallet;
222     }
223     function setBonusList(address _bonusList) public onlyOwner {
224         require(now <= START_DATE);
225         BonusListUpdated(address(bonusList), _bonusList);
226         bonusList = BonusListInterface(_bonusList);
227     }
228     function setEndDate(uint _endDate) public onlyOwner {
229         require(_endDate >= now);
230         EndDateUpdated(endDate, _endDate);
231         endDate = _endDate;
232     }
233     function setUsdPerKEther(uint _usdPerKEther) public onlyOwner {
234         require(now <= START_DATE);
235         UsdPerKEtherUpdated(usdPerKEther, _usdPerKEther);
236         usdPerKEther = _usdPerKEther;
237     }
238     function setLockedAccountThresholdUsd(uint _lockedAccountThresholdUsd) public onlyOwner {
239         require(now <= START_DATE);
240         LockedAccountThresholdUsdUpdated(lockedAccountThresholdUsd, _lockedAccountThresholdUsd);
241         lockedAccountThresholdUsd = _lockedAccountThresholdUsd;
242     }
243 
244     function capEth() public view returns (uint) {
245         return CAP_USD * 10**uint(3 + 18) / usdPerKEther;
246     }
247     function gzeFromEth(uint ethAmount, uint bonusPercent) public view returns (uint) {
248         return usdPerKEther * ethAmount * (100 + bonusPercent) / 10**uint(3 + 2 - 2) / USD_CENT_PER_GZE;
249     }
250     function gzePerEth() public view returns (uint) {
251         return gzeFromEth(10**18, 0);
252     }
253     function lockedAccountThresholdEth() public view returns (uint) {
254         return lockedAccountThresholdUsd * 10**uint(3 + 18) / usdPerKEther;
255     }
256     function getBonusPercent(address addr) public view returns (uint bonusPercent) {
257         uint tier = bonusList.bonusList(addr);
258         if (tier == 1) {
259             bonusPercent = TIER1_BONUS;
260         } else if (tier == 2) {
261             bonusPercent = TIER2_BONUS;
262         } else if (tier == 3) {
263             bonusPercent = TIER3_BONUS;
264         } else {
265             bonusPercent = 0;
266         }
267     }
268     function () public payable {
269         require((now >= START_DATE && now <= endDate) || (msg.sender == owner && msg.value == MIN_CONTRIBUTION_ETH));
270         require(contributedEth < capEth());
271         require(msg.value >= MIN_CONTRIBUTION_ETH);
272         uint bonusPercent = getBonusPercent(msg.sender);
273         uint ethAmount = msg.value;
274         uint ethRefund = 0;
275         if (safeAdd(contributedEth, ethAmount) > capEth()) {
276             ethAmount = safeSub(capEth(), contributedEth);
277             ethRefund = safeSub(msg.value, ethAmount);
278         }
279         uint usdAmount = safeDiv(safeMul(ethAmount, usdPerKEther), 10**uint(3 + 18));
280         uint gzeAmount = gzeFromEth(ethAmount, bonusPercent);
281         generatedGze = safeAdd(generatedGze, gzeAmount);
282         contributedEth = safeAdd(contributedEth, ethAmount);
283         contributedUsd = safeAdd(contributedUsd, usdAmount);
284         accountEthAmount[msg.sender] = safeAdd(accountEthAmount[msg.sender], ethAmount);
285         bool lockAccount = accountEthAmount[msg.sender] > lockedAccountThresholdEth();
286         bttsToken.mint(msg.sender, gzeAmount, lockAccount);
287         if (ethAmount > 0) {
288             wallet.transfer(ethAmount);
289         }
290         Contributed(msg.sender, ethAmount, ethRefund, accountEthAmount[msg.sender], usdAmount, gzeAmount, contributedEth, contributedUsd, generatedGze, lockAccount);
291         if (ethRefund > 0) {
292             msg.sender.transfer(ethRefund);
293         }
294     }
295 
296     function addPrecommitment(address tokenOwner, uint ethAmount, uint bonusPercent) public onlyOwner {
297         require(!finalised);
298         uint usdAmount = safeDiv(safeMul(ethAmount, usdPerKEther), 10**uint(3 + 18));
299         uint gzeAmount = gzeFromEth(ethAmount, bonusPercent);
300         uint ethRefund = 0;
301         generatedGze = safeAdd(generatedGze, gzeAmount);
302         contributedEth = safeAdd(contributedEth, ethAmount);
303         contributedUsd = safeAdd(contributedUsd, usdAmount);
304         accountEthAmount[tokenOwner] = safeAdd(accountEthAmount[tokenOwner], ethAmount);
305         bool lockAccount = accountEthAmount[tokenOwner] > lockedAccountThresholdEth();
306         bttsToken.mint(tokenOwner, gzeAmount, lockAccount);
307         Contributed(tokenOwner, ethAmount, ethRefund, accountEthAmount[tokenOwner], usdAmount, gzeAmount, contributedEth, contributedUsd, generatedGze, lockAccount);
308     }
309     function addPrecommitmentAdjustment(address tokenOwner, uint gzeAmount) public onlyOwner {
310         require(now > endDate || contributedEth >= capEth());
311         require(!finalised);
312         uint ethAmount = 0;
313         uint usdAmount = 0;
314         uint ethRefund = 0;
315         generatedGze = safeAdd(generatedGze, gzeAmount);
316         bool lockAccount = accountEthAmount[tokenOwner] > lockedAccountThresholdEth();
317         bttsToken.mint(tokenOwner, gzeAmount, lockAccount);
318         precommitmentAdjusted = true;
319         Contributed(tokenOwner, ethAmount, ethRefund, accountEthAmount[tokenOwner], usdAmount, gzeAmount, contributedEth, contributedUsd, generatedGze, lockAccount);
320     }
321     function roundUp(uint a) public pure returns (uint) {
322         uint multiple = 10**uint(TOKEN_DECIMALS);
323         uint remainder = a % multiple;
324         if (remainder > 0) {
325             return safeSub(safeAdd(a, multiple), remainder);
326         }
327     }
328     function finalise() public onlyOwner {
329         require(!finalised);
330         require(precommitmentAdjusted);
331         require(now > endDate || contributedEth >= capEth());
332         uint total = safeDiv(safeMul(generatedGze, 100), safeSub(100, TEAM_PERCENT_GZE));
333         uint amountTeam = safeDiv(safeMul(total, TEAM_PERCENT_GZE), 100);
334         generatedGze = safeAdd(generatedGze, amountTeam);
335         uint rounded = roundUp(generatedGze);
336         if (rounded > generatedGze) {
337             uint dust = safeSub(rounded, generatedGze);
338             generatedGze = safeAdd(generatedGze, dust);
339             amountTeam = safeAdd(amountTeam, dust);
340         }
341         bttsToken.mint(teamWallet, amountTeam, false);
342         bttsToken.disableMinting();
343         finalised = true;
344     }
345 }