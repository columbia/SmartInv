1 /**
2  *Submitted for verification at Etherscan.io on 2018-06-20
3 */
4 
5 pragma solidity ^0.4.18;
6 
7 /**
8  * @title ERC20Basic
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 /**
18  * @title ERC20 interface
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender) public constant returns (uint256);
22   function transferFrom(address from, address to, uint256 value) public returns (bool);
23   function approve(address spender, uint256 value) public returns (bool);
24   event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     
33   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal constant returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a + b;
53     assert(c >= a);
54     return c;
55   }
56   
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
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97   mapping (address => mapping (address => uint256)) allowed;
98 
99   /**
100    * @dev Transfer tokens from one address to another
101    * @param _from address The address which you want to send tokens from
102    * @param _to address The address which you want to transfer to
103    * @param _value uint256 the amout of tokens to be transfered
104    */
105   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
106     var _allowance = allowed[_from][msg.sender];
107 
108     balances[_to] = balances[_to].add(_value);
109     balances[_from] = balances[_from].sub(_value);
110     allowed[_from][msg.sender] = _allowance.sub(_value);
111     Transfer(_from, _to, _value);
112     return true;
113   }
114 
115   /**
116    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
117    * @param _spender The address which will spend the funds.
118    * @param _value The amount of tokens to be spent.
119    */
120   function approve(address _spender, uint256 _value) public returns (bool) {
121 
122     // To change the approve amount you first have to reduce the addresses`
123     //  allowance to zero by calling `approve(_spender, 0)` if it is not
124     //  already 0 to mitigate the race condition described here:
125     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
126     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
127 
128     allowed[msg.sender][_spender] = _value;
129     Approval(msg.sender, _spender, _value);
130     return true;
131   }
132 
133   /**
134    * @dev Function to check the amount of tokens that an owner allowed to a spender.
135    * @param _owner address The address which owns the funds.
136    * @param _spender address The address which will spend the funds.
137    * @return A uint256 specifing the amount of tokens still available for the spender.
138    */
139   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
140     return allowed[_owner][_spender];
141   }
142 
143 }
144 
145 /**
146  * @title Ownable
147  * @dev The Ownable contract has an owner address, and provides basic authorization control
148  * functions, this simplifies the implementation of "user permissions".
149  */
150 contract Ownable {
151     
152   address public owner;
153 
154   /**
155    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
156    * account.
157    */
158   function Ownable() {
159     owner = msg.sender;
160   }
161 
162   /**
163    * @dev Throws if called by any account other than the owner.
164    */
165   modifier onlyOwner() {
166     require(msg.sender == owner);
167     _;
168   }
169 
170   /**
171    * @dev Allows the current owner to transfer control of the contract to a newOwner.
172    * @param newOwner The address to transfer ownership to.
173    */
174   function transferOwnership(address newOwner) onlyOwner {
175     require(newOwner != address(0));      
176     owner = newOwner;
177   }
178 
179 }
180 
181 contract AgrolotToken is StandardToken {
182     
183   string public constant name = "Agrolot Token";
184    
185   string public constant symbol = "AGLT";
186     
187   uint32 public constant decimals = 18;
188 
189   uint256 public INITIAL_SUPPLY = 100000000 * 1 ether;
190 
191   function AgrolotToken() {
192     totalSupply = INITIAL_SUPPLY;
193     balances[msg.sender] = INITIAL_SUPPLY;
194   }
195     
196 }
197 
198 contract Crowdsale is Ownable {
199     
200   using SafeMath for uint;
201     
202   address multisig;
203 
204   uint restrictedTeam;
205   
206   uint restrictedVIA;
207   
208   uint restrictedAirdrop;
209 
210   address restricted_address;
211   
212   address airdropAddress;
213 
214   AgrolotToken public token = new AgrolotToken();
215 
216   uint public minPaymentWei = 0.1 ether;
217     
218   uint public maxCapTokenPresale;
219   
220   uint public maxCapTokenTotal;
221   
222   uint public totalTokensSold;
223   
224   uint public totalWeiReceived;
225   
226   uint startPresale;
227     
228   uint periodPresale;
229   
230   uint startSale;
231     
232   uint periodSale;
233 
234   uint rate;
235 
236   function Crowdsale() {
237     multisig = 0x7c8Ef6E9437E8B1554dCd22a00AB1B3a709998d9;
238     restricted_address = 0x3a5d3146Cd9f1157F2d36488B99429500A257b13;
239     airdropAddress = 0xe86AC25B3d2fe81951A314BA1042Fc17A096F3a2;
240     restrictedTeam = 20000000 * 1 ether;
241     restrictedVIA = 45250000 * 1 ether;
242     restrictedAirdrop = 1250000 * 1 ether;
243     rate = 530 * 1 ether;
244     maxCapTokenPresale = 3000000 * 1 ether;
245     maxCapTokenTotal = 23000000 * 1 ether;
246     
247     startPresale = 1529496000;
248     periodPresale = 10;
249     
250     startSale = 1530446400;
251     periodSale = 90;
252     
253     token.transfer(airdropAddress, restrictedAirdrop);
254     
255     //privatesale 
256     token.transfer(0xA44ceA410e7D1100e05bC8CDe6C63cee947A28f7, 1500000 * 1 ether);
257     token.transfer(0x4d044d2921e25Abda8D279d21FED919fB150F8C8, 600000 * 1 ether);
258     token.transfer(0x076A7E0A69Da48ac928508c1ac0E9cDCeDCeE903, 350000 * 1 ether);
259     token.transfer(0x60a7536b58ba2BEBB25165c09E39365c9d7Fb49A, 800000 * 1 ether);
260     token.transfer(0x41B05379ba55954D9e1Db10fd464cEc6cA8b085D, 750000 * 1 ether);
261 
262   }
263 
264   modifier saleIsOn() {
265     require ((now > startPresale && now < startPresale + (periodPresale * 1 days)) || (now > startSale && now < startSale + (periodSale * 1 days)));
266     
267     _;
268   }
269 
270   function createTokens() saleIsOn payable {
271     require(msg.value >= minPaymentWei);
272     uint tokens = rate.mul(msg.value).div(1 ether);
273     uint bonusTokens = 0;
274     if (now <= startPresale + (periodPresale * 1 days)) {
275         require(totalTokensSold.add(tokens) <= maxCapTokenPresale);
276         bonusTokens = tokens.div(100).mul(50);
277     } else {
278         require(totalTokensSold.add(tokens) <= maxCapTokenTotal);
279         if(now < startSale + (15 * 1 days)) {
280             bonusTokens = tokens.div(100).mul(25);
281         } else if(now < startSale + (25 * 1 days)) {
282             bonusTokens = tokens.div(100).mul(15);
283         } else if(now < startSale + (35 * 1 days)) {
284             bonusTokens = tokens.div(100).mul(7);
285         }
286     }
287 
288     totalTokensSold = totalTokensSold.add(tokens);
289     totalWeiReceived = totalWeiReceived.add(msg.value);
290     uint tokensWithBonus = tokens.add(bonusTokens);
291     multisig.transfer(msg.value);
292     token.transfer(msg.sender, tokensWithBonus);
293   }
294 
295   function() external payable {
296     createTokens();
297   }
298   
299  
300   function getVIATokens() public {
301     require(now > startSale + (91 * 1 days));
302     address contractAddress = address(this);
303     uint allTokens = token.balanceOf(contractAddress).sub(restrictedTeam);
304     token.transfer(restricted_address, allTokens);
305   }
306   
307   function getTeamTokens() public {
308     require(now > startSale + (180 * 1 days));
309     
310     token.transfer(restricted_address, restrictedTeam);
311   }
312     
313 }