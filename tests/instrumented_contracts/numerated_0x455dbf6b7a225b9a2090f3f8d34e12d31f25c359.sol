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
31     OsmLike constant eth = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
32     OsmLike constant bat = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
33     OsmLike constant wbtc = OsmLike(0xf185d0682d50819263941e5f4EacC763CC5C6C42);
34     OsmLike constant knc = OsmLike(0xf36B79BD4C0904A5F350F1e4f776B81208c13069);
35     OsmLike constant zrx = OsmLike(0x7382c066801E7Acb2299aC8562847B9883f5CD3c);
36     OsmLike constant mana = OsmLike(0x8067259EA630601f319FccE477977E55C6078C13);
37     OsmLike constant usdt = OsmLike(0x7a5918670B0C390aD25f7beE908c1ACc2d314A3C);
38     SpotLike constant spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
39 
40     function poke() external {
41         if (eth.pass()) eth.poke();
42         if (bat.pass()) bat.poke();
43         if (wbtc.pass()) wbtc.poke();
44         if (knc.pass()) knc.poke();
45         if (zrx.pass()) zrx.poke();
46         if (mana.pass()) mana.poke();
47         if (usdt.pass()) usdt.poke();
48 
49         spot.poke("ETH-A");
50         spot.poke("BAT-A");
51         spot.poke("WBTC-A");
52         spot.poke("KNC-A");
53         spot.poke("ZRX-A");
54         spot.poke("MANA-A");
55         spot.poke("USDT-A");
56     }
57 }