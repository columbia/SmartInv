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
22 contract TokenERC20 is owned {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     uint8 public decimals = 18;
27     // 18 decimals is the strongly suggested default, avoid changing it
28     uint256 public totalSupply;
29 
30     bool public send_allowed = false;
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
47     function TokenERC20(
48         uint256 initialSupply,
49         string tokenName,
50         string tokenSymbol
51     ) public {
52         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
53         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
54         name = tokenName;                                   // Set the name for display purposes
55         symbol = tokenSymbol;                               // Set the symbol for display purposes
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
88         require(msg.sender == owner || send_allowed == true); 
89         _transfer(msg.sender, _to, _value);
90     }
91     
92     function setSendAllow(bool send_allow) onlyOwner public {
93         send_allowed = send_allow;
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
106         require(msg.sender == owner || send_allowed == true); 
107         require(_value <= allowance[_from][msg.sender]);     // Check allowance
108         allowance[_from][msg.sender] -= _value;
109         _transfer(_from, _to, _value);
110         return true;
111     }
112 
113     /**
114      * Set allowance for other address
115      *
116      * Allows `_spender` to spend no more than `_value` tokens in your behalf
117      *
118      * @param _spender The address authorized to spend
119      * @param _value the max amount they can spend
120      */
121     function approve(address _spender, uint256 _value) public
122         returns (bool success) {
123         allowance[msg.sender][_spender] = _value;
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
157         Burn(msg.sender, _value);
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
175         Burn(_from, _value);
176         return true;
177     }
178 }
179 
180 // SCVToken Start
181 contract TokenToken is TokenERC20 {
182 
183     uint256 public sellPrice;
184     uint256 public buyPrice;
185     uint256 public leastSwap;
186     uint256 public onSaleAmount;
187     
188     bool public funding = true;
189     
190     mapping (address => bool) public frozenAccount;
191     
192 
193     /* This generates a public event on the blockchain that will notify clients */
194     event FrozenFunds(address target, bool frozen);
195 
196     /* Initializes contract with initial supply tokens to the creator of the contract */
197     function TokenToken(
198         uint256 initialSupply,
199         string tokenName,
200         string tokenSymbol
201     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
202 
203     /* Internal transfer, only can be called by this contract */
204     function _transfer(address _from, address _to, uint _value) internal {
205         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
206         require (balanceOf[_from] >= _value);               // Check if the sender has enough
207         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
208         require(!frozenAccount[_from]);                     // Check if sender is frozen
209         require(!frozenAccount[_to]);                       // Check if recipient is frozen
210         balanceOf[_from] -= _value;                         // Subtract from the sender
211         balanceOf[_to] += _value;                           // Add the same to the recipient
212         Transfer(_from, _to, _value);
213     }
214 
215     /// @notice Create `mintedAmount` tokens and send it to `target`
216     /// @param target Address to receive the tokens
217     /// @param mintedAmount the amount of tokens it will receive
218     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
219         balanceOf[target] += mintedAmount;
220         totalSupply += mintedAmount;
221         Transfer(0, this, mintedAmount);
222         Transfer(this, target, mintedAmount);
223     }
224 
225     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
226     /// @param target Address to be frozen
227     /// @param freeze either to freeze it or not
228     function freezeAccount(address target, bool freeze) onlyOwner public {
229         frozenAccount[target] = freeze;
230         FrozenFunds(target, freeze);
231     }
232 
233     function setOnSaleAmount(uint256 amount) onlyOwner public {
234         onSaleAmount = amount;
235     }
236     
237     function setFunding(bool funding_val) onlyOwner public {
238         funding = funding_val;
239     }
240 
241     // Note that not ether...its wei!!
242     function setLeastFund(uint256 least_val) onlyOwner public {
243         leastSwap = least_val;
244     }
245 
246     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
247     /// @param newSellPrice Price the users can sell to the contract
248     /// @param newBuyPrice Price users can buy from the contract
249     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
250         sellPrice = newSellPrice;
251         buyPrice = newBuyPrice;
252     }
253     
254     
255     /// @notice Buy tokens from contract by sending ether
256     function buy() payable public {
257         require(funding == true);
258         require(onSaleAmount >= (msg.value * 10 ** uint256(decimals)));
259         require(leastSwap <= (msg.value * 10 ** uint256(decimals)));
260         uint amount = msg.value * buyPrice;               // calculates the amount
261         _transfer(this, msg.sender, amount);              // makes the transfers
262         onSaleAmount = onSaleAmount - (msg.value * 10 ** uint256(decimals)); // calculate token amount on sale
263     }
264 
265     /// @notice Harvest `amount` ETH from contract
266     /// @param amount amount of ETH to be harvested
267     function harvest(uint256 amount) onlyOwner public {
268         require(this.balance >= amount);      // checks if the contract has enough ether to buy
269         msg.sender.transfer(amount);          // sends ether to you. It's important to do this last to avoid recursion attacks
270     }
271 }