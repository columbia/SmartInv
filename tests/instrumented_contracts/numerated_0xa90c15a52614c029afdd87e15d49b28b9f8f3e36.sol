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
24     address constant bat            = 0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6;
25     address constant btc            = 0xf185d0682d50819263941e5f4EacC763CC5C6C42;
26     address constant zrx            = 0x7382c066801E7Acb2299aC8562847B9883f5CD3c;
27     address constant mana           = 0x8067259EA630601f319FccE477977E55C6078C13;
28     address constant comp           = 0xBED0879953E633135a48a157718Aa791AC0108E4;
29     address constant link           = 0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7;
30     address constant lrc            = 0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a;
31     address constant yfi            = 0x5F122465bCf86F45922036970Be6DD7F58820214;
32     address constant bal            = 0x3ff860c0F28D69F392543A16A397D0dAe85D16dE;
33     address constant uni            = 0xf363c7e351C96b910b92b45d34190650df4aE8e7;
34     address constant aave           = 0x8Df8f06DC2dE0434db40dcBb32a82A104218754c;
35     address constant univ2daieth    = 0xFc8137E1a45BAF0030563EC4F0F851bd36a85b7D;
36     address constant univ2wbtceth   = 0x8400D2EDb8B97f780356Ef602b1BdBc082c2aD07;
37     address constant univ2usdceth   = 0xf751f24DD9cfAd885984D1bA68860F558D21E52A;
38     address constant univ2daiusdc   = 0x25D03C2C928ADE19ff9f4FFECc07d991d0df054B;
39     address constant univ2linketh   = 0xd7d31e62AE5bfC3bfaa24Eda33e8c32D31a1746F;
40     address constant univ2unieth    = 0x8462A88f50122782Cc96108F476deDB12248f931;
41     address constant univ2wbtcdai   = 0x5bB72127a196392cf4aC00Cf57aB278394d24e55;
42     address constant univ2aaveeth   = 0x32d8416e8538Ac36272c44b0cd962cD7E0198489;
43     address constant matic          = 0x8874964279302e6d4e523Fb1789981C39a1034Ba;
44     address constant wsteth         = 0xFe7a2aC0B945f12089aEEB6eCebf4F384D9f043F;
45     address constant guniv3daiusdc1 = 0x7F6d78CC0040c87943a0e0c140De3F77a273bd58;
46     address constant spotter        = 0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3;
47 }
48 
49 contract MegaPoker is PokingAddresses {
50     function poke() external {
51         bool ok;
52 
53         // poke() = 0x18178358
54         (ok,) = eth.call(abi.encodeWithSelector(0x18178358));
55         (ok,) = bat.call(abi.encodeWithSelector(0x18178358));
56         (ok,) = btc.call(abi.encodeWithSelector(0x18178358));
57         (ok,) = zrx.call(abi.encodeWithSelector(0x18178358));
58         (ok,) = mana.call(abi.encodeWithSelector(0x18178358));
59         (ok,) = comp.call(abi.encodeWithSelector(0x18178358));
60         (ok,) = link.call(abi.encodeWithSelector(0x18178358));
61         (ok,) = lrc.call(abi.encodeWithSelector(0x18178358));
62         (ok,) = yfi.call(abi.encodeWithSelector(0x18178358));
63         (ok,) = bal.call(abi.encodeWithSelector(0x18178358));
64         (ok,) = uni.call(abi.encodeWithSelector(0x18178358));
65         (ok,) = aave.call(abi.encodeWithSelector(0x18178358));
66         (ok,) = univ2daieth.call(abi.encodeWithSelector(0x18178358));
67         (ok,) = univ2wbtceth.call(abi.encodeWithSelector(0x18178358));
68         (ok,) = univ2usdceth.call(abi.encodeWithSelector(0x18178358));
69         (ok,) = univ2daiusdc.call(abi.encodeWithSelector(0x18178358));
70         (ok,) = univ2linketh.call(abi.encodeWithSelector(0x18178358));
71         (ok,) = univ2unieth.call(abi.encodeWithSelector(0x18178358));
72         (ok,) = univ2wbtcdai.call(abi.encodeWithSelector(0x18178358));
73         (ok,) = univ2aaveeth.call(abi.encodeWithSelector(0x18178358));
74         (ok,) = matic.call(abi.encodeWithSelector(0x18178358));
75         (ok,) = wsteth.call(abi.encodeWithSelector(0x18178358));
76         (ok,) = guniv3daiusdc1.call(abi.encodeWithSelector(0x18178358));
77 
78         // poke(bytes32) = 0x1504460f
79         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-A")));
80         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("BAT-A")));
81         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WBTC-A")));
82         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ZRX-A")));
83         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MANA-A")));
84         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("COMP-A")));
85         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("LINK-A")));
86         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("LRC-A")));
87         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-B")));
88         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("YFI-A")));
89         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("BAL-A")));
90         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("RENBTC-A")));
91         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNI-A")));
92         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("AAVE-A")));
93         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIETH-A")));
94         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCETH-A")));
95         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2USDCETH-A")));
96         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2DAIUSDC-A")));
97         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2LINKETH-A")));
98         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2UNIETH-A")));
99         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2WBTCDAI-A")));
100         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("UNIV2AAVEETH-A")));
101         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("ETH-C")));
102         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("MATIC-A")));
103         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("WSTETH-A")));
104         (ok,) = spotter.call(abi.encodeWithSelector(0x1504460f, bytes32("GUNIV3DAIUSDC1-A")));
105     }
106 }