1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
4 
5 contract TokenERC20 {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
12 
13     // This creates an array with all balances
14     mapping (address => uint256) public balanceOf;
15     mapping (address => mapping (address => uint256)) public allowance;
16     
17     // This creates an array with strings of keys of registered participants
18     mapping (address => string) public  keys;
19 
20     // This generates a public event on the blockchain that will notify clients
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     
23     // This generates a public event on the blockchain that will notify clients
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25 
26     // This notifies clients about the amount burnt
27     event Burn(address indexed from, uint256 value);
28     
29     // This notifies clients about changed key registrations
30     event Register (address user, string key);
31 
32     /**
33      * Constructor function
34      *
35      * Initializes contract with initial supply tokens to the creator of the contract
36      */
37     function TokenERC20(
38         uint256 initialSupply,
39         string tokenName,
40         string tokenSymbol
41     ) public {
42         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
43         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
44         name = tokenName;                                   // Set the name for display purposes
45         symbol = tokenSymbol;                               // Set the symbol for display purposes
46     }
47 
48     /**
49      * Internal transfer, only can be called by this contract
50      */
51     function _transfer(address _from, address _to, uint _value) internal {
52         // Prevent transfer to 0x0 address. Use burn() instead
53         require(_to != 0x0);
54         // Check if the sender has enough
55         require(balanceOf[_from] >= _value);
56         // Check for overflows
57         require(balanceOf[_to] + _value >= balanceOf[_to]);
58         // Save this for an assertion in the future
59         uint previousBalances = balanceOf[_from] + balanceOf[_to];
60         // Subtract from the sender
61         balanceOf[_from] -= _value;
62         // Add the same to the recipient
63         balanceOf[_to] += _value;
64         emit Transfer(_from, _to, _value);
65         // Asserts are used to use static analysis to find bugs in your code. They should never fail
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
67     }
68 
69     /**
70      * Transfer tokens
71      *
72      * Send `_value` tokens to `_to` from your account
73      *
74      * @param _to The address of the recipient
75      * @param _value the amount to send
76      */
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         _transfer(msg.sender, _to, _value);
79         return true;
80     }
81 
82     /**
83      * Transfer tokens from other address
84      *
85      * Send `_value` tokens to `_to` on behalf of `_from`
86      *
87      * @param _from The address of the sender
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     // Check allowance
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     /**
99      * Set allowance for other address
100      *
101      * Allows `_spender` to spend no more than `_value` tokens on your behalf
102      *
103      * @param _spender The address authorized to spend
104      * @param _value the max amount they can spend
105      */
106     function approve(address _spender, uint256 _value) public
107         returns (bool success) {
108         allowance[msg.sender][_spender] = _value;
109         emit Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address and notify
115      *
116      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123         public
124         returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Remove `_value` tokens from the system irreversibly
136      *
137      * @param _value the amount of money to burn
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] -= _value;            // Subtract from the sender
142         totalSupply -= _value;                      // Updates totalSupply
143         emit Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
159         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160         totalSupply -= _value;                              // Update totalSupply
161         emit Burn(_from, _value);
162         return true;
163     }
164 
165 
166     /**
167      * Registers a key as string for the sending address
168      * Value should be a public key for release of MainNet
169      *
170      * @param _key the key to register on behalf of the sender
171      */
172     function register(string _key) public {
173         keys[msg.sender] = _key;
174         emit Register(msg.sender, _key);
175     }
176 }