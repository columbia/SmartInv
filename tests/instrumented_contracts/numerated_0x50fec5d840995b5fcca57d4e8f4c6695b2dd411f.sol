1 pragma solidity ^0.4.16;
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
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) returns (bool);
22   function approve(address spender, uint256 value) returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31 
32   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
33     uint256 c = a * b;
34     assert(a == 0 || c / a == b);
35     return c;
36   }
37 
38   function div(uint256 a, uint256 b) internal constant returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   function add(uint256 a, uint256 b) internal constant returns (uint256) {
51     uint256 c = a + b;
52     assert(c >= a);
53     return c;
54   }
55 
56 }
57 
58 /**
59  * @title Basic token
60  * @dev Basic version of StandardToken, with no allowances.
61  */
62 contract BasicToken is ERC20Basic {
63 
64   using SafeMath for uint256;
65 
66   mapping(address => uint256) balances;
67 
68   /**
69   * @dev transfer token for a specified address
70   * @param _to The address to transfer to.
71   * @param _value The amount to be transferred.
72   */
73   function transfer(address _to, uint256 _value) returns (bool) {
74     balances[msg.sender] = balances[msg.sender].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     Transfer(msg.sender, _to, _value);
77     return true;
78   }
79 
80   /**
81   * @dev Gets the balance of the specified address.
82   * @param _owner The address to query the the balance of.
83   * @return An uint256 representing the amount owned by the passed address.
84   */
85   function balanceOf(address _owner) constant returns (uint256 balance) {
86     return balances[_owner];
87   }
88 
89 }
90 
91 /**
92  * @title Standard ERC20 token
93  *
94  * @dev Implementation of the basic standard token.
95  * @dev https://github.com/ethereum/EIPs/issues/20
96  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amout of tokens to be transfered
107    */
108   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
109     var _allowance = allowed[_from][msg.sender];
110 
111     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112     // require (_value <= _allowance);
113 
114     balances[_to] = balances[_to].add(_value);
115     balances[_from] = balances[_from].sub(_value);
116     allowed[_from][msg.sender] = _allowance.sub(_value);
117     Transfer(_from, _to, _value);
118     return true;
119   }
120 
121   /**
122    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) returns (bool) {
127 
128     // To change the approve amount you first have to reduce the addresses`
129     //  allowance to zero by calling `approve(_spender, 0)` if it is not
130     //  already 0 to mitigate the race condition described here:
131     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
133 
134     allowed[msg.sender][_spender] = _value;
135     Approval(msg.sender, _spender, _value);
136     return true;
137   }
138 
139   /**
140    * @dev Function to check the amount of tokens that an owner allowed to a spender.
141    * @param _owner address The address which owns the funds.
142    * @param _spender address The address which will spend the funds.
143    * @return A uint256 specifing the amount of tokens still available for the spender.
144    */
145   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
146     return allowed[_owner][_spender];
147   }
148 
149 }
150 
151 /**
152  * @title Ownable
153  * @dev The Ownable contract has an owner address, and provides basic authorization control
154  * functions, this simplifies the implementation of "user permissions".
155  */
156 contract Ownable {
157 
158   address public owner;
159 
160   /**
161    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
162    * account.
163    */
164   function Ownable() {
165     owner = msg.sender;
166   }
167 
168   /**
169    * @dev Throws if called by any account other than the owner.
170    */
171   modifier onlyOwner() {
172     require(msg.sender == owner);
173     _;
174   }
175 
176   /**
177    * @dev Allows the current owner to transfer control of the contract to a newOwner.
178    * @param newOwner The address to transfer ownership to.
179    */
180   function transferOwnership(address newOwner) onlyOwner {
181     require(newOwner != address(0));
182     owner = newOwner;
183   }
184 
185 }
186 
187 /**
188  * @title Burnable Token
189  * @dev Token that can be irreversibly burned (destroyed).
190  */
191 contract BurnableToken is StandardToken {
192 
193   /**
194    * @dev Burns a specific amount of tokens.
195    * @param _value The amount of token to be burned.
196    */
197   function burn(uint _value) public {
198     require(_value > 0);
199     address burner = msg.sender;
200     balances[burner] = balances[burner].sub(_value);
201     totalSupply = totalSupply.sub(_value);
202     Burn(burner, _value);
203   }
204 
205   event Burn(address indexed burner, uint indexed value);
206 
207 }
208 
209 contract Presscoins is BurnableToken {
210 
211   string public constant name = "Presscoins";
212 
213   string public constant symbol = "PRESS";
214 
215   uint32 public constant decimals = 18;
216 
217   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
218 
219   function Presscoins() {
220     totalSupply = INITIAL_SUPPLY;
221     balances[msg.sender] = INITIAL_SUPPLY;
222   }
223 
224 }
225 
226 contract Crowdsale is Ownable {
227 
228   using SafeMath for uint;
229 
230   address multisig;
231 
232   address restricted;
233 
234   Presscoins public token = new Presscoins();
235 
236   uint public start;
237 
238   uint public period;
239 
240   uint per_p_sale;
241 
242   uint per_sale;
243 
244   uint start_ico;
245 
246   uint sale_pre_sale;
247   uint sale_1_week;
248   uint sale_2_week;
249   uint sale_3_week;
250   uint sale_4_week;
251   uint sale_5_week;
252 
253   uint rate;
254   uint256 public presaleTokens;
255   uint256 public preSaleSupply;
256   uint256 public restrictedTokens;
257   uint256 public ini_supply;
258   function Crowdsale() {
259     multisig = 0xB4ac5FF29F9D44976e0Afcd58A52f490e1F5B96A;
260     restricted = 0x4DBe3d19A87EC865FD052736Ccf9596E668DEdF4;
261     rate = 2000000000000000000000;
262     start = 1509498061;
263     period = 80;
264     per_p_sale = 5;
265     per_sale = 7;
266     sale_pre_sale = 50;
267     sale_1_week = 40;
268     sale_2_week = 30;
269     sale_3_week = 20;
270     sale_4_week = 10;
271     sale_5_week = 5;
272     preSaleSupply = 0;
273     presaleTokens    = 40000000 * 1 ether;
274     restrictedTokens = 30000000 * 1 ether;
275 
276     token.transfer(restricted, restrictedTokens);
277   }
278 
279   modifier saleIsOn() {
280     require(now > start && now < start + period * 1 days);
281     _;
282   }
283 
284   function setStart(uint _start) public onlyOwner {
285     start = _start;
286   }
287 
288   function setPeriod(uint _period) public onlyOwner {
289     period = _period;
290   }
291 
292   function setSail(uint _sale_pre_sale, uint _sale_1_week, uint _sale_2_week, uint _sale_3_week, uint _sale_4_week, uint _sale_5_week) public onlyOwner {
293     sale_pre_sale = _sale_pre_sale;
294     sale_1_week = _sale_1_week;
295     sale_2_week = _sale_2_week;
296     sale_3_week = _sale_3_week;
297     sale_4_week = _sale_4_week;
298     sale_5_week = _sale_5_week;
299   }
300 
301   function createTokens() saleIsOn payable {
302     uint tokens = rate.mul(msg.value).div(1 ether);
303     uint bonusTokens = 0;
304     start_ico = start + per_p_sale * 1 days;
305     multisig.transfer(msg.value);
306     if(now < start_ico)
307     {
308       require(preSaleSupply <= presaleTokens);
309       bonusTokens = tokens.div(100).mul(sale_pre_sale);
310     } else if(now >= start_ico && now < start_ico + (per_sale * 1 days)) {
311       bonusTokens = tokens.div(100).mul(sale_1_week);
312     } else if(now >= start_ico + (per_sale * 1 days) && now < start_ico + (per_sale * 1 days).mul(2)) {
313       bonusTokens = tokens.div(100).mul(sale_2_week);
314     } else if(now >= start_ico + (per_sale * 1 days).mul(2) && now < start_ico + (per_sale * 1 days).mul(3)) {
315       bonusTokens = tokens.div(100).mul(sale_3_week);
316     } else if(now >= start_ico + (per_sale * 1 days).mul(3) && now < start_ico + (per_sale * 1 days).mul(4)) {
317       bonusTokens = tokens.div(100).mul(sale_4_week);
318     } else if(now >= start_ico + (per_sale * 1 days).mul(4) && now < start_ico + (per_sale * 1 days).mul(5)) {
319       bonusTokens = tokens.div(100).mul(sale_5_week);
320     }
321     uint tokensWithBonus = tokens.add(bonusTokens);
322     preSaleSupply = preSaleSupply.add(tokensWithBonus);
323     token.transfer(msg.sender, tokensWithBonus);
324   }
325 
326   function() external payable {
327     createTokens();
328   }
329 
330 }
331 
332 
333 
334 
335 /** PressOnDemand is the first decentralized ondemand platform with in-Dapp store,
336   * Powered by smartcontracts utilize blockchain technology. Users can instantly book and
337   * schedule a service provider to their home or office or most locations with the press of a
338   * button. The decentralized design of the PressOnDemand platform eliminates middlemen,
339   * making the whole service more efficient and transparent as well as saving money for both
340   * the service provider and the customer.
341   /*