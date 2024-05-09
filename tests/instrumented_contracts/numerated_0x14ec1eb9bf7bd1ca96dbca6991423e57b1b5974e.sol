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
25     return a / b;
26   }
27 
28   /**
29   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
30   */
31   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   /**
37   * @dev Adds two numbers, throws on overflow.
38   */
39   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
40     c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
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
81  * @dev https://github.com/ethereum/EIPs/issues/20
82  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
83  */
84 contract StandardToken is ERC20 {
85 
86   using SafeMath for uint256;
87   
88   address public owner;
89 
90   mapping(address => uint256) balances;
91   mapping (address => mapping (address => uint256)) internal allowed;
92 
93   uint256 totalSupply_;
94 
95   uint256 minAmount = 10; // minimum amount to be sent
96   uint256 maxAmount = 100000; // maximum amount to be sent
97   
98   /**
99    * Init contract creator
100    */
101   constructor() public {
102     owner = msg.sender;
103   }
104   
105   /**
106    * @dev get minimal amount to be sent
107    */
108    function getMinAmount() public view returns (uint256) {
109      return minAmount;
110    }
111    
112    /**
113    * @dev get maximum amount to be sent
114    */
115    function getMaxAmount() public view returns (uint256) {
116      return maxAmount;
117    }
118    
119   /**
120    * @dev set minimal amount to be sent
121    */
122    function setMinAmount(uint256 newMinAmount) public returns (bool) {
123      require(msg.sender == owner);
124      require(newMinAmount < maxAmount);
125      
126      minAmount = newMinAmount;
127      return true;
128    }
129    
130   /**
131    * @dev set maximum amount to be sent
132    */
133    function setMaxAmount(uint256 newMaxAmount) public returns (bool) {
134      require(msg.sender == owner);
135      require(newMaxAmount > minAmount);
136     
137      maxAmount = newMaxAmount;
138      return true;
139    }
140   
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value >= minAmount && _value <= maxAmount);
156     require(_value <= balances[msg.sender]);
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256) {
170     return balances[_owner];
171   }
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_to != address(0));
188     require(_value >= minAmount && _value <= maxAmount);
189     require(_value <= balances[_from]);
190     require(_value <= allowed[_from][msg.sender]);
191 
192     balances[_from] = balances[_from].sub(_value);
193     balances[_to] = balances[_to].add(_value);
194     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
195     emit Transfer(_from, _to, _value);
196     return true;
197   }
198 
199   /**
200    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
201    *
202    * Beware that changing an allowance with this method brings the risk that someone may use both the old
203    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
204    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
205    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206    * @param _spender The address which will spend the funds.
207    * @param _value The amount of tokens to be spent.
208    */
209   function approve(address _spender, uint256 _value) public returns (bool) {
210     allowed[msg.sender][_spender] = _value;
211     emit Approval(msg.sender, _spender, _value);
212     return true;
213   }
214 
215   /**
216    * @dev Function to check the amount of tokens that an owner allowed to a spender.
217    * @param _owner address The address which owns the funds.
218    * @param _spender address The address which will spend the funds.
219    * @return A uint256 specifying the amount of tokens still available for the spender.
220    */
221   function allowance(
222     address _owner,
223     address _spender
224    )
225     public
226     view
227     returns (uint256)
228   {
229     return allowed[_owner][_spender];
230   }
231 
232   /**
233    * @dev Increase the amount of tokens that an owner allowed to a spender.
234    *
235    * approve should be called when allowed[_spender] == 0. To increment
236    * allowed value is better to use this function to avoid 2 calls (and wait until
237    * the first transaction is mined)
238    * From MonolithDAO Token.sol
239    * @param _spender The address which will spend the funds.
240    * @param _addedValue The amount of tokens to increase the allowance by.
241    */
242   function increaseApproval(
243     address _spender,
244     uint _addedValue
245   )
246     public
247     returns (bool)
248   {
249     allowed[msg.sender][_spender] = (
250       allowed[msg.sender][_spender].add(_addedValue));
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255   /**
256    * @dev Decrease the amount of tokens that an owner allowed to a spender.
257    *
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(
266     address _spender,
267     uint _subtractedValue
268   )
269     public
270     returns (bool)
271   {
272     uint oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue > oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 /**
285  * @title MobarakToken
286  * @dev ERC20 token, where all tokens are preassigned to the creator.
287  */
288 contract MobarakToken is StandardToken {
289 
290   string public constant name = "(Mobarak) مبارك";
291   string public constant symbol = "MBK";
292   uint8 public constant decimals = 18;
293 
294   uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(decimals));
295 
296   /**
297    * @dev Constructor that gives msg.sender all of existing tokens.
298    */
299   constructor() public {
300     totalSupply_ = INITIAL_SUPPLY;
301     balances[msg.sender] = INITIAL_SUPPLY;
302     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
303   }
304 
305 }