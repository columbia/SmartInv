1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     constructor() public {
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
24     // Moneybrain BiPS 
25     string public name;
26     // BiPS 
27     string public symbol;
28     uint8 public decimals = 18;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     // 500 millions, 500000000 
31     uint256 public totalSupply;
32 
33     // This creates an array with all balances
34     mapping (address => uint256) public balanceOf;
35     mapping (address => mapping (address => uint256)) public allowance;
36 
37     // This generates a public event on the blockchain that will notify clients
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     
40     // This generates a public event on the blockchain that will notify clients
41     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     constructor(
52         uint256 initialSupply,
53         string tokenName,
54         string tokenSymbol
55     ) public {
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58         name = tokenName;                                   // Set the name for display purposes
59         symbol = tokenSymbol;                               // Set the symbol for display purposes
60     }
61 
62     /**
63      * Internal transfer, only can be called by this contract
64      */
65     function _transfer(address _from, address _to, uint _value) internal {
66         // Prevent transfer to 0x0 address. Use burn() instead
67         require(_to != 0x0);
68         // Check if the sender has enough
69         require(balanceOf[_from] >= _value);
70         // Check for overflows
71         require(balanceOf[_to] + _value > balanceOf[_to]);
72         // Save this for an assertion in the future
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         // Subtract from the sender
75         balanceOf[_from] -= _value;
76         // Add the same to the recipient
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         // Asserts are used to use static analysis to find bugs in your code. They should never fail
80         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
81     }
82 
83     /**
84      * Transfer tokens
85      *
86      * Send `_value` tokens to `_to` from your account
87      *
88      * @param _to The address of the recipient
89      * @param _value the amount to send
90      */
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     /**
97      * Transfer tokens from other address
98      *
99      * Send `_value` tokens to `_to` in behalf of `_from`
100      *
101      * @param _from The address of the sender
102      * @param _to The address of the recipient
103      * @param _value the amount to send
104      */
105     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
106         require(_value <= allowance[_from][msg.sender]);     // Check allowance
107         allowance[_from][msg.sender] -= _value;
108         _transfer(_from, _to, _value);
109         return true;
110     }
111 
112     /**
113      * Set allowance for other address
114      *
115      * Allows `_spender` to spend no more than `_value` tokens in your behalf
116      *
117      * @param _spender The address authorized to spend
118      * @param _value the max amount they can spend
119      */
120     function approve(address _spender, uint256 _value) public
121         returns (bool success) {
122         allowance[msg.sender][_spender] = _value;
123         emit Approval(msg.sender, _spender, _value);
124         return true;
125     }
126 
127     /**
128      * Set allowance for other address and notify
129      *
130      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
131      *
132      * @param _spender The address authorized to spend
133      * @param _value the max amount they can spend
134      * @param _extraData some extra information to send to the approved contract
135      */
136     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
137         public
138         returns (bool success) {
139         tokenRecipient spender = tokenRecipient(_spender);
140         if (approve(_spender, _value)) {
141             spender.receiveApproval(msg.sender, _value, this, _extraData);
142             return true;
143         }
144     }
145 
146     /**
147      * Destroy tokens
148      *
149      * Remove `_value` tokens from the system irreversibly
150      *
151      * @param _value the amount of money to burn
152      */
153     function burn(uint256 _value) public returns (bool success) {
154         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
155         balanceOf[msg.sender] -= _value;            // Subtract from the sender
156         totalSupply -= _value;                      // Updates totalSupply
157         emit Burn(msg.sender, _value);
158         return true;
159     }
160 
161     /**
162      * Destroy tokens from other account
163      *
164      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
165      *
166      * @param _from the address of the sender
167      * @param _value the amount of money to burn
168      */
169     function burnFrom(address _from, uint256 _value) public returns (bool success) {
170         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
171         require(_value <= allowance[_from][msg.sender]);    // Check allowance
172         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
173         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
174         totalSupply -= _value;                              // Update totalSupply
175         emit Burn(_from, _value);
176         return true;
177     }
178 }
179 
180 /******************************************/
181 /*       ADVANCED TOKEN STARTS HERE       */
182 /******************************************/
183 
184 contract MoneybrainBips is owned, TokenERC20 {
185 
186     uint256 public sellPrice;
187     uint256 public buyPrice;
188 
189     mapping (address => bool) public frozenAccount;
190 
191     /* This generates a public event on the blockchain that will notify clients */
192     event FrozenFunds(address target, bool frozen);
193 
194     /* Initializes contract with initial supply tokens to the creator of the contract */
195     constructor(
196         uint256 initialSupply,
197         string tokenName,
198         string tokenSymbol
199     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
200 
201     /* Internal transfer, only can be called by this contract */
202     function _transfer(address _from, address _to, uint _value) internal {
203         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
204         require (balanceOf[_from] >= _value);               // Check if the sender has enough
205         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
206         require(!frozenAccount[_from]);                     // Check if sender is frozen
207         require(!frozenAccount[_to]);                       // Check if recipient is frozen
208         balanceOf[_from] -= _value;                         // Subtract from the sender
209         balanceOf[_to] += _value;                           // Add the same to the recipient
210         emit Transfer(_from, _to, _value);
211     }
212 
213     /// @notice Create `mintedAmount` tokens and send it to `target`
214     /// @param target Address to receive the tokens
215     /// @param mintedAmount the amount of tokens it will receive
216     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
217         balanceOf[target] += mintedAmount;
218         totalSupply += mintedAmount;
219         emit Transfer(0, this, mintedAmount);
220         emit Transfer(this, target, mintedAmount);
221     }
222 
223     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
224     /// @param target Address to be frozen
225     /// @param freeze either to freeze it or not
226     function freezeAccount(address target, bool freeze) onlyOwner public {
227         frozenAccount[target] = freeze;
228         emit FrozenFunds(target, freeze);
229     }
230 
231     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
232     /// @param newSellPrice Price the users can sell to the contract
233     /// @param newBuyPrice Price users can buy from the contract
234     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
235         sellPrice = newSellPrice;
236         buyPrice = newBuyPrice;
237     }
238 
239     /// @notice Buy tokens from contract by sending ether
240     function buy() payable public {
241         uint amount = msg.value / buyPrice;               // calculates the amount
242         _transfer(this, msg.sender, amount);              // makes the transfers
243     }
244 
245     /// @notice Sell `amount` tokens to contract
246     /// @param amount amount of tokens to be sold
247     function sell(uint256 amount) public {
248         address myAddress = this;
249         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
250         _transfer(msg.sender, this, amount);              // makes the transfers
251         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
252     }
253 }