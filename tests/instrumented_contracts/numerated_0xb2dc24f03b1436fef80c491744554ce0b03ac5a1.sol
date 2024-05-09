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
114 contract BasicToken is ERC20Basic{
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
141 
142 }
143 
144 contract ERC20 is ERC20Basic {
145   function allowance(address owner, address spender)
146     public view returns (uint256);
147 
148   function transferFrom(address from, address to, uint256 value)
149     public returns (bool);
150 
151   function approve(address spender, uint256 value) public returns (bool);
152   event Approval(
153     address indexed owner,
154     address indexed spender,
155     uint256 value
156   );
157 }
158 
159 contract StandardToken is ERC20, BasicToken {
160 
161   mapping (address => mapping (address => uint256)) internal allowed;
162 
163   event Burn(address indexed from, uint256 value);
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(
172     address _from,
173     address _to,
174     uint256 _value
175   )
176     public
177     onlyPayloadSize(3 * 32)
178     returns (bool)
179   {
180     require(_to != address(0));
181     require(_value <= balances[_from]);
182     require(_value <= allowed[_from][msg.sender]);
183 
184     balances[_from] = balances[_from].sub(_value);
185     balances[_to] = balances[_to].add(_value);
186     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
187     emit Transfer(_from, _to, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
193    *
194    * Beware that changing an allowance with this method brings the risk that someone may use both the old
195    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
196    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
197    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
198    * @param _spender The address which will spend the funds.
199    * @param _value The amount of tokens to be spent.
200    */
201   function approve(address _spender, uint256 _value) public returns (bool) {
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(
214     address _owner,
215     address _spender
216    )
217     public
218     view
219     returns (uint256)
220   {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(
258     address _spender,
259     uint _subtractedValue
260   )
261     public
262     returns (bool)
263   {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 }
274 
275 contract SLTToken is StandardToken {
276     using SafeMath for uint256;
277     
278     string constant public name = "SLT Coin";
279     string constant public symbol = "SLT";
280     uint8 constant public decimals = 18;
281     uint public totalSupply = 100*10**26;
282 
283     constructor() public {
284       balances[msg.sender] = totalSupply;
285         emit Transfer(address(0), msg.sender, totalSupply);
286     }
287 
288   /**
289   * burn
290   */
291   function burn(uint256 _value) public returns (bool) 
292   {
293     require(balances[msg.sender] >= _value);
294     balances[msg.sender] = balances[msg.sender].sub(_value);
295     totalSupply = totalSupply.sub(_value);
296     emit Burn(msg.sender, _value);
297     return true;
298   }
299 }