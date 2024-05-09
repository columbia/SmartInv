1 pragma solidity ^0.4.18;
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
43     function balanceOf(address who) public view returns (uint256);
44     function transfer(address to, uint256 value) public returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 /**
50  * @title ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/20
52  */
53 contract ERC20 is ERC20Basic {
54     function allowance(address owner, address spender) public view returns (uint256);
55     function transferFrom(address from, address to, uint256 value) public returns (bool);
56     function approve(address spender, uint256 value) public returns (bool);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 }
59 
60 /**
61  * @title Basic token
62  * @dev Basic version of StandardToken, with no allowances.
63  */
64 contract BasicToken is ERC20Basic {
65     using SafeMath for uint256;
66 
67     mapping(address => uint256) balances;
68 
69     /**
70     * @dev transfer token for a specified address
71     * @param _to The address to transfer to.
72     * @param _value The amount to be transferred.
73     */
74     function transfer(address _to, uint256 _value) public returns (bool) {
75         require(_to != address(0));
76         require(_value <= balances[msg.sender]);
77 
78         // SafeMath.sub will throw if there is not enough balance.
79         balances[msg.sender] = balances[msg.sender].sub(_value);
80         balances[_to] = balances[_to].add(_value);
81         Transfer(msg.sender, _to, _value);
82         return true;
83     }
84 
85     /**
86     * @dev Gets the balance of the specified address.
87     * @param _owner The address to query the the balance of.
88     * @return An uint256 representing the amount owned by the passed address.
89     */
90     function balanceOf(address _owner) public view returns (uint256 balance) {
91         return balances[_owner];
92     }
93 
94 }
95 
96 /**
97  * @title Standard ERC20 token
98  *
99  * @dev Implementation of the basic standard token.
100  * @dev https://github.com/ethereum/EIPs/issues/20
101  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
102  */
103 contract StandardToken is ERC20, BasicToken {
104 
105     mapping (address => mapping (address => uint256)) internal allowed;
106 
107 
108     /**
109      * @dev Transfer tokens from one address to another
110      * @param _from address The address which you want to send tokens from
111      * @param _to address The address which you want to transfer to
112      * @param _value uint256 the amount of tokens to be transferred
113      */
114     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115         require(_to != address(0));
116         require(_value <= balances[_from]);
117         require(_value <= allowed[_from][msg.sender]);
118 
119         balances[_from] = balances[_from].sub(_value);
120         balances[_to] = balances[_to].add(_value);
121         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
122         Transfer(_from, _to, _value);
123         return true;
124     }
125 
126     /**
127      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
128      *
129      * Beware that changing an allowance with this method brings the risk that someone may use both the old
130      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
131      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
132      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
133      * @param _spender The address which will spend the funds.
134      * @param _value The amount of tokens to be spent.
135      */
136     function approve(address _spender, uint256 _value) public returns (bool) {
137         allowed[msg.sender][_spender] = _value;
138         Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     /**
143      * @dev Function to check the amount of tokens that an owner allowed to a spender.
144      * @param _owner address The address which owns the funds.
145      * @param _spender address The address which will spend the funds.
146      * @return A uint256 specifying the amount of tokens still available for the spender.
147      */
148     function allowance(address _owner, address _spender) public view returns (uint256) {
149         return allowed[_owner][_spender];
150     }
151 
152     /**
153      * @dev Increase the amount of tokens that an owner allowed to a spender.
154      *
155      * approve should be called when allowed[_spender] == 0. To increment
156      * allowed value is better to use this function to avoid 2 calls (and wait until
157      * the first transaction is mined)
158      * From MonolithDAO Token.sol
159      * @param _spender The address which will spend the funds.
160      * @param _addedValue The amount of tokens to increase the allowance by.
161      */
162     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     /**
169      * @dev Decrease the amount of tokens that an owner allowed to a spender.
170      *
171      * approve should be called when allowed[_spender] == 0. To decrement
172      * allowed value is better to use this function to avoid 2 calls (and wait until
173      * the first transaction is mined)
174      * From MonolithDAO Token.sol
175      * @param _spender The address which will spend the funds.
176      * @param _subtractedValue The amount of tokens to decrease the allowance by.
177      */
178     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
179         uint oldValue = allowed[msg.sender][_spender];
180         if (_subtractedValue > oldValue) {
181             allowed[msg.sender][_spender] = 0;
182         } else {
183             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
184         }
185         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
186         return true;
187     }
188 
189 }
190 contract Ownable {
191     address public owner;
192 
193 
194     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
195 
196 
197     /**
198      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
199      * account.
200      */
201     function Ownable() public {
202         owner = msg.sender;
203     }
204 
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(msg.sender == owner);
211         _;
212     }
213 
214 
215     /**
216      * @dev Allows the current owner to transfer control of the contract to a newOwner.
217      * @param newOwner The address to transfer ownership to.
218      */
219     function transferOwnership(address newOwner) public onlyOwner {
220         require(newOwner != address(0));
221         OwnershipTransferred(owner, newOwner);
222         owner = newOwner;
223     }
224 }
225 
226 
227 contract MintableToken is StandardToken, Ownable {
228     string public constant name = "MCCoin";
229     string public constant symbol = "MCC";
230     uint8 public constant decimals = 18;
231 
232     event Mint(address indexed to, uint256 amount);
233     event MintFinished();
234 
235     bool public mintingFinished = false;
236 
237 
238     modifier canMint() {
239         require(!mintingFinished);
240         _;
241     }
242 
243     /**
244      * @dev Function to mint tokens
245      * @param _to The address that will receive the minted tokens.
246      * @param _amount The amount of tokens to mint.
247      * @return A boolean that indicates if the operation was successful.
248      */
249     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
250         totalSupply = totalSupply.add(_amount);
251         balances[_to] = balances[_to].add(_amount);
252         Mint(_to, _amount);
253         Transfer(address(0), _to, _amount);
254         return true;
255     }
256 
257     /**
258      * @dev Function to stop minting new tokens.
259      * @return True if the operation was successful.
260      */
261     function finishMinting() onlyOwner canMint public returns (bool) {
262         mintingFinished = true;
263         MintFinished();
264         return true;
265     }
266 }
267 
268 
269 /**
270  * @title Crowdsale
271  * @dev Crowdsale is a base contract for managing a token crowdsale.
272  * Crowdsales have a start and end timestamps, where investors can make
273  * token purchases and the crowdsale will assign them tokens based
274  * on a token per ETH rate. Funds collected are forwarded to a wallet
275  * as they arrive.
276  */
277 contract Crowdsale {
278     using SafeMath for uint256;
279 
280     // The token being sold
281     MintableToken public token;
282 
283     uint256 public hardCap = 100000000 * (10**18);
284 
285     // address where funds are collected
286     address public wallet = 0xD0b6c1F479eACcce7A77D5Aa3b6c9fc2213EecCb;
287 
288     // how many token units a buyer gets per wei
289     uint256 public rate = 40000;
290 
291     // amount of raised money in wei
292     uint256 public weiRaised;
293 
294     // march 1 00:00 GMT
295     uint public bonus20end = 1519862400;
296     // april 1 00:00 GMT
297     uint public bonus15end = 1522540800;
298     // may 1 00:00 GMT
299     uint public bonus10end = 1525132800;
300 
301 
302     /**
303      * event for token purchase logging
304      * @param purchaser who paid for the tokens
305      * @param beneficiary who got the tokens
306      * @param value weis paid for purchase
307      * @param amount amount of tokens purchased
308      */
309     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
310 
311     event Value(uint256 indexed value);
312 
313     function Crowdsale() public {
314         token = createTokenContract();
315     }
316 
317     // creates the token to be sold.
318     // override this method to have crowdsale of a specific mintable token.
319     function createTokenContract() internal returns (MintableToken) {
320         return new MintableToken();
321     }
322 
323     // fallback function can be used to buy tokens
324     function () external payable {
325         buyTokens(msg.sender);
326     }
327 
328     // low level token purchase function
329     function buyTokens(address beneficiary) public payable {
330         require(beneficiary != address(0));
331         require(validPurchase());
332         require(!hasEnded());
333 
334         uint256 weiAmount = msg.value;
335 
336         // calculate token amount to be created
337         uint256 tokens = weiAmount.mul(rate).mul(getCurrentBonus()).div(100);
338 
339         // update state
340         weiRaised = weiRaised.add(weiAmount);
341 
342         token.mint(beneficiary, tokens);
343         TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
344         forwardFunds();
345     }
346 
347     // send ether to the fund collection wallet
348     // override to create custom fund forwarding mechanisms
349     function forwardFunds() internal {
350         wallet.transfer(msg.value);
351     }
352 
353     // @return true if the transaction can buy tokens
354     function validPurchase() internal view returns (bool) {
355         bool nonZeroPurchase = msg.value != 0;
356         return nonZeroPurchase;
357     }
358 
359     // @return true if crowdsale event has ended
360     function hasEnded() public view returns (bool) {
361         return token.totalSupply() >= hardCap;
362     }
363 
364     function getCurrentBonus() public view returns (uint) {
365         if (now < bonus20end) return 120;
366         if (now < bonus15end) return 115;
367         if (now < bonus10end) return 110;
368         return 100;
369     }
370 }