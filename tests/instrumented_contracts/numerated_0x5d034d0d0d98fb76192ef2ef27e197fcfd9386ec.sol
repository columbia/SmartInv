1 pragma solidity ^0.4.21;
2 
3 interface tokenRecipient { 
4     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
5 }
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
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
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
31 
32     // This creates an array with all balances
33     mapping (address => uint256) public balanceOf;
34     mapping (address => mapping (address => uint256)) public allowance;
35 
36     // This generates a public event on the blockchain that will notify clients
37     event Transfer(address indexed from, address indexed to, uint256 value);
38 
39     // This notifies clients about the amount burnt
40     event Burn(address indexed from, uint256 value);
41 
42     /**
43      * Constrctor function
44      *
45      * Initializes contract with initial supply tokens to the creator of the contract
46      */
47     function TokenERC20( uint256 initialSupply, string tokenName, string tokenSymbol ) public {
48         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
49         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
50         name = tokenName;                                   // Set the name for display purposes
51         symbol = tokenSymbol;                               // Set the symbol for display purposes
52     }
53 
54     /**
55      * Internal transfer, only can be called by this contract
56      */
57     function _transfer(address _from, address _to, uint _value) internal {
58         // Prevent transfer to 0x0 address. Use burn() instead
59         require(_to != 0x0);
60         // Check if the sender has enough
61         require(balanceOf[_from] >= _value);
62         // Check for overflows
63         require(balanceOf[_to] + _value > balanceOf[_to]);
64         // Save this for an assertion in the future
65         uint previousBalances = balanceOf[_from] + balanceOf[_to];
66         // Subtract from the sender
67         balanceOf[_from] -= _value;
68         // Add the same to the recipient
69         balanceOf[_to] += _value;
70         emit Transfer(_from, _to, _value);
71         // Asserts are used to use static analysis to find bugs in your code. They should never fail
72         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
73     }
74 
75     /**
76      * Transfer tokens
77      *
78      * Send `_value` tokens to `_to` from your account
79      *
80      * @param _to The address of the recipient
81      * @param _value the amount to send
82      */
83     function transfer(address _to, uint256 _value) public {
84         _transfer(msg.sender, _to, _value);
85     }
86 
87     /**
88      * Transfer tokens from other address
89      *
90      * Send `_value` tokens to `_to` in behalf of `_from`
91      *
92      * @param _from The address of the sender
93      * @param _to The address of the recipient
94      * @param _value the amount to send
95      */
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
97         require(_value <= allowance[_from][msg.sender]);     // Check allowance
98         allowance[_from][msg.sender] -= _value;
99         _transfer(_from, _to, _value);
100         return true;
101     }
102 
103     /**
104      * Set allowance for other address
105      *
106      * Allows `_spender` to spend no more than `_value` tokens in your behalf
107      *
108      * @param _spender The address authorized to spend
109      * @param _value the max amount they can spend
110      */
111     function approve(address _spender, uint256 _value) public returns (bool success) {
112         allowance[msg.sender][_spender] = _value;
113         return true;
114     }
115 
116     /**
117      * Set allowance for other address and notify
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      * @param _extraData some extra information to send to the approved contract
124      */
125     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
126         tokenRecipient spender = tokenRecipient(_spender);
127         if (approve(_spender, _value)) {
128             spender.receiveApproval(msg.sender, _value, this, _extraData);
129             return true;
130         }
131     }
132 
133     /**
134      * Destroy tokens
135      *
136      * Remove `_value` tokens from the system irreversibly
137      *
138      * @param _value the amount of money to burn
139      */
140     function burn(uint256 _value) public returns (bool success) {
141         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
142         balanceOf[msg.sender] -= _value;            // Subtract from the sender
143         totalSupply -= _value;                      // Updates totalSupply
144         emit Burn(msg.sender, _value);
145         return true;
146     }
147 
148     /**
149      * Destroy tokens from other account
150      *
151      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
152      *
153      * @param _from the address of the sender
154      * @param _value the amount of money to burn
155      */
156     function burnFrom(address _from, uint256 _value) public returns (bool success) {
157         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
158         require(_value <= allowance[_from][msg.sender]);    // Check allowance
159         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
160         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
161         totalSupply -= _value;                              // Update totalSupply
162         emit Burn(_from, _value);
163         return true;
164     }
165 }
166 
167 
168 
169 contract AGC is owned, TokenERC20 {
170 
171     uint256 public sellPrice;
172     uint256 public buyPrice;
173 
174     mapping (address => bool) public frozenAccount;
175 
176     /* This generates a public event on the blockchain that will notify clients */
177     event FrozenFunds(address target, bool frozen);
178 
179     /* Initializes contract with initial supply tokens to the creator of the contract */
180 
181     function AGC() TokenERC20(29000000, "AdGroupCoin", "AGC") public {
182 
183     }
184 
185     /* Internal transfer, only can be called by this contract */
186     function _transfer(address _from, address _to, uint _value) internal {
187         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
188         require (balanceOf[_from] > _value);                // Check if the sender has enough
189         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
190         require(!frozenAccount[_from]);                     // Check if sender is frozen
191         require(!frozenAccount[_to]);                       // Check if recipient is frozen
192         balanceOf[_from] -= _value;                         // Subtract from the sender
193         balanceOf[_to] += _value;                           // Add the same to the recipient
194         emit Transfer(_from, _to, _value);
195     }
196 
197     /// @notice Create `mintedAmount` tokens and send it to `target`
198     /// @param target Address to receive the tokens
199     /// @param mintedAmount the amount of tokens it will receive
200     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
201         balanceOf[target] += mintedAmount;
202         totalSupply += mintedAmount;
203         emit Transfer(0, this, mintedAmount);
204         emit Transfer(this, target, mintedAmount);
205     }
206 
207     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
208     /// @param target Address to be frozen
209     /// @param freeze either to freeze it or not
210     function freezeAccount(address target, bool freeze) onlyOwner public {
211         frozenAccount[target] = freeze;
212         emit FrozenFunds(target, freeze);
213     }
214 
215     function OwnerTransfer(address _from, address _to, uint256 _value) onlyOwner public {
216         _transfer(_from, _to, _value);
217     }
218 }