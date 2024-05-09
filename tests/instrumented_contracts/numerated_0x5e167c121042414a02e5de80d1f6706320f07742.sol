1 pragma solidity ^0.4.16;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 
36 contract owned {
37     address public owner;
38 
39     function owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         owner = newOwner;
50     }
51 }
52 
53 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
54 
55 contract TokenERC20 {
56     // Public variables of the token
57    
58     string public name;
59     string public symbol;
60 
61     uint8 public decimals = 18;
62     // 18 decimals is the strongly suggested default, avoid changing it
63     uint256 public totalSupply;
64 
65     
66     
67     
68     // This creates an array with all balances
69     mapping (address => uint256) public balanceOf;
70     mapping (address => mapping (address => uint256)) public allowance;
71 
72     // This generates a public event on the blockchain that will notify clients
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     // This notifies clients about the amount burnt
76     event Burn(address indexed from, uint256 value);
77 
78     /**
79      * Constrctor function
80      *
81      * Initializes contract with initial supply tokens to the creator of the contract
82      */
83     function TokenERC20(
84         uint256 initialSupply,
85         string tokenName,
86         string tokenSymbol
87     ) public 
88     {
89         totalSupply = initialSupply * 10**18;  // Update total supply with the decimal amount
90         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
91         name = tokenName;                                   // Set the name for display purposes
92         symbol = tokenSymbol;                               // Set the symbol for display purposes
93     }
94 
95 
96     /**
97      * Internal transfer, only can be called by this contract
98      */
99     function _transfer(address _from, address _to, uint _value) internal {
100         // Prevent transfer to 0x0 address. Use burn() instead
101         require(_to != 0x0);
102         // Check if the sender has enough
103         require(balanceOf[_from] >= _value);
104         // Check for overflows
105         require(balanceOf[_to] + _value > balanceOf[_to]);
106         // Save this for an assertion in the future
107         uint previousBalances = balanceOf[_from] + balanceOf[_to];
108         // Subtract from the sender
109         balanceOf[_from] -= _value;
110         // Add the same to the recipient
111         balanceOf[_to] += _value;
112         Transfer(_from, _to, _value);
113         // Asserts are used to use static analysis to find bugs in your code. They should never fail
114         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
115     }
116 
117     /**
118      * Transfer tokens
119      *
120      * Send `_value` tokens to `_to` from your account
121      *
122      * @param _to The address of the recipient
123      * @param _value the amount to send
124      */
125     function transfer(address _to, uint256 _value) public {
126         _transfer(msg.sender, _to, _value);
127     }
128 
129     /**
130      * Transfer tokens from other address
131      *
132      * Send `_value` tokens to `_to` in behalf of `_from`
133      *
134      * @param _from The address of the sender
135      * @param _to The address of the recipient
136      * @param _value the amount to send
137      */
138     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
139         require(_value <= allowance[_from][msg.sender]);     // Check allowance
140         allowance[_from][msg.sender] -= _value;
141         _transfer(_from, _to, _value);
142         return true;
143     }
144 
145     /**
146      * Set allowance for other address
147      *
148      * Allows `_spender` to spend no more than `_value` tokens in your behalf
149      *
150      * @param _spender The address authorized to spend
151      * @param _value the max amount they can spend
152      */
153     function approve(address _spender, uint256 _value) public
154         returns (bool success) 
155         {
156         allowance[msg.sender][_spender] = _value;
157         return true;
158     }
159 
160     /**
161      * Set allowance for other address and notify
162      *
163      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
164      *
165      * @param _spender The address authorized to spend
166      * @param _value the max amount they can spend
167      * @param _extraData some extra information to send to the approved contract
168      */
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
170         public
171         returns (bool success) 
172         {
173         tokenRecipient spender = tokenRecipient(_spender);
174         if (approve(_spender, _value)) {
175             spender.receiveApproval(msg.sender, _value, this, _extraData);
176             return true;
177         }
178     }
179 
180     /**
181      * Destroy tokens
182      *
183      * Remove `_value` tokens from the system irreversibly
184      *
185      * @param _value the amount of money to burn
186      */
187     function burn(uint256 _value) public returns (bool success) {
188         _value = _value * (10**18);
189         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
190         balanceOf[msg.sender] -= _value;            // Subtract from the sender
191         totalSupply -= _value;                      // Updates totalSupply
192         Burn(msg.sender, _value);
193         return true;
194     }
195 
196 
197     /**
198      * Destroy tokens from other account
199      *
200      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
201      *
202      * @param _from the address of the sender
203      * @param _value the amount of money to burn
204      */
205     function burnFrom(address _from, uint256 _value) public returns (bool success) {
206         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
207         require(_value <= allowance[_from][msg.sender]);    // Check allowance
208         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
209         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
210         totalSupply -= _value;                              // Update totalSupply
211         Burn(_from, _value);
212         return true;
213     }
214 }
215 
216 /******************************************/
217 /*       ADVANCED TOKEN STARTS HERE       */
218 /******************************************/
219 
220 contract DaddyToken is owned, TokenERC20 {
221     
222     uint8 public decimals = 18;
223     
224     uint256 public totalContribution = 0;
225     uint256 public totalBonusTokensIssued = 0;
226  
227     uint256 public sellTokenPerEther;
228     uint256 public buyTokenPerEther;
229     bool public purchasingAllowed = true;
230     
231     mapping (address => bool) public frozenAccount;
232 
233     /* This generates a public event on the blockchain that will notify clients */
234     event FrozenFunds(address target, bool frozen);
235 
236     /* Initializes contract with initial supply tokens to the creator of the contract */
237        function DaddyToken(
238         uint256 initialSupply,
239         string tokenName,
240         string tokenSymbol
241     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public 
242     {}
243 
244 
245     function distributeToken(address[] addresses, uint256 _value) onlyOwner public returns (bool) {
246         for (uint i = 0; i < addresses.length; i++) {
247             _value = _value * 10**18;
248             balanceOf[owner] -= _value;
249             balanceOf[addresses[i]] += _value;
250             Transfer(owner, addresses[i], _value);
251         }
252     }
253 
254     function enablePurchasing() onlyOwner public {
255         require (msg.sender == owner); 
256         purchasingAllowed = true;
257     }
258     function disablePurchasing() onlyOwner public {
259         require (msg.sender == owner); 
260         purchasingAllowed = false;
261     }
262     /* Internal transfer, only can be called by this contract */
263     function _transfer(address _from, address _to, uint _value) internal {
264         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
265         require (balanceOf[_from] >= _value);               // Check if the sender has enough
266         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
267         require(!frozenAccount[_from]);                     // Check if sender is frozen
268         require(!frozenAccount[_to]);                       // Check if recipient is frozen
269         balanceOf[_from] -= _value;                         // Subtract from the sender
270         balanceOf[_to] += _value;                           // Add the same to the recipient
271         Transfer(_from, _to, _value);
272     }
273 
274     /// @notice Create `mintedAmount` tokens and send it to `target`
275     /// @param target Address to receive the tokens
276     /// @param mintedAmount the amount of tokens it will receive
277     function mintToken(address target, uint256 mintedAmount) onlyOwner public returns (bool) {
278         mintedAmount = mintedAmount * 10**18;
279         balanceOf[target] += mintedAmount;
280         totalSupply += mintedAmount;
281         Transfer(0, this, mintedAmount);
282         Transfer(this, target, mintedAmount);
283         return true;
284     }
285 
286     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
287     /// @param target Address to be frozen
288     /// @param freeze either to freeze it or not
289     function freezeAccount(address target, bool freeze) onlyOwner public {
290         frozenAccount[target] = freeze;
291         FrozenFunds(target, freeze);
292     }
293 
294     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
295     /// @param newSellPrice Price the users can sell to the contract
296     /// @param newBuyPrice Price users can buy from the contract
297     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
298         sellTokenPerEther = newSellPrice;
299         buyTokenPerEther = newBuyPrice;
300     }
301 
302     /// @notice Buy tokens from contract by sending ether
303     function() payable public {
304         require(msg.value > 0);
305         require(purchasingAllowed);
306         //uint amount = msg.value / buyTokenPerEther;               // calculates the amount
307         //_transfer(this, msg.sender, amount);              // makes the transfers
308 
309         owner.transfer(msg.value);
310         totalContribution += msg.value;
311 
312         uint256 tokensIssued = (msg.value * buyTokenPerEther);
313 
314         if (msg.value >= 10 finney) {
315             tokensIssued += totalContribution;
316 
317             bytes20 bonusHash = ripemd160(block.coinbase, block.number, block.timestamp);
318             if (bonusHash[0] == 0) {
319                 uint8 bonusMultiplier = ((bonusHash[1] & 0x01 != 0) ? 1 : 0) + ((bonusHash[1] & 0x02 != 0) ? 1 : 0) + ((bonusHash[1] & 0x04 != 0) ? 1 : 0) + ((bonusHash[1] & 0x08 != 0) ? 1 : 0) + ((bonusHash[1] & 0x10 != 0) ? 1 : 0) + ((bonusHash[1] & 0x20 != 0) ? 1 : 0) + ((bonusHash[1] & 0x40 != 0) ? 1 : 0) + ((bonusHash[1] & 0x80 != 0) ? 1 : 0);
320                 
321                 uint256 bonusTokensIssued = (msg.value * 100) * bonusMultiplier;
322                 tokensIssued += bonusTokensIssued;
323 
324                 totalBonusTokensIssued += bonusTokensIssued;
325             }
326         }
327 
328         totalSupply += tokensIssued;
329         balanceOf[msg.sender] += tokensIssued;
330         
331         Transfer(address(this), msg.sender, tokensIssued);
332     
333     
334     }
335 
336     /// @notice Sell `amount` tokens to contract
337     /// @param amount amount of tokens to be sold
338     function sell(uint256 amount) public {
339         require(this.balance >= amount * sellTokenPerEther);      // checks if the contract has enough ether to buy
340         _transfer(msg.sender, this, amount);              // makes the transfers
341         msg.sender.transfer(amount * sellTokenPerEther);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
342     }
343 }