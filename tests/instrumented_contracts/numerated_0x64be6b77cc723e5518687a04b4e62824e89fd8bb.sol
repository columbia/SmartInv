1 pragma solidity ^0.4.18;
2 
3 /**
4  * Welcome to the Telegram chat https://devsolidity.io/
5  */
6 
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     uint256 c = a * b;
16     assert(a == 0 || c / a == b);
17     return c;
18   }
19 
20   function div(uint256 a, uint256 b) internal constant returns (uint256) {
21     // assert(b > 0); // Solidity automatically throws when dividing by 0
22     uint256 c = a / b;
23     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
24     return c;
25   }
26 
27   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
28     assert(b <= a);
29     return a - b;
30   }
31 
32   function add(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a + b;
34     assert(c >= a);
35     return c;
36   }
37 }
38 
39 contract ERC20Basic {
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) public view returns (uint256);
48   function transferFrom(address from, address to, uint256 value) public returns (bool);
49   function approve(address spender, uint256 value) public returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58   using SafeMath for uint256;
59 
60   mapping(address => uint256) balances;
61 
62   uint256 totalSupply_;
63 
64   /**
65   * @dev total number of tokens in existence
66   */
67   function totalSupply() public view returns (uint256) {
68     return totalSupply_;
69   }
70 
71   /**
72   * @dev transfer token for a specified address
73   * @param _to The address to transfer to.
74   * @param _value The amount to be transferred.
75   */
76   function transfer(address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[msg.sender]);
79 
80     // SafeMath.sub will throw if there is not enough balance.
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of.
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) public view returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 /**
99  * @title Ownable
100  * @dev The Ownable contract has an owner address, and provides basic authorization control
101  * functions, this simplifies the implementation of "user permissions".
102  */
103 contract Ownable {
104   address public owner;
105 
106   /**
107    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
108    * account.
109    */
110   function Ownable() public {
111     owner = msg.sender;
112   }
113 
114 
115   /**
116    * @dev Throws if called by any account other than the owner.
117    */
118   modifier onlyOwner() {
119     require(msg.sender == owner);
120     _;
121   }
122 
123 
124   /**
125    * @dev Allows the current owner to transfer control of the contract to a newOwner.
126    * @param newOwner The address to transfer ownership to.
127    */
128   function transferOwnership(address newOwner) onlyOwner public {
129     require(newOwner != address(0));
130     owner = newOwner;
131   }
132 
133 }
134 
135 contract Pausable is Ownable {
136 
137   uint public endDate;
138 
139   /**
140    * @dev modifier to allow actions only when the contract IS not paused
141    */
142   modifier whenNotPaused() {
143     require(now >= endDate);
144     _;
145   }
146 
147 }
148 
149 
150 contract StandardToken is ERC20, BasicToken {
151  using SafeMath for uint256;
152  mapping (address => mapping (address => uint256)) internal allowed;
153 
154 
155   /**
156    * @dev Transfer tokens from one address to another
157    * @param _from address The address which you want to send tokens from
158    * @param _to address The address which you want to transfer to
159    * @param _value uint256 the amount of tokens to be transferred
160    */
161   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
162     require(_to != address(0));
163     require(_value <= balances[_from]);
164     require(_value <= allowed[_from][msg.sender]);
165 
166     balances[_from] = balances[_from].sub(_value);
167     balances[_to] = balances[_to].add(_value);
168     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
169     Transfer(_from, _to, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
175    *
176    * Beware that changing an allowance with this method brings the risk that someone may use both the old
177    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
178    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
179    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
180    * @param _spender The address which will spend the funds.
181    * @param _value The amount of tokens to be spent.
182    */
183   function approve(address _spender, uint256 _value) public returns (bool) {
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifying the amount of tokens still available for the spender.
194    */
195   function allowance(address _owner, address _spender) public view returns (uint256) {
196     return allowed[_owner][_spender];
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To increment
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _addedValue The amount of tokens to increase the allowance by.
208    */
209   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
210     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215   /**
216    * @dev Decrease the amount of tokens that an owner allowed to a spender.
217    *
218    * approve should be called when allowed[_spender] == 0. To decrement
219    * allowed value is better to use this function to avoid 2 calls (and wait until
220    * the first transaction is mined)
221    * From MonolithDAO Token.sol
222    * @param _spender The address which will spend the funds.
223    * @param _subtractedValue The amount of tokens to decrease the allowance by.
224    */
225   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
226     uint oldValue = allowed[msg.sender][_spender];
227     if (_subtractedValue > oldValue) {
228       allowed[msg.sender][_spender] = 0;
229     } else {
230       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
231     }
232     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
233     return true;
234   }
235 
236 }
237 
238 /**
239  * @title Pausable token
240  * @dev StandardToken modified with pausable transfers.
241  **/
242 contract PausableToken is StandardToken, Pausable {
243 
244   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
245     return super.transfer(_to, _value);
246   }
247 
248   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
249     return super.transferFrom(_from, _to, _value);
250   }
251 
252   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
253     return super.approve(_spender, _value);
254   }
255 
256   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
257     return super.increaseApproval(_spender, _addedValue);
258   }
259 
260   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
261     return super.decreaseApproval(_spender, _subtractedValue);
262   }
263 }
264 
265 contract StopTheFakes is PausableToken {
266 
267     string public constant name = "STFCoin";
268     string public constant symbol = "STF";
269     uint8 public constant decimals = 18;
270     address public tokenWallet;
271     address public teamWallet = 0x5b2E57eA330a26a8e6e32256DDc4681Df8bFE809;
272 
273     uint256 public constant INITIAL_SUPPLY = 29000000 ether;
274 
275     function StopTheFakes(address tokenOwner, uint _endDate) {
276         totalSupply_ = INITIAL_SUPPLY;
277         balances[teamWallet] = 7424000 ether;
278         balances[tokenOwner] = INITIAL_SUPPLY - balances[teamWallet];
279         endDate = _endDate;
280         tokenWallet = tokenOwner;
281         Transfer(0x0, teamWallet, balances[teamWallet]);
282         Transfer(0x0, tokenOwner, balances[tokenOwner]);
283     }
284 
285     function sendTokens(address _to, uint _value) public onlyOwner {
286         require(_to != address(0));
287         require(_value <= balances[tokenWallet]);
288         balances[tokenWallet] = balances[tokenWallet].sub(_value);
289         balances[_to] = balances[_to].add(_value);
290         Transfer(tokenWallet, _to, _value);
291     }
292 
293 }