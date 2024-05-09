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
253 
254 
255 
256 
257 
258 contract PrivateSale is Ownable {    
259     using SafeMath for uint;        
260     AgroTechFarmToken public token;
261     bool public PrivateSaleFinished = false;          
262     address public multisig;
263     address public preSale = 0x02Dcc61022771015b1408323D29C790066CBe2e4;
264     address public preSale1 = 0xfafbb19945fc2d79828e4c5813a619d5683074ba;
265     address public preSale2 = 0x62451D37Ca2EC1f0499996Bc3C7e2BAF258E9729;
266     address public preSale3 = 0x72636c350431895fc6ee718b92bcc5b4fbd70304;
267 	address public preSale4 = 0xE2615137c379910897D4c662345a5A1D0B91f719;
268 	address public preSale5 = 0x25190dca5d174f08205F7376A36CAdDF14072732;
269     uint public rate;
270     uint public start;
271     uint public end;
272     uint public hardcap;
273     address public restricted;
274 	uint public restrictedPercent;
275 
276     function PrivateSale() public {        
277 	    token = AgroTechFarmToken(0xa55ffAeA5c8cf32B550F663bf17d4F7b739534ff); 
278 		multisig = 0x227917ac3C1F192874d43031cF4D40fd40Ae6127;
279 		rate = 83333333333000000000; 
280 		start = 1525150800;
281         end = 1527829200; 
282 	    hardcap = 500000000000000000000;
283 	    restricted = 0xbcCd749ecCCee5B4898d0E38D2a536fa84Ea9Ef6;   
284 	    restrictedPercent = 35;
285           
286     }
287  
288    modifier saleIsOn() {
289     	require(now > start && now < end);
290     	_;
291     }
292 	
293     modifier isUnderHardCap() {
294       require(this.balance <= hardcap);
295         _;
296     } 
297 
298 
299   function balancePrivateSale() public constant returns (uint) {
300      return this.balance;
301     }
302 
303  
304   function finishPrivateSale() public onlyOwner returns (bool)  {
305         if(now > end || this.balance >= hardcap) {                     
306          multisig.transfer(this.balance);
307          PrivateSaleFinished = true;
308          return true;
309          } else return false;     
310       }
311  
312    function createTokens() public isUnderHardCap saleIsOn payable {
313         uint tokens = rate.mul(msg.value).div(1 ether);           
314         uint bonusTokens = tokens.mul(30).div(100);       
315         tokens += bonusTokens;     
316         token.mint(msg.sender, tokens);
317        
318 	    uint restrictedTokens = tokens.mul(restrictedPercent).div(100); 
319         token.mint(restricted, restrictedTokens);        
320         
321     }
322  
323 
324     function() external payable {
325         createTokens();
326     } 
327 }