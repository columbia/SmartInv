1 pragma solidity ^0.5.6;
2 
3 library SafeMath {
4   /**
5     * @dev Multiplies two unsigned integers, reverts on overflow.
6     */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12       return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17     return c;
18   }
19 
20   /**
21     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
22     */
23   function div(uint256 a, uint256 b) internal pure returns (uint256) {
24     // Solidity only automatically asserts when dividing by 0
25     require(b > 0);
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
33     */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     require(b <= a);
36     uint256 c = a - b;
37     return c;
38   }
39 
40   /**
41     * @dev Adds two unsigned integers, reverts on overflow.
42     */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     require(c >= a);
46     return c;
47   }
48 }
49 
50 contract Ownable {
51   address public owner;
52   mapping(address => bool) public adminList;
53 
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59   /**
60    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61    * account.
62    */
63   constructor() public {
64     owner = msg.sender;
65   }
66 
67   /**
68    * @dev Throws if called by any account other than the owner.
69    */
70   modifier onlyOwner() {
71     require(msg.sender == owner);
72     _;
73   }
74 
75   modifier onlyAdmin() {
76     require(adminList[msg.sender] == true || msg.sender == owner);
77     _;
78   }
79 
80   function addAdmin(address _address) public onlyOwner {
81       adminList[_address] = true;
82   }
83 
84   function removeAdmin(address _address) public onlyOwner {
85       adminList[_address] = false;
86   }
87 
88   /**
89    * @dev Allows the current owner to transfer control of the contract to a newOwner.
90    * @param _newOwner The address to transfer ownership to.
91    */
92   function transferOwnership(address _newOwner) public onlyOwner {
93     _transferOwnership(_newOwner);
94   }
95 
96   /**
97    * @dev Transfers control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function _transferOwnership(address _newOwner) internal {
101     require(_newOwner != address(0));
102     emit OwnershipTransferred(owner, _newOwner);
103     owner = _newOwner;
104   }
105 }
106 
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() public onlyOwner whenNotPaused {
134     paused = true;
135     emit Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() public onlyOwner whenPaused {
142     paused = false;
143     emit Unpause();
144   }
145 }
146 
147 /**
148  * @title Standard ERC20 token
149  */
150 contract StandardToken {
151   using SafeMath for uint256;
152 
153   mapping(address => uint256) internal balances;
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157   uint256 internal totalSupply_;
158 
159   event Transfer(
160     address indexed from,
161     address indexed to,
162     uint256 value
163   );
164 
165   event Approval(
166     address indexed owner,
167     address indexed spender,
168     uint256 vaule
169   );
170 
171   /**
172   * @dev Total number of tokens in existence
173   */
174   function totalSupply() public view returns (uint256) {
175     return totalSupply_;
176   }
177 
178   /**
179   * @dev Gets the balance of the specified address.
180   * @param _owner The address to query the the balance of.
181   * @return An uint256 representing the amount owned by the passed address.
182   */
183   function balanceOf(address _owner) public view returns (uint256) {
184     return balances[_owner];
185   }
186 
187   /**
188    * @dev Function to check the amount of tokens that an owner allowed to a spender.
189    * @param _owner address The address which owns the funds.
190    * @param _spender address The address which will spend the funds.
191    * @return A uint256 specifying the amount of tokens still available for the spender.
192    */
193   function allowance(
194     address _owner,
195     address _spender
196    )
197     public
198     view
199     returns (uint256)
200   {
201     return allowed[_owner][_spender];
202   }
203 
204   /**
205   * @dev Transfer token for a specified address
206   * @param _to The address to transfer to.
207   * @param _value The amount to be transferred.
208   */
209   function transfer(address _to, uint256 _value) public returns (bool) {
210     require(_to != address(0));
211     require(_value <= balances[msg.sender]);
212 
213     balances[msg.sender] = balances[msg.sender].sub(_value);
214     balances[_to] = balances[_to].add(_value);
215     emit Transfer(msg.sender, _to, _value);
216     return true;
217   }
218 
219   /**
220    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
221    * Beware that changing an allowance with this method brings the risk that someone may use both the old
222    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
223    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
224    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
225    * @param _spender The address which will spend the funds.
226    * @param _value The amount of tokens to be spent.
227    */
228   function approve(address _spender, uint256 _value) public returns (bool) {
229     allowed[msg.sender][_spender] = _value;
230     emit Approval(msg.sender, _spender, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Transfer tokens from one address to another
236    * @param _from address The address which you want to send tokens from
237    * @param _to address The address which you want to transfer to
238    * @param _value uint256 the amount of tokens to be transferred
239    */
240   function transferFrom(
241     address _from,
242     address _to,
243     uint256 _value
244   )
245     public
246     returns (bool)
247   {
248     require(_to != address(0));
249     require(_value <= balances[_from]);
250     require(_value <= allowed[_from][msg.sender]);
251 
252     balances[_from] = balances[_from].sub(_value);
253     balances[_to] = balances[_to].add(_value);
254     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
255     emit Transfer(_from, _to, _value);
256     return true;
257   }
258 }
259 
260 /**
261  * Overriding ERC-20 specification that lets owner Pause all trading.
262  */
263 contract PausableToken is StandardToken, Pausable {
264 
265   event Burn(address indexed from, uint256 value);
266   event Mint(address indexed to, uint256 value);
267 
268   function transfer(
269     address _to,
270     uint256 _value
271   )
272     public
273     whenNotPaused
274     returns (bool)
275   {
276     return super.transfer(_to, _value);
277   }
278 
279   function transferFrom(
280     address _from,
281     address _to,
282     uint256 _value
283   )
284     public
285     whenNotPaused
286     returns (bool)
287   {
288     return super.transferFrom(_from, _to, _value);
289   }
290 
291   function approve(
292     address _spender,
293     uint256 _value
294   )
295     public
296     whenNotPaused
297     returns (bool)
298   {
299     return super.approve(_spender, _value);
300   }
301 
302   /**
303    * @dev Burns a specific amount of tokens.
304    * @param _value The amount of token to be burned.
305    */
306   function burn(uint256 _value) public onlyOwner {
307     require(balances[msg.sender] >= _value);
308     balances[msg.sender] = balances[msg.sender].sub(_value);
309     totalSupply_ = totalSupply_.sub(_value);
310     emit Transfer(msg.sender, address(0x00), _value);
311     emit Burn(msg.sender, _value);
312   }
313 
314   function mint(uint256 _value) public onlyOwner {
315     balances[msg.sender] = balances[msg.sender].add(_value);
316     totalSupply_ = totalSupply_.add(_value);
317     emit Transfer(address(0x00), msg.sender, _value);
318     emit Mint(msg.sender, _value);
319   }
320 }
321 
322 contract FreezeToken is PausableToken {
323   mapping(address=>bool) public frozenAccount;
324   event FrozenAccount(address indexed target, bool frozen);
325 
326   function frozenCheck(address target) internal view {
327     require(!frozenAccount[target]);
328   }
329 
330   function freezeAccount(address target, bool frozen) public onlyAdmin {
331     frozenAccount[target] = frozen;
332     emit FrozenAccount(target, frozen);
333   }
334 
335   function transfer(
336     address _to,
337     uint256 _value
338   )
339     public
340     returns (bool)
341   {
342     frozenCheck(msg.sender);
343     frozenCheck(_to);
344     return super.transfer(_to, _value);
345   }
346 
347   function transferFrom(
348     address _from,
349     address _to,
350     uint256 _value
351   )
352     public
353     whenNotPaused
354     returns (bool)
355   {
356     frozenCheck(msg.sender);
357     frozenCheck(_from);
358     frozenCheck(_to);
359     return super.transferFrom(_from, _to, _value);
360   }
361 }
362 
363 contract Token is FreezeToken {
364   string public constant name = "Panda Coin";  // name of Token 
365   string public constant symbol = "PANDA"; // symbol of Token 
366   uint8 public constant decimals = 18;
367   mapping (address => string) public keys;
368 
369   event Register (address user, string key);
370   
371   constructor() public {
372     totalSupply_ = 1350852214721 * 10 ** uint256(decimals - 2);
373     balances[msg.sender] = totalSupply_;
374     emit Transfer(address(0x00), msg.sender,totalSupply_);
375   }
376   
377   function register(string memory key) public {
378     keys[msg.sender] = key;
379     emit Register(msg.sender, key);
380   }
381 }