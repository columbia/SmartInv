1 pragma solidity ^0.4.24;
2 
3 contract Owned {
4 
5     address public owner;
6     
7     function Owned() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         // Prevent transfer to 0x0 address.
18         require(newOwner != 0x0);
19         owner = newOwner;
20     }
21 }
22 
23 library SafeMath {
24     function add(uint a, uint b) internal pure returns (uint c) {
25         c = a + b;
26         require(c >= a);
27     }
28 
29     function sub(uint a, uint b) internal pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33 
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     
39     function div(uint a, uint b) internal pure returns (uint c) {
40         require(b > 0);
41         c = a / b;
42     }
43 }
44 
45 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
50 // ----------------------------------------------------------------------------
51 contract ERC20Interface {
52     function totalSupply() public constant returns (uint);
53     function balanceOf(address tokenOwner) public constant returns (uint balance);
54     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
55     function transfer(address to, uint tokens) public returns (bool success);
56     function approve(address spender, uint tokens) public returns (bool success);
57     function transferFrom(address from, address to, uint tokens) public returns (bool success);
58 
59     event Transfer(address indexed from, address indexed to, uint tokens);
60     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
61 }
62 
63 contract TokenERC20 {
64     using SafeMath for uint;
65 
66     // Public variables of the token
67     string public name;
68     string public symbol;
69     uint8 public decimals = 18;
70     // 18 decimals is the strongly suggested default, avoid changing it
71     uint256 public totalSupply;
72 
73     // This creates an array with all balances
74     mapping (address => uint256) public balanceOf;
75     mapping (address => mapping (address => uint256)) public allowance;
76 
77     // This generates a public event on the blockchain that will notify clients
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     // This notifies clients about the amount burnt
81     event Burn(address indexed from, uint256 value);
82     
83     event Approval(address indexed tokenOwner, address indexed spender, uint value);
84 
85     /**
86      * Constrctor function
87      *
88      * Initializes contract with initial supply tokens to the creator of the contract
89      */
90     function TokenERC20() public {
91         totalSupply = 160000000 * 10 ** uint256(decimals);  // Update total supply with the decimal amount
92         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
93         name = 'LEXIT';                                   // Set the name for display purposes
94         symbol = 'LXT';                               // Set the symbol for display purposes
95     }
96 
97     /**
98      * Internal transfer, only can be called by this contract
99      */
100     function _transfer(address _from, address _to, uint _value) internal {
101         // Prevent transfer to 0x0 address. Use burn() instead
102         require(_to != 0x0);
103         // Check if the sender has enough
104         require(balanceOf[_from] >= _value);
105         // Check for overflows
106         require(balanceOf[_to].add(_value) > balanceOf[_to]);
107         // Save this for an assertion in the future
108         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
109         // Subtract from the sender
110         balanceOf[_from] = balanceOf[_from].sub(_value);
111         // Add the same to the recipient
112         balanceOf[_to] = balanceOf[_to].add(_value);
113         emit Transfer(_from, _to, _value);
114         // Asserts are used to use static analysis to find bugs in your code. They should never fail
115         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
116     }
117 
118     /**
119      * Transfer tokens
120      *
121      * Send `_value` tokens to `_to` from your account
122      *
123      * @param _to The address of the recipient
124      * @param _value the amount to send
125      */
126     function transfer(address _to, uint256 _value) public returns (bool success) {
127         _transfer(msg.sender, _to, _value);
128         return true;
129     }
130 
131     /**
132      * Transfer tokens from other address
133      *
134      * Send `_value` tokens to `_to` in behalf of `_from`
135      *
136      * @param _from The address of the sender
137      * @param _to The address of the recipient
138      * @param _value the amount to send
139      */
140     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141         require(_value <= allowance[_from][msg.sender]);     // Check allowance
142         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
143         _transfer(_from, _to, _value);
144         return true;
145     }
146 
147     /**
148      * Set allowance for other address
149      *
150      * Allows `_spender` to spend no more than `_value` tokens in your behalf
151      *
152      * @param _spender The address authorized to spend
153      * @param _value the max amount they can spend
154      */
155     function approve(address _spender, uint256 _value) public
156         returns (bool success) {
157         allowance[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162     /**
163      * Set allowance for other address and notify
164      *
165      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
166      *
167      * @param _spender The address authorized to spend
168      * @param _value the max amount they can spend
169      * @param _extraData some extra information to send to the approved contract
170      */
171     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
172         public
173         returns (bool success) {
174         tokenRecipient spender = tokenRecipient(_spender);
175         approve(_spender, _value);
176         spender.receiveApproval(msg.sender, _value, this, _extraData);
177         return true;
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
188         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
189         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
190         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
191         emit Burn(msg.sender, _value);
192         return true;
193     }
194 
195     /**
196      * Destroy tokens from other account
197      *
198      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
199      *
200      * @param _from the address of the sender
201      * @param _value the amount of money to burn
202      */
203     function burnFrom(address _from, uint256 _value) public returns (bool success) {
204         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
205         require(_value <= allowance[_from][msg.sender]);    // Check allowance
206         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the targeted balance
207         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);             // Subtract from the sender's allowance
208         totalSupply = totalSupply.sub(_value);                              // Update totalSupply
209         emit Burn(_from, _value);
210         return true;
211     }
212 }
213 
214 contract LexitToken is Owned, TokenERC20 {
215     using SafeMath for uint;
216 
217     uint256 public sellPrice;
218     uint256 public buyPrice;
219 
220     mapping (address => bool) public frozenAccount;
221 
222     /* This generates a public event on the blockchain that will notify clients */
223     event FrozenFunds(address target, bool frozen);
224 
225     /* Initializes contract with initial supply tokens to the creator of the contract */
226     function LexitToken() TokenERC20() public {
227         sellPrice = 1000 * 10 ** uint256(decimals);
228         buyPrice =  1 * 10 ** uint256(decimals);
229     }
230 
231     /* Internal transfer, only can be called by this contract */
232     function _transfer(address _from, address _to, uint _value) internal {
233         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
234         require (balanceOf[_from] >= _value);               // Check if the sender has enough
235         require (balanceOf[_to].add(_value) > balanceOf[_to]); // Check for overflows
236         require(!frozenAccount[_from]);                     // Check if sender is frozen
237         require(!frozenAccount[_to]);                       // Check if recipient is frozen
238         balanceOf[_from] = balanceOf[_from].sub(_value);                         // Subtract from the sender
239         balanceOf[_to] = balanceOf[_to].add(_value);                           // Add the same to the recipient
240         emit Transfer(_from, _to, _value);
241     }
242 
243     /// @notice Create `mintedAmount` tokens and send it to `target`
244     /// @param target Address to receive the tokens
245     /// @param mintedAmount the amount of tokens it will receive
246     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
247         balanceOf[target] = balanceOf[target].add(mintedAmount);
248         totalSupply = totalSupply.add(mintedAmount);
249         emit Transfer(0, this, mintedAmount);
250         emit Transfer(this, target, mintedAmount);
251     }
252 
253     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
254     /// @param target Address to be frozen
255     /// @param freeze either to freeze it or not
256     function freezeAccount(address target, bool freeze) onlyOwner public {
257         frozenAccount[target] = freeze;
258         emit FrozenFunds(target, freeze);
259     }
260 
261     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
262     /// @param newSellPrice Price the users can sell to the contract
263     /// @param newBuyPrice Price users can buy from the contract
264     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
265         require(newSellPrice > 0);
266         require(newBuyPrice > 0);
267         sellPrice = newSellPrice;        
268         buyPrice = newBuyPrice;
269     }
270 
271     /// @notice Buy tokens from contract by sending ether
272     function buy() payable public {
273         uint amount = msg.value.div(buyPrice);               // calculates the amount
274         _transfer(this, msg.sender, amount);              // makes the transfers
275     }
276 
277     /// @notice Sell `amount` tokens to contract
278     /// @param amount amount of tokens to be sold
279     function sell(uint256 amount) public {
280         require(address(this).balance >= amount.mul(sellPrice));      // checks if the contract has enough ether to buy
281         _transfer(msg.sender, this, amount);              // makes the transfers
282         msg.sender.transfer(amount.mul(sellPrice));          // sends ether to the seller. It's important to do this last to avoid recursion attacks
283     }
284     
285     // ------------------------------------------------------------------------
286     // Owner can transfer out any accidentally sent ERC20 tokens
287     // ------------------------------------------------------------------------
288     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
289         return ERC20Interface(tokenAddress).transfer(owner, tokens);
290     }
291 }
292 
293 contract LxtBonusDistribution is Owned {
294     using SafeMath for uint;
295     
296     LexitToken public LXT;
297     address public LXT_OWNER; 
298 
299     uint256 private constant decimalFactor = 10**uint256(18);
300 
301     enum AllocationType { WHITE_LISTING, BOUNTY, AIRDROP, REFERRAL }
302 
303     uint256 public constant INITIAL_SUPPLY = 2488000 * decimalFactor;
304     uint256 public AVAILABLE_TOTAL_SUPPLY = 2488000 * decimalFactor;
305     uint256 public AVAILABLE_WHITE_LISTING_SUPPLY = 50000 * decimalFactor; 
306     uint256 public AVAILABLE_BOUNTY_SUPPLY = 1008000 * decimalFactor;
307     uint256 public AVAILABLE_REFERRAL_SUPPLY = 430000 * decimalFactor;
308     uint256 public AVAILABLE_AIRDROP_SUPPLY = 1000000 * decimalFactor; 
309 
310     uint256 public grandTotalClaimed = 0;
311 
312     struct Allocation {
313         uint256 totalAllocated; // Total tokens allocated
314         uint256 amountClaimed;  // Total tokens claimed
315     }
316   
317     mapping(address => mapping(uint8 => Allocation)) public allocations;
318 
319     mapping (address => bool) public admins;
320 
321     modifier onlyOwnerOrAdmin() {
322         require(msg.sender == owner || admins[msg.sender]);
323         _;
324     }
325 
326     function LxtBonusDistribution(LexitToken _tokenContract, address _withdrawnWallet) public {
327         LXT = _tokenContract;
328         LXT_OWNER = _withdrawnWallet;
329     }
330 
331     function updateLxtOwner(address _withdrawnWallet) public onlyOwnerOrAdmin {
332         LXT_OWNER = _withdrawnWallet;
333     }
334  
335     function setAdmin(address _admin, bool _isAdmin) public onlyOwnerOrAdmin {
336         admins[_admin] = _isAdmin;
337     }
338  
339     function setAllocation (address[] _recipients, uint256[] _amounts, AllocationType _bonusType) public onlyOwnerOrAdmin {
340         require(_recipients.length == _amounts.length);
341         require(_bonusType >= AllocationType.WHITE_LISTING && _bonusType <= AllocationType.REFERRAL);
342         for (uint256 i = 0; i < _recipients.length; i++) {
343             require(_recipients[i] != address(0));
344         }
345 
346         for (uint256 addressIndex = 0; addressIndex < _recipients.length; addressIndex++) {
347             address recipient = _recipients[addressIndex];
348             uint256 amount = _amounts[addressIndex] * decimalFactor;
349 
350             if (_bonusType == AllocationType.BOUNTY) {
351                 AVAILABLE_BOUNTY_SUPPLY = AVAILABLE_BOUNTY_SUPPLY.sub(amount);
352             } else if (_bonusType == AllocationType.AIRDROP) {
353                 AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.sub(amount);
354             } else if (_bonusType == AllocationType.WHITE_LISTING) {
355                 AVAILABLE_WHITE_LISTING_SUPPLY = AVAILABLE_WHITE_LISTING_SUPPLY.sub(amount);
356             } else if (_bonusType == AllocationType.REFERRAL) {
357                 AVAILABLE_REFERRAL_SUPPLY = AVAILABLE_REFERRAL_SUPPLY.sub(amount);
358             } 
359             
360             uint256 newAmount = allocations[recipient][uint8(_bonusType)].totalAllocated.add(amount);
361             allocations[recipient][uint8(_bonusType)] = Allocation(newAmount, allocations[recipient][uint8(_bonusType)].amountClaimed);
362 
363             AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.sub(amount);
364         }
365     }
366 
367     function updateAllocation (address[] _recipients, uint256[] _amounts, uint256[] _claimedAmounts, AllocationType _bonusType) public onlyOwnerOrAdmin {
368         require(_recipients.length == _amounts.length);
369         require(_bonusType >= AllocationType.WHITE_LISTING && _bonusType <= AllocationType.REFERRAL);
370         for (uint256 i = 0; i < _recipients.length; i++) {
371             require(_recipients[i] != address(0));
372         }
373 
374         for (uint256 addressIndex = 0; addressIndex < _recipients.length; addressIndex++) {
375             address recipient = _recipients[addressIndex];
376             uint256 amount = _amounts[addressIndex] * decimalFactor;
377             uint256 difference = amount.sub(allocations[recipient][uint8(_bonusType)].totalAllocated);
378             if (_bonusType == AllocationType.BOUNTY) {
379                 AVAILABLE_BOUNTY_SUPPLY = AVAILABLE_BOUNTY_SUPPLY.add(difference);
380             } else if (_bonusType == AllocationType.AIRDROP) {
381                 AVAILABLE_AIRDROP_SUPPLY = AVAILABLE_AIRDROP_SUPPLY.add(difference);
382             } else if (_bonusType == AllocationType.WHITE_LISTING) {
383                 AVAILABLE_WHITE_LISTING_SUPPLY = AVAILABLE_WHITE_LISTING_SUPPLY.add(difference);
384             } else if (_bonusType == AllocationType.REFERRAL) {
385                 AVAILABLE_REFERRAL_SUPPLY = AVAILABLE_REFERRAL_SUPPLY.add(difference);
386             } 
387             
388             allocations[recipient][uint8(_bonusType)] = Allocation(amount, _claimedAmounts[addressIndex]);
389             AVAILABLE_TOTAL_SUPPLY = AVAILABLE_TOTAL_SUPPLY.add(difference);
390         }
391     }
392 
393     function transferTokens (address[] _recipients, AllocationType _bonusType) public onlyOwnerOrAdmin {
394         for (uint256 i = 0; i < _recipients.length; i++) {
395             require(_recipients[i] != address(0));
396             require(allocations[_recipients[i]][uint8(_bonusType)].amountClaimed < allocations[_recipients[i]][uint8(_bonusType)].totalAllocated);
397         }
398         for (uint256 addressIndex = 0; addressIndex < _recipients.length; addressIndex++) {
399             address recipient = _recipients[addressIndex];
400             Allocation storage allocation = allocations[recipient][uint8(_bonusType)];
401             if (allocation.totalAllocated > 0) {
402                 uint256 amount = allocation.totalAllocated.sub(allocation.amountClaimed);
403                 require(LXT.transferFrom(LXT_OWNER, recipient, amount));
404                 allocation.amountClaimed = allocation.amountClaimed.add(amount);
405                 grandTotalClaimed = grandTotalClaimed.add(amount);
406             }
407         }
408     }
409     
410     function grandTotalAllocated() public view returns (uint256) {
411         return INITIAL_SUPPLY - AVAILABLE_TOTAL_SUPPLY;
412     }
413 }