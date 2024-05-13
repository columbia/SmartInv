1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 // From MakerDAO DSS
4 
5 // Copyright (C) 2018 Rain <rainbreak@riseup.net>
6 //
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU Affero General Public License as published by
9 // the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 //
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU Affero General Public License for more details.
16 //
17 // You should have received a copy of the GNU Affero General Public License
18 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
19 
20 pragma solidity ^0.8.0;
21 
22 library RPow {
23     function rpow(uint x, uint n, uint base) internal pure returns (uint z) {
24         assembly {
25             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
26             default {
27                 switch mod(n, 2) case 0 { z := base } default { z := x }
28                 let half := div(base, 2)  // for rounding.
29                 for { n := div(n, 2) } n { n := div(n,2) } {
30                     let xx := mul(x, x)
31                     if iszero(eq(div(xx, x), x)) { revert(0,0) }
32                     let xxRound := add(xx, half)
33                     if lt(xxRound, xx) { revert(0,0) }
34                     x := div(xxRound, base)
35                     if mod(n,2) {
36                         let zx := mul(z, x)
37                         if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
38                         let zxRound := add(zx, half)
39                         if lt(zxRound, zx) { revert(0,0) }
40                         z := div(zxRound, base)
41                     }
42                 }
43             }
44         }
45     }
46 }
