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
28     address constant uni            = 0xf363c7e351C96b910b92b45d34190650df4aE8e7;
29     address constant univ2daieth    = 0xFc8137E1a45BAF0030563EC4F0F851bd36a85b7D;
30     address constant univ2wbtceth   = 0x8400D2EDb8B97f780356Ef602b1BdBc082c2aD07;
31     address constant univ2usdceth   = 0xf751f24DD9cfAd885984D1bA68860F558D21E52A;
32     address constant univ2daiusdc   = 0x25D03C2C928ADE19ff9f4FFECc07d991d0df054B;
33     address constant univ2unieth    = 0x8462A88f50122782Cc96108F476deDB12248f931;
34     address constant univ2wbtcdai   = 0x5bB72127a196392cf4aC00Cf57aB278394d24e55;
35     address constant matic          = 0x8874964279302e6d4e523Fb1789981C39a1034Ba;
36     address constant wsteth         = 0xFe7a2aC0B945f12089aEEB6eCebf4F384D9f043F;
37     address constant crvv1ethsteth  = 0xEa508F82728927454bd3ce853171b0e2705880D4;
38     address constant guniv3daiusdc1 = 0x7F6d78CC0040c87943a0e0c140De3F77a273bd58;
39     address constant guniv3daiusdc2 = 0xcCBa43231aC6eceBd1278B90c3a44711a00F4e93;
40     address constant spotter        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
41 }
42 
43 contract MegaPoker is PokingAddresses {
44 
45     uint256 public last;
46 
47     function poke() external {
48         bool ok;
49 
50         // poke() = 0x18178358
51         (ok,) = eth.call(abi.encodeWithSelector(0x18178358));
52         (ok,) = btc.call(abi.encodeWithSelector(0x18178358));
53         (ok,) = mana.call(abi.encodeWithSelector(0x18178358));
54         (ok,) = link.call(abi.encodeWithSelector(0x18178358));
55         (ok,) = yfi.call(abi.encodeWithSelector(0x18178358));
56         (ok,) = uni.call(abi.encodeWithSelector(0x18178358));
57         (ok,) = univ2daieth.call(abi.encodeWithSelector(0x18178358));
58         (ok,) = univ2wbtceth.call(abi.encodeWithSelector(0x18178358));
59         (ok,) = univ2usdceth.call(abi.encodeWithSelector(0x18178358));
60         (ok,) = univ2daiusdc.call(abi.encodeWithSelector(0x18178358));
61         (ok,) = univ2unieth.call(abi.encodeWithSelector(0x18178358));
62         (ok,) = univ2wbtcdai.call(abi.encodeWithSelector(0x18178358));
63         (ok,) = matic.call(abi.encodeWithSelector(0x18178358));
64         (ok,) = wsteth.call(abi.encodeWithSelector(0x18178358));
65         (ok,) = crvv1ethsteth.call(abi.encodeWithSelector(0x18178358));
66 
67 
68         // poke(bytes32) = 0x1504460f
69         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-A")));
70         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-A")));
71         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MANA-A")));
72         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("LINK-A")));
73         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-B")));
74         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("YFI-A")));
75         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RENBTC-A")));
76         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNI-A")));
77         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIETH-A")));
78         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCETH-A")));
79         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2USDCETH-A")));
80         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIUSDC-A")));
81         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2UNIETH-A")));
82         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCDAI-A")));
83         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-C")));
84         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MATIC-A")));
85         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-A")));
86         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("CRVV1ETHSTETH-A")));
87         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-B")));
88         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-C")));
89 
90 
91         // Daily pokes
92         //  Reduced cost pokes
93         if (last <= block.timestamp - 1 days) {
94 
95             // The GUINIV3DAIUSDCX Oracles are very expensive to poke, and the price should not
96             //  change frequently, so they are getting poked only once a day.
97             (ok,) = guniv3daiusdc1.call(abi.encodeWithSelector(0x18178358));
98             (ok,) = guniv3daiusdc2.call(abi.encodeWithSelector(0x18178358));
99 
100 
101             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC1-A")));
102             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC2-A")));
103 
104             last = block.timestamp;
105         }
106     }
107 }