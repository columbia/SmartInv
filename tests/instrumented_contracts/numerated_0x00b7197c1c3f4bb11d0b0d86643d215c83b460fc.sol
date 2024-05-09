1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     assert(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     assert(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     assert(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract Distributor is Ownable {
107     using SafeERC20 for ERC20;
108 
109     ERC20 token;
110     address holder;
111 
112     constructor(ERC20 _token, address _holder) {
113         token = _token;
114         holder = _holder;
115     }
116 
117     function distribute(address _addr, uint256 _amount) public onlyOwner {
118         require(_amount <= token.allowance(holder, address(this)), "Insufficient amount.");
119         token.safeTransferFrom(holder, _addr, _amount);
120     }
121 
122     function distributeMany(address[] _addrs, uint256[] _amounts) public {
123         require(_addrs.length == _amounts.length, "Address - Amount pair mismatch.");
124 
125         for(uint64 i = 0; i < _addrs.length; i++) {
126             distribute(_addrs[i], _amounts[i]);
127         }
128     }
129 }
130 
131 contract ERC20 {
132   function totalSupply() public view returns (uint256);
133 
134   function balanceOf(address _who) public view returns (uint256);
135 
136   function allowance(address _owner, address _spender)
137     public view returns (uint256);
138 
139   function transfer(address _to, uint256 _value) public returns (bool);
140 
141   function approve(address _spender, uint256 _value)
142     public returns (bool);
143 
144   function transferFrom(address _from, address _to, uint256 _value)
145     public returns (bool);
146 
147   event Transfer(
148     address indexed from,
149     address indexed to,
150     uint256 value
151   );
152 
153   event Approval(
154     address indexed owner,
155     address indexed spender,
156     uint256 value
157   );
158 }
159 
160 library SafeERC20 {
161   function safeTransfer(
162     ERC20 _token,
163     address _to,
164     uint256 _value
165   )
166     internal
167   {
168     require(_token.transfer(_to, _value));
169   }
170 
171   function safeTransferFrom(
172     ERC20 _token,
173     address _from,
174     address _to,
175     uint256 _value
176   )
177     internal
178   {
179     require(_token.transferFrom(_from, _to, _value));
180   }
181 
182   function safeApprove(
183     ERC20 _token,
184     address _spender,
185     uint256 _value
186   )
187     internal
188   {
189     require(_token.approve(_spender, _value));
190   }
191 }
192 
193 contract StandardToken is ERC20 {
194   using SafeMath for uint256;
195 
196   mapping(address => uint256) balances;
197 
198   mapping (address => mapping (address => uint256)) internal allowed;
199 
200   uint256 totalSupply_;
201 
202   /**
203   * @dev Total number of tokens in existence
204   */
205   function totalSupply() public view returns (uint256) {
206     return totalSupply_;
207   }
208 
209   /**
210   * @dev Gets the balance of the specified address.
211   * @param _owner The address to query the the balance of.
212   * @return An uint256 representing the amount owned by the passed address.
213   */
214   function balanceOf(address _owner) public view returns (uint256) {
215     return balances[_owner];
216   }
217 
218   /**
219    * @dev Function to check the amount of tokens that an owner allowed to a spender.
220    * @param _owner address The address which owns the funds.
221    * @param _spender address The address which will spend the funds.
222    * @return A uint256 specifying the amount of tokens still available for the spender.
223    */
224   function allowance(
225     address _owner,
226     address _spender
227    )
228     public
229     view
230     returns (uint256)
231   {
232     return allowed[_owner][_spender];
233   }
234 
235   /**
236   * @dev Transfer token for a specified address
237   * @param _to The address to transfer to.
238   * @param _value The amount to be transferred.
239   */
240   function transfer(address _to, uint256 _value) public returns (bool) {
241     require(_value <= balances[msg.sender]);
242     require(_to != address(0));
243 
244     balances[msg.sender] = balances[msg.sender].sub(_value);
245     balances[_to] = balances[_to].add(_value);
246     emit Transfer(msg.sender, _to, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
252    * Beware that changing an allowance with this method brings the risk that someone may use both the old
253    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
254    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
255    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
256    * @param _spender The address which will spend the funds.
257    * @param _value The amount of tokens to be spent.
258    */
259   function approve(address _spender, uint256 _value) public returns (bool) {
260     allowed[msg.sender][_spender] = _value;
261     emit Approval(msg.sender, _spender, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Transfer tokens from one address to another
267    * @param _from address The address which you want to send tokens from
268    * @param _to address The address which you want to transfer to
269    * @param _value uint256 the amount of tokens to be transferred
270    */
271   function transferFrom(
272     address _from,
273     address _to,
274     uint256 _value
275   )
276     public
277     returns (bool)
278   {
279     require(_value <= balances[_from]);
280     require(_value <= allowed[_from][msg.sender]);
281     require(_to != address(0));
282 
283     balances[_from] = balances[_from].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     emit Transfer(_from, _to, _value);
287     return true;
288   }
289 
290   /**
291    * @dev Increase the amount of tokens that an owner allowed to a spender.
292    * approve should be called when allowed[_spender] == 0. To increment
293    * allowed value is better to use this function to avoid 2 calls (and wait until
294    * the first transaction is mined)
295    * From MonolithDAO Token.sol
296    * @param _spender The address which will spend the funds.
297    * @param _addedValue The amount of tokens to increase the allowance by.
298    */
299   function increaseApproval(
300     address _spender,
301     uint256 _addedValue
302   )
303     public
304     returns (bool)
305   {
306     allowed[msg.sender][_spender] = (
307       allowed[msg.sender][_spender].add(_addedValue));
308     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
309     return true;
310   }
311 
312   /**
313    * @dev Decrease the amount of tokens that an owner allowed to a spender.
314    * approve should be called when allowed[_spender] == 0. To decrement
315    * allowed value is better to use this function to avoid 2 calls (and wait until
316    * the first transaction is mined)
317    * From MonolithDAO Token.sol
318    * @param _spender The address which will spend the funds.
319    * @param _subtractedValue The amount of tokens to decrease the allowance by.
320    */
321   function decreaseApproval(
322     address _spender,
323     uint256 _subtractedValue
324   )
325     public
326     returns (bool)
327   {
328     uint256 oldValue = allowed[msg.sender][_spender];
329     if (_subtractedValue >= oldValue) {
330       allowed[msg.sender][_spender] = 0;
331     } else {
332       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
333     }
334     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
335     return true;
336   }
337 
338 }
339 
340 contract MintableToken is StandardToken, Ownable {
341   event Mint(address indexed to, uint256 amount);
342   event MintFinished();
343 
344   bool public mintingFinished = false;
345 
346 
347   modifier canMint() {
348     require(!mintingFinished);
349     _;
350   }
351 
352   modifier hasMintPermission() {
353     require(msg.sender == owner);
354     _;
355   }
356 
357   /**
358    * @dev Function to mint tokens
359    * @param _to The address that will receive the minted tokens.
360    * @param _amount The amount of tokens to mint.
361    * @return A boolean that indicates if the operation was successful.
362    */
363   function mint(
364     address _to,
365     uint256 _amount
366   )
367     public
368     hasMintPermission
369     canMint
370     returns (bool)
371   {
372     totalSupply_ = totalSupply_.add(_amount);
373     balances[_to] = balances[_to].add(_amount);
374     emit Mint(_to, _amount);
375     emit Transfer(address(0), _to, _amount);
376     return true;
377   }
378 
379   /**
380    * @dev Function to stop minting new tokens.
381    * @return True if the operation was successful.
382    */
383   function finishMinting() public onlyOwner canMint returns (bool) {
384     mintingFinished = true;
385     emit MintFinished();
386     return true;
387   }
388 }