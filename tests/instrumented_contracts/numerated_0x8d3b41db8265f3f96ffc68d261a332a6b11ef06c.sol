1 pragma solidity ^0.4.8;
2 
3 contract admined {
4 	address public admin;
5 
6 	function admined() public {
7 		admin = msg.sender;
8 	}
9 
10 	modifier onlyAdmin(){
11 		require(msg.sender == admin) ;
12 		_;
13 	}
14 
15 	function transferAdminship(address newAdmin) onlyAdmin public  {
16 		admin = newAdmin;
17 	}
18 
19 }
20 
21 contract Topscoin {
22 
23 	mapping (address => uint256) public balanceOf;
24 	mapping (address => mapping (address => uint256)) public allowance;
25 	// balanceOf[address] = 5;
26 	string public standard = "Topscoin v1.0";
27 	string public name;
28 	string public symbol;
29 	uint8 public decimals; 
30 	uint256 public totalSupply;
31 	event Transfer(address indexed from, address indexed to, uint256 value);
32 
33 
34 	function Topscoin(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits) public {
35 		balanceOf[msg.sender] = initialSupply;
36 		totalSupply = initialSupply;
37 		decimals = decimalUnits;
38 		symbol = tokenSymbol;
39 		name = tokenName;
40 	}
41 
42 	function transfer(address _to, uint256 _value) public {
43 		require(balanceOf[msg.sender] > _value) ;
44 		require(balanceOf[_to] + _value > balanceOf[_to]) ;
45 		//if(admin)
46 
47 		balanceOf[msg.sender] -= _value;
48 		balanceOf[_to] += _value;
49 		Transfer(msg.sender, _to, _value);
50 	}
51 
52 	function approve(address _spender, uint256 _value) public returns (bool success){
53 		allowance[msg.sender][_spender] = _value;
54 		return true;
55 	}
56 
57 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
58 		require(balanceOf[_from] > _value) ;
59 		require(balanceOf[_to] + _value > balanceOf[_to]) ;
60 		require(_value < allowance[_from][msg.sender]) ;
61 		balanceOf[_from] -= _value;
62 		balanceOf[_to] += _value;
63 		allowance[_from][msg.sender] -= _value;
64 		Transfer(_from, _to, _value);
65 		return true;
66 
67 	}
68 }
69 
70 contract TopscoinAdvanced is admined, Topscoin{
71 
72 	uint256 minimumBalanceForAccounts = 5 finney;
73 	uint256 public sellPrice;
74 	uint256 public buyPrice;
75 	mapping (address => bool) public frozenAccount;
76 
77 	event FrozenFund(address target, bool frozen);
78 
79 	function TopscoinAdvanced(uint256 initialSupply, string tokenName, string tokenSymbol, uint8 decimalUnits, address centralAdmin) Topscoin (0, tokenName, tokenSymbol, decimalUnits ) public {
80 		
81 		if(centralAdmin != 0)
82 			admin = centralAdmin;
83 		else
84 			admin = msg.sender;
85 		balanceOf[admin] = initialSupply;
86 		totalSupply = initialSupply;	
87 	}
88 
89 	function mintToken(address target, uint256 mintedAmount) onlyAdmin public {
90 		balanceOf[target] += mintedAmount;
91 		totalSupply += mintedAmount;
92 		Transfer(0, this, mintedAmount);
93 		Transfer(this, target, mintedAmount);
94 	}
95 
96 	function freezeAccount(address target, bool freeze) onlyAdmin public {
97 		frozenAccount[target] = freeze;
98 		FrozenFund(target, freeze);
99 	}
100 
101 	function transfer(address _to, uint256 _value) public {
102 		if(msg.sender.balance < minimumBalanceForAccounts)
103 		sell((minimumBalanceForAccounts - msg.sender.balance)/sellPrice);
104 
105 		require(frozenAccount[msg.sender]) ;
106 		require(balanceOf[msg.sender] > _value) ;
107 		require(balanceOf[_to] + _value > balanceOf[_to]) ;
108 		//if(admin)
109 
110 		balanceOf[msg.sender] -= _value;
111 		balanceOf[_to] += _value;
112 		Transfer(msg.sender, _to, _value);
113 	}
114 
115 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
116 		require(frozenAccount[_from]) ;
117 		require(balanceOf[_from] > _value) ;
118 		require(balanceOf[_to] + _value > balanceOf[_to]) ;
119 		require(_value < allowance[_from][msg.sender]) ;
120 		balanceOf[_from] -= _value;
121 		balanceOf[_to] += _value;
122 		allowance[_from][msg.sender] -= _value;
123 		Transfer(_from, _to, _value);
124 		return true;
125 
126 	}
127 
128 	function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyAdmin public {
129 		sellPrice = newSellPrice;
130 		buyPrice = newBuyPrice;
131 	}
132 
133 	function buy() payable  public {
134 		uint256 amount = (msg.value/(1 ether)) / buyPrice;
135 		require(balanceOf[this] > amount) ;
136 		balanceOf[msg.sender] += amount;
137 		balanceOf[this] -= amount;
138 		Transfer(this, msg.sender, amount);
139 	}
140 
141 	function sell(uint256 amount) public {
142 		require(balanceOf[msg.sender] > amount) ;
143 		balanceOf[this] +=amount;
144 		balanceOf[msg.sender] -= amount;
145 		if(!msg.sender.send(amount * sellPrice * 1 ether)){
146 			revert();
147 		} else {
148 			Transfer(msg.sender, this, amount);
149 		}
150 	}
151 
152 	function giveBlockreward() public {
153 		balanceOf[block.coinbase] += 1;
154 	}
155 
156 	bytes32 public currentChallenge;
157 	uint public timeOfLastProof;
158 	uint public difficulty = 10**32;
159 
160 	function proofOfWork(uint nonce) public {
161 		bytes8 n = bytes8(keccak256(nonce, currentChallenge));
162 
163 		require(n > bytes8(difficulty)) ;
164 		uint timeSinceLastBlock = (now - timeOfLastProof);
165 		require(timeSinceLastBlock > 5 seconds) ;
166 
167 		balanceOf[msg.sender] += timeSinceLastBlock / 60 seconds;
168 		difficulty = difficulty * 10 minutes / timeOfLastProof + 1;
169 		timeOfLastProof = now;
170 		currentChallenge = keccak256(nonce, currentChallenge, block.blockhash(block.number-1));
171  	}
172 
173 
174 
175 
176 
177 }