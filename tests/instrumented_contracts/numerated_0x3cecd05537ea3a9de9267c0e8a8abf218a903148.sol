1 /**
2  * @title METTA platform token & preICO crowdsale implementasion
3  * @author Maxim Akimov - <devstylesoftware@gmail.com>
4  * @author Dmitrii Bykov - <bykoffdn@gmail.com>
5  */
6 
7 pragma solidity ^0.4.18;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14     
15 	function mul(uint256 a, uint256 b) internal constant returns (uint256) {
16 		uint256 c = a * b;
17 		assert(a == 0 || c / a == b);
18 		return c;
19 	}
20 
21 	function div(uint256 a, uint256 b) internal constant returns (uint256) {
22 		// assert(b > 0); // Solidity automatically throws when dividing by 0
23 		uint256 c = a / b;
24 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
25 		return c;
26 	}
27 
28 	function sub(uint256 a, uint256 b) internal constant returns (uint256) {
29 		assert(b <= a);
30 		return a - b;
31 	}
32 
33 	function add(uint256 a, uint256 b) internal constant returns (uint256) {
34 		uint256 c = a + b;
35 		assert(c >= a);
36 		return c;
37 	}
38   
39 }
40 
41 /**
42  * @title ERC20Basic
43  * @dev Simpler version of ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/179
45  */
46 contract ERC20Basic {
47 	uint256 public totalSupply;
48 	function balanceOf(address who) constant returns (uint256);
49 	function transfer(address to, uint256 value) returns (bool);
50 	event Transfer(address indexed from, address indexed to, uint256 value);
51 }
52 
53 /**
54  * @title ERC20 interface
55  * @dev see https://github.com/ethereum/EIPs/issues/20
56  */
57 contract ERC20 is ERC20Basic {
58 	function allowance(address owner, address spender) constant returns (uint256);
59 	function transferFrom(address from, address to, uint256 value) returns (bool);
60 	function approve(address spender, uint256 value) returns (bool);
61 	event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances. 
67  */
68 contract BasicToken is ERC20Basic {
69     
70 	using SafeMath for uint256;
71 
72 	mapping(address => uint256) balances;
73 
74 	/**
75 	* @dev transfer token for a specified address
76 	* @param _to The address to transfer to.
77 	* @param _value The amount to be transferred.
78 	*/
79 	function transfer(address _to, uint256 _value) returns (bool) {
80 		balances[msg.sender] = balances[msg.sender].sub(_value);
81 		balances[_to] = balances[_to].add(_value);
82 		Transfer(msg.sender, _to, _value);
83 		return true;
84 	}
85 
86 	/**
87 	* @dev Gets the balance of the specified address.
88 	* @param _owner The address to query the the balance of. 
89 	* @return An uint256 representing the amount owned by the passed address.
90 	*/
91 	function balanceOf(address _owner) constant returns (uint256 balance) {
92 		return balances[_owner];
93 	}
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105 	mapping (address => mapping (address => uint256)) allowed;
106 
107 	/**
108 	* @dev Transfer tokens from one address to another
109 	* @param _from address The address which you want to send tokens from
110 	* @param _to address The address which you want to transfer to
111 	* @param _value uint256 the amout of tokens to be transfered
112 	*/
113 	function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
114 	  
115 		var _allowance = allowed[_from][msg.sender];
116 
117 		// Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
118 		// require (_value <= _allowance);
119 
120 		balances[_to] = balances[_to].add(_value);
121 		balances[_from] = balances[_from].sub(_value);
122 		allowed[_from][msg.sender] = _allowance.sub(_value);
123 		Transfer(_from, _to, _value);
124 		return true;
125 	}
126 
127 	/**
128 	* @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
129 	* @param _spender The address which will spend the funds.
130 	* @param _value The amount of tokens to be spent.
131 	*/
132 	function approve(address _spender, uint256 _value) returns (bool) {
133 
134 		// To change the approve amount you first have to reduce the addresses`
135 		//  allowance to zero by calling `approve(_spender, 0)` if it is not
136 		//  already 0 to mitigate the race condition described here:
137 		//  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138 		require((_value == 0) || (allowed[msg.sender][_spender] == 0));
139 
140 		allowed[msg.sender][_spender] = _value;
141 		Approval(msg.sender, _spender, _value);
142 		return true;
143 	}
144 
145 	/**
146 	* @dev Function to check the amount of tokens that an owner allowed to a spender.
147 	* @param _owner address The address which owns the funds.
148 	* @param _spender address The address which will spend the funds.
149 	* @return A uint256 specifing the amount of tokens still available for the spender.
150 	*/
151 	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
152 		return allowed[_owner][_spender];
153 	}
154 
155 }
156 
157 /**
158  * @title Ownable
159  * @dev The Ownable contract has an owner address, and provides basic authorization control
160  * functions, this simplifies the implementation of "user permissions".
161  */
162 contract Ownable {
163     
164 	address public owner;
165 	address public ownerCandidat;
166 
167 	/**
168 	* @dev The Ownable constructor sets the original `owner` of the contract to the sender
169 	* account.
170 	*/
171 	function Ownable() {
172 		owner = msg.sender;
173 		
174 	}
175 
176 	/**
177 	* @dev Throws if called by any account other than the owner.
178 	*/
179 	modifier onlyOwner() {
180 		require(msg.sender == owner);
181 		_;
182 	}
183 
184 	/**
185 	* @dev Allows the current owner to transfer control of the contract to a newOwner.
186 	* @param newOwner The address to transfer ownership to.
187 	*/
188 	function transferOwnership(address newOwner) onlyOwner {
189 		require(newOwner != address(0));      
190 		ownerCandidat = newOwner;
191 	}
192 	/**
193 	* @dev Allows safe change current owner to a newOwner.
194 	*/
195 	function confirmOwnership()  {
196 		require(msg.sender == ownerCandidat);      
197 		owner = msg.sender;
198 	}
199 
200 }
201 
202 /**
203  * @title Burnable Token
204  * @dev Token that can be irreversibly burned (destroyed).
205  */
206 contract BurnableToken is StandardToken, Ownable {
207  
208 	/**
209 	* @dev Burns a specific amount of tokens.
210 	* @param _value The amount of token to be burned.
211 	*/
212 	function burn(uint256 _value) public onlyOwner {
213 		require(_value > 0);
214 
215 		address burner = msg.sender;    
216 										
217 
218 		balances[burner] = balances[burner].sub(_value);
219 		totalSupply = totalSupply.sub(_value);
220 		Burn(burner, _value);
221 	}
222 
223 	event Burn(address indexed burner, uint indexed value);
224  
225 }
226  
227 contract MettaCoin is BurnableToken {
228  
229 	string public constant name = "TOKEN METTA";   
230 	string public constant symbol = "METTA";   
231 	uint32 public constant decimals = 18;    
232 	uint256 public constant initialSupply = 300000000 * 1 ether;
233 
234 	function MettaCoin() {
235 		totalSupply = initialSupply;
236 		balances[msg.sender] = initialSupply;
237 	}    
238   
239 }
240 
241 
242 contract MettaCrowdsale is Ownable {
243     
244     using SafeMath for uint;
245 	//
246     MettaCoin public token = new MettaCoin();
247 	//
248     uint public start;    
249     //
250 	uint public period;
251 	//
252     uint public rate;
253 	//  
254     uint public softcap;
255     //
256     uint public availableTokensforPreICO;
257     //
258     uint public countOfSaleTokens;
259     //    
260     uint public currentPreICObalance;
261     //
262     uint public refererPercent;
263     //
264 	mapping(address => uint) public balances;
265     
266     // preICO manager data//////////////
267      address public managerETHaddress;
268      address public managerETHcandidatAddress;
269      uint public managerETHbonus;
270     
271     /////////////////////////////////
272    
273     function MettaCrowdsale() {
274      
275 		// 1 METTACOIN = 0.00027 ETH
276 		rate = 270000000000000; 
277 		//Mon, 20 Nov 2017 00:00:00 GMT
278 		start = 1511136000;
279 		// preICO period is 20 of november - 19 of december (include 19)
280 		period = 30; //  
281 		// minimum attracted ETH during preICO - 409
282 		softcap = 409 * 1 ether;
283 		// maximum number mettacoins for preICO
284 		availableTokensforPreICO = 8895539 * 1 ether;
285 		// current ETH balance of preICO
286 		currentPreICObalance = 0; 
287 		// how much mettacoins are sold
288 		countOfSaleTokens = 0; 
289 		//percent for referer bonus program
290 		refererPercent = 15;
291 		
292 		//data of manager of company
293 		managerETHaddress = 0x0;   
294 		managerETHbonus = 27 * 1 ether;  
295 
296     }
297     /**
298 	 * @dev Initially safe sets preICO manager address
299 	 */
300     function setPreIcoManager(address _addr) public onlyOwner {   
301         require(managerETHaddress == 0x0) ;//only once
302 			managerETHcandidatAddress = _addr;
303         
304     }
305 	/**
306 	 * @dev Allows safe confirm of manager address
307 	 */
308     function confirmManager() public {
309         require(msg.sender == managerETHcandidatAddress); 
310 			managerETHaddress = managerETHcandidatAddress;
311     }
312     
313     	/**
314 	 * @dev Allows safe changing of manager address
315 	 */
316     function changeManager(address _addr) public {
317         require(msg.sender == managerETHaddress); 
318 			managerETHcandidatAddress = _addr;
319     }
320 	/**
321 	 * @dev Indicates that preICO starts and not finishes
322 	 */
323     modifier saleIsOn() {
324 		require(now > start && now < start + period * 1 days);
325 		_;
326     }
327 	
328 	/**
329 	 * @dev Indicates that we have available tokens for sale
330 	 */
331     modifier issetTokensForSale() {
332 		require(countOfSaleTokens < availableTokensforPreICO); 
333 		_;
334     }
335   
336 	/**
337 	 * @dev Tokens ans ownership will be transfered from preICO contract to ICO contract after preICO period.
338 	 */
339     function TransferTokenToIcoContract(address ICOcontract) public onlyOwner {
340         
341 		require(now > start + period * 1 days && token.owner()==ICOcontract);
342 		token.transfer(ICOcontract, token.balanceOf(this));
343     }
344     
345     /**
346     * @dev Transfer ownershop to ICO contract after pre ICO
347     */
348     function TransferTokenOwnership(address ICOcontract) onlyOwner{
349         require(now > start + period * 1 days);
350 		token.transferOwnership(ICOcontract);
351     }
352     
353 	/**
354 	 * @dev Investments will be refunded if preICO not hits the softcap.
355 	 */
356     function refund() public {
357 		require(currentPreICObalance < softcap && now > start + period * 1 days);
358 		msg.sender.transfer(balances[msg.sender]);
359 		balances[msg.sender] = 0;
360     }
361 	/**
362 	 * @dev Manager can get his/shes bonus after preICO reaches it's softcap
363 	 */
364     function withdrawManagerBonus() public {    
365         if(currentPreICObalance > softcap && managerETHbonus > 0 && managerETHaddress!=0x0){
366             managerETHaddress.transfer(managerETHbonus);
367             managerETHbonus = 0;
368         }
369     }
370 	/**
371 	 * @dev If ICO reached owner can withdrow ETH for ICO comping managment
372 	 */
373     function withdrawPreIcoFounds() public onlyOwner {  
374 		if(currentPreICObalance > softcap) {
375 			// send all current ETH from contract to owner
376 			uint availableToTranser = this.balance-managerETHbonus;
377 			owner.transfer(availableToTranser);
378 		}
379     }
380 	/**
381 	 * @dev convert bytes to address
382 	 */
383     function bytesToAddress(bytes source) internal returns(address) {
384         uint result;
385         uint mul = 1;
386         for(uint i = 20; i > 0; i--) {
387           result += uint8(source[i-1])*mul;
388           mul = mul*256;
389         }
390         return address(result);
391     }
392    function buyTokens() issetTokensForSale saleIsOn payable {   
393         require(msg.value >= rate);// minimum 0,00022 eth for investment
394          uint tokens = msg.value.mul(1 ether).div(rate);
395              address referer = 0x0;
396             //-------------BONUSES-------------//
397              uint bonusTokens = 0;
398             if(now < start.add(7* 1 days)) {// 1st week
399     			bonusTokens = tokens.mul(45).div(100); //+45%
400             } else if(now >= start.add(7 * 1 days) && now < start.add(14 * 1 days)) { // 2nd week
401     			bonusTokens = tokens.mul(40).div(100); //+40%
402             } else if(now >= start.add(14* 1 days) && now < start.add(21 * 1 days)) { // 3th week
403     			bonusTokens = tokens.mul(35).div(100); //+35%
404             } else if(now >= start.add(21* 1 days) && now < start.add(28 * 1 days)) { // 4th week
405     			bonusTokens = tokens.mul(30).div(100); //+30% 
406             } 
407             tokens = tokens.add(bonusTokens);
408             //---------END-BONUSES-------------//
409     		
410     		//---------referal program--------- //abailable after 3th week only
411     		if(now >= start.add(14* 1 days) && now < start.add(28 * 1 days)) {
412                 if(msg.data.length == 20) {
413                   referer = bytesToAddress(bytes(msg.data));
414                   require(referer != msg.sender);
415                   uint refererTokens = tokens.mul(refererPercent).div(100);
416                 }
417     		}
418     		//---------end referal program---------//
419     		
420     		if(availableTokensforPreICO > countOfSaleTokens.add(tokens)) {  
421     			token.transfer(msg.sender, tokens);
422     			currentPreICObalance = currentPreICObalance.add(msg.value); 
423     			countOfSaleTokens = countOfSaleTokens.add(tokens); 
424     			balances[msg.sender] = balances[msg.sender].add(msg.value);
425     			if(availableTokensforPreICO > countOfSaleTokens.add(tokens).add(refererTokens)){
426     			     // send token to referrer
427     			     if(referer !=0x0 && refererTokens >0){
428     			        token.transfer(referer, refererTokens);
429     			        	countOfSaleTokens = countOfSaleTokens.add(refererTokens); 
430     			     }
431     			}
432     		} else {
433     			// changes to buyer
434     
435     	    	uint availabeTokensToSale = availableTokensforPreICO.sub(countOfSaleTokens);
436     			countOfSaleTokens = countOfSaleTokens.add(availabeTokensToSale); 
437     			token.transfer(msg.sender, availabeTokensToSale);
438     			
439     			uint changes = msg.value.sub(availabeTokensToSale.mul(rate).div(1 ether));
440     			balances[msg.sender] = balances[msg.sender].add(msg.value.sub(changes));
441     			currentPreICObalance = currentPreICObalance.add(msg.value.sub(changes));
442     			msg.sender.transfer(changes);
443     		}
444     }
445 
446     function() external payable {
447 		buyTokens();  
448     }
449       
450 }