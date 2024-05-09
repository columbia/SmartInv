1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public owner;
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39   /**
40    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41    * account.
42    */
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   /**
48    * @dev Throws if called by any account other than the owner.
49    */
50   modifier onlyOwner() {
51     require(msg.sender == owner);
52     _;
53   }
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 contract Pausable is Ownable {
67 
68   event Pause();
69   event Unpause();
70 
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
114 
115   using SafeMath for uint256;
116 
117   mapping(address => uint256) balances;
118 
119   /**
120   * @dev transfer token for a specified address
121   * @param _to The address to transfer to.
122   * @param _value The amount to be transferred.
123   */
124   function transfer(address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[msg.sender]);
127 
128     // SafeMath.sub will throw if there is not enough balance.
129     balances[msg.sender] = balances[msg.sender].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     Transfer(msg.sender, _to, _value);
132     return true;
133   }
134 
135   /**
136   * @dev Gets the balance of the specified address.
137   * @param _owner The address to query the the balance of.
138   * @return An uint256 representing the amount owned by the passed address.
139   */
140   function balanceOf(address _owner) public view returns (uint256 balance) {
141     return balances[_owner];
142   }
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
156   /**
157    * @dev Transfer tokens from one address to another
158    * @param _from address The address which you want to send tokens from
159    * @param _to address The address which you want to transfer to
160    * @param _value uint256 the amount of tokens to be transferred
161    */
162   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
163     require(_to != address(0));
164     require(_value <= balances[_from]);
165     require(_value <= allowed[_from][msg.sender]);
166 
167     balances[_from] = balances[_from].sub(_value);
168     balances[_to] = balances[_to].add(_value);
169     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
170     Transfer(_from, _to, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176    *
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(address _owner, address _spender) public view returns (uint256) {
197     return allowed[_owner][_spender];
198   }
199 
200   /**
201    * approve should be called when allowed[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    */
206   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
207     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
208     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
209     return true;
210   }
211 
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 }
223 
224 contract BurnableToken is StandardToken {
225 
226     event Burn(address indexed burner, uint256 value);
227 
228     /**
229      * @dev Burns a specific amount of tokens.
230      * @param _value The amount of token to be burned.
231      */
232     function burn(uint256 _value) public {
233         require(_value > 0);
234         require(_value <= balances[msg.sender]);
235         // no need to require value <= totalSupply, since that would imply the
236         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
237 
238         address burner = msg.sender;
239         balances[burner] = balances[burner].sub(_value);
240         totalSupply = totalSupply.sub(_value);
241         Burn(burner, _value);
242     }
243 }
244 
245 contract PausableToken is StandardToken, Pausable {
246 
247   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
248     return super.transfer(_to, _value);
249   }
250 
251   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
252     return super.transferFrom(_from, _to, _value);
253   }
254 
255   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
256     return super.approve(_spender, _value);
257   }
258 
259   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
260     return super.increaseApproval(_spender, _addedValue);
261   }
262 
263   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
264     return super.decreaseApproval(_spender, _subtractedValue);
265   }
266 }
267 
268 contract MakonikolikoToken is PausableToken, BurnableToken {
269 
270     string public constant name = "Makonikoliko Token";
271     string public constant symbol = "MMQZ";
272     uint8 public constant decimals = 18;
273     uint256 public constant INITIAL_SUPPLY = 120000000 * 10**uint256(decimals);
274 
275     function MakonikolikoToken() {
276         totalSupply = INITIAL_SUPPLY;
277         balances[msg.sender] = INITIAL_SUPPLY;
278     }
279 
280     function transferTokens(address beneficiary, uint256 amount) onlyOwner returns (bool) {
281         require(amount > 0);
282 
283         balances[owner] = balances[owner].sub(amount);
284         balances[beneficiary] = balances[beneficiary].add(amount);
285         Transfer(owner, beneficiary, amount);
286 
287         return true;
288     }
289 }