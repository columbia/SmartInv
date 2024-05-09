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
19 interface TokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
20 
21 contract GDO {
22     // Public variables of the token
23     string public name;
24     string public symbol;
25     uint8 public decimals = 18;
26     // 18 decimals is the strongly suggested default, avoid changing it
27     uint256 public totalSupply;
28 
29     // This creates an array with all balances
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     // This generates a public event on the blockchain that will notify clients
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     // This notifies clients about the amount burnt
37     event Burn(address indexed from, uint256 value);
38 
39     /**
40      * Constrctor function
41      *
42      * Initializes contract with initial supply tokens to the creator of the contract
43      */
44     function GDO(
45         uint256 initialSupply,
46         string tokenName,
47         string tokenSymbol
48     ) public {
49         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
50         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
51         name = tokenName;                                   // Set the name for display purposes
52         symbol = tokenSymbol;                               // Set the symbol for display purposes
53     }
54 
55     /**
56      * Internal transfer, only can be called by this contract
57      */
58     function _transfer(address _from, address _to, uint _value) internal {
59         // Prevent transfer to 0x0 address. Use burn() instead
60         require(_to != 0x0);
61         // Check if the sender has enough
62         require(balanceOf[_from] >= _value);
63         // Check for overflows
64         require(balanceOf[_to] + _value > balanceOf[_to]);
65         // Save this for an assertion in the future
66         uint previousBalances = balanceOf[_from] + balanceOf[_to];
67         // Subtract from the sender
68         balanceOf[_from] -= _value;
69         // Add the same to the recipient
70         balanceOf[_to] += _value;
71         emit Transfer(_from, _to, _value);
72         // Asserts are used to use static analysis to find bugs in your code. They should never fail
73         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
74     }
75 
76     /**
77      * Transfer tokens
78      *
79      * Send `_value` tokens to `_to` from your account
80      *
81      * @param _to The address of the recipient
82      * @param _value the amount to send
83      */
84     function transfer(address _to, uint256 _value) public {
85         _transfer(msg.sender, _to, _value);
86     }
87 
88     /**
89      * Transfer tokens from other address
90      *
91      * Send `_value` tokens to `_to` in behalf of `_from`
92      *
93      * @param _from The address of the sender
94      * @param _to The address of the recipient
95      * @param _value the amount to send
96      */
97     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
98         require(_value <= allowance[_from][msg.sender]);     // Check allowance
99         allowance[_from][msg.sender] -= _value;
100         _transfer(_from, _to, _value);
101         return true;
102     }
103 
104     /**
105      * Set allowance for other address
106      *
107      * Allows `_spender` to spend no more than `_value` tokens in your behalf
108      *
109      * @param _spender The address authorized to spend
110      * @param _value the max amount they can spend
111      */
112     function approve(address _spender, uint256 _value) public
113         returns (bool success) {
114         allowance[msg.sender][_spender] = _value;
115         return true;
116     }
117 
118     /**
119      * Set allowance for other address and notify
120      *
121      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
122      *
123      * @param _spender The address authorized to spend
124      * @param _value the max amount they can spend
125      * @param _extraData some extra information to send to the approved contract
126      */
127     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
128         public
129         returns (bool success) {
130         TokenRecipient spender = TokenRecipient(_spender);
131         if (approve(_spender, _value)) {
132             spender.receiveApproval(msg.sender, _value, this, _extraData);
133             return true;
134         }
135     }
136 
137     /**
138      * Destroy tokens
139      *
140      * Remove `_value` tokens from the system irreversibly
141      *
142      * @param _value the amount of money to burn
143      */
144     function burn(uint256 _value) public returns (bool success) {
145         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
146         balanceOf[msg.sender] -= _value;            // Subtract from the sender
147         totalSupply -= _value;                      // Updates totalSupply
148         emit Burn(msg.sender, _value);
149         return true;
150     }
151 
152     /**
153      * Destroy tokens from other account
154      *
155      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
156      *
157      * @param _from the address of the sender
158      * @param _value the amount of money to burn
159      */
160     function burnFrom(address _from, uint256 _value) public returns (bool success) {
161         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
162         require(_value <= allowance[_from][msg.sender]);    // Check allowance
163         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
164         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
165         totalSupply -= _value;                              // Update totalSupply
166         emit Burn(_from, _value);
167         return true;
168     }
169 }
170 
171 /******************************************/
172 /*       ADVANCED TOKEN STARTS HERE       */
173 /******************************************/
174 
175 contract GDOAdv is owned, GDO {
176 
177     uint256 public sellPrice;
178     uint256 public buyPrice;
179 
180     mapping (address => bool) public frozenAccount;
181 
182     /* This generates a public event on the blockchain that will notify clients */
183     event FrozenFunds(address target, bool frozen);
184 
185     /* Initializes contract with initial supply tokens to the creator of the contract */
186     function GDOAdv(
187         uint256 initialSupply,
188         string tokenName,
189         string tokenSymbol
190     ) GDO(initialSupply, tokenName, tokenSymbol) public {}
191 
192     /* Internal transfer, only can be called by this contract */
193     function _transfer(address _from, address _to, uint _value) internal {
194         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
195         require (balanceOf[_from] >= _value);               // Check if the sender has enough
196         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
197         require(!frozenAccount[_from]);                     // Check if sender is frozen
198         require(!frozenAccount[_to]);                       // Check if recipient is frozen
199         balanceOf[_from] -= _value;                         // Subtract from the sender
200         balanceOf[_to] += _value;                           // Add the same to the recipient
201         emit Transfer(_from, _to, _value);
202     }
203 
204     /// @notice Create `mintedAmount` tokens and send it to `target`
205     /// @param target Address to receive the tokens
206     /// @param mintedAmount the amount of tokens it will receive
207     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
208         balanceOf[target] += mintedAmount;
209         totalSupply += mintedAmount;
210         emit Transfer(0, this, mintedAmount);
211         emit Transfer(this, target, mintedAmount);
212     }
213 
214     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
215     /// @param target Address to be frozen
216     /// @param freeze either to freeze it or not
217     function freezeAccount(address target, bool freeze) onlyOwner public {
218         frozenAccount[target] = freeze;
219         emit FrozenFunds(target, freeze);
220     }
221 
222     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
223     /// @param newSellPrice Price the users can sell to the contract
224     /// @param newBuyPrice Price users can buy from the contract
225     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
226         sellPrice = newSellPrice;
227         buyPrice = newBuyPrice;
228     }
229 
230     /// @notice Buy tokens from contract by sending ether
231     function buy() payable public {
232         uint amount = msg.value / buyPrice;               // calculates the amount
233         _transfer(this, msg.sender, amount);              // makes the transfers
234     }
235 
236     /// @notice Sell `amount` tokens to contract
237     /// @param amount amount of tokens to be sold
238     function sell(uint256 amount) public {
239         require(address(this).balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
240         _transfer(msg.sender, this, amount);              // makes the transfers
241         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
242     }
243 }