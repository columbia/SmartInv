1 pragma solidity ^0.4.22;
2 
3 contract Ownable {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
8 
9     function Ownable() public {
10         owner = msg.sender;
11         newOwner = address(0);
12     }
13 
14     modifier onlyOwner() {
15         require(msg.sender == owner);
16         _;
17     }
18 
19     function transferOwnership(address _newOwner) public onlyOwner {
20         require(address(0) != _newOwner);
21         newOwner = _newOwner;
22     }
23 
24     function acceptOwnership() public {
25         require(msg.sender == newOwner);
26         emit OwnershipTransferred(owner, msg.sender);
27         owner = msg.sender;
28         newOwner = address(0);
29     }
30 }
31 /** @author OVCode Switzerland AG */
32 
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 contract SafeMath {
38     /**
39     * @dev constructor
40     */
41     function SafeMath() public {
42     }
43 
44     function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a * b;
46         assert(a == 0 || c / a == b);
47         return c;
48     }
49 
50     function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a / b;
52         return c;
53     }
54 
55     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
56         assert(a >= b);
57         return a - b;
58     }
59 
60     function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 /** @author OVCode Switzerland AG */
68 
69 contract TokenERC20 is SafeMath {
70     // Public variables of the token
71     string public name;
72     string public symbol;
73     
74     // 18 decimals is the strongly suggested default, avoid changing it
75     uint8 public decimals = 18;
76     uint256 public totalSupply;
77 
78     // This creates an array with all balances
79     mapping (address => uint256) public balanceOf;
80     mapping (address => mapping (address => uint256)) public allowance;
81 
82     // This generates a public event on the blockchain that will notify clients
83     event Transfer(address indexed from, address indexed to, uint256 value);
84     event ReceiveApproval(address _from, uint256 _value, address _token);
85 
86     // This notifies clients about the amount burnt
87     event Burn(address indexed from, uint256 value);
88 
89     /**
90     * For the ERC20 short address attack.
91     */
92     modifier onlyPayloadSize(uint size) {
93         assert(msg.data.length >= size + 4);
94         _;
95     }
96 
97     /**
98     * @dev constructor
99     */
100     function TokenERC20() public {
101     }
102 
103     /**
104      * Internal transfer, only can be called by this contract
105      */
106     function _transfer(address _from, address _to, uint _value) internal {
107         // Prevent transfer to 0x0 address. Use burn() instead
108         require(_to != 0x0);
109         // Check if the sender has enough
110         require(balanceOf[_from] >= _value);
111         // Check for overflows
112         require(safeAdd(balanceOf[_to],_value) > balanceOf[_to]);
113         // Save this for an assertion in the future
114         uint previousBalances = safeAdd(balanceOf[_from],balanceOf[_to]);
115         // Subtract from the sender
116         balanceOf[_from] = safeSub(balanceOf[_from],_value);
117         // Add the same to the recipient
118         balanceOf[_to] = safeAdd(balanceOf[_to],_value);
119         emit Transfer(_from, _to, _value);
120         // Asserts are used to use static analysis to find bugs in your code. They should never fail
121         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
122     }
123 
124     /**
125      * Transfer tokens
126      *
127      * Send `_value` tokens to `_to` from your account
128      *
129      * @param _to The address of the recipient
130      * @param _value the amount to send
131      */
132     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public {
133         _transfer(msg.sender, _to, _value);
134     }
135 
136     /**
137      * Transfer tokens from other address
138      *
139      * Send `_value` tokens to `_to` in behalf of `_from`
140      *
141      * @param _from The address of the sender
142      * @param _to The address of the recipient
143      * @param _value the amount to send
144      */
145     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(32 * 3) public returns (bool success) {
146         require(_value <= allowance[_from][msg.sender]);     // Check allowance
147         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender],_value);
148         _transfer(_from, _to, _value);
149         return true;
150     }
151 
152     /**
153      * Set allowance for other address
154      *
155      * Allows `_spender` to spend no more than `_value` tokens in your behalf
156      *
157      * @param _spender The address authorized to spend
158      * @param _value the max amount they can spend
159      */
160     function approve(address _spender, uint256 _value) onlyPayloadSize(32 * 2) public returns (bool success) {
161         allowance[msg.sender][_spender] = _value;
162         emit ReceiveApproval(msg.sender, _value, this);
163         return true;
164     }
165 
166     /**
167      * Destroy tokens
168      *
169      * Remove `_value` tokens from the system irreversibly
170      *
171      * @param _value the amount of money to burn
172      */
173     function burn(uint256 _value) public returns (bool success) {
174         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
175         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender],_value);  // Subtract from the sender
176         totalSupply = safeSub(totalSupply,_value);                      // Updates totalSupply
177         emit Burn(msg.sender, _value);
178         return true;
179     }
180 
181     /**
182      * Destroy tokens from other account
183      *
184      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
185      *
186      * @param _from the address of the sender
187      * @param _value the amount of money to burn
188      */
189     function burnFrom(address _from, uint256 _value) onlyPayloadSize(32 * 2) public returns (bool success) {
190         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
191         require(_value <= allowance[_from][msg.sender]);    // Check allowance
192         balanceOf[_from] = safeSub(balanceOf[_from],_value);                         // Subtract from the targeted balance
193         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender],_value);             // Subtract from the sender's allowance
194         totalSupply = safeSub(totalSupply,_value);                              // Update totalSupply
195         emit Burn(_from, _value);
196         return true;
197     }
198 }
199 
200 /** @author OVCode Switzerland AG */
201 
202 
203 contract OVC is Ownable, TokenERC20 {
204 
205     uint256 public ovcPerEther = 0;
206     uint256 public minOVC;
207     uint256 public constant ICO_START_TIME = 1526891400; // 05.21.2018 08:30:00 UTC
208     uint256 public constant ICO_END_TIME = 1532131199; // 07.20.2018 11:59:59 UTC
209 
210     uint256 public totalOVCSold = 0;
211     
212     OVCLockAllocation public lockedAllocation;
213     mapping (address => bool) public frozenAccount;
214   
215     /* This generates a public event on the blockchain that will notify clients */
216     event FrozenFunds(address target, bool frozen);
217     event ChangeOvcEtherConversion(address owner, uint256 amount);
218     /* Initializes contract, Total Supply (83,875,000 OVC), name (OVCODE) and symbol (OVC), Min OVC Per Wallet
219     // Assign the 30,000,000 of the total supply to the presale account
220     // Assign the 10,500,000 of the total supply to the First ICO account
221     // Assign the 11,000,000 of the total supply to the Second ICO account
222     // Assign the 1,075,000 of the total supply to the bonus account
223     // Assign the 2,450,000 of the total supply to the bounty account
224     // Assign the 14,850,000 of the total supply to the first investor account
225     // Assign the 4,000,000 of the total supply to the second investor account
226     // Lock-in the 10,000,000 of the total supply to `OVCLockAllocation` contract within 36 months(unlock 1/3 every 12 months)
227     */
228     function OVC() public {
229 
230         totalSupply = safeMul(83875000,(10 ** uint256(decimals) ));  // Update total supply(83,875,000) with the decimal amount
231         name = "OVCODE";  // Set the name for display purposes
232         symbol = "OVC";   // Set the symbol for display purposes
233         
234         // 30,000,000 tokens for Presale 
235         balanceOf[msg.sender] = safeMul(30000000,(10 ** uint256(decimals))); 
236 
237         // 11,000,000 ICO tokens for direct buy on the smart contract
238         /* @notice Transfer this token to OVC Smart Contract Address 
239           to enable the puchaser to buy directly on the contract */
240         address icoAccount1 = 0xe5aB5D1Da8817bFB4b0Af44eFDcCC850a47E477a;
241         balanceOf[icoAccount1] = safeMul(11000000,(10 ** uint256(decimals))); 
242 
243         // 10,500,000 ICO tokens for cash and btc purchaser
244         /* @notice This account will be used to send token 
245             to the purchaser that used BTC or CASH */
246         address icoAccount2 = 0xfD382a7478ce3ddCd6a03F6c1848F31659753388;
247         balanceOf[icoAccount2] = safeMul(10500000,(10 ** uint256(decimals))); 
248 
249         // 1,075,000 tokens for bonus, referrals and discounts
250         address bonusAccount = 0xAde1Cf49c41919658132FF003C409fBcb2909472;
251         balanceOf[bonusAccount] = safeMul(1075000,(10 ** uint256(decimals)));
252         
253         // 2,450,000 tokens for bounty
254         address bountyAccount = 0xb690acb524BFBD968A91D614654aEEC5041597E0;
255         balanceOf[bountyAccount] = safeMul(2450000,(10 ** uint256(decimals)));
256 
257         // 14,850,000 & 4,000,000 for our investors
258         address investor1 = 0x17dC8dD84bD8DbAC168209360EDc1E8539D965DA;
259         balanceOf[investor1] = safeMul(14850000,(10 ** uint256(decimals)));
260         address investor2 = 0x5B2213eeFc9b7939D863085f7F2D9D1f3a771D5f;
261         balanceOf[investor2] = safeMul(4000000,(10 ** uint256(decimals)));
262         
263         // Founder and Developer 10,000,000 of the total Supply / Lock-in within 36 months(unlock 1/3 every 12 months)
264         uint256 totalAllocation = safeMul(10000000,(10 ** uint256(decimals)));
265         
266         // Initilize the `OVCLockAllocation` contract with the totalAllocation and 3 allocated wallets
267         address firstAllocatedWallet = 0xD0427222388145a1A14F5FC4a376e8412C39c6a4;
268         address secondAllocatedWallet = 0xe141c480274376A4eB499ACEeD84c47b5FDF4B39;
269         address thirdAllocatedWallet = 0xD46811aBe15a53dd76b309E3e1f8f9C4550D3918;
270         lockedAllocation = new OVCLockAllocation(totalAllocation,firstAllocatedWallet,secondAllocatedWallet,thirdAllocatedWallet);
271         // Assign the 10,000,000 lock token to the `OVCLockAllocation` contract address
272         balanceOf[lockedAllocation] = totalAllocation;
273 
274         // @notice Minimum token per wallet 10 OVC
275         minOVC = safeMul(10,(10 ** uint256(decimals)));
276     }
277     
278     /* @notice Allow user to send ether directly to the contract address */
279     function () public payable {
280         buyTokens();
281     }
282     
283     /* @notice private function for buy token, enable the purchaser to 
284     // send Ether directly to the contract address */
285     function buyTokens() private {
286         require(now > ICO_START_TIME );
287         require(now < ICO_END_TIME );
288 
289         uint256 _value = safeMul(msg.value,ovcPerEther);
290         uint256 futureBalance = safeAdd(balanceOf[msg.sender],_value);
291 
292         require(futureBalance >= minOVC);
293         owner.transfer(address(this).balance);
294 
295         _transfer(this, msg.sender, _value);
296         totalOVCSold = safeAdd(totalOVCSold,_value);
297     }
298     
299      /* @notice Change the current amount of OVC token per Ether */
300     function changeOVCPerEther(uint256 amount) onlyPayloadSize(1 * 32) onlyOwner public {
301         require(amount >= 0);
302         ovcPerEther = amount;
303         emit ChangeOvcEtherConversion(msg.sender, amount);
304     }
305 
306     /* @notice Transfer all unsold token to the contract owner */
307     function transferUnsoldToken() onlyOwner public {
308         require(now > ICO_END_TIME );
309         require (balanceOf[this] > 0); 
310         uint256 unsoldToken = balanceOf[this]; 
311         _transfer(this, msg.sender, unsoldToken);
312     }
313 
314     /* Internal transfer, only can be called by this contract */
315     function _transfer(address _from, address _to, uint _value) internal {
316         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
317         require (balanceOf[_from] >= _value);               // Check if the sender has enough balance
318         require (safeAdd(balanceOf[_to],_value) > balanceOf[_to]); // Check for overflows
319         require(!frozenAccount[_from]);                     // Check if sender is frozen
320         require(!frozenAccount[_to]);                       // Check if recipient is frozen
321         balanceOf[_from] = safeSub(balanceOf[_from],_value);// Subtract from the sender
322         balanceOf[_to] = safeAdd(balanceOf[_to],_value);// Add the same to the recipient
323         emit Transfer(_from, _to, _value);
324     }
325 
326     /// @notice Create `mintedAmount` tokens and send it to `target`
327     /// @param target Address to receive the tokens
328     /// @param mintedAmount the amount of tokens it will receive
329     function mintToken(address target, uint256 mintedAmount) onlyPayloadSize(32 * 2) onlyOwner public {
330         balanceOf[target] = safeAdd(balanceOf[target],mintedAmount);
331         totalSupply = safeAdd(totalSupply,mintedAmount);
332         emit Transfer(0, this, mintedAmount);
333         emit Transfer(this, target, mintedAmount);
334     }
335 
336     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
337     /// @param target Address to be frozen
338     /// @param freeze either to freeze it or not
339     function freezeAccount(address target, bool freeze) onlyOwner public {
340         frozenAccount[target] = freeze;
341         emit FrozenFunds(target, freeze);
342     }
343 }
344 
345 /** @author OVCode Switzerland AG */
346 
347 
348 contract OVCLockAllocation is SafeMath {
349 
350     uint256 public totalLockAllocated;
351     OVC public ovc;
352     /**
353     * For the ERC20 short address attack.
354     */
355     modifier onlyPayloadSize(uint size) {
356         assert(msg.data.length >= size + 4);
357         _;
358     }
359 
360     struct Allocations {
361         uint256 allocated;
362         uint256 unlockedAt;
363         bool released;
364     }
365 
366     mapping (address => Allocations) public allocations;
367 
368     /* Initialize the total allocated OVC token */
369     // Initialize the 3 wallet address, allocated amount and date unlock
370     // @param `totalAllocated` Total allocated token from  `OVC` contract
371     // @param `firstAllocatedWallet` wallet address that allowed to unlock the first 1/3 allocated token
372     // @param `secondAllocatedWallet` wallet address that allowed to unlock the second 1/3 allocated token
373     // @param `thirdAllocatedWallet` wallet address that allowed to unlock the third 1/3 allocated token
374     function OVCLockAllocation(uint256 totalAllocated, address firstAllocatedWallet, address secondAllocatedWallet, address thirdAllocatedWallet) public {
375         ovc = OVC(msg.sender);
376         totalLockAllocated = totalAllocated;
377         Allocations memory allocation;
378 
379         // Initialize the first allocation wallet address and date unlockedAt
380         // Unlock 1/3 or 33% of the token allocated after 12 months
381         allocation.allocated = safeDiv(safeMul(totalLockAllocated, 33),100);
382         allocation.unlockedAt = safeAdd(now,(safeMul(12,30 days)));
383         allocation.released = false;
384         allocations[firstAllocatedWallet] = allocation;
385         
386 
387         // Initialize the second allocation wallet address and date unlockedAt
388         // Unlock 1/3 or 33% of the token allocated after 24 months
389         allocation.allocated = safeDiv(safeMul(totalLockAllocated, 33),100);
390         allocation.unlockedAt = safeAdd(now,(safeMul(24,30 days)));
391         allocation.released = false;
392         allocations[secondAllocatedWallet] = allocation;
393 
394         // Initialize the third allocation wallet address and date unlockedAt
395         // Unlock last or 34% of the token allocated after 36 months
396         allocation.allocated = safeDiv(safeMul(totalLockAllocated, 34),100);
397         allocation.unlockedAt = safeAdd(now,(safeMul(36,30 days))); 
398         allocation.released = false;
399         allocations[thirdAllocatedWallet] = allocation;
400     }
401     
402         /**
403     * @notice called by allocated address to release the token
404     */
405     function releaseTokens() public {
406         Allocations memory allocation;
407         allocation = allocations[msg.sender];
408         require(allocation.released == false);
409         require(allocation.allocated > 0);
410         require(allocation.unlockedAt > 0);
411         require(now >= allocation.unlockedAt);
412             
413         uint256 allocated = allocation.allocated;
414         ovc.transfer(msg.sender, allocated);
415 
416         allocation.allocated = 0;
417         allocation.unlockedAt = 0;
418         allocation.released = true;
419         allocations[msg.sender] = allocation;
420     }
421 } 
422 
423 /** @author OVCode Switzerland AG */