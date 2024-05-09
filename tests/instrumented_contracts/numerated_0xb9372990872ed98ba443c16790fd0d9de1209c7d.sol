1 pragma solidity ^0.4.16;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract BAHACAN {
6     // Public variables of the token
7     string public name;
8     string public symbol;
9     uint8 public decimals = 8;
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
24      * Constructor function
25      *
26      * Initializes contract with initial supply tokens to the creator of the contract
27      */
28 	 
29     function BAHACAN(
30         uint256 initialSupply,
31         string tokenName,
32         string tokenSymbol
33     ) public {
34         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
35         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
36         name = tokenName;                                   // Set the name for display purposes
37         symbol = tokenSymbol;                               // Set the symbol for display purposes
38     }
39 
40     /**
41      * Internal transfer, only can be called by this contract
42      */
43     function _transfer(address _from, address _to, uint _value) internal {
44         // Prevent transfer to 0x0 address. Use burn() instead
45         require(_to != 0x0);
46         // Check if the sender has enough
47         require(balanceOf[_from] >= _value);
48         // Check for overflows
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         // Save this for an assertion in the future
51         uint previousBalances = balanceOf[_from] + balanceOf[_to];
52         // Subtract from the sender
53         balanceOf[_from] -= _value;
54         // Add the same to the recipient
55         balanceOf[_to] += _value;
56         Transfer(_from, _to, _value);
57         // Asserts are used to use static analysis to find bugs in your code. They should never fail
58         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
59     }
60 
61     /**
62      * Transfer tokens
63      *
64      * Send `_value` tokens to `_to` from your account
65      *
66      * @param _to The address of the recipient
67      * @param _value the amount to send
68      */
69     function transfer(address _to, uint256 _value) public {
70         _transfer(msg.sender, _to, _value);
71     }
72 
73     /**
74      * Transfer tokens from other address
75      *
76      * Send `_value` tokens to `_to` on behalf of `_from`
77      *
78      * @param _from The address of the sender
79      * @param _to The address of the recipient
80      * @param _value the amount to send
81      */
82     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
83         require(_value <= allowance[_from][msg.sender]);     // Check allowance
84         allowance[_from][msg.sender] -= _value;
85         _transfer(_from, _to, _value);
86         return true;
87     }
88 	
89     function multiPartyTransfer(address[] _toAddresses, uint256[] _amounts) public {
90         require(_toAddresses.length <= 255);
91         require(_toAddresses.length == _amounts.length);
92 
93         for (uint8 i = 0; i < _toAddresses.length; i++) {
94             transfer(_toAddresses[i], _amounts[i]);
95         }
96     }
97 
98     function multiPartyTransferFrom(address _from, address[] _toAddresses, uint256[] _amounts) public {
99         require(_toAddresses.length <= 255);
100         require(_toAddresses.length == _amounts.length);
101 
102         for (uint8 i = 0; i < _toAddresses.length; i++) {
103             transferFrom(_from, _toAddresses[i], _amounts[i]);
104         }
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens on your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115 	 
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131 	 
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149 	 
150     function burn(uint256 _value) public returns (bool success) {
151         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
152         balanceOf[msg.sender] -= _value;            // Subtract from the sender
153         totalSupply -= _value;                      // Updates totalSupply
154         Burn(msg.sender, _value);
155         return true;
156     }
157 
158     /**
159      * Destroy tokens from other account
160      *
161      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
162      *
163      * @param _from the address of the sender
164      * @param _value the amount of money to burn
165      */
166 	 
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172         totalSupply -= _value;                              // Update totalSupply
173         Burn(_from, _value);
174         return true;
175     }
176 }