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
18 import "./CurveFactory.sol";
19 import "./Curve.sol";
20 
21 import "@openzeppelin/contracts/math/SafeMath.sol";
22 
23 import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
24 import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
25 
26 // Simplistic router that assumes USD is the only quote currency for
27 contract Router {
28     using SafeMath for uint256;
29     using SafeERC20 for IERC20;
30 
31     address public factory;
32 
33     constructor(address _factory) {
34         require(_factory != address(0), "Curve/factory-cannot-be-zeroth-address");
35 
36         factory = _factory;
37     }
38 
39     /// @notice view how much target amount a fixed origin amount will swap for
40     /// @param _quoteCurrency the address of the quote currency (usually USDC)
41     /// @param _origin the address of the origin
42     /// @param _target the address of the target
43     /// @param _originAmount the origin amount
44     /// @return targetAmount_ the amount of target that will be returned
45     function viewOriginSwap(
46         address _quoteCurrency,
47         address _origin,
48         address _target,
49         uint256 _originAmount
50     ) external view returns (uint256 targetAmount_) {
51         // If its an immediate pair then just swap directly on it
52         address curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _target)));
53         if (_origin == _quoteCurrency) {
54             curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _origin)));
55         }
56         if (curve0 != address(0)) {
57             targetAmount_ = Curve(curve0).viewOriginSwap(_origin, _target, _originAmount);
58             return targetAmount_;
59         }
60 
61         // Otherwise go through the quote currency
62         curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _quoteCurrency)));
63         address curve1 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _quoteCurrency)));
64         if (curve0 != address(0) && curve1 != address(0)) {
65             uint256 _quoteAmount = Curve(curve0).viewOriginSwap(_origin, _quoteCurrency, _originAmount);
66             targetAmount_ = Curve(curve1).viewOriginSwap(_quoteCurrency, _target, _quoteAmount);
67             return targetAmount_;
68         }
69 
70         revert("Router/No-path");
71     }
72 
73     /// @notice swap a dynamic origin amount for a fixed target amount
74     /// @param _quoteCurrency the address of the quote currency (usually USDC)
75     /// @param _origin the address of the origin
76     /// @param _target the address of the target
77     /// @param _originAmount the origin amount
78     /// @param _minTargetAmount the minimum target amount
79     /// @param _deadline deadline in block number after which the trade will not execute
80     /// @return targetAmount_ the amount of target that has been swapped for the origin amount
81     function originSwap(
82         address _quoteCurrency,
83         address _origin,
84         address _target,
85         uint256 _originAmount,
86         uint256 _minTargetAmount,
87         uint256 _deadline
88     ) public returns (uint256 targetAmount_) {
89         IERC20(_origin).safeTransferFrom(msg.sender, address(this), _originAmount);
90 
91         // If its an immediate pair then just swap directly on it
92         address curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _target)));
93         if (_origin == _quoteCurrency) {
94             curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _origin)));
95         }
96         if (curve0 != address(0)) {
97             IERC20(_origin).safeApprove(curve0, _originAmount);
98             targetAmount_ = Curve(curve0).originSwap(_origin, _target, _originAmount, _minTargetAmount, _deadline);
99             IERC20(_target).safeTransfer(msg.sender, targetAmount_);
100             return targetAmount_;
101         }
102 
103         // Otherwise go through the quote currency
104         curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _quoteCurrency)));
105         address curve1 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _quoteCurrency)));
106         if (curve0 != address(0) && curve1 != address(0)) {
107             IERC20(_origin).safeApprove(curve0, _originAmount);
108             uint256 _quoteAmount = Curve(curve0).originSwap(_origin, _quoteCurrency, _originAmount, 0, _deadline);
109 
110             IERC20(_quoteCurrency).safeApprove(curve1, _quoteAmount);
111             targetAmount_ = Curve(curve1).originSwap(
112                 _quoteCurrency,
113                 _target,
114                 _quoteAmount,
115                 _minTargetAmount,
116                 _deadline
117             );
118             IERC20(_target).safeTransfer(msg.sender, targetAmount_);
119             return targetAmount_;
120         }
121 
122         revert("Router/No-path");
123     }
124 
125     /// @notice view how much of the origin currency the target currency will take
126     /// @param _quoteCurrency the address of the quote currency (usually USDC)
127     /// @param _origin the address of the origin
128     /// @param _target the address of the target
129     /// @param _targetAmount the target amount
130     /// @return originAmount_ the amount of target that has been swapped for the origin
131     function viewTargetSwap(
132         address _quoteCurrency,
133         address _origin,
134         address _target,
135         uint256 _targetAmount
136     ) public view returns (uint256 originAmount_) {
137         // If its an immediate pair then just swap directly on it
138         address curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _target)));
139         if (_origin == _quoteCurrency) {
140             curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _origin)));
141         }
142 
143         if (curve0 != address(0)) {
144             originAmount_ = Curve(curve0).viewTargetSwap(_origin, _target, _targetAmount);
145             return originAmount_;
146         }
147 
148         // Otherwise go through the quote currency
149         curve0 = CurveFactory(factory).curves(keccak256(abi.encode(_target, _quoteCurrency)));
150         address curve1 = CurveFactory(factory).curves(keccak256(abi.encode(_origin, _quoteCurrency)));
151         if (curve0 != address(0) && curve1 != address(0)) {
152             uint256 _quoteAmount = Curve(curve0).viewTargetSwap(_quoteCurrency, _target, _targetAmount);
153             originAmount_ = Curve(curve1).viewTargetSwap(_origin, _quoteCurrency, _quoteAmount);
154             return originAmount_;
155         }
156 
157         revert("Router/No-path");
158     }
159 }
