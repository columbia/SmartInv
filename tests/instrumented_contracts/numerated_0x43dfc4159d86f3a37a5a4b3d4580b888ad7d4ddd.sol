1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 
12 /**
13  * @title SafeMath
14  * @author DODO Breeder
15  *
16  * @notice Math operations with safety checks that revert on error
17  */
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "MUL_ERROR");
26 
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         require(b > 0, "DIVIDING_ERROR");
32         return a / b;
33     }
34 
35     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 quotient = div(a, b);
37         uint256 remainder = a - quotient * b;
38         if (remainder > 0) {
39             return quotient + 1;
40         } else {
41             return quotient;
42         }
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a, "SUB_ERROR");
47         return a - b;
48     }
49 
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "ADD_ERROR");
53         return c;
54     }
55 
56     function sqrt(uint256 x) internal pure returns (uint256 y) {
57         uint256 z = x / 2 + 1;
58         y = x;
59         while (z < y) {
60             y = z;
61             z = (x / z + z) / 2;
62         }
63     }
64 }
65 
66 
67 // File: contracts/token/DODOToken.sol
68 
69 /*
70 
71     Copyright 2020 DODO ZOO.
72 
73 */
74 
75 /**
76  * @title DODO Token
77  * @author DODO Breeder
78  */
79 contract DODOToken {
80     using SafeMath for uint256;
81 
82     string public symbol = "DODO";
83     string public name = "DODO bird";
84 
85     uint256 public decimals = 18;
86     uint256 public totalSupply = 1000000000 * 10**18; // 1 Billion
87 
88     mapping(address => uint256) internal balances;
89     mapping(address => mapping(address => uint256)) internal allowed;
90 
91     // ============ Events ============
92 
93     event Transfer(address indexed from, address indexed to, uint256 amount);
94 
95     event Approval(address indexed owner, address indexed spender, uint256 amount);
96 
97     // ============ Functions ============
98 
99     constructor() public {
100         balances[msg.sender] = totalSupply;
101     }
102 
103     /**
104      * @dev transfer token for a specified address
105      * @param to The address to transfer to.
106      * @param amount The amount to be transferred.
107      */
108     function transfer(address to, uint256 amount) public returns (bool) {
109         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
110 
111         balances[msg.sender] = balances[msg.sender].sub(amount);
112         balances[to] = balances[to].add(amount);
113         emit Transfer(msg.sender, to, amount);
114         return true;
115     }
116 
117     /**
118      * @dev Gets the balance of the specified address.
119      * @param owner The address to query the the balance of.
120      * @return balance An uint256 representing the amount owned by the passed address.
121      */
122     function balanceOf(address owner) external view returns (uint256 balance) {
123         return balances[owner];
124     }
125 
126     /**
127      * @dev Transfer tokens from one address to another
128      * @param from address The address which you want to send tokens from
129      * @param to address The address which you want to transfer to
130      * @param amount uint256 the amount of tokens to be transferred
131      */
132     function transferFrom(
133         address from,
134         address to,
135         uint256 amount
136     ) public returns (bool) {
137         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
138         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
139 
140         balances[from] = balances[from].sub(amount);
141         balances[to] = balances[to].add(amount);
142         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
143         emit Transfer(from, to, amount);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * @param spender The address which will spend the funds.
150      * @param amount The amount of tokens to be spent.
151      */
152     function approve(address spender, uint256 amount) public returns (bool) {
153         allowed[msg.sender][spender] = amount;
154         emit Approval(msg.sender, spender, amount);
155         return true;
156     }
157 
158     /**
159      * @dev Function to check the amount of tokens that an owner allowed to a spender.
160      * @param owner address The address which owns the funds.
161      * @param spender address The address which will spend the funds.
162      * @return A uint256 specifying the amount of tokens still available for the spender.
163      */
164     function allowance(address owner, address spender) public view returns (uint256) {
165         return allowed[owner][spender];
166     }
167 }