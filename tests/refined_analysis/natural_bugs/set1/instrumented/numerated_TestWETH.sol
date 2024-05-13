1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 
10 
11 contract WETH9 {
12     string public name = "Wrapped Ether";
13     string public symbol = "WETH";
14     uint8 public decimals = 18;
15 
16     event Approval(address indexed src, address indexed guy, uint256 wad);
17     event Transfer(address indexed src, address indexed dst, uint256 wad);
18     event Deposit(address indexed dst, uint256 wad);
19     event Withdrawal(address indexed src, uint256 wad);
20 
21     mapping(address => uint256) public balanceOf;
22     mapping(address => mapping(address => uint256)) public allowance;
23 
24     fallback() external payable {
25         deposit();
26     }
27 
28     receive() external payable {
29         deposit();
30     }
31 
32     function deposit() public payable {
33         balanceOf[msg.sender] += msg.value;
34         emit Deposit(msg.sender, msg.value);
35     }
36 
37     function withdraw(uint256 wad) public {
38         require(balanceOf[msg.sender] >= wad);
39         balanceOf[msg.sender] -= wad;
40         msg.sender.transfer(wad);
41         emit Withdrawal(msg.sender, wad);
42     }
43 
44     function totalSupply() public view returns (uint256) {
45         return address(this).balance;
46     }
47 
48     function approve(address guy, uint256 wad) public returns (bool) {
49         allowance[msg.sender][guy] = wad;
50         emit Approval(msg.sender, guy, wad);
51         return true;
52     }
53 
54     function transfer(address dst, uint256 wad) public returns (bool) {
55         return transferFrom(msg.sender, dst, wad);
56     }
57 
58     function transferFrom(
59         address src,
60         address dst,
61         uint256 wad
62     ) public returns (bool) {
63         require(balanceOf[src] >= wad);
64 
65         if (src != msg.sender && allowance[src][msg.sender] != uint256(-1)) {
66             require(allowance[src][msg.sender] >= wad);
67             allowance[src][msg.sender] -= wad;
68         }
69 
70         balanceOf[src] -= wad;
71         balanceOf[dst] += wad;
72 
73         Transfer(src, dst, wad);
74 
75         return true;
76     }
77 }
