1 pragma solidity ^0.4.18;
2 
3 //Hello if you're reading this! 
4 // buy raiblocks 
5 // sorry reddit 
6 
7 contract owned {
8     address public owner;
9 
10     function owned() public {
11         owner = msg.sender;
12     }
13 
14     modifier onlyOwner {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address newOwner) onlyOwner public {
20         owner = newOwner;
21     }
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
25 
26 contract TokenERC20 {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;
31     // 18 decimals is the strongly suggested default, avoid changing it
32     uint256 public totalSupply;
33     
34     //variables for crowd sale 
35     uint256 public unitsOneEthCanBuy;  //what it's worth in the inital crowd sale 
36     uint256 public totalEthInWei;         // keeping track of how much eth worth has been sold   
37     address public fundsWallet;           // Where should the raised ETH go?
38     address public contractWallet;        //the address of the contract 
39     bool public crowdSaleIsOver;          // will be True if this contract is not selling tokens anymore 
40 
41     // This creates an array with all balances
42     mapping (address => uint256) public balanceOf;
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     // This generates a public event on the blockchain that will notify clients
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 
48     // This notifies clients about the amount burnt
49     event Burn(address indexed from, uint256 value);
50 
51     /**
52      * Constrctor function
53      *
54      * Initializes contract with initial supply tokens to the creator of the contract
55      */
56     function TokenERC20(
57         uint256 initialSupply,
58         string tokenName,
59         string tokenSymbol
60     ) public {
61         //number of coins for creator of contract 
62         uint256 balanceOfSender = 30000000;
63         //balance of creator of contract = balanceOfSender * decimals 
64         balanceOf[msg.sender] = balanceOfSender * 10 ** uint256(decimals); 
65         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount 
66         
67         //setting balanceof this contract total supply - balanceOfSender
68         balanceOf[this] = totalSupply - (balanceOf[msg.sender]);
69         name = tokenName;                                   // Set the name for display purposes
70         symbol = tokenSymbol;                               // Set the symbol for display purposes
71         
72         //for crowdsale 
73         fundsWallet = msg.sender; //setting fundsWallet to my wallet 
74         contractWallet = this; //this; //setting contractWallet to be the contract
75         unitsOneEthCanBuy = 10000000; //10,000 for $1 * $1000 per ether = 10,000,000
76         //tracking crowdsale
77         crowdSaleIsOver = false; 
78     }
79 
80     /**
81      * Internal transfer, only can be called by this contract
82      */
83     function _transfer(address _from, address _to, uint _value) internal {
84         // Prevent transfer to 0x0 address. Use burn() instead
85         require(_to != 0x0);
86         // Check if the sender has enough
87         require(balanceOf[_from] >= _value);
88         // Check for overflows
89         require(balanceOf[_to] + _value > balanceOf[_to]);
90         // Save this for an assertion in the future
91         uint previousBalances = balanceOf[_from] + balanceOf[_to];
92         // Subtract from the sender
93         balanceOf[_from] -= _value;
94         // Add the same to the recipient
95         balanceOf[_to] += _value;
96         Transfer(_from, _to, _value);
97         // Asserts are used to use static analysis to find bugs in your code. They should never fail
98         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
99     }
100 
101     /**
102      * Transfer tokens
103      *
104      * Send `_value` tokens to `_to` from your account
105      *
106      * @param _to The address of the recipient
107      * @param _value the amount to send
108      */
109     function transfer(address _to, uint256 _value) public {
110         _transfer(msg.sender, _to, _value);
111     }
112 
113     /**
114      * Transfer tokens from other address
115      *
116      * Send `_value` tokens to `_to` in behalf of `_from`
117      *
118      * @param _from The address of the sender
119      * @param _to The address of the recipient
120      * @param _value the amount to send
121      */
122     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
123         require(_value <= allowance[_from][msg.sender]);     // Check allowance
124         allowance[_from][msg.sender] -= _value;
125         _transfer(_from, _to, _value);
126         return true;
127     }
128 
129     /**
130      * Set allowance for other address
131      *
132      * Allows `_spender` to spend no more than `_value` tokens in your behalf
133      *
134      * @param _spender The address authorized to spend
135      * @param _value the max amount they can spend
136      */
137     function approve(address _spender, uint256 _value) public
138         returns (bool success) {
139         allowance[msg.sender][_spender] = _value;
140         return true;
141     }
142 
143     /**
144      * Set allowance for other address and notify
145      *
146      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
147      *
148      * @param _spender The address authorized to spend
149      * @param _value the max amount they can spend
150      * @param _extraData some extra information to send to the approved contract
151      */
152     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
153         public
154         returns (bool success) {
155         tokenRecipient spender = tokenRecipient(_spender);
156         if (approve(_spender, _value)) {
157             spender.receiveApproval(msg.sender, _value, this, _extraData);
158             return true;
159         }
160     }
161 
162     /**
163      * Destroy tokens
164      *
165      * Remove `_value` tokens from the system irreversibly
166      *
167      * @param _value the amount of money to burn
168      */
169     function burn(uint256 _value) public returns (bool success) {
170         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
171         //balanceOf[msg.sender] -= _value;            // Subtract from the sender
172         totalSupply -= _value;                      // Updates totalSupply
173         balanceOf[contractWallet] -= _value;  //Subtract from the contract 
174         Burn(msg.sender, _value);
175         return true;
176     }
177 
178     /**
179      * Destroy tokens from other account
180      *
181      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
182      *
183      * @param _from the address of the sender
184      * @param _value the amount of money to burn
185      */
186     function burnFrom(address _from, uint256 _value) public returns (bool success) {
187         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
188         require(_value <= allowance[_from][msg.sender]);    // Check allowance
189         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
190         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
191         totalSupply -= _value;                              // Update totalSupply
192         Burn(_from, _value);
193         return true;
194     }
195     
196     /*
197     ending the crowdsale when the value xx ether or xx days is reached
198     */
199     function setCrowdSaleStatus(bool status) public returns (bool success) {
200         crowdSaleIsOver = status;
201         return true;
202     }
203     
204     /*
205     changing the price if needed 
206     */
207     function changeAmountPerEther(uint256 newAmountPerEther) public returns (bool success) {
208         unitsOneEthCanBuy = newAmountPerEther;
209         return true;
210     }
211     
212 }
213 
214 /******************************************/
215 /*       ADVANCED TOKEN STARTS HERE       */
216 /******************************************/
217 
218 contract MyAdvancedToken is owned, TokenERC20 {
219 
220     //not used
221     uint256 public sellPrice;
222     uint256 public buyPrice;
223 
224     mapping (address => bool) public frozenAccount;
225 
226     /* This generates a public event on the blockchain that will notify clients */
227     event FrozenFunds(address target, bool frozen);
228 
229     /* Initializes contract with initial supply tokens to the creator of the contract */
230     function MyAdvancedToken(
231         uint256 initialSupply,
232         string tokenName,
233         string tokenSymbol
234     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
235     
236     
237     function() payable public{
238         //tracking how much ether this contract has raised
239         totalEthInWei = totalEthInWei + msg.value;
240         //amount = how much ether someone sent * the rate
241         uint256 amount = msg.value * unitsOneEthCanBuy;
242         //if there's not enough  OR  if the ICO is over 
243         // if ((balanceOf[contractWallet] < amount) || (crowdSaleIsOver == true)) {
244         //     _transfer(this, msg.sender, msg.value); 
245         //     return;
246         // }
247         require(!crowdSaleIsOver);
248         require(balanceOf[contractWallet] >= amount);
249       
250         //tracking the balances correctly 
251         balanceOf[contractWallet] = balanceOf[contractWallet] - amount;
252         balanceOf[msg.sender] = balanceOf[msg.sender] + amount;
253 
254         // Broadcast a message to the blockchain
255         Transfer(contractWallet, msg.sender, amount); 
256 
257         //Transfer ether to fundsWallet
258         fundsWallet.transfer(msg.value);                               
259     }
260     
261     
262 
263     /* Internal transfer, only can be called by this contract */
264     function _transfer(address _from, address _to, uint _value) internal {
265         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
266         require (balanceOf[_from] >= _value);               // Check if the sender has enough
267         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
268         require(!frozenAccount[_from]);                     // Check if sender is frozen
269         require(!frozenAccount[_to]);                       // Check if recipient is frozen
270         balanceOf[_from] -= _value;                         // Subtract from the sender
271         balanceOf[_to] += _value;                           // Add the same to the recipient
272         Transfer(_from, _to, _value);
273     }
274 
275     /// @notice Create `mintedAmount` tokens and send it to `target`
276     /// @param target Address to receive the tokens
277     /// @param mintedAmount the amount of tokens it will receive
278     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
279         balanceOf[target] += mintedAmount;
280         totalSupply += mintedAmount;
281         Transfer(0, this, mintedAmount);
282         Transfer(this, target, mintedAmount);
283     }
284 
285     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
286     /// @param target Address to be frozen
287     /// @param freeze either to freeze it or not
288     function freezeAccount(address target, bool freeze) onlyOwner public {
289         frozenAccount[target] = freeze;
290         FrozenFunds(target, freeze);
291     }
292 
293     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
294     /// @param newSellPrice Price the users can sell to the contract
295     /// @param newBuyPrice Price users can buy from the contract
296     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
297         sellPrice = newSellPrice;
298         buyPrice = newBuyPrice;
299     }
300 
301     /// @notice Buy tokens from contract by sending ether
302     function buy() payable public {
303         require(!crowdSaleIsOver);
304        
305         uint amount = msg.value / buyPrice;               // calculates the amount
306         _transfer(this, msg.sender, amount);              // makes the transfers
307     }
308     
309 
310 
311     // /// @notice Sell `amount` tokens to contract
312     // /// @param amount amount of tokens to be sold
313     // function sell(uint256 amount) public {
314     //     require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
315     //     _transfer(msg.sender, this, amount);              // makes the transfers
316     //     msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
317     // }
318 }