1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     modifier onlyOwner {
7         require(msg.sender == owner);
8         _;
9     }
10 
11     function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 
16 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
17 
18 contract ERC20 is owned {
19     // Public variables of the token
20     string public name = "hylos";
21     string public symbol = "HYT";
22     uint8 public decimals = 18;
23     uint256 public totalSupply = 900000000 * 10 ** uint256(decimals);
24     uint256 public releaseDate = 1577750400;
25     uint256 public holdedToken = 300000000 * 10 ** uint256(decimals);
26 
27 
28     // This creates an array with all balances
29     mapping (address => uint256) public balanceOf;
30     mapping (address => mapping (address => uint256)) public allowance;
31     mapping (address => bool) public frozenAccount;
32    
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /* This generates a public event on the blockchain that will notify clients */
37     event FrozenFunds(address target, bool frozen);
38     
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     
48     constructor (address _owner) public {
49          owner = _owner;
50          balanceOf[owner] = totalSupply - holdedToken;
51          balanceOf[this] = holdedToken;
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint256 _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Check if sender is frozen
65         require(!frozenAccount[_from]);
66         // Check if recipient is frozen
67         require(!frozenAccount[_to]);
68         // Save this for an assertion in the future
69         uint256 previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         emit Transfer(_from, _to, _value);
75         // Asserts are used to use static analysis to find bugs in your code. They should never fail
76         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
77     }
78 
79     /**
80      * Transfer tokens
81      *
82      * Send `_value` tokens to `_to` from your account
83      *
84      * @param _to The address of the recipient
85      * @param _value the amount to send
86      */
87     function transfer(address _to, uint256 _value) public {
88         _transfer(msg.sender, _to, _value);
89     }
90 
91     /**
92      * Transfer tokens from other address
93      *
94      * Send `_value` tokens to `_to` in behalf of `_from`
95      *
96      * @param _from The address of the sender
97      * @param _to The address of the recipient
98      * @param _value the amount to send
99      */
100     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
101         require(_value <= allowance[_from][msg.sender]);     // Check allowance
102         allowance[_from][msg.sender] -= _value;
103         _transfer(_from, _to, _value);
104         return true;
105     }
106 
107     /**
108      * Set allowance for other address
109      *
110      * Allows `_spender` to spend no more than `_value` tokens in your behalf
111      *
112      * @param _spender The address authorized to spend
113      * @param _value the max amount they can spend
114      */
115     function approve(address _spender, uint256 _value) public
116         returns (bool success) {
117         allowance[msg.sender][_spender] = _value;
118         return true;
119     }
120 
121     /**
122      * Set allowance for other address and notify
123      *
124      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
125      *
126      * @param _spender The address authorized to spend
127      * @param _value the max amount they can spend
128      * @param _extraData some extra information to send to the approved contract
129      */
130     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
131         public
132         returns (bool success) {
133         tokenRecipient spender = tokenRecipient(_spender);
134         if (approve(_spender, _value)) {
135             spender.receiveApproval(msg.sender, _value, this, _extraData);
136             return true;
137         }
138     }
139 
140     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
141     /// @param target Address to be frozen
142     /// @param freeze either to freeze it or not
143     function freezeAccount(address target, bool freeze) onlyOwner public {
144         frozenAccount[target] = freeze;
145         emit FrozenFunds(target, freeze);
146     }
147     /// @notice Create `mintedAmount` tokens and send it to `target`
148     /// @param target Address to receive the tokens
149     /// @param mintedAmount the amount of tokens it will receive
150     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
151         balanceOf[target] += mintedAmount;
152         totalSupply += mintedAmount;
153         emit Transfer(this, target, mintedAmount);
154     }
155     
156      /**
157      * Destroy tokens
158      *
159      * Remove `_value` tokens from the system irreversibly
160      *
161      * @param _value the amount of money to burn
162      */
163     function burn(uint256 _value) public returns (bool success) {
164         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
165         balanceOf[msg.sender] -= _value;            // Subtract from the sender
166         totalSupply -= _value;                      // Updates totalSupply
167         emit Burn(msg.sender, _value);
168         return true;
169     }
170 
171     /**
172      * Destroy tokens from other account
173      *
174      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
175      *
176      * @param _from the address of the sender
177      * @param _value the amount of money to burn
178      */
179     function burnFrom(address _from, uint256 _value) public returns (bool success) {
180         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
181         require(_value <= allowance[_from][msg.sender]);    // Check allowance
182         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
183         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
184         totalSupply -= _value;                              // Update totalSupply
185         emit Burn(_from, _value);
186         return true;
187     }
188     
189     /**
190      * Release tokens
191      *
192      * Relese 300000000 tokens and send to _to address
193      *
194      * @param _to the address of the token receiver
195      */
196     function releseToken(address _to) onlyOwner public {
197         require(now >= releaseDate);                // Check if the targeted balance is enough
198         _transfer(this, _to, holdedToken);
199     }
200 }