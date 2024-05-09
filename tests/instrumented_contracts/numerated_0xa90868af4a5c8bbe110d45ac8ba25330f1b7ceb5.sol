1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title ERC20Basic
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public constant returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 /**
14  * @title ERC20 interface
15  */
16 contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) public constant returns (uint256);
18   function transferFrom(address from, address to, uint256 value) public returns (bool);
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 /**
24  * @title SafeMath
25  * @dev Math operations with safety checks that throw on error
26  */
27 library SafeMath {
28     
29   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
30     uint256 c = a * b;
31     assert(a == 0 || c / a == b);
32     return c;
33   }
34 
35   function div(uint256 a, uint256 b) internal constant returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
43     assert(b <= a);
44     return a - b;
45   }
46 
47   function add(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52   
53 }
54 
55 /**
56  * @title Basic token
57  * @dev Basic version of StandardToken, with no allowances. 
58  */
59 contract BasicToken is ERC20Basic {
60     
61   using SafeMath for uint256;
62 
63   mapping(address => uint256) balances;
64 
65   /**
66   * @dev transfer token for a specified address
67   * @param _to The address to transfer to.
68   * @param _value The amount to be transferred.
69   */
70   function transfer(address _to, uint256 _value) public returns (bool) {
71     balances[msg.sender] = balances[msg.sender].sub(_value);
72     balances[_to] = balances[_to].add(_value);
73     Transfer(msg.sender, _to, _value);
74     return true;
75   }
76 
77   /**
78   * @dev Gets the balance of the specified address.
79   * @param _owner The address to query the the balance of. 
80   * @return An uint256 representing the amount owned by the passed address.
81   */
82   function balanceOf(address _owner) public constant returns (uint256 balance) {
83     return balances[_owner];
84   }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  */
91 contract StandardToken is ERC20, BasicToken {
92 
93   mapping (address => mapping (address => uint256)) allowed;
94 
95   /**
96    * @dev Transfer tokens from one address to another
97    * @param _from address The address which you want to send tokens from
98    * @param _to address The address which you want to transfer to
99    * @param _value uint256 the amout of tokens to be transfered
100    */
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     var _allowance = allowed[_from][msg.sender];
103 
104     balances[_to] = balances[_to].add(_value);
105     balances[_from] = balances[_from].sub(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) public returns (bool) {
117 
118     // To change the approve amount you first have to reduce the addresses`
119     //  allowance to zero by calling `approve(_spender, 0)` if it is not
120     //  already 0 to mitigate the race condition described here:
121     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
122     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
123 
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
135   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
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
177 contract AgrolotToken is StandardToken {
178     
179   string public constant name = "Agrolot Token";
180    
181   string public constant symbol = "AGLT";
182     
183   uint32 public constant decimals = 18;
184 
185   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
186 
187   function AgrolotToken() {
188     totalSupply = INITIAL_SUPPLY;
189     balances[msg.sender] = INITIAL_SUPPLY;
190   }
191     
192 }
193 
194 contract Crowdsale is Ownable {
195     
196   using SafeMath for uint;
197     
198   address multisig;
199 
200   uint restrictedTeam;
201   
202   uint restrictedVIA;
203   
204   uint restrictedAirdrop;
205 
206   address restricted_address;
207   
208   address airdropAddress;
209 
210   AgrolotToken public token = new AgrolotToken();
211 
212   uint public minPaymentWei = 0.1 ether;
213     
214   uint public maxCapTokenPresale;
215   
216   uint public maxCapTokenTotal;
217   
218   uint public totalTokensSold;
219   
220   uint public totalWeiReceived;
221   
222   uint startPresale;
223     
224   uint periodPresale;
225   
226   uint startSale;
227     
228   uint periodSale;
229 
230   uint rate;
231 
232   function Crowdsale() {
233     multisig = 0x7c8Ef6E9437E8B1554dCd22a00AB1B3a709998d9;
234     restricted_address = 0x3a5d3146Cd9f1157F2d36488B99429500A257b13;
235     airdropAddress = 0xe86AC25B3d2fe81951A314BA1042Fc17A096F3a2;
236     restrictedTeam = 20000000 * 1 ether;
237     restrictedVIA = 45250000 * 1 ether;
238     restrictedAirdrop = 1250000 * 1 ether;
239     rate = 530 * 1 ether;
240     maxCapTokenPresale = 3000000 * 1 ether;
241     maxCapTokenTotal = 23000000 * 1 ether;
242     
243     startPresale = 1529496000;
244     periodPresale = 10;
245     
246     startSale = 1530446400;
247     periodSale = 90;
248     
249     token.transfer(airdropAddress, restrictedAirdrop);
250     
251     //privatesale 
252     token.transfer(0xA44ceA410e7D1100e05bC8CDe6C63cee947A28f7, 1500000 * 1 ether);
253     token.transfer(0x4d044d2921e25Abda8D279d21FED919fB150F8C8, 600000 * 1 ether);
254     token.transfer(0x076A7E0A69Da48ac928508c1ac0E9cDCeDCeE903, 350000 * 1 ether);
255     token.transfer(0x60a7536b58ba2BEBB25165c09E39365c9d7Fb49A, 800000 * 1 ether);
256     token.transfer(0x41B05379ba55954D9e1Db10fd464cEc6cA8b085D, 750000 * 1 ether);
257 
258   }
259 
260   modifier saleIsOn() {
261     require ((now > startPresale && now < startPresale + (periodPresale * 1 days)) || (now > startSale && now < startSale + (periodSale * 1 days)));
262     
263     _;
264   }
265 
266   function createTokens() saleIsOn payable {
267     require(msg.value >= minPaymentWei);
268     uint tokens = rate.mul(msg.value).div(1 ether);
269     uint bonusTokens = 0;
270     if (now <= startPresale + (periodPresale * 1 days)) {
271         require(totalTokensSold.add(tokens) <= maxCapTokenPresale);
272         bonusTokens = tokens.div(100).mul(50);
273     } else {
274         require(totalTokensSold.add(tokens) <= maxCapTokenTotal);
275         if(now < startSale + (15 * 1 days)) {
276             bonusTokens = tokens.div(100).mul(25);
277         } else if(now < startSale + (25 * 1 days)) {
278             bonusTokens = tokens.div(100).mul(15);
279         } else if(now < startSale + (35 * 1 days)) {
280             bonusTokens = tokens.div(100).mul(7);
281         }
282     }
283 
284     totalTokensSold = totalTokensSold.add(tokens);
285     totalWeiReceived = totalWeiReceived.add(msg.value);
286     uint tokensWithBonus = tokens.add(bonusTokens);
287     multisig.transfer(msg.value);
288     token.transfer(msg.sender, tokensWithBonus);
289   }
290 
291   function() external payable {
292     createTokens();
293   }
294   
295  
296   function getVIATokens() public {
297     require(now > startSale + (91 * 1 days));
298     address contractAddress = address(this);
299     uint allTokens = token.balanceOf(contractAddress).sub(restrictedTeam);
300     token.transfer(restricted_address, allTokens);
301   }
302   
303   function getTeamTokens() public {
304     require(now > startSale + (180 * 1 days));
305     
306     token.transfer(restricted_address, restrictedTeam);
307   }
308     
309 }