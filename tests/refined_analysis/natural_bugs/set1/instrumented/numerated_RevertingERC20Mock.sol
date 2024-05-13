1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 // RevertingERC20 reverts on errors
5 contract RevertingERC20Mock {
6     string public symbol;
7     string public name;
8     uint8 public immutable decimals;
9     uint256 public totalSupply;
10     mapping(address => uint256) public balanceOf;
11     mapping(address => mapping(address => uint256)) public allowance;
12 
13     event Transfer(address indexed _from, address indexed _to, uint256 _value);
14     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
15 
16     constructor(
17         string memory name_,
18         string memory symbol_,
19         uint8 decimals_,
20         uint256 supply
21     ) public {
22         name = name_;
23         symbol = symbol_;
24         decimals = decimals_;
25         totalSupply = supply;
26         balanceOf[msg.sender] = supply;
27     }
28 
29     function transfer(address to, uint256 amount) public returns (bool success) {
30         require(balanceOf[msg.sender] >= amount, "TokenB: balance too low");
31         require(amount >= 0, "TokenB: amount should be > 0");
32         require(balanceOf[to] + amount >= balanceOf[to], "TokenB: overflow detected");
33         balanceOf[msg.sender] -= amount;
34         balanceOf[to] += amount;
35         emit Transfer(msg.sender, to, amount);
36         return true;
37     }
38 
39     function transferFrom(
40         address from,
41         address to,
42         uint256 amount
43     ) public returns (bool success) {
44         require(balanceOf[from] >= amount, "TokenB: balance too low");
45         require(allowance[from][msg.sender] >= amount, "TokenB: allowance too low");
46         require(amount >= 0, "TokenB: amount should be >= 0");
47         require(balanceOf[to] + amount >= balanceOf[to], "TokenB: overflow detected");
48         balanceOf[from] -= amount;
49         allowance[from][msg.sender] -= amount;
50         balanceOf[to] += amount;
51         emit Transfer(from, to, amount);
52         return true;
53     }
54 
55     function approve(address spender, uint256 amount) public returns (bool success) {
56         allowance[msg.sender][spender] = amount;
57         emit Approval(msg.sender, spender, amount);
58         return true;
59     }
60 }
