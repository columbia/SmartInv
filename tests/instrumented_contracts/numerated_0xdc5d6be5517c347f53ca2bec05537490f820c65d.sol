1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations that are safe for uint256 against overflow and negative values
6  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
7  */
8 
9 library SafeMath {
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   function div(uint256 a, uint256 b) internal pure returns (uint256) {
20     // assert(b > 0); // Solidity automatically throws when dividing by 0
21     uint256 c = a / b;
22     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23     return c;
24   }
25 
26   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27     assert(b <= a);
28     return a - b;
29   }
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256) {
32     uint256 c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 } 
37 
38 
39 
40 /**
41  * @title Moderated
42  * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator
43  * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted 
44  *      boolean state is true
45  * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address
46  */
47 contract Moderated {
48     
49     address public moderator;
50     
51     bool public unrestricted;
52     
53     modifier onlyModerator {
54         require(msg.sender == moderator);
55         _;
56     }
57     
58     modifier ifUnrestricted {
59         require(unrestricted);
60         _;
61     }
62     
63     modifier onlyPayloadSize(uint256 numWords) {
64         assert(msg.data.length >= numWords * 32 + 4);
65         _;
66     }    
67     
68     function Moderated() public {
69         moderator = msg.sender;
70         unrestricted = true;
71     }
72     
73     function reassignModerator(address newModerator) public onlyModerator {
74         moderator = newModerator;
75     }
76     
77     function restrict() public onlyModerator {
78         unrestricted = false;
79     }
80     
81     function unrestrict() public onlyModerator {
82         unrestricted = true;
83     }  
84     
85     /// This method can be used to extract tokens mistakenly sent to this contract.
86     /// @param _token The address of the token contract that you want to recover
87     function extract(address _token) public returns (bool) {
88         require(_token != address(0x0));
89         Token token = Token(_token);
90         uint256 balance = token.balanceOf(this);
91         return token.transfer(moderator, balance);
92     }
93     
94     function isContract(address _addr) internal view returns (bool) {
95         uint256 size;
96         assembly { size := extcodesize(_addr) }
97         return (size > 0);
98     }  
99     
100     function getModerator() public view returns (address) {
101         return moderator;
102     }
103 } 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract Token { 
110 
111     function totalSupply() public view returns (uint256);
112     function balanceOf(address who) public view returns (uint256);
113     function transfer(address to, uint256 value) public returns (bool);
114     function transferFrom(address from, address to, uint256 value) public returns (bool);    
115     function approve(address spender, uint256 value) public returns (bool);
116     function allowance(address owner, address spender) public view returns (uint256);    
117     event Transfer(address indexed from, address indexed to, uint256 value);    
118     event Approval(address indexed owner, address indexed spender, uint256 value);    
119 
120 }
121 
122 
123 
124 
125 
126 
127 
128 // @dev Assign moderation of contract to CrowdSale
129 
130 contract LEON is Moderated {	
131 	using SafeMath for uint256;
132 
133 		string public name = "LEONS Coin";	
134 		string public symbol = "LEONS";			
135 		uint8 public decimals = 18;
136 		
137 		mapping(address => uint256) internal balances;
138 		mapping (address => mapping (address => uint256)) internal allowed;
139 
140 		uint256 internal totalSupply_;
141 
142 		// the maximum number of LEONS there may exist is capped at 200 million tokens
143 		uint256 public constant maximumTokenIssue = 200000000 * 10**18;
144 		
145 		event Approval(address indexed owner, address indexed spender, uint256 value); 
146 		event Transfer(address indexed from, address indexed to, uint256 value);		
147 
148 		/**
149 		* @dev total number of tokens in existence
150 		*/
151 		function totalSupply() public view returns (uint256) {
152 			return totalSupply_;
153 		}
154 
155 		/**
156 		* @dev transfer token for a specified address
157 		* @param _to The address to transfer to.
158 		* @param _value The amount to be transferred.
159 		*/
160 		function transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
161 		    return _transfer(msg.sender, _to, _value);
162 		}
163 
164 		/**
165 		* @dev Transfer tokens from one address to another
166 		* @param _from address The address which you want to send tokens from
167 		* @param _to address The address which you want to transfer to
168 		* @param _value uint256 the amount of tokens to be transferred
169 		*/
170 		function transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {
171 		    require(_value <= allowed[_from][msg.sender]);
172 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173 		    return _transfer(_from, _to, _value);
174 		}		
175 
176 		function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
177 			// Do not allow transfers to 0x0 or to this contract
178 			require(_to != address(0x0) && _to != address(this));
179 			// Do not allow transfer of value greater than sender's current balance
180 			require(_value <= balances[_from]);
181 			// Update balance of sending address
182 			balances[_from] = balances[_from].sub(_value);	
183 			// Update balance of receiving address
184 			balances[_to] = balances[_to].add(_value);		
185 			// An event to make the transfer easy to find on the blockchain
186 			Transfer(_from, _to, _value);
187 			return true;
188 		}
189 
190 		/**
191 		* @dev Gets the balance of the specified address.
192 		* @param _owner The address to query the the balance of.
193 		* @return An uint256 representing the amount owned by the passed address.
194 		*/
195 		function balanceOf(address _owner) public view returns (uint256) {
196 			return balances[_owner];
197 		}
198 
199 		/**
200 		* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201 		*
202 		* Beware that changing an allowance with this method brings the risk that someone may use both the old
203 		* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204 		* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206 		* @param _spender The address which will spend the funds.
207 		* @param _value The amount of tokens to be spent.
208 		*/
209 		function approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {
210 			// Can only approve when value has not already been set or is zero
211 			require(allowed[msg.sender][_spender] == 0 || _value == 0);
212 			allowed[msg.sender][_spender] = _value;
213 			Approval(msg.sender, _spender, _value);
214 			return true;
215 		}
216 
217 		/**
218 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
219 		* @param _owner address The address which owns the funds.
220 		* @param _spender address The address which will spend the funds.
221 		* @return A uint256 specifying the amount of tokens still available for the spender.
222 		*/
223 		function allowance(address _owner, address _spender) public view returns (uint256) {
224 			return allowed[_owner][_spender];
225 		}
226 
227 		/**
228 		* @dev Increase the amount of tokens that an owner allowed to a spender.
229 		*
230 		* approve should be called when allowed[_spender] == 0. To increment
231 		* allowed value is better to use this function to avoid 2 calls (and wait until
232 		* the first transaction is mined)
233 		* From MonolithDAO Token.sol
234 		* @param _spender The address which will spend the funds.
235 		* @param _addedValue The amount of tokens to increase the allowance by.
236 		*/
237 		function increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
238 			require(_addedValue > 0);
239 			allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
240 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241 			return true;
242 		}
243 
244 		/**
245 		* @dev Decrease the amount of tokens that an owner allowed to a spender.
246 		*
247 		* approve should be called when allowed[_spender] == 0. To decrement
248 		* allowed value is better to use this function to avoid 2 calls (and wait until
249 		* the first transaction is mined)
250 		* From MonolithDAO Token.sol
251 		* @param _spender The address which will spend the funds.
252 		* @param _subtractedValue The amount of tokens to decrease the allowance by.
253 		*/
254 		function decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
255 			uint256 oldValue = allowed[msg.sender][_spender];
256 			require(_subtractedValue > 0);
257 			if (_subtractedValue > oldValue) {
258 				allowed[msg.sender][_spender] = 0;
259 			} else {
260 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261 			}
262 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263 			return true;
264 		}
265 
266 		/**
267 		* @dev Function to mint tokens
268 		* @param _to The address that will receive the minted tokens.
269 		* @param _amount The amount of tokens to mint.
270 		* @return A boolean that indicates if the operation was successful.
271 		*/
272 		function generateTokens(address _to, uint _amount) public onlyModerator returns (bool) {
273 		    require(isContract(moderator));
274 			require(totalSupply_.add(_amount) <= maximumTokenIssue);
275 			totalSupply_ = totalSupply_.add(_amount);
276 			balances[_to] = balances[_to].add(_amount);
277 			Transfer(address(0x0), _to, _amount);
278 			return true;
279 		}
280 		/**
281 		* @dev fallback function - reverts transaction
282 		*/		
283     	function () external payable {
284     	    revert();
285     	}		
286 }
287 
288 
289 contract CrowdSale is Moderated {
290     using SafeMath for uint256;
291     
292     // LEON ERC20 smart contract
293     LEON public tokenContract;
294     
295     // crowdsale aims to sell at least 10 000 000 LEONS
296     uint256 public constant crowdsaleTarget = 10000000 * 10**18;
297     // running total of LEONS sold
298     uint256 public tokensSold;
299     // running total of ether raised
300     uint256 public weiRaised;
301 
302     // 1 Ether buys 13 000 LEONS
303     uint256 public constant etherToLEONRate = 13000;
304     // address to receive ether 
305     address public constant etherVault = 0xD8d97E3B5dB13891e082F00ED3fe9A0BC6B7eA01;    
306     // address to store bounty allocation
307     address public constant bountyVault = 0x96B083a253A90e321fb9F53645483745630be952;
308     // vesting contract to store team allocation
309     VestingVault public vestingContract;
310     // minimum of 1 ether to participate in crowdsale
311     uint256 constant purchaseMinimum = 1 ether;
312     // maximum of 65 ether 
313     uint256 constant purchaseMaximum = 65 ether;
314     
315     // boolean to indicate crowdsale finalized state    
316     bool public isFinalized;
317     // boolean to indicate crowdsale is actively accepting ether
318     bool public active;
319     
320     // mapping of whitelisted participants
321     mapping (address => bool) internal whitelist;   
322     
323     // finalization event
324     event Finalized(uint256 sales, uint256 raised);
325     // purchase event
326     event Purchased(address indexed purchaser, uint256 tokens, uint256 totsales, uint256 ethraised);
327     // whitelisting event
328     event Whitelisted(address indexed participant);
329     // revocation of whitelisting event
330     event Revoked(address indexed participant);
331     
332     // limits purchase to whitelisted participants only
333     modifier onlyWhitelist {
334         require(whitelist[msg.sender]);
335         _;
336     }
337     // purchase while crowdsale is live only   
338     modifier whileActive {
339         require(active);
340         _;
341     }
342     
343     // constructor
344     // @param _tokenAddr, the address of the deployed LEON token
345     function CrowdSale(address _tokenAddr) public {
346         tokenContract = LEON(_tokenAddr);
347     }   
348 
349     // fallback function invokes buyTokens method
350     function() external payable {
351         buyTokens(msg.sender);
352     }
353     
354     // forwards ether received to refund vault and generates tokens for purchaser
355     function buyTokens(address _purchaser) public payable ifUnrestricted onlyWhitelist whileActive {
356         // purchase value must be between 10 Ether and 65 Ether
357         require(msg.value > purchaseMinimum && msg.value < purchaseMaximum);
358         // transfer ether to the ether vault
359         etherVault.transfer(msg.value);
360         // increment wei raised total
361         weiRaised = weiRaised.add(msg.value);
362         // 1 ETHER buys 13 000 LEONS
363         uint256 _tokens = (msg.value).mul(etherToLEONRate); 
364         // mint tokens into purchaser address
365         require(tokenContract.generateTokens(_purchaser, _tokens));
366         // increment token sales total
367         tokensSold = tokensSold.add(_tokens);
368         // emit purchase event
369         Purchased(_purchaser, _tokens, tokensSold, weiRaised);
370     }
371     
372     function initialize() external onlyModerator {
373         // cannot have been finalized nor previously activated
374         require(!isFinalized && !active);
375         // check that this contract address is the moderator of the token contract
376         require(tokenContract.getModerator() == address(this));
377         // restrict trading
378         tokenContract.restrict();
379         // set crowd sale to active state
380         active = true;
381     }
382     
383     // close sale and allocate bounty and team tokens
384     function finalize() external onlyModerator {
385         // cannot have been finalized and must be in active state
386         require(!isFinalized && active);
387         // calculate team allocation (45% of total supply)
388         uint256 teamAllocation = tokensSold.mul(9000).div(10000);
389         // calculate bounty allocation (5% of total supply)
390         uint256 bountyAllocation = tokensSold.sub(teamAllocation);
391         // spawn new vesting contract, time of release in six months from present date
392         vestingContract = new VestingVault(address(tokenContract), etherVault, (block.timestamp + 26 weeks));
393         // generate team allocation
394         require(tokenContract.generateTokens(address(vestingContract), teamAllocation));
395         // generate bounty tokens
396         require(tokenContract.generateTokens(bountyVault, bountyAllocation));
397         // emit finalized event
398         Finalized(tokensSold, weiRaised);
399         // set state to finalized
400         isFinalized = true;
401         // deactivate crowdsale
402         active = false;
403     }
404     
405     // reassign LEON token to the subsequent ICO smart contract
406     function migrate(address _moderator) external onlyModerator {
407         // only after finalization
408         require(isFinalized);
409         // can only reassign moderator privelege to another contract
410         require(isContract(_moderator));
411         // reassign moderator role
412         tokenContract.reassignModerator(_moderator);    
413     }
414     
415     // add address to whitelist
416     function verifyParticipant(address participant) external onlyModerator {
417         // whitelist the address
418         whitelist[participant] = true;
419         // emit whitelisted event
420         Whitelisted(participant);
421     }
422     
423     // remove address from whitelist
424     function revokeParticipation(address participant) external onlyModerator {
425         // remove address from whitelist
426         whitelist[participant] = false;
427         // emit revoked event
428         Revoked(participant);
429     }
430     
431     // check if an address is whitelisted
432     function checkParticipantStatus(address participant) external view returns (bool whitelisted) {
433         return whitelist[participant];
434     }
435 }   
436 
437 // Vesting contract to lock team allocation
438 contract VestingVault {
439 
440     // reference to LEON smart contract
441     LEON public tokenContract; 
442     // address to which the tokens are released
443     address public beneficiary;
444     // time upon which tokens may be released
445     uint256 public releaseDate;
446     
447     // constructor takes LEON token address, etherVault address and current time + 6 months as parameters
448     function VestingVault(address _token, address _beneficiary, uint256 _time) public {
449         tokenContract = LEON(_token);
450         beneficiary = _beneficiary;
451         releaseDate = _time;
452     }
453     
454     // check token balance in this contract
455     function checkBalance() constant public returns (uint256 tokenBalance) {
456         return tokenContract.balanceOf(this);
457     }
458 
459     // function to release tokens to beneficiary address
460     function claim() external {
461         // can only be invoked by beneficiary
462         require(msg.sender == beneficiary);
463         // can only be invoked at maturity of vesting period
464         require(block.timestamp > releaseDate);
465         // compute current balance
466         uint256 balance = tokenContract.balanceOf(this);
467         // transfer tokens to beneficary
468         tokenContract.transfer(beneficiary, balance);
469     }
470     
471     // change the beneficary address
472     function changeBeneficiary(address _newBeneficiary) external {
473         // can only be changed by current beneficary
474         require(msg.sender == beneficiary);
475         // assign to new beneficiary
476         beneficiary = _newBeneficiary;
477     }
478     
479     /// This method can be used to extract tokens mistakenly sent to this contract.
480     /// @param _token The address of the token contract that you want to recover
481     function extract(address _token) public returns (bool) {
482         require(_token != address(0x0) || _token != address(tokenContract));
483         Token token = Token(_token);
484         uint256 balance = token.balanceOf(this);
485         return token.transfer(beneficiary, balance);
486     }   
487     
488     function() external payable {
489         revert();
490     }
491 }