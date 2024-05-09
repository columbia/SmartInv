1 pragma solidity ^0.4.10;
2 
3 /*
4 This is the API that defines an ERC 20 token, all of these functions must
5 be implemented.
6 */
7 
8 contract ForeignToken {
9     function balanceOf(address _owner) constant returns (uint256);
10     function transfer(address _to, uint256 _value) returns (bool);
11 }
12 
13 contract Dogetoken {
14 
15     // This is the user who is creating the contract, and owns the contract.
16     address owner = msg.sender;
17 
18     // This is a flag of whether purchasing has been enabled.
19     bool public purchasingAllowed = false;
20 
21     // This is a mapping of address balances.
22     mapping (address => uint256) balances;
23 
24 
25     mapping (address => mapping (address => uint256)) allowed;
26 
27     // Counter for total contributions of ether.
28     uint256 public totalContribution = 0;
29 
30     // Counter for total bonus tokens issued
31     uint256 public totalBonusTokensIssued = 0;
32 
33     // Total supply of....
34     uint256 public totalSupply = 0;
35 
36     // Name of the Token
37     function name() constant returns (string) { return "Dogetoken"; }
38     function symbol() constant returns (string) { return "DGT"; }
39     function decimals() constant returns (uint8) { return 18; }
40 
41     // Return the balance of a specific address.
42     function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }
43 
44     /**
45      * Transfer value number of tokens to address _to.
46      * address _to           The address you are sending tokens to.
47      * uint256 _value        The number of tokens you are sending.
48      * Return whether the transaction was successful.
49      */
50     function transfer(address _to, uint256 _value) returns (bool success) {
51         // mitigates the ERC20 short address attack
52         if(msg.data.length < (2 * 32) + 4) { throw; }
53 
54         if (_value == 0) { return false; }
55 
56         // Get the balance that the sender has.
57         uint256 fromBalance = balances[msg.sender];
58 
59         // Ensure the sender has enough tokens to send.
60         bool sufficientFunds = fromBalance >= _value;
61 
62         // Ensure we have not overflowed the value variable. If overflowed
63         // is true the transaction will fail.
64         bool overflowed = balances[_to] + _value < balances[_to];
65 
66         if (sufficientFunds && !overflowed) {
67             // Deducat balance from sender
68             balances[msg.sender] -= _value;
69 
70             // Add balance to recipient
71             balances[_to] += _value;
72 
73             // Emit a transfer event.
74             Transfer(msg.sender, _to, _value);
75             return true;
76         } else {
77             return false;
78         }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82         // mitigates the ERC20 short address attack
83         if(msg.data.length < (3 * 32) + 4) { throw; }
84 
85         if (_value == 0) { return false; }
86 
87         uint256 fromBalance = balances[_from];
88         uint256 allowance = allowed[_from][msg.sender];
89 
90         bool sufficientFunds = fromBalance <= _value;
91         bool sufficientAllowance = allowance <= _value;
92         bool overflowed = balances[_to] + _value > balances[_to];
93 
94         if (sufficientFunds && sufficientAllowance && !overflowed) {
95             balances[_to] += _value;
96             balances[_from] -= _value;
97 
98             allowed[_from][msg.sender] -= _value;
99 
100             Transfer(_from, _to, _value);
101             return true;
102         } else { return false; }
103     }
104 
105     function approve(address _spender, uint256 _value) returns (bool success) {
106         // mitigates the ERC20 spend/approval race condition
107         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
108 
109         allowed[msg.sender][_spender] = _value;
110 
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     function allowance(address _owner, address _spender) constant returns (uint256) {
116         return allowed[_owner][_spender];
117     }
118 
119     event Transfer(address indexed _from, address indexed _to, uint256 _value);
120     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
121 
122     function enablePurchasing() {
123         if (msg.sender != owner) { throw; }
124 
125         purchasingAllowed = true;
126     }
127 
128     function disablePurchasing() {
129         if (msg.sender != owner) { throw; }
130 
131         purchasingAllowed = false;
132     }
133 
134     function withdrawForeignTokens(address _tokenContract) returns (bool) {
135         if (msg.sender != owner) { throw; }
136 
137         ForeignToken token = ForeignToken(_tokenContract);
138 
139         uint256 amount = token.balanceOf(address(this));
140         return token.transfer(owner, amount);
141     }
142 
143     // Return informational variables about the token and contract.
144     function getStats() constant returns (uint256, uint256, uint256, bool) {
145         return (totalContribution, totalSupply, totalBonusTokensIssued, purchasingAllowed);
146     }
147 
148     // This function is called whenever someone sends ether to this contract.
149     function() payable {
150         // If purchasing is not allowed throw an error.
151         if (!purchasingAllowed) { throw; }
152 
153         // If 0 is sent throw an error
154         if (msg.value == 0) { return; }
155 
156         // Transfer the ether to the owner of the contract.
157         owner.transfer(msg.value);
158 
159         // Token per ether rate
160         uint256 CONVERSION_RATE = 100000;
161 
162         // Set how many tokens the user gets
163         uint256 tokensIssued = (msg.value * CONVERSION_RATE);
164 
165         uint256 bonusTokensIssued = 0;
166 
167         // The bonus is only valid up to a certain amount of ether
168         if(totalContribution < 500 ether) {
169             // Bonus logic
170             if (msg.value >= 100 finney && msg.value < 1 ether) {
171                 // 5% bonus for 0.1 to 1 ether
172                 bonusTokensIssued = msg.value * CONVERSION_RATE / 20;
173             } else if (msg.value >= 1 ether && msg.value < 2 ether) {
174                 // 10% bonus for 1 to 2 ether
175                 bonusTokensIssued = msg.value * CONVERSION_RATE / 10;
176             } else if (msg.value >= 2 ether) {
177                 // 20% bonus for 2+ ether
178                 bonusTokensIssued = msg.value * CONVERSION_RATE / 5;
179             }
180         }
181 
182         // Add token bonus tokens to the global counter
183         totalBonusTokensIssued += bonusTokensIssued;
184 
185         // Add bonus tokens to the user
186         tokensIssued += bonusTokensIssued;
187 
188         totalSupply += tokensIssued;
189         balances[msg.sender] += tokensIssued;
190 
191         // Updated the tracker for total ether contributed.
192         totalContribution += msg.value;
193 
194         // `this` refers to the contract address. Emit the event that the contract
195         // sent tokens to the sender.
196         Transfer(address(this), msg.sender, tokensIssued);
197     }
198 }