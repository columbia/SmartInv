1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name = "Lyu Test Token";
25     string public symbol = "LTT";
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply = 10000000000 * (10 ** 18);
29 
30     // This creates an array with all balances
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33 
34     // This generates a public event on the blockchain that will notify clients
35     event Transfer(address indexed from, address indexed to, uint256 value);
36 
37     // This notifies clients about the amount burnt
38     event Burn(address indexed from, uint256 value);
39 
40     /**
41      * Constrctor function
42      *
43      * Initializes contract with initial supply tokens to the creator of the contract
44      */
45     function TokenERC20(
46     ) public {
47         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
48     }
49 
50     /**
51      * Internal transfer, only can be called by this contract
52      */
53     function _transfer(address _from, address _to, uint _value) internal {
54         // Prevent transfer to 0x0 address. Use burn() instead
55         require(_to != 0x0);
56         // Check if the sender has enough
57         require(balanceOf[_from] >= _value);
58         // Check for overflows
59         require(balanceOf[_to] + _value > balanceOf[_to]);
60         // Save this for an assertion in the future
61         uint previousBalances = balanceOf[_from] + balanceOf[_to];
62         // Subtract from the sender
63         balanceOf[_from] -= _value;
64         // Add the same to the recipient
65         balanceOf[_to] += _value;
66         Transfer(_from, _to, _value);
67         // Asserts are used to use static analysis to find bugs in your code. They should never fail
68         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
69     }
70 
71     /**
72      * Transfer tokens
73      *
74      * Send `_value` tokens to `_to` from your account
75      *
76      * @param _to The address of the recipient
77      * @param _value the amount to send
78      */
79     function transfer(address _to, uint256 _value) public {
80         _transfer(msg.sender, _to, _value);
81     }
82 
83     /**
84      * Transfer tokens from other address
85      *
86      * Send `_value` tokens to `_to` in behalf of `_from`
87      *
88      * @param _from The address of the sender
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_value <= allowance[_from][msg.sender]);     // Check allowance
94         allowance[_from][msg.sender] -= _value;
95         _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     /**
100      * Set allowance for other address
101      *
102      * Allows `_spender` to spend no more than `_value` tokens in your behalf
103      *
104      * @param _spender The address authorized to spend
105      * @param _value the max amount they can spend
106      */
107     function approve(address _spender, uint256 _value) public
108         returns (bool success) {
109         allowance[msg.sender][_spender] = _value;
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address and notify
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      * @param _extraData some extra information to send to the approved contract
121      */
122     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
123         public
124         returns (bool success) {
125         tokenRecipient spender = tokenRecipient(_spender);
126         if (approve(_spender, _value)) {
127             spender.receiveApproval(msg.sender, _value, this, _extraData);
128             return true;
129         }
130     }
131 
132     /**
133      * Destroy tokens
134      *
135      * Remove `_value` tokens from the system irreversibly
136      *
137      * @param _value the amount of money to burn
138      */
139     function burn(uint256 _value) public returns (bool success) {
140         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
141         balanceOf[msg.sender] -= _value;            // Subtract from the sender
142         totalSupply -= _value;                      // Updates totalSupply
143         Burn(msg.sender, _value);
144         return true;
145     }
146 
147     /**
148      * Destroy tokens from other account
149      *
150      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
151      *
152      * @param _from the address of the sender
153      * @param _value the amount of money to burn
154      */
155     function burnFrom(address _from, uint256 _value) public returns (bool success) {
156         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
157         require(_value <= allowance[_from][msg.sender]);    // Check allowance
158         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
159         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
160         totalSupply -= _value;                              // Update totalSupply
161         Burn(_from, _value);
162         return true;
163     }
164 }
165 
166 /******************************************/
167 /*       LyuTestToken STARTS HERE         */
168 /******************************************/
169 
170 contract LyuTestToken is owned, TokenERC20 {
171 
172     uint256 public sellPrice;
173     uint256 public buyPrice;
174 
175     mapping (address => bool) public frozenAccount;
176 
177     /* This generates a public event on the blockchain that will notify clients */
178     event FrozenFunds(address target, bool frozen);
179 
180     /* Initializes contract with initial supply tokens to the creator of the contract */
181     function LyuTestToken(
182     ) TokenERC20() public {}
183 
184     /* Internal transfer, only can be called by this contract */
185     function _transfer(address _from, address _to, uint _value) internal {
186         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
187         require (balanceOf[_from] >= _value);               // Check if the sender has enough
188         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
189         require(!frozenAccount[_from]);                     // Check if sender is frozen
190         require(!frozenAccount[_to]);                       // Check if recipient is frozen
191         balanceOf[_from] -= _value;                         // Subtract from the sender
192         balanceOf[_to] += _value;                           // Add the same to the recipient
193         Transfer(_from, _to, _value);
194     }
195 
196     /// @notice Create `mintedAmount` tokens and send it to `target`
197     /// @param target Address to receive the tokens
198     /// @param mintedAmount the amount of tokens it will receive
199     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
200         balanceOf[target] += mintedAmount;
201         totalSupply += mintedAmount;
202         Transfer(0, this, mintedAmount);
203         Transfer(this, target, mintedAmount);
204     }
205 
206     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
207     /// @param target Address to be frozen
208     /// @param freeze either to freeze it or not
209     function freezeAccount(address target, bool freeze) onlyOwner public {
210         frozenAccount[target] = freeze;
211         FrozenFunds(target, freeze);
212     }
213 
214     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
215     /// @param newSellPrice Price the users can sell to the contract
216     /// @param newBuyPrice Price users can buy from the contract
217     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
218         sellPrice = newSellPrice;
219         buyPrice = newBuyPrice;
220     }
221 
222     /// @notice Buy tokens from contract by sending ether
223     function buy() payable public {
224         uint amount = msg.value / buyPrice;               // calculates the amount
225         _transfer(this, msg.sender, amount);              // makes the transfers
226     }
227 
228     /// @notice Sell `amount` tokens to contract
229     /// @param amount amount of tokens to be sold
230     function sell(uint256 amount) public {
231         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
232         _transfer(msg.sender, this, amount);              // makes the transfers
233         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
234     }
235 }