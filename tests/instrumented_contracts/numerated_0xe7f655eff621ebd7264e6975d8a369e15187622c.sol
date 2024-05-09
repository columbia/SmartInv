1 // +----------------------------------------------------------------------
2 // | Copyright (c) 2019 OFEX Token (OFT)
3 // +----------------------------------------------------------------------
4 // | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
5 // +----------------------------------------------------------------------
6 // | TECHNICAL SUPPORT: HAO MA STUDIO
7 // +----------------------------------------------------------------------
8 
9 pragma solidity ^0.4.16;
10 
11 contract owned {
12     address public owner;
13 
14     function owned() public { owner = msg.sender; }
15 
16     modifier onlyOwner {
17         require(msg.sender == owner);
18         _;
19     }
20 
21     function transferOwnership(address newOwner) onlyOwner public {
22         owner = newOwner;
23     }
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract TokenERC20 {
29     uint256 public totalSupply;
30     string public name;
31     string public symbol;
32     uint8 public decimals = 18;
33 
34     // This creates an array with all balances
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     // Event which is triggered to log all transfers to this contract's event log
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     // Event which is triggered whenever an owner approves a new allowance for a spender.
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42     // This notifies clients about the amount burnt
43     event Burn(address indexed from, uint256 value);
44 
45     /**
46      * Initialization Construction
47      */
48     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
49         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                     // Give the creator all initial tokens
51         name = _tokenName;                                       // Set the name for display purposes
52         symbol = _tokenSymbol;                                   // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal Realization of Token Transaction Transfer
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         require(_to != 0x0);                                            // Prevent transfer to 0x0 address. Use burn() instead
60         require(balanceOf[_from] >= _value);                            // Check if the sender has enough    
61         require(balanceOf[_to] + _value > balanceOf[_to]);              // Check for overflows
62 
63         uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this for an assertion in the future
64         balanceOf[_from] -= _value;                                     // Subtract from the sender
65         balanceOf[_to] += _value;                                       // Add the same to the recipient
66         Transfer(_from, _to, _value);                                   // Notify anyone listening that this transfer took place
67 
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Use assert to check code logic
69     }
70 
71     /**
72      * Transfer tokens
73      * Send `_value` tokens to `_to` from your account
74      *
75      * @param _to     The address of the recipient
76      * @param _value  The amount to send
77      */
78     function transfer(address _to, uint256 _value) public {
79         _transfer(msg.sender, _to, _value);
80     }
81 
82     /**
83      * Transfer tokens from other address
84      * Send `_value` tokens to `_to` in behalf of `_from`
85      *
86      * @param _from   The address of the sender
87      * @param _to     The address of the recipient
88      * @param _value  The amount to send
89      */
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         require(_value <= allowance[_from][msg.sender]);    // Check allowance
92         allowance[_from][msg.sender] -= _value;
93         _transfer(_from, _to, _value);
94         return true;
95     }
96 
97     /**
98      * Set allowance for other address
99      * Allows `_spender` to spend no more than `_value` tokens in your behalf
100      *
101      * @param _spender  The address authorized to spend
102      * @param _value    The max amount they can spend
103      */
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         allowance[msg.sender][_spender] = _value;
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address and notify
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
112      *
113      * @param _spender    The address authorized to spend
114      * @param _value      The max amount they can spend
115      * @param _extraData  Some extra information to send to the approved contract
116      */
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
118         tokenRecipient spender = tokenRecipient(_spender);
119         if (approve(_spender, _value)) {
120             spender.receiveApproval(msg.sender, _value, this, _extraData);
121             return true;
122         }
123     }
124 
125     /**
126      * Destroy tokens
127      * Remove `_value` tokens from the system irreversibly
128      *
129      * @param _value  The amount of money to burn
130      */
131     function burn(uint256 _value) public returns (bool success) {
132         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
133         balanceOf[msg.sender] -= _value;            // Subtract from the sender
134         totalSupply -= _value;                      // Updates totalSupply
135         Burn(msg.sender, _value);
136         return true;
137     }
138 
139     /**
140      * Destroy tokens from other account
141      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
142      *
143      * @param _from   The address of the sender
144      * @param _value  The amount of money to burn
145      */
146     function burnFrom(address _from, uint256 _value) public returns (bool success) {
147         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
148         require(_value <= allowance[_from][msg.sender]);    // Check allowance
149         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
150         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
151         totalSupply -= _value;                              // Update totalSupply
152         Burn(_from, _value);
153         return true;
154     }
155 }