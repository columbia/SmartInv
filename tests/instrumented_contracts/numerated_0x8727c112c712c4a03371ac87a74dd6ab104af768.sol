1 pragma solidity ^0.4.13;
2 
3 
4 
5 
6 
7 
8 /**
9  * Math operations with safety checks
10  */
11 library SafeMath {
12   function mul(uint a, uint b) internal returns (uint) {
13     uint c = a * b;
14     assert(a == 0 || c / a == b);
15     return c;
16   }
17 
18   function div(uint a, uint b) internal returns (uint) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 
36   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
37     return a >= b ? a : b;
38   }
39 
40   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
41     return a < b ? a : b;
42   }
43 
44   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
45     return a >= b ? a : b;
46   }
47 
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51 
52 }
53 
54 
55 
56 
57 /**
58  * @title ERC20Basic
59  * @dev Simpler version of ERC20 interface
60  * @dev see https://github.com/ethereum/EIPs/issues/20
61  */
62 contract ERC20Basic {
63   uint public totalSupply;
64   function balanceOf(address who) constant returns (uint);
65   function transfer(address to, uint value);
66   event Transfer(address indexed from, address indexed to, uint value);
67 }
68 
69 
70 /**
71  * @title Basic token
72  * @dev Basic version of StandardToken, with no allowances. 
73  */
74 contract BasicToken is ERC20Basic {
75   using SafeMath for uint;
76 
77   mapping(address => uint) balances;
78 
79   /**
80    * @dev Fix for the ERC20 short address attack.
81    */
82   modifier onlyPayloadSize(uint size) {
83      require(msg.data.length >= size + 4);
84      _;
85   }
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of. 
101   * @return An uint representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) constant returns (uint balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint);
117   function transferFrom(address from, address to, uint value);
118   function approve(address spender, uint value);
119   event Approval(address indexed owner, address indexed spender, uint value);
120 }
121 
122 
123 /**
124  * @title Standard ERC20 token
125  *
126  * @dev Implemantation of the basic standart token.
127  * @dev https://github.com/ethereum/EIPs/issues/20
128  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
129  */
130 contract StandardToken is BasicToken, ERC20 {
131 
132   mapping (address => mapping (address => uint)) allowed;
133 
134 
135   /**
136    * @dev Transfer tokens from one address to another
137    * @param _from address The address which you want to send tokens from
138    * @param _to address The address which you want to transfer to
139    * @param _value uint the amout of tokens to be transfered
140    */
141   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
142     var _allowance = allowed[_from][msg.sender];
143 
144     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
145     // if (_value > _allowance) throw;
146 
147     balances[_to] = balances[_to].add(_value);
148     balances[_from] = balances[_from].sub(_value);
149     allowed[_from][msg.sender] = _allowance.sub(_value);
150     Transfer(_from, _to, _value);
151   }
152 
153   /**
154    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
155    * @param _spender The address which will spend the funds.
156    * @param _value The amount of tokens to be spent.
157    */
158   function approve(address _spender, uint _value) {
159 
160     // To change the approve amount you first have to reduce the addresses`
161     //  allowance to zero by calling `approve(_spender, 0)` if it is not
162     //  already 0 to mitigate the race condition described here:
163     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
165 
166     allowed[msg.sender][_spender] = _value;
167     Approval(msg.sender, _spender, _value);
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens than an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint specifing the amount of tokens still avaible for the spender.
175    */
176   function allowance(address _owner, address _spender) constant returns (uint remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180 }
181 
182 
183 /**
184  * @title Ownable
185  * @dev The Ownable contract has an owner address, and provides basic authorization control 
186  * functions, this simplifies the implementation of "user permissions". 
187  */
188 contract Ownable {
189   address public owner;
190 
191 
192   /** 
193    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
194    * account.
195    */
196   function Ownable() {
197     owner = msg.sender;
198   }
199 
200 
201   /**
202    * @dev Throws if called by any account other than the owner. 
203    */
204   modifier onlyOwner() {
205     if (msg.sender != owner) {
206       throw;
207     }
208     _;
209   }
210 
211 
212   /**
213    * @dev Allows the current owner to transfer control of the contract to a newOwner.
214    * @param newOwner The address to transfer ownership to. 
215    */
216   function transferOwnership(address newOwner) onlyOwner {
217     if (newOwner != address(0)) {
218       owner = newOwner;
219     }
220   }
221 }
222 
223 
224 /**
225  * @title Pausable
226  * @dev Base contract which allows children to implement an emergency stop mechanism.
227  */
228 contract Pausable is Ownable {
229   event Pause();
230   event Unpause();
231 
232   bool public paused = false;
233 
234 
235   /**
236    * @dev modifier to allow actions only when the contract IS paused
237    */
238   modifier whenNotPaused() {
239     require (!paused) ;
240     _;
241   }
242 
243   /**
244    * @dev modifier to allow actions only when the contract IS NOT paused
245    */
246   modifier whenPaused {
247     require (paused);
248     _;
249   }
250 
251   /**
252    * @dev called by the owner to pause, triggers stopped state
253    */
254   function pause() onlyOwner whenNotPaused returns (bool) {
255     paused = true;
256     Pause();
257     return true;
258   }
259 
260   /**
261    * @dev called by the owner to unpause, returns to normal state
262    */
263   function unpause() onlyOwner whenPaused returns (bool) {
264     paused = false;
265     Unpause();
266     return true;
267   }
268 }
269 
270 
271 /**
272  * Jetcoin Standard ERC20 token
273  *
274  * https://github.com/ethereum/EIPs/issues/20
275  */
276 contract JetCoin is StandardToken, Pausable {
277 
278   string    public name = "Jetcoin";
279   string    public symbol = "JET";
280   uint8     public decimals = 18;
281   string    public version  = "2.0";
282   address   public replacesOldContract = 0xc1E6C6C681B286Fb503B36a9dD6c1dbFF85E73CF;
283 
284   function transfer(address _to, uint _value) whenNotPaused {
285     require(_to != address(this));
286     super.transfer(_to,_value);
287   }
288 
289   function transferFrom(address _from, address _to, uint _value) whenNotPaused {
290     require(_to != address(this));
291     super.transferFrom(_from,_to,_value);
292   }
293 
294   function approve(address _spender, uint _value) whenNotPaused {
295     return super.approve(_spender,_value);
296   }
297 
298   function JetCoin() {
299     totalSupply = 80000000 ether;
300     balances[0xe955C7616dc449Fd0CBEeCa277cC078F9510BC04] = totalSupply;
301   }
302 
303 }