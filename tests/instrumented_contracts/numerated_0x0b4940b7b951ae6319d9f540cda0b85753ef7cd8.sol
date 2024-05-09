1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Ownable
35  * @dev The Ownable contract has an owner address, and provides basic authorization control 
36  * functions, this simplifies the implementation of "user permissions". 
37  */
38 contract Ownable {
39   address public owner;
40 
41 
42   /** 
43    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
44    * account.
45    */
46   function Ownable() {
47     owner = msg.sender;
48   }
49 
50 
51   /**
52    * @dev Throws if called by any account other than the owner. 
53    */
54   modifier onlyOwner() {
55     require(msg.sender == owner);
56     _;
57   }
58 
59 
60   /**
61    * @dev Allows the current owner to transfer control of the contract to a newOwner.
62    * @param newOwner The address to transfer ownership to. 
63    */
64   function transferOwnership(address newOwner) onlyOwner {
65     if (newOwner != address(0)) {
66       owner = newOwner;
67     }
68   }
69 
70 }
71 
72 
73 /**
74  * @title ERC20Basic
75  * @dev Simpler version of ERC20 interface
76  * @dev see https://github.com/ethereum/EIPs/issues/179
77  */
78 contract ERC20Basic {
79   uint256 public totalSupply;
80   function balanceOf(address who) constant returns (uint256);
81   function transfer(address to, uint256 value) returns (bool);
82   event Transfer(address indexed from, address indexed to, uint256 value);
83 }
84 
85 /**
86  * @title Basic token
87  * @dev Basic version of StandardToken, with no allowances. 
88  */
89 contract BasicToken is ERC20Basic {
90   using SafeMath for uint256;
91 
92   mapping(address => uint256) balances;
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) returns (bool) {
100     balances[msg.sender] = balances[msg.sender].sub(_value);
101     balances[_to] = balances[_to].add(_value);
102     Transfer(msg.sender, _to, _value);
103     return true;
104   }
105 
106   /**
107   * @dev Gets the balance of the specified address.
108   * @param _owner The address to query the the balance of. 
109   * @return An uint256 representing the amount owned by the passed address.
110   */
111   function balanceOf(address _owner) constant returns (uint256 balance) {
112     return balances[_owner];
113   }
114 
115 }
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) constant returns (uint256);
124   function transferFrom(address from, address to, uint256 value) returns (bool);
125   function approve(address spender, uint256 value) returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  *
132  * @dev Implementation of the basic standard token.
133  * @dev https://github.com/ethereum/EIPs/issues/20
134  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
135  */
136 contract StandardToken is ERC20, BasicToken {
137 
138   mapping (address => mapping (address => uint256)) allowed;
139 
140 
141   /**
142    * @dev Transfer tokens from one address to another
143    * @param _from address The address which you want to send tokens from
144    * @param _to address The address which you want to transfer to
145    * @param _value uint256 the amout of tokens to be transfered
146    */
147   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
148     var _allowance = allowed[_from][msg.sender];
149 
150     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
151     // require (_value <= _allowance);
152 
153     balances[_to] = balances[_to].add(_value);
154     balances[_from] = balances[_from].sub(_value);
155     allowed[_from][msg.sender] = _allowance.sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * @param _spender The address which will spend the funds.
163    * @param _value The amount of tokens to be spent.
164    */
165   function approve(address _spender, uint256 _value) returns (bool) {
166 
167     // To change the approve amount you first have to reduce the addresses`
168     //  allowance to zero by calling `approve(_spender, 0)` if it is not
169     //  already 0 to mitigate the race condition described here:
170     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
171     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
172 
173     allowed[msg.sender][_spender] = _value;
174     Approval(msg.sender, _spender, _value);
175     return true;
176   }
177 
178   /**
179    * @dev Function to check the amount of tokens that an owner allowed to a spender.
180    * @param _owner address The address which owns the funds.
181    * @param _spender address The address which will spend the funds.
182    * @return A uint256 specifing the amount of tokens still avaible for the spender.
183    */
184   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
185     return allowed[_owner][_spender];
186   }
187 
188 }
189 
190 
191 /**
192  * @title Mintable token
193  * @dev Simple ERC20 Token example, with mintable token creation
194  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
195  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
196  */
197 
198 contract MintableToken is StandardToken, Ownable {
199   event Mint(address indexed to, uint256 amount);
200   event MintFinished();
201 
202   bool public mintingFinished = false;
203 
204 
205   modifier canMint() {
206     require(!mintingFinished);
207     _;
208   }
209 
210   /**
211    * @dev Function to mint tokens
212    * @param _to The address that will recieve the minted tokens.
213    * @param _amount The amount of tokens to mint.
214    * @return A boolean that indicates if the operation was successful.
215    */
216   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
217     totalSupply = totalSupply.add(_amount);
218     balances[_to] = balances[_to].add(_amount);
219     Mint(_to, _amount);
220     return true;
221   }
222 
223   /**
224    * @dev Function to stop minting new tokens.
225    * @return True if the operation was successful.
226    */
227   function finishMinting() onlyOwner returns (bool) {
228     mintingFinished = true;
229     MintFinished();
230     return true;
231   }
232 }
233 
234 contract XxxToken is MintableToken {
235     // Token Info.
236     string public constant name = "XXX Token";
237     string public constant symbol = "XXX";
238     uint8 public constant decimals = 18;
239 }
240 
241 contract XxxTokenSale is Ownable {
242     using SafeMath for uint256;
243 
244     // Sale period.
245     uint256 public startDate;
246     uint256 public endDate;
247 
248     // Cap USD 25mil @ 200 ETH/USD
249     uint256 public cap;
250 
251     // Address where funds are collected.
252     address public wallet;
253 
254     // Amount of raised money in wei.
255     uint256 public weiRaised;
256 
257     // Actual Token contract
258     XxxToken public token;
259 
260     // Event
261     event TokenPurchase(address indexed purchaser, address indexed beneficiary,
262                         uint256 value, uint256 amount);
263     event TokenReserveMinted(uint256 amount);
264 
265     // Modifiers
266     modifier initialized() {
267         require(address(token) != 0x0);
268         _;
269     }
270 
271     function XxxTokenSale() {
272     }
273 
274     function initialize(XxxToken _token, address _wallet,
275                         uint256 _start, uint256 _end,
276                         uint256 _cap) onlyOwner {
277         require(address(token) == address(0));
278         require(_token.owner() == address(this));
279         require(_start >= getCurrentTimestamp());
280         require(_start < _end);
281         require(_wallet != 0x0);
282 
283         token = _token;
284         wallet = _wallet;
285         startDate = _start;
286         endDate = _end;
287         cap = _cap;
288     }
289 
290     function getCurrentTimestamp() internal returns (uint256) {
291         return now;
292     }
293 
294     // fallback function can be used to buy tokens
295     function () payable {
296         buyTokens(msg.sender);
297     }
298 
299     function getRateAt(uint256 at) constant returns (uint256) {
300         if (at < startDate) {
301             return 0;
302         } else if (at < (startDate + 7 days)) {
303             return 2000;
304         } else if (at < (startDate + 14 days)) {
305             return 1800;
306         } else if (at < (startDate + 21 days)) {
307             return 1700;
308         } else if (at < (startDate + 28 days)) {
309             return 1600;
310         } else if (at < (startDate + 35 days)) {
311             return 1500;
312         } else if (at < (startDate + 49 days)) {
313             return 1400;
314         } else if (at < (startDate + 63 days)) {
315             return 1300;
316         } else if (at < (startDate + 77 days)) {
317             return 1200;
318         } else if (at <= endDate) {
319             return 1100;
320         } else {
321             return 0;
322         }
323     }
324 
325     function buyTokens(address beneficiary) payable {
326         require(beneficiary != 0x0);
327         require(msg.value != 0);
328         require(saleActive());
329 
330         uint256 weiAmount = msg.value;
331         uint256 updatedWeiRaised = weiRaised.add(weiAmount);
332 
333         // Can not exceed cap.
334         require(updatedWeiRaised <= cap);
335 
336         // calculate token amount to be created
337         uint256 actualRate = getRateAt(getCurrentTimestamp());
338         uint256 tokens = weiAmount.mul(actualRate);
339 
340         // Update state.
341         weiRaised = updatedWeiRaised;
342 
343         // Mint Token and give it to sender.
344         token.mint(beneficiary, tokens);
345         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
346 
347         // Forward the fund to fund collection wallet.
348         wallet.transfer(msg.value);
349     }
350 
351     function finalize() onlyOwner {
352         require(!saleActive());
353 
354         // Allocate 20% for AirPorn (for development, marketing, etc...)
355         uint256 xxxToReserve = SafeMath.div(token.totalSupply(), 5);
356         token.mint(wallet, xxxToReserve);
357         TokenReserveMinted(xxxToReserve);
358 
359         // Finish minting as we no longer want to mint any new token after the
360         // sale.
361         token.finishMinting();
362     }
363 
364     function saleActive() public constant returns (bool) {
365         return (getCurrentTimestamp() >= startDate &&
366                 getCurrentTimestamp() <= endDate && weiRaised < cap);
367     }
368 }