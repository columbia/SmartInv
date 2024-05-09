1 pragma solidity ^0.4.13;
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
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47 
48   /**
49    * @dev Throws if called by any account other than the owner.
50    */
51   modifier onlyOwner() {
52     require(msg.sender == owner);
53     _;
54   }
55 
56 
57   /**
58    * @dev Allows the current owner to transfer control of the contract to a newOwner.
59    * @param newOwner The address to transfer ownership to.
60    */
61   function transferOwnership(address newOwner) public onlyOwner {
62     require(newOwner != address(0));
63     OwnershipTransferred(owner, newOwner);
64     owner = newOwner;
65   }
66 
67 }
68 
69 contract Pausable is Ownable {
70   event Pause();
71   event Unpause();
72 
73   bool public paused = false;
74 
75 
76   /**
77    * @dev Modifier to make a function callable only when the contract is not paused.
78    */
79   modifier whenNotPaused() {
80     require(!paused);
81     _;
82   }
83 
84   /**
85    * @dev Modifier to make a function callable only when the contract is paused.
86    */
87   modifier whenPaused() {
88     require(paused);
89     _;
90   }
91 
92   /**
93    * @dev called by the owner to pause, triggers stopped state
94    */
95   function pause() onlyOwner whenNotPaused public {
96     paused = true;
97     Pause();
98   }
99 
100   /**
101    * @dev called by the owner to unpause, returns to normal state
102    */
103   function unpause() onlyOwner whenPaused public {
104     paused = false;
105     Unpause();
106   }
107 }
108 
109 contract ERC20Basic {
110   uint256 public totalSupply;
111   function balanceOf(address who) public view returns (uint256);
112   function transfer(address to, uint256 value) public returns (bool);
113   event Transfer(address indexed from, address indexed to, uint256 value);
114 }
115 
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   /**
122   * @dev transfer token for a specified address
123   * @param _to The address to transfer to.
124   * @param _value The amount to be transferred.
125   */
126   function transfer(address _to, uint256 _value) public returns (bool) {
127     require(_to != address(0));
128     require(_value <= balances[msg.sender]);
129 
130     // SafeMath.sub will throw if there is not enough balance.
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   /**
138   * @dev Gets the balance of the specified address.
139   * @param _owner The address to query the the balance of.
140   * @return An uint256 representing the amount owned by the passed address.
141   */
142   function balanceOf(address _owner) public view returns (uint256 balance) {
143     return balances[_owner];
144   }
145 
146 }
147 
148 contract BurnableToken is BasicToken {
149 
150     event Burn(address indexed burner, uint256 value);
151 
152     /**
153      * @dev Burns a specific amount of tokens.
154      * @param _value The amount of token to be burned.
155      */
156     function burn(uint256 _value) public {
157         require(_value <= balances[msg.sender]);
158         // no need to require value <= totalSupply, since that would imply the
159         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
160 
161         address burner = msg.sender;
162         balances[burner] = balances[burner].sub(_value);
163         totalSupply = totalSupply.sub(_value);
164         Burn(burner, _value);
165     }
166 }
167 
168 contract ERC20 is ERC20Basic {
169   function allowance(address owner, address spender) public view returns (uint256);
170   function transferFrom(address from, address to, uint256 value) public returns (bool);
171   function approve(address spender, uint256 value) public returns (bool);
172   event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
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
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 contract PausableToken is StandardToken, Pausable {
264 
265   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
266     return super.transfer(_to, _value);
267   }
268 
269   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
270     return super.transferFrom(_from, _to, _value);
271   }
272 
273   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
274     return super.approve(_spender, _value);
275   }
276 
277   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
278     return super.increaseApproval(_spender, _addedValue);
279   }
280 
281   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
282     return super.decreaseApproval(_spender, _subtractedValue);
283   }
284 }
285 
286 contract DataWalletToken is PausableToken, BurnableToken {
287 
288     string public constant name = "DataWallet Token";
289     string public constant symbol = "DXT";
290     uint8 public constant decimals = 8;
291     uint256 public constant INITIAL_SUPPLY = 1000000000 * 10**uint256(decimals);
292     
293     /**
294     * @dev DataWalletToken Constructor
295     */
296 
297     function DataWalletToken() public {
298         totalSupply = INITIAL_SUPPLY;   
299         balances[msg.sender] = INITIAL_SUPPLY;
300     }
301 
302     function transfer(address beneficiary, uint256 amount) public returns (bool) {
303         if (msg.sender != owner) {
304             require(!paused);
305         }
306         require(beneficiary != address(0));
307         require(amount <= balances[msg.sender]);
308 
309         // SafeMath.sub will throw if there is not enough balance.
310         balances[msg.sender] = balances[msg.sender].sub(amount);
311         balances[beneficiary] = balances[beneficiary].add(amount);
312         Transfer(msg.sender, beneficiary, amount);
313         return true;
314     }
315 }