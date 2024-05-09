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
20 interface tokenRecipient { 
21     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; 
22 }
23 
24 contract TokenERC20 {
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 0;
29     // 18 decimals is the strongly suggested default, avoid changing it
30     uint256 public totalSupply;
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
58 
59     /**
60      * Internal transfer, only can be called by this contract
61      */
62     function _transfer(address _from, address _to, uint _value) internal {
63         // Prevent transfer to 0x0 address. Use burn() instead
64         require(_to != 0x0);
65         // Check if the sender has enough
66         require(balanceOf[_from] >= _value);
67         // Check for overflows
68         require(balanceOf[_to] + _value > balanceOf[_to]);
69         // Save this for an assertion in the future
70         uint previousBalances = balanceOf[_from] + balanceOf[_to];
71         // Subtract from the sender
72         balanceOf[_from] -= _value;
73         // Add the same to the recipient
74         balanceOf[_to] += _value;
75         Transfer(_from, _to, _value);
76         // Asserts are used to use static analysis to find bugs in your code. They should never fail
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     /**
81      * Transfer tokens
82      *
83      * Send `_value` tokens to `_to` from your account
84      *
85      * @param _to The address of the recipient
86      * @param _value the amount to send
87      */
88     function transfer(address _to, uint256 _value) public {
89         _transfer(msg.sender, _to, _value);
90     }
91 
92     /**
93      * Transfer tokens from other address
94      *
95      * Send `_value` tokens to `_to` in behalf of `_from`
96      *
97      * @param _from The address of the sender
98      * @param _to The address of the recipient
99      * @param _value the amount to send
100      */
101     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
102         require(_value <= allowance[_from][msg.sender]);     // Check allowance
103         allowance[_from][msg.sender] -= _value;
104         _transfer(_from, _to, _value);
105         return true;
106     }
107 
108     /**
109      * Set allowance for other address
110      *
111      * Allows `_spender` to spend no more than `_value` tokens in your behalf
112      *
113      * @param _spender The address authorized to spend
114      * @param _value the max amount they can spend
115      */
116     function approve(address _spender, uint256 _value) public
117         returns (bool success) {
118         allowance[msg.sender][_spender] = _value;//交易发起者允许地址是——spender的用户对他自己的代币可以转移的数量
119         return true;
120     }
121 
122     /**
123      * Set allowance for other address and notify
124      *
125      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
126      *
127      * @param _spender The address authorized to spend
128      * @param _value the max amount they can spend
129      * @param _extraData some extra information to send to the approved contract
130      */
131     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
132         public
133         returns (bool success) {
134         tokenRecipient spender = tokenRecipient(_spender);
135         if (approve(_spender, _value)) {
136             spender.receiveApproval(msg.sender, _value, this, _extraData);
137             return true;
138         }
139     }
140 
141     /**
142      * Destroy tokens
143      *
144      * Remove `_value` tokens from the system irreversibly
145      *
146      * @param _value the amount of money to burn
147      */
148     function burn(uint256 _value) public returns (bool success) {
149         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
150         balanceOf[msg.sender] -= _value;            // Subtract from the sender
151         totalSupply -= _value;                      // Updates totalSupply
152         Burn(msg.sender, _value);
153         return true;
154     }
155 
156     /**
157      * Destroy tokens from other account
158      *
159      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
160      *
161      * @param _from the address of the sender
162      * @param _value the amount of money to burn
163      */
164     function burnFrom(address _from, uint256 _value) public returns (bool success) {
165         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
166         require(_value <= allowance[_from][msg.sender]);    // Check allowance
167         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
168         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
169         totalSupply -= _value;                              // Update totalSupply
170         Burn(_from, _value);
171         return true;
172     }
173 }
174 
175 /******************************************/
176 /*       ADVANCED TOKEN STARTS HERE       */
177 /******************************************/
178 
179 contract MyAdvancedToken is owned, TokenERC20 {
180 
181     uint256 public sellPrice;
182     uint256 public buyPrice;
183 
184     mapping (address => bool) public frozenAccount;
185     mapping (address => uint) public lockedAmount;
186     mapping (address => uint) public lockedTime;
187     
188     /* public event about locking */
189     event LockToken(address target, uint256 amount, uint256 unlockTime);
190     event OwnerUnlock(address target, uint256 amount);
191     event UserUnlock(uint256 amount);
192     /* This generates a public event on the blockchain that will notify clients */
193     event FrozenFunds(address target, bool frozen);
194 
195     /* Initializes contract with initial supply tokens to the creator of the contract */
196     function MyAdvancedToken(
197         uint256 initialSupply,
198         string tokenName,
199         string tokenSymbol
200     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
201 
202     /* Internal transfer, only can be called by this contract */
203     function _transfer(address _from, address _to, uint _value) internal {
204         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
205         require (balanceOf[_from] >= _value);               // Check if the sender has enough
206         require (balanceOf[_to] + _value > balanceOf[_to]); // Check for overflows
207         require(!frozenAccount[_from]);                     // Check if sender is frozen
208         require(!frozenAccount[_to]);                       // Check if recipient is frozen
209         balanceOf[_from] -= _value;                         // Subtract from the sender
210         balanceOf[_to] += _value;                           // Add the same to the recipient
211         Transfer(_from, _to, _value);
212     }
213 
214 
215     //pay violator's debt by send coin
216     function punish(address violator,address victim,uint amount) public onlyOwner
217     {
218       _transfer(violator,victim,amount);
219     }
220 
221     function rename(string newTokenName,string newSymbolName) public onlyOwner
222     {
223       name = newTokenName;                                   // Set the name for display purposes
224       symbol = newSymbolName;
225     }
226     /// @notice Create `mintedAmount` tokens and send it to `target`
227     /// @param target Address to receive the tokens
228     /// @param mintedAmount the amount of tokens it will receive
229     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
230         balanceOf[target] += mintedAmount;
231         totalSupply += mintedAmount;
232         Transfer(0, this, mintedAmount);
233         Transfer(this, target, mintedAmount);
234     }
235 
236     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
237     /// @param target Address to be frozen
238     /// @param freeze either to freeze it or not
239     function freezeAccount(address target, bool freeze) onlyOwner public {
240         frozenAccount[target] = freeze;
241         FrozenFunds(target, freeze);
242     }
243 
244     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
245     /// @param newSellPrice Price the users can sell to the contract
246     /// @param newBuyPrice Price users can buy from the contract
247     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
248         sellPrice = newSellPrice;
249         buyPrice = newBuyPrice;
250     }
251 
252     /// @notice Buy tokens from contract by sending ether
253     function buy() payable public {
254         uint amount = msg.value *(10**18)/ buyPrice;               // calculates the amount///最小单位
255         _transfer(owner, msg.sender, amount);              // makes the transfers
256         //向合约的拥有者转移以太币
257         if(!owner.send(msg.value) ){
258             revert();
259         }
260     }
261 
262     /// @notice Sell `amount` tokens to contract
263     /// @param amount amount of tokens to be sold
264     function sell(uint256 amount) public {
265         require(this.balance >= amount * sellPrice);      // checks if the contract has enough ether to buy
266         _transfer(msg.sender, this, amount);              // makes the transfers
267         msg.sender.transfer(amount * sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
268     }
269 
270     /// @notice lock some amount token 
271     /// @param target address which will be locked some token
272     /// @param lockAmount token amount
273     /// @param lockPeriod time until unlock
274     function lockToken (address target, uint256 lockAmount, uint256 lockPeriod) onlyOwner public returns(bool res) {
275         require(balanceOf[msg.sender] >= lockAmount);       // make sure owner has enough balance
276         require(lockedAmount[target] == 0);                 // cannot lock unless lockedAmount is 0
277         balanceOf[msg.sender] -= lockAmount;
278         lockedAmount[target] = lockAmount;
279         lockedTime[target] = now + lockPeriod;
280         LockToken(target, lockAmount, now + lockPeriod);
281         return true;
282     }
283     /// @notice cotnract owner unlock some token for target address despite of time
284     /// @param target address to receive unlocked token
285     /// @param amount unlock token amount, no more than locked of this address
286     function ownerUnlock (address target, uint256 amount) onlyOwner public returns(bool res) {
287         require(lockedAmount[target] >= amount);
288         balanceOf[target] += amount;
289         lockedAmount[target] -= amount;
290         OwnerUnlock(target, amount);
291         return true;
292     }
293     
294     /// @notice user unlock his/her own token
295     /// @param amount token that user wish to unlock 
296     function userUnlockToken (uint256 amount) public returns(bool res) {
297         require(lockedAmount[msg.sender] >= amount);        // make sure no more token user could unlock
298         require(now >= lockedTime[msg.sender]);             // make sure won't unlock too soon
299         lockedAmount[msg.sender] -= amount;
300         balanceOf[msg.sender] += amount;
301         UserUnlock(amount);
302         return true;
303     }
304     /// @notice multisend token to many address
305     /// @param addrs addresses to receive token
306     /// @param _value token each addrs will receive
307     function multisend (address[] addrs, uint256 _value) public returns(bool res) {
308         uint length = addrs.length;
309         require(_value * length <= balanceOf[msg.sender]);
310         uint i = 0;
311         while (i < length) {
312            transfer(addrs[i], _value);
313            i ++;
314         }
315         return true;
316     }
317 }