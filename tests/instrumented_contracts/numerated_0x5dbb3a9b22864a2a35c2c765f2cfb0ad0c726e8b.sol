1 pragma solidity ^0.4.15;
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
39     uint256 c = a / b;
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53   
54 }
55 
56 /**
57  * @title Basic token
58  * @dev Basic version of StandardToken, with no allowances. 
59  */
60 contract BasicToken is ERC20Basic {
61     
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   /**
67   * @dev transfer token for a specified address
68   * @param _to The address to transfer to.
69   * @param _value The amount to be transferred.
70   */
71   function transfer(address _to, uint256 _value) returns (bool) {
72     balances[msg.sender] = balances[msg.sender].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     Transfer(msg.sender, _to, _value);
75     return true;
76   }
77 
78   /**
79   * @dev Gets the balance of the specified address.
80   * @param _owner The address to query the the balance of. 
81   * @return An uint256 representing the amount owned by the passed address.
82   */
83   function balanceOf(address _owner) constant returns (uint256 balance) {
84     return balances[_owner];
85   }
86 
87 }
88 
89 /**
90  * @title Standard ERC20 token
91  *
92  * @dev Implementation of the basic standard token.
93  * @dev https://github.com/ethereum/EIPs/issues/20
94  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
95  */
96 contract StandardToken is ERC20, BasicToken {
97 
98   mapping (address => mapping (address => uint256)) allowed;
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
109     balances[_to] = balances[_to].add(_value);
110     balances[_from] = balances[_from].sub(_value);
111     allowed[_from][msg.sender] = _allowance.sub(_value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   /**
117    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
118    * @param _spender The address which will spend the funds.
119    * @param _value The amount of tokens to be spent.
120    */
121   function approve(address _spender, uint256 _value) returns (bool) {
122 
123     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
124     allowed[msg.sender][_spender] = _value;
125     Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Function to check the amount of tokens that an owner allowed to a spender.
131    * @param _owner address The address which owns the funds.
132    * @param _spender address The address which will spend the funds.
133    * @return A uint256 specifing the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138 
139 }
140 
141 /**
142  * @title Ownable
143  * @dev The Ownable contract has an owner address, and provides basic authorization control
144  * functions, this simplifies the implementation of "user permissions".
145  */
146 contract Ownable {
147     
148   address public owner;
149 
150   /**
151    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
152    * account.
153    */
154   function Ownable() {
155     owner = msg.sender;
156   }
157 
158   /**
159    * @dev Throws if called by any account other than the owner.
160    */
161   modifier onlyOwner() {
162     require(msg.sender == owner);
163     _;
164   }
165 
166   /**
167    * @dev Allows the current owner to transfer control of the contract to a newOwner.
168    * @param newOwner The address to transfer ownership to.
169    */
170   function transferOwnership(address newOwner) onlyOwner {
171     require(newOwner != address(0));      
172     owner = newOwner;
173   }
174 
175 }
176 
177 /**
178  * @title Mintable token
179  * @dev Simple ERC20 Token example, with mintable token creation
180  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
181  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
182  */
183 
184 contract MintableToken is StandardToken, Ownable {
185     
186   event Mint(address indexed to, uint256 amount);
187   
188   event MintFinished();
189 
190   bool public mintingFinished = false;
191 
192   modifier canMint() {
193     require(!mintingFinished);
194     _;
195   }
196 
197   /**
198    * @dev Function to mint tokens
199    * @param _to The address that will recieve the minted tokens.
200    * @param _amount The amount of tokens to mint.
201    * @return A boolean that indicates if the operation was successful.
202    */
203   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
204     totalSupply = totalSupply.add(_amount);
205     balances[_to] = balances[_to].add(_amount);
206     Mint(_to, _amount);
207     return true;
208   }
209 
210   /**
211    * @dev Function to stop minting new tokens.
212    * @return True if the operation was successful.
213    */
214   function finishMinting() onlyOwner returns (bool) {
215     mintingFinished = true;
216     MintFinished();
217     return true;
218   }
219   
220 }
221 
222 contract IBFSTokenCoin is MintableToken {
223     
224     string public constant name = "IBFS Token Coin";
225     
226     string public constant symbol = "IBFS";
227     
228     uint32 public constant decimals = 18;
229     
230 }
231 
232 
233 contract Crowdsale is Ownable {
234     
235     using SafeMath for uint;
236     
237     address multisig;
238 
239     uint restrictedPercent;
240 
241     address restricted;
242 
243     IBFSTokenCoin public token = new IBFSTokenCoin();
244 
245     uint start;
246     
247     uint period;
248 
249     uint hardcap;
250 
251     uint rate;
252 
253     function Crowdsale() {
254 	/** for etherium  (ibfs)*/	
255 	
256 	multisig = 0xd1e9e31Ff2AaB53211Ff57b6996Ba9C40055023f;
257 	
258 	/** for team  (mk)  */
259 	restricted = 0x332d2F8f22Eeed97C08cDbf50203c545E7AF076b;
260 	
261 	restrictedPercent = 10;
262 	
263 	rate = 400;
264 		
265 	/** start = 1512086400;  real start date */
266 		
267 	start = 1512086400; 
268 	period = 92;
269 	
270 	/** hardcap  approx eqv.50 000 000 usd */
271    
272    
273    hardcap = 50000000000000000000000000;                     
274                       
275     }
276 
277     modifier saleIsOn() {
278     	require(now > start && now < start + period * 1 days);
279     	_;
280     }
281 	
282     modifier isUnderHardCap() {
283         require(multisig.balance <= hardcap);
284         _;
285     }
286 
287     function finishMinting() public onlyOwner {
288 	uint issuedTokenSupply = token.totalSupply();
289 	uint restrictedTokens = issuedTokenSupply.mul(restrictedPercent).div(100 - restrictedPercent);
290 	token.mint(restricted, restrictedTokens);
291         token.finishMinting();
292     }
293 
294    function createTokens() isUnderHardCap saleIsOn payable {
295         multisig.transfer(msg.value);
296         /** uint tokens = rate.mul(msg.value).div(1 ether); */
297         uint tokens = rate.mul(msg.value);
298         uint bonusTokens = 0;
299         if(now < start + ( 7 days)) { bonusTokens = tokens.div(4);} 
300            else if(now >= start + (7 days) && now < start + (14 days)) {  bonusTokens = tokens.mul(15).div(100); } 
301               else if(now >= start + (14 days) && now < start + (21 days)) { bonusTokens = tokens.div(10); }
302                  else if(now >= start + (21 days) && now < start + (28 days)) { bonusTokens = tokens.div(20); }
303         tokens += bonusTokens;
304         token.mint(msg.sender, tokens);
305     }
306 
307     function() external payable {
308         createTokens();
309     }
310     
311 }