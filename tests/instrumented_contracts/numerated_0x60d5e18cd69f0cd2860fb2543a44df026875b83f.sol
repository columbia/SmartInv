1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // 'FIXED' 'Example Fixed Supply Token' token contract
5 //
6 // Symbol      : VXCR2
7 // Name        : Vixcore 2
8 // Total supply: 10,000,000,000.000000000000000000
9 // Decimals    : 18
10 //
11 // Enjoy.
12 //
13 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
14 // ----------------------------------------------------------------------------
15 //https://remix.ethereum.org/#optimize=true&version=soljson-v0.4.24+commit.e67f0147.js
16 //
17 
18 
19 // ----------------------------------------------------------------------------
20 // Safe maths
21 // ----------------------------------------------------------------------------
22 library SafeMath {
23 
24     /**
25     * @dev Multiplies two numbers, reverts on overflow.
26     */
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
29         // benefit is lost if 'b' is also tested.
30         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
31         if (a == 0) {
32             return 0;
33         }
34 
35         uint256 c = a * b;
36         require(c / a == b);
37 
38         return c;
39     }
40 
41     /**
42     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
43     */
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b > 0); // Solidity only automatically asserts when dividing by 0
46         uint256 c = a / b;
47         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48 
49         return c;
50     }
51 
52     /**
53     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
54     */
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         require(b <= a);
57         uint256 c = a - b;
58 
59         return c;
60     }
61 
62     /**
63     * @dev Adds two numbers, reverts on overflow.
64     */
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a);
68 
69         return c;
70     }
71 
72     /**
73     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
74     * reverts when dividing by zero.
75     */
76     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
77         require(b != 0);
78         return a % b;
79     }
80 }
81 
82 
83 
84 // ----------------------------------------------------------------------------
85 // ERC Token Standard #20 Interface
86 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
87 // ----------------------------------------------------------------------------
88 contract ERC20Interface {
89     function totalSupply() public constant returns (uint);
90     function balanceOf(address tokenOwner) public constant returns (uint balance);
91     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
92     function transfer(address to, uint tokens) public returns (bool success);
93     function approve(address spender, uint tokens) public returns (bool success);
94     function transferFrom(address from, address to, uint tokens) public returns (bool success);
95 
96     event Transfer(address indexed from, address indexed to, uint tokens);
97     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
98 }
99 
100 
101 // ----------------------------------------------------------------------------
102 // Contract function to receive approval and execute function in one call
103 //
104 // Borrowed from MiniMeToken
105 // ----------------------------------------------------------------------------
106 contract ApproveAndCallFallBack {
107     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
108 }
109 
110 
111 // ----------------------------------------------------------------------------
112 // Owned contract
113 // ----------------------------------------------------------------------------
114 contract Owned {
115     address public owner;
116     address public newOwner;
117 
118     event OwnershipTransferred(address indexed _from, address indexed _to);
119 
120     constructor() public {
121         owner = msg.sender;
122     }
123 
124     modifier onlyOwner {
125         require(msg.sender == owner);
126         _;
127     }
128 
129     function transferOwnership(address _newOwner) public onlyOwner {
130         newOwner = _newOwner;
131     }
132     function acceptOwnership() public {
133         require(msg.sender == newOwner);
134         emit OwnershipTransferred(owner, newOwner);
135         owner = newOwner;
136         newOwner = address(0);
137     }
138 } 
139 
140 // ----------------------------------------------------------------------------
141 // ERC20 Token, with the addition of symbol, name and decimals and a
142 // fixed supply
143 // ----------------------------------------------------------------------------
144 contract FixedSupplyToken is ERC20Interface, Owned {
145     using SafeMath for uint;
146 
147     string public symbol;
148     string public  name;
149     uint8 public decimals;
150     uint _totalSupply; 
151     
152     bool public allowCrowdsale;
153     uint public weiPerUToken;
154     uint public bonusMinWei;
155     uint public bonusPct; 
156 
157     mapping(address => uint) balances;
158     mapping(address => mapping(address => uint)) allowed;
159     
160     // ------------------------------------------------------------------------
161     // Custom Events
162     // ------------------------------------------------------------------------
163     event Burn(address indexed from, uint256 value);
164     event Bonus(address indexed from, uint256 value); 
165 
166 
167     // ------------------------------------------------------------------------
168     // Constructor
169     // ------------------------------------------------------------------------
170     constructor() public {
171         symbol = "XLR";
172         name = "Xunilair";
173         decimals = 18;
174         _totalSupply = 88000000000000000000000000000; //88000000000 * 1000000000000000000;
175 
176 
177         allowCrowdsale = false;
178         weiPerUToken = 5500000;
179         bonusMinWei = 0;
180         bonusPct = 0; 
181 
182         balances[owner] = _totalSupply;
183         emit Transfer(address(0), owner, _totalSupply);
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Total supply
189     // ------------------------------------------------------------------------
190     function totalSupply() public view returns (uint) {
191         return _totalSupply.sub(balances[address(0)]);
192     }
193 
194 
195     // ------------------------------------------------------------------------
196     // Get the token balance for account `tokenOwner`
197     // ------------------------------------------------------------------------
198     function balanceOf(address tokenOwner) public view returns (uint balance) {
199         return balances[tokenOwner];
200     }
201 
202 
203     // ------------------------------------------------------------------------
204     // Transfer the balance from token owner's account to `to` account
205     // - Owner's account must have sufficient balance to transfer
206     // - 0 value transfers are allowed
207     // ------------------------------------------------------------------------
208     function transfer(address to, uint tokens) public returns (bool success) {
209         balances[msg.sender] = balances[msg.sender].sub(tokens);
210         balances[to] = balances[to].add(tokens);
211         emit Transfer(msg.sender, to, tokens);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Token owner can approve for `spender` to transferFrom(...) `tokens`
218     // from the token owner's account
219     //
220     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
221     // recommends that there are no checks for the approval double-spend attack
222     // as this should be implemented in user interfaces 
223     // ------------------------------------------------------------------------
224     function approve(address spender, uint tokens) public returns (bool success) {
225         allowed[msg.sender][spender] = tokens;
226         emit Approval(msg.sender, spender, tokens);
227         return true;
228     }
229 
230 
231     // ------------------------------------------------------------------------
232     // Transfer `tokens` from the `from` account to the `to` account
233     // 
234     // The calling account must already have sufficient tokens approve(...)-d
235     // for spending from the `from` account and
236     // - From account must have sufficient balance to transfer
237     // - Spender must have sufficient allowance to transfer
238     // - 0 value transfers are allowed
239     // ------------------------------------------------------------------------
240     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
241         balances[from] = balances[from].sub(tokens);
242         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
243         balances[to] = balances[to].add(tokens);
244         emit Transfer(from, to, tokens);
245         return true;
246     }
247 
248 
249     // ------------------------------------------------------------------------
250     // Returns the amount of tokens approved by the owner that can be
251     // transferred to the spender's account
252     // ------------------------------------------------------------------------
253     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
254         return allowed[tokenOwner][spender];
255     }
256 
257 
258     // ------------------------------------------------------------------------
259     // Token owner can approve for `spender` to transferFrom(...) `tokens`
260     // from the token owner's account. The `spender` contract function
261     // `receiveApproval(...)` is then executed
262     // ------------------------------------------------------------------------
263     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
264         allowed[msg.sender][spender] = tokens;
265         emit Approval(msg.sender, spender, tokens);
266         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
267         return true;
268     }
269 
270 
271     // ------------------------------------------------------------------------
272     // Owner can transfer out any accidentally sent ERC20 tokens
273     // ------------------------------------------------------------------------
274     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
275         return ERC20Interface(tokenAddress).transfer(owner, tokens);
276     }
277 
278 
279     // ------------------------------------------------------------------------
280     // Crowdsale 
281     // ------------------------------------------------------------------------
282     function () public payable {
283         //crowd sale is open/allowed
284         require(allowCrowdsale); 
285         
286         uint ethValue = msg.value;
287         
288         //get token equivalent
289         uint tokens = ethValue.mul(weiPerUToken);
290 
291         
292         //append bonus if we have active bonus promo
293         //and if ETH sent is more than then minimum required to avail bonus
294         if(bonusPct > 0 && ethValue >= bonusMinWei){
295             //compute bonus value based on percentage
296             uint bonus = tokens.div(100).mul(bonusPct);
297             
298             //emit bonus event
299             emit Bonus(msg.sender, bonus);
300             
301             //add bonus to final amount of token to be 
302             //transferred to sender/purchaser
303             tokens = tokens.add(bonus);
304         }
305         
306         
307         //validate token amount 
308         //assert(tokens > 0);
309         //assert(tokens <= balances[owner]);  
310         
311 
312         //transfer from owner to sender/purchaser
313         balances[owner] = balances[owner].sub(tokens);
314         balances[msg.sender] = balances[msg.sender].add(tokens);
315         
316         //emit transfer event
317         emit Transfer(owner, msg.sender, tokens);
318     } 
319 
320 
321     // ------------------------------------------------------------------------
322     // Open the token for Crowdsale 
323     // ------------------------------------------------------------------------
324     function openPurchase() public onlyOwner{
325         allowCrowdsale = true; 
326     }
327 
328 
329     // ------------------------------------------------------------------------
330     // Close the token for Crowdsale 
331     // ------------------------------------------------------------------------
332     function closePurchase() public onlyOwner{
333         allowCrowdsale = false; 
334     }
335 
336 
337     // ------------------------------------------------------------------------
338     // Set the ICO price. 
339     // E.g. : _weiPerUToken = 550,0000 to get 55,000 Token per 0.01 ETH
340     // ------------------------------------------------------------------------
341     function setIcoPrice(uint _weiPerUToken) public onlyOwner{ 
342         weiPerUToken = _weiPerUToken;
343     } 
344 
345 
346     // ------------------------------------------------------------------------
347     // Set crowdsale bonus percentage and its minimum
348     // ------------------------------------------------------------------------
349     function setBonus(uint _bonusPct, uint _minWei) public onlyOwner {
350         bonusMinWei = _minWei;
351         bonusPct = _bonusPct;
352     }
353 
354 
355     // ------------------------------------------------------------------------
356     // Burn token
357     // ------------------------------------------------------------------------
358     function burn(uint256 _value) public onlyOwner {
359         require(_value > 0);
360         require(_value <= balances[msg.sender]); 
361 
362         address burner = msg.sender;
363         
364         //deduct from initiator's balance
365         balances[burner] = balances[burner].sub(_value);
366         
367         //deduct from total supply
368         _totalSupply = _totalSupply.sub(_value);
369         
370         emit Burn(burner, _value); 
371     } 
372 
373 
374     // ------------------------------------------------------------------------
375     // Withdraw
376     // ------------------------------------------------------------------------ 
377     function withdraw(uint _amount) onlyOwner public {
378         require(_amount > 0);
379         
380         // Amount withdraw should be less or equal to balance
381         require(_amount <= address(this).balance);     
382         
383         owner.transfer(_amount);
384     }
385 
386 
387 }