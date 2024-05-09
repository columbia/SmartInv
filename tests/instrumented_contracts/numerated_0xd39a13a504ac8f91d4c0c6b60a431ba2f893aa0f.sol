1 pragma solidity ^0.4.21;
2 
3 /**xxp 校验防止溢出情况
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 /**
34  * @title ERC20Basic
35  */
36 contract ERC20Basic {
37     uint256 public totalSupply;
38     function balanceOf(address who) public constant returns (uint256);
39     function transfer(address to, uint256 value) public returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41 
42     function allowance(address owner, address spender) public constant returns (uint256);
43     function transferFrom(address from, address to, uint256 value) public returns (bool);
44     function approve(address spender, uint256 value) public returns (bool);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54     address public owner;
55 
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58   /**
59    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
60    * account.
61    */
62     function Ownable() public {
63         owner = msg.sender;
64     }
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69     modifier onlyOwner() {
70         require(msg.sender == owner);
71         _;
72     }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78     function transferOwnership(address newOwner) onlyOwner public {
79         require(newOwner != address(0));
80         emit OwnershipTransferred(owner, newOwner);
81         owner = newOwner;
82     }
83 
84 }
85 
86 /**
87  * @title Standard ERC20 token
88  *
89  * @dev Implementation of the basic standard token.
90  * @dev https://github.com/ethereum/EIPs/issues/20
91  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
92  */
93 contract StandardToken is ERC20Basic {
94 
95     using SafeMath for uint256;
96 
97     mapping (address => mapping (address => uint256)) internal allowed;
98     // store tokens
99     mapping(address => uint256) balances;
100   // uint256 public totalSupply;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
110 
111         // SafeMath.sub will throw if there is not enough balance.
112         balances[msg.sender] = balances[msg.sender].sub(_value);
113         balances[_to] = balances[_to].add(_value);
114         emit Transfer(msg.sender, _to, _value);
115         return true;
116     }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123     function balanceOf(address _owner) public constant returns (uint256 balance) {
124         return balances[_owner];
125     }
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amount of tokens to be transferred
133    */
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138 
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146   /**
147    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
148    *
149    * Beware that changing an allowance with this method brings the risk that someone may use both the old
150    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153    * @param _spender The address which will spend the funds.
154    * @param _value The amount of tokens to be spent.
155    */
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160     }
161 
162   /**
163    * @dev Function to check the amount of tokens that an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint256 specifying the amount of tokens still available for the spender.
167    */
168     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
169         return allowed[_owner][_spender];
170     }
171 }
172 
173 /**
174  * @title Burnable Token
175  * @dev Token that can be irreversibly burned (destroyed).
176  */
177 contract BurnableToken is StandardToken {
178 
179     event Burn(address indexed burner, uint256 value);
180 
181     /**
182      * @dev Burns a specific amount of tokens.
183      * @param _value The amount of token to be burned.
184      */
185     function burn(uint256 _value) public {
186         require(_value > 0);
187         require(_value <= balances[msg.sender]);
188         // no need to require value <= totalSupply, since that would imply the
189         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
190 
191         address burner = msg.sender;
192         balances[burner] = balances[burner].sub(_value);
193         totalSupply = totalSupply.sub(_value);
194         emit Burn(burner, _value);
195     }
196 }
197 
198 /**
199  * @title Mintable token
200  * @dev Simple ERC20 Token example, with mintable token creation
201  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
202  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
203  */
204 
205 contract MintableToken is StandardToken, Ownable {
206     event Mint(address indexed to, uint256 amount);
207     event MintFinished();
208 
209     bool public mintingFinished = false;
210 
211 
212     modifier canMint() {
213         require(!mintingFinished);
214         _;
215     }
216 
217   /**
218    * @dev Function to mint tokens
219    * @param _to The address that will receive the minted tokens.
220    * @param _amount The amount of tokens to mint.
221    * @return A boolean that indicates if the operation was successful.
222    */
223     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
224         totalSupply = totalSupply.add(_amount);
225         balances[_to] = balances[_to].add(_amount);
226         emit Mint(_to, _amount);
227         emit Transfer(0x0, _to, _amount);
228         return true;
229     }
230 
231   /**
232    * @dev Function to stop minting new tokens.
233    * @return True if the operation was successful.
234    */
235     function finishMinting() onlyOwner public returns (bool) {
236         mintingFinished = true;
237         emit MintFinished();
238         return true;
239     }
240 }
241 
242 /**
243  * @title Pausable
244  * @dev Base contract which allows children to implement an emergency stop mechanism.
245  */
246 contract Pausable is Ownable {
247     event Pause();
248     event Unpause();
249 
250     bool public paused = false;
251 
252 
253   /**
254    * @dev Modifier to make a function callable only when the contract is not paused.
255    */
256     modifier whenNotPaused() {
257         require(!paused);
258         _;
259     }
260 
261   /**
262    * @dev Modifier to make a function callable only when the contract is paused.
263    */
264     modifier whenPaused() {
265         require(paused);
266         _;
267     }
268 
269   /**
270    * @dev called by the owner to pause, triggers stopped state
271    */
272     function pause() onlyOwner whenNotPaused public {
273         paused = true;
274         emit Pause();
275     }
276 
277   /**
278    * @dev called by the owner to unpause, returns to normal state
279    */
280     function unpause() onlyOwner whenPaused public {
281         paused = false;
282         emit Unpause();
283     }
284 }
285 
286 /**
287  * @title Pausable token
288  *
289  * @dev StandardToken modified with pausable transfers.
290  **/
291 
292 contract PausableToken is StandardToken, Pausable {
293 
294     function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
295         return super.transfer(_to, _value);
296     }
297 
298     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
299         return super.transferFrom(_from, _to, _value);
300     }
301 
302     function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
303         return super.approve(_spender, _value);
304     }
305 }
306 
307 /*
308  * @title EchoChainToken
309  */
310 contract EchoChainToken is BurnableToken, MintableToken, PausableToken {
311     // Public variables of the token
312     string public name;
313     string public symbol;
314     // decimals is the strongly suggested default, avoid changing it
315     uint8 public decimals;
316 
317     function EchoChainToken() public {
318         name = "EchoChain";
319         symbol = "ECHO";
320         decimals = 18;
321         totalSupply = 1000000000 * 10 ** uint256(decimals);
322 
323         // Allocate initial balance to the owner
324         balances[msg.sender] = totalSupply;
325     }
326 
327     // transfer balance to owner
328     function withdrawEther() onlyOwner public {
329         address addr = this;
330         owner.transfer(addr.balance);
331     }
332 
333     // can accept ether
334     function() payable public {
335     }
336 }