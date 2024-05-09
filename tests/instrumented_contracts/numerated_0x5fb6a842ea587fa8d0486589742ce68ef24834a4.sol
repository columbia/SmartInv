1 pragma solidity ^0.4.16;//800000000, "Revizor Coin", "RR"
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 	
13 	
14 	bytes32 public currentChallenge;                         // The coin starts with a challenge
15     uint public timeOfLastProof;                             // Variable to keep track of when rewards were given
16     uint public difficulty = 10**32;                         // Difficulty starts reasonably low
17 	uint constant amounttomine = 5000000;
18 	bool miningGoalReached = false;
19 	uint public mined = 0; 
20 	uint public curReward = 0;
21 	
22 
23     // This creates an array with all balances
24     mapping (address => uint256) public balanceOf;
25     mapping (address => mapping (address => uint256)) public allowance;
26 
27     // This generates a public event on the blockchain that will notify clients
28     event Transfer(address indexed from, address indexed to, uint256 value);
29 
30     // This notifies clients about the amount burnt
31     event Burn(address indexed from, uint256 value);
32 
33     /**
34      * Constrctor function
35      *
36      * Initializes contract with initial supply tokens to the creator of the contract
37      */
38     function TokenERC20(
39         uint256 initialSupply,
40         string tokenName,
41         string tokenSymbol
42     ) public {
43         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
44         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
45         name = tokenName;                                   // Set the name for display purposes
46         symbol = tokenSymbol;                               // Set the symbol for display purposes
47 		timeOfLastProof = now;
48 
49     }
50 
51     /**
52      * Internal transfer, only can be called by this contract
53      */
54     function _transfer(address _from, address _to, uint _value) internal {
55         // Prevent transfer to 0x0 address. Use burn() instead
56         require(_to != 0x0);
57         // Check if the sender has enough
58         require(balanceOf[_from] >= _value);
59         // Check for overflows
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68         // Asserts are used to use static analysis to find bugs in your code. They should never fail
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     /**
73      * Transfer tokens
74      *
75      * Send `_value` tokens to `_to` from your account
76      *
77      * @param _to The address of the recipient
78      * @param _value the amount to send
79      */
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     /**
85      * Transfer tokens from other address
86      *
87      * Send `_value` tokens to `_to` in behalf of `_from`
88      *
89      * @param _from The address of the sender
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
94         require(_value <= allowance[_from][msg.sender]);     // Check allowance
95         allowance[_from][msg.sender] -= _value;
96         _transfer(_from, _to, _value);
97         return true;
98     }
99 
100     /**
101      * Set allowance for other address
102      *
103      * Allows `_spender` to spend no more than `_value` tokens in your behalf
104      *
105      * @param _spender The address authorized to spend
106      * @param _value the max amount they can spend
107      */
108     function approve(address _spender, uint256 _value) public
109         returns (bool success) {
110         allowance[msg.sender][_spender] = _value;
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address and notify
116      *
117      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      * @param _extraData some extra information to send to the approved contract
122      */
123     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
124         public
125         returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
142         balanceOf[msg.sender] -= _value;            // Subtract from the sender
143         totalSupply -= _value;                      // Updates totalSupply
144         Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
158         require(_value <= allowance[_from][msg.sender]);    // Check allowance
159         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
160         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
161         totalSupply -= _value;                              // Update totalSupply
162         Burn(_from, _value);
163         return true;
164     }
165 	
166 	
167     function proofOfWork(uint nonce) public{
168 
169         bytes8 n = bytes8(keccak256(nonce, currentChallenge));    // Generate a random hash based on input
170         require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
171 
172         uint timeSinceLastProof = (now - timeOfLastProof);  // Calculate time since last reward was given
173         require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
174 		
175 		require(!miningGoalReached); 
176 		
177 		curReward = timeSinceLastProof; // 1 second = 1 coin
178 		if((curReward+mined)>amounttomine){
179 			curReward = amounttomine - mined;
180 
181 		}
182 		
183 		curReward = curReward * 10 ** uint256(decimals);
184 		
185         balanceOf[msg.sender] += curReward;  // The reward to the winner grows by the minute
186 		mined+=curReward;
187 		
188 		if(mined>=amounttomine){
189 			miningGoalReached = true;
190 		}
191 		
192 		
193 
194         difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  // Adjusts the difficulty
195 
196         timeOfLastProof = now;                              // Reset the counter
197         currentChallenge = keccak256(nonce, currentChallenge, block.blockhash(block.number - 1));  // Save a hash that will be used as the next proof
198     }	
199 }