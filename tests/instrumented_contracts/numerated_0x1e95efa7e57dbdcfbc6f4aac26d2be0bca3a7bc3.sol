1 pragma solidity ^0.4.24;
2 
3 
4 // Interface for burning tokens
5 contract Burnable {
6   // @dev Destroys tokens for an account
7   // @param account Account whose tokens are destroyed
8   // @param value Amount of tokens to destroy
9   function _burnTokens(address account, uint value) internal;
10   event Burned(address account, uint value);
11 }
12 
13 /**
14  * @title Ownable
15  * @dev The Ownable contract has an owner address, and provides basic authorization control
16  * functions, this simplifies the implementation of "user permissions".
17  */
18 contract Ownable {
19   address public owner;
20 
21   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23   /**
24    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
25    * account.
26    */
27   constructor() public {
28     owner = msg.sender;
29   }
30 
31   event Error(string _t);
32 
33   /**
34    * @dev Throws if called by any account other than the owner.
35    */
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   /**
42    * @dev Allows the current owner to transfer control of the contract to a newOwner.
43    * @param newOwner The address to transfer ownership to.
44    */
45   function transferOwnership(address newOwner) public onlyOwner {
46     require(newOwner != address(0));
47     emit OwnershipTransferred(owner, newOwner);
48     owner = newOwner;
49   }
50 
51 }
52 
53 contract HoldAssistant is Ownable {
54 
55 	struct stholdPeriod {
56         uint256 startsAtTime;
57         uint256 endsAtTime;
58 		uint256 balance;
59     }
60     mapping (address => stholdPeriod) private holdPeriod;
61 
62 	event Log_AdminHold(address _holder, uint _balance, bool _status);
63 	function adminHold(address _holder, uint _balance, bool _status) public returns (bool) {
64 		emit Log_AdminHold(_holder, _balance, _status);
65 		return true;
66 	}
67 
68 	event Log_Hold(address _holder, uint _balance, bool _status);
69 	function hold(address _holder, uint _balance, bool _status) public returns (bool) {
70 		emit Log_Hold(_holder, _balance, _status);
71 		return true;
72 	}
73 
74 }
75 
76 contract Pausable is Ownable {
77   event Pause();
78   event Unpause();
79 
80   bool public paused = false;
81 
82 
83   /**
84    * @dev Modifier to make a function callable only when the contract is not paused.
85    */
86   modifier whenNotPaused() {
87     require(!paused);
88     _;
89   }
90 
91   /**
92    * @dev Modifier to make a function callable only when the contract is paused.
93    */
94   modifier whenPaused() {
95     require(paused);
96     _;
97   }
98 
99   /**
100    * @dev called by the owner to pause, triggers stopped state
101    */
102   function pause() onlyOwner whenNotPaused public {
103     paused = true;
104     emit Pause();
105   }
106 
107   /**
108    * @dev called by the owner to unpause, returns to normal state
109    */
110   function unpause() onlyOwner whenPaused public {
111     paused = false;
112     emit Unpause();
113   }
114 }
115 
116 contract StandardToken is Burnable, Pausable {
117     using SafeMath for uint;
118 
119     uint private total_supply;
120     uint public decimals;
121 
122     // This creates an array with all balances
123     mapping (address => uint) private balances;
124     mapping (address => mapping (address => uint)) private allowed;
125 
126     // This generates a public event on the blockchain that will notify clients
127     event Transfer(address indexed from, address indexed to, uint value);
128     event Approval(address indexed owner, address indexed spender, uint value);
129 
130     //Constructor
131     constructor(uint supply, uint token_decimals, address token_retriever) public {
132         decimals                    = token_decimals;
133         total_supply                = supply * uint(10) ** decimals ; // 10 ** 9,  1000 millions
134         balances[token_retriever]   = total_supply;                   // Give to the creator all initial tokens
135     }
136 
137     function totalSupply() public view returns (uint) {
138         return total_supply;
139     }
140 
141     //Public interface for balances
142     function balanceOf(address account) public view returns (uint balance) {
143         return balances[account];
144     }
145 
146     //Public interface for allowances
147     function allowance(address account, address spender) public view returns (uint remaining) {
148         return allowed[account][spender];
149     }
150 
151     //Internal transfer, only can be called by this contract
152     function _transfer(address _from, address _to, uint _value) internal {
153         require(_to != 0x0);                        //Burn is an specific op
154         require(balances[_from] >= _value);        //Enough ?
155         require(balances[_to].add(_value) >= balances[_to]);
156 
157         // Save this for an assertion in the future
158         uint previousBalances = balances[_from].add(balances[_to]);
159 
160         balances[_from] = balances[_from].sub(_value);
161         balances[_to]  = balances[_to].add(_value);
162 
163         emit Transfer(_from, _to, _value);
164 
165         // Asserts are used to use static analysis to find bugs in your code. They should never fail
166         assert(balances[_from].add(balances[_to]) == previousBalances);
167     }
168 
169     function transfer(address _to, uint _value) public whenNotPaused returns (bool success){
170         _transfer(msg.sender, _to, _value);
171         return true;
172     }
173 
174     function transferFrom(address _from, address _to, uint _value) public whenNotPaused returns (bool success) {
175         require(_value <= allowed[_from][msg.sender]);     // Check allowance
176         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub( _value);
177         _transfer(_from, _to, _value);
178         return true;
179     }
180 
181     function _approve(address _holder, address _spender, uint _value) internal {
182         require(_value <= total_supply);
183         require(_value >= 0);
184         allowed[_holder][_spender] = _value;
185         emit Approval(_holder, _spender,_value);
186     }
187     function approve(address _spender, uint _value) public returns (bool success) {
188         _approve(msg.sender, _spender, _value);
189         return true;
190     }
191 
192     function safeApprove(address _spender, uint _currentValue, uint _value)  public returns (bool success) {
193         require(allowed[msg.sender][_spender] == _currentValue);
194         _approve(msg.sender, _spender, _value);
195         return true;
196     }
197 
198     /**
199      * Destroy tokens
200      */
201     function _burnTokens(address from, uint _value) internal {
202         require(balances[from] >= _value);                    // Check if the sender has enough
203         balances[from] = balances[from].sub(_value);    // Subtract from the sender
204         total_supply = total_supply.sub(_value);                    // Updates totalSupply
205         emit  Burned(from, _value);
206     }
207 
208     function burn(uint _value) public whenNotPaused returns (bool success) {
209         _burnTokens(msg.sender,_value);
210         return true;
211     }
212 }
213 
214 //Define interface for releasing the token transfer after a successful crowdsale.
215 contract HoldableToken is StandardToken {
216 
217 	//Specific block to support holdwallet
218     mapping (address => bool) private holdFlag;
219 
220     //Another contract can do a finer track of the hold
221     address public holdAssistantAddr = address(0);
222 
223 	function holded(address _account) public view returns(bool) {
224 		return holdFlag[_account];
225 	}
226 
227     function adminHold(bool _status) public onlyOwner returns (bool) {
228         holdFlag[msg.sender] = _status;
229 
230         //Just in case that fine tracker exists
231         if (address(0) != holdAssistantAddr) {
232             HoldAssistant(holdAssistantAddr).adminHold(msg.sender, balanceOf(msg.sender), _status);
233         }
234         emit Log_AdminHold(msg.sender, block.number, balanceOf(msg.sender), _status);
235 		return true;
236     }
237     function hold(bool _status) public returns (bool) {
238         holdFlag[msg.sender] = _status;
239 
240         //Just in case that fine tracker exists
241         if (address(0) != holdAssistantAddr) {
242             require(HoldAssistant(holdAssistantAddr).hold(msg.sender, balanceOf(msg.sender), _status));
243         }
244         emit Log_Hold(msg.sender, block.number, balanceOf(msg.sender), _status);
245 		return true;
246     }
247     event Log_Hold(address indexed _account, uint _holdBlock, uint _balance, bool _holded);
248     event Log_AdminHold(address indexed _account, uint _holdBlock, uint _balance, bool _holded);
249 
250     function setHoldAssistant(address _newHoldAssistant) public onlyOwner returns(bool) {
251         holdAssistantAddr = _newHoldAssistant;
252         emit Log_SetHoldAssistant(holdAssistantAddr);
253 		return true;
254     }
255     event Log_SetHoldAssistant(address);
256 
257     modifier notHolded(address _account) {
258         require(! holdFlag[_account]);
259         _;
260     }
261 
262 
263   	//We restrict transfers by overriding it
264   	function transfer(address to, uint value) public notHolded(msg.sender) returns (bool success) {
265   		return super.transfer(to, value);
266   	}
267 
268   	//We restrict transferFrom by overriding it
269   	//"from" must be an agent before released
270   	function transferFrom(address from, address to, uint value) public notHolded(from) returns (bool success) {
271    	 	return super.transferFrom(from, to, value);
272   	}
273 
274   	//We restrict burn by overriding it
275   	function burn(uint value) public notHolded(msg.sender) returns (bool success) {
276     	return super.burn(value);
277   	}
278 
279 }
280 
281 /**
282  * Math operations with safety checks
283  */
284 library SafeMath {
285   function mul(uint a, uint b) internal pure returns (uint) {
286     uint c = a * b;
287     assert(a == 0 || c / a == b);
288     return c;
289   }
290 
291   function div(uint a, uint b) internal pure returns (uint) {
292     // assert(b > 0); // Solidity automatically throws when dividing by 0
293     uint c = a / b;
294     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295     return c;
296   }
297 
298   function sub(uint a, uint b) internal pure returns (uint) {
299     assert(b <= a);
300     return a - b;
301   }
302 
303   function add(uint a, uint b) internal pure returns (uint) {
304     uint c = a + b;
305     assert(c >= a && c>=b);
306     return c;
307   }
308 }
309 
310 /**
311  * @title Pausable
312  * @dev Base contract which allows children to implement an emergency stop mechanism.
313  */
314 
315 //Define interface for Manage + release a resource normal operation after an external trigger
316 contract Releasable is Ownable {
317 
318   address public releaseAgent;
319   bool public released = false;
320   mapping (address => bool) public Agents;
321 
322   event ReleaseAgent(address previous, address newAgent);
323 
324   //Set the contract that can call release and make the resource operative
325   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
326     releaseAgent = addr;
327     emit ReleaseAgent(releaseAgent, addr);
328   }
329 
330   // Owner can allow a particular address (e.g. a crowdsale contract) to be Agent to manage the resource
331   function setAgent(address addr) onlyOwner inReleaseState(false) public returns(bool){
332     Agents[addr] = true;
333     emit Agent(addr,true);
334     return true;
335   }
336 
337   // Owner forbids a particular address (e.g. a crowdsale contract) to be Agent to manage the resource
338   function resetAgent(address addr) onlyOwner inReleaseState(false) public returns(bool){
339     Agents[addr] = false;
340     emit Agent(addr,false);
341     return true;
342   }
343     event Agent(address addr, bool status);
344 
345   function amIAgent() public view returns (bool) {
346     return Agents[msg.sender];
347   }
348 
349   function isAgent(address addr) public view /*onlyOwner */ returns(bool) {
350     return Agents[addr];
351   }
352 
353   //From now the resource is free
354   function releaseOperation() public onlyReleaseAgent {
355         released = true;
356 		emit Released();
357   }
358   event Released();
359 
360   // Limit resource operative until the release
361   modifier canOperate(address sender) {
362     require(released || Agents[sender]);
363     _;
364   }
365 
366   //The function can be called only before or after the tokens have been released
367   modifier inReleaseState(bool releaseState) {
368     require(releaseState == released);
369     _;
370   }
371 
372   //The function can be called only by a whitelisted release agent.
373   modifier onlyReleaseAgent() {
374     require(msg.sender == releaseAgent);
375     _;
376   }
377 }
378 
379 //Define interface for releasing the token transfer after a successful crowdsale.
380 contract ReleasableToken is Releasable, HoldableToken {
381 
382   //We restrict transfer by overriding it
383   function transfer(address to, uint value) public canOperate(msg.sender) returns (bool success) {
384    return super.transfer(to, value);
385   }
386 
387   //We restrict transferFrom by overriding it
388   //"from" must be an agent before released
389   function transferFrom(address from, address to, uint value) public canOperate(from) returns (bool success) {
390     return super.transferFrom(from, to, value);
391   }
392 
393   //We restrict burn by overriding it
394   function burn(uint value) public canOperate(msg.sender) returns (bool success) {
395     return super.burn(value);
396   }
397 }
398 
399 
400 contract ALIVE is ReleasableToken {
401 
402     string public name = "ALIVE";
403     string public symbol = "AL ";
404 
405     //    Constructor
406     constructor (uint supply, uint token_decimals, address token_retriever) StandardToken(supply, token_decimals, token_retriever) public { }
407     
408 }