1 pragma solidity ^0.4.24;
2 
3 // File: contracts/interfaces/IOwned.sol
4 
5 /*
6     Owned Contract Interface
7 */
8 contract IOwned {
9     function transferOwnership(address _newOwner) public;
10     function acceptOwnership() public;
11     function transferOwnershipNow(address newContractOwner) public;
12 }
13 
14 // File: contracts/utility/Owned.sol
15 
16 /*
17     This is the "owned" utility contract used by bancor with one additional function - transferOwnershipNow()
18     
19     The original unmodified version can be found here:
20     https://github.com/bancorprotocol/contracts/commit/63480ca28534830f184d3c4bf799c1f90d113846
21     
22     Provides support and utilities for contract ownership
23 */
24 contract Owned is IOwned {
25     address public owner;
26     address public newOwner;
27 
28     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
29 
30     /**
31         @dev constructor
32     */
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     // allows execution by the owner only
38     modifier ownerOnly {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     /**
44         @dev allows transferring the contract ownership
45         the new owner still needs to accept the transfer
46         can only be called by the contract owner
47         @param _newOwner    new contract owner
48     */
49     function transferOwnership(address _newOwner) public ownerOnly {
50         require(_newOwner != owner);
51         newOwner = _newOwner;
52     }
53 
54     /**
55         @dev used by a new owner to accept an ownership transfer
56     */
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnerUpdate(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 
64     /**
65         @dev transfers the contract ownership without needing the new owner to accept ownership
66         @param newContractOwner    new contract owner
67     */
68     function transferOwnershipNow(address newContractOwner) ownerOnly public {
69         require(newContractOwner != owner);
70         emit OwnerUpdate(owner, newContractOwner);
71         owner = newContractOwner;
72     }
73 
74 }
75 
76 // File: contracts/utility/SafeMath.sol
77 
78 /**
79  * @title SafeMath
80  * @dev Math operations with safety checks that revert on error
81  * From https://github.com/OpenZeppelin/openzeppelin-solidity/commit/a2e710386933d3002062888b35aae8ac0401a7b3
82  */
83 library SafeMath {
84 
85     /**
86     * @dev Multiplies two numbers, reverts on overflow.
87     */
88     function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
89         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90         // benefit is lost if 'b' is also tested.
91         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92         if (_a == 0) {
93             return 0;
94         }
95 
96         uint256 c = _a * _b;
97         require(c / _a == _b);
98 
99         return c;
100     }
101 
102     /**
103     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
104     */
105     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
106         require(_b > 0); // Solidity only automatically asserts when dividing by 0
107         uint256 c = _a / _b;
108         // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
109 
110         return c;
111     }
112 
113     /**
114     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
115     */
116     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
117         require(_b <= _a);
118         uint256 c = _a - _b;
119 
120         return c;
121     }
122 
123     /**
124     * @dev Adds two numbers, reverts on overflow.
125     */
126     function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
127         uint256 c = _a + _b;
128         require(c >= _a);
129 
130         return c;
131     }
132 }
133 
134 // File: contracts/interfaces/IERC20.sol
135 
136 /*
137     Smart Token Interface
138 */
139 contract IERC20 {
140     function balanceOf(address tokenOwner) public constant returns (uint balance);
141     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
142     function transfer(address to, uint tokens) public returns (bool success);
143     function approve(address spender, uint tokens) public returns (bool success);
144     function transferFrom(address from, address to, uint tokens) public returns (bool success);
145 
146     event Transfer(address indexed from, address indexed to, uint tokens);
147     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
148 }
149 
150 // File: contracts/interfaces/ISmartToken.sol
151 
152 /**
153     @notice Smart Token Interface
154 */
155 contract ISmartToken is IOwned, IERC20 {
156     function disableTransfers(bool _disable) public;
157     function issue(address _to, uint256 _amount) public;
158     function destroy(address _from, uint256 _amount) public;
159 }
160 
161 // File: contracts/SmartToken.sol
162 
163 /*
164 
165 This contract implements the required functionality to be considered a Bancor smart token.
166 Additionally it has custom token sale functionality and the ability to withdraw tokens accidentally deposited
167 
168 // TODO abstract this into 3 contracts and inherit from them: 1) ERC20, 2) Smart Token, 3) Native specific functionality
169 */
170 contract SmartToken is Owned, IERC20, ISmartToken {
171 
172     /**
173         Smart Token Implementation
174     */
175 
176     bool public transfersEnabled = true;    // true if transfer/transferFrom are enabled, false if not
177     /// @notice Triggered when a smart token is deployed - the _token address is defined for forward compatibility, in case we want to trigger the event from a factory
178     event NewSmartToken(address _token);
179     /// @notice Triggered when the total supply is increased
180     event Issuance(uint256 _amount);
181     // @notice Triggered when the total supply is decreased
182     event Destruction(uint256 _amount);
183 
184     // @notice Verifies that the address is different than this contract address
185     modifier notThis(address _address) {
186         require(_address != address(this));
187         _;
188     }
189 
190     modifier transfersAllowed {
191         assert(transfersEnabled);
192         _;
193     }
194 
195     /// @notice Validates an address - currently only checks that it isn't null
196     modifier validAddress(address _address) {
197         require(_address != address(0));
198         _;
199     }
200 
201     /**
202         @dev disables/enables transfers
203         can only be called by the contract owner
204         @param _disable    true to disable transfers, false to enable them
205     */
206     function disableTransfers(bool _disable) public ownerOnly {
207         transfersEnabled = !_disable;
208     }
209 
210     /**
211         @dev increases the token supply and sends the new tokens to an account
212         can only be called by the contract owner
213         @param _to         account to receive the new amount
214         @param _amount     amount to increase the supply by
215     */
216     function issue(address _to, uint256 _amount)
217     public
218     ownerOnly
219     validAddress(_to)
220     notThis(_to)
221     {
222         totalSupply = SafeMath.add(totalSupply, _amount);
223         balances[_to] = SafeMath.add(balances[_to], _amount);
224         emit Issuance(_amount);
225         emit Transfer(this, _to, _amount);
226     }
227 
228     /**
229         @dev removes tokens from an account and decreases the token supply
230         can be called by the contract owner to destroy tokens from any account or by any holder to destroy tokens from his/her own account
231         @param _from       account to remove the amount from
232         @param _amount     amount to decrease the supply by
233     */
234     function destroy(address _from, uint256 _amount) public {
235         require(msg.sender == _from || msg.sender == owner); // validate input
236         balances[_from] = SafeMath.sub(balances[_from], _amount);
237         totalSupply = SafeMath.sub(totalSupply, _amount);
238 
239         emit Transfer(_from, this, _amount);
240         emit Destruction(_amount);
241     }
242 
243     /**
244         @notice ERC20 Implementation
245     */
246     uint256 public totalSupply;
247 
248     event Transfer(address indexed _from, address indexed _to, uint256 _value);
249     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
250 
251 
252     function transfer(address _to, uint256 _value) public transfersAllowed returns (bool success) {
253         if (balances[msg.sender] >= _value && _to != address(0)) {
254             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
255             balances[_to] = SafeMath.add(balances[_to], _value);
256             emit Transfer(msg.sender, _to, _value);
257             return true;
258         } else {return false; }
259     }
260 
261     function transferFrom(address _from, address _to, uint256 _value) public transfersAllowed returns (bool success) {
262         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _to != address(0)) {
263 
264             balances[_to] = SafeMath.add(balances[_to], _value);
265             balances[_from] = SafeMath.sub(balances[_from], _value);
266             allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
267             emit Transfer(_from, _to, _value);
268             return true;
269         } else { return false; }
270     }
271 
272     function balanceOf(address _owner) public constant returns (uint256 balance) {
273         return balances[_owner];
274     }
275 
276     function approve(address _spender, uint256 _value) public returns (bool success) {
277         allowed[msg.sender][_spender] = _value;
278         emit Approval(msg.sender, _spender, _value);
279         return true;
280     }
281 
282     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
283         return allowed[_owner][_spender];
284     }
285 
286     mapping (address => uint256) balances;
287     mapping (address => mapping (address => uint256)) allowed;
288 
289     string public name;
290     uint8 public decimals;
291     string public symbol;
292     string public version;
293 
294     constructor(string _name, uint _totalSupply, uint8 _decimals, string _symbol, string _version, address sender) public {
295         balances[sender] = _totalSupply;               // Give the creator all initial tokens
296         totalSupply = _totalSupply;                        // Update total supply
297         name = _name;                                   // Set the name for display purposes
298         decimals = _decimals;                            // Amount of decimals for display purposes
299         symbol = _symbol;                               // Set the symbol for display purposes
300         version = _version;
301 
302         emit NewSmartToken(address(this));
303     }
304 
305     /**
306         @notice Token Sale Implementation
307     */
308     uint public saleStartTime;
309     uint public saleEndTime;
310     uint public price;
311     uint public amountRemainingForSale;
312     bool public buyModeEth = true;
313     address public beneficiary;
314     address public payableTokenAddress;
315 
316     event TokenSaleInitialized(uint _saleStartTime, uint _saleEndTime, uint _price, uint _amountForSale, uint nowTime);
317     event TokensPurchased(address buyer, uint amount);
318 
319     /**
320         @dev increases the token supply and sends the new tokens to an account.  Similar to issue() but for use in token sale
321         @param _to         account to receive the new amount
322         @param _amount     amount to increase the supply by
323     */
324     function issuePurchase(address _to, uint256 _amount)
325     internal
326     validAddress(_to)
327     notThis(_to)
328     {
329         totalSupply = SafeMath.add(totalSupply, _amount);
330         balances[_to] = SafeMath.add(balances[_to], _amount);
331         emit Issuance(_amount);
332         emit Transfer(this, _to, _amount);
333     }
334 
335     /**
336         @notice Begins the token sale for this token instance
337         @param _saleStartTime Unix timestamp of the token sale start
338         @param _saleEndTime Unix timestamp of the token sale close
339         @param _price If sale initialized in ETH: price in Wei.
340                 If not, token purchases are enabled and this is the amount of tokens issued per tokens paid
341         @param _amountForSale Amount of tokens for sale
342         @param _beneficiary Recipient of the token sale proceeds
343     */
344     function initializeTokenSale(uint _saleStartTime, uint _saleEndTime, uint _price, uint _amountForSale, address _beneficiary) public ownerOnly {
345         // Check that the token sale has not yet been initialized
346         initializeSale(_saleStartTime, _saleEndTime, _price, _amountForSale, _beneficiary);
347     }
348     /**
349         @notice Begins the token sale for this token instance
350         @notice Uses the same signature as initializeTokenSale() with:
351         @param _tokenAddress The whitelisted token address to allow payments in
352     */
353     function initializeTokenSaleWithToken(uint _saleStartTime, uint _saleEndTime, uint _price, uint _amountForSale, address _beneficiary, address _tokenAddress) public ownerOnly {
354         buyModeEth = false;
355         payableTokenAddress = _tokenAddress;
356         initializeSale(_saleStartTime, _saleEndTime, _price, _amountForSale, _beneficiary);
357     }
358 
359     function initializeSale(uint _saleStartTime, uint _saleEndTime, uint _price, uint _amountForSale, address _beneficiary) internal {
360         // Check that the token sale has not yet been initialized
361         require(saleStartTime == 0);
362         saleStartTime = _saleStartTime;
363         saleEndTime = _saleEndTime;
364         price = _price;
365         amountRemainingForSale = _amountForSale;
366         beneficiary = _beneficiary;
367         emit TokenSaleInitialized(saleStartTime, saleEndTime, price, amountRemainingForSale, now);
368     }
369 
370     function updateStartTime(uint _newSaleStartTime) public ownerOnly {
371         saleStartTime = _newSaleStartTime;
372     }
373 
374     function updateEndTime(uint _newSaleEndTime) public ownerOnly {
375         require(_newSaleEndTime >= saleStartTime);
376         saleEndTime = _newSaleEndTime;
377     }
378 
379     function updateAmountRemainingForSale(uint _newAmountRemainingForSale) public ownerOnly {
380         amountRemainingForSale = _newAmountRemainingForSale;
381     }
382 
383     function updatePrice(uint _newPrice) public ownerOnly { 
384         price = _newPrice;
385     }
386 
387     /// @dev Allows owner to withdraw erc20 tokens that were accidentally sent to this contract
388     function withdrawToken(IERC20 _token, uint amount) public ownerOnly {
389         _token.transfer(msg.sender, amount);
390     }
391 
392     /**
393         @dev Allows token sale with parent token
394     */
395     function buyWithToken(IERC20 _token, uint amount) public payable {
396         require(_token == payableTokenAddress);
397         uint amountToBuy = SafeMath.mul(amount, price);
398         require(amountToBuy <= amountRemainingForSale);
399         require(now <= saleEndTime && now >= saleStartTime);
400         amountRemainingForSale = SafeMath.sub(amountRemainingForSale, amountToBuy);
401         require(_token.transferFrom(msg.sender, beneficiary, amount));
402         issuePurchase(msg.sender, amountToBuy);
403         emit TokensPurchased(msg.sender, amountToBuy);
404     }
405 
406     function() public payable {
407         require(buyModeEth == true);
408         uint amountToBuy = SafeMath.div( SafeMath.mul(msg.value, 1 ether), price);
409         require(amountToBuy <= amountRemainingForSale);
410         require(now <= saleEndTime && now >= saleStartTime);
411         amountRemainingForSale = SafeMath.sub(amountRemainingForSale, amountToBuy);
412         issuePurchase(msg.sender, amountToBuy);
413         beneficiary.transfer(msg.value);
414         emit TokensPurchased(msg.sender, amountToBuy);
415     }
416 }