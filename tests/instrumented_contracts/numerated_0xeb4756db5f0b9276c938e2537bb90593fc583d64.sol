1 pragma solidity ^0.4.13;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   /**
8    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
9    * account.
10    */
11   function Ownable() {
12     owner = msg.sender;
13   }
14 
15 
16   /**
17    * @dev Throws if called by any account other than the owner.
18    */
19   modifier onlyOwner() {
20     require(msg.sender == owner);
21     _;
22   }
23 
24 
25   /**
26    * @dev Allows the current owner to transfer control of the contract to a newOwner.
27    * @param newOwner The address to transfer ownership to.
28    */
29   function transferOwnership(address newOwner) onlyOwner {
30     require(newOwner != address(0));      
31     owner = newOwner;
32   }
33 
34 }
35 
36 contract ERC20Basic {
37   function totalSupply() public view returns (uint256);
38   function balanceOf(address who) public view returns (uint256);
39   function transfer(address to, uint256 value) public returns (bool);
40   event Transfer(address indexed from, address indexed to, uint256 value);
41 }
42 
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   uint256 totalSupply_;
49 
50   /**
51   * @dev total number of tokens in existence
52   */
53   function totalSupply() public view returns (uint256) {
54     return totalSupply_;
55   }
56 
57   /**
58   * @dev transfer token for a specified address
59   * @param _to The address to transfer to.
60   * @param _value The amount to be transferred.
61   */
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     // SafeMath.sub will throw if there is not enough balance.
67     balances[msg.sender] = balances[msg.sender].sub(_value);
68     balances[_to] = balances[_to].add(_value);
69     Transfer(msg.sender, _to, _value);
70     return true;
71   }
72 
73   /**
74   * @dev Gets the balance of the specified address.
75   * @param _owner The address to query the the balance of.
76   * @return An uint256 representing the amount owned by the passed address.
77   */
78   function balanceOf(address _owner) public view returns (uint256 balance) {
79     return balances[_owner];
80   }
81 
82 }
83 
84 library SafeMath {
85   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
86     uint256 c = a * b;
87     assert(a == 0 || c / a == b);
88     return c;
89   }
90 
91   function div(uint256 a, uint256 b) internal constant returns (uint256) {
92     // assert(b > 0); // Solidity automatically throws when dividing by 0
93     uint256 c = a / b;
94     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
95     return c;
96   }
97 
98   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
99     assert(b <= a);
100     return a - b;
101   }
102 
103   function add(uint256 a, uint256 b) internal constant returns (uint256) {
104     uint256 c = a + b;
105     assert(c >= a);
106     return c;
107   }
108 }
109 
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) internal allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
129     require(_to != address(0));
130     require(_value <= balances[_from]);
131     require(_value <= allowed[_from][msg.sender]);
132 
133     balances[_from] = balances[_from].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
136     Transfer(_from, _to, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
142    *
143    * Beware that changing an allowance with this method brings the risk that someone may use both the old
144    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
145    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
146    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint256 _value) public returns (bool) {
151     allowed[msg.sender][_spender] = _value;
152     Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Function to check the amount of tokens that an owner allowed to a spender.
158    * @param _owner address The address which owns the funds.
159    * @param _spender address The address which will spend the funds.
160    * @return A uint256 specifying the amount of tokens still available for the spender.
161    */
162   function allowance(address _owner, address _spender) public view returns (uint256) {
163     return allowed[_owner][_spender];
164   }
165 
166   /**
167    * @dev Increase the amount of tokens that an owner allowed to a spender.
168    *
169    * approve should be called when allowed[_spender] == 0. To increment
170    * allowed value is better to use this function to avoid 2 calls (and wait until
171    * the first transaction is mined)
172    * From MonolithDAO Token.sol
173    * @param _spender The address which will spend the funds.
174    * @param _addedValue The amount of tokens to increase the allowance by.
175    */
176   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
177     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
178     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182   /**
183    * @dev Decrease the amount of tokens that an owner allowed to a spender.
184    *
185    * approve should be called when allowed[_spender] == 0. To decrement
186    * allowed value is better to use this function to avoid 2 calls (and wait until
187    * the first transaction is mined)
188    * From MonolithDAO Token.sol
189    * @param _spender The address which will spend the funds.
190    * @param _subtractedValue The amount of tokens to decrease the allowance by.
191    */
192   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
193     uint oldValue = allowed[msg.sender][_spender];
194     if (_subtractedValue > oldValue) {
195       allowed[msg.sender][_spender] = 0;
196     } else {
197       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
198     }
199     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
200     return true;
201   }
202 
203 }
204 
205 contract ReleasableToken is ERC20, Ownable {
206 
207   /* The finalizer contract that allows unlift the transfer limits on this token */
208   address public releaseAgent;
209 
210   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
211   bool public released = false;
212 
213   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
214   mapping (address => bool) public transferAgents;
215   
216   //dtco : time lock with specific address
217   mapping(address => uint) public lock_addresses;
218   
219   event AddLockAddress(address addr, uint lock_time);  
220 
221   /**
222    * Limit token transfer until the crowdsale is over.
223    *
224    */
225   modifier canTransfer(address _sender) {
226 
227     if(!released) {
228         if(!transferAgents[_sender]) {
229             revert();
230         }
231     }
232 	else {
233 		//check time lock with team
234 		if(now < lock_addresses[_sender]) {
235 			revert();
236 		}
237 	}
238     _;
239   }
240   
241   function ReleasableToken() {
242 	releaseAgent = msg.sender;
243   }
244   
245   //lock new team release time
246   function addLockAddressInternal(address addr, uint lock_time) inReleaseState(false) internal {
247 	if(addr == 0x0) revert();
248 	lock_addresses[addr]= lock_time;
249 	AddLockAddress(addr, lock_time);
250   }
251   
252   
253   /**
254    * Set the contract that can call release and make the token transferable.
255    *
256    * Design choice. Allow reset the release agent to fix fat finger mistakes.
257    */
258   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
259 
260     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
261     releaseAgent = addr;
262   }
263 
264   /**
265    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
266    */
267   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
268     transferAgents[addr] = state;
269   }
270   
271   /** The function can be called only by a whitelisted release agent. */
272   modifier onlyReleaseAgent() {
273     if(msg.sender != releaseAgent) {
274         revert();
275     }
276     _;
277   }
278 
279   /**
280    * One way function to release the tokens to the wild.
281    *
282    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
283    */
284   function releaseTokenTransfer() public onlyReleaseAgent {
285     released = true;
286   }
287 
288   /** The function can be called only before or after the tokens have been releasesd */
289   modifier inReleaseState(bool releaseState) {
290     if(releaseState != released) {
291         revert();
292     }
293     _;
294   }  
295 
296   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
297     // Call StandardToken.transfer()
298    return super.transfer(_to, _value);
299   }
300 
301   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
302     // Call StandardToken.transferForm()
303     return super.transferFrom(_from, _to, _value);
304   }
305 
306 }
307 
308 contract MintableToken is StandardToken, Ownable {
309   bool public mintingFinished = false;
310   
311   /** List of agents that are allowed to create new tokens */
312   mapping (address => bool) public mintAgents;
313 
314   event MintingAgentChanged(address addr, bool state  );
315   event Mint(address indexed to, uint256 amount);
316   event MintFinished();
317 
318   modifier onlyMintAgent() {
319     // Only crowdsale contracts are allowed to mint new tokens
320     if(!mintAgents[msg.sender]) {
321         revert();
322     }
323     _;
324   }
325   
326   modifier canMint() {
327     require(!mintingFinished);
328     _;
329   }
330   
331   /**
332    * Owner can allow a crowdsale contract to mint new tokens.
333    */
334   function setMintAgent(address addr, bool state) onlyOwner canMint public {
335     mintAgents[addr] = state;
336     MintingAgentChanged(addr, state);
337   }
338 
339   /**
340    * @dev Function to mint tokens
341    * @param _to The address that will recieve the minted tokens.
342    * @param _amount The amount of tokens to mint.
343    * @return A boolean that indicates if the operation was successful.
344    */
345   function mint(address _to, uint256 _amount) onlyMintAgent canMint public returns (bool) {
346     totalSupply_ = totalSupply_.add(_amount);
347     balances[_to] = balances[_to].add(_amount);
348     Mint(_to, _amount);
349 	
350 	Transfer(address(0), _to, _amount);
351     return true;
352   }
353 
354   /**
355    * @dev Function to stop minting new tokens.
356    * @return True if the operation was successful.
357    */
358   function finishMinting() onlyMintAgent public returns (bool) {
359     mintingFinished = true;
360     MintFinished();
361     return true;
362   }
363 }
364 
365 contract CrowdsaleToken is ReleasableToken, MintableToken {
366 
367   string public name;
368 
369   string public symbol;
370 
371   uint public decimals;
372     
373   /**
374    * Construct the token.
375    *
376    * @param _name Token name
377    * @param _symbol Token symbol - should be all caps
378    * @param _initialSupply How many tokens we start with
379    * @param _decimals Number of decimal places
380    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
381    */
382   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) {
383 
384     owner = msg.sender;
385 
386     name = _name;
387     symbol = _symbol;
388 
389     totalSupply_ = _initialSupply;
390 
391     decimals = _decimals;
392 
393     balances[owner] = totalSupply_;
394 
395     if(totalSupply_ > 0) {
396       Mint(owner, totalSupply_);
397     }
398 
399     // No more new supply allowed after the token creation
400     if(!_mintable) {
401       mintingFinished = true;
402       if(totalSupply_ == 0) {
403         revert(); // Cannot create a token without supply and no minting
404       }
405     }
406   }
407 
408   /**
409    * When token is released to be transferable, enforce no new tokens can be created.
410    */
411    
412   function releaseTokenTransfer() public onlyReleaseAgent {
413     mintingFinished = true;
414     super.releaseTokenTransfer();
415   }
416   
417   //lock team address by crowdsale
418   function addLockAddress(address addr, uint lock_time) onlyMintAgent inReleaseState(false) public {
419 	super.addLockAddressInternal(addr, lock_time);
420   }
421 
422 }