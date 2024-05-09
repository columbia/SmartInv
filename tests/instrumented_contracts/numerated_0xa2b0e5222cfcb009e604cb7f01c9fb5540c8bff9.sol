1 /**
2  *Submitted for verification at BscScan.com on 2021-07-01
3 */
4 
5 // File: contracts/lib/SafeMath.sol
6 
7 /*
8 
9     Copyright 2020 DODO ZOO.
10     SPDX-License-Identifier: Apache-2.0
11 
12 */
13 
14 pragma solidity 0.6.9;
15 
16 
17 /**
18  * @title SafeMath
19  * @author DODO Breeder
20  *
21  * @notice Math operations with safety checks that revert on error
22  */
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "MUL_ERROR");
31 
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         require(b > 0, "DIVIDING_ERROR");
37         return a / b;
38     }
39 
40     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 quotient = div(a, b);
42         uint256 remainder = a - quotient * b;
43         if (remainder > 0) {
44             return quotient + 1;
45         } else {
46             return quotient;
47         }
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         require(b <= a, "SUB_ERROR");
52         return a - b;
53     }
54 
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "ADD_ERROR");
58         return c;
59     }
60 
61     function sqrt(uint256 x) internal pure returns (uint256 y) {
62         uint256 z = x / 2 + 1;
63         y = x;
64         while (z < y) {
65             y = z;
66             z = (x / z + z) / 2;
67         }
68     }
69 }
70 
71 // File: contracts/external/ERC20/InitializableERC20.sol
72 
73 
74 
75 contract InitializableERC20 {
76     using SafeMath for uint256;
77 
78     string public name;
79     uint8 public decimals;
80     string public symbol;
81     uint256 public totalSupply;
82 
83     bool public initialized;
84 
85     mapping(address => uint256) balances;
86     mapping(address => mapping(address => uint256)) internal allowed;
87 
88     event Transfer(address indexed from, address indexed to, uint256 amount);
89     event Approval(address indexed owner, address indexed spender, uint256 amount);
90 
91     function init(
92         address _creator,
93         uint256 _totalSupply,
94         string memory _name,
95         string memory _symbol,
96         uint8 _decimals
97     ) public {
98         require(!initialized, "TOKEN_INITIALIZED");
99         initialized = true;
100         totalSupply = _totalSupply;
101         balances[_creator] = _totalSupply;
102         name = _name;
103         symbol = _symbol;
104         decimals = _decimals;
105         emit Transfer(address(0), _creator, _totalSupply);
106     }
107 
108     function transfer(address to, uint256 amount) public returns (bool) {
109         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
110         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
111 
112         balances[msg.sender] = balances[msg.sender].sub(amount);
113         balances[to] = balances[to].add(amount);
114         emit Transfer(msg.sender, to, amount);
115         return true;
116     }
117 
118     function balanceOf(address owner) public view returns (uint256 balance) {
119         return balances[owner];
120     }
121 
122     function transferFrom(
123         address from,
124         address to,
125         uint256 amount
126     ) public returns (bool) {
127         require(to != address(0), "TO_ADDRESS_IS_EMPTY");
128         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
129         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
130 
131         balances[from] = balances[from].sub(amount);
132         balances[to] = balances[to].add(amount);
133         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
134         emit Transfer(from, to, amount);
135         return true;
136     }
137 
138     function approve(address spender, uint256 amount) public returns (bool) {
139         allowed[msg.sender][spender] = amount;
140         emit Approval(msg.sender, spender, amount);
141         return true;
142     }
143 
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return allowed[owner][spender];
146     }
147 }