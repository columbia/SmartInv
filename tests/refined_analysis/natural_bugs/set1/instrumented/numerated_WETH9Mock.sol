1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.6.12;
3 
4 contract WETH9Mock {
5     string public name = "Wrapped Ether";
6     string public symbol = "WETH";
7     uint8 public decimals = 18;
8 
9     event Approval(address indexed src, address indexed guy, uint256 wad);
10     event Transfer(address indexed src, address indexed dst, uint256 wad);
11     event Deposit(address indexed dst, uint256 wad);
12     event Withdrawal(address indexed src, uint256 wad);
13 
14     mapping(address => uint256) public balanceOf;
15     mapping(address => mapping(address => uint256)) public allowance;
16 
17     /*fallback () external payable {
18         deposit();
19     }*/
20     function deposit() public payable {
21         balanceOf[msg.sender] += msg.value;
22         emit Deposit(msg.sender, msg.value);
23     }
24 
25     function withdraw(uint256 wad) public {
26         require(balanceOf[msg.sender] >= wad, "WETH9: Error");
27         balanceOf[msg.sender] -= wad;
28         msg.sender.transfer(wad);
29         emit Withdrawal(msg.sender, wad);
30     }
31 
32     function totalSupply() public view returns (uint256) {
33         return address(this).balance;
34     }
35 
36     function approve(address guy, uint256 wad) public returns (bool) {
37         allowance[msg.sender][guy] = wad;
38         emit Approval(msg.sender, guy, wad);
39         return true;
40     }
41 
42     function transfer(address dst, uint256 wad) public returns (bool) {
43         return transferFrom(msg.sender, dst, wad);
44     }
45 
46     function transferFrom(
47         address src,
48         address dst,
49         uint256 wad
50     ) public returns (bool) {
51         require(balanceOf[src] >= wad, "WETH9: Error");
52 
53         if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
54             require(allowance[src][msg.sender] >= wad, "WETH9: Error");
55             allowance[src][msg.sender] -= wad;
56         }
57 
58         balanceOf[src] -= wad;
59         balanceOf[dst] += wad;
60 
61         emit Transfer(src, dst, wad);
62 
63         return true;
64     }
65 }
