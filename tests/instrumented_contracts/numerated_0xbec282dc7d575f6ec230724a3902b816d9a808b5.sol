1 // MegaPoker
2 // (c) 2019 - Maker Foundation
3 pragma solidity ^0.5.12;
4 
5 contract PotLike {
6     function drip() external;
7 }
8 
9 contract JugLike {
10     function drip(bytes32) external;
11 }
12 
13 contract OsmLike {
14     function poke() external;
15     function pass() external view returns (bool);
16 }
17 
18 contract SpotLike {
19     function poke(bytes32) external;
20 }
21 
22 contract MegaPoker {
23     OsmLike constant public eth = OsmLike(0x81FE72B5A8d1A857d176C3E7d5Bd2679A9B85763);
24     OsmLike constant public bat = OsmLike(0xB4eb54AF9Cc7882DF0121d26c5b97E802915ABe6);
25     PotLike constant public pot = PotLike(0x197E90f9FAD81970bA7976f33CbD77088E5D7cf7);
26     JugLike constant public jug = JugLike(0x19c0976f590D67707E62397C87829d896Dc0f1F1);
27     SpotLike constant public spot = SpotLike(0x65C79fcB50Ca1594B025960e539eD7A9a6D434A3);
28 
29     function poke() external {
30         if (eth.pass()) eth.poke();
31         if (bat.pass()) bat.poke();
32         spot.poke("ETH-A");
33         spot.poke("BAT-A");
34         jug.drip("ETH-A");
35         jug.drip("BAT-A");
36         pot.drip();
37     }
38 }