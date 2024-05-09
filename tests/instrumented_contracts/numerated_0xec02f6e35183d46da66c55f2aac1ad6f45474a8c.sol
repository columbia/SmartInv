1 //SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 interface IERC20 {
6 
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 library SafeMath { 
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21       assert(b <= a);
22       return a - b;
23     }
24     
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26       uint256 c = a + b;
27       assert(c >= a);
28       return c;
29     }
30 }
31 
32 contract APING is IERC20 {
33     using SafeMath for uint256;
34 
35     string public constant name = "ApingGames";
36     string public constant symbol = "APING";
37     uint8 public constant decimals = 18;  
38     uint256 private supply = 13370 * 10 ** 18;
39 
40     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
41     event Transfer(address indexed from, address indexed to, uint256 tokens);
42 
43     mapping(address => uint256) balances;
44     mapping(address => mapping (address => uint256)) allowed;
45     
46     constructor() public {
47         balances[msg.sender] = supply;
48         emit Transfer(address(0), msg.sender, supply);
49     }
50 
51     function totalSupply() public override view returns (uint256) {
52         return supply;
53     }
54     
55     function balanceOf(address tokenOwner) public override view returns (uint256) {
56         return balances[tokenOwner];
57     }
58 
59     function transfer(address receiver, uint256 numTokens) public override returns (bool) {
60         require(receiver != address(0));
61         require(numTokens <= balances[msg.sender]);
62     
63         balances[msg.sender] = balances[msg.sender].sub(numTokens);
64         balances[receiver] = balances[receiver].add(numTokens);
65     
66         emit Transfer(msg.sender, receiver, numTokens);
67         return true;
68     }
69 
70     function approve(address delegate, uint256 numTokens) public override returns (bool) {
71         require(delegate != address(0));
72     
73         allowed[msg.sender][delegate] = numTokens;
74     
75         emit Approval(msg.sender, delegate, numTokens);
76         return true;
77     }
78 
79     function allowance(address tokenOwner, address delegate) public override view returns (uint256) {
80         return allowed[tokenOwner][delegate];
81     }
82     
83     function burn(uint256 numTokens) public returns (bool) {
84         require(numTokens <= balances[msg.sender]);
85     
86         balances[msg.sender] = balances[msg.sender].sub(numTokens);
87         supply = supply.sub(numTokens);
88     
89         emit Transfer(msg.sender, address(0), numTokens);
90         return true;
91     }
92 
93     function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
94         require(numTokens <= balances[owner]);
95         require(numTokens <= allowed[owner][msg.sender]);
96     
97         balances[owner] = balances[owner].sub(numTokens);
98         allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
99         balances[buyer] = balances[buyer].add(numTokens);
100     
101         emit Transfer(owner, buyer, numTokens);
102         return true;
103     }
104 }