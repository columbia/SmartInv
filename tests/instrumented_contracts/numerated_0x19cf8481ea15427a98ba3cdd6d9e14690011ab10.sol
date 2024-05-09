1 //DAO Polska Token deployment
2 pragma solidity ^0.4.11;
3 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
4 
5 
6 // title Migration Agent interface
7 contract MigrationAgent {
8     function migrateFrom(address _from, uint256 _value);
9 }
10 
11 contract ERC20 {
12   uint public totalSupply;
13   function balanceOf(address who) constant returns (uint);
14   function allowance(address owner, address spender) constant returns (uint);
15 
16   function transfer(address to, uint value) returns (bool ok);
17   function transferFrom(address from, address to, uint value) returns (bool ok);
18   function approve(address spender, uint value) returns (bool ok);
19   event Transfer(address indexed from, address indexed to, uint value);
20   event Approval(address indexed owner, address indexed spender, uint value);
21 }
22 
23 
24 
25 /**
26  * Math operations with safety checks
27  */
28 contract SafeMath {
29   function safeMul(uint a, uint b) internal returns (uint) {
30     uint c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function safeDiv(uint a, uint b) internal returns (uint) {
36     assert(b > 0);
37     uint c = a / b;
38     assert(a == b * c + a % b);
39     return c;
40   }
41 
42   function safeSub(uint a, uint b) internal returns (uint) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function safeAdd(uint a, uint b) internal returns (uint) {
48     uint c = a + b;
49     assert(c>=a && c>=b);
50     return c;
51   }
52 
53   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
54     return a >= b ? a : b;
55   }
56 
57   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
58     return a < b ? a : b;
59   }
60 
61   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
62     return a >= b ? a : b;
63   }
64 
65   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
66     return a < b ? a : b;
67   }
68 
69   function assert(bool assertion) internal {
70     if (!assertion) {
71       throw;
72     }
73   }
74 }
75 
76 
77 
78 /**
79  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
80  *
81  * Based on code by FirstBlood:
82  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20, SafeMath {
85 
86   /* Token supply got increased and a new owner received these tokens */
87   event Minted(address receiver, uint amount);
88 
89   /* Actual balances of token holders */
90   mapping(address => uint) balances;
91   // what exaclt ether was sent
92   mapping(address => uint) balancesRAW;
93   /* approve() allowances */
94   mapping (address => mapping (address => uint)) allowed;
95 
96   /* Interface declaration */
97   function isToken() public constant returns (bool weAre) {
98     return true;
99   }
100 
101   function transfer(address _to, uint _value) returns (bool success) {
102     balances[msg.sender] = safeSub(balances[msg.sender], _value);
103     balances[_to] = safeAdd(balances[_to], _value);
104     Transfer(msg.sender, _to, _value);
105     return true;
106   }
107 
108   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
109     uint _allowance = allowed[_from][msg.sender];
110 
111     balances[_to] = safeAdd(balances[_to], _value);
112     balances[_from] = safeSub(balances[_from], _value);
113     allowed[_from][msg.sender] = safeSub(_allowance, _value);
114     Transfer(_from, _to, _value);
115     return true;
116   }
117 
118   function balanceOf(address _owner) constant returns (uint balance) {
119     return balances[_owner];
120   }
121 
122   function approve(address _spender, uint _value) returns (bool success) {
123 
124     // To change the approve amount you first have to reduce the addresses`
125     //  allowance to zero by calling `approve(_spender, 0)` if it is not
126     //  already 0 to mitigate the race condition described here:
127     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
129 
130     allowed[msg.sender][_spender] = _value;
131     Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   function allowance(address _owner, address _spender) constant returns (uint remaining) {
136     return allowed[_owner][_spender];
137   }
138 
139   
140   
141 }
142 
143 
144 //  daoPOLSKAtokens
145 contract daoPOLSKAtokens{
146 
147     string public name = "DAO POLSKA TOKEN version 1";
148     string public symbol = "DPL";
149     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETC/ETH/HEE.
150 
151     // Receives 
152     address public owner;
153     address public migrationMaster;	
154     // The current total token supply.
155 
156     uint256 public otherchainstotalsupply =1.0 ether;
157     uint256 public supplylimit      = 10000.0 ether;
158 	//totalSupply   
159    uint256 public  totalSupply      = 0.0 ether;
160 	//chains:
161 	address public Chain1 = 0x0;
162 	address public Chain2 = 0x0;
163 	address public Chain3 = 0x0;
164 	address public Chain4 = 0x0;
165 
166 	address public migrationAgent=0x8585D5A25b1FA2A0E6c3BcfC098195bac9789BE2;
167     uint256 public totalMigrated;
168 
169 
170     event Migrate(address indexed _from, address indexed _to, uint256 _value);
171     event Refund(address indexed _from, uint256 _value);
172 
173 	
174 	struct sendTokenAway{
175 		StandardToken coinContract;
176 		uint amount;
177 		address recipient;
178 	}
179 	mapping(uint => sendTokenAway) transfers;
180 	uint numTransfers=0;
181 	
182   mapping (address => uint256) balances;
183 mapping (address => uint256) balancesRAW;
184   mapping (address => mapping (address => uint256)) allowed;
185 
186 	event UpdatedTokenInformation(string newName, string newSymbol);	
187  
188     event Transfer(address indexed _from, address indexed _to, uint256 _value);
189 	event receivedEther(address indexed _from,uint256 _value);
190   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
191 
192       // This notifies clients about the amount burnt
193     event Burn(address indexed from, uint256 value);
194   //tokenCreationCap
195   bool public supplylimitset = false;
196   bool public otherchainstotalset = false;
197    
198   function daoPOLSKAtokens() {
199 owner=msg.sender;
200 migrationMaster=msg.sender;
201 }
202 
203 function  setSupply(uint256 supplyLOCKER) public {
204     	   if (msg.sender != owner) {
205       throw;
206     }
207 		    	   if (supplylimitset != false) {
208       throw;
209     }
210 	supplylimitset = true;
211   
212 	supplylimit = supplyLOCKER ** uint256(decimals);
213 //balances[owner]=supplylimit;
214   } 
215 function setotherchainstotalsupply(uint256 supplyLOCKER) public {
216     	   if (msg.sender != owner) {
217       throw;
218     }
219 	    	   if (supplylimitset != false) {
220       throw;
221     }
222 
223 	otherchainstotalset = true;
224 	otherchainstotalsupply = supplyLOCKER ** uint256(decimals);
225 	
226   } 
227     /**
228      * Set allowance for other address and notify
229      *
230      * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it
231      *
232      * @param _spender The address authorized to spend
233      * @param _value the max amount they can spend
234      * @param _extraData some extra information to send to the approved contract
235      */
236     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
237         public
238         returns (bool success) {
239         tokenRecipient spender = tokenRecipient(_spender);
240         if (approve(_spender, _value)) {
241             spender.receiveApproval(msg.sender, _value, this, _extraData);
242             return true;
243         }
244     }
245 
246     /**
247      * Destroy tokens
248      *
249      * Remove `_value` tokens from the system irreversibly
250      *
251      * @param _value the amount of money to burn
252      */
253     function burn(uint256 _value) public returns (bool success) {
254         require(balances[msg.sender] >= _value);   // Check if the sender has enough
255         balances[msg.sender] -= _value;            // Subtract from the sender
256         totalSupply -= _value;                      // Updates totalSupply
257         Burn(msg.sender, _value);
258         return true;
259     }
260 
261     /**
262      * Destroy tokens from other account
263      *
264      * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
265      *
266      * @param _from the address of the sender
267      * @param _value the amount of money to burn
268      */
269     function burnFrom(address _from, uint256 _value) public returns (bool success) {
270         require(balances[_from] >= _value);                // Check if the targeted balance is enough
271         require(_value <= allowed[_from][msg.sender]);    // Check allowance
272         balances[_from] -= _value;                         // Subtract from the targeted balance
273         allowed[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
274         totalSupply -= _value;                              // Update totalSupply
275         Burn(_from, _value);
276         return true;
277     }
278   
279   function transfer(address _to, uint256 _value) returns (bool success) {
280     //Default assumes totalSupply can't be over max (2^256 - 1).
281     //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
282     //Replace the if with this one instead.
283     if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
284     //if (balances[msg.sender] >= _value && _value > 0) {
285       balances[msg.sender] -= _value;
286       balances[_to] += _value;
287       Transfer(msg.sender, _to, _value);
288       return true;
289     } else { return false; }
290   }
291 
292   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
293     //same as above. Replace this line with the following if you want to protect against wrapping uints.
294     if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
295     //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
296       balances[_to] += _value;
297       balances[_from] -= _value;
298       allowed[_from][msg.sender] -= _value;
299       Transfer(_from, _to, _value);
300       return true;
301     } else { return false; }
302   }
303 
304   function balanceOf(address _owner) constant returns (uint256 balance) {
305     return balances[_owner];
306   }
307 
308   function approve(address _spender, uint256 _value) returns (bool success) {
309     allowed[msg.sender][_spender] = _value;
310     Approval(msg.sender, _spender, _value);
311     return true;
312   }
313 
314   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
315     return allowed[_owner][_spender];
316   }
317 
318 
319 	
320 	    function () payable  public {
321 		 if(funding){ 
322         receivedEther(msg.sender, msg.value);
323 		balances[msg.sender]=balances[msg.sender]+msg.value;
324 		} else throw;
325 		
326     }
327    
328 
329 
330 
331 	
332   function setTokenInformation(string _name, string _symbol) {
333     
334 	   if (msg.sender != owner) {
335       throw;
336     }
337 	name = _name;
338     symbol = _symbol;
339 
340     UpdatedTokenInformation(name, symbol);
341   }
342 
343 function setChainsAddresses(address chainAd, int chainnumber) {
344     
345 	   if (msg.sender != owner) {
346       throw;
347     }
348 	if(chainnumber==1){Chain1=chainAd;}
349 	if(chainnumber==2){Chain2=chainAd;}
350 	if(chainnumber==3){Chain3=chainAd;}
351 	if(chainnumber==4){Chain4=chainAd;}		
352   } 
353 
354   function DAOPolskaTokenICOregulations() external returns(string wow) {
355 	return 'Regulations of preICO and ICO are present at website  DAO Polska Token.network and by using this smartcontract and blockchains you commit that you accept and will follow those rules';
356 }
357 // if accidentally other token was donated to Project Dev
358 
359 
360 	function sendTokenAw(address StandardTokenAddress, address receiver, uint amount){
361 		if (msg.sender != owner) {
362 		throw;
363 		}
364 		sendTokenAway t = transfers[numTransfers];
365 		t.coinContract = StandardToken(StandardTokenAddress);
366 		t.amount = amount;
367 		t.recipient = receiver;
368 		t.coinContract.transfer(receiver, amount);
369 		numTransfers++;
370 	}
371 
372      // Crowdfunding:
373 uint public tokenCreationRate=1000;
374 uint public bonusCreationRate=1000;
375 uint public CreationRate=1761;
376    uint256 public constant oneweek = 36000;
377 uint256 public fundingEndBlock = 5433616;
378 bool public funding = true;
379 bool public refundstate = false;
380 bool public migratestate= false;
381         function createDaoPOLSKAtokens(address holder) payable {
382 
383         if (!funding) throw;
384 
385         // Do not allow creating 0 or more than the cap tokens.
386         if (msg.value == 0) throw;
387 		// check the maximum token creation cap
388         if (msg.value > (supplylimit - totalSupply) / CreationRate)
389           throw;
390 		
391 		//bonus structure
392 // in early stage there is about 100% more details in ico regulations on website
393 // price and converstion rate in tabled to PLN not ether, and is updated daily
394 
395 
396 
397 	 var numTokensRAW = msg.value;
398 
399         var numTokens = msg.value * CreationRate;
400         totalSupply += numTokens;
401 
402         // Assign new tokens to the sender
403         balances[holder] += numTokens;
404         balancesRAW[holder] += numTokensRAW;
405         // Log token creation event
406         Transfer(0, holder, numTokens);
407 		
408 		// Create additional Dao Tokens for the community and developers around 12%
409         uint256 percentOfTotal = 12;
410         uint256 additionalTokens = 	numTokens * percentOfTotal / (100);
411 
412         totalSupply += additionalTokens;
413 
414         balances[migrationMaster] += additionalTokens;
415         Transfer(0, migrationMaster, additionalTokens);
416 	
417 	}
418 	function setBonusCreationRate(uint newRate){
419 	if(msg.sender == owner) {
420 	bonusCreationRate=newRate;
421 	CreationRate=tokenCreationRate+bonusCreationRate;
422 	}
423 	}
424 
425     function FundsTransfer() external {
426 	if(funding==true) throw;
427 		 	if (!owner.send(this.balance)) throw;
428     }
429 	
430     function PartialFundsTransfer(uint SubX) external {
431 	      if (msg.sender != owner) throw;
432         owner.send(this.balance - SubX);
433 	}
434 	function turnrefund() external {
435 	      if (msg.sender != owner) throw;
436 	refundstate=!refundstate;
437         }
438 		
439 			function fundingState() external {
440 	      if (msg.sender != owner) throw;
441 	funding=!funding;
442         }
443     function turnmigrate() external {
444 	      if (msg.sender != migrationMaster) throw;
445 	migratestate=!migratestate;
446 }
447 
448     // notice Finalize crowdfunding clossing funding options
449 	
450 function finalize() external {
451         if (block.number <= fundingEndBlock+8*oneweek) throw;
452         // Switch to Operational state. This is the only place this can happen.
453         funding = false;	
454 		refundstate=!refundstate;
455         // Transfer ETH to theDAO Polska Token network Storage address.
456         if (msg.sender==owner)
457 		owner.send(this.balance);
458     }
459     function migrate(uint256 _value) external {
460         // Abort if not in Operational Migration state.
461         if (migratestate) throw;
462 
463 
464         // Validate input value.
465         if (_value == 0) throw;
466         if (_value > balances[msg.sender]) throw;
467 
468         balances[msg.sender] -= _value;
469         totalSupply -= _value;
470         totalMigrated += _value;
471         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
472         Migrate(msg.sender, migrationAgent, _value);
473     }
474 	
475 function refundTRA() external {
476         // Abort if not in Funding Failure state.
477         if (funding) throw;
478         if (!refundstate) throw;
479 
480         var DAOPLTokenValue = balances[msg.sender];
481         var ETHValue = balancesRAW[msg.sender];
482         if (ETHValue == 0) throw;
483         balancesRAW[msg.sender] = 0;
484         totalSupply -= DAOPLTokenValue;
485          
486         Refund(msg.sender, ETHValue);
487         msg.sender.transfer(ETHValue);
488 }
489 
490 function preICOregulations() external returns(string wow) {
491 	return 'Regulations of preICO are present at website  daopolska.pl and by using this smartcontract you commit that you accept and will follow those rules';
492 }
493 
494 
495 }
496 
497 
498 //------------------------------------------------------