1 pragma solidity ^0.4.24;
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
12     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13         if (a == 0) {
14             return 0;
15         }
16         uint256 c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     /**
32     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     /**
71      * @dev Throws if called by any account other than the owner.
72      */
73     modifier onlyOwner() {
74         require(msg.sender == owner);
75         _;
76     }
77 
78     /**
79      * @dev Allows the current owner to transfer control of the contract to a newOwner.
80      * @param newOwner The address to transfer ownership to.
81      */
82     function transferOwnership(address newOwner) public onlyOwner {
83         emit OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85     }
86 
87 }
88 
89 
90 contract BasicERC20
91 {
92     /* Public variables of the token */
93     string public standard = 'ERC20';
94     string public name;
95     string public symbol;
96     uint8 public decimals;
97     uint256 public totalSupply;
98     bool public isTokenTransferable = true;
99 
100     /* This creates an array with all balances */
101     mapping (address => uint256) public balanceOf;
102     mapping (address => mapping (address => uint256)) public allowance;
103 
104     /* This generates a public event on the blockchain that will notify clients */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /* Send coins */
108     function transfer(address _to, uint256 _value) public {
109         assert(isTokenTransferable);
110         assert(balanceOf[msg.sender] >= _value);             // Check if the sender has enough
111         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
112         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
113         balanceOf[_to] += _value;                            // Add the same to the recipient
114         emit Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
115     }
116 
117     /* Allow another contract to spend some tokens in your behalf */
118     function approve(address _spender, uint256 _value) public
119     returns (bool success)  {
120         allowance[msg.sender][_spender] = _value;
121         return true;
122     }
123 
124     /* A contract attempts to get the coins */
125     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
126         assert(isTokenTransferable);
127         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
128         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
129         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
130         balanceOf[_from] -= _value;                          // Subtract from the sender
131         balanceOf[_to] += _value;                            // Add the same to the recipient
132         allowance[_from][msg.sender] -= _value;
133         emit Transfer(_from, _to, _value);
134         return true;
135     }
136 }
137 
138 
139 
140 
141 
142 
143 
144 
145 
146 
147 
148 
149 
150 
151 contract BasicCrowdsale is Ownable
152 {
153     using SafeMath for uint256;
154     BasicERC20 token;
155 
156     address public ownerWallet;
157     uint256 public startTime;
158     uint256 public endTime;
159     uint256 public totalEtherRaised = 0;
160     uint256 public minDepositAmount;
161     uint256 public maxDepositAmount;
162 
163     uint256 public softCapEther;
164     uint256 public hardCapEther;
165 
166     mapping(address => uint256) private deposits;
167 
168     constructor () public {
169 
170     }
171 
172     function () external payable {
173         buy(msg.sender);
174     }
175 
176     function getSettings () view public returns(uint256 _startTime,
177         uint256 _endTime,
178         uint256 _rate,
179         uint256 _totalEtherRaised,
180         uint256 _minDepositAmount,
181         uint256 _maxDepositAmount,
182         uint256 _tokensLeft ) {
183 
184         _startTime = startTime;
185         _endTime = endTime;
186         _rate = getRate();
187         _totalEtherRaised = totalEtherRaised;
188         _minDepositAmount = minDepositAmount;
189         _maxDepositAmount = maxDepositAmount;
190         _tokensLeft = tokensLeft();
191     }
192 
193     function tokensLeft() view public returns (uint256)
194     {
195         return token.balanceOf(address(0x0));
196     }
197 
198     function changeMinDepositAmount (uint256 _minDepositAmount) onlyOwner public {
199         minDepositAmount = _minDepositAmount;
200     }
201 
202     function changeMaxDepositAmount (uint256 _maxDepositAmount) onlyOwner public {
203         maxDepositAmount = _maxDepositAmount;
204     }
205 
206     function getRate() view public returns (uint256) {
207         assert(false);
208     }
209 
210     function getTokenAmount(uint256 weiAmount) public view returns(uint256) {
211         return weiAmount.mul(getRate());
212     }
213 
214     function checkCorrectPurchase() view internal {
215         require(startTime < now && now < endTime);
216         require(msg.value > minDepositAmount);
217         require(msg.value < maxDepositAmount);
218         require(totalEtherRaised + msg.value < hardCapEther);
219     }
220 
221     function isCrowdsaleFinished() view public returns(bool)
222     {
223         return totalEtherRaised >= hardCapEther || now > endTime;
224     }
225 
226     function buy(address userAddress) public payable {
227         require(userAddress != address(0));
228         checkCorrectPurchase();
229 
230         // calculate token amount to be created
231         uint256 tokens = getTokenAmount(msg.value);
232 
233         // update state
234         totalEtherRaised = totalEtherRaised.add(msg.value);
235 
236         token.transferFrom(address(0x0), userAddress, tokens);
237 
238         if (totalEtherRaised >= softCapEther)
239         {
240             ownerWallet.transfer(this.balance);
241         }
242         else
243         {
244             deposits[userAddress] = deposits[userAddress].add(msg.value);
245         }
246     }
247 
248     function getRefundAmount(address userAddress) view public returns (uint256)
249     {
250         if (totalEtherRaised >= softCapEther) return 0;
251         return deposits[userAddress];
252     }
253 
254     function refund(address userAddress) public
255     {
256         assert(totalEtherRaised < softCapEther && now > endTime);
257         uint256 amount = deposits[userAddress];
258         deposits[userAddress] = 0;
259         userAddress.transfer(amount);
260     }
261 }
262 
263 
264 contract CrowdsaleCompatible is BasicERC20, Ownable
265 {
266     BasicCrowdsale public crowdsale = BasicCrowdsale(0x0);
267 
268     // anyone can unfreeze tokens when crowdsale is finished
269     function unfreezeTokens() public
270     {
271         assert(now > crowdsale.endTime());
272         isTokenTransferable = true;
273     }
274 
275     // change owner to 0x0 to lock this function
276     function initializeCrowdsale(address crowdsaleContractAddress, uint256 tokensAmount) onlyOwner public  {
277         transfer((address)(0x0), tokensAmount);
278         allowance[(address)(0x0)][crowdsaleContractAddress] = tokensAmount;
279         crowdsale = BasicCrowdsale(crowdsaleContractAddress);
280         isTokenTransferable = false;
281         transferOwnership(0x0); // remove an owner
282     }
283 }
284 
285 
286 
287 
288 
289 
290 
291 contract EditableToken is BasicERC20, Ownable {
292     using SafeMath for uint256;
293 
294     // change owner to 0x0 to lock this function
295     function editTokenProperties(string _name, string _symbol, int256 extraSupplay) onlyOwner public {
296         name = _name;
297         symbol = _symbol;
298         if (extraSupplay > 0)
299         {
300             balanceOf[owner] = balanceOf[owner].add(uint256(extraSupplay));
301             totalSupply = totalSupply.add(uint256(extraSupplay));
302             emit Transfer(address(0x0), owner, uint256(extraSupplay));
303         }
304         else if (extraSupplay < 0)
305         {
306             balanceOf[owner] = balanceOf[owner].sub(uint256(extraSupplay * -1));
307             totalSupply = totalSupply.sub(uint256(extraSupplay * -1));
308             emit Transfer(owner, address(0x0), uint256(extraSupplay * -1));
309         }
310     }
311 }
312 
313 
314 
315 
316 
317 
318 
319 contract ThirdPartyTransferableToken is BasicERC20{
320     using SafeMath for uint256;
321 
322     struct confidenceInfo {
323         uint256 nonce;
324         mapping (uint256 => bool) operation;
325     }
326     mapping (address => confidenceInfo) _confidence_transfers;
327 
328     function nonceOf(address src) view public returns (uint256) {
329         return _confidence_transfers[src].nonce;
330     }
331 
332     function transferByThirdParty(uint256 nonce, address where, uint256 amount, uint8 v, bytes32 r, bytes32 s) public returns (bool){
333         assert(where != address(this));
334         assert(where != address(0x0));
335 
336         bytes32 hash = sha256(this, nonce, where, amount);
337         address src = ecrecover(keccak256("\x19Ethereum Signed Message:\n32", hash),v,r,s);
338         assert(balanceOf[src] >= amount);
339         assert(nonce == _confidence_transfers[src].nonce+1);
340 
341         assert(_confidence_transfers[src].operation[uint256(hash)]==false);
342 
343         balanceOf[src] = balanceOf[src].sub(amount);
344         balanceOf[where] = balanceOf[where].add(amount);
345         _confidence_transfers[src].nonce += 1;
346         _confidence_transfers[src].operation[uint256(hash)] = true;
347 
348         emit Transfer(src, where, amount);
349 
350         return true;
351     }
352 }
353 
354 
355 
356 contract ERC20Token is CrowdsaleCompatible, EditableToken, ThirdPartyTransferableToken {
357     using SafeMath for uint256;
358 
359     /* Initializes contract with initial supply tokens to the creator of the contract */
360     constructor() public
361     {
362         balanceOf[0x0d3e2e1e260089747c30e32bc320a953e6d33dc9] = uint256(1000000) * 10**18;
363         emit Transfer(address(0x0), 0x0d3e2e1e260089747c30e32bc320a953e6d33dc9, balanceOf[0x0d3e2e1e260089747c30e32bc320a953e6d33dc9]);
364 
365         transferOwnership(0x0d3e2e1e260089747c30e32bc320a953e6d33dc9);
366 
367         totalSupply = 1000000 * 10**18;                  // Update total supply
368         name = 'Credo';                                   // Set the name for display purposes
369         symbol = 'CRD';                               // Set the symbol for display purposes
370         decimals = 18;                                           // Amount of decimals for display purposes
371     }
372 
373     /* This unnamed function is called whenever someone tries to send ether to it */
374     function () public {
375         assert(false);     // Prevents accidental sending of ether
376     }
377 }