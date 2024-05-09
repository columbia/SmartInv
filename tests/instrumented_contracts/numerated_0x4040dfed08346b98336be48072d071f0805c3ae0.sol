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
48         string tokenSymbol,
49         uint8  tokenDecimals
50     ) public {
51 
52         name = tokenName;                                   // Set the name for display purposes
53         symbol = tokenSymbol;  
54         decimals = tokenDecimals;                         // Set the symbol for display purposes
55         
56         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
57         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
58 
59     }
60 
61     /**
62      * Internal transfer, only can be called by this contract
63      */
64     function _transfer(address _from, address _to, uint _value) internal {
65         // Prevent transfer to 0x0 address. Use burn() instead
66         require(_to != 0x0);
67         // Check if the sender has enough
68         require(balanceOf[_from] >= _value);
69         // Check for overflows
70         require(balanceOf[_to] + _value > balanceOf[_to]);
71         // Save this for an assertion in the future
72         uint previousBalances = balanceOf[_from] + balanceOf[_to];
73         // Subtract from the sender
74         balanceOf[_from] -= _value;
75         // Add the same to the recipient
76         balanceOf[_to] += _value;
77         Transfer(_from, _to, _value);
78         // Asserts are used to use static analysis to find bugs in your code. They should never fail
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     /**
83      * Transfer tokens
84      *
85      * Send `_value` tokens to `_to` from your account
86      *
87      * @param _to The address of the recipient
88      * @param _value the amount to send
89      */
90     function transfer(address _to, uint256 _value) public {
91 
92         _transfer(msg.sender, _to, _value);
93     }
94 
95     /**
96      * Transfer tokens from other address
97      *
98      * Send `_value` tokens to `_to` in behalf of `_from`
99      *
100      * @param _from The address of the sender
101      * @param _to The address of the recipient
102      * @param _value the amount to send
103      */
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);     // Check allowance
106         allowance[_from][msg.sender] -= _value;
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     /**
112      * Set allowance for other address
113      *
114      * Allows `_spender` to spend no more than `_value` tokens in your behalf
115      *
116      * @param _spender The address authorized to spend
117      * @param _value the max amount they can spend
118      */
119     function approve(address _spender, uint256 _value) public
120         returns (bool success) {
121         allowance[msg.sender][_spender] = _value;
122         return true;
123     }
124 
125     /**
126      * Set allowance for other address and notify
127      *
128      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
129      *
130      * @param _spender The address authorized to spend
131      * @param _value the max amount they can spend
132      * @param _extraData some extra information to send to the approved contract
133      */
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
135         public
136         returns (bool success) {
137         tokenRecipient spender = tokenRecipient(_spender);
138         if (approve(_spender, _value)) {
139             spender.receiveApproval(msg.sender, _value, this, _extraData);
140             return true;
141         }
142     }
143 
144     /**
145      * Destroy tokens
146      *
147      * Remove `_value` tokens from the system irreversibly
148      *
149      * @param _value the amount of money to burn
150      */
151     function burn(uint256 _value) public returns (bool success) {
152         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
153         balanceOf[msg.sender] -= _value;            // Subtract from the sender
154         totalSupply -= _value;                      // Updates totalSupply
155         Burn(msg.sender, _value);
156         return true;
157     }
158 
159     /**
160      * Destroy tokens from other account
161      *
162      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
163      *
164      * @param _from the address of the sender
165      * @param _value the amount of money to burn
166      */
167     function burnFrom(address _from, uint256 _value) public returns (bool success) {
168         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
169         require(_value <= allowance[_from][msg.sender]);    // Check allowance
170         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
171         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
172         totalSupply -= _value;                              // Update totalSupply
173         Burn(_from, _value);
174         return true;
175     }
176 }
177 
178 /******************************************/
179 /*       ADVANCED TOKEN STARTS HERE       */
180 /******************************************/
181 
182 contract DITECHCOIN is owned, TokenERC20 {
183     uint256 public constant initialSupply = 44950000;
184     string public constant tokenName = "DITECHCOIN";
185     string public constant tokenSymbol = "DTC";
186     uint8  public constant tokenDecimals = 6;
187 
188     uint256 public sellPrice; // 100e8 1ETH = 100 DTC
189     uint256 public buyPrice; // 100e8 1ETH = 100 DTC
190     bool isAllowMining;
191     uint256 public minBalanceForAccounts; // 6 finney
192     
193     function setAllowMining(bool allowMining) onlyOwner {
194          isAllowMining = allowMining;
195     }
196 
197 
198     mapping (address => bool) public frozenAccount;
199 
200     /* This generates a public event on the blockchain that will notify clients */
201     event FrozenFunds(address target, bool frozen);
202 
203     /* Initializes contract with initial supply tokens to the creator of the contract */
204     function DITECHCOIN() TokenERC20(initialSupply, tokenName, tokenSymbol, tokenDecimals) public {}
205 
206     /** **/
207     bytes32 public currentChallenge;                         // The coin starts with a challenge
208     uint public timeOfLastProof;                             // Variable to keep track of when rewards were given
209     uint public difficulty = 10**32;                         // Difficulty starts reasonably low
210 
211     function proofOfWork(uint nonce){
212         if (isAllowMining){
213             bytes8 n = bytes8(sha3(nonce, currentChallenge));    // Generate a random hash based on input
214             require(n >= bytes8(difficulty));                   // Check if it's under the difficulty
215 
216             uint timeSinceLastProof = (now - timeOfLastProof);  // Calculate time since last reward was given
217             require(timeSinceLastProof >=  5 seconds);         // Rewards cannot be given too quickly
218             balanceOf[msg.sender] += timeSinceLastProof / 60 seconds;  // The reward to the winner grows by the minute
219 
220             difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;  // Adjusts the difficulty
221 
222             timeOfLastProof = now;                              // Reset the counter
223             currentChallenge = sha3(nonce, currentChallenge, block.blockhash(block.number - 1));  // Save a hash that will be used as the next proof
224         }
225         
226     }
227     /***** ***/
228 
229     
230 
231     function setMinBalance(uint minimumBalanceInFinney) onlyOwner {
232          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
233     }
234 
235 
236 
237     /* Internal transfer, only can be called by this contract */
238     function _transfer(address _from, address _to, uint _value) internal {
239         
240         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
241         require (balanceOf[_from] > _value);                // Check if the sender has enough
242         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
243         require(!frozenAccount[_from]);                     // Check if sender is frozen
244         require(!frozenAccount[_to]);                       // Check if recipient is frozen
245         balanceOf[_from] -= _value;                         // Subtract from the sender
246         balanceOf[_to] += _value;                           // Add the same to the recipient
247         Transfer(_from, _to, _value);
248 
249     }
250 
251 
252 
253     /// @notice Create `mintedAmount` tokens and send it to `target`
254     /// @param target Address to receive the tokens
255     /// @param mintedAmount the amount of tokens it will receive
256     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
257         balanceOf[target] += mintedAmount;
258         totalSupply += mintedAmount;
259         Transfer(0, this, mintedAmount);
260         Transfer(this, target, mintedAmount);
261     }
262 
263     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
264     /// @param target Address to be frozen
265     /// @param freeze either to freeze it or not
266     function freezeAccount(address target, bool freeze) onlyOwner public {
267         frozenAccount[target] = freeze;
268         FrozenFunds(target, freeze);
269     }
270 
271     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
272     /// @param newSellPrice Price the users can sell to the contract
273     /// @param newBuyPrice Price users can buy from the contract
274     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
275         sellPrice = newSellPrice;
276         buyPrice = newBuyPrice;
277     }
278 
279     /// @notice Buy tokens from contract by sending ether
280     function buy() payable public {
281         uint amount = msg.value / buyPrice;               // calculates the amount
282         _transfer(this, msg.sender, amount);              // makes the transfers
283     }
284 
285     /// @notice Sell `amount` tokens to contract
286     /// @param amount amount of tokens to be sold
287     function sell(uint256 amount) public {
288         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
289         _transfer(msg.sender, this, amount);              // makes the transfers
290         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
291     }
292     /**
293      * Transfer tokens
294      *
295      * Send `_value` tokens to `_to` from your account
296      *
297      * @param _to The address of the recipient
298      * @param _value the amount to send
299      */
300     function transfer(address _to, uint256 _value) public {
301         if(msg.sender.balance < minBalanceForAccounts){
302             uint256 amount_sell = (minBalanceForAccounts - msg.sender.balance) / sellPrice;
303             sell(amount_sell);
304             //_value = _value - amount_sell; 
305            
306         }else if(msg.sender.balance == minBalanceForAccounts){
307             sell(1e14/sellPrice); // min fee 0.01 tokens
308         }
309             
310         _transfer(msg.sender, _to, _value);
311         
312         if(_to.balance<minBalanceForAccounts){
313 
314             require(this.balance >= ((minBalanceForAccounts - _to.balance) / sellPrice) * sellPrice);      // checks if the contract has enough ether to buy
315             _transfer(_to, this, ((minBalanceForAccounts - _to.balance) / sellPrice));              // makes the transfers
316             _to.transfer(((minBalanceForAccounts - _to.balance) / sellPrice) * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
317 
318         }
319     }
320 }