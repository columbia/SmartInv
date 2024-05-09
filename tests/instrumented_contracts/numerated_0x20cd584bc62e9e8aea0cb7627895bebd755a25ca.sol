1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) constant returns (uint256);
11   function transfer(address to, uint256 value) returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
21     uint256 c = a * b;
22     assert(a == 0 || c / a == b);
23     return c;
24   }
25 
26   function div(uint256 a, uint256 b) internal constant returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
34     assert(b <= a);
35     return a - b;
36   }
37 
38   function add(uint256 a, uint256 b) internal constant returns (uint256) {
39     uint256 c = a + b;
40     assert(c >= a);
41     return c;
42   }
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
59   function transfer(address _to, uint256 _value) returns (bool) {
60     balances[msg.sender] = balances[msg.sender].sub(_value);
61     balances[_to] = balances[_to].add(_value);
62     Transfer(msg.sender, _to, _value);
63     return true;
64   }
65 
66   /**
67   * @dev Gets the balance of the specified address.
68   * @param _owner The address to query the the balance of. 
69   * @return An uint256 representing the amount owned by the passed address.
70   */
71   function balanceOf(address _owner) constant returns (uint256 balance) {
72     return balances[_owner];
73   }
74 
75 }
76 
77 /**
78  * @title ERC20 interface
79  * @dev see https://github.com/ethereum/EIPs/issues/20
80  */
81 contract ERC20 is ERC20Basic {
82   function allowance(address owner, address spender) constant returns (uint256);
83   function transferFrom(address from, address to, uint256 value) returns (bool);
84   function approve(address spender, uint256 value) returns (bool);
85   event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99 
100   /**
101    * @dev Transfer tokens from one address to another
102    * @param _from address The address which you want to send tokens from
103    * @param _to address The address which you want to transfer to
104    * @param _value uint256 the amout of tokens to be transfered
105    */
106   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
107     var _allowance = allowed[_from][msg.sender];
108 
109     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
110     // require (_value <= _allowance);
111 
112     balances[_to] = balances[_to].add(_value);
113     balances[_from] = balances[_from].sub(_value);
114     allowed[_from][msg.sender] = _allowance.sub(_value);
115     Transfer(_from, _to, _value);
116     return true;
117   }
118 
119   /**
120    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
121    * @param _spender The address which will spend the funds.
122    * @param _value The amount of tokens to be spent.
123    */
124   function approve(address _spender, uint256 _value) returns (bool) {
125 
126     // To change the approve amount you first have to reduce the addresses`
127     //  allowance to zero by calling `approve(_spender, 0)` if it is not
128     //  already 0 to mitigate the race condition described here:
129     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
130     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
131 
132     allowed[msg.sender][_spender] = _value;
133     Approval(msg.sender, _spender, _value);
134     return true;
135   }
136 
137   /**
138    * @dev Function to check the amount of tokens that an owner allowed to a spender.
139    * @param _owner address The address which owns the funds.
140    * @param _spender address The address which will spend the funds.
141    * @return A uint256 specifing the amount of tokens still avaible for the spender.
142    */
143   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144     return allowed[_owner][_spender];
145   }
146 
147 }
148 
149 /**
150  * @title Burnable
151  *
152  * @dev Standard ERC20 token
153  */
154 contract Burnable is StandardToken {
155   using SafeMath for uint;
156 
157   /* This notifies clients about the amount burnt */
158   event Burn(address indexed from, uint value);
159 
160   function burn(uint _value) returns (bool success) {
161     require(_value > 0 && balances[msg.sender] >= _value);
162     balances[msg.sender] = balances[msg.sender].sub(_value);
163     totalSupply = totalSupply.sub(_value);
164     Burn(msg.sender, _value);
165     return true;
166   }
167 
168   function burnFrom(address _from, uint _value) returns (bool success) {
169     require(_from != 0x0 && _value > 0 && balances[_from] >= _value);
170     require(_value <= allowed[_from][msg.sender]);
171     balances[_from] = balances[_from].sub(_value);
172     totalSupply = totalSupply.sub(_value);
173     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
174     Burn(_from, _value);
175     return true;
176   }
177 
178   function transfer(address _to, uint _value) returns (bool success) {
179     require(_to != 0x0); //use burn
180 
181     return super.transfer(_to, _value);
182   }
183 
184   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
185     require(_to != 0x0); //use burn
186 
187     return super.transferFrom(_from, _to, _value);
188   }
189 }
190 
191 /**
192  * @title Ownable
193  * @dev The Ownable contract has an owner address, and provides basic authorization control
194  * functions, this simplifies the implementation of "user permissions".
195  */
196 contract Ownable {
197   address public owner;
198 
199 
200   /**
201    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
202    * account.
203    */
204   function Ownable() {
205     owner = msg.sender;
206   }
207 
208 
209   /**
210    * @dev Throws if called by any account other than the owner.
211    */
212   modifier onlyOwner() {
213     require(msg.sender == owner);
214     _;
215   }
216 
217 
218   /**
219    * @dev Allows the current owner to transfer control of the contract to a newOwner.
220    * @param newOwner The address to transfer ownership to.
221    */
222   function transferOwnership(address newOwner) onlyOwner {
223     if (newOwner != address(0)) {
224       owner = newOwner;
225     }
226   }
227 
228 }
229 
230 /**
231  * @title QuantorToken
232  *
233  * @dev Burnable Ownable ERC20 token
234  */
235 contract QuantorToken is Burnable, Ownable {
236 
237   string public constant name = "Quant";
238   string public constant symbol = "QNT";
239   uint8 public constant decimals = 18;
240   uint public constant INITIAL_SUPPLY = 2000000000 * 1 ether;
241 
242   /* The finalizer contract that allows unlift the transfer limits on this token */
243   address public releaseAgent;
244 
245   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
246   bool public released = false;
247 
248   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
249   mapping (address => bool) public transferAgents;
250 
251   /**
252    * Limit token transfer until the crowdsale is over.
253    *
254    */
255   modifier canTransfer(address _sender) {
256     require(released || transferAgents[_sender]);
257     _;
258   }
259 
260   /** The function can be called only before or after the tokens have been released */
261   modifier inReleaseState(bool releaseState) {
262     require(releaseState == released);
263     _;
264   }
265 
266   /** The function can be called only by a whitelisted release agent. */
267   modifier onlyReleaseAgent() {
268     require(msg.sender == releaseAgent);
269     _;
270   }
271 
272 
273   /**
274    * @dev Constructor that gives msg.sender all of existing tokens.
275    */
276   function QuantorToken() {
277     totalSupply = INITIAL_SUPPLY;
278     balances[msg.sender] = INITIAL_SUPPLY;
279     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
280   }
281 
282 
283   /**
284    * Set the contract that can call release and make the token transferable.
285    *
286    * Design choice. Allow reset the release agent to fix fat finger mistakes.
287    */
288   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
289     require(addr != 0x0);
290 
291     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
292     releaseAgent = addr;
293   }
294 
295   function release() onlyReleaseAgent inReleaseState(false) public {
296     released = true;
297   }
298 
299   /**
300    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
301    */
302   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
303     require(addr != 0x0);
304     transferAgents[addr] = state;
305   }
306 
307   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
308     // Call Burnable.transfer()
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
313     // Call Burnable.transferForm()
314     return super.transferFrom(_from, _to, _value);
315   }
316 
317   function burn(uint _value) onlyOwner returns (bool success) {
318     return super.burn(_value);
319   }
320 
321   function burnFrom(address _from, uint _value) onlyOwner returns (bool success) {
322     return super.burnFrom(_from, _value);
323   }
324 }