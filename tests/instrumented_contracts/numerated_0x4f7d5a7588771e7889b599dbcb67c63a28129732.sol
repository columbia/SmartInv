1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev Total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev Transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256) {
54     return balances[_owner];
55   }
56 }
57 
58 /**
59  * @title ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20 is ERC20Basic {
63   function allowance(address owner, address spender)
64     public view returns (uint256);
65 
66   function transferFrom(address from, address to, uint256 value)
67     public returns (bool);
68 
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(
71     address indexed owner,
72     address indexed spender,
73     uint256 value
74   );
75 }
76 
77 /**
78  * @title Standard ERC20 token
79  *
80  * @dev Implementation of the basic standard token.
81  * https://github.com/ethereum/EIPs/issues/20
82  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20, BasicToken {
85 
86   mapping (address => mapping (address => uint256)) internal allowed;
87 
88 
89   /**
90    * @dev Transfer tokens from one address to another
91    * @param _from address The address which you want to send tokens from
92    * @param _to address The address which you want to transfer to
93    * @param _value uint256 the amount of tokens to be transferred
94    */
95   function transferFrom(
96     address _from,
97     address _to,
98     uint256 _value
99   )
100     public
101     returns (bool)
102   {
103     require(_to != address(0));
104     require(_value <= balances[_from]);
105     require(_value <= allowed[_from][msg.sender]);
106 
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
110     emit Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   /**
115    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
116    * Beware that changing an allowance with this method brings the risk that someone may use both the old
117    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
118    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
119    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
120    * @param _spender The address which will spend the funds.
121    * @param _value The amount of tokens to be spent.
122    */
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     emit Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(
136     address _owner,
137     address _spender
138    )
139     public
140     view
141     returns (uint256)
142   {
143     return allowed[_owner][_spender];
144   }
145 
146   /**
147    * @dev Increase the amount of tokens that an owner allowed to a spender.
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param _spender The address which will spend the funds.
153    * @param _addedValue The amount of tokens to increase the allowance by.
154    */
155   function increaseApproval(
156     address _spender,
157     uint256 _addedValue
158   )
159     public
160     returns (bool)
161   {
162     allowed[msg.sender][_spender] = (
163       allowed[msg.sender][_spender].add(_addedValue));
164     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165     return true;
166   }
167 
168   /**
169    * @dev Decrease the amount of tokens that an owner allowed to a spender.
170    * approve should be called when allowed[_spender] == 0. To decrement
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _subtractedValue The amount of tokens to decrease the allowance by.
176    */
177   function decreaseApproval(
178     address _spender,
179     uint256 _subtractedValue
180   )
181     public
182     returns (bool)
183   {
184     uint256 oldValue = allowed[msg.sender][_spender];
185     if (_subtractedValue > oldValue) {
186       allowed[msg.sender][_spender] = 0;
187     } else {
188       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189     }
190     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 }
194 
195 
196 
197 
198 
199 /**
200  * @title Ownable
201  * @dev The Ownable contract has an owner address, and provides basic authorization control
202  * functions, this simplifies the implementation of "user permissions".
203  */
204 contract Ownable {
205   address public owner;
206 
207   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
208 
209 
210   /**
211    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
212    * account.
213    */
214   constructor() public {
215     owner = msg.sender;
216   }
217 
218   /**
219    * @dev Throws if called by any account other than the owner.
220    */
221   modifier onlyOwner() {
222     require(msg.sender == owner);
223     _;
224   }
225 
226   /**
227    * @dev Allows the current owner to transfer control of the contract to a newOwner.
228    * @param newOwner The address to transfer ownership to.
229    */
230   function transferOwnership(address newOwner) public onlyOwner {
231     require(newOwner != address(0));
232     emit OwnershipTransferred(owner, newOwner);
233     owner = newOwner;
234   }
235 }
236 
237 /**
238  * @title SafeMath
239  * @dev Math operations with safety checks that throw on error
240  */
241 library SafeMath {
242 
243   /**
244   * @dev Multiplies two numbers, throws on overflow.
245   */
246   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
247     if (a == 0) {
248       return 0;
249     }
250     uint256 c = a * b;
251     assert(c / a == b);
252     return c;
253   }
254 
255   /**
256   * @dev Integer division of two numbers, truncating the quotient.
257   */
258   function div(uint256 a, uint256 b) internal pure returns (uint256) {
259     // assert(b > 0); // Solidity automatically throws when dividing by 0
260     // uint256 c = a / b;
261     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
262     return a / b;
263   }
264 
265   /**
266   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
267   */
268   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
269     assert(b <= a);
270     return a - b;
271   }
272 
273   /**
274   * @dev Adds two numbers, throws on overflow.
275   */
276   function add(uint256 a, uint256 b) internal pure returns (uint256) {
277     uint256 c = a + b;
278     assert(c >= a);
279     return c;
280   }
281 }
282 
283 /**
284  * @title SimpleToken
285  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
286  * Note they can later distribute these tokens as they wish using `transfer` and other
287  * `StandardToken` functions.
288  */
289 contract Gerc is StandardToken, Ownable {
290     using SafeMath for uint256;
291 
292     string public constant name = "Game Eternal Role Chain";
293     string public constant symbol = "GERC";
294     uint8 public constant decimals = 3;
295     //总配额1000亿
296     uint256 constant INITIAL_SUPPLY = 100000000000 * (10 ** uint256(decimals));
297     //设置GERC代币官网短URL(32字节以内)，供管理平台自动查询
298     string public website = "www.gerc.club";
299     //设置GERC代币icon短URL(32字节以内)，供管理平台自动查询
300     string public icon = "/css/gerc.png";
301 
302     /**
303      * @dev Constructor that gives msg.sender all of existing tokens.
304      */
305     constructor() public {
306         totalSupply_ = INITIAL_SUPPLY;
307         balances[msg.sender] = INITIAL_SUPPLY;
308         emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);    
309     }
310 
311     /**
312      * airdorp in batch
313      */
314     function airdrop(address[] payees, uint256 airdropValue) public onlyOwner returns(bool) {
315         uint256 _size = payees.length;       
316         uint256 amount = airdropValue.mul(_size);
317         require(amount <= balances[owner], "balance error"); 
318 
319         for (uint i = 0; i<_size; i++) {
320             if (payees[i] == address(0)) {
321                 amount = amount.sub(airdropValue);
322                 continue;   
323             }
324             balances[payees[i]] = balances[payees[i]].add(airdropValue);
325             emit Transfer(owner, payees[i], airdropValue);
326         }        
327         balances[owner] = balances[owner].sub(amount);
328         return true;
329     }
330 
331     /**
332      * 设置token官网和icon信息
333      */
334     function setWebInfo(string _website, string _icon) public onlyOwner returns(bool){
335         website = _website;
336         icon = _icon;
337         return true;
338     }
339 }