1 pragma solidity ^0.4.23;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint a, uint b) internal pure returns (uint) {
8     uint c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint a, uint b) internal pure returns (uint) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint c = a / b;
16     assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint a, uint b) internal pure returns (uint) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint a, uint b) internal pure returns (uint) {
26     uint c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 
50 /**
51  * @title ERC20Basic
52  * @dev Simpler version of ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20Basic {
56   uint public totalSupply;
57   function balanceOf(address who) constant public returns (uint);
58   function transfer(address to, uint value) public;
59   event Transfer(address indexed from, address indexed to, uint value);
60 }
61 
62 
63 /**
64  * @title Basic token
65  * @dev Basic version of StandardToken, with no allowances.
66  */
67 contract BasicToken is ERC20Basic {
68   using SafeMath for uint;
69 
70   mapping(address => uint) balances;
71 
72   /**
73    * @dev Fix for the ERC20 short address attack.
74    */
75   modifier onlyPayloadSize(uint size) {
76      assert(msg.data.length >= size + 4);
77      _;
78   }
79 
80   /**
81   * @dev transfer token for a specified address
82   * @param _to The address to transfer to.
83   * @param _value The amount to be transferred.
84   */
85   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32)  public {
86     balances[msg.sender] = balances[msg.sender].sub(_value);
87     balances[_to] = balances[_to].add(_value);
88     emit Transfer(msg.sender, _to, _value);
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of.
94   * @return An uint representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) constant public returns (uint balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 
103 /**
104  * @title ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/20
106  */
107 contract ERC20 is ERC20Basic {
108   function allowance(address owner, address spender) constant  public returns (uint);
109   function transferFrom(address from, address to, uint value)  public;
110   function approve(address spender, uint value)  public;
111   event Approval(address indexed owner, address indexed spender, uint value);
112 }
113 
114 
115 /**
116  * @title Standard ERC20 token
117  *
118  * @dev Implemantation of the basic standart token.
119  * @dev https://github.com/ethereum/EIPs/issues/20
120  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
121  */
122 contract StandardToken is BasicToken, ERC20 {
123 
124   mapping (address => mapping (address => uint)) allowed;
125 
126 
127   /**
128    * @dev Transfer tokens from one address to another
129    * @param _from address The address which you want to send tokens from
130    * @param _to address The address which you want to transfer to
131    * @param _value uint the amout of tokens to be transfered
132    */
133   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32)  public {
134     uint _allowance;
135     _allowance = allowed[_from][msg.sender];
136 
137     require(_allowance >= _value);
138 
139     balances[_from] = balances[_from].sub(_value);
140     balances[_to] = balances[_to].add(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     emit Transfer(_from, _to, _value);
143   }
144 
145   /**
146    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
147    * @param _spender The address which will spend the funds.
148    * @param _value The amount of tokens to be spent.
149    */
150   function approve(address _spender, uint _value)  public {
151 
152     // To change the approve amount you first have to reduce the addresses`
153     //  allowance to zero by calling `approve(_spender, 0)` if it is not
154     //  already 0 to mitigate the race condition described here:
155     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
157 
158     allowed[msg.sender][_spender] = _value;
159     emit Approval(msg.sender, _spender, _value);
160   }
161 
162   /**
163    * @dev Function to check the amount of tokens than an owner allowed to a spender.
164    * @param _owner address The address which owns the funds.
165    * @param _spender address The address which will spend the funds.
166    * @return A uint specifing the amount of tokens still avaible for the spender.
167    */
168   function allowance(address _owner, address _spender) constant public returns (uint remaining) {
169     return allowed[_owner][_spender];
170   }
171 
172 }
173 
174 
175 /**
176  * @title Ownable
177  * @dev The Ownable contract has an owner address, and provides basic authorization control
178  * functions, this simplifies the implementation of "user permissions".
179  */
180 contract Ownable {
181   address public owner;
182 
183 
184   /**
185    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
186    * account.
187    */
188   constructor()  public {
189     owner = msg.sender;
190   }
191 
192 
193   /**
194    * @dev Throws if called by any account other than the owner.
195    */
196   modifier onlyOwner() {
197     require(msg.sender == owner);
198     _;
199   }
200 
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   function transferOwnership(address newOwner) onlyOwner  public {
207     if (newOwner != address(0)) {
208       owner = newOwner;
209     }
210   }
211 
212 }
213 
214 /**
215  * @title Pausable
216  * @dev Base contract which allows children to implement an emergency stop mechanism.
217  */
218 contract Pausable is Ownable {
219   event Pause();
220   event Unpause();
221 
222   bool public paused = false;
223 
224 
225   /**
226    * @dev modifier to allow actions only when the contract IS paused
227    */
228   modifier whenNotPaused() {
229     // if (paused) throw;
230     require(!paused);
231     _;
232   }
233 
234   /**
235    * @dev modifier to allow actions only when the contract IS NOT paused
236    */
237   modifier whenPaused {
238     require(paused);
239     _;
240   }
241 
242   /**
243    * @dev called by the owner to pause, triggers stopped state
244    */
245   function pause() onlyOwner whenNotPaused  public returns (bool) {
246     paused = true;
247     emit Pause();
248     return true;
249   }
250 
251   /**
252    * @dev called by the owner to unpause, returns to normal state
253    */
254   function unpause() onlyOwner whenPaused  public returns (bool) {
255     paused = false;
256     emit Unpause();
257     return true;
258   }
259 }
260 
261 
262 /**
263  * Pausable token
264  *
265  * Simple ERC20 Token example, with pausable token creation
266  **/
267 
268 contract PausableToken is StandardToken, Pausable {
269 
270   function transfer(address _to, uint _value) whenNotPaused  public {
271     super.transfer(_to, _value);
272   }
273 
274   function transferFrom(address _from, address _to, uint _value) whenNotPaused  public {
275     super.transferFrom(_from, _to, _value);
276   }
277 }
278 
279 /**
280  * @title BitgeneToken
281  * @dev Bitgene Token contract
282  */
283 contract BitgeneToken is PausableToken {
284   using SafeMath for uint256;
285 
286   string public name = "Bitgene Token";
287   string public symbol = "BGT";
288   uint public decimals = 18;
289   uint256 public totalSupply = 10 ** 10 * 10**uint(decimals);
290   
291   constructor() public {
292     balances[owner] = totalSupply;        
293     emit Transfer(address(0), msg.sender, totalSupply);
294   }
295   
296 	function batchTransfer(address[] _receivers, uint256 _value) public whenNotPaused returns (bool) {
297 	    uint cnt = _receivers.length;
298 	    uint256 amount = uint256(cnt).mul(_value);
299 	    require(cnt > 0 && cnt <= 200);
300 	    require(_value > 0 && balances[msg.sender] >= amount);
301 	
302 	    balances[msg.sender] = balances[msg.sender].sub(amount);
303 	    for (uint i = 0; i < cnt; i++) {
304 	        balances[_receivers[i]] = balances[_receivers[i]].add(_value);
305 	        emit Transfer(msg.sender, _receivers[i], _value);
306 	    }
307 	    return true;
308 	}
309 
310   // If the user transfers ETH to contract, it will revert
311   function () public payable{ revert(); }
312 }