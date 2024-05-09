1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title NeuralTrade Network Tokensale Contract
5  * @dev Deployed from 0x66efaB36d7f1f1EfDF4f3F9C0F2711DDe7CbE16B
6  * @dev Symbol: NET
7  * @dev Name: NeuralTrade Token
8  * @dev Total Supply: 10000000
9  * @dev Decimals: 2
10  * @dev (c) by NeuralTrade Network
11  */
12 contract ERC20Basic {
13   uint256 public totalSupply;
14   function balanceOf(address who) public constant returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 /**
20  * @title ERC20 interface
21  */
22 contract ERC20 is ERC20Basic {
23   function allowance(address owner, address spender) public constant returns (uint256);
24   function transferFrom(address from, address to, uint256 value) public returns (bool);
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 /**
30  * @title SafeMath
31  * @dev Math operations with safety checks that throw on error
32  */
33 library SafeMath {
34   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
35     uint256 c = a * b;
36     assert(a == 0 || c / a == b);
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
53     uint256 c = a + b; assert(c >= a);
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
75     require(_to != address(0));
76     require(_value <= balances[msg.sender]);
77     // SafeMath.sub will throw if there is not enough balance.
78     balances[msg.sender] = balances[msg.sender].sub(_value);
79     balances[_to] = balances[_to].add(_value);
80     emit Transfer(msg.sender, _to, _value);
81     return true;
82   }
83 
84   /**
85    * @dev Gets the balance of the specified address.
86    * @param _owner The address to query the the balance of.
87    * @return An uint256 representing the amount owned by the passed address.
88    */
89   function balanceOf(address _owner) public constant returns (uint256 balance) {
90     return balances[_owner];
91   }
92 }
93 
94 /**
95  * @title Standard ERC20 token
96  *
97  * @dev Implementation of the basic standard token.
98  */
99 contract StandardToken is ERC20, BasicToken {
100 
101   mapping (address => mapping (address => uint256)) internal allowed;
102 
103   /**
104    * @dev Transfer tokens from one address to another
105    * @param _from address The address which you want to send tokens from
106    * @param _to address The address which you want to transfer to
107    * @param _value uint256 the amount of tokens to be transferred
108    */
109   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
110     require(_to != address(0));
111     require(_value <= balances[_from]);
112     require(_value <= allowed[_from][msg.sender]);
113     balances[_from] = balances[_from].sub(_value);
114     balances[_to] = balances[_to].add(_value);
115     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
116     emit Transfer(_from, _to, _value);
117     return true;
118   }
119 
120  /**
121   * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
122   * @param _spender The address which will spend the funds.
123   * @param _value The amount of tokens to be spent.
124   */
125   function approve(address _spender, uint256 _value) public returns (bool) {
126     allowed[msg.sender][_spender] = _value;
127     emit Approval(msg.sender, _spender, _value);
128     return true;
129   }
130 
131  /**
132   * @dev Function to check the amount of tokens that an owner allowed to a spender.
133   * @param _owner address The address which owns the funds.
134   * @param _spender address The address which will spend the funds.
135   * @return A uint256 specifying the amount of tokens still available for the spender.
136   */
137   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
138     return allowed[_owner][_spender];
139   }
140 
141  /**
142   * approve should be called when allowed[_spender] == 0. To increment
143   * allowed value is better to use this function to avoid 2 calls (and wait until
144   * the first transaction is mined)
145   */
146   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163   function () public payable {
164     revert();
165   }
166 
167 }
168 
169 /**
170  * @title Owned
171  */
172 contract Owned {
173   address public owner;
174 
175   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 
177   constructor() public {
178     owner = msg.sender;
179   }
180 
181   modifier onlyOwner() {
182     require(msg.sender == owner);
183     _;
184   }
185 
186   function transferOwnership(address newOwner) onlyOwner public {
187     require(newOwner != address(0));
188     emit OwnershipTransferred(owner, newOwner);
189     owner = newOwner;
190   }
191 
192 }
193 
194 /**
195  * @title Burnable Token
196  * @dev Token that can be irreversibly burned (destroyed).
197  */
198 
199 contract BurnableToken is StandardToken, Owned {
200 
201   /**
202   * @dev Burns a specific amount of tokens.
203   * @param _value The amount of token to be burned.
204   */
205 
206   function burn(uint _value) public {
207     require(_value > 0);
208     address burner = msg.sender;
209     balances[burner] = balances[burner].sub(_value);
210     totalSupply = totalSupply.sub(_value);
211     emit Burn(burner, _value);
212   }
213 
214   event Burn(address indexed burner, uint indexed value);
215 
216 }
217 
218 contract NeuralTradeToken is BurnableToken {
219 
220     string public constant name = "Neural Trade Token";
221 
222     string public constant symbol = "NET";
223 
224     uint32 public constant decimals = 2;
225 
226     uint256 public INITIAL_SUPPLY = 10000000 * 1 ether;
227 
228     constructor() public {
229       totalSupply = INITIAL_SUPPLY;
230       balances[msg.sender] = INITIAL_SUPPLY;
231     }
232 
233 }
234 
235 contract NETCrowdsale is Owned {
236    using SafeMath for uint;
237 
238     address vaulted;
239 
240     uint restrictedPercent;
241 
242     address restricted;
243 
244     NeuralTradeToken public token = new NeuralTradeToken();
245 
246     uint start;
247 
248     uint period = 140;
249 
250     uint hardcap;
251 
252     uint rate;
253 
254     uint minPurchase;
255 
256     uint earlyBirdBonus;
257 
258     constructor() public payable {
259         owner = msg.sender;
260         vaulted = 0xbffCFc20D314333B9Ff92fb157A6bd6dA4474A2E;
261         restricted = 0x9c3730239B2AB9B9575F093dF593867041f777dF;
262         restrictedPercent = 50;
263         rate = 100;
264         start = 1550448000;
265         period = 140;
266         minPurchase = 0.1 ether;
267         earlyBirdBonus = 1 ether;
268     }
269 
270     modifier saleIsOn() {
271     	require(now > start && now < start + period * 1 days);
272     	_;
273     }
274 
275     modifier purchaseAllowed() {
276         require(msg.value >= minPurchase);
277         _;
278     }
279 
280     function createTokens() saleIsOn purchaseAllowed public payable {
281         vaulted.transfer(msg.value);
282         uint tokens = rate.mul(msg.value).div(1 ether);
283         uint bonusTokens = 0;
284         if(now < start + (period * 1 days).div(10) && msg.value >= earlyBirdBonus) {
285           bonusTokens = tokens.div(1);
286         } else if(now < start + (period * 1 days).div(10).mul(2)) {
287           bonusTokens = tokens.div(2);
288         } else if(now >= start + (period * 1 days).div(10).mul(2) && now < start + (period * 1 days).div(10).mul(4)) {
289           bonusTokens = tokens.div(4);
290         } else if(now >= start + (period * 1 days).div(10).mul(4) && now < start + (period * 1 days).div(10).mul(8)) {
291           bonusTokens = tokens.div(5);
292         }
293         uint tokensWithBonus = tokens.add(bonusTokens);
294         token.transfer(msg.sender, tokensWithBonus);
295 
296         uint restrictedTokens = tokens.mul(restrictedPercent).div(100 - restrictedPercent);
297         token.transfer(restricted, restrictedTokens);
298 
299         if(msg.data.length == 20) {
300           address referer = bytesToAddress(bytes(msg.data));
301           require(referer != msg.sender);
302           uint refererTokens = tokens.mul(10).div(100);
303           token.transfer(referer, refererTokens);
304         }
305     }
306 
307     function bytesToAddress(bytes source) internal pure returns(address) {
308         uint result;
309         uint mul = 1;
310         for(uint i = 20; i > 0; i--) {
311           result += uint8(source[i-1])*mul;
312           mul = mul*256;
313         }
314         return address(result);
315     }
316 
317     function() external payable {
318         createTokens();
319     }
320 
321 }