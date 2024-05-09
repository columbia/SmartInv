1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title ERC20Basic
35  * @dev Simpler version of ERC20 interface
36  * @dev see https://github.com/ethereum/EIPs/issues/179
37  */
38 contract ERC20Basic {
39   uint256 public totalSupply;
40   function balanceOf(address who) public constant returns (uint256);
41   function transfer(address to, uint256 value) public returns (bool);
42   event Transfer(address indexed from, address indexed to, uint256 value);
43 }
44 
45 /**
46  * @title Basic token
47  * @dev Basic version of StandardToken, with no allowances.
48  */
49 contract BasicToken is ERC20Basic {
50   using SafeMath for uint256;
51 
52   mapping(address => uint256) balances;
53 
54   /**
55   * @dev transfer token for a specified address
56   * @param _to The address to transfer to.
57   * @param _value The amount to be transferred.
58   */
59   function transfer(address _to, uint256 _value) public returns (bool) {
60     require(_to != address(0));
61     require(_value > 0 && _value <= balances[msg.sender]);
62 
63     // SafeMath.sub will throw if there is not enough balance.
64     balances[msg.sender] = balances[msg.sender].sub(_value);
65     balances[_to] = balances[_to].add(_value);
66     Transfer(msg.sender, _to, _value);
67     return true;
68   }
69 
70   /**
71   * @dev Gets the balance of the specified address.
72   * @param _owner The address to query the the balance of.
73   * @return An uint256 representing the amount owned by the passed address.
74   */
75   function balanceOf(address _owner) public constant returns (uint256 balance) {
76     return balances[_owner];
77   }
78 }
79 
80 /**
81  * @title ERC20 interface
82  * @dev see https://github.com/ethereum/EIPs/issues/20
83  */
84 contract ERC20 is ERC20Basic {
85   function allowance(address owner, address spender) public constant returns (uint256);
86   function transferFrom(address from, address to, uint256 value) public returns (bool);
87   function approve(address spender, uint256 value) public returns (bool);
88   event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 
91 
92 /**
93  * @title Standard ERC20 token
94  *
95  * @dev Implementation of the basic standard token.
96  * @dev https://github.com/ethereum/EIPs/issues/20
97  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
98  */
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
112     require(_value > 0 && _value <= balances[_from]);
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
144   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 }
148 
149 /**
150  * @title Ownable
151  * @dev The Ownable contract has an owner address, and provides basic authorization control
152  * functions, this simplifies the implementation of "user permissions".
153  */
154 contract Ownable {
155   address public owner;
156 
157 
158   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
159 
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() {
166     owner = msg.sender;
167   }
168 
169 
170   /**
171    * @dev Throws if called by any account other than the owner.
172    */
173   modifier onlyOwner() {
174     require(msg.sender == owner);
175     _;
176   }
177 
178 
179   /**
180    * @dev Allows the current owner to transfer control of the contract to a newOwner.
181    * @param newOwner The address to transfer ownership to.
182    */
183   function transferOwnership(address newOwner) onlyOwner public {
184     require(newOwner != address(0));
185     OwnershipTransferred(owner, newOwner);
186     owner = newOwner;
187   }
188 
189 }
190 
191 /**
192  * @title Pausable
193  * @dev Base contract which allows children to implement an emergency stop mechanism.
194  */
195 contract Pausable is Ownable {
196   event Pause();
197   event Unpause();
198 
199   bool public paused = false;
200 
201 
202   /**
203    * @dev Modifier to make a function callable only when the contract is not paused.
204    */
205   modifier whenNotPaused() {
206     require(!paused);
207     _;
208   }
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is paused.
212    */
213   modifier whenPaused() {
214     require(paused);
215     _;
216   }
217 
218   /**
219    * @dev called by the owner to pause, triggers stopped state
220    */
221   function pause() onlyOwner whenNotPaused public {
222     paused = true;
223     Pause();
224   }
225 
226   /**
227    * @dev called by the owner to unpause, returns to normal state
228    */
229   function unpause() onlyOwner whenPaused public {
230     paused = false;
231     Unpause();
232   }
233 }
234 
235 /**
236  * @title Pausable token
237  *
238  * @dev StandardToken modified with pausable transfers.
239  **/
240 
241 contract PausableToken is StandardToken, Pausable {
242 
243   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
244     return super.transfer(_to, _value);
245   }
246 
247   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
248     return super.transferFrom(_from, _to, _value);
249   }
250 
251   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
252     return super.approve(_spender, _value);
253   }
254   
255   function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
256     uint cnt = _receivers.length;
257     uint256 amount = uint256(cnt) * _value;
258     require(cnt > 0 && cnt <= 20);
259     require(_value > 0 && balances[msg.sender] >= amount);
260 
261     balances[msg.sender] = balances[msg.sender].sub(amount);
262     for (uint i = 0; i < cnt; i++) {
263         balances[_receivers[i]] = balances[_receivers[i]].add(_value);
264         Transfer(msg.sender, _receivers[i], _value);
265     }
266     return true;
267   }
268 }
269 
270 /**
271  * @title Bec Token
272  *
273  * @dev Implementation of Bec Token based on the basic standard token.
274  */
275 contract BecToken is PausableToken {
276     /**
277     * Public variables of the token
278     * The following variables are OPTIONAL vanities. One does not have to include them.
279     * They allow one to customise the token contract & in no way influences the core functionality.
280     * Some wallets/interfaces might not even bother to look at this information.
281     */
282     string public name = "BeautyChain";
283     string public symbol = "BEC";
284     string public version = '1.0.0';
285     uint8 public decimals = 18;
286 
287     /**
288      * @dev Function to check the amount of tokens that an owner allowed to a spender.
289      */
290     function BecToken() {
291       totalSupply = 7000000000 * (10**(uint256(decimals)));
292       balances[msg.sender] = totalSupply;    // Give the creator all initial tokens
293     }
294 
295     function () {
296         //if ether is sent to this address, send it back.
297         revert();
298     }
299 }