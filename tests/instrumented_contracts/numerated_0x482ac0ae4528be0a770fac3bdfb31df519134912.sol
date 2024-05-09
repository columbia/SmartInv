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
19 pragma solidity >=0.5.12;
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
31     OsmLike constant eth  = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
32     OsmLike constant bat  = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
33     OsmLike constant wbtc = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
34     OsmLike constant knc  = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
35     OsmLike constant zrx  = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
36     OsmLike constant mana = OsmLike(0x8067259EA630601f319FccE477977E55C6078C13);
37     OsmLike constant usdt = OsmLike(0x7a5918670B0C390aD25f7beE908c1ACc2d314A3C);
38     OsmLike constant comp = OsmLike(0xBED0879953E633135a48a157718Aa791AC0108E4);
39     OsmLike constant link = OsmLike(0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7);
40     OsmLike constant lrc  = OsmLike(0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a);
41     OsmLike constant yfi  = OsmLike(0x5F122465bCf86F45922036970Be6DD7F58820214);
42     OsmLike constant bal  = OsmLike(0x3ff860c0F28D69F392543A16A397D0dAe85D16dE);
43     SpotLike constant spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
44 
45     function poke() external {
46         if ( eth.pass())  eth.poke();
47         if ( bat.pass())  bat.poke();
48         if (wbtc.pass()) wbtc.poke();
49         if ( knc.pass())  knc.poke();
50         if ( zrx.pass())  zrx.poke();
51         if (mana.pass()) mana.poke();
52         if (usdt.pass()) usdt.poke();
53         if (comp.pass()) comp.poke();
54         if (link.pass()) link.poke();
55         if ( lrc.pass())  lrc.poke();
56         if ( yfi.pass())  yfi.poke();
57         if ( bal.pass())  bal.poke();
58 
59         spot.poke("ETH-A");
60         spot.poke("BAT-A");
61         spot.poke("WBTC-A");
62         spot.poke("KNC-A");
63         spot.poke("ZRX-A");
64         spot.poke("MANA-A");
65         spot.poke("USDT-A");
66         spot.poke("COMP-A");
67         spot.poke("LINK-A");
68         spot.poke("LRC-A");
69         spot.poke("ETH-B");
70         spot.poke("YFI-A");
71         spot.poke("BAL-A");
72     }
73 
74     // Use for poking OSMs prior to collateral being added
75     function pokeTemp() external {
76         if ( eth.pass())  eth.poke();
77         if ( bat.pass())  bat.poke();
78         if (wbtc.pass()) wbtc.poke();
79         if ( knc.pass())  knc.poke();
80         if ( zrx.pass())  zrx.poke();
81         if (mana.pass()) mana.poke();
82         if (usdt.pass()) usdt.poke();
83         if (comp.pass()) comp.poke();
84         if (link.pass()) link.poke();
85         if ( lrc.pass())  lrc.poke();
86         if ( yfi.pass())  yfi.poke();
87         if ( bal.pass())  bal.poke();
88 
89         spot.poke("ETH-A");
90         spot.poke("BAT-A");
91         spot.poke("WBTC-A");
92         spot.poke("KNC-A");
93         spot.poke("ZRX-A");
94         spot.poke("MANA-A");
95         spot.poke("USDT-A");
96         spot.poke("COMP-A");
97         spot.poke("LINK-A");
98         spot.poke("LRC-A");
99         spot.poke("ETH-B");
100     }
101 }