1 // SPDX-License-Identifier: AGPL-3.0
2 // The MegaPoker
3 //
4 // Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
5 //
6 // This program is free software: you can redistribute it and/or modify
7 // it under the terms of the GNU Affero General Public License as published by
8 // the Free Software Foundation, either version 3 of the License, or
9 // (at your option) any later version.
10 //
11 // This program is distributed in the hope that it will be useful,
12 // but WITHOUT ANY WARRANTY; without even the implied warranty of
13 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 // GNU Affero General Public License for more details.
15 //
16 // You should have received a copy of the GNU Affero General Public License
17 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
18 
19 pragma solidity ^0.6.12;
20 
21 contract PokingAddresses {
22     // OSMs and Spotter addresses
23     address constant eth            = 0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763;
24     address constant btc            = 0xf185d0682d50819263941e5f4EacC763CC5C6C42;
25     address constant mana           = 0x8067259EA630601f319FccE477977E55C6078C13;
26     address constant link           = 0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7;
27     address constant yfi            = 0x5F122465bCf86F45922036970Be6DD7F58820214;
28     address constant univ2usdceth   = 0xf751f24DD9cfAd885984D1bA68860F558D21E52A;
29     address constant univ2daiusdc   = 0x25D03C2C928ADE19ff9f4FFECc07d991d0df054B;
30     address constant matic          = 0x8874964279302e6d4e523Fb1789981C39a1034Ba;
31     address constant wsteth         = 0xFe7a2aC0B945f12089aEEB6eCebf4F384D9f043F;
32     address constant crvv1ethsteth  = 0xEa508F82728927454bd3ce853171b0e2705880D4;
33     address constant guniv3daiusdc1 = 0x7F6d78CC0040c87943a0e0c140De3F77a273bd58;
34     address constant guniv3daiusdc2 = 0xcCBa43231aC6eceBd1278B90c3a44711a00F4e93;
35     address constant spotter        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
36     address constant reth           = 0xeE7F0b350aA119b3d05DC733a4621a81972f7D47;
37 }
38 
39 contract MegaPoker is PokingAddresses {
40 
41     uint256 public last;
42 
43     function poke() external {
44         bool ok;
45 
46         // poke() = 0x18178358
47         (ok,) = eth.call(abi.encodeWithSelector(0x18178358));
48         (ok,) = btc.call(abi.encodeWithSelector(0x18178358));
49         (ok,) = mana.call(abi.encodeWithSelector(0x18178358));
50         (ok,) = link.call(abi.encodeWithSelector(0x18178358));
51         (ok,) = yfi.call(abi.encodeWithSelector(0x18178358));
52         (ok,) = univ2usdceth.call(abi.encodeWithSelector(0x18178358));
53         (ok,) = univ2daiusdc.call(abi.encodeWithSelector(0x18178358));
54         (ok,) = matic.call(abi.encodeWithSelector(0x18178358));
55         (ok,) = wsteth.call(abi.encodeWithSelector(0x18178358));
56         (ok,) = crvv1ethsteth.call(abi.encodeWithSelector(0x18178358));
57         (ok,) = reth.call(abi.encodeWithSelector(0x18178358));
58 
59 
60         // poke(bytes32) = 0x1504460f
61         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-A")));
62         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-A")));
63         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MANA-A")));
64         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("LINK-A")));
65         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-B")));
66         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("YFI-A")));
67         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RENBTC-A")));
68         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2USDCETH-A")));
69         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIUSDC-A")));
70         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-C")));
71         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MATIC-A")));
72         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-A")));
73         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-B")));
74         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("CRVV1ETHSTETH-A")));
75         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-B")));
76         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-C")));
77         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RETH-A")));
78 
79 
80         // Daily pokes
81         //  Reduced cost pokes
82         if (last <= block.timestamp - 1 days) {
83 
84             // The GUINIV3DAIUSDCX Oracles are very expensive to poke, and the price should not
85             //  change frequently, so they are getting poked only once a day.
86             (ok,) = guniv3daiusdc1.call(abi.encodeWithSelector(0x18178358));
87             (ok,) = guniv3daiusdc2.call(abi.encodeWithSelector(0x18178358));
88 
89 
90             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC1-A")));
91             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC2-A")));
92 
93             last = block.timestamp;
94         }
95     }
96 }