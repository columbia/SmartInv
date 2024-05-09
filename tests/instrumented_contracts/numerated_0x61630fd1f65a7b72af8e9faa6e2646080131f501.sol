1 pragma solidity ^0.4.23;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipRenounced(address indexed previousOwner);
28   event OwnershipTransferred(
29     address indexed previousOwner,
30     address indexed newOwner
31   );
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
36    * account.
37    */
38   constructor() public {
39     owner = msg.sender;
40   }
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   /**
51    * @dev Allows the current owner to relinquish control of the contract.
52    */
53   function renounceOwnership() public onlyOwner {
54     emit OwnershipRenounced(owner);
55     owner = address(0);
56   }
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param _newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address _newOwner) public onlyOwner {
63     _transferOwnership(_newOwner);
64   }
65 
66   /**
67    * @dev Transfers control of the contract to a newOwner.
68    * @param _newOwner The address to transfer ownership to.
69    */
70   function _transferOwnership(address _newOwner) internal {
71     require(_newOwner != address(0));
72     emit OwnershipTransferred(owner, _newOwner);
73     owner = _newOwner;
74   }
75 }
76 
77 
78 
79 
80 
81 
82 
83 
84 
85 
86 
87 /**
88  * @title SafeMath
89  * @dev Math operations with safety checks that throw on error
90  */
91 library SafeMath {
92 
93   /**
94   * @dev Multiplies two numbers, throws on overflow.
95   */
96   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
97     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
98     // benefit is lost if 'b' is also tested.
99     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
100     if (a == 0) {
101       return 0;
102     }
103 
104     c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   /**
110   * @dev Integer division of two numbers, truncating the quotient.
111   */
112   function div(uint256 a, uint256 b) internal pure returns (uint256) {
113     // assert(b > 0); // Solidity automatically throws when dividing by 0
114     // uint256 c = a / b;
115     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116     return a / b;
117   }
118 
119   /**
120   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
121   */
122   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
123     assert(b <= a);
124     return a - b;
125   }
126 
127   /**
128   * @dev Adds two numbers, throws on overflow.
129   */
130   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
131     c = a + b;
132     assert(c >= a);
133     return c;
134   }
135 }
136 
137 
138 
139 /**
140  * @title Basic token
141  * @dev Basic version of StandardToken, with no allowances.
142  */
143 contract BasicToken is ERC20Basic {
144   using SafeMath for uint256;
145 
146   mapping(address => uint256) balances;
147 
148   uint256 totalSupply_;
149 
150   /**
151   * @dev total number of tokens in existence
152   */
153   function totalSupply() public view returns (uint256) {
154     return totalSupply_;
155   }
156 
157   /**
158   * @dev transfer token for a specified address
159   * @param _to The address to transfer to.
160   * @param _value The amount to be transferred.
161   */
162   function transfer(address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[msg.sender]);
165 
166     balances[msg.sender] = balances[msg.sender].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     emit Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   /**
173   * @dev Gets the balance of the specified address.
174   * @param _owner The address to query the the balance of.
175   * @return An uint256 representing the amount owned by the passed address.
176   */
177   function balanceOf(address _owner) public view returns (uint256) {
178     return balances[_owner];
179   }
180 
181 }
182 
183 
184 
185 
186 
187 
188 /**
189  * @title ERC20 interface
190  * @dev see https://github.com/ethereum/EIPs/issues/20
191  */
192 contract ERC20 is ERC20Basic {
193   function allowance(address owner, address spender)
194     public view returns (uint256);
195 
196   function transferFrom(address from, address to, uint256 value)
197     public returns (bool);
198 
199   function approve(address spender, uint256 value) public returns (bool);
200   event Approval(
201     address indexed owner,
202     address indexed spender,
203     uint256 value
204   );
205 }
206 
207 
208 
209 /**
210  * @title Standard ERC20 token
211  *
212  * @dev Implementation of the basic standard token.
213  * @dev https://github.com/ethereum/EIPs/issues/20
214  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
215  */
216 contract StandardToken is ERC20, BasicToken {
217 
218   mapping (address => mapping (address => uint256)) internal allowed;
219 
220 
221   /**
222    * @dev Transfer tokens from one address to another
223    * @param _from address The address which you want to send tokens from
224    * @param _to address The address which you want to transfer to
225    * @param _value uint256 the amount of tokens to be transferred
226    */
227   function transferFrom(
228     address _from,
229     address _to,
230     uint256 _value
231   )
232     public
233     returns (bool)
234   {
235     require(_to != address(0));
236     require(_value <= balances[_from]);
237     require(_value <= allowed[_from][msg.sender]);
238 
239     balances[_from] = balances[_from].sub(_value);
240     balances[_to] = balances[_to].add(_value);
241     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
242     emit Transfer(_from, _to, _value);
243     return true;
244   }
245 
246   /**
247    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
248    *
249    * Beware that changing an allowance with this method brings the risk that someone may use both the old
250    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
251    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
252    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
253    * @param _spender The address which will spend the funds.
254    * @param _value The amount of tokens to be spent.
255    */
256   function approve(address _spender, uint256 _value) public returns (bool) {
257     allowed[msg.sender][_spender] = _value;
258     emit Approval(msg.sender, _spender, _value);
259     return true;
260   }
261 
262   /**
263    * @dev Function to check the amount of tokens that an owner allowed to a spender.
264    * @param _owner address The address which owns the funds.
265    * @param _spender address The address which will spend the funds.
266    * @return A uint256 specifying the amount of tokens still available for the spender.
267    */
268   function allowance(
269     address _owner,
270     address _spender
271    )
272     public
273     view
274     returns (uint256)
275   {
276     return allowed[_owner][_spender];
277   }
278 
279   /**
280    * @dev Increase the amount of tokens that an owner allowed to a spender.
281    *
282    * approve should be called when allowed[_spender] == 0. To increment
283    * allowed value is better to use this function to avoid 2 calls (and wait until
284    * the first transaction is mined)
285    * From MonolithDAO Token.sol
286    * @param _spender The address which will spend the funds.
287    * @param _addedValue The amount of tokens to increase the allowance by.
288    */
289   function increaseApproval(
290     address _spender,
291     uint _addedValue
292   )
293     public
294     returns (bool)
295   {
296     allowed[msg.sender][_spender] = (
297       allowed[msg.sender][_spender].add(_addedValue));
298     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
299     return true;
300   }
301 
302   /**
303    * @dev Decrease the amount of tokens that an owner allowed to a spender.
304    *
305    * approve should be called when allowed[_spender] == 0. To decrement
306    * allowed value is better to use this function to avoid 2 calls (and wait until
307    * the first transaction is mined)
308    * From MonolithDAO Token.sol
309    * @param _spender The address which will spend the funds.
310    * @param _subtractedValue The amount of tokens to decrease the allowance by.
311    */
312   function decreaseApproval(
313     address _spender,
314     uint _subtractedValue
315   )
316     public
317     returns (bool)
318   {
319     uint oldValue = allowed[msg.sender][_spender];
320     if (_subtractedValue > oldValue) {
321       allowed[msg.sender][_spender] = 0;
322     } else {
323       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
324     }
325     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
326     return true;
327   }
328 
329 }
330 
331 
332 
333 
334 /**
335  * @title PesaPepe
336  *  Implementation of PEP, an ERC20 token for the PesaPepe ecosystem.
337  */
338 contract PesaPepe is StandardToken, Ownable {
339 
340   string public constant name = "PesaPepe"; 
341   string public constant symbol = "PEP"; 
342   uint8 public constant decimals = 18; 
343 
344   uint256 public constant INITIAL_SUPPLY = 900000000 * (10 ** uint256(decimals));
345 
346   /**
347    * @dev Constructor that gives the tokens_Owner all of existing tokens.
348    */
349   constructor(address _admin) public {
350     totalSupply_ = INITIAL_SUPPLY;
351 	balances[_admin] = INITIAL_SUPPLY;
352 	emit Transfer(address(0x0), _admin, INITIAL_SUPPLY);
353   }
354   
355 }