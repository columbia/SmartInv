1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 
8 import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
9 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
10 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
11 import "./interface/IVBNB.sol";
12 import "./interface/CompleteVToken.sol";
13 import "./wbnb/WBNB.sol";
14 import "@openzeppelin/contracts-upgradeable/proxy/Initializable.sol";
15 
16 contract VenusInteractorInitializableV2 is Initializable, ReentrancyGuardUpgradeable {
17 
18   using SafeMath for uint256;
19   using SafeBEP20 for IBEP20;
20 
21   address public constant _wbnb = address(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
22 
23   bytes32 internal constant _INTERACTOR_UNDERLYING_SLOT = 0x3e9f9f7ea72bae20746fd93eefa9f38d4f124c4ea7b6f6d6641f8cca268c5697;
24   bytes32 internal constant _VTOKEN_SLOT = 0xd10d7aea8cd8c74e560aafdc0a5d3820e89ad384815628d13908d84a477ec585;
25   bytes32 internal constant _COMPTROLLER_SLOT = 0xd6eb26dcc0c659c2dac09757ba602511aadae03cd65090aa8c177fb971879dd6;
26 
27   constructor() public {
28     assert(_INTERACTOR_UNDERLYING_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.underlying")) - 1));
29     assert(_VTOKEN_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.vtoken")) - 1));
30     assert(_COMPTROLLER_SLOT == bytes32(uint256(keccak256("eip1967.interactorStorage.comptroller")) - 1));
31   }
32 
33   function initialize(
34     address _underlying,
35     address _vtoken,
36     address _comptroller
37   ) public initializer {
38     __ReentrancyGuard_init();
39     // Comptroller:
40     _setComptroller(_comptroller);
41     _setInteractorUnderlying(_underlying);
42     _setVToken(_vtoken);
43 
44     // Enter the market
45     address[] memory vTokens = new address[](1);
46     vTokens[0] = _vtoken;
47     ComptrollerInterface(comptroller()).enterMarkets(vTokens);
48 
49   }
50 
51   /**
52   * Supplies BNB to Venus
53   * Unwraps WBNB to BNB, then invoke the special mint for vBNB
54   * We ask to supply "amount", if the "amount" we asked to supply is
55   * more than balance (what we really have), then only supply balance.
56   * If we the "amount" we want to supply is less than balance, then
57   * only supply that amount.
58   */
59   function _supplyBNBInWBNB(uint256 amountInWBNB) internal nonReentrant {
60     // underlying here is WBNB
61     uint256 balance = IBEP20(_underlying()).balanceOf(address(this)); // supply at most "balance"
62     if (amountInWBNB < balance) {
63       balance = amountInWBNB; // only supply the "amount" if its less than what we have
64     }
65     WBNB wbnb = WBNB(payable(_wbnb));
66     wbnb.withdraw(balance); // Unwrapping
67     IVBNB(vToken()).mint{value: balance}();
68   }
69 
70   /**
71   * Redeems BNB from Venus
72   * receives BNB. Wrap all the BNB that is in this contract.
73   */
74   function _redeemBNBInvTokens(uint256 amountVTokens) internal nonReentrant {
75     _redeemInVTokens(amountVTokens);
76     WBNB wbnb = WBNB(payable(_wbnb));
77     wbnb.deposit{value: address(this).balance}();
78   }
79 
80   /**
81   * Supplies to Venus
82   */
83   function _supply(uint256 amount) internal returns(uint256) {
84     uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
85     if (amount < balance) {
86       balance = amount;
87     }
88     IBEP20(_underlying()).safeApprove(vToken(), 0);
89     IBEP20(_underlying()).safeApprove(vToken(), balance);
90     uint256 mintResult = CompleteVToken(vToken()).mint(balance);
91     require(mintResult == 0, "Supplying failed");
92     return balance;
93   }
94 
95   /**
96   * Borrows against the collateral
97   */
98   function _borrow(uint256 amountUnderlying) internal {
99     // Borrow, check the balance for this contract's address
100     uint256 result = CompleteVToken(vToken()).borrow(amountUnderlying);
101     require(result == 0, "Borrow failed");
102   }
103 
104   /**
105   * Borrows against the collateral
106   */
107   function _borrowInWBNB(uint256 amountUnderlying) internal {
108     // Borrow BNB, wraps into WBNB
109     uint256 result = CompleteVToken(vToken()).borrow(amountUnderlying);
110     require(result == 0, "Borrow failed");
111     WBNB wbnb = WBNB(payable(_wbnb));
112     wbnb.deposit{value: address(this).balance}();
113   }
114 
115   /**
116   * Repays a loan
117   */
118   function _repay(uint256 amountUnderlying) internal {
119     IBEP20(_underlying()).safeApprove(vToken(), 0);
120     IBEP20(_underlying()).safeApprove(vToken(), amountUnderlying);
121     CompleteVToken(vToken()).repayBorrow(amountUnderlying);
122     IBEP20(_underlying()).safeApprove(vToken(), 0);
123   }
124 
125   /**
126   * Repays a loan in BNB
127   */
128   function _repayInWBNB(uint256 amountUnderlying) internal {
129     WBNB wbnb = WBNB(payable(_wbnb));
130     wbnb.withdraw(amountUnderlying); // Unwrapping
131     IVBNB(vToken()).repayBorrow{value: amountUnderlying}();
132   }
133 
134   /**
135   * Redeem liquidity in vTokens
136   */
137   function _redeemInVTokens(uint256 amountVTokens) internal {
138     if(amountVTokens > 0){
139       CompleteVToken(vToken()).redeem(amountVTokens);
140     }
141   }
142 
143   /**
144   * Redeem liquidity in underlying
145   */
146   function _redeemUnderlying(uint256 amountUnderlying) internal {
147     if (amountUnderlying > 0) {
148       CompleteVToken(vToken()).redeemUnderlying(amountUnderlying);
149     }
150   }
151 
152   /**
153   * Redeem liquidity in underlying
154   */
155   function redeemUnderlyingInWBNB(uint256 amountUnderlying) internal {
156     if (amountUnderlying > 0) {
157       _redeemUnderlying(amountUnderlying);
158       WBNB wbnb = WBNB(payable(_wbnb));
159       wbnb.deposit{value: address(this).balance}();
160     }
161   }
162 
163   /**
164   * Get XVS
165   */
166   function claimVenus() public {
167     address[] memory markets = new address[](1);
168     markets[0] = address(vToken());
169     ComptrollerInterface(comptroller()).claimVenus(address(this), markets);
170   }
171 
172   function redeemMaximumWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
173     // amount of liquidity in Venus
174     uint256 available = CompleteVToken(vToken()).getCash();
175     // amount we supplied
176     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
177     // amount we borrowed
178     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
179 
180     while (borrowed > borrowMinThreshold) {
181       uint256 requiredCollateral = borrowed
182         .mul(collateralFactorDenominator)
183         .add(collateralFactorNumerator.div(2))
184         .div(collateralFactorNumerator);
185 
186       // redeem just as much as needed to repay the loan
187       uint256 wantToRedeem = supplied.sub(requiredCollateral);
188       _redeemUnderlying(MathUpgradeable.min(wantToRedeem, available));
189 
190       // now we can repay our borrowed amount
191       uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
192       _repay(MathUpgradeable.min(borrowed, balance));
193 
194       // update the parameters
195       available = CompleteVToken(vToken()).getCash();
196       borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
197       supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
198     }
199 
200     // redeem the most we can redeem
201     _redeemUnderlying(MathUpgradeable.min(available, supplied));
202   }
203 
204   function redeemMaximumNoFold() internal {
205     // amount of liquidity in Venus
206     uint256 available = CompleteVToken(vToken()).getCash();
207     // amount we supplied
208     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
209 
210     _redeemUnderlying(MathUpgradeable.min(supplied, available));
211   }
212 
213   function redeemMaximumWBNBWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
214     // amount of liquidity in Venus
215     uint256 available = CompleteVToken(vToken()).getCash();
216     // amount of WBNB we supplied
217     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
218     // amount of WBNB we borrowed
219     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
220 
221     while (borrowed > borrowMinThreshold) {
222       uint256 requiredCollateral = borrowed
223         .mul(collateralFactorDenominator)
224         .add(collateralFactorNumerator.div(2))
225         .div(collateralFactorNumerator);
226 
227       // redeem just as much as needed to repay the loan
228       uint256 wantToRedeem = supplied.sub(requiredCollateral);
229       redeemUnderlyingInWBNB(MathUpgradeable.min(wantToRedeem, available));
230 
231       // now we can repay our borrowed amount
232       uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
233       _repayInWBNB(MathUpgradeable.min(borrowed, balance));
234 
235       // update the parameters
236       available = CompleteVToken(vToken()).getCash();
237       borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
238       supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
239     }
240 
241     // redeem the most we can redeem
242     redeemUnderlyingInWBNB(MathUpgradeable.min(available, supplied));
243   }
244 
245   function redeemMaximumWBNBNoFold() internal {
246     // amount of liquidity in Venus
247     uint256 available = CompleteVToken(vToken()).getCash();
248     // amount we supplied
249     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
250 
251     redeemUnderlyingInWBNB(MathUpgradeable.min(supplied, available));
252   }
253 
254   function getLiquidity() external view returns(uint256) {
255     return CompleteVToken(vToken()).getCash();
256   }
257 
258   function redeemMaximumToken() internal {
259     // amount of tokens in vtoken
260     uint256 available = CompleteVToken(vToken()).getCash();
261     // amount of tokens we own
262     uint256 owned = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
263 
264     // redeem the most we can redeem
265     _redeemUnderlying(available < owned ? available : owned);
266   }
267 
268   receive() external payable {} // this is needed for the WBNB unwrapping
269 
270   function _setInteractorUnderlying(address _address) internal {
271     _setAddress(_INTERACTOR_UNDERLYING_SLOT, _address);
272   }
273 
274   function _underlying() internal virtual view returns (address) {
275     return _getAddress(_INTERACTOR_UNDERLYING_SLOT);
276   }
277 
278   function _setVToken(address _address) internal {
279     _setAddress(_VTOKEN_SLOT, _address);
280   }
281 
282   function vToken() public virtual view returns (address) {
283     return _getAddress(_VTOKEN_SLOT);
284   }
285 
286   function _setComptroller(address _address) internal {
287     _setAddress(_COMPTROLLER_SLOT, _address);
288   }
289 
290   function comptroller() public virtual view returns (address) {
291     return _getAddress(_COMPTROLLER_SLOT);
292   }
293 
294   function _setAddress(bytes32 slot, address _address) internal {
295     // solhint-disable-next-line no-inline-assembly
296     assembly {
297       sstore(slot, _address)
298     }
299   }
300 
301   function _getAddress(bytes32 slot) internal view returns (address str) {
302     // solhint-disable-next-line no-inline-assembly
303     assembly {
304       str := sload(slot)
305     }
306   }
307 }
