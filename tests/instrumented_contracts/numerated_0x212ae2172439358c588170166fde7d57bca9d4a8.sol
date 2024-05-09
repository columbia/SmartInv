1 /*
2 --------------------------------------------------------------------------------
3 The Ethereum Secure Token Smart Contract
4 
5 Credit:
6 Ethereum Secure Foundation
7 
8 ERC20: https://github.com/ethereum/EIPs/issues/20
9 ERC223: https://github.com/ethereum/EIPs/issues/223
10 
11 MIT Licence
12 --------------------------------------------------------------------------------
13 */
14 
15 /*
16 * Contract that is working with ERC20 tokens
17 */
18 
19 pragma solidity ^0.4.24;
20 
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39     assert(b <= a);
40     return a - b;
41   }
42 
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   constructor() public {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     emit OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 contract Pausable is Ownable {
88   event Pause();
89   event Unpause();
90 
91   bool public paused = false;
92 
93 
94   /**
95    * @dev Modifier to make a function callable only when the contract is not paused.
96    */
97   modifier whenNotPaused() {
98     require(!paused);
99     _;
100   }
101 
102   /**
103    * @dev Modifier to make a function callable only when the contract is paused.
104    */
105   modifier whenPaused() {
106     require(paused);
107     _;
108   }
109 
110   /**
111    * @dev called by the owner to pause, triggers stopped state
112    */
113   function pause() onlyOwner whenNotPaused public {
114     paused = true;
115     emit Pause();
116   }
117 
118   /**
119    * @dev called by the owner to unpause, returns to normal state
120    */
121   function unpause() onlyOwner whenPaused public {
122     paused = false;
123     emit Unpause();
124   }
125 }
126 
127 contract ERC20Basic {
128   uint256 public totalSupply;
129   function balanceOf(address who) public view returns (uint256);
130   function transfer(address to, uint256 value) public returns (bool);
131   event Transfer(address indexed from, address indexed to, uint256 value);
132 }
133 
134 contract ERC20 is ERC20Basic {
135   function allowance(address owner, address spender) public view returns (uint256);
136   function transferFrom(address from, address to, uint256 value) public returns (bool);
137   function approve(address spender, uint256 value) public returns (bool);
138   event Approval(address indexed owner, address indexed spender, uint256 value);
139 }
140 
141 contract BasicToken is ERC20Basic {
142   using SafeMath for uint256;
143 
144   mapping(address => uint256) balances;
145 
146   /**
147   * @dev transfer token for a specified address
148   * @param _to The address to transfer to.
149   * @param _value The amount to be transferred.
150   */
151   function transfer(address _to, uint256 _value) public returns (bool) {
152     require(_to != address(0));
153     require(_value <= balances[msg.sender]);
154 
155     // SafeMath.sub will throw if there is not enough balance.
156     balances[msg.sender] = balances[msg.sender].sub(_value);
157     balances[_to] = balances[_to].add(_value);
158     emit Transfer(msg.sender, _to, _value);
159     return true;
160   }
161 
162   /**
163   * @dev Gets the balance of the specified address.
164   * @param _owner The address to query the the balance of.
165   * @return An uint256 representing the amount owned by the passed address.
166   */
167   function balanceOf(address _owner) public view returns (uint256 balance) {
168     return balances[_owner];
169   }
170 
171 }
172 
173 contract StandardToken is ERC20, BasicToken {
174 
175   mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178   /**
179    * @dev Transfer tokens from one address to another
180    * @param _from address The address which you want to send tokens from
181    * @param _to address The address which you want to transfer to
182    * @param _value uint256 the amount of tokens to be transferred
183    */
184   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185     require(_to != address(0));
186     require(_value <= balances[_from]);
187     require(_value <= allowed[_from][msg.sender]);
188 
189     balances[_from] = balances[_from].sub(_value);
190     balances[_to] = balances[_to].add(_value);
191     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192     emit Transfer(_from, _to, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198    *
199    * Beware that changing an allowance with this method brings the risk that someone may use both the old
200    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203    * @param _spender The address which will spend the funds.
204    * @param _value The amount of tokens to be spent.
205    */
206   function approve(address _spender, uint256 _value) public returns (bool) {
207     allowed[msg.sender][_spender] = _value;
208     emit Approval(msg.sender, _spender, _value);
209     return true;
210   }
211 
212   /**
213    * @dev Function to check the amount of tokens that an owner allowed to a spender.
214    * @param _owner address The address which owns the funds.
215    * @param _spender address The address which will spend the funds.
216    * @return A uint256 specifying the amount of tokens still available for the spender.
217    */
218   function allowance(address _owner, address _spender) public view returns (uint256) {
219     return allowed[_owner][_spender];
220   }
221 
222   /**
223    * @dev Increase the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To increment
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _addedValue The amount of tokens to increase the allowance by.
231    */
232   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
233     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
234     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
235     return true;
236   }
237 
238   /**
239    * @dev Decrease the amount of tokens that an owner allowed to a spender.
240    *
241    * approve should be called when allowed[_spender] == 0. To decrement
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    * @param _spender The address which will spend the funds.
246    * @param _subtractedValue The amount of tokens to decrease the allowance by.
247    */
248   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
249     uint oldValue = allowed[msg.sender][_spender];
250     if (_subtractedValue > oldValue) {
251       allowed[msg.sender][_spender] = 0;
252     } else {
253       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
254     }
255     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
256     return true;
257   }
258 
259 } 
260 
261 contract PausableToken is StandardToken, Pausable {
262 
263   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
264     return super.transfer(_to, _value);
265   }
266 
267   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
268     return super.transferFrom(_from, _to, _value);
269   }
270 
271   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
272     return super.approve(_spender, _value);
273   }
274 
275   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
276     return super.increaseApproval(_spender, _addedValue);
277   }
278 
279   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
280     return super.decreaseApproval(_spender, _subtractedValue);
281   }
282 }
283 
284 contract EthereumSecure is PausableToken {
285     string public name = "Ethereum Secure";
286     string public symbol = "ETHSecure";
287     uint public decimals = 18;
288     uint public INITIAL_SUPPLY = 21000000000000000000000000;
289 
290     constructor() public {
291         totalSupply = INITIAL_SUPPLY;
292         balances[msg.sender] = INITIAL_SUPPLY;
293     }
294 }