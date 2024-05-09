1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         if (a == 0) {
11             return 0;
12         }
13         uint256 c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         // assert(b > 0); // Solidity automatically throws when dividing by 0
20         uint256 c = a / b;
21         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         assert(b <= a);
27         return a - b;
28     }
29 
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         assert(c >= a);
33         return c;
34     }
35 }
36 
37 /**
38  * @title ERC20Basic
39  * @dev Simpler version of ERC20 interface
40  * @dev see https://github.com/ethereum/EIPs/issues/179
41  */
42 contract ERC20Basic {
43     uint256 public totalSupply;
44     function balanceOf(address who) public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47 }
48 
49 
50 /**
51  * @title ERC20 interface
52  * @dev see https://github.com/ethereum/EIPs/issues/20
53  */
54 contract ERC20 is ERC20Basic {
55     function allowance(address owner, address spender) public view returns (uint256);
56     function transferFrom(address from, address to, uint256 value) public returns (bool);
57     function approve(address spender, uint256 value) public returns (bool);
58     event Approval(address indexed owner, address indexed spender, uint256 value);
59 }
60 
61 /**
62  * @title Basic token
63  * @dev Basic version of StandardToken, with no allowances.
64  */
65 contract BasicToken is ERC20Basic {
66     using SafeMath for uint256;
67 
68     mapping(address => uint256) balances;
69 
70     /**
71     * @dev transfer token for a specified address
72     * @param _to The address to transfer to.
73     * @param _value The amount to be transferred.
74     */
75     function transfer(address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[msg.sender]);
78 
79         // SafeMath.sub will throw if there is not enough balance.
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         Transfer(msg.sender, _to, _value);
83         return true;
84     }
85 
86     /**
87     * @dev Gets the balance of the specified address.
88     * @param _owner The address to query the the balance of.
89     * @return An uint256 representing the amount owned by the passed address.
90     */
91     function balanceOf(address _owner) public view returns (uint256 balance) {
92         return balances[_owner];
93     }
94 
95 }
96 
97 /**
98  * @title Standard ERC20 token
99  *
100  * @dev Implementation of the basic standard token.
101  * @dev https://github.com/ethereum/EIPs/issues/20
102  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
103  */
104 contract StandardToken is ERC20, BasicToken {
105 
106     mapping (address => mapping (address => uint256)) internal allowed;
107 
108 
109     /**
110      * @dev Transfer tokens from one address to another
111      * @param _from address The address which you want to send tokens from
112      * @param _to address The address which you want to transfer to
113      * @param _value uint256 the amount of tokens to be transferred
114      */
115     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
116         require(_to != address(0));
117         require(_value <= balances[_from]);
118         require(_value <= allowed[_from][msg.sender]);
119 
120         balances[_from] = balances[_from].sub(_value);
121         balances[_to] = balances[_to].add(_value);
122         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
123         Transfer(_from, _to, _value);
124         return true;
125     }
126 
127     /**
128      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
129      *
130      * Beware that changing an allowance with this method brings the risk that someone may use both the old
131      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
132      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      * @param _spender The address which will spend the funds.
135      * @param _value The amount of tokens to be spent.
136      */
137     function approve(address _spender, uint256 _value) public returns (bool) {
138         allowed[msg.sender][_spender] = _value;
139         Approval(msg.sender, _spender, _value);
140         return true;
141     }
142 
143     /**
144      * @dev Function to check the amount of tokens that an owner allowed to a spender.
145      * @param _owner address The address which owns the funds.
146      * @param _spender address The address which will spend the funds.
147      * @return A uint256 specifying the amount of tokens still available for the spender.
148      */
149     function allowance(address _owner, address _spender) public view returns (uint256) {
150         return allowed[_owner][_spender];
151     }
152 
153     /**
154      * @dev Increase the amount of tokens that an owner allowed to a spender.
155      *
156      * approve should be called when allowed[_spender] == 0. To increment
157      * allowed value is better to use this function to avoid 2 calls (and wait until
158      * the first transaction is mined)
159      * From MonolithDAO Token.sol
160      * @param _spender The address which will spend the funds.
161      * @param _addedValue The amount of tokens to increase the allowance by.
162      */
163     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
164         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
165         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166         return true;
167     }
168 
169     /**
170      * @dev Decrease the amount of tokens that an owner allowed to a spender.
171      *
172      * approve should be called when allowed[_spender] == 0. To decrement
173      * allowed value is better to use this function to avoid 2 calls (and wait until
174      * the first transaction is mined)
175      * From MonolithDAO Token.sol
176      * @param _spender The address which will spend the funds.
177      * @param _subtractedValue The amount of tokens to decrease the allowance by.
178      */
179     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
180         uint oldValue = allowed[msg.sender][_spender];
181         if (_subtractedValue > oldValue) {
182             allowed[msg.sender][_spender] = 0;
183         } else {
184             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
185         }
186         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
187         return true;
188     }
189 
190 }
191 contract Ownable {
192     address public owner;
193 
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197 
198     /**
199      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
200      * account.
201      */
202     function Ownable() public {
203         owner = msg.sender;
204     }
205 
206 
207     /**
208      * @dev Throws if called by any account other than the owner.
209      */
210     modifier onlyOwner() {
211         require(msg.sender == owner);
212         _;
213     }
214 
215 
216     /**
217      * @dev Allows the current owner to transfer control of the contract to a newOwner.
218      * @param newOwner The address to transfer ownership to.
219      */
220     function transferOwnership(address newOwner) public onlyOwner {
221         require(newOwner != address(0));
222         OwnershipTransferred(owner, newOwner);
223         owner = newOwner;
224     }
225 }
226 
227 
228 contract MintableToken is StandardToken, Ownable {
229     string public constant name = "MCCoin";
230     string public constant symbol = "MCC";
231     uint8 public constant decimals = 18;
232 
233     event Mint(address indexed to, uint256 amount);
234     event MintFinished();
235 
236     bool public mintingFinished = false;
237 
238 
239     modifier canMint() {
240         require(!mintingFinished);
241         _;
242     }
243 
244     /**
245      * @dev Function to mint tokens
246      * @param _to The address that will receive the minted tokens.
247      * @param _amount The amount of tokens to mint.
248      * @return A boolean that indicates if the operation was successful.
249      */
250     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
251         totalSupply = totalSupply.add(_amount);
252         balances[_to] = balances[_to].add(_amount);
253         Mint(_to, _amount);
254         Transfer(address(0), _to, _amount);
255         return true;
256     }
257 
258     /**
259      * @dev Function to stop minting new tokens.
260      * @return True if the operation was successful.
261      */
262     function finishMinting() onlyOwner canMint public returns (bool) {
263         mintingFinished = true;
264         MintFinished();
265         return true;
266     }
267 }
268 
269 
270 /**
271  * @title Crowdsale
272  * @dev Crowdsale is a base contract for managing a token crowdsale.
273  * Crowdsales have a start and end timestamps, where investors can make
274  * token purchases and the crowdsale will assign them tokens based
275  * on a token per ETH rate. Funds collected are forwarded to a wallet
276  * as they arrive.
277  */
278 contract Crowdsale {
279     using SafeMath for uint256;
280 
281     // The token being sold
282     MintableToken public token;
283 
284     uint256 public hardCap = 100000000 * (10**18);
285 
286     // address where funds are collected
287     address public wallet = 0xD0b6c1F479eACcce7A77D5Aa3b6c9fc2213EecCb;
288 
289     // how many token units a buyer gets per wei
290     uint256 public rate = 40000;
291 
292     // amount of raised money in wei
293     uint256 public weiRaised;
294 
295     /**
296      * event for token purchase logging
297      * @param purchaser who paid for the tokens
298      * @param beneficiary who got the tokens
299      * @param value weis paid for purchase
300      * @param amount amount of tokens purchased
301      */
302     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
303 
304     event Value(uint256 indexed value);
305 
306     function Crowdsale() public {
307         token = createTokenContract();
308     }
309 
310     // creates the token to be sold.
311     // override this method to have crowdsale of a specific mintable token.
312     function createTokenContract() internal returns (MintableToken) {
313         return new MintableToken();
314     }
315 
316 
317     // fallback function can be used to buy tokens
318     function () external payable {
319         buyTokens(msg.sender);
320     }
321 
322     // low level token purchase function
323     function buyTokens(address beneficiary) public payable {
324         require(beneficiary != address(0));
325         require(validPurchase());
326         require(!hasEnded());
327 
328         uint256 weiAmount = msg.value;
329 
330         // calculate token amount to be created
331         uint256 tokens = weiAmount.mul(rate);
332 
333         // update state
334         weiRaised = weiRaised.add(weiAmount);
335 
336         token.mint(beneficiary, tokens);
337         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
338         wallet.transfer(msg.value);
339     }
340 
341     // send ether to the fund collection wallet
342     // override to create custom fund forwarding mechanisms
343     function forwardFunds() internal {
344         wallet.transfer(msg.value);
345     }
346 
347     // @return true if the transaction can buy tokens
348     function validPurchase() internal view returns (bool) {
349         bool nonZeroPurchase = msg.value != 0;
350         return nonZeroPurchase;
351     }
352 
353     // @return true if crowdsale event has ended
354     function hasEnded() public view returns (bool) {
355         return token.totalSupply() >= hardCap;
356     }
357 }