1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   function totalSupply() public view returns (uint256);
36   function balanceOf(address who) public view returns (uint256);
37   function transfer(address to, uint256 value) public returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) public view returns (uint256);
43   function transferFrom(address from, address to, uint256 value) public returns (bool);
44   function approve(address spender, uint256 value) public returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Basic token
50  * @dev Basic version of StandardToken, with no allowances.
51  */
52 contract BasicToken is ERC20Basic {
53   using SafeMath for uint256;
54 
55   mapping(address => uint256) balances;
56 
57   uint256 totalSupply_;
58 
59   /**
60   * @dev total number of tokens in existence
61   */
62   function totalSupply() public view returns (uint256) {
63     return totalSupply_;
64   }
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) public returns (bool) {
72     require(_to != address(0));
73     require(_value <= balances[msg.sender]);
74 
75     // SafeMath.sub will throw if there is not enough balance.
76     balances[msg.sender] = balances[msg.sender].sub(_value);
77     balances[_to] = balances[_to].add(_value);
78     Transfer(msg.sender, _to, _value);
79     return true;
80   }
81 
82   /**
83   * @dev Gets the balance of the specified address.
84   * @param _owner The address to query the the balance of.
85   * @return An uint256 representing the amount owned by the passed address.
86   */
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 /**
94  * @title Ownable
95  * @dev The Ownable contract has an owner address, and provides basic authorization control
96  * functions, this simplifies the implementation of "user permissions".
97  */
98 contract Ownable {
99   address public owner;
100 
101   /**
102    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
103    * account.
104    */
105   function Ownable() public {
106     owner = msg.sender;
107   }
108 
109 
110   /**
111    * @dev Throws if called by any account other than the owner.
112    */
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117 
118 
119   /**
120    * @dev Allows the current owner to transfer control of the contract to a newOwner.
121    * @param newOwner The address to transfer ownership to.
122    */
123   function transferOwnership(address newOwner) onlyOwner public {
124     require(newOwner != address(0));
125     owner = newOwner;
126   }
127 
128 }
129 
130 contract Pausable is Ownable {
131 
132     event EPause();
133     event EUnpause();
134 
135     bool public paused = true;
136 
137     modifier whenNotPaused()
138     {
139         require(!paused);
140         _;
141     }
142 
143     modifier whenPaused()
144     {
145         require(paused);
146         _;
147     }
148 
149     function pause() public onlyOwner
150     {
151         paused = true;
152         EPause();
153     }
154 
155     function pauseInternal() internal
156     {
157         paused = true;
158         EPause();
159     }
160 
161     function unpause() public onlyOwner
162     {
163         paused = false;
164         EUnpause();
165     }
166 
167     function isPaused() view public returns(bool) {
168         return paused;
169     }
170 
171     function unpauseInternal() internal
172     {
173         paused = false;
174         EUnpause();
175     }
176 
177 }
178 
179 contract StandardToken is ERC20, BasicToken {
180   using SafeMath for uint256;
181   mapping (address => mapping (address => uint256)) internal allowed;
182 
183 
184   /**
185    * @dev Transfer tokens from one address to another
186    * @param _from address The address which you want to send tokens from
187    * @param _to address The address which you want to transfer to
188    * @param _value uint256 the amount of tokens to be transferred
189    */
190   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
191     require(_to != address(0));
192     require(_value <= balances[_from]);
193     require(_value <= allowed[_from][msg.sender]);
194 
195     balances[_from] = balances[_from].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198     Transfer(_from, _to, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    *
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     Approval(msg.sender, _spender, _value);
215     return true;
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(address _owner, address _spender) public view returns (uint256) {
225     return allowed[_owner][_spender];
226   }
227 
228   /**
229    * @dev Increase the amount of tokens that an owner allowed to a spender.
230    *
231    * approve should be called when allowed[_spender] == 0. To increment
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _addedValue The amount of tokens to increase the allowance by.
237    */
238   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
239     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
240     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241     return true;
242   }
243 
244   /**
245    * @dev Decrease the amount of tokens that an owner allowed to a spender.
246    *
247    * approve should be called when allowed[_spender] == 0. To decrement
248    * allowed value is better to use this function to avoid 2 calls (and wait until
249    * the first transaction is mined)
250    * From MonolithDAO Token.sol
251    * @param _spender The address which will spend the funds.
252    * @param _subtractedValue The amount of tokens to decrease the allowance by.
253    */
254   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
255     uint oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 
265 }
266 
267 /**
268  * @title Pausable token
269  * @dev StandardToken modified with pausable transfers.
270  **/
271 contract PausableToken is StandardToken, Pausable {
272 
273   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
274     return super.transfer(_to, _value);
275   }
276 
277   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
278     return super.transferFrom(_from, _to, _value);
279   }
280 
281   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
282     return super.approve(_spender, _value);
283   }
284 
285   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
286     return super.increaseApproval(_spender, _addedValue);
287   }
288 
289   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
290     return super.decreaseApproval(_spender, _subtractedValue);
291   }
292 }
293 
294 /**
295  * @title Burnable Token
296  * @dev Token that can be irreversibly burned (destroyed).
297  */
298 contract BurnableToken is PausableToken {
299 
300   event Burn(address indexed burner, uint256 value);
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _value The amount of token to be burned.
305    */
306   function burn(uint256 _value) public {
307     require(_value <= balances[msg.sender]);
308     // no need to require value <= totalSupply, since that would imply the
309     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
310 
311     address burner = msg.sender;
312     balances[burner] = balances[burner].sub(_value);
313     totalSupply_ = totalSupply_.sub(_value);
314     Burn(burner, _value);
315   }
316 }
317 
318 contract Streamity is BurnableToken {
319 
320     string public constant name = "Streamity";
321     string public constant symbol = "STM";
322     uint8 public constant decimals = 18;
323 
324     uint256 public constant INITIAL_SUPPLY = 180000000 ether;
325 
326 
327     address public tokenOwner = 0x99395F3CFa72E30E1073E2DB4d716efCFa1a9b82;
328     address public reserveFund = 0xC5fed49Be1F6c3949831a06472aC5AB271AF89BD; //18 600 000 STM
329     address public advisersPartners = 0x5B5521E9D795CA083eF928A58393B8f7FF95e098; //3 720 000 STM
330     address public teamWallet = 0x556dB38b73B97954960cA72580EbdAc89327808E; // 4 650 000 STM
331 
332 
333     uint public timeLock = now + 1 years;
334 
335     function Streamity () public {
336         totalSupply_ = INITIAL_SUPPLY;
337 
338         balances[tokenOwner] = INITIAL_SUPPLY;
339 
340         balances[this] = balances[tokenOwner].sub(23250000 ether); // for freezing
341         balances[tokenOwner] = balances[tokenOwner].sub(23250000 ether);
342         Transfer(tokenOwner, this, 23250000 ether);
343 
344         balances[reserveFund] = balances[tokenOwner].sub(18600000 ether);
345         balances[tokenOwner] = balances[tokenOwner].sub(18600000 ether);
346         Transfer(tokenOwner, reserveFund, 18600000 ether);
347 
348         balances[advisersPartners] = balances[tokenOwner].sub(3720000 ether);
349         balances[tokenOwner] = balances[tokenOwner].sub(3720000 ether);
350         Transfer(tokenOwner, advisersPartners, 3720000 ether);
351 
352         balances[teamWallet] = balances[tokenOwner].sub(4650000 ether);
353         balances[tokenOwner] = balances[tokenOwner].sub(4650000 ether);
354         Transfer(tokenOwner, teamWallet, 4650000 ether);
355     }
356 
357     function sendTokens(address _to, uint _value) public onlyOwner {
358         require(_to != address(0));
359         require(_value <= balances[tokenOwner]);
360         balances[tokenOwner] = balances[tokenOwner].sub(_value);
361         balances[_to] = balances[_to].add(_value);
362         Transfer(tokenOwner, _to, _value);
363     }
364 
365     function unlockTeamTokens() public {
366         require(now >= timeLock);
367 
368         uint amount = 23250000 ether;
369 
370         balances[this] = balances[this].sub(amount);
371         balances[teamWallet] = balances[teamWallet].add(amount);
372         Transfer(this, teamWallet, amount);
373     }
374 
375 }