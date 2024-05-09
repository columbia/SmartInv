1 pragma solidity ^0.4.24;
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
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
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
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
61      * account.
62      */
63     constructor () internal {
64         _owner = msg.sender;
65         emit OwnershipTransferred(address(0), _owner);
66     }
67 
68     /**
69      * @return the address of the owner.
70      */
71     function owner() public view returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(isOwner());
80         _;
81     }
82 
83     /**
84      * @return true if `msg.sender` is the owner of the contract.
85      */
86     function isOwner() public view returns (bool) {
87         return msg.sender == _owner;
88     }
89 
90     /**
91      * @dev Allows the current owner to relinquish control of the contract.
92      * @notice Renouncing to ownership will leave the contract without an owner.
93      * It will not be possible to call the functions with the `onlyOwner`
94      * modifier anymore.
95      */
96     function renounceOwnership() public onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101     /**
102      * @dev Allows the current owner to transfer control of the contract to a newOwner.
103      * @param newOwner The address to transfer ownership to.
104      */
105     function transferOwnership(address newOwner) public onlyOwner {
106         _transferOwnership(newOwner);
107     }
108 
109     /**
110      * @dev Transfers control of the contract to a newOwner.
111      * @param newOwner The address to transfer ownership to.
112      */
113     function _transferOwnership(address newOwner) internal {
114         require(newOwner != address(0));
115         emit OwnershipTransferred(_owner, newOwner);
116         _owner = newOwner;
117     }
118 }
119 
120 /**
121  * @title ERC20Basic
122  * @dev Simpler version of ERC20 interface
123  * @dev see https://github.com/ethereum/EIPs/issues/179
124  */
125 contract ERC20Basic {
126   function totalSupply() public view returns (uint256);
127   function balanceOf(address who) public view returns (uint256);
128   function transfer(address to, uint256 value) public returns (bool);
129   event Transfer(address indexed from, address indexed to, uint256 value);
130 }
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public view returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 contract IConnector
144 {
145     function getSellPrice() public view returns (uint);
146     function transfer(address to, uint256 numberOfTokens, uint256 price) public;
147 }
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   IConnector internal connector;
157   mapping(address => uint256) balances;
158 
159   uint256 totalSupply_;
160 
161   constructor (address _connector) public
162   {
163       connector = IConnector(_connector);
164   }
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185 
186     emit Transfer(msg.sender, _to, _value);
187     return true;
188   }
189 
190   /**
191   * @dev Gets the balance of the specified address.
192   * @param _owner The address to query the the balance of.
193   * @return An uint256 representing the amount owned by the passed address.
194   */
195   function balanceOf(address _owner) public view returns (uint256 balance) {
196     return balances[_owner];
197   }
198 
199 }
200 
201 
202 
203 /**
204  * @title Standard ERC20 token
205  *
206  * @dev Implementation of the basic standard token.
207  * @dev https://github.com/ethereum/EIPs/issues/20
208  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
209  */
210 contract StandardToken is ERC20, BasicToken {
211 
212   mapping (address => mapping (address => uint256)) internal allowed;
213 
214 
215   /**
216    * @dev Transfer tokens from one address to another
217    * @param _from address The address which you want to send tokens from
218    * @param _to address The address which you want to transfer to
219    * @param _value uint256 the amount of tokens to be transferred
220    */
221   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
222     require(_to != address(0));
223     require(_value <= balances[_from]);
224     require(_value <= allowed[_from][msg.sender]);
225 
226     balances[_from] = balances[_from].sub(_value);
227     balances[_to] = balances[_to].add(_value);
228     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
229 
230     emit Transfer(_from, _to, _value);
231     return true;
232   }
233 
234   /**
235    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
236    *
237    * Beware that changing an allowance with this method brings the risk that someone may use both the old
238    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
239    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
240    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
241    * @param _spender The address which will spend the funds.
242    * @param _value The amount of tokens to be spent.
243    */
244   function approve(address _spender, uint256 _value) public returns (bool) {
245     allowed[msg.sender][_spender] = _value;
246     emit Approval(msg.sender, _spender, _value);
247     return true;
248   }
249 
250   /**
251    * @dev Function to check the amount of tokens that an owner allowed to a spender.
252    * @param _owner address The address which owns the funds.
253    * @param _spender address The address which will spend the funds.
254    * @return A uint256 specifying the amount of tokens still available for the spender.
255    */
256   function allowance(address _owner, address _spender) public view returns (uint256) {
257     return allowed[_owner][_spender];
258   }
259 
260   /**
261    * @dev Increase the amount of tokens that an owner allowed to a spender.
262    *
263    * approve should be called when allowed[_spender] == 0. To increment
264    * allowed value is better to use this function to avoid 2 calls (and wait until
265    * the first transaction is mined)
266    * From MonolithDAO Token.sol
267    * @param _spender The address which will spend the funds.
268    * @param _addedValue The amount of tokens to increase the allowance by.
269    */
270   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
271     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
272     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
273     return true;
274   }
275 
276   /**
277    * @dev Decrease the amount of tokens that an owner allowed to a spender.
278    *
279    * approve should be called when allowed[_spender] == 0. To decrement
280    * allowed value is better to use this function to avoid 2 calls (and wait until
281    * the first transaction is mined)
282    * From MonolithDAO Token.sol
283    * @param _spender The address which will spend the funds.
284    * @param _subtractedValue The amount of tokens to decrease the allowance by.
285    */
286   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
287     uint oldValue = allowed[msg.sender][_spender];
288     if (_subtractedValue > oldValue) {
289       allowed[msg.sender][_spender] = 0;
290     } else {
291       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
292     }
293     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
294     return true;
295   }
296 
297 }
298 
299 contract MapsStorage is Ownable
300 {
301     mapping(address => uint) public winners;
302     mapping(address => address) public parents;
303 
304     function setWinnerValue(address key, uint value) public onlyOwner
305     {
306         winners[key] = value;
307     }
308 
309     function setParentValue(address key, address value) public onlyOwner
310     {
311         parents[key] = value;
312     }
313 }
314 
315 contract INFToken is StandardToken
316 {
317     string public name = "";
318     string public symbol = "";
319     uint public decimals = 2;
320 
321     constructor (address connector, string _name, string _symbol, uint _totalSupply) BasicToken(connector) public
322     {
323         name = _name;
324         symbol = _symbol;
325         totalSupply_ = _totalSupply * 10 ** decimals;
326 
327         address owner = msg.sender;
328         balances[owner] = totalSupply_;
329         emit Transfer(0x0, owner, totalSupply_);
330     }
331 
332     function transfer(address _to, uint256 _value) public returns (bool)
333     {
334         uint price = 0;
335         if(_to == address(connector))
336         {
337             price = connector.getSellPrice();
338         }
339 
340         bool result = super.transfer(_to, _value);
341 
342         if(result && _to == address(connector))
343         {
344             connector.transfer(msg.sender, _value, price);
345         }
346 
347         return result;
348     }
349 
350     function transferFrom(address _from, address _to, uint256 _value) public returns (bool)
351     {
352         uint price = 0;
353         if(_to == address(connector))
354         {
355             price = connector.getSellPrice();
356         }
357 
358         bool result = super.transferFrom(_from, _to, _value);
359 
360         if(result && _to == address(connector))
361         {
362             connector.transfer(msg.sender, _value, price);
363         }
364 
365         return result;
366     }
367 }