1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
11     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
12     // benefit is lost if 'b' is also tested.
13     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14     if (a == 0) {
15       return 0;
16     }
17 
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 contract Ownable {
52   address public owner;
53 
54 
55   event OwnershipRenounced(address indexed previousOwner);
56   event OwnershipTransferred(
57     address indexed previousOwner,
58     address indexed newOwner
59   );
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   constructor() public {
67     owner = msg.sender;
68   }
69 
70   /**
71    * @dev Throws if called by any account other than the owner.
72    */
73   modifier onlyOwner() {
74     require(msg.sender == owner);
75     _;
76   }
77 
78   /**
79    * @dev Allows the current owner to relinquish control of the contract.
80    * @notice Renouncing to ownership will leave the contract without an owner.
81    * It will not be possible to call the functions with the `onlyOwner`
82    * modifier anymore.
83    */
84   function renounceOwnership() public onlyOwner {
85     emit OwnershipRenounced(owner);
86     owner = address(0);
87   }
88 
89   /**
90    * @dev Allows the current owner to transfer control of the contract to a newOwner.
91    * @param _newOwner The address to transfer ownership to.
92    */
93   function transferOwnership(address _newOwner) public onlyOwner {
94     _transferOwnership(_newOwner);
95   }
96 
97   /**
98    * @dev Transfers control of the contract to a newOwner.
99    * @param _newOwner The address to transfer ownership to.
100    */
101   function _transferOwnership(address _newOwner) internal {
102     require(_newOwner != address(0));
103     emit OwnershipTransferred(owner, _newOwner);
104     owner = _newOwner;
105   }
106 }
107 
108 contract ERC20Basic {
109   function totalSupply() public view returns (uint256);
110   function balanceOf(address who) public view returns (uint256);
111   function transfer(address to, uint256 value) public returns (bool);
112   event Transfer(address indexed from, address indexed to, uint256 value);
113 }
114 
115 library SafeERC20 {
116   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
117     require(token.transfer(to, value));
118   }
119 
120   function safeTransferFrom(
121     ERC20 token,
122     address from,
123     address to,
124     uint256 value
125   )
126     internal
127   {
128     require(token.transferFrom(from, to, value));
129   }
130 
131   function safeApprove(ERC20 token, address spender, uint256 value) internal {
132     require(token.approve(spender, value));
133   }
134 }
135 
136 contract BasicToken is ERC20Basic {
137   using SafeMath for uint256;
138 
139   mapping(address => uint256) balances;
140 
141   uint256 totalSupply_;
142 
143   /**
144   * @dev Total number of tokens in existence
145   */
146   function totalSupply() public view returns (uint256) {
147     return totalSupply_;
148   }
149 
150   /**
151   * @dev Transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155   function transfer(address _to, uint256 _value) public returns (bool) {
156     require(_to != address(0));
157     require(_value <= balances[msg.sender]);
158 
159     balances[msg.sender] = balances[msg.sender].sub(_value);
160     balances[_to] = balances[_to].add(_value);
161     emit Transfer(msg.sender, _to, _value);
162     return true;
163   }
164 
165   /**
166   * @dev Gets the balance of the specified address.
167   * @param _owner The address to query the the balance of.
168   * @return An uint256 representing the amount owned by the passed address.
169   */
170   function balanceOf(address _owner) public view returns (uint256) {
171     return balances[_owner];
172   }
173 
174 }
175 
176 contract ERC20 is ERC20Basic {
177   function allowance(address owner, address spender)
178     public view returns (uint256);
179 
180   function transferFrom(address from, address to, uint256 value)
181     public returns (bool);
182 
183   function approve(address spender, uint256 value) public returns (bool);
184   event Approval(
185     address indexed owner,
186     address indexed spender,
187     uint256 value
188   );
189 }
190 
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
202   function transferFrom(
203     address _from,
204     address _to,
205     uint256 _value
206   )
207     public
208     returns (bool)
209   {
210     require(_to != address(0));
211     require(_value <= balances[_from]);
212     require(_value <= allowed[_from][msg.sender]);
213 
214     balances[_from] = balances[_from].sub(_value);
215     balances[_to] = balances[_to].add(_value);
216     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
217     emit Transfer(_from, _to, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
223    * Beware that changing an allowance with this method brings the risk that someone may use both the old
224    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
225    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
226    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
227    * @param _spender The address which will spend the funds.
228    * @param _value The amount of tokens to be spent.
229    */
230   function approve(address _spender, uint256 _value) public returns (bool) {
231     allowed[msg.sender][_spender] = _value;
232     emit Approval(msg.sender, _spender, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Function to check the amount of tokens that an owner allowed to a spender.
238    * @param _owner address The address which owns the funds.
239    * @param _spender address The address which will spend the funds.
240    * @return A uint256 specifying the amount of tokens still available for the spender.
241    */
242   function allowance(
243     address _owner,
244     address _spender
245    )
246     public
247     view
248     returns (uint256)
249   {
250     return allowed[_owner][_spender];
251   }
252 
253   /**
254    * @dev Increase the amount of tokens that an owner allowed to a spender.
255    * approve should be called when allowed[_spender] == 0. To increment
256    * allowed value is better to use this function to avoid 2 calls (and wait until
257    * the first transaction is mined)
258    * From MonolithDAO Token.sol
259    * @param _spender The address which will spend the funds.
260    * @param _addedValue The amount of tokens to increase the allowance by.
261    */
262   function increaseApproval(
263     address _spender,
264     uint256 _addedValue
265   )
266     public
267     returns (bool)
268   {
269     allowed[msg.sender][_spender] = (
270       allowed[msg.sender][_spender].add(_addedValue));
271     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275   /**
276    * @dev Decrease the amount of tokens that an owner allowed to a spender.
277    * approve should be called when allowed[_spender] == 0. To decrement
278    * allowed value is better to use this function to avoid 2 calls (and wait until
279    * the first transaction is mined)
280    * From MonolithDAO Token.sol
281    * @param _spender The address which will spend the funds.
282    * @param _subtractedValue The amount of tokens to decrease the allowance by.
283    */
284   function decreaseApproval(
285     address _spender,
286     uint256 _subtractedValue
287   )
288     public
289     returns (bool)
290   {
291     uint256 oldValue = allowed[msg.sender][_spender];
292     if (_subtractedValue > oldValue) {
293       allowed[msg.sender][_spender] = 0;
294     } else {
295       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
296     }
297     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
298     return true;
299   }
300 
301 }
302 
303 contract Terminable is Ownable {
304     bool isTerminated = false;
305     
306     event Terminated();
307     
308     modifier whenLive() {
309         require(!isTerminated);
310         _;
311     }
312     
313     function terminate() onlyOwner whenLive public {
314         isTerminated = true;
315         emit Terminated();
316     }
317 }
318 
319 contract MBACC is StandardToken, Terminable {
320 	using SafeERC20 for ERC20;
321 	using SafeMath for uint256;
322 	
323 	string public name = "MBACC";
324 	string public symbol = "MBA";
325 	uint8 public decimals = 18;
326 
327     mapping (address => bool) issued;
328     uint256 public eachIssuedAmount;
329 	
330 	constructor(uint256 _totalSupply, uint256 _eachIssuedAmount) public {
331 	    require(_totalSupply >= _eachIssuedAmount);
332 	    
333 		totalSupply_ = _totalSupply * (10 ** uint256(decimals));
334 		eachIssuedAmount = _eachIssuedAmount * (10 ** uint256(decimals));
335 		
336 		balances[msg.sender] = totalSupply_;
337 		issued[msg.sender] = true;
338 	}
339 	
340 	function issue() whenLive public {
341 	    require(balances[owner] >= eachIssuedAmount);
342 	    require(!issued[msg.sender]);
343 	    
344 	    balances[owner] = balances[owner].sub(eachIssuedAmount);
345 	    balances[msg.sender] = balances[msg.sender].add(eachIssuedAmount);
346 	    issued[msg.sender] = true;
347 	    
348 	    emit Transfer(owner, msg.sender, eachIssuedAmount);
349 	}
350 	
351 	function transfer(address _to, uint256 _value) whenLive public returns (bool) {
352         return super.transfer(_to, _value);
353     }
354     
355     function transferFrom(address _from, address _to, uint256 _value)
356         whenLive
357         public
358         returns (bool)
359     {
360         return super.transferFrom(_from, _to, _value);
361     }
362 
363     function approve(address _spender, uint256 _value) 
364         whenLive 
365         public 
366         returns (bool)
367     {
368         return super.approve(_spender, _value);
369     }
370 
371     function increaseApproval(address _spender, uint _addedValue)
372         whenLive
373         public
374         returns (bool)
375     {
376         return super.increaseApproval(_spender, _addedValue);
377     }
378     
379     function decreaseApproval(address _spender, uint _subtractedValue)
380         whenLive
381         public
382         returns (bool)
383     {
384         return super.decreaseApproval(_spender, _subtractedValue);
385     }
386 }