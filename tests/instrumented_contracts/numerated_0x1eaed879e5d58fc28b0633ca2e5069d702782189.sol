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
22     // OSMs
23     address constant btc            = 0xf185d0682d50819263941e5f4EacC763CC5C6C42;
24     address constant eth            = 0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763;
25     address constant gno            = 0xd800ca44fFABecd159c7889c3bf64a217361AEc8;
26     address constant reth           = 0xeE7F0b350aA119b3d05DC733a4621a81972f7D47;
27     address constant wsteth         = 0xFe7a2aC0B945f12089aEEB6eCebf4F384D9f043F;
28 
29     address constant crvv1ethsteth  = 0xEa508F82728927454bd3ce853171b0e2705880D4;
30     address constant guniv3daiusdc1 = 0x7F6d78CC0040c87943a0e0c140De3F77a273bd58;
31     address constant guniv3daiusdc2 = 0xcCBa43231aC6eceBd1278B90c3a44711a00F4e93;
32     address constant univ2daiusdc   = 0x25D03C2C928ADE19ff9f4FFECc07d991d0df054B;
33 
34     // Spotter
35     address constant spotter        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
36 }
37 
38 contract MegaPoker is PokingAddresses {
39 
40     uint256 public last;
41 
42     function poke() external {
43         bool ok;
44 
45         // poke() = 0x18178358
46         (ok,) = btc.call(abi.encodeWithSelector(0x18178358));
47         (ok,) = eth.call(abi.encodeWithSelector(0x18178358));
48         (ok,) = gno.call(abi.encodeWithSelector(0x18178358));
49         (ok,) = reth.call(abi.encodeWithSelector(0x18178358));
50         (ok,) = wsteth.call(abi.encodeWithSelector(0x18178358));
51 
52         // poke(bytes32) = 0x1504460f
53         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-A")));
54         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-B")));
55         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-C")));
56         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RETH-A")));
57         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-A")));
58         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-B")));
59         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-C")));
60         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-A")));
61         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-B")));
62 
63         // Daily pokes, i.e. reduced cost pokes
64         if (last <= block.timestamp - 1 days) {
65             // Poke
66             (ok,) = crvv1ethsteth.call(abi.encodeWithSelector(0x18178358));
67 
68             // The GUINIV3DAIUSDCX Oracles are very expensive to poke, and the
69             // price should not change frequently, so they are getting poked
70             // only once a day.
71             (ok,) = guniv3daiusdc1.call(abi.encodeWithSelector(0x18178358));
72             (ok,) = guniv3daiusdc2.call(abi.encodeWithSelector(0x18178358));
73 
74             (ok,) = univ2daiusdc.call(abi.encodeWithSelector(0x18178358));
75 
76             // Spotter pokes
77             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("CRVV1ETHSTETH-A")));
78             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC1-A")));
79             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC2-A")));
80             (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIUSDC-A")));
81 
82             last = block.timestamp;
83         }
84     }
85 }