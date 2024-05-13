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
16 contract VenusInteractorInitializable is Initializable, ReentrancyGuardUpgradeable {
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
172   /**
173   * Redeem the minimum of the WBNB we own, and the WBNB that the vToken can
174   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently
175   */
176   function redeemMaximumWBNB() internal {
177     // amount of WBNB in contract
178     uint256 available = CompleteVToken(vToken()).getCash();
179     // amount of WBNB we own
180     uint256 owned = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
181 
182     // redeem the most we can redeem
183     redeemUnderlyingInWBNB(available < owned ? available : owned);
184   }
185 
186   function redeemMaximumWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
187     // amount of liquidity in Venus
188     uint256 available = CompleteVToken(vToken()).getCash();
189     // amount we supplied
190     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
191     // amount we borrowed
192     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
193 
194     while (borrowed > borrowMinThreshold) {
195       uint256 requiredCollateral = borrowed
196         .mul(collateralFactorDenominator)
197         .add(collateralFactorNumerator.div(2))
198         .div(collateralFactorNumerator);
199 
200       // redeem just as much as needed to repay the loan
201       uint256 wantToRedeem = supplied.sub(requiredCollateral);
202       _redeemUnderlying(MathUpgradeable.min(wantToRedeem, available));
203 
204       // now we can repay our borrowed amount
205       uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
206       _repay(MathUpgradeable.min(borrowed, balance));
207 
208       // update the parameters
209       available = CompleteVToken(vToken()).getCash();
210       borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
211       supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
212     }
213 
214     // redeem the most we can redeem
215     _redeemUnderlying(MathUpgradeable.min(available, supplied));
216   }
217 
218   function redeemMaximumWBNBWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
219     // amount of liquidity in Venus
220     uint256 available = CompleteVToken(vToken()).getCash();
221     // amount of WBNB we supplied
222     uint256 supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
223     // amount of WBNB we borrowed
224     uint256 borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
225 
226     while (borrowed > borrowMinThreshold) {
227       uint256 requiredCollateral = borrowed
228         .mul(collateralFactorDenominator)
229         .add(collateralFactorNumerator.div(2))
230         .div(collateralFactorNumerator);
231 
232       // redeem just as much as needed to repay the loan
233       uint256 wantToRedeem = supplied.sub(requiredCollateral);
234       redeemUnderlyingInWBNB(MathUpgradeable.min(wantToRedeem, available));
235 
236       // now we can repay our borrowed amount
237       uint256 balance = IBEP20(_underlying()).balanceOf(address(this));
238       _repayInWBNB(MathUpgradeable.min(borrowed, balance));
239 
240       // update the parameters
241       available = CompleteVToken(vToken()).getCash();
242       borrowed = CompleteVToken(vToken()).borrowBalanceCurrent(address(this));
243       supplied = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
244     }
245 
246     // redeem the most we can redeem
247     redeemUnderlyingInWBNB(MathUpgradeable.min(available, supplied));
248   }
249 
250   function getLiquidity() external view returns(uint256) {
251     return CompleteVToken(vToken()).getCash();
252   }
253 
254   function redeemMaximumToken() internal {
255     // amount of tokens in vtoken
256     uint256 available = CompleteVToken(vToken()).getCash();
257     // amount of tokens we own
258     uint256 owned = CompleteVToken(vToken()).balanceOfUnderlying(address(this));
259 
260     // redeem the most we can redeem
261     _redeemUnderlying(available < owned ? available : owned);
262   }
263 
264   receive() external payable {} // this is needed for the WBNB unwrapping
265 
266   function _setInteractorUnderlying(address _address) internal {
267     _setAddress(_INTERACTOR_UNDERLYING_SLOT, _address);
268   }
269 
270   function _underlying() internal virtual view returns (address) {
271     return _getAddress(_INTERACTOR_UNDERLYING_SLOT);
272   }
273 
274   function _setVToken(address _address) internal {
275     _setAddress(_VTOKEN_SLOT, _address);
276   }
277 
278   function vToken() public virtual view returns (address) {
279     return _getAddress(_VTOKEN_SLOT);
280   }
281 
282   function _setComptroller(address _address) internal {
283     _setAddress(_COMPTROLLER_SLOT, _address);
284   }
285 
286   function comptroller() public virtual view returns (address) {
287     return _getAddress(_COMPTROLLER_SLOT);
288   }
289 
290   function _setAddress(bytes32 slot, address _address) internal {
291     // solhint-disable-next-line no-inline-assembly
292     assembly {
293       sstore(slot, _address)
294     }
295   }
296 
297   function _getAddress(bytes32 slot) internal view returns (address str) {
298     // solhint-disable-next-line no-inline-assembly
299     assembly {
300       str := sload(slot)
301     }
302   }
303 }
