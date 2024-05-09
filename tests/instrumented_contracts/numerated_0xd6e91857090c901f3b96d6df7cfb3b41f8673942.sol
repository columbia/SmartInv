1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20 interface 
5  * 
6  */
7 contract ERC20 {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address private _owner;
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29   /**
30    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
31    * account.
32    */
33   constructor () internal {
34       _owner = msg.sender;
35       emit OwnershipTransferred(address(0), _owner);
36   }
37 
38   /**
39    * @return the address of the owner.
40    */
41   function owner() public view returns (address) {
42       return _owner;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49       require(isOwner());
50       _;
51   }
52 
53   /**
54    * @return true if `msg.sender` is the owner of the contract.
55    */
56   function isOwner() public view returns (bool) {
57       return msg.sender == _owner;
58   }
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to.
63    */
64   function transferOwnership(address newOwner) public onlyOwner {
65       _transferOwnership(newOwner);
66   }
67 
68   /**
69    * @dev Transfers control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function _transferOwnership(address newOwner) internal {
73       require(newOwner != address(0));
74       emit OwnershipTransferred(_owner, newOwner);
75       _owner = newOwner;
76   }
77 
78 }
79 
80 /**
81  * @title SafeMath
82  * @dev Math operations with safety checks that revert on error
83  */
84 library SafeMath {
85   /**
86   * @dev Multiplies two numbers, reverts on overflow.
87   */
88   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
89       // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
90       // benefit is lost if 'b' is also tested.
91       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
92       if (a == 0) {
93           return 0;
94       }
95 
96       uint256 c = a * b;
97       require(c / a == b);
98 
99       return c;
100   }
101 
102   /**
103   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
104   */
105   function div(uint256 a, uint256 b) internal pure returns (uint256) {
106       // Solidity only automatically asserts when dividing by 0
107       require(b > 0);
108       uint256 c = a / b;
109       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111       return c;
112   }
113 
114   /**
115   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
116   */
117   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
118       require(b <= a);
119       uint256 c = a - b;
120 
121       return c;
122   }
123 
124   /**
125   * @dev Adds two numbers, reverts on overflow.
126   */
127   function add(uint256 a, uint256 b) internal pure returns (uint256) {
128       uint256 c = a + b;
129       require(c >= a);
130 
131       return c;
132   }
133 
134   /**
135   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
136   * reverts when dividing by zero.
137   */
138   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139       require(b != 0);
140       return a % b;
141   }
142  
143 
144   function uint2str(uint i) internal pure returns (string){
145       if (i == 0) return "0";
146       uint j = i;
147       uint length;
148       while (j != 0){
149           length++;
150           j /= 10;
151       }
152       bytes memory bstr = new bytes(length);
153       uint k = length - 1;
154       while (i != 0){
155           bstr[k--] = byte(48 + i % 10);
156           i /= 10;
157       }
158       return string(bstr);
159   }
160  
161   
162 }
163 
164 
165 /**
166  * @title ZBX Token  
167  *
168  */
169 contract ZBXToken is ERC20, Ownable {
170   using SafeMath for uint256;
171 
172   string public constant name = "ZBX Token";
173   string public constant symbol = "ZBX"; 
174   uint8 public constant decimals = 18;
175 
176 
177 
178   mapping (address => uint256) private _balances;
179 
180   mapping (address => mapping (address => uint256)) private _allowed;
181 
182   uint256 private _totalSupply;
183 
184   //Total amount of tokens is 500,000,000 - 500 million + 18 decimals
185   uint256 public hardcap = 500000000 * (10**uint256(18));
186  
187   //Enable/Disable mint and burn functions
188   bool private _enbaleActions = true;
189 
190 
191 
192   /**
193    * @dev Constructor
194    */
195   constructor() public {
196 
197     //Set total supply to hardcap
198     _totalSupply = hardcap;
199 
200     //Transfer total supply to owner
201     _balances[owner()] = _totalSupply;
202     emit Transfer(address(0), owner(), _totalSupply);
203 
204   }
205 
206 
207   /**
208    * @dev onlyPayloadSize
209    * @notice Fix for the ERC20 short address attack.
210    */
211   modifier onlyPayloadSize(uint size) {
212     assert(msg.data.length >= size + 4);
213     _;
214   } 
215  
216 
217   /**
218    * @dev total number of tokens in existence
219    */
220   function totalSupply() public view returns (uint256) {
221     return _totalSupply;
222   }
223 
224   /**
225    * @dev Gets the balance of the specified address.
226    * @param _owner The address to query the the balance of.
227    * @return An uint256 representing the amount owned by the passed address.
228    */
229   function balanceOf(address _owner) public view returns (uint256 balance) {
230     return _balances[_owner];
231   }
232  
233  
234   /**
235    * @dev transfer token for a specified address
236    * @param _to The address to transfer to.
237    * @param _value The amount to be transferred.
238    */
239   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {    
240       require(_to != address(0)); // Prevent transfer to 0x0 address.
241       require(_value <= _balances[msg.sender]);  // Check if the sender has enough      
242 
243       // SafeMath.sub will throw if there is not enough balance.
244       _balances[msg.sender] = _balances[msg.sender].sub(_value);
245       _balances[_to] = _balances[_to].add(_value);
246       emit Transfer(msg.sender, _to, _value);
247       return true;
248   }
249 
250 
251   /**
252    * @dev Transfer tokens from one address to another
253    * @param _from address The address which you want to send tokens from
254    * @param _to address The address which you want to transfer to
255    * @param _value uint256 the amount of tokens to be transferred
256    */
257   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
258 
259     require(_to != address(0));                     // Prevent transfer to 0x0 address. Use burn() instead
260     require(_value <= _balances[_from]);             // Check if the sender has enough
261     require(_value <= _allowed[_from][msg.sender]);  // Check if the sender is _allowed to send
262 
263 
264     // SafeMath.sub will throw if there is not enough balance.
265     _balances[_from] = _balances[_from].sub(_value);
266     _balances[_to] = _balances[_to].add(_value);
267     _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
268     emit Transfer(_from, _to, _value);
269     return true; 
270   }
271 
272 
273   /**
274    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
275    *
276    * Beware that changing an allowance with this method brings the risk that someone may use both the old
277    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
278    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:  
279    * @param _spender The address which will spend the funds.
280    * @param _value The amount of tokens to be spent.
281    */
282   function approve(address _spender, uint256 _value) public returns (bool) {
283     _allowed[msg.sender][_spender] = _value;
284     emit Approval(msg.sender, _spender, _value);
285     return true;
286   }
287 
288 
289 
290   /**
291    * @dev Function to check the amount of tokens that an owner _allowed to a spender.
292    * @param _owner address The address which owns the funds.
293    * @param _spender address The address which will spend the funds.
294    * @return A uint256 specifying the amount of tokens still available for the spender.
295    */
296   function allowance(address _owner, address _spender) public view returns (uint256) {
297     return _allowed[_owner][_spender];
298   }
299 
300 
301 
302   /**
303    * @dev Increase the amount of tokens that an owner _allowed to a spender.
304    *
305    * approve should be called when _allowed[_spender] == 0. To increment
306    * _allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)   
308    * @param _spender The address which will spend the funds.
309    * @param _addedValue The amount of tokens to increase the allowance by.
310    */
311   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
312     _allowed[msg.sender][_spender] = _allowed[msg.sender][_spender].add(_addedValue);
313     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
314     return true;
315   }
316 
317 
318 
319   /**
320    * @dev Decrease the amount of tokens that an owner _allowed to a spend.
321    *
322    * approve should be called when _allowed[_spender] == 0. To decrement
323    * _allowed value is better to use this function to avoid 2 calls (and wait until
324    * the first transaction is mined)   
325    * @param _spender The address which will spend the funds.
326    * @param _subtractedValue The amount of tokens to decrease the allowance by.
327    */
328   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
329     uint oldValue = _allowed[msg.sender][_spender];
330     if (_subtractedValue > oldValue) {
331       _allowed[msg.sender][_spender] = 0;
332     } else {
333       _allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
334     }
335     emit Approval(msg.sender, _spender, _allowed[msg.sender][_spender]);
336     return true;
337   }
338 
339 
340   /**
341    * @dev Function to toggle token actions
342    * 
343    */
344   function toggleActions()  onlyOwner public {
345     if(_enbaleActions){
346       _enbaleActions = false; 
347     }else{
348       _enbaleActions = true; 
349     }     
350   }
351 
352  
353   /**
354    * @dev Burns a specific amount of tokens.
355    * @param _account The account whose tokens will be burnt.
356    * @param _value The amount of token to be burned.
357    */
358   function burn(address _account, uint256 _value) onlyOwner public {
359       require(_account != address(0));
360       require(_enbaleActions);
361 
362       // SafeMath.sub will throw if there is not enough balance.
363       _totalSupply = _totalSupply.sub(_value);
364       _balances[_account] = _balances[_account].sub(_value);
365       emit Transfer(_account, address(0), _value);
366   }
367 
368   /**
369    * @dev Function to mint tokens
370    * @param _account The address that will receive the minted tokens.
371    * @param _value The amount of tokens to mint.
372    * @return A boolean that indicates if the operation was successful.
373    */
374   function mint(address _account, uint256 _value) onlyOwner public {
375       require(_account != address(0));
376       require(_totalSupply.add(_value) <= hardcap);
377       require(_enbaleActions);
378 
379       _totalSupply = _totalSupply.add(_value);
380       _balances[_account] = _balances[_account].add(_value);
381       emit Transfer(address(0), _account, _value);
382   }
383 
384 
385   /**
386    * @dev Owner can transfer tokens that are sent to the contract by mistake
387    * 
388    */
389   function refundTokens(address _recipient, ERC20 _token)  onlyOwner public {
390     require(_token.transfer(_recipient, _token.balanceOf(this)));
391   }
392 
393 
394   /**
395    * @dev transfer balance to owner
396    * 
397    */
398   function withdrawEther(uint256 amount) onlyOwner public {
399     owner().transfer(amount);
400   }
401   
402   /**
403    * @dev accept ether
404    * 
405    */
406   function() public payable {
407   }
408 
409  
410 }