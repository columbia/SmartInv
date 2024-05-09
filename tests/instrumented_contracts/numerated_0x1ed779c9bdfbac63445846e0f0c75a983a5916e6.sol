1 pragma solidity ^0.4.16;
2 
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) constant returns (uint256);
13   function transfer(address to, uint256 value) returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  * @dev see https://github.com
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) returns (bool);
24   function approve(address spender, uint256 value) returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33     
34   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal constant returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal constant returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57   
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances. 
63  */
64 contract BasicToken is ERC20Basic {
65     
66   using SafeMath for uint256;
67 
68   mapping(address => uint256) balances;
69 
70 
71   modifier onlyPayloadSize(uint size) {
72     require(msg.data.length >= size + 4);
73     _;
74   }
75 
76   /**
77   * @dev transfer token for a specified address
78   * @param _to The address to transfer to.
79   * @param _value The amount to be transferred.
80   */
81 
82   function transfer(address _to, uint256 _value) onlyPayloadSize(32*2) returns (bool) {
83     require(_to != address(0));
84     require(_value <= balances[msg.sender]);
85     balances[msg.sender] = balances[msg.sender].sub(_value);
86     balances[_to] = balances[_to].add(_value);
87     Transfer(msg.sender, _to, _value);
88     return true;
89   }
90 
91   /**
92   * @dev Gets the balance of the specified address.
93   * @param _owner The address to query the the balance of. 
94   * @return An uint256 representing the amount owned by the passed address.
95   */
96   function balanceOf(address _owner) constant returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * @dev https://github.com/ethereum/EIPs/issues/20
107  * @dev Based on code by FirstBlood: https://github.com
108  */
109 contract StandardToken is ERC20, BasicToken {
110 
111   mapping (address => mapping (address => uint256)) allowed;
112 
113   /**
114    * @dev Transfer tokens from one address to another
115    * @param _from address The address which you want to send tokens from
116    * @param _to address The address which you want to transfer to
117    * @param _value uint256 the amout of tokens to be transfered
118    */
119   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
120     var _allowance = allowed[_from][msg.sender];
121 
122     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
123     require (_value <= _allowance);
124     require(_to != address(0));
125     require(_value <= balances[_from]);
126 
127     balances[_to] = balances[_to].add(_value);
128     balances[_from] = balances[_from].sub(_value);
129     allowed[_from][msg.sender] = _allowance.sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    * @param _spender The address which will spend the funds.
137    * @param _value The amount of tokens to be spent.
138    */
139   function approve(address _spender, uint256 _value) returns (bool) {
140 
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/
145     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
146 
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Function to check the amount of tokens that an owner allowed to a spender.
154    * @param _owner address The address which owns the funds.
155    * @param _spender address The address which will spend the funds.
156    * @return A uint256 specifing the amount of tokens still available for the spender.
157    */
158   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159     return allowed[_owner][_spender];
160   }
161 
162 }
163 
164 /**
165  * @title Ownable
166  * @dev The Ownable contract has an owner address, and provides basic authorization control
167  * functions, this simplifies the implementation of "user permissions".
168  */
169 contract Ownable {
170     
171   address public owner;
172   address public candidate;
173 
174 
175 
176   /**
177    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
178    * account.
179    */
180   function Ownable() {
181     owner = msg.sender;
182   }
183 
184   /**
185    * @dev Throws if called by any account other than the owner.
186    */
187   modifier onlyOwner() {
188     require(msg.sender == owner);
189     _;
190   }
191   
192   function changeOwner(address _owner) onlyOwner {
193     candidate = _owner;      
194   }
195   
196   function confirmOwner() public {
197     require(candidate == msg.sender); 
198     owner = candidate;   
199   }
200   
201 
202   /**
203    * @dev Allows the current owner to transfer control of the contract to a newOwner.
204    * @param newOwner The address to transfer ownership to.
205    */
206   /**
207    *function transferOwnership(address newOwner) onlyOwner {
208    * require(newOwner != address(0));      
209    * owner = newOwner;
210    *}
211    */
212 }
213 
214 /**
215  * @title Mintable token
216  * @dev Simple ERC20 Token example, with mintable token creation
217  * @dev Issue: * https://github.com
218  * Based on code by TokenMarketNet: https://github.com
219  */
220 
221 contract MintableToken is StandardToken, Ownable {
222     
223   event Mint(address indexed to, uint256 amount);
224   
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228   uint256 public lastTotalSupply = 0;
229 
230   address public saleAgent = 0;
231 
232 
233 
234   modifier canMint() {
235     require(!mintingFinished);
236     _;
237   }
238 
239 
240   function setSaleAgent(address newSaleAgent) public {
241     require(msg.sender == saleAgent || msg.sender == owner);
242     saleAgent = newSaleAgent;
243   }
244 
245   /**
246    * @dev Function to mint tokens
247    * @param _to The address that will recieve the minted tokens.
248    * @param _amount The amount of tokens to mint.
249    * @return A boolean that indicates if the operation was successful.
250    */
251   function mint(address _to, uint256 _amount) canMint returns (bool) {
252     require(msg.sender == saleAgent); 
253     totalSupply = totalSupply.add(_amount);
254     balances[_to] = balances[_to].add(_amount);
255     Mint(_to, _amount);
256     Transfer(address(0), _to, _amount);
257     return true;
258   }
259 
260   /**
261    * @dev Function to stop minting new tokens.
262    * @return True if the operation was successful.
263    */
264 
265   function finishMinting() returns (bool) {
266     require((msg.sender == saleAgent) || (msg.sender == owner)); 
267     lastTotalSupply = totalSupply;
268     mintingFinished = true;
269     MintFinished();
270     return mintingFinished;
271   }
272   function startMinting()  returns (bool) {
273     require((msg.sender == saleAgent) || (msg.sender == owner)); 
274     mintingFinished = false;
275     return mintingFinished;
276   }
277   
278 }
279 
280 contract BetOnCryptToken is MintableToken {
281     
282     string public constant name = "BetOnCrypt_Token";
283     
284     string public constant symbol = "BEC";
285     
286     uint32 public constant decimals = 18;
287     
288 }