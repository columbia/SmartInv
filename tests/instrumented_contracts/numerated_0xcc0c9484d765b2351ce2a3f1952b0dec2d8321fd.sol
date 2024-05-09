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
54   address payable public owner;
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
82   function transferOwnership(address payable _newOwner) public onlyOwner {
83     _transferOwnership(_newOwner);
84   }
85 
86   /**
87    * @dev Transfers control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function _transferOwnership(address payable _newOwner) internal {
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
118 
119   /**
120    * @dev Fix for the ERC20 short address attack.
121    */
122   modifier onlyPayloadSize(uint size) {
123      require(msg.data.length >= size + 4);
124      _;
125   }
126   
127   function transfer(address _to, uint _value) 
128     public 
129     onlyPayloadSize(2 * 32)
130   {
131     require(_to != address(0));
132     require(_value <= balances[msg.sender]);
133     balances[msg.sender] = balances[msg.sender].sub(_value);
134     balances[_to] = balances[_to].add(_value);
135     emit Transfer(msg.sender, _to, _value);
136   }
137 
138   function balanceOf(address _owner) public view returns (uint) {
139     return balances[_owner];
140   }
141 }
142 
143 contract ERC20 is ERC20Basic {
144   function allowance(address owner, address spender)
145     public view returns (uint256);
146 
147   function transferFrom(address from, address to, uint256 value)
148     public returns (bool);
149 
150   function approve(address spender, uint256 value) public returns (bool);
151   event Approval(
152     address indexed owner,
153     address indexed spender,
154     uint256 value
155   );
156 }
157 
158 contract StandardToken is ERC20, BasicToken {
159 
160   mapping (address => mapping (address => uint256)) internal allowed;
161 
162   event Burn(address indexed from, uint256 value);
163 
164   /**
165    * @dev Transfer tokens from one address to another
166    * @param _from address The address which you want to send tokens from
167    * @param _to address The address which you want to transfer to
168    * @param _value uint256 the amount of tokens to be transferred
169    */
170   function transferFrom(
171     address _from,
172     address _to,
173     uint256 _value
174   )
175     public
176     onlyPayloadSize(3 * 32)
177     returns (bool)
178   {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     emit Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     allowed[msg.sender][_spender] = _value;
202     emit Approval(msg.sender, _spender, _value);
203     return true;
204   }
205 
206   /**
207    * @dev Function to check the amount of tokens that an owner allowed to a spender.
208    * @param _owner address The address which owns the funds.
209    * @param _spender address The address which will spend the funds.
210    * @return A uint256 specifying the amount of tokens still available for the spender.
211    */
212   function allowance(
213     address _owner,
214     address _spender
215    )
216     public
217     view
218     returns (uint256)
219   {
220     return allowed[_owner][_spender];
221   }
222 
223   /**
224    * @dev Increase the amount of tokens that an owner allowed to a spender.
225    *
226    * approve should be called when allowed[_spender] == 0. To increment
227    * allowed value is better to use this function to avoid 2 calls (and wait until
228    * the first transaction is mined)
229    * From MonolithDAO Token.sol
230    * @param _spender The address which will spend the funds.
231    * @param _addedValue The amount of tokens to increase the allowance by.
232    */
233   function increaseApproval(
234     address _spender,
235     uint _addedValue
236   )
237     public
238     returns (bool)
239   {
240     allowed[msg.sender][_spender] = (
241       allowed[msg.sender][_spender].add(_addedValue));
242     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
243     return true;
244   }
245 
246   /**
247    * @dev Decrease the amount of tokens that an owner allowed to a spender.
248    *
249    * approve should be called when allowed[_spender] == 0. To decrement
250    * allowed value is better to use this function to avoid 2 calls (and wait until
251    * the first transaction is mined)
252    * From MonolithDAO Token.sol
253    * @param _spender The address which will spend the funds.
254    * @param _subtractedValue The amount of tokens to decrease the allowance by.
255    */
256   function decreaseApproval(
257     address _spender,
258     uint _subtractedValue
259   )
260     public
261     returns (bool)
262   {
263     uint oldValue = allowed[msg.sender][_spender];
264     if (_subtractedValue > oldValue) {
265       allowed[msg.sender][_spender] = 0;
266     } else {
267       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
268     }
269     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
270     return true;
271   }
272 }
273 
274 contract COOLToken is StandardToken {
275   using SafeMath for uint256;
276   
277   string constant public name = "COOL Token";
278   string constant public symbol = "COOL";
279   uint8 constant public decimals = 18;
280   uint public totalSupply = 100*10**26;
281 
282   event PaymentReceived(address _from, uint256 _amount);
283 
284   constructor(address _wallet) public {
285     balances[_wallet] = totalSupply;
286     emit Transfer(address(0), _wallet, totalSupply);
287   }
288 
289   function burn(uint256 _value) public returns (bool) 
290   {
291     require(balances[msg.sender] >= _value);
292     balances[msg.sender] = balances[msg.sender].sub(_value);
293     totalSupply = totalSupply.sub(_value);
294     emit Burn(msg.sender, _value);
295     return true;
296   }
297   
298   function withdrawEther(uint256 _amount) public onlyOwner {
299     owner.transfer(_amount);
300   }
301 
302   function () external payable {
303     emit PaymentReceived(msg.sender, msg.value);
304   }
305 }