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
19 
20 import "../lib/ABDKMath64x64.sol";
21 import "../interfaces/IAssimilator.sol";
22 import "../interfaces/IOracle.sol";
23 
24 contract UsdcToUsdAssimilator is IAssimilator {
25     using ABDKMath64x64 for int128;
26     using ABDKMath64x64 for uint256;
27 
28     IOracle private constant oracle = IOracle(0x8fFfFfd4AfB6115b954Bd326cbe7B4BA576818f6);
29     IERC20 private constant usdc = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
30 
31     // solhint-disable-next-line
32     constructor() {}
33 
34     // solhint-disable-next-line
35     function getRate() public view override returns (uint256) {
36         return uint256(oracle.latestAnswer());
37     }
38 
39     function intakeRawAndGetBalance(uint256 _amount) external override returns (int128 amount_, int128 balance_) {
40         bool _success = usdc.transferFrom(msg.sender, address(this), _amount);
41 
42         require(_success, "Curve/USDC-transfer-from-failed");
43 
44         uint256 _balance = usdc.balanceOf(address(this));
45 
46         uint256 _rate = getRate();
47 
48         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
49 
50         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
51     }
52 
53     function intakeRaw(uint256 _amount) external override returns (int128 amount_) {
54         bool _success = usdc.transferFrom(msg.sender, address(this), _amount);
55 
56         require(_success, "Curve/USDC-transfer-from-failed");
57 
58         uint256 _rate = getRate();
59 
60         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
61     }
62 
63     function intakeNumeraire(int128 _amount) external override returns (uint256 amount_) {
64         uint256 _rate = getRate();
65 
66         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
67 
68         bool _success = usdc.transferFrom(msg.sender, address(this), amount_);
69 
70         require(_success, "Curve/USDC-transfer-from-failed");
71     }
72 
73     function intakeNumeraireLPRatio(
74         uint256,
75         uint256,
76         address,
77         int128 _amount
78     ) external override returns (uint256 amount_) {
79         amount_ = _amount.mulu(1e6);
80 
81         bool _success = usdc.transferFrom(msg.sender, address(this), amount_);
82 
83         require(_success, "Curve/USDC-transfer-from-failed");
84     }
85 
86     function outputRawAndGetBalance(address _dst, uint256 _amount)
87         external
88         override
89         returns (int128 amount_, int128 balance_)
90     {
91         uint256 _rate = getRate();
92 
93         uint256 _usdcAmount = ((_amount * _rate) / 1e8);
94 
95         bool _success = usdc.transfer(_dst, _usdcAmount);
96 
97         require(_success, "Curve/USDC-transfer-failed");
98 
99         uint256 _balance = usdc.balanceOf(address(this));
100 
101         amount_ = _usdcAmount.divu(1e6);
102 
103         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
104     }
105 
106     function outputRaw(address _dst, uint256 _amount) external override returns (int128 amount_) {
107         uint256 _rate = getRate();
108 
109         uint256 _usdcAmount = (_amount * _rate) / 1e8;
110 
111         bool _success = usdc.transfer(_dst, _usdcAmount);
112 
113         require(_success, "Curve/USDC-transfer-failed");
114 
115         amount_ = _usdcAmount.divu(1e6);
116     }
117 
118     function outputNumeraire(address _dst, int128 _amount) external override returns (uint256 amount_) {
119         uint256 _rate = getRate();
120 
121         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
122 
123         bool _success = usdc.transfer(_dst, amount_);
124 
125         require(_success, "Curve/USDC-transfer-failed");
126     }
127 
128     function viewRawAmount(int128 _amount) external view override returns (uint256 amount_) {
129         uint256 _rate = getRate();
130 
131         amount_ = (_amount.mulu(1e6) * 1e8) / _rate;
132     }
133 
134     function viewRawAmountLPRatio(
135         uint256,
136         uint256,
137         address,
138         int128 _amount
139     ) external pure override returns (uint256 amount_) {
140         amount_ = _amount.mulu(1e6);
141     }
142 
143     function viewNumeraireAmount(uint256 _amount) external view override returns (int128 amount_) {
144         uint256 _rate = getRate();
145 
146         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
147     }
148 
149     function viewNumeraireBalance(address _addr) public view override returns (int128 balance_) {
150         uint256 _rate = getRate();
151 
152         uint256 _balance = usdc.balanceOf(_addr);
153 
154         if (_balance <= 0) return ABDKMath64x64.fromUInt(0);
155 
156         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
157     }
158 
159     // views the numeraire value of the current balance of the reserve wrt to USD
160     // since this is already the USD assimlator, the ratio is just 1
161     function viewNumeraireBalanceLPRatio(
162         uint256,
163         uint256,
164         address _addr
165     ) external view override returns (int128 balance_) {
166         uint256 _balance = usdc.balanceOf(_addr);
167 
168         return _balance.divu(1e6);
169     }
170 
171     function viewNumeraireAmountAndBalance(address _addr, uint256 _amount)
172         external
173         view
174         override
175         returns (int128 amount_, int128 balance_)
176     {
177         uint256 _rate = getRate();
178 
179         amount_ = ((_amount * _rate) / 1e8).divu(1e6);
180 
181         uint256 _balance = usdc.balanceOf(_addr);
182 
183         balance_ = ((_balance * _rate) / 1e8).divu(1e6);
184     }
185 }
