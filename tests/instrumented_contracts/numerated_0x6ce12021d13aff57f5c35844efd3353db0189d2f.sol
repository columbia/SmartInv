1 pragma solidity ^0.4.24;
2 
3 contract SaiTap {
4     function s2s() public returns (uint);
5     function bid(uint wad) public returns (uint);
6     function ask(uint wad) public returns (uint);
7 }
8 
9 contract GetSaiTapValues {
10     SaiTap public saiTap = SaiTap(0xBda109309f9FafA6Dd6A9CB9f1Df4085B27Ee8eF);
11 
12     uint public wad;
13     uint public s2s;
14     uint public bid;
15     uint public ask;
16 
17     function update(uint _wad) public {
18         wad = _wad;
19         s2s = saiTap.s2s();
20         bid = saiTap.bid(_wad);
21         ask = saiTap.ask(_wad);
22     }
23 }