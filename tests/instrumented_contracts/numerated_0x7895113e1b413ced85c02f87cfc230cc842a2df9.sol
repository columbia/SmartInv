1 pragma solidity ^0.4.23;
2 /*
3  compiler version: http://remix.ethereum.org/#optimize=false&version=soljson-v0.4.24+commit.e67f0147.js
4  Author: skypigr@gmail.com
5  Date: 05/28/18
6  version: 0.0.1
7 */
8 
9 
10 //////////////////////////////////////// ERC20Basic.sol ////////////////////////////////////////
11 
12 
13 /**
14  * @title ERC20Basic
15  * @dev Simpler version of ERC20 interface
16  * @dev see https://github.com/ethereum/EIPs/issues/179
17  */
18 contract ERC20Basic {
19   function totalSupply() public view returns (uint256);
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 
25 //////////////////////////////////////// SafeMath.sol ////////////////////////////////////////
26 
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33 
34   /**
35   * @dev Multiplies two numbers, throws on overflow.
36   */
37   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
38     if (a == 0) {
39       return 0;
40     }
41     c = a * b;
42     assert(c / a == b);
43     return c;
44   }
45 
46   /**
47   * @dev Integer division of two numbers, truncating the quotient.
48   */
49   function div(uint256 a, uint256 b) internal pure returns (uint256) {
50     // assert(b > 0); // Solidity automatically throws when dividing by 0
51     // uint256 c = a / b;
52     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
53     return a / b;
54   }
55 
56   /**
57   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
58   */
59   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
60     assert(b <= a);
61     return a - b;
62   }
63 
64   /**
65   * @dev Adds two numbers, throws on overflow.
66   */
67   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
68     c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 //////////////////////////////////////// BasicToken.sol ////////////////////////////////////////
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   uint256 totalSupply_;
87 
88   /**
89   * @dev total number of tokens in existence
90   */
91   function totalSupply() public view returns (uint256) {
92     return totalSupply_;
93   }
94 
95   /**
96   * @dev transfer token for a specified address
97   * @param _to The address to transfer to.
98   * @param _value The amount to be transferred.
99   */
100   function transfer(address _to, uint256 _value) public returns (bool) {
101     require(_to != address(0));
102     require(_value <= balances[msg.sender]);
103 
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 //////////////////////////////////////// ERC20.sol ////////////////////////////////////////
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender)
130     public view returns (uint256);
131 
132   function transferFrom(address from, address to, uint256 value)
133     public returns (bool);
134 
135   function approve(address spender, uint256 value) public returns (bool);
136   event Approval(
137     address indexed owner,
138     address indexed spender,
139     uint256 value
140   );
141 }
142 
143 //////////////////////////////////////// StandardToken.sol ////////////////////////////////////////
144 
145 
146 /**
147  * @title Standard ERC20 token
148  *
149  * @dev Implementation of the basic standard token.
150  * @dev https://github.com/ethereum/EIPs/issues/20
151  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, BasicToken {
154 
155   mapping (address => mapping (address => uint256)) internal allowed;
156 
157 
158   /**
159    * @dev Transfer tokens from one address to another
160    * @param _from address The address which you want to send tokens from
161    * @param _to address The address which you want to transfer to
162    * @param _value uint256 the amount of tokens to be transferred
163    */
164   function transferFrom(
165     address _from,
166     address _to,
167     uint256 _value
168   )
169     public
170     returns (bool)
171   {
172     require(_to != address(0));
173     require(_value <= balances[_from]);
174     require(_value <= allowed[_from][msg.sender]);
175 
176     balances[_from] = balances[_from].sub(_value);
177     balances[_to] = balances[_to].add(_value);
178     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
179     emit Transfer(_from, _to, _value);
180     return true;
181   }
182 
183   /**
184    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
185    *
186    * Beware that changing an allowance with this method brings the risk that someone may use both the old
187    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
188    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
189    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
190    * @param _spender The address which will spend the funds.
191    * @param _value The amount of tokens to be spent.
192    */
193   function approve(address _spender, uint256 _value) public returns (bool) {
194     allowed[msg.sender][_spender] = _value;
195     emit Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Function to check the amount of tokens that an owner allowed to a spender.
201    * @param _owner address The address which owns the funds.
202    * @param _spender address The address which will spend the funds.
203    * @return A uint256 specifying the amount of tokens still available for the spender.
204    */
205   function allowance(
206     address _owner,
207     address _spender
208    )
209     public
210     view
211     returns (uint256)
212   {
213     return allowed[_owner][_spender];
214   }
215 
216   /**
217    * @dev Increase the amount of tokens that an owner allowed to a spender.
218    *
219    * approve should be called when allowed[_spender] == 0. To increment
220    * allowed value is better to use this function to avoid 2 calls (and wait until
221    * the first transaction is mined)
222    * From MonolithDAO Token.sol
223    * @param _spender The address which will spend the funds.
224    * @param _addedValue The amount of tokens to increase the allowance by.
225    */
226   function increaseApproval(
227     address _spender,
228     uint _addedValue
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
241    *
242    * approve should be called when allowed[_spender] == 0. To decrement
243    * allowed value is better to use this function to avoid 2 calls (and wait until
244    * the first transaction is mined)
245    * From MonolithDAO Token.sol
246    * @param _spender The address which will spend the funds.
247    * @param _subtractedValue The amount of tokens to decrease the allowance by.
248    */
249   function decreaseApproval(
250     address _spender,
251     uint _subtractedValue
252   )
253     public
254     returns (bool)
255   {
256     uint oldValue = allowed[msg.sender][_spender];
257     if (_subtractedValue > oldValue) {
258       allowed[msg.sender][_spender] = 0;
259     } else {
260       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
261     }
262     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
263     return true;
264   }
265 
266 }
267 
268 //////////////////////////////////////// DetailedERC20.sol ////////////////////////////////////////
269 
270 
271 contract DetailedERC20 is ERC20 {
272   string public name;
273   string public symbol;
274   uint8 public decimals;
275 
276   constructor(string _name, string _symbol, uint8 _decimals) public {
277     name = _name;
278     symbol = _symbol;
279     decimals = _decimals;
280   }
281 }
282 
283 //////////////////////////////////////// Ownable.sol ////////////////////////////////////////
284 
285 
286 /**
287  * @title Ownable
288  * @dev The Ownable contract has an owner address, and provides basic authorization control
289  * functions, this simplifies the implementation of "user permissions".
290  */
291 contract Ownable {
292   address public owner;
293 
294 
295   event OwnershipRenounced(address indexed previousOwner);
296   event OwnershipTransferred(
297     address indexed previousOwner,
298     address indexed newOwner
299   );
300 
301 
302   /**
303    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304    * account.
305    */
306   constructor() public {
307     owner = msg.sender;
308   }
309 
310   /**
311    * @dev Throws if called by any account other than the owner.
312    */
313   modifier onlyOwner() {
314     require(msg.sender == owner);
315     _;
316   }
317 
318   /**
319    * @dev Allows the current owner to transfer control of the contract to a newOwner.
320    * @param newOwner The address to transfer ownership to.
321    */
322   function transferOwnership(address newOwner) public onlyOwner {
323     require(newOwner != address(0));
324     emit OwnershipTransferred(owner, newOwner);
325     owner = newOwner;
326   }
327 
328   /**
329    * @dev Allows the current owner to relinquish control of the contract.
330    */
331   function renounceOwnership() public onlyOwner {
332     emit OwnershipRenounced(owner);
333     owner = address(0);
334   }
335 }
336 
337 //////////////////////////////////////// CanReclaimToken.sol ////////////////////////////////////////
338 
339 
340 
341 /**
342  * @title Contracts that should be able to recover tokens
343  * @author SylTi
344  * @dev This allow a contract to recover any ERC20 token received in a contract by transferring the balance to the contract owner.
345  * This will prevent any accidental loss of tokens.
346  */
347 contract CanReclaimToken is Ownable {
348 
349   /**
350    * @dev Reclaim all ERC20Basic compatible tokens
351    * @param token ERC20Basic The address of the token contract
352    */
353   function reclaimToken(ERC20Basic token) external onlyOwner {
354     uint256 balance = token.balanceOf(this);
355     token.transfer(owner, balance);
356   }
357 
358 }
359 
360 //////////////////////////////////////// ERC20Token.sol ////////////////////////////////////////
361 
362 
363 contract ERC20Token is DetailedERC20, StandardToken, CanReclaimToken {
364     address public funder;
365 
366     constructor(string _name, string _symbol, uint8 _decimals, address _funder, uint256 _initToken)
367         public
368         DetailedERC20(_name, _symbol, _decimals)
369     {
370         uint256 initToken = _initToken.mul(10** uint256(_decimals));
371         require(address(0)!= _funder);
372         funder = _funder;
373         owner = _funder;
374         totalSupply_ = initToken;
375         balances[_funder] = initToken;
376         emit Transfer(address(0), funder, initToken);
377     }
378 }