1 // File: contracts/lib/SafeMath.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 
12 
13 /**
14  * @title SafeMath
15  * @author DODO Breeder
16  *
17  * @notice Math operations with safety checks that revert on error
18  */
19 library SafeMath {
20     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21         if (a == 0) {
22             return 0;
23         }
24 
25         uint256 c = a * b;
26         require(c / a == b, "MUL_ERROR");
27 
28         return c;
29     }
30 
31     function div(uint256 a, uint256 b) internal pure returns (uint256) {
32         require(b > 0, "DIVIDING_ERROR");
33         return a / b;
34     }
35 
36     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 quotient = div(a, b);
38         uint256 remainder = a - quotient * b;
39         if (remainder > 0) {
40             return quotient + 1;
41         } else {
42             return quotient;
43         }
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b <= a, "SUB_ERROR");
48         return a - b;
49     }
50 
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "ADD_ERROR");
54         return c;
55     }
56 
57     function sqrt(uint256 x) internal pure returns (uint256 y) {
58         uint256 z = x / 2 + 1;
59         y = x;
60         while (z < y) {
61             y = z;
62             z = (x / z + z) / 2;
63         }
64     }
65 }
66 
67 // File: contracts/external/ERC20/InitializableERC20.sol
68 
69 
70 
71 contract InitializableERC20 {
72     using SafeMath for uint256;
73 
74     string public name;
75     uint256 public decimals;
76     string public symbol;
77     uint256 public totalSupply;
78 
79     bool public initialized;
80 
81     mapping(address => uint256) balances;
82     mapping(address => mapping(address => uint256)) internal allowed;
83 
84     event Transfer(address indexed from, address indexed to, uint256 amount);
85     event Approval(address indexed owner, address indexed spender, uint256 amount);
86 
87     function init(
88         address _creator,
89         uint256 _totalSupply,
90         string memory _name,
91         string memory _symbol,
92         uint256 _decimals
93     ) public {
94         require(!initialized, "TOKEN_INITIALIZED");
95         initialized = true;
96         totalSupply = _totalSupply;
97         balances[_creator] = _totalSupply;
98         name = _name;
99         symbol = _symbol;
100         decimals = _decimals;
101         emit Transfer(address(0), _creator, _totalSupply);
102     }
103 
104     function transfer(address to, uint256 amount) public returns (bool) {
105         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
106         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
107 
108         balances[msg.sender] = balances[msg.sender].sub(amount);
109         balances[to] = balances[to].add(amount);
110         emit Transfer(msg.sender, to, amount);
111         return true;
112     }
113 
114     function balanceOf(address owner) public view returns (uint256 balance) {
115         return balances[owner];
116     }
117 
118     function transferFrom(
119         address from,
120         address to,
121         uint256 amount
122     ) public returns (bool) {
123         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
124         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
125         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
126 
127         balances[from] = balances[from].sub(amount);
128         balances[to] = balances[to].add(amount);
129         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
130         emit Transfer(from, to, amount);
131         return true;
132     }
133 
134     function approve(address spender, uint256 amount) public returns (bool) {
135         allowed[msg.sender][spender] = amount;
136         emit Approval(msg.sender, spender, amount);
137         return true;
138     }
139 
140     function allowance(address owner, address spender) public view returns (uint256) {
141         return allowed[owner][spender];
142     }
143 }