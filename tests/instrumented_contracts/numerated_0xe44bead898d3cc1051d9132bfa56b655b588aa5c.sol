1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
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
33 
34 /**
35  * @title Ownable
36  * @dev The Ownable contract has an owner address, and provides basic authorization control
37  * functions, this simplifies the implementation of "user permissions".
38  */
39 contract Ownable {
40   address public owner;
41 
42 
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
44 
45 
46   /**
47    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
48    * account.
49    */
50   constructor() public {
51     owner = msg.sender;
52   }
53 
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 /**
76  * @title ERC20Basic
77  * @dev Simpler version of ERC20 interface
78  * @dev see https://github.com/ethereum/EIPs/issues/179
79  */
80 contract ERC20Basic {
81   uint256 public totalSupply;
82   function balanceOf(address who) public constant returns (uint256);
83   function transfer(address to, uint256 value) public returns (bool);
84   event Transfer(address indexed from, address indexed to, uint256 value);
85 }
86 
87 
88 /**
89  * @title Basic token
90  * @dev Basic version of StandardToken, with no allowances.
91  */
92 contract BasicToken is ERC20Basic, Ownable {
93   using SafeMath for uint256;
94 
95   mapping(address => uint256) balances;
96 
97   uint pointMultiplier = 1e18;
98   mapping (address => uint) lastDivPoints;
99   uint totalDivPoints = 0;
100 
101   string[] public divMessages;
102 
103   event DividendsTransferred(address account, uint amount);
104   event DividendsAdded(uint amount, string message);
105 
106   function divsOwing(address _addr) public view returns (uint) {
107     uint newDivPoints = totalDivPoints.sub(lastDivPoints[_addr]);
108     return balances[_addr].mul(newDivPoints).div(pointMultiplier);
109   }
110 
111   function updateAccount(address account) internal {
112     uint owing = divsOwing(account);
113     if (owing > 0) {
114       account.transfer(owing);
115       emit DividendsTransferred(account, owing);
116     }
117     lastDivPoints[account] = totalDivPoints;
118   }
119 
120   function payDividends(string message) payable public onlyOwner {
121     uint weiAmount = msg.value;
122     require(weiAmount>0);
123 
124     divMessages.push(message);
125 
126     totalDivPoints = totalDivPoints.add(weiAmount.mul(pointMultiplier).div(totalSupply));
127     emit DividendsAdded(weiAmount, message);
128   }
129 
130   function getLastDivMessage() public view returns (string, uint) {
131     return (divMessages[divMessages.length - 1], divMessages.length);
132   }
133 
134   function claimDividends() public {
135     updateAccount(msg.sender);
136   }
137 
138   /**
139   * @dev transfer token for a specified address
140   * @param _to The address to transfer to.
141   * @param _value The amount to be transferred.
142   */
143   function transfer(address _to, uint256 _value) public returns (bool) {
144     require(_to != address(0));
145     
146     updateAccount(msg.sender);
147     updateAccount(_to);
148 
149     // SafeMath.sub will throw if there is not enough balance.
150     balances[msg.sender] = balances[msg.sender].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     emit Transfer(msg.sender, _to, _value);
153     return true;
154   }
155 
156   /**
157   * @dev Gets the balance of the specified address.
158   * @param _owner The address to query the the balance of.
159   * @return An uint256 representing the amount owned by the passed address.
160   */
161   function balanceOf(address _owner) public constant returns (uint256 balance) {
162     return balances[_owner];
163   }
164 }
165 
166 /**
167  * @title ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/20
169  */
170 contract ERC20 is ERC20Basic {
171   function allowance(address owner, address spender) public constant returns (uint256);
172   function transferFrom(address from, address to, uint256 value) public returns (bool);
173   function approve(address spender, uint256 value) public returns (bool);
174   event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * @dev https://github.com/ethereum/EIPs/issues/20
183  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken {
186 
187   mapping (address => mapping (address => uint256)) allowed;
188 
189 
190   /**
191    * @dev Transfer tokens from one address to another
192    * @param _from address The address which you want to send tokens from
193    * @param _to address The address which you want to transfer to
194    * @param _value uint256 the amount of tokens to be transferred
195    */
196   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
197     require(_to != address(0));
198 
199     updateAccount(_from);
200     updateAccount(_to);
201 
202     uint256 _allowance = allowed[_from][msg.sender];
203 
204     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
205     // require (_value <= _allowance);
206 
207     balances[_from] = balances[_from].sub(_value);
208     balances[_to] = balances[_to].add(_value);
209     allowed[_from][msg.sender] = _allowance.sub(_value);
210     emit Transfer(_from, _to, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
216    *
217    * Beware that changing an allowance with this method brings the risk that someone may use both the old
218    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
219    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
220    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
221    * @param _spender The address which will spend the funds.
222    * @param _value The amount of tokens to be spent.
223    */
224   function approve(address _spender, uint256 _value) public returns (bool) {
225     allowed[msg.sender][_spender] = _value;
226     emit Approval(msg.sender, _spender, _value);
227     return true;
228   }
229 
230   /**
231    * @dev Function to check the amount of tokens that an owner allowed to a spender.
232    * @param _owner address The address which owns the funds.
233    * @param _spender address The address which will spend the funds.
234    * @return A uint256 specifying the amount of tokens still available for the spender.
235    */
236   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
237     return allowed[_owner][_spender];
238   }
239 
240   /**
241    * approve should be called when allowed[_spender] == 0. To increment
242    * allowed value is better to use this function to avoid 2 calls (and wait until
243    * the first transaction is mined)
244    * From MonolithDAO Token.sol
245    */
246   function increaseApproval (address _spender, uint _addedValue) public
247     returns (bool success) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   function decreaseApproval (address _spender, uint _subtractedValue) public
254     returns (bool success) {
255     uint oldValue = allowed[msg.sender][_spender];
256     if (_subtractedValue > oldValue) {
257       allowed[msg.sender][_spender] = 0;
258     } else {
259       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
260     }
261     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
262     return true;
263   }
264 }
265 
266 
267 /**
268  * @title Burnable Token
269  * @dev Token that can be irreversibly burned (destroyed).
270  */
271 contract BurnableToken is StandardToken {
272 
273     event Burn(address indexed burner, uint256 value);
274 
275     /**
276      * @dev Burns a specific amount of tokens.
277      * @param _value The amount of token to be burned.
278      */
279     function burn(uint256 _value) public onlyOwner {
280         require(_value > 0);
281         require(_value <= balances[msg.sender]);
282         updateAccount(msg.sender);
283         // no need to require value <= totalSupply, since that would imply the
284         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
285 
286         address burner = msg.sender;
287         balances[burner] = balances[burner].sub(_value);
288         totalSupply = totalSupply.sub(_value);
289         emit Burn(burner, _value);
290         emit Transfer(burner, address(0), _value);
291     }
292 }
293 
294 contract NetCurrencyIndexToken is BurnableToken {
295 
296     string public constant name = "NetCurrencyIndex";
297     string public constant symbol = "NCI500";
298     uint public constant decimals = 18;
299     // there is no problem in using * here instead of .mul()
300     uint256 public constant initialSupply = 50000000 * (10 ** uint256(decimals));
301 
302     // Constructors
303     constructor () public {
304         totalSupply = initialSupply;
305         balances[msg.sender] = initialSupply; // Send all tokens to owner
306         emit Transfer(0x0,msg.sender,initialSupply);
307     }
308 
309     struct Rate {
310       uint256 current_rate;
311       string remark;
312       uint256 time;
313     }
314 
315     Rate[] public rates;
316 
317     // owner can save current rate from API
318     function update_current_rate(uint256 current_rate, string remark) public onlyOwner{
319       Rate memory rate = Rate({current_rate: current_rate, remark: remark, time: now});
320       rates.push(rate);
321     }
322 
323     function getLastRate() public view returns (uint, string, uint, uint) {
324     Rate memory rate = rates[rates.length - 1];
325       return (rate.current_rate, rate.remark, rate.time, rates.length);
326     }
327 }