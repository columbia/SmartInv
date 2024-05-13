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
18 import "@openzeppelin/contracts/utils/Address.sol";
19 import "./interfaces/IAssimilator.sol";
20 import "./lib/ABDKMath64x64.sol";
21 
22 library Assimilators {
23     using ABDKMath64x64 for int128;
24     using Address for address;
25 
26     IAssimilator public constant iAsmltr = IAssimilator(address(0));
27 
28     function delegate(address _callee, bytes memory _data) internal returns (bytes memory) {
29         require(_callee.isContract(), "Assimilators/callee-is-not-a-contract");
30 
31         // solhint-disable-next-line
32         (bool _success, bytes memory returnData_) = _callee.delegatecall(_data);
33 
34         // solhint-disable-next-line
35         assembly {
36             if eq(_success, 0) {
37                 revert(add(returnData_, 0x20), returndatasize())
38             }
39         }
40 
41         return returnData_;
42     }
43 
44     function getRate(address _assim) internal view returns (uint256 amount_) {
45         amount_ = IAssimilator(_assim).getRate();
46     }
47 
48     function viewRawAmount(address _assim, int128 _amt) internal view returns (uint256 amount_) {
49         amount_ = IAssimilator(_assim).viewRawAmount(_amt);
50     }
51 
52     function viewRawAmountLPRatio(
53         address _assim,
54         uint256 _baseWeight,
55         uint256 _quoteWeight,
56         int128 _amount
57     ) internal view returns (uint256 amount_) {
58         amount_ = IAssimilator(_assim).viewRawAmountLPRatio(_baseWeight, _quoteWeight, address(this), _amount);
59     }
60 
61     function viewNumeraireAmount(address _assim, uint256 _amt) internal view returns (int128 amt_) {
62         amt_ = IAssimilator(_assim).viewNumeraireAmount(_amt);
63     }
64 
65     function viewNumeraireAmountAndBalance(address _assim, uint256 _amt)
66         internal
67         view
68         returns (int128 amt_, int128 bal_)
69     {
70         (amt_, bal_) = IAssimilator(_assim).viewNumeraireAmountAndBalance(address(this), _amt);
71     }
72 
73     function viewNumeraireBalance(address _assim) internal view returns (int128 bal_) {
74         bal_ = IAssimilator(_assim).viewNumeraireBalance(address(this));
75     }
76 
77     function viewNumeraireBalanceLPRatio(
78         uint256 _baseWeight,
79         uint256 _quoteWeight,
80         address _assim
81     ) internal view returns (int128 bal_) {
82         bal_ = IAssimilator(_assim).viewNumeraireBalanceLPRatio(_baseWeight, _quoteWeight, address(this));
83     }
84 
85     function intakeRaw(address _assim, uint256 _amt) internal returns (int128 amt_) {
86         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRaw.selector, _amt);
87 
88         amt_ = abi.decode(delegate(_assim, data), (int128));
89     }
90 
91     function intakeRawAndGetBalance(address _assim, uint256 _amt) internal returns (int128 amt_, int128 bal_) {
92         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeRawAndGetBalance.selector, _amt);
93 
94         (amt_, bal_) = abi.decode(delegate(_assim, data), (int128, int128));
95     }
96 
97     function intakeNumeraire(address _assim, int128 _amt) internal returns (uint256 amt_) {
98         bytes memory data = abi.encodeWithSelector(iAsmltr.intakeNumeraire.selector, _amt);
99 
100         amt_ = abi.decode(delegate(_assim, data), (uint256));
101     }
102 
103     function intakeNumeraireLPRatio(
104         address _assim,
105         uint256 _baseWeight,
106         uint256 _quoteWeight,
107         int128 _amount
108     ) internal returns (uint256 amt_) {
109         bytes memory data =
110             abi.encodeWithSelector(
111                 iAsmltr.intakeNumeraireLPRatio.selector,
112                 _baseWeight,
113                 _quoteWeight,
114                 address(this),
115                 _amount
116             );
117 
118         amt_ = abi.decode(delegate(_assim, data), (uint256));
119     }
120 
121     function outputRaw(
122         address _assim,
123         address _dst,
124         uint256 _amt
125     ) internal returns (int128 amt_) {
126         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRaw.selector, _dst, _amt);
127 
128         amt_ = abi.decode(delegate(_assim, data), (int128));
129 
130         amt_ = amt_.neg();
131     }
132 
133     function outputRawAndGetBalance(
134         address _assim,
135         address _dst,
136         uint256 _amt
137     ) internal returns (int128 amt_, int128 bal_) {
138         bytes memory data = abi.encodeWithSelector(iAsmltr.outputRawAndGetBalance.selector, _dst, _amt);
139 
140         (amt_, bal_) = abi.decode(delegate(_assim, data), (int128, int128));
141 
142         amt_ = amt_.neg();
143     }
144 
145     function outputNumeraire(
146         address _assim,
147         address _dst,
148         int128 _amt
149     ) internal returns (uint256 amt_) {
150         bytes memory data = abi.encodeWithSelector(iAsmltr.outputNumeraire.selector, _dst, _amt.abs());
151 
152         amt_ = abi.decode(delegate(_assim, data), (uint256));
153     }
154 }
