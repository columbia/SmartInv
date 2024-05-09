1 pragma solidity ^0.4.18;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract ValueLink {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 12;
10     // 18 decimals is the strongly suggested default, avoid changing it
11     uint256 public totalSupply;
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
23     /**
24      * Constrctor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28     function ValueLink() public {
29         totalSupply = 72000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
30         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
31         name = "Value Link";                                   // Set the name for display purposes
32         symbol = "VLK";                               // Set the symbol for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
40         require (balanceOf[_from] > _value);                // Check if the sender has enough
41         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
42         balanceOf[_from] -= _value;                         // Subtract from the sender
43         balanceOf[_to] += _value;                           // Add the same to the recipient
44         Transfer(_from, _to, _value);
45     }
46 
47     /**
48      * Transfer tokens
49      *
50      * Send `_value` tokens to `_to` from your account
51      *
52      * @param _to The address of the recipient
53      * @param _value the amount to send
54      */
55     function transfer(address _to, uint256 _value) public {
56         _transfer(msg.sender, _to, _value);
57     }
58 
59     /**
60      * Transfer tokens from other address
61      *
62      * Send `_value` tokens to `_to` in behalf of `_from`
63      *
64      * @param _from The address of the sender
65      * @param _to The address of the recipient
66      * @param _value the amount to send
67      */
68     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
69         require(_value <= allowance[_from][msg.sender]);     // Check allowance
70         allowance[_from][msg.sender] -= _value;
71         _transfer(_from, _to, _value);
72         return true;
73     }
74 
75     /**
76      * Set allowance for other address
77      *
78      * Allows `_spender` to spend no more than `_value` tokens in your behalf
79      *
80      * @param _spender The address authorized to spend
81      * @param _value the max amount they can spend
82      */
83     function approve(address _spender, uint256 _value) public
84         returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89     /**
90      * Set allowance for other address and notify
91      *
92      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
93      *
94      * @param _spender The address authorized to spend
95      * @param _value the max amount they can spend
96      * @param _extraData some extra information to send to the approved contract
97      */
98     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
99         public
100         returns (bool success) {
101         tokenRecipient spender = tokenRecipient(_spender);
102         if (approve(_spender, _value)) {
103             spender.receiveApproval(msg.sender, _value, this, _extraData);
104             return true;
105         }
106     }
107 
108     /**
109      * Destroy tokens
110      *
111      * Remove `_value` tokens from the system irreversibly
112      *
113      * @param _value the amount of money to burn
114      */
115     function burn(uint256 _value) public returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
117         balanceOf[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122 
123     /**
124      * Destroy tokens from other account
125      *
126      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
127      *
128      * @param _from the address of the sender
129      * @param _value the amount of money to burn
130      */
131     function burnFrom(address _from, uint256 _value) public returns (bool success) {
132         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
133         require(_value <= allowance[_from][msg.sender]);    // Check allowance
134         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
135         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
136         totalSupply -= _value;                              // Update totalSupply
137         Burn(_from, _value);
138         return true;
139     }
140 }