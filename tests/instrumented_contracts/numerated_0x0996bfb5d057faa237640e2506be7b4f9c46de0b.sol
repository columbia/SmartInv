1 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
2 
3 pragma solidity ^0.4.11;
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) constant returns (uint256);
14   function transfer(address to, uint256 value) returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 // File: zeppelin-solidity/contracts/math/SafeMath.sol
19 
20 pragma solidity ^0.4.11;
21 
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
29     uint256 c = a * b;
30     assert(a == 0 || c / a == b);
31     return c;
32   }
33 
34   function div(uint256 a, uint256 b) internal constant returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   function add(uint256 a, uint256 b) internal constant returns (uint256) {
47     uint256 c = a + b;
48     assert(c >= a);
49     return c;
50   }
51 }
52 
53 // File: zeppelin-solidity/contracts/token/BasicToken.sol
54 
55 pragma solidity ^0.4.11;
56 
57 
58 
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances. 
63  */
64 contract BasicToken is ERC20Basic {
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) returns (bool) {
75     balances[msg.sender] = balances[msg.sender].sub(_value);
76     balances[_to] = balances[_to].add(_value);
77     Transfer(msg.sender, _to, _value);
78     return true;
79   }
80 
81   /**
82   * @dev Gets the balance of the specified address.
83   * @param _owner The address to query the the balance of. 
84   * @return An uint256 representing the amount owned by the passed address.
85   */
86   function balanceOf(address _owner) constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
91 
92 // File: zeppelin-solidity/contracts/token/ERC20.sol
93 
94 pragma solidity ^0.4.11;
95 
96 
97 
98 /**
99  * @title ERC20 interface
100  * @dev see https://github.com/ethereum/EIPs/issues/20
101  */
102 contract ERC20 is ERC20Basic {
103   function allowance(address owner, address spender) constant returns (uint256);
104   function transferFrom(address from, address to, uint256 value) returns (bool);
105   function approve(address spender, uint256 value) returns (bool);
106   event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 // File: zeppelin-solidity/contracts/token/StandardToken.sol
110 
111 pragma solidity ^0.4.11;
112 
113 
114 
115 
116 /**
117  * @title Standard ERC20 token
118  *
119  * @dev Implementation of the basic standard token.
120  * @dev https://github.com/ethereum/EIPs/issues/20
121  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
122  */
123 contract StandardToken is ERC20, BasicToken {
124 
125   mapping (address => mapping (address => uint256)) allowed;
126 
127 
128   /**
129    * @dev Transfer tokens from one address to another
130    * @param _from address The address which you want to send tokens from
131    * @param _to address The address which you want to transfer to
132    * @param _value uint256 the amout of tokens to be transfered
133    */
134   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
135     var _allowance = allowed[_from][msg.sender];
136 
137     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
138     // require (_value <= _allowance);
139 
140     balances[_to] = balances[_to].add(_value);
141     balances[_from] = balances[_from].sub(_value);
142     allowed[_from][msg.sender] = _allowance.sub(_value);
143     Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
149    * @param _spender The address which will spend the funds.
150    * @param _value The amount of tokens to be spent.
151    */
152   function approve(address _spender, uint256 _value) returns (bool) {
153 
154     // To change the approve amount you first have to reduce the addresses`
155     //  allowance to zero by calling `approve(_spender, 0)` if it is not
156     //  already 0 to mitigate the race condition described here:
157     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
159 
160     allowed[msg.sender][_spender] = _value;
161     Approval(msg.sender, _spender, _value);
162     return true;
163   }
164 
165   /**
166    * @dev Function to check the amount of tokens that an owner allowed to a spender.
167    * @param _owner address The address which owns the funds.
168    * @param _spender address The address which will spend the funds.
169    * @return A uint256 specifing the amount of tokens still avaible for the spender.
170    */
171   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
172     return allowed[_owner][_spender];
173   }
174 
175 }
176 
177 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
178 
179 pragma solidity ^0.4.11;
180 
181 
182 /**
183  * @title Ownable
184  * @dev The Ownable contract has an owner address, and provides basic authorization control
185  * functions, this simplifies the implementation of "user permissions".
186  */
187 contract Ownable {
188   address public owner;
189 
190 
191   /**
192    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
193    * account.
194    */
195   function Ownable() {
196     owner = msg.sender;
197   }
198 
199 
200   /**
201    * @dev Throws if called by any account other than the owner.
202    */
203   modifier onlyOwner() {
204     require(msg.sender == owner);
205     _;
206   }
207 
208 
209   /**
210    * @dev Allows the current owner to transfer control of the contract to a newOwner.
211    * @param newOwner The address to transfer ownership to.
212    */
213   function transferOwnership(address newOwner) onlyOwner {
214     if (newOwner != address(0)) {
215       owner = newOwner;
216     }
217   }
218 
219 }
220 
221 // File: zeppelin-solidity/contracts/token/MintableToken.sol
222 
223 pragma solidity ^0.4.11;
224 
225 
226 
227 
228 
229 /**
230  * @title Mintable token
231  * @dev Simple ERC20 Token example, with mintable token creation
232  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
233  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
234  */
235 
236 contract MintableToken is StandardToken, Ownable {
237   event Mint(address indexed to, uint256 amount);
238   event MintFinished();
239 
240   bool public mintingFinished = false;
241 
242 
243   modifier canMint() {
244     require(!mintingFinished);
245     _;
246   }
247 
248   /**
249    * @dev Function to mint tokens
250    * @param _to The address that will recieve the minted tokens.
251    * @param _amount The amount of tokens to mint.
252    * @return A boolean that indicates if the operation was successful.
253    */
254   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
255     totalSupply = totalSupply.add(_amount);
256     balances[_to] = balances[_to].add(_amount);
257     Mint(_to, _amount);
258     return true;
259   }
260 
261   /**
262    * @dev Function to stop minting new tokens.
263    * @return True if the operation was successful.
264    */
265   function finishMinting() onlyOwner returns (bool) {
266     mintingFinished = true;
267     MintFinished();
268     return true;
269   }
270 }
271 
272 // File: contracts/RenderToken.sol
273 
274 pragma solidity ^0.4.14;
275 
276 
277 /**
278  * @title RenderToken
279  * @dev ERC20 mintable token
280  * The token will be minted by the crowdsale contract only
281  */
282 contract RenderToken is MintableToken {
283 
284   string public constant name = "Render Token";
285   string public constant symbol = "RNDR";
286   uint8 public constant decimals = 18;
287 
288 }