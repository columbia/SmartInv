1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract Ownable {
33   address public owner;
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36 
37   /**
38    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39    * account.
40    */
41   function Ownable() public {
42     owner = msg.sender;
43   }
44 
45 
46   /**
47    * @dev Throws if called by any account other than the owner.
48    */
49   modifier onlyOwner() {
50     require(msg.sender == owner);
51     _;
52   }
53 
54 
55   /**
56    * @dev Allows the current owner to transfer control of the contract to a newOwner.
57    * @param newOwner The address to transfer ownership to.
58    */
59   function transferOwnership(address newOwner) public onlyOwner {
60     require(newOwner != address(0));
61     OwnershipTransferred(owner, newOwner);
62     owner = newOwner;
63   }
64 }
65 
66 contract Destructible is Ownable {
67 
68   function Destructible() public payable { }
69 
70   /**
71    * @dev Transfers the current balance to the owner and terminates the contract.
72    */
73   function destroy() onlyOwner public {
74     selfdestruct(owner);
75   }
76 
77   function destroyAndSend(address _recipient) onlyOwner public {
78     selfdestruct(_recipient);
79   }
80 }
81 
82 
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) public view returns (uint256);
86   function transfer(address to, uint256 value) public returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract BasicToken is ERC20Basic {
98   using SafeMath for uint256;
99 
100   mapping(address => uint256) balances;
101 
102   /**
103   * @dev transfer token for a specified address
104   * @param _to The address to transfer to.
105   * @param _value The amount to be transferred.
106   */
107   function transfer(address _to, uint256 _value) public returns (bool) {
108     require(_to != address(0));
109     require(_value <= balances[msg.sender]);
110 
111     // SafeMath.sub will throw if there is not enough balance.
112     balances[msg.sender] = balances[msg.sender].sub(_value);
113     balances[_to] = balances[_to].add(_value);
114     Transfer(msg.sender, _to, _value);
115     return true;
116   }
117 
118   /**
119   * @dev Gets the balance of the specified address.
120   * @param _owner The address to query the the balance of.
121   * @return An uint256 representing the amount owned by the passed address.
122   */
123   function balanceOf(address _owner) public view returns (uint256 balance) {
124     return balances[_owner];
125   }
126 }
127 
128 contract StandardToken is ERC20, BasicToken {
129 
130   mapping (address => mapping (address => uint256)) internal allowed;
131 
132   /**
133    * @dev Transfer tokens from one address to another
134    * @param _from address The address which you want to send tokens from
135    * @param _to address The address which you want to transfer to
136    * @param _value uint256 the amount of tokens to be transferred
137    */
138   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
139     require(_to != address(0));
140     require(_value <= balances[_from]);
141     require(_value <= allowed[_from][msg.sender]);
142 
143     balances[_from] = balances[_from].sub(_value);
144     balances[_to] = balances[_to].add(_value);
145     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
146     Transfer(_from, _to, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
152    *
153    * Beware that changing an allowance with this method brings the risk that someone may use both the old
154    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
155    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
156    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) public returns (bool) {
161     allowed[msg.sender][_spender] = _value;
162     Approval(msg.sender, _spender, _value);
163     return true;
164   }
165 
166   /**
167    * @dev Function to check the amount of tokens that an owner allowed to a spender.
168    * @param _owner address The address which owns the funds.
169    * @param _spender address The address which will spend the funds.
170    * @return A uint256 specifying the amount of tokens still available for the spender.
171    */
172   function allowance(address _owner, address _spender) public view returns (uint256) {
173     return allowed[_owner][_spender];
174   }
175 
176   /**
177    * @dev Increase the amount of tokens that an owner allowed to a spender.
178    *
179    * approve should be called when allowed[_spender] == 0. To increment
180    * allowed value is better to use this function to avoid 2 calls (and wait until
181    * the first transaction is mined)
182    * From MonolithDAO Token.sol
183    * @param _spender The address which will spend the funds.
184    * @param _addedValue The amount of tokens to increase the allowance by.
185    */
186   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
187     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
188     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
189     return true;
190   }
191 
192   /*
193    * @dev Decrease the amount of tokens that an owner allowed to a spender.
194    *
195    * approve should be called when allowed[_spender] == 0. To decrement
196    * allowed value is better to use this function to avoid 2 calls (and wait until
197    * the first transaction is mined)
198    * From MonolithDAO Token.sol
199    * @param _spender The address which will spend the funds.
200    * @param _subtractedValue The amount of tokens to decrease the allowance by.
201    */
202   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
203     uint oldValue = allowed[msg.sender][_spender];
204     if (_subtractedValue > oldValue) {
205       allowed[msg.sender][_spender] = 0;
206     } else {
207       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
208     }
209     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
210     return true;
211   }
212 }
213 
214 contract MintableToken is StandardToken, Ownable {
215   event Mint(address indexed to, uint256 amount);
216   event MintFinished();
217 
218   bool public mintingFinished = false;
219 
220 
221   modifier canMint() {
222     require(!mintingFinished);
223     _;
224   }
225 
226   /**
227    * @dev Function to mint tokens
228    * @param _to The address that will receive the minted tokens.
229    * @param _amount The amount of tokens to mint.
230    * @return A boolean that indicates if the operation was successful.
231    */
232   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
233     totalSupply = totalSupply.add(_amount);
234     balances[_to] = balances[_to].add(_amount);
235     Mint(_to, _amount);
236     Transfer(address(0), _to, _amount);
237     return true;
238   }
239 
240   /**
241    * @dev Function to stop minting new tokens.
242    * @return True if the operation was successful.
243    */
244   function finishMinting() onlyOwner canMint public returns (bool) {
245     mintingFinished = true;
246     MintFinished();
247     return true;
248   }
249 }
250 
251 
252 /**
253  * @title Crowdsale
254  * @dev Crowdsale is a base contract for managing a token crowdsale.
255  * Crowdsales have a start and end timestamps, where investors can make
256  * token purchases and the crowdsale will assign them tokens based
257  * on a token per ETH rate. Funds collected are forwarded to a wallet
258  * as they arrive.
259  */
260 contract MEXCFinalSale is Ownable, Destructible {
261   using SafeMath for uint256;
262 
263   // The token being sold
264   MintableToken public token;
265 
266   // address where funds are collected
267   address public wallet = address(0);
268 
269   // how many token units a buyer gets per wei
270   uint256 public rate = 50000;
271 
272   // amount of raised money in wei
273   uint256 public weiRaised = 0;
274 
275   // closed the sale
276   bool closed = false;
277 
278   /**
279    * event for token purchase logging
280    * @param purchaser who paid for the tokens
281    * @param beneficiary who got the tokens
282    * @param value weis paid for purchase
283    * @param amount amount of tokens purchased
284    */
285   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
286 
287   function MEXCFinalSale(MintableToken _contract, address _wallet) public {
288     token = _contract;
289     wallet = _wallet;
290   }
291 
292   function setTokenContract(MintableToken _contract) public onlyOwner {
293     token = _contract;
294   }
295 
296   function setTokenOwner (address _newOwner) public onlyOwner {
297     token.transferOwnership(_newOwner);
298   }
299 
300   function setWallet(address _wallet) public onlyOwner {
301     wallet = _wallet;
302   }
303 
304   function setRate(uint256 _rate) public onlyOwner {
305     rate = _rate;
306   }
307 
308   function closeSale() public onlyOwner {
309     closed = true;
310   }
311 
312   function openSale() public onlyOwner {
313     closed = false;
314   }
315 
316   // fallback function can be used to buy tokens
317   function () external payable {
318     buyTokens(msg.sender);
319   }
320 
321   // low level token purchase function
322   function buyTokens(address beneficiary) public payable {
323     require(beneficiary != address(0));
324     require(validPurchase());
325 
326     uint256 weiAmount = msg.value;
327 
328     // calculate token amount to be created
329     uint256 tokens = weiAmount.mul(rate);
330 
331     // update state
332     weiRaised = weiRaised.add(weiAmount);
333 
334     token.mint(beneficiary, tokens);
335     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
336 
337     forwardFunds();
338   }
339 
340   // send ether to the fund collection wallet
341   // override to create custom fund forwarding mechanisms
342   function forwardFunds() internal {
343     wallet.transfer(msg.value);
344   }
345 
346   // @return true if the transaction can buy tokens
347   function validPurchase() internal view returns (bool) {
348     return msg.value != 0 && !closed;
349   }
350   
351   function mintToken(address _recipient, uint256 _tokens) public onlyOwner {
352     // mint the tokens
353     token.mint(_recipient, _tokens);
354   }
355 
356   // @return true if crowdsale event has ended
357   function hasEnded() public view returns (bool) {
358     return closed;
359   }
360 
361 }