1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 /// Drizzle.sol -- Drip all mcd collateral types
4 
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public License
16 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 
18 pragma solidity ^0.6.12;
19 
20 interface Chainlog {
21     function getAddress(bytes32) external returns (address);
22 }
23 
24 interface IlkRegistry {
25     function list() external view returns (bytes32[] memory);
26 }
27 
28 interface PotLike {
29     function drip() external;
30 }
31 
32 interface JugLike {
33     function drip(bytes32) external;
34 }
35 
36 contract Drizzle {
37 
38     Chainlog    private constant  _chl = Chainlog(0xdA0Ab1e0017DEbCd72Be8599041a2aa3bA7e740F);
39     IlkRegistry private immutable _reg;
40     PotLike     private immutable _pot;
41     JugLike     private immutable _jug;
42 
43     constructor() public {
44         _reg = IlkRegistry(_chl.getAddress("ILK_REGISTRY"));
45         _pot = PotLike(_chl.getAddress("MCD_POT"));
46         _jug = JugLike(_chl.getAddress("MCD_JUG"));
47     }
48 
49     function drizzle(bytes32[] memory ilks) public {
50         _pot.drip();
51         for (uint256 i = 0; i < ilks.length; i++) {
52             _jug.drip(ilks[i]);
53         }
54     }
55 
56     function drizzle() external {
57         bytes32[] memory ilks = _reg.list();
58         drizzle(ilks);
59     }
60 
61     function registry() external view returns (address) {
62         return address(_reg);
63     }
64 
65     function pot() external view returns (address) {
66         return address(_pot);
67     }
68 
69     function jug() external view returns (address) {
70         return address(_jug);
71     }
72 }