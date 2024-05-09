1 pragma solidity ^0.4.2;
2 contract owned {
3 	address public owner;
4 	function owned() {
5 		owner = msg.sender;
6 	}
7 	function changeOwner(address newOwner) onlyowner {
8 		owner = newOwner;
9 	}
10 	modifier onlyowner() {
11 		if (msg.sender==owner) _;
12 	}
13 }
14 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
15 contract CSToken is owned {
16 	/* Public variables of the token */
17 	string public standard = 'Token 0.1';
18 	string public name;
19 	string public symbol;
20 	uint8 public decimals;
21 	uint256 public totalSupply;
22 	/* This creates an array with all balances */
23 	mapping (address => uint256) public balanceOf;
24 	mapping (address => mapping (address => uint256)) public allowance;
25 	/* This generates a public event on the blockchain that will notify clients */
26 	event Transfer(address indexed from, address indexed to, uint256 value);
27 	/* Initializes contract with initial supply tokens to the creator of the contract */
28 	function CSToken(
29 	uint256 initialSupply,
30 	string tokenName,
31 	uint8 decimalUnits,
32 	string tokenSymbol
33 	) {
34 		owner = msg.sender;
35 		balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
36 		totalSupply = initialSupply;                        // Update total supply
37 		name = tokenName;                                   // Set the name for display purposes
38 		symbol = tokenSymbol;                               // Set the symbol for display purposes
39 		decimals = decimalUnits;                            // Amount of decimals for display purposes
40 	}
41 	/* Send coins */
42 	function transfer(address _to, uint256 _value) {
43 		if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
44 		if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
45 		balanceOf[msg.sender] -= _value;                     // Subtract from the sender
46 		balanceOf[_to] += _value;                            // Add the same to the recipient
47 		Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
48 	}
49 	function mintToken(address target, uint256 mintedAmount) onlyowner {
50 		balanceOf[target] += mintedAmount;
51 		totalSupply += mintedAmount;
52 		Transfer(0, owner, mintedAmount);
53 		Transfer(owner, target, mintedAmount);
54 	}
55 	/* Allow another contract to spend some tokens in your behalf */
56 	function approve(address _spender, uint256 _value)
57 	returns (bool success) {
58 		allowance[msg.sender][_spender] = _value;
59 		return true;
60 	}
61 	/* Approve and then comunicate the approved contract in a single tx */
62 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
63 	returns (bool success) {
64 		tokenRecipient spender = tokenRecipient(_spender);
65 		if (approve(_spender, _value)) {
66 			spender.receiveApproval(msg.sender, _value, this, _extraData);
67 			return true;
68 		}
69 	}
70 	/* A contract attempts to get the coins */
71 	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
72 		if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
73 		if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
74 		if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
75 		balanceOf[_from] -= _value;                          // Subtract from the sender
76 		balanceOf[_to] += _value;                            // Add the same to the recipient
77 		allowance[_from][msg.sender] -= _value;
78 		Transfer(_from, _to, _value);
79 		return true;
80 	}
81 	/* This unnamed function is called whenever someone tries to send ether to it */
82 	function () {
83 		throw;     // Prevents accidental sending of ether
84 	}
85 }
86 contract Crowdsale is owned{
87         uint public start = 1498651200;
88         uint public currentStage = 0;
89         bool public crowdsaleStarted = false;
90         uint[] public prices;
91         uint[] public tresholds;
92         address public bounties;
93         uint public totalCollected;
94         uint public deadline;
95         uint public presaleDeadline;
96         uint public tokensRaised;
97     
98         uint constant presaleDuration = 19 days;
99         uint constant saleDuration = 29 days;
100         uint tokenMultiplier = 10;
101     
102     
103         CSToken public tokenReward;
104         mapping(address => uint256) public balanceOf;
105         event GoalReached(address beneficiary, uint totalCollected);
106         event FundTransfer(address backer, uint amount, bool isContribution);
107         event NewStage (uint time, uint stage);
108     
109     
110         modifier saleFinished() { if (now < deadline && currentStage < 2) throw; _; }
111         modifier beforeDeadline() { if (now >= deadline) throw; _; }
112 
113 	function Crowdsale(
114 	address _bounties
115 	) {
116 		tokenReward = new CSToken(0, 'MyBit Token', 8, 'MyB');
117 		tokenMultiplier = tokenMultiplier**tokenReward.decimals();
118 		tokenReward.mintToken(_bounties, 1100000 * tokenMultiplier);
119 		presaleDeadline = start + presaleDuration;
120 		deadline = start + presaleDuration + saleDuration;
121 		tresholds.push(1250000 * tokenMultiplier);
122 		tresholds.push(3000000 * tokenMultiplier);
123 		tresholds.push(2**256 - 1);
124 		prices.push(7500 szabo / tokenMultiplier);
125 		prices.push(10 finney / tokenMultiplier);
126 		prices.push(2**256 - 1);
127 
128 
129 		bounties = _bounties;
130 
131 	}
132 
133     
134 	function mint(uint amount, uint tokens, address sender) internal {
135 		balanceOf[sender] += amount;
136 		tokensRaised += tokens;
137 		totalCollected += amount;
138 		tokenReward.mintToken(sender, tokens);
139 		tokenReward.mintToken(owner, tokens * 1333333 / 10000000);
140 		tokenReward.mintToken(bounties, tokens * 1666667 / 10000000);
141 		FundTransfer(sender, amount, true);
142 	}
143 
144 	function processPayment(address from, uint amount) internal beforeDeadline
145 	{
146 		FundTransfer(from, amount, false);
147 		uint price = prices[currentStage];
148 		uint256 tokenAmount = amount / price;
149 		if (tokensRaised + tokenAmount > tresholds[currentStage])
150 		{
151 			uint256 currentTokens = tresholds[currentStage] - tokensRaised;
152 			uint256 currentAmount = currentTokens * price;
153 			mint(currentAmount, currentTokens, from);
154 			currentStage++;
155 			NewStage(now, currentStage);
156 			processPayment(from, amount - currentAmount);
157 			return;
158 		}
159 	        mint(amount, tokenAmount, from);
160 		uint256 change = amount - tokenAmount * price;
161 		if(change > 0)
162 		{
163 			totalCollected -= change;
164 			balanceOf[from] -= change;
165 			if (!from.send(change)){
166 				throw;
167 			}
168 		}
169 	}
170 
171 	function () payable beforeDeadline {
172 		if(now < start) throw;
173 		if(currentStage > 1) throw;
174 		if (crowdsaleStarted){
175 			processPayment(msg.sender, msg.value);
176 		} else {
177 			if (now > presaleDeadline)
178 			{
179 				crowdsaleStarted = true;
180 			} else {
181 				if (msg.value < 1 ether) throw;
182 			}
183 			processPayment(msg.sender, msg.value);    
184         }
185     }
186 
187     function safeWithdrawal() saleFinished {
188         if (bounties == msg.sender) {
189             if (!bounties.send(totalCollected)) {
190                 throw;
191             }
192         }
193     }
194 }