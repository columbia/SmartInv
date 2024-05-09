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
31     OsmLike constant eth         = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
32     OsmLike constant bat         = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
33     OsmLike constant btc         = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
34     OsmLike constant knc         = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
35     OsmLike constant zrx         = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
36     OsmLike constant mana        = OsmLike(0x8067259EA630601f319FccE477977E55C6078C13);
37     OsmLike constant usdt        = OsmLike(0x7a5918670B0C390aD25f7beE908c1ACc2d314A3C);
38     OsmLike constant comp        = OsmLike(0xBED0879953E633135a48a157718Aa791AC0108E4);
39     OsmLike constant link        = OsmLike(0x9B0C694C6939b5EA9584e9b61C7815E8d97D9cC7);
40     OsmLike constant lrc         = OsmLike(0x9eb923339c24c40Bef2f4AF4961742AA7C23EF3a);
41     OsmLike constant yfi         = OsmLike(0x5F122465bCf86F45922036970Be6DD7F58820214);
42     OsmLike constant bal         = OsmLike(0x3ff860c0F28D69F392543A16A397D0dAe85D16dE);
43     OsmLike constant uni         = OsmLike(0xf363c7e351C96b910b92b45d34190650df4aE8e7);
44     OsmLike constant aave        = OsmLike(0x8Df8f06DC2dE0434db40dcBb32a82A104218754c);
45     OsmLike constant univ2daieth = OsmLike(0x87ecBd742cEB40928E6cDE77B2f0b5CFa3342A09);
46     SpotLike constant spot       = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
47 
48     function process() internal {
49         if (        eth.pass())          eth.poke();
50         if (        bat.pass())          bat.poke();
51         if (        btc.pass())          btc.poke();
52         if (        knc.pass())          knc.poke();
53         if (        zrx.pass())          zrx.poke();
54         if (       mana.pass())         mana.poke();
55         if (       usdt.pass())         usdt.poke();
56         if (       comp.pass())         comp.poke();
57         if (       link.pass())         link.poke();
58         if (        lrc.pass())          lrc.poke();
59         if (        yfi.pass())          yfi.poke();
60         if (        bal.pass())          bal.poke();
61         if (        uni.pass())          uni.poke();
62         if (       aave.pass())         aave.poke();
63 
64         spot.poke("ETH-A");
65         spot.poke("BAT-A");
66         spot.poke("WBTC-A");
67         spot.poke("KNC-A");
68         spot.poke("ZRX-A");
69         spot.poke("MANA-A");
70         spot.poke("USDT-A");
71         spot.poke("COMP-A");
72         spot.poke("LINK-A");
73         spot.poke("LRC-A");
74         spot.poke("ETH-B");
75         spot.poke("YFI-A");
76         spot.poke("BAL-A");
77         spot.poke("RENBTC-A");
78         spot.poke("UNI-A");
79     }
80 
81     function poke() external {
82         process();
83         spot.poke("AAVE-A");
84         if (univ2daieth.pass())  univ2daieth.poke();
85         spot.poke("UNIV2DAIETH-A");
86     }
87 
88     // Use for poking OSMs prior to collateral being added
89     function pokeTemp() external {
90         process();
91     }
92 }