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
18 
19     function kill() onlyOwner public {
20         selfdestruct(owner);
21     }
22 
23     function () public payable {}
24 }
25 
26 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
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
51     function TokenERC20(
52         uint256 initialSupply,
53         uint8 initialDecimals,
54         string tokenName,
55         string tokenSymbol
56     ) public {
57         decimals = initialDecimals;
58         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
59         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
60         name = tokenName;                                   // Set the name for display purposes
61         symbol = tokenSymbol;                               // Set the symbol for display purposes
62     }
63 
64     /**
65      * Internal transfer, only can be called by this contract
66      */
67     function _transfer(address _from, address _to, uint _value) internal {
68         // Prevent transfer to 0x0 address. Use burn() instead
69         require(_to != 0x0);
70         // Check if the sender has enough
71         require(balanceOf[_from] >= _value);
72         // Check for overflows
73         require(balanceOf[_to] + _value > balanceOf[_to]);
74         // Save this for an assertion in the future
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         // Subtract from the sender
77         balanceOf[_from] -= _value;
78         // Add the same to the recipient
79         balanceOf[_to] += _value;
80         emit Transfer(_from, _to, _value);
81         // Asserts are used to use static analysis to find bugs in your code. They should never fail
82         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
83     }
84 
85     /**
86      * Transfer tokens
87      *
88      * Send `_value` tokens to `_to` from your account
89      *
90      * @param _to The address of the recipient
91      * @param _value the amount to send
92      */
93     function transfer(address _to, uint256 _value) public {
94         _transfer(msg.sender, _to, _value);
95     }
96 
97     /**
98      * Transfer tokens from other address
99      *
100      * Send `_value` tokens to `_to` in behalf of `_from`
101      *
102      * @param _from The address of the sender
103      * @param _to The address of the recipient
104      * @param _value the amount to send
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
107         if (_value <= allowance[_from][msg.sender]) {
108           allowance[_from][msg.sender] -= _value;
109           _transfer(_from, _to, _value);
110           return true;
111         }
112         else
113           return false;
114     }
115 
116     /**
117      * Set allowance for other address
118      *
119      * Allows `_spender` to spend no more than `_value` tokens in your behalf
120      *
121      * @param _spender The address authorized to spend
122      * @param _value the max amount they can spend
123      */
124     function approve(address _spender, uint256 _value) public
125         returns (bool success) {
126         allowance[msg.sender][_spender] = _value;
127         return true;
128     }
129 
130     /**
131      * Set allowance for other address and notify
132      *
133      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
134      *
135      * @param _spender The address authorized to spend
136      * @param _value the max amount they can spend
137      * @param _extraData some extra information to send to the approved contract
138      */
139     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
140         public
141         returns (bool success) {
142         tokenRecipient spender = tokenRecipient(_spender);
143         if (approve(_spender, _value)) {
144             spender.receiveApproval(msg.sender, _value, this, _extraData);
145             return true;
146         }
147     }
148 
149     /**
150      * Destroy tokens
151      *
152      * Remove `_value` tokens from the system irreversibly
153      *
154      * @param _value the amount of money to burn
155      */
156     function burn(uint256 _value) public returns (bool success) {
157         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
158         balanceOf[msg.sender] -= _value;            // Subtract from the sender
159         totalSupply -= _value;                      // Updates totalSupply
160         emit Burn(msg.sender, _value);
161         return true;
162     }
163 
164     /**
165      * Destroy tokens from other account
166      *
167      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
168      *
169      * @param _from the address of the sender
170      * @param _value the amount of money to burn
171      */
172     function burnFrom(address _from, uint256 _value) public returns (bool success) {
173         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
174         require(_value <= allowance[_from][msg.sender]);    // Check allowance
175         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
176         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
177         totalSupply -= _value;                              // Update totalSupply
178         emit Burn(_from, _value);
179         return true;
180     }
181 }
182 
183 /******************************************/
184 /*       ADVANCED TOKEN STARTS HERE       */
185 /******************************************/
186 
187 contract JiucaiToken is owned, TokenERC20 {
188 
189     uint256 public price;
190     uint256 public priceInc;
191     uint256 public transferFees;
192 
193     mapping (address => bool) public frozenAccount;
194 
195     /* This generates a public event on the blockchain that will notify clients */
196     event FrozenFunds(address target, bool frozen);
197 
198     /* Initializes contract with initial supply tokens to the creator of the contract */
199     function JiucaiToken (
200         uint256 initialSupply,
201         uint8 initialDecimals,
202         string tokenName,
203         string tokenSymbol
204     ) TokenERC20(initialSupply, initialDecimals, tokenName, tokenSymbol) public {
205 
206         price = 10 finney;
207         priceInc = 10 finney;
208         transferFees = 20 finney;
209     }
210 
211     /* Internal transfer, only can be called by this contract */
212     function _transfer(address _from, address _to, uint _value) internal {
213         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
214         require (balanceOf[_from] >= _value);               // Check if the sender has enough
215         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
216         require(!frozenAccount[_from]);                     // Check if sender is frozen
217         require(!frozenAccount[_to]);                       // Check if recipient is frozen
218         balanceOf[_from] -= _value;                         // Subtract from the sender
219         balanceOf[_to] += _value;                           // Add the same to the recipient
220         emit Transfer(_from, _to, _value);
221     }
222 
223     /// @notice Create `mintedAmount` tokens and send it to `target`
224     /// @param target Address to receive the tokens
225     /// @param mintedAmount the amount of tokens it will receive
226     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
227         balanceOf[target] += mintedAmount;
228         totalSupply += mintedAmount;
229         emit Transfer(0, this, mintedAmount);
230         emit Transfer(this, target, mintedAmount);
231     }
232 
233     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
234     /// @param target Address to be frozen
235     /// @param freeze either to freeze it or not
236     function freezeAccount(address target, bool freeze) onlyOwner public {
237         frozenAccount[target] = freeze;
238         emit FrozenFunds(target, freeze);
239     }
240 
241     /// @notice Allow users to buy and sell tokens for `newPrice` eth
242     /// @param newPrice Price users can buy and sell to the contract
243     /// @param newPriceInc new price inc
244     /// @param newTransferFees new transfer fees
245     function setPrices(uint256 newPrice, uint256 newPriceInc, uint256 newTransferFees) onlyOwner public {
246         require(newTransferFees > newPriceInc);
247         price = newPrice;
248         priceInc = newPriceInc;
249         transferFees = newTransferFees;
250     }
251 
252     /// @notice Buy tokens from contract by sending ether
253     function buy() payable public {
254         require(msg.value == price);
255         uint amount = msg.value / price;               // calculates the amount
256         _transfer(this, msg.sender, amount);              // makes the transfers
257 
258         price += priceInc;
259     }
260 
261     /// @notice Sell `amount` tokens to contract
262     /// @param amount amount of tokens to be sold
263     function sell(uint256 amount) public {
264         require(amount == 1);
265         require(address(this).balance >= amount * price);      // checks if the contract has enough ether to buy
266         _transfer(msg.sender, this, amount);              // makes the transfers
267         msg.sender.transfer(amount * price - transferFees);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
268 
269         price -= priceInc;
270     }
271 }