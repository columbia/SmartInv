1 pragma solidity ^0.4.21;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 /**
50  * @title Ownable
51  * @dev The Ownable contract has an owner address, and provides basic authorization control
52  * functions, this simplifies the implementation of "user permissions".
53  */
54 contract Ownable {
55     address public owner;
56 
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60 
61     /**
62      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
63      * account.
64      */
65     function Ownable() public {
66         owner = msg.sender;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     /**
78      * @dev Allows the current owner to transfer control of the contract to a newOwner.
79      * @param newOwner The address to transfer ownership to.
80      */
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0));
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 /**
90  * @title Pausable
91  * @dev Base contract which allows children to implement an emergency stop mechanism.
92  */
93 contract Pausable is Ownable {
94     event Pause();
95     event Unpause();
96 
97     bool public paused = false;
98 
99 
100     /**
101      * @dev Modifier to make a function callable only when the contract is not paused.
102      */
103     modifier whenNotPaused() {
104         require(!paused);
105         _;
106     }
107 
108     /**
109      * @dev Modifier to make a function callable only when the contract is paused.
110      */
111     modifier whenPaused() {
112         require(paused);
113         _;
114     }
115 
116     /**
117      * @dev called by the owner to pause, triggers stopped state
118      */
119     function pause() onlyOwner whenNotPaused public {
120         paused = true;
121         emit Pause();
122     }
123 
124     /**
125      * @dev called by the owner to unpause, returns to normal state
126      */
127     function unpause() onlyOwner whenPaused public {
128         paused = false;
129         emit Unpause();
130     }
131 }
132 
133 contract ERC20Basic {
134     function totalSupply() public view returns (uint256);
135     function balanceOf(address who) public view returns (uint256);
136     function transfer(address to, uint256 value) public returns (bool);
137     event Transfer(address indexed from, address indexed to, uint256 value);
138 }
139 
140 contract BasicToken is ERC20Basic {
141     using SafeMath for uint256;
142 
143     mapping (address => uint256) balances;
144     uint256 totalSupply_;
145 
146     function totalSupply() public view returns (uint256) {
147         return totalSupply_;
148     }
149 
150     /**
151   * @dev transfer token for a specified address
152   * @param _to The address to transfer to.
153   * @param _value The amount to be transferred.
154   */
155 
156     function transfer(address _to, uint256 _value) public returns (bool) {
157         require(_to != address(0));
158         require(_value <= balances[msg.sender]);
159 
160         balances[msg.sender] = balances[msg.sender].sub(_value);
161         balances[_to] = balances[_to].add(_value);
162         emit Transfer(msg.sender, _to, _value);
163         return true;
164     }
165 
166     /**
167     * @dev Gets the balance of the specified address.
168     * @param _owner The address to query the the balance of.
169     * @return An uint256 representing the amount owned by the passed address.
170     */
171     function balanceOf(address _owner) public view returns (uint256 balance) {
172         return balances[_owner];
173     }
174 }
175 
176 contract ERC20 is ERC20Basic {
177     function allowance(address owner, address spender) public view returns (uint256);
178     function transferFrom(address from, address to, uint256 value) public returns (bool);
179     function approve(address spender, uint256 value) public returns (bool);
180 }
181 
182 contract BurnableToken is BasicToken {
183 
184     event Burn(address indexed burner, uint256 value);
185 
186     /**
187      * @dev Burns a specific amount of tokens.
188      * @param _value The amount of token to be burned.
189      */
190     function burn(uint256 _value) public {
191         require(_value <= balances[msg.sender]);
192         // no need to require value <= totalSupply, since that would imply the
193         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
194 
195         address burner = msg.sender;
196         balances[burner] = balances[burner].sub(_value);
197         totalSupply_ = totalSupply_.sub(_value);
198         emit Burn(burner, _value);
199         emit Transfer(burner, address(0), _value);
200     }
201 }
202 
203 contract StandardToken is ERC20, BurnableToken {
204 
205     mapping (address => mapping (address => uint256)) allowed;
206 
207     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
208 
209         require(_to != address(0));
210         require(_value <= balances[msg.sender]);
211         require(_value <= allowed[_from][msg.sender]);
212 
213         balances[_to] = balances[_to].add(_value);
214         balances[_from] = balances[_from].sub(_value);
215         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
216 
217         emit Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     /**
222      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
223      * @param _spender The address which will spend the funds.
224      * @param _value The amount of tokens to be spent.
225      */
226     function approve(address _spender, uint256 _value) public returns (bool) {
227         allowed[msg.sender][_spender] = _value;
228         return true;
229     }
230 
231     /**
232      * @dev Function to check the amount of tokens that an owner allowed to a spender.
233      * @param _owner address The address which owns the funds.
234      * @param _spender address The address which will spend the funds.
235      * @return A uint256 specifing the amount of tokens still avaible for the spender.
236      */
237     function allowance(address _owner, address _spender) public view returns (uint256) {
238         return allowed[_owner][_spender];
239     }
240 
241 }
242 
243 contract ASGToken is StandardToken {
244 
245     string constant public name = "ASGARD";
246     string constant public symbol = "ASG";
247     uint256 constant public decimals = 18;
248 
249     address constant public marketingWallet = 0x341570A97E15DbA3D92dcc889Fff1bbd6709D20a;
250     uint256 public marketingPart = uint256(2100000000).mul(10 ** decimals); // 8.4% = 2 100 000 000 tokens
251 
252     address constant public airdropWallet = 0xCB3D939804C97441C58D9AC6566A412768a7433B;
253     uint256 public airdropPart = uint256(1750000000).mul(10 ** decimals); // 7% = 1 750 000 000 tokens
254 
255     address constant public bountyICOWallet = 0x5570EE8D93e730D8867A113ae45fB348BFc2e138;
256     uint256 public bountyICOPart = uint256(375000000).mul(10 ** decimals); // 1.5% = 375 000 000 tokens
257 
258     address constant public bountyECOWallet = 0x89d90bA8135C77cDE1C3297076C5e1209806f048;
259     uint256 public bountyECOPart = uint256(375000000).mul(10 ** decimals); // 1.5% = 375 000 000 tokens
260 
261     address constant public foundersWallet = 0xE03d060ac22fdC21fDF42eB72Eb4d8BA2444b1B0;
262     uint256 public foundersPart = uint256(2500000000).mul(10 ** decimals); // 10% = 2 500 000 000 tokens
263 
264     address constant public cryptoExchangeWallet = 0x5E74DcA28cE21Bf066FC9eb7D10946316528d4d6;
265     uint256 public cryptoExchangePart = uint256(400000000).mul(10 ** decimals); // 1.6% = 400 000 000 tokens
266 
267     address constant public ICOWallet = 0xCe2d50c646e83Ae17B7BFF3aE7611EDF0a75E03d;
268     uint256 public ICOPart = uint256(10000000000).mul(10 ** decimals); // 40% = 10 000 000 000 tokens
269 
270     address constant public PreICOWallet = 0x83D921224c8B3E4c60E286B98Fd602CBa5d7B1AB;
271     uint256 public PreICOPart = uint256(7500000000).mul(10 ** decimals); // 30% = 7 500 000 000 tokens
272 
273     uint256 public INITIAL_SUPPLY = uint256(25000000000).mul(10 ** decimals); // 100% = 25 000 000 000 tokens
274 
275     constructor() public {
276         totalSupply_ = INITIAL_SUPPLY;
277 
278         balances[marketingWallet] = marketingPart;
279         emit Transfer(this, marketingWallet, marketingPart); // 8.4%
280 
281         balances[airdropWallet] = airdropPart;
282         emit Transfer(this, airdropWallet, airdropPart); // 7%
283 
284         balances[bountyICOWallet] = bountyICOPart;
285         emit Transfer(this, bountyICOWallet, bountyICOPart); // 1.5%
286 
287         balances[bountyECOWallet] = bountyECOPart;
288         emit Transfer(this, bountyECOWallet, bountyECOPart); // 1.5%
289 
290         balances[foundersWallet] = foundersPart;
291         emit Transfer(this, foundersWallet, foundersPart); // 10%
292 
293         balances[cryptoExchangeWallet] = cryptoExchangePart;
294         emit Transfer(this, cryptoExchangeWallet, cryptoExchangePart); // 1.6%
295 
296         balances[ICOWallet] = ICOPart;
297         emit Transfer(this, ICOWallet, ICOPart); // 40%
298 
299         balances[PreICOWallet] = PreICOPart;
300         emit Transfer(this, PreICOWallet, PreICOPart); // 30%
301     }
302 
303 }
304 
305 contract ASGPresale is Pausable {
306     using SafeMath for uint256;
307 
308     ASGToken public tokenReward;
309     uint256 constant public decimals = 1000000000000000000; // 10 ** 18
310 
311     uint256 public minimalPriceUSD = 5350; // 53.50 USD
312     uint256 public ETHUSD = 390; // 1 ETH = 390 USD
313     uint256 public tokenPricePerUSD = 1666; // 1 ASG = 0.1666 USD
314     uint256 public bonus = 0;
315     uint256 public tokensRaised;
316 
317     constructor(address _tokenReward) public {
318         tokenReward = ASGToken(_tokenReward);
319     }
320 
321     function () public payable {
322         buy(msg.sender);
323     }
324 
325     function buy(address buyer) whenNotPaused public payable {
326         require(buyer != address(0));
327         require(msg.value.mul(ETHUSD) >= minimalPriceUSD.mul(decimals).div(100));
328 
329         uint256 tokens = msg.value.mul(ETHUSD).mul(bonus.add(100)).div(100).mul(10000).div(tokenPricePerUSD);
330         tokenReward.transfer(buyer, tokens);
331         tokensRaised = tokensRaised.add(tokens);
332     }
333 
334     function tokenTransfer(address who, uint256 amount) onlyOwner public {
335         uint256 tokens = amount.mul(decimals);
336         tokenReward.transfer(who, tokens);
337         tokensRaised = tokensRaised.add(tokens);
338     }
339 
340     function updateMinimal(uint256 _minimalPriceUSD) onlyOwner public {
341         minimalPriceUSD = _minimalPriceUSD;
342     }
343 
344     function updatePriceETHUSD(uint256 _ETHUSD) onlyOwner public {
345         ETHUSD = _ETHUSD;
346     }
347 
348     function updatePriceASGUSD(uint256 _tokenPricePerUSD) onlyOwner public {
349         tokenPricePerUSD = _tokenPricePerUSD;
350     }
351 
352     function updateBonus(uint256 _bonus) onlyOwner public {
353         require(bonus <= 50);
354         bonus = _bonus;
355     }
356 
357     function finishPresale() onlyOwner public {
358         owner.transfer(address(this).balance);
359         uint256 tokenBalance = tokenReward.balanceOf(address(this));
360         tokenReward.transfer(owner, tokenBalance);
361     }
362 
363 }