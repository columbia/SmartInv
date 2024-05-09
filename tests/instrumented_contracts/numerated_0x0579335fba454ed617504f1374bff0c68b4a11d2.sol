1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.6.10;
4 
5 contract KabazonPoints {
6     // Track how many tokens are owned by each address.
7     mapping (address => uint256) public balanceOf;
8 
9     string public name = "Kabazon Points";
10     string public symbol = "KP";
11     uint8 public decimals = 18;
12     uint256 public totalSupply = 20000000000 * (uint256(10) ** decimals);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15 
16     constructor() public {
17         // Initially assign all tokens to the contract's creator.
18         balanceOf[msg.sender] = totalSupply;
19         emit Transfer(address(0), msg.sender, totalSupply);
20     }
21 
22     function transfer(address to, uint256 value) public returns (bool success) {
23         require(balanceOf[msg.sender] >= value);
24 
25         balanceOf[msg.sender] -= value;  // deduct from sender's balance
26         balanceOf[to] += value;          // add to recipient's balance
27         emit Transfer(msg.sender, to, value);
28         return true;
29     }
30 
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 
33     mapping(address => mapping(address => uint256)) public allowance;
34 
35     function approve(address spender, uint256 value)
36         public
37         returns (bool success)
38     {
39         allowance[msg.sender][spender] = value;
40         emit Approval(msg.sender, spender, value);
41         return true;
42     }
43 
44     function transferFrom(address from, address to, uint256 value)
45         public
46         returns (bool success)
47     {
48         require(value <= balanceOf[from]);
49         require(value <= allowance[from][msg.sender]);
50 
51         balanceOf[from] -= value;
52         balanceOf[to] += value;
53         allowance[from][msg.sender] -= value;
54         emit Transfer(from, to, value);
55         return true;
56     }
57 }