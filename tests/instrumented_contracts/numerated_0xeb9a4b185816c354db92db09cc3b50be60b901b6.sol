1 pragma solidity ^0.4.18;
2 
3 // zeppelin-solidity: 1.8.0
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55     if (a == 0) {
56       return 0;
57     }
58     uint256 c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return c;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256) {
85     uint256 c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 /**
92  * @title ERC20Basic
93  * @dev Simpler version of ERC20 interface
94  * @dev see https://github.com/ethereum/EIPs/issues/179
95  */
96 contract ERC20Basic {
97   function totalSupply() public view returns (uint256);
98   function balanceOf(address who) public view returns (uint256);
99   function transfer(address to, uint256 value) public returns (bool);
100   event Transfer(address indexed from, address indexed to, uint256 value);
101 }
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) public view returns (uint256);
109   function transferFrom(address from, address to, uint256 value) public returns (bool);
110   function approve(address spender, uint256 value) public returns (bool);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @title Basic token
116  * @dev Basic version of StandardToken, with no allowances.
117  */
118 contract BasicToken is ERC20Basic {
119   using SafeMath for uint256;
120 
121   mapping(address => uint256) balances;
122 
123   uint256 totalSupply_;
124 
125   /**
126   * @dev total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev transfer token for a specified address
134   * @param _to The address to transfer to.
135   * @param _value The amount to be transferred.
136   */
137   function transfer(address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[msg.sender]);
140 
141     // SafeMath.sub will throw if there is not enough balance.
142     balances[msg.sender] = balances[msg.sender].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     Transfer(msg.sender, _to, _value);
145     return true;
146   }
147 
148   /**
149   * @dev Gets the balance of the specified address.
150   * @param _owner The address to query the the balance of.
151   * @return An uint256 representing the amount owned by the passed address.
152   */
153   function balanceOf(address _owner) public view returns (uint256 balance) {
154     return balances[_owner];
155   }
156 
157 }
158 
159 /**
160  * @title Burnable Token
161  * @dev Token that can be irreversibly burned (destroyed).
162  */
163 contract BurnableToken is BasicToken {
164 
165   event Burn(address indexed burner, uint256 value);
166 
167   /**
168    * @dev Burns a specific amount of tokens.
169    * @param _value The amount of token to be burned.
170    */
171   function burn(uint256 _value) public {
172     // require(_value <= balances[msg.sender]);
173     // no need to require value <= totalSupply, since that would imply the
174     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
175 
176     address burner = msg.sender;
177     balances[burner] = balances[burner].sub(_value);
178     totalSupply_ = totalSupply_.sub(_value);
179     Burn(burner, _value);
180     Transfer(burner, address(0), _value);
181   }
182 }
183 
184 /**
185  * @title Standard ERC20 token
186  *
187  * @dev Implementation of the basic standard token.
188  * @dev https://github.com/ethereum/EIPs/issues/20
189  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
190  */
191 contract StandardToken is ERC20, BasicToken {
192 
193   mapping (address => mapping (address => uint256)) internal allowed;
194 
195 
196   /**
197    * @dev Transfer tokens from one address to another
198    * @param _from address The address which you want to send tokens from
199    * @param _to address The address which you want to transfer to
200    * @param _value uint256 the amount of tokens to be transferred
201    */
202   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[_from]);
205     require(_value <= allowed[_from][msg.sender]);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
210     Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public view returns (uint256) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * @dev Increase the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To increment
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _addedValue The amount of tokens to increase the allowance by.
249    */
250   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
251     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
252     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    *
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
267     uint oldValue = allowed[msg.sender][_spender];
268     if (_subtractedValue > oldValue) {
269       allowed[msg.sender][_spender] = 0;
270     } else {
271       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
272     }
273     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277 }
278 
279 contract OriginSportToken is StandardToken, Ownable, BurnableToken {
280   using SafeMath for uint;
281 
282   // Events
283   event Burn(address indexed _burner, uint _value);
284 
285   // Constants
286   string public constant name           = 'OriginSport Token';
287   string public constant symbol         = 'ORS';
288   uint   public constant decimals       = 18;
289   uint   public constant INITIAL_SUPPLY = 300000000 * 10 ** uint(decimals);
290 
291   // Properties
292   bool public transferable = false;
293   mapping (address => bool) public whitelistedTransfer;
294 
295   // Filter invalid address
296   modifier validAddress(address addr) {
297     require(addr != address(0x0));
298     require(addr != address(this));
299     _;
300   }
301 
302   modifier onlyWhenTransferable() {
303     if (!transferable) {
304       require(whitelistedTransfer[msg.sender]);
305     }
306     _;
307   }
308 
309   /**
310    * @dev Constructor for Origin Sport Token, assigns the total supply to admin address 
311    * @param admin the admin address of ors
312    */
313   function OriginSportToken(address admin) validAddress(admin) public {
314     require(msg.sender != admin);
315     whitelistedTransfer[admin] = true;
316     totalSupply_ = INITIAL_SUPPLY;
317     balances[admin] = totalSupply_;
318     Transfer(address(0x0), admin, totalSupply_);
319 
320     transferOwnership(admin);
321   }
322 
323   /**
324    * @dev allow owner to add addresse to transfer tokens
325    * @param _address address Address to be added
326    */
327   function addWhitelistedTransfer(address _address) onlyOwner public {
328     whitelistedTransfer[_address] = true;
329   }
330 
331   /**
332    * @dev allow all users to transfer tokens
333    */
334   function activeTransfer() onlyOwner public {
335     transferable = true;
336   }
337 
338   /**
339    * @dev overrides transfer function with modifier to prevent from transfer with invalid address
340    * @param _to The address to transfer to
341    * @param _value The amount to be transferred
342    */
343   function transfer(address _to, uint _value) public 
344     validAddress(_to) 
345     onlyWhenTransferable
346     returns (bool) 
347   {
348     return super.transfer(_to, _value);
349   }
350 
351   /**
352    * @dev overrides transfer function with modifier to prevent from transfer with invalid address
353    * @param _from The address to transfer from.
354    * @param _to The address to transfer to.
355    * @param _value The amount to be transferred.
356    */
357   function transferFrom(address _from, address _to, uint _value) public 
358     validAddress(_to) 
359     onlyWhenTransferable
360     returns (bool) 
361   {
362     return super.transferFrom(_from, _to, _value);
363   }
364 
365   /**
366    * @dev overrides transfer function with modifier to prevent from transfer with invalid address
367    * @param _recipients An array of address to transfer to.
368    * @param _value The amount to be transferred.
369    */
370   function batchTransfer(address[] _recipients, uint _value) public onlyWhenTransferable returns (bool) {
371     uint count = _recipients.length;
372     require(count > 0 && count <= 20);
373     uint needAmount =  count.mul(_value);
374     require(_value > 0 && balances[msg.sender] >= needAmount);
375 
376     for (uint i = 0; i < count; i++) {
377       transfer(_recipients[i], _value);
378     }
379     return true;
380   }
381 
382   /**
383    * @dev overrides burn function with modifier to prevent burn while untransferable
384    * @param _value The amount to be burned.
385    */
386   function burn(uint _value) public onlyWhenTransferable onlyOwner {
387     super.burn(_value);
388   }
389 }