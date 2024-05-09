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
24   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     if (a == 0) {
26       return 0;
27     }
28     c = a * b;
29     assert(c / a == b);
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers, truncating the quotient.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     // uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return a / b;
41   }
42 
43   /**
44   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   /**
52   * @dev Adds two numbers, throws on overflow.
53   */
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
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
88     balances[msg.sender] = balances[msg.sender].sub(_value);
89     balances[_to] = balances[_to].add(_value);
90     emit Transfer(msg.sender, _to, _value);
91     return true;
92   }
93 
94   /**
95   * @dev Gets the balance of the specified address.
96   * @param _owner The address to query the the balance of.
97   * @return An uint256 representing the amount owned by the passed address.
98   */
99   function balanceOf(address _owner) public view returns (uint256) {
100     return balances[_owner];
101   }
102 
103 }
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) internal allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142     emit Transfer(_from, _to, _value);
143     return true;
144   }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156   function approve(address _spender, uint256 _value) public returns (bool) {
157     allowed[msg.sender][_spender] = _value;
158     emit Approval(msg.sender, _spender, _value);
159     return true;
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168   function allowance(address _owner, address _spender) public view returns (uint256) {
169     return allowed[_owner][_spender];
170   }
171 
172   /**
173    * @dev Increase the amount of tokens that an owner allowed to a spender.
174    *
175    * approve should be called when allowed[_spender] == 0. To increment
176    * allowed value is better to use this function to avoid 2 calls (and wait until
177    * the first transaction is mined)
178    * From MonolithDAO Token.sol
179    * @param _spender The address which will spend the funds.
180    * @param _addedValue The amount of tokens to increase the allowance by.
181    */
182   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
183     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
184     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
185     return true;
186   }
187 
188   /**
189    * @dev Decrease the amount of tokens that an owner allowed to a spender.
190    *
191    * approve should be called when allowed[_spender] == 0. To decrement
192    * allowed value is better to use this function to avoid 2 calls (and wait until
193    * the first transaction is mined)
194    * From MonolithDAO Token.sol
195    * @param _spender The address which will spend the funds.
196    * @param _subtractedValue The amount of tokens to decrease the allowance by.
197    */
198   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
199     uint oldValue = allowed[msg.sender][_spender];
200     if (_subtractedValue > oldValue) {
201       allowed[msg.sender][_spender] = 0;
202     } else {
203       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
204     }
205     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
206     return true;
207   }
208 
209 }
210 
211 /**
212  * @title Burnable
213  *
214  * @dev Standard ERC20 token
215  */
216 contract Burnable is StandardToken {
217   using SafeMath for uint;
218 
219   /* This notifies clients about the amount burnt */
220   event Burn(address indexed from, uint value);
221 
222   function burn(uint _value) returns (bool success) {
223     require(_value > 0 && balances[msg.sender] >= _value);
224     balances[msg.sender] = balances[msg.sender].sub(_value);
225     totalSupply_ = totalSupply_.sub(_value);
226     Burn(msg.sender, _value);
227     return true;
228   }
229 
230   function burnFrom(address _from, uint _value) returns (bool success) {
231     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
232     require(_value <= allowed[_from][msg.sender]);
233     balances[_from] = balances[_from].sub(_value);
234     totalSupply_ = totalSupply_.sub(_value);
235     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236     Burn(_from, _value);
237     return true;
238   }
239 
240   function transfer(address _to, uint _value) returns (bool success) {
241     require(_to != 0x0); //use burn
242 
243     return super.transfer(_to, _value);
244   }
245 
246   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
247     require(_to != 0x0); //use burn
248 
249     return super.transferFrom(_from, _to, _value);
250   }
251 }
252 
253 /**
254  * @title Ownable
255  * @dev The Ownable contract has an owner address, and provides basic authorization control
256  * functions, this simplifies the implementation of "user permissions".
257  */
258 contract Ownable {
259   address public owner;
260 
261 
262   event OwnershipRenounced(address indexed previousOwner);
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
288     emit OwnershipTransferred(owner, newOwner);
289     owner = newOwner;
290   }
291 
292   /**
293    * @dev Allows the current owner to relinquish control of the contract.
294    */
295   function renounceOwnership() public onlyOwner {
296     emit OwnershipRenounced(owner);
297     owner = address(0);
298   }
299 }
300 
301 /**
302  * @title MyPizzaPieToken
303  *
304  * @dev Burnable Ownable ERC20 token
305  */
306 contract MyPizzaPieToken is Burnable, Ownable {
307 
308   string public constant name = "MyPizzaPie Token";
309   string public constant symbol = "PZA";
310   uint8 public constant decimals = 18;
311   uint public constant INITIAL_SUPPLY = 81192000 * 1 ether;
312 
313   /* The finalizer contract that allows unlift the transfer limits on this token */
314   address public releaseAgent;
315 
316   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
317   bool public released = false;
318 
319   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
320   mapping (address => bool) public transferAgents;
321 
322   /**
323    * Limit token transfer until the crowdsale is over.
324    *
325    */
326   modifier canTransfer(address _sender) {
327     require(released || transferAgents[_sender]);
328     _;
329   }
330 
331   /** The function can be called only before or after the tokens have been released */
332   modifier inReleaseState(bool releaseState) {
333     require(releaseState == released);
334     _;
335   }
336 
337   /** The function can be called only by a whitelisted release agent. */
338   modifier onlyReleaseAgent() {
339     require(msg.sender == releaseAgent);
340     _;
341   }
342 
343 
344   /**
345    * @dev Constructor that gives msg.sender all of existing tokens.
346    */
347   function MyPizzaPieToken() {
348     totalSupply_ = INITIAL_SUPPLY;
349     balances[msg.sender] = INITIAL_SUPPLY;
350   }
351 
352 
353   /**
354    * Set the contract that can call release and make the token transferable.
355    *
356    * Design choice. Allow reset the release agent to fix fat finger mistakes.
357    */
358   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
359     require(addr != 0x0);
360 
361     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
362     releaseAgent = addr;
363   }
364 
365   function release() onlyReleaseAgent inReleaseState(false) public {
366     released = true;
367   }
368 
369   /**
370    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
371    */
372   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
373     require(addr != 0x0);
374     transferAgents[addr] = state;
375   }
376 
377   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
378     // Call Burnable.transfer()
379     return super.transfer(_to, _value);
380   }
381 
382   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
383     // Call Burnable.transferForm()
384     return super.transferFrom(_from, _to, _value);
385   }
386 
387   function burn(uint _value) onlyOwner returns (bool success) {
388     return super.burn(_value);
389   }
390 
391   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
392     return super.burnFrom(_from, _value);
393   }
394 }