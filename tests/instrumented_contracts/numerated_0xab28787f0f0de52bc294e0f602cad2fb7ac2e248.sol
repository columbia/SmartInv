1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, throws on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         if (a == 0) {
13             return 0;
14         }
15         uint256 c = a * b;
16         assert(c / a == b);
17         return c;
18     }
19 
20     /**
21     * @dev Integer division of two numbers, truncating the quotient.
22     */
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     /**
31     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
32     */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     /**
39     * @dev Adds two numbers, throws on overflow.
40     */
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56   event OwnershipRenounced(address indexed previousOwner);
57   event OwnershipTransferred(
58     address indexed previousOwner,
59     address indexed newOwner
60   );
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
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address _newOwner) public onlyOwner {
83     _transferOwnership(_newOwner);
84   }
85 
86   /**
87    * @dev Transfers control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function _transferOwnership(address _newOwner) internal {
91     require(_newOwner != address(0));
92     emit OwnershipTransferred(owner, _newOwner);
93     owner = _newOwner;
94   }
95 }
96 
97 /**
98  * @title ERC20Basic 
99  * @dev Simpler version of ERC20 interface 
100  * @dev see https://github.com/ethereum/EIPs/issues/20 
101  */ 
102 contract ERC20Basic {
103      uint public totalSupply;
104      function balanceOf(address who) public view returns (uint); 
105      function transfer(address to, uint value) public ; 
106      event Transfer(address indexed from, address indexed to, uint value); 
107 } 
108 
109 /** 
110  * @title ERC20 interface 
111  * @dev see https://github.com/ethereum/EIPs/issues/20 
112  */
113 
114 contract BasicToken is ERC20Basic, Ownable{
115   using SafeMath for uint;
116 
117   mapping(address => uint) balances;
118   mapping(address => bool) public frozenAccount;
119   
120   event FrozenFunds(address target, bool frozen);
121   
122   function freezeAccount(address target, bool freeze) public onlyOwner {
123         frozenAccount[target] = freeze;
124         emit FrozenFunds(target, freeze);
125    }
126   /**
127    * @dev Fix for the ERC20 short address attack.
128    */
129   modifier onlyPayloadSize(uint size) {
130      require(msg.data.length >= size + 4);
131      _;
132   }
133   
134   function transfer(address _to, uint _value) 
135     public 
136     onlyPayloadSize(2 * 32)
137   {
138     require(!frozenAccount[msg.sender]);
139     require(_to != address(0));
140     require(_value <= balances[msg.sender]);
141     balances[msg.sender] = balances[msg.sender].sub(_value);
142     balances[_to] = balances[_to].add(_value);
143     emit Transfer(msg.sender, _to, _value);
144   }
145 
146   function balanceOf(address _owner) public view returns (uint) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender)
154     public view returns (uint256);
155 
156   function transferFrom(address from, address to, uint256 value)
157     public returns (bool);
158 
159   function approve(address spender, uint256 value) public returns (bool);
160   event Approval(
161     address indexed owner,
162     address indexed spender,
163     uint256 value
164   );
165 }
166 
167 contract StandardToken is ERC20, BasicToken {
168 
169   mapping (address => mapping (address => uint256)) internal allowed;
170   
171   event Burn(address indexed from, uint256 value);
172   /**
173    * @dev Transfer tokens from one address to another
174    * @param _from address The address which you want to send tokens from
175    * @param _to address The address which you want to transfer to
176    * @param _value uint256 the amount of tokens to be transferred
177    */
178   function transferFrom(
179     address _from,
180     address _to,
181     uint256 _value
182   )
183     public
184     onlyPayloadSize(3 * 32)
185     returns (bool)
186   {
187     require(!frozenAccount[msg.sender]);
188     require(_to != address(0));
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
281 }
282 
283 contract Token is StandardToken {
284     using SafeMath for uint256;
285     
286     string constant public name = "Max Flow Token";
287     string constant public symbol = "MFT";
288     uint8 constant public decimals = 2;
289     uint public totalSupply = 210000000000;
290 
291     constructor() public {
292     //  address wallet = msg.sender;
293       balances[msg.sender] = totalSupply;
294         emit Transfer(address(0), msg.sender, totalSupply);
295     }
296 
297   /**
298   * burn
299   */
300   function burn(uint256 _value) public onlyOwner returns (bool) 
301   {
302     require(balances[msg.sender] >= _value);
303     balances[msg.sender] = balances[msg.sender].sub(_value);
304     totalSupply = totalSupply.sub(_value);
305     emit Burn(msg.sender, _value);
306     return true;
307   }
308 }