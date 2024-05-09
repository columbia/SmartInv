1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title NeuralTrade Network Tokensale Contract
5  * @dev Symbol: Network
6  * @dev Name: NeuralTrade Token
7  * @dev Total Supply: 10000000
8  * @dev Decimals: 2
9  * @dev (c) by NeuralTrade Network
10  */
11 contract ERC20Basic {
12   uint256 public totalSupply;
13   function balanceOf(address who) public constant returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 /**
19  * @title ERC20 interface
20  */
21 contract ERC20 is ERC20Basic {
22   function allowance(address owner, address spender) public constant returns (uint256);
23   function transferFrom(address from, address to, uint256 value) public returns (bool);
24   function approve(address spender, uint256 value) public returns (bool);
25   event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 /**
29  * @title SafeMath
30  * @dev Math operations with safety checks that throw on error
31  */
32 library SafeMath {
33   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34     uint256 c = a * b;
35     assert(a == 0 || c / a == b);
36     return c;
37   }
38 
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     // assert(b > 0); // Solidity automatically throws when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43     return c;
44   }
45 
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     assert(b <= a);
48     return a - b;
49   }
50 
51   function add(uint256 a, uint256 b) internal pure returns (uint256) {
52     uint256 c = a + b; assert(c >= a);
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
73   function transfer(address _to, uint256 _value) public returns (bool) {
74     require(_to != address(0));
75     require(_value <= balances[msg.sender]);
76     // SafeMath.sub will throw if there is not enough balance.
77     balances[msg.sender] = balances[msg.sender].sub(_value);
78     balances[_to] = balances[_to].add(_value);
79     emit Transfer(msg.sender, _to, _value);
80     return true;
81   }
82 
83   /**
84    * @dev Gets the balance of the specified address.
85    * @param _owner The address to query the the balance of.
86    * @return An uint256 representing the amount owned by the passed address.
87    */
88   function balanceOf(address _owner) public constant returns (uint256 balance) {
89     return balances[_owner];
90   }
91 }
92 
93 /**
94  * @title Standard ERC20 token
95  *
96  * @dev Implementation of the basic standard token.
97  */
98 contract StandardToken is ERC20, BasicToken {
99 
100   mapping (address => mapping (address => uint256)) internal allowed;
101 
102   /**
103    * @dev Transfer tokens from one address to another
104    * @param _from address The address which you want to send tokens from
105    * @param _to address The address which you want to transfer to
106    * @param _value uint256 the amount of tokens to be transferred
107    */
108   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
109     require(_to != address(0));
110     require(_value <= balances[_from]);
111     require(_value <= allowed[_from][msg.sender]);
112     balances[_from] = balances[_from].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
115     emit Transfer(_from, _to, _value);
116     return true;
117   }
118 
119  /**
120   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
121   * @param _spender The address which will spend the funds.
122   * @param _value The amount of tokens to be spent.
123   */
124   function approve(address _spender, uint256 _value) public returns (bool) {
125     allowed[msg.sender][_spender] = _value;
126     emit Approval(msg.sender, _spender, _value);
127     return true;
128   }
129 
130  /**
131   * @dev Function to check the amount of tokens that an owner allowed to a spender.
132   * @param _owner address The address which owns the funds.
133   * @param _spender address The address which will spend the funds.
134   * @return A uint256 specifying the amount of tokens still available for the spender.
135   */
136   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
137     return allowed[_owner][_spender];
138   }
139 
140  /**
141   * approve should be called when allowed[_spender] == 0. To increment
142   * allowed value is better to use this function to avoid 2 calls (and wait until
143   * the first transaction is mined)
144   */
145   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
146     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
147     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
148     return true;
149   }
150 
151   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
152     uint oldValue = allowed[msg.sender][_spender];
153     if (_subtractedValue > oldValue) {
154       allowed[msg.sender][_spender] = 0;
155     } else {
156       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
157     }
158     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
159     return true;
160   }
161 
162   function () public payable {
163     revert();
164   }
165 
166 }
167 
168 /**
169  * @title Owned
170  */
171 contract Owned {
172   address public owner;
173 
174 
175   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177   constructor() public {
178     owner = msg.sender;
179   }
180 
181 
182   modifier onlyOwner() {
183     require(msg.sender == owner);
184     _;
185   }
186 
187 
188   function transferOwnership(address newOwner) onlyOwner public {
189     require(newOwner != address(0));
190     emit OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 
194 }
195 
196 /**
197  * @title Burnable Token
198  * @dev Token that can be irreversibly burned (destroyed).
199  */
200 
201 contract BurnableToken is StandardToken, Owned {
202 
203   /**
204   * @dev Burns a specific amount of tokens.
205   * @param _value The amount of token to be burned.
206   */
207 
208   function burn(uint _value) public {
209     require(_value > 0);
210     address burner = msg.sender;
211     balances[burner] = balances[burner].sub(_value);
212     totalSupply = totalSupply.sub(_value);
213     emit Burn(burner, _value);
214   }
215 
216   event Burn(address indexed burner, uint indexed value);
217 
218 }
219 
220 contract NeuralTradeToken is BurnableToken {
221 
222     string public constant name = "Neural Trade Token";
223 
224     string public constant symbol = "NET";
225 
226     uint32 public constant decimals = 2;
227 
228     uint256 public INITIAL_SUPPLY = 10000000 * 1 ether;
229 
230     constructor() public {
231       totalSupply = INITIAL_SUPPLY;
232       balances[msg.sender] = INITIAL_SUPPLY;
233     }
234 
235 }
236 
237 contract NETCrowdsale is Owned {
238    using SafeMath for uint;
239 
240     address vaulted;
241 
242     uint restrictedPercent;
243 
244     address restricted;
245 
246     NeuralTradeToken public token = new NeuralTradeToken();
247 
248     uint start;
249 
250     uint period = 140;
251 
252     uint hardcap;
253 
254     uint rate;
255 
256     uint minPurchase;
257 
258     uint earlyBirdBonus;
259 
260     constructor() public payable {
261         owner = msg.sender;
262         vaulted = 0xD1eA8ACE84C56BF21a1b481Ca492b6aA65D95830;
263         restricted = 0xBbC18b0824709Fd3E0fA3aF49b812E5B6efAC3c1;
264         restrictedPercent = 50;
265         rate = 100000000000000000000;
266         start = 1549843200;
267         period = 140;
268         minPurchase = 0.1 ether;
269         earlyBirdBonus = 1 ether;
270     }
271 
272     modifier saleIsOn() {
273     	require(now > start && now < start + period * 1 days);
274     	_;
275     }
276 
277     modifier purchaseAllowed() {
278         require(msg.value >= minPurchase);
279         _;
280     }
281 
282     function createTokens() saleIsOn purchaseAllowed public payable {
283         vaulted.transfer(msg.value);
284         uint tokens = rate.mul(msg.value).div(1 ether);
285         uint bonusTokens = 0;
286         if(now < start + (period * 1 days).div(10) && msg.value >= earlyBirdBonus) {
287           bonusTokens = tokens.div(1);
288         } else if(now < start + (period * 1 days).div(10).mul(2)) {
289           bonusTokens = tokens.div(2);
290         } else if(now >= start + (period * 1 days).div(10).mul(2) && now < start + (period * 1 days).div(10).mul(4)) {
291           bonusTokens = tokens.div(4);
292         } else if(now >= start + (period * 1 days).div(10).mul(4) && now < start + (period * 1 days).div(10).mul(8)) {
293           bonusTokens = tokens.div(5);
294         }
295         uint tokensWithBonus = tokens.add(bonusTokens);
296         token.transfer(msg.sender, tokensWithBonus);
297 
298         uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
299         token.transfer(restricted, restrictedTokens);
300 
301         if(msg.data.length == 20) {
302           address referer = bytesToAddress(bytes(msg.data));
303           require(referer != msg.sender);
304           uint refererTokens = tokens.mul(10).div(100);
305           token.transfer(referer, refererTokens);
306         }
307     }
308 
309     function bytesToAddress(bytes source) internal pure returns(address) {
310         uint result;
311         uint mul = 1;
312         for(uint i = 20; i > 0; i--) {
313           result += uint8(source[i-1])*mul;
314           mul = mul*256;
315         }
316         return address(result);
317     }
318 
319     function() external payable {
320         createTokens();
321     }
322 
323 }