1 pragma solidity ^0.4.16;
2 //https://github.com/genkifs/staticoin
3 
4 contract owned  {
5   address owner;
6   function owned() {
7     owner = msg.sender;
8   }
9   function changeOwner(address newOwner) onlyOwner {
10     owner = newOwner;
11   }
12   modifier onlyOwner() {
13     if (msg.sender==owner) 
14     _;
15   }
16 }
17 
18 contract mortal is owned() {
19   function kill() onlyOwner {
20     if (msg.sender == owner) selfdestruct(owner);
21   }
22 }
23 
24 library ERC20Lib {
25 //Inspired by https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736
26   struct TokenStorage {
27     mapping (address => uint256) balances;
28     mapping (address => mapping (address => uint256)) allowed;
29     uint256 totalSupply;
30   }
31   
32 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
33 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
34 
35 	modifier onlyPayloadSize(uint numwords) {
36 		/**
37 		* @dev  Checks for short addresses  
38 		* @param numwords number of parameters passed 
39 		*/
40         assert(msg.data.length >= numwords * 32 + 4);
41         _;
42 	}
43   
44 	modifier validAddress(address _address) { 
45 		/**
46 		* @dev  validates an address.  
47 		* @param _address checks that it isn't null or this contract address
48 		*/		
49         require(_address != 0x0); 
50         require(_address != address(msg.sender)); 
51         _; 
52     } 
53 	
54 	modifier IsWallet(address _address) {
55 		/**
56 		* @dev Transfer tokens from msg.sender to another address.  
57 		* Cannot Allows execution if the transfer to address code size is 0
58 		* @param _address address to check that its not a contract
59 		*/		
60 		uint codeLength;
61 		assembly {
62             // Retrieve the size of the code on target address, this needs assembly .
63             codeLength := extcodesize(_address)
64         }
65 		assert(codeLength==0);		
66         _; 
67     } 
68 
69    function safeMul(uint a, uint b) returns (uint) { 
70      uint c = a * b; 
71      assert(a == 0 || c / a == b); 
72      return c; 
73    } 
74  
75    function safeSub(uint a, uint b) returns (uint) { 
76      assert(b <= a); 
77      return a - b; 
78    }  
79  
80    function safeAdd(uint a, uint b) returns (uint) { 
81      uint c = a + b; 
82      assert(c>=a && c>=b); 
83      return c; 
84    } 
85 	
86 	function init(TokenStorage storage self, uint _initial_supply) {
87 		self.totalSupply = _initial_supply;
88 		self.balances[msg.sender] = _initial_supply;
89 	}
90   
91 	function transfer(TokenStorage storage self, address _to, uint256 _value) 
92 		onlyPayloadSize(3)
93 		IsWallet(_to)		
94 		returns (bool success) {				
95 		/**
96 		* @dev Transfer tokens from msg.sender to another address.  
97 		* Cannot be used to send tokens to a contract, this means contracts cannot mint coins to themselves
98 		* Contracts have to use the approve and transfer method
99 		* this is based on https://github.com/Dexaran/ERC223-token-standard
100 		* @param _to address The address where the coin is to be transfered
101 		* @param _value uint256 the amount of tokens to be transferred
102 		*/
103        if (self.balances[msg.sender] >= _value && self.balances[_to] + _value > self.balances[_to]) {
104             self.balances[msg.sender] = safeSub(self.balances[msg.sender], _value);
105             self.balances[_to] = safeAdd(self.balances[_to], _value);
106             Transfer(msg.sender, _to, _value);
107             return true;
108         } else { return false; }
109     }
110   
111 	function transferFrom(TokenStorage storage self, address _from, address _to, uint256 _value) 
112 		onlyPayloadSize(4) 
113 		validAddress(_from)
114 		validAddress(_to)
115 		returns (bool success) {
116 		/**
117 		* @dev Transfer tokens from one address to another.  Requires allowance to be set.
118 		* @param _from address The address which you want to send tokens from
119 		* @param _to address The address which you want to transfer to
120 		* @param _value uint256 the amount of tokens to be transferred
121 		*/
122         if (self.balances[_from] >= _value && self.allowed[_from][msg.sender] >= _value && self.balances[_to] + _value > self.balances[_to]) {
123 			var _allowance = self.allowed[_from][msg.sender];
124             self.balances[_to] = safeAdd(self.balances[_to], _value);
125             self.balances[_from] = safeSub(self.balances[_from], _value);
126             self.allowed[_from][msg.sender] = safeSub(_allowance, _value);
127             Transfer(_from, _to, _value);
128             return true;
129         } else { return false; }
130     }
131      
132     function balanceOf(TokenStorage storage self, address _owner) constant 
133 		onlyPayloadSize(2) 
134 		validAddress(_owner)
135 		returns (uint256 balance) {
136 		/**
137 		* @dev returns the amount given to an account
138 		* @param _owner The address to be queried
139 		* @return Balance of _owner.
140 		*/
141         return self.balances[_owner];
142     }
143 	 
144     function approve(TokenStorage storage self, address _spender, uint256 _value) 
145 		onlyPayloadSize(3) 
146 		validAddress(_spender)	
147 		returns (bool success) {
148 	/**
149     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
150     * @param _spender The address which will spend the funds.
151     * @param _value The amount of tokens to be spent.
152     */
153 		//require user to set to zero before resetting to nonzero
154 		if ((_value != 0) && (self.allowed[msg.sender][_spender] != 0)) { 
155            return false; 
156         } else {
157 			self.allowed[msg.sender][_spender] = _value;
158 			Approval(msg.sender, _spender, _value);
159 			return true;
160 		}
161     }
162 		
163 	function allowance(TokenStorage storage self, address _owner, address _spender) constant 
164 		onlyPayloadSize(3) 
165 		validAddress(_owner)	
166 		validAddress(_spender)	
167 		returns (uint256 remaining) {
168 			/**
169 			* @dev allows queries of how much a given address is allowed to spend on behalf of another account
170 			* @param _owner address The address which owns the funds.
171 			* @param _spender address The address which will spend the funds.
172 			* @return remaining uint256 specifying the amount of tokens still available for the spender.
173 			*/
174         return self.allowed[_owner][_spender];
175     }
176 	
177 	function increaseApproval(TokenStorage storage self, address _spender, uint256 _addedValue)  
178 		onlyPayloadSize(3) 
179 		validAddress(_spender)	
180 		returns (bool success) { 
181 		/**
182 		* @dev Allows to increment allowed value
183 		* better to use this function to avoid 2 calls
184 		* @param _spender address The address which will spend the funds.
185 		* @param _addedValue amount to increase alowance by.
186 		* @return True if allowance increased
187 		*/
188         uint256 oldValue = self.allowed[msg.sender][_spender]; 
189         self.allowed[msg.sender][_spender] = safeAdd(oldValue, _addedValue); 
190         return true; 
191     } 
192 	
193 	function decreaseApproval(TokenStorage storage self,address _spender, uint256 _subtractedValue)  
194 		onlyPayloadSize(3) 
195 		validAddress(_spender)	
196 		returns (bool success) { 
197 		/**
198 		* @dev Allows to decrement allowed value
199 		* better to use this function to avoid 2 calls
200 		* @param _spender address The address which will spend the funds.
201 		* @param _subtractedValue amount to decrease allowance by.
202 		* @return True if allowance decreased
203 		*/
204 		uint256 oldValue = self.allowed[msg.sender][_spender]; 
205 		if (_subtractedValue > oldValue) { 
206 			self.allowed[msg.sender][_spender] = 0; 
207 		} else { 
208 			self.allowed[msg.sender][_spender] = safeSub(oldValue, _subtractedValue); 
209 		} 
210 		return true; 
211 	} 
212 
213     /* Approves and then calls the receiving contract with any additional paramteres*/
214     function approveAndCall(TokenStorage storage self, address _spender, uint256 _value, bytes _extraData)
215 		onlyPayloadSize(4) 
216 		validAddress(_spender)   
217 		returns (bool success) {
218 	//require user to set to zero before resetting to nonzero
219 			/**
220 			* @dev Approves and then calls the receiving contract with any additional paramteres
221 			* @param _owner address The address which owns the funds.
222 			* @param _spender address The address which will spend the funds.
223 			* @param _value address The address which will spend the funds.
224 			* @param _extraData is the additional paramters passed
225 			* @return True if successful.
226 			*/
227 		if ((_value != 0) && (self.allowed[msg.sender][_spender] != 0)) { 
228 				return false; 
229 			} else {
230 			self.allowed[msg.sender][_spender] = _value;
231 			Approval(msg.sender, _spender, _value);
232 			//call the receiveApproval function on the contract you want to be notified. 
233 			//This crafts the function signature manually so one doesn't have to include a contract in here just for this.
234 			//it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
235 			if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
236 			return true;
237 		}
238     }	
239 	
240 	function mintCoin(TokenStorage storage self, address target, uint256 mintedAmount, address owner) 
241 		internal
242 		returns (bool success) {
243 			/**
244 			* @dev Approves and then calls the receiving contract with any additional paramteres
245 			* @param target address the address which will receive the funds.
246 			* @param mintedAmount the amount of funds to be sent.
247 			* @param owner the contract responsable for controling the amount of funds.
248 			* @return True if successful.
249 			*/
250         self.balances[target] = safeAdd(self.balances[target], mintedAmount);//balances[target] += mintedAmount;
251         self.totalSupply = safeAdd(self.totalSupply, mintedAmount);//totalSupply += mintedAmount;
252         Transfer(0, owner, mintedAmount); // Deliver coin to the mint
253         Transfer(owner, target, mintedAmount); // mint delivers to address
254 		return true;
255     }
256 
257     function meltCoin(TokenStorage storage self, address target, uint256 meltedAmount, address owner) 
258 		internal
259 		returns (bool success) {
260 			/**
261 			* @dev Approves and then calls the receiving contract with any additional paramteres
262 			* @param target address the address which will return the funds.
263 			* @param meltedAmount the amount of funds to be returned.
264 			* @param owner the contract responsable for controling the amount of funds.
265 			* @return True if successful.
266 			*/
267         if(self.balances[target]<meltedAmount){
268             return false;
269         }
270 		self.balances[target] = safeSub(self.balances[target], meltedAmount); //balances[target] -= meltedAmount;
271 		self.totalSupply = safeSub(self.totalSupply, meltedAmount); //totalSupply -= meltedAmount;
272 		Transfer(target, owner, meltedAmount); // address delivers to minter
273 		Transfer(owner, 0, meltedAmount); // minter delivers coin to the burn address
274 		return true;
275     }
276 }
277 
278 /** @title StandardToken. */
279 contract StandardToken is owned{
280     using ERC20Lib for ERC20Lib.TokenStorage;
281     ERC20Lib.TokenStorage public token;
282 
283 	string public name;                   //Long token name
284     uint8 public decimals=18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
285     string public symbol;                 //An identifier: eg SBX
286     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
287     uint public INITIAL_SUPPLY = 0;		// mintable coin has zero inital supply (and can fall back to zero)
288 
289     event Transfer(address indexed _from, address indexed _to, uint _value);
290     event Approval(address indexed _owner, address indexed _spender, uint _value);   
291    
292     function StandardToken() {
293 		token.init(INITIAL_SUPPLY);
294     }
295 
296     function totalSupply() constant returns (uint) {
297 		return token.totalSupply;
298     }
299 
300     function balanceOf(address who) constant returns (uint) {
301 		return token.balanceOf(who);
302     }
303 
304     function allowance(address owner, address _spender) constant returns (uint) {
305 		return token.allowance(owner, _spender);
306     }
307 
308 	function transfer(address to, uint value) returns (bool ok) {
309 		return token.transfer(to, value);
310 	}
311 
312 	function transferFrom(address _from, address _to, uint _value) returns (bool ok) {
313 		return token.transferFrom(_from, _to, _value);
314 	}
315 
316 	function approve(address _spender, uint value) returns (bool ok) {
317 		return token.approve(_spender, value);
318 	}
319    
320 	function increaseApproval(address _spender, uint256 _addedValue) returns (bool ok) {  
321 		return token.increaseApproval(_spender, _addedValue);
322 	}    
323  
324 	function decreaseApproval(address _spender, uint256 _subtractedValue) returns (bool ok) {  
325 		return token.decreaseApproval(_spender, _subtractedValue);
326 	}
327 
328 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool ok){
329 		return token.approveAndCall(_spender,_value,_extraData);
330     }
331 	
332 	function mintCoin(address target, uint256 mintedAmount) onlyOwner returns (bool ok) {
333 		return token.mintCoin(target,mintedAmount,owner);
334     }
335 
336     function meltCoin(address target, uint256 meltedAmount) onlyOwner returns (bool ok) {
337 		return token.meltCoin(target,meltedAmount,owner);
338     }
339 }
340 
341 /** @title Coin. */
342 contract Coin is StandardToken, mortal{
343     I_minter public mint;				  //Minter interface  
344     event EventClear();
345 
346     function Coin(string _tokenName, string _tokenSymbol, address _minter) { 
347         name = _tokenName;                                   // Set the name for display purposes
348         symbol = _tokenSymbol;                               // Set the symbol for display purposes
349         changeOwner(_minter);
350         mint=I_minter(_minter); 
351 	}
352 }
353 
354 /** @title RiskCoin. */
355 contract RiskCoin is Coin{
356     function RiskCoin(string _tokenName, string _tokenSymbol, address _minter) 
357 	Coin(_tokenName,_tokenSymbol,_minter) {} 
358 	
359     function() payable {
360 		/** @dev direct any ETH sent to this RiskCoin address to the minter.NewRisk function
361 		*/
362         mint.NewRiskAdr.value(msg.value)(msg.sender);
363     }  
364 }
365 
366 /** @title StatiCoin. */
367 contract StatiCoin is Coin{
368     function StatiCoin(string _tokenName, string _tokenSymbol, address _minter) 
369 	Coin(_tokenName,_tokenSymbol,_minter) {} 
370 
371     function() payable {        
372 		/** @dev direct any ETH sent to this StatiCoin address to the minter.NewStatic function
373         */
374         mint.NewStaticAdr.value(msg.value)(msg.sender);
375     }  
376 }
377 
378 /** @title I_coin. */
379 contract I_coin is mortal {
380 
381     event EventClear();
382 
383 	I_minter public mint;
384     string public name;                   //fancy name: eg Simon Bucks
385     uint8 public decimals=18;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
386     string public symbol;                 //An identifier: eg SBX
387     string public version = '';       //human 0.1 standard. Just an arbitrary versioning scheme.
388 	
389     function mintCoin(address target, uint256 mintedAmount) returns (bool success) {}
390     function meltCoin(address target, uint256 meltedAmount) returns (bool success) {}
391     function approveAndCall(address _spender, uint256 _value, bytes _extraData){}
392 
393     function setMinter(address _minter) {}   
394 	function increaseApproval (address _spender, uint256 _addedValue) returns (bool success) {}    
395 	function decreaseApproval (address _spender, uint256 _subtractedValue) 	returns (bool success) {} 
396 
397     // @param _owner The address from which the balance will be retrieved
398     // @return The balance
399     function balanceOf(address _owner) constant returns (uint256 balance) {}    
400 
401 
402     // @notice send `_value` token to `_to` from `msg.sender`
403     // @param _to The address of the recipient
404     // @param _value The amount of token to be transferred
405     // @return Whether the transfer was successful or not
406     function transfer(address _to, uint256 _value) returns (bool success) {}
407 
408 
409     // @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
410     // @param _from The address of the sender
411     // @param _to The address of the recipient
412     // @param _value The amount of token to be transferred
413     // @return Whether the transfer was successful or not
414     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
415 
416     // @notice `msg.sender` approves `_addr` to spend `_value` tokens
417     // @param _spender The address of the account able to transfer the tokens
418     // @param _value The amount of wei to be approved for transfer
419     // @return Whether the approval was successful or not
420     function approve(address _spender, uint256 _value) returns (bool success) {}
421 
422     event Transfer(address indexed _from, address indexed _to, uint256 _value);
423     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
424 	
425 	// @param _owner The address of the account owning tokens
426     // @param _spender The address of the account able to transfer the tokens
427     // @return Amount of remaining tokens allowed to spent
428     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
429 	
430 	mapping (address => uint256) balances;
431     mapping (address => mapping (address => uint256)) allowed;
432 
433 	// @return total amount of tokens
434     uint256 public totalSupply;
435 }
436 
437 /** @title I_minter. */
438 contract I_minter { 
439     event EventCreateStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
440     event EventRedeemStatic(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
441     event EventCreateRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
442     event EventRedeemRisk(address indexed _from, uint128 _value, uint _transactionID, uint _Price); 
443     event EventBankrupt();
444 	
445     function Leverage() constant returns (uint128)  {}
446     function RiskPrice(uint128 _currentPrice,uint128 _StaticTotal,uint128 _RiskTotal, uint128 _ETHTotal) constant returns (uint128 price)  {}
447     function RiskPrice(uint128 _currentPrice) constant returns (uint128 price)  {}     
448     function PriceReturn(uint _TransID,uint128 _Price) {}
449     function NewStatic() external payable returns (uint _TransID)  {}
450     function NewStaticAdr(address _Risk) external payable returns (uint _TransID)  {}
451     function NewRisk() external payable returns (uint _TransID)  {}
452     function NewRiskAdr(address _Risk) external payable returns (uint _TransID)  {}
453     function RetRisk(uint128 _Quantity) external payable returns (uint _TransID)  {}
454     function RetStatic(uint128 _Quantity) external payable returns (uint _TransID)  {}
455     function Strike() constant returns (uint128)  {}
456 }