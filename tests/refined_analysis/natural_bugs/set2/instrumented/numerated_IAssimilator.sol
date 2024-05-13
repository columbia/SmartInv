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
18 interface IAssimilator {
19     function getRate() external view returns (uint256);
20 
21     function intakeRaw(uint256 amount) external returns (int128);
22 
23     function intakeRawAndGetBalance(uint256 amount) external returns (int128, int128);
24 
25     function intakeNumeraire(int128 amount) external returns (uint256);
26 
27     function intakeNumeraireLPRatio(
28         uint256,
29         uint256,
30         address,
31         int128
32     ) external returns (uint256);
33 
34     function outputRaw(address dst, uint256 amount) external returns (int128);
35 
36     function outputRawAndGetBalance(address dst, uint256 amount) external returns (int128, int128);
37 
38     function outputNumeraire(address dst, int128 amount) external returns (uint256);
39 
40     function viewRawAmount(int128) external view returns (uint256);
41 
42     function viewRawAmountLPRatio(
43         uint256,
44         uint256,
45         address,
46         int128
47     ) external view returns (uint256);
48 
49     function viewNumeraireAmount(uint256) external view returns (int128);
50 
51     function viewNumeraireBalanceLPRatio(
52         uint256,
53         uint256,
54         address
55     ) external view returns (int128);
56 
57     function viewNumeraireBalance(address) external view returns (int128);
58 
59     function viewNumeraireAmountAndBalance(address, uint256) external view returns (int128, int128);
60 }
