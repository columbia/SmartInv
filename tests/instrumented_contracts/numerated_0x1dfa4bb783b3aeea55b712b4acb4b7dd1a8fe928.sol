1 pragma solidity ^0.4.18;
2 
3 contract ERC20 {
4 	uint public totalSupply;
5 	function balanceOf(address _owner) public constant returns (uint balance);
6 	function transfer(address _to, uint256 _value) public returns (bool success);
7 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
8 	function approve(address _spender, uint256 _value) public returns (bool success);
9 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
20 		uint256 c = a * b;
21 		assert(a == 0 || c / a == b);
22 		return c;
23 	}
24 
25 	/* function div(uint256 a, uint256 b) internal constant returns (uint256) {
26 		// assert(b > 0); // Solidity automatically throws when dividing by 0
27 		uint256 c = a / b;
28 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 		return c;
30 	} */
31 
32 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
33 		assert(b <= a);
34 		return a - b;
35 	}
36 
37 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
38 		uint256 c = a + b;
39 		assert(c >= a);
40 		return c;
41 	}
42 }
43 
44 contract ERC20Token is ERC20 {
45 	using SafeMath for uint256;
46 
47 	mapping (address => uint) balances;
48 	mapping (address => mapping (address => uint256)) allowed;
49 
50 	modifier onlyPayloadSize(uint size) {
51 		require(msg.data.length >= (size + 4));
52 		_;
53 	}
54 
55 	function () public{
56 		revert();
57 	}
58 
59 	function balanceOf(address _owner) public constant returns (uint balance) {
60 		return balances[_owner];
61 	}
62 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
63 		return allowed[_owner][_spender];
64 	}
65 
66 	function transfer(address _to, uint _value) public onlyPayloadSize(2 * 32) returns (bool success) {
67 		_transferFrom(msg.sender, _to, _value);
68 		return true;
69 	}
70 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
71 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
72 		_transferFrom(_from, _to, _value);
73 		return true;
74 	}
75 	function _transferFrom(address _from, address _to, uint256 _value) internal {
76 		require(_value > 0);
77 		balances[_from] = balances[_from].sub(_value);
78 		balances[_to] = balances[_to].add(_value);
79 		Transfer(_from, _to, _value);
80 	}
81 
82 	function approve(address _spender, uint256 _value) public returns (bool) {
83 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
84 		allowed[msg.sender][_spender] = _value;
85 		Approval(msg.sender, _spender, _value);
86 		return true;
87 	}
88 }
89 
90 contract owned {
91 	address public owner;
92 
93 	function owned() public {
94 		owner = msg.sender;
95 	}
96 
97 	modifier onlyOwner {
98 		require(msg.sender == owner);
99 		_;
100 	}
101 
102 	function transferOwnership(address newOwner) public onlyOwner {
103 		owner = newOwner;
104 	}
105 }
106 
107 contract ZodiaqToken is ERC20Token, owned {
108 	string public name = 'Zodiaq Token';
109 	string public symbol = 'ZOD';
110 	uint8 public decimals = 6;
111 
112 	uint256 public totalSupply = 50000000000000;		// 50000000 * 1000000(6 decimal)
113 
114 	address public reservationWallet;
115 	uint256 public reservationSupply = 11000000000000;	// 11000000 * 1000000(6 decimal)
116 
117 	address public bountyWallet;
118 	uint256 public bountySupply = 2000000000000;		// 2000000 * 1000000(6 decimal)
119 
120 	address public teamWallet;
121 	uint256 public teamSupply = 3500000000000;			// 3500000 * 1000000(6 decimal)
122 
123 	address public partnerWallet;
124 	uint256 public partnerSupply = 3500000000000;		// 3500000 * 1000000(6 decimal)
125 
126 	address public currentIcoWallet;
127 	uint256 public currentIcoSupply;
128 
129 
130 	function ZodiaqToken () public {
131 		balances[this] = totalSupply;
132 	}
133 
134 	function setWallets(address _reservationWallet, address _bountyWallet, address _teamWallet, address _partnerWallet) public onlyOwner {
135 		reservationWallet = _reservationWallet;
136 		bountyWallet = _bountyWallet;
137 		teamWallet = _teamWallet;
138 		partnerWallet = _partnerWallet;
139 
140 		_transferFrom(this, reservationWallet, reservationSupply);
141 		_transferFrom(this, bountyWallet, bountySupply);
142 		_transferFrom(this, teamWallet, teamSupply);
143 		_transferFrom(this, partnerWallet, partnerSupply);
144 	}
145 
146 	// Private Token Sale - 10000000000000;	// 10000000 * 1000000(6 decimal)
147 	// Pre-Ico Token Sale - 5000000000000;	//  5000000 * 1000000(6 decimal)
148 	// Ico Token Sale	  - 15000000000000;	// 15000000 * 1000000(6 decimal)
149 	function setICO(address icoWallet, uint256 IcoSupply) public onlyOwner {
150 		allowed[this][icoWallet] = IcoSupply;
151 		Approval(this, icoWallet, IcoSupply);
152 		// _transferFrom(this, icoWallet, IcoSupply);
153 
154 		currentIcoWallet = icoWallet;
155 		currentIcoSupply = IcoSupply;
156 	}
157 
158 	function mintToken(uint256 mintedAmount) public onlyOwner {
159 		totalSupply = totalSupply.add(mintedAmount);
160 		balances[this] = balances[this].add(mintedAmount);
161 	}
162 
163 	function burnBalance() public onlyOwner {
164 		balances[this] = 0;
165 	}
166 }
167 
168 contract ZodiaqICO is owned {
169 	string public name;
170 
171 	uint256 public saleStart;
172 	uint256 public saleEnd;
173 
174 	uint256 public tokenPrice;
175 
176 	ZodiaqToken public token;
177 
178 	function balance() public constant returns (uint256 tokens) {
179 		return token.allowance(token, this);
180 	}
181 
182 	function active() public constant returns (bool yes){
183 		return ((now > saleStart) && (now < saleEnd));
184 	}
185 
186 	function canBuy() public constant returns (bool yes){
187 		return active();
188 	}
189 
190 	function getBonus() public constant returns (uint256 bonus){
191 		return 0;
192 	}
193 
194 	function stopForce() public onlyOwner {
195 		saleEnd = now;
196 	}
197 
198 	function sendTokens(address _to, uint tokens) public onlyOwner {
199 		require(active() && token.transferFrom(token, _to, tokens));
200 	}
201 }
202 
203 contract ZodiaqPrivateTokenSale is ZodiaqICO {
204 
205 	function ZodiaqPrivateTokenSale (
206 		// address tokenAddress
207 	) public {
208 		// token = ZodiaqToken(tokenAddress);
209 		token = ZodiaqToken(0x6488ab8f1DF285d5B70CCF57A489CD27888a4d14);
210 
211 		name = 'Private Token Sale';
212 		saleStart = 1511989200;		// 2017-11-30 00:00:00
213 		saleEnd = 1519938000;		// 2018-03-02 00:00:00
214 	}
215 
216 	function () public payable {
217 		revert();
218 	}
219 
220 	function canBuy() public constant returns (bool yes){
221 		return false;
222 	}
223 }