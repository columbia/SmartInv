1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(
13     address indexed previousOwner,
14     address indexed newOwner
15   );
16 
17 
18   /**
19    * The Ownable constructor sets the original `owner` of the contract to the sender
20    * account.
21    */
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   /**
27    * Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34   /**
35    * Allows the current owner to relinquish control of the contract.
36    */
37   function renounceOwnership() public onlyOwner {
38     emit OwnershipRenounced(owner);
39     owner = address(0);
40   }
41 
42   /**
43    * Allows the current owner to transfer control of the contract to a newOwner.
44    * @param _newOwner The address to transfer ownership to.
45    */
46   function transferOwnership(address _newOwner) public onlyOwner {
47     _transferOwnership(_newOwner);
48   }
49 
50   /**
51    * Transfers control of the contract to a newOwner.
52    * @param _newOwner The address to transfer ownership to.
53    */
54   function _transferOwnership(address _newOwner) internal {
55     require(_newOwner != address(0));
56     emit OwnershipTransferred(owner, _newOwner);
57     owner = _newOwner;
58   }
59 }
60 
61 
62 /**
63  * @title SafeMath
64  * Math operations with safety checks that throw on error
65  */
66 library SafeMath {
67 
68   /**
69   * Multiplies two numbers, throws on overflow.
70   */
71   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
72     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
73     // benefit is lost if 'b' is also tested.
74     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
75     if (a == 0) {
76       return 0;
77     }
78 
79     c = a * b;
80     assert(c / a == b);
81     return c;
82   }
83 
84   /**
85   * Integer division of two numbers, truncating the quotient.
86   */
87   function div(uint256 a, uint256 b) internal pure returns (uint256) {
88     // assert(b > 0); // Solidity automatically throws when dividing by 0
89     // uint256 c = a / b;
90     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
91     return a / b;
92   }
93 
94   /**
95   * Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
96   */
97   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
98     assert(b <= a);
99     return a - b;
100   }
101 
102   /**
103   * Adds two numbers, throws on overflow.
104   */
105   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
106     c = a + b;
107     assert(c >= a);
108     return c;
109   }
110 }
111 
112 
113 /**
114  * @title ERC20Basic
115  * Simpler version of ERC20 interface
116  * see https://github.com/ethereum/EIPs/issues/179
117  */
118 contract ERC20Basic {
119   function totalSupply() public view returns (uint256);
120   function balanceOf(address who) public view returns (uint256);
121   function transfer(address to, uint256 value) public returns (bool);
122   event Transfer(address indexed from, address indexed to, uint256 value);
123 }
124 
125 
126 /**
127  * @title Basic token
128  * Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131   using SafeMath for uint256;
132 
133   mapping(address => uint256) balances;
134 
135   uint256 totalSupply_;
136 
137   /**
138   * total number of tokens in existence
139   */
140   function totalSupply() public view returns (uint256) {
141     return totalSupply_;
142   }
143 
144   /**
145   * transfer token for a specified address
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
160   * Gets the balance of the specified address.
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
171 /**
172  * @title ERC20 interface
173  * see https://github.com/ethereum/EIPs/issues/20
174  */
175 contract ERC20 is ERC20Basic {
176   function allowance(address owner, address spender)
177     public view returns (uint256);
178 
179   function transferFrom(address from, address to, uint256 value)
180     public returns (bool);
181 
182   function approve(address spender, uint256 value) public returns (bool);
183   event Approval(
184     address indexed owner,
185     address indexed spender,
186     uint256 value
187   );
188 }
189 
190 
191 /**
192  * @title Standard ERC20 token
193  *
194  * Implementation of the basic standard token.
195  * https://github.com/ethereum/EIPs/issues/20
196  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
197  */
198 contract StandardToken is ERC20, BasicToken {
199 
200   mapping (address => mapping (address => uint256)) internal allowed;
201 
202   /**
203    * Transfer tokens from one address to another
204    * @param _from address The address which you want to send tokens from
205    * @param _to address The address which you want to transfer to
206    * @param _value uint256 the amount of tokens to be transferred
207    */
208   function transferFrom(
209     address _from,
210     address _to,
211     uint256 _value
212   )
213     public
214     returns (bool)
215   {
216     require(_to != address(0));
217     require(_value <= balances[_from]);
218     require(_value <= allowed[_from][msg.sender]);
219 
220     balances[_from] = balances[_from].sub(_value);
221     balances[_to] = balances[_to].add(_value);
222     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
223     emit Transfer(_from, _to, _value);
224     return true;
225   }
226 
227   /**
228    * Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
229    *
230    * Beware that changing an allowance with this method brings the risk that someone may use both the old
231    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
232    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
233    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234    * @param _spender The address which will spend the funds.
235    * @param _value The amount of tokens to be spent.
236    */
237   function approve(address _spender, uint256 _value) public returns (bool) {
238     allowed[msg.sender][_spender] = _value;
239     emit Approval(msg.sender, _spender, _value);
240     return true;
241   }
242 
243   /**
244    * Function to check the amount of tokens that an owner allowed to a spender.
245    * @param _owner address The address which owns the funds.
246    * @param _spender address The address which will spend the funds.
247    * @return A uint256 specifying the amount of tokens still available for the spender.
248    */
249   function allowance(
250     address _owner,
251     address _spender
252    )
253     public
254     view
255     returns (uint256)
256   {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * Increase the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(
271     address _spender,
272     uint _addedValue
273   )
274     public
275     returns (bool)
276   {
277     allowed[msg.sender][_spender] = (
278       allowed[msg.sender][_spender].add(_addedValue));
279     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
280     return true;
281   }
282 
283   /**
284    * Decrease the amount of tokens that an owner allowed to a spender.
285    *
286    * approve should be called when allowed[_spender] == 0. To decrement
287    * allowed value is better to use this function to avoid 2 calls (and wait until
288    * the first transaction is mined)
289    * From MonolithDAO Token.sol
290    * @param _spender The address which will spend the funds.
291    * @param _subtractedValue The amount of tokens to decrease the allowance by.
292    */
293   function decreaseApproval(
294     address _spender,
295     uint _subtractedValue
296   )
297     public
298     returns (bool)
299   {
300     uint oldValue = allowed[msg.sender][_spender];
301     if (_subtractedValue > oldValue) {
302       allowed[msg.sender][_spender] = 0;
303     } else {
304       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
305     }
306     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
307     return true;
308   }
309 
310 }
311 
312 
313 contract TokenCSR is StandardToken, Ownable {
314     string public name;
315     string public symbol;
316     uint8 public decimals;
317 
318     constructor (
319         string paramName,
320         string paramDymbol,
321         uint8 paramDecimals,
322         uint256  paramInitialSupply
323     ) public
324     {
325         name = paramName;
326         symbol = paramDymbol;
327         decimals = paramDecimals;
328         totalSupply_ = paramInitialSupply;
329 
330         balances[msg.sender] = paramInitialSupply;
331     }
332 
333     function multisend(address[] dests, uint256[] values)
334     public onlyOwner
335     returns (uint256) {
336         uint256 i = 0;
337         while (i < dests.length) {
338            transfer(dests[i], values[i]);
339            i += 1;
340         }
341         return(i);
342     }
343 }