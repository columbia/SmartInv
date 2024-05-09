1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.4;
4 
5 contract GDT {
6     mapping (address => uint256) public balanceOf;
7     mapping(address => mapping(address => uint256)) public allowance;
8 
9     string public constant name = "GDT";
10     string public constant symbol = "GDT";
11     uint8 public constant decimals = 8;
12     address private immutable initial_address;
13     uint256 public totalSupply = 400_000_000 * (uint256(10) ** decimals);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17     
18     modifier validAddress(address addr) {
19         require(addr != address(0), "Address cannot be 0x0");
20         require(addr != address(this), "Address cannot be contract address");
21         _;
22     }
23 
24     constructor(address manager) validAddress(manager) {
25         initial_address = manager;
26         balanceOf[manager] = totalSupply;
27         emit Transfer(address(0), manager, totalSupply);
28     }
29 
30     function transfer(address to, uint256 value) external validAddress(to) returns (bool success) {
31         uint256 senderBalance = balanceOf[msg.sender];
32         require(senderBalance >= value, "ERC20: insufficient balance for transfer");
33         balanceOf[msg.sender] = senderBalance - value; // deduct from sender's balance
34         balanceOf[to] += value; // add to recipient's balance
35         emit Transfer(msg.sender, to, value);
36         return true;
37     }
38 
39     function approve(address spender, uint256 value)
40         public
41         validAddress(spender)
42         returns (bool success)
43     {
44         allowance[msg.sender][spender] = value;
45         emit Approval(msg.sender, spender, value);
46         return true;
47     }
48 
49     function transferFrom(address from, address to, uint256 value)
50         external
51         validAddress(to)
52         returns (bool success)
53     {
54         uint256 balanceFrom = balanceOf[from];
55         uint256 allowanceSender = allowance[from][msg.sender];
56         require(value <= balanceFrom, "ERC20: insufficient balance for transferFrom");
57         require(value <= allowanceSender, "ERC20: unauthorized transferFrom");
58         balanceOf[from] = balanceFrom - value;
59         balanceOf[to] += value;
60         allowance[from][msg.sender] = allowanceSender - value;
61         emit Transfer(from, to, value);
62         return true;
63     }
64 
65     function burn(uint256 amount)
66         external
67         returns (bool success)
68     {
69         require(msg.sender==initial_address,'ERC20: burn not authorized.');
70         uint256 accountBalance = balanceOf[msg.sender];
71         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
72         balanceOf[msg.sender] = accountBalance - amount;
73         totalSupply -= amount;
74         emit Transfer(msg.sender, address(0), amount);
75         return true;
76     }
77 
78     function increaseAllowance(address spender, uint256 addedValue)
79         external
80         validAddress(spender)
81         returns (bool)
82     {
83         approve(spender, allowance[msg.sender][spender] + addedValue);
84         return true;
85     }
86 
87     function decreaseAllowance(address spender, uint256 subtractedValue)
88         external
89         validAddress(spender)
90         returns (bool)
91     {
92         uint256 currentAllowance = allowance[msg.sender][spender];
93         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
94         approve(spender, currentAllowance - subtractedValue);
95         return true;
96     }
97 }