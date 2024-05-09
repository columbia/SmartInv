1 pragma solidity ^0.4.11;
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
29 
30 /**
31  * @title ERC20Basic
32  * @dev Simpler version of ERC20 interface
33  * @dev see https://github.com/ethereum/EIPs/issues/179
34  */
35 contract ERC20Basic {
36   uint256 public totalSupply;
37   function balanceOf(address who) constant returns (uint256);
38   function transfer(address to, uint256 value) returns (bool);
39   event Transfer(address indexed from, address indexed to, uint256 value);
40 }
41 
42 
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49 
50   /**
51    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
52    * account.
53    */
54   function Ownable() {
55     owner = msg.sender;
56   }
57 
58 
59   /**
60    * @dev Throws if called by any account other than the owner.
61    */
62   modifier onlyOwner() {
63     require(msg.sender == owner);
64     _;
65   }
66 
67 
68   /**
69    * @dev Allows the current owner to transfer control of the contract to a newOwner.
70    * @param newOwner The address to transfer ownership to.
71    */
72   function transferOwnership(address newOwner) onlyOwner {
73     require(newOwner != address(0));
74     OwnershipTransferred(owner, newOwner);
75     owner = newOwner;
76   }
77 
78 }
79 
80 
81 
82 /**
83  * @title ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/20
85  */
86 contract ERC20 is ERC20Basic {
87   function allowance(address owner, address spender) constant returns (uint256);
88   function transferFrom(address from, address to, uint256 value) returns (bool);
89   function approve(address spender, uint256 value) returns (bool);
90   event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) returns (bool) {
105     require(_to != address(0));
106 
107     // SafeMath.sub will throw if there is not enough balance.
108     balances[msg.sender] = balances[msg.sender].sub(_value);
109     balances[_to] = balances[_to].add(_value);
110     Transfer(msg.sender, _to, _value);
111     return true;
112   }
113 
114   /**
115   * @dev Gets the balance of the specified address.
116   * @param _owner The address to query the the balance of.
117   * @return An uint256 representing the amount owned by the passed address.
118   */
119   function balanceOf(address _owner) constant returns (uint256 balance) {
120     return balances[_owner];
121   }
122 
123 }
124 
125 
126 contract StandardToken is ERC20, BasicToken {
127 
128   mapping (address => mapping (address => uint256)) allowed;
129 
130 
131   /**
132    * @dev Transfer tokens from one address to another
133    * @param _from address The address which you want to send tokens from
134    * @param _to address The address which you want to transfer to
135    * @param _value uint256 the amount of tokens to be transferred
136    */
137   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
138     require(_to != address(0));
139 
140     var _allowance = allowed[_from][msg.sender];
141 
142     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
143     // require (_value <= _allowance);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = _allowance.sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    * @param _spender The address which will spend the funds.
155    * @param _value The amount of tokens to be spent.
156    */
157   function approve(address _spender, uint256 _value) returns (bool) {
158 
159     // To change the approve amount you first have to reduce the addresses`
160     //  allowance to zero by calling `approve(_spender, 0)` if it is not
161     //  already 0 to mitigate the race condition described here:
162     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
163     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
164 
165     allowed[msg.sender][_spender] = _value;
166     Approval(msg.sender, _spender, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Function to check the amount of tokens that an owner allowed to a spender.
172    * @param _owner address The address which owns the funds.
173    * @param _spender address The address which will spend the funds.
174    * @return A uint256 specifying the amount of tokens still available for the spender.
175    */
176   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
177     return allowed[_owner][_spender];
178   }
179 
180   /**
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    */
186   function increaseApproval (address _spender, uint _addedValue)
187     returns (bool success) {
188     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
189     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
190     return true;
191   }
192 
193   function decreaseApproval (address _spender, uint _subtractedValue)
194     returns (bool success) {
195     uint oldValue = allowed[msg.sender][_spender];
196     if (_subtractedValue > oldValue) {
197       allowed[msg.sender][_spender] = 0;
198     } else {
199       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
200     }
201     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
202     return true;
203   }
204 
205 }
206 
207 
208 contract MintableToken is StandardToken, Ownable {
209   event Mint(address indexed to, uint256 amount);
210   event MintFinished();
211 
212   bool public mintingFinished = false;
213 
214 
215   modifier canMint() {
216     require(!mintingFinished);
217     _;
218   }
219 
220   /**
221    * @dev Function to mint tokens
222    * @param _to The address that will receive the minted tokens.
223    * @param _amount The amount of tokens to mint.
224    * @return A boolean that indicates if the operation was successful.
225    */
226   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
227     totalSupply = totalSupply.add(_amount);
228     balances[_to] = balances[_to].add(_amount);
229     Mint(_to, _amount);
230     Transfer(0x0, _to, _amount);
231     return true;
232   }
233 
234   /**
235    * @dev Function to stop minting new tokens.
236    * @return True if the operation was successful.
237    */
238   function finishMinting() onlyOwner returns (bool) {
239     mintingFinished = true;
240     MintFinished();
241     return true;
242   }
243 }
244 
245 contract PrymexToken is MintableToken {
246   string public constant name = "PrymexToken";
247   string public constant symbol = "PRX";
248   uint8 public constant decimals = 18;
249 }
250 
251 contract PrymexPreICOCrowdsale is Ownable {
252 
253   using SafeMath for uint256;
254 
255   PrymexToken public token;
256 
257   uint256 public startTime;
258   uint256 public endTime;
259 
260   address public wallet;
261 
262   uint256 public rate;
263 
264   uint256 public weiRaised;
265 
266   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
267 
268   function PrymexPreICOCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _rate, address _wallet) {
269     // require(_startTime >= now);
270     require(_endTime >= _startTime);
271     require(_rate > 0);
272     require(_wallet != 0x0);
273 
274     token = createTokenContract();
275     startTime = _startTime;
276     endTime = _endTime;
277     rate = _rate;
278     wallet = _wallet;
279   }
280 
281   function createTokenContract() internal returns (PrymexToken) {
282     return new PrymexToken();
283   }
284 
285   function () payable {
286     buyTokens(msg.sender);
287   }
288 
289   function buyTokens(address beneficiary) payable {
290     require(beneficiary != 0x0);
291     require(validPurchase());
292 
293     uint256 weiAmount = msg.value;
294     uint256 tokens = weiAmount.mul(rate);
295     weiRaised = weiRaised.add(weiAmount);
296 
297     token.mint(beneficiary, tokens);
298     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
299 
300     forwardFunds();
301   }
302 
303   function forwardFunds() internal {
304     wallet.transfer(msg.value);
305   }
306 
307   function validPurchase() internal constant returns (bool) {
308     bool withinPeriod = now >= startTime && now <= endTime;
309     bool nonZeroPurchase = msg.value != 0;
310     return withinPeriod && nonZeroPurchase;
311   }
312 
313   function hasEnded() public constant returns (bool) {
314     return now > endTime;
315   }
316 
317   function closeAndTransferTokenOwnership() onlyOwner {
318     require(now > endTime);
319     // reserve for a team
320     uint256 toMint = token.totalSupply().mul(15).div(100);
321     token.mint(owner, toMint);
322     // transfer of ownership
323     token.transferOwnership(owner);
324   }
325 
326 }