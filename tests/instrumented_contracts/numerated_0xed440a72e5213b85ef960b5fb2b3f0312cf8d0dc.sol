1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         assert(c / a == b);
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         // assert(b > 0); // Solidity automatically throws when dividing by 0
62         uint256 c = a / b;
63         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64         return c;
65     }
66 
67     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
68         assert(b <= a);
69         return a - b;
70     }
71 
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         assert(c >= a);
75         return c;
76     }
77 }
78 
79 
80 /**
81  * @title Destructible
82  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
83  */
84 contract Destructible is Ownable {
85 
86   function Destructible() public payable { }
87 
88   /**
89    * @dev Transfers the current balance to the owner and terminates the contract.
90    */
91   function destroy() onlyOwner public {
92     selfdestruct(owner);
93   }
94 
95   function destroyAndSend(address _recipient) onlyOwner public {
96     selfdestruct(_recipient);
97   }
98 }
99 
100 
101 /**
102  * @title ERC20Basic
103  * @dev Simpler version of ERC20 interface
104  * @dev see https://github.com/ethereum/EIPs/issues/179
105  */
106 contract ERC20Basic {
107     uint256 public totalSupply;
108     function balanceOf(address who) public view returns (uint256);
109     function transfer(address to, uint256 value) public returns (bool);
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120     function allowance(address owner, address spender) public view returns (uint256);
121     function transferFrom(address from, address to, uint256 value) public returns (bool);
122     function approve(address spender, uint256 value) public returns (bool);
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 
128 /**
129  * @title Basic token
130  * @dev Basic version of StandardToken, with no allowances.
131  */
132 contract BasicToken is ERC20Basic {
133     using SafeMath for uint256;
134 
135     mapping(address => uint256) public balances;
136 
137     /**
138     * @dev transfer token for a specified address
139     * @param _to The address to transfer to.
140     * @param _value The amount to be transferred.
141     */
142     function transfer(address _to, uint256 _value) public returns (bool) {
143         require(_to != address(0));
144         require(_value <= balances[msg.sender]);
145 
146         // SafeMath.sub will throw if there is not enough balance.
147         balances[msg.sender] = balances[msg.sender].sub(_value);
148         balances[_to] = balances[_to].add(_value);
149         Transfer(msg.sender, _to, _value);
150         return true;
151     }
152 
153     /**
154     * @dev Gets the balance of the specified address.
155     * @param _owner The address to query the the balance of.
156     * @return An uint256 representing the amount owned by the passed address.
157     */
158     function balanceOf(address _owner) public view returns (uint256 balance) {
159         return balances[_owner];
160     }
161 
162 }
163 
164 
165 
166 /**
167  * @title Standard ERC20 token
168  *
169  * @dev Implementation of the basic standard token.
170  * @dev https://github.com/ethereum/EIPs/issues/20
171  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  */
173 contract StandardToken is ERC20, BasicToken {
174 
175     mapping (address => mapping (address => uint256)) internal allowed;
176 
177 
178     /**
179      * @dev Transfer tokens from one address to another
180      * @param _from address The address which you want to send tokens from
181      * @param _to address The address which you want to transfer to
182      * @param _value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
185         require(_to != address(0));
186         require(_value <= balances[_from]);
187         require(_value <= allowed[_from][msg.sender]);
188 
189         balances[_from] = balances[_from].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
192         Transfer(_from, _to, _value);
193         return true;
194     }
195 
196     /**
197      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
198      *
199      * Beware that changing an allowance with this method brings the risk that someone may use both the old
200      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
201      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      * @param _spender The address which will spend the funds.
204      * @param _value The amount of tokens to be spent.
205      */
206     function approve(address _spender, uint256 _value) public returns (bool) {
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211 
212     /**
213      * @dev Function to check the amount of tokens that an owner allowed to a spender.
214      * @param _owner address The address which owns the funds.
215      * @param _spender address The address which will spend the funds.
216      * @return A uint256 specifying the amount of tokens still available for the spender.
217      */
218     function allowance(address _owner, address _spender) public view returns (uint256) {
219         return allowed[_owner][_spender];
220     }
221 
222     /**
223      * approve should be called when allowed[_spender] == 0. To increment
224      * allowed value is better to use this function to avoid 2 calls (and wait until
225      * the first transaction is mined)
226      * From MonolithDAO Token.sol
227      */
228     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
229         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
230         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
231         return true;
232     }
233 
234     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
235         uint oldValue = allowed[msg.sender][_spender];
236         if (_subtractedValue > oldValue) {
237             allowed[msg.sender][_spender] = 0;
238         } else {
239             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
240         }
241         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
242         return true;
243     }
244 
245 }
246 
247 /**
248  * @title KryptoroToken
249  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
250  * Note they can later distribute these tokens as they wish using `transfer` and other
251  * `StandardToken` functions.
252  */
253 contract KryptoroToken is StandardToken, Destructible {
254 
255     string public constant name = "KRYPTORO Coin";
256     string public constant symbol = "KTO";
257     uint8 public constant decimals = 18;
258 
259     uint256 public constant INITIAL_SUPPLY = 100 * 1000000 * (10 ** uint256(decimals));
260 
261     /**
262     * @dev Constructor that gives msg.sender all of existing tokens.
263     */
264     function KryptoroToken() public {
265         totalSupply = INITIAL_SUPPLY;
266         balances[msg.sender] = INITIAL_SUPPLY;
267     }
268 }
269 
270 
271 /**
272  * @title KTOCrowdsale
273  * @dev KTOCrowdsale is a completed contract for managing a token crowdsale.
274  * KTOCrowdsale have a start and end timestamps, where investors can make
275  * token purchases and the KTOCrowdsale will assign them tokens based
276  * on a token per ETH rate. Funds collected are forwarded to a wallet
277  * as they arrive.
278  */
279 contract KTOCrowdsale is Ownable{
280   using SafeMath for uint256;
281 
282   // The token being sold
283   KryptoroToken public token;
284 
285   // start and end timestamps where investments are allowed (both inclusive)
286   uint256 public startTime;
287   uint256 public endTime;
288     
289   // address where funds are collected
290   address public wallet;
291 
292   // how many token units a buyer gets per wei
293   uint256 public rate;
294 
295   /**
296    * event for token purchase logging
297    * @param purchaser who paid for the tokens
298    * @param beneficiary who got the tokens
299    * @param value weis paid for purchase
300    * @param amount amount of tokens purchased
301    */
302   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
303 
304   event TokenContractUpdated(bool state);
305 
306   event WalletAddressUpdated(bool state);
307 
308   function KTOCrowdsale() public {
309     token = createTokenContract();
310     startTime = 1532332800;
311     endTime = 1539590400;
312     rate = 612;
313     wallet = 0x34367d515ff223a27985518f2780cccc4a7e0fc9;
314   }
315 
316   // creates the token to be sold.
317   // override this method to have crowdsale of a specific mintable token.
318   function createTokenContract() internal returns (KryptoroToken) {
319     return new KryptoroToken();
320   }
321 
322 
323   // fallback function can be used to buy tokens
324   function () external payable {
325     buyTokens(msg.sender);
326   }
327 
328   // low level token purchase function
329   function buyTokens(address beneficiary) public payable {
330     require(beneficiary != address(0));
331     require(validPurchase());
332 
333     uint256 weiAmount = msg.value;
334 
335     // calculate token amount to be created
336     uint256 tokens = weiAmount.mul(rate);
337 
338     token.transfer(beneficiary, tokens);
339     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
340 
341     forwardFunds();
342   }
343 
344   // send ether to the fund collection wallet
345   // override to create custom fund forwarding mechanisms
346   function forwardFunds() internal {
347     wallet.transfer(msg.value);
348   }
349 
350   // @return true if the transaction can buy tokens
351   function validPurchase() internal view returns (bool) {
352     bool nonZeroPurchase = msg.value != 0;
353     bool withinPeriod = now >= startTime && now <= endTime;
354     
355     return nonZeroPurchase && withinPeriod;
356   }
357   
358   // @return true if crowdsale event has ended
359   function hasEnded() public view returns (bool) {
360       bool timeEnded = now > endTime;
361 
362       return timeEnded;
363   }
364   
365   // update token contract
366    function updateKryptoroToken(address _tokenAddress) onlyOwner{
367       require(_tokenAddress != address(0));
368       token.transferOwnership(_tokenAddress);
369 
370       TokenContractUpdated(true);
371   }
372   
373   // update wallet address
374   function updateWalletAddress(address _newWallet) onlyOwner {
375       require(_newWallet != address(0));
376       wallet = _newWallet;
377 
378       WalletAddressUpdated(true);
379   }
380   
381   // transfer tokens
382   function transferTokens(address _to, uint256 _amount) onlyOwner {
383       require(_to != address(0));
384       
385       token.transfer(_to, _amount);
386   }
387 }