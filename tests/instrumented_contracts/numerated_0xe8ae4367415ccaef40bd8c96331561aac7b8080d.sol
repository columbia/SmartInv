1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 library SafeMath {
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     uint256 c = a * b;
21     assert(a == 0 || c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 
46 
47 
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55   function allowance(address owner, address spender) public view returns (uint256);
56   function transferFrom(address from, address to, uint256 value) public returns (bool);
57   function approve(address spender, uint256 value) public returns (bool);
58   event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 
62 contract Hive is ERC20 {
63 
64     using SafeMath for uint;
65     string public constant name = "UHIVE";
66     string public constant symbol = "HVE";    
67     uint256 public constant decimals = 18;
68     uint256 _totalSupply = 80000000000 * (10**decimals);
69 
70     mapping (address => bool) public frozenAccount;
71     event FrozenFunds(address target, bool frozen);
72 
73     // Balances for each account
74     mapping(address => uint256) balances;
75 
76     // Owner of account approves the transfer of an amount to another account
77     mapping(address => mapping (address => uint256)) allowed;
78 
79     // Owner of this contract
80     address public owner;
81 
82     // Functions with this modifier can only be executed by the owner
83     modifier onlyOwner() {
84         require(msg.sender == owner);
85         _;
86     }
87 
88     function changeOwner(address _newOwner) onlyOwner public {
89         require(_newOwner != address(0));
90         owner = _newOwner;
91     }
92 
93     function freezeAccount(address target, bool freeze) onlyOwner public {
94         frozenAccount[target] = freeze;
95         FrozenFunds(target, freeze);
96     }
97 
98     function isFrozenAccount(address _addr) public constant returns (bool) {
99         return frozenAccount[_addr];
100     }
101 
102     function destroyCoins(address addressToDestroy, uint256 amount) onlyOwner public {
103         require(addressToDestroy != address(0));
104         require(amount > 0);
105         require(amount <= balances[addressToDestroy]);
106         balances[addressToDestroy] -= amount;    
107         _totalSupply -= amount;
108     }
109 
110     // Constructor
111     function Hive() public {
112         owner = msg.sender;
113         balances[owner] = _totalSupply;
114     }
115 
116     function totalSupply() public constant returns (uint256 supply) {
117         supply = _totalSupply;
118     }
119 
120     // What is the balance of a particular account?
121     function balanceOf(address _owner) public constant returns (uint256 balance) {
122         return balances[_owner];
123     }
124     
125     // Transfer the balance from owner's account to another account
126     function transfer(address _to, uint256 _value) public returns (bool success) {        
127         if (_to != address(0) && isFrozenAccount(msg.sender) == false && balances[msg.sender] >= _value && _value > 0 && balances[_to].add(_value) > balances[_to]) {
128             balances[msg.sender] = balances[msg.sender].sub(_value);
129             balances[_to] = balances[_to].add(_value);
130             Transfer(msg.sender, _to, _value);
131             return true;
132         } else {
133             return false;
134         }
135     }
136 
137     // Send _value amount of tokens from address _from to address _to
138     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
139     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
140     // fees in sub-currencies; the command should fail unless the _from account has
141     // deliberately authorized the sender of the message via some mechanism; we propose
142     // these standardized APIs for approval:
143     function transferFrom(address _from,address _to, uint256 _value) public returns (bool success) {
144         if (_to != address(0) && isFrozenAccount(_from) == false && balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to].add(_value) > balances[_to]) {
145             balances[_from] = balances[_from].sub(_value);
146             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147             balances[_to] = balances[_to].add(_value);
148             Transfer(_from, _to, _value);
149             return true;
150         } else {
151             return false;
152         }
153     }
154 
155     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
156     // If this function is called again it overwrites the current allowance with _value.
157     function approve(address _spender, uint256 _value) public returns (bool success) {
158         allowed[msg.sender][_spender] = _value;
159         Approval(msg.sender, _spender, _value);
160         return true;
161     }
162     
163     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
164         return allowed[_owner][_spender];
165     }
166     
167 }
168 
169 contract HivePreSale {
170 
171     using SafeMath for uint256;
172     // The token being sold
173     Hive public token;
174 
175     // Address where funds are collected
176     address public vaultWallet;
177 
178     // How many token units a buyer gets per wei
179     uint256 public hivePerEther;
180 
181     // How much hive cost per USD
182     uint256 public hivePerUSD;
183 
184     // Owner of this contract
185     address public owner;
186 
187     //Flag paused sale
188     bool public paused;
189 
190     uint256 public openingTime;
191     uint256 public closingTime;
192 
193     uint256 public minimumWei;
194 
195     /**
196     * @dev Reverts if not in crowdsale time range. 
197     */
198     modifier onlyWhileOpen {
199         require(now >= openingTime && now <= closingTime && paused == false);
200         _;
201     }
202 
203     // Functions with this modifier can only be executed by the owner
204     modifier onlyOwner() {
205         require(msg.sender == owner);
206         _;
207     }
208 
209     function HivePreSale(uint256 _hivePerEther, address _vaultWallet, Hive _token, uint256 _openingTime, uint256 _closingTime) public {
210         hivePerEther = _hivePerEther;
211         vaultWallet = _vaultWallet;
212         token = _token;
213         owner = msg.sender;
214         openingTime = _openingTime;
215         closingTime = _closingTime;
216         paused = false;
217         hivePerUSD = 667; //each hive is 0.0015$
218         minimumWei = 100000000000000000; //0.1 Ether
219     }
220 
221     function () external payable {
222         buyTokens(msg.sender);
223     }
224     
225     /**
226     * Event for token purchase logging
227     * @param purchaser who paid for the tokens
228     * @param beneficiary who got the tokens
229     * @param value weis paid for purchase
230     * @param amount amount of tokens purchased
231     */
232     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
233 
234     /**
235     * @dev Checks whether the period in which the crowdsale is open has already elapsed.
236     * @return Whether crowdsale period has elapsed
237     */
238     function hasClosed() public view returns (bool) {
239         return now > closingTime;
240     }
241 
242 
243     /**
244     * @dev low level token purchase ***DO NOT OVERRIDE***
245     * @param _beneficiary Address performing the token purchase
246     */
247     function buyTokens(address _beneficiary) public payable onlyWhileOpen {
248 
249         uint256 weiAmount = msg.value;
250         _preValidatePurchase(_beneficiary, weiAmount);
251 
252         // calculate token amount to be created
253         uint256 tokens = _getTokenAmount(weiAmount);
254         _verifyAvailability(tokens);
255 
256         _processPurchase(_beneficiary, tokens);
257         TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
258         _forwardFunds();
259     }
260 
261     function changeRate(uint256 _newRate) onlyOwner public {
262         require(_newRate > 0);
263         hivePerEther = _newRate;
264     }
265 
266     function changeMinimumWei(uint256 _newMinimumWei) onlyOwner public {        
267         minimumWei = _newMinimumWei;
268     }
269 
270     function extendSale(uint256 _newClosingTime) onlyOwner public {
271         require(_newClosingTime > closingTime);
272         closingTime = _newClosingTime;
273     }
274 
275     function haltSale() onlyOwner public {
276         paused = true;
277     }
278 
279     function resumeSale() onlyOwner public {
280         paused = false;
281     }
282 
283     //Called from outside to auto handle BTC and FIAT purchases
284     function forwardTokens(address _beneficiary, uint256 totalTokens) onlyOwner onlyWhileOpen public {        
285         _preValidateTokenTransfer(_beneficiary, totalTokens);
286         _deliverTokens(_beneficiary, totalTokens);
287     }
288 
289     function changeOwner(address _newOwner) onlyOwner public {
290         require(_newOwner != address(0));
291         owner = _newOwner;
292     }
293 
294     function changeVaultWallet(address _newVaultWallet) onlyOwner public {
295         require(_newVaultWallet != address(0));
296         vaultWallet = _newVaultWallet;
297     }
298 
299     //Called after the sale ends to withdraw remaining unsold tokens
300     function withdrawUnsoldTokens() onlyOwner public {    
301         uint256 unsold = token.balanceOf(this);
302         token.transfer(owner, unsold);
303     }
304 
305     function terminate() public onlyOwner {
306         selfdestruct(owner);
307     }
308 
309     // -----------------------------------------
310     // Internal interface (extensible)
311     // -----------------------------------------
312 
313     /**
314     * @dev Validation of an incoming purchase.
315     * @param _beneficiary Address performing the token purchase
316     * @param _weiAmount Value in wei involved in the purchase
317     */
318     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal view {
319         require(hasClosed() == false);
320         require(paused == false);
321         require(_beneficiary != address(0));
322         require(_weiAmount >= minimumWei);
323     }
324 
325     /**
326     * @dev Validation of a token transfer, used with BTC purchase.
327     * @param _beneficiary Address performing the token purchase
328     * @param _tokenAmount Number to tokens to transfer
329     */
330     function _preValidateTokenTransfer(address _beneficiary, uint256 _tokenAmount) internal view {
331         require(hasClosed() == false);
332         require(paused == false);
333         require(_beneficiary != address(0));
334         require(_tokenAmount > 0);
335     }
336 
337     /**
338     * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
339     * @param _beneficiary Address performing the token purchase
340     * @param _tokenAmount Number of tokens to be emitted
341     */
342     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) private {
343         token.transfer(_beneficiary, _tokenAmount);
344     }
345 
346     /**
347     * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
348     * @param _beneficiary Address receiving the tokens
349     * @param _tokenAmount Number of tokens to be purchased
350     */
351     function _processPurchase(address _beneficiary, uint256 _tokenAmount) private {
352         _deliverTokens(_beneficiary, _tokenAmount);
353     }
354   
355 
356     /**
357     * @dev Override to extend the way in which ether is converted to tokens.
358     * @param _weiAmount Value in wei to be converted into tokens
359     * @return Number of tokens that can be purchased with the specified _weiAmount
360     */
361     function _getTokenAmount(uint256 _weiAmount) private view returns (uint256) {
362         return _weiAmount.mul(hivePerEther);
363     }
364 
365     /**
366     * @dev Determines how ETH is stored/forwarded on purchases.
367     */
368     function _forwardFunds() private {
369         vaultWallet.transfer(msg.value);
370     }
371 
372     function _verifyAvailability(uint256 _requestedAmount) private view {
373         uint256 remaining = token.balanceOf(this);
374         require(remaining >= _requestedAmount);
375     }
376 }