1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4 //	function totalSupply() public constant returns (uint supply);
5 //	function balanceOf(address who) public constant returns (uint value);
6 //	function allowance(address owner, address spender) public constant returns (uint _allowance);
7 	function transfer(address to, uint value) public returns (bool success);
8 	function transferFrom(address from, address to, uint value) public returns (bool success);
9 	function approve(address spender, uint value) public returns (bool success);
10 
11 	event Transfer(address indexed from, address indexed to, uint value);
12 	event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 /**
16  * Math operations with safety checks
17  */
18 contract SafeMath {
19 
20 	function mul(uint a, uint b) internal pure returns (uint) {
21 		uint c = a * b;
22 		assert(a == 0 || c / a == b);
23 		return c;
24 	}
25 
26 	function div(uint a, uint b) internal pure returns (uint) {
27 		assert(b > 0);
28 		return a / b;
29 	}
30 
31 	function sub(uint a, uint b) internal pure returns (uint) {
32 		assert(b <= a);
33 		return a - b;
34 	}
35 
36 	function add(uint a, uint b) internal pure returns (uint) {
37 		uint c = a + b;
38 		assert(c >= a && c >= b);
39 		return c;
40 	}
41 
42 	function min(uint x, uint y) internal pure returns (uint) {
43 		return x <= y ? x : y;
44 	}
45 
46 	function max(uint x, uint y) internal pure returns (uint) {
47 		return x >= y ? x : y;
48 	}
49 }
50 
51 contract Owned {
52     address public owner;
53 
54     function Owned() public {
55         owner = msg.sender;
56     }
57 
58     modifier onlyOwner {
59         require(msg.sender == owner);
60         _;
61     }
62 
63     function transferOwnership(address newOwner) onlyOwner public {
64         owner = newOwner;
65     }
66 }
67 
68 contract SOPToken is ERC20, SafeMath, Owned {
69 
70 	// Public variables of the token
71 	string public name;
72 	string public symbol;
73 	uint8 public decimals = 18;
74 	// 18 decimals is the strongly suggested default, avoid changing it
75 	uint public totalSupply;
76 
77 	// This creates an array with all balances
78 	mapping(address => uint) public balanceOf;
79 	mapping(address => mapping(address => uint)) public allowance;
80 
81 
82 	mapping(address=>uint) public lock; 
83 	mapping(address=>bool) public freezeIn;
84 	mapping(address=>bool) public freezeOut;
85 	
86 
87 	//event definitions
88 	/* This notifies clients about the amount burnt */
89 	event Burn(address indexed from, uint value);
90 
91 	event FreezeIn(address[] indexed from, bool value);
92 
93 	event FreezeOut(address[] indexed from, bool value);
94 
95 
96 	function SOPToken(string tokenName, string tokenSymbol, uint initSupply) public {
97 		totalSupply=initSupply*10**uint(decimals);      //update total supply
98 		name=tokenName;
99 		symbol=tokenSymbol;
100 
101 		balanceOf[owner]=totalSupply;       //give the owner all initial tokens
102 
103 	}
104 
105 	//ERC 20
106 	///////////////////////////////////////////////////////////////////////////////////////////
107 
108 	function internalTransfer(address from, address toaddr, uint value) internal {
109 		require(toaddr!=0);
110 		require(balanceOf[from]>=value);
111 
112 		require(now>=lock[from]);
113 		require(!freezeIn[toaddr]);
114 		require(!freezeOut[from]);
115 
116 		balanceOf[from]=sub(balanceOf[from], value);
117 		balanceOf[toaddr]=add(balanceOf[toaddr], value);
118 
119 		Transfer(from, toaddr, value);
120 	}
121 
122 	function transfer(address toaddr, uint value) public returns (bool) {
123 		internalTransfer(msg.sender, toaddr, value);
124 
125 		return true;
126 	}
127 	
128 	function transferFrom(address from, address toaddr, uint value) public returns (bool) {
129 		require(allowance[from][msg.sender]>=value);
130 
131 		allowance[from][msg.sender]=sub(allowance[from][msg.sender], value);
132 
133 		internalTransfer(from, toaddr, value);
134 
135 		return true;
136 	}
137 
138 	function approve(address spender, uint amount) public returns (bool) {
139 		require((amount == 0) || (allowance[msg.sender][spender] == 0));
140 		
141 		allowance[msg.sender][spender]=amount;
142 
143 		Approval(msg.sender, spender, amount);
144 
145 		return true;
146 	}
147 
148 	/////////////////////////////////////////////////////////////////////////////////////////
149 
150 	function setNameSymbol(string tokenName, string tokenSymbol) public onlyOwner {
151 		name=tokenName;
152 		symbol=tokenSymbol;
153 	}
154 
155 	////////////////////////////////////////////////////////////////////////////////////////////
156 	function setLock(address[] addrs, uint[] times) public onlyOwner {
157 		require(addrs.length==times.length);
158 
159 		for (uint i=0; i<addrs.length; i++) {
160 			lock[addrs[i]]=times[i];
161 		}
162 	}
163 
164 	function setFreezeIn(address[] addrs, bool value) public onlyOwner {
165 		for (uint i=0; i<addrs.length; i++) {
166 			freezeIn[addrs[i]]=value;
167 		}
168 
169 		FreezeIn(addrs, value);
170 	}
171 
172 	function setFreezeOut(address[] addrs, bool value) public onlyOwner {
173 		for (uint i=0; i<addrs.length; i++) {
174 			freezeOut[addrs[i]]=value;
175 		}
176 
177 		FreezeOut(addrs, value);
178 	}
179 
180 	///////////////////////////////////////////////////////////////////////////////////////////
181 	function mint(uint amount) public onlyOwner {
182 		balanceOf[owner]=add(balanceOf[owner], amount);
183 		totalSupply=add(totalSupply, amount);
184 	}
185 
186 	function burn(uint amount) public {
187 		balanceOf[msg.sender]=sub(balanceOf[msg.sender], amount);
188 		totalSupply=sub(totalSupply, amount);
189 
190 		Burn(msg.sender, amount);
191 	}
192 
193 	///////////////////////////////////////////////////////////////////////////////////////////
194 
195 	function withdrawEther(uint amount) public onlyOwner {
196 		owner.transfer(amount);
197 	}
198 
199 	// can accept ether
200 	function() public payable {
201     }
202 
203 
204 }