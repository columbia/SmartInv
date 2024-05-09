1 // +----------------------------------------------------------------------
2 // | Copyright (c) 2019 FCTCN
3 // +----------------------------------------------------------------------
4 // | Licensed ( http://www.apache.org/licenses/LICENSE-2.0 )
5 // +----------------------------------------------------------------------
6 
7 pragma solidity ^0.4.16;
8 
9 contract owned {
10     address public owner;
11 
12     function owned() public { owner = msg.sender; }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     uint256 public totalSupply;
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // Event which is triggered to log all transfers to this contract's event log
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     // Event which is triggered whenever an owner approves a new allowance for a spender.
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Initialization Construction
45      */
46     function TokenERC20(uint256 _initialSupply, string _tokenName, string _tokenSymbol) public {
47         totalSupply = _initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
48         balanceOf[msg.sender] = totalSupply;                     // Give the creator all initial tokens
49         name = _tokenName;                                       // Set the name for display purposes
50         symbol = _tokenSymbol;                                   // Set the symbol for display purposes
51     }
52 
53     /**
54      * Internal Realization of Token Transaction Transfer
55      */
56     function _transfer(address _from, address _to, uint _value) internal {
57         require(_to != 0x0);                                            // Prevent transfer to 0x0 address. Use burn() instead
58         require(balanceOf[_from] >= _value);                            // Check if the sender has enough    
59         require(balanceOf[_to] + _value > balanceOf[_to]);              // Check for overflows
60 
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this for an assertion in the future
62         balanceOf[_from] -= _value;                                     // Subtract from the sender
63         balanceOf[_to] += _value;                                       // Add the same to the recipient
64         Transfer(_from, _to, _value);                                   // Notify anyone listening that this transfer took place
65 
66         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);  // Use assert to check code logic
67     }
68 
69     /**
70      * Transfer tokens
71      * Send `_value` tokens to `_to` from your account
72      *
73      * @param _to     The address of the recipient
74      * @param _value  The amount to send
75      */
76     function transfer(address _to, uint256 _value) public {
77         _transfer(msg.sender, _to, _value);
78     }
79 
80     /**
81      * Transfer tokens from other address
82      * Send `_value` tokens to `_to` in behalf of `_from`
83      *
84      * @param _from   The address of the sender
85      * @param _to     The address of the recipient
86      * @param _value  The amount to send
87      */
88     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
89         require(_value <= allowance[_from][msg.sender]);    // Check allowance
90         allowance[_from][msg.sender] -= _value;
91         _transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * Set allowance for other address
97      * Allows `_spender` to spend no more than `_value` tokens in your behalf
98      *
99      * @param _spender  The address authorized to spend
100      * @param _value    The max amount they can spend
101      */
102     function approve(address _spender, uint256 _value) public returns (bool success) {
103         allowance[msg.sender][_spender] = _value;
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address and notify
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
110      *
111      * @param _spender    The address authorized to spend
112      * @param _value      The max amount they can spend
113      * @param _extraData  Some extra information to send to the approved contract
114      */
115     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
116         tokenRecipient spender = tokenRecipient(_spender);
117         if (approve(_spender, _value)) {
118             spender.receiveApproval(msg.sender, _value, this, _extraData);
119             return true;
120         }
121     }
122 
123     /**
124      * Destroy tokens
125      * Remove `_value` tokens from the system irreversibly
126      *
127      * @param _value  The amount of money to burn
128      */
129     function burn(uint256 _value) public returns (bool success) {
130         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
131         balanceOf[msg.sender] -= _value;            // Subtract from the sender
132         totalSupply -= _value;                      // Updates totalSupply
133         Burn(msg.sender, _value);
134         return true;
135     }
136 
137     /**
138      * Destroy tokens from other account
139      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
140      *
141      * @param _from   The address of the sender
142      * @param _value  The amount of money to burn
143      */
144     function burnFrom(address _from, uint256 _value) public returns (bool success) {
145         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
146         require(_value <= allowance[_from][msg.sender]);    // Check allowance
147         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
148         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
149         totalSupply -= _value;                              // Update totalSupply
150         Burn(_from, _value);
151         return true;
152     }
153 }