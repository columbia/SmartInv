1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 
8 /// @notice Tokenised representation of assets
9 contract EToken is BaseLogic {
10     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__ETOKEN, moduleGitCommit_) {}
11 
12     function CALLER() private view returns (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) {
13         (msgSender, proxyAddr) = unpackTrailingParams();
14         assetStorage = eTokenLookup[proxyAddr];
15         underlying = assetStorage.underlying;
16         require(underlying != address(0), "e/unrecognized-etoken-caller");
17     }
18 
19 
20     // Events
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 
25 
26 
27     // External methods
28 
29     /// @notice Pool name, ie "Euler Pool: DAI"
30     function name() external view returns (string memory) {
31         (address underlying,,,) = CALLER();
32         return string(abi.encodePacked("Euler Pool: ", IERC20(underlying).name()));
33     }
34 
35     /// @notice Pool symbol, ie "eDAI"
36     function symbol() external view returns (string memory) {
37         (address underlying,,,) = CALLER();
38         return string(abi.encodePacked("e", IERC20(underlying).symbol()));
39     }
40 
41     /// @notice Decimals, always normalised to 18.
42     function decimals() external pure returns (uint8) {
43         return 18;
44     }
45 
46     /// @notice Address of underlying asset
47     function underlyingAsset() external view returns (address) {
48         (address underlying,,,) = CALLER();
49         return underlying;
50     }
51 
52 
53 
54     /// @notice Sum of all balances, in internal book-keeping units (non-increasing)
55     function totalSupply() external view returns (uint) {
56         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
57         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
58 
59         return assetCache.totalBalances;
60     }
61 
62     /// @notice Sum of all balances, in underlying units (increases as interest is earned)
63     function totalSupplyUnderlying() external view returns (uint) {
64         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
65         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
66 
67         return balanceToUnderlyingAmount(assetCache, assetCache.totalBalances) / assetCache.underlyingDecimalsScaler;
68     }
69 
70 
71     /// @notice Balance of a particular account, in internal book-keeping units (non-increasing)
72     function balanceOf(address account) external view returns (uint) {
73         (, AssetStorage storage assetStorage,,) = CALLER();
74 
75         return assetStorage.users[account].balance;
76     }
77 
78     /// @notice Balance of a particular account, in underlying units (increases as interest is earned)
79     function balanceOfUnderlying(address account) external view returns (uint) {
80         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
81         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
82 
83         return balanceToUnderlyingAmount(assetCache, assetStorage.users[account].balance) / assetCache.underlyingDecimalsScaler;
84     }
85 
86 
87     /// @notice Balance of the reserves, in internal book-keeping units (non-increasing)
88     function reserveBalance() external view returns (uint) {
89         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
90         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
91 
92         return assetCache.reserveBalance;
93     }
94 
95     /// @notice Balance of the reserves, in underlying units (increases as interest is earned)
96     function reserveBalanceUnderlying() external view returns (uint) {
97         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
98         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
99 
100         return balanceToUnderlyingAmount(assetCache, assetCache.reserveBalance) / assetCache.underlyingDecimalsScaler;
101     }
102 
103 
104     /// @notice Convert an eToken balance to an underlying amount, taking into account current exchange rate
105     /// @param balance eToken balance, in internal book-keeping units (18 decimals)
106     /// @return Amount in underlying units, (same decimals as underlying token)
107     function convertBalanceToUnderlying(uint balance) external view returns (uint) {
108         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
109         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
110 
111         return balanceToUnderlyingAmount(assetCache, balance) / assetCache.underlyingDecimalsScaler;
112     }
113 
114     /// @notice Convert an underlying amount to an eToken balance, taking into account current exchange rate
115     /// @param underlyingAmount Amount in underlying units (same decimals as underlying token)
116     /// @return eToken balance, in internal book-keeping units (18 decimals)
117     function convertUnderlyingToBalance(uint underlyingAmount) external view returns (uint) {
118         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
119         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
120 
121         return underlyingAmountToBalance(assetCache, decodeExternalAmount(assetCache, underlyingAmount));
122     }
123 
124 
125     /// @notice Updates interest accumulator and totalBorrows, credits reserves, re-targets interest rate, and logs asset status
126     function touch() external nonReentrant {
127         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
128         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
129 
130         updateInterestRate(assetStorage, assetCache);
131 
132         logAssetStatus(assetCache);
133     }
134 
135 
136     /// @notice Transfer underlying tokens from sender to the Euler pool, and increase account's eTokens
137     /// @param subAccountId 0 for primary, 1-255 for a sub-account
138     /// @param amount In underlying units (use max uint256 for full underlying token balance)
139     function deposit(uint subAccountId, uint amount) external nonReentrant {
140         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
141         address account = getSubAccount(msgSender, subAccountId);
142 
143         updateAverageLiquidity(account);
144         emit RequestDeposit(account, amount);
145 
146         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
147 
148         if (amount == type(uint).max) {
149             amount = callBalanceOf(assetCache, msgSender);
150         }
151 
152         amount = decodeExternalAmount(assetCache, amount);
153 
154         uint amountTransferred = pullTokens(assetCache, msgSender, amount);
155         uint amountInternal;
156 
157         // pullTokens() updates poolSize in the cache, but we need the poolSize before the deposit to determine
158         // the internal amount so temporarily reduce it by the amountTransferred (which is size checked within
159         // pullTokens()). We can't compute this value before the pull because we don't know how much we'll
160         // actually receive (the token might be deflationary).
161 
162         unchecked {
163             assetCache.poolSize -= amountTransferred;
164             amountInternal = underlyingAmountToBalance(assetCache, amountTransferred);
165             assetCache.poolSize += amountTransferred;
166         }
167 
168         increaseBalance(assetStorage, assetCache, proxyAddr, account, amountInternal);
169 
170         // Depositing a token to an account with pre-existing debt in that token creates a self-collateralized loan
171         // which may result in borrow isolation violation if other tokens are also borrowed on the account
172         if (assetStorage.users[account].owed != 0) checkLiquidity(account);
173 
174         logAssetStatus(assetCache);
175     }
176 
177     /// @notice Transfer underlying tokens from Euler pool to sender, and decrease account's eTokens
178     /// @param subAccountId 0 for primary, 1-255 for a sub-account
179     /// @param amount In underlying units (use max uint256 for full pool balance)
180     function withdraw(uint subAccountId, uint amount) external nonReentrant {
181         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
182         address account = getSubAccount(msgSender, subAccountId);
183 
184         updateAverageLiquidity(account);
185         emit RequestWithdraw(account, amount);
186 
187         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
188 
189         uint amountInternal;
190         (amount, amountInternal) = withdrawAmounts(assetStorage, assetCache, account, amount);
191         require(assetCache.poolSize >= amount, "e/insufficient-pool-size");
192 
193         pushTokens(assetCache, msgSender, amount);
194 
195         decreaseBalance(assetStorage, assetCache, proxyAddr, account, amountInternal);
196 
197         checkLiquidity(account);
198 
199         logAssetStatus(assetCache);
200     }
201 
202 
203     /// @notice Mint eTokens and a corresponding amount of dTokens ("self-borrow")
204     /// @param subAccountId 0 for primary, 1-255 for a sub-account
205     /// @param amount In underlying units
206     function mint(uint subAccountId, uint amount) external nonReentrant {
207         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
208         address account = getSubAccount(msgSender, subAccountId);
209 
210         updateAverageLiquidity(account);
211         emit RequestMint(account, amount);
212 
213         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
214 
215         amount = decodeExternalAmount(assetCache, amount);
216         uint amountInternal = underlyingAmountToBalanceRoundUp(assetCache, amount);
217         amount = balanceToUnderlyingAmount(assetCache, amountInternal);
218 
219         // Mint ETokens
220 
221         increaseBalance(assetStorage, assetCache, proxyAddr, account, amountInternal);
222 
223         // Mint DTokens
224 
225         increaseBorrow(assetStorage, assetCache, assetStorage.dTokenAddress, account, amount);
226 
227         checkLiquidity(account);
228         logAssetStatus(assetCache);
229     }
230 
231     /// @notice Pay off dToken liability with eTokens ("self-repay")
232     /// @param subAccountId 0 for primary, 1-255 for a sub-account
233     /// @param amount In underlying units (use max uint256 to repay the debt in full or up to the available underlying balance)
234     function burn(uint subAccountId, uint amount) external nonReentrant {
235         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
236         address account = getSubAccount(msgSender, subAccountId);
237 
238         updateAverageLiquidity(account);
239         emit RequestBurn(account, amount);
240 
241         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
242 
243         uint owed = getCurrentOwed(assetStorage, assetCache, account);
244         if (owed == 0) return;
245 
246         uint amountInternal;
247         (amount, amountInternal) = withdrawAmounts(assetStorage, assetCache, account, amount);
248 
249         if (amount > owed) {
250             amount = owed;
251             amountInternal = underlyingAmountToBalanceRoundUp(assetCache, amount);
252         }
253 
254         // Burn ETokens
255 
256         decreaseBalance(assetStorage, assetCache, proxyAddr, account, amountInternal);
257 
258         // Burn DTokens
259 
260         decreaseBorrow(assetStorage, assetCache, assetStorage.dTokenAddress, account, amount);
261 
262         checkLiquidity(account);
263         logAssetStatus(assetCache);
264     }
265 
266 
267 
268     /// @notice Allow spender to access an amount of your eTokens in sub-account 0
269     /// @param spender Trusted address
270     /// @param amount Use max uint256 for "infinite" allowance
271     function approve(address spender, uint amount) external reentrantOK returns (bool) {
272         return approveSubAccount(0, spender, amount);
273     }
274 
275     /// @notice Allow spender to access an amount of your eTokens in a particular sub-account
276     /// @param subAccountId 0 for primary, 1-255 for a sub-account
277     /// @param spender Trusted address
278     /// @param amount Use max uint256 for "infinite" allowance
279     function approveSubAccount(uint subAccountId, address spender, uint amount) public nonReentrant returns (bool) {
280         (, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
281         address account = getSubAccount(msgSender, subAccountId);
282 
283         require(!isSubAccountOf(spender, account), "e/self-approval");
284 
285         assetStorage.eTokenAllowance[account][spender] = amount;
286         emitViaProxy_Approval(proxyAddr, account, spender, amount);
287 
288         return true;
289     }
290 
291     /// @notice Retrieve the current allowance
292     /// @param holder Xor with the desired sub-account ID (if applicable)
293     /// @param spender Trusted address
294     function allowance(address holder, address spender) external view returns (uint) {
295         (, AssetStorage storage assetStorage,,) = CALLER();
296 
297         return assetStorage.eTokenAllowance[holder][spender];
298     }
299 
300 
301 
302 
303     /// @notice Transfer eTokens to another address (from sub-account 0)
304     /// @param to Xor with the desired sub-account ID (if applicable)
305     /// @param amount In internal book-keeping units (as returned from balanceOf).
306     function transfer(address to, uint amount) external reentrantOK returns (bool) {
307         return transferFrom(address(0), to, amount);
308     }
309 
310     /// @notice Transfer the full eToken balance of an address to another
311     /// @param from This address must've approved the to address, or be a sub-account of msg.sender
312     /// @param to Xor with the desired sub-account ID (if applicable)
313     function transferFromMax(address from, address to) external reentrantOK returns (bool) {
314         (, AssetStorage storage assetStorage,,) = CALLER();
315 
316         return transferFrom(from, to, assetStorage.users[from].balance);
317     }
318 
319     /// @notice Transfer eTokens from one address to another
320     /// @param from This address must've approved the to address, or be a sub-account of msg.sender
321     /// @param to Xor with the desired sub-account ID (if applicable)
322     /// @param amount In internal book-keeping units (as returned from balanceOf).
323     function transferFrom(address from, address to, uint amount) public nonReentrant returns (bool) {
324         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
325 
326         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
327 
328         if (from == address(0)) from = msgSender;
329         require(from != to, "e/self-transfer");
330 
331         updateAverageLiquidity(from);
332         updateAverageLiquidity(to);
333         emit RequestTransferEToken(from, to, amount);
334 
335         if (amount == 0) return true;
336 
337         if (!isSubAccountOf(msgSender, from) && assetStorage.eTokenAllowance[from][msgSender] != type(uint).max) {
338             require(assetStorage.eTokenAllowance[from][msgSender] >= amount, "e/insufficient-allowance");
339             unchecked { assetStorage.eTokenAllowance[from][msgSender] -= amount; }
340             emitViaProxy_Approval(proxyAddr, from, msgSender, assetStorage.eTokenAllowance[from][msgSender]);
341         }
342 
343         transferBalance(assetStorage, assetCache, proxyAddr, from, to, amount);
344 
345         checkLiquidity(from);
346 
347         // Depositing a token to an account with pre-existing debt in that token creates a self-collateralized loan
348         // which may result in borrow isolation violation if other tokens are also borrowed on the account
349         if (assetStorage.users[to].owed != 0) checkLiquidity(to);
350 
351         logAssetStatus(assetCache);
352 
353         return true;
354     }
355 
356     /// @notice Donate eTokens to the reserves
357     /// @param subAccountId 0 for primary, 1-255 for a sub-account
358     /// @param amount In internal book-keeping units (as returned from balanceOf).
359     function donateToReserves(uint subAccountId, uint amount) external nonReentrant {
360         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
361         address account = getSubAccount(msgSender, subAccountId);
362 
363         updateAverageLiquidity(account);
364         emit RequestDonate(account, amount);
365 
366         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
367 
368         uint origBalance = assetStorage.users[account].balance;
369         uint newBalance;
370 
371         if (amount == type(uint).max) {
372             amount = origBalance;
373             newBalance = 0;
374         } else {
375             require(origBalance >= amount, "e/insufficient-balance");
376             unchecked { newBalance = origBalance - amount; }
377         }
378 
379         assetStorage.users[account].balance = encodeAmount(newBalance);
380         assetStorage.reserveBalance = assetCache.reserveBalance = encodeSmallAmount(assetCache.reserveBalance + amount);
381 
382         emit Withdraw(assetCache.underlying, account, amount);
383         emitViaProxy_Transfer(proxyAddr, account, address(0), amount);
384 
385         logAssetStatus(assetCache);
386     }
387 }
