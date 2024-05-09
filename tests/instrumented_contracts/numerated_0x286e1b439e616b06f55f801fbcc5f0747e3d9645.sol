1 pragma solidity ^0.4.24;
2 
3 // File: contracts\XRUN.sol
4 
5 contract owned {
6 
7 	address public owner;
8 
9 	constructor() public {
10 
11 		owner = msg.sender;
12 	}
13 
14 	modifier onlyOwner {
15 
16 		require(msg.sender == owner);
17 		_;
18 	}
19 
20 	function transferOwnership(address newOwner) onlyOwner public {
21 
22 		owner = newOwner;
23 	}
24 }
25 
26 interface tokenRecipient {
27 
28 	function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
29 }
30 
31 contract TokenERC20 {
32 
33 	string public name;
34 	string public symbol;
35 	uint8 public decimals = 18;
36 	uint256 public totalSupply;
37 
38 	mapping (address => uint256) public balanceOf;
39 	mapping (address => mapping (address => uint256)) public allowance;
40 
41 	event Transfer(address indexed from, address indexed to, uint256 value);
42 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
43 	event Burn(address indexed from, uint256 value);
44 
45 	constructor(
46 		uint256 initialSupply,
47 		string memory tokenName,
48 		string memory tokenSymbol
49 	) public {
50 		totalSupply = initialSupply * 10 ** uint256(decimals);
51 		balanceOf[msg.sender] = totalSupply;
52 		name = tokenName;
53 		symbol = tokenSymbol;
54 	}
55 
56 	function _transfer(address _from, address _to, uint _value) internal {
57 
58 		require(_to != address(0x0));
59 		require(balanceOf[_from] >= _value);
60 		require(balanceOf[_to] + _value > balanceOf[_to]);
61 
62 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
63 		balanceOf[_from] -= _value;
64 		balanceOf[_to] += _value;
65 
66 		emit Transfer(_from, _to, _value);
67 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
68 	}
69 
70 	function transfer(address _to, uint256 _value) public returns (bool success) {
71 
72 		_transfer(msg.sender, _to, _value);
73 
74 		return true;
75 	}
76 
77 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78 
79 		require(_value <= allowance[_from][msg.sender]);
80 
81 		allowance[_from][msg.sender] -= _value;
82 
83 		_transfer(_from, _to, _value);
84 
85 		return true;
86 	}
87 
88 	function approve(address _spender, uint256 _value) public returns (bool success) {
89 
90 		allowance[msg.sender][_spender] = _value;
91 
92 		emit Approval(msg.sender, _spender, _value);
93 
94 		return true;
95 	}
96 
97 	function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
98 
99 		tokenRecipient spender = tokenRecipient(_spender);
100 
101 		if (approve(_spender, _value)) {
102 			spender.receiveApproval(msg.sender, _value, address(this), _extraData);
103 
104 			return true;
105 		}
106 	}
107 
108 	function burn(uint256 _value) public returns (bool success) {
109 
110 		require(balanceOf[msg.sender] >= _value);
111 
112 		balanceOf[msg.sender] -= _value;
113 		totalSupply -= _value;
114 
115 		emit Burn(msg.sender, _value);
116 		return true;
117 	}
118 
119 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
120 
121 		require(balanceOf[_from] >= _value);
122 		require(_value <= allowance[_from][msg.sender]);
123 
124 		balanceOf[_from] -= _value;
125 		allowance[_from][msg.sender] -= _value;
126 		totalSupply -= _value;
127 
128 		emit Burn(_from, _value);
129 		return true;
130 	}
131 }
132 
133 contract XRUN is owned, TokenERC20 {
134 
135 	uint256 public sellPrice;
136 	uint256 public buyPrice;
137 
138 	mapping (address => bool) public frozenAccount;
139 
140 	event FrozenFunds(address target, bool frozen);
141 
142 	constructor(
143 		uint256 initialSupply,
144 		string memory tokenName,
145 		string memory tokenSymbol
146 	) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
147 
148 	function _transfer(address _from, address _to, uint _value) internal {
149 
150 		require(_to != address(0x0));
151 		require(balanceOf[_from] >= _value);
152 		require(balanceOf[_to] + _value >= balanceOf[_to]);
153 		require(!frozenAccount[_from]);
154 		require(!frozenAccount[_to]);
155 
156 		balanceOf[_from] -= _value;
157 		balanceOf[_to] += _value;
158 
159 		emit Transfer(_from, _to, _value);
160 	}
161 
162 	function mintToken(address target, uint256 mintedAmount) onlyOwner public {
163 
164 		balanceOf[target] += mintedAmount;
165 		totalSupply += mintedAmount;
166 
167 		emit Transfer(address(0), address(this), mintedAmount);
168 		emit Transfer(address(this), target, mintedAmount);
169 	}
170 
171 	function freezeAccount(address target, bool freeze) onlyOwner public {
172 
173 		frozenAccount[target] = freeze;
174 
175 		emit FrozenFunds(target, freeze);
176 	}
177 
178 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
179 
180 		sellPrice = newSellPrice;
181 		buyPrice = newBuyPrice;
182 	}
183 
184 	function buy() payable public {
185 
186 		uint amount = msg.value / buyPrice;
187 
188 		_transfer(address(this), msg.sender, amount);
189 	}
190 
191 	function sell(uint256 amount) public {
192 
193 		address myAddress = address(this);
194 
195 		require(myAddress.balance >= amount * sellPrice);
196 
197 		_transfer(msg.sender, address(this), amount);
198 
199 		msg.sender.transfer(amount * sellPrice);
200 	}
201 }