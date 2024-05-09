1 /**
2  * @title SafeMath
3  * @dev Math operations that are safe for uint256 against overflow and negative values
4  * @dev https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
5  */
6 
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title Moderated
38  * @dev restricts execution of 'onlyModerator' modified functions to the contract moderator
39  * @dev restricts execution of 'ifUnrestricted' modified functions to when unrestricted
40  *      boolean state is true
41  * @dev allows for the extraction of ether or other ERC20 tokens mistakenly sent to this address
42  */
43 contract Moderated {
44 
45     address public moderator;
46 
47     bool public unrestricted;
48 
49     modifier onlyModerator {
50         require(msg.sender == moderator);
51         _;
52     }
53 
54     modifier ifUnrestricted {
55         require(unrestricted);
56         _;
57     }
58 
59     modifier onlyPayloadSize(uint numWords) {
60         assert(msg.data.length >= numWords * 32 + 4);
61         _;
62     }
63 
64     function Moderated() public {
65         moderator = msg.sender;
66         unrestricted = true;
67     }
68 
69     function reassignModerator(address newModerator) public onlyModerator {
70         moderator = newModerator;
71     }
72 
73     function restrict() public onlyModerator {
74         unrestricted = false;
75     }
76 
77     function unrestrict() public onlyModerator {
78         unrestricted = true;
79     }
80 
81     /// This method can be used to extract tokens mistakenly sent to this contract.
82     /// @param _token The address of the token contract that you want to recover
83     function extract(address _token) public returns (bool) {
84         require(_token != address(0x0));
85         Token token = Token(_token);
86         uint256 balance = token.balanceOf(this);
87         return token.transfer(moderator, balance);
88     }
89 
90     function isContract(address _addr) internal view returns (bool) {
91         uint256 size;
92         assembly { size := extcodesize(_addr) }
93         return (size > 0);
94     }
95 }
96 
97 /**
98  * @title ERC20 interface
99  * @dev see https://github.com/ethereum/EIPs/issues/20
100  */
101 contract Token {
102 
103     function totalSupply() public view returns (uint256);
104     function balanceOf(address who) public view returns (uint256);
105     function transfer(address to, uint256 value) public returns (bool);
106     function transferFrom(address from, address to, uint256 value) public returns (bool);
107     function approve(address spender, uint256 value) public returns (bool);
108     function allowance(address owner, address spender) public view returns (uint256);
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(address indexed owner, address indexed spender, uint256 value);
111 
112 }
113 
114 // @dev Assign moderation of contract to CrowdSale
115 
116 contract Touch is Moderated {
117 	using SafeMath for uint256;
118 
119 		string public name = "Touch. Token";
120 		string public symbol = "TST";
121 		uint8 public decimals = 18;
122 
123         uint256 public maximumTokenIssue = 1000000000 * 10**18;
124 
125 		mapping(address => uint256) internal balances;
126 		mapping (address => mapping (address => uint256)) internal allowed;
127 
128 		uint256 internal totalSupply_;
129 
130 		event Approval(address indexed owner, address indexed spender, uint256 value);
131 		event Transfer(address indexed from, address indexed to, uint256 value);
132 
133 		/**
134 		* @dev total number of tokens in existence
135 		*/
136 		function totalSupply() public view returns (uint256) {
137 			return totalSupply_;
138 		}
139 
140 		/**
141 		* @dev transfer token for a specified address
142 		* @param _to The address to transfer to.
143 		* @param _value The amount to be transferred.
144 		*/
145 		function transfer(address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
146 		    return _transfer(msg.sender, _to, _value);
147 		}
148 
149 		/**
150 		* @dev Transfer tokens from one address to another
151 		* @param _from address The address which you want to send tokens from
152 		* @param _to address The address which you want to transfer to
153 		* @param _value uint256 the amount of tokens to be transferred
154 		*/
155 		function transferFrom(address _from, address _to, uint256 _value) public ifUnrestricted onlyPayloadSize(3) returns (bool) {
156 		    require(_value <= allowed[_from][msg.sender]);
157 		    allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
158 		    return _transfer(_from, _to, _value);
159 		}
160 
161 		function _transfer(address _from, address _to, uint256 _value) internal returns (bool) {
162 			// Do not allow transfers to 0x0 or to this contract
163 			require(_to != address(0x0) && _to != address(this));
164 			// Do not allow transfer of value greater than sender's current balance
165 			require(_value <= balances[_from]);
166 			// Update balance of sending address
167 			balances[_from] = balances[_from].sub(_value);
168 			// Update balance of receiving address
169 			balances[_to] = balances[_to].add(_value);
170 			// An event to make the transfer easy to find on the blockchain
171 			Transfer(_from, _to, _value);
172 			return true;
173 		}
174 
175 		/**
176 		* @dev Gets the balance of the specified address.
177 		* @param _owner The address to query the the balance of.
178 		* @return An uint256 representing the amount owned by the passed address.
179 		*/
180 		function balanceOf(address _owner) public view returns (uint256) {
181 			return balances[_owner];
182 		}
183 
184 		/**
185 		* @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
186 		*
187 		* Beware that changing an allowance with this method brings the risk that someone may use both the old
188 		* and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189 		* race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190 		* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191 		* @param _spender The address which will spend the funds.
192 		* @param _value The amount of tokens to be spent.
193 		*/
194 		function approve(address _spender, uint256 _value) public ifUnrestricted onlyPayloadSize(2) returns (bool sucess) {
195 			// Can only approve when value has not already been set or is zero
196 			require(allowed[msg.sender][_spender] == 0 || _value == 0);
197 			allowed[msg.sender][_spender] = _value;
198 			Approval(msg.sender, _spender, _value);
199 			return true;
200 		}
201 
202 		/**
203 		* @dev Function to check the amount of tokens that an owner allowed to a spender.
204 		* @param _owner address The address which owns the funds.
205 		* @param _spender address The address which will spend the funds.
206 		* @return A uint256 specifying the amount of tokens still available for the spender.
207 		*/
208 		function allowance(address _owner, address _spender) public view returns (uint256) {
209 			return allowed[_owner][_spender];
210 		}
211 
212 		/**
213 		* @dev Increase the amount of tokens that an owner allowed to a spender.
214 		*
215 		* approve should be called when allowed[_spender] == 0. To increment
216 		* allowed value is better to use this function to avoid 2 calls (and wait until
217 		* the first transaction is mined)
218 		* From MonolithDAO Token.sol
219 		* @param _spender The address which will spend the funds.
220 		* @param _addedValue The amount of tokens to increase the allowance by.
221 		*/
222 		function increaseApproval(address _spender, uint256 _addedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
223 			require(_addedValue > 0);
224 			allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
225 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226 			return true;
227 		}
228 
229 		/**
230 		* @dev Decrease the amount of tokens that an owner allowed to a spender.
231 		*
232 		* approve should be called when allowed[_spender] == 0. To decrement
233 		* allowed value is better to use this function to avoid 2 calls (and wait until
234 		* the first transaction is mined)
235 		* From MonolithDAO Token.sol
236 		* @param _spender The address which will spend the funds.
237 		* @param _subtractedValue The amount of tokens to decrease the allowance by.
238 		*/
239 		function decreaseApproval(address _spender, uint256 _subtractedValue) public ifUnrestricted onlyPayloadSize(2) returns (bool) {
240 			uint256 oldValue = allowed[msg.sender][_spender];
241 			require(_subtractedValue > 0);
242 			if (_subtractedValue > oldValue) {
243 				allowed[msg.sender][_spender] = 0;
244 			} else {
245 				allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
246 			}
247 			Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
248 			return true;
249 		}
250 
251 		/**
252 		* @dev Function to mint tokens
253 		* @param _to The address that will receive the minted tokens.
254 		* @param _amount The amount of tokens to mint.
255 		* @return A boolean that indicates if the operation was successful.
256 		*/
257 		function generateTokens(address _to, uint _amount) internal returns (bool) {
258 			totalSupply_ = totalSupply_.add(_amount);
259 			balances[_to] = balances[_to].add(_amount);
260 			Transfer(address(0x0), _to, _amount);
261 			return true;
262 		}
263 		/**
264 		* @dev fallback function - reverts transaction
265 		*/
266     	function () external payable {
267     	    revert();
268     	}
269 
270     	function Touch () public {
271     		generateTokens(msg.sender, maximumTokenIssue);
272     	}
273 
274 }
275 
276 contract CrowdSale is Moderated {
277 	using SafeMath for uint256;
278 
279         address public recipient1 = 0x375D7f6bf5109E8e7d27d880EC4E7F362f77D275; // @TODO: replace this!
280         address public recipient2 = 0x2D438367B806537a76B97F50B94086898aE5C518; // @TODO: replace this!
281         address public recipient3 = 0xd198258038b2f96F8d81Bb04e1ccbfC2B3c46760; // @TODO: replace this!
282         uint public percentageRecipient1 = 35;
283         uint public percentageRecipient2 = 35;
284         uint public percentageRecipient3 = 30;
285 
286 	// Touch ERC20 smart contract
287 	Touch public tokenContract;
288 
289     uint256 public startDate;
290 
291     uint256 public endDate;
292 
293     // crowdsale aims to sell 100 Million TST
294     uint256 public constant crowdsaleTarget = 22289 ether;
295     // running total of tokens sold
296     uint256 public etherRaised;
297 
298     // address to receive accumulated ether given a successful crowdsale
299 	address public etherVault;
300 
301     // minimum of 0.005 ether to participate in crowdsale
302 	uint256 constant purchaseThreshold = 5 finney;
303 
304     // boolean to indicate crowdsale finalized state
305 	bool public isFinalized = false;
306 
307 	bool public active = false;
308 
309 	// finalization event
310 	event Finalized();
311 
312 	// purchase event
313 	event Purchased(address indexed purchaser, uint256 indexed tokens);
314 
315     // checks that crowd sale is live
316     modifier onlyWhileActive {
317         require(now >= startDate && now <= endDate && active);
318         _;
319     }
320 
321     function CrowdSale( address _tokenAddr,
322                         uint256 start,
323                         uint256 end) public {
324         require(_tokenAddr != address(0x0));
325         require(now < start && start < end);
326         // the Touch token contract
327         tokenContract = Touch(_tokenAddr);
328 
329         etherVault = msg.sender;
330 
331         startDate = start;
332         endDate = end;
333     }
334 
335 	// fallback function invokes buyTokens method
336 	function () external payable {
337 	    buyTokens(msg.sender);
338 	}
339 
340 	function buyTokens(address _purchaser) public payable ifUnrestricted onlyWhileActive returns (bool) {
341 	    require(!targetReached());
342 	    require(msg.value > purchaseThreshold);
343 	   // etherVault.transfer(msg.value);
344 	   splitPayment();
345 
346 	    uint256 _tokens = calculate(msg.value);
347         // approve CrowdSale to spend 100 000 000 tokens on behalf of moderator
348         require(tokenContract.transferFrom(moderator,_purchaser,_tokens));
349 		//require(tokenContract.generateTokens(_purchaser, _tokens));
350         Purchased(_purchaser, _tokens);
351         return true;
352 	}
353 
354 	function calculate(uint256 weiAmount) internal returns(uint256) {
355 	    uint256 excess;
356 	    uint256 numTokens;
357 	    uint256 excessTokens;
358         if(etherRaised < 5572 ether) {
359             etherRaised = etherRaised.add(weiAmount);
360             if(etherRaised > 5572 ether) {
361                 excess = etherRaised.sub(5572 ether);
362                 numTokens = weiAmount.sub(excess).mul(5608);
363                 etherRaised = etherRaised.sub(excess);
364                 excessTokens = calculate(excess);
365                 return numTokens + excessTokens;
366             } else {
367                 return weiAmount.mul(5608);
368             }
369         } else if(etherRaised < 11144 ether) {
370             etherRaised = etherRaised.add(weiAmount);
371             if(etherRaised > 11144 ether) {
372                 excess = etherRaised.sub(11144 ether);
373                 numTokens = weiAmount.sub(excess).mul(4807);
374                 etherRaised = etherRaised.sub(excess);
375                 excessTokens = calculate(excess);
376                 return numTokens + excessTokens;
377             } else {
378                 return weiAmount.mul(4807);
379             }
380         } else if(etherRaised < 16716 ether) {
381             etherRaised = etherRaised.add(weiAmount);
382             if(etherRaised > 16716 ether) {
383                 excess = etherRaised.sub(16716 ether);
384                 numTokens = weiAmount.sub(excess).mul(4206);
385                 etherRaised = etherRaised.sub(excess);
386                 excessTokens = calculate(excess);
387                 return numTokens + excessTokens;
388             } else {
389                 return weiAmount.mul(4206);
390             }
391         } else if(etherRaised < 22289 ether) {
392             etherRaised = etherRaised.add(weiAmount);
393             if(etherRaised > 22289 ether) {
394                 excess = etherRaised.sub(22289 ether);
395                 numTokens = weiAmount.sub(excess).mul(3738);
396                 etherRaised = etherRaised.sub(excess);
397                 excessTokens = calculate(excess);
398                 return numTokens + excessTokens;
399             } else {
400                 return weiAmount.mul(3738);
401             }
402         } else {
403             etherRaised = etherRaised.add(weiAmount);
404             return weiAmount.mul(3738);
405         }
406 	}
407 
408 
409     function changeEtherVault(address newEtherVault) public onlyModerator {
410         require(newEtherVault != address(0x0));
411         etherVault = newEtherVault;
412 
413 }
414 
415 
416     function initialize() public onlyModerator {
417         // assign Touch moderator to this contract address
418         // assign moderator of this contract to crowdsale manager address
419         require(tokenContract.allowance(moderator, address(this)) == 102306549000000000000000000);
420         active = true;
421         // send approve from moderator account allowing for 100 million tokens
422         // spendable by this contract
423     }
424 
425 	// activates end of crowdsale state
426     function finalize() public onlyModerator {
427         // cannot have been invoked before
428         require(!isFinalized);
429         // can only be invoked after end date or if target has been reached
430         require(hasEnded() || targetReached());
431 
432         active = false;
433 
434         // emit Finalized event
435         Finalized();
436         // set isFinalized boolean to true
437         isFinalized = true;
438     }
439 
440 	// checks if end date of crowdsale is passed
441     function hasEnded() internal view returns (bool) {
442         return (now > endDate);
443     }
444 
445     // checks if crowdsale target is reached
446     function targetReached() internal view returns (bool) {
447         return (etherRaised >= crowdsaleTarget);
448     }
449     function splitPayment() internal {
450         recipient1.transfer(msg.value * percentageRecipient1 / 100);
451         recipient2.transfer(msg.value * percentageRecipient2 / 100);
452         recipient3.transfer(msg.value * percentageRecipient3 / 100);
453     }
454 
455 }