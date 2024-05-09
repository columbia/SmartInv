1 pragma solidity ^0.4.2;
2 contract tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
3 
4 contract owned {
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         if (msg.sender != owner) throw;
13         _;
14     }
15 }
16 
17 contract Quitcoin is owned {
18 /* Public variables of the token */
19     string public standard = 'Token 0.1';
20     string public name = "Quitcoin";
21     string public symbol = "QUIT";
22     uint8 public decimals;
23     uint256 public totalSupply;
24     uint public timeOfLastDistribution;
25     uint256 public rateOfEmissionPerYear;
26     address[] public arrayOfNonTrivialAccounts;
27     uint256 public trivialThreshold;
28 
29     bytes32 public currentChallenge = 1;
30     uint public timeOfLastProof;
31     uint public difficulty = 10**77;
32     uint public max = 2**256-1;
33     uint public numclaimed = 0;
34     address[] public arrayOfAccountsThatHaveClaimed;
35 
36     uint public ownerDailyWithdrawal = 0;
37     uint public timeOfLastOwnerWithdrawal = 0;
38 
39     /* This creates an array with all balances */
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42     mapping (address => bool) public frozenAccount;
43     mapping (address => bool) public accountClaimedReward;
44 
45 
46     /* This generates a public event on the blockchain that will notify clients */
47     event Transfer(address indexed _from, address indexed _to, uint256 _value);
48 
49     event FrozenFunds(address target, bool frozen);
50     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
51 
52     /* Initializes contract with initial supply tokens to the creator of the contract */
53     function Quitcoin() {
54         balanceOf[msg.sender] = 324779816*10**10;              // Give the creator all initial tokens
55         totalSupply = 324779816*10**10;                        // Update total supply
56         decimals = 10;                            // Amount of decimals for display purposes
57 	timeOfLastDistribution = now;
58 	rateOfEmissionPerYear = 6773979019428571428;
59 	trivialThreshold = 10**8;
60 	arrayOfNonTrivialAccounts.push(msg.sender);
61 	timeOfLastProof = now;
62     }
63 
64     function interestDistribution() {
65 	if (now-timeOfLastDistribution < 1 days) throw;
66 	if (totalSupply < 4639711657142857143) throw;
67 	if (totalSupply > 2*324779816*10**10) throw;
68 
69 	rateOfEmissionPerYear = 846747377428571428;
70 
71 	uint256 starttotalsupply = totalSupply;
72 
73 	for (uint i = 0; i < arrayOfNonTrivialAccounts.length; i ++) {
74 	    totalSupply += balanceOf[arrayOfNonTrivialAccounts[i]] * rateOfEmissionPerYear / 365 / starttotalsupply;
75 	    balanceOf[arrayOfNonTrivialAccounts[i]] += balanceOf[arrayOfNonTrivialAccounts[i]] * rateOfEmissionPerYear / 365 / starttotalsupply;
76 	}
77 
78 	timeOfLastDistribution = now;
79     }
80 
81     function proofOfWork(uint nonce) {
82 	uint n = uint(sha3(sha3(sha3(nonce, currentChallenge, msg.sender))));
83 	if (n < difficulty) throw;
84 	if (totalSupply > 4639711657142857143) throw;
85 	if (accountClaimedReward[msg.sender]) throw;
86 	
87 	balanceOf[msg.sender] += rateOfEmissionPerYear/365/24/60/10;
88 	totalSupply += rateOfEmissionPerYear/365/24/60/10;
89 	
90 	numclaimed += 1;
91 	arrayOfAccountsThatHaveClaimed.push(msg.sender);
92 	accountClaimedReward[msg.sender] = true;
93 
94 	if (balanceOf[msg.sender] > trivialThreshold && balanceOf[msg.sender] - (rateOfEmissionPerYear/365/24/60/10) <= trivialThreshold) arrayOfNonTrivialAccounts.push(msg.sender);
95 	if (numclaimed > 49) {
96 	    uint timeSinceLastProof = (now-timeOfLastProof);
97 	    difficulty = max - (max-difficulty) * (timeSinceLastProof / 5 minutes);
98 
99 	    timeOfLastProof = now;
100 	    currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number-1));
101 	    numclaimed = 0;
102 	    for (uint i = 0; i < arrayOfAccountsThatHaveClaimed.length; i ++) {
103 		accountClaimedReward[arrayOfAccountsThatHaveClaimed[i]] = false;
104 	    }
105 	    arrayOfAccountsThatHaveClaimed = new address[](0);
106 	}
107     }
108 
109 
110     /* Send coins */
111     function transfer(address _to, uint256 _value) {
112         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
113         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
114 	if (frozenAccount[msg.sender]) throw;
115 	if (totalSupply < 4639711657142857143) throw;
116 	if (msg.sender == owner) {
117 	    if (now - timeOfLastOwnerWithdrawal > 1 days) {
118 		ownerDailyWithdrawal = 0;
119 		timeOfLastOwnerWithdrawal = now;
120 	    }
121 	    if (_value+ownerDailyWithdrawal > 324779816*10**8 || totalSupply < 4747584953171428570) throw;
122 	    ownerDailyWithdrawal += _value;
123 	}
124         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
125 	if (balanceOf[msg.sender] <= trivialThreshold && balanceOf[msg.sender] + _value > trivialThreshold) {
126 	    for (uint i = 0; i < arrayOfNonTrivialAccounts.length; i ++) {
127 		if (msg.sender == arrayOfNonTrivialAccounts[i]) {
128 		    delete arrayOfNonTrivialAccounts[i];
129 		    arrayOfNonTrivialAccounts[i] = arrayOfNonTrivialAccounts[arrayOfNonTrivialAccounts.length-1];
130 		    arrayOfNonTrivialAccounts.length --;
131 		    break;
132 		}
133 	    }
134 	} 
135         balanceOf[_to] += _value;                 
136 	if (balanceOf[_to] > trivialThreshold && balanceOf[_to] - _value <= trivialThreshold) arrayOfNonTrivialAccounts.push(_to);
137         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
138     }
139 
140     /* Allow another contract to spend some tokens in your behalf */
141     function approve(address _spender, uint256 _value)
142         returns (bool success) {
143         allowance[msg.sender][_spender] = _value;
144 	Approval(msg.sender, _spender, _value);
145         return true;
146     }
147 
148 
149     /* Approve and then comunicate the approved contract in a single tx */
150     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
151         returns (bool success) {
152         tokenRecipient spender = tokenRecipient(_spender);
153         if (approve(_spender, _value)) {
154             spender.receiveApproval(msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }        
158 
159     /* A contract attempts to get the coins */
160     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
161         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
162         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
163         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
164 	if (frozenAccount[_from]) throw;
165 	if (totalSupply < 4639711657142857143) throw;
166 	if (_from == owner) {
167 	    if (now - timeOfLastOwnerWithdrawal > 1 days) {
168 		ownerDailyWithdrawal = 0;
169 		timeOfLastOwnerWithdrawal = now;
170 	    }
171 	    if (_value+ownerDailyWithdrawal > 324779816*10**8 || totalSupply < 4747584953171428570) throw;
172 	    ownerDailyWithdrawal += _value;
173 	}
174         balanceOf[_from] -= _value;                          // Subtract from the sender
175 	if (balanceOf[_from] <= trivialThreshold && balanceOf[_from] + _value > trivialThreshold) {
176 	    for (uint i = 0; i < arrayOfNonTrivialAccounts.length; i ++) {
177 		if (_from == arrayOfNonTrivialAccounts[i]) {
178 		    delete arrayOfNonTrivialAccounts[i];
179 		    arrayOfNonTrivialAccounts[i] = arrayOfNonTrivialAccounts[arrayOfNonTrivialAccounts.length-1];
180 		    arrayOfNonTrivialAccounts.length --;
181 		    break;
182 		}
183 	    }
184 	} 
185         balanceOf[_to] += _value;                            
186 	if (balanceOf[_to] > trivialThreshold && balanceOf[_to] - _value <= trivialThreshold) arrayOfNonTrivialAccounts.push(_to);
187         allowance[_from][msg.sender] -= _value;
188         Transfer(_from, _to, _value);
189         return true;
190     }
191 
192     function raiseTrivialThreshold(uint256 newTrivialThreshold) onlyOwner {
193 	trivialThreshold = newTrivialThreshold;
194 	for (uint i = arrayOfNonTrivialAccounts.length; i > 0; i --) {
195 	    if (balanceOf[arrayOfNonTrivialAccounts[i-1]] <= trivialThreshold) {
196 		delete arrayOfNonTrivialAccounts[i-1];
197 		arrayOfNonTrivialAccounts[i-1] = arrayOfNonTrivialAccounts[arrayOfNonTrivialAccounts.length-1];
198 		arrayOfNonTrivialAccounts.length --;
199 	    }
200 	}
201     }
202 
203     function freezeAccount(address target, bool freeze) onlyOwner {
204 	frozenAccount[target] = freeze;
205 	FrozenFunds(target, freeze);
206     }
207 
208     /* This unnamed function is called whenever someone tries to send ether to it */
209     function () {
210         throw;     // Prevents accidental sending of ether
211     }
212 }