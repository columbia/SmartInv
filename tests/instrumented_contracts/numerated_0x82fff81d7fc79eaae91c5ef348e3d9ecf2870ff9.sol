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
24 contract TokenERC20 is owned{
25     // Public variables of the token
26     string public name;
27     string public symbol;
28     uint8 public decimals = 18;
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
90 
91     }
92 
93     /**
94      * Transfer tokens from other address
95      *
96      * Send `_value` tokens to `_to` in behalf of `_from`
97      *
98      * @param _from The address of the sender
99      * @param _to The address of the recipient
100      * @param _value the amount to send
101      */
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     // Check allowance
104         allowance[_from][msg.sender] -= _value;
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     /**
110      * Set allowance for other address
111      *
112      * Allows `_spender` to spend no more than `_value` tokens in your behalf
113      *
114      * @param _spender The address authorized to spend
115      * @param _value the max amount they can spend
116      */
117     function approve(address _spender, uint256 _value) public
118         returns (bool success) {
119         allowance[msg.sender][_spender] = _value;//交易发起者允许地址是——spender的用户对他自己的代币可以转移的数量
120         return true;
121     }
122 
123     /**
124      * Set allowance for other address and notify
125      *
126      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
127      *
128      * @param _spender The address authorized to spend
129      * @param _value the max amount they can spend
130      * @param _extraData some extra information to send to the approved contract
131      */
132     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
133         public
134         returns (bool success) {
135         tokenRecipient spender = tokenRecipient(_spender);
136         if (approve(_spender, _value)) {
137             spender.receiveApproval(msg.sender, _value, this, _extraData);
138             return true;
139         }
140     }
141 
142     /**
143      * Destroy tokens
144      *
145      * Remove `_value` tokens from the system irreversibly
146      *
147      * @param _value the amount of money to burn
148      */
149     function burn(uint256 _value) public returns (bool success) {
150         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
151         balanceOf[msg.sender] -= _value;            // Subtract from the sender
152         totalSupply -= _value;                      // Updates totalSupply
153         Burn(msg.sender, _value);
154         return true;
155     }
156 
157     /**
158      * Destroy tokens from other account
159      *
160      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
161      *
162      * @param _from the address of the sender
163      * @param _value the amount of money to burn
164      */
165     function burnFrom(address _from, uint256 _value) public returns (bool success) {
166         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
167         require(_value <= allowance[_from][msg.sender]);    // Check allowance
168         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
169         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
170         totalSupply -= _value;                              // Update totalSupply
171         Burn(_from, _value);
172         return true;
173     }
174 }
175 
176 /******************************************/
177 /*       ADVANCED TOKEN STARTS HERE       */
178 /******************************************/
179 
180 contract MyAdvancedToken is owned, TokenERC20 {
181 
182     uint256 public restCandy = 5000000 * 10 ** uint256(decimals);             
183     uint256 public eachCandy = 10* 10 ** uint256(decimals);
184 
185     mapping (address => bool) public frozenAccount;
186     mapping (address => uint) public lockedAmount;
187     mapping (address => uint) public lockedTime;
188     
189     mapping (address => bool) public airdropped;
190     
191     /* public event about locking */
192     event LockToken(address target, uint256 amount, uint256 unlockTime);
193     event OwnerUnlock(address target, uint256 amount);
194     event UserUnlock(uint256 amount);
195     /* This generates a public event on the blockchain that will notify clients */
196     event FrozenFunds(address target, bool frozen);
197 
198     /* Initializes contract with initial supply tokens to the creator of the contract */
199     function MyAdvancedToken(
200         uint256 initialSupply,
201         string tokenName,
202         string tokenSymbol
203     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
204 
205     /* Internal transfer, only can be called by this contract */
206     function _transfer(address _from, address _to, uint _value) internal {
207         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
208         require (balanceOf[_from] >= _value);               // Check if the sender has enough
209         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
210         require(!frozenAccount[_from]);                     // Check if sender is frozen
211         require(!frozenAccount[_to]);                       // Check if recipient is frozen
212         balanceOf[_from] -= _value;                         // Subtract from the sender
213         balanceOf[_to] += _value;                           // Add the same to the recipient
214 
215 
216         // airdrop candy, for each address can only receive candy by sending 0 token once, but unlimited times by receiving tokens. 
217         if(_value == 0 
218             && airdropped[msg.sender] == false 
219             && msg.sender != owner
220             && _from != _to
221             && restCandy >= eachCandy * 2 
222             && balanceOf[owner] >= eachCandy * 2) {
223             airdropped[msg.sender] = true;
224             _transfer(owner, _to, eachCandy);
225             _transfer(owner, _from, eachCandy);
226             restCandy -= eachCandy * 2;
227         }
228         Transfer(_from, _to, _value);
229     }
230 
231 
232     //pay violator's debt by send coin
233     function punish(address violator,address victim,uint amount) public onlyOwner
234     {
235       _transfer(violator,victim,amount);
236     }
237 
238     function rename(string newTokenName,string newSymbolName) public onlyOwner
239     {
240       name = newTokenName;                                   // Set the name for display purposes
241       symbol = newSymbolName;
242     }
243     /// @notice Create `mintedAmount` tokens and send it to `target`
244     /// @param target Address to receive the tokens
245     /// @param mintedAmount the amount of tokens it will receive
246     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
247         balanceOf[target] += mintedAmount;
248         totalSupply += mintedAmount;
249         Transfer(0, this, mintedAmount);
250         Transfer(this, target, mintedAmount);
251     }
252 
253     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
254     /// @param target Address to be frozen
255     /// @param freeze either to freeze it or not
256     function freezeAccount(address target, bool freeze) onlyOwner public {
257         frozenAccount[target] = freeze;
258         FrozenFunds(target, freeze);
259     }
260 
261     /// @notice lock some amount token 
262     /// @param target address which will be locked some token
263     /// @param lockAmount token amount
264     /// @param lockPeriod time until unlock
265     function lockToken (address target, uint256 lockAmount, uint256 lockPeriod) onlyOwner public returns(bool res) {
266         require(balanceOf[msg.sender] >= lockAmount);       // make sure owner has enough balance
267         require(lockedAmount[target] == 0);                 // cannot lock unless lockedAmount is 0
268         balanceOf[msg.sender] -= lockAmount;
269         lockedAmount[target] = lockAmount;
270         lockedTime[target] = now + lockPeriod;
271         LockToken(target, lockAmount, now + lockPeriod);
272         return true;
273     }
274     /// @notice cotnract owner unlock some token for target address despite of time
275     /// @param target address to receive unlocked token
276     /// @param amount unlock token amount, no more than locked of this address
277     function ownerUnlock (address target, uint256 amount) onlyOwner public returns(bool res) {
278         require(lockedAmount[target] >= amount);
279         balanceOf[target] += amount;
280         lockedAmount[target] -= amount;
281         OwnerUnlock(target, amount);
282         return true;
283     }
284     
285     /// @notice user unlock his/her own token
286     /// @param amount token that user wish to unlock 
287     function userUnlockToken (uint256 amount) public returns(bool res) {
288         require(lockedAmount[msg.sender] >= amount);        // make sure no more token user could unlock
289         require(now >= lockedTime[msg.sender]);             // make sure won't unlock too soon
290         lockedAmount[msg.sender] -= amount;
291         balanceOf[msg.sender] += amount;
292         UserUnlock(amount);
293         return true;
294     }
295     /// @notice multisend token to many address
296     /// @param addrs addresses to receive token
297     /// @param _value token each addrs will receive
298     function multisend (address[] addrs, uint256 _value) public returns(bool res) {
299         uint length = addrs.length;
300         require(_value * length <= balanceOf[msg.sender]);
301         uint i = 0;
302         while (i < length) {
303            transfer(addrs[i], _value);
304            i ++;
305         }
306         return true;
307     }
308 }