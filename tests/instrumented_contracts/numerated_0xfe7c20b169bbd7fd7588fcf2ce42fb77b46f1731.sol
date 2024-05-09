1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract Token {
6     // Public variables
7     string public name;
8     string public symbol;
9     uint256 public totalSupply;
10     address public owner;
11     uint8 public decimals = 12; // 18 decimals
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16 
17     // This generates a public event on the blockchain that will notify clients
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 
20     // This notifies clients about the amount burnt
21     event Burn(address indexed from, uint256 value);
22 
23     // This notifies clients about the emission amount
24     event tokenEmission(address indexed from, uint256 value);
25 
26     /**
27      * Constrctor function
28      *
29      * Initializes contract with initial supply tokens to the creator of the contract
30      */
31     function Token() public {
32         totalSupply = 10000000000 * 10 ** uint256(decimals);       // Update total supply with the decimal amount
33         name = 'Deal Guard Token';                                                      // Set the name for display purposes
34         symbol = 'DG';                                                     // Set the symbol for display purposes
35         balanceOf[msg.sender] = totalSupply;                                        // Give the creator all initial tokens
36         owner = msg.sender;                                                         // Contract owner
37     }
38 
39     /**
40      * Admin modifier
41      *
42      * Check admin
43      *
44      */
45     modifier onlyOwner {
46         require(msg.sender == owner);
47         _;
48     }
49 
50     /**
51      * Token creation
52      *
53      * Create `_value` tokens
54      *
55      * @param _value the amount to create
56      */
57     function emission(uint256 _value) onlyOwner {
58         _value = _value * 10 ** uint256(decimals);
59         balanceOf[owner] += _value;  // Append to the sender
60         totalSupply += _value;       // Updates totalSupply
61         tokenEmission(msg.sender, _value);
62     }
63 
64 
65     /**
66      * Internal transfer, only can be called by this contract
67      */
68     function _transfer(address _from, address _to, uint _value) internal {
69         // Prevent transfer to 0x0 address. Use burn() instead
70         require(_to != 0x0);
71         // Check if the sender has enough
72         require(balanceOf[_from] >= _value);
73         // Check for overflows
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         // Save this for an assertion in the future
76         uint previousBalances = balanceOf[_from] + balanceOf[_to];
77         // Subtract from the sender
78         balanceOf[_from] -= _value;
79         // Add the same to the recipient
80         balanceOf[_to] += _value;
81         Transfer(_from, _to, _value);
82         // Asserts are used to use static analysis to find bugs in your code. They should never fail
83         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
84     }
85 
86     /**
87      * Transfer tokens
88      *
89      * Send `_value` tokens to `_to` from your account
90      *
91      * @param _to The address of the recipient
92      * @param _value the amount to send
93      */
94     function transfer(address _to, uint256 _value) public {
95         _transfer(msg.sender, _to, _value);
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
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
138         public
139         returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);
141         if (approve(_spender, _value)) {
142             spender.receiveApproval(msg.sender, _value, this, _extraData);
143             return true;
144         }
145     }
146 
147     /**
148      * Destroy tokens
149      *
150      * Remove `_value` tokens from the system irreversibly
151      *
152      * @param _value the amount of money to burn
153      */
154     function burn(uint256 _value) public returns (bool success) {
155         _value = _value * 10 ** uint256(decimals);  // INTEGER!
156         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
157         balanceOf[msg.sender] -= _value;            // Subtract from the sender
158         totalSupply -= _value;                      // Updates totalSupply
159         Burn(msg.sender, _value);
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
177         Burn(_from, _value);
178         return true;
179     }
180 }