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
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
21 
22 contract TokenERC20 {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
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
46         uint256 initialSupply,
47         string tokenName,
48         string tokenSymbol
49     ) public {
50         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
51         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;                               // Set the symbol for display purposes
54     }
55 
56     /**
57      * Internal transfer, only can be called by this contract
58      */
59     function _transfer(address _from, address _to, uint _value) internal {
60         // Prevent transfer to 0x0 address. Use burn() instead
61         require(_to != 0x0);
62         // Check if the sender has enough
63         require(balanceOf[_from] >= _value);
64         // Check for overflows
65         require(balanceOf[_to] + _value > balanceOf[_to]);
66         // Save this for an assertion in the future
67         uint previousBalances = balanceOf[_from] + balanceOf[_to];
68         // Subtract from the sender
69         balanceOf[_from] -= _value;
70         // Add the same to the recipient
71         balanceOf[_to] += _value;
72         emit Transfer(_from, _to, _value);
73         // Asserts are used to use static analysis to find bugs in your code. They should never fail
74         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
75     }
76 
77     /**
78      * Transfer tokens
79      *
80      * Send `_value` tokens to `_to` from your account
81      *
82      * @param _to The address of the recipient
83      * @param _value the amount to send
84      */
85     function transfer(address _to, uint256 _value) public returns (bool success) {
86         _transfer(msg.sender, _to, _value);
87         return true;
88     }
89 
90     /**
91      * Transfer tokens from other address
92      *
93      * Send `_value` tokens to `_to` in behalf of `_from`
94      *
95      * @param _from The address of the sender
96      * @param _to The address of the recipient
97      * @param _value the amount to send
98      */
99     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         return true;
118     }
119 
120     /**
121      * Set allowance for other address and notify
122      *
123      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
124      *
125      * @param _spender The address authorized to spend
126      * @param _value the max amount they can spend
127      * @param _extraData some extra information to send to the approved contract
128      */
129     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
130         public
131         returns (bool success) {
132         tokenRecipient spender = tokenRecipient(_spender);
133         if (approve(_spender, _value)) {
134             spender.receiveApproval(msg.sender, _value, this, _extraData);
135             return true;
136         }
137     }
138 
139     /**
140      * Destroy tokens
141      *
142      * Remove `_value` tokens from the system irreversibly
143      *
144      * @param _value the amount of money to burn
145      */
146     function burn(uint256 _value) public returns (bool success) {
147         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
148         balanceOf[msg.sender] -= _value;            // Subtract from the sender
149         totalSupply -= _value;                      // Updates totalSupply
150         emit Burn(msg.sender, _value);
151         return true;
152     }
153 
154     /**
155      * Destroy tokens from other account
156      *
157      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
158      *
159      * @param _from the address of the sender
160      * @param _value the amount of money to burn
161      */
162     function burnFrom(address _from, uint256 _value) public returns (bool success) {
163         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
164         require(_value <= allowance[_from][msg.sender]);    // Check allowance
165         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
166         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
167         totalSupply -= _value;                              // Update totalSupply
168         emit Burn(_from, _value);
169         return true;
170     }
171 }
172 
173 /******************************************/
174 /*       ADVANCED TOKEN STARTS HERE       */
175 /******************************************/
176 
177 contract MoonToken is owned, TokenERC20 {
178 
179     uint256 public sellPrice;
180     uint256 public buyPrice;
181 
182     mapping (address => bool) public frozenAccount;
183 
184     /* This generates a public event on the blockchain that will notify clients */
185     event FrozenFunds(address target, bool frozen);
186 
187     /* Initializes contract with initial supply tokens to the creator of the contract */
188     function MoonToken(
189         uint256 initialSupply,
190         string tokenName,
191         string tokenSymbol
192     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
193 
194     /* Internal transfer, only can be called by this contract */
195     function _transfer(address _from, address _to, uint _value) internal {
196         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
197         require (balanceOf[_from] >= _value);               // Check if the sender has enough
198         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
199         require(!frozenAccount[_from]);                     // Check if sender is frozen
200         require(!frozenAccount[_to]);                       // Check if recipient is frozen
201         balanceOf[_from] -= _value;                         // Subtract from the sender
202         balanceOf[_to] += _value;                           // Add the same to the recipient
203         emit Transfer(_from, _to, _value);
204     }
205 
206     /// @notice Create `mintedAmount` tokens and send it to `target`
207     /// @param target Address to receive the tokens
208     /// @param mintedAmount the amount of tokens it will receive
209     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
210         balanceOf[target] += mintedAmount;
211         totalSupply += mintedAmount;
212         emit Transfer(0, this, mintedAmount);
213         emit Transfer(this, target, mintedAmount);
214     }
215 
216     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
217     /// @param target Address to be frozen
218     /// @param freeze either to freeze it or not
219     function freezeAccount(address target, bool freeze) onlyOwner public {
220         frozenAccount[target] = freeze;
221         emit FrozenFunds(target, freeze);
222     }
223 
224     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
225     /// @param newSellPrice Price the users can sell to the contract
226     /// @param newBuyPrice Price users can buy from the contract
227     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
228         sellPrice = newSellPrice;
229         buyPrice = newBuyPrice;
230     }
231 
232     /// @notice Buy tokens from contract by sending ether
233     function buy() payable public {
234         uint amount = msg.value / buyPrice;               // calculates the amount
235         _transfer(this, msg.sender, amount);              // makes the transfers
236     }
237 
238     /// @notice Sell `amount` tokens to contract
239     /// @param amount amount of tokens to be sold
240     function sell(uint256 amount) public {
241         address myAddress = this;
242         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
243         _transfer(msg.sender, this, amount);              // makes the transfers
244         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
245     }
246 }