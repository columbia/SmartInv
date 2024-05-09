1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 
21   /**
22   * @dev Multiplies two numbers, throws on overflow.
23   */
24   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25     if (a == 0) {
26       return 0;
27     }
28     uint256 c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   /**
44   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256) {
55     uint256 c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70   uint256 totalSupply_;
71 
72   /**
73   * @dev total number of tokens in existence
74   */
75   function totalSupply() public view returns (uint256) {
76     return totalSupply_;
77   }
78 
79   /**
80   * @dev transfer token for a specified address
81   * @param _to The address to transfer to.
82   * @param _value The amount to be transferred.
83   */
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of.
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) public view returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 /**
107  * @title ERC20 interface
108  * @dev see https://github.com/ethereum/EIPs/issues/20
109  */
110 contract ERC20 is ERC20Basic {
111   function allowance(address owner, address spender) public view returns (uint256);
112   function transferFrom(address from, address to, uint256 value) public returns (bool);
113   function approve(address spender, uint256 value) public returns (bool);
114   event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @title Standard ERC20 token
119  *
120  * @dev Implementation of the basic standard token.
121  * @dev https://github.com/ethereum/EIPs/issues/20
122  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
123  */
124 contract StandardToken is ERC20, BasicToken {
125 
126   mapping (address => mapping (address => uint256)) internal allowed;
127 
128 
129   /**
130    * @dev Transfer tokens from one address to another
131    * @param _from address The address which you want to send tokens from
132    * @param _to address The address which you want to transfer to
133    * @param _value uint256 the amount of tokens to be transferred
134    */
135   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
136     require(_to != address(0));
137     require(_value <= balances[_from]);
138     require(_value <= allowed[_from][msg.sender]);
139 
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    *
150    * Beware that changing an allowance with this method brings the risk that someone may use both the old
151    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
152    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
153    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) public returns (bool) {
158     allowed[msg.sender][_spender] = _value;
159     Approval(msg.sender, _spender, _value);
160     return true;
161   }
162 
163   /**
164    * @dev Function to check the amount of tokens that an owner allowed to a spender.
165    * @param _owner address The address which owns the funds.
166    * @param _spender address The address which will spend the funds.
167    * @return A uint256 specifying the amount of tokens still available for the spender.
168    */
169   function allowance(address _owner, address _spender) public view returns (uint256) {
170     return allowed[_owner][_spender];
171   }
172 
173   /**
174    * @dev Increase the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To increment
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _addedValue The amount of tokens to increase the allowance by.
182    */
183   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
184     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
185     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186     return true;
187   }
188 
189   /**
190    * @dev Decrease the amount of tokens that an owner allowed to a spender.
191    *
192    * approve should be called when allowed[_spender] == 0. To decrement
193    * allowed value is better to use this function to avoid 2 calls (and wait until
194    * the first transaction is mined)
195    * From MonolithDAO Token.sol
196    * @param _spender The address which will spend the funds.
197    * @param _subtractedValue The amount of tokens to decrease the allowance by.
198    */
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 /**
213  * @title Burnable
214  *
215  * @dev Standard ERC20 token
216  */
217 contract Burnable is StandardToken {
218   using SafeMath for uint;
219 
220   /* This notifies clients about the amount burnt */
221   event Burn(address indexed from, uint value);
222 
223   function burn(uint _value) returns (bool success) {
224     require(_value > 0 && balances[msg.sender] >= _value);
225     balances[msg.sender] = balances[msg.sender].sub(_value);
226     totalSupply_ = totalSupply_.sub(_value);
227     Burn(msg.sender, _value);
228     return true;
229   }
230 
231   function burnFrom(address _from, uint _value) returns (bool success) {
232     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
233     require(_value <= allowed[_from][msg.sender]);
234     balances[_from] = balances[_from].sub(_value);
235     totalSupply_ = totalSupply_.sub(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     Burn(_from, _value);
238     return true;
239   }
240 
241   function transfer(address _to, uint _value) returns (bool success) {
242     require(_to != 0x0); //use burn
243 
244     return super.transfer(_to, _value);
245   }
246 
247   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
248     require(_to != 0x0); //use burn
249 
250     return super.transferFrom(_from, _to, _value);
251   }
252 }
253 
254 /**
255  * @title Ownable
256  * @dev The Ownable contract has an owner address, and provides basic authorization control
257  * functions, this simplifies the implementation of "user permissions".
258  */
259 contract Ownable {
260   address public owner;
261 
262 
263   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
264 
265 
266   /**
267    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
268    * account.
269    */
270   function Ownable() public {
271     owner = msg.sender;
272   }
273 
274   /**
275    * @dev Throws if called by any account other than the owner.
276    */
277   modifier onlyOwner() {
278     require(msg.sender == owner);
279     _;
280   }
281 
282   /**
283    * @dev Allows the current owner to transfer control of the contract to a newOwner.
284    * @param newOwner The address to transfer ownership to.
285    */
286   function transferOwnership(address newOwner) public onlyOwner {
287     require(newOwner != address(0));
288     OwnershipTransferred(owner, newOwner);
289     owner = newOwner;
290   }
291 
292 }
293 
294 /**
295  * @title DirectCryptToken
296  *
297  * @dev Burnable Ownable ERC20 token
298  */
299 contract DirectCryptToken is Burnable, Ownable {
300 
301   string public constant name = "Direct Crypt Token";
302   string public constant symbol = "DRCT";
303   uint8 public constant decimals = 18;
304   uint public constant INITIAL_SUPPLY = 500000000 * 1 ether;
305 
306   /* The finalizer contract that allows unlift the transfer limits on this token */
307   address public releaseAgent;
308 
309   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
310   bool public released = false;
311 
312   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
313   mapping (address => bool) public transferAgents;
314 
315   /**
316    * Limit token transfer until the crowdsale is over.
317    *
318    */
319   modifier canTransfer(address _sender) {
320     require(released || transferAgents[_sender]);
321     _;
322   }
323 
324   /** The function can be called only before or after the tokens have been released */
325   modifier inReleaseState(bool releaseState) {
326     require(releaseState == released);
327     _;
328   }
329 
330   /** The function can be called only by a whitelisted release agent. */
331   modifier onlyReleaseAgent() {
332     require(msg.sender == releaseAgent);
333     _;
334   }
335 
336 
337   /**
338    * @dev Constructor that gives msg.sender all of existing tokens.
339    */
340   function DirectCryptToken() {
341     totalSupply_ = INITIAL_SUPPLY;
342     balances[msg.sender] = INITIAL_SUPPLY;
343   }
344 
345 
346   /**
347    * Set the contract that can call release and make the token transferable.
348    *
349    * Design choice. Allow reset the release agent to fix fat finger mistakes.
350    */
351   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
352     require(addr != 0x0);
353 
354     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
355     releaseAgent = addr;
356   }
357 
358   function release() onlyReleaseAgent inReleaseState(false) public {
359     released = true;
360   }
361 
362   /**
363    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
364    */
365   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
366     require(addr != 0x0);
367     transferAgents[addr] = state;
368   }
369 
370   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
371     // Call Burnable.transfer()
372     return super.transfer(_to, _value);
373   }
374 
375   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
376     // Call Burnable.transferForm()
377     return super.transferFrom(_from, _to, _value);
378   }
379 
380   function burn(uint _value) onlyOwner returns (bool success) {
381     return super.burn(_value);
382   }
383 
384   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
385     return super.burnFrom(_from, _value);
386   }
387 }