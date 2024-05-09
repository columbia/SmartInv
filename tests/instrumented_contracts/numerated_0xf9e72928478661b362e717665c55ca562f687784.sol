1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title ERC20Basic
51  * @dev Simpler version of ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/179
53  */
54 contract ERC20Basic {
55   function totalSupply() public view returns (uint256);
56   function balanceOf(address who) public view returns (uint256);
57   function transfer(address to, uint256 value) public returns (bool);
58   event Transfer(address indexed from, address indexed to, uint256 value);
59 }
60 
61 /**
62  * @title ERC20 interface
63  * @dev see https://github.com/ethereum/EIPs/issues/20
64  */
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender)
68     public view returns (uint256);
69 
70   function transferFrom(address from, address to, uint256 value)
71     public returns (bool);
72 
73   function approve(address spender, uint256 value) public returns (bool);
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title Basic token
83  * @dev Basic version of StandardToken, with no allowances.
84  */
85 contract BasicToken is ERC20Basic {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89 
90   uint256 totalSupply_;
91 
92   /**
93   * @dev total number of tokens in existence
94   */
95   function totalSupply() public view returns (uint256) {
96     return totalSupply_;
97   }
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107 
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     emit Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) public view returns (uint256) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) internal allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amount of tokens to be transferred
141    */
142   function transferFrom(
143     address _from,
144     address _to,
145     uint256 _value
146   )
147     public
148     returns (bool)
149   {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     emit Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     emit Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(
184     address _owner,
185     address _spender
186    )
187     public
188     view
189     returns (uint256)
190   {
191     return allowed[_owner][_spender];
192   }
193 
194   /**
195    * @dev Increase the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To increment
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined
200    * @param _spender The address which will spend the funds.
201    * @param _addedValue The amount of tokens to increase the allowance by.
202    */
203   function increaseApproval(
204     address _spender,
205     uint _addedValue
206   )
207     public
208     returns (bool)
209   {
210     allowed[msg.sender][_spender] = (
211       allowed[msg.sender][_spender].add(_addedValue));
212     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213     return true;
214   }
215 
216   /**
217    * @dev Decrease the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To decrement
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _subtractedValue The amount of tokens to decrease the allowance by.
225    */
226   function decreaseApproval(
227     address _spender,
228     uint _subtractedValue
229   )
230     public
231     returns (bool)
232   {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 /**
246  * @title Ownable
247  * @dev The Ownable contract has an owner address, and provides basic authorization control
248  * functions, this simplifies the implementation of "user permissions".
249  */
250 contract Ownable {
251   address public owner;
252 
253 
254   event OwnershipRenounced(address indexed previousOwner);
255   event OwnershipTransferred(
256     address indexed previousOwner,
257     address indexed newOwner
258   );
259 
260 
261   /**
262    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
263    * account.
264    */
265   constructor() public {
266     owner = msg.sender;
267   }
268 
269   /**
270    * @dev Throws if called by any account other than the owner.
271    */
272   modifier onlyOwner() {
273     require(msg.sender == owner);
274     _;
275   }
276 
277   /**
278    * @dev Allows the current owner to transfer control of the contract to a newOwner.
279    * @param newOwner The address to transfer ownership to.
280    */
281   function transferOwnership(address newOwner) public onlyOwner {
282     require(newOwner != address(0));
283     emit OwnershipTransferred(owner, newOwner);
284     owner = newOwner;
285   }
286 
287   /**
288    * @dev Allows the current owner to relinquish control of the contract.
289    */
290   function renounceOwnership() public onlyOwner {
291     emit OwnershipRenounced(owner);
292     owner = address(0);
293   }
294 }
295 
296 contract MONNEX is StandardToken, Ownable {
297   string public constant name = "MONNEX";
298   string public constant symbol = "MONN";
299   uint32 public constant decimals = 18;
300 
301   // HardCap
302   uint256 public totalTokens = uint256(150000000).mul(1 ether);
303   // Tokens for the Pre ICO and ICO stages
304   uint256 public saleTokens = uint256(100000000).mul(1 ether);
305   // ICO end
306   bool icoEnd = false;
307   // sale contract address
308   address saleContract = address(0);
309 
310   constructor(address _newOwner) public {
311     require(_newOwner != address(0));
312     owner = _newOwner;
313     uint256 tokens = totalTokens.sub(saleTokens);
314     balances[owner] = balances[owner].add(tokens);
315     totalSupply_ = totalSupply_.add(tokens);
316     emit Transfer(address(0), owner, tokens);
317   }
318 
319   modifier notBlocked() {
320     require(msg.sender == owner || msg.sender == saleContract || icoEnd);
321     _;
322   }
323 
324   function activateSaleContract(address _contractAddress) public onlyOwner {
325     require(_contractAddress != address(0));
326     require(saleContract == address(0));
327     saleContract = _contractAddress;
328     balances[saleContract] = balances[saleContract].add(saleTokens);
329     totalSupply_ = totalSupply_.add(saleTokens);
330     emit Transfer(address(0), saleContract, saleTokens);
331   }
332 
333   function endIco () public returns (bool) {
334     require(msg.sender != address(0));
335     require(msg.sender == saleContract);
336     icoEnd = true;
337     return true;
338   }
339 
340   function transfer(address to, uint256 value) public notBlocked returns (bool) {
341     return super.transfer(to, value);
342   }
343 
344   function transferFrom(address from, address to, uint256 value) public notBlocked returns (bool) {
345     return super.transferFrom(from, to, value);
346   }
347 
348   function approve(address spender, uint256 value) public notBlocked returns (bool) {
349     return super.approve(spender, value);
350   }
351 }