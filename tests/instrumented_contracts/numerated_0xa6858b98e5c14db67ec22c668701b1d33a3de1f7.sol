1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control 
6  * functions, this simplifies the implementation of "user permissions". 
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   /** 
13    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
14    * account.
15    */
16   function Ownable() {
17     owner = msg.sender;
18   }
19 
20 
21   /**
22    * @dev Throws if called by any account other than the owner. 
23    */
24   modifier onlyOwner() {
25     if (msg.sender != owner) {
26       throw;
27     }
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
44 /**
45  * @title Authorizable
46  * @dev Allows to authorize access to certain function calls
47  * 
48  * ABI
49  * [{"constant":true,"inputs":[{"name":"authorizerIndex","type":"uint256"}],"name":"getAuthorizer","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"},{"constant":false,"inputs":[{"name":"_addr","type":"address"}],"name":"addAuthorized","outputs":[],"payable":false,"type":"function"},{"constant":true,"inputs":[{"name":"_addr","type":"address"}],"name":"isAuthorized","outputs":[{"name":"","type":"bool"}],"payable":false,"type":"function"},{"inputs":[],"payable":false,"type":"constructor"}]
50  */
51 contract Authorizable {
52 
53   address[] authorizers;
54   mapping(address => uint) authorizerIndex;
55 
56   /**
57    * @dev Throws if called by any account tat is not authorized. 
58    */
59   modifier onlyAuthorized {
60     require(isAuthorized(msg.sender));
61     _;
62   }
63 
64   /**
65    * @dev Contructor that authorizes the msg.sender. 
66    */
67   function Authorizable() {
68     authorizers.length = 2;
69     authorizers[1] = msg.sender;
70     authorizerIndex[msg.sender] = 1;
71   }
72 
73   /**
74    * @dev Function to get a specific authorizer
75    * @param authorizerIndex index of the authorizer to be retrieved.
76    * @return The address of the authorizer.
77    */
78   function getAuthorizer(uint authorizerIndex) external constant returns(address) {
79     return address(authorizers[authorizerIndex + 1]);
80   }
81 
82   /**
83    * @dev Function to check if an address is authorized
84    * @param _addr the address to check if it is authorized.
85    * @return boolean flag if address is authorized.
86    */
87   function isAuthorized(address _addr) constant returns(bool) {
88     return authorizerIndex[_addr] > 0;
89   }
90 
91   /**
92    * @dev Function to add a new authorizer
93    * @param _addr the address to add as a new authorizer.
94    */
95   function addAuthorized(address _addr) external onlyAuthorized {
96     authorizerIndex[_addr] = authorizers.length;
97     authorizers.length++;
98     authorizers[authorizers.length - 1] = _addr;
99   }
100 
101 }
102 
103 
104 /**
105  * Math operations with safety checks
106  */
107 library SafeMath {
108   function mul(uint a, uint b) internal returns (uint) {
109     uint c = a * b;
110     assert(a == 0 || c / a == b);
111     return c;
112   }
113 
114   function div(uint a, uint b) internal returns (uint) {
115     // assert(b > 0); // Solidity automatically throws when dividing by 0
116     uint c = a / b;
117     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118     return c;
119   }
120 
121   function sub(uint a, uint b) internal returns (uint) {
122     assert(b <= a);
123     return a - b;
124   }
125 
126   function add(uint a, uint b) internal returns (uint) {
127     uint c = a + b;
128     assert(c >= a);
129     return c;
130   }
131 
132   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
133     return a >= b ? a : b;
134   }
135 
136   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
137     return a < b ? a : b;
138   }
139 
140   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
141     return a >= b ? a : b;
142   }
143 
144   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
145     return a < b ? a : b;
146   }
147 
148   function assert(bool assertion) internal {
149     if (!assertion) {
150       throw;
151     }
152   }
153 }
154 
155 /**
156  * @title ERC20Basic
157  * @dev Simpler version of ERC20 interface
158  * @dev see https://github.com/ethereum/EIPs/issues/20
159  */
160 contract ERC20Basic {
161   uint public totalSupply;
162   function balanceOf(address who) constant returns (uint);
163   function transfer(address to, uint value);
164   event Transfer(address indexed from, address indexed to, uint value);
165 }
166 
167 
168 
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) constant returns (uint);
176   function transferFrom(address from, address to, uint value);
177   function approve(address spender, uint value);
178   event Approval(address indexed owner, address indexed spender, uint value);
179 }
180 
181 
182 
183 
184 /**
185  * @title Basic token
186  * @dev Basic version of StandardToken, with no allowances. 
187  */
188 contract BasicToken is ERC20Basic {
189   using SafeMath for uint;
190 
191   mapping(address => uint) balances;
192 
193   /**
194    * @dev Fix for the ERC20 short address attack.
195    */
196   modifier onlyPayloadSize(uint size) {
197      if(msg.data.length < size + 4) {
198        throw;
199      }
200      _;
201   }
202 
203   /**
204   * @dev transfer token for a specified address
205   * @param _to The address to transfer to.
206   * @param _value The amount to be transferred.
207   */
208   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
209     balances[msg.sender] = balances[msg.sender].sub(_value);
210     balances[_to] = balances[_to].add(_value);
211     Transfer(msg.sender, _to, _value);
212   }
213 
214   /**
215   * @dev Gets the balance of the specified address.
216   * @param _owner The address to query the the balance of. 
217   * @return An uint representing the amount owned by the passed address.
218   */
219   function balanceOf(address _owner) constant returns (uint balance) {
220     return balances[_owner];
221   }
222 
223 }
224 
225 /**
226  * @title Standard ERC20 token
227  *
228  * @dev Implemantation of the basic standart token.
229  * @dev https://github.com/ethereum/EIPs/issues/20
230  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
231  */
232 contract StandardToken is BasicToken, ERC20 {
233 
234   mapping (address => mapping (address => uint)) allowed;
235 
236 
237   /**
238    * @dev Transfer tokens from one address to another
239    * @param _from address The address which you want to send tokens from
240    * @param _to address The address which you want to transfer to
241    * @param _value uint the amout of tokens to be transfered
242    */
243   function transferFrom(address _from, address _to, uint _value) onlyPayloadSize(3 * 32) {
244     var _allowance = allowed[_from][msg.sender];
245 
246     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
247     // if (_value > _allowance) throw;
248 
249     balances[_to] = balances[_to].add(_value);
250     balances[_from] = balances[_from].sub(_value);
251     allowed[_from][msg.sender] = _allowance.sub(_value);
252     Transfer(_from, _to, _value);
253   }
254 
255   /**
256    * @dev Aprove the passed address to spend the specified amount of tokens on beahlf of msg.sender.
257    * @param _spender The address which will spend the funds.
258    * @param _value The amount of tokens to be spent.
259    */
260   function approve(address _spender, uint _value) {
261 
262     // To change the approve amount you first have to reduce the addresses`
263     //  allowance to zero by calling `approve(_spender, 0)` if it is not
264     //  already 0 to mitigate the race condition described here:
265     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
266     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
267 
268     allowed[msg.sender][_spender] = _value;
269     Approval(msg.sender, _spender, _value);
270   }
271 
272   /**
273    * @dev Function to check the amount of tokens than an owner allowed to a spender.
274    * @param _owner address The address which owns the funds.
275    * @param _spender address The address which will spend the funds.
276    * @return A uint specifing the amount of tokens still avaible for the spender.
277    */
278   function allowance(address _owner, address _spender) constant returns (uint remaining) {
279     return allowed[_owner][_spender];
280   }
281 
282 }
283 
284 
285 /**
286  * @title Mintable token
287  * @dev Simple ERC20 Token example, with mintable token creation
288  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
289  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
290  */
291 
292 contract MintableToken is StandardToken, Ownable {
293   event Mint(address indexed to, uint value);
294   event MintFinished();
295 
296   bool public mintingFinished = false;
297   uint public totalSupply = 0;
298 
299 
300   modifier canMint() {
301     if(mintingFinished) throw;
302     _;
303   }
304 
305   /**
306    * @dev Function to mint tokens
307    * @param _to The address that will recieve the minted tokens.
308    * @param _amount The amount of tokens to mint.
309    * @return A boolean that indicates if the operation was successful.
310    */
311   function mint(address _to, uint _amount) onlyOwner canMint returns (bool) {
312     totalSupply = totalSupply.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     Mint(_to, _amount);
315     return true;
316   }
317 
318   /**
319    * @dev Function to stop minting new tokens.
320    * @return True if the operation was successful.
321    */
322   function finishMinting() onlyOwner returns (bool) {
323     mintingFinished = true;
324     MintFinished();
325     return true;
326   }
327 }
328 
329 
330 /**
331  * @title TmacToken
332  * @dev The main TMAC token contract
333  * 
334  */
335 contract TmacToken is MintableToken {
336 
337   string public name = "Time Asset Chain Token";
338   string public symbol = "TMAC";
339   uint public decimals = 18;
340 
341 }