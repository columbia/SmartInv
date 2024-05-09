1 pragma solidity ^0.4.13;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MINEX {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals;
10     uint256 public totalSupply;
11 
12     // This creates an array with all balances
13     mapping (address => uint256) public balanceOf;
14     mapping (address => mapping (address => uint256)) public allowance;
15 
16     // This generates a public event on the blockchain that will notify clients
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     // This notifies clients about the amount burnt
20     event Burn(address indexed from, uint256 value);
21 
22     /**
23      * Constrctor function
24      *
25      * Initializes contract with initial supply tokens to the creator of the contract
26      */
27     function MINEX() {
28         balanceOf[msg.sender] = 2999029096950000;              // Give the creator all initial tokens
29         totalSupply = 2999029096950000;                        // Update total supply
30         name = 'MINEX';                                   // Set the name for display purposes
31         symbol = 'MINEX';                               // Set the symbol for display purposes
32         decimals = 8;                            // Amount of decimals for display purposes
33     }
34 
35     /**
36      * Internal transfer, only can be called by this contract
37      */
38     function _transfer(address _from, address _to, uint _value) internal {
39         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
40         require(balanceOf[_from] >= _value);                // Check if the sender has enough
41         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
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
55     function transfer(address _to, uint256 _value) {
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
68     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
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
83     function approve(address _spender, uint256 _value)
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
99         returns (bool success) {
100         tokenRecipient spender = tokenRecipient(_spender);
101         if (approve(_spender, _value)) {
102             spender.receiveApproval(msg.sender, _value, this, _extraData);
103             return true;
104         }
105     }
106 
107     /**
108      * Destroy tokens
109      *
110      * Remove `_value` tokens from the system irreversibly
111      *
112      * @param _value the amount of money to burn
113      */
114     function burn(uint256 _value) returns (bool success) {
115         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
116         balanceOf[msg.sender] -= _value;            // Subtract from the sender
117         totalSupply -= _value;                      // Updates totalSupply
118         Burn(msg.sender, _value);
119         return true;
120     }
121 
122     /**
123      * Destroy tokens from other ccount
124      *
125      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
126      *
127      * @param _from the address of the sender
128      * @param _value the amount of money to burn
129      */
130     function burnFrom(address _from, uint256 _value) returns (bool success) {
131         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
132         require(_value <= allowance[_from][msg.sender]);    // Check allowance
133         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
134         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
135         totalSupply -= _value;                              // Update totalSupply
136         Burn(_from, _value);
137         return true;
138     }
139 }