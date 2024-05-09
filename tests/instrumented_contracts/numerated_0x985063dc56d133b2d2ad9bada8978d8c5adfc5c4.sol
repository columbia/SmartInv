1 pragma solidity ^0.4.17;
2 
3 contract ERC20Basic {
4     uint256 public totalSupply;
5     function balanceOf(address who) constant returns (uint256);
6     function transfer(address to, uint256 value) returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) constant returns (uint256);
12     function transferFrom(address from, address to, uint256 value) returns (bool);
13     function approve(address spender, uint256 value) returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19         uint256 c = a * b;
20         assert(a == 0 || c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal constant returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal constant returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract BasicToken is ERC20Basic {
44     using SafeMath for uint256;
45 
46     mapping(address => uint256) balances;
47 
48     /**
49     * @dev transfer token for a specified address
50     * @param _to The address to transfer to.
51     * @param _value The amount to be transferred.
52     */
53     function transfer(address _to, uint256 _value) returns (bool) {
54         balances[msg.sender] = balances[msg.sender].sub(_value);
55         balances[_to] = balances[_to].add(_value);
56         Transfer(msg.sender, _to, _value);
57         return true;
58     }
59 
60     /**
61     * @dev Gets the balance of the specified address.
62     * @param _owner The address to query the the balance of.
63     * @return An uint256 representing the amount owned by the passed address.
64     */
65     function balanceOf(address _owner) constant returns (uint256 balance) {
66         return balances[_owner];
67     }
68 
69 }
70 
71 contract StandardToken is ERC20, BasicToken {
72 
73     mapping (address => mapping (address => uint256)) allowed;
74 
75 
76     /**
77      * @dev Transfer tokens from one address to another
78      * @param _from address The address which you want to send tokens from
79      * @param _to address The address which you want to transfer to
80      * @param _value uint256 the amout of tokens to be transfered
81      */
82     function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
83         var _allowance = allowed[_from][msg.sender];
84 
85         // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
86         // require (_value <= _allowance);
87 
88         balances[_to] = balances[_to].add(_value);
89         balances[_from] = balances[_from].sub(_value);
90         allowed[_from][msg.sender] = _allowance.sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94 
95     /**
96      * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
97      * @param _spender The address which will spend the funds.
98      * @param _value The amount of tokens to be spent.
99      */
100     function approve(address _spender, uint256 _value) returns (bool) {
101 
102         // To change the approve amount you first have to reduce the addresses`
103         //  allowance to zero by calling `approve(_spender, 0)` if it is not
104         //  already 0 to mitigate the race condition described here:
105         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
106         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
107 
108         allowed[msg.sender][_spender] = _value;
109         Approval(msg.sender, _spender, _value);
110         return true;
111     }
112 
113     /**
114      * @dev Function to check the amount of tokens that an owner allowed to a spender.
115      * @param _owner address The address which owns the funds.
116      * @param _spender address The address which will spend the funds.
117      * @return A uint256 specifing the amount of tokens still available for the spender.
118      */
119     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
120         return allowed[_owner][_spender];
121     }
122 
123 }
124 
125 contract Ownable {
126     address public owner;
127 
128 
129     /**
130      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
131      * account.
132      */
133     function Ownable() {
134         owner = msg.sender;
135     }
136 
137 
138     /**
139      * @dev Throws if called by any account other than the owner.
140      */
141     modifier onlyOwner() {
142         require(msg.sender == owner);
143         _;
144     }
145 
146 
147     /**
148      * @dev Allows the current owner to transfer control of the contract to a newOwner.
149      * @param newOwner The address to transfer ownership to.
150      */
151     function transferOwnership(address newOwner) onlyOwner {
152         require(newOwner != address(0));
153         owner = newOwner;
154     }
155 
156 }
157 
158 contract MintableToken is StandardToken, Ownable {
159     event Mint(address indexed to, uint256 amount);
160     event MintFinished();
161 
162     bool public mintingFinished = false;
163 
164 
165     modifier canMint() {
166         require(!mintingFinished);
167         _;
168     }
169 
170     /**
171     * @dev Function to mint tokens
172     * @param _to The address that will recieve the minted tokens.
173     * @param _amount The amount of tokens to mint.
174     * @return A boolean that indicates if the operation was successful.
175     */
176     function mint(address _to, uint256 _amount) onlyOwner returns (bool) {
177         return mintInternal(_to, _amount);
178     }
179 
180     /**
181     * @dev Function to stop minting new tokens.
182     * @return True if the operation was successful.
183     */
184     function finishMinting() onlyOwner returns (bool) {
185         mintingFinished = true;
186         MintFinished();
187         return true;
188     }
189 
190     function mintInternal(address _to, uint256 _amount) internal canMint returns (bool) {
191         totalSupply = totalSupply.add(_amount);
192         balances[_to] = balances[_to].add(_amount);
193         Mint(_to, _amount);
194         return true;
195     }
196 }
197 
198 contract CustomToken is MintableToken {
199 
200     string public name;
201 
202     string public currentState = 'Inactive';
203 
204     string public symbol;
205 
206     uint8 public decimals;
207 
208     uint256 public limitPreIcoTokens;
209 
210     uint256 public weiPerToken;
211 
212     uint256 public limitIcoTokens;
213 
214     bool public preIcoActive = false;
215 
216     bool public icoActive = false;
217 
218     bool public preBountyAdded = false;
219 
220     bool public bountyAdded = false;
221 
222     bool public ownersStakeAdded = false;
223 
224     // address where funds are collected
225     address public wallet;
226 
227     // how many token units a buyer gets per wei
228     uint256 public ratePreIco;
229 
230     uint256 public rateIco;
231 
232     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
233 
234     // Only Owner can transfer balances and mint ROOTS without payment.
235     // Everybody can buy IOU ROOT token by sending some amount of ETH to the contract.
236     // Amount of purchased ROOTS determined by the Rate.
237     // All ETH are going to Wallet address.
238     // Owner can finalize the contract by `finishMinting` transaction
239     function CustomToken(
240     uint256 _ratePre,
241     uint256 _rate,
242     address _wallet,
243     string _name,
244     string _symbol,
245     uint8 _decimals,
246     uint256 _weiPerToken,
247     uint256 _limitPreICO,
248     uint256 _limitICO
249     ) {
250         require(_rate > 0);
251         require(_wallet != 0x0);
252 
253         rateIco = _rate;
254         ratePreIco = _ratePre;
255         wallet = _wallet;
256         name = _name;
257         weiPerToken = _weiPerToken;
258         symbol = _symbol;
259         decimals = _decimals;
260         limitPreIcoTokens = _limitPreICO;
261         limitIcoTokens = _limitICO;
262     }
263 
264     function transfer(address _to, uint _value) onlyOwner returns (bool) {
265         return super.transfer(_to, _value);
266     }
267 
268     function transferFrom(address _from, address _to, uint _value) onlyOwner returns (bool) {
269         return super.transferFrom(_from, _to, _value);
270     }
271 
272     function () payable {
273         buyTokens(msg.sender);
274     }
275 
276     function changeWallet(address _newWallet) onlyOwner returns (bool) {
277         require(_newWallet != 0x0);
278         wallet = _newWallet;
279         return true;
280     }
281 
282     function changeWeiPerToken(uint256 _newWeiPerToken) onlyOwner returns (bool) {
283         require(weiPerToken != 0);
284         weiPerToken = _newWeiPerToken;
285         return true;
286     }
287 
288     function stopIco(address _addrToSendSteak) onlyOwner returns (bool) {
289         require(!bountyAdded && !ownersStakeAdded);
290         require(_addrToSendSteak != 0x0);
291         icoActive = false;
292         preIcoActive = false;
293         currentState = "Ico finished";
294         addOwnersStakeAndBonty(_addrToSendSteak);
295         mintingFinished = true;
296         MintFinished();
297         return true;
298     }
299 
300     function stopPreIco() onlyOwner returns (bool) {
301         require(!preBountyAdded);
302         preIcoActive = false;
303         currentState = "Pre Ico finished";
304         addPreBounty();
305         return true;
306     }
307 
308     function startPreIco() onlyOwner returns (bool) {
309         require(!icoActive);
310         icoActive = false;
311         preIcoActive = true;
312         currentState = "Pre Ico";
313         return true;
314     }
315 
316     function startIco() onlyOwner returns (bool) {
317         icoActive = true;
318         preIcoActive = false;
319         currentState = "Ico";
320         return true;
321     }
322 
323     function buyTokens(address beneficiary) payable {
324         require(beneficiary != 0x0);
325         require(msg.value > 0);
326 
327         uint256 weiAmount = msg.value;
328 
329         uint256 rate = ratePreIco;
330         if(icoActive) rate = rateIco;
331 
332         // calculate token amount to be created
333         uint256 tokens = weiAmount.div(weiPerToken).mul(rate);
334 
335         require((preIcoActive && totalSupply + tokens <= limitPreIcoTokens) || (icoActive && totalSupply + tokens <= limitIcoTokens) );
336 
337         mintInternal(beneficiary, tokens);
338         TokenPurchase(
339         msg.sender,
340         beneficiary,
341         weiAmount,
342         tokens
343         );
344 
345         forwardFunds();
346     }
347 
348     // send ether to the fund collection wallet
349     function forwardFunds() internal {
350         wallet.transfer(msg.value);
351     }
352 
353     function addPreBounty() internal onlyOwner returns (bool status) {
354         require(!preBountyAdded);
355         uint256 additionalCount = totalSupply * 6/100;
356         preBountyAdded = true;
357         mintInternal(wallet, additionalCount);
358         return true;
359     }
360 
361     function addOwnersStakeAndBonty(address _addrToSendSteak) internal onlyOwner returns (bool status) {
362         require(!bountyAdded && !ownersStakeAdded);
363         uint256 additionalCount = totalSupply * 14/100;
364         uint256 additionalOwnersStakeCount = totalSupply * 14/100;
365         bountyAdded = true;
366         ownersStakeAdded = true;
367         mintInternal(wallet, additionalCount);
368         mintInternal(_addrToSendSteak, additionalOwnersStakeCount);
369         return true;
370     }
371 
372 }