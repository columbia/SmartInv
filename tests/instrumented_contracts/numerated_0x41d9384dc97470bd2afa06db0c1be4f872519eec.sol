1 pragma solidity ^0.4.13;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control
36  * functions, this simplifies the implementation of "user permissions".
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /**
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner.
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 }
70 
71 /**
72  * @title ERC20Basic
73  * @dev Simpler version of ERC20 interface
74  * @dev see https://github.com/ethereum/EIPs/issues/179
75  */
76 contract ERC20Basic {
77   uint256 public totalSupply;
78   function balanceOf(address who) constant returns (uint256);
79   function transfer(address to, uint256 value) returns (bool);
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 }
82 
83 /**
84  * @title ERC20 interface
85  * @dev see https://github.com/ethereum/EIPs/issues/20
86  */
87 contract ERC20 is ERC20Basic {
88   function allowance(address owner, address spender) constant returns (uint256);
89   function transferFrom(address from, address to, uint256 value) returns (bool);
90   function approve(address spender, uint256 value) returns (bool);
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 contract FollowCoin is Ownable, ERC20 {
95     using SafeMath for uint256;
96 
97     // Public variables of the token
98     string public name;
99     string public symbol;
100     uint8 public decimals;
101     
102     // This creates an array with all balances
103     mapping (address => uint256) public balances;
104     mapping (address => bool) public allowedAccount;
105     mapping (address => mapping (address => uint256)) public allowance;
106     mapping (address => bool) public isHolder;
107     address [] public holders;
108 
109     // This notifies clients about the amount burnt
110     event Burn(address indexed from, uint256 value);
111 
112     bool public contributorsLockdown = true;
113 
114     function disableLockDown() onlyOwner {
115       contributorsLockdown = false;
116     }
117 
118     modifier coinsLocked() {
119       require(!contributorsLockdown || msg.sender == owner || allowedAccount[msg.sender]);
120       _;
121     }
122 
123     /**
124      * Constructor function
125      *
126      * Initializes contract with initial supply tokens to the creator of the contract
127      */
128     function FollowCoin(
129         
130         address multiSigWallet,
131         uint256 initialSupply,
132         string tokenName,
133         uint8 decimalUnits,
134         string tokenSymbol
135         
136     ) {
137 
138         owner = multiSigWallet;
139         totalSupply = initialSupply;                        // Update total supply
140         name = tokenName;                                   // Set the name for display purposes
141         symbol = tokenSymbol;                               // Set the symbol for display purposes
142         decimals = decimalUnits;                            // Amount of decimals for display purposes
143         balances[owner] = totalSupply;                   // Give the creator all initial tokens
144 
145         if (isHolder[owner] != true) {
146             holders[holders.length++] = owner;
147             isHolder[owner] = true;
148         }
149     }
150 
151     /**
152      * Internal transfer, only can be called by this contract
153      */
154     function _transfer(address _from, address _to, uint _value) internal coinsLocked {
155         require(_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
156 
157         require(balanceOf(_from) >= _value);                // Check if the sender has enough
158         require(balanceOf(_to).add(_value) > balanceOf(_to)); // Check for overflows
159         balances[_from] = balanceOf(_from).sub(_value);                         // Subtract from the sender
160         balances[_to] = balanceOf(_to).add(_value);                           // Add the same to the recipient
161 
162         if (isHolder[_to] != true) {
163             holders[holders.length++] = _to;
164             isHolder[_to] = true;
165         }
166         Transfer(_from, _to, _value);
167     }
168     
169     /**
170      * Transfer tokens
171      *
172      * Send `_value` tokens to `_to` from your account
173      *
174      * @param _to The address of the recipient
175      * @param _value the amount to send
176      */
177 
178     function transfer(address _to, uint256 _value) public returns (bool)  {
179         require(_to != address(this));
180         _transfer(msg.sender, _to, _value);
181     }
182 
183     /**
184      * Transfer tokens from other address
185      *
186      * Send `_value` tokens to `_to` in behalf of `_from`
187      *
188      * @param _from The address of the sender
189      * @param _to The address of the recipient
190      * @param _value the amount to send
191      */
192     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
193         require(_value <= allowance[_from][msg.sender]);     // Check allowance
194         allowance[_from][msg.sender] -= _value;
195         _transfer(_from, _to, _value);
196         return true;
197     }
198 
199 
200     function balanceOf(address _owner) constant returns (uint256 balance) {
201         return balances[_owner];
202     }
203 
204     /**
205      * Set allowance for other address
206      *
207      * Allows `_spender` to spend no more than `_value` tokens in your behalf
208      *
209      * @param _spender The address authorized to spend
210      * @param _value the max amount they can spend
211      */
212     function approve(address _spender, uint256 _value) public
213         returns (bool success) {
214         allowance[msg.sender][_spender] = _value;
215         Approval(msg.sender, _spender, _value);
216         return true;
217     }
218 
219     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
220          return allowance[_owner][_spender];
221     }
222 
223 
224     function allowAccount(address _target, bool allow) onlyOwner returns (bool success) {
225 
226          allowedAccount[_target] = allow;
227          return true;
228     }
229 
230     function mint(uint256 mintedAmount) onlyOwner {
231         balances[msg.sender] = balanceOf(msg.sender).add(mintedAmount);
232         totalSupply  = totalSupply.add(mintedAmount);
233         Transfer(0, owner, mintedAmount);
234     }
235 
236     /**
237      * Destroy tokens
238      *
239      * Remove `_value` tokens from the system irreversibly
240      *
241      * @param _value the amount of money to burn
242      */
243     function burn(uint256 _value) onlyOwner returns (bool success) {
244         require(balanceOf(msg.sender) >= _value);   // Check if the sender has enough
245         balances[msg.sender] = balanceOf(msg.sender).sub(_value);            // Subtract from the sender
246         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
247         Burn(msg.sender, _value);
248         return true;
249     }
250 }
251 
252 
253 /*
254  * Haltable
255  *
256  * Abstract contract that allows children to implement an
257  * emergency stop mechanism. Differs from Pausable by requiring a state.
258  *
259  *
260  * Originally envisioned in FirstBlood ICO contract.
261  */
262  contract Haltable is Ownable {
263    bool public halted;
264 
265    modifier inNormalState {
266      assert(!halted);
267      _;
268    }
269 
270    modifier inEmergencyState {
271      assert(halted);
272      _;
273    }
274 
275    // called by the owner on emergency, triggers stopped state
276    function halt() external onlyOwner inNormalState {
277      halted = true;
278    }
279 
280    // called by the owner on end of emergency, returns to normal state
281    function unhalt() external onlyOwner inEmergencyState {
282      halted = false;
283    }
284 
285  }
286 
287 contract FollowCoinTokenSale is Haltable {
288     using SafeMath for uint256;
289 
290     address public beneficiary;
291     address public multisig;
292     uint public tokenLimitPerWallet;
293     uint public hardCap;
294     uint public amountRaised;
295     uint public totalTokens;
296     uint public tokensSold = 0;
297     uint public investorCount = 0;
298     uint public startTimestamp;
299     uint public deadline;
300     uint public tokensPerEther;
301     FollowCoin public tokenReward;
302     mapping(address => uint256) public balances;
303 
304     event FundTransfer(address backer, uint amount, bool isContribution);
305 
306     /**
307      * Constructor function
308      *
309      * Setup the owner
310      */
311     function FollowCoinTokenSale(
312         address multiSigWallet,
313         uint icoTokensLimitPerWallet,
314         uint icoHardCap,
315         uint icoStartTimestamp,
316         uint durationInDays,
317         uint icoTotalTokens,
318         uint icoTokensPerEther,
319         address addressOfTokenUsedAsReward
320         
321     ) {
322         multisig = multiSigWallet;
323         owner = multiSigWallet;
324         hardCap = icoHardCap;
325         deadline = icoStartTimestamp + durationInDays * 1 days;
326         startTimestamp = icoStartTimestamp;
327         totalTokens = icoTotalTokens;
328         tokenLimitPerWallet = icoTokensLimitPerWallet;
329         tokensPerEther = icoTokensPerEther;
330         tokenReward = FollowCoin(addressOfTokenUsedAsReward);
331         beneficiary = multisig;
332     }
333 
334     function changeMultisigWallet(address _multisig) onlyOwner {
335         require(_multisig != address(0));
336         multisig = _multisig;
337     }
338 
339     function changeTokenReward(address _token) onlyOwner {
340         require(_token != address(0));
341         tokenReward = FollowCoin(_token);
342         beneficiary = tokenReward.owner();
343     }
344 
345     function balanceOf(address _owner) constant returns (uint256 balance) {
346         return balances[_owner];
347     }
348 
349     /**
350      * Fallback function
351      *
352      * The function without name is the default function that is called whenever anyone sends funds to a contract
353      */
354     function () payable preSaleActive inNormalState {
355         buyTokens();
356     }
357 
358     function buyTokens() payable preSaleActive inNormalState {
359         require(msg.value > 0);
360        
361         uint amount = msg.value;
362         require(balanceOf(msg.sender).add(amount) <= tokenLimitPerWallet);
363 
364         uint tokens =  calculateTokenAmount(amount);
365         require(totalTokens >= tokens);
366         require(tokensSold.add(tokens) <= hardCap); // hardCap limit
367         
368         balances[msg.sender] = balances[msg.sender].add(amount);
369         amountRaised = amountRaised.add(amount);
370 
371         tokensSold = tokensSold.add(tokens);
372         totalTokens = totalTokens.sub(tokens);
373 
374         if (tokenReward.balanceOf(msg.sender) == 0) investorCount++;
375 
376         tokenReward.transfer(msg.sender, tokens);
377         multisig.transfer(amount);
378         FundTransfer(msg.sender, amount, true);
379     }
380 
381     modifier preSaleActive() {
382       require(now >= startTimestamp);
383       require(now < deadline);
384       _;
385     }
386 
387     function setSold(uint tokens) onlyOwner {
388       tokensSold = tokensSold.add(tokens);
389     }
390 
391 
392     function sendTokensBackToWallet() onlyOwner {
393       totalTokens = 0;
394       tokenReward.transfer(multisig, tokenReward.balanceOf(address(this)));
395     }
396 
397     function getTokenBalance(address _from) constant returns(uint) {
398       return tokenReward.balanceOf(_from);
399     }
400 
401     function calculateTokenAmount(uint256 amount) constant returns(uint256) {
402         return amount.mul(tokensPerEther);
403     }
404 }