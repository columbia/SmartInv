1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract ERC20Basic {
6   function totalSupply() public view returns (uint256);
7   function balanceOf(address who) public view returns (uint256);
8   function transfer(address to, uint256 value) public returns (bool);
9   event Transfer(address indexed from, address indexed to, uint256 value);
10 }
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
18     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22       return 0;
23     }
24 
25     c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   /**
31   * @dev Integer division of two numbers, truncating the quotient.
32   */
33   function div(uint256 a, uint256 b) internal pure returns (uint256) {
34     // assert(b > 0); // Solidity automatically throws when dividing by 0
35     // uint256 c = a / b;
36     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37     return a / b;
38   }
39 
40   /**
41   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
42   */
43   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
52     c = a + b;
53     assert(c >= a);
54     return c;
55   }
56 }
57 
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipRenounced(address indexed previousOwner);
63   event OwnershipTransferred(
64     address indexed previousOwner,
65     address indexed newOwner
66   );
67 
68 
69   /**
70    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
71    * account.
72    */
73   constructor() public {
74     owner = msg.sender;
75   }
76 
77   /**
78    * @dev Throws if called by any account other than the owner.
79    */
80   modifier onlyOwner() {
81     require(msg.sender == owner);
82     _;
83   }
84 
85   /**
86    * @dev Allows the current owner to relinquish control of the contract.
87    * @notice Renouncing to ownership will leave the contract without an owner.
88    * It will not be possible to call the functions with the `onlyOwner`
89    * modifier anymore.
90    */
91   function renounceOwnership() public onlyOwner {
92     emit OwnershipRenounced(owner);
93     owner = address(0);
94   }
95 
96   /**
97    * @dev Allows the current owner to transfer control of the contract to a newOwner.
98    * @param _newOwner The address to transfer ownership to.
99    */
100   function transferOwnership(address _newOwner) public onlyOwner {
101     _transferOwnership(_newOwner);
102   }
103 
104   /**
105    * @dev Transfers control of the contract to a newOwner.
106    * @param _newOwner The address to transfer ownership to.
107    */
108   function _transferOwnership(address _newOwner) internal {
109     require(_newOwner != address(0));
110     emit OwnershipTransferred(owner, _newOwner);
111     owner = _newOwner;
112   }
113 }
114 
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender)
117     public view returns (uint256);
118 
119   function transferFrom(address from, address to, uint256 value)
120     public returns (bool);
121 
122   function approve(address spender, uint256 value) public returns (bool);
123   event Approval(
124     address indexed owner,
125     address indexed spender,
126     uint256 value
127   );
128 }
129 
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * @dev Total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * @dev Transfer token for a specified address
146   * @param _to The address to transfer to.
147   * @param _value The amount to be transferred.
148   */
149   function transfer(address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[msg.sender]);
152 
153     balances[msg.sender] = balances[msg.sender].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     emit Transfer(msg.sender, _to, _value);
156     return true;
157   }
158 
159   /**
160   * @dev Gets the balance of the specified address.
161   * @param _owner The address to query the the balance of.
162   * @return An uint256 representing the amount owned by the passed address.
163   */
164   function balanceOf(address _owner) public view returns (uint256) {
165     return balances[_owner];
166   }
167 
168 }
169 
170 
171 
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(
185     address _from,
186     address _to,
187     uint256 _value
188   )
189     public
190     returns (bool)
191   {
192     require(_to != address(0));
193     require(_value <= balances[_from]);
194     require(_value <= allowed[_from][msg.sender]);
195 
196     balances[_from] = balances[_from].sub(_value);
197     balances[_to] = balances[_to].add(_value);
198     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199     emit Transfer(_from, _to, _value);
200     return true;
201   }
202 
203   /**
204    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
205    * Beware that changing an allowance with this method brings the risk that someone may use both the old
206    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
207    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
208    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
209    * @param _spender The address which will spend the funds.
210    * @param _value The amount of tokens to be spent.
211    */
212   function approve(address _spender, uint256 _value) public returns (bool) {
213     allowed[msg.sender][_spender] = _value;
214     emit Approval(msg.sender, _spender, _value);
215     return true;
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
236    * @dev Increase the amount of tokens that an owner allowed to a spender.
237    * approve should be called when allowed[_spender] == 0. To increment
238    * allowed value is better to use this function to avoid 2 calls (and wait until
239    * the first transaction is mined)
240    * From MonolithDAO Token.sol
241    * @param _spender The address which will spend the funds.
242    * @param _addedValue The amount of tokens to increase the allowance by.
243    */
244   function increaseApproval(
245     address _spender,
246     uint256 _addedValue
247   )
248     public
249     returns (bool)
250   {
251     allowed[msg.sender][_spender] = (
252       allowed[msg.sender][_spender].add(_addedValue));
253     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
254     return true;
255   }
256 
257   /**
258    * @dev Decrease the amount of tokens that an owner allowed to a spender.
259    * approve should be called when allowed[_spender] == 0. To decrement
260    * allowed value is better to use this function to avoid 2 calls (and wait until
261    * the first transaction is mined)
262    * From MonolithDAO Token.sol
263    * @param _spender The address which will spend the funds.
264    * @param _subtractedValue The amount of tokens to decrease the allowance by.
265    */
266   function decreaseApproval(
267     address _spender,
268     uint256 _subtractedValue
269   )
270     public
271     returns (bool)
272   {
273     uint256 oldValue = allowed[msg.sender][_spender];
274     if (_subtractedValue > oldValue) {
275       allowed[msg.sender][_spender] = 0;
276     } else {
277       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
278     }
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283 }
284 
285 contract Terminable is Ownable {
286     bool public isTerminated = false;
287     
288     event Terminated();
289     
290     modifier whenLive() {
291         require(!isTerminated);
292         _;
293     }
294     
295     function terminate() onlyOwner whenLive public {
296         isTerminated = true;
297         emit Terminated();
298     }
299 }
300 library SafeERC20 {
301   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
302     require(token.transfer(to, value));
303   }
304 
305   function safeTransferFrom(
306     ERC20 token,
307     address from,
308     address to,
309     uint256 value
310   )
311     internal
312   {
313     require(token.transferFrom(from, to, value));
314   }
315 
316   function safeApprove(ERC20 token, address spender, uint256 value) internal {
317     require(token.approve(spender, value));
318   }
319 }
320 
321 
322 contract MBAS is StandardToken, Terminable {
323 	using SafeERC20 for ERC20;
324 	using SafeMath for uint256;
325 	
326 	string public name = "MBAS";
327 	string public symbol = "MBAS";
328 	uint8 public decimals = 18;
329 	
330 	constructor(uint256 _totalSupply) public {
331 		totalSupply_ = _totalSupply * (10 ** uint256(decimals));
332 		balances[msg.sender] = totalSupply_;
333 	}
334 	
335 	function transfer(address _to, uint256 _value) whenLive public returns (bool) {
336         return super.transfer(_to, _value);
337     }
338     
339     function transferFrom(address _from, address _to, uint256 _value)
340         whenLive
341         public
342         returns (bool)
343     {
344         return super.transferFrom(_from, _to, _value);
345     }
346 
347     function approve(address _spender, uint256 _value) 
348         whenLive 
349         public 
350         returns (bool)
351     {
352         return super.approve(_spender, _value);
353     }
354 
355     function increaseApproval(address _spender, uint _addedValue)
356         whenLive
357         public
358         returns (bool)
359     {
360         return super.increaseApproval(_spender, _addedValue);
361     }
362     
363     function decreaseApproval(address _spender, uint _subtractedValue)
364         whenLive
365         public
366         returns (bool)
367     {
368         return super.decreaseApproval(_spender, _subtractedValue);
369     }
370 }