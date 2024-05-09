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
96  */
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) allowed;
100 
101   /**
102    * @dev Transfer tokens from one address to another
103    * @param _from address The address which you want to send tokens from
104    * @param _to address The address which you want to transfer to
105    * @param _value uint256 the amout of tokens to be transfered
106    */
107   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
108     var _allowance = allowed[_from][msg.sender];
109 
110     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
111     // require (_value <= _allowance);
112 
113     balances[_to] = balances[_to].add(_value);
114     balances[_from] = balances[_from].sub(_value);
115     allowed[_from][msg.sender] = _allowance.sub(_value);
116     Transfer(_from, _to, _value);
117     return true;
118   }
119 
120   /**
121    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
122    * @param _spender The address which will spend the funds.
123    * @param _value The amount of tokens to be spent.
124    */
125   function approve(address _spender, uint256 _value) returns (bool) {
126 
127     // To change the approve amount you first have to reduce the addresses`
128     //  allowance to zero by calling `approve(_spender, 0)` if it is not
129     //  already 0 to mitigate the race condition described here:
130     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
132 
133     allowed[msg.sender][_spender] = _value;
134     Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   /**
139    * @dev Function to check the amount of tokens that an owner allowed to a spender.
140    * @param _owner address The address which owns the funds.
141    * @param _spender address The address which will spend the funds.
142    * @return A uint256 specifing the amount of tokens still available for the spender.
143    */
144   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
145     return allowed[_owner][_spender];
146   }
147 
148 }
149 
150 /**
151  * @title Ownable
152  * @dev The Ownable contract has an owner address, and provides basic authorization control
153  * functions, this simplifies the implementation of "user permissions".
154  */
155 contract Ownable {
156     
157   address public owner;
158 
159   /**
160    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
161    * account.
162    */
163   function Ownable() {
164     owner = msg.sender;
165   }
166 
167   /**
168    * @dev Throws if called by any account other than the owner.
169    */
170   modifier onlyOwner() {
171     require(msg.sender == owner);
172     _;
173   }
174 
175   /**
176    * @dev Allows the current owner to transfer control of the contract to a newOwner.
177    * @param newOwner The address to transfer ownership to.
178    */
179   function transferOwnership(address newOwner) onlyOwner {
180     require(newOwner != address(0));      
181     owner = newOwner;
182   }
183 
184 }
185 
186 
187 contract MintableToken is StandardToken, Ownable {
188     
189   event Mint(address indexed to, uint256 amount);
190   
191   event MintFinished();
192 
193   bool public mintingFinished = false;
194 
195   modifier canMint() {
196     require(!mintingFinished);
197     _;
198   }
199 
200   /**
201    * @dev Function to mint tokens
202    * @param _to The address that will recieve the minted tokens.
203    * @param _amount The amount of tokens to mint.
204    * @return A boolean that indicates if the operation was successful.
205    */
206   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
207     totalSupply = totalSupply.add(_amount);
208     balances[_to] = balances[_to].add(_amount);
209     Mint(_to, _amount);
210     return true;
211   }
212 
213   /**
214    * @dev Function to stop minting new tokens.
215    * @return True if the operation was successful.
216    */
217   function finishMinting() onlyOwner returns (bool) {
218     mintingFinished = true;
219     MintFinished();
220     return true;
221   }
222   
223 }
224 
225 contract ChatTradersCoin is MintableToken {
226     
227     string public constant name = "Chat Traders Coin";
228     
229     string public constant symbol = "CTC";
230     
231     uint32 public constant decimals = 3;
232     
233 }
234 
235 
236 contract Crowdsale is Ownable {
237     
238     using SafeMath for uint;
239     
240     address multisig;
241 
242     ChatTradersCoin public token = new ChatTradersCoin();
243 
244     uint start;
245     
246     uint period;
247     
248     uint rate;
249 
250     function Crowdsale() {
251       multisig = 0xd951Fa6f1546d0979BB9fC671C40bB9027d31763;
252       start = 1518300000;
253       rate = 1000000;
254       period = 28;
255     }
256 
257     modifier saleIsOn() {
258       require(now > start && now < start + period * 1 days);
259       _;
260     }
261   
262 
263     function finishMinting() public onlyOwner {
264        uint issuedTokenSupply = token.totalSupply();
265        token.finishMinting();
266     }
267 
268    function createTokens() saleIsOn payable {
269         multisig.transfer(msg.value);
270         uint tokens = rate.mul(msg.value).div(1 ether);
271         uint bonusTokens = 0;
272         if(now < start + 3 days) {
273           bonusTokens = tokens.div(2);
274         } else if( (now >= start + 3 days) && (now < start + 7 days) ) {
275           bonusTokens = tokens.div(4);
276         } else if( (now >= start + 7 days) && (now < start + 14 days) ) {
277           bonusTokens = tokens.div(10);
278         }
279         tokens += bonusTokens;
280         token.mint(msg.sender, tokens);
281     }
282 
283     function() external payable {
284         createTokens();
285     }
286     
287 }