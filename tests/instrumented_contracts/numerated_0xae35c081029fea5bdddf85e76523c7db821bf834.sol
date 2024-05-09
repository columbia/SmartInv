1 pragma solidity ^0.4.23;
2 
3 
4 library SafeMath {
5 
6   /**
7   * @dev Multiplies two numbers, throws on overflow.
8   */
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   /**
19   * @dev Integer division of two numbers, truncating the quotient.
20   */
21   function div(uint256 a, uint256 b) internal pure returns (uint256) {
22     // assert(b > 0); // Solidity automatically throws when dividing by 0
23     // uint256 c = a / b;
24     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
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
46 
47 contract Ownable {
48     address public owner;
49 
50 
51     event OwnershipRenounced(address indexed previousOwner);
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55    /**
56    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57    * account.
58    */
59     constructor() public {
60         owner = msg.sender;
61     }
62 
63    /**
64    * @dev Throws if called by any account other than the owner.
65    */
66     modifier onlyOwner() {
67         require(msg.sender == owner);
68         _;
69     }
70 
71    /**
72    * @dev Allows the current owner to transfer control of the contract to a newOwner.
73    * @param newOwner The address to transfer ownership to.
74    */
75     function transferOwnership(address newOwner) public onlyOwner {
76         require(newOwner != address(0));
77         emit OwnershipTransferred(owner, newOwner);
78         owner = newOwner;
79     }
80 
81    /**
82    * @dev Allows the current owner to relinquish control of the contract.
83    */
84     function renounceOwnership() public onlyOwner {
85         emit OwnershipRenounced(owner);
86         owner = address(0);
87     }
88 }
89 
90 
91 contract ERC20Basic {
92   function totalSupply() public view returns (uint256);
93   function balanceOf(address who) public view returns (uint256);
94   function transfer(address to, uint256 value) public returns (bool);
95   event Transfer(address indexed from, address indexed to, uint256 value);
96 }
97 
98 
99 contract ERC20 is ERC20Basic {
100   function allowance(address owner, address spender)
101     public view returns (uint256);
102 
103   function transferFrom(address from, address to, uint256 value)
104     public returns (bool);
105 
106   function approve(address spender, uint256 value) public returns (bool);
107   event Approval(
108     address indexed owner,
109     address indexed spender,
110     uint256 value
111   );
112 }
113 
114 
115 contract BasicToken is ERC20Basic {
116   using SafeMath for uint256;
117 
118   mapping(address => uint256) balances;
119 
120   uint256 totalSupply_;
121 
122   /**
123   * @dev total number of tokens in existence
124   */
125   function totalSupply() public view returns (uint256) {
126     return totalSupply_;
127   }
128 
129   /**
130   * @dev transfer token for a specified address
131   * @param _to The address to transfer to.
132   * @param _value The amount to be transferred.
133   */
134   function transfer(address _to, uint256 _value) public returns (bool) {
135     require(_to != address(0));
136     require(_value <= balances[msg.sender]);
137 
138     balances[msg.sender] = balances[msg.sender].sub(_value);
139     balances[_to] = balances[_to].add(_value);
140     emit Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   /**
145   * @dev Gets the balance of the specified address.
146   * @param _owner The address to query the the balance of.
147   * @return An uint256 representing the amount owned by the passed address.
148   */
149   function balanceOf(address _owner) public view returns (uint256) {
150     return balances[_owner];
151   }
152 
153 }
154 
155 
156 contract StandardToken is ERC20, BasicToken, Ownable {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(
168     address _from,
169     address _to,
170     uint256 _value
171   )
172     public
173     returns (bool)
174   {
175     require(_to != address(0));
176     require(_value <= balances[_from]);
177     require(_value <= allowed[_from][msg.sender]);
178 
179     balances[_from] = balances[_from].sub(_value);
180     balances[_to] = balances[_to].add(_value);
181     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
182     emit Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   /**
187    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
188    *
189    * Beware that changing an allowance with this method brings the risk that someone may use both the old
190    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
191    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
192    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193    * @param _spender The address which will spend the funds.
194    * @param _value The amount of tokens to be spent.
195    */
196   function approve(address _spender, uint256 _value) public returns (bool) {
197     allowed[msg.sender][_spender] = _value;
198     emit Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Function to check the amount of tokens that an owner allowed to a spender.
204    * @param _owner address The address which owns the funds.
205    * @param _spender address The address which will spend the funds.
206    * @return A uint256 specifying the amount of tokens still available for the spender.
207    */
208   function allowance(
209     address _owner,
210     address _spender
211    )
212     public
213     view
214     returns (uint256)
215   {
216     return allowed[_owner][_spender];
217   }
218 
219   /**
220    * @dev Increase the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To increment
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _addedValue The amount of tokens to increase the allowance by.
228    */
229   function increaseApproval(
230     address _spender,
231     uint _addedValue
232   )
233     public
234     returns (bool)
235   {
236     allowed[msg.sender][_spender] = (
237       allowed[msg.sender][_spender].add(_addedValue));
238     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242   /**
243    * @dev Decrease the amount of tokens that an owner allowed to a spender.
244    *
245    * approve should be called when allowed[_spender] == 0. To decrement
246    * allowed value is better to use this function to avoid 2 calls (and wait until
247    * the first transaction is mined)
248    * From MonolithDAO Token.sol
249    * @param _spender The address which will spend the funds.
250    * @param _subtractedValue The amount of tokens to decrease the allowance by.
251    */
252   function decreaseApproval(
253     address _spender,
254     uint _subtractedValue
255   )
256     public
257     returns (bool)
258   {
259     uint oldValue = allowed[msg.sender][_spender];
260     if (_subtractedValue > oldValue) {
261       allowed[msg.sender][_spender] = 0;
262     } else {
263       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
264     }
265     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
266     return true;
267   }
268 
269 }
270 
271 
272 contract ibuynew is StandardToken {
273 
274   string public constant name = "ibuynew"; // solium-disable-line uppercase
275   string public constant symbol = "IBN"; // solium-disable-line uppercase
276   uint8 public constant decimals = 18; // solium-disable-line uppercase
277 
278   uint256 public constant INITIAL_SUPPLY = 100000000000000000000000000;
279 
280   /**
281    * @dev Constructor that gives msg.sender all of existing tokens.
282    */
283   constructor() public {
284     totalSupply_ = INITIAL_SUPPLY;
285     balances[msg.sender] = INITIAL_SUPPLY;
286     emit Transfer(0x0, msg.sender, INITIAL_SUPPLY);
287   }
288 
289 }