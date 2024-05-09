1 pragma solidity ^0.4.13;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract MyToken {
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
27     function MyToken(
28         uint256 initialSupply,
29         string tokenName,
30         uint8 decimalUnits,
31         string tokenSymbol
32     ) {
33         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
34         totalSupply = initialSupply;                        // Update total supply
35         name = tokenName;                                   // Set the name for display purposes
36         symbol = tokenSymbol;                               // Set the symbol for display purposes
37         decimals = decimalUnits;                            // Amount of decimals for display purposes
38       
39     }
40 
41     /**
42      * Internal transfer, only can be called by this contract
43      */
44     function _transfer(address _from, address _to, uint _value) internal {
45         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
46         require(balanceOf[_from] >= _value);                // Check if the sender has enough
47         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
48         balanceOf[_from] -= _value;                         // Subtract from the sender
49         balanceOf[_to] += _value;                           // Add the same to the recipient
50         Transfer(_from, _to, _value);
51     }
52 
53     /**
54      * Transfer tokens
55      *
56      * Send `_value` tokens to `_to` from your account
57      *
58      * @param _to The address of the recipient
59      * @param _value the amount to send
60      */
61     function transfer(address _to, uint256 _value) {
62         _transfer(msg.sender, _to, _value);
63     }
64 
65     /**
66      * Transfer tokens from other address
67      *
68      * Send `_value` tokens to `_to` in behalf of `_from`
69      *
70      * @param _from The address of the sender
71      * @param _to The address of the recipient
72      * @param _value the amount to send
73      */
74     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
75         require(_value <= allowance[_from][msg.sender]);     // Check allowance
76         allowance[_from][msg.sender] -= _value;
77         _transfer(_from, _to, _value);
78         return true;
79     }
80 
81     /**
82      * Set allowance for other address
83      *
84      * Allows `_spender` to spend no more than `_value` tokens in your behalf
85      *
86      * @param _spender The address authorized to spend
87      * @param _value the max amount they can spend
88      */
89     function approve(address _spender, uint256 _value)
90         returns (bool success) {
91         allowance[msg.sender][_spender] = _value;
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address and notify
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      * @param _extraData some extra information to send to the approved contract
103      */
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
105         returns (bool success) {
106         tokenRecipient spender = tokenRecipient(_spender);
107         if (approve(_spender, _value)) {
108             spender.receiveApproval(msg.sender, _value, this, _extraData);
109             return true;
110         }
111     }
112 
113     /**
114      * Destroy tokens
115      *
116      * Remove `_value` tokens from the system irreversibly
117      *
118      * @param _value the amount of money to burn
119      */
120     function burn(uint256 _value) returns (bool success) {
121         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
122         balanceOf[msg.sender] -= _value;            // Subtract from the sender
123         totalSupply -= _value;                      // Updates totalSupply
124         Burn(msg.sender, _value);
125         return true;
126     }
127 
128     /**
129      * Destroy tokens from other ccount
130      *
131      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
132      *
133      * @param _from the address of the sender
134      * @param _value the amount of money to burn
135      */
136     function burnFrom(address _from, uint256 _value) returns (bool success) {
137         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
138         require(_value <= allowance[_from][msg.sender]);    // Check allowance
139         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
140         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
141         totalSupply -= _value;                              // Update totalSupply
142         Burn(_from, _value);
143         return true;
144     }
145 }