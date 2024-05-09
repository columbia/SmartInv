1 pragma solidity ^0.4.11;
2 
3 contract Owned {
4 
5     address public owner;
6     address public newOwner;
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Owned() {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) onlyOwner {
19         newOwner = _newOwner;
20     }
21 
22     function acceptOwnership() {
23         require(msg.sender == newOwner);
24         OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26     }
27     
28 }
29 
30 contract Token {
31     uint256 public totalSupply;
32     function balanceOf(address _owner) constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value) returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
35     function approve(address _spender, uint256 _value) returns (bool success);
36     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
37     event Transfer(address indexed _from, address indexed _to, uint256 _value);
38     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
39 }
40 
41 library SafeMath {
42   function mul(uint256 a, uint256 b) internal returns (uint256) {
43     uint256 c = a * b;
44     assert(a == 0 || c / a == b);
45     return c;
46   }
47 
48   function div(uint256 a, uint256 b) internal returns (uint256) {
49     // assert(b > 0); // Solidity automatically throws when dividing by 0
50     uint256 c = a / b;
51     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
52     return c;
53   }
54 
55   function sub(uint256 a, uint256 b) internal returns (uint256) {
56     assert(b <= a);
57     return a - b;
58   }
59 
60   function add(uint256 a, uint256 b) internal returns (uint256) {
61     uint256 c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 
66   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a >= b ? a : b;
68   }
69 
70   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
71     return a < b ? a : b;
72   }
73 
74   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a >= b ? a : b;
76   }
77 
78   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
79     return a < b ? a : b;
80   }
81 
82 }
83 
84 contract SalesAgentInterface {
85      /**** Properties ***********/
86     // Main contract token address
87     address tokenContractAddress;
88     // Contributions per address
89     mapping (address => uint256) public contributions;    
90     // Total ETH contributed     
91     uint256 public contributedTotal;                       
92     /// @dev Only allow access from the main token contract
93     modifier onlyTokenContract() {_;}
94     /*** Events ****************/
95     event Contribute(address _agent, address _sender, uint256 _value);
96     event FinaliseSale(address _agent, address _sender, uint256 _value);
97     event Refund(address _agent, address _sender, uint256 _value);
98     event ClaimTokens(address _agent, address _sender, uint256 _value);  
99     /*** Methods ****************/
100     /// @dev The address used for the depositAddress must checkin with the contract to verify it can interact with this contract, must happen or it won't accept funds
101     function getDepositAddressVerify() public;
102     /// @dev Get the contribution total of ETH from a contributor
103     /// @param _owner The owners address
104     function getContributionOf(address _owner) constant returns (uint256 balance);
105 }
106 
107 /*  ERC 20 token */
108 contract StandardToken is Token {
109 
110     function transfer(address _to, uint256 _value) returns (bool success) {
111       if (balances[msg.sender] >= _value && _value > 0) {
112         balances[msg.sender] -= _value;
113         balances[_to] += _value;
114         Transfer(msg.sender, _to, _value);
115         return true;
116       } else {
117         return false;
118       }
119     }
120 
121     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
122       if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
123         balances[_to] += _value;
124         balances[_from] -= _value;
125         allowed[_from][msg.sender] -= _value;
126         Transfer(_from, _to, _value);
127         return true;
128       } else {
129         return false;
130       }
131     }
132 
133     function balanceOf(address _owner) constant returns (uint256 balance) {
134         return balances[_owner];
135     }
136 
137     function approve(address _spender, uint256 _value) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144       return allowed[_owner][_spender];
145     }
146 
147     mapping (address => uint256) balances;
148     mapping (address => mapping (address => uint256)) allowed;
149 }
150 
151 /// @title The main Rocket Pool Token (RPL) contract
152 /// @author David Rugendyke - http://www.rocketpool.net
153 
154 /*****************************************************************
155 *   This is the main Rocket Pool Token (RPL) contract. It features
156 *   Smart Agent compatibility. The Sale Agent is a new type of 
157 *   contract that can authorise the minting of tokens on behalf of
158 *   the traditional ERC20 token contract. This allows you to 
159 *   distribute your ICO tokens through multiple Sale Agents, 
160 *   at various times, of various token quantities and of varying
161 *   fund targets. Once you’ve written a new Sale Agent contract,
162 *   you can register him with the main ERC20 token contract, 
163 *   he’s then permitted to sell it’s tokens on your behalf using
164 *   guidelines such as the amount of tokens he’s allowed to sell, 
165 *   the maximum ether he’s allowed to raise, the start block and
166 *   end blocks he’s allowed to sell between and more.
167 /****************************************************************/
168 
169 contract RocketPoolToken is StandardToken, Owned {
170 
171      /**** Properties ***********/
172 
173     string public name = "Rocket Pool";
174     string public symbol = "RPL";
175     string public version = "1.0";
176     // Set our token units
177     uint8 public constant decimals = 18;
178     uint256 public exponent = 10**uint256(decimals);
179     uint256 public totalSupply = 0;                             // The total of tokens currently minted by sales agent contracts    
180     uint256 public totalSupplyCap = 18 * (10**6) * exponent;    // 18 Million tokens
181 
182 
183     /**** Libs *****************/
184     
185     using SafeMath for uint;                           
186     
187     
188     /*** Sale Addresses *********/
189        
190     mapping (address => SalesAgent) private salesAgents;   // Our contract addresses of our sales contracts 
191     address[] private salesAgentsAddresses;                // Keep an array of all our sales agent addresses for iteration
192 
193     /*** Structs ***************/
194              
195     struct SalesAgent {                     // These are contract addresses that are authorised to mint tokens
196         address saleContractAddress;        // Address of the contract
197         bytes32 saleContractType;           // Type of the contract ie. presale, crowdsale 
198         uint256 targetEthMax;               // The max amount of ether the agent is allowed raise
199         uint256 targetEthMin;               // The min amount of ether to raise to consider this contracts sales a success
200         uint256 tokensLimit;                // The maximum amount of tokens this sale contract is allowed to distribute
201         uint256 tokensMinted;               // The current amount of tokens minted by this agent
202         uint256 minDeposit;                 // The minimum deposit amount allowed
203         uint256 maxDeposit;                 // The maximum deposit amount allowed
204         uint256 startBlock;                 // The start block when allowed to mint tokens
205         uint256 endBlock;                   // The end block when to finish minting tokens
206         address depositAddress;             // The address that receives the ether for that sale contract
207         bool depositAddressCheckedIn;       // The address that receives the ether for that sale contract must check in with its sale contract to verify its a valid address that can interact
208         bool finalised;                     // Has this sales contract been completed and the ether sent to the deposit address?
209         bool exists;                        // Check to see if the mapping exists
210     }
211 
212     /*** Events ****************/
213 
214     event MintToken(address _agent, address _address, uint256 _value);
215     event SaleFinalised(address _agent, address _address, uint256 _value);
216   
217     /*** Tests *****************/
218 
219     event FlagUint(uint256 flag);
220     event FlagAddress(address flag);
221 
222     
223     /*** Modifiers *************/
224 
225     /// @dev Only allow access from the latest version of a sales contract
226     modifier isSalesContract(address _sender) {
227         // Is this an authorised sale contract?
228         assert(salesAgents[_sender].exists == true);
229         _;
230     }
231 
232     
233     /**** Methods ***********/
234 
235     /// @dev RPL Token Init
236     function RocketPoolToken() {}
237 
238 
239     // @dev General validation for a sales agent contract receiving a contribution, additional validation can be done in the sale contract if required
240     // @param _value The value of the contribution in wei
241     // @return A boolean that indicates if the operation was successful.
242     function validateContribution(uint256 _value) isSalesContract(msg.sender) returns (bool) {
243         // Get an instance of the sale agent contract
244         SalesAgentInterface saleAgent = SalesAgentInterface(msg.sender);
245         // Did they send anything from a proper address?
246         assert(_value > 0);  
247         // Check the depositAddress has been verified by the account holder
248         assert(salesAgents[msg.sender].depositAddressCheckedIn == true);
249         // Check if we're ok to receive contributions, have we started?
250         assert(block.number > salesAgents[msg.sender].startBlock);       
251         // Already ended? Or if the end block is 0, it's an open ended sale until finalised by the depositAddress
252         assert(block.number < salesAgents[msg.sender].endBlock || salesAgents[msg.sender].endBlock == 0); 
253         // Is it above the min deposit amount?
254         assert(_value >= salesAgents[msg.sender].minDeposit); 
255         // Is it below the max deposit allowed?
256         assert(_value <= salesAgents[msg.sender].maxDeposit); 
257         // No contributions if the sale contract has finalised
258         assert(salesAgents[msg.sender].finalised == false);      
259         // Does this deposit put it over the max target ether for the sale contract?
260         assert(saleAgent.contributedTotal().add(_value) <= salesAgents[msg.sender].targetEthMax);       
261         // All good
262         return true;
263     }
264 
265 
266     // @dev General validation for a sales agent contract that requires the user claim the tokens after the sale has finished
267     // @param _sender The address sent the request
268     // @return A boolean that indicates if the operation was successful.
269     function validateClaimTokens(address _sender) isSalesContract(msg.sender) returns (bool) {
270         // Get an instance of the sale agent contract
271         SalesAgentInterface saleAgent = SalesAgentInterface(msg.sender);
272         // Must have previously contributed
273         assert(saleAgent.getContributionOf(_sender) > 0); 
274         // Sale contract completed
275         assert(block.number > salesAgents[msg.sender].endBlock);  
276         // All good
277         return true;
278     }
279     
280 
281     // @dev Mint the Rocket Pool Tokens (RPL)
282     // @param _to The address that will receive the minted tokens.
283     // @param _amount The amount of tokens to mint.
284     // @return A boolean that indicates if the operation was successful.
285     function mint(address _to, uint _amount) isSalesContract(msg.sender) returns (bool) {
286         // Check if we're ok to mint new tokens, have we started?
287         // We dont check for the end block as some sale agents mint tokens during the sale, and some after its finished (proportional sales)
288         assert(block.number > salesAgents[msg.sender].startBlock);   
289         // Check the depositAddress has been verified by the designated account holder that will receive the funds from that agent
290         assert(salesAgents[msg.sender].depositAddressCheckedIn == true);
291         // No minting if the sale contract has finalised
292         assert(salesAgents[msg.sender].finalised == false);
293         // Check we don't exceed the assigned tokens of the sale agent
294         assert(salesAgents[msg.sender].tokensLimit >= salesAgents[msg.sender].tokensMinted.add(_amount));
295         // Verify ok balances and values
296         assert(_amount > 0);
297          // Check we don't exceed the supply limit
298         assert(totalSupply.add(_amount) <= totalSupplyCap);
299          // Ok all good, automatically checks for overflow with safeMath
300         balances[_to] = balances[_to].add(_amount);
301         // Add to the total minted for that agent, automatically checks for overflow with safeMath
302         salesAgents[msg.sender].tokensMinted = salesAgents[msg.sender].tokensMinted.add(_amount);
303         // Add to the overall total minted, automatically checks for overflow with safeMath
304         totalSupply = totalSupply.add(_amount);
305         // Fire the event
306         MintToken(msg.sender, _to, _amount);
307         // Fire the transfer event
308         Transfer(0x0, _to, _amount); 
309         // Completed
310         return true; 
311     }
312 
313     /// @dev Returns the amount of tokens that can still be minted
314     function getRemainingTokens() public constant returns(uint256) {
315         return totalSupplyCap.sub(totalSupply);
316     }
317     
318     /// @dev Set the address of a new crowdsale/presale contract agent if needed, usefull for upgrading
319     /// @param _saleAddress The address of the new token sale contract
320     /// @param _saleContractType Type of the contract ie. presale, crowdsale, quarterly
321     /// @param _targetEthMin The min amount of ether to raise to consider this contracts sales a success
322     /// @param _targetEthMax The max amount of ether the agent is allowed raise
323     /// @param _tokensLimit The maximum amount of tokens this sale contract is allowed to distribute
324     /// @param _minDeposit The minimum deposit amount allowed
325     /// @param _maxDeposit The maximum deposit amount allowed
326     /// @param _startBlock The start block when allowed to mint tokens
327     /// @param _endBlock The end block when to finish minting tokens
328     /// @param _depositAddress The address that receives the ether for that sale contract
329     function setSaleAgentContract(
330         address _saleAddress, 
331          string _saleContractType, 
332         uint256 _targetEthMin, 
333         uint256 _targetEthMax, 
334         uint256 _tokensLimit, 
335         uint256 _minDeposit,
336         uint256 _maxDeposit,
337         uint256 _startBlock, 
338         uint256 _endBlock, 
339         address _depositAddress
340     ) 
341     // Only the owner can register a new sale agent
342     public onlyOwner  
343     {
344         // Valid addresses?
345         assert(_saleAddress != 0x0 && _depositAddress != 0x0);  
346         // Must have some available tokens
347         assert(_tokensLimit > 0 && _tokensLimit <= totalSupplyCap);
348         // Make sure the min deposit is less than or equal to the max
349         assert(_minDeposit <= _maxDeposit);
350         // Add the new sales contract
351         salesAgents[_saleAddress] = SalesAgent({
352             saleContractAddress: _saleAddress,
353             saleContractType: sha3(_saleContractType),
354             targetEthMin: _targetEthMin,
355             targetEthMax: _targetEthMax,
356             tokensLimit: _tokensLimit,
357             tokensMinted: 0,
358             minDeposit: _minDeposit,
359             maxDeposit: _maxDeposit,
360             startBlock: _startBlock,
361             endBlock: _endBlock,
362             depositAddress: _depositAddress,
363             depositAddressCheckedIn: false,
364             finalised: false,
365             exists: true                      
366         });
367         // Store our agent address so we can iterate over it if needed
368         salesAgentsAddresses.push(_saleAddress);
369     }
370 
371 
372     /// @dev Sets the contract sale agent process as completed, that sales agent is now retired
373     function setSaleContractFinalised(address _sender) isSalesContract(msg.sender) public returns(bool) {
374         // Get an instance of the sale agent contract
375         SalesAgentInterface saleAgent = SalesAgentInterface(msg.sender);
376         // Finalise the crowdsale funds
377         assert(!salesAgents[msg.sender].finalised);                       
378         // The address that will receive this contracts deposit, should match the original senders
379         assert(salesAgents[msg.sender].depositAddress == _sender);            
380         // If the end block is 0, it means an open ended crowdsale, once it's finalised, the end block is set to the current one
381         if (salesAgents[msg.sender].endBlock == 0) {
382             salesAgents[msg.sender].endBlock = block.number;
383         }
384         // Not yet finished?
385         assert(block.number >= salesAgents[msg.sender].endBlock);         
386         // Not enough raised?
387         assert(saleAgent.contributedTotal() >= salesAgents[msg.sender].targetEthMin);
388         // We're done now
389         salesAgents[msg.sender].finalised = true;
390         // Fire the event
391         SaleFinalised(msg.sender, _sender, salesAgents[msg.sender].tokensMinted);
392         // All good
393         return true;
394     }
395 
396 
397     /// @dev Verifies if the current address matches the depositAddress
398     /// @param _verifyAddress The address to verify it matches the depositAddress given for the sales agent
399     function setSaleContractDepositAddressVerified(address _verifyAddress) isSalesContract(msg.sender) public {
400         // Check its verified
401         assert(salesAgents[msg.sender].depositAddress == _verifyAddress && _verifyAddress != 0x0);
402         // Ok set it now
403         salesAgents[msg.sender].depositAddressCheckedIn = true;
404     }
405 
406     /// @dev Returns true if this sales contract has finalised
407     /// @param _salesAgentAddress The address of the token sale agent contract
408     function getSaleContractIsFinalised(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(bool) {
409         return salesAgents[_salesAgentAddress].finalised;
410     }
411 
412     /// @dev Returns the min target amount of ether the contract wants to raise
413     /// @param _salesAgentAddress The address of the token sale agent contract
414     function getSaleContractTargetEtherMin(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
415         return salesAgents[_salesAgentAddress].targetEthMin;
416     }
417 
418     /// @dev Returns the max target amount of ether the contract can raise
419     /// @param _salesAgentAddress The address of the token sale agent contract
420     function getSaleContractTargetEtherMax(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
421         return salesAgents[_salesAgentAddress].targetEthMax;
422     }
423 
424     /// @dev Returns the min deposit amount of ether
425     /// @param _salesAgentAddress The address of the token sale agent contract
426     function getSaleContractDepositEtherMin(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
427         return salesAgents[_salesAgentAddress].minDeposit;
428     }
429 
430     /// @dev Returns the max deposit amount of ether
431     /// @param _salesAgentAddress The address of the token sale agent contract
432     function getSaleContractDepositEtherMax(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
433         return salesAgents[_salesAgentAddress].maxDeposit;
434     }
435 
436     /// @dev Returns the address where the sale contracts ether will be deposited
437     /// @param _salesAgentAddress The address of the token sale agent contract
438     function getSaleContractDepositAddress(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(address) {
439         return salesAgents[_salesAgentAddress].depositAddress;
440     }
441 
442     /// @dev Returns the true if the sale agents deposit address has been verified
443     /// @param _salesAgentAddress The address of the token sale agent contract
444     function getSaleContractDepositAddressVerified(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(bool) {
445         return salesAgents[_salesAgentAddress].depositAddressCheckedIn;
446     }
447 
448     /// @dev Returns the start block for the sale agent
449     /// @param _salesAgentAddress The address of the token sale agent contract
450     function getSaleContractStartBlock(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
451         return salesAgents[_salesAgentAddress].startBlock;
452     }
453 
454     /// @dev Returns the start block for the sale agent
455     /// @param _salesAgentAddress The address of the token sale agent contract
456     function getSaleContractEndBlock(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
457         return salesAgents[_salesAgentAddress].endBlock;
458     }
459 
460     /// @dev Returns the max tokens for the sale agent
461     /// @param _salesAgentAddress The address of the token sale agent contract
462     function getSaleContractTokensLimit(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
463         return salesAgents[_salesAgentAddress].tokensLimit;
464     }
465 
466     /// @dev Returns the token total currently minted by the sale agent
467     /// @param _salesAgentAddress The address of the token sale agent contract
468     function getSaleContractTokensMinted(address _salesAgentAddress) constant isSalesContract(_salesAgentAddress) public returns(uint256) {
469         return salesAgents[_salesAgentAddress].tokensMinted;
470     }
471 
472     
473 }