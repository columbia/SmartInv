1 pragma solidity ^0.4.20;
2 
3 
4 interface tokenRecipient {
5     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
6 }
7 
8 
9 contract owned {
10     address public owner;
11 
12     function owned() public {
13         owner = msg.sender;
14     }
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
26 
27 contract ERC20Token {
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     uint256 public totalSupply;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) private allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39 
40     // This notifies clients about the amount burnt
41     event Burn(address indexed from, uint256 value);
42 
43     /**
44      * Initializes contract with initial supply tokens to the creator of the contract
45      */
46     function ERC20Token(uint256 initialSupply, string tokenName, string tokenSymbol) public {
47         totalSupply = initialSupply * 10 ** uint256(decimals);
48         balanceOf[msg.sender] = totalSupply;
49         name = tokenName;
50         symbol = tokenSymbol;
51     }
52 
53     /**
54      * Set allowance for other address
55      *
56      * Allows `_spender` to spend no more than `_value` tokens in your behalf
57      *
58      * @param _spender The address authorized to spend
59      * @param _value the max amount they can spend
60      */
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         return true;
64     }
65 
66     /**
67      * Set allowance for other address and notify
68      *
69      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
70      *
71      * @param _spender The address authorized to spend
72      * @param _value the max amount they can spend
73      * @param _extraData some extra information to send to the approved contract
74      */
75     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
76         tokenRecipient spender = tokenRecipient(_spender);
77         if (approve(_spender, _value)) {
78             spender.receiveApproval(msg.sender, _value, this, _extraData);
79             return true;
80         }
81     }
82 
83     /**
84      * Destroy tokens
85      *
86      * Remove `_value` tokens from the system irreversibly
87      *
88      * @param _value the amount of money to burn
89      */
90     function burn(uint256 _value) public returns (bool success) {
91         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
92         balanceOf[msg.sender] -= _value;            // Subtract from the sender
93         totalSupply -= _value;                      // Updates totalSupply
94         Burn(msg.sender, _value);
95         return true;
96     }
97 
98     /**
99      * Destroy tokens from other account
100      *
101      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
102      *
103      * @param _from the address of the sender
104      * @param _value the amount of money to burn
105      */
106     function burnFrom(address _from, uint256 _value) public returns (bool success) {
107         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
108         require(_value <= allowance[_from][msg.sender]);    // Check allowance
109         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
110         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
111         totalSupply -= _value;                              // Update totalSupply
112         Burn(_from, _value);
113         return true;
114     }
115 
116     /**
117      * Transfer tokens
118      *
119      * Send `_value` tokens to `_to` from your account
120      *
121      * @param _to The address of the recipient
122      * @param _value the amount to send
123      */
124     function transfer(address _to, uint256 _value) public {
125         _transfer(msg.sender, _to, _value);
126     }
127 
128     /**
129      * Transfer tokens from other address
130      *
131      * Send `_value` tokens to `_to` in behalf of `_from`
132      *
133      * @param _from The address of the sender
134      * @param _to The address of the recipient
135      * @param _value the amount to send
136      */
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
138         require(_value <= allowance[_from][msg.sender]);     // Check allowance
139         allowance[_from][msg.sender] -= _value;              // Subtract from the targeted balance
140         _transfer(_from, _to, _value);
141         return true;
142     }
143 
144     /**
145      * Internal transfer, only can be called by this contract
146      */
147     function _transfer(address _from, address _to, uint _value) internal {
148         require(_to != 0x0);                                            // Prevent transfer to 0x0 address. Use burn() instead
149         require(balanceOf[_from] >= _value);                            // Check if the sender has enough
150         require(balanceOf[_to] + _value > balanceOf[_to]);              // Check for overflows
151         uint previousBalances = balanceOf[_from] + balanceOf[_to];      // Save this for an assertion in the future
152         balanceOf[_from] -= _value;                                     // Subtract from the sender
153         balanceOf[_to] += _value;                                       // Add the same to the recipient
154         Transfer(_from, _to, _value);
155         // Asserts are used to use static analysis to find bugs in your code. They should never fail
156         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
157     }
158 
159 }
160 
161 
162 contract HereCoin is ERC20Token, owned {
163 
164     uint256 private buyPrice;
165     uint256 private sellPrice;
166 
167     mapping (address => bool) public frozenAccount;
168 
169     /* This generates a public event on the blockchain that will notify clients */
170     event FrozenFunds(address target, bool frozen);
171 
172     /* Initializes contract with initial supply tokens to the creator of the contract */
173     function HereCoin() ERC20Token(100000000, "HereCo.in", "HERE") public {}
174 
175     /* Internal transfer, only can be called by this contract */
176     function _transfer(address _from, address _to, uint _value) internal {
177         require (_to != 0x0);                                // Prevent transfer to 0x0 address. Use burn() instead
178         require (balanceOf[_from] >= _value);                // Check if the sender has enough
179         require (balanceOf[_to] + _value > balanceOf[_to]);  // Check for overflows
180         require(!frozenAccount[_from]);                      // Check if sender is frozen
181         require(!frozenAccount[_to]);                        // Check if recipient is frozen
182         balanceOf[_from] -= _value;                          // Subtract from the sender
183         balanceOf[_to] += _value;                            // Add the same to the recipient
184         Transfer(_from, _to, _value);
185     }
186 
187     /// @notice Create `mintedAmount` tokens and send it to `target`
188     /// @param target Address to receive the tokens
189     /// @param mintedAmount the amount of tokens it will receive
190     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
191         balanceOf[target] += mintedAmount;
192         totalSupply += mintedAmount;
193         Transfer(0, this, mintedAmount);
194         Transfer(this, target, mintedAmount);
195     }
196 
197     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
198     /// @param target Address to be frozen
199     /// @param freeze either to freeze it or not
200     function freezeAccount(address target, bool freeze) onlyOwner public {
201         frozenAccount[target] = freeze;
202         FrozenFunds(target, freeze);
203     }
204 
205     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
206     /// @param newBuyPrice Price users can buy from the contract
207     /// @param newSellPrice Price the users can sell to the contract
208     function setPrices(uint256 newBuyPrice, uint256 newSellPrice) onlyOwner public {
209         buyPrice = newBuyPrice;
210         sellPrice = newSellPrice;
211     }
212 
213     /* msg.value will be in wei so buyPrice is price per 0.000000000000000001 HERE */
214     /// @notice Buy tokens from contract by sending ether
215     function buy() payable public {
216         uint amount = msg.value / buyPrice;               // calculates the amount
217         _transfer(this, msg.sender, amount);              // makes the transfers
218     }
219 
220     /// @notice Sell `amount` tokens to contract (1 amount = 0.000000000000000001 HERE)
221     /// @param amount amount of tokens to be sold
222     function sell(uint256 amount) public {
223         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
224         _transfer(msg.sender, this, amount);              // makes the transfers
225         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
226     }
227 
228 }