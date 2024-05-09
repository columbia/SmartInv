1 pragma solidity ^0.4.20;
2 
3 contract NENCToken {
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6 
7     /* Initializes contract with initial supply tokens to the creator of the contract */
8     function NENCToken(
9         uint256 initialSupply
10         ) public {
11         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
12     }
13 
14     /* Send coins */
15     function transfer(address _to, uint256 _value) public returns (bool success) {
16         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
17         require(balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
18         balanceOf[msg.sender] -= _value;                    // Subtract from the sender
19         balanceOf[_to] += _value;                           // Add the same to the recipient
20         return true;
21     }
22 }
23 pragma solidity ^0.4.16;
24 
25 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
26 
27 contract TokenERC20 {
28     // Public variables of the token
29     string public name;
30     string public symbol;
31     uint8 public decimals = 18;
32     // 18 decimals is the strongly suggested default, avoid changing it
33     uint256 public totalSupply;
34 
35     // This creates an array with all balances
36     mapping (address => uint256) public balanceOf;
37     mapping (address => mapping (address => uint256)) public allowance;
38 
39     // This generates a public event on the blockchain that will notify clients
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     
42     // This generates a public event on the blockchain that will notify clients
43     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
44 
45     // This notifies clients about the amount burnt
46     event Burn(address indexed from, uint256 value);
47 
48     /**
49      * Constructor function
50      *
51      * Initializes contract with initial supply tokens to the creator of the contract
52      */
53     function TokenERC20(
54         uint256 initialSupply,
55         string tokenName,
56         string tokenSymbol
57     ) public {
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62     }
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value >= balanceOf[_to]);
74         // Save this for an assertion in the future
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         // Subtract from the sender
77         balanceOf[_from] -= _value;
78         // Add the same to the recipient
79         balanceOf[_to] += _value;
80         emit Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public returns (bool success) {
94         _transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Transfer tokens from other address
100      *
101      * Send `_value` tokens to `_to` on behalf of `_from`
102      *
103      * @param _from The address of the sender
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         require(_value <= allowance[_from][msg.sender]);     // Check allowance
109         allowance[_from][msg.sender] -= _value;
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     /**
115      * Set allowance for other address
116      *
117      * Allows `_spender` to spend no more than `_value` tokens on your behalf
118      *
119      * @param _spender The address authorized to spend
120      * @param _value the max amount they can spend
121      */
122     function approve(address _spender, uint256 _value) public
123         returns (bool success) {
124         allowance[msg.sender][_spender] = _value;
125         emit Approval(msg.sender, _spender, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address and notify
131      *
132      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      * @param _extraData some extra information to send to the approved contract
137      */
138     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
139         public
140         returns (bool success) {
141         tokenRecipient spender = tokenRecipient(_spender);
142         if (approve(_spender, _value)) {
143             spender.receiveApproval(msg.sender, _value, this, _extraData);
144             return true;
145         }
146     }
147 
148     /**
149      * Destroy tokens
150      *
151      * Remove `_value` tokens from the system irreversibly
152      *
153      * @param _value the amount of money to burn
154      */
155     function burn(uint256 _value) public returns (bool success) {
156         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
157         balanceOf[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         emit Burn(msg.sender, _value);
160         return true;
161     }
162 
163     /**
164      * Destroy tokens from other account
165      *
166      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
167      *
168      * @param _from the address of the sender
169      * @param _value the amount of money to burn
170      */
171     function burnFrom(address _from, uint256 _value) public returns (bool success) {
172         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
173         require(_value <= allowance[_from][msg.sender]);    // Check allowance
174         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
175         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
176         totalSupply -= _value;                              // Update totalSupply
177         emit Burn(_from, _value);
178         return true;
179     }
180 }