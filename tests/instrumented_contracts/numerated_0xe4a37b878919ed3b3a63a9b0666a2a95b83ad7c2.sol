1 // The MegaPoker
2 //
3 // Copyright (C) 2020 Maker Ecosystem Growth Holdings, INC.
4 //
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public License
16 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 
18 pragma solidity >=0.5.12;
19 
20 abstract contract PotLike {
21     function drip() virtual external;
22 }
23 
24 abstract contract JugLike {
25     function drip(bytes32) virtual external;
26 }
27 
28 abstract contract OsmLike {
29     function poke() virtual external;
30     function pass() virtual external view returns (bool);
31 }
32 
33 abstract contract SpotLike {
34     function poke(bytes32) virtual external;
35 }
36 
37 contract MegaPoker {
38     OsmLike constant public eth = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
39     OsmLike constant public bat = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
40     OsmLike constant public wbtc = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
41     PotLike constant public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
42     JugLike constant public jug = JugLike(0x19c0976f590D67707E62397C87829d896Dc0f1F1);
43     SpotLike constant public spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
44 
45     function poke() external {
46         if (eth.pass()) eth.poke();
47         if (bat.pass()) bat.poke();
48         if (wbtc.pass()) wbtc.poke();
49         
50         spot.poke("ETH-A");
51         spot.poke("BAT-A");
52         spot.poke("WBTC-A");
53         
54         jug.drip("ETH-A");
55         jug.drip("BAT-A");
56         jug.drip("USDC-A");
57         jug.drip("WBTC-A");
58         
59         pot.drip();
60     }
61 }