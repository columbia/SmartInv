1 // SPDX-License-Identifier: MIT
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 pragma solidity ^0.7.3;
17 
18 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
19 import "@openzeppelin/contracts/math/SafeMath.sol";
20 
21 import "../lib/ABDKMath64x64.sol";
22 import "../interfaces/IAssimilator.sol";
23 import "../interfaces/IOracle.sol";
24 
25 contract XsgdToUsdAssimilator is IAssimilator {
26     using ABDKMath64x64 for int128;
27     using ABDKMath64x64 for uint256;
28 
29     using SafeMath for uint256;
30 
31     IERC20 private constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
32 
33     IOracle private constant oracle = IOracle(0xe25277fF4bbF9081C75Ab0EB13B4A13a721f3E13);
34     IERC20 private constant xsgd = IERC20(0x70e8dE73cE538DA2bEEd35d14187F6959a8ecA96);
35 
36     // solhint-disable-next-line
37     constructor() {}
38 
39     function getRate() public view override returns (uint256) {
40         (, int256 price, , , ) = oracle.latestRoundData();
41         return uint256(price);
42     }
43 
44     // takes raw xsgd amount, transfers it in, calculates corresponding numeraire amount and returns it
45     function intakeRawAndGetBalance(uint256 _amount) external override returns (int128 amount_, int128 balance_) {
46         bool _transferSuccess = xsgd.transferFrom(msg.sender, address(this), _amount);
47 
48         require(_transferSuccess, "Curve/XSGD-transfer-from-failed");
49 
50         uint256 _balance = xsgd.balanceOf(address(this));
51 
52         uint256 _rate = getRate();
53 
54         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
55 
56         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
57     }
58 
59     // takes raw xsgd amount, transfers it in, calculates corresponding numeraire amount and returns it
60     function intakeRaw(uint256 _amount) external override returns (int128 amount_) {
61         bool _transferSuccess = xsgd.transferFrom(msg.sender, address(this), _amount);
62 
63         require(_transferSuccess, "Curve/XSGD-transfer-from-failed");
64 
65         uint256 _rate = getRate();
66 
67         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
68     }
69 
70     // takes a numeraire amount, calculates the raw amount of xsgd, transfers it in and returns the corresponding raw amount
71     function intakeNumeraire(int128 _amount) external override returns (uint256 amount_) {
72         uint256 _rate = getRate();
73 
74         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
75 
76         bool _transferSuccess = xsgd.transferFrom(msg.sender, address(this), amount_);
77 
78         require(_transferSuccess, "Curve/XSGD-transfer-from-failed");
79     }
80 
81     // takes a numeraire amount, calculates the raw amount of xsgd, transfers it in and returns the corresponding raw amount
82     function intakeNumeraireLPRatio(
83         uint256 _baseWeight,
84         uint256 _quoteWeight,
85         address _addr,
86         int128 _amount
87     ) external override returns (uint256 amount_) {
88         uint256 _xsgdBal = xsgd.balanceOf(_addr);
89 
90         if (_xsgdBal <= 0) return 0;
91 
92         // 1e6
93         _xsgdBal = _xsgdBal.mul(1e18).div(_baseWeight);
94 
95         // 1e6
96         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
97 
98         // Rate is in 1e6
99         uint256 _rate = _usdcBal.mul(1e6).div(_xsgdBal);
100 
101         amount_ = (_amount.mulu(1e6) * 1e6) / _rate;
102 
103         bool _transferSuccess = xsgd.transferFrom(msg.sender, address(this), amount_);
104 
105         require(_transferSuccess, "Curve/XSGD-transfer-failed");
106     }
107 
108     // takes a raw amount of xsgd and transfers it out, returns numeraire value of the raw amount
109     function outputRawAndGetBalance(address _dst, uint256 _amount)
110         external
111         override
112         returns (int128 amount_, int128 balance_)
113     {
114         uint256 _rate = getRate();
115 
116         uint256 _xsgdAmount = ((_amount) * _rate) / 1e8;
117 
118         bool _transferSuccess = xsgd.transfer(_dst, _xsgdAmount);
119 
120         require(_transferSuccess, "Curve/XSGD-transfer-failed");
121 
122         uint256 _balance = xsgd.balanceOf(address(this));
123 
124         amount_ = _xsgdAmount.divu(1e6);
125 
126         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
127     }
128 
129     // takes a raw amount of xsgd and transfers it out, returns numeraire value of the raw amount
130     function outputRaw(address _dst, uint256 _amount) external override returns (int128 amount_) {
131         uint256 _rate = getRate();
132 
133         uint256 _xsgdAmount = (_amount * _rate) / 1e8;
134 
135         bool _transferSuccess = xsgd.transfer(_dst, _xsgdAmount);
136 
137         require(_transferSuccess, "Curve/XSGD-transfer-failed");
138 
139         amount_ = _xsgdAmount.divu(1e6);
140     }
141 
142     // takes a numeraire value of xsgd, figures out the raw amount, transfers raw amount out, and returns raw amount
143     function outputNumeraire(address _dst, int128 _amount) external override returns (uint256 amount_) {
144         uint256 _rate = getRate();
145 
146         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
147 
148         bool _transferSuccess = xsgd.transfer(_dst, amount_);
149 
150         require(_transferSuccess, "Curve/XSGD-transfer-failed");
151     }
152 
153     // takes a numeraire amount and returns the raw amount
154     function viewRawAmount(int128 _amount) external view override returns (uint256 amount_) {
155         uint256 _rate = getRate();
156 
157         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
158     }
159 
160     function viewRawAmountLPRatio(
161         uint256 _baseWeight,
162         uint256 _quoteWeight,
163         address _addr,
164         int128 _amount
165     ) external view override returns (uint256 amount_) {
166         uint256 _xsgdBal = xsgd.balanceOf(_addr);
167 
168         if (_xsgdBal <= 0) return 0;
169 
170         // 1e6
171         _xsgdBal = _xsgdBal.mul(1e18).div(_baseWeight);
172 
173         // 1e6
174         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
175 
176         // Rate is in 1e6
177         uint256 _rate = _usdcBal.mul(1e6).div(_xsgdBal);
178 
179         amount_ = (_amount.mulu(1e6) * 1e6) / _rate;
180     }
181 
182     // takes a raw amount and returns the numeraire amount
183     function viewNumeraireAmount(uint256 _amount) external view override returns (int128 amount_) {
184         uint256 _rate = getRate();
185 
186         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
187     }
188 
189     // views the numeraire value of the current balance of the reserve, in this case xsgd
190     function viewNumeraireBalance(address _addr) external view override returns (int128 balance_) {
191         uint256 _rate = getRate();
192 
193         uint256 _balance = xsgd.balanceOf(_addr);
194 
195         if (_balance <= 0) return ABDKMath64x64.fromUInt(0);
196 
197         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
198     }
199 
200     // views the numeraire value of the current balance of the reserve, in this case xsgd
201     function viewNumeraireAmountAndBalance(address _addr, uint256 _amount)
202         external
203         view
204         override
205         returns (int128 amount_, int128 balance_)
206     {
207         uint256 _rate = getRate();
208 
209         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
210 
211         uint256 _balance = xsgd.balanceOf(_addr);
212 
213         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
214     }
215 
216     // views the numeraire value of the current balance of the reserve, in this case xsgd
217     // instead of calculating with chainlink's "rate" it'll be determined by the existing
218     // token ratio
219     // Mainly to protect LP from losing
220     function viewNumeraireBalanceLPRatio(
221         uint256 _baseWeight,
222         uint256 _quoteWeight,
223         address _addr
224     ) external view override returns (int128 balance_) {
225         uint256 _xsgdBal = xsgd.balanceOf(_addr);
226 
227         if (_xsgdBal <= 0) return ABDKMath64x64.fromUInt(0);
228 
229         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
230 
231         // Rate is in 1e6
232         uint256 _rate = _usdcBal.mul(1e18).div(_xsgdBal.mul(1e18).div(_baseWeight));
233 
234         balance_ = ((_xsgdBal * _rate) / 1e6).divu(1e18);
235     }
236 }
