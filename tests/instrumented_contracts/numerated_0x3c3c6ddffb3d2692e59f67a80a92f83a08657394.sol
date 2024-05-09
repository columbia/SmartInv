1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TCC{
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12     address public owner;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => uint256) public freezeOf;
17     mapping (address => mapping (address => uint256)) public allowance;
18 
19     // This generates a public event on the blockchain that will notify clients
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     
22     // This generates a public event on the blockchain that will notify clients
23     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
24 
25     // This notifies clients about the amount burnt
26     event Burn(address indexed from, uint256 value);
27 
28     /* This notifies clients about the amount frozen */
29     event Freeze(address indexed from, uint256 value);
30 	
31     /* This notifies clients about the amount unfrozen */
32     event Unfreeze(address indexed from, uint256 value);
33 	
34     /**
35      * Constructor function
36      *
37      * Initializes contract with initial supply tokens to the creator of the contract
38      */
39     constructor(
40         uint256 initialSupply,
41         string tokenName,
42         string tokenSymbol
43     ) public {
44         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
45         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
46         name = tokenName;                                   // Set the name for display purposes
47         symbol = tokenSymbol; 
48 	owner = msg.sender;		// Set the symbol for display purposes
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
60         require(balanceOf[_to] + _value >= balanceOf[_to]);
61         // Save this for an assertion in the future
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63         // Subtract from the sender
64         balanceOf[_from] -= _value;
65         // Add the same to the recipient
66         balanceOf[_to] += _value;
67         emit Transfer(_from, _to, _value);
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
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         _transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86      * Transfer tokens from other address
87      *
88      * Send `_value` tokens to `_to` on behalf of `_from`
89      *
90      * @param _from The address of the sender
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
95         require(_value <= allowance[_from][msg.sender]);     // Check allowance
96         allowance[_from][msg.sender] -= _value;
97         _transfer(_from, _to, _value);
98         return true;
99     }
100 
101     /**
102      * Set allowance for other address
103      *
104      * Allows `_spender` to spend no more than `_value` tokens on your behalf
105      *
106      * @param _spender The address authorized to spend
107      * @param _value the max amount they can spend
108      */
109     function approve(address _spender, uint256 _value) public
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      * @param _extraData some extra information to send to the approved contract
124      */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
126         public
127         returns (bool success) {
128         tokenRecipient spender = tokenRecipient(_spender);
129         if (approve(_spender, _value)) {
130             spender.receiveApproval(msg.sender, _value, this, _extraData);
131             return true;
132         }
133     }
134 
135     /**
136      * Destroy tokens
137      *
138      * Remove `_value` tokens from the system irreversibly
139      *
140      * @param _value the amount of money to burn
141      */
142     function burn(uint256 _value) public returns (bool success) {
143         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
144         balanceOf[msg.sender] -= _value;            // Subtract from the sender
145         totalSupply -= _value;                      // Updates totalSupply
146         emit Burn(msg.sender, _value);
147         return true;
148     }
149 
150     /**
151      * Destroy tokens from other account
152      *
153      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
154      *
155      * @param _from the address of the sender
156      * @param _value the amount of money to burn
157      */
158     function burnFrom(address _from, uint256 _value) public returns (bool success) {
159         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
160         require(_value <= allowance[_from][msg.sender]);    // Check allowance
161         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
162         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
163         totalSupply -= _value;                              // Update totalSupply
164         emit Burn(_from, _value);
165         return true;
166     }
167 	
168 	function freeze(uint256 _value) public returns (bool success) {
169         require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
170 	require(freezeOf[msg.sender] + _value > freezeOf[msg.sender]);
171 	require(_value > 0); 
172         balanceOf[msg.sender] -= _value;                      // Subtract from the sender
173         freezeOf[msg.sender] += _value;                                // Updates totalSupply
174         emit Freeze(msg.sender, _value);
175         return true;
176     }
177 	
178 	function unfreeze(uint256 _value) public returns (bool success) {
179         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
180 	require(balanceOf[msg.sender] + _value > balanceOf[msg.sender]);
181 	require(_value > 0); 
182         freezeOf[msg.sender] -= _value;                      // Subtract from the sender
183 	balanceOf[msg.sender] += _value;
184         emit Unfreeze(msg.sender, _value);
185         return true;
186     }
187 	
188 	// transfer balance to owner
189 	function withdrawEther(uint256 amount) public {
190 		require(msg.sender == owner);
191 		owner.transfer(amount);
192 	}
193 }