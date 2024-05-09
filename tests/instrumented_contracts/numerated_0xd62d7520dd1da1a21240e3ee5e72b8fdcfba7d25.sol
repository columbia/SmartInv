1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface 
6  * 
7  */
8 contract ERC20 {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   function allowance(address owner, address spender) public view returns (uint256);
13   function transferFrom(address from, address to, uint256 value) public returns (bool);
14   function approve(address spender, uint256 value) public returns (bool);
15   event Approval(address indexed owner, address indexed spender, uint256 value);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 
20 /**
21  * @title Ownable
22  * @dev The Ownable contract has an owner address, and provides basic authorization control
23  * functions, this simplifies the implementation of "user permissions".
24  */
25 contract Ownable {
26   address private _owner;
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   constructor () internal {
35       _owner = msg.sender;
36       emit OwnershipTransferred(address(0), _owner);
37   }
38 
39   /**
40    * @return the address of the owner.
41    */
42   function owner() public view returns (address) {
43       return _owner;
44   }
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50       require(isOwner());
51       _;
52   }
53 
54   /**
55    * @return true if `msg.sender` is the owner of the contract.
56    */
57   function isOwner() public view returns (bool) {
58       return msg.sender == _owner;
59   }
60 
61   /**
62    * @dev Allows the current owner to transfer control of the contract to a newOwner.
63    * @param newOwner The address to transfer ownership to.
64    */
65   function transferOwnership(address newOwner) public onlyOwner {
66       _transferOwnership(newOwner);
67   }
68 
69   /**
70    * @dev Transfers control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function _transferOwnership(address newOwner) internal {
74       require(newOwner != address(0));
75       emit OwnershipTransferred(_owner, newOwner);
76       _owner = newOwner;
77   }
78 
79 }
80 
81 
82 /**
83  * @title SafeMath
84  * @dev Math operations with safety checks that revert on error
85  */
86 library SafeMath {
87   /**
88   * @dev Multiplies two numbers, reverts on overflow.
89   */
90   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
92       // benefit is lost if 'b' is also tested.
93       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
94       if (a == 0) {
95           return 0;
96       }
97 
98       uint256 c = a * b;
99       require(c / a == b);
100 
101       return c;
102   }
103 
104   /**
105   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
106   */
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108       // Solidity only automatically asserts when dividing by 0
109       require(b > 0);
110       uint256 c = a / b;
111       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
112 
113       return c;
114   }
115 
116   /**
117   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
118   */
119   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120       require(b <= a);
121       uint256 c = a - b;
122 
123       return c;
124   }
125 
126   /**
127   * @dev Adds two numbers, reverts on overflow.
128   */
129   function add(uint256 a, uint256 b) internal pure returns (uint256) {
130       uint256 c = a + b;
131       require(c >= a);
132 
133       return c;
134   }
135 
136   /**
137   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
138   * reverts when dividing by zero.
139   */
140   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141       require(b != 0);
142       return a % b;
143   }
144  
145 
146   function uint2str(uint i) internal pure returns (string){
147       if (i == 0) return "0";
148       uint j = i;
149       uint length;
150       while (j != 0){
151           length++;
152           j /= 10;
153       }
154       bytes memory bstr = new bytes(length);
155       uint k = length - 1;
156       while (i != 0){
157           bstr[k--] = byte(48 + i % 10);
158           i /= 10;
159       }
160       return string(bstr);
161   }
162  
163   
164 }
165 
166 
167 /**
168  * @title ZBX Token  
169  *
170  */
171 contract ZBXToken is ERC20, Ownable {
172   using SafeMath for uint256;
173 
174   string public constant name = "ZBX Token";
175   string public constant symbol = "XT"; 
176   uint8 public constant decimals = 18;
177 
178 
179 
180   mapping (address => uint256) private _balances;
181 
182   mapping (address => mapping (address => uint256)) private _allowed;
183 
184   uint256 private _totalSupply;
185 
186   //Total amount of tokens is 500,000,000 - 500 million + 18 decimals
187   uint256 public hardcap = 500000000 * (10**uint256(18));
188  
189   //Enable/Disable mint and burn functions
190   bool private _enbaleActions = true;
191 
192 
193 
194   /**
195    * @dev Constructor
196    */
197   constructor() public {
198 
199     //Set total supply to hardcap
200     _totalSupply = hardcap;
201 
202     //Transfer total supply to owner
203     _balances[owner()] = _totalSupply;
204     emit Transfer(address(0), owner(), _totalSupply);
205 
206   }
207 
208 
209   /**
210    * @dev onlyPayloadSize
211    * @notice Fix for the ERC20 short address attack.
212    */
213   modifier onlyPayloadSize(uint size) {
214     assert(msg.data.length >= size + 4);
215     _;
216   } 
217  
218 
219   /**
220    * @dev total number of tokens in existence
221    */
222   function totalSupply() public view returns (uint256) {
223     return _totalSupply;
224   }
225 
226   /**
227    * @dev Gets the balance of the specified address.
228    * @param _owner The address to query the the balance of.
229    * @return An uint256 representing the amount owned by the passed address.
230    */
231   function balanceOf(address _owner) public view returns (uint256 balance) {
232     return _balances[_owner];
233   }
234  
235  
236   /**
237    * @dev transfer token for a specified address
238    * @param _to The address to transfer to.
239    * @param _value The amount to be transferred.
240    */
241   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {    
242       require(_to != address(0)); // Prevent transfer to 0x0 address.
243       require(_value <= _balances[msg.sender]);  // Check if the sender has enough      
244 
245       // SafeMath.sub will throw if there is not enough balance.
246       _balances[msg.sender] = _balances[msg.sender].sub(_value);
247       _balances[_to] = _balances[_to].add(_value);
248       emit Transfer(msg.sender, _to, _value);
249       return true;
250   }
251 
252 
253   /**
254    * @dev Transfer tokens from one address to another
255    * @param _from address The address which you want to send tokens from
256    * @param _to address The address which you want to transfer to
257    * @param _value uint256 the amount of tokens to be transferred
258    */
259   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
260 
261     require(_to != address(0));                     // Prevent transfer to 0x0 address. Use burn() instead
262     require(_value <= _balances[_from]);             // Check if the sender has enough
263     require(_value <= _allowed[_from][msg.sender]);  // Check if the sender is _allowed to send
264 
265 
266     // SafeMath.sub will throw if there is not enough balance.
267     _balances[_from] = _balances[_from].sub(_value);
268     _balances[_to] = _balances[_to].add(_value);
269     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
270     emit Transfer(_from, _to, _value);
271     return true; 
272   }
273 
274 
275   /**
276    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
277    *
278    * Beware that changing an allowance with this method brings the risk that someone may use both the old
279    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
280    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:  
281    * @param _spender The address which will spend the funds.
282    * @param _value The amount of tokens to be spent.
283    */
284   function approve(address _spender, uint256 _value) public returns (bool) {
285     _allowed[msg.sender][_spender] = _value;
286     emit Approval(msg.sender, _spender, _value);
287     return true;
288   }
289 
290 
291 
292   /**
293    * @dev Function to check the amount of tokens that an owner _allowed to a spender.
294    * @param _owner address The address which owns the funds.
295    * @param _spender address The address which will spend the funds.
296    * @return A uint256 specifying the amount of tokens still available for the spender.
297    */
298   function allowance(address _owner, address _spender) public view returns (uint256) {
299     return _allowed[_owner][_spender];
300   }
301 
302 
303 
304   /**
305    * @dev Increase the amount of tokens that an owner _allowed to a spender.
306    *
307    * approve should be called when _allowed[_spender] == 0. To increment
308    * _allowed value is better to use this function to avoid 2 calls (and wait until
309    * the first transaction is mined)   
310    * @param _spender The address which will spend the funds.
311    * @param _addedValue The amount of tokens to increase the allowance by.
312    */
313   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
314     _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(_addedValue);
315     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
316     return true;
317   }
318 
319 
320 
321   /**
322    * @dev Decrease the amount of tokens that an owner _allowed to a spend.
323    *
324    * approve should be called when _allowed[_spender] == 0. To decrement
325    * _allowed value is better to use this function to avoid 2 calls (and wait until
326    * the first transaction is mined)   
327    * @param _spender The address which will spend the funds.
328    * @param _subtractedValue The amount of tokens to decrease the allowance by.
329    */
330   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
331     uint oldValue = _allowed[msg.sender][_spender];
332     if (_subtractedValue > oldValue) {
333       _allowed[msg.sender][_spender] = 0;
334     } else {
335       _allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
336     }
337     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
338     return true;
339   }
340 
341 
342   /**
343    * @dev Function to toggle token actions
344    * 
345    */
346   function toggleActions()  onlyOwner public {
347     if(_enbaleActions){
348       _enbaleActions = false; 
349     }else{
350       _enbaleActions = true; 
351     }     
352   }
353 
354  
355   /**
356    * @dev Burns a specific amount of tokens.
357    * @param _account The account whose tokens will be burnt.
358    * @param _value The amount of token to be burned.
359    */
360   function burn(address _account, uint256 _value) onlyOwner public {
361       require(_account != address(0));
362       require(_enbaleActions);
363 
364       // SafeMath.sub will throw if there is not enough balance.
365       _totalSupply = _totalSupply.sub(_value);
366       _balances[_account] = _balances[_account].sub(_value);
367       emit Transfer(_account, address(0), _value);
368   }
369 
370   /**
371    * @dev Function to mint tokens
372    * @param _account The address that will receive the minted tokens.
373    * @param _value The amount of tokens to mint.
374    * @return A boolean that indicates if the operation was successful.
375    */
376   function mint(address _account, uint256 _value) onlyOwner public {
377       require(_account != address(0));
378       require(_totalSupply.add(_value) <= hardcap);
379       require(_enbaleActions);
380 
381       _totalSupply = _totalSupply.add(_value);
382       _balances[_account] = _balances[_account].add(_value);
383       emit Transfer(address(0), _account, _value);
384   }
385 
386 
387   /**
388    * @dev Owner can transfer tokens that are sent to the contract by mistake
389    * 
390    */
391   function refundTokens(address _recipient, ERC20 _token)  onlyOwner public {
392     require(_token.transfer(_recipient, _token.balanceOf(this)));
393   }
394 
395 
396   /**
397    * @dev transfer balance to owner
398    * 
399    */
400   function withdrawEther(uint256 amount) onlyOwner public {
401     owner().transfer(amount);
402   }
403   
404   /**
405    * @dev accept ether
406    * 
407    */
408   function() public payable {
409   }
410 
411  
412 }