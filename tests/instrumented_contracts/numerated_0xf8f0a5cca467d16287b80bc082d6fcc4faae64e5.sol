1 pragma solidity ^0.4.24;
2 
3 // ---------------------------------------------------------------------------- 
4 // Symbol      : UBTR
5 // Name        : OBETR.COM
6 // Total supply: 12,000,000,000
7 // Decimals    : 18 
8 // ----------------------------------------------------------------------------
9 //https://remix.ethereum.org/#optimize=true&version=soljson-v0.4.24+commit.e67f0147.js
10 //
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17 
18     /**
19     * @dev Multiplies two numbers, reverts on overflow.
20     */
21     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
23         // benefit is lost if 'b' is also tested.
24         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b);
31 
32         return c;
33     }
34 
35     /**
36     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
37     */
38     function div(uint256 a, uint256 b) internal pure returns (uint256) {
39         require(b > 0); // Solidity only automatically asserts when dividing by 0
40         uint256 c = a / b;
41         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42 
43         return c;
44     }
45 
46     /**
47     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
48     */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         require(b <= a);
51         uint256 c = a - b;
52 
53         return c;
54     }
55 
56     /**
57     * @dev Adds two numbers, reverts on overflow.
58     */
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a);
62 
63         return c;
64     }
65 
66     /**
67     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
68     * reverts when dividing by zero.
69     */
70     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
71         require(b != 0);
72         return a % b;
73     }
74 }
75 
76 
77 
78 // ----------------------------------------------------------------------------
79 // ERC Token Standard #20 Interface
80 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
81 // ----------------------------------------------------------------------------
82 contract ERC20Interface {
83     function totalSupply() public constant returns (uint);
84     function balanceOf(address tokenOwner) public constant returns (uint balance);
85     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
86     function transfer(address to, uint tokens) public returns (bool success);
87     function approve(address spender, uint tokens) public returns (bool success);
88     function transferFrom(address from, address to, uint tokens) public returns (bool success);
89 
90     event Transfer(address indexed from, address indexed to, uint tokens);
91     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // Contract function to receive approval and execute function in one call
97 //
98 // Borrowed from MiniMeToken
99 // ----------------------------------------------------------------------------
100 contract ApproveAndCallFallBack {
101     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
102 }
103 
104 
105 // ----------------------------------------------------------------------------
106 // Owned contract
107 // ----------------------------------------------------------------------------
108 contract Owned {
109     address public owner;
110     address public newOwner;
111 
112     event OwnershipTransferred(address indexed _from, address indexed _to);
113 
114     constructor() public {
115         owner = msg.sender;
116     }
117 
118     modifier onlyOwner {
119         require(msg.sender == owner);
120         _;
121     }
122 
123     function transferOwnership(address _newOwner) public onlyOwner {
124         newOwner = _newOwner;
125     }
126     function acceptOwnership() public {
127         require(msg.sender == newOwner);
128         emit OwnershipTransferred(owner, newOwner);
129         owner = newOwner;
130         newOwner = address(0);
131     }
132 } 
133 
134 // ----------------------------------------------------------------------------
135 // ERC20 Token, with the addition of symbol, name and decimals and a
136 // fixed supply
137 // ----------------------------------------------------------------------------
138 contract FixedSupplyToken is ERC20Interface, Owned {
139     using SafeMath for uint;
140 
141     string public symbol;
142     string public  name;
143     uint8 public decimals;
144     uint _totalSupply; 
145     
146     bool public crowdsaleEnabled;
147     uint public ethPerToken;
148     uint public bonusMinEth;
149     uint public bonusPct; 
150 
151     mapping(address => uint) balances;
152     mapping(address => mapping(address => uint)) allowed;
153     
154     // ------------------------------------------------------------------------
155     // Custom Events
156     // ------------------------------------------------------------------------
157     event Burn(address indexed from, uint256 value);
158     event Bonus(address indexed from, uint256 value); 
159 
160 
161     // ------------------------------------------------------------------------
162     // Constructor
163     // ------------------------------------------------------------------------
164     constructor() public {
165         symbol = "UBTR";
166         name = "UBETR";
167         decimals = 18;
168         _totalSupply = 12000000000000000000000000000;
169 
170 
171         crowdsaleEnabled = false;
172         ethPerToken = 20000;
173         bonusMinEth = 0;
174         bonusPct = 0; 
175 
176         balances[owner] = _totalSupply;
177         emit Transfer(address(0), owner, _totalSupply);
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Total supply
183     // ------------------------------------------------------------------------
184     function totalSupply() public view returns (uint) {
185         return _totalSupply.sub(balances[address(0)]);
186     }
187 
188 
189     // ------------------------------------------------------------------------
190     // Get the token balance for account `tokenOwner`
191     // ------------------------------------------------------------------------
192     function balanceOf(address tokenOwner) public view returns (uint balance) {
193         return balances[tokenOwner];
194     }
195 
196 
197     // ------------------------------------------------------------------------
198     // Transfer the balance from token owner's account to `to` account
199     // - Owner's account must have sufficient balance to transfer
200     // - 0 value transfers are allowed
201     // ------------------------------------------------------------------------
202     function transfer(address to, uint tokens) public returns (bool success) {
203         balances[msg.sender] = balances[msg.sender].sub(tokens);
204         balances[to] = balances[to].add(tokens);
205         emit Transfer(msg.sender, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Token owner can approve for `spender` to transferFrom(...) `tokens`
212     // from the token owner's account
213     //
214     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
215     // recommends that there are no checks for the approval double-spend attack
216     // as this should be implemented in user interfaces 
217     // ------------------------------------------------------------------------
218     function approve(address spender, uint tokens) public returns (bool success) {
219         allowed[msg.sender][spender] = tokens;
220         emit Approval(msg.sender, spender, tokens);
221         return true;
222     }
223 
224 
225     // ------------------------------------------------------------------------
226     // Transfer `tokens` from the `from` account to the `to` account
227     // 
228     // The calling account must already have sufficient tokens approve(...)-d
229     // for spending from the `from` account and
230     // - From account must have sufficient balance to transfer
231     // - Spender must have sufficient allowance to transfer
232     // - 0 value transfers are allowed
233     // ------------------------------------------------------------------------
234     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
235         balances[from] = balances[from].sub(tokens);
236         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
237         balances[to] = balances[to].add(tokens);
238         emit Transfer(from, to, tokens);
239         return true;
240     }
241 
242 
243     // ------------------------------------------------------------------------
244     // Returns the amount of tokens approved by the owner that can be
245     // transferred to the spender's account
246     // ------------------------------------------------------------------------
247     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
248         return allowed[tokenOwner][spender];
249     }
250 
251 
252     // ------------------------------------------------------------------------
253     // Token owner can approve for `spender` to transferFrom(...) `tokens`
254     // from the token owner's account. The `spender` contract function
255     // `receiveApproval(...)` is then executed
256     // ------------------------------------------------------------------------
257     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
258         allowed[msg.sender][spender] = tokens;
259         emit Approval(msg.sender, spender, tokens);
260         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
261         return true;
262     }
263 
264 
265     // ------------------------------------------------------------------------
266     // Owner can transfer out any accidentally sent ERC20 tokens
267     // ------------------------------------------------------------------------
268     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
269         return ERC20Interface(tokenAddress).transfer(owner, tokens);
270     }
271 
272 
273     // ------------------------------------------------------------------------
274     // Crowdsale 
275     // ------------------------------------------------------------------------
276     function () public payable {
277         //crowd sale is open/allowed
278         require(crowdsaleEnabled); 
279         
280         uint ethValue = msg.value;
281         
282         //get token equivalent
283         uint tokens = ethValue.mul(ethPerToken);
284 
285         
286         //append bonus if we have active bonus promo
287         //and if ETH sent is more than then minimum required to avail bonus
288         if(bonusPct > 0 && ethValue >= bonusMinEth){
289             //compute bonus value based on percentage
290             uint bonus = tokens.div(100).mul(bonusPct);
291             
292             //emit bonus event
293             emit Bonus(msg.sender, bonus);
294             
295             //add bonus to final amount of token to be 
296             //transferred to sender/purchaser
297             tokens = tokens.add(bonus);
298         }
299         
300         
301         //validate token amount 
302         //assert(tokens > 0);
303         //assert(tokens <= balances[owner]);  
304         
305 
306         //transfer from owner to sender/purchaser
307         balances[owner] = balances[owner].sub(tokens);
308         balances[msg.sender] = balances[msg.sender].add(tokens);
309         
310         //emit transfer event
311         emit Transfer(owner, msg.sender, tokens);
312     } 
313 
314 
315     // ------------------------------------------------------------------------
316     // Open the token for Crowdsale 
317     // ------------------------------------------------------------------------
318     function enableCrowdsale() public onlyOwner{
319         crowdsaleEnabled = true; 
320     }
321 
322 
323     // ------------------------------------------------------------------------
324     // Close the token for Crowdsale 
325     // ------------------------------------------------------------------------
326     function disableCrowdsale() public onlyOwner{
327         crowdsaleEnabled = false; 
328     }
329 
330 
331     // ------------------------------------------------------------------------
332     // Set the token price.  
333     // ------------------------------------------------------------------------
334     function setTokenPrice(uint _ethPerToken) public onlyOwner{ 
335         ethPerToken = _ethPerToken;
336     } 
337 
338 
339     // ------------------------------------------------------------------------
340     // Set crowdsale bonus percentage and its minimum
341     // ------------------------------------------------------------------------
342     function setBonus(uint _bonusPct, uint _minEth) public onlyOwner {
343         bonusMinEth = _minEth;
344         bonusPct = _bonusPct;
345     }
346 
347 
348     // ------------------------------------------------------------------------
349     // Burn token
350     // ------------------------------------------------------------------------
351     function burn(uint256 _value) public onlyOwner {
352         require(_value > 0);
353         require(_value <= balances[msg.sender]); 
354 
355         address burner = msg.sender;
356         
357         //deduct from initiator's balance
358         balances[burner] = balances[burner].sub(_value);
359         
360         //deduct from total supply
361         _totalSupply = _totalSupply.sub(_value);
362         
363         emit Burn(burner, _value); 
364     } 
365 
366 
367     // ------------------------------------------------------------------------
368     // Withdraw
369     // ------------------------------------------------------------------------ 
370     function withdraw(uint _amount) onlyOwner public {
371         require(_amount > 0);
372         
373         // Amount withdraw should be less or equal to balance
374         require(_amount <= address(this).balance);     
375         
376         owner.transfer(_amount);
377     }
378 
379 
380 }