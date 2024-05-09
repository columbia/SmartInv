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
40   function div(uint256 a, uint256 b) internal pure  returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   function sub(uint256 a, uint256 b) internal pure  returns (uint256) {
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
181   function transferOwnership(address newOwner) public onlyOwner {
182     require(newOwner != address(0));      
183     owner = newOwner;
184   }
185  
186 }
187  
188 /**
189  * @title Mintable token
190  * @dev Simple ERC20 Token example, with mintable token creation
191  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
192  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
193  */
194  
195 contract MintableToken is StandardToken, Ownable {
196     
197   event Mint(address indexed to, uint256 amount);
198   
199   event MintFinished();
200  
201   bool public mintingFinished = false;
202  
203   address public saleAgent;
204   
205    modifier canMint() {
206    require(!mintingFinished);
207     _;
208   }
209   
210    modifier onlySaleAgent() {
211    require(msg.sender == saleAgent);
212     _;
213   }
214 
215   function setSaleAgent(address newSaleAgent) public onlyOwner {
216    saleAgent = newSaleAgent;
217   }
218 
219   /**
220    * @dev Function to mint tokens
221    * @param _to The address that will recieve the minted tokens.
222    * @param _amount The amount of tokens to mint.
223    * @return A boolean that indicates if the operation was successful.
224    */
225   function mint(address _to, uint256 _amount) public onlySaleAgent canMint returns (bool) {
226     totalSupply = totalSupply.add(_amount);
227     balances[_to] = balances[_to].add(_amount);
228     Mint(_to, _amount);
229     return true;
230   }
231  
232   /**
233    * @dev Function to stop minting new tokens.
234    * @return True if the operation was successful.
235    */
236   function finishMinting() public onlySaleAgent returns (bool) {
237     mintingFinished = true;
238     MintFinished();
239     return true;
240   }
241   
242 }
243  
244 contract AgroTechFarmToken is MintableToken {
245     
246     string public constant name = "Agro Tech Farm";
247     
248     string public constant symbol = "ATF";
249     
250     uint32 public constant decimals = 18;
251 }
252 
253 contract preSale2 is Ownable {    
254     using SafeMath for uint;        
255     AgroTechFarmToken public token;
256     bool public preSale2Finished = false;          
257     address public multisig;  
258     uint public rate;
259     uint public tokenCap;
260     uint public start;
261     uint public period;
262     uint public hardcap;
263     address public restricted;
264 	uint public restrictedPercent;
265 
266     function preSale2() public {        
267 	    token = AgroTechFarmToken(0xa55ffAeA5c8cf32B550F663bf17d4F7b739534ff); 
268 		multisig = 0x227917ac3C1F192874d43031cF4D40fd40Ae6127;
269 		rate = 83333333333000000000; 
270 		tokenCap =  25000000000000000000000; 
271 		start = 1518739200; 
272 		period = 8; 
273 	    hardcap = 500000000000000000000;
274 	    restricted = 0xbcCd749ecCCee5B4898d0E38D2a536fa84Ea9Ef6;   
275 	    restrictedPercent = 35;
276           
277     }
278  
279     modifier saleIsOn() {
280     	require(now > start && now < start + period * 1 days);
281     	_;
282     }
283 	
284     modifier isUnderHardCap() {
285       require(this.balance <= hardcap);
286         _;
287     } 
288 
289 
290   function balancePreSale2() public constant returns (uint) {
291      return this.balance;
292     }
293 
294 
295   function finishPreSale2() public onlyOwner returns (bool)  {
296         if(now > start + period * 1 days || this.balance >= hardcap) {                     
297          multisig.transfer(this.balance);
298          preSale2Finished = true;
299          return true;
300          } else return false;     
301       }
302  
303    function createTokens() public isUnderHardCap saleIsOn payable {
304         uint tokens = rate.mul(msg.value).div(1 ether);      
305         uint bonusTokens = 0;        
306         uint totalSupply = token.totalSupply();
307        
308         if (totalSupply <= tokenCap) {
309             bonusTokens = tokens.div(2); 
310         } else bonusTokens = tokens.mul(40).div(100); 
311 
312         
313         tokens += bonusTokens;     
314         token.mint(msg.sender, tokens);
315        
316 	    uint restrictedTokens = tokens.mul(restrictedPercent).div(100); 
317         token.mint(restricted, restrictedTokens);        
318         
319     }
320  
321 
322     function() external payable {
323         createTokens();
324     } 
325 }