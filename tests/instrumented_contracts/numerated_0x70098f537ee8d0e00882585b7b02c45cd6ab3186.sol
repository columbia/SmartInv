1 // hevm: flattened sources of src/MegaPoker.sol
2 // SPDX-License-Identifier: AGPL-3.0
3 pragma solidity >=0.6.12 <0.7.0;
4 
5 ////// src/MegaPoker.sol
6 // The MegaPoker
7 //
8 // Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
9 //
10 // This program is free software: you can redistribute it and/or modify
11 // it under the terms of the GNU Affero General Public License as published by
12 // the Free Software Foundation, either version 3 of the License, or
13 // (at your option) any later version.
14 //
15 // This program is distributed in the hope that it will be useful,
16 // but WITHOUT ANY WARRANTY; without even the implied warranty of
17 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
18 // GNU Affero General Public License for more details.
19 //
20 // You should have received a copy of the GNU Affero General Public License
21 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
22 
23 /* pragma solidity ^0.6.12; */
24 
25 contract PokingAddresses {
26     // OSMs and Spotter addresses
27     address constant eth            = 0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763;
28     address constant btc            = 0xf185d0682d50819263941e5f4EacC763CC5C6C42;
29     address constant mana           = 0x8067259EA630601f319FccE477977E55C6078C13;
30     address constant link           = 0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7;
31     address constant yfi            = 0x5F122465bCf86F45922036970Be6DD7F58820214;
32     address constant uni            = 0xf363c7e351C96b910b92b45d34190650df4aE8e7;
33     address constant univ2daieth    = 0xFc8137E1a45BAF0030563EC4F0F851bd36a85b7D;
34     address constant univ2wbtceth   = 0x8400D2EDb8B97f780356Ef602b1BdBc082c2aD07;
35     address constant univ2usdceth   = 0xf751f24DD9cfAd885984D1bA68860F558D21E52A;
36     address constant univ2daiusdc   = 0x25D03C2C928ADE19ff9f4FFECc07d991d0df054B;
37     address constant univ2unieth    = 0x8462A88f50122782Cc96108F476deDB12248f931;
38     address constant univ2wbtcdai   = 0x5bB72127a196392cf4aC00Cf57aB278394d24e55;
39     address constant matic          = 0x8874964279302e6d4e523Fb1789981C39a1034Ba;
40     address constant wsteth         = 0xFe7a2aC0B945f12089aEEB6eCebf4F384D9f043F;
41     address constant crvv1ethsteth  = 0x0A7DA4e31582a2fB4FD4067943e88f127F70ab39;
42     address constant guniv3daiusdc1 = 0x7F6d78CC0040c87943a0e0c140De3F77a273bd58;
43     address constant guniv3daiusdc2 = 0xcCBa43231aC6eceBd1278B90c3a44711a00F4e93;
44     address constant spotter        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
45 }
46 
47 contract MegaPoker is PokingAddresses {
48 
49     uint256 public last;
50 
51     function poke() external {
52         bool ok;
53 
54         // poke() = 0x18178358
55         (ok,) = eth.call(abi.encodeWithSelector(0x18178358));
56         (ok,) = btc.call(abi.encodeWithSelector(0x18178358));
57         (ok,) = mana.call(abi.encodeWithSelector(0x18178358));
58         (ok,) = link.call(abi.encodeWithSelector(0x18178358));
59         (ok,) = yfi.call(abi.encodeWithSelector(0x18178358));
60         (ok,) = uni.call(abi.encodeWithSelector(0x18178358));
61         (ok,) = univ2daieth.call(abi.encodeWithSelector(0x18178358));
62         (ok,) = univ2wbtceth.call(abi.encodeWithSelector(0x18178358));
63         (ok,) = univ2usdceth.call(abi.encodeWithSelector(0x18178358));
64         (ok,) = univ2daiusdc.call(abi.encodeWithSelector(0x18178358));
65         (ok,) = univ2unieth.call(abi.encodeWithSelector(0x18178358));
66         (ok,) = univ2wbtcdai.call(abi.encodeWithSelector(0x18178358));
67         (ok,) = matic.call(abi.encodeWithSelector(0x18178358));
68         (ok,) = wsteth.call(abi.encodeWithSelector(0x18178358));
69         (ok,) = crvv1ethsteth.call(abi.encodeWithSelector(0x18178358));
70 
71 
72         // poke(bytes32) = 0x1504460f
73         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-A")));
74         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-A")));
75         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MANA-A")));
76         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("LINK-A")));
77         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-B")));
78         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("YFI-A")));
79         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RENBTC-A")));
80         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNI-A")));
81         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIETH-A")));
82         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCETH-A")));
83         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2USDCETH-A")));
84         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIUSDC-A")));
85         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2UNIETH-A")));
86         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCDAI-A")));
87         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-C")));
88         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MATIC-A")));
89         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-A")));
90         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("CRVV1ETHSTETH-A")));
91         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-B")));
92         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-C")));
93 
94 
95         // Daily pokes
96         //  Reduced cost pokes
97         if (last <= block.timestamp - 1 days) {
98 
99             // The GUINIV3DAIUSDCX Oracles are very expensive to poke, and the price should not
100             //  change frequently, so they are getting poked only once a day.
101             (ok,) = guniv3daiusdc1.call(abi.encodeWithSelector(0x18178358));
102             (ok,) = guniv3daiusdc2.call(abi.encodeWithSelector(0x18178358));
103 
104 
105             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC1-A")));
106             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC2-A")));
107 
108             last = block.timestamp;
109         }
110     }
111 }