1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10             return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21         return c;
22     }
23 
24     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25         assert(b <= a);
26         return a - b;
27     }
28 
29     function add(uint256 a, uint256 b) internal pure returns (uint256) {
30         uint256 c = a + b;
31         assert(c >= a);
32         return c;
33     }
34 }
35 
36 /**
37  * @title ERC20Basic
38  * @dev Simpler version of ERC20 interface
39  * @dev see https://github.com/ethereum/EIPs/issues/179
40  */
41 contract ERC20Basic {
42     uint256 public totalSupply;
43 
44     function balanceOf(address who) public view returns (uint256);
45 
46     function transfer(address to, uint256 value) public returns (bool);
47 
48     event Transfer(address indexed from, address indexed to, uint256 value);
49 }
50 
51 /**
52  * @title ERC20 interface
53  * @dev see https://github.com/ethereum/EIPs/issues/20
54  */
55 contract ERC20 is ERC20Basic {
56     function allowance(address owner, address spender) public view returns (uint256);
57 
58     function transferFrom(address from, address to, uint256 value) public returns (bool);
59 
60     function approve(address spender, uint256 value) public returns (bool);
61 
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63 }
64 
65 contract ShortAddressProtection {
66 
67     modifier onlyPayloadSize(uint256 numwords) {
68         assert(msg.data.length >= numwords * 32 + 4);
69         _;
70     }
71 }
72 
73 /**
74  * @title Basic token
75  * @dev Basic version of StandardToken, with no allowances.
76  */
77 contract BasicToken is ERC20Basic, ShortAddressProtection {
78     using SafeMath for uint256;
79 
80     mapping(address => uint256) balances;
81 
82     /**
83     * @dev transfer token for a specified address
84     * @param _to The address to transfer to.
85     * @param _value The amount to be transferred.
86     */
87     function transfer(address _to, uint256 _value) onlyPayloadSize(2) public returns (bool) {
88         require(_to != address(0));
89         require(_value <= balances[msg.sender]);
90 
91         // SafeMath.sub will throw if there is not enough balance.
92         balances[msg.sender] = balances[msg.sender].sub(_value);
93         balances[_to] = balances[_to].add(_value);
94         Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     /**
99     * @dev Gets the balance of the specified address.
100     * @param _owner The address to query the the balance of.
101     * @return An uint256 representing the amount owned by the passed address.
102     */
103     function balanceOf(address _owner) public view returns (uint256 balance) {
104         return balances[_owner];
105     }
106 }
107 
108 /**
109  * @title Standard ERC20 token
110  *
111  * @dev Implementation of the basic standard token.
112  * @dev https://github.com/ethereum/EIPs/issues/20
113  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
114  */
115 contract StandardToken is ERC20, BasicToken {
116 
117     mapping(address => mapping(address => uint256)) internal allowed;
118 
119     /**
120      * @dev Transfer tokens from one address to another
121      * @param _from address The address which you want to send tokens from
122      * @param _to address The address which you want to transfer to
123      * @param _value uint256 the amount of tokens to be transferred
124      */
125     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3) public returns (bool) {
126         require(_to != address(0));
127         require(_value <= balances[_from]);
128         require(_value <= allowed[_from][msg.sender]);
129 
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
139      *
140      * Beware that changing an allowance with this method brings the risk that someone may use both the old
141      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
142      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      * @param _spender The address which will spend the funds.
145      * @param _value The amount of tokens to be spent.
146      */
147     function approve(address _spender, uint256 _value) onlyPayloadSize(2) public returns (bool) {
148         allowed[msg.sender][_spender] = _value;
149         Approval(msg.sender, _spender, _value);
150         return true;
151     }
152 
153     /**
154      * @dev Function to check the amount of tokens that an owner allowed to a spender.
155      * @param _owner address The address which owns the funds.
156      * @param _spender address The address which will spend the funds.
157      * @return A uint256 specifying the amount of tokens still available for the spender.
158      */
159     function allowance(address _owner, address _spender) public view returns (uint256) {
160         return allowed[_owner][_spender];
161     }
162 
163     /**
164      * @dev Increase the amount of tokens that an owner allowed to a spender.
165      *
166      * approve should be called when allowed[_spender] == 0. To increment
167      * allowed value is better to use this function to avoid 2 calls (and wait until
168      * the first transaction is mined)
169      * From MonolithDAO Token.sol
170      * @param _spender The address which will spend the funds.
171      * @param _addedValue The amount of tokens to increase the allowance by.
172      */
173     function increaseApproval(address _spender, uint _addedValue) onlyPayloadSize(2) public returns (bool) {
174         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
175         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 
179     /**
180      * @dev Decrease the amount of tokens that an owner allowed to a spender.
181      *
182      * approve should be called when allowed[_spender] == 0. To decrement
183      * allowed value is better to use this function to avoid 2 calls (and wait until
184      * the first transaction is mined)
185      * From MonolithDAO Token.sol
186      * @param _spender The address which will spend the funds.
187      * @param _subtractedValue The amount of tokens to decrease the allowance by.
188      */
189     function decreaseApproval(address _spender, uint _subtractedValue) onlyPayloadSize(2) public returns (bool) {
190         uint oldValue = allowed[msg.sender][_spender];
191         if (_subtractedValue > oldValue) {
192             allowed[msg.sender][_spender] = 0;
193         } else {
194             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
195         }
196         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
197         return true;
198     }
199 
200 }
201 
202 contract Ownable {
203     address public owner;
204 
205     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
206 
207     /**
208      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
209      * account.
210      */
211     function Ownable() public {
212         owner = msg.sender;
213     }
214 
215     /**
216      * @dev Throws if called by any account other than the owner.
217      */
218     modifier onlyOwner() {
219         require(msg.sender == owner);
220         _;
221     }
222 
223     /**
224      * @dev Allows the current owner to transfer control of the contract to a newOwner.
225      * @param newOwner The address to transfer ownership to.
226      */
227     function transferOwnership(address newOwner) public onlyOwner {
228         require(newOwner != address(0));
229         OwnershipTransferred(owner, newOwner);
230         owner = newOwner;
231     }
232 }
233 
234 /**
235  * @title Mintable token
236  * @dev Simple ERC20 Token example, with mintable token creation
237  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
238  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
239  */
240 contract MintableToken is StandardToken, Ownable {
241     /**
242      * Total amount of tokens that could be minted
243      */
244     uint256 public mintLimit;
245 
246     address public saleAgent;
247 
248     bool public mintingFinished = false;
249 
250     event Mint(address indexed to, uint256 amount);
251     event MintFinished();
252 
253     modifier canMint() {
254         require(!mintingFinished);
255         _;
256     }
257 
258     modifier onlySaleAgent() {
259         require(msg.sender == saleAgent);
260         _;
261     }
262 
263     function setSaleAgent(address _saleAgent) onlyOwner public {
264         require(_saleAgent != address(0));
265         saleAgent = _saleAgent;
266     }
267 
268     /**
269      * @dev Function to mint tokens
270      * @param _to The address that will receive the minted tokens.
271      * @param _amount The amount of tokens to mint.
272      * @return A boolean that indicates if the operation was successful.
273      */
274     function mint(address _to, uint256 _amount) onlySaleAgent canMint public returns (bool) {
275         totalSupply = totalSupply.add(_amount);
276         require(totalSupply <= mintLimit);
277         balances[_to] = balances[_to].add(_amount);
278         Mint(_to, _amount);
279         Transfer(address(0), _to, _amount);
280         return true;
281     }
282 
283     /**
284      * @dev Function to stop minting new tokens.
285      * @return True if the operation was successful.
286      */
287     function finishMinting() onlyOwner canMint public returns (bool) {
288         mintingFinished = true;
289         MintFinished();
290         return true;
291     }
292 }
293 
294 contract Token is MintableToken {
295     string public constant name = "PatentCoin";
296     string public constant symbol = "PTC";
297     uint8 public constant decimals = 6;
298 
299     function Token() public {
300         mintLimit = 100000000 * (10 ** 6);
301     }
302 }
303 
304 contract PatentCoinPreICO is Ownable {
305     using SafeMath for uint256;
306 
307     // Limit of tokens
308     uint256 public constant hardCap = 6150000 * (10 ** 6);
309 
310     // How many token units a buyer gets per wei
311     uint256 public constant rate = 1080;
312 
313     // Address where funds are collected
314     address public wallet;
315 
316     // Amount sold tokens
317     uint256 public tokenRaised;
318 
319     // Amount of raised money in wei
320     uint256 public weiRaised;
321 
322     // The token being sold
323     Token public token;
324 
325     // Date start preICO - 03/25/2018 @ 00:00 (UTC)
326     uint256 public constant dateStart = 1521936000;
327 
328     // Date end preICO - 05/25/2018 @ 23:59 (UTC)
329     uint256 public constant dateEnd = 1527292740;
330 
331     /**
332      * PatentCoinPreICO constructor
333      */
334     function PatentCoinPreICO(address _wallet, address _token) public {
335         require(_wallet != address(0));
336         require(_token != address(0));
337         wallet = _wallet;
338         token = Token(_token);
339     }
340 
341     /**
342      * event for token purchase logging
343      * @param purchaser who paid for the tokens
344      * @param beneficiary who got the tokens
345      * @param value weis paid for purchase
346      * @param amount amount of tokens purchased
347      */
348     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
349 
350     // Fallback function can be used to buy tokens
351     function() external payable {
352         buyTokens(msg.sender);
353     }
354 
355     // Low level token purchase function
356     function buyTokens(address beneficiary) public payable {
357         require(beneficiary != address(0));
358         require(msg.value != 0);
359         require(now > dateStart);
360         require(now <= dateEnd);
361 
362         uint256 weiAmount = msg.value;
363 
364         // calculate token amount to be created
365         uint256 tokens = weiAmount.div(10 ** 12).mul(rate);
366 
367         // update state
368         require(token.mint(beneficiary, tokens));
369         tokenRaised = tokenRaised.add(tokens);
370         require(tokenRaised <= hardCap);
371         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
372         weiRaised = weiRaised.add(weiAmount);
373         forwardFunds();
374     }
375 
376     // Send ether to the fund collection wallet
377     // override to create custom fund forwarding mechanisms
378     function forwardFunds() internal {
379         wallet.transfer(msg.value);
380     }
381 }