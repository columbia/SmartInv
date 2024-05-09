1 /**
2 * The BIGFARM Coin contract bases on the ERC20 standard token contracts
3 * Author: Farm Suk Jai Social Enterprise
4 */
5 
6 pragma solidity ^0.4.25;
7 
8 
9 library SafeMath {
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         uint256 c = a * b;
12         require(a == 0 || c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         require(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract owned {
37     address public owner;
38 
39     constructor() public {
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
53 
54 contract Authorizable is owned {
55 
56     struct Authoriz{
57         uint index;
58         address account;
59     }
60     
61     mapping(address => bool) public authorized;
62     mapping(address => Authoriz) public authorizs;
63     address[] public authorizedAccts;
64 
65     modifier onlyAuthorized() {
66         if(authorizedAccts.length >0)
67         {
68             require(authorized[msg.sender] == true || owner == msg.sender);
69             _;
70         }else{
71             require(owner == msg.sender);
72             _;
73         }
74      
75     }
76 
77     function addAuthorized(address _toAdd) 
78         onlyOwner 
79         public 
80     {
81         require(_toAdd != 0);
82         require(!isAuthorizedAccount(_toAdd));
83         authorized[_toAdd] = true;
84         Authoriz storage authoriz = authorizs[_toAdd];
85         authoriz.account = _toAdd;
86         authoriz.index = authorizedAccts.push(_toAdd) -1;
87     }
88 
89     function removeAuthorized(address _toRemove) 
90         onlyOwner 
91         public 
92     {
93         require(_toRemove != 0);
94         require(_toRemove != msg.sender);
95         authorized[_toRemove] = false;
96     }
97     
98     function isAuthorizedAccount(address account) 
99         public 
100         constant 
101         returns(bool isIndeed) 
102     {
103         if(account == owner) return true;
104         if(authorizedAccts.length == 0) return false;
105         return (authorizedAccts[authorizs[account].index] == account);
106     }
107 
108 }
109 
110 
111 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
112 
113 contract TokenERC20 {
114     // Public variables of the token
115     string public name;
116     string public symbol;
117     uint8 public decimals = 18;
118     // 18 decimals is the strongly suggested default, avoid changing it
119     uint256 public totalSupply;
120 
121     // This creates an array with all balances
122     mapping (address => uint256) public balanceOf;
123     mapping (address => mapping (address => uint256)) public allowance;
124 
125     // This generates a public event on the blockchain that will notify clients
126     event Transfer(address indexed from, address indexed to, uint256 value);
127     
128     // This generates a public event on the blockchain that will notify clients
129     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
130 
131     // This notifies clients about the amount burnt
132     event Burn(address indexed from, uint256 value);
133 
134     /**
135      * Constrctor function
136      *
137      * Initializes contract with initial supply tokens to the creator of the contract
138      */
139     constructor(
140         uint256 initialSupply,
141         string tokenName,
142         string tokenSymbol
143     ) public {
144         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
145         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
146         name = tokenName;                                   // Set the name for display purposes
147         symbol = tokenSymbol;                               // Set the symbol for display purposes
148     }
149 
150     /**
151      * Internal transfer, only can be called by this contract
152      */
153     function _transfer(address _from, address _to, uint _value) internal {
154         // Prevent transfer to 0x0 address. Use burn() instead
155         require(_to != 0x0);
156         // Check if the sender has enough
157         require(balanceOf[_from] >= _value);
158         // Check for overflows
159         require(balanceOf[_to] + _value > balanceOf[_to]);
160         // Save this for an assertion in the future
161         uint previousBalances = balanceOf[_from] + balanceOf[_to];
162         // Subtract from the sender
163         balanceOf[_from] -= _value;
164         // Add the same to the recipient
165         balanceOf[_to] += _value;
166         emit Transfer(_from, _to, _value);
167         // Asserts are used to use static analysis to find bugs in your code. They should never fail
168         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
169     }
170 
171     /**
172      * Transfer tokens
173      *
174      * Send `_value` tokens to `_to` from your account
175      *
176      * @param _to The address of the recipient
177      * @param _value the amount to send
178      */
179     function transfer(address _to, uint256 _value) public returns (bool success) {
180         _transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184     /**
185      * Transfer tokens from other address
186      *
187      * Send `_value` tokens to `_to` in behalf of `_from`
188      *
189      * @param _from The address of the sender
190      * @param _to The address of the recipient
191      * @param _value the amount to send
192      */
193     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
194         require(_value <= allowance[_from][msg.sender]);     // Check allowance
195         allowance[_from][msg.sender] -= _value;
196         _transfer(_from, _to, _value);
197         return true;
198     }
199 
200     /**
201      * Set allowance for other address
202      *
203      * Allows `_spender` to spend no more than `_value` tokens in your behalf
204      *
205      * @param _spender The address authorized to spend
206      * @param _value the max amount they can spend
207      */
208     function approve(address _spender, uint256 _value) public
209         returns (bool success) {
210         allowance[msg.sender][_spender] = _value;
211         emit Approval(msg.sender, _spender, _value);
212         return true;
213     }
214 
215     /**
216      * Set allowance for other address and notify
217      *
218      * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
219      *
220      * @param _spender The address authorized to spend
221      * @param _value the max amount they can spend
222      * @param _extraData some extra information to send to the approved contract
223      */
224     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
225         public
226         returns (bool success) {
227         tokenRecipient spender = tokenRecipient(_spender);
228         if (approve(_spender, _value)) {
229             spender.receiveApproval(msg.sender, _value, this, _extraData);
230             return true;
231         }
232     }
233 
234     /**
235      * Destroy tokens
236      *
237      * Remove `_value` tokens from the system irreversibly
238      *
239      * @param _value the amount of money to burn
240      */
241     function burn(uint256 _value) public returns (bool success) {
242         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
243         balanceOf[msg.sender] -= _value;            // Subtract from the sender
244         totalSupply -= _value;                      // Updates totalSupply
245         emit Burn(msg.sender, _value);
246         return true;
247     }
248 
249     /**
250      * Destroy tokens from other account
251      *
252      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
253      *
254      * @param _from the address of the sender
255      * @param _value the amount of money to burn
256      */
257     function burnFrom(address _from, uint256 _value) public returns (bool success) {
258         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
259         require(_value <= allowance[_from][msg.sender]);    // Check allowance
260         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
261         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
262         totalSupply -= _value;                              // Update totalSupply
263         emit Burn(_from, _value);
264         return true;
265     }
266 }
267 
268 
269 /******************************************/
270 /* BIGFARM COIN STARTS HERE               */
271 /******************************************/
272 
273 contract BIGFARMCoin is Authorizable, TokenERC20 {
274 
275     using SafeMath for uint256;
276     
277     /// Maximum tokens to be allocated on the sale
278     uint256 public tokenSaleHardCap;
279     /// Base exchange rate is set to 1 ETH = BIF.
280     uint256 public baseRate;
281 
282    /// no tokens can be ever issued when this is set to "true"
283     bool public tokenSaleClosed = false;
284 
285     mapping (address => bool) public frozenAccount;
286 
287     /* This generates a public event on the blockchain that will notify clients */
288     event FrozenFunds(address target, bool frozen);
289 
290     modifier inProgress {
291         require(totalSupply < tokenSaleHardCap
292             && !tokenSaleClosed);
293         _;
294     }
295 
296     modifier beforeEnd {
297         require(!tokenSaleClosed);
298         _;
299     }
300 
301     /* Initializes contract with initial supply tokens to the creator of the contract */
302     constructor(
303         uint256 initialSupply,
304         string tokenName,
305         string tokenSymbol
306     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {
307         tokenSaleHardCap = 3376050000 * 10**uint256(decimals); // Default Crowsale Hard Cap amount with decimals
308         baseRate = 4000 * 10**uint256(decimals); // Default base rate BIF :1 eth amount with decimals
309     }
310 
311     /// @dev This default function allows token to be purchased by directly
312     /// sending ether to this smart contract.
313     function () public payable {
314        purchaseTokens(msg.sender);
315     }
316     
317     /// @dev Issue token based on Ether received.
318     /// @param _beneficiary Address that newly issued token will be sent to.
319     function purchaseTokens(address _beneficiary) public payable inProgress{
320         // only accept a minimum amount of ETH?
321         require(msg.value >= 0.01 ether);
322 
323         uint _tokens = computeTokenAmount(msg.value); 
324         doIssueTokens(_beneficiary, _tokens);
325         /// forward the raised funds to the contract creator
326         owner.transfer(address(this).balance);
327     }
328     
329     /* Internal transfer, only can be called by this contract */
330     function _transfer(address _from, address _to, uint _value) internal {
331         require (_to != 0x0);                               // Prevent transfer to 0x0 address. Use burn() instead
332         require (balanceOf[_from] >= _value);               // Check if the sender has enough
333         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
334         require(!frozenAccount[_from]);                     // Check if sender is frozen
335         require(!frozenAccount[_to]);                       // Check if recipient is frozen
336         balanceOf[_from] -= _value;                         // Subtract from the sender
337         balanceOf[_to] += _value;                           // Add the same to the recipient
338         emit Transfer(_from, _to, _value);
339     }
340 
341     /// @notice Create `mintedAmount` tokens and send it to `target`
342     /// @param target Address to receive the tokens
343     /// @param mintedAmount the amount of tokens it will receive
344     function mintToken(address target, uint256 mintedAmount) onlyAuthorized public {
345         balanceOf[target] += mintedAmount;
346         totalSupply += mintedAmount;
347         emit Transfer(0, this, mintedAmount);
348         emit Transfer(this, target, mintedAmount);
349     }
350 
351     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
352     /// @param target Address to be frozen
353     /// @param freeze either to freeze it or not
354     function freezeAccount(address target, bool freeze) onlyAuthorized public {
355         frozenAccount[target] = freeze;
356         emit FrozenFunds(target, freeze);
357     }
358 
359     /// @notice Allow users to buy tokens for `newRatePrice` eth 
360     /// @param newRate Price the users can sell to the contract
361     function setRatePrices(uint256 newRate) onlyAuthorized public {
362         baseRate = newRate;
363     }
364 
365     /// @notice Allow users to buy tokens for `newTokenSaleHardCap` BIF 
366     /// @param newTokenSaleHardCap Amount of BIF token sale hard cap
367     function setTokenSaleHardCap(uint256 newTokenSaleHardCap) onlyAuthorized public {
368         tokenSaleHardCap = newTokenSaleHardCap;
369     }
370 
371     function doIssueTokens(address _beneficiary, uint256 _tokens) internal {
372         require(_beneficiary != address(0));
373         balanceOf[_beneficiary] += _tokens;
374         totalSupply += _tokens;
375         emit Transfer(0, this, _tokens);
376         emit Transfer(this, _beneficiary, _tokens);
377     }
378 
379     /// @dev Compute the amount of BIF token that can be purchased.
380     /// @param ethAmount Amount of Ether in WEI to purchase BIF.
381     /// @return Amount of BIF token to purchase
382     function computeTokenAmount(uint256 ethAmount) internal view returns (uint256) {
383         uint256 tokens = ethAmount.mul(baseRate) / 10**uint256(decimals);
384         return tokens;
385     }
386 
387     /// @notice collect ether to owner account
388     function collect() external onlyAuthorized {
389         owner.transfer(address(this).balance);
390     }
391 
392     /// @notice getBalance ether
393     function getBalance() public view onlyAuthorized returns (uint) {
394         return address(this).balance;
395     }
396 
397     /// @dev Closes the sale, issues the team tokens and burns the unsold
398     function close() public onlyAuthorized beforeEnd {
399         tokenSaleClosed = true;
400         /// forward the raised funds to the contract creator
401         owner.transfer(address(this).balance);
402     }
403 
404     /// @dev Open the sale status
405     function openSale() public onlyAuthorized{
406         tokenSaleClosed = false;
407     }
408 
409 }