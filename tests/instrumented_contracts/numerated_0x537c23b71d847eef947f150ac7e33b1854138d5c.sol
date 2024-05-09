1 pragma solidity ^0.4.25;
2 
3 // SWISS TURBO TOKEN
4 //
5 //PDF LINK TO BE INCORPORATED INSIDE THE CONTRACT: https://drive.google.com/file/d/1tnb7sV8Oes8Eu3Vv6sZZQF5VtFU2BH7l/view
6 //
7 //TOKEN NAME – SWTT 
8 //
9 //Company name - SWISS TURBO
10 //
11 //Total Token supply – 50000
12 //
13 //Tokens for sale – 50000
14 //
15 //Owner - 0xCD6011A9D3995A693F9964608D08EDbb48220225
16 //
17 // Website Url - https://swiss-turbo.com
18 //
19 //Email - info@swiss-turbo.com
20 
21 
22 contract owned {
23     address public owner;
24 
25     modifier onlyOwner {
26         require(msg.sender == owner);
27         _;
28     }
29 
30     function transferOwnership(address newOwner) onlyOwner public {
31         owner = newOwner;
32     }
33 }
34 
35 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
36 
37 contract ERC20 is owned {
38     // Public variables of the token
39     string public name = "SWTT";
40     string public symbol = "SWTT";
41     uint8 public decimals = 18;
42     uint256 public totalSupply = 50000 * 10 ** uint256(decimals);
43     
44      string public contract_link = "https://drive.google.com/file/d/1tnb7sV8Oes8Eu3Vv6sZZQF5VtFU2BH7l/view"; 
45      
46     // This creates an array with all balances
47     mapping (address => uint256) public balanceOf;
48     mapping (address => mapping (address => uint256)) public allowance;
49     mapping (address => bool) public frozenAccount;
50    
51     // This generates a public event on the blockchain that will notify clients
52     event Transfer(address indexed from, address indexed to, uint256 value);
53 
54     /* This generates a public event on the blockchain that will notify clients */
55     event FrozenFunds(address target, bool frozen);
56     
57     // This notifies clients about the amount burnt
58     event Burn(address indexed from, uint256 value);
59 
60     /**
61      * Constrctor function
62      *
63      * Initializes contract with initial supply tokens to the creator of the contract
64      */
65     
66     constructor () public {
67          owner = 0xCD6011A9D3995A693F9964608D08EDbb48220225;
68          balanceOf[owner] = totalSupply;
69     }
70 
71     /**
72      * Internal transfer, only can be called by this contract
73      */
74     function _transfer(address _from, address _to, uint256 _value) internal {
75         // Prevent transfer to 0x0 address. Use burn() instead
76         require(_to != 0x0);
77         // Check if the sender has enough
78         require(balanceOf[_from] >= _value);
79         // Check for overflows
80         require(balanceOf[_to] + _value > balanceOf[_to]);
81         // Check if sender is frozen
82         require(!frozenAccount[_from]);
83         // Check if recipient is frozen
84         require(!frozenAccount[_to]);
85         // Save this for an assertion in the future
86         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
87         // Subtract from the sender
88         balanceOf[_from] -= _value;
89         // Add the same to the recipient
90         balanceOf[_to] += _value;
91         emit Transfer(_from, _to, _value);
92         // Asserts are used to use static analysis to find bugs in your code. They should never fail
93         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
94     }
95 
96     /**
97      * Transfer tokens
98      *
99      * Send `_value` tokens to `_to` from your account
100      *
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transfer(address _to, uint256 _value) public {
105         _transfer(msg.sender, _to, _value);
106     }
107 
108     /**
109      * Transfer tokens from other address
110      *
111      * Send `_value` tokens to `_to` in behalf of `_from`
112      *
113      * @param _from The address of the sender
114      * @param _to The address of the recipient
115      * @param _value the amount to send
116      */
117     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
118         require(_value <= allowance[_from][msg.sender]);     // Check allowance
119         allowance[_from][msg.sender] -= _value;
120         _transfer(_from, _to, _value);
121         return true;
122     }
123 
124     /**
125      * Set allowance for other address
126      *
127      * Allows `_spender` to spend no more than `_value` tokens in your behalf
128      *
129      * @param _spender The address authorized to spend
130      * @param _value the max amount they can spend
131      */
132     function approve(address _spender, uint256 _value) public
133         returns (bool success) {
134         allowance[msg.sender][_spender] = _value;
135         return true;
136     }
137 
138     /**
139      * Set allowance for other address and notify
140      *
141      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
142      *
143      * @param _spender The address authorized to spend
144      * @param _value the max amount they can spend
145      * @param _extraData some extra information to send to the approved contract
146      */
147     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
148         public
149         returns (bool success) {
150         tokenRecipient spender = tokenRecipient(_spender);
151         if (approve(_spender, _value)) {
152             spender.receiveApproval(msg.sender, _value, this, _extraData);
153             return true;
154         }
155     }
156 
157     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
158     /// @param target Address to be frozen
159     /// @param freeze either to freeze it or not
160     function freezeAccount(address target, bool freeze) onlyOwner public {
161         frozenAccount[target] = freeze;
162         emit FrozenFunds(target, freeze);
163     }
164     /// @notice Create `mintedAmount` tokens and send it to `target`
165     /// @param target Address to receive the tokens
166     /// @param mintedAmount the amount of tokens it will receive
167     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
168         balanceOf[target] += mintedAmount;
169         totalSupply += mintedAmount;
170         emit Transfer(this, target, mintedAmount);
171     }
172     
173      /**
174      * Destroy tokens
175      *
176      * Remove `_value` tokens from the system irreversibly
177      *
178      * @param _value the amount of money to burn
179      */
180     function burn(uint256 _value) public returns (bool success) {
181         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
182         balanceOf[msg.sender] -= _value;            // Subtract from the sender
183         totalSupply -= _value;                      // Updates totalSupply
184         emit Burn(msg.sender, _value);
185         return true;
186     }
187 
188     /**
189      * Destroy tokens from other account
190      *
191      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
192      *
193      * @param _from the address of the sender
194      * @param _value the amount of money to burn
195      */
196     function burnFrom(address _from, uint256 _value) public returns (bool success) {
197         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
198         require(_value <= allowance[_from][msg.sender]);    // Check allowance
199         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
200         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
201         totalSupply -= _value;                              // Update totalSupply
202         emit Burn(_from, _value);
203         return true;
204     }
205 }