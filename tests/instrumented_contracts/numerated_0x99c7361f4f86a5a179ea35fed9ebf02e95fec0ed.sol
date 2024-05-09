1 pragma solidity ^0.4.17;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 
5 contract LENRCoin {
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
27     function LENRCoin(
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
38     }
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
45         require(balanceOf[_from] >= _value);                // Check if the sender has enough
46         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
47         balanceOf[_from] -= _value;                         // Subtract from the sender
48         balanceOf[_to] += _value;                           // Add the same to the recipient
49         Transfer(_from, _to, _value);
50     }
51 
52     /**
53      * Transfer tokens
54      *
55      * Send `_value` tokens to `_to` from your account
56      *
57      * @param _to The address of the recipient
58      * @param _value the amount to send
59      */
60     function transfer(address _to, uint256 _value) {
61         _transfer(msg.sender, _to, _value);
62     }
63 
64     /**
65      * Transfer tokens from other address
66      *
67      * Send `_value` tokens to `_to` in behalf of `_from`
68      *
69      * @param _from The address of the sender
70      * @param _to The address of the recipient
71      * @param _value the amount to send
72      */
73     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
74         require(_value <= allowance[_from][msg.sender]);     // Check allowance
75         allowance[_from][msg.sender] -= _value;
76         _transfer(_from, _to, _value);
77         return true;
78     }
79 
80     /**
81      * Set allowance for other address
82      *
83      * Allows `_spender` to spend no more than `_value` tokens in your behalf
84      *
85      * @param _spender The address authorized to spend
86      * @param _value the max amount they can spend
87      */
88     function approve(address _spender, uint256 _value)
89         returns (bool success) {
90         allowance[msg.sender][_spender] = _value;
91         return true;
92     }
93 
94     /**
95      * Set allowance for other address and notify
96      *
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
98      *
99      * @param _spender The address authorized to spend
100      * @param _value the max amount they can spend
101      * @param _extraData some extra information to send to the approved contract
102      */
103     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
104         returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     /**
113      * Destroy tokens
114      *
115      * Remove `_value` tokens from the system irreversibly
116      *
117      * @param _value the amount of money to burn
118      */
119     function burn(uint256 _value) returns (bool success) {
120         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
121         balanceOf[msg.sender] -= _value;            // Subtract from the sender
122         totalSupply -= _value;                      // Updates totalSupply
123         Burn(msg.sender, _value);
124         return true;
125     }
126 
127     /**
128      * Destroy tokens from other ccount
129      *
130      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
131      *
132      * @param _from the address of the sender
133      * @param _value the amount of money to burn
134      */
135     function burnFrom(address _from, uint256 _value) returns (bool success) {
136         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
137         require(_value <= allowance[_from][msg.sender]);    // Check allowance
138         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
139         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
140         totalSupply -= _value;                              // Update totalSupply
141         Burn(_from, _value);
142         return true;
143     }
144 }