1 pragma solidity ^0.4.11;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract SUNX {
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
27     function SUNX(
28     ) {
29         balanceOf[msg.sender] = 10000000000000000000000000;              // Give the creator all initial tokens
30         totalSupply = 10000000000000000000000000;                        // Update total supply
31         name = "SUNX";                                   // Set the name for display purposes
32         symbol = "XNS";                               // Set the symbol for display purposes
33         decimals = 18;                            // Amount of decimals for display purposes
34     }
35 
36     /**
37      * Internal transfer, only can be called by this contract
38      */
39     function _transfer(address _from, address _to, uint _value) internal {
40         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
41         require(balanceOf[_from] >= _value);                // Check if the sender has enough
42         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
43         balanceOf[_from] -= _value;                         // Subtract from the sender
44         balanceOf[_to] += _value;                           // Add the same to the recipient
45         Transfer(_from, _to, _value);
46     }
47 
48     /**
49      * Transfer tokens
50      *
51      * Send `_value` tokens to `_to` from your account
52      *
53      * @param _to The address of the recipient
54      * @param _value the amount to send
55      */
56     function transfer(address _to, uint256 _value) {
57         _transfer(msg.sender, _to, _value);
58     }
59 
60     /**
61      * Transfer tokens from other address
62      *
63      * Send `_value` tokens to `_to` in behalf of `_from`
64      *
65      * @param _from The address of the sender
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     /**
77      * Set allowance for other address
78      *
79      * Allows `_spender` to spend no more than `_value` tokens in your behalf
80      *
81      * @param _spender The address authorized to spend
82      * @param _value the max amount they can spend
83      */
84     function approve(address _spender, uint256 _value)
85         returns (bool success) {
86         allowance[msg.sender][_spender] = _value;
87         return true;
88     }
89 
90     /**
91      * Set allowance for other address and notify
92      *
93      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
94      *
95      * @param _spender The address authorized to spend
96      * @param _value the max amount they can spend
97      * @param _extraData some extra information to send to the approved contract
98      */
99     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
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
115     function burn(uint256 _value) returns (bool success) {
116         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
117         balanceOf[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         Burn(msg.sender, _value);
120         return true;
121     }
122 
123     /**
124      * Destroy tokens from other ccount
125      *
126      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
127      *
128      * @param _from the address of the sender
129      * @param _value the amount of money to burn
130      */
131     function burnFrom(address _from, uint256 _value) returns (bool success) {
132         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
133         require(_value <= allowance[_from][msg.sender]);    // Check allowance
134         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
135         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
136         totalSupply -= _value;                              // Update totalSupply
137         Burn(_from, _value);
138         return true;
139     }
140 }