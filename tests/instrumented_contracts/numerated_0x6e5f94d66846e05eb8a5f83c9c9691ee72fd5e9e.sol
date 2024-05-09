1 pragma solidity ^0.4.13;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public constant returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Ownable {
18   address public owner;
19 
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23 
24   /**
25    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
26    * account.
27    */
28   function Ownable() {
29     owner = msg.sender;
30   }
31 
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41 
42   /**
43    * @dev Allows the current owner to transfer control of the contract to a newOwner.
44    * @param newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address newOwner) onlyOwner public {
47     require(newOwner != address(0));
48     OwnershipTransferred(owner, newOwner);
49     owner = newOwner;
50   }
51 
52 }
53 
54 library SafeERC20 {
55   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
56     assert(token.transfer(to, value));
57   }
58 
59   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
60     assert(token.transferFrom(from, to, value));
61   }
62 
63   function safeApprove(ERC20 token, address spender, uint256 value) internal {
64     assert(token.approve(spender, value));
65   }
66 }
67 
68 library SafeMath {
69   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function div(uint256 a, uint256 b) internal constant returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return c;
80   }
81 
82   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function add(uint256 a, uint256 b) internal constant returns (uint256) {
88     uint256 c = a + b;
89     assert(c >= a);
90     return c;
91   }
92 }
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98   /**
99   * @dev transfer token for a specified address
100   * @param _to The address to transfer to.
101   * @param _value The amount to be transferred.
102   */
103   function transfer(address _to, uint256 _value) public returns (bool) {
104     require(_to != address(0));
105 
106     // SafeMath.sub will throw if there is not enough balance.
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) public constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 contract BountyManager is Ownable  {
125 	using SafeMath for uint256;
126 
127 	
128 
129 	
130 	/*Variables about the token contract */	
131 	Peculium public pecul; // The Peculium token
132 	bool public initPecul; // boolean to know if the Peculium token address has been init
133 	
134 	event InitializedToken(address contractToken);
135 	
136 	/*Variables about the bounty manager */
137 	address public bountymanager ; // address of the bounty manager 
138 	uint256 public bountymanagerShare; // nb token for the bountymanager
139 	bool public First_pay_bountymanager; // boolean to test if the first pay has been send to the bountymanager
140 	uint256 public first_pay; // pourcent of the first pay rate
141 	uint256 public montly_pay; // pourcent of the montly pay rate
142 	bool public bountyInit; // boolean to know if the bounty address has been init
143 	uint256 public payday; // Day when the bounty manager is paid
144 	uint256 public nbMonthsPay; // The montly pay is sent for 6 months
145 
146 	event InitializedManager(address ManagerAdd);
147 	event FirstPaySend(uint256 first,address receiver);
148 	event MonthlyPaySend(uint256 monthPay,address receiverMonthly);
149 	
150 	
151 	//Constructor
152 	function BountyManager() {
153 		
154 		bountymanagerShare = SafeMath.mul(72000000,(10**8)); // we allocate 72 million token to the bounty manager (maybe to change)
155 		
156 		first_pay = SafeMath.div(SafeMath.mul(40,bountymanagerShare),100); // first pay is 40%
157 		montly_pay = SafeMath.div(SafeMath.mul(10,bountymanagerShare),100); // other pay are 10%
158 		nbMonthsPay = 0;
159 		
160 		First_pay_bountymanager=true;
161 		initPecul = false;
162 		bountyInit==false;
163 		
164 
165 	}
166 	
167 	
168 	/***  Functions of the contract ***/
169 	
170 	function InitPeculiumAdress(address peculAdress) onlyOwner 
171 	{ // We init the address of the token
172 	
173 		pecul = Peculium(peculAdress);
174 		payday = pecul.dateDefrost();
175 		initPecul = true;
176 		InitializedToken(peculAdress);
177 	
178 	}
179 	
180 	function change_bounty_manager (address public_key) onlyOwner 
181 	{ // to change the bounty manager address
182 	
183 		bountymanager = public_key;
184 		bountyInit=true;
185 		InitializedManager(public_key);
186 	
187 	}
188 	
189 	function transferManager() onlyOwner Initialize BountyManagerInit 
190 	{ // Transfer pecul for the Bounty manager
191 		
192 		require(now > payday);
193 	
194 		if(First_pay_bountymanager==false && nbMonthsPay < 6)
195 		{
196 
197 			pecul.transfer(bountymanager,montly_pay);
198 			payday = payday.add( 31 days);
199 			nbMonthsPay=nbMonthsPay.add(1);
200 			MonthlyPaySend(montly_pay,bountymanager);
201 		
202 		}
203 		
204 		if(First_pay_bountymanager==true)
205 		{
206 
207 			pecul.transfer(bountymanager,first_pay);
208 			payday = payday.add( 35 days);
209 			First_pay_bountymanager=false;
210 			FirstPaySend(first_pay,bountymanager);
211 		
212 		}
213 
214 
215 		
216 	}
217 		/***  Modifiers of the contract ***/
218 	
219 	modifier Initialize { // We need to initialize first the token contract
220 		require (initPecul==true);
221 		_;
222     	}
223     	modifier BountyManagerInit { // We need to initialize first the address of the bountyManager
224 		require (bountyInit==true);
225 		_;
226     	} 
227 
228 }
229 
230 contract StandardToken is ERC20, BasicToken {
231 
232   mapping (address => mapping (address => uint256)) internal allowed;
233 
234 
235   /**
236    * @dev Transfer tokens from one address to another
237    * @param _from address The address which you want to send tokens from
238    * @param _to address The address which you want to transfer to
239    * @param _value uint256 the amount of tokens to be transferred
240    */
241   function transferFrom(address _from, address _to, uint256 _value) public returns (bool)  {
242     require(_to != address(0));
243 
244     uint256 _allowance = allowed[_from][msg.sender];
245 
246     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
247     // require (_value <= _allowance);
248 
249     balances[_from] = balances[_from].sub(_value);
250     balances[_to] = balances[_to].add(_value);
251     allowed[_from][msg.sender] = _allowance.sub(_value);
252     Transfer(_from, _to, _value);
253     return true;
254   }
255 
256   /**
257    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
258    *
259    * Beware that changing an allowance with this method brings the risk that someone may use both the old
260    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
261    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
262    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
263    * @param _spender The address which will spend the funds.
264    * @param _value The amount of tokens to be spent.
265    */
266   function approve(address _spender, uint256 _value) public returns (bool) {
267     allowed[msg.sender][_spender] = _value;
268     Approval(msg.sender, _spender, _value);
269     return true;
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens that an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint256 specifying the amount of tokens still available for the spender.
277    */
278   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
279     return allowed[_owner][_spender];
280   }
281 
282   /**
283    * approve should be called when allowed[_spender] == 0. To increment
284    * allowed value is better to use this function to avoid 2 calls (and wait until
285    * the first transaction is mined)
286    * From MonolithDAO Token.sol
287    */
288   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
289     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
290     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291     return true;
292   }
293 
294   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
295     uint oldValue = allowed[msg.sender][_spender];
296     if (_subtractedValue > oldValue) {
297       allowed[msg.sender][_spender] = 0;
298     } else {
299       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
300     }
301     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
302     return true;
303   }
304 
305 }
306 
307 contract BurnableToken is StandardToken {
308 
309     event Burn(address indexed burner, uint256 value);
310 
311     /**
312      * @dev Burns a specific amount of tokens.
313      * @param _value The amount of token to be burned.
314      */
315     function burn(uint256 _value) public {
316         require(_value > 0);
317         require(_value <= balances[msg.sender]);
318         // no need to require value <= totalSupply, since that would imply the
319         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
320 
321         address burner = msg.sender;
322         balances[burner] = balances[burner].sub(_value);
323         totalSupply = totalSupply.sub(_value);
324         Burn(burner, _value);
325     }
326 }
327 
328 contract Peculium is BurnableToken,Ownable { // Our token is a standard ERC20 Token with burnable and ownable aptitude
329 
330 	using SafeMath for uint256; // We use safemath to do basic math operation (+,-,*,/)
331 	using SafeERC20 for ERC20Basic; 
332 
333     	/* Public variables of the token for ERC20 compliance */
334 	string public name = "Peculium"; //token name 
335     	string public symbol = "PCL"; // token symbol
336     	uint256 public decimals = 8; // token number of decimal
337     	
338     	/* Public variables specific for Peculium */
339         uint256 public constant MAX_SUPPLY_NBTOKEN   = 20000000000*10**8; // The max cap is 20 Billion Peculium
340 
341 	uint256 public dateStartContract; // The date of the deployment of the token
342 	mapping(address => bool) public balancesCanSell; // The boolean variable, to frost the tokens
343 	uint256 public dateDefrost; // The date when the owners of token can defrost their tokens
344 
345 
346     	/* Event for the freeze of account */
347  	event FrozenFunds(address target, bool frozen);     	 
348      	event Defroze(address msgAdd, bool freeze);
349 	
350 
351 
352    
353 	//Constructor
354 	function Peculium() {
355 		totalSupply = MAX_SUPPLY_NBTOKEN;
356 		balances[owner] = totalSupply; // At the beginning, the owner has all the tokens. 
357 		balancesCanSell[owner] = true; // The owner need to sell token for the private sale and for the preICO, ICO.
358 		
359 		dateStartContract=now;
360 		dateDefrost = dateStartContract + 85 days; // everybody can defrost his own token after the 25 january 2018 (85 days after 1 November)
361 
362 	}
363 
364 	/*** Public Functions of the contract ***/	
365 	
366 	function defrostToken() public 
367 	{ // Function to defrost your own token, after the date of the defrost
368 	
369 		require(now>dateDefrost);
370 		balancesCanSell[msg.sender]=true;
371 		Defroze(msg.sender,true);
372 	}
373 				
374 	function transfer(address _to, uint256 _value) public returns (bool) 
375 	{ // We overright the transfer function to allow freeze possibility
376 	
377 		require(balancesCanSell[msg.sender]);
378 		return BasicToken.transfer(_to,_value);
379 	
380 	}
381 	
382 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) 
383 	{ // We overright the transferFrom function to allow freeze possibility (need to allow before)
384 	
385 		require(balancesCanSell[msg.sender]);	
386 		return StandardToken.transferFrom(_from,_to,_value);
387 	
388 	}
389 
390 	/***  Owner Functions of the contract ***/	
391 
392    	function freezeAccount(address target, bool canSell) onlyOwner 
393    	{
394         
395         	balancesCanSell[target] = canSell;
396         	FrozenFunds(target, canSell);
397     	
398     	}
399 
400 
401 	/*** Others Functions of the contract ***/	
402 	
403 	/* Approves and then calls the receiving contract */
404 	function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
405 		allowed[msg.sender][_spender] = _value;
406 		Approval(msg.sender, _spender, _value);
407 
408 		require(_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
409         	return true;
410     }
411 
412   	function getBlockTimestamp() constant returns (uint256)
413   	{
414         
415         	return now;
416   	
417   	}
418 
419   	function getOwnerInfos() constant returns (address ownerAddr, uint256 ownerBalance)  
420   	{ // Return info about the public address and balance of the account of the owner of the contract
421     	
422     		ownerAddr = owner;
423 		ownerBalance = balanceOf(ownerAddr);
424   	
425   	}
426 
427 }