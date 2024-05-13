1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/IBEP20.sol";
6 import "@pancakeswap/pancake-swap-lib/contracts/token/BEP20/SafeBEP20.sol";
7 import "@openzeppelin/contracts-upgradeable/math/MathUpgradeable.sol";
8 import "@pancakeswap/pancake-swap-lib/contracts/math/SafeMath.sol";
9 
10 import "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
11 
12 import "./interface/IVBNB.sol";
13 import "./interface/CompleteVToken.sol";
14 import "./wbnb/WBNB.sol";
15 
16 contract VenusInteractor is ReentrancyGuardUpgradeable {
17 
18   using SafeMath for uint256;
19   using SafeBEP20 for IBEP20;
20 
21   IBEP20 public underlying;
22   IBEP20 public _wbnb = IBEP20(0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c);
23   CompleteVToken public vtoken;
24   ComptrollerInterface public comptroller;
25 
26   constructor(
27     address _underlying,
28     address _vtoken,
29     address _comptroller
30   ) public {
31     // Comptroller:
32     comptroller = ComptrollerInterface(_comptroller);
33 
34     underlying = IBEP20(_underlying);
35     vtoken = CompleteVToken(_vtoken);
36 
37     // Enter the market
38     address[] memory vTokens = new address[](1);
39     vTokens[0] = _vtoken;
40     comptroller.enterMarkets(vTokens);
41   }
42 
43   /**
44   * Supplies BNB to Venus
45   * Unwraps WBNB to BNB, then invoke the special mint for vBNB
46   * We ask to supply "amount", if the "amount" we asked to supply is
47   * more than balance (what we really have), then only supply balance.
48   * If we the "amount" we want to supply is less than balance, then
49   * only supply that amount.
50   */
51   function _supplyBNBInWBNB(uint256 amountInWBNB) internal nonReentrant {
52     // underlying here is WBNB
53     uint256 balance = underlying.balanceOf(address(this)); // supply at most "balance"
54     if (amountInWBNB < balance) {
55       balance = amountInWBNB; // only supply the "amount" if its less than what we have
56     }
57     WBNB wbnb = WBNB(payable(address(_wbnb)));
58     wbnb.withdraw(balance); // Unwrapping
59     IVBNB(address(vtoken)).mint{value: balance}();
60   }
61 
62   /**
63   * Redeems BNB from Venus
64   * receives BNB. Wrap all the BNB that is in this contract.
65   */
66   function _redeemBNBInvTokens(uint256 amountVTokens) internal nonReentrant {
67     _redeemInVTokens(amountVTokens);
68     WBNB wbnb = WBNB(payable(address(_wbnb)));
69     wbnb.deposit{value: address(this).balance}();
70   }
71 
72   /**
73   * Supplies to Venus
74   */
75   function _supply(uint256 amount) internal returns(uint256) {
76     uint256 balance = underlying.balanceOf(address(this));
77     if (amount < balance) {
78       balance = amount;
79     }
80     underlying.safeApprove(address(vtoken), 0);
81     underlying.safeApprove(address(vtoken), balance);
82     uint256 mintResult = vtoken.mint(balance);
83     require(mintResult == 0, "Supplying failed");
84     return balance;
85   }
86 
87   /**
88   * Borrows against the collateral
89   */
90   function _borrow(uint256 amountUnderlying) internal {
91     // Borrow, check the balance for this contract's address
92     uint256 result = vtoken.borrow(amountUnderlying);
93     require(result == 0, "Borrow failed");
94   }
95 
96   /**
97   * Borrows against the collateral
98   */
99   function _borrowInWBNB(uint256 amountUnderlying) internal {
100     // Borrow BNB, wraps into WBNB
101     uint256 result = vtoken.borrow(amountUnderlying);
102     require(result == 0, "Borrow failed");
103     WBNB wbnb = WBNB(payable(address(_wbnb)));
104     wbnb.deposit{value: address(this).balance}();
105   }
106 
107   /**
108   * Repays a loan
109   */
110   function _repay(uint256 amountUnderlying) internal {
111     underlying.safeApprove(address(vtoken), 0);
112     underlying.safeApprove(address(vtoken), amountUnderlying);
113     vtoken.repayBorrow(amountUnderlying);
114     underlying.safeApprove(address(vtoken), 0);
115   }
116 
117   /**
118   * Repays a loan in BNB
119   */
120   function _repayInWBNB(uint256 amountUnderlying) internal {
121     WBNB wbnb = WBNB(payable(address(_wbnb)));
122     wbnb.withdraw(amountUnderlying); // Unwrapping
123     IVBNB(address(vtoken)).repayBorrow{value: amountUnderlying}();
124   }
125 
126   /**
127   * Redeem liquidity in vTokens
128   */
129   function _redeemInVTokens(uint256 amountVTokens) internal {
130     if(amountVTokens > 0){
131       vtoken.redeem(amountVTokens);
132     }
133   }
134 
135   /**
136   * Redeem liquidity in underlying
137   */
138   function _redeemUnderlying(uint256 amountUnderlying) internal {
139     if (amountUnderlying > 0) {
140       vtoken.redeemUnderlying(amountUnderlying);
141     }
142   }
143 
144   /**
145   * Redeem liquidity in underlying
146   */
147   function redeemUnderlyingInWBNB(uint256 amountUnderlying) internal {
148     if (amountUnderlying > 0) {
149       _redeemUnderlying(amountUnderlying);
150       WBNB wbnb = WBNB(payable(address(_wbnb)));
151       wbnb.deposit{value: address(this).balance}();
152     }
153   }
154 
155   /**
156   * Get XVS
157   */
158   function claimVenus() public {
159     address[] memory markets = new address[](1);
160     markets[0] = address(vtoken);
161     comptroller.claimVenus(address(this), markets);
162   }
163 
164   /**
165   * Redeem the minimum of the WBNB we own, and the WBNB that the vToken can
166   * immediately retrieve. Ensures that `redeemMaximum` doesn't fail silently
167   */
168   function redeemMaximumWBNB() internal {
169     // amount of WBNB in contract
170     uint256 available = vtoken.getCash();
171     // amount of WBNB we own
172     uint256 owned = vtoken.balanceOfUnderlying(address(this));
173 
174     // redeem the most we can redeem
175     redeemUnderlyingInWBNB(available < owned ? available : owned);
176   }
177 
178   function redeemMaximumWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
179     // amount of liquidity in Venus
180     uint256 available = vtoken.getCash();
181     // amount we supplied
182     uint256 supplied = vtoken.balanceOfUnderlying(address(this));
183     // amount we borrowed
184     uint256 borrowed = vtoken.borrowBalanceCurrent(address(this));
185 
186     while (borrowed > borrowMinThreshold) {
187       uint256 requiredCollateral = borrowed
188         .mul(collateralFactorDenominator)
189         .add(collateralFactorNumerator.div(2))
190         .div(collateralFactorNumerator);
191 
192       // redeem just as much as needed to repay the loan
193       uint256 wantToRedeem = supplied.sub(requiredCollateral);
194       _redeemUnderlying(MathUpgradeable.min(wantToRedeem, available));
195 
196       // now we can repay our borrowed amount
197       uint256 balance = underlying.balanceOf(address(this));
198       _repay(MathUpgradeable.min(borrowed, balance));
199 
200       // update the parameters
201       available = vtoken.getCash();
202       borrowed = vtoken.borrowBalanceCurrent(address(this));
203       supplied = vtoken.balanceOfUnderlying(address(this));
204     }
205 
206     // redeem the most we can redeem
207     _redeemUnderlying(MathUpgradeable.min(available, supplied));
208   }
209 
210   function redeemMaximumWBNBWithLoan(uint256 collateralFactorNumerator, uint256 collateralFactorDenominator, uint256 borrowMinThreshold) internal {
211     // amount of liquidity in Venus
212     uint256 available = vtoken.getCash();
213     // amount of WBNB we supplied
214     uint256 supplied = vtoken.balanceOfUnderlying(address(this));
215     // amount of WBNB we borrowed
216     uint256 borrowed = vtoken.borrowBalanceCurrent(address(this));
217 
218     while (borrowed > borrowMinThreshold) {
219       uint256 requiredCollateral = borrowed
220         .mul(collateralFactorDenominator)
221         .add(collateralFactorNumerator.div(2))
222         .div(collateralFactorNumerator);
223 
224       // redeem just as much as needed to repay the loan
225       uint256 wantToRedeem = supplied.sub(requiredCollateral);
226       redeemUnderlyingInWBNB(MathUpgradeable.min(wantToRedeem, available));
227 
228       // now we can repay our borrowed amount
229       uint256 balance = underlying.balanceOf(address(this));
230       _repayInWBNB(MathUpgradeable.min(borrowed, balance));
231 
232       // update the parameters
233       available = vtoken.getCash();
234       borrowed = vtoken.borrowBalanceCurrent(address(this));
235       supplied = vtoken.balanceOfUnderlying(address(this));
236     }
237 
238     // redeem the most we can redeem
239     redeemUnderlyingInWBNB(MathUpgradeable.min(available, supplied));
240   }
241 
242   function getLiquidity() external view returns(uint256) {
243     return vtoken.getCash();
244   }
245 
246   function redeemMaximumToken() internal {
247     // amount of tokens in vtoken
248     uint256 available = vtoken.getCash();
249     // amount of tokens we own
250     uint256 owned = vtoken.balanceOfUnderlying(address(this));
251 
252     // redeem the most we can redeem
253     _redeemUnderlying(available < owned ? available : owned);
254   }
255 
256   receive() external payable {} // this is needed for the WBNB unwrapping
257 }
