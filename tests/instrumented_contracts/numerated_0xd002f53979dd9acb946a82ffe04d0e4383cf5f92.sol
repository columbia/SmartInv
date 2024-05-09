1 /*
2 
3     Copyright 2020 UBI.city
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 pragma solidity 0.6.9;
8 pragma experimental ABIEncoderV2;
9 
10 
11 /**
12  * @title SafeMath
13  * @author CITYMAN
14  *
15  * @notice Math operations with safety checks that revert on error
16  */
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
19         if (a == 0) {
20             return 0;
21         }
22 
23         uint256 c = a * b;
24         require(c / a == b, "MUL_ERROR");
25 
26         return c;
27     }
28 
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         require(b > 0, "DIVIDING_ERROR");
31         return a / b;
32     }
33 
34     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 quotient = div(a, b);
36         uint256 remainder = a - quotient * b;
37         if (remainder > 0) {
38             return quotient + 1;
39         } else {
40             return quotient;
41         }
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a, "SUB_ERROR");
46         return a - b;
47     }
48 
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "ADD_ERROR");
52         return c;
53     }
54 
55     function sqrt(uint256 x) internal pure returns (uint256 y) {
56         uint256 z = x / 2 + 1;
57         y = x;
58         while (z < y) {
59             y = z;
60             z = (x / z + z) / 2;
61         }
62     }
63 }
64 
65 
66 
67 /**
68  * @title UBI.city Token
69  * @author CITYMAN
70  */
71 contract UBIcityERC20 {
72     using SafeMath for uint256;
73 
74     string public symbol = "CITY";
75     string public name = "UBICITY";
76 
77     uint256 public decimals = 18;
78     uint256 public totalSupply = 100000000 * 10**18; // 100 million
79 
80     mapping(address => uint256) internal balances;
81     mapping(address => mapping(address => uint256)) internal allowed;
82 
83     // ============ Events ============
84 
85     event Transfer(address indexed from, address indexed to, uint256 amount);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 amount);
88 
89     // ============ Functions ============
90 
91     constructor() public {
92         balances[msg.sender] = totalSupply;
93     }
94 
95     /**
96      * @dev transfer token for a specified address
97      * @param to The address to transfer to.
98      * @param amount The amount to be transferred.
99      */
100     function transfer(address to, uint256 amount) public returns (bool) {
101         require(amount <= balances[msg.sender], "BALANCE_NOT_ENOUGH");
102 
103         balances[msg.sender] = balances[msg.sender].sub(amount);
104         balances[to] = balances[to].add(amount);
105         emit Transfer(msg.sender, to, amount);
106         return true;
107     }
108 
109     /**
110      * @dev Gets the balance of the specified address.
111      * @param owner The address to query the the balance of.
112      * @return balance An uint256 representing the amount owned by the passed address.
113      */
114     function balanceOf(address owner) external view returns (uint256 balance) {
115         return balances[owner];
116     }
117 
118     /**
119      * @dev Transfer tokens from one address to another
120      * @param from address The address which you want to send tokens from
121      * @param to address The address which you want to transfer to
122      * @param amount uint256 the amount of tokens to be transferred
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 amount
128     ) public returns (bool) {
129         require(amount <= balances[from], "BALANCE_NOT_ENOUGH");
130         require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
131 
132         balances[from] = balances[from].sub(amount);
133         balances[to] = balances[to].add(amount);
134         allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
135         emit Transfer(from, to, amount);
136         return true;
137     }
138 
139     /**
140      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
141      * @param spender The address which will spend the funds.
142      * @param amount The amount of tokens to be spent.
143      */
144     function approve(address spender, uint256 amount) public returns (bool) {
145         allowed[msg.sender][spender] = amount;
146         emit Approval(msg.sender, spender, amount);
147         return true;
148     }
149 
150     /**
151      * @dev Function to check the amount of tokens that an owner allowed to a spender.
152      * @param owner address The address which owns the funds.
153      * @param spender address The address which will spend the funds.
154      * @return A uint256 specifying the amount of tokens still available for the spender.
155      */
156     function allowance(address owner, address spender) public view returns (uint256) {
157         return allowed[owner][spender];
158     }
159 }