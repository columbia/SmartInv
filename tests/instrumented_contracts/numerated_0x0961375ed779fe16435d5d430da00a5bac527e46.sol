1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /**
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   function Ownable() {
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner.
44    */
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50 
51   /**
52    * @dev Allows the current owner to transfer control of the contract to a newOwner.
53    * @param newOwner The address to transfer ownership to.
54    */
55   function transferOwnership(address newOwner) onlyOwner {
56     if (newOwner != address(0)) {
57       owner = newOwner;
58     }
59   }
60 
61 }
62 
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) constant returns (uint256);
66   function transfer(address to, uint256 value) returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   /**
76   * @dev transfer token for a specified address
77   * @param _to The address to transfer to.
78   * @param _value The amount to be transferred.
79   */
80   function transfer(address _to, uint256 _value) returns (bool) {
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   /**
88   * @dev Gets the balance of the specified address.
89   * @param _owner The address to query the the balance of. 
90   * @return An uint256 representing the amount owned by the passed address.
91   */
92   function balanceOf(address _owner) constant returns (uint256 balance) {
93     return balances[_owner];
94   }
95 
96 }
97 
98 contract ERC20 is ERC20Basic {
99   function allowance(address owner, address spender) constant returns (uint256);
100   function transferFrom(address from, address to, uint256 value) returns (bool);
101   function approve(address spender, uint256 value) returns (bool);
102   event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 contract StandardToken is ERC20, BasicToken {
106 
107   mapping (address => mapping (address => uint256)) allowed;
108 
109 
110   /**
111    * @dev Transfer tokens from one address to another
112    * @param _from address The address which you want to send tokens from
113    * @param _to address The address which you want to transfer to
114    * @param _value uint256 the amout of tokens to be transfered
115    */
116   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
117     var _allowance = allowed[_from][msg.sender];
118 
119     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
120     // require (_value <= _allowance);
121 
122     balances[_to] = balances[_to].add(_value);
123     balances[_from] = balances[_from].sub(_value);
124     allowed[_from][msg.sender] = _allowance.sub(_value);
125     Transfer(_from, _to, _value);
126     return true;
127   }
128 
129   /**
130    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
131    * @param _spender The address which will spend the funds.
132    * @param _value The amount of tokens to be spent.
133    */
134   function approve(address _spender, uint256 _value) returns (bool) {
135 
136     // To change the approve amount you first have to reduce the addresses`
137     //  allowance to zero by calling `approve(_spender, 0)` if it is not
138     //  already 0 to mitigate the race condition described here:
139     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
141 
142     allowed[msg.sender][_spender] = _value;
143     Approval(msg.sender, _spender, _value);
144     return true;
145   }
146 
147   /**
148    * @dev Function to check the amount of tokens that an owner allowed to a spender.
149    * @param _owner address The address which owns the funds.
150    * @param _spender address The address which will spend the funds.
151    * @return A uint256 specifing the amount of tokens still avaible for the spender.
152    */
153   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
154     return allowed[_owner][_spender];
155   }
156 
157 }
158 
159 contract MintableToken is StandardToken, Ownable {
160   event Mint(address indexed to, uint256 amount);
161   event MintFinished();
162 
163   bool public mintingFinished = false;
164 
165 
166   modifier canMint() {
167     require(!mintingFinished);
168     _;
169   }
170 
171   /**
172    * @dev Function to mint tokens
173    * @param _to The address that will recieve the minted tokens.
174    * @param _amount The amount of tokens to mint.
175    * @return A boolean that indicates if the operation was successful.
176    */
177   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
178     totalSupply = totalSupply.add(_amount);
179     balances[_to] = balances[_to].add(_amount);
180     Mint(_to, _amount);
181     return true;
182   }
183 
184   /**
185    * @dev Function to stop minting new tokens.
186    * @return True if the operation was successful.
187    */
188   function finishMinting() onlyOwner returns (bool) {
189     mintingFinished = true;
190     MintFinished();
191     return true;
192   }
193 }
194 
195 contract Presale {
196     using SafeMath for uint256;
197 
198     // Miniml possible cap
199     uint256 public minimalCap;
200 
201     // Maximum possible cap
202     uint256 public maximumCap;
203 
204     // Presale token
205     Token public token;
206 
207     // Early bird ether
208     uint256 public early_bird_minimal;
209 
210     // Withdraw wallet
211     address public wallet;
212 
213     // Minimal token buy
214     uint256 public minimal_token_sell;
215 
216     // Token per ether
217     uint256 public wei_per_token;
218 
219     // start and end timestamp where investments are allowed (both inclusive)
220     uint256 public startTime;
221     uint256 public endTime;
222 
223 
224     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     function Presale(uint256 _startTime, address _wallet) {
228         require(_startTime >=  now);
229         require(_wallet != 0x0);
230 
231         token = new Token();
232         wallet = _wallet;
233         startTime = _startTime;
234         minimal_token_sell = 1e10;
235         endTime = _startTime + 86400 * 7;
236         wei_per_token = 62500000;  // 1e10 / 160
237         early_bird_minimal = 30e18;
238         maximumCap = 1875e18 / wei_per_token;
239         minimalCap = 350e18 / wei_per_token;
240     }
241 
242     /*
243      * @dev fallback for processing ether
244      */
245     function() payable {
246         return buyTokens(msg.sender);
247     }
248 
249     /*
250      * @dev calculate amount
251      * @return token amount that we should send to our dear investor
252      */
253     function calcAmount() internal returns (uint256) {
254         if (now < startTime && msg.value >= early_bird_minimal) {
255             return (msg.value / wei_per_token / 60) * 70;   
256         }
257         return msg.value / wei_per_token;
258     }
259 
260     /*
261      * @dev sell token and send to contributor address
262      * @param contributor address
263      */
264     function buyTokens(address contributor) payable {
265         uint256 amount = calcAmount();
266 
267         require(contributor != 0x0) ;
268         require(minimal_token_sell < amount);
269         require((token.totalSupply() + amount) <= maximumCap);
270         require(validPurchase());
271 
272         token.mint(contributor, amount);
273         TokenPurchase(0x0, contributor, msg.value, amount);
274         Transfer(0x0, contributor, amount);
275         wallet.transfer(msg.value);
276     }
277 
278     // @return user balance
279     function balanceOf(address _owner) constant returns (uint256 balance) {
280         return token.balanceOf(_owner);
281     }
282 
283     // @return true if the transaction can buy tokens
284     function validPurchase() internal constant returns (bool) {
285         bool withinPeriod = ((now >= startTime  || msg.value >= early_bird_minimal) && now <= endTime);
286         bool nonZeroPurchase = msg.value != 0;
287 
288         return withinPeriod && nonZeroPurchase;
289     }
290 
291     // @return true if crowdsale event has ended
292     function hasStarted() public constant returns (bool) {
293         return now >= startTime;
294     }
295 
296     // @return true if crowdsale event has ended
297     function hasEnded() public constant returns (bool) {
298         return now > endTime || token.totalSupply() == maximumCap;
299     }
300 
301 }
302 
303 contract Token is MintableToken {
304 
305     string public constant name = 'Privatix Presale';
306     string public constant symbol = 'PRIXY';
307     uint256 public constant decimals = 8;
308 
309     function transferFrom(address from, address to, uint256 value) returns (bool) {
310         revert();
311     }
312 
313     function transfer(address _to, uint256 _value) returns (bool) {
314         revert();
315     }
316 
317 }