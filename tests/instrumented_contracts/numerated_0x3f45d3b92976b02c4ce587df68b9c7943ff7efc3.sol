1 library SafeMath {
2 
3   /**
4   * @dev Multiplies two numbers, throws on overflow.
5   */
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   /**
26   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
27   */
28   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29     assert(b <= a);
30     return a - b;
31   }
32 
33   /**
34   * @dev Adds two numbers, throws on overflow.
35   */
36   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 contract ERC20Basic {
44   function totalSupply() public view returns (uint256);
45   function balanceOf(address who) public view returns (uint256);
46   function transfer(address to, uint256 value) public returns (bool);
47   event Transfer(address indexed from, address indexed to, uint256 value);
48 }
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   uint256 totalSupply_;
55 
56   /**
57   * @dev total number of tokens in existence
58   */
59   function totalSupply() public view returns (uint256) {
60     return totalSupply_;
61   }
62 
63   /**
64   * @dev transfer token for a specified address
65   * @param _to The address to transfer to.
66   * @param _value The amount to be transferred.
67   */
68   function transfer(address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[msg.sender]);
71 
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     emit Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of.
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) public view returns (uint256) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 contract ERC20 is ERC20Basic {
90   function allowance(address owner, address spender) public view returns (uint256);
91   function transferFrom(address from, address to, uint256 value) public returns (bool);
92   function approve(address spender, uint256 value) public returns (bool);
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) internal allowed;
99 
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amount of tokens to be transferred
106    */
107   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[_from]);
110     require(_value <= allowed[_from][msg.sender]);
111 
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    *
122    * Beware that changing an allowance with this method brings the risk that someone may use both the old
123    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
124    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
125    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126    * @param _spender The address which will spend the funds.
127    * @param _value The amount of tokens to be spent.
128    */
129   function approve(address _spender, uint256 _value) public returns (bool) {
130     allowed[msg.sender][_spender] = _value;
131     emit Approval(msg.sender, _spender, _value);
132     return true;
133   }
134 
135   /**
136    * @dev Function to check the amount of tokens that an owner allowed to a spender.
137    * @param _owner address The address which owns the funds.
138    * @param _spender address The address which will spend the funds.
139    * @return A uint256 specifying the amount of tokens still available for the spender.
140    */
141   function allowance(address _owner, address _spender) public view returns (uint256) {
142     return allowed[_owner][_spender];
143   }
144 
145   /**
146    * @dev Increase the amount of tokens that an owner allowed to a spender.
147    *
148    * approve should be called when allowed[_spender] == 0. To increment
149    * allowed value is better to use this function to avoid 2 calls (and wait until
150    * the first transaction is mined)
151    * From MonolithDAO Token.sol
152    * @param _spender The address which will spend the funds.
153    * @param _addedValue The amount of tokens to increase the allowance by.
154    */
155   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
156     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
157     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
158     return true;
159   }
160 
161   /**
162    * @dev Decrease the amount of tokens that an owner allowed to a spender.
163    *
164    * approve should be called when allowed[_spender] == 0. To decrement
165    * allowed value is better to use this function to avoid 2 calls (and wait until
166    * the first transaction is mined)
167    * From MonolithDAO Token.sol
168    * @param _spender The address which will spend the funds.
169    * @param _subtractedValue The amount of tokens to decrease the allowance by.
170    */
171   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
172     uint oldValue = allowed[msg.sender][_spender];
173     if (_subtractedValue > oldValue) {
174       allowed[msg.sender][_spender] = 0;
175     } else {
176       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
177     }
178     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
179     return true;
180   }
181 
182 }
183 
184 contract Ownable {
185   address public owner;
186 
187 
188   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() public {
196     owner = msg.sender;
197   }
198 
199   /**
200    * @dev Throws if called by any account other than the owner.
201    */
202   modifier onlyOwner() {
203     require(msg.sender == owner);
204     _;
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     emit OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217 }
218 
219 contract Pausable is Ownable {
220   event Pause();
221   event Unpause();
222 
223   bool public paused = false;
224 
225 
226   /**
227    * @dev Modifier to make a function callable only when the contract is not paused.
228    */
229   modifier whenNotPaused() {
230     require(!paused);
231     _;
232   }
233 
234   /**
235    * @dev Modifier to make a function callable only when the contract is paused.
236    */
237   modifier whenPaused() {
238     require(paused);
239     _;
240   }
241 
242   /**
243    * @dev called by the owner to pause, triggers stopped state
244    */
245   function pause() onlyOwner whenNotPaused public {
246     paused = true;
247     emit Pause();
248   }
249 
250   /**
251    * @dev called by the owner to unpause, returns to normal state
252    */
253   function unpause() onlyOwner whenPaused public {
254     paused = false;
255     emit Unpause();
256   }
257 }
258 
259 contract PausableToken is StandardToken, Pausable {
260 
261   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
262     return super.transfer(_to, _value);
263   }
264 
265   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
266     return super.transferFrom(_from, _to, _value);
267   }
268 
269   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
270     return super.approve(_spender, _value);
271   }
272 
273   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
274     return super.increaseApproval(_spender, _addedValue);
275   }
276 
277   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
278     return super.decreaseApproval(_spender, _subtractedValue);
279   }
280 }
281 
282 contract BurnableToken is BasicToken {
283 
284   event Burn(address indexed burner, uint256 value);
285 
286   /**
287    * @dev Burns a specific amount of tokens.
288    * @param _value The amount of token to be burned.
289    */
290   function burn(uint256 _value) public {
291     _burn(msg.sender, _value);
292   }
293 
294   function _burn(address _who, uint256 _value) internal {
295     require(_value <= balances[_who]);
296     // no need to require value <= totalSupply, since that would imply the
297     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
298 
299     balances[_who] = balances[_who].sub(_value);
300     totalSupply_ = totalSupply_.sub(_value);
301     emit Burn(_who, _value);
302     emit Transfer(_who, address(0), _value);
303   }
304 }
305 
306 contract TSCoin is PausableToken, BurnableToken {
307 
308     string public name = 'Trust Shore Coin';
309     string public symbol = 'TS';
310     uint8 public decimals = 18;
311     uint256 public INITIAL_SUPPLY = 50000000000;
312 
313     constructor() public {
314         totalSupply_ = INITIAL_SUPPLY*10**18;
315         balances[msg.sender] = totalSupply_;
316     }
317 
318     function burn(uint256 _value) public whenNotPaused {
319         super.burn(_value);
320     }
321 }