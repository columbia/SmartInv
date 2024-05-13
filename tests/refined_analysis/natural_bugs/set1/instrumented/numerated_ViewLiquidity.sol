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
18 import "./Storage.sol";
19 
20 import "./Assimilators.sol";
21 
22 import "./lib/ABDKMath64x64.sol";
23 
24 library ViewLiquidity {
25     using ABDKMath64x64 for int128;
26 
27     function viewLiquidity(Storage.Curve storage curve)
28         external
29         view
30         returns (uint256 total_, uint256[] memory individual_)
31     {
32         uint256 _length = curve.assets.length;
33 
34         individual_ = new uint256[](_length);
35 
36         for (uint256 i = 0; i < _length; i++) {
37             uint256 _liquidity = Assimilators.viewNumeraireBalance(curve.assets[i].addr).mulu(1e18);
38 
39             total_ += _liquidity;
40             individual_[i] = _liquidity;
41         }
42 
43         return (total_, individual_);
44     }
45 }
