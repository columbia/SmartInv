1 pragma solidity ^0.4.18;
2 
3 /**xxp 校验防止溢出情况
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 /**
37  * @title ERC20Basic
38  */
39 contract ERC20Basic {
40   uint256 public totalSupply;
41   function balanceOf(address who) public constant returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 
45   function allowance(address owner, address spender) public constant returns (uint256);
46   function transferFrom(address from, address to, uint256 value) public returns (bool);
47   function approve(address spender, uint256 value) public returns (bool);
48   event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 /**
52  * @title Ownable
53  * @dev The Ownable contract has an owner address, and provides basic authorization control
54  * functions, this simplifies the implementation of "user permissions".
55  */
56 contract Ownable {
57   address public owner;
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61   /**
62    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63    * account.
64    */
65   function Ownable() public {
66     owner = msg.sender;
67   }
68 
69   /**
70    * @dev Throws if called by any account other than the owner.
71    */
72   modifier onlyOwner() {
73     require(msg.sender == owner);
74     _;
75   }
76 
77   /**
78    * @dev Allows the current owner to transfer control of the contract to a newOwner.
79    * @param newOwner The address to transfer ownership to.
80    */
81   function transferOwnership(address newOwner) onlyOwner public {
82     require(newOwner != address(0));
83     OwnershipTransferred(owner, newOwner);
84     owner = newOwner;
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20Basic {
97 
98   using SafeMath for uint256;
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101   // store tokens
102   mapping(address => uint256) balances;
103   // uint256 public totalSupply;
104 
105   /**
106   * @dev transfer token for a specified address
107   * @param _to The address to transfer to.
108   * @param _value The amount to be transferred.
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     require(_to != address(0));
112     require(_value <= balances[msg.sender]);
113 
114     // SafeMath.sub will throw if there is not enough balance.
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   /**
122   * @dev Gets the balance of the specified address.
123   * @param _owner The address to query the the balance of.
124   * @return An uint256 representing the amount owned by the passed address.
125   */
126   function balanceOf(address _owner) public constant returns (uint256 balance) {
127     return balances[_owner];
128   }
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138     require(_to != address(0));
139     require(_value <= balances[_from]);
140     require(_value <= allowed[_from][msg.sender]);
141 
142     balances[_from] = balances[_from].sub(_value);
143     balances[_to] = balances[_to].add(_value);
144     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145     Transfer(_from, _to, _value);
146     return true;
147   }
148 
149   /**
150    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
151    *
152    * Beware that changing an allowance with this method brings the risk that someone may use both the old
153    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
154    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
155    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156    * @param _spender The address which will spend the funds.
157    * @param _value The amount of tokens to be spent.
158    */
159   function approve(address _spender, uint256 _value) public returns (bool) {
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifying the amount of tokens still available for the spender.
170    */
171   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 }
175 
176 /**
177  * @title Burnable Token
178  * @dev Token that can be irreversibly burned (destroyed).
179  */
180 contract BurnableToken is StandardToken {
181 
182     event Burn(address indexed burner, uint256 value);
183 
184     /**
185      * @dev Burns a specific amount of tokens.
186      * @param _value The amount of token to be burned.
187      */
188     function burn(uint256 _value) public {
189         require(_value > 0);
190         require(_value <= balances[msg.sender]);
191         // no need to require value <= totalSupply, since that would imply the
192         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
193 
194         address burner = msg.sender;
195         balances[burner] = balances[burner].sub(_value);
196         totalSupply = totalSupply.sub(_value);
197         Burn(burner, _value);
198     }
199 }
200 
201 /**
202  * @title Mintable token
203  * @dev Simple ERC20 Token example, with mintable token creation
204  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
205  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
206  */
207 
208 contract MintableToken is StandardToken, Ownable {
209   event Mint(address indexed to, uint256 amount);
210   event MintFinished();
211 
212   bool public mintingFinished = false;
213 
214 
215   modifier canMint() {
216     require(!mintingFinished);
217     _;
218   }
219 
220   /**
221    * @dev Function to mint tokens
222    * @param _to The address that will receive the minted tokens.
223    * @param _amount The amount of tokens to mint.
224    * @return A boolean that indicates if the operation was successful.
225    */
226   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
227     totalSupply = totalSupply.add(_amount);
228     balances[_to] = balances[_to].add(_amount);
229     Mint(_to, _amount);
230     Transfer(0x0, _to, _amount);
231     return true;
232   }
233 
234   /**
235    * @dev Function to stop minting new tokens.
236    * @return True if the operation was successful.
237    */
238   function finishMinting() onlyOwner public returns (bool) {
239     mintingFinished = true;
240     MintFinished();
241     return true;
242   }
243 }
244 
245 /**
246  * @title Pausable
247  * @dev Base contract which allows children to implement an emergency stop mechanism.
248  */
249 contract Pausable is Ownable {
250   event Pause();
251   event Unpause();
252 
253   bool public paused = false;
254 
255 
256   /**
257    * @dev Modifier to make a function callable only when the contract is not paused.
258    */
259   modifier whenNotPaused() {
260     require(!paused);
261     _;
262   }
263 
264   /**
265    * @dev Modifier to make a function callable only when the contract is paused.
266    */
267   modifier whenPaused() {
268     require(paused);
269     _;
270   }
271 
272   /**
273    * @dev called by the owner to pause, triggers stopped state
274    */
275   function pause() onlyOwner whenNotPaused public {
276     paused = true;
277     Pause();
278   }
279 
280   /**
281    * @dev called by the owner to unpause, returns to normal state
282    */
283   function unpause() onlyOwner whenPaused public {
284     paused = false;
285     Unpause();
286   }
287 }
288 
289 /**
290  * @title Pausable token
291  *
292  * @dev StandardToken modified with pausable transfers.
293  **/
294 
295 contract PausableToken is StandardToken, Pausable {
296 
297   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
298     return super.transfer(_to, _value);
299   }
300 
301   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
302     return super.transferFrom(_from, _to, _value);
303   }
304 
305   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
306     return super.approve(_spender, _value);
307   }
308 }
309 
310 /*
311  * @title DininbToken
312  */
313 contract DininbToken is BurnableToken, MintableToken, PausableToken {
314   // Public variables of the token
315   string public name;
316   string public symbol;
317   // 等同于Wei的概念,  decimals is the strongly suggested default, avoid changing it
318   uint8 public decimals;
319 
320   function DininbToken() public {
321     name = "dininb";
322     symbol = "db";
323     decimals = 18;
324     totalSupply = 1000000000 * 10 ** uint256(decimals);
325 
326     // Allocate initial balance to the owner
327     balances[msg.sender] = totalSupply;
328   }
329 }