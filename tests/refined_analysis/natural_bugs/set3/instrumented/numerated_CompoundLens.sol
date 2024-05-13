1 pragma solidity ^0.5.16;
2 pragma experimental ABIEncoderV2;
3 
4 import "../CErc20.sol";
5 import "../Comptroller.sol";
6 import "../CToken.sol";
7 import "../PriceOracle/PriceOracle.sol";
8 import "../EIP20Interface.sol";
9 import "../Exponential.sol";
10 
11 interface CSLPInterface {
12     function claimSushi(address) external returns (uint256);
13 }
14 
15 interface CCTokenInterface {
16     function claimComp(address) external returns (uint256);
17 }
18 
19 contract CompoundLens is Exponential {
20     struct CTokenMetadata {
21         address cToken;
22         uint256 exchangeRateCurrent;
23         uint256 supplyRatePerBlock;
24         uint256 borrowRatePerBlock;
25         uint256 reserveFactorMantissa;
26         uint256 totalBorrows;
27         uint256 totalReserves;
28         uint256 totalSupply;
29         uint256 totalCash;
30         uint256 totalCollateralTokens;
31         bool isListed;
32         uint256 collateralFactorMantissa;
33         address underlyingAssetAddress;
34         uint256 cTokenDecimals;
35         uint256 underlyingDecimals;
36         ComptrollerV2Storage.Version version;
37         uint256 collateralCap;
38         uint256 underlyingPrice;
39         bool supplyPaused;
40         bool borrowPaused;
41         uint256 supplyCap;
42         uint256 borrowCap;
43     }
44 
45     function cTokenMetadataInternal(
46         CToken cToken,
47         Comptroller comptroller,
48         PriceOracle priceOracle
49     ) internal returns (CTokenMetadata memory) {
50         uint256 exchangeRateCurrent = cToken.exchangeRateCurrent();
51         (bool isListed, uint256 collateralFactorMantissa, , ComptrollerV2Storage.Version version) = comptroller.markets(
52             address(cToken)
53         );
54         address underlyingAssetAddress;
55         uint256 underlyingDecimals;
56         uint256 collateralCap;
57         uint256 totalCollateralTokens;
58 
59         if (compareStrings(cToken.symbol(), "crETH")) {
60             underlyingAssetAddress = address(0);
61             underlyingDecimals = 18;
62         } else {
63             CErc20 cErc20 = CErc20(address(cToken));
64             underlyingAssetAddress = cErc20.underlying();
65             underlyingDecimals = EIP20Interface(cErc20.underlying()).decimals();
66         }
67 
68         if (version == ComptrollerV2Storage.Version.COLLATERALCAP) {
69             collateralCap = CCollateralCapErc20Interface(address(cToken)).collateralCap();
70             totalCollateralTokens = CCollateralCapErc20Interface(address(cToken)).totalCollateralTokens();
71         } else if (version == ComptrollerV2Storage.Version.WRAPPEDNATIVE) {
72             collateralCap = CWrappedNativeInterface(address(cToken)).collateralCap();
73             totalCollateralTokens = CWrappedNativeInterface(address(cToken)).totalCollateralTokens();
74         }
75 
76         return
77             CTokenMetadata({
78                 cToken: address(cToken),
79                 exchangeRateCurrent: exchangeRateCurrent,
80                 supplyRatePerBlock: cToken.supplyRatePerBlock(),
81                 borrowRatePerBlock: cToken.borrowRatePerBlock(),
82                 reserveFactorMantissa: cToken.reserveFactorMantissa(),
83                 totalBorrows: cToken.totalBorrows(),
84                 totalReserves: cToken.totalReserves(),
85                 totalSupply: cToken.totalSupply(),
86                 totalCash: cToken.getCash(),
87                 totalCollateralTokens: totalCollateralTokens,
88                 isListed: isListed,
89                 collateralFactorMantissa: collateralFactorMantissa,
90                 underlyingAssetAddress: underlyingAssetAddress,
91                 cTokenDecimals: cToken.decimals(),
92                 underlyingDecimals: underlyingDecimals,
93                 version: version,
94                 collateralCap: collateralCap,
95                 underlyingPrice: priceOracle.getUnderlyingPrice(cToken),
96                 supplyPaused: comptroller.mintGuardianPaused(address(cToken)),
97                 borrowPaused: comptroller.borrowGuardianPaused(address(cToken)),
98                 supplyCap: comptroller.supplyCaps(address(cToken)),
99                 borrowCap: comptroller.borrowCaps(address(cToken))
100             });
101     }
102 
103     function cTokenMetadata(CToken cToken) public returns (CTokenMetadata memory) {
104         Comptroller comptroller = Comptroller(address(cToken.comptroller()));
105         PriceOracle priceOracle = comptroller.oracle();
106         return cTokenMetadataInternal(cToken, comptroller, priceOracle);
107     }
108 
109     function cTokenMetadataAll(CToken[] calldata cTokens) external returns (CTokenMetadata[] memory) {
110         uint256 cTokenCount = cTokens.length;
111         require(cTokenCount > 0, "invalid input");
112         CTokenMetadata[] memory res = new CTokenMetadata[](cTokenCount);
113         Comptroller comptroller = Comptroller(address(cTokens[0].comptroller()));
114         PriceOracle priceOracle = comptroller.oracle();
115         for (uint256 i = 0; i < cTokenCount; i++) {
116             require(address(comptroller) == address(cTokens[i].comptroller()), "mismatch comptroller");
117             res[i] = cTokenMetadataInternal(cTokens[i], comptroller, priceOracle);
118         }
119         return res;
120     }
121 
122     struct CTokenBalances {
123         address cToken;
124         uint256 balanceOf;
125         uint256 borrowBalanceCurrent;
126         uint256 balanceOfUnderlying;
127         uint256 tokenBalance;
128         uint256 tokenAllowance;
129         bool collateralEnabled;
130         uint256 collateralBalance;
131         uint256 nativeTokenBalance;
132     }
133 
134     function cTokenBalances(CToken cToken, address payable account) public returns (CTokenBalances memory) {
135         address comptroller = address(cToken.comptroller());
136         bool collateralEnabled = Comptroller(comptroller).checkMembership(account, cToken);
137         uint256 tokenBalance;
138         uint256 tokenAllowance;
139         uint256 collateralBalance;
140 
141         if (compareStrings(cToken.symbol(), "crETH")) {
142             tokenBalance = account.balance;
143             tokenAllowance = account.balance;
144         } else {
145             CErc20 cErc20 = CErc20(address(cToken));
146             EIP20Interface underlying = EIP20Interface(cErc20.underlying());
147             tokenBalance = underlying.balanceOf(account);
148             tokenAllowance = underlying.allowance(account, address(cToken));
149         }
150 
151         if (collateralEnabled) {
152             (, collateralBalance, , ) = cToken.getAccountSnapshot(account);
153         }
154 
155         return
156             CTokenBalances({
157                 cToken: address(cToken),
158                 balanceOf: cToken.balanceOf(account),
159                 borrowBalanceCurrent: cToken.borrowBalanceCurrent(account),
160                 balanceOfUnderlying: cToken.balanceOfUnderlying(account),
161                 tokenBalance: tokenBalance,
162                 tokenAllowance: tokenAllowance,
163                 collateralEnabled: collateralEnabled,
164                 collateralBalance: collateralBalance,
165                 nativeTokenBalance: account.balance
166             });
167     }
168 
169     function cTokenBalancesAll(CToken[] calldata cTokens, address payable account)
170         external
171         returns (CTokenBalances[] memory)
172     {
173         uint256 cTokenCount = cTokens.length;
174         CTokenBalances[] memory res = new CTokenBalances[](cTokenCount);
175         for (uint256 i = 0; i < cTokenCount; i++) {
176             res[i] = cTokenBalances(cTokens[i], account);
177         }
178         return res;
179     }
180 
181     struct AccountLimits {
182         CToken[] markets;
183         uint256 liquidity;
184         uint256 shortfall;
185     }
186 
187     function getAccountLimits(Comptroller comptroller, address account) public returns (AccountLimits memory) {
188         (uint256 errorCode, uint256 liquidity, uint256 shortfall) = comptroller.getAccountLiquidity(account);
189         require(errorCode == 0);
190 
191         return AccountLimits({markets: comptroller.getAssetsIn(account), liquidity: liquidity, shortfall: shortfall});
192     }
193 
194     function getClaimableSushiRewards(
195         CSLPInterface[] calldata cTokens,
196         address sushi,
197         address account
198     ) external returns (uint256[] memory) {
199         uint256 cTokenCount = cTokens.length;
200         uint256[] memory rewards = new uint256[](cTokenCount);
201         for (uint256 i = 0; i < cTokenCount; i++) {
202             uint256 balanceBefore = EIP20Interface(sushi).balanceOf(account);
203             cTokens[i].claimSushi(account);
204             uint256 balanceAfter = EIP20Interface(sushi).balanceOf(account);
205             rewards[i] = sub_(balanceAfter, balanceBefore);
206         }
207         return rewards;
208     }
209 
210     function getClaimableCompRewards(
211         CCTokenInterface[] calldata cTokens,
212         address comp,
213         address account
214     ) external returns (uint256[] memory) {
215         uint256 cTokenCount = cTokens.length;
216         uint256[] memory rewards = new uint256[](cTokenCount);
217         for (uint256 i = 0; i < cTokenCount; i++) {
218             uint256 balanceBefore = EIP20Interface(comp).balanceOf(account);
219             cTokens[i].claimComp(account);
220             uint256 balanceAfter = EIP20Interface(comp).balanceOf(account);
221             rewards[i] = sub_(balanceAfter, balanceBefore);
222         }
223         return rewards;
224     }
225 
226     function compareStrings(string memory a, string memory b) internal pure returns (bool) {
227         return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked((b))));
228     }
229 }
