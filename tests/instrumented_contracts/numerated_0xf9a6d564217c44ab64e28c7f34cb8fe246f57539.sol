1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // Fxxx Land Rush Contract - Purchase land parcels with GZE and ETH
5 //
6 // Enjoy.
7 //
8 // (c) BokkyPooBah / Bok Consulting Pty Ltd for GazeCoin 2018. The MIT Licence.
9 // ----------------------------------------------------------------------------
10 
11 
12 // ----------------------------------------------------------------------------
13 // Owned contract
14 // ----------------------------------------------------------------------------
15 contract Owned {
16     address public owner;
17     address public newOwner;
18     bool private initialised;
19 
20     event OwnershipTransferred(address indexed _from, address indexed _to);
21 
22     modifier onlyOwner {
23         require(msg.sender == owner);
24         _;
25     }
26 
27     function initOwned(address _owner) internal {
28         require(!initialised);
29         owner = _owner;
30         initialised = true;
31     }
32     function transferOwnership(address _newOwner) public onlyOwner {
33         newOwner = _newOwner;
34     }
35     function acceptOwnership() public {
36         require(msg.sender == newOwner);
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39         newOwner = address(0);
40     }
41     function transferOwnershipImmediately(address _newOwner) public onlyOwner {
42         emit OwnershipTransferred(owner, _newOwner);
43         owner = _newOwner;
44     }
45 }
46 
47 // ----------------------------------------------------------------------------
48 // Safe maths
49 // ----------------------------------------------------------------------------
50 library SafeMath {
51     function add(uint a, uint b) internal pure returns (uint c) {
52         c = a + b;
53         require(c >= a);
54     }
55     function sub(uint a, uint b) internal pure returns (uint c) {
56         require(b <= a);
57         c = a - b;
58     }
59     function mul(uint a, uint b) internal pure returns (uint c) {
60         c = a * b;
61         require(a == 0 || c / a == b);
62     }
63     function div(uint a, uint b) internal pure returns (uint c) {
64         require(b > 0);
65         c = a / b;
66     }
67     function max(uint a, uint b) internal pure returns (uint c) {
68         c = a >= b ? a : b;
69     }
70     function min(uint a, uint b) internal pure returns (uint c) {
71         c = a <= b ? a : b;
72     }
73 }
74 
75 // ----------------------------------------------------------------------------
76 // BokkyPooBah's Token Teleportation Service Interface v1.10
77 //
78 // https://github.com/bokkypoobah/BokkyPooBahsTokenTeleportationServiceSmartContract
79 //
80 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
81 // ----------------------------------------------------------------------------
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC Token Standard #20 Interface
86 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
87 // ----------------------------------------------------------------------------
88 contract ERC20Interface {
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 
92     function totalSupply() public constant returns (uint);
93     function balanceOf(address tokenOwner) public constant returns (uint balance);
94     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
95     function transfer(address to, uint tokens) public returns (bool success);
96     function approve(address spender, uint tokens) public returns (bool success);
97     function transferFrom(address from, address to, uint tokens) public returns (bool success);
98 }
99 
100 // ----------------------------------------------------------------------------
101 // Contracts that can have tokens approved, and then a function executed
102 // ----------------------------------------------------------------------------
103 contract ApproveAndCallFallBack {
104     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
105 }
106 
107 
108 // ----------------------------------------------------------------------------
109 // BokkyPooBah's Token Teleportation Service Interface v1.10
110 //
111 // Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
112 // ----------------------------------------------------------------------------
113 contract BTTSTokenInterface is ERC20Interface {
114     uint public constant bttsVersion = 110;
115 
116     bytes public constant signingPrefix = "\x19Ethereum Signed Message:\n32";
117     bytes4 public constant signedTransferSig = "\x75\x32\xea\xac";
118     bytes4 public constant signedApproveSig = "\xe9\xaf\xa7\xa1";
119     bytes4 public constant signedTransferFromSig = "\x34\x4b\xcc\x7d";
120     bytes4 public constant signedApproveAndCallSig = "\xf1\x6f\x9b\x53";
121 
122     event OwnershipTransferred(address indexed from, address indexed to);
123     event MinterUpdated(address from, address to);
124     event Mint(address indexed tokenOwner, uint tokens, bool lockAccount);
125     event MintingDisabled();
126     event TransfersEnabled();
127     event AccountUnlocked(address indexed tokenOwner);
128 
129     function symbol() public view returns (string);
130     function name() public view returns (string);
131     function decimals() public view returns (uint8);
132 
133     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success);
134 
135     // ------------------------------------------------------------------------
136     // signed{X} functions
137     // ------------------------------------------------------------------------
138     function signedTransferHash(address tokenOwner, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
139     function signedTransferCheck(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
140     function signedTransfer(address tokenOwner, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
141 
142     function signedApproveHash(address tokenOwner, address spender, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
143     function signedApproveCheck(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
144     function signedApprove(address tokenOwner, address spender, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
145 
146     function signedTransferFromHash(address spender, address from, address to, uint tokens, uint fee, uint nonce) public view returns (bytes32 hash);
147     function signedTransferFromCheck(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
148     function signedTransferFrom(address spender, address from, address to, uint tokens, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
149 
150     function signedApproveAndCallHash(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce) public view returns (bytes32 hash);
151     function signedApproveAndCallCheck(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public view returns (CheckResult result);
152     function signedApproveAndCall(address tokenOwner, address spender, uint tokens, bytes _data, uint fee, uint nonce, bytes sig, address feeAccount) public returns (bool success);
153 
154     function mint(address tokenOwner, uint tokens, bool lockAccount) public returns (bool success);
155     function unlockAccount(address tokenOwner) public;
156     function disableMinting() public;
157     function enableTransfers() public;
158 
159     // ------------------------------------------------------------------------
160     // signed{X}Check return status
161     // ------------------------------------------------------------------------
162     enum CheckResult {
163         Success,                           // 0 Success
164         NotTransferable,                   // 1 Tokens not transferable yet
165         AccountLocked,                     // 2 Account locked
166         SignerMismatch,                    // 3 Mismatch in signing account
167         InvalidNonce,                      // 4 Invalid nonce
168         InsufficientApprovedTokens,        // 5 Insufficient approved tokens
169         InsufficientApprovedTokensForFees, // 6 Insufficient approved tokens for fees
170         InsufficientTokens,                // 7 Insufficient tokens
171         InsufficientTokensForFees,         // 8 Insufficient tokens for fees
172         OverflowError                      // 9 Overflow error
173     }
174 }
175 
176 // ----------------------------------------------------------------------------
177 // PriceFeed Interface - _live is true if the rate is valid, false if invalid
178 // ----------------------------------------------------------------------------
179 contract PriceFeedInterface {
180     function name() public view returns (string);
181     function getRate() public view returns (uint _rate, bool _live);
182 }
183 
184 // ----------------------------------------------------------------------------
185 // Bonus List interface
186 // ----------------------------------------------------------------------------
187 contract BonusListInterface {
188     function isInBonusList(address account) public view returns (bool);
189 }
190 
191 
192 // ----------------------------------------------------------------------------
193 // FxxxLandRush Contract
194 // ----------------------------------------------------------------------------
195 contract FxxxLandRush is Owned, ApproveAndCallFallBack {
196     using SafeMath for uint;
197 
198     uint private constant TENPOW18 = 10 ** 18;
199 
200     BTTSTokenInterface public parcelToken;
201     BTTSTokenInterface public gzeToken;
202     PriceFeedInterface public ethUsdPriceFeed;
203     PriceFeedInterface public gzeEthPriceFeed;
204     BonusListInterface public bonusList;
205 
206     address public wallet;
207     uint public startDate;
208     uint public endDate;
209     uint public maxParcels;
210     uint public parcelUsd;                  // USD per parcel, e.g., USD 1,500 * 10^18
211     uint public usdLockAccountThreshold;    // e.g., USD 7,000 * 10^18
212     uint public gzeBonusOffList;            // e.g., 20 = 20% bonus
213     uint public gzeBonusOnList;             // e.g., 30 = 30% bonus
214 
215     uint public parcelsSold;
216     uint public contributedGze;
217     uint public contributedEth;
218     bool public finalised;
219 
220     event WalletUpdated(address indexed oldWallet, address indexed newWallet);
221     event StartDateUpdated(uint oldStartDate, uint newStartDate);
222     event EndDateUpdated(uint oldEndDate, uint newEndDate);
223     event MaxParcelsUpdated(uint oldMaxParcels, uint newMaxParcels);
224     event ParcelUsdUpdated(uint oldParcelUsd, uint newParcelUsd);
225     event UsdLockAccountThresholdUpdated(uint oldUsdLockAccountThreshold, uint newUsdLockAccountThreshold);
226     event GzeBonusOffListUpdated(uint oldGzeBonusOffList, uint newGzeBonusOffList);
227     event GzeBonusOnListUpdated(uint oldGzeBonusOnList, uint newGzeBonusOnList);
228     event Purchased(address indexed addr, uint parcels, uint gzeToTransfer, uint ethToTransfer, uint parcelsSold, uint contributedGze, uint contributedEth, bool lockAccount);
229 
230     constructor(address _parcelToken, address _gzeToken, address _ethUsdPriceFeed, address _gzeEthPriceFeed, address _bonusList, address _wallet, uint _startDate, uint _endDate, uint _maxParcels, uint _parcelUsd, uint _usdLockAccountThreshold, uint _gzeBonusOffList, uint _gzeBonusOnList) public {
231         require(_parcelToken != address(0) && _gzeToken != address(0));
232         require(_ethUsdPriceFeed != address(0) && _gzeEthPriceFeed != address(0) && _bonusList != address(0));
233         require(_wallet != address(0));
234         require(_startDate >= now && _endDate > _startDate);
235         require(_maxParcels > 0 && _parcelUsd > 0);
236         initOwned(msg.sender);
237         parcelToken = BTTSTokenInterface(_parcelToken);
238         gzeToken = BTTSTokenInterface(_gzeToken);
239         ethUsdPriceFeed = PriceFeedInterface(_ethUsdPriceFeed);
240         gzeEthPriceFeed = PriceFeedInterface(_gzeEthPriceFeed);
241         bonusList = BonusListInterface(_bonusList);
242         wallet = _wallet;
243         startDate = _startDate;
244         endDate = _endDate;
245         maxParcels = _maxParcels;
246         parcelUsd = _parcelUsd;
247         usdLockAccountThreshold = _usdLockAccountThreshold;
248         gzeBonusOffList = _gzeBonusOffList;
249         gzeBonusOnList = _gzeBonusOnList;
250     }
251     function setWallet(address _wallet) public onlyOwner {
252         require(!finalised);
253         require(_wallet != address(0));
254         emit WalletUpdated(wallet, _wallet);
255         wallet = _wallet;
256     }
257     function setStartDate(uint _startDate) public onlyOwner {
258         require(!finalised);
259         require(_startDate >= now);
260         emit StartDateUpdated(startDate, _startDate);
261         startDate = _startDate;
262     }
263     function setEndDate(uint _endDate) public onlyOwner {
264         require(!finalised);
265         require(_endDate > startDate);
266         emit EndDateUpdated(endDate, _endDate);
267         endDate = _endDate;
268     }
269     function setMaxParcels(uint _maxParcels) public onlyOwner {
270         require(!finalised);
271         require(_maxParcels >= parcelsSold);
272         emit MaxParcelsUpdated(maxParcels, _maxParcels);
273         maxParcels = _maxParcels;
274     }
275     function setParcelUsd(uint _parcelUsd) public onlyOwner {
276         require(!finalised);
277         require(_parcelUsd > 0);
278         emit ParcelUsdUpdated(parcelUsd, _parcelUsd);
279         parcelUsd = _parcelUsd;
280     }
281     function setUsdLockAccountThreshold(uint _usdLockAccountThreshold) public onlyOwner {
282         require(!finalised);
283         emit UsdLockAccountThresholdUpdated(usdLockAccountThreshold, _usdLockAccountThreshold);
284         usdLockAccountThreshold = _usdLockAccountThreshold;
285     }
286     function setGzeBonusOffList(uint _gzeBonusOffList) public onlyOwner {
287         require(!finalised);
288         emit GzeBonusOffListUpdated(gzeBonusOffList, _gzeBonusOffList);
289         gzeBonusOffList = _gzeBonusOffList;
290     }
291     function setGzeBonusOnList(uint _gzeBonusOnList) public onlyOwner {
292         require(!finalised);
293         emit GzeBonusOnListUpdated(gzeBonusOnList, _gzeBonusOnList);
294         gzeBonusOnList = _gzeBonusOnList;
295     }
296 
297     function symbol() public view returns (string _symbol) {
298         _symbol = parcelToken.symbol();
299     }
300     function name() public view returns (string _name) {
301         _name = parcelToken.name();
302     }
303 
304     // USD per ETH, e.g., 221.99 * 10^18
305     function ethUsd() public view returns (uint _rate, bool _live) {
306         return ethUsdPriceFeed.getRate();
307     }
308     // ETH per GZE, e.g., 0.00004366 * 10^18
309     function gzeEth() public view returns (uint _rate, bool _live) {
310         return gzeEthPriceFeed.getRate();
311     }
312     // USD per GZE, e.g., 0.0096920834 * 10^18
313     function gzeUsd() public view returns (uint _rate, bool _live) {
314         uint _ethUsd;
315         bool _ethUsdLive;
316         (_ethUsd, _ethUsdLive) = ethUsdPriceFeed.getRate();
317         uint _gzeEth;
318         bool _gzeEthLive;
319         (_gzeEth, _gzeEthLive) = gzeEthPriceFeed.getRate();
320         if (_ethUsdLive && _gzeEthLive) {
321             _live = true;
322             _rate = _ethUsd.mul(_gzeEth).div(TENPOW18);
323         }
324     }
325     // ETH per parcel, e.g., 6.757061128879679264 * 10^18
326     function parcelEth() public view returns (uint _rate, bool _live) {
327         uint _ethUsd;
328         (_ethUsd, _live) = ethUsd();
329         if (_live) {
330             _rate = parcelUsd.mul(TENPOW18).div(_ethUsd);
331         }
332     }
333     // GZE per parcel, without bonus, e.g., 154765.486231783766945298 * 10^18
334     function parcelGzeWithoutBonus() public view returns (uint _rate, bool _live) {
335         uint _gzeUsd;
336         (_gzeUsd, _live) = gzeUsd();
337         if (_live) {
338             _rate = parcelUsd.mul(TENPOW18).div(_gzeUsd);
339         }
340     }
341     // GZE per parcel, with bonus but not on bonus list, e.g., 128971.238526486472454415 * 10^18
342     function parcelGzeWithBonusOffList() public view returns (uint _rate, bool _live) {
343         uint _parcelGzeWithoutBonus;
344         (_parcelGzeWithoutBonus, _live) = parcelGzeWithoutBonus();
345         if (_live) {
346             _rate = _parcelGzeWithoutBonus.mul(100).div(gzeBonusOffList.add(100));
347         }
348     }
349     // GZE per parcel, with bonus and on bonus list, e.g., 119050.374024449051496383 * 10^18
350     function parcelGzeWithBonusOnList() public view returns (uint _rate, bool _live) {
351         uint _parcelGzeWithoutBonus;
352         (_parcelGzeWithoutBonus, _live) = parcelGzeWithoutBonus();
353         if (_live) {
354             _rate = _parcelGzeWithoutBonus.mul(100).div(gzeBonusOnList.add(100));
355         }
356     }
357 
358     // Account contributes by:
359     // 1. calling GZE.approve(landRushAddress, tokens)
360     // 2. calling this.purchaseWithGze(tokens)
361     function purchaseWithGze(uint256 tokens) public {
362         require(gzeToken.allowance(msg.sender, this) >= tokens);
363         receiveApproval(msg.sender, tokens, gzeToken, "");
364     }
365     // Account contributes by calling GZE.approveAndCall(landRushAddress, tokens, "")
366     function receiveApproval(address from, uint256 tokens, address token, bytes /* data */) public {
367         require(now >= startDate && now <= endDate);
368         require(token == address(gzeToken));
369         uint _parcelGze;
370         bool _live;
371         if (bonusList.isInBonusList(from)) {
372             (_parcelGze, _live) = parcelGzeWithBonusOnList();
373         } else {
374             (_parcelGze, _live) = parcelGzeWithBonusOffList();
375         }
376         require(_live);
377         uint parcels = tokens.div(_parcelGze);
378         if (parcelsSold.add(parcels) >= maxParcels) {
379             parcels = maxParcels.sub(parcelsSold);
380         }
381         uint gzeToTransfer = parcels.mul(_parcelGze);
382         contributedGze = contributedGze.add(gzeToTransfer);
383         require(ERC20Interface(token).transferFrom(from, wallet, gzeToTransfer));
384         bool lock = mintParcelTokens(from, parcels);
385         emit Purchased(from, parcels, gzeToTransfer, 0, parcelsSold, contributedGze, contributedEth, lock);
386     }
387     // Account contributes by sending ETH
388     function () public payable {
389         require(now >= startDate && now <= endDate);
390         uint _parcelEth;
391         bool _live;
392         (_parcelEth, _live) = parcelEth();
393         require(_live);
394         uint parcels = msg.value.div(_parcelEth);
395         if (parcelsSold.add(parcels) >= maxParcels) {
396             parcels = maxParcels.sub(parcelsSold);
397         }
398         uint ethToTransfer = parcels.mul(_parcelEth);
399         contributedEth = contributedEth.add(ethToTransfer);
400         uint ethToRefund = msg.value.sub(ethToTransfer);
401         if (ethToRefund > 0) {
402             msg.sender.transfer(ethToRefund);
403         }
404         bool lock = mintParcelTokens(msg.sender, parcels);
405         emit Purchased(msg.sender, parcels, 0, ethToTransfer, parcelsSold, contributedGze, contributedEth, lock);
406     }
407     // Contract owner allocates parcels to tokenOwner for offline purchase
408     function offlinePurchase(address tokenOwner, uint parcels) public onlyOwner {
409         require(!finalised);
410         if (parcelsSold.add(parcels) >= maxParcels) {
411             parcels = maxParcels.sub(parcelsSold);
412         }
413         bool lock = mintParcelTokens(tokenOwner, parcels);
414         emit Purchased(tokenOwner, parcels, 0, 0, parcelsSold, contributedGze, contributedEth, lock);
415     }
416     // Internal function to mint tokens and disable minting if maxParcels sold
417     function mintParcelTokens(address account, uint parcels) internal returns (bool _lock) {
418         require(parcels > 0);
419         parcelsSold = parcelsSold.add(parcels);
420         _lock = parcelToken.balanceOf(account).add(parcelUsd.mul(parcels)) >= usdLockAccountThreshold;
421         require(parcelToken.mint(account, parcelUsd.mul(parcels), _lock));
422         if (parcelsSold >= maxParcels) {
423             parcelToken.disableMinting();
424             finalised = true;
425         }
426     }
427     // Contract owner finalises to disable parcel minting
428     function finalise() public onlyOwner {
429         require(!finalised);
430         require(now > endDate || parcelsSold >= maxParcels);
431         parcelToken.disableMinting();
432         finalised = true;
433     }
434 }