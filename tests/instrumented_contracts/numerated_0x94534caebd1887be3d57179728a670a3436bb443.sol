1 pragma solidity ^0.5.9;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param _newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address _newOwner) public onlyOwner {
40     _transferOwnership(_newOwner);
41   }
42 
43   /**
44    * @dev Transfers control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function _transferOwnership(address _newOwner) internal {
48     require(_newOwner != address(0));
49     emit OwnershipTransferred(owner, _newOwner);
50     owner = _newOwner;
51   }
52 }
53 
54 
55 
56 /**
57  * @title SafeMath
58  * @dev Math operations with safety checks that throw on error
59  */
60 library SafeMath {
61 
62   /**
63   * @dev Multiplies two numbers, throws on overflow.
64   */
65   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
66     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
67     // benefit is lost if 'b' is also tested.
68     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
69     if (a == 0) {
70       return 0;
71     }
72 
73     c = a * b;
74     require(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // require(b > 0); // Solidity automatically throws when dividing by 0
83     // uint256 c = a / b;
84     // require(a == b * c + a % b); // There is no case in which this doesn't hold
85     return a / b;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     require(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
100     c = a + b;
101     require(c >= a);
102     return c;
103   }
104 }
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * See https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   function totalSupply() public view returns (uint256);
113   function balanceOf(address who) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 
119 /**
120  * @title Basic token
121  * @dev Basic version of StandardToken, with no allowances.
122  */
123 contract BasicToken is ERC20Basic {
124   using SafeMath for uint256;
125 
126   mapping(address => uint256) balances;
127 
128   uint256 totalSupply_;
129 
130   /**
131   * @dev Total number of tokens in existence
132   */
133   function totalSupply() public view returns (uint256) {
134     return totalSupply_;
135   }
136 
137   /**
138   * @dev Transfer token for a specified address
139   * @param _to The address to transfer to.
140   * @param _value The amount to be transferred.
141   */
142   function transfer(address _to, uint256 _value) public returns (bool) {
143     require(_value <= balances[msg.sender]);
144     require(_to != address(0));
145 
146     balances[msg.sender] = balances[msg.sender].sub(_value);
147     balances[_to] = balances[_to].add(_value);
148     emit Transfer(msg.sender, _to, _value);
149     return true;
150   }
151 
152   /**
153   * @dev Gets the balance of the specified address.
154   * @param _owner The address to query the the balance of.
155   * @return An uint256 representing the amount owned by the passed address.
156   */
157   function balanceOf(address _owner) public view returns (uint256) {
158     return balances[_owner];
159   }
160 
161 }
162 
163 
164 
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender)
172   public view returns (uint256);
173 
174   function transferFrom(address from, address to, uint256 value)
175   public returns (bool);
176 
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(
179     address indexed owner,
180     address indexed spender,
181     uint256 value
182   );
183 }
184 
185 
186 /**
187  * @title Standard ERC20 token
188  *
189  * @dev Implementation of the basic standard token.
190  * https://github.com/ethereum/EIPs/issues/20
191  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
192  */
193 contract StandardToken is ERC20, BasicToken {
194 
195   mapping (address => mapping (address => uint256)) internal allowed;
196 
197 
198   /**
199    * @dev Transfer tokens from one address to another
200    * @param _from address The address which you want to send tokens from
201    * @param _to address The address which you want to transfer to
202    * @param _value uint256 the amount of tokens to be transferred
203    */
204   function transferFrom(
205     address _from,
206     address _to,
207     uint256 _value
208   )
209     public
210     returns (bool)
211   {
212     require(_value <= balances[_from]);
213     require(_value <= allowed[_from][msg.sender]);
214     require(_to != address(0));
215 
216     balances[_from] = balances[_from].sub(_value);
217     balances[_to] = balances[_to].add(_value);
218     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
219     emit Transfer(_from, _to, _value);
220     return true;
221   }
222 
223   /**
224    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
225    * Beware that changing an allowance with this method brings the risk that someone may use both the old
226    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
227    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
228    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
229    * @param _spender The address which will spend the funds.
230    * @param _value The amount of tokens to be spent.
231    */
232   function approve(address _spender, uint256 _value) public returns (bool) {
233     allowed[msg.sender][_spender] = _value;
234     emit Approval(msg.sender, _spender, _value);
235     return true;
236   }
237 
238   /**
239    * @dev Function to check the amount of tokens that an owner allowed to a spender.
240    * @param _owner address The address which owns the funds.
241    * @param _spender address The address which will spend the funds.
242    * @return A uint256 specifying the amount of tokens still available for the spender.
243    */
244   function allowance(
245     address _owner,
246     address _spender
247   )
248     public
249     view
250     returns (uint256)
251   {
252     return allowed[_owner][_spender];
253   }
254 
255   /**
256    * @dev Increase the amount of tokens that an owner allowed to a spender.
257    * approve should be called when allowed[_spender] == 0. To increment
258    * allowed value is better to use this function to avoid 2 calls (and wait until
259    * the first transaction is mined)
260    * From MonolithDAO Token.sol
261    * @param _spender The address which will spend the funds.
262    * @param _addedValue The amount of tokens to increase the allowance by.
263    */
264   function increaseApproval(
265     address _spender,
266     uint256 _addedValue
267   )
268     public
269     returns (bool)
270   {
271     allowed[msg.sender][_spender] = (
272     allowed[msg.sender][_spender].add(_addedValue));
273     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
274     return true;
275   }
276 
277   /**
278    * @dev Decrease the amount of tokens that an owner allowed to a spender.
279    * approve should be called when allowed[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param _spender The address which will spend the funds.
284    * @param _subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseApproval(
287     address _spender,
288     uint256 _subtractedValue
289   )
290     public
291     returns (bool)
292   {
293     uint256 oldValue = allowed[msg.sender][_spender];
294     if (_subtractedValue >= oldValue) {
295       allowed[msg.sender][_spender] = 0;
296     } else {
297       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
298     }
299     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
300     return true;
301   }
302 
303 }
304 
305 
306 contract IrbisToken is StandardToken, Ownable {
307 
308     string public constant name = 'Irbis Network';
309 
310     string public constant symbol = 'IBS';
311 
312     uint32 public constant decimals = 18;
313 
314     uint256 public INITIAL_SUPPLY = 100000000 * 1 ether; 
315 
316     /**
317    * @dev Constructor that gives tokenHolderContract all of existing tokens.
318    */
319     constructor() public {
320         totalSupply_ = INITIAL_SUPPLY;
321         balances[msg.sender] = INITIAL_SUPPLY;
322         emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
323     }
324 
325 }
326 
327 
328 contract IEOIBS is Ownable {
329 
330     using SafeMath for uint;
331 
332     uint public firstDate;
333     uint public secondDate;
334 
335     uint public firstLimit;
336     uint public secondLimit;
337 
338     IrbisToken private IBS;
339 
340     constructor(address _IBS) public {
341 
342         //UTC time
343         firstDate = 1577836800; // Wed, 01 Jan 2020 00:00:00 GMT
344         secondDate = 1592092800; // Sun, 14 Jun 2020 00:00:00 GMT
345 
346         firstLimit = 60000000 * 1 ether;
347         secondLimit = 30000000 * 1 ether;
348 
349         IBS = IrbisToken(_IBS);
350     }
351 
352     function withdraw(address _recipient, uint _amount) public onlyOwner {
353         if(now <= firstDate) {
354             
355             require(IBS.balanceOf(address(this)) >= firstLimit.add(_amount), 
356             "Tokens will be available after Wed, 01 Jan 2020 00:00:00 GMT"); 
357 
358         }
359         else if(firstDate < now && now <= secondDate) {
360 
361             require(IBS.balanceOf(address(this))  >= secondLimit.add(_amount),
362             "Tokens will be available after Sun, 14 Jun 2020 00:00:00 GMT");
363 
364         } 
365         
366         IBS.transfer(_recipient, _amount);
367         
368     }
369     
370 }