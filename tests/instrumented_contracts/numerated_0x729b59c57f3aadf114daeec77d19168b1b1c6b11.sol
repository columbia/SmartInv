1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     c = _a * _b;
22     assert(c / _a == _b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
30     // assert(_b > 0); // Solidity automatically throws when dividing by 0
31     // uint256 c = _a / _b;
32     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
33     return _a / _b;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
40     assert(_b <= _a);
41     return _a - _b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
48     c = _a + _b;
49     assert(c >= _a);
50     return c;
51   }
52 }
53 
54 library Math {
55   function max64(uint64 _a, uint64 _b) internal pure returns (uint64) {
56     return _a >= _b ? _a : _b;
57   }
58 
59   function min64(uint64 _a, uint64 _b) internal pure returns (uint64) {
60     return _a < _b ? _a : _b;
61   }
62 
63   function max256(uint256 _a, uint256 _b) internal pure returns (uint256) {
64     return _a >= _b ? _a : _b;
65   }
66 
67   function min256(uint256 _a, uint256 _b) internal pure returns (uint256) {
68     return _a < _b ? _a : _b;
69   }
70 }
71 
72 library SafeERC20 {
73   function safeTransfer(ERC20Basic _token, address _to, uint256 _value) internal {
74     require(_token.transfer(_to, _value));
75   }
76 
77   function safeTransferFrom(
78     ERC20 _token,
79     address _from,
80     address _to,
81     uint256 _value
82   )
83     internal
84   {
85     require(_token.transferFrom(_from, _to, _value));
86   }
87 
88   function safeApprove(ERC20 _token, address _spender, uint256 _value) internal {
89     require(_token.approve(_spender, _value));
90   }
91 }
92 contract ERC20Basic {
93   function totalSupply() public view returns (uint256);
94   function balanceOf(address _who) public view returns (uint256);
95   function transfer(address _to, uint256 _value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 
100 contract ERC20 is ERC20Basic {
101   function allowance(address _owner, address _spender)
102     public view returns (uint256);
103 
104   function transferFrom(address _from, address _to, uint256 _value)
105     public returns (bool);
106 
107   function approve(address _spender, uint256 _value) public returns (bool);
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) internal balances;
120 
121   uint256 internal totalSupply_;
122 
123   /**
124   * @dev Total number of tokens in existence
125   */
126   function totalSupply() public view returns (uint256) {
127     return totalSupply_;
128   }
129 
130   /**
131   * @dev Transfer token for a specified address
132   * @param _to The address to transfer to.
133   * @param _value The amount to be transferred.
134   */
135   function transfer(address _to, uint256 _value) public returns (bool) {
136     require(_value <= balances[msg.sender]);
137     require(_to != address(0));
138 
139     balances[msg.sender] = balances[msg.sender].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     emit Transfer(msg.sender, _to, _value);
142     return true;
143   }
144 
145   /**
146   * @dev Gets the balance of the specified address.
147   * @param _owner The address to query the the balance of.
148   * @return An uint256 representing the amount owned by the passed address.
149   */
150   function balanceOf(address _owner) public view returns (uint256) {
151     return balances[_owner];
152   }
153 
154 }
155 contract StandardToken is ERC20, BasicToken {
156 
157   mapping (address => mapping (address => uint256)) internal allowed;
158 
159 
160   /**
161    * @dev Transfer tokens from one address to another
162    * @param _from address The address which you want to send tokens from
163    * @param _to address The address which you want to transfer to
164    * @param _value uint256 the amount of tokens to be transferred
165    */
166   function transferFrom(
167     address _from,
168     address _to,
169     uint256 _value
170   )
171     public
172     returns (bool)
173   {
174     require(_value <= balances[_from]);
175     require(_value <= allowed[_from][msg.sender]);
176     require(_to != address(0));
177 
178     balances[_from] = balances[_from].sub(_value);
179     balances[_to] = balances[_to].add(_value);
180     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
181     emit Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   /**
186    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
187    * Beware that changing an allowance with this method brings the risk that someone may use both the old
188    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
189    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
190    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191    * @param _spender The address which will spend the funds.
192    * @param _value The amount of tokens to be spent.
193    */
194   function approve(address _spender, uint256 _value) public returns (bool) {
195     allowed[msg.sender][_spender] = _value;
196     emit Approval(msg.sender, _spender, _value);
197     return true;
198   }
199 
200   /**
201    * @dev Function to check the amount of tokens that an owner allowed to a spender.
202    * @param _owner address The address which owns the funds.
203    * @param _spender address The address which will spend the funds.
204    * @return A uint256 specifying the amount of tokens still available for the spender.
205    */
206   function allowance(
207     address _owner,
208     address _spender
209    )
210     public
211     view
212     returns (uint256)
213   {
214     return allowed[_owner][_spender];
215   }
216 
217   /**
218    * @dev Increase the amount of tokens that an owner allowed to a spender.
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint256 _addedValue
229   )
230     public
231     returns (bool)
232   {
233     allowed[msg.sender][_spender] = (
234       allowed[msg.sender][_spender].add(_addedValue));
235     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236     return true;
237   }
238 
239   /**
240    * @dev Decrease the amount of tokens that an owner allowed to a spender.
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(
249     address _spender,
250     uint256 _subtractedValue
251   )
252     public
253     returns (bool)
254   {
255     uint256 oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue >= oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 }
265 contract Ownable {
266   address public owner;
267 
268 
269   event OwnershipRenounced(address indexed previousOwner);
270   event OwnershipTransferred(
271     address indexed previousOwner,
272     address indexed newOwner
273   );
274 
275 
276   /**
277    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
278    * account.
279    */
280   constructor() public {
281     owner = msg.sender;
282   }
283 
284   /**
285    * @dev Throws if called by any account other than the owner.
286    */
287   modifier onlyOwner() {
288     require(msg.sender == owner);
289     _;
290   }
291 
292   /**
293    * @dev Allows the current owner to relinquish control of the contract.
294    * @notice Renouncing to ownership will leave the contract without an owner.
295    * It will not be possible to call the functions with the `onlyOwner`
296    * modifier anymore.
297    */
298   function renounceOwnership() public onlyOwner {
299     emit OwnershipRenounced(owner);
300     owner = address(0);
301   }
302 
303   /**
304    * @dev Allows the current owner to transfer control of the contract to a newOwner.
305    * @param _newOwner The address to transfer ownership to.
306    */
307   function transferOwnership(address _newOwner) public onlyOwner {
308     _transferOwnership(_newOwner);
309   }
310 
311   /**
312    * @dev Transfers control of the contract to a newOwner.
313    * @param _newOwner The address to transfer ownership to.
314    */
315   function _transferOwnership(address _newOwner) internal {
316     require(_newOwner != address(0));
317     emit OwnershipTransferred(owner, _newOwner);
318     owner = _newOwner;
319   
320 }
321 
322 }
323 
324 contract MintableToken is StandardToken, Ownable {
325   event Mint(address indexed to, uint256 amount);
326   event MintFinished();
327 
328 string public name = "B2BCoin Classic";
329     string public symbol = "BBCC";
330     uint256 public decimals = 18;
331   bool public mintingFinished = false;
332 
333 
334   modifier canMint() {
335     require(!mintingFinished);
336     _;
337   }
338 
339   modifier hasMintPermission() {
340     require(msg.sender == owner);
341     _;
342   }
343 
344 constructor () public {
345     mint(msg.sender,1000000000000000000000000000);
346 }
347 
348   function mint(
349     address _to,
350     uint256 _amount
351   )
352     hasMintPermission
353     canMint
354     public
355     returns (bool)
356   {
357     totalSupply_ = totalSupply_.add(_amount);
358     balances[_to] = balances[_to].add(_amount);
359     emit Mint(_to, _amount);
360     emit Transfer(address(0), _to, _amount);
361     return true;
362   }
363 
364   /**
365    * @dev Function to stop minting new tokens.
366    * @return True if the operation was successful.
367    */
368   function finishMinting() onlyOwner canMint public returns (bool) {
369     mintingFinished = true;
370     emit MintFinished();
371     return true;
372   }
373 }