1 //SPDX-License-Identifier: GPL-3.0
2 pragma solidity 0.8.4;
3 
4 contract Exchange is ERC20, ReentrancyGuard {
5     using MathLib for uint256;
6     using SafeERC20 for IERC20;
7 
8     address public immutable baseToken; // address of ERC20 base token (elastic or fixed supply)
9     address public immutable quoteToken; // address of ERC20 quote token (WETH or a stable coin w/ fixed supply)
10     address public immutable exchangeFactoryAddress;
11 
12     uint256 public constant TOTAL_LIQUIDITY_FEE = 30; // fee provided to liquidity providers + DAO in basis points
13 
14     MathLib.InternalBalances public internalBalances =
15         MathLib.InternalBalances(0, 0, 0);
16 
17     event AddLiquidity(
18         address indexed liquidityProvider,
19         uint256 baseTokenQtyAdded,
20         uint256 quoteTokenQtyAdded
21     );
22     event RemoveLiquidity(
23         address indexed liquidityProvider,
24         uint256 baseTokenQtyRemoved,
25         uint256 quoteTokenQtyRemoved
26     );
27     event Swap(
28         address indexed sender,
29         uint256 baseTokenQtyIn,
30         uint256 quoteTokenQtyIn,
31         uint256 baseTokenQtyOut,
32         uint256 quoteTokenQtyOut
33     );
34 
35 
36     function isNotExpired(uint256 _expirationTimeStamp) internal view {
37         require(_expirationTimeStamp >= block.timestamp, "Exchange: EXPIRED");
38     }
39 
40   
41     constructor(
42         string memory _name,
43         string memory _symbol,
44         address _baseToken,
45         address _quoteToken,
46         address _exchangeFactoryAddress
47     ) ERC20(_name, _symbol) {
48         baseToken = _baseToken;
49         quoteToken = _quoteToken;
50         exchangeFactoryAddress = _exchangeFactoryAddress;
51     }
52 
53 
54     function addLiquidity(
55         uint256 _baseTokenQtyDesired,
56         uint256 _quoteTokenQtyDesired,
57         uint256 _baseTokenQtyMin,
58         uint256 _quoteTokenQtyMin,
59         address _liquidityTokenRecipient,
60         uint256 _expirationTimestamp
61     ) external nonReentrant() {
62         isNotExpired(_expirationTimestamp);
63 
64         MathLib.TokenQtys memory tokenQtys =
65             MathLib.calculateAddLiquidityQuantities(
66                 _baseTokenQtyDesired,
67                 _quoteTokenQtyDesired,
68                 _baseTokenQtyMin,
69                 _quoteTokenQtyMin,
70                 IERC20(baseToken).balanceOf(address(this)),
71                 IERC20(quoteToken).balanceOf(address(this)),
72                 this.totalSupply(),
73                 internalBalances
74             );
75         //here is the buggy line 
76         internalBalances.kLast =
77             internalBalances.baseTokenReserveQty 
78             internalBalances.quoteTokenReserveQty;
79 
80         if (tokenQtys.liquidityTokenFeeQty > 0) {
81             // mint liquidity tokens to fee address for k growth.
82             _mint(
83                 IExchangeFactory(exchangeFactoryAddress).feeAddress(),
84                 tokenQtys.liquidityTokenFeeQty
85             );
86         }
87         _mint(_liquidityTokenRecipient, tokenQtys.liquidityTokenQty); // mint liquidity tokens to recipient
88 
89         if (tokenQtys.baseTokenQty != 0) {
90             bool isExchangeEmpty =
91                 IERC20(baseToken).balanceOf(address(this)) == 0;
92 
93             // transfer base tokens to Exchange
94             IERC20(baseToken).safeTransferFrom(
95                 msg.sender,
96                 address(this),
97                 tokenQtys.baseTokenQty
98             );
99 
100             if (isExchangeEmpty) {
101                 require(
102                     IERC20(baseToken).balanceOf(address(this)) ==
103                         tokenQtys.baseTokenQty,
104                     "Exchange: FEE_ON_TRANSFER_NOT_SUPPORTED"
105                 );
106             }
107         }
108 
109         if (tokenQtys.quoteTokenQty != 0) {
110             // transfer quote tokens to Exchange
111             IERC20(quoteToken).safeTransferFrom(
112                 msg.sender,
113                 address(this),
114                 tokenQtys.quoteTokenQty
115             );
116         }
117 
118         emit AddLiquidity(
119             msg.sender,
120             tokenQtys.baseTokenQty,
121             tokenQtys.quoteTokenQty
122         );
123     }
124 
125    
126     function removeLiquidity(
127         uint256 _liquidityTokenQty,
128         uint256 _baseTokenQtyMin,
129         uint256 _quoteTokenQtyMin,
130         address _tokenRecipient,
131         uint256 _expirationTimestamp
132     ) external nonReentrant() {
133         isNotExpired(_expirationTimestamp);
134         require(this.totalSupply() > 0, "Exchange: INSUFFICIENT_LIQUIDITY");
135         require(
136             _baseTokenQtyMin > 0 && _quoteTokenQtyMin > 0,
137             "Exchange: MINS_MUST_BE_GREATER_THAN_ZERO"
138         );
139 
140     
141         uint256 baseTokenReserveQty =
142             IERC20(baseToken).balanceOf(address(this));
143         uint256 quoteTokenReserveQty =
144             IERC20(quoteToken).balanceOf(address(this));
145 
146         uint256 totalSupplyOfLiquidityTokens = this.totalSupply();
147         // calculate any DAO fees here.
148         uint256 liquidityTokenFeeQty =
149             MathLib.calculateLiquidityTokenFees(
150                 totalSupplyOfLiquidityTokens,
151                 internalBalances
152             );
153 
154         totalSupplyOfLiquidityTokens += liquidityTokenFeeQty;
155 
156         uint256 baseTokenQtyToReturn =
157             (_liquidityTokenQty * baseTokenReserveQty) /
158                 totalSupplyOfLiquidityTokens;
159         uint256 quoteTokenQtyToReturn =
160             (_liquidityTokenQty * quoteTokenReserveQty) /
161                 totalSupplyOfLiquidityTokens;
162 
163         require(
164             baseTokenQtyToReturn >= _baseTokenQtyMin,
165             "Exchange: INSUFFICIENT_BASE_QTY"
166         );
167 
168         require(
169             quoteTokenQtyToReturn >= _quoteTokenQtyMin,
170             "Exchange: INSUFFICIENT_QUOTE_QTY"
171         );
172 
173         uint256 baseTokenQtyToRemoveFromInternalAccounting =
174             (_liquidityTokenQty * internalBalances.baseTokenReserveQty) /
175                 totalSupplyOfLiquidityTokens;
176 
177         internalBalances
178             .baseTokenReserveQty -= baseTokenQtyToRemoveFromInternalAccounting;
179 
180 
181         if (quoteTokenQtyToReturn > internalBalances.quoteTokenReserveQty) {
182             internalBalances.quoteTokenReserveQty = 0;
183         } else {
184             internalBalances.quoteTokenReserveQty -= quoteTokenQtyToReturn;
185         }
186 
187         internalBalances.kLast =
188             internalBalances.baseTokenReserveQty *
189             internalBalances.quoteTokenReserveQty;
190 
191         if (liquidityTokenFeeQty > 0) {
192             _mint(
193                 IExchangeFactory(exchangeFactoryAddress).feeAddress(),
194                 liquidityTokenFeeQty
195             );
196         }
197 
198         _burn(msg.sender, _liquidityTokenQty);
199         IERC20(baseToken).safeTransfer(_tokenRecipient, baseTokenQtyToReturn);
200         IERC20(quoteToken).safeTransfer(_tokenRecipient, quoteTokenQtyToReturn);
201         emit RemoveLiquidity(
202             msg.sender,
203             baseTokenQtyToReturn,
204             quoteTokenQtyToReturn
205         );
206     }
207 }