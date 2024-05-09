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
19 pragma solidity ^0.6.11;
20 
21 interface OsmLike {
22     function poke() external;
23     function pass() external view returns (bool);
24 }
25 
26 interface SpotLike {
27     function poke(bytes32) external;
28 }
29 
30 contract MegaPoker {
31     OsmLike constant eth          = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
32     OsmLike constant bat          = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
33     OsmLike constant btc          = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
34     OsmLike constant knc          = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
35     OsmLike constant zrx          = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
36     OsmLike constant mana         = OsmLike(0x8067259EA630601f319FccE477977E55C6078C13);
37     OsmLike constant usdt         = OsmLike(0x7a5918670B0C390aD25f7beE908c1ACc2d314A3C);
38     OsmLike constant comp         = OsmLike(0xBED0879953E633135a48a157718Aa791AC0108E4);
39     OsmLike constant link         = OsmLike(0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7);
40     OsmLike constant lrc          = OsmLike(0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a);
41     OsmLike constant yfi          = OsmLike(0x5F122465bCf86F45922036970Be6DD7F58820214);
42     OsmLike constant bal          = OsmLike(0x3ff860c0F28D69F392543A16A397D0dAe85D16dE);
43     OsmLike constant uni          = OsmLike(0xf363c7e351C96b910b92b45d34190650df4aE8e7);
44     OsmLike constant aave         = OsmLike(0x8Df8f06DC2dE0434db40dcBb32a82A104218754c);
45     OsmLike constant univ2daieth  = OsmLike(0x87ecBd742cEB40928E6cDE77B2f0b5CFa3342A09);
46     OsmLike constant univ2wbtceth = OsmLike(0x771338D5B31754b25D2eb03Cea676877562Dec26);
47     OsmLike constant univ2usdceth = OsmLike(0xECB03Fec701B93DC06d19B4639AA8b5a838472BE);
48     OsmLike constant univ2daiusdc = OsmLike(0x25CD858a00146961611b18441353603191f110A0);
49     OsmLike constant univ2ethusdt = OsmLike(0x9b015AA3e4787dd0df8B43bF2FE6d90fa543E13B);
50     OsmLike constant univ2linketh = OsmLike(0x628009F5F5029544AE84636Ef676D3Cc5755238b);
51     OsmLike constant univ2unieth  = OsmLike(0x8Ce9E9442F2791FC63CD6394cC12F2dE4fbc1D71);
52     OsmLike constant univ2wbtcdai = OsmLike(0x5FB5a346347ACf4FCD3AAb28f5eE518785FB0AD0);
53     OsmLike constant univ2aaveeth = OsmLike(0x8D34DC2c33A6386E96cA562D8478Eaf82305b81a);
54     OsmLike constant univ2daiusdt = OsmLike(0x69562A7812830E6854Ffc50b992c2AA861D5C2d3);
55     SpotLike constant spot        = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
56 
57     function process() internal {
58         if (         eth.pass())           eth.poke();
59         if (         bat.pass())           bat.poke();
60         if (         btc.pass())           btc.poke();
61         if (         knc.pass())           knc.poke();
62         if (         zrx.pass())           zrx.poke();
63         if (        mana.pass())          mana.poke();
64         if (        usdt.pass())          usdt.poke();
65         if (        comp.pass())          comp.poke();
66         if (        link.pass())          link.poke();
67         if (         lrc.pass())           lrc.poke();
68         if (         yfi.pass())           yfi.poke();
69         if (         bal.pass())           bal.poke();
70         if (         uni.pass())           uni.poke();
71         if (        aave.pass())          aave.poke();
72         if ( univ2daieth.pass())   univ2daieth.poke();
73         if (univ2wbtceth.pass())  univ2wbtceth.poke();
74         if (univ2usdceth.pass())  univ2usdceth.poke();
75         if (univ2daiusdc.pass())  univ2daiusdc.poke();
76         if (univ2ethusdt.pass())  univ2ethusdt.poke();
77         if (univ2linketh.pass())  univ2linketh.poke();
78         if ( univ2unieth.pass())   univ2unieth.poke();
79         if (univ2wbtcdai.pass())  univ2wbtcdai.poke();
80         if (univ2aaveeth.pass())  univ2aaveeth.poke();
81 
82         spot.poke("ETH-A");
83         spot.poke("BAT-A");
84         spot.poke("WBTC-A");
85         spot.poke("KNC-A");
86         spot.poke("ZRX-A");
87         spot.poke("MANA-A");
88         spot.poke("USDT-A");
89         spot.poke("COMP-A");
90         spot.poke("LINK-A");
91         spot.poke("LRC-A");
92         spot.poke("ETH-B");
93         spot.poke("YFI-A");
94         spot.poke("BAL-A");
95         spot.poke("RENBTC-A");
96         spot.poke("UNI-A");
97         spot.poke("AAVE-A");
98         spot.poke("UNIV2DAIETH-A");
99         spot.poke("UNIV2WBTCETH-A");
100         spot.poke("UNIV2USDCETH-A");
101         spot.poke("UNIV2DAIUSDC-A");
102         spot.poke("UNIV2ETHUSDT-A");
103         spot.poke("UNIV2LINKETH-A");
104         spot.poke("UNIV2UNIETH-A");
105         spot.poke("UNIV2WBTCDAI-A");
106         spot.poke("UNIV2AAVEETH-A");
107     }
108 
109     function poke() external {
110         process();
111 
112         if (univ2daiusdt.pass())  univ2daiusdt.poke();
113 
114         spot.poke("UNIV2DAIUSDT-A");
115     }
116 
117     // Use for poking OSMs prior to collateral being added
118     function pokeTemp() external {
119         process();
120     }
121 }