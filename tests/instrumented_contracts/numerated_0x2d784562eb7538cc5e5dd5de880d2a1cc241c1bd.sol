1 pragma solidity ^0.4.18;
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
22 contract Token {
23     // Public variables of the token
24     string public name;
25     string public symbol;
26     string public author = 'GMMGHoldings: DobroCoin (ByVitiook) v 1.1';
27     uint8 public decimals = 8;
28     // 18 decimals is the strongly suggested default, avoid changing it
29     uint256 public totalSupply;
30 
31     // This creates an array with all balances
32     mapping (address => uint256) public balanceOf;
33     mapping (address => mapping (address => uint256)) public allowance;
34 
35     // This generates a public event on the blockchain that will notify clients
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     
38     // This generates a public event on the blockchain that will notify clients
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41     // This notifies clients about the amount burnt
42     event Burn(address indexed from, uint256 value);
43 
44     /**
45      * Constrctor function
46      *
47      * Initializes contract with initial supply tokens to the creator of the contract
48      */
49     constructor(
50         uint256 initialSupply,
51         string tokenName,
52         string tokenSymbol,
53         string tokenAuthor
54     ) public {
55         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
56         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
57         name = tokenName;                                   // Set the name for display purposes
58         symbol = tokenSymbol;                               // Set the symbol for display purposes
59         author = tokenAuthor;                               // Set the symbol for display purposes
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
124         emit Approval(msg.sender, _spender, _value);
125         return true;
126     }
127 
128     /**
129      * Set allowance for other address and notify
130      *
131      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
132      *
133      * @param _spender The address authorized to spend
134      * @param _value the max amount they can spend
135      * @param _extraData some extra information to send to the approved contract
136      */
137     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
138         public
139         returns (bool success) {
140         tokenRecipient spender = tokenRecipient(_spender);
141         if (approve(_spender, _value)) {
142             spender.receiveApproval(msg.sender, _value, this, _extraData);
143             return true;
144         }
145     }
146 
147 }
148 
149 /******************************************/
150 /*       ADVANCED TOKEN STARTS HERE       */
151 /******************************************/
152 
153 contract DobrocoinContract is owned, Token {
154 
155     uint256 public sellPrice;
156     uint256 public buyPrice;
157     uint256 public AutoBuy = 1;
158     uint256 public AutoSell = 1;
159     address[] public ReservedAddress;
160 
161     mapping (address => bool) public frozenAccount;
162 
163     /* This generates a public event on the blockchain that will notify clients */
164     event FrozenFunds(address target, bool frozen);
165 
166     /* Initializes contract with initial supply tokens to the creator of the contract */
167     constructor(
168         uint256 initialSupply,
169         string tokenName,
170         string tokenSymbol,
171         string tokenAuthor
172     ) Token(initialSupply, tokenName, tokenSymbol, tokenAuthor) public {}
173 
174     /* Internal transfer, only can be called by this contract */
175     function _transfer(address _from, address _to, uint _value) internal {
176         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
177         require (balanceOf[_from] >= _value);               // Check if the sender has enough
178         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
179         require(!frozenAccount[_from]);                     // Check if sender is frozen
180         require(!frozenAccount[_to]);                       // Check if recipient is frozen
181         balanceOf[_from] -= _value;                         // Subtract from the sender
182         balanceOf[_to] += _value;                           // Add the same to the recipient
183         emit Transfer(_from, _to, _value);
184     }
185 
186     /// @notice Create `mintedAmount` tokens and send it to `target`
187     /// @param target Address to receive the tokens
188     /// @param mintedAmount the amount of tokens it will receive
189     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
190         balanceOf[target] += mintedAmount;
191         totalSupply += mintedAmount;
192         emit Transfer(0, this, mintedAmount);
193         emit Transfer(this, target, mintedAmount);
194     }
195 
196     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
197     /// @param target Address to be frozen
198     /// @param freeze either to freeze it or not
199     function freezeAccount(address target, bool freeze) onlyOwner public {
200         frozenAccount[target] = freeze;
201         emit FrozenFunds(target, freeze);
202     }
203 
204     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
205     /// @param newSellPrice Price the users can sell to the contract
206     /// @param newBuyPrice Price users can buy from the contract
207     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
208         sellPrice = newSellPrice;
209         buyPrice = newBuyPrice;
210     }
211     
212     /**
213      * Destroy tokens
214      *
215      * Remove `_value` tokens from the system irreversibly
216      *
217      * @param _value the amount of money to burn
218      */
219     function burn(uint256 _value) public returns (bool success) {
220         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
221         balanceOf[msg.sender] -= _value;            // Subtract from the sender
222         totalSupply -= _value;                      // Updates totalSupply
223         emit Burn(msg.sender, _value);
224         return true;
225     }
226 
227     /**
228      * Destroy tokens from other account
229      *
230      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
231      *
232      * @param _from the address of the sender
233      * @param _value the amount of money to burn
234      */
235     function burnFrom(address _from, uint256 _value) public returns (bool success) {
236         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
237         require(_value <= allowance[_from][msg.sender]);    // Check allowance
238         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
239         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
240         totalSupply -= _value;                              // Update totalSupply
241         emit Burn(_from, _value);
242         return true;
243     }
244     
245     function setAutoBuy(uint256 newAutoBuy) onlyOwner public {
246         AutoBuy = newAutoBuy;
247     } // Set aviable to buy
248     
249     function setName(string newName) onlyOwner public {
250         name = newName;
251     } // Set aviable to buy
252     
253     function setAuthor(string newAuthor) onlyOwner public {
254         author = newAuthor;
255     } // Set aviable to buy
256     
257     function setAutoSell(uint256 newAutoSell) onlyOwner public {
258         AutoSell = newAutoSell;
259     } // Set aviable to sell
260     
261     /// @notice Buy tokens from contract by sending ether
262     function buy() payable public {
263         // Check if the sender has enough
264         if(AutoBuy > 0) {
265         uint amount = msg.value / buyPrice;               // calculates the amount
266         _transfer(this, msg.sender, amount);              // makes the transfers
267         }
268     }
269 
270     /// @notice Sell `amount` tokens to contract
271     /// @param amount amount of tokens to be sold
272     function sell(uint256 amount) public {
273         if(AutoSell > 0){
274         address myAddress = this;
275         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
276         _transfer(msg.sender, this, amount);              // makes the transfers
277         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
278     }
279     }
280 }