1 /**
2  *Submitted for verification at Etherscan.io on 2018-02-09
3 */
4 
5 pragma solidity ^0.4.16;
6 
7 /**
8  * @title SafeMath
9  * @dev Math operations with safety checks that throw on error
10  */
11 library SafeMath {
12   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
13     uint256 c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint256 a, uint256 b) internal constant returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43   uint256 public totalSupply;
44   function balanceOf(address who) public constant returns (uint256);
45   function transfer(address to, uint256 value) public returns (bool);
46   event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 /**
50  * @title Basic token
51  * @dev Basic version of StandardToken, with no allowances.
52  */
53 contract BasicToken is ERC20Basic {
54   using SafeMath for uint256;
55 
56   mapping(address => uint256) balances;
57 
58   /**
59   * @dev transfer token for a specified address
60   * @param _to The address to transfer to.
61   * @param _value The amount to be transferred.
62   */
63   function transfer(address _to, uint256 _value) public returns (bool) {
64     require(_to != address(0));
65     require(_value > 0 && _value <= balances[msg.sender]);
66 
67     // SafeMath.sub will throw if there is not enough balance.
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   /**
75   * @dev Gets the balance of the specified address.
76   * @param _owner The address to query the the balance of.
77   * @return An uint256 representing the amount owned by the passed address.
78   */
79   function balanceOf(address _owner) public constant returns (uint256 balance) {
80     return balances[_owner];
81   }
82 }
83 
84 /**
85  * @title ERC20 interface
86  * @dev see https://github.com/ethereum/EIPs/issues/20
87  */
88 contract ERC20 is ERC20Basic {
89   function allowance(address owner, address spender) public constant returns (uint256);
90   function transferFrom(address from, address to, uint256 value) public returns (bool);
91   function approve(address spender, uint256 value) public returns (bool);
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105   mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108   /**
109    * @dev Transfer tokens from one address to another
110    * @param _from address The address which you want to send tokens from
111    * @param _to address The address which you want to transfer to
112    * @param _value uint256 the amount of tokens to be transferred
113    */
114   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115     require(_to != address(0));
116     require(_value > 0 && _value <= balances[_from]);
117     require(_value <= allowed[_from][msg.sender]);
118 
119     balances[_from] = balances[_from].sub(_value);
120     balances[_to] = balances[_to].add(_value);
121     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122     Transfer(_from, _to, _value);
123     return true;
124   }
125 
126   /**
127    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128    *
129    * Beware that changing an allowance with this method brings the risk that someone may use both the old
130    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133    * @param _spender The address which will spend the funds.
134    * @param _value The amount of tokens to be spent.
135    */
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   /**
143    * @dev Function to check the amount of tokens that an owner allowed to a spender.
144    * @param _owner address The address which owns the funds.
145    * @param _spender address The address which will spend the funds.
146    * @return A uint256 specifying the amount of tokens still available for the spender.
147    */
148   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
149     return allowed[_owner][_spender];
150   }
151 }
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() {
170     owner = msg.sender;
171   }
172 
173 
174   /**
175    * @dev Throws if called by any account other than the owner.
176    */
177   modifier onlyOwner() {
178     require(msg.sender == owner);
179     _;
180   }
181 
182 
183   /**
184    * @dev Allows the current owner to transfer control of the contract to a newOwner.
185    * @param newOwner The address to transfer ownership to.
186    */
187   function transferOwnership(address newOwner) onlyOwner public {
188     require(newOwner != address(0));
189     OwnershipTransferred(owner, newOwner);
190     owner = newOwner;
191   }
192 
193 }
194 
195 /**
196  * @title Pausable
197  * @dev Base contract which allows children to implement an emergency stop mechanism.
198  */
199 contract Pausable is Ownable {
200   event Pause();
201   event Unpause();
202 
203   bool public paused = false;
204 
205 
206   /**
207    * @dev Modifier to make a function callable only when the contract is not paused.
208    */
209   modifier whenNotPaused() {
210     require(!paused);
211     _;
212   }
213 
214   /**
215    * @dev Modifier to make a function callable only when the contract is paused.
216    */
217   modifier whenPaused() {
218     require(paused);
219     _;
220   }
221 
222   /**
223    * @dev called by the owner to pause, triggers stopped state
224    */
225   function pause() onlyOwner whenNotPaused public {
226     paused = true;
227     Pause();
228   }
229 
230   /**
231    * @dev called by the owner to unpause, returns to normal state
232    */
233   function unpause() onlyOwner whenPaused public {
234     paused = false;
235     Unpause();
236   }
237 }
238 
239 /**
240  * @title Pausable token
241  *
242  * @dev StandardToken modified with pausable transfers.
243  **/
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
259   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
260     uint cnt = _receivers.length;
261     uint256 amount = uint256(cnt) * _value;
262     require(cnt > 0 && cnt <= 20);
263     require(_value > 0 && balances[msg.sender] >= amount);
264 
265     balances[msg.sender] = balances[msg.sender].sub(amount);
266     for (uint i = 0; i < cnt; i++) {
267         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
268         Transfer(msg.sender, _receivers[i], _value);
269     }
270     return true;
271   }
272 }
273 
274 /**
275  * @title Bec Token
276  *
277  * @dev Implementation of Bec Token based on the basic standard token.
278  */
279 contract BecToken is PausableToken {
280     /**
281     * Public variables of the token
282     * The following variables are OPTIONAL vanities. One does not have to include them.
283     * They allow one to customise the token contract & in no way influences the core functionality.
284     * Some wallets/interfaces might not even bother to look at this information.
285     */
286     string public name = "BeautyChain";
287     string public symbol = "BEC";
288     string public version = '1.0.0';
289     uint8 public decimals = 18;
290 
291     /**
292      * @dev Function to check the amount of tokens that an owner allowed to a spender.
293      */
294     function BecToken() {
295       totalSupply = 7000000000 * (10**(uint256(decimals)));
296       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
297     }
298 
299     function () {
300         //if ether is sent to this address, send it back.
301         revert();
302     }
303 }