1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal returns (uint256) {
16     // assert(b > 0); // Solidity automatically throws when dividing by 0
17     uint256 c = a / b;
18     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 
34 contract ERC20Basic {
35   uint256 public totalSupply;
36   function balanceOf(address who) constant returns (uint256);
37   function transfer(address to, uint256 value) returns (bool);
38   event Transfer(address indexed from, address indexed to, uint256 value);
39 }
40 
41 contract ERC20 is ERC20Basic {
42   function allowance(address owner, address spender) constant returns (uint256);
43   function transferFrom(address from, address to, uint256 value) returns (bool);
44   function approve(address spender, uint256 value) returns (bool);
45   event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 contract BasicToken is ERC20Basic {
49   using SafeMath for uint256;
50 
51   mapping(address => uint256) balances;
52 
53   /**
54   * @dev transfer token for a specified address
55   * @param _to The address to transfer to.
56   * @param _value The amount to be transferred.
57   */
58   function transfer(address _to, uint256 _value) returns (bool) {
59     balances[msg.sender] = balances[msg.sender].sub(_value);
60     balances[_to] = balances[_to].add(_value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63   }
64 
65 
66 //burn tokens from sender balance
67 //function burn(uint256 _value){
68 //    require( balances[msg.sender] >= _value);
69  //   balances[msg.sender] = balances[msg.sender].sub(_value);
70  //   totalSupply = totalSupply.sub(_value);
71  //   Burn (msg.sender, _value);
72  // }
73 
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of. 
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) constant returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) allowed;
90 
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
99     var _allowance = allowed[_from][msg.sender];
100 
101     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
102     // require (_value <= _allowance);
103 
104     balances[_from] = balances[_from].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     allowed[_from][msg.sender] = _allowance.sub(_value);
107     Transfer(_from, _to, _value);
108     return true;
109   }
110 
111   /**
112    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
113    * @param _spender The address which will spend the funds.
114    * @param _value The amount of tokens to be spent.
115    */
116   function approve(address _spender, uint256 _value) returns (bool) {
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
133    * @return A uint256 specifying the amount of tokens still available for the spender.
134    */
135   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
136     return allowed[_owner][_spender];
137   }
138 
139 }
140 
141 contract Ownable {
142   address public owner;
143 
144 
145   /**
146    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
147    * account.
148    */
149   function Ownable() {
150     owner = msg.sender;
151   }
152 
153 
154   /**
155    * @dev Throws if called by any account other than the owner.
156    */
157   modifier onlyOwner() {
158     require(msg.sender == owner);
159     _;
160   }
161 
162 
163   /**
164    * @dev Allows the current owner to transfer control of the contract to a newOwner.
165    * @param newOwner The address to transfer ownership to.
166    */
167   function transferOwnership(address newOwner) onlyOwner {
168     require(newOwner != address(0));      
169     owner = newOwner;
170   }
171 
172 }
173 
174 contract MintableToken is StandardToken, Ownable {
175   event Mint(address indexed to, uint256 amount);
176   event MintFinished();
177 
178   bool public mintingFinished = false;
179 
180   string public name = "Tiberium";		
181   string public symbol = "TIB";		
182   uint256 public decimals = 18;		
183 
184   modifier canMint() {
185     require(!mintingFinished);
186     _;
187   }
188 
189 function MintableToken(){
190     mint(msg.sender,5000000000000000000000000);
191     //finishMinting
192 }
193 
194   /**
195    * @dev Function to mint tokens
196    * @param _to The address that will receive the minted tokens.
197    * @param _amount The amount of tokens to mint.
198    * @return A boolean that indicates if the operation was successful.
199    */
200   function mint(address _to, uint256 _amount) onlyOwner canMint returns (bool) {
201     totalSupply = totalSupply.add(_amount);
202     balances[_to] = balances[_to].add(_amount);
203     Mint(_to, _amount);
204     Transfer(0x0, _to, _amount);
205     return true;
206   }
207 
208   /**
209    * @dev Function to stop minting new tokens.
210    * @return True if the operation was successful.
211    */
212   function finishMinting() onlyOwner returns (bool) {
213     mintingFinished = true;
214     MintFinished();
215     return true;
216   }
217   
218   
219 }
220 
221 contract Crowdsale {
222   using SafeMath for uint256;
223 
224   // The token being sold
225   MintableToken public token;
226 
227   // start and end block where investments are allowed (both inclusive)
228   
229   uint256 public deadline;
230 
231   // address where funds are collected
232   address public wallet;
233 
234   // how many token units a buyer gets per wei
235   uint256 public rate;
236 
237   // amount of raised money in wei
238   uint256 public weiRaised;
239   
240   // how Much token sold
241     uint256 public tokensSold;
242     
243   /**
244    * event for token purchase logging
245    * @param purchaser who paid for the tokens
246    * @param beneficiary who got the tokens
247    * @param value weis paid for purchase
248    * @param amount amount of tokens purchased
249    */
250   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
251 
252 
253   function Crowdsale(MintableToken tokenContract, uint256 durationInWeeks, uint256 _rate, address _wallet) {
254     
255     require(_rate > 0);
256     require(_wallet != 0x0);
257 
258     //token = createTokenContract();
259     token = tokenContract;
260     
261     deadline = now + durationInWeeks * 1 weeks;
262     rate = _rate;
263     wallet = _wallet;
264   }
265 
266   // creates the token to be sold.
267   // override this method to have crowdsale of a specific mintable token.
268   function createTokenContract() internal returns (MintableToken) {
269     return new MintableToken();
270   }
271 
272 
273   // fallback function can be used to buy tokens
274   function () payable {
275     buyTokens(msg.sender);
276   }
277 
278   // low level token purchase function
279   function buyTokens(address beneficiary) payable {
280     require(beneficiary != 0x0);
281     require(validPurchase());
282 
283     uint256 weiAmount = msg.value;
284     uint256 updatedWeiRaised = weiRaised.add(weiAmount);
285 
286     // calculate token amount to be created
287     uint256 tokens = weiAmount.mul(rate);
288 
289     // update state
290     weiRaised = updatedWeiRaised;
291 
292     token.mint(beneficiary, tokens);
293     tokensSold =  tokensSold.add(tokens);
294     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
295 
296     forwardFunds();
297   }
298 
299   // send ether to the fund collection wallet
300   // override to create custom fund forwarding mechanisms
301   function forwardFunds() internal {
302     wallet.transfer(msg.value);
303   }
304 
305   // @return true if the transaction can buy tokens
306   function validPurchase() internal constant returns (bool) {
307     //uint256 current = block.number;
308     bool withinPeriod = now <= deadline;
309     bool nonZeroPurchase = msg.value != 0;
310     return withinPeriod && nonZeroPurchase;
311   }
312 
313   // @return true if crowdsale event has ended
314   function hasEnded() public constant returns (bool) {
315     return (now > deadline);
316   }
317   
318  // function tokenResend() onlyOwner {
319  //     token.transfer(owner, token.balanceOf(this));
320  // }
321 
322 }