1 pragma solidity ^0.4.21;
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
209 contract AriumToken is BurnableToken {
210    
211   string public constant name = "Arium Token";
212    
213   string public constant symbol = "ARM";
214    
215   uint32 public constant decimals = 10;
216  
217   uint256 public INITIAL_SUPPLY = 420000000000000000;        // supply 42 000 000
218  
219  
220   function AriumToken() {
221     totalSupply = INITIAL_SUPPLY;
222     balances[msg.sender] = INITIAL_SUPPLY;
223   }
224  
225 }
226  
227 contract AriumCrowdsale is Ownable {
228    
229   using SafeMath for uint;
230    
231   address multisig;
232  
233   uint restrictedPercent;
234  
235   address restricted;
236  
237   AriumToken public token;
238  
239   uint start;
240    
241   uint preico;
242  
243   uint rate;
244  
245   uint icostart;
246  
247   uint ico;
248  
249   function AriumCrowdsale(AriumToken _token) {
250     token=_token;
251     multisig = 0x661AD28e92d43Af07E1508e7A04f74E4a0D6728d;          // ether holder
252     restricted = 0xC357d4e9601B11BF0d63a718228bfc021360E05E;        // team holder
253     restrictedPercent = 13;             // percent to team
254     rate = 10000000000000;
255     start = 1520496194;     //start pre ico
256     preico = 30;        // pre ico period
257     icostart= 1537760157;       // ico start
258     ico = 60;           // ico period
259    
260    
261   }
262  
263   modifier saleIsOn() {
264     require((now > start && now < start + preico * 1 days) || (now > icostart && now < icostart + ico * 1 days ) );
265     _;
266   }
267  
268   function createTokens() saleIsOn payable {
269     multisig.transfer(msg.value);
270    
271     uint tokens = rate.mul(msg.value).div(1 ether);
272     uint bonusTokens = 0;
273     uint BonusPerAmount = 0;
274     if(msg.value >= 0.5 ether && msg.value < 1 ether){
275         BonusPerAmount = tokens.div(20);                     // 5% 5/100=1/20
276     } else if (msg.value >= 1 ether && msg.value < 5 ether){
277         BonusPerAmount = tokens.div(10);                     // 10%
278     } else if (msg.value >= 5 ether && msg.value < 10 ether){
279         BonusPerAmount = tokens.mul(15).div(100);
280     } else if (msg.value >= 10 ether && msg.value < 20 ether){
281         BonusPerAmount = tokens.div(5);
282     } else if (msg.value >= 20 ether){
283         BonusPerAmount = tokens.div(4);
284     }
285     if(now < start + (preico * 1 days).div(3)) {
286       bonusTokens = tokens.div(10).mul(3);
287     } else if(now >= start + (preico * 1 days).div(3) && now < start + (preico * 1 days).div(3).mul(2)) {
288       bonusTokens = tokens.div(5);
289     } else if(now >= start + (preico * 1 days).div(3).mul(2) && now < start + (preico * 1 days)) {
290       bonusTokens = tokens.div(10);
291     }
292     uint tokensWithBonus = tokens.add(BonusPerAmount);
293     tokensWithBonus = tokensWithBonus.add(bonusTokens);
294     token.transfer(msg.sender, tokensWithBonus);
295     uint restrictedTokens = tokens.mul(restrictedPercent).div(100);
296     token.transfer(restricted, restrictedTokens);
297   }
298  
299     function manualTransfer(address _to , uint ammount) saleIsOn onlyOwner payable{           //function for manual transfer(purchase with no ETH)
300     token.transfer(_to, rate.div(1000).mul(ammount));                              
301     token.transfer(restricted, rate.div(100000).mul(restrictedPercent).mul(ammount));             // transfer 13% to team balance
302     }
303    
304     function BurnUnsoldToken(uint _value) onlyOwner payable{                                // burn unsold token after
305         token.burn(_value);
306        
307     }
308  
309   function() external payable {
310     createTokens();
311   }
312    
313 }