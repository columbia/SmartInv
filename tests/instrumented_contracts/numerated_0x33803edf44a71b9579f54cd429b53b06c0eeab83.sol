1 pragma solidity ^0.4.15;
2 
3 /**
4 * GoldGate Token Contract
5 * Copyright © 2017 by GoldGate https://goldgate.io
6 */
7 
8 /**
9  * @title ERC20Basic
10  * Simpler version of ERC20 interface
11  * https://github.com/ethereum/EIPs/issues/179
12  */
13 contract ERC20Basic {
14   uint256 public totalSupply;
15   function balanceOf(address who) constant returns (uint256);
16   function transfer(address to, uint256 value) returns (bool);
17   event Transfer(address indexed from, address indexed to, uint256 value);
18 }
19 
20 /**
21  * @title ERC20 interface
22  * https://github.com/ethereum/EIPs/issues/20
23  */
24 contract ERC20 is ERC20Basic {
25   function allowance(address owner, address spender) constant returns (uint256);
26   function transferFrom(address from, address to, uint256 value) returns (bool);
27   function approve(address spender, uint256 value) returns (bool);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 /**
32  * @title Basic token
33  * Basic version of StandardToken, with no allowances. 
34  */
35 contract BasicToken is ERC20Basic {
36   using SafeMath for uint256;
37 
38   mapping(address => uint256) balances;
39 
40   /**
41   * transfer token for a specified address
42   */
43   function transfer(address _to, uint256 _value) returns (bool) {
44     require(_to != address(0));
45 
46     // SafeMath.sub will throw if there is not enough balance.
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * Gets the balance of the specified address.
55   */
56   function balanceOf(address _owner) constant returns (uint256 balance) {
57     return balances[_owner];
58   }
59 
60 }
61 
62 /**
63  * @title Ownable
64  * The Ownable contract has an owner address, and provides basic authorization control
65  */
66 contract Ownable {
67   address public owner;
68 
69 
70   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72 
73   /**
74    * The Ownable constructor sets the original `owner` of the contract to the sender
75    * account.
76    */
77   function Ownable() {
78     owner = msg.sender;
79   }
80 
81   /**
82    * Throws if called by any account other than the owner.
83    */
84   modifier onlyOwner() {
85     require(msg.sender == owner);
86     _;
87   }
88 
89 
90   /**
91    * Allows the current owner to transfer control of the contract to a newOwner.
92    */
93   function transferOwnership(address newOwner) onlyOwner {
94     require(newOwner != address(0));      
95     OwnershipTransferred(owner, newOwner);
96     owner = newOwner;
97   }
98 
99 }
100 
101 /**
102  * @title Pausable
103  * Base contract which allows children to implement an emergency stop mechanism.
104  */
105 contract Pausable is Ownable {
106   event Pause();
107   event Unpause();
108 
109   bool public paused = false;
110 
111 
112   /**
113    * Modifier to make a function callable only when the contract is not paused.
114    */
115   modifier whenNotPaused() {
116     require(!paused);
117     _;
118   }
119 
120   /**
121    * Modifier to make a function callable only when the contract is paused.
122    */
123   modifier whenPaused() {
124     require(paused);
125     _;
126   }
127 
128   /**
129    * called by the owner to pause, triggers stopped state
130    */
131   function pause() onlyOwner whenNotPaused {
132     paused = true;
133     Pause();
134   }
135 
136   /**
137    * called by the owner to unpause, returns to normal state
138    */
139   function unpause() onlyOwner whenPaused {
140     paused = false;
141     Unpause();
142   }
143 }
144 
145 /**
146  * @title Ownable
147  */
148 contract GGOwnable is Ownable {
149 
150   address public newOwner;
151 
152   /**
153    * Allows the current owner to transfer control of the contract to an otherOwner.
154    */
155   function transferOwnership(address otherOwner) onlyOwner {
156     require(otherOwner != address(0));      
157     newOwner = otherOwner;
158   }
159 
160   /**
161    * Finish ownership transfer.
162    */
163   function approveOwnership() {
164     require(msg.sender == newOwner);
165     OwnershipTransferred(owner, newOwner);
166     owner = newOwner;
167     newOwner = address(0);
168   }
169 }
170 
171 
172 /**
173  * @title Moderated
174  * Moderator can make transfers from and to any account (including frozen).
175  */
176 contract GGModerated is GGOwnable {
177 
178   address public moderator;
179   address public newModerator;
180 
181   /**
182    * Throws if called by any account other than the moderator.
183    */
184   modifier onlyModerator() {
185     require(msg.sender == moderator);
186     _;
187   }
188 
189   /**
190    * Throws if called by any account other than the owner or moderator.
191    */
192   modifier onlyOwnerOrModerator() {
193     require((msg.sender == moderator) || (msg.sender == owner));
194     _;
195   }
196 
197   /**
198    * Moderator same as owner
199    */
200   function GGModerated(){
201     moderator = msg.sender;
202   }
203 
204   /**
205    * Allows the current moderator to transfer control of the contract to an otherModerator.
206    */
207   function transferModeratorship(address otherModerator) onlyModerator {
208     newModerator = otherModerator;
209   }
210 
211   /**
212    * Complete moderatorship transfer.
213    */
214   function approveModeratorship() {
215     require(msg.sender == newModerator);
216     moderator = newModerator;
217     newModerator = address(0);
218   }
219 
220   /**
221    * Removes moderator from the contract.
222    */
223   function removeModeratorship() onlyOwner {
224       moderator = address(0);
225   }
226 
227   function hasModerator() constant returns(bool) {
228       return (moderator != address(0));
229   }
230 }
231 
232 /**
233  * @title Pausable
234  */
235 contract GGPausable is Pausable, GGModerated {
236   /**
237    * called by the owner or moderator to pause, triggers stopped state
238    */
239   function pause() onlyOwnerOrModerator whenNotPaused {
240     paused = true;
241     Pause();
242   }
243 
244   /**
245    * called by the owner or moderator to unpause, returns to normal state
246    */
247   function unpause() onlyOwnerOrModerator whenPaused {
248     paused = false;
249     Unpause();
250   }
251 }
252 
253 /**
254  * @title Standard ERC20 token
255  * Implementation of the basic standard token.
256  */
257 contract StandardToken is ERC20, BasicToken {
258 
259   mapping (address => mapping (address => uint256)) allowed;
260 
261   /**
262    * transfer tokens from one address to another
263    */
264   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
265     require(_to != address(0));
266 
267     var _allowance = allowed[_from][msg.sender];
268 
269     balances[_from] = balances[_from].sub(_value);
270     balances[_to] = balances[_to].add(_value);
271     allowed[_from][msg.sender] = _allowance.sub(_value);
272     Transfer(_from, _to, _value);
273     return true;
274   }
275 
276   /**
277    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
278    */
279   function approve(address _spender, uint256 _value) returns (bool) {
280     // to change the approve amount you first have to reduce the addresses`
281     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
282 
283     allowed[msg.sender][_spender] = _value;
284     Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288   /**
289    * function to check the amount of tokens that an owner allowed to a spender.
290    */
291   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
292     return allowed[_owner][_spender];
293   }
294   
295   function increaseApproval (address _spender, uint _addedValue) 
296     returns (bool success) {
297     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
298     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302   function decreaseApproval (address _spender, uint _subtractedValue) 
303     returns (bool success) {
304     uint oldValue = allowed[msg.sender][_spender];
305     if (_subtractedValue > oldValue) {
306       allowed[msg.sender][_spender] = 0;
307     } else {
308       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
309     }
310     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311     return true;
312   }
313 
314 }
315 
316 /**
317  * @title SafeMath
318  * Math operations with safety checks that throw on error
319  */
320 library SafeMath {
321   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
322     uint256 c = a * b;
323     assert(a == 0 || c / a == b);
324     return c;
325   }
326 
327   function div(uint256 a, uint256 b) internal constant returns (uint256) {
328     // assert(b > 0); // Solidity automatically throws when dividing by 0
329     uint256 c = a / b;
330     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
331     return c;
332   }
333 
334   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
335     assert(b <= a);
336     return a - b;
337   }
338 
339   function add(uint256 a, uint256 b) internal constant returns (uint256) {
340     uint256 c = a + b;
341     assert(c >= a);
342     return c;
343   }
344 }
345 
346 /**
347  * Pausable token with moderator role and freeze address implementation
348  **/
349 contract ModToken is StandardToken, GGPausable {
350 
351   mapping(address => bool) frozen;
352 
353   /**
354    * check if given address is frozen. Freeze works only if moderator role is active
355    */
356   function isFrozen(address _addr) constant returns (bool){
357       return frozen[_addr] && hasModerator();
358   }
359 
360   /**
361    * Freezes address (no transfer can be made from or to this address).
362    */
363   function freeze(address _addr) onlyModerator {
364       frozen[_addr] = true;
365   }
366 
367   /**
368    * Unfreezes frozen address.
369    */
370   function unfreeze(address _addr) onlyModerator {
371       frozen[_addr] = false;
372   }
373 
374   /**
375    * Declines transfers from/to frozen addresses.
376    */
377   function transfer(address _to, uint256 _value) whenNotPaused returns (bool) {
378     require(!isFrozen(msg.sender));
379     require(!isFrozen(_to));
380     return super.transfer(_to, _value);
381   }
382 
383   /**
384    * Declines transfers from/to/by frozen addresses.
385    */
386   function transferFrom(address _from, address _to, uint256 _value) whenNotPaused returns (bool) {
387     require(!isFrozen(msg.sender));
388     require(!isFrozen(_from));
389     require(!isFrozen(_to));
390     return super.transferFrom(_from, _to, _value);
391   }
392 
393   /**
394    * Allows moderator to transfer tokens from one address to another.
395    */
396   function moderatorTransferFrom(address _from, address _to, uint256 _value) onlyModerator returns (bool) {
397     balances[_to] = balances[_to].add(_value);
398     balances[_from] = balances[_from].sub(_value);
399     Transfer(_from, _to, _value);
400     return true;
401   }
402 }
403 
404 contract GoldGate is ModToken {
405   string public constant version = "1.0.0";
406   string public constant name = "GoldGate";
407   string public constant symbol = "BGG";
408   uint256 public constant decimals = 8;
409 
410   function GoldGate(uint256 _initialSupply) {   
411     totalSupply = _initialSupply;
412     balances[msg.sender] = _initialSupply;
413   }
414 }