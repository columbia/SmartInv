1 pragma solidity ^0.4.15;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5         uint256 c = a * b;
6         if (a != 0 && c / a != b) revert();
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal constant returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         if (b > a) revert();
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         if (c < a) revert();
25         return c;
26     }
27 }
28 
29 contract ERC20Basic {
30     uint256 public totalSupply;
31 
32     function balanceOf(address who) public constant returns (uint256);
33 
34     function transfer(address to, uint256 value) public returns (bool);
35 
36     event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 /**
40  * @title ERC20 interface
41  * @dev see https://github.com/ethereum/EIPs/issues/20
42  */
43 contract ERC20 is ERC20Basic {
44     function allowance(address owner, address spender) public constant returns (uint256);
45 
46     function transferFrom(address from, address to, uint256 value) public returns (bool);
47 
48     function approve(address spender, uint256 value) public returns (bool);
49 
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 /**
54  * @title Basic token
55  * @dev Basic version of StandardToken, with no allowances.
56  */
57 contract BasicToken is ERC20Basic {
58     using SafeMath for uint256;
59 
60     mapping (address => uint256) balances;
61 
62     /**
63     * @dev transfer token for a specified address
64     * @param _to The address to transfer to.
65     * @param _value The amount to be transferred.
66     */
67     function transfer(address _to, uint256 _value) public returns (bool) {
68         require(_to != address(0));
69 
70         // SafeMath.sub will throw if there is not enough balance.
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     /**
78     * @dev Gets the balance of the specified address.
79     * @param _owner The address to query the the balance of.
80     * @return An uint256 representing the amount owned by the passed address.
81     */
82     function balanceOf(address _owner) public constant returns (uint256 balance) {
83         return balances[_owner];
84     }
85 
86 }
87 
88 /**
89  * @title Standard ERC20 token
90  *
91  * @dev Implementation of the basic standard token.
92  * @dev https://github.com/ethereum/EIPs/issues/20
93  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
94  */
95 contract StandardToken is ERC20, BasicToken {
96 
97     mapping (address => mapping (address => uint256)) allowed;
98 
99 
100     /**
101      * @dev Transfer tokens from one address to another
102      * @param _from address The address which you want to send tokens from
103      * @param _to address The address which you want to transfer to
104      * @param _value uint256 the amount of tokens to be transferred
105      */
106     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
107         require(_to != address(0));
108 
109         uint256 _allowance = allowed[_from][msg.sender];
110 
111         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
112         // require (_value <= _allowance);
113 
114         balances[_from] = balances[_from].sub(_value);
115         balances[_to] = balances[_to].add(_value);
116         allowed[_from][msg.sender] = _allowance.sub(_value);
117         Transfer(_from, _to, _value);
118         return true;
119     }
120 
121     /**
122      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
123      *
124      * Beware that changing an allowance with this method brings the risk that someone may use both the old
125      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
126      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      * @param _spender The address which will spend the funds.
129      * @param _value The amount of tokens to be spent.
130      */
131     function approve(address _spender, uint256 _value) public returns (bool) {
132         allowed[msg.sender][_spender] = _value;
133         Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     /**
138      * @dev Function to check the amount of tokens that an owner allowed to a spender.
139      * @param _owner address The address which owns the funds.
140      * @param _spender address The address which will spend the funds.
141      * @return A uint256 specifying the amount of tokens still available for the spender.
142      */
143     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146 
147     /**
148      * approve should be called when allowed[_spender] == 0. To increment
149      * allowed value is better to use this function to avoid 2 calls (and wait until
150      * the first transaction is mined)
151      * From MonolithDAO Token.sol
152      */
153     function increaseApproval(address _spender, uint _addedValue)
154     returns (bool success) {
155         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
156         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
157         return true;
158     }
159 
160     function decreaseApproval(address _spender, uint _subtractedValue)
161     returns (bool success) {
162         uint oldValue = allowed[msg.sender][_spender];
163         if (_subtractedValue > oldValue) {
164             allowed[msg.sender][_spender] = 0;
165         }
166         else {
167             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
168         }
169         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
170         return true;
171     }
172 
173 }
174 /**
175  * @title Ownable
176  * @dev The Ownable contract has an owner address, and provides basic authorization control
177  * functions, this simplifies the implementation of "user permissions".
178  */
179 contract Ownable {
180     address public owner;
181 
182     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
183     /**
184      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185      * account.
186      */
187     function Ownable() {
188         owner = msg.sender;
189     }
190 
191     /**
192      * @dev Throws if called by any account other than the owner.
193      */
194     modifier onlyOwner() {
195         require(msg.sender == owner);
196         _;
197     }
198 
199     /**
200      * @dev Allows the current owner to transfer control of the contract to a newOwner.
201      * @param newOwner The address to transfer ownership to.
202      */
203     function transferOwnership(address newOwner) onlyOwner public {
204         require(newOwner != address(0));
205         OwnershipTransferred(owner, newOwner);
206         owner = newOwner;
207     }
208 
209 }
210 
211 
212 /**
213  * @title IRBTokens
214  * @dev IRB Token contract based on Zeppelin StandardToken contract
215  */
216 contract IRBToken is StandardToken, Ownable {
217     using SafeMath for uint256;
218 
219     /**
220      * @dev ERC20 descriptor variables
221      */
222     string public constant name = "IRB Tokens";
223 
224     string public constant symbol = "IRB";
225 
226     uint8 public decimals = 18;
227 
228     /**
229      * @dev 489.58 millions s the initial Token sale
230      */
231     uint256 public constant crowdsaleTokens = 489580 * 10 ** 21;
232 
233     /**
234      * @dev 10.42 millions is the initial Token presale
235      */
236     uint256 public constant preCrowdsaleTokens = 10420 * 10 ** 21;
237 
238     // TODO: TestRPC addresses, replace to real
239     // PRE Crowdsale Tokens Wallet
240     address public constant preCrowdsaleTokensWallet = 0x0CD95a59fAd089c4EBCCEB54f335eC8f61Caa80e;
241     // Crowdsale Tokens Wallet
242     address public constant crowdsaleTokensWallet = 0x48545E41696Dc51020C35cA8C36b678101a98437;
243 
244     /**
245      * @dev Address of PRE Crowdsale contract which will be compared
246      *       against in the appropriate modifier check
247      */
248     address public preCrowdsaleContractAddress;
249 
250     /**
251      * @dev Address of Crowdsale contract which will be compared
252      *       against in the appropriate modifier check
253      */
254     address public crowdsaleContractAddress;
255 
256     /**
257      * @dev variable that holds flag of ended pre tokensake
258      */
259     bool isPreFinished = false;
260 
261     /**
262      * @dev variable that holds flag of ended tokensake
263      */
264     bool isFinished = false;
265 
266     /**
267      * @dev Modifier that allow only the Crowdsale contract to be sender
268      */
269     modifier onlyPreCrowdsaleContract() {
270         require(msg.sender == preCrowdsaleContractAddress);
271         _;
272     }
273 
274     /**
275      * @dev Modifier that allow only the Crowdsale contract to be sender
276      */
277     modifier onlyCrowdsaleContract() {
278         require(msg.sender == crowdsaleContractAddress);
279         _;
280     }
281 
282     /**
283      * @dev event for the burnt tokens after crowdsale logging
284      * @param tokens amount of tokens available for crowdsale
285      */
286     event TokensBurnt(uint256 tokens);
287 
288     /**
289      * @dev event for the tokens contract move to the active state logging
290      * @param supply amount of tokens left after all the unsold was burned
291      */
292     event Live(uint256 supply);
293 
294     /**
295      * @dev Contract constructor
296      */
297     function IRBToken() {
298         // Issue pre crowdsale tokens
299         balances[preCrowdsaleTokensWallet] = balanceOf(preCrowdsaleTokensWallet).add(preCrowdsaleTokens);
300         Transfer(address(0), preCrowdsaleTokensWallet, preCrowdsaleTokens);
301 
302         // Issue crowdsale tokens
303         balances[crowdsaleTokensWallet] = balanceOf(crowdsaleTokensWallet).add(crowdsaleTokens);
304         Transfer(address(0), crowdsaleTokensWallet, crowdsaleTokens);
305 
306         // 500 millions tokens overall
307         totalSupply = crowdsaleTokens.add(preCrowdsaleTokens);
308     }
309 
310     /**
311      * @dev back link IRBToken contract with IRBPreCrowdsale one
312      * @param _preCrowdsaleAddress non zero address of IRBPreCrowdsale contract
313      */
314     function setPreCrowdsaleAddress(address _preCrowdsaleAddress) onlyOwner external {
315         require(_preCrowdsaleAddress != address(0));
316         preCrowdsaleContractAddress = _preCrowdsaleAddress;
317 
318         // Allow pre crowdsale contract
319         uint256 balance = balanceOf(preCrowdsaleTokensWallet);
320         allowed[preCrowdsaleTokensWallet][preCrowdsaleContractAddress] = balance;
321         Approval(preCrowdsaleTokensWallet, preCrowdsaleContractAddress, balance);
322     }
323 
324     /**
325      * @dev back link IRBToken contract with IRBCrowdsale one
326      * @param _crowdsaleAddress non zero address of IRBCrowdsale contract
327      */
328     function setCrowdsaleAddress(address _crowdsaleAddress) onlyOwner external {
329         require(isPreFinished);
330         require(_crowdsaleAddress != address(0));
331         crowdsaleContractAddress = _crowdsaleAddress;
332 
333         // Allow crowdsale contract
334         uint256 balance = balanceOf(crowdsaleTokensWallet);
335         allowed[crowdsaleTokensWallet][crowdsaleContractAddress] = balance;
336         Approval(crowdsaleTokensWallet, crowdsaleContractAddress, balance);
337     }
338 
339     /**
340      * @dev called only by linked IRBPreCrowdsale contract to end precrowdsale.
341      */
342     function endPreTokensale() onlyPreCrowdsaleContract external {
343         require(!isPreFinished);
344         uint256 preCrowdsaleLeftovers = balanceOf(preCrowdsaleTokensWallet);
345 
346         if (preCrowdsaleLeftovers > 0) {
347             balances[preCrowdsaleTokensWallet] = 0;
348             balances[crowdsaleTokensWallet] = balances[crowdsaleTokensWallet].add(preCrowdsaleLeftovers);
349             Transfer(preCrowdsaleTokensWallet, crowdsaleTokensWallet, preCrowdsaleLeftovers);
350         }
351 
352         isPreFinished = true;
353     }
354 
355     /**
356      * @dev called only by linked IRBCrowdsale contract to end crowdsale.
357      */
358     function endTokensale() onlyCrowdsaleContract external {
359         require(!isFinished);
360         uint256 crowdsaleLeftovers = balanceOf(crowdsaleTokensWallet);
361 
362         if (crowdsaleLeftovers > 0) {
363             totalSupply = totalSupply.sub(crowdsaleLeftovers);
364 
365             balances[crowdsaleTokensWallet] = 0;
366             Transfer(crowdsaleTokensWallet, address(0), crowdsaleLeftovers);
367             TokensBurnt(crowdsaleLeftovers);
368         }
369 
370         isFinished = true;
371         Live(totalSupply);
372     }
373 }