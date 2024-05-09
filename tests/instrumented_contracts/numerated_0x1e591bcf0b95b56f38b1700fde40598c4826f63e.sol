1 pragma solidity ^0.4.16;
2 
3 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
4 // Set values before deploy
5 // ----------------------------
6 // ADDRESS_FOR_TOKENS
7 // ADDRESS_FOR_ETH
8 // RATE
9 // START_DATETIME
10 // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
11 
12 /**
13  * @title ERC20Basic
14  * @dev Simpler version of ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/179
16  */
17 contract ERC20Basic {
18   uint256 public totalSupply;
19   function balanceOf(address who) constant returns (uint256);
20   function transfer(address to, uint256 value) returns (bool);
21   event Transfer(address indexed from, address indexed to, uint256 value);
22 }
23 
24 /**
25  * @title ERC20 interface
26  * @dev see https://github.com/ethereum/EIPs/issues/20
27  */
28 contract ERC20 is ERC20Basic {
29   function allowance(address owner, address spender) constant returns (uint256);
30   function transferFrom(address from, address to, uint256 value) returns (bool);
31   function approve(address spender, uint256 value) returns (bool);
32   event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 /**
36  * @title SafeMath
37  * @dev Math operations with safety checks that throw on error
38  */
39 library SafeMath {
40     
41   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function div(uint256 a, uint256 b) internal constant returns (uint256) {
48     // assert(b > 0); // Solidity automatically throws when dividing by 0
49     uint256 c = a / b;
50     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
51     return c;
52   }
53 
54   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   function add(uint256 a, uint256 b) internal constant returns (uint256) {
60     uint256 c = a + b;
61     assert(c >= a);
62     return c;
63   }
64   
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances. 
70  */
71 contract BasicToken is ERC20Basic {
72     
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   /**
78   * @dev transfer token for a specified address
79   * @param _to The address to transfer to.
80   * @param _value The amount to be transferred.
81   */
82   function transfer(address _to, uint256 _value) returns (bool) {
83     balances[msg.sender] = balances[msg.sender].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     Transfer(msg.sender, _to, _value);
86     return true;
87   }
88 
89   /**
90   * @dev Gets the balance of the specified address.
91   * @param _owner The address to query the the balance of. 
92   * @return An uint256 representing the amount owned by the passed address.
93   */
94   function balanceOf(address _owner) constant returns (uint256 balance) {
95     return balances[_owner];
96   }
97 
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * @dev https://github.com/ethereum/EIPs/issues/20
105  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract StandardToken is ERC20, BasicToken {
108 
109   mapping (address => mapping (address => uint256)) allowed;
110 
111   /**
112    * @dev Transfer tokens from one address to another
113    * @param _from address The address which you want to send tokens from
114    * @param _to address The address which you want to transfer to
115    * @param _value uint256 the amout of tokens to be transfered
116    */
117   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
118     var _allowance = allowed[_from][msg.sender];
119 
120     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
121     // require (_value <= _allowance);
122 
123     balances[_to] = balances[_to].add(_value);
124     balances[_from] = balances[_from].sub(_value);
125     allowed[_from][msg.sender] = _allowance.sub(_value);
126     Transfer(_from, _to, _value);
127     return true;
128   }
129 
130   /**
131    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
132    * @param _spender The address which will spend the funds.
133    * @param _value The amount of tokens to be spent.
134    */
135   function approve(address _spender, uint256 _value) returns (bool) {
136 
137     // To change the approve amount you first have to reduce the addresses`
138     //  allowance to zero by calling `approve(_spender, 0)` if it is not
139     //  already 0 to mitigate the race condition described here:
140     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
142 
143     allowed[msg.sender][_spender] = _value;
144     Approval(msg.sender, _spender, _value);
145     return true;
146   }
147 
148   /**
149    * @dev Function to check the amount of tokens that an owner allowed to a spender.
150    * @param _owner address The address which owns the funds.
151    * @param _spender address The address which will spend the funds.
152    * @return A uint256 specifing the amount of tokens still available for the spender.
153    */
154   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155     return allowed[_owner][_spender];
156   }
157 
158 }
159 
160 /**
161  * @title Ownable
162  * @dev The Ownable contract has an owner address, and provides basic authorization control
163  * functions, this simplifies the implementation of "user permissions".
164  */
165 contract Ownable {
166     
167   address public owner;
168 
169   /**
170    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
171    * account.
172    */
173   function Ownable() {
174     owner = msg.sender;
175   }
176 
177   /**
178    * @dev Throws if called by any account other than the owner.
179    */
180   modifier onlyOwner() {
181     require(msg.sender == owner);
182     _;
183   }
184 
185   /**
186    * @dev Allows the current owner to transfer control of the contract to a newOwner.
187    * @param newOwner The address to transfer ownership to.
188    */
189   function transferOwnership(address newOwner) onlyOwner {
190     require(newOwner != address(0));      
191     owner = newOwner;
192   }
193 
194 }
195 
196 /**
197  * @title Burnable Token
198  * @dev Token that can be irreversibly burned (destroyed).
199  */
200 contract BurnableToken is StandardToken {
201 
202   /**
203    * @dev Burns a specific amount of tokens.
204    * @param _value The amount of token to be burned.
205    */
206   function burn(uint _value) public {
207     require(_value > 0);
208     address burner = msg.sender;
209     balances[burner] = balances[burner].sub(_value);
210     totalSupply = totalSupply.sub(_value);
211     Burn(burner, _value);
212   }
213 
214   event Burn(address indexed burner, uint indexed value);
215 
216 }
217 
218 contract UkeyToken is BurnableToken {
219     
220   string public constant name = "UKEY";
221    
222   string public constant symbol = "UKEY";
223     
224   uint8 public constant decimals = 8;
225 
226   uint256 public INITIAL_SUPPLY = 10000000000000000;
227 
228   function UkeyToken  () {
229     totalSupply = INITIAL_SUPPLY;
230     balances[0xBE676E13a92cdDF686Cc001e87F51FB55779f40e] = INITIAL_SUPPLY;
231   }
232     
233 }
234 
235 contract Crowdsale is Ownable {
236     
237   using SafeMath for uint;
238     
239   address multisig;
240 
241   UkeyToken public token = new UkeyToken ();
242 
243 
244   uint start;
245     
246     function Start() constant returns (uint) {
247         return start;
248     }
249   
250     function setStart(uint newStart) onlyOwner {
251         start = newStart;
252     }
253     
254   uint period;
255   
256    function Period() constant returns (uint) {
257         return period;
258     }
259   
260     function setPeriod(uint newPeriod) onlyOwner {
261         period = newPeriod;
262     }
263 
264   uint rate;
265   
266     function Rate() constant returns (uint) {
267         return rate;
268     }
269   
270     function setRate(uint newRate) onlyOwner {
271         rate = newRate * (10**8);
272     }
273 
274   function Crowdsale() {
275     multisig = 0xC2C09c1307024c583bAa56792B1A8Bf705a8d918;
276     rate = 0;
277     start = 0;
278     period = 0;
279   }
280   
281   modifier saleIsOn() {
282     require(now > start && now < start + period * 1 days);
283     _;
284   }
285 
286     // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
287     // @10000000000000000 - 16 null = 0.01 min payment ETH.
288     // !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
289   modifier limitation() {
290     require(msg.value >= 10000000000000000);
291     _;
292   }
293 
294   function createTokens() limitation saleIsOn payable {
295     multisig.transfer(msg.value);
296     uint tokens = rate.mul(msg.value).div(1 ether);
297     token.transfer(msg.sender, tokens);
298   }
299  
300   function() external payable {
301     createTokens();
302   }
303     
304 }