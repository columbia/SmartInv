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
25 contract CadcToUsdAssimilator is IAssimilator {
26     using ABDKMath64x64 for int128;
27     using ABDKMath64x64 for uint256;
28 
29     using SafeMath for uint256;
30 
31     IOracle private constant oracle = IOracle(0xa34317DB73e77d453b1B8d04550c44D10e981C8e);
32     IERC20 private constant cadc = IERC20(0xcaDC0acd4B445166f12d2C07EAc6E2544FbE2Eef);
33 
34     IERC20 private constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
35 
36     // solhint-disable-next-line
37     constructor() {}
38 
39     function getRate() public view override returns (uint256) {
40         (, int256 price, , , ) = oracle.latestRoundData();
41         return uint256(price);
42     }
43 
44     // takes raw cadc amount, transfers it in, calculates corresponding numeraire amount and returns it
45     function intakeRawAndGetBalance(uint256 _amount) external override returns (int128 amount_, int128 balance_) {
46         bool _transferSuccess = cadc.transferFrom(msg.sender, address(this), _amount);
47 
48         require(_transferSuccess, "Curve/CADC-transfer-from-failed");
49 
50         uint256 _balance = cadc.balanceOf(address(this));
51 
52         uint256 _rate = getRate();
53 
54         balance_ = ((_balance * _rate) / 1e8).divu(1e18);
55 
56         amount_ = ((_amount * _rate) / 1e8).divu(1e18);
57     }
58 
59     // takes raw cadc amount, transfers it in, calculates corresponding numeraire amount and returns it
60     function intakeRaw(uint256 _amount) external override returns (int128 amount_) {
61         bool _transferSuccess = cadc.transferFrom(msg.sender, address(this), _amount);
62 
63         require(_transferSuccess, "Curve/cadc-transfer-from-failed");
64 
65         uint256 _rate = getRate();
66 
67         amount_ = ((_amount * _rate) / 1e8).divu(1e18);
68     }
69 
70     // takes a numeraire amount, calculates the raw amount of cadc, transfers it in and returns the corresponding raw amount
71     function intakeNumeraire(int128 _amount) external override returns (uint256 amount_) {
72         uint256 _rate = getRate();
73 
74         amount_ = (_amount.mulu(1e18) * 1e8) / _rate;
75 
76         bool _transferSuccess = cadc.transferFrom(msg.sender, address(this), amount_);
77 
78         require(_transferSuccess, "Curve/CADC-transfer-from-failed");
79     }
80 
81     // takes a numeraire account, calculates the raw amount of cadc, transfers it in and returns the corresponding raw amount
82     function intakeNumeraireLPRatio(
83         uint256 _baseWeight,
84         uint256 _quoteWeight,
85         address _addr,
86         int128 _amount
87     ) external override returns (uint256 amount_) {
88         uint256 _cadcBal = cadc.balanceOf(_addr);
89 
90         if (_cadcBal <= 0) return 0;
91 
92         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
93 
94         // Rate is in 1e6
95         uint256 _rate = _usdcBal.mul(1e18).div(_cadcBal.mul(1e18).div(_baseWeight));
96 
97         amount_ = (_amount.mulu(1e18) * 1e6) / _rate;
98 
99         bool _transferSuccess = cadc.transferFrom(msg.sender, address(this), amount_);
100 
101         require(_transferSuccess, "Curve/CADC-transfer-from-failed");
102     }
103 
104     // takes a raw amount of cadc and transfers it out, returns numeraire value of the raw amount
105     function outputRawAndGetBalance(address _dst, uint256 _amount)
106         external
107         override
108         returns (int128 amount_, int128 balance_)
109     {
110         uint256 _rate = getRate();
111 
112         uint256 _cadcAmount = ((_amount) * _rate) / 1e8;
113 
114         bool _transferSuccess = cadc.transfer(_dst, _cadcAmount);
115 
116         require(_transferSuccess, "Curve/CADC-transfer-failed");
117 
118         uint256 _balance = cadc.balanceOf(address(this));
119 
120         amount_ = _cadcAmount.divu(1e18);
121 
122         balance_ = ((_balance * _rate) / 1e8).divu(1e18);
123     }
124 
125     // takes a raw amount of cadc and transfers it out, returns numeraire value of the raw amount
126     function outputRaw(address _dst, uint256 _amount) external override returns (int128 amount_) {
127         uint256 _rate = getRate();
128 
129         uint256 _cadcAmount = (_amount * _rate) / 1e8;
130 
131         bool _transferSuccess = cadc.transfer(_dst, _cadcAmount);
132 
133         require(_transferSuccess, "Curve/CADC-transfer-failed");
134 
135         amount_ = _cadcAmount.divu(1e18);
136     }
137 
138     // takes a numeraire value of cadc, figures out the raw amount, transfers raw amount out, and returns raw amount
139     function outputNumeraire(address _dst, int128 _amount) external override returns (uint256 amount_) {
140         uint256 _rate = getRate();
141 
142         amount_ = (_amount.mulu(1e18) * 1e8) / _rate;
143 
144         bool _transferSuccess = cadc.transfer(_dst, amount_);
145 
146         require(_transferSuccess, "Curve/CADC-transfer-failed");
147     }
148 
149     // takes a numeraire amount and returns the raw amount
150     function viewRawAmount(int128 _amount) external view override returns (uint256 amount_) {
151         uint256 _rate = getRate();
152 
153         amount_ = (_amount.mulu(1e18) * 1e8) / _rate;
154     }
155 
156     // takes a numeraire amount and returns the raw amount without the rate
157     function viewRawAmountLPRatio(
158         uint256 _baseWeight,
159         uint256 _quoteWeight,
160         address _addr,
161         int128 _amount
162     ) external view override returns (uint256 amount_) {
163         uint256 _cadcBal = cadc.balanceOf(_addr);
164 
165         if (_cadcBal <= 0) return 0;
166 
167         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
168 
169         // Rate is in 1e6
170         uint256 _rate = _usdcBal.mul(1e18).div(_cadcBal.mul(1e18).div(_baseWeight));
171 
172         amount_ = (_amount.mulu(1e18) * 1e6) / _rate;
173     }
174 
175     // takes a raw amount and returns the numeraire amount
176     function viewNumeraireAmount(uint256 _amount) external view override returns (int128 amount_) {
177         uint256 _rate = getRate();
178 
179         amount_ = ((_amount * _rate) / 1e8).divu(1e18);
180     }
181 
182     // views the numeraire value of the current balance of the reserve, in this case cadc
183     function viewNumeraireBalance(address _addr) external view override returns (int128 balance_) {
184         uint256 _rate = getRate();
185 
186         uint256 _balance = cadc.balanceOf(_addr);
187 
188         if (_balance <= 0) return ABDKMath64x64.fromUInt(0);
189 
190         balance_ = ((_balance * _rate) / 1e8).divu(1e18);
191     }
192 
193     // views the numeraire value of the current balance of the reserve, in this case cadc
194     function viewNumeraireAmountAndBalance(address _addr, uint256 _amount)
195         external
196         view
197         override
198         returns (int128 amount_, int128 balance_)
199     {
200         uint256 _rate = getRate();
201 
202         amount_ = ((_amount * _rate) / 1e8).divu(1e18);
203 
204         uint256 _balance = cadc.balanceOf(_addr);
205 
206         balance_ = ((_balance * _rate) / 1e8).divu(1e18);
207     }
208 
209     // views the numeraire value of the current balance of the reserve, in this case cadc
210     // instead of calculating with chainlink's "rate" it'll be determined by the existing
211     // token ratio. This is in here to prevent LPs from losing out on future oracle price updates
212     function viewNumeraireBalanceLPRatio(
213         uint256 _baseWeight,
214         uint256 _quoteWeight,
215         address _addr
216     ) external view override returns (int128 balance_) {
217         uint256 _cadcBal = cadc.balanceOf(_addr);
218 
219         if (_cadcBal <= 0) return ABDKMath64x64.fromUInt(0);
220 
221         uint256 _usdcBal = usdc.balanceOf(_addr).mul(1e18).div(_quoteWeight);
222 
223         // Rate is in 1e6
224         uint256 _rate = _usdcBal.mul(1e18).div(_cadcBal.mul(1e18).div(_baseWeight));
225 
226         balance_ = ((_cadcBal * _rate) / 1e6).divu(1e18);
227     }
228 }
