1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 /**
27  * @title SafeMath
28  * @dev Math operations with safety checks that throw on error
29  */
30 library SafeMath {
31   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
32     if (a == 0) {
33       return 0;
34     }
35     uint256 c = a * b;
36     assert(c / a == b);
37     return c;
38   }
39 
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a);
55     return c;
56   }
57 }
58 
59 /**
60  * @title Basic token
61  * @dev Basic version of StandardToken, with no allowances. 
62  */
63 contract BasicToken is ERC20Basic {
64     
65   using SafeMath for uint256;
66 
67   mapping(address => uint256) balances;
68 
69   /**
70   * @dev transfer token for a specified address
71   * @param _to The address to transfer to.
72   * @param _value The amount to be transferred.
73   */
74   function transfer(address _to, uint256 _value) public returns (bool) {
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
86   function balanceOf(address _owner) public constant returns (uint256 balance) {
87     return balances[_owner];
88   }
89 
90 }
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
101   mapping (address => mapping (address => uint256)) allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amout of tokens to be transfered
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     var _allowance = allowed[_from][msg.sender];
111 
112     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
113     // require (_value <= _allowance);
114 
115     balances[_to] = balances[_to].add(_value);
116     balances[_from] = balances[_from].sub(_value);
117     allowed[_from][msg.sender] = _allowance.sub(_value);
118     Transfer(_from, _to, _value);
119     return true;
120   }
121 
122   /**
123    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
124    * @param _spender The address which will spend the funds.
125    * @param _value The amount of tokens to be spent.
126    */
127   function approve(address _spender, uint256 _value) public returns (bool) {
128 
129     // To change the approve amount you first have to reduce the addresses`
130     //  allowance to zero by calling `approve(_spender, 0)` if it is not
131     //  already 0 to mitigate the race condition described here:
132     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
134 
135     allowed[msg.sender][_spender] = _value;
136     Approval(msg.sender, _spender, _value);
137     return true;
138   }
139 
140   /**
141    * @dev Function to check the amount of tokens that an owner allowed to a spender.
142    * @param _owner address The address which owns the funds.
143    * @param _spender address The address which will spend the funds.
144    * @return A uint256 specifing the amount of tokens still available for the spender.
145    */
146   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
147     return allowed[_owner][_spender];
148   }
149 
150 }
151 
152 /**
153  * @title Ownable
154  * @dev The Ownable contract has an owner address, and provides basic authorization control
155  * functions, this simplifies the implementation of "user permissions".
156  */
157 contract Ownable {
158     
159   address public owner;
160 
161   /**
162    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
163    * account.
164    */
165   function Ownable() public {
166     owner = msg.sender;
167   }
168 
169   /**
170    * @dev Throws if called by any account other than the owner.
171    */
172   modifier onlyOwner() {
173     require(msg.sender == owner);
174     _;
175   }
176 
177   /**
178    * @dev Allows the current owner to transfer control of the contract to a newOwner.
179    * @param newOwner The address to transfer ownership to.
180    */
181   function transferOwnership(address newOwner) onlyOwner public {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185 
186 }
187 
188 /**
189  * @title Burnable Token
190  * @dev Token that can be irreversibly burned (destroyed).
191  */
192 contract BurnableToken is StandardToken {
193 
194   /**
195    * @dev Burns a specific amount of tokens.
196    * @param _value The amount of token to be burned.
197    */
198   function burn(uint _value) public {
199     require(_value > 0);
200     address burner = msg.sender;
201     balances[burner] = balances[burner].sub(_value);
202     totalSupply = totalSupply.sub(_value);
203     Burn(burner, _value);
204   }
205 
206   event Burn(address indexed burner, uint indexed value);
207 
208 }
209 
210 contract Testcoin is BurnableToken {
211     
212   string public constant name = "Testcoin";
213    
214   string public constant symbol = "TSX";
215     
216   uint32 public constant decimals = 18;
217 
218   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
219 
220   function Testcoin() public {
221     totalSupply = INITIAL_SUPPLY;
222     balances[msg.sender] = INITIAL_SUPPLY;
223   }
224     
225 }
226 
227 contract Crowdsale is Ownable {
228     
229   using SafeMath for uint;
230     
231   address multisig;
232 
233   address restricted;
234 
235   Testcoin public token = new Testcoin();
236 
237   uint public start;
238     
239   uint public period;
240   
241   uint per_p_sale;
242   
243   uint per_sale;
244   
245   uint start_ico;
246   
247   uint sale_pre_sale;
248   uint sale_1_week;
249   uint sale_2_week;
250   uint sale_3_week;
251   uint sale_4_week;
252   uint sale_5_week;
253 
254   uint rate;
255   uint256 public presaleTokens;
256   uint256 public restrictedTokens;
257   uint256 public ini_supply;
258   function Crowdsale() public {
259     multisig = 0x476Bb28Bc6D0e9De04dB5E19912C392F9a76535d;
260     restricted = 0x476Bb28Bc6D0e9De04dB5E19912C392F9a76535d;
261     rate = 1000000000000000000000;
262     start = 1513555200; /* 12/18/2017 @ 12:00am (UTC) */
263     period = 5 * 365;
264     per_p_sale = 5;
265     per_sale = 365;
266     sale_pre_sale = 50;
267     sale_1_week = 40;
268     sale_2_week = 30;
269     sale_3_week = 20;
270     sale_4_week = 10;
271     sale_5_week = 5;
272     ini_supply = 100000000 * 1 ether;
273     presaleTokens    = 60000000 * 1 ether;
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
301   function createTokens() saleIsOn payable public {
302 
303     uint tokens = rate.mul(msg.value).div(1 ether);
304     uint bonusTokens = 0;
305     start_ico = start + per_p_sale * 1 days; 
306     multisig.transfer(msg.value);    
307     if(now < start_ico) 
308     { 
309      if(address(this).balance >= ini_supply.sub(restrictedTokens).sub(presaleTokens))
310        {
311          bonusTokens = tokens.div(100).mul(sale_pre_sale);
312        } 
313 	  
314     } else if(now >= start_ico && now < start_ico + (per_sale * 1 days)) {
315       bonusTokens = tokens.div(100).mul(sale_1_week);
316     } else if(now >= start_ico + (per_sale * 1 days) && now < start_ico + (per_sale * 1 days).mul(2)) {
317       bonusTokens = tokens.div(100).mul(sale_2_week);
318     } else if(now >= start_ico + (per_sale * 1 days).mul(2) && now < start_ico + (per_sale * 1 days).mul(3)) {
319       bonusTokens = tokens.div(100).mul(sale_3_week);  
320     } else if(now >= start_ico + (per_sale * 1 days).mul(3) && now < start_ico + (per_sale * 1 days).mul(4)) {
321       bonusTokens = tokens.div(100).mul(sale_4_week);       
322     } else if(now >= start_ico + (per_sale * 1 days).mul(4) && now < start_ico + (per_sale * 1 days).mul(5)) {
323       bonusTokens = tokens.div(100).mul(sale_5_week);      
324     }
325     uint tokensWithBonus = tokens.add(bonusTokens);
326     token.transfer(msg.sender, tokensWithBonus);
327     
328   }
329 
330   function() external payable {
331     createTokens();
332   }
333     
334 }