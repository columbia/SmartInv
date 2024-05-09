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
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public view returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 contract ERC20 is ERC20Basic {
40   function allowance(address owner, address spender) public view returns (uint256);
41   function transferFrom(address from, address to, uint256 value) public returns (bool);
42   function approve(address spender, uint256 value) public returns (bool);
43   event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 contract BasicToken is ERC20Basic {
47   using SafeMath for uint256;
48 
49   mapping(address => uint256) balances;
50 
51   /**
52   * @dev transfer token for a specified address
53   * @param _to The address to transfer to.
54   * @param _value The amount to be transferred.
55   */
56   function transfer(address _to, uint256 _value) public returns (bool) {
57     require(_to != address(0));
58     require(_value <= balances[msg.sender]);
59 
60     // SafeMath.sub will throw if there is not enough balance.
61     balances[msg.sender] = balances[msg.sender].sub(_value);
62     balances[_to] = balances[_to].add(_value);
63     Transfer(msg.sender, _to, _value);
64     return true;
65   }
66 
67   /**
68   * @dev Gets the balance of the specified address.
69   * @param _owner The address to query the the balance of.
70   * @return An uint256 representing the amount owned by the passed address.
71   */
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76 }
77 
78 contract BurnableToken is BasicToken {
79 
80     event Burn(address indexed burner, uint256 value);
81 
82     /**
83      * @dev Burns a specific amount of tokens.
84      * @param _value The amount of token to be burned.
85      */
86     function burn(uint256 _value) public {
87         require(_value <= balances[msg.sender]);
88         // no need to require value <= totalSupply, since that would imply the
89         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
90 
91         address burner = msg.sender;
92         balances[burner] = balances[burner].sub(_value);
93         totalSupply = totalSupply.sub(_value);
94         Burn(burner, _value);
95     }
96 }
97 
98 
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103 
104   /**
105    * @dev Transfer tokens from one address to another
106    * @param _from address The address which you want to send tokens from
107    * @param _to address The address which you want to transfer to
108    * @param _value uint256 the amount of tokens to be transferred
109    */
110   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[_from]);
113     require(_value <= allowed[_from][msg.sender]);
114 
115     balances[_from] = balances[_from].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    *
125    * Beware that changing an allowance with this method brings the risk that someone may use both the old
126    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
127    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
128    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129    * @param _spender The address which will spend the funds.
130    * @param _value The amount of tokens to be spent.
131    */
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifying the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) public view returns (uint256) {
145     return allowed[_owner][_spender];
146   }
147 
148   /**
149    * @dev Increase the amount of tokens that an owner allowed to a spender.
150    *
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _addedValue The amount of tokens to increase the allowance by.
157    */
158   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
159     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
160     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
161     return true;
162   }
163 
164   /**
165    * @dev Decrease the amount of tokens that an owner allowed to a spender.
166    *
167    * approve should be called when allowed[_spender] == 0. To decrement
168    * allowed value is better to use this function to avoid 2 calls (and wait until
169    * the first transaction is mined)
170    * From MonolithDAO Token.sol
171    * @param _spender The address which will spend the funds.
172    * @param _subtractedValue The amount of tokens to decrease the allowance by.
173    */
174   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
175     uint oldValue = allowed[msg.sender][_spender];
176     if (_subtractedValue > oldValue) {
177       allowed[msg.sender][_spender] = 0;
178     } else {
179       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
180     }
181     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
182     return true;
183   }
184 
185 }
186 
187 
188 contract Ownable {
189   address public owner;
190 
191 
192   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194 
195   /**
196    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
197    * account.
198    */
199   function Ownable() public {
200     owner = msg.sender;
201   }
202 
203 
204   /**
205    * @dev Throws if called by any account other than the owner.
206    */
207   modifier onlyOwner() {
208     require(msg.sender == owner);
209     _;
210   }
211 
212 
213   /**
214    * @dev Allows the current owner to transfer control of the contract to a newOwner.
215    * @param newOwner The address to transfer ownership to.
216    */
217   function transferOwnership(address newOwner) public onlyOwner {
218     require(newOwner != address(0));
219     OwnershipTransferred(owner, newOwner);
220     owner = newOwner;
221   }
222 
223 }
224 
225 
226 contract Pausable is Ownable {
227   event Pause();
228   event Unpause();
229 
230   bool public paused = false;
231 
232 
233   /**
234    * @dev Modifier to make a function callable only when the contract is not paused.
235    */
236   modifier whenNotPaused() {
237     require(!paused);
238     _;
239   }
240 
241   /**
242    * @dev Modifier to make a function callable only when the contract is paused.
243    */
244   modifier whenPaused() {
245     require(paused);
246     _;
247   }
248 
249   /**
250    * @dev called by the owner to pause, triggers stopped state
251    */
252   function pause() onlyOwner whenNotPaused public {
253     paused = true;
254     Pause();
255   }
256 
257   /**
258    * @dev called by the owner to unpause, returns to normal state
259    */
260   function unpause() onlyOwner whenPaused public {
261     paused = false;
262     Unpause();
263   }
264 }
265 
266 contract PausableToken is StandardToken, Pausable {
267 
268   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
269     return super.transfer(_to, _value);
270   }
271 
272   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
273     return super.transferFrom(_from, _to, _value);
274   }
275 
276   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
277     return super.approve(_spender, _value);
278   }
279 
280   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
281     return super.increaseApproval(_spender, _addedValue);
282   }
283 
284   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
285     return super.decreaseApproval(_spender, _subtractedValue);
286   }
287 }
288 
289 contract CrypStock is PausableToken, BurnableToken {
290 	string  public  name       = "CrypStock";
291 	string  public  symbol     = "CPSK";
292 	uint    public  decimals   = 18;
293 
294 	function CrypStock(uint256 initBalance) {
295 		balances[msg.sender] = totalSupply = initBalance;
296 	}
297 
298 	function burn(uint256 _value) onlyOwner public {
299 		super.burn(_value);
300 	}
301 }