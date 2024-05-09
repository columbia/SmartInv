1 pragma solidity ^0.4.19; //0.4.19+commit
2 
3 /*---------------------------------------
4     ERC 20 Credit Washington Share Coin
5     March 2, 2018
6     sale_pause remains false during ICO
7     return_pause remains true during ICO
8 -----------------------------------------*/
9 
10 contract owned {
11     address public owner;
12 
13     function owned() public {
14         owner = msg.sender;
15     }
16 
17     modifier onlyOwner {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     function transferOwnership(address newOwner) onlyOwner public {
23         owner = newOwner;
24     }
25 }
26 
27 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
28 
29 contract TokenERC20 {
30     // Public variables of the token
31     string public name;
32     string public symbol;
33     uint8 public decimals = 18;
34     // 18 decimals is the strongly suggested default, avoid changing it
35     uint256 public totalSupply;
36 
37     // This creates an array with all balances
38     mapping (address => uint256) public balanceOf;
39     mapping (address => mapping (address => uint256)) public allowance;
40 
41     // This generates a public event on the blockchain that will notify clients
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     // This notifies clients about the amount burnt
45     event Burn(address indexed from, uint256 value);
46 
47     /**
48      * Constrctor function
49      *
50      * Initializes contract with initial supply tokens to the creator of the contract
51      */
52     function TokenERC20(
53         uint256 initialSupply,
54         string tokenName,
55         string tokenSymbol
56     ) public {
57         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
58         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
59         name = tokenName;                                   // Set the name for display purposes
60         symbol = tokenSymbol;                               // Set the symbol for display purposes
61     }
62 
63     /**
64      * Internal transfer, only can be called by this contract
65      */
66     function _transfer(address _from, address _to, uint _value) internal {
67         // Prevent transfer to 0x0 address. Use burn() instead
68         require(_to != 0x0);
69         // Check if the sender has enough
70         require(balanceOf[_from] >= _value);
71         // Check for overflows
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         // Save this for an assertion in the future
74         uint previousBalances = balanceOf[_from] + balanceOf[_to];
75         // Subtract from the sender
76         balanceOf[_from] -= _value;
77         // Add the same to the recipient
78         balanceOf[_to] += _value;
79         Transfer(_from, _to, _value);
80         // Asserts are used to use static analysis to find bugs in your code. They should never fail
81         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
82     }
83 
84     /**
85      * Transfer tokens
86      *
87      * Send `_value` tokens to `_to` from your account
88      *
89      * @param _to The address of the recipient
90      * @param _value the amount to send
91      */
92     function transfer(address _to, uint256 _value) public {
93         _transfer(msg.sender, _to, _value);
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
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address and notify
128      *
129      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
130      *
131      * @param _spender The address authorized to spend
132      * @param _value the max amount they can spend
133      * @param _extraData some extra information to send to the approved contract
134      */
135     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
136         public
137         returns (bool success) {
138         tokenRecipient spender = tokenRecipient(_spender);
139         if (approve(_spender, _value)) {
140             spender.receiveApproval(msg.sender, _value, this, _extraData);
141             return true;
142         }
143     }
144 
145     /**
146      * Destroy tokens
147      *
148      * Remove `_value` tokens from the system irreversibly
149      *
150      * @param _value the amount of money to burn
151      */
152     function burn(uint256 _value) public returns (bool success) {
153         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
154         balanceOf[msg.sender] -= _value;            // Subtract from the sender
155         totalSupply -= _value;                      // Updates totalSupply
156         Burn(msg.sender, _value);
157         return true;
158     }
159 
160     /**
161      * Destroy tokens from other account
162      *
163      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
164      *
165      * @param _from the address of the sender
166      * @param _value the amount of money to burn
167      */
168     function burnFrom(address _from, uint256 _value) public returns (bool success) {
169         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
170         require(_value <= allowance[_from][msg.sender]);    // Check allowance
171         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
172         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
173         totalSupply -= _value;                              // Update totalSupply
174         Burn(_from, _value);
175         return true;
176     }
177 }
178 
179 /******************************************/
180 /*       ADVANCED TOKEN STARTS HERE       */
181 /******************************************/
182 
183 contract CWS is owned, TokenERC20 {
184 
185     uint256 public sellPrice;
186     uint256 public buyPrice;
187     //--- Added by Credit Washington, March 2, 2018 ---//
188     bool public sale_pause=false; 
189     bool public return_pause=false;
190 
191     mapping (address => bool) public frozenAccount;
192 
193     /* This generates a public event on the blockchain that will notify clients */
194     event FrozenFunds(address target, bool frozen);
195 
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     function CWS(
198         uint256 initialSupply,
199         string tokenName,
200         string tokenSymbol
201     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
202 
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] >= _value);               // Check if the sender has enough
207         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         Transfer(_from, _to, _value);
213     }
214 
215     /// Added by Credit Washington, March 2, 2018
216     /// @notice Set the bool value of sale_pause
217     /// @param _pauseSale the bool value
218     function set_pauseSale(bool _pauseSale) onlyOwner public {
219         sale_pause=_pauseSale;
220     }
221     
222     /// Added by Credit Washington, March 2, 2018
223     /// @notice Set the bool value of return_pause
224     /// @param _pauseReturn the bool value
225     function set_pauseReturn(bool _pauseReturn) onlyOwner public {
226         return_pause=_pauseReturn;
227     }
228     
229     /// @notice Create `mintedAmount` tokens and send it to `target`
230     /// @param target Address to receive the tokens
231     /// @param mintedAmount the amount of tokens it will receive
232     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
233         balanceOf[target] += mintedAmount;
234         totalSupply += mintedAmount;
235         Transfer(0, this, mintedAmount);
236         Transfer(this, target, mintedAmount);
237     }
238 
239     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
240     /// @param target Address to be frozen
241     /// @param freeze either to freeze it or not
242     function freezeAccount(address target, bool freeze) onlyOwner public {
243         frozenAccount[target] = freeze;
244         FrozenFunds(target, freeze);
245     }
246 
247     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
248     /// @param newSellPrice Price the users can sell to the contract
249     /// @param newBuyPrice Price users can buy from the contract
250     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
251         sellPrice = newSellPrice;
252         buyPrice = newBuyPrice;
253     }
254 
255     /// Added by Credit Washington, March 2, 2018
256     /// @notice standard fallback payable
257     function () payable {
258         require(!sale_pause); // Added by Credit Washington, March 2, 2018 (to save gas)
259         buy();
260     }
261 
262     /// Revised by Credit Washington, March 2, 2018
263     /// @notice Buy tokens from contract by sending ether
264     function buy() payable public {
265         require(!sale_pause); // Added by Credit Washington, March 2, 2018
266         uint amount = msg.value / buyPrice;               // calculates the amount
267         _transfer(this, msg.sender, amount);              // makes the transfers
268     }
269 
270     /// @notice Sell `amount` tokens to contract
271     /// @param amount amount of tokens to be sold
272     function sell(uint256 amount) public {
273         require(!return_pause); // Added by Credit Washington, March 2, 2018
274         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
275         _transfer(msg.sender, this, amount);              // makes the transfers
276         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
277     }
278 }