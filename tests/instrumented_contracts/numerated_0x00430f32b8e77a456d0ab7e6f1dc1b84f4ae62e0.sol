1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData); }
4 contract owned {
5     address public owner;
6 
7     function owned() {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner {
17         owner = newOwner;
18     }
19 }
20 contract MyToken is owned {
21     // Public variables of the token
22     string public name = "Empyrean Mark";
23     string public symbol = "MARK";
24     uint8 public decimals;
25     uint256 public totalSupply;
26 
27     // This creates an array with all balances
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     // This generates a public event on the blockchain that will notify clients
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     // This notifies clients about the amount burnt
35     event Burn(address indexed from, uint256 value);
36 
37     /**
38      * Constructor function
39      *
40      * Initializes contract with initial supply tokens to the creator of the contract
41      */
42     function MyToken(
43         uint256 initialSupply,
44         string tokenName,
45         uint8 decimalUnits,
46         string tokenSymbol
47     ) {
48         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
49         totalSupply = initialSupply;                        // Update total supply
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52         decimals = decimalUnits;                            // Amount of decimals for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
60         require(balanceOf[_from] >= _value);                // Check if the sender has enough
61         require(balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
62         balanceOf[_from] -= _value;                         // Subtract from the sender
63         balanceOf[_to] += _value;                           // Add the same to the recipient
64         Transfer(_from, _to, _value);
65     }
66 
67     /**
68      * Transfer tokens
69      *
70      * Send `_value` tokens to `_to` from your account
71      *
72      * @param _to The address of the recipient
73      * @param _value the amount to send
74      */
75     function transfer(address _to, uint256 _value) {
76         _transfer(msg.sender, _to, _value);
77     }
78 
79     /**
80      * Transfer tokens from other address
81      *
82      * Send `_value` tokens to `_to` in behalf of `_from`
83      *
84      * @param _from The address of the sender
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);     // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      *
98      * Allows `_spender` to spend no more than `_value` tokens in your behalf
99      *
100      * @param _spender The address authorized to spend
101      * @param _value the max amount they can spend
102      */
103     function approve(address _spender, uint256 _value)
104         returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address and notify
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      * @param _extraData some extra information to send to the approved contract
117      */
118     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
119         returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     /**
128      * Destroy tokens
129      *
130      * Remove `_value` tokens from the system irreversibly
131      *
132      * @param _value the amount of money to burn
133      */
134     function burn(uint256 _value) returns (bool success) {
135         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
136         balanceOf[msg.sender] -= _value;            // Subtract from the sender
137         totalSupply -= _value;                      // Updates totalSupply
138         Burn(msg.sender, _value);
139         return true;
140     }
141 
142     /**
143      * Destroy tokens from other ccount
144      *
145      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
146      *
147      * @param _from the address of the sender
148      * @param _value the amount of money to burn
149      */
150     function burnFrom(address _from, uint256 _value) returns (bool success) {
151         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
152         require(_value <= allowance[_from][msg.sender]);    // Check allowance
153         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
154         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
155         totalSupply -= _value;                              // Update totalSupply
156         Burn(_from, _value);
157         return true;
158     }
159 
160     /**
161      * New tokens can be minted
162      *
163      * Allows owner account to mint new tokens, or remove tokens from supply as needed
164      *
165      */
166     function mintToken(address target, uint256 mintedAmount) onlyOwner {
167         balanceOf[target] += mintedAmount;
168         totalSupply += mintedAmount;
169         Transfer(0, owner, mintedAmount);
170         Transfer(owner, target, mintedAmount);
171     }
172 }