1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) constant returns (uint256);
6   function transfer(address to, uint256 value) returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract Ownable {
11   address public owner;
12 
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22 
23   /**
24    * @dev Throws if called by any account other than the owner.
25    */
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30 
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) onlyOwner {
37     if (newOwner != address(0)) {
38       owner = newOwner;
39     }
40   }
41 
42 }
43 
44 contract Pausable is Ownable {
45   event Pause();
46   event Unpause();
47 
48   bool public paused = false;
49 
50 
51   /**
52    * @dev modifier to allow actions only when the contract IS paused
53    */
54   modifier whenNotPaused() {
55     require(!paused);
56     _;
57   }
58 
59   /**
60    * @dev modifier to allow actions only when the contract IS NOT paused
61    */
62   modifier whenPaused {
63     require(paused);
64     _;
65   }
66 
67   /**
68    * @dev called by the owner to pause, triggers stopped state
69    */
70   function pause() onlyOwner whenNotPaused returns (bool) {
71     paused = true;
72     Pause();
73     return true;
74   }
75 
76   /**
77    * @dev called by the owner to unpause, returns to normal state
78    */
79   function unpause() onlyOwner whenPaused returns (bool) {
80     paused = false;
81     Unpause();
82     return true;
83   }
84 }
85 
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) returns (bool);
89   function approve(address spender, uint256 value) returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 library SafeMath {
94   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
95     uint256 c = a * b;
96     assert(a == 0 || c / a == b);
97     return c;
98   }
99 
100   function div(uint256 a, uint256 b) internal constant returns (uint256) {
101     // assert(b > 0); // Solidity automatically throws when dividing by 0
102     uint256 c = a / b;
103     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104     return c;
105   }
106 
107   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
108     assert(b <= a);
109     return a - b;
110   }
111 
112   function add(uint256 a, uint256 b) internal constant returns (uint256) {
113     uint256 c = a + b;
114     assert(c >= a);
115     return c;
116   }
117 }
118 
119 contract BasicToken is ERC20Basic {
120   using SafeMath for uint256;
121 
122   mapping(address => uint256) balances;
123 
124   /**
125   * @dev transfer token for a specified address
126   * @param _to The address to transfer to.
127   * @param _value The amount to be transferred.
128   */
129   function transfer(address _to, uint256 _value) returns (bool) {
130     balances[msg.sender] = balances[msg.sender].sub(_value);
131     balances[_to] = balances[_to].add(_value);
132     Transfer(msg.sender, _to, _value);
133     return true;
134   }
135 
136   /**
137   * @dev Gets the balance of the specified address.
138   * @param _owner The address to query the the balance of. 
139   * @return An uint256 representing the amount owned by the passed address.
140   */
141   function balanceOf(address _owner) constant returns (uint256 balance) {
142     return balances[_owner];
143   }
144 
145 }
146 
147 contract StandardToken is ERC20, BasicToken {
148 
149   mapping (address => mapping (address => uint256)) allowed;
150 
151 
152   /**
153    * @dev Transfer tokens from one address to another
154    * @param _from address The address which you want to send tokens from
155    * @param _to address The address which you want to transfer to
156    * @param _value uint256 the amout of tokens to be transfered
157    */
158   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
159     var _allowance = allowed[_from][msg.sender];
160 
161     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
162     // require (_value <= _allowance);
163 
164     balances[_to] = balances[_to].add(_value);
165     balances[_from] = balances[_from].sub(_value);
166     allowed[_from][msg.sender] = _allowance.sub(_value);
167     Transfer(_from, _to, _value);
168     return true;
169   }
170 
171   /**
172    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
173    * @param _spender The address which will spend the funds.
174    * @param _value The amount of tokens to be spent.
175    */
176   function approve(address _spender, uint256 _value) returns (bool) {
177 
178     // To change the approve amount you first have to reduce the addresses`
179     //  allowance to zero by calling `approve(_spender, 0)` if it is not
180     //  already 0 to mitigate the race condition described here:
181     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
182     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
183 
184     allowed[msg.sender][_spender] = _value;
185     Approval(msg.sender, _spender, _value);
186     return true;
187   }
188 
189   /**
190    * @dev Function to check the amount of tokens that an owner allowed to a spender.
191    * @param _owner address The address which owns the funds.
192    * @param _spender address The address which will spend the funds.
193    * @return A uint256 specifing the amount of tokens still avaible for the spender.
194    */
195   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
196     return allowed[_owner][_spender];
197   }
198 
199 }
200 
201 contract MintableToken is StandardToken, Ownable {
202   event Mint(address indexed to, uint256 amount);
203   event MintFinished();
204 
205   bool public mintingFinished = false;
206 
207   uint256 public cap = 4560000000 * (10 ** uint256(18));
208 
209 
210   modifier canMint() {
211     require(!mintingFinished);
212     _;
213   }
214 
215   /**
216    * @dev Function to mint tokens
217    * @param _to The address that will recieve the minted tokens.
218    * @param _amount The amount of tokens to mint.
219    * @return A boolean that indicates if the operation was successful.
220    */
221   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
222     totalSupply = totalSupply.add(_amount);
223     balances[_to] = balances[_to].add(_amount);
224     Mint(_to, _amount);
225     return true;
226   }
227 
228   /**
229    * @dev Function to stop minting new tokens.
230    * @return True if the operation was successful.
231    */
232   function finishMinting() onlyOwner returns (bool) {
233     mintingFinished = true;
234     MintFinished();
235     return true;
236   }
237 }
238 
239 contract PausableToken is StandardToken, Pausable {
240 
241   function transfer(address _to, uint _value) whenNotPaused returns (bool) {
242     return super.transfer(_to, _value);
243   }
244 
245   function transferFrom(address _from, address _to, uint _value) whenNotPaused returns (bool) {
246     return super.transferFrom(_from, _to, _value);
247   }
248 }
249 
250 contract BurnableToken is StandardToken {
251 
252     event Burn(address indexed burner, uint256 value);
253 
254     /**
255      * @dev Burns a specified amount of tokens.
256      * @param _value The amount of tokens to burn. 
257      */
258     function burn(uint256 _value) public {
259         require(_value > 0);
260 
261         address burner = msg.sender;
262         balances[burner] = balances[burner].sub(_value);
263         totalSupply = totalSupply.sub(_value);
264         Burn(msg.sender, _value);
265     }
266 
267 }
268 
269 /**
270  * @title Capped token
271  * @dev Mintable token with a token cap.
272  */
273 contract CappedToken is MintableToken {
274 
275   /**
276    * @dev Function to mint tokens
277    * @param _to The address that will receive the minted tokens.
278    * @param _amount The amount of tokens to mint.
279    * @return A boolean that indicates if the operation was successful.
280    */
281   function mint(
282     address _to,
283     uint256 _amount
284   )
285     public
286     returns (bool)
287   {
288     require(totalSupply.add(_amount) <= cap);
289 
290     return super.mint(_to, _amount);
291   }
292 
293 }
294 
295 
296 
297 contract SYMTOKEN is BurnableToken, PausableToken, MintableToken, CappedToken {
298 
299     string public constant symbol = "SYM";
300 
301     string public constant name = "Sym Token";
302 
303     uint8 public constant decimals = 18;
304 
305     uint256 public constant INITIAL_SUPPLY = 44396844 * (10 ** uint256(decimals));
306 
307     function burn(uint256 _value) whenNotPaused public {
308         super.burn(_value);
309     }
310 
311     function SYMTOKEN() {
312         totalSupply = INITIAL_SUPPLY;
313         balances[msg.sender] = INITIAL_SUPPLY;
314     }
315 }