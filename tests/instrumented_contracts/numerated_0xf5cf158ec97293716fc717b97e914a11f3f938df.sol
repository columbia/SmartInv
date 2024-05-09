1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
9     if (a == 0) {   
10       return 0;
11     }
12     c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   /**
18   * @dev Integer division of two numbers, truncating the quotient.
19   */
20   function div(uint256 a, uint256 b) internal pure returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     // uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return a / b;
25   }
26 
27   /**
28   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
29   */
30   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   /**
36   * @dev Adds two numbers, throws on overflow.
37   */
38   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
39     c = a + b;
40     assert(c >= a);
41     return c;
42   }
43 }
44 
45 contract Ownable {
46   address public owner;
47 
48 
49   event OwnershipRenounced(address indexed previousOwner);
50   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
51 
52 
53   /**
54    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55    * account.
56    */
57   constructor() public {
58     owner = msg.sender;
59   }
60 
61   /**
62    * @dev Throws if called by any account other than the owner.
63    */
64   modifier onlyOwner() {
65     require(msg.sender == owner);
66     _;
67   }
68 
69   /**
70    * @dev Allows the current owner to transfer control of the contract to a newOwner.
71    * @param newOwner The address to transfer ownership to.
72    */
73   function transferOwnership(address newOwner) public onlyOwner {
74     require(newOwner != address(0));
75     emit OwnershipTransferred(owner, newOwner);
76     owner = newOwner;
77   }
78 
79   /**
80    * @dev Allows the current owner to relinquish control of the contract.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 }
87 
88 contract Pausable is Ownable {
89   event Pause();
90   event Unpause();
91 
92   bool public paused = false;
93 
94 
95   /**
96    * @dev Modifier to make a function callable only when the contract is not paused.
97    */
98   modifier whenNotPaused() {
99     require(!paused);
100     _;
101   }
102 
103   /**
104    * @dev Modifier to make a function callable only when the contract is paused.
105    */
106   modifier whenPaused() {
107     require(paused);
108     _;
109   }
110 
111   /**
112    * @dev called by the owner to pause, triggers stopped state
113    */
114   function pause() onlyOwner whenNotPaused public {
115     paused = true;
116     emit Pause();
117   }
118 
119   /**
120    * @dev called by the owner to unpause, returns to normal state
121    */
122   function unpause() onlyOwner whenPaused public {
123     paused = false;
124     emit Unpause();
125   }
126 }
127 
128 contract ERC20Basic {
129   function totalSupply() public view returns (uint256);
130   function balanceOf(address who) public view returns (uint256);
131   function transfer(address to, uint256 value) public returns (bool);
132   event Transfer(address indexed from, address indexed to, uint256 value);
133 }
134 
135 contract ERC20 is ERC20Basic {
136   function allowance(address owner, address spender) public view returns (uint256);
137   function transferFrom(address from, address to, uint256 value) public returns (bool);
138   function approve(address spender, uint256 value) public returns (bool);
139   event Approval(address indexed owner, address indexed spender, uint256 value);
140 }
141 
142 contract BasicToken is ERC20Basic {
143   using SafeMath for uint256;
144 
145   mapping(address => uint256) balances;
146 
147   uint256 totalSupply_;
148 
149   /**
150   * @dev total number of tokens in existence
151   */
152   function totalSupply() public view returns (uint256) {
153     return totalSupply_;
154   }
155 
156   /**
157   * @dev transfer token for a specified address
158   * @param _to The address to transfer to.
159   * @param _value The amount to be transferred.
160   */
161   function transfer(address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[msg.sender]);
164 
165     balances[msg.sender] = balances[msg.sender].sub(_value);
166     balances[_to] = balances[_to].add(_value);
167     emit Transfer(msg.sender, _to, _value);
168     return true;
169   }
170 
171   /**
172   * @dev Gets the balance of the specified address.
173   * @param _owner The address to query the the balance of.
174   * @return An uint256 representing the amount owned by the passed address.
175   */
176   function balanceOf(address _owner) public view returns (uint256) {
177     return balances[_owner];
178   }
179 
180 }
181 
182 contract StandardToken is ERC20, BasicToken {
183 
184   mapping (address => mapping (address => uint256)) internal allowed;
185 
186 
187   /**
188    * @dev Transfer tokens from one address to another
189    * @param _from address The address which you want to send tokens from
190    * @param _to address The address which you want to transfer to
191    * @param _value uint256 the amount of tokens to be transferred
192    */
193   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
194     require(_to != address(0));
195     require(_value <= balances[_from]);
196     require(_value <= allowed[_from][msg.sender]);
197 
198     balances[_from] = balances[_from].sub(_value);
199     balances[_to] = balances[_to].add(_value);
200     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
201     emit Transfer(_from, _to, _value);
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    *
208    * Beware that changing an allowance with this method brings the risk that someone may use both the old
209    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
210    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
211    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212    * @param _spender The address which will spend the funds.
213    * @param _value The amount of tokens to be spent.
214    */
215   function approve(address _spender, uint256 _value) public returns (bool) {
216     allowed[msg.sender][_spender] = _value;
217     emit Approval(msg.sender, _spender, _value);
218     return true;
219   }
220 
221   /**
222    * @dev Function to check the amount of tokens that an owner allowed to a spender.
223    * @param _owner address The address which owns the funds.
224    * @param _spender address The address which will spend the funds.
225    * @return A uint256 specifying the amount of tokens still available for the spender.
226    */
227   function allowance(address _owner, address _spender) public view returns (uint256) {
228     return allowed[_owner][_spender];
229   }
230 
231   /**
232    * @dev Increase the amount of tokens that an owner allowed to a spender.
233    *
234    * approve should be called when allowed[_spender] == 0. To increment
235    * allowed value is better to use this function to avoid 2 calls (and wait until
236    * the first transaction is mined)
237    * From MonolithDAO Token.sol
238    * @param _spender The address which will spend the funds.
239    * @param _addedValue The amount of tokens to increase the allowance by.
240    */
241   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
242     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
258     uint oldValue = allowed[msg.sender][_spender];
259     if (_subtractedValue > oldValue) {
260       allowed[msg.sender][_spender] = 0;
261     } else {
262       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
263     }
264     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
265     return true;
266   }
267 
268 }
269 
270 contract PausableToken is StandardToken, Pausable {
271 
272   function transfer(
273     address _to,
274     uint256 _value
275   )
276     public
277     whenNotPaused
278     returns (bool)
279   {
280     return super.transfer(_to, _value);
281   }
282 
283   function transferFrom(
284     address _from,
285     address _to,
286     uint256 _value
287   )
288     public
289     whenNotPaused
290     returns (bool)
291   {
292     return super.transferFrom(_from, _to, _value);
293   }
294 
295   function approve(
296     address _spender,
297     uint256 _value
298   )
299     public
300     whenNotPaused
301     returns (bool)
302   {
303     return super.approve(_spender, _value);
304   }
305 
306   function increaseApproval(
307     address _spender,
308     uint _addedValue
309   )
310     public
311     whenNotPaused
312     returns (bool success)
313   {
314     return super.increaseApproval(_spender, _addedValue);
315   }
316 
317   function decreaseApproval(
318     address _spender,
319     uint _subtractedValue
320   )
321     public
322     whenNotPaused
323     returns (bool success)
324   {
325     return super.decreaseApproval(_spender, _subtractedValue);
326   }
327 }
328 
329 contract Yangzaizai is PausableToken {
330     
331     string public name = "洋崽崽币";
332     string public symbol = "YZZ";
333     uint8 public decimals = 18;
334     
335     constructor () public {
336         totalSupply_=5201314*(10**(uint256(decimals)));
337         balances[msg.sender] = totalSupply_;
338     }
339     
340 	function withdrawEther(uint256 amount) onlyOwner public {
341 		owner.transfer(amount);
342 	}
343 	
344 	function() payable public {
345     }
346     
347 }