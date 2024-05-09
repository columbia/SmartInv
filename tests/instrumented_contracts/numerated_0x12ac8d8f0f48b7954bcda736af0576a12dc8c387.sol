1 pragma solidity ^0.4.19;
2 
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 contract OPL {
6     // Public variables
7     string public name;
8     string public symbol;
9     uint8 public decimals = 18; // 18 decimals
10     bool public adminVer = false;
11     address public owner;
12     uint256 public totalSupply;
13 
14     // This creates an array with all balances
15     mapping (address => uint256) public balanceOf;
16     mapping (address => mapping (address => uint256)) public allowance;
17 
18     // This generates a public event on the blockchain that will notify clients
19     event Transfer(address indexed from, address indexed to, uint256 value);
20 
21     // This notifies clients about the amount burnt
22     event Burn(address indexed from, uint256 value);
23 
24     // This notifies clients about the emission amount
25     event Emission(address indexed from, uint256 value);
26 
27     /**
28      * Constrctor function
29      *
30      * Initializes contract with initial supply tokens to the creator of the contract
31      */
32     function OPL() public {
33         totalSupply = 210000000 * 10 ** uint256(decimals);      // Update total supply with the decimal amount
34         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
35         name = 'OnPlace';                                           // Set the name for display purposes
36         symbol = 'OPL';                                         // Set the symbol for display purposes
37         owner = msg.sender;                                     // Contract owner
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     /**
46     * Check ownership
47     */
48     function checkAdmin() onlyOwner {
49         adminVer = true;
50     }
51 
52     /**
53      * Transfer ownership
54      *
55      * Change admin wallet
56      *
57      * @param newOwner is address of new admin wallet
58      */
59     function transferOwnership(address newOwner) onlyOwner {
60         owner = newOwner;
61         adminVer = false;
62     }
63 
64     /**
65      * Token emission
66      *
67      * Add `_value` tokens to the system
68      *
69      * @param _value the amount of money to add
70      */
71     function emission(uint256 _value) onlyOwner {
72         _value = _value * 10 ** uint256(decimals);
73         balanceOf[owner] += _value;  // Append to the sender
74         totalSupply += _value;       // Updates totalSupply
75         Emission(msg.sender, _value);
76     }
77 
78 
79     /**
80      * Internal transfer, only can be called by this contract
81      */
82     function _transfer(address _from, address _to, uint _value) internal {
83         // Prevent transfer to 0x0 address. Use burn() instead
84         require(_to != 0x0);
85         // Check if the sender has enough
86         require(balanceOf[_from] >= _value);
87         // Check for overflows
88         require(balanceOf[_to] + _value > balanceOf[_to]);
89         // Save this for an assertion in the future
90         uint previousBalances = balanceOf[_from] + balanceOf[_to];
91         // Subtract from the sender
92         balanceOf[_from] -= _value;
93         // Add the same to the recipient
94         balanceOf[_to] += _value;
95         Transfer(_from, _to, _value);
96         // Asserts are used to use static analysis to find bugs in your code. They should never fail
97         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
98     }
99 
100     /**
101      * Transfer tokens
102      *
103      * Send `_value` tokens to `_to` from your account
104      *
105      * @param _to The address of the recipient
106      * @param _value the amount to send
107      */
108     function transfer(address _to, uint256 _value) public {
109         _transfer(msg.sender, _to, _value);
110     }
111 
112     /**
113      * Transfer tokens from other address
114      *
115      * Send `_value` tokens to `_to` on behalf of `_from`
116      *
117      * @param _from The address of the sender
118      * @param _to The address of the recipient
119      * @param _value the amount to send
120      */
121     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
122         require(_value <= allowance[_from][msg.sender]);     // Check allowance
123         allowance[_from][msg.sender] -= _value;
124         _transfer(_from, _to, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address
130      *
131      * Allows `_spender` to spend no more than `_value` tokens on your behalf
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      */
136     function approve(address _spender, uint256 _value) public
137         returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address and notify
144      *
145      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      * @param _extraData some extra information to send to the approved contract
150      */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
152         public
153         returns (bool success) {
154         tokenRecipient spender = tokenRecipient(_spender);
155         if (approve(_spender, _value)) {
156             spender.receiveApproval(msg.sender, _value, this, _extraData);
157             return true;
158         }
159     }
160 
161     /**
162      * Destroy tokens
163      *
164      * Remove `_value` tokens from the system irreversibly
165      *
166      * @param _value the amount of money to burn
167      */
168     function burn(uint256 _value) public returns (bool success) {
169         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
170         balanceOf[msg.sender] -= _value;            // Subtract from the sender
171         totalSupply -= _value;                      // Updates totalSupply
172         Burn(msg.sender, _value);
173         return true;
174     }
175 
176     /**
177      * Destroy tokens
178      *
179      * Remove `_value` tokens from the system irreversibly
180      *
181      * @param _value the amount of money to burn
182      * @param _dec is decimals coeff
183      */
184     function burnWithDecimals(uint256 _value, uint256 _dec) public returns (bool success) {
185         _value = _value * 10 ** _dec;
186         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
187         balanceOf[msg.sender] -= _value;            // Subtract from the sender
188         totalSupply -= _value;                      // Updates totalSupply
189         Burn(msg.sender, _value);
190         return true;
191     }
192 
193     /**
194      * Destroy tokens from other account
195      *
196      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
197      *
198      * @param _from the address of the sender
199      * @param _value the amount of money to burn
200      */
201     function burnFrom(address _from, uint256 _value) public returns (bool success) {
202         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
203         require(_value <= allowance[_from][msg.sender]);    // Check allowance
204         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
205         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
206         totalSupply -= _value;                              // Update totalSupply
207         Burn(_from, _value);
208         return true;
209     }
210 }