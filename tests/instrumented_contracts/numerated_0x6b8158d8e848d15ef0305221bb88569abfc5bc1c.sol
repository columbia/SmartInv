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
21 abstract contract PotLike {
22     function drip() virtual external;
23 }
24 
25 abstract contract JugLike {
26     function drip(bytes32) virtual external;
27 }
28 
29 abstract contract OsmLike {
30     function poke() virtual external;
31     function pass() virtual external view returns (bool);
32 }
33 
34 abstract contract SpotLike {
35     function poke(bytes32) virtual external;
36 }
37 
38 contract MegaPoker {
39     OsmLike constant public eth = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
40     OsmLike constant public bat = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
41     OsmLike constant public wbtc = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
42     OsmLike constant public knc = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
43     OsmLike constant public zrx = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
44     PotLike constant public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
45     JugLike constant public jug = JugLike(0x19c0976f590D67707E62397C87829d896Dc0f1F1);
46     SpotLike constant public spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
47 
48     function poke() external {
49         if (eth.pass()) eth.poke();
50         if (bat.pass()) bat.poke();
51         if (wbtc.pass()) wbtc.poke();
52         if (knc.pass()) knc.poke();
53         if (zrx.pass()) zrx.poke();
54         
55         spot.poke("ETH-A");
56         spot.poke("BAT-A");
57         spot.poke("WBTC-A");
58         spot.poke("KNC-A");
59         spot.poke("ZRX-A");
60         
61         jug.drip("ETH-A");
62         jug.drip("BAT-A");
63         jug.drip("WBTC-A");
64         jug.drip("USDC-A");
65         jug.drip("USDC-B");
66         jug.drip("TUSD-A");
67         jug.drip("KNC-A");
68         jug.drip("ZRX-A");
69         
70         pot.drip();
71     }
72 }