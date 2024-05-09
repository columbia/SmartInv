1 pragma solidity ^0.4.18;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     /**
24     * @dev Integer division of two numbers, truncating the quotient.
25     */
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         // assert(b > 0); // Solidity automatically throws when dividing by 0
28         uint256 c = a / b;
29         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30         return c;
31     }
32 
33     /**
34     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35     */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     /**
42     * @dev Adds two numbers, throws on overflow.
43     */
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         assert(c >= a);
47         return c;
48     }
49 }
50 
51 
52 contract ERC20Basic {
53     function totalSupply() public view returns (uint256);
54     function balanceOf(address who) public view returns (uint256);
55     function transfer(address to, uint256 value) public returns (bool);
56     event Transfer(address indexed from, address indexed to, uint256 value);
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances.
62  */
63 contract BasicToken is ERC20Basic {
64     using SafeMath for uint256;
65     mapping(address => uint256) balances;
66     uint256 totalSupply_;
67 
68     /**
69     * @dev total number of tokens in existence
70     */
71     function totalSupply() public view returns (uint256) {
72         return totalSupply_;
73     }
74 
75     /**
76     * @dev transfer token for a specified address
77     * @param _to The address to transfer to.
78     * @param _value The amount to be transferred.
79     */
80     function transfer(address _to, uint256 _value) public returns (bool) {
81         require(_to != address(0));
82         require(_value <= balances[msg.sender]);
83 
84         // SafeMath.sub will throw if there is not enough balance.
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         Transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96     function balanceOf(address _owner) public view returns (uint256 balance) {
97         return balances[_owner];
98     }
99 
100 }
101 
102 contract ERC20 is ERC20Basic {
103     function allowance(address owner, address spender) public view returns (uint256);
104     function transferFrom(address from, address to, uint256 value) public returns (bool);
105     function approve(address spender, uint256 value) public returns (bool);
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 contract StandardToken is ERC20, BasicToken {
110 
111     mapping (address => mapping (address => uint256)) internal allowed;
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amount of tokens to be transferred
118    */
119     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120         require(_to != address(0));
121         require(_value <= balances[_from]);
122         require(_value <= allowed[_from][msg.sender]);
123 
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130 
131   /**
132    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133    *
134    * Beware that changing an allowance with this method brings the risk that someone may use both the old
135    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
136    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
137    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
138    * @param _spender The address which will spend the funds.
139    * @param _value The amount of tokens to be spent.
140    */
141     function approve(address _spender, uint256 _value) public returns (bool) {
142         allowed[msg.sender][_spender] = _value;
143         Approval(msg.sender, _spender, _value);
144         return true;
145     }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifying the amount of tokens still available for the spender.
152    */
153     function allowance(address _owner, address _spender) public view returns (uint256) {
154         return allowed[_owner][_spender];
155     }
156 
157   /**
158    * @dev Increase the amount of tokens that an owner allowed to a spender.
159    *
160    * approve should be called when allowed[_spender] == 0. To increment
161    * allowed value is better to use this function to avoid 2 calls (and wait until
162    * the first transaction is mined)
163    * From MonolithDAO Token.sol
164    * @param _spender The address which will spend the funds.
165    * @param _addedValue The amount of tokens to increase the allowance by.
166    */
167     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
168         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173   /**
174    * @dev Decrease the amount of tokens that an owner allowed to a spender.
175    *
176    * approve should be called when allowed[_spender] == 0. To decrement
177    * allowed value is better to use this function to avoid 2 calls (and wait until
178    * the first transaction is mined)
179    * From MonolithDAO Token.sol
180    * @param _spender The address which will spend the funds.
181    * @param _subtractedValue The amount of tokens to decrease the allowance by.
182    */
183     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
184         uint oldValue = allowed[msg.sender][_spender];
185         if (_subtractedValue > oldValue) {
186             allowed[msg.sender][_spender] = 0;
187         } else {
188             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
189         }
190         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191         return true;
192     }
193 }
194 
195 contract Ownable {
196     address public owner;
197     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
198 
199   /**
200    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
201    * account.
202    */
203     function Ownable() public {
204         owner = msg.sender;
205     }
206 
207   /**
208    * @dev Throws if called by any account other than the owner.
209    */
210     modifier onlyOwner() {
211         require(msg.sender == owner);
212         _;
213     }
214 
215   /**
216    * @dev Allows the current owner to transfer control of the contract to a newOwner.
217    * @param newOwner The address to transfer ownership to.
218    */
219     function transferOwnership(address newOwner) public onlyOwner {
220         require(newOwner != address(0));
221         OwnershipTransferred(owner, newOwner);
222         owner = newOwner;
223     }
224 }
225 
226 contract Steel is StandardToken, Ownable {
227 
228     using SafeMath for uint256;
229     string public constant ContractName = "TokenSteel";
230     string public constant name = "Steel";
231     string public constant symbol = "STL";
232     uint8 public constant decimals = 18;
233     uint256 public constant INITIAL_SUPPLY = 35000000000 * (10 ** uint256(decimals));
234     mapping(address => uint256) freezeOf;
235     event Burn(address indexed burner, uint256 value);
236     event Freeze(address freeze, uint256 value);
237     event Unfreeze(address unfreeze, uint256 value);
238 
239    /**
240    * @dev Constructor that gives msg.sender all of existing tokens.
241    */
242     function Steel() public {
243         totalSupply_ = INITIAL_SUPPLY;
244         balances[msg.sender] = INITIAL_SUPPLY;
245         Transfer(0x0, msg.sender, INITIAL_SUPPLY);
246     }
247 
248     function burn(uint256 _value) public onlyOwner {
249         require(_value <= balances[msg.sender]);
250         // no need to require value <= totalSupply, since that would imply the
251         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
252         address burner = msg.sender;
253         balances[burner] = balances[burner].sub(_value);
254         totalSupply_ = totalSupply_.sub(_value);
255         Burn(burner, _value);
256     }
257 
258     function freeze(uint256 _value) public onlyOwner returns (bool success) {
259         require(_value > 0);
260         require(_value <= balances[msg.sender]);
261         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);// Subtract from the sender
262         freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);       
263         Freeze(msg.sender, _value);
264         return true;
265     }
266 
267     function unfreeze(uint256 _value) public onlyOwner returns (bool success) {
268         require(_value > 0);
269         require(_value <= freezeOf[msg.sender]);
270         freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);// Subtract from the sender
271         balances[msg.sender] = SafeMath.add(balances[msg.sender], _value);
272         Unfreeze(msg.sender, _value);
273         return true;
274     }
275 }