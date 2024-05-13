1 // SPDX-License-Identifier: GPL-2.0-or-later
2 
3 pragma solidity ^0.8.0;
4 
5 import "../BaseLogic.sol";
6 
7 
8 /// @notice Definition of callback method that flashLoan will invoke on your contract
9 interface IFlashLoan {
10     function onFlashLoan(bytes memory data) external;
11 }
12 
13 
14 /// @notice Tokenised representation of debts
15 contract DToken is BaseLogic {
16     constructor(bytes32 moduleGitCommit_) BaseLogic(MODULEID__DTOKEN, moduleGitCommit_) {}
17 
18     function CALLER() private view returns (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) {
19         (msgSender, proxyAddr) = unpackTrailingParams();
20         address eTokenAddress = dTokenLookup[proxyAddr];
21         require(eTokenAddress != address(0), "e/unrecognized-dtoken-caller");
22         assetStorage = eTokenLookup[eTokenAddress];
23         underlying = assetStorage.underlying;
24     }
25 
26 
27     // Events
28 
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 
32 
33 
34     // External methods
35 
36     /// @notice Debt token name, ie "Euler Debt: DAI"
37     function name() external view returns (string memory) {
38         (address underlying,,,) = CALLER();
39         return string(abi.encodePacked("Euler Debt: ", IERC20(underlying).name()));
40     }
41 
42     /// @notice Debt token symbol, ie "dDAI"
43     function symbol() external view returns (string memory) {
44         (address underlying,,,) = CALLER();
45         return string(abi.encodePacked("d", IERC20(underlying).symbol()));
46     }
47 
48     /// @notice Decimals of underlying
49     function decimals() external view returns (uint8) {
50         (,AssetStorage storage assetStorage,,) = CALLER();
51         return assetStorage.underlyingDecimals;
52     }
53 
54     /// @notice Address of underlying asset
55     function underlyingAsset() external view returns (address) {
56         (address underlying,,,) = CALLER();
57         return underlying;
58     }
59 
60 
61     /// @notice Sum of all outstanding debts, in underlying units (increases as interest is accrued)
62     function totalSupply() external view returns (uint) {
63         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
64         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
65 
66         return assetCache.totalBorrows / INTERNAL_DEBT_PRECISION / assetCache.underlyingDecimalsScaler;
67     }
68 
69     /// @notice Sum of all outstanding debts, in underlying units normalized to 27 decimals (increases as interest is accrued)
70     function totalSupplyExact() external view returns (uint) {
71         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
72         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
73 
74         return assetCache.totalBorrows;
75     }
76 
77 
78     /// @notice Debt owed by a particular account, in underlying units
79     function balanceOf(address account) external view returns (uint) {
80         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
81         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
82 
83         return getCurrentOwed(assetStorage, assetCache, account) / assetCache.underlyingDecimalsScaler;
84     }
85 
86     /// @notice Debt owed by a particular account, in underlying units normalized to 27 decimals
87     function balanceOfExact(address account) external view returns (uint) {
88         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
89         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
90 
91         return getCurrentOwedExact(assetStorage, assetCache, account, assetStorage.users[account].owed);
92     }
93 
94 
95     /// @notice Transfer underlying tokens from the Euler pool to the sender, and increase sender's dTokens
96     /// @param subAccountId 0 for primary, 1-255 for a sub-account
97     /// @param amount In underlying units (use max uint256 for all available tokens)
98     function borrow(uint subAccountId, uint amount) external nonReentrant {
99         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
100         address account = getSubAccount(msgSender, subAccountId);
101 
102         updateAverageLiquidity(account);
103         emit RequestBorrow(account, amount);
104 
105         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
106 
107         if (amount == type(uint).max) {
108             amount = assetCache.poolSize;
109         } else {
110             amount = decodeExternalAmount(assetCache, amount);
111         }
112 
113         require(amount <= assetCache.poolSize, "e/insufficient-tokens-available");
114 
115         pushTokens(assetCache, msgSender, amount);
116 
117         increaseBorrow(assetStorage, assetCache, proxyAddr, account, amount);
118 
119         checkLiquidity(account);
120         logAssetStatus(assetCache);
121     }
122 
123     /// @notice Transfer underlying tokens from the sender to the Euler pool, and decrease sender's dTokens
124     /// @param subAccountId 0 for primary, 1-255 for a sub-account
125     /// @param amount In underlying units (use max uint256 for full debt owed)
126     function repay(uint subAccountId, uint amount) external nonReentrant {
127         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
128         address account = getSubAccount(msgSender, subAccountId);
129 
130         updateAverageLiquidity(account);
131         emit RequestRepay(account, amount);
132 
133         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
134 
135         if (amount != type(uint).max) {
136             amount = decodeExternalAmount(assetCache, amount);
137         }
138 
139         uint owed = getCurrentOwed(assetStorage, assetCache, account);
140         if (owed == 0) return;
141         if (amount > owed) amount = owed;
142 
143         amount = pullTokens(assetCache, msgSender, amount);
144 
145         decreaseBorrow(assetStorage, assetCache, proxyAddr, account, amount);
146 
147         logAssetStatus(assetCache);
148     }
149 
150 
151     /// @notice Request a flash-loan. A onFlashLoan() callback in msg.sender will be invoked, which must repay the loan to the main Euler address prior to returning.
152     /// @param amount In underlying units
153     /// @param data Passed through to the onFlashLoan() callback, so contracts don't need to store transient data in storage
154     function flashLoan(uint amount, bytes calldata data) external nonReentrant {
155         (address underlying,,, address msgSender) = CALLER();
156 
157         uint origBalance = IERC20(underlying).balanceOf(address(this));
158 
159         Utils.safeTransfer(underlying, msgSender, amount);
160 
161         IFlashLoan(msgSender).onFlashLoan(data);
162 
163         require(IERC20(underlying).balanceOf(address(this)) >= origBalance, "e/flash-loan-not-repaid");
164     }
165 
166 
167     /// @notice Allow spender to send an amount of dTokens to a particular sub-account
168     /// @param subAccountId 0 for primary, 1-255 for a sub-account
169     /// @param spender Trusted address
170     /// @param amount In underlying units (use max uint256 for "infinite" allowance)
171     function approveDebt(uint subAccountId, address spender, uint amount) public nonReentrant returns (bool) {
172         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
173         address account = getSubAccount(msgSender, subAccountId);
174 
175         require(!isSubAccountOf(spender, account), "e/self-approval");
176 
177         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
178 
179         assetStorage.dTokenAllowance[account][spender] = amount == type(uint).max ? type(uint).max : decodeExternalAmount(assetCache, amount);
180 
181         emitViaProxy_Approval(proxyAddr, account, spender, amount);
182 
183         return true;
184     }
185 
186     /// @notice Retrieve the current debt allowance
187     /// @param holder Xor with the desired sub-account ID (if applicable)
188     /// @param spender Trusted address
189     function debtAllowance(address holder, address spender) external view returns (uint) {
190         (address underlying, AssetStorage storage assetStorage,,) = CALLER();
191         AssetCache memory assetCache = loadAssetCacheRO(underlying, assetStorage);
192 
193         uint allowance = assetStorage.dTokenAllowance[holder][spender];
194 
195         return allowance == type(uint).max ? type(uint).max : allowance / assetCache.underlyingDecimalsScaler;
196     }
197 
198 
199 
200     /// @notice Transfer dTokens to another address (from sub-account 0)
201     /// @param to Xor with the desired sub-account ID (if applicable)
202     /// @param amount In underlying units. Use max uint256 for full balance.
203     function transfer(address to, uint amount) external reentrantOK returns (bool) {
204         return transferFrom(address(0), to, amount);
205     }
206 
207     /// @notice Transfer dTokens from one address to another
208     /// @param from Xor with the desired sub-account ID (if applicable)
209     /// @param to This address must've approved the from address, or be a sub-account of msg.sender
210     /// @param amount In underlying units. Use max uint256 for full balance.
211     function transferFrom(address from, address to, uint amount) public nonReentrant returns (bool) {
212         (address underlying, AssetStorage storage assetStorage, address proxyAddr, address msgSender) = CALLER();
213         AssetCache memory assetCache = loadAssetCache(underlying, assetStorage);
214 
215         if (from == address(0)) from = msgSender;
216         require(from != to, "e/self-transfer");
217 
218         updateAverageLiquidity(from);
219         updateAverageLiquidity(to);
220         emit RequestTransferDToken(from, to, amount);
221 
222         if (amount == type(uint).max) amount = getCurrentOwed(assetStorage, assetCache, from);
223         else amount = decodeExternalAmount(assetCache, amount);
224 
225         if (amount == 0) return true;
226 
227         if (!isSubAccountOf(msgSender, to) && assetStorage.dTokenAllowance[to][msgSender] != type(uint).max) {
228             require(assetStorage.dTokenAllowance[to][msgSender] >= amount, "e/insufficient-debt-allowance");
229             unchecked { assetStorage.dTokenAllowance[to][msgSender] -= amount; }
230             emitViaProxy_Approval(proxyAddr, to, msgSender, assetStorage.dTokenAllowance[to][msgSender] / assetCache.underlyingDecimalsScaler);
231         }
232 
233         transferBorrow(assetStorage, assetCache, proxyAddr, from, to, amount);
234 
235         checkLiquidity(to);
236         logAssetStatus(assetCache);
237 
238         return true;
239     }
240 }
