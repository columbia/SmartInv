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
18     // function balanceOf(address _owner) constant returns (uint256 balance) {
19     //     return balances[_owner];
20     // }
21 
22 }
23 
24 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
25 
26 contract HngCoin {
27     // Public variables of the token
28     string public name;
29     string public symbol;
30     uint8 public decimals = 18;                 // 18 decimals is the strongly suggested default, avoid changing it
31     uint256 public totalSupply;
32     uint256 public coinunits;                 // How many units of your coin can be bought by 1 ETH?
33     uint256 public ethereumWei;            // WEI is the smallest unit of ETH (the equivalent of cent in USD or satoshi in BTC). We'll store the total ETH raised via our ICO here.
34     address public tokensWallet;             // Safe Address could be changed so owner isnt same address
35     address public owner;             // Safe Address could be changed so owner isnt same address
36     address public salesaccount;           // Where should the raised ETH be sent to?
37     uint256 public sellPrice;             //sellprice if need be we ever call rates that are dynamic from api
38     uint256 public buyPrice;             //sellprice if need be we ever call rates that are dynamic from api
39     //uint256 public investreturns;
40     bool public isActive; //check if we are seling or not
41 
42     // This creates an array with all balances
43     mapping (address => uint256) public balanceOf;
44     mapping (address => mapping (address => uint256)) public allowance;
45 
46     // This generates a public event on the blockchain that will notify clients
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     //event TransferSender(address indexed _from, address indexed _to, uint256 _value);
49 
50     // This notifies clients about the amount burnt
51     event Burn(address indexed from, uint256 value);
52 
53     /**
54      * Constrctor function
55      *
56      * Initializes contract with initial supply tokens to the creator of the contract
57      */
58     function HngCoin(
59         uint256 initialSupply,
60         string tokenName,
61         string tokenSymbol
62     ) public {
63         //initialSupply = 900000000000000000000000000;
64         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
65         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
66         name = "HNGCOIN";                                   // Set the name for display purposes
67         symbol = "HNGC";                               // Set the symbol for display purposes
68         coinunits = 100;                                      // Set the price of your token for the ICO (CHANGE THIS)
69         tokensWallet = msg.sender;
70         salesaccount = msg.sender;
71         ethereumWei = 1000000000000000000;                                    // The owner of the contract gets ETH
72         isActive = true;               //set true or false for sale or not
73         owner = msg.sender;
74     }
75 
76 
77 
78     /**
79      * Internal transfer, only can be called by this contract
80      */
81     function _transfer(address _from, address _to, uint _value) internal {
82         // Prevent transfer to 0x0 address. Use burn() instead
83         require(_to != 0x0);
84         // Check if the sender has enough
85         require(balanceOf[_from] >= _value);
86         // Check for overflows
87         require(balanceOf[_to] + _value > balanceOf[_to]);
88         // Save this for an assertion in the future
89         uint previousBalances = balanceOf[_from] + balanceOf[_to];
90         // Subtract from the sender
91         balanceOf[_from] -= _value;
92         // Add the same to the recipient
93         balanceOf[_to] += _value;
94         emit Transfer(_from, _to, _value);
95         // Asserts are used to use static analysis to find bugs in your code. They should never fail
96         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
97     }
98 
99     /**
100      * Transfer tokens
101      *
102      * Send `_value` tokens to `_to` from your account
103      *
104      * @param _to The address of the recipient
105      * @param _value the amount to send
106      */
107      //function sendit(address _to, uint256 _value) public returns (bool success) {}
108     function transfer(address _to, uint256 _value) public returns (bool success) {
109         _transfer(msg.sender, _to, _value);
110         return true;
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
137     function approve(address _spender, uint256 _value) public returns (bool success) {
138         allowance[msg.sender][_spender] = _value;
139         return true;
140     }
141 
142     /**
143      * Set allowance for other address and notify
144      *
145      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
146      *
147      * @param _spender The address authorized to spend
148      * @param _value the max amount they can spend
149      * @param _extraData some extra information to send to the approved contract
150      */
151     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
152         tokenRecipient spender = tokenRecipient(_spender);
153         if (approve(_spender, _value)) {
154             spender.receiveApproval(msg.sender, _value, this, _extraData);
155             return true;
156         }
157     }
158 
159     function multiply(uint x, uint y) internal pure returns (uint z) {
160         require(y == 0 || (z = x * y) / y == x);
161     }
162 
163     /**
164      * Destroy tokens
165      *
166      * Remove `_value` tokens from the system irreversibly
167      *
168      * @param _value the amount of money to burn
169      */
170     function burn(uint256 _value) public returns (bool success) {
171         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
172         balanceOf[msg.sender] -= _value;            // Subtract from the sender
173         totalSupply -= _value;                      // Updates totalSupply
174         emit Burn(msg.sender, _value);
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
192         emit Burn(_from, _value);
193         return true;
194     }
195     // change salesaccount address
196     function salesAddress(address sales) public returns (bool success){
197         require(msg.sender == tokensWallet);
198         salesaccount = sales;
199         return true;
200     }
201     // change units address
202     function coinsUnit(uint256 amount) public returns (bool success){
203         require(msg.sender == tokensWallet);
204         coinunits = amount;
205         return true;
206     }
207     // transfer balance to owner withdraw owner
208   	function withdrawEther(uint256 amount) public returns (bool success){
209   		require(msg.sender == tokensWallet);
210       //require(msg.value == multiply(amount, ethereumWei));
211       amount = amount * ethereumWei;
212   		salesaccount.transfer(amount);
213   		return true;
214   	}
215 
216     /* /// @notice Buy tokens from contract by sending ether
217     function buy(uint256 amount) public payable{
218       //  uint amount = msg.value * buyPrice;               // calculates the amount
219         require(msg.value == multiply(amount, ethereumWei));
220         _transfer(this,msg.sender, amount);              // makes the transfers
221     } */
222     function startSale() external {
223       require(msg.sender == owner);
224       isActive = true;
225     }
226     function stopSale() external {
227       require(msg.sender == owner);
228       isActive = false;
229     }
230 
231     function() payable public {
232     //  ethereumWei = ethereumWei + msg.value;
233     //  investreturns = msg.value + ethereumWei;
234       //investreturns = investreturns + msg.value;
235       //investreturns = investreturns + msg.value;
236       require(isActive);
237       uint256 amount = msg.value * coinunits;
238       //uint256 amount = 100000000000000000;
239       require(balanceOf[tokensWallet] >= amount);
240 
241       balanceOf[tokensWallet] -= amount;
242       balanceOf[msg.sender] += amount;
243 
244       Transfer(tokensWallet, msg.sender, amount); // Broadcast a message to the blockchain
245 
246       //Transfer ether to tokensWallet
247     //  tokensWallet.transfer(msg.value);
248     //  _transfer(msg.sender, tokensWallet, msg.value);
249       }
250 
251 }
252 
253 /******************************************/
254 /*      Token Sale       */
255 /******************************************/
256 
257 contract HngCoinSale is owned, HngCoin {
258 
259 
260 
261     mapping (address => bool) public frozenAccount;
262 
263     /* This generates a public event on the blockchain that will notify clients */
264     event FrozenFunds(address target, bool frozen);
265 
266     /* Initializes contract with initial supply tokens to the creator of the contract */
267     function HngCoinSale(
268         uint256 initialSupply,
269         string tokenName,
270         string tokenSymbol
271     ) HngCoin(initialSupply, tokenName, tokenSymbol) public {}
272 
273     /* Internal transfer, only can be called by this contract */
274     function _transfer(address _from, address _to, uint _value) internal {
275         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
276         require (balanceOf[_from] >= _value);               // Check if the sender has enough
277         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
278         require(!frozenAccount[_from]);                     // Check if sender is frozen
279         require(!frozenAccount[_to]);                       // Check if recipient is frozen
280         balanceOf[_from] -= _value;                         // Subtract from the sender
281         balanceOf[_to] += _value;                           // Add the same to the recipient
282         emit Transfer(_from, _to, _value);
283     }
284 
285     /// @notice Create `mintedAmount` tokens and send it to `target`
286     /// @param target Address to receive the tokens
287     /// @param mintedAmount the amount of tokens it will receive
288     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
289         balanceOf[target] += mintedAmount;
290         totalSupply += mintedAmount;
291         emit Transfer(0, this, mintedAmount);
292         emit Transfer(this, target, mintedAmount);
293     }
294 
295     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
296     /// @param target Address to be frozen
297     /// @param freeze either to freeze it or not
298     function freezeAccount(address target, bool freeze) onlyOwner public {
299         frozenAccount[target] = freeze;
300         emit FrozenFunds(target, freeze);
301     }
302 
303     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
304     /// @param newSellPrice Price the users can sell to the contract
305     /// @param newBuyPrice Price users can buy from the contract
306     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
307         sellPrice = newSellPrice;
308         buyPrice = newBuyPrice;
309     }
310     function multiply(uint x, uint y) internal pure returns (uint z) {
311         require(y == 0 || (z = x * y) / y == x);
312     }
313     /* /// @notice Buy tokens from contract by sending ether
314     function buy(uint256 amount) public payable{
315       //  uint amount = msg.value * buyPrice;               // calculates the amount
316         require(msg.value == multiply(amount, buyPrice));
317         _transfer(owner,msg.sender, amount);              // makes the transfers
318     } */
319     /* function buyTokens(uint256 _numberOfTokens) public payable {
320         require(msg.value == multiply(_numberOfTokens, tokenPrice));
321         require(tokenContract.balanceOf(this) >= _numberOfTokens);
322         require(tokenContract.transfer(msg.sender, _numberOfTokens));
323 
324         tokensSold += _numberOfTokens;
325 
326         Sell(msg.sender, _numberOfTokens);
327     } */
328 
329     /// @notice Sell `amount` tokens to contract
330     /// @param amount amount of tokens to be sold
331     /* function sell(uint256 amount) public {
332         address myAddress = this;
333         require(myAddress.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
334         _transfer(msg.sender, owner, amount);              // makes the transfers
335         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
336     } */
337 
338 }