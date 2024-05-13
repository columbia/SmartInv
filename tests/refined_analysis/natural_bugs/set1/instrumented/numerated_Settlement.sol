1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {SafeMath} from "../lib/SafeMath.sol";
12 import {SafeERC20} from "../lib/SafeERC20.sol";
13 import {DecimalMath} from "../lib/DecimalMath.sol";
14 import {Types} from "../lib/Types.sol";
15 import {IDODOLpToken} from "../intf/IDODOLpToken.sol";
16 import {IERC20} from "../intf/IERC20.sol";
17 import {Storage} from "./Storage.sol";
18 
19 
20 /**
21  * @title Settlement
22  * @author DODO Breeder
23  *
24  * @notice Functions for assets settlement
25  */
26 contract Settlement is Storage {
27     using SafeMath for uint256;
28     using SafeERC20 for IERC20;
29 
30     // ============ Events ============
31 
32     event Donate(uint256 amount, bool isBaseToken);
33 
34     event ClaimAssets(address indexed user, uint256 baseTokenAmount, uint256 quoteTokenAmount);
35 
36     // ============ Assets IN/OUT Functions ============
37 
38     function _baseTokenTransferIn(address from, uint256 amount) internal {
39         require(_BASE_BALANCE_.add(amount) <= _BASE_BALANCE_LIMIT_, "BASE_BALANCE_LIMIT_EXCEEDED");
40         IERC20(_BASE_TOKEN_).safeTransferFrom(from, address(this), amount);
41         _BASE_BALANCE_ = _BASE_BALANCE_.add(amount);
42     }
43 
44     function _quoteTokenTransferIn(address from, uint256 amount) internal {
45         require(
46             _QUOTE_BALANCE_.add(amount) <= _QUOTE_BALANCE_LIMIT_,
47             "QUOTE_BALANCE_LIMIT_EXCEEDED"
48         );
49         IERC20(_QUOTE_TOKEN_).safeTransferFrom(from, address(this), amount);
50         _QUOTE_BALANCE_ = _QUOTE_BALANCE_.add(amount);
51     }
52 
53     function _baseTokenTransferOut(address to, uint256 amount) internal {
54         IERC20(_BASE_TOKEN_).safeTransfer(to, amount);
55         _BASE_BALANCE_ = _BASE_BALANCE_.sub(amount);
56     }
57 
58     function _quoteTokenTransferOut(address to, uint256 amount) internal {
59         IERC20(_QUOTE_TOKEN_).safeTransfer(to, amount);
60         _QUOTE_BALANCE_ = _QUOTE_BALANCE_.sub(amount);
61     }
62 
63     // ============ Donate to Liquidity Pool Functions ============
64 
65     function _donateBaseToken(uint256 amount) internal {
66         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.add(amount);
67         emit Donate(amount, true);
68     }
69 
70     function _donateQuoteToken(uint256 amount) internal {
71         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.add(amount);
72         emit Donate(amount, false);
73     }
74 
75     function donateBaseToken(uint256 amount) external preventReentrant {
76         _baseTokenTransferIn(msg.sender, amount);
77         _donateBaseToken(amount);
78     }
79 
80     function donateQuoteToken(uint256 amount) external preventReentrant {
81         _quoteTokenTransferIn(msg.sender, amount);
82         _donateQuoteToken(amount);
83     }
84 
85     // ============ Final Settlement Functions ============
86 
87     // last step to shut down dodo
88     function finalSettlement() external onlyOwner notClosed {
89         _CLOSED_ = true;
90         _DEPOSIT_QUOTE_ALLOWED_ = false;
91         _DEPOSIT_BASE_ALLOWED_ = false;
92         _TRADE_ALLOWED_ = false;
93         uint256 totalBaseCapital = getTotalBaseCapital();
94         uint256 totalQuoteCapital = getTotalQuoteCapital();
95 
96         if (_QUOTE_BALANCE_ > _TARGET_QUOTE_TOKEN_AMOUNT_) {
97             uint256 spareQuote = _QUOTE_BALANCE_.sub(_TARGET_QUOTE_TOKEN_AMOUNT_);
98             _BASE_CAPITAL_RECEIVE_QUOTE_ = DecimalMath.divFloor(spareQuote, totalBaseCapital);
99         } else {
100             _TARGET_QUOTE_TOKEN_AMOUNT_ = _QUOTE_BALANCE_;
101         }
102 
103         if (_BASE_BALANCE_ > _TARGET_BASE_TOKEN_AMOUNT_) {
104             uint256 spareBase = _BASE_BALANCE_.sub(_TARGET_BASE_TOKEN_AMOUNT_);
105             _QUOTE_CAPITAL_RECEIVE_BASE_ = DecimalMath.divFloor(spareBase, totalQuoteCapital);
106         } else {
107             _TARGET_BASE_TOKEN_AMOUNT_ = _BASE_BALANCE_;
108         }
109 
110         _R_STATUS_ = Types.RStatus.ONE;
111     }
112 
113     // claim remaining assets after final settlement
114     function claimAssets() external preventReentrant {
115         require(_CLOSED_, "DODO_NOT_CLOSED");
116         require(!_CLAIMED_[msg.sender], "ALREADY_CLAIMED");
117         _CLAIMED_[msg.sender] = true;
118 
119         uint256 quoteCapital = getQuoteCapitalBalanceOf(msg.sender);
120         uint256 baseCapital = getBaseCapitalBalanceOf(msg.sender);
121 
122         uint256 quoteAmount = 0;
123         if (quoteCapital > 0) {
124             quoteAmount = _TARGET_QUOTE_TOKEN_AMOUNT_.mul(quoteCapital).div(getTotalQuoteCapital());
125         }
126         uint256 baseAmount = 0;
127         if (baseCapital > 0) {
128             baseAmount = _TARGET_BASE_TOKEN_AMOUNT_.mul(baseCapital).div(getTotalBaseCapital());
129         }
130 
131         _TARGET_QUOTE_TOKEN_AMOUNT_ = _TARGET_QUOTE_TOKEN_AMOUNT_.sub(quoteAmount);
132         _TARGET_BASE_TOKEN_AMOUNT_ = _TARGET_BASE_TOKEN_AMOUNT_.sub(baseAmount);
133 
134         quoteAmount = quoteAmount.add(DecimalMath.mul(baseCapital, _BASE_CAPITAL_RECEIVE_QUOTE_));
135         baseAmount = baseAmount.add(DecimalMath.mul(quoteCapital, _QUOTE_CAPITAL_RECEIVE_BASE_));
136 
137         _baseTokenTransferOut(msg.sender, baseAmount);
138         _quoteTokenTransferOut(msg.sender, quoteAmount);
139 
140         IDODOLpToken(_BASE_CAPITAL_TOKEN_).burn(msg.sender, baseCapital);
141         IDODOLpToken(_QUOTE_CAPITAL_TOKEN_).burn(msg.sender, quoteCapital);
142 
143         emit ClaimAssets(msg.sender, baseAmount, quoteAmount);
144         return;
145     }
146 
147     // in case someone transfer to contract directly
148     function retrieve(address token, uint256 amount) external onlyOwner {
149         if (token == _BASE_TOKEN_) {
150             require(
151                 IERC20(_BASE_TOKEN_).balanceOf(address(this)) >= _BASE_BALANCE_.add(amount),
152                 "DODO_BASE_BALANCE_NOT_ENOUGH"
153             );
154         }
155         if (token == _QUOTE_TOKEN_) {
156             require(
157                 IERC20(_QUOTE_TOKEN_).balanceOf(address(this)) >= _QUOTE_BALANCE_.add(amount),
158                 "DODO_QUOTE_BALANCE_NOT_ENOUGH"
159             );
160         }
161         IERC20(token).safeTransfer(msg.sender, amount);
162     }
163 }
