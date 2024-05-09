1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.13;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(
16         address sender,
17         address recipient,
18         uint256 amount
19     ) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 contract MetaBabyToken is IERC20 {
26     
27     mapping(address => uint256) public balanceOf;
28     mapping(address => mapping(address => uint256)) public allowance;
29     string public name = "meta baby";
30     string public symbol = "BABY";
31     uint public decimals = 18;
32     uint256 public totalSupply = 0;
33 
34     constructor(address foundation){
35 
36         uint256 amount = 1000*1000*1000*10**decimals;
37 
38         balanceOf[foundation] = amount;
39         totalSupply += amount;
40         emit Transfer(address(0), foundation, amount);
41     }
42 
43     function transfer(address recipient, uint256 amount) external returns (bool) {
44         balanceOf[msg.sender] -= amount;
45         balanceOf[recipient] += amount;
46         emit Transfer(msg.sender, recipient, amount);
47         return true;
48     }
49 
50     function approve(address spender, uint256 amount) external returns (bool) {
51         allowance[msg.sender][spender] = amount;
52         emit Approval(msg.sender, spender, amount);
53         return true;
54     }
55 
56     function transferFrom(
57         address sender,
58         address recipient,
59         uint256 amount
60     ) external returns (bool) {
61         allowance[sender][msg.sender] -= amount;
62         balanceOf[sender] -= amount;
63         balanceOf[recipient] += amount;
64         emit Transfer(sender, recipient, amount);
65         return true;
66     }
67 
68     function burn(uint256 amount) external {
69         balanceOf[msg.sender] -= amount;
70         totalSupply -= amount;
71         emit Transfer(msg.sender, address(0), amount);
72     }
73 }