1 pragma solidity ^0.6.12;
2 // SPDX-License-Identifier: agpl-3.0
3 
4 library SafeMath {
5 
6     function mul(uint a, uint b) internal pure returns (uint) {
7         uint c = a * b;
8         require(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint a, uint b) internal pure returns (uint) {
13         require(b > 0);
14         uint c = a / b;
15         require(a == b * c + a % b);
16         return c;
17     }
18 
19     function sub(uint a, uint b) internal pure returns (uint) {
20         require(b <= a);
21         return a - b;
22     }
23 
24     function add(uint a, uint b) internal pure returns (uint) {
25         uint c = a + b;
26         require(c >= a);
27         return c;
28     }
29 
30     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
31         return a >= b ? a : b;
32     }
33 
34     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
35         return a < b ? a : b;
36     }
37 
38     function max256(uint a, uint b) internal pure returns (uint) {
39         return a >= b ? a : b;
40     }
41 
42     function min256(uint a, uint b) internal pure returns (uint) {
43         return a < b ? a : b;
44     }
45 }
46 
47 // NOTE: this interface lacks return values for transfer/transferFrom/approve on purpose,
48 // as we use the SafeERC20 library to check the return value
49 interface GeneralERC20 {
50 	function transfer(address to, uint256 amount) external;
51 	function transferFrom(address from, address to, uint256 amount) external;
52 	function approve(address spender, uint256 amount) external;
53 	function balanceOf(address spender) external view returns (uint);
54 	function allowance(address owner, address spender) external view returns (uint);
55 }
56 
57 library SafeERC20 {
58 	function checkSuccess()
59 		private
60 		pure
61 		returns (bool)
62 	{
63 		uint256 returnValue = 0;
64 
65 		assembly {
66 			// check number of bytes returned from last function call
67 			switch returndatasize()
68 
69 			// no bytes returned: assume success
70 			case 0x0 {
71 				returnValue := 1
72 			}
73 
74 			// 32 bytes returned: check if non-zero
75 			case 0x20 {
76 				// copy 32 bytes into scratch space
77 				returndatacopy(0x0, 0x0, 0x20)
78 
79 				// load those bytes into returnValue
80 				returnValue := mload(0x0)
81 			}
82 
83 			// not sure what was returned: don't mark as success
84 			default { }
85 		}
86 
87 		return returnValue != 0;
88 	}
89 
90 	function transfer(address token, address to, uint256 amount) internal {
91 		GeneralERC20(token).transfer(to, amount);
92 		require(checkSuccess());
93 	}
94 
95 	function transferFrom(address token, address from, address to, uint256 amount) internal {
96 		GeneralERC20(token).transferFrom(from, to, amount);
97 		require(checkSuccess());
98 	}
99 
100 	function approve(address token, address spender, uint256 amount) internal {
101 		GeneralERC20(token).approve(spender, amount);
102 		require(checkSuccess());
103 	}
104 }
105 
106 contract ADXToken {
107 	using SafeMath for uint;
108 
109 	// Constants
110 	string public constant name = "AdEx Network";
111 	string public constant symbol = "ADX";
112 	uint8 public constant decimals = 18;
113 
114 	// Mutable variables
115 	uint public totalSupply;
116 	mapping(address => uint) balances;
117 	mapping(address => mapping(address => uint)) allowed;
118 
119 	event Approval(address indexed owner, address indexed spender, uint amount);
120 	event Transfer(address indexed from, address indexed to, uint amount);
121 
122 	address public supplyController;
123 	address public immutable PREV_TOKEN;
124 
125 	constructor(address supplyControllerAddr, address prevTokenAddr) public {
126 		supplyController = supplyControllerAddr;
127 		PREV_TOKEN = prevTokenAddr;
128 	}
129 
130 	function balanceOf(address owner) external view returns (uint balance) {
131 		return balances[owner];
132 	}
133 
134 	function transfer(address to, uint amount) external returns (bool success) {
135 		balances[msg.sender] = balances[msg.sender].sub(amount);
136 		balances[to] = balances[to].add(amount);
137 		emit Transfer(msg.sender, to, amount);
138 		return true;
139 	}
140 
141 	function transferFrom(address from, address to, uint amount) external returns (bool success) {
142 		balances[from] = balances[from].sub(amount);
143 		allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
144 		balances[to] = balances[to].add(amount);
145 		emit Transfer(from, to, amount);
146 		return true;
147 	}
148 
149 	function approve(address spender, uint amount) external returns (bool success) {
150 		allowed[msg.sender][spender] = amount;
151 		emit Approval(msg.sender, spender, amount);
152 		return true;
153 	}
154 
155 	function allowance(address owner, address spender) external view returns (uint remaining) {
156 		return allowed[owner][spender];
157 	}
158 
159 	// Supply control
160 	function innerMint(address owner, uint amount) internal {
161 		totalSupply = totalSupply.add(amount);
162 		balances[owner] = balances[owner].add(amount);
163 		// Because of https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md#transfer-1
164 		emit Transfer(address(0), owner, amount);
165 	}
166 
167 	function mint(address owner, uint amount) external {
168 		require(msg.sender == supplyController, 'NOT_SUPPLYCONTROLLER');
169 		innerMint(owner, amount);
170 	}
171 
172 	function changeSupplyController(address newSupplyController) external {
173 		require(msg.sender == supplyController, 'NOT_SUPPLYCONTROLLER');
174 		supplyController = newSupplyController;
175 	}
176 
177 	// Swapping: multiplier is 10**(18-4)
178 	// NOTE: Burning by sending to 0x00 is not possible with many ERC20 implementations, but this one is made specifically for the old ADX
179 	uint constant PREV_TO_CURRENT_TOKEN_MULTIPLIER = 100000000000000;
180 	function swap(uint prevTokenAmount) external {
181 		innerMint(msg.sender, prevTokenAmount.mul(PREV_TO_CURRENT_TOKEN_MULTIPLIER));
182 		SafeERC20.transferFrom(PREV_TOKEN, msg.sender, address(0), prevTokenAmount);
183 	}
184 }