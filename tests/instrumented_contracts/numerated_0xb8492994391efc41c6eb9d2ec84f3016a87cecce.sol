1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC20Basic {
30   uint256 public totalSupply;
31   function balanceOf(address who) constant returns (uint256);
32   function transfer(address to, uint256 value) returns (bool);
33   event Transfer(address indexed from, address indexed to, uint256 value);
34 }
35 
36 contract BasicToken is ERC20Basic {
37   using SafeMath for uint256;
38 
39   mapping(address => uint256) balances;
40 
41   /**
42   * @dev transfer token for a specified address
43   * @param _to The address to transfer to.
44   * @param _value The amount to be transferred.
45   */
46   function transfer(address _to, uint256 _value) /* internal? */ returns (bool) {
47     balances[msg.sender] = balances[msg.sender].sub(_value);
48     balances[_to] = balances[_to].add(_value);
49     Transfer(msg.sender, _to, _value);
50     return true;
51   }
52 
53   /**
54   * @dev Gets the balance of the specified address.
55   * @param _owner The address to query the the balance of. 
56   * @return An uint256 representing the amount owned by the passed address.
57   */
58   function balanceOf(address _owner) constant returns (uint256 balance) {
59     return balances[_owner];
60   }
61 
62 }
63 
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender) constant returns (uint256);
66   function transferFrom(address from, address to, uint256 value) returns (bool);
67   function approve(address spender, uint256 value) returns (bool);
68   event Approval(address indexed owner, address indexed spender, uint256 value);
69 }
70 
71 contract Ownable {
72   address public owner;
73 
74 
75   /**
76    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77    * account.
78    */
79   function Ownable() {
80     owner = msg.sender;
81   }
82 
83 
84   /**
85    * @dev Throws if called by any account other than the owner.
86    */
87   modifier onlyOwner() {
88     require(msg.sender == owner);
89     _;
90   }
91 
92 
93   /**
94    * @dev Allows the current owner to transfer control of the contract to a newOwner.
95    * @param newOwner The address to transfer ownership to.
96    */
97   function transferOwnership(address newOwner) onlyOwner {
98     require(newOwner != address(0));      
99     owner = newOwner;
100   }
101 
102 }
103 
104 contract ReleasableToken is ERC20, Ownable {
105 
106   /* The finalizer contract that allows unlift the transfer limits on this token */
107   address public releaseAgent;
108 
109   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
110   bool public released = false;
111 
112   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
113   mapping (address => bool) public transferAgents;
114   
115   //dtco : time lock with specific address
116   mapping(address => uint) public lock_addresses;
117   
118   event AddLockAddress(address addr, uint lock_time);  
119 
120   /**
121    * Limit token transfer until the crowdsale is over.
122    *
123    */
124   modifier canTransfer(address _sender) {
125 
126     if(!released) {
127         if(!transferAgents[_sender]) {
128             revert();
129         }
130     }
131 	else {
132 		//check time lock with team
133 		if(now < lock_addresses[_sender]) {
134 			revert();
135 		}
136 	}
137     _;
138   }
139   
140   function ReleasableToken() {
141 	releaseAgent = msg.sender;
142   }
143   
144   //lock new team release time
145   function addLockAddressInternal(address addr, uint lock_time) inReleaseState(false) internal {
146 	if(addr == 0x0) revert();
147 	lock_addresses[addr]= lock_time;
148 	AddLockAddress(addr, lock_time);
149   }
150   
151   
152   /**
153    * Set the contract that can call release and make the token transferable.
154    *
155    * Design choice. Allow reset the release agent to fix fat finger mistakes.
156    */
157   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
158 
159     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
160     releaseAgent = addr;
161   }
162 
163   /**
164    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
165    */
166   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
167     transferAgents[addr] = state;
168   }
169   
170   /** The function can be called only by a whitelisted release agent. */
171   modifier onlyReleaseAgent() {
172     if(msg.sender != releaseAgent) {
173         revert();
174     }
175     _;
176   }
177 
178   /**
179    * One way function to release the tokens to the wild.
180    *
181    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
182    */
183   function releaseTokenTransfer() public onlyReleaseAgent {
184     released = true;
185   }
186 
187   /** The function can be called only before or after the tokens have been releasesd */
188   modifier inReleaseState(bool releaseState) {
189     if(releaseState != released) {
190         revert();
191     }
192     _;
193   }  
194 
195   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
196     // Call StandardToken.transfer()
197    return super.transfer(_to, _value);
198   }
199 
200   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
201     // Call StandardToken.transferForm()
202     return super.transferFrom(_from, _to, _value);
203   }
204 
205 }
206 
207 contract StandardToken is ERC20, BasicToken {
208 
209   mapping (address => mapping (address => uint256)) allowed;
210 
211 
212   /**
213    * @dev Transfer tokens from one address to another
214    * @param _from address The address which you want to send tokens from
215    * @param _to address The address which you want to transfer to
216    * @param _value uint256 the amout of tokens to be transfered
217    */
218   function transferFrom(address _from, address _to, uint256 _value) /* internal */ returns (bool) {
219     var _allowance = allowed[_from][msg.sender];
220 
221     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
222     // require (_value <= _allowance);
223 
224     balances[_to] = balances[_to].add(_value);
225     balances[_from] = balances[_from].sub(_value);
226     allowed[_from][msg.sender] = _allowance.sub(_value);
227     Transfer(_from, _to, _value);
228     return true;
229   }
230 
231   /**
232    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
233    * @param _spender The address which will spend the funds.
234    * @param _value The amount of tokens to be spent.
235    */
236   function approve(address _spender, uint256 _value) returns (bool) {
237 
238     // To change the approve amount you first have to reduce the addresses`
239     //  allowance to zero by calling `approve(_spender, 0)` if it is not
240     //  already 0 to mitigate the race condition described here:
241     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
242     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
243 
244     allowed[msg.sender][_spender] = _value;
245     Approval(msg.sender, _spender, _value);
246     return true;
247   }
248 
249   /**
250    * @dev Function to check the amount of tokens that an owner allowed to a spender.
251    * @param _owner address The address which owns the funds.
252    * @param _spender address The address which will spend the funds.
253    * @return A uint256 specifing the amount of tokens still available for the spender.
254    */
255   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
256     return allowed[_owner][_spender];
257   }
258 
259 }
260 
261 contract MintableToken is StandardToken, Ownable {
262   bool public mintingFinished = false;
263   
264   /** List of agents that are allowed to create new tokens */
265   mapping (address => bool) public mintAgents;
266 
267   event MintingAgentChanged(address addr, bool state  );
268   event Mint(address indexed to, uint256 amount);
269   event MintFinished();
270 
271   modifier onlyMintAgent() {
272     // Only crowdsale contracts are allowed to mint new tokens
273     if(!mintAgents[msg.sender]) {
274         revert();
275     }
276     _;
277   }
278   
279   modifier canMint() {
280     require(!mintingFinished);
281     _;
282   }
283   
284   /**
285    * Owner can allow a crowdsale contract to mint new tokens.
286    */
287   function setMintAgent(address addr, bool state) onlyOwner canMint public {
288     mintAgents[addr] = state;
289     MintingAgentChanged(addr, state);
290   }
291 
292   /**
293    * @dev Function to mint tokens
294    * @param _to The address that will recieve the minted tokens.
295    * @param _amount The amount of tokens to mint.
296    * @return A boolean that indicates if the operation was successful.
297    */
298   function mint(address _to, uint256 _amount) onlyMintAgent canMint returns (bool) {
299     totalSupply = totalSupply.add(_amount);
300     balances[_to] = balances[_to].add(_amount);
301     Mint(_to, _amount);
302     return true;
303   }
304 
305   /**
306    * @dev Function to stop minting new tokens.
307    * @return True if the operation was successful.
308    */
309   function finishMinting() onlyMintAgent returns (bool) {
310     mintingFinished = true;
311     MintFinished();
312     return true;
313   }
314 }
315 
316 contract CrowdsaleToken is ReleasableToken, MintableToken {
317 
318   string public name;
319 
320   string public symbol;
321 
322   uint public decimals;
323     
324   /**
325    * Construct the token.
326    *
327    * @param _name Token name
328    * @param _symbol Token symbol - should be all caps
329    * @param _initialSupply How many tokens we start with
330    * @param _decimals Number of decimal places
331    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
332    */
333   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable) {
334 
335     owner = msg.sender;
336 
337     name = _name;
338     symbol = _symbol;
339 
340     totalSupply = _initialSupply;
341 
342     decimals = _decimals;
343 
344     balances[owner] = totalSupply;
345 
346     if(totalSupply > 0) {
347       Mint(owner, totalSupply);
348     }
349 
350     // No more new supply allowed after the token creation
351     if(!_mintable) {
352       mintingFinished = true;
353       if(totalSupply == 0) {
354         revert(); // Cannot create a token without supply and no minting
355       }
356     }
357   }
358 
359   /**
360    * When token is released to be transferable, enforce no new tokens can be created.
361    */
362    
363   function releaseTokenTransfer() public onlyReleaseAgent {
364     mintingFinished = true;
365     super.releaseTokenTransfer();
366   }
367   
368   //lock team address by crowdsale
369   function addLockAddress(address addr, uint lock_time) onlyMintAgent inReleaseState(false) public {
370 	super.addLockAddressInternal(addr, lock_time);
371   }
372 
373 }