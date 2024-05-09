1 pragma solidity ^0.4.18;
2 /**
3  * MyAdvancedToken
4  * edisonlee55/ethereum-org (https://github.com/edisonlee55/ethereum-org/blob/master/solidity/token-advanced.sol)
5  *
6  * Copyright (c) 2017 MING-CHIEN LEE
7  * Forked from ethereum/ethereum-org (https://github.com/ethereum/ethereum-org/blob/master/solidity/token-advanced.sol)
8  */
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
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
27 
28 contract TokenERC20 {
29     // Public variables of the token
30     string public name;
31     string public symbol;
32     uint8 public decimals = 18;
33     // 18 decimals is the strongly suggested default, avoid changing it
34     uint256 public totalSupply;
35 
36     // This creates an array with all balances
37     mapping (address => uint256) public balanceOf;
38     mapping (address => mapping (address => uint256)) public allowance;
39 
40     // This generates a public event on the blockchain that will notify clients
41     event Transfer(address indexed from, address indexed to, uint256 value);
42 
43     // This notifies clients about the amount burnt
44     event Burn(address indexed from, uint256 value);
45 
46     /**
47      * Constrctor function
48      *
49      * Initializes contract with initial supply tokens to the creator of the contract
50      */
51     function TokenERC20() public {
52         totalSupply = 1000000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = "LoliCoin";                                   // Set the name for display purposes
55         symbol = "LOLI";                               // Set the symbol for display purposes
56     }
57 
58     /**
59      * Internal transfer, only can be called by this contract
60      */
61     function _transfer(address _from, address _to, uint _value) internal {
62         // Prevent transfer to 0x0 address. Use burn() instead
63         require(_to != 0x0);
64         // Check if the sender has enough
65         require(balanceOf[_from] >= _value);
66         // Check for overflows
67         require(balanceOf[_to] + _value > balanceOf[_to]);
68         // Save this for an assertion in the future
69         uint previousBalances = balanceOf[_from] + balanceOf[_to];
70         // Subtract from the sender
71         balanceOf[_from] -= _value;
72         // Add the same to the recipient
73         balanceOf[_to] += _value;
74         Transfer(_from, _to, _value);
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
140     /**
141      * Destroy tokens
142      *
143      * Remove `_value` tokens from the system irreversibly
144      *
145      * @param _value the amount of money to burn
146      */
147     function burn(uint256 _value) public returns (bool success) {
148         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
149         balanceOf[msg.sender] -= _value;            // Subtract from the sender
150         totalSupply -= _value;                      // Updates totalSupply
151         Burn(msg.sender, _value);
152         return true;
153     }
154 
155     /**
156      * Destroy tokens from other account
157      *
158      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
159      *
160      * @param _from the address of the sender
161      * @param _value the amount of money to burn
162      */
163     function burnFrom(address _from, uint256 _value) public returns (bool success) {
164         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
165         require(_value <= allowance[_from][msg.sender]);    // Check allowance
166         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
167         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
168         totalSupply -= _value;                              // Update totalSupply
169         Burn(_from, _value);
170         return true;
171     }
172 }
173 
174 /******************************************/
175 /*       ADVANCED TOKEN STARTS HERE       */
176 /******************************************/
177 
178 contract MyAdvancedToken is owned, TokenERC20 {
179 
180     uint256 public sellPrice;
181     uint256 public buyPrice;
182 
183     mapping (address => bool) public frozenAccount;
184 
185     /* This generates a public event on the blockchain that will notify clients */
186     event FrozenFunds(address target, bool frozen);
187 
188     /* Initializes contract with initial supply tokens to the creator of the contract */
189     function MyAdvancedToken() TokenERC20() public {}
190 
191     /* Internal transfer, only can be called by this contract */
192     function _transfer(address _from, address _to, uint _value) internal {
193         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
194         require (balanceOf[_from] > _value);                // Check if the sender has enough
195         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
196         require(!frozenAccount[_from]);                     // Check if sender is frozen
197         require(!frozenAccount[_to]);                       // Check if recipient is frozen
198         balanceOf[_from] -= _value;                         // Subtract from the sender
199         balanceOf[_to] += _value;                           // Add the same to the recipient
200         Transfer(_from, _to, _value);
201     }
202 
203     /// @notice Create `mintedAmount` tokens and send it to `target`
204     /// @param target Address to receive the tokens
205     /// @param mintedAmount the amount of tokens it will receive
206     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
207         balanceOf[target] += mintedAmount;
208         totalSupply += mintedAmount;
209         Transfer(0, this, mintedAmount);
210         Transfer(this, target, mintedAmount);
211     }
212 
213     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
214     /// @param target Address to be frozen
215     /// @param freeze either to freeze it or not
216     function freezeAccount(address target, bool freeze) onlyOwner public {
217         frozenAccount[target] = freeze;
218         FrozenFunds(target, freeze);
219     }
220 
221     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
222     /// @param newSellPrice Price the users can sell to the contract
223     /// @param newBuyPrice Price users can buy from the contract
224     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
225         sellPrice = newSellPrice;
226         buyPrice = newBuyPrice;
227     }
228 
229     /// @notice Buy tokens from contract by sending ether
230     function buy() payable public {
231         uint amount = msg.value / buyPrice;               // calculates the amount
232         _transfer(this, msg.sender, amount);              // makes the transfers
233     }
234 
235     /// @notice Sell `amount` tokens to contract
236     /// @param amount amount of tokens to be sold
237     function sell(uint256 amount) public {
238         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
239         _transfer(msg.sender, this, amount);              // makes the transfers
240         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
241     }
242 }