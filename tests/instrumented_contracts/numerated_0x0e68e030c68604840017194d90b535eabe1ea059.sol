1 pragma solidity ^0.4.15;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal constant returns (uint256) {
12     // assert(b > 0); // Solidity automatically throws when dividing by 0
13     uint256 c = a / b;
14     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32 
33 
34   /**
35    * @dev The Ownable constructor sets the original `owner` of 
36    * the contract to the sender account.
37    */
38   function Ownable() {
39     owner = msg.sender;
40   }
41 
42 
43   /**
44    * @dev Throws if called by any account other than the owner.
45    */
46   modifier onlyOwner() {
47     require(msg.sender == owner);
48     _;
49   }
50 
51 
52   /**
53    * @dev Allows the current owner to transfer control of the
54    *    contract to a newOwner.
55    * @param newOwner The address to transfer ownership to.
56    */
57   function transferOwnership(address newOwner) onlyOwner {
58     require(newOwner != address(0));      
59     owner = newOwner;
60   }
61 
62 }
63 
64 contract ERC20Basic {
65   uint256 public totalSupply;
66   function balanceOf(address who) constant returns (uint256);
67   function transfer(address to, uint256 value) returns (bool);
68   event Transfer(address indexed from, address indexed to, uint256 value);
69 }
70 
71 contract ERC20 is ERC20Basic {
72   function allowance(address owner, address spender) constant returns (uint256);
73   function transferFrom(address from, address to, uint256 value) returns (bool);
74   function approve(address spender, uint256 value) returns (bool);
75   event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @title Basic token
80  * @dev Basic version of StandardToken, with no allowances. 
81  */
82 contract BasicToken is ERC20Basic {
83   using SafeMath for uint256;
84 
85   mapping(address => uint256) balances;
86 
87   /**
88   * @dev transfer token for a specified address
89   * @param _to The address to transfer to.
90   * @param _value The amount to be transferred.
91   */
92   function transfer(address _to, uint256 _value) returns (bool) {
93     balances[msg.sender] = balances[msg.sender].sub(_value);
94     balances[_to] = balances[_to].add(_value);
95     Transfer(msg.sender, _to, _value);
96     return true;
97   }
98 
99   /**
100   * @dev Gets the balance of the specified address.
101   * @param _owner The address to query the the balance of. 
102   * @return An uint256 representing the amount owned by the passed address.
103   */
104   function balanceOf(address _owner) constant returns (uint256 balance) {
105     return balances[_owner];
106   }
107 
108 }
109 
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  */
117 contract StandardToken is ERC20, BasicToken {
118 
119   mapping (address => mapping (address => uint256)) allowed;
120 
121 
122   /**
123    * @dev Transfer tokens from one address to another
124    * @param _from address The address which you want to send tokens from
125    * @param _to address The address which you want to transfer to
126    * @param _value uint256 the amount of tokens to be transferred
127    */
128   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
129 
130     var _allowance = allowed[_from][msg.sender];
131 
132     require (_value <= _allowance);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = _allowance.sub(_value);
137     Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified 
143    *      amount of tokens on behalf of msg.sender.
144    * @param _spender The address which will spend the funds.
145    * @param _value The amount of tokens to be spent.
146    */
147   function approve(address _spender, uint256 _value) returns (bool) {
148 
149     // To change the approve amount you first have to reduce the addresses`
150     //  allowance to zero by calling `approve(_spender, 0)` if it is not
151     //  already 0 to mitigate the race condition described here:
152     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
154 
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Function to check the amount of tokens that an owner allowed to a spender.
162    * @param _owner address The address which owns the funds.
163    * @param _spender address The address which will spend the funds.
164    * @return A uint256 specifying the amount of tokens still available for the spender.
165    */
166   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
167     return allowed[_owner][_spender];
168   }
169   
170 }
171 
172 
173 /**
174  * @title Crowdsale 
175  * @dev Crowdsale is a base contract for managing a token crowdsale.
176  * Crowdsales have a start and end timestamps, where investors can make
177  * token purchases and the crowdsale will assign them tokens based
178  * on a token per ETH rate. Funds collected are forwarded to a wallet 
179  * as they arrive.
180  */
181 contract Crowdsale is StandardToken, Ownable {
182   using SafeMath for uint256;
183 
184   string public constant name = "Blowjob";
185   string public constant symbol = "BJ";
186   uint8 public constant decimals = 2;
187   uint public constant INITIAL_SUPPLY = 1000000; // 10,000 tokens times 10 to the decimals
188 
189   // how many wei per token 
190   uint256 public constant rate = 100000000000000; // 0.0001 ether per 0.01 token
191 
192   string public site;
193 
194   string public why;
195 
196   address public wallet;
197 
198   // amount of raised money in wei
199   uint256 public weiRaised;
200 
201   function Crowdsale() {
202       totalSupply = INITIAL_SUPPLY;
203       balances[msg.sender] = INITIAL_SUPPLY;
204       weiRaised = 0;
205       owner = msg.sender;
206       wallet = 0x672f86bc2D6862C58648381AaeE561aDA192853C;
207       site = "www.blowjob.gratis";
208       why = "Give a blow job, get a blow job.";
209   }
210 
211   function setSink ( address sink ) onlyOwner {
212      require( sink != 0x0);
213      wallet = sink; 
214   }
215 
216   function Site ( string _site ) onlyOwner {
217       site = _site; 
218   }
219 
220   function Why( string _why ) onlyOwner {
221       why = _why; 
222   }
223 
224 
225   /**
226    * event for token purchase logging
227    * @param purchaser who paid for the tokens
228    * @param beneficiary who got the tokens
229    * @param value weis paid for purchase
230    * @param amount amount of tokens purchased
231    */ 
232   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
233 
234 
235   // fallback function can be used to buy tokens
236   function () payable {
237     buyTokens(msg.sender);
238   }
239 
240   // low level token purchase function
241   function buyTokens(address beneficiary) payable {
242     require(beneficiary != 0x0);
243     require(msg.value > 0);
244 
245     uint256 weiAmount = msg.value;
246 
247     // calculate token amount to be created
248     uint256 tokens = weiAmount.div(rate);
249 
250     // update state
251     weiRaised = weiRaised.add(weiAmount);
252 
253     totalSupply = totalSupply.add(tokens);
254     balances[beneficiary] = balances[beneficiary].add(tokens);
255     wallet.transfer(msg.value);
256 
257     Transfer(0x0, beneficiary, tokens);
258     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
259   }
260 
261 }