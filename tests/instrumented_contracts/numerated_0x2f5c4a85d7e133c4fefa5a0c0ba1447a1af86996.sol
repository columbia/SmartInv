1 pragma solidity ^0.4.24;
2 
3 contract SaiTub {
4     function tab(bytes32 cup) public returns (uint);
5     function rap(bytes32 cup) public returns (uint);
6     function din() public returns (uint);
7     function chi() public returns (uint);
8     function rhi() public returns (uint);
9 }
10 
11 contract GetSaiTubValues {
12     SaiTub public saiTub = SaiTub(0x448a5065aeBB8E423F0896E6c5D525C040f59af3);
13 
14     bytes32 public cup;
15     uint public tab;
16     uint public rap;
17     uint public din;
18     uint public chi;
19     uint public rhi;
20 
21     function updateTabRap(bytes32 _cup) public {
22         cup = _cup;
23         tab = saiTub.tab(_cup);
24         rap = saiTub.rap(_cup);
25     }
26 
27     function updateRest() public {
28         din = saiTub.din();
29         chi = saiTub.chi();
30         rhi = saiTub.rhi();
31     }
32 }