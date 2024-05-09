1 // ----------------------------------------------------------------------------
2 // YUN token contract
3 //
4 // (c) 2019 BITPoint APEC
5 // ----------------------------------------------------------------------------
6 
7 pragma solidity ^0.4.18;
8 
9 contract SafeMath
10 {
11 	function safeAdd(uint a, uint b) public pure returns (uint c)
12 	{
13 		c = a + b;
14 		require(c >= a);
15 	}
16 	
17 	function safeSub(uint a, uint b) public pure returns (uint c)
18 	{
19 		require(b <= a);
20 		c = a - b;
21 	}
22 	
23 	function safeMul(uint a, uint b) public pure returns (uint c)
24 	{
25 		c = a * b;
26 		require(a == 0 || c / a == b);
27 	}
28 	
29 	function safeDiv(uint a, uint b) public pure returns (uint c)
30 	{
31 		require(b > 0);
32 		c = a / b;
33 	}
34 }
35 
36 
37 contract Owned
38 {
39 	address public owner;
40 	address public newOwner;
41 	
42 	event OwnershipTransferred
43 	(
44 		address indexed owner,
45 		address indexed newOwner
46 	);
47 	
48 	constructor() public
49 	{
50 		owner = msg.sender;
51 	}
52 	
53 	modifier onlyOwner
54 	{
55 		require(msg.sender == owner);
56 		_;
57 	}
58 	
59 	function transferOwnership(address _newOwner) onlyOwner public
60 	{
61 		newOwner = _newOwner;
62 	}
63 	
64 	function acceptOwnership() public
65 	{
66 		require(msg.sender == newOwner);
67 		emit OwnershipTransferred(owner, newOwner);
68 		owner = newOwner;
69 		newOwner = address(0);
70 	}
71 }
72 
73 
74 contract ERC20Interface
75 {
76 	function totalSupply() public view returns (uint);
77 	function balanceOf(address tokenOwner) public view returns (uint balance);
78 	function allowance(address tokenOwner, address spender) public view returns (uint remaining);
79 	function transfer(address to, uint tokens) public returns (bool success);
80 	function approve(address spender, uint tokens) public returns (bool success);
81 	function transferFrom(address from, address to, uint tokens) public returns (bool success);
82 
83 	event Transfer
84 	(
85 		address indexed from,
86 		address indexed to,
87 		uint tokens
88 	);
89 	
90 	event Approval
91 	(
92 		address indexed tokenOwner,
93 		address indexed spender,
94 		uint tokens
95 	);
96 }
97 
98 
99 contract StandardERC20Token is ERC20Interface, SafeMath
100 {
101 	string public name;
102 	string public symbol;
103 	uint8 public decimals = 18;
104 	uint256 public totalSupply;
105 	
106 	mapping(address => bool) frozen;
107 	mapping(address => uint) balanceOfAddress;
108 	mapping(address => mapping(address => uint)) allowed;
109 	
110 	constructor(string _tokenName, string _tokenSymbol) public
111 	{
112 		name = _tokenName;
113 		symbol = _tokenSymbol;
114 	}
115 	
116 	function totalSupply() public view returns (uint)
117 	{
118 		return totalSupply - balanceOfAddress[address(0)];
119 	}
120 	
121 	function balanceOf(address tokenOwner) public view returns (uint balance)
122 	{
123 		return balanceOfAddress[tokenOwner];
124 	}
125 	
126 	function allowance(address tokenOwner, address spender) public view returns (uint remaining)
127 	{
128 		return allowed[tokenOwner][spender];
129 	}
130 	
131 	function transfer(address to, uint tokens) public returns (bool success)
132 	{
133 		require(to != address(0));
134 		require(!frozen[msg.sender]);
135 		require(!frozen[to]);
136 		balanceOfAddress[msg.sender] = safeSub(balanceOfAddress[msg.sender], tokens);
137 		balanceOfAddress[to] = safeAdd(balanceOfAddress[to], tokens);
138 		emit Transfer(msg.sender, to, tokens);
139 		return true;
140 	}
141 	
142 	function approve(address spender, uint tokens) public returns (bool success)
143 	{
144 		allowed[msg.sender][spender] = tokens;
145 		emit Approval(msg.sender, spender, tokens);
146 		return true;
147 	}
148 	
149 	function transferFrom(address from, address to, uint tokens) public returns (bool success)
150 	{
151 		require(to != address(0));
152 		require(!frozen[msg.sender]);
153 		require(!frozen[to]);
154 		balanceOfAddress[from] = safeSub(balanceOfAddress[from], tokens);
155 		allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
156 		balanceOfAddress[to] = safeAdd(balanceOfAddress[to], tokens);
157 		emit Transfer(from, to, tokens);
158 		return true;
159 	}
160 
161 	function isFrozenAccount(address target) public constant returns (bool freezed)
162 	{
163 		return frozen[target];
164 	}
165 }
166 
167 
168 contract YUNToken is StandardERC20Token, Owned
169 {
170 	address public vault;
171 	address public wallet;
172 	bool public isBurnable = true;
173 	
174 	event FreezeAccount
175 	(
176 		address indexed target,
177 		bool freezed
178 	);
179 
180 	event WalletChanged
181 	(
182 		address indexed oldWallet,
183 		address indexed newWallet
184 	);
185 
186 	constructor
187 	(
188 		string tokenName,
189 		string tokenSymbol,
190 		uint256 initialSupply,
191 		address _vault,
192 		address _wallet
193 	) StandardERC20Token(tokenName, tokenSymbol) public
194 	{
195 		require(vault == address(0));
196 		require(_vault != address(0));
197 		
198 		totalSupply = initialSupply * 10 ** uint256(decimals);
199 		vault = _vault;
200 		wallet = _wallet;
201 		balanceOfAddress[vault] = totalSupply;
202 	}
203 
204 	function freezeAccount(address target) onlyOwner public
205 	{
206 		require(target != owner);
207 		frozen[target] = true;
208 		emit FreezeAccount(target, true);
209 	}
210 
211 	function unfreezeAccount(address target) onlyOwner public
212 	{
213 		frozen[target] = false;
214 		emit FreezeAccount(target, false);
215 	}
216 	
217 	function setWallet(address newWallet) onlyOwner public
218 	{
219 		require(newWallet != address(0));
220 		emit WalletChanged(wallet, newWallet);
221 		wallet = newWallet;
222 	}
223 
224 	function () public payable
225 	{
226 		 wallet.transfer(msg.value);
227 	}
228 	
229 	function transferAnyERC20Token(address tokenAddress, uint tokens) onlyOwner public returns (bool success) {
230 		return ERC20Interface(tokenAddress).transfer(vault, tokens);
231 	}
232 }