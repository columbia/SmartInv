1 // File: contracts/interfaces/IContractRegistry.sol
2 
3 pragma solidity ^0.4.23;
4 
5 /*
6     Contract Registry interface
7 */
8 contract IContractRegistry {
9     function addressOf(bytes32 _contractName) public view returns (address);
10 }
11 
12 // File: contracts/interfaces/IERC20Token.sol
13 
14 pragma solidity ^0.4.23;
15 
16 /*
17     ERC20 Standard Token interface
18 */
19 contract IERC20Token {
20     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
21     function name() public view returns (string) {}
22     function symbol() public view returns (string) {}
23     function decimals() public view returns (uint8) {}
24     function totalSupply() public view returns (uint256) {}
25     function balanceOf(address _owner) public view returns (uint256) { _owner; }
26     function allowance(address _owner, address _spender) public view returns (uint256) { _owner; _spender; }
27 
28     function transfer(address _to, uint256 _value) public returns (bool success);
29     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
30     function approve(address _spender, uint256 _value) public returns (bool success);
31 }
32 
33 // File: contracts/interfaces/IPegSettings.sol
34 
35 pragma solidity ^0.4.23;
36 
37 
38 contract IPegSettings {
39 
40     function authorized(address _address) public view returns (bool) { _address; }
41     
42     function authorize(address _address, bool _auth) public;
43     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;
44 
45 }
46 
47 // File: contracts/interfaces/IVault.sol
48 
49 pragma solidity ^0.4.23;
50 
51 
52 
53 contract IVault {
54 
55     function registry() public view returns (IContractRegistry);
56 
57     function auctions(address _borrower) public view returns (address) { _borrower; }
58     function vaultExists(address _vault) public view returns (bool) { _vault; }
59     function totalBorrowed(address _vault) public view returns (uint256) { _vault; }
60     function rawBalanceOf(address _vault) public view returns (uint256) { _vault; }
61     function rawDebt(address _vault) public view returns (uint256) { _vault; }
62     function rawTotalBalance() public view returns (uint256);
63     function rawTotalDebt() public view returns (uint256);
64     function collateralBorrowedRatio() public view returns (uint256);
65     function amountMinted() public view returns (uint256);
66 
67     function debtScalePrevious() public view returns (uint256);
68     function debtScaleTimestamp() public view returns (uint256);
69     function debtScaleRate() public view returns (int256);
70     function balScalePrevious() public view returns (uint256);
71     function balScaleTimestamp() public view returns (uint256);
72     function balScaleRate() public view returns (int256);
73     
74     function liquidationRatio() public view returns (uint32);
75     function maxBorrowLTV() public view returns (uint32);
76 
77     function borrowingEnabled() public view returns (bool);
78     function biddingTime() public view returns (uint);
79 
80     function setType(bool _type) public;
81     function create(address _vault) public;
82     function setCollateralBorrowedRatio(uint _newRatio) public;
83     function setAmountMinted(uint _amountMinted) public;
84     function setLiquidationRatio(uint32 _liquidationRatio) public;
85     function setMaxBorrowLTV(uint32 _maxBorrowLTV) public;
86     function setDebtScalingRate(int256 _debtScalingRate) public;
87     function setBalanceScalingRate(int256 _balanceScalingRate) public;
88     function setBiddingTime(uint _biddingTime) public;
89     function setRawTotalDebt(uint _rawTotalDebt) public;
90     function setRawTotalBalance(uint _rawTotalBalance) public;
91     function setRawBalanceOf(address _borrower, uint _rawBalance) public;
92     function setRawDebt(address _borrower, uint _rawDebt) public;
93     function setTotalBorrowed(address _borrower, uint _totalBorrowed) public;
94     function debtScalingFactor() public view returns (uint256);
95     function balanceScalingFactor() public view returns (uint256);
96     function debtRawToActual(uint256 _raw) public view returns (uint256);
97     function debtActualToRaw(uint256 _actual) public view returns (uint256);
98     function balanceRawToActual(uint256 _raw) public view returns (uint256);
99     function balanceActualToRaw(uint256 _actual) public view returns (uint256);
100     function getVaults(address _vault, uint256 _balanceOf) public view returns(address[]);
101     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public;
102     function oracleValue() public view returns(uint256);
103     function emitBorrow(address _borrower, uint256 _amount) public;
104     function emitRepay(address _borrower, uint256 _amount) public;
105     function emitDeposit(address _borrower, uint256 _amount) public;
106     function emitWithdraw(address _borrower, address _to, uint256 _amount) public;
107     function emitLiquidate(address _borrower) public;
108     function emitAuctionStarted(address _borrower) public;
109     function emitAuctionEnded(address _borrower, address _highestBidder, uint256 _highestBid) public;
110     function setAuctionAddress(address _borrower, address _auction) public;
111 }
112 
113 // File: contracts/interfaces/IPegOracle.sol
114 
115 pragma solidity ^0.4.23;
116 
117 contract IPegOracle {
118     function getValue() public view returns (uint256);
119 }
120 
121 // File: contracts/interfaces/IOwned.sol
122 
123 pragma solidity ^0.4.23;
124 
125 /*
126     Owned contract interface
127 */
128 contract IOwned {
129     // this function isn't abstract since the compiler emits automatically generated getter functions as external
130     function owner() public view returns (address) {}
131 
132     function transferOwnership(address _newOwner) public;
133     function acceptOwnership() public;
134     function setOwner(address _newOwner) public;
135 }
136 
137 // File: contracts/interfaces/ISmartToken.sol
138 
139 pragma solidity ^0.4.23;
140 
141 
142 
143 /*
144     Smart Token interface
145 */
146 contract ISmartToken is IOwned, IERC20Token {
147     function disableTransfers(bool _disable) public;
148     function issue(address _to, uint256 _amount) public;
149     function destroy(address _from, uint256 _amount) public;
150 }
151 
152 // File: contracts/interfaces/IPegLogic.sol
153 
154 pragma solidity ^0.4.23;
155 
156 
157 
158 
159 contract IPegLogic {
160 
161     function adjustCollateralBorrowingRate() public;
162     function isInsolvent(IVault _vault, address _borrower) public view returns (bool);
163     function actualDebt(IVault _vault, address _address) public view returns(uint256);
164     function excessCollateral(IVault _vault, address _borrower) public view returns (int256);
165     function availableCredit(IVault _vault, address _borrower) public view returns (int256);
166     function getCollateralToken(IVault _vault) public view returns(IERC20Token);
167     function getDebtToken(IVault _vault) public view returns(ISmartToken);
168 
169 }
170 
171 // File: contracts/interfaces/IAuctionActions.sol
172 
173 pragma solidity ^0.4.23;
174 
175 
176 contract IAuctionActions {
177 
178     function startAuction(IVault _vault, address _borrower) public;
179     function endAuction(IVault _vault, address _borrower) public;
180 
181 }
182 
183 // File: contracts/ContractIds.sol
184 
185 pragma solidity ^0.4.23;
186 
187 contract ContractIds {
188     bytes32 public constant STABLE_TOKEN = "StableToken";
189     bytes32 public constant COLLATERAL_TOKEN = "CollateralToken";
190 
191     bytes32 public constant PEGUSD_TOKEN = "PEGUSD";
192 
193     bytes32 public constant VAULT_A = "VaultA";
194     bytes32 public constant VAULT_B = "VaultB";
195 
196     bytes32 public constant PEG_LOGIC = "PegLogic";
197     bytes32 public constant PEG_LOGIC_ACTIONS = "LogicActions";
198     bytes32 public constant AUCTION_ACTIONS = "AuctionActions";
199 
200     bytes32 public constant PEG_SETTINGS = "PegSettings";
201     bytes32 public constant ORACLE = "Oracle";
202     bytes32 public constant FEE_RECIPIENT = "StabilityFeeRecipient";
203 }
204 
205 // File: contracts/Helpers.sol
206 
207 pragma solidity ^0.4.23;
208 
209 
210 
211 
212 
213 
214 
215 
216 
217 
218 contract Helpers is ContractIds {
219 
220     IContractRegistry public registry;
221 
222     constructor(IContractRegistry _registry) public {
223         registry = _registry;
224     }
225 
226     modifier authOnly() {
227         require(settings().authorized(msg.sender));
228         _;
229     }
230 
231     modifier validate(IVault _vault, address _borrower) {
232         require(address(_vault) == registry.addressOf(ContractIds.VAULT_A) || address(_vault) == registry.addressOf(ContractIds.VAULT_B));
233         _vault.create(_borrower);
234         _;
235     }
236 
237     function stableToken() internal returns(ISmartToken) {
238         return ISmartToken(registry.addressOf(ContractIds.STABLE_TOKEN));
239     }
240 
241     function collateralToken() internal returns(ISmartToken) {
242         return ISmartToken(registry.addressOf(ContractIds.COLLATERAL_TOKEN));
243     }
244 
245     function PEGUSD() internal returns(IERC20Token) {
246         return IERC20Token(registry.addressOf(ContractIds.PEGUSD_TOKEN));
247     }
248 
249     function vaultA() internal returns(IVault) {
250         return IVault(registry.addressOf(ContractIds.VAULT_A));
251     }
252 
253     function vaultB() internal returns(IVault) {
254         return IVault(registry.addressOf(ContractIds.VAULT_B));
255     }
256 
257     function oracle() internal returns(IPegOracle) {
258         return IPegOracle(registry.addressOf(ContractIds.ORACLE));
259     }
260 
261     function settings() internal returns(IPegSettings) {
262         return IPegSettings(registry.addressOf(ContractIds.PEG_SETTINGS));
263     }
264 
265     function pegLogic() internal returns(IPegLogic) {
266         return IPegLogic(registry.addressOf(ContractIds.PEG_LOGIC));
267     }
268 
269     function auctionActions() internal returns(IAuctionActions) {
270         return IAuctionActions(registry.addressOf(ContractIds.AUCTION_ACTIONS));
271     }
272 
273     function transferERC20Token(IERC20Token _token, address _to, uint256 _amount) public authOnly {
274         _token.transfer(_to, _amount);
275     }
276 
277 }
278 
279 // File: contracts/library/SafeMath.sol
280 
281 pragma solidity ^0.4.23;
282 
283 library SafeMath {
284     function plus(uint256 _a, uint256 _b) internal pure returns (uint256) {
285         uint256 c = _a + _b;
286         assert(c >= _a);
287         return c;
288     }
289 
290     function plus(int256 _a, int256 _b) internal pure returns (int256) {
291         int256 c = _a + _b;
292         assert((_b >= 0 && c >= _a) || (_b < 0 && c < _a));
293         return c;
294     }
295 
296     function minus(uint256 _a, uint256 _b) internal pure returns (uint256) {
297         assert(_a >= _b);
298         return _a - _b;
299     }
300 
301     function minus(int256 _a, int256 _b) internal pure returns (int256) {
302         int256 c = _a - _b;
303         assert((_b >= 0 && c <= _a) || (_b < 0 && c > _a));
304         return c;
305     }
306 
307     function times(uint256 _a, uint256 _b) internal pure returns (uint256) {
308         if (_a == 0) {
309             return 0;
310         }
311         uint256 c = _a * _b;
312         assert(c / _a == _b);
313         return c;
314     }
315 
316     function times(int256 _a, int256 _b) internal pure returns (int256) {
317         if (_a == 0) {
318             return 0;
319         }
320         int256 c = _a * _b;
321         assert(c / _a == _b);
322         return c;
323     }
324 
325     function toInt256(uint256 _a) internal pure returns (int256) {
326         assert(_a <= 2 ** 255);
327         return int256(_a);
328     }
329 
330     function toUint256(int256 _a) internal pure returns (uint256) {
331         assert(_a >= 0);
332         return uint256(_a);
333     }
334 
335     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
336         return _a / _b;
337     }
338 
339     function div(int256 _a, int256 _b) internal pure returns (int256) {
340         return _a / _b;
341     }
342 }
343 
344 // File: contracts/LogicActions.sol
345 
346 pragma solidity ^0.4.23;
347 
348 
349 
350 
351 
352 
353 contract LogicActions is Helpers {
354 
355     using SafeMath for uint256;
356     using SafeMath for int256;
357 
358     IContractRegistry public registry;
359 
360     constructor(IContractRegistry _registry) public Helpers(_registry) {
361         registry = _registry;
362     }
363 
364     function deposit(IVault _vault, uint256 _amount) public validate(_vault, msg.sender) {
365         IERC20Token vaultCollateralToken = pegLogic().getCollateralToken(_vault);
366         vaultCollateralToken.transferFrom(msg.sender, address(_vault), _amount);
367         _vault.setRawBalanceOf(
368             msg.sender,
369             _vault.rawBalanceOf(msg.sender).plus(_vault.balanceActualToRaw(_amount))
370         );
371         _vault.setRawTotalBalance(
372             _vault.rawTotalBalance().plus(_vault.balanceActualToRaw(_amount))
373         );
374         pegLogic().adjustCollateralBorrowingRate();
375         _vault.emitDeposit(msg.sender, _amount);
376     }
377 
378     function withdraw(IVault _vault, address _to, uint256 _amount) public validate(_vault, msg.sender) {
379         IPegLogic ipegLogic = pegLogic();
380         require(_amount.toInt256() <= ipegLogic.excessCollateral(_vault, msg.sender), "Insufficient collateral balance");
381         _vault.setRawBalanceOf(
382             msg.sender,
383             _vault.rawBalanceOf(msg.sender).minus(_vault.balanceActualToRaw(_amount))
384         );
385         _vault.setRawTotalBalance(
386             _vault.rawTotalBalance().minus(_vault.balanceActualToRaw(_amount))
387         );
388         _vault.transferERC20Token(ipegLogic.getCollateralToken(_vault), _to, _amount);
389         if(_vault.rawTotalBalance() > 0)
390             ipegLogic.adjustCollateralBorrowingRate();
391         _vault.emitWithdraw(msg.sender, _to, _amount);
392     }
393 
394     function borrow(IVault _vault, uint256 _amount) public validate(_vault, msg.sender) {
395         IPegLogic ipegLogic = pegLogic();
396         require(_amount.toInt256() <= ipegLogic.availableCredit(_vault, msg.sender), "Not enough available credit");
397         require(_vault.borrowingEnabled(), "Borrowing disabled");
398         address auctionAddress = _vault.auctions(msg.sender);
399         require(auctionAddress == address(0), "Can't borrow when there's ongoing auction on your vault");
400         _vault.setRawDebt(msg.sender, _vault.rawDebt(msg.sender).plus(_vault.debtActualToRaw(_amount)));
401         _vault.setTotalBorrowed(msg.sender, _vault.totalBorrowed(msg.sender).plus(_amount));
402         _vault.setRawTotalDebt(_vault.rawTotalDebt().plus(_vault.debtActualToRaw(_amount)));
403         if (address(_vault) == address(vaultA())) {
404             stableToken().issue(msg.sender, _amount);
405         } else {
406             vaultA().transferERC20Token(collateralToken(), msg.sender, _amount);
407         }
408         ipegLogic.adjustCollateralBorrowingRate();
409         _vault.emitBorrow(msg.sender, _amount);
410     }
411 
412     function doPay(IVault _vault, address _payor, address _borrower, uint256 _amount, bool _all) internal {
413         ISmartToken vaultDebtToken = pegLogic().getDebtToken(_vault);
414         if (address(_vault) == address(vaultA())) {
415             vaultDebtToken.destroy(_payor, _amount);
416         } else {
417             vaultDebtToken.transferFrom(_payor, address(vaultA()), _amount);
418         }
419         _vault.setRawTotalDebt(_vault.rawTotalDebt().minus(_vault.debtActualToRaw(_amount)));
420 
421         if(_all) {
422             _vault.setRawDebt(_borrower, 0);
423             _vault.setTotalBorrowed(_borrower, 0);
424         } else {
425             _vault.setRawDebt(_borrower, _vault.rawDebt(_borrower).minus(_vault.debtActualToRaw(_amount)));
426             _vault.setTotalBorrowed(_borrower, _vault.totalBorrowed(_borrower).minus(_amount));
427         }
428         pegLogic().adjustCollateralBorrowingRate();
429         _vault.emitRepay(_borrower, _amount);
430     }
431 
432     function repay(IVault _vault, address _borrower, uint256 _amount) public validate(_vault, _borrower) {
433         doPay(_vault, msg.sender, _borrower, _amount, false);
434     }
435 
436     function repayAuction(IVault _vault, address _borrower, uint256 _amount) public validate(_vault, _borrower)
437     {
438         require(_vault.auctions(_borrower) == msg.sender, "Invalid auction");
439         doPay(_vault, msg.sender, msg.sender, _amount, true);
440     }
441 
442     function repayAll(IVault _vault, address _borrower) public validate(_vault, _borrower) {
443         uint256 _amount = pegLogic().actualDebt(_vault, _borrower);
444         doPay(_vault, msg.sender, _borrower, _amount, true);
445     }
446 
447 }