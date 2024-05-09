1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45   /**
46    * @dev Throws if called by any account other than the owner.
47    */
48   modifier onlyOwner() {
49     require(msg.sender == owner);
50     _;
51   }
52 
53   /**
54    * @dev Allows the current owner to transfer control of the contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 }
63 
64 contract Pausable is Ownable {
65   event Pause();
66   event Unpause();
67 
68   /**
69    * set initial value to paused.
70    */
71   bool public paused = false;
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     Unpause();
103   }
104 }
105 
106 contract ERC20Basic {
107   uint256 public totalSupply;
108   function balanceOf(address who) public view returns (uint256);
109   function transfer(address to, uint256 value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   /**
119   * @dev transfer token for a specified address
120   * @param _to The address to transfer to.
121   * @param _value The amount to be transferred.
122   */
123   function transfer(address _to, uint256 _value) public returns (bool) {
124     require(_to != address(0));
125     require(_value <= balances[msg.sender]);
126 
127     // SafeMath.sub will throw if there is not enough balance.
128     balances[msg.sender] = balances[msg.sender].sub(_value);
129     balances[_to] = balances[_to].add(_value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   /**
135   * @dev Gets the balance of the specified address.
136   * @param _owner The address to query the the balance of.
137   * @return An uint256 representing the amount owned by the passed address.
138   */
139   function balanceOf(address _owner) public view returns (uint256 balance) {
140     return balances[_owner];
141   }
142 
143 }
144 
145 contract ERC20 is ERC20Basic {
146   function allowance(address owner, address spender) public view returns (uint256);
147   function transferFrom(address from, address to, uint256 value) public returns (bool);
148   function approve(address spender, uint256 value) public returns (bool);
149   event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 contract StandardToken is ERC20, BasicToken {
153 
154   mapping (address => mapping (address => uint256)) internal allowed;
155 
156 
157   /**
158    * @dev Transfer tokens from one address to another
159    * @param _from address The address which you want to send tokens from
160    * @param _to address The address which you want to transfer to
161    * @param _value uint256 the amount of tokens to be transferred
162    */
163   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    *
178    * Beware that changing an allowance with this method brings the risk that someone may use both the old
179    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
180    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
181    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182    * @param _spender The address which will spend the funds.
183    * @param _value The amount of tokens to be spent.
184    */
185   function approve(address _spender, uint256 _value) public returns (bool) {
186     allowed[msg.sender][_spender] = _value;
187     Approval(msg.sender, _spender, _value);
188     return true;
189   }
190 
191   /**
192    * @dev Function to check the amount of tokens that an owner allowed to a spender.
193    * @param _owner address The address which owns the funds.
194    * @param _spender address The address which will spend the funds.
195    * @return A uint256 specifying the amount of tokens still available for the spender.
196    */
197   function allowance(address _owner, address _spender) public view returns (uint256) {
198     return allowed[_owner][_spender];
199   }
200 
201   /**
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    */
207   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 
213   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
214     uint oldValue = allowed[msg.sender][_spender];
215     if (_subtractedValue > oldValue) {
216       allowed[msg.sender][_spender] = 0;
217     } else {
218       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
219     }
220     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
221     return true;
222   }
223 
224 }
225 
226 contract BurnableToken is StandardToken {
227 
228     event Burn(address indexed burner, uint256 value);
229 
230     /**
231      * @dev Burns a specific amount of tokens.
232      * @param _value The amount of token to be burned.
233      */
234     function burn(uint256 _value) public {
235         require(_value > 0);
236         require(_value <= balances[msg.sender]);
237         // no need to require value <= totalSupply, since that would imply the
238         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
239 
240         address burner = msg.sender;
241         balances[burner] = balances[burner].sub(_value);
242         totalSupply = totalSupply.sub(_value);
243         Burn(burner, _value);
244     }
245 }
246 
247 contract PausableToken is StandardToken, Pausable {
248 
249   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
250     return super.transfer(_to, _value);
251   }
252 
253   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
254     return super.transferFrom(_from, _to, _value);
255   }
256 
257   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
258     return super.approve(_spender, _value);
259   }
260 
261   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
262     return super.increaseApproval(_spender, _addedValue);
263   }
264 
265   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
266     return super.decreaseApproval(_spender, _subtractedValue);
267   }
268 }
269 
270 contract BITToken is PausableToken, BurnableToken {
271 
272     string public constant name = "Basic Intelligence Token";
273     string public constant url = "https://cen.ai";
274     string public constant symbol = "BIT";
275     uint8 public constant decimals = 8;
276     string public version = 'BIT_0.1';  //An arbitrary versioning scheme
277     uint256 public constant INITIAL_SUPPLY = 20000000000 * 10**uint256(decimals);
278     
279     /**
280     * @dev BITToken Constructor
281     */
282 
283     function BITToken() public {
284         Pause();
285         totalSupply = INITIAL_SUPPLY;   
286         balances[msg.sender] = INITIAL_SUPPLY;
287     }
288 
289     function transferTokens(address beneficiary, uint256 amount) public onlyOwner returns (bool) {
290         require(amount > 0);
291 
292         balances[owner] = balances[owner].sub(amount);
293         balances[beneficiary] = balances[beneficiary].add(amount);
294         Transfer(owner, beneficiary, amount);
295 
296         return true;
297     }
298 }