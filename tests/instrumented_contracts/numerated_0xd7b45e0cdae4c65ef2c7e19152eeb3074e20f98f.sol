1 pragma solidity ^0.4.18;
2 
3 interface TokenRecipient {
4 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public;
5 }
6 
7 contract Erc20 { // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
8 	function totalSupply() public constant returns (uint256 amount);
9 	function balanceOf(address owner) public constant returns (uint256 balance);
10 	function transfer(address to, uint256 value) public returns (bool success);
11 	function transferFrom(address from, address to, uint256 value) public returns (bool success);
12 	function approve(address spender, uint256 value) public returns (bool success);
13 	function allowance(address owner, address spender) public constant returns (uint256 remaining);
14 
15 	event Transfer(address indexed from, address indexed to, uint256 value);
16 	event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 contract Erc20Plus is Erc20 {
20 	function approveAndCall(address spender, uint256 value, bytes extraData) public returns (bool success);
21 	function burn(uint256 value) public returns (bool success);
22 	function burnFrom(address from, uint256 value) public returns (bool success);
23 }
24 
25 contract Owned {
26 	address internal _owner;
27 
28 	function Owned() public {
29 		_owner = msg.sender;
30 	}
31 
32 	function kill() public onlyOwner {
33 		selfdestruct(_owner);
34 	}
35 
36 	modifier onlyOwner {
37 		require(msg.sender == _owner);
38 		_;
39 	}
40 
41 	function harvest() onlyOwner public {
42 		_owner.transfer(this.balance);
43 	}
44 
45 	function () public payable {
46 		require(false); // throw
47 	}
48 }
49 
50 contract CreditcoinBase is Owned {
51 //----------- ERC20 members
52 	uint8 public constant decimals = 18;
53 //=========== ERC20 members
54 
55 	uint256 internal constant FRAC_IN1UNIT = 10 ** uint256(decimals);
56 	uint256 public constant creditcoinLimitInFrac = 2000000000 * FRAC_IN1UNIT;
57 	uint256 public constant initialSupplyInFrac = creditcoinLimitInFrac * 30 / 100; // 10% for sale + 15% for Gluwa + 5% for Creditcoin Foundation
58 }
59 
60 /// @title Creditcoin ERC20 token
61 contract Creditcoin is CreditcoinBase, Erc20Plus {
62 //----------- ERC20 members
63 	string public constant name = "Creditcoin";
64 	string public constant symbol = "CRE";
65 //=========== ERC20 members
66 
67 	mapping (address => uint256) internal _balanceOf;
68 	uint256 internal _totalSupply;
69 	mapping (address => mapping (address => uint256)) internal _allowance;
70 
71 	event Burnt(address indexed from, uint256 value);
72 	event Minted(uint256 value);
73 
74 	address public pool;
75 	address internal minter;
76 
77 	function Creditcoin(address icoSalesAccount) public {
78 		_totalSupply = initialSupplyInFrac;
79 		pool = icoSalesAccount;
80 		_balanceOf[pool] = _totalSupply;
81 	}
82 
83 	function _transfer(address from, address to, uint256 value) internal {
84 		require(to != 0x0);
85 		require(_balanceOf[from] >= value);
86 		require(_balanceOf[to] + value > _balanceOf[to]);
87 
88 		uint256 previousBalances = _balanceOf[from] + _balanceOf[to];
89 
90 		_balanceOf[from] -= value;
91 		_balanceOf[to] += value;
92 
93 		Transfer(from, to, value);
94 		assert(_balanceOf[from] + _balanceOf[to] == previousBalances);
95 	}
96 
97 //----------- ERC20 members
98 	function totalSupply() public constant returns (uint256 amount) {
99 		amount = _totalSupply;
100 	}
101 	
102 	function balanceOf(address owner) public constant returns (uint256 balance) {
103 		balance = _balanceOf[owner];
104 	}
105 	
106 	function allowance(address owner, address spender) public constant returns (uint256 remaining) {
107 		remaining = _allowance[owner][spender];
108 	}
109 	
110 	function transfer(address to, uint256 value) public returns (bool success) {
111 		_transfer(msg.sender, to, value);
112 		success = true;
113 	}
114 
115 	function transferFrom(address from, address to, uint256 value) public returns (bool success) {
116 		require(value <= _allowance[from][msg.sender]);
117 		_allowance[from][msg.sender] -= value;
118 		_transfer(from, to, value);
119 		success = true;
120 	}
121 
122 	function approve(address spender, uint256 value) public returns (bool success) {
123 		_allowance[msg.sender][spender] = value;
124 		success = true;
125 	}
126 //=========== ERC20 members
127 
128 	function approveAndCall(address spender, uint256 value, bytes extraData) public returns (bool success) {
129 		TokenRecipient recepient = TokenRecipient(spender);
130 		if (approve(spender, value)) {
131 			recepient.receiveApproval(msg.sender, value, this, extraData);
132 			success = true;
133 		}
134 	}
135 
136 	function burn(uint256 value) public returns (bool success) {
137 		require(_balanceOf[msg.sender] >= value);
138 		_balanceOf[msg.sender] -= value;
139 		_totalSupply -= value;
140 
141 		Burnt(msg.sender, value);
142 		success = true;
143 	}
144 
145 	function burnFrom(address from, uint256 value) public returns (bool success) {
146 		require(_balanceOf[from] >= value);
147 		require(value <= _allowance[from][msg.sender]);
148 		_balanceOf[from] -= value;
149 		_allowance[from][msg.sender] -= value;
150 		_totalSupply -= value;
151 
152 		Burnt(from, value);
153 		success = true;
154 	}
155 
156 	/// this function allows to mint coins up to totalSupply, so if coins were burnt it adds room for minting
157 	/// since natural loss of coins is expected the overall amount in use will be less than totalSupply
158 	function mint(uint256 amount) public returns (bool success) {
159 		require(msg.sender == minter);
160 		require(creditcoinLimitInFrac > amount && creditcoinLimitInFrac - amount >= _totalSupply);
161 		require(_balanceOf[msg.sender] + amount > _balanceOf[msg.sender]);
162 		_balanceOf[msg.sender] += amount;
163 		_totalSupply += amount;
164 
165 		Minted(amount);
166 		success = true;
167 	}
168 
169 	function setMinter(address newMinter) onlyOwner public returns (bool success) {
170 		minter = newMinter;
171 		success = true;
172 	}
173 }