1 pragma solidity  ^0.4.23;
2 
3 /**
4  *  SafeMath <https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol/>
5  *  Copyright (c) 2016 Smart Contract Solutions, Inc.
6  *  Released under the MIT License (MIT)
7  */
8 
9 /// @title Math operations with safety checks
10 library SafeMath {
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a * b;
13         assert(a == 0 || c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 
35     function max64(uint64 a, uint64 b) internal pure returns (uint64) {
36         return a >= b ? a : b;
37     }
38 
39     function min64(uint64 a, uint64 b) internal pure returns (uint64) {
40         return a < b ? a : b;
41     }
42 
43     function max256(uint256 a, uint256 b) internal pure returns (uint256) {
44         return a >= b ? a : b;
45     }
46 
47     function min256(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a < b ? a : b;
49     }
50 }
51 
52 /**
53  * @title Ownable
54  * @dev The Ownable contract has an owner address, and provides basic authorization control
55  * functions, this simplifies the implementation of "user permissions".
56  */
57 contract Ownable {
58     address public owner;
59 
60 
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68     constructor () public {
69         owner = msg.sender;
70     }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75     modifier onlyOwner() {
76         require(msg.sender == owner);
77         _;
78     }
79 
80   /**
81    * @dev Allows the current owner t o transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84     function transferOwnership(address newOwner) public onlyOwner {
85         require(newOwner != address(0));
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 
92 /// ERC Token Standard #20 Interface (https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
93 interface IERC20 {
94     function balanceOf(address _owner) public view returns (uint256 balance);
95     function transfer(address _to, uint256 _value) external returns (bool success);
96     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
97     function approve(address _spender, uint256 _value) external returns (bool success);
98     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
99     function totalSupply() external view returns (uint256);
100     event Transfer(address indexed _from, address indexed _to, uint256 _value);
101     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102 }
103 
104 interface ISecurityToken {
105 
106 
107     /**
108      * @dev Add a verified address to the Security Token whitelist
109      * @param _whitelistAddress Address attempting to join ST whitelist
110      * @return bool success
111      */
112     function addToWhitelist(address _whitelistAddress) public returns (bool success);
113 
114     /**
115      * @dev Add verified addresses to the Security Token whitelist
116      * @param _whitelistAddresses Array of addresses attempting to join ST whitelist
117      * @return bool success
118      */
119     function addToWhitelistMulti(address[] _whitelistAddresses) external returns (bool success);
120 
121     /**
122      * @dev Removes a previosly verified address to the Security Token blacklist
123      * @param _blacklistAddress Address being added to the blacklist
124      * @return bool success
125      */
126     function addToBlacklist(address _blacklistAddress) public returns (bool success);
127 
128     /**
129      * @dev Removes previously verified addresseses to the Security Token whitelist
130      * @param _blacklistAddresses Array of addresses attempting to join ST whitelist
131      * @return bool success
132      */
133     function addToBlacklistMulti(address[] _blacklistAddresses) external returns (bool success);
134 
135     /// Get token decimals
136     function decimals() view external returns (uint);
137 
138 
139     // @notice it will return status of white listing
140     // @return true if user is white listed and false if is not
141     function isWhiteListed(address _user) external view returns (bool);
142 }
143 
144 // The  Exchange token
145 contract SecurityToken is IERC20, Ownable, ISecurityToken {
146 
147     using SafeMath for uint;
148     // Public variables of the token
149     string public name;
150     string public symbol;
151     uint public decimals; // How many decimals to show.
152     string public version;
153     uint public totalSupply;
154     uint public tokenPrice;
155     bool public exchangeEnabled;    
156     bool public codeExportEnabled;
157     address public commissionAddress;           // address to deposit commissions
158     uint public deploymentCost;                 // cost of deployment with exchange feature
159     uint public tokenOnlyDeploymentCost;        // cost of deployment with basic ERC20 feature
160     uint public exchangeEnableCost;             // cost of upgrading existing ERC20 to exchange feature
161     uint public codeExportCost;                 // cost of exporting the code
162     string public securityISIN;
163 
164 
165     // Security token shareholders
166     struct Shareholder {                        // Structure that contains the data of the shareholders        
167         bool allowed;                           // allowed - whether the shareholder is allowed to transfer or recieve the security token       
168         uint receivedAmt;
169         uint releasedAmt;
170         uint vestingDuration;
171         uint vestingCliff;
172         uint vestingStart;
173     }
174 
175     mapping(address => uint) public balances;
176     mapping(address => mapping(address => uint)) public allowed;
177     mapping(address => Shareholder) public shareholders; // Mapping that holds the data of the shareholder corresponding to investor address
178 
179 
180     modifier onlyWhitelisted(address _to) {
181         require(shareholders[_to].allowed && shareholders[msg.sender].allowed);
182         _;
183     }
184 
185 
186     modifier onlyVested(address _from) {
187 
188         require(availableAmount(_from) > 0);
189         _;
190     }
191 
192     // The Token constructor     
193     constructor (
194         uint _initialSupply,
195         string _tokenName,
196         string _tokenSymbol,
197         uint _decimalUnits,        
198         string _version,                       
199         uint _tokenPrice,
200         string _securityISIN
201                         ) public payable
202     {
203 
204         totalSupply = _initialSupply * (10**_decimalUnits);                                             
205         name = _tokenName;          // Set the name for display purposes
206         symbol = _tokenSymbol;      // Set the symbol for display purposes
207         decimals = _decimalUnits;   // Amount of decimals for display purposes
208         version = _version;         // Version of token
209         tokenPrice = _tokenPrice;   // Token price in Wei     
210         securityISIN = _securityISIN;// ISIN security registration number        
211             
212         balances[owner] = totalSupply;    
213 
214         deploymentCost = 25e17;             
215         tokenOnlyDeploymentCost = 15e17;
216         exchangeEnableCost = 15e17;
217         codeExportCost = 1e19;   
218 
219         codeExportEnabled = true;
220         exchangeEnabled = true;  
221             
222         commissionAddress = 0x80eFc17CcDC8fE6A625cc4eD1fdaf71fD81A2C99;                                   
223         commissionAddress.transfer(msg.value);       
224         addToWhitelist(owner);  
225 
226     }
227 
228     event LogTransferSold(address indexed to, uint value);
229     event LogTokenExchangeEnabled(address indexed caller, uint exchangeCost);
230     event LogTokenExportEnabled(address indexed caller, uint enableCost);
231     event LogNewWhitelistedAddress( address indexed shareholder);
232     event LogNewBlacklistedAddress(address indexed shareholder);
233     event logVestingAllocation(address indexed shareholder, uint amount, uint duration, uint cliff, uint start);
234     event logISIN(string isin);
235 
236 
237 
238     function updateISIN(string _securityISIN) external onlyOwner() {
239 
240         bytes memory tempISIN = bytes(_securityISIN);
241 
242         require(tempISIN.length > 0);  // ensure that ISIN has been passed
243         securityISIN = _securityISIN;// ISIN security registration number  
244         emit logISIN(_securityISIN);  
245     }
246 
247     function allocateVestedTokens(address _to, uint _value, uint _duration, uint _cliff, uint _vestingStart ) 
248                                   external onlyWhitelisted(_to) onlyOwner() returns (bool) 
249     {
250 
251         require(_to != address(0));        
252         balances[msg.sender] = balances[msg.sender].sub(_value);
253         balances[_to] = balances[_to].add(_value);        
254         if (shareholders[_to].receivedAmt == 0) {
255             shareholders[_to].vestingDuration = _duration;
256             shareholders[_to].vestingCliff = _cliff;
257             shareholders[_to].vestingStart = _vestingStart;
258         }
259         shareholders[_to].receivedAmt = shareholders[_to].receivedAmt.add(_value);
260         emit Transfer(msg.sender, _to, _value);
261         
262         emit logVestingAllocation(_to, _value, _duration, _cliff, _vestingStart);
263         return true;
264     }
265 
266     function availableAmount(address _from) public view returns (uint256) {                
267         
268         if (block.timestamp < shareholders[_from].vestingCliff) {            
269             return balanceOf(_from).sub(shareholders[_from].receivedAmt);
270         } else if (block.timestamp >= shareholders[_from].vestingStart.add(shareholders[_from].vestingDuration)) {
271             return balanceOf(_from);
272         } else {
273             uint totalVestedBalance = shareholders[_from].receivedAmt;
274             uint totalAvailableVestedBalance = totalVestedBalance.mul(block.timestamp.sub(shareholders[_from].vestingStart)).div(shareholders[_from].vestingDuration);
275             uint lockedBalance = totalVestedBalance - totalAvailableVestedBalance;
276             return balanceOf(_from).sub(lockedBalance);
277         }
278     }
279 
280     // @noice To be called by owner of the contract to enable exchange functionality
281     // @param _tokenPrice {uint} cost of token in ETH
282     // @return true {bool} if successful
283     function enableExchange(uint _tokenPrice) public payable {
284         
285         require(!exchangeEnabled);
286         require(exchangeEnableCost == msg.value);
287         exchangeEnabled = true;
288         tokenPrice = _tokenPrice;
289         commissionAddress.transfer(msg.value);
290         emit LogTokenExchangeEnabled(msg.sender, _tokenPrice);                          
291     }
292 
293     // @notice to enable code export functionality
294     function enableCodeExport() public payable {   
295         
296         require(!codeExportEnabled);
297         require(codeExportCost == msg.value);     
298         codeExportEnabled = true;
299         commissionAddress.transfer(msg.value);  
300         emit LogTokenExportEnabled(msg.sender, msg.value);        
301     }
302 
303     // @notice It will send tokens to sender based on the token price    
304     function swapTokens() public payable onlyWhitelisted(msg.sender) {     
305 
306         require(exchangeEnabled);   
307         uint tokensToSend;
308         tokensToSend = (msg.value * (10**decimals)) / tokenPrice; 
309         require(balances[owner] >= tokensToSend);
310         balances[msg.sender] = balances[msg.sender].add(tokensToSend);
311         balances[owner] = balances[owner].sub(tokensToSend);
312         owner.transfer(msg.value);
313         emit Transfer(owner, msg.sender, tokensToSend);
314         emit LogTransferSold(msg.sender, tokensToSend);       
315     }
316 
317     // @notice will be able to mint tokens in the future
318     // @param _target {address} address to which new tokens will be assigned
319     // @parm _mintedAmount {uint256} amouont of tokens to mint
320     function mintToken(address _target, uint256 _mintedAmount) public onlyWhitelisted(_target) onlyOwner() {        
321         
322         balances[_target] += _mintedAmount;
323         totalSupply += _mintedAmount;
324         emit Transfer(0, _target, _mintedAmount);       
325     }
326   
327     // @notice transfer tokens to given address
328     // @param _to {address} address or recipient
329     // @param _value {uint} amount to transfer
330     // @return  {bool} true if successful
331     function transfer(address _to, uint _value) external onlyVested(_to) onlyWhitelisted(_to)  returns(bool) {
332 
333         require(_to != address(0));
334         require(balances[msg.sender] >= _value);
335         balances[msg.sender] = balances[msg.sender].sub(_value);
336         balances[_to] = balances[_to].add(_value);
337         emit Transfer(msg.sender, _to, _value);
338         return true;
339     }
340 
341     // @notice transfer tokens from given address to another address
342     // @param _from {address} from whom tokens are transferred
343     // @param _to {address} to whom tokens are transferred
344     // @param _value {uint} amount of tokens to transfer
345     // @return  {bool} true if successful
346     function transferFrom(address _from, address _to, uint256 _value) 
347                           external onlyVested(_to)  onlyWhitelisted(_to) returns(bool success) {
348 
349         require(_to != address(0));
350         require(balances[_from] >= _value); // Check if the sender has enough
351         require(_value <= allowed[_from][msg.sender]); // Check if allowed is greater or equal
352 
353         balances[_from] = balances[_from].sub(_value); // Subtract from the sender
354         balances[_to] = balances[_to].add(_value); // Add the same to the recipient
355         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); // adjust allowed
356         emit Transfer(_from, _to, _value);
357         return true;
358     }
359 
360     // @notice to query balance of account
361     // @return _owner {address} address of user to query balance
362     function balanceOf(address _owner) public view returns(uint balance) {
363         return balances[_owner];
364     }
365 
366     /**
367     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
368     *
369     * Beware that changing an allowance with this method brings the risk that someone may use both the old
370     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
371     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
372     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
373     * @param _spender The address which will spend the funds.
374     * @param _value The amount of tokens to be spent.
375     */
376     function approve(address _spender, uint _value) external returns(bool) {
377         allowed[msg.sender][_spender] = _value;
378         emit Approval(msg.sender, _spender, _value);
379         return true;
380     }
381 
382     // @notice to query of allowance of one user to the other
383     // @param _owner {address} of the owner of the account
384     // @param _spender {address} of the spender of the account
385     // @return remaining {uint} amount of remaining allowance
386     function allowance(address _owner, address _spender) external view returns(uint remaining) {
387         return allowed[_owner][_spender];
388     }
389 
390     /**
391     * approve should be called when allowed[_spender] == 0. To increment
392     * allowed value is better to use this function to avoid 2 calls (and wait until
393     * the first transaction is mined)
394     * From MonolithDAO Token.sol
395     */
396     function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
397         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
398         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
399         return true;
400     }
401 
402     function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
403         uint oldValue = allowed[msg.sender][_spender];
404         if (_subtractedValue > oldValue) {
405             allowed[msg.sender][_spender] = 0;
406         } else {
407             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
408         }
409         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
410         return true;
411     }
412 
413      /**
414      * @dev Add a verified address to the Security Token whitelist
415      * The Issuer can add an address to the whitelist by themselves by
416      * creating their own KYC provider and using it to verify the accounts
417      * they want to add to the whitelist.
418      * @param _whitelistAddress Address attempting to join ST whitelist
419      * @return bool success
420      */
421     function addToWhitelist(address _whitelistAddress) onlyOwner public returns (bool success) {       
422         shareholders[_whitelistAddress].allowed = true;
423         emit LogNewWhitelistedAddress(_whitelistAddress);
424         return true;
425     }
426 
427     /**
428      * @dev Add verified addresses to the Security Token whitelist
429      * @param _whitelistAddresses Array of addresses attempting to join ST whitelist
430      * @return bool success
431      */
432     function addToWhitelistMulti(address[] _whitelistAddresses) onlyOwner external returns (bool success) {
433         for (uint256 i = 0; i < _whitelistAddresses.length; i++) {
434             addToWhitelist(_whitelistAddresses[i]);
435         }
436         return true;
437     }
438 
439     /**
440      * @dev Add a verified address to the Security Token blacklist
441      * @param _blacklistAddress Address being added to the blacklist
442      * @return bool success
443      */
444     function addToBlacklist(address _blacklistAddress) onlyOwner public returns (bool success) {
445         require(shareholders[_blacklistAddress].allowed);
446         shareholders[_blacklistAddress].allowed = false;
447         emit LogNewBlacklistedAddress(_blacklistAddress);
448         return true;
449     }
450 
451     /**
452      * @dev Removes previously verified addresseses to the Security Token whitelist
453      * @param _blacklistAddresses Array of addresses attempting to join ST whitelist
454      * @return bool success
455      */
456     function addToBlacklistMulti(address[] _blacklistAddresses) onlyOwner external returns (bool success) {
457         for (uint256 i = 0; i < _blacklistAddresses.length; i++) {
458             addToBlacklist(_blacklistAddresses[i]);
459         }
460         return true;
461     }
462 
463     // @notice it will return status of white listing
464     // @return true if user is white listed and false if is not
465     function isWhiteListed(address _user) external view returns (bool) {
466 
467         return shareholders[_user].allowed;
468     }
469 
470     function totalSupply() external view returns (uint256) {
471         return totalSupply;
472     }
473 
474     function decimals() external view returns (uint) {
475         return decimals;
476     }
477 
478 }