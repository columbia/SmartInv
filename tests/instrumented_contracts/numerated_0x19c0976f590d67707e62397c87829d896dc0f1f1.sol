1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/jug.sol
2 pragma solidity =0.5.12;
3 
4 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/lib.sol
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 /* pragma solidity 0.5.12; */
19 
20 contract LibNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  usr,
24         bytes32  indexed  arg1,
25         bytes32  indexed  arg2,
26         bytes             data
27     ) anonymous;
28 
29     modifier note {
30         _;
31         assembly {
32             // log an 'anonymous' event with a constant 6 words of calldata
33             // and four indexed topics: selector, caller, arg1 and arg2
34             let mark := msize                         // end of memory ensures zero
35             mstore(0x40, add(mark, 288))              // update free memory pointer
36             mstore(mark, 0x20)                        // bytes type data offset
37             mstore(add(mark, 0x20), 224)              // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
39             log4(mark, 288,                           // calldata
40                  shl(224, shr(224, calldataload(0))), // msg.sig
41                  caller,                              // msg.sender
42                  calldataload(4),                     // arg1
43                  calldataload(36)                     // arg2
44                 )
45         }
46     }
47 }
48 
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/jug.sol
50 /* pragma solidity 0.5.12; */
51 
52 /* import "./lib.sol"; */
53 
54 contract VatLike {
55     function ilks(bytes32) external returns (
56         uint256 Art,   // wad
57         uint256 rate   // ray
58     );
59     function fold(bytes32,address,int) external;
60 }
61 
62 contract Jug is LibNote {
63     // --- Auth ---
64     mapping (address => uint) public wards;
65     function rely(address usr) external note auth { wards[usr] = 1; }
66     function deny(address usr) external note auth { wards[usr] = 0; }
67     modifier auth {
68         require(wards[msg.sender] == 1, "Jug/not-authorized");
69         _;
70     }
71 
72     // --- Data ---
73     struct Ilk {
74         uint256 duty;
75         uint256  rho;
76     }
77 
78     mapping (bytes32 => Ilk) public ilks;
79     VatLike                  public vat;
80     address                  public vow;
81     uint256                  public base;
82 
83     // --- Init ---
84     constructor(address vat_) public {
85         wards[msg.sender] = 1;
86         vat = VatLike(vat_);
87     }
88 
89     // --- Math ---
90     function rpow(uint x, uint n, uint b) internal pure returns (uint z) {
91       assembly {
92         switch x case 0 {switch n case 0 {z := b} default {z := 0}}
93         default {
94           switch mod(n, 2) case 0 { z := b } default { z := x }
95           let half := div(b, 2)  // for rounding.
96           for { n := div(n, 2) } n { n := div(n,2) } {
97             let xx := mul(x, x)
98             if iszero(eq(div(xx, x), x)) { revert(0,0) }
99             let xxRound := add(xx, half)
100             if lt(xxRound, xx) { revert(0,0) }
101             x := div(xxRound, b)
102             if mod(n,2) {
103               let zx := mul(z, x)
104               if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
105               let zxRound := add(zx, half)
106               if lt(zxRound, zx) { revert(0,0) }
107               z := div(zxRound, b)
108             }
109           }
110         }
111       }
112     }
113     uint256 constant ONE = 10 ** 27;
114     function add(uint x, uint y) internal pure returns (uint z) {
115         z = x + y;
116         require(z >= x);
117     }
118     function diff(uint x, uint y) internal pure returns (int z) {
119         z = int(x) - int(y);
120         require(int(x) >= 0 && int(y) >= 0);
121     }
122     function rmul(uint x, uint y) internal pure returns (uint z) {
123         z = x * y;
124         require(y == 0 || z / y == x);
125         z = z / ONE;
126     }
127 
128     // --- Administration ---
129     function init(bytes32 ilk) external note auth {
130         Ilk storage i = ilks[ilk];
131         require(i.duty == 0, "Jug/ilk-already-init");
132         i.duty = ONE;
133         i.rho  = now;
134     }
135     function file(bytes32 ilk, bytes32 what, uint data) external note auth {
136         require(now == ilks[ilk].rho, "Jug/rho-not-updated");
137         if (what == "duty") ilks[ilk].duty = data;
138         else revert("Jug/file-unrecognized-param");
139     }
140     function file(bytes32 what, uint data) external note auth {
141         if (what == "base") base = data;
142         else revert("Jug/file-unrecognized-param");
143     }
144     function file(bytes32 what, address data) external note auth {
145         if (what == "vow") vow = data;
146         else revert("Jug/file-unrecognized-param");
147     }
148 
149     // --- Stability Fee Collection ---
150     function drip(bytes32 ilk) external note returns (uint rate) {
151         require(now >= ilks[ilk].rho, "Jug/invalid-now");
152         (, uint prev) = vat.ilks(ilk);
153         rate = rmul(rpow(add(base, ilks[ilk].duty), now - ilks[ilk].rho, ONE), prev);
154         vat.fold(ilk, vow, diff(rate, prev));
155         ilks[ilk].rho = now;
156     }
157 }