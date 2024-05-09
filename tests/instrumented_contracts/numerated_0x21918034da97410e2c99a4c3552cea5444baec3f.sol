1 pragma solidity ^0.4.23;
2 
3 // File: contracts/ERC223.sol
4 
5 contract ERC223 {
6 	
7 	// Get the account balance of another account with address owner
8 	function balanceOf(address owner) public view returns (uint);
9 	
10 	function name() public view returns (string);
11 	function symbol() public view returns (string);
12 	function decimals() public view returns (uint8);
13     function totalSupply() public view returns (uint);
14 
15 	// Needed due to backwards compatibility reasons because of ERC20 transfer function does't have bytes
16 	// parameter. This function must transfer tokens and invoke the function tokenFallback(address, uint256,
17 	// bytes) in to, if to is a contract. If the tokenFallback function is not implemented in to (receiver 
18 	// contract), the transaaction must fail and the transfer of tokens should not occur.
19 	function transfer(address to, uint value) public returns (bool success);
20 
21 	// This function must transfer tokens and invoke the function tokenFallback(address, uint256, bytes) in
22 	// to, if to is a contract. If the tokenFallback function is not implemented in to (receiver contract), then
23 	// the transaction must fail and the transfer of tokens should not occur.
24 	// If to is an externally owned address, then the transaction must be sent without trying to execute
25 	// tokenFallback in to.
26 	// data can be attached to this token transaction it will stay in blockchain forever(requires more gas).
27 	// data can be empty.
28     function transfer(address to, uint value, bytes data) public returns (bool success);
29 
30     //
31     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool success);
32 
33     // Triggered when tokens are transferred.
34     event Transfer(address indexed from, address indexed to, uint indexed value, bytes data);
35 }
36 
37 // File: contracts/ERC223ReceivingContract.sol
38 
39 contract ERC223ReceivingContract { 
40 	
41 	// A function for handling token transfers, which is called from the token contract, when a token holder sends
42 	// tokens. from is the address of the sender of the token, value is the amount of incoming tokens, and data is
43 	// attached data siimilar to msg.data of Ether transactions. It works by analogy with the fallback function of
44 	// Ether transactions and returns nothing.
45     function tokenFallback(address from, uint value, bytes data) public;
46 }
47 
48 // File: contracts/SafeMath.sol
49 
50 /**
51  * Math operations with safety checks
52  */
53 library SafeMath {function mul(uint a, uint b) internal pure returns (uint) {
54     uint c = a * b;
55     assert(a == 0 || c / a == b);
56     return c;
57   }
58 
59   function div(uint a, uint b) internal pure returns (uint) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65 
66   function sub(uint a, uint b) internal pure returns (uint) {
67     assert(b <= a);
68     return a - b;
69   }
70 
71   function add(uint a, uint b) internal pure returns (uint) {
72     uint c = a + b;
73     assert(c >= a);
74     return c;
75   }
76 
77   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
78     return a >= b ? a : b;
79   }
80 
81   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
82         return a < b ? a : b;
83     } 
84 
85     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
86     return a >= b ? a : b;
87     }
88 
89   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
90          return a < b ? a : b;
91   }
92 
93 }
94 
95 // File: contracts/MyToken.sol
96 
97 /*
98  * @title Reference implementation fo the ERC223 standard token.
99  */
100 contract MyToken is ERC223 {
101     using SafeMath for uint;
102 
103     mapping(address => uint) balances; // List of user balances.
104 
105     string public name;
106     string public symbol;
107     uint8 public decimals;
108     uint public totalSupply;
109 
110  
111     constructor(string _name, string _symbol,  uint _totalSupply) public {
112 		name = _name;
113 		symbol = _symbol;
114 		decimals = 18;
115 		totalSupply = _totalSupply * (10 ** uint256(decimals));
116 		balances[msg.sender] = _totalSupply;
117 	}
118 
119     function name() public view returns (string) {
120 		 return name;
121     }
122 
123     function symbol() public view returns (string) {
124 		return symbol;
125 	}
126 
127     function decimals() public view returns (uint8) {
128     	return decimals;
129     }
130 
131     function totalSupply() public view returns (uint) {
132     	return totalSupply;
133     }
134 
135 
136 	function balanceOf(address owner) public view returns (uint) {
137 		return balances[owner];
138 	}
139 
140 	function transfer(address to, uint value, bytes data) public returns (bool) {
141 		if(balanceOf(msg.sender) < value) revert();
142 		// Standard function transfer similar to ERC20 transfer with no data.
143 		// Added due to backwards compatibility reasons.
144 
145 		balances[msg.sender] = balances[msg.sender].sub(value);
146 		balances[to] = balances[to].add(value);
147 		if(isContract(to)) {
148 			ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
149 			receiver.tokenFallback(msg.sender, value, data);
150 		}
151 		emit Transfer(msg.sender, to, value, data);
152 		return true;
153 	}
154 
155 	function transfer(address to, uint value) public returns (bool) {
156 		if(balanceOf(msg.sender) < value) revert();
157 		bytes memory empty;
158 
159 		balances[msg.sender] = balances[msg.sender].sub(value);
160         balances[to] = balances[to].add(value);
161         if(isContract(to)) {
162             ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
163             receiver.tokenFallback(msg.sender, value, empty);
164         }
165         emit Transfer(msg.sender, to, value, empty);
166         return true;
167 	}
168 
169 	function transfer(address to, uint value, bytes data, string customFallback) public returns (bool) {
170 		if(balanceOf(msg.sender) < value) revert();
171 
172 		balances[msg.sender] = balances[msg.sender].sub(value);
173         balances[to] = balances[to].add(value);
174 		if (isContract(to)) {
175             assert(to.call.value(0)(bytes4(keccak256(customFallback)), msg.sender, value, data));
176         }
177         emit Transfer(msg.sender, to, value, data);
178         return true;
179 	}
180 
181 	function isContract(address addr) private view returns (bool) {
182 		uint len;
183 		assembly {
184 			len := extcodesize(addr)
185 		}
186 		return (len > 0);
187 	}
188 }