1 /*************************************************************************
2  * This contract has been merged with solidify
3  * https://github.com/tiesnetwork/solidify
4  *************************************************************************/
5  
6  pragma solidity ^0.4.10;
7 
8 /*************************************************************************
9  * import "../common/Manageable.sol" : start
10  *************************************************************************/
11 
12 /*************************************************************************
13  * import "../common/Owned.sol" : start
14  *************************************************************************/
15 
16 
17 contract Owned {
18     address public owner;        
19 
20     function Owned() {
21         owner = msg.sender;
22     }
23 
24     // allows execution by the owner only
25     modifier ownerOnly {
26         assert(msg.sender == owner);
27         _;
28     }
29 
30     /**@dev allows transferring the contract ownership. */
31     function transferOwnership(address _newOwner) public ownerOnly {
32         require(_newOwner != owner);
33         owner = _newOwner;
34     }
35 }
36 /*************************************************************************
37  * import "../common/Owned.sol" : end
38  *************************************************************************/
39 
40 ///A token that have an owner and a list of managers that can perform some operations
41 ///Owner is always a manager too
42 contract Manageable is Owned {
43 
44     event ManagerSet(address manager, bool state);
45 
46     mapping (address => bool) public managers;
47 
48     function Manageable() Owned() {
49         managers[owner] = true;
50     }
51 
52     /**@dev Allows execution by managers only */
53     modifier managerOnly {
54         assert(managers[msg.sender]);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public ownerOnly {
59         super.transferOwnership(_newOwner);
60 
61         managers[_newOwner] = true;
62         managers[msg.sender] = false;
63     }
64 
65     function setManager(address manager, bool state) ownerOnly {
66         managers[manager] = state;
67         ManagerSet(manager, state);
68     }
69 }/*************************************************************************
70  * import "../common/Manageable.sol" : end
71  *************************************************************************/
72 /*************************************************************************
73  * import "./ValueToken.sol" : start
74  *************************************************************************/
75 
76 /*************************************************************************
77  * import "./ERC20StandardToken.sol" : start
78  *************************************************************************/
79 
80 /*************************************************************************
81  * import "./IERC20Token.sol" : start
82  *************************************************************************/
83 
84 /**@dev ERC20 compliant token interface. 
85 https://theethereum.wiki/w/index.php/ERC20_Token_Standard 
86 https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md */
87 contract IERC20Token {
88 
89     // these functions aren't abstract since the compiler emits automatically generated getter functions as external    
90     function name() public constant returns (string _name) { _name; }
91     function symbol() public constant returns (string _symbol) { _symbol; }
92     function decimals() public constant returns (uint8 _decimals) { _decimals; }
93     
94     function totalSupply() constant returns (uint total) {total;}
95     function balanceOf(address _owner) constant returns (uint balance) {_owner; balance;}    
96     function allowance(address _owner, address _spender) constant returns (uint remaining) {_owner; _spender; remaining;}
97 
98     function transfer(address _to, uint _value) returns (bool success);
99     function transferFrom(address _from, address _to, uint _value) returns (bool success);
100     function approve(address _spender, uint _value) returns (bool success);
101     
102 
103     event Transfer(address indexed _from, address indexed _to, uint _value);
104     event Approval(address indexed _owner, address indexed _spender, uint _value);
105 }
106 /*************************************************************************
107  * import "./IERC20Token.sol" : end
108  *************************************************************************/
109 /*************************************************************************
110  * import "../common/SafeMath.sol" : start
111  *************************************************************************/
112 
113 /**dev Utility methods for overflow-proof arithmetic operations 
114 */
115 contract SafeMath {
116 
117     /**dev Returns the sum of a and b. Throws an exception if it exceeds uint256 limits*/
118     function safeAdd(uint256 a, uint256 b) internal returns (uint256) {        
119         uint256 c = a + b;
120         assert(c >= a);
121 
122         return c;
123     }
124 
125     /**dev Returns the difference of a and b. Throws an exception if a is less than b*/
126     function safeSub(uint256 a, uint256 b) internal returns (uint256) {
127         assert(a >= b);
128         return a - b;
129     }
130 
131     /**dev Returns the product of a and b. Throws an exception if it exceeds uint256 limits*/
132     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
133         uint256 z = x * y;
134         assert((x == 0) || (z / x == y));
135         return z;
136     }
137 
138     function safeDiv(uint256 x, uint256 y) internal returns (uint256) {
139         assert(y != 0);
140         return x / y;
141     }
142 }/*************************************************************************
143  * import "../common/SafeMath.sol" : end
144  *************************************************************************/
145 
146 /**@dev Standard ERC20 compliant token implementation */
147 contract ERC20StandardToken is IERC20Token, SafeMath {
148     string public name;
149     string public symbol;
150     uint8 public decimals;
151 
152     //tokens already issued
153     uint256 tokensIssued;
154     //balances for each account
155     mapping (address => uint256) balances;
156     //one account approves the transfer of an amount to another account
157     mapping (address => mapping (address => uint256)) allowed;
158 
159     function ERC20StandardToken() {
160      
161     }    
162 
163     //
164     //IERC20Token implementation
165     // 
166 
167     function totalSupply() constant returns (uint total) {
168         total = tokensIssued;
169     }
170  
171     function balanceOf(address _owner) constant returns (uint balance) {
172         balance = balances[_owner];
173     }
174 
175     function transfer(address _to, uint256 _value) returns (bool) {
176         require(_to != address(0));
177 
178         // safeSub inside doTransfer will throw if there is not enough balance.
179         doTransfer(msg.sender, _to, _value);        
180         Transfer(msg.sender, _to, _value);
181         return true;
182     }
183 
184     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
185         require(_to != address(0));
186         
187         // Check for allowance is not needed because sub(_allowance, _value) will throw if this condition is not met
188         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);        
189         // safeSub inside doTransfer will throw if there is not enough balance.
190         doTransfer(_from, _to, _value);        
191         Transfer(_from, _to, _value);
192         return true;
193     }
194 
195     function approve(address _spender, uint256 _value) returns (bool success) {
196         allowed[msg.sender][_spender] = _value;
197         Approval(msg.sender, _spender, _value);
198         return true;
199     }
200 
201     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
202         remaining = allowed[_owner][_spender];
203     }    
204 
205     //
206     // Additional functions
207     //
208     /**@dev Gets real token amount in the smallest token units */
209     function getRealTokenAmount(uint256 tokens) constant returns (uint256) {
210         return tokens * (uint256(10) ** decimals);
211     }
212 
213     //
214     // Internal functions
215     //    
216     
217     function doTransfer(address _from, address _to, uint256 _value) internal {
218         balances[_from] = safeSub(balances[_from], _value);
219         balances[_to] = safeAdd(balances[_to], _value);
220     }
221 }/*************************************************************************
222  * import "./ERC20StandardToken.sol" : end
223  *************************************************************************/
224 /*************************************************************************
225  * import "../token/ValueTokenAgent.sol" : start
226  *************************************************************************/
227 
228 
229 
230 
231 /**@dev Watches transfer operation of tokens to validate value-distribution state */
232 contract ValueTokenAgent {
233 
234     /**@dev Token whose transfers that contract watches */
235     ValueToken public valueToken;
236 
237     /**@dev Allows only token to execute method */
238     modifier valueTokenOnly {require(msg.sender == address(valueToken)); _;}
239 
240     function ValueTokenAgent(ValueToken token) {
241         valueToken = token;
242     }
243 
244     /**@dev Called just before the token balance update*/   
245     function tokenIsBeingTransferred(address from, address to, uint256 amount);
246 
247     /**@dev Called when non-transfer token state change occurs: burn, issue, change of valuable tokens.
248     holder - address of token holder that committed the change
249     amount - amount of new or deleted tokens  */
250     function tokenChanged(address holder, uint256 amount);
251 }/*************************************************************************
252  * import "../token/ValueTokenAgent.sol" : end
253  *************************************************************************/
254 
255 
256 /**@dev Can be relied on to distribute values according to its balances 
257  Can set some reserve addreses whose tokens don't take part in dividend distribution */
258 contract ValueToken is Manageable, ERC20StandardToken {
259     
260     /**@dev Watches transfer operation of this token */
261     ValueTokenAgent valueAgent;
262 
263     /**@dev Holders of reserved tokens */
264     mapping (address => bool) public reserved;
265 
266     /**@dev Reserved token amount */
267     uint256 public reservedAmount;
268 
269     function ValueToken() {}
270 
271     /**@dev Sets new value agent */
272     function setValueAgent(ValueTokenAgent newAgent) managerOnly {
273         valueAgent = newAgent;
274     }
275 
276     function doTransfer(address _from, address _to, uint256 _value) internal {
277 
278         if (address(valueAgent) != 0x0) {
279             //first execute agent method
280             valueAgent.tokenIsBeingTransferred(_from, _to, _value);
281         }
282 
283         //first check if addresses are reserved and adjust reserved amount accordingly
284         if (reserved[_from]) {
285             reservedAmount = safeSub(reservedAmount, _value);
286             //reservedAmount -= _value;
287         } 
288         if (reserved[_to]) {
289             reservedAmount = safeAdd(reservedAmount, _value);
290             //reservedAmount += _value;
291         }
292 
293         //then do actual transfer
294         super.doTransfer(_from, _to, _value);
295     }
296 
297     /**@dev Returns a token amount that is accounted in the process of dividend calculation */
298     function getValuableTokenAmount() constant returns (uint256) {
299         return totalSupply() - reservedAmount;
300     }
301 
302     /**@dev Sets specific address to be reserved */
303     function setReserved(address holder, bool state) managerOnly {        
304 
305         uint256 holderBalance = balanceOf(holder);
306         if (address(valueAgent) != 0x0) {            
307             valueAgent.tokenChanged(holder, holderBalance);
308         }
309 
310         //change reserved token amount according to holder's state
311         if (state) {
312             //reservedAmount += holderBalance;
313             reservedAmount = safeAdd(reservedAmount, holderBalance);
314         } else {
315             //reservedAmount -= holderBalance;
316             reservedAmount = safeSub(reservedAmount, holderBalance);
317         }
318 
319         reserved[holder] = state;
320     }
321 }/*************************************************************************
322  * import "./ValueToken.sol" : end
323  *************************************************************************/
324 /*************************************************************************
325  * import "./ReturnableToken.sol" : start
326  *************************************************************************/
327 
328 
329 
330 /*************************************************************************
331  * import "./ReturnTokenAgent.sol" : start
332  *************************************************************************/
333 
334 
335 
336 
337 ///Returnable tokens receiver
338 contract ReturnTokenAgent is Manageable {
339     //ReturnableToken public returnableToken;
340 
341     /**@dev List of returnable tokens in format token->flag  */
342     mapping (address => bool) public returnableTokens;
343 
344     /**@dev Allows only token to execute method */
345     //modifier returnableTokenOnly {require(msg.sender == address(returnableToken)); _;}
346     modifier returnableTokenOnly {require(returnableTokens[msg.sender]); _;}
347 
348     /**@dev Executes when tokens are transferred to this */
349     function returnToken(address from, uint256 amountReturned);
350 
351     /**@dev Sets token that can call returnToken method */
352     function setReturnableToken(ReturnableToken token) managerOnly {
353         returnableTokens[address(token)] = true;
354     }
355 
356     /**@dev Removes token that can call returnToken method */
357     function removeReturnableToken(ReturnableToken token) managerOnly {
358         returnableTokens[address(token)] = false;
359     }
360 }/*************************************************************************
361  * import "./ReturnTokenAgent.sol" : end
362  *************************************************************************/
363 
364 ///Token that when sent to specified contract (returnAgent) invokes additional actions
365 contract ReturnableToken is Manageable, ERC20StandardToken {
366 
367     /**@dev List of return agents */
368     mapping (address => bool) public returnAgents;
369 
370     function ReturnableToken() {}    
371     
372     /**@dev Sets new return agent */
373     function setReturnAgent(ReturnTokenAgent agent) managerOnly {
374         returnAgents[address(agent)] = true;
375     }
376 
377     /**@dev Removes return agent from list */
378     function removeReturnAgent(ReturnTokenAgent agent) managerOnly {
379         returnAgents[address(agent)] = false;
380     }
381 
382     function doTransfer(address _from, address _to, uint256 _value) internal {
383         super.doTransfer(_from, _to, _value);
384         if (returnAgents[_to]) {
385             ReturnTokenAgent(_to).returnToken(_from, _value);                
386         }
387     }
388 }/*************************************************************************
389  * import "./ReturnableToken.sol" : end
390  *************************************************************************/
391 /*************************************************************************
392  * import "./IBurnableToken.sol" : start
393  *************************************************************************/
394 
395 /**@dev A token that can be burnt */
396 contract IBurnableToken {
397     function burn(uint256 _value);
398 }/*************************************************************************
399  * import "./IBurnableToken.sol" : end
400  *************************************************************************/
401 
402 /**@dev bcshop.io crowdsale token */
403 contract BCSToken is ValueToken, ReturnableToken, IBurnableToken {
404 
405     /**@dev Specifies allowed address that always can transfer tokens in case of global transfer lock */
406     mapping (address => bool) public transferAllowed;
407     /**@dev Specifies timestamp when specific token holder can transfer funds */    
408     mapping (address => uint256) public transferLockUntil; 
409     /**@dev True if transfer is locked for all holders, false otherwise */
410     bool public transferLocked;
411 
412     event Burn(address sender, uint256 value);
413 
414     /**@dev Creates a token with given initial supply  */
415     function BCSToken(uint256 _initialSupply, uint8 _decimals) {
416         name = "BCShop.io Token";
417         symbol = "BCS";
418         decimals = _decimals;        
419 
420         tokensIssued = _initialSupply * (uint256(10) ** decimals);
421         //store all tokens at the owner's address;
422         balances[msg.sender] = tokensIssued;
423 
424         transferLocked = true;
425         transferAllowed[msg.sender] = true;        
426     }
427 
428     /**@dev ERC20StandatdToken override */
429     function doTransfer(address _from, address _to, uint256 _value) internal {
430         require(canTransfer(_from));
431         super.doTransfer(_from, _to, _value);
432     }    
433 
434     /**@dev Returns true if given address can transfer tokens */
435     function canTransfer(address holder) constant returns (bool) {
436         if(transferLocked) {
437             return transferAllowed[holder];
438         } else {
439             return now > transferLockUntil[holder];
440         }
441         //return !transferLocked && now > transferLockUntil[holder];
442     }    
443 
444     /**@dev Lock transfer for a given holder for a given amount of days */
445     function lockTransferFor(address holder, uint256 daysFromNow) managerOnly {
446         transferLockUntil[holder] = daysFromNow * 1 days + now;
447     }
448 
449     /**@dev Sets transfer allowance for specific holder */
450     function allowTransferFor(address holder, bool state) managerOnly {
451         transferAllowed[holder] = state;
452     }
453 
454     /**@dev Locks or allows transfer for all holders, for emergency reasons*/
455     function setLockedState(bool state) managerOnly {
456         transferLocked = state;
457     }
458     
459     function burn(uint256 _value) managerOnly {        
460         require (balances[msg.sender] >= _value);            // Check if the sender has enough
461 
462         if (address(valueAgent) != 0x0) {            
463             valueAgent.tokenChanged(msg.sender, _value);
464         }
465 
466         balances[msg.sender] -= _value;                      // Subtract from the sender
467         tokensIssued -= _value;                              // Updates totalSupply        
468 
469         Burn(msg.sender, _value);        
470     }
471 }