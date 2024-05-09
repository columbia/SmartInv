1 //Have an idea for a studio? Email: admin[at]EtherPornStars.com
2 pragma solidity ^0.4.24;
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 contract ERC20 {
10   function totalSupply() public view returns (uint256);
11 
12   function balanceOf(address _who) public view returns (uint256);
13 
14   function allowance(address _owner, address _spender)
15     public view returns (uint256);
16 
17   function transfer(address _to, uint256 _value) public returns (bool);
18 
19   function approve(address _spender, uint256 _value)
20     public returns (bool);
21 
22   function transferFrom(address _from, address _to, uint256 _value)
23     public returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 
39 
40 
41 
42 
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that revert on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, reverts on overflow.
53   */
54   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
55     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
56     // benefit is lost if 'b' is also tested.
57     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
58     if (_a == 0) {
59       return 0;
60     }
61 
62     uint256 c = _a * _b;
63     require(c / _a == _b);
64 
65     return c;
66   }
67 
68   /**
69   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
70   */
71   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
72     require(_b > 0); // Solidity only automatically asserts when dividing by 0
73     uint256 c = _a / _b;
74     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
75 
76     return c;
77   }
78 
79   /**
80   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
81   */
82   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
83     require(_b <= _a);
84     uint256 c = _a - _b;
85 
86     return c;
87   }
88 
89   /**
90   * @dev Adds two numbers, reverts on overflow.
91   */
92   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
93     uint256 c = _a + _b;
94     require(c >= _a);
95 
96     return c;
97   }
98 
99   /**
100   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
101   * reverts when dividing by zero.
102   */
103   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
104     require(b != 0);
105     return a % b;
106   }
107 }
108 
109 /**
110  * @title Standard ERC20 token
111  *
112  * @dev Implementation of the basic standard token.
113  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
114  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
115  */
116 contract StandardToken is ERC20 {
117   using SafeMath for uint256;
118 
119   mapping (address => uint256) balances;
120 
121   mapping (address => mapping (address => uint256)) allowed;
122 
123   uint256 totalSupply_;
124 
125   /**
126   * @dev Total number of tokens in existence
127   */
128   function totalSupply() public view returns (uint256) {
129     return totalSupply_;
130   }
131 
132   /**
133   * @dev Gets the balance of the specified address.
134   * @param _owner The address to query the the balance of.
135   * @return An uint256 representing the amount owned by the passed address.
136   */
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances[_owner];
139   }
140 
141   /**
142    * @dev Function to check the amount of tokens that an owner allowed to a spender.
143    * @param _owner address The address which owns the funds.
144    * @param _spender address The address which will spend the funds.
145    * @return A uint256 specifying the amount of tokens still available for the spender.
146    */
147   function allowance(
148     address _owner,
149     address _spender
150    )
151     public
152     view
153     returns (uint256)
154   {
155     return allowed[_owner][_spender];
156   }
157 
158   /**
159   * @dev Transfer token for a specified address
160   * @param _to The address to transfer to.
161   * @param _value The amount to be transferred.
162   */
163   function transfer(address _to, uint256 _value) public returns (bool) {
164     require(_value <= balances[msg.sender]);
165     require(_to != address(0));
166 
167     balances[msg.sender] = balances[msg.sender].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     emit Transfer(msg.sender, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    * Beware that changing an allowance with this method brings the risk that someone may use both the old
176    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
177    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
178    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
179    * @param _spender The address which will spend the funds.
180    * @param _value The amount of tokens to be spent.
181    */
182   function approve(address _spender, uint256 _value) public returns (bool) {
183     allowed[msg.sender][_spender] = _value;
184     emit Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Transfer tokens from one address to another
190    * @param _from address The address which you want to send tokens from
191    * @param _to address The address which you want to transfer to
192    * @param _value uint256 the amount of tokens to be transferred
193    */
194   function transferFrom(
195     address _from,
196     address _to,
197     uint256 _value
198   )
199     public
200     returns (bool)
201   {
202     require(_value <= balances[_from]);
203     require(_value <= allowed[_from][msg.sender]);
204     require(_to != address(0));
205 
206     balances[_from] = balances[_from].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
209     emit Transfer(_from, _to, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Increase the amount of tokens that an owner allowed to a spender.
215    * approve should be called when allowed[_spender] == 0. To increment
216    * allowed value is better to use this function to avoid 2 calls (and wait until
217    * the first transaction is mined)
218    * From MonolithDAO Token.sol
219    * @param _spender The address which will spend the funds.
220    * @param _addedValue The amount of tokens to increase the allowance by.
221    */
222   function increaseApproval(
223     address _spender,
224     uint256 _addedValue
225   )
226     public
227     returns (bool)
228   {
229     allowed[msg.sender][_spender] = (
230       allowed[msg.sender][_spender].add(_addedValue));
231     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
232     return true;
233   }
234 
235   /**
236    * @dev Decrease the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To decrement
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _subtractedValue The amount of tokens to decrease the allowance by.
243    */
244   function decreaseApproval(
245     address _spender,
246     uint256 _subtractedValue
247   )
248     public
249     returns (bool)
250   {
251     uint256 oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue >= oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261   /**
262    * @dev Internal function that mints an amount of the token and assigns it to
263    * an account. This encapsulates the modification of balances such that the
264    * proper events are emitted.
265    * @param _account The account that will receive the created tokens.
266    * @param _amount The amount that will be created.
267    */
268   function _mint(address _account, uint256 _amount) internal {
269     require(_account != 0);
270     totalSupply_ = totalSupply_.add(_amount);
271     balances[_account] = balances[_account].add(_amount);
272     emit Transfer(address(0), _account, _amount);
273   }
274 
275   /**
276    * @dev Internal function that burns an amount of the token of a given
277    * account.
278    * @param _account The account whose tokens will be burnt.
279    * @param _amount The amount that will be burnt.
280    */
281   function _burn(address _account, uint256 _amount) internal {
282     require(_account != 0);
283     require(_amount <= balances[_account]);
284 
285     totalSupply_ = totalSupply_.sub(_amount);
286     balances[_account] = balances[_account].sub(_amount);
287     emit Transfer(_account, address(0), _amount);
288   }
289 
290   /**
291    * @dev Internal function that burns an amount of the token of a given
292    * account, deducting from the sender's allowance for said account. Uses the
293    * internal _burn function.
294    * @param _account The account whose tokens will be burnt.
295    * @param _amount The amount that will be burnt.
296    */
297   function _burnFrom(address _account, uint256 _amount) internal {
298     require(_amount <= allowed[_account][msg.sender]);
299 
300     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
301     // this function needs to emit an event with the updated approval.
302     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
303     _burn(_account, _amount);
304   }
305 }
306 
307 /**
308  * @title ERC20 token receiver interface
309  * @dev Interface for any contract that wants to support safeTransfers
310  *  from ERC20 asset contracts.
311  */
312 
313 /**
314  * @title SafeMath
315  * @dev Math operations with safety checks that revert on error
316  */
317 
318 
319 
320 contract Ownable {
321   address public owner;
322 
323 
324   event OwnershipRenounced(address indexed previousOwner);
325   event OwnershipTransferred(
326     address indexed previousOwner,
327     address indexed newOwner
328   );
329 
330 
331   /**
332    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
333    * account.
334    */
335   constructor() public {
336     owner = msg.sender;
337   }
338 
339   /**
340    * @dev Throws if called by any account other than the owner.
341    */
342   modifier onlyOwner() {
343     require(msg.sender == owner);
344     _;
345   }
346 }
347 
348 
349 contract StarCoin is Ownable, StandardToken {
350     using SafeMath for uint;
351     address gateway;
352     string public name = "EtherPornStars Coin";
353     string public symbol = "EPS";
354     uint8 public decimals = 18;
355     mapping (uint8 => address) public studioContracts;
356     mapping (address => bool) public isMinter;
357     event Withdrawal(address indexed to, uint256 value);
358     event Burn(address indexed from, uint256 value);
359     modifier onlyMinters {
360       require(msg.sender == owner || isMinter[msg.sender]);
361       _;
362     }
363 
364     constructor () public {
365   }
366   /**
367    * @dev Future sidechain integration for studios.
368    */
369     function setGateway(address _gateway) external onlyOwner {
370         gateway = _gateway;
371     }
372 
373 
374     function _mintTokens(address _user, uint256 _amount) private {
375         require(_user != 0x0);
376         balances[_user] = balances[_user].add(_amount);
377         totalSupply_ = totalSupply_.add(_amount);
378         emit Transfer(address(this), _user, _amount);
379     }
380 
381     function rewardTokens(address _user, uint256 _tokens) external   { 
382         require(msg.sender == owner || isMinter[msg.sender]);
383         _mintTokens(_user, _tokens);
384     }
385     function buyStudioStake(address _user, uint256 _tokens) external   { 
386         require(msg.sender == owner || isMinter[msg.sender]);
387         _burn(_user, _tokens);
388     }
389     function transferFromStudio(
390       address _from,
391       address _to,
392       uint256 _value
393     )
394       external
395       returns (bool)
396     {
397       require(msg.sender == owner || isMinter[msg.sender]);
398       require(_value <= balances[_from]);
399       require(_to != address(0));
400 
401       balances[_from] = balances[_from].sub(_value);
402       balances[_to] = balances[_to].add(_value);
403       emit Transfer(_from, _to, _value);
404       return true;
405   }
406 
407     function() payable public {
408         // Intentionally left empty, for use by studios
409     }
410 
411     function accountAuth(uint256 /*_challenge*/) external {
412         // Does nothing by design
413     }
414 
415     function burn(uint256 _amount) external {
416         require(balances[msg.sender] >= _amount);
417         balances[msg.sender] = balances[msg.sender].sub(_amount);
418         totalSupply_ = totalSupply_.sub(_amount);
419         emit Burn(msg.sender, _amount);
420     }
421 
422     function withdrawBalance(uint _amount) external {
423         require(balances[msg.sender] >= _amount);
424         balances[msg.sender] = balances[msg.sender].sub(_amount);
425         totalSupply_ = totalSupply_.sub(_amount);
426         uint ethexchange = _amount.div(2);
427         msg.sender.transfer(ethexchange);
428     }
429 
430     function setIsMinter(address _address, bool _value) external onlyOwner {
431         isMinter[_address] = _value;
432     }
433 
434     function depositToGateway(uint256 amount) external {
435         transfer(gateway, amount);
436     }
437 }