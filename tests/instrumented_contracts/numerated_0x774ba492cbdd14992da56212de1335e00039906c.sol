1 pragma solidity ^0.4.24;
2 //Spielleys Divide Drain and Destroy minigame v 1.0
3 
4 //99% of eth payed is returned directly to players according to their stack of shares vs totalSupply
5 // players need to fetch divs themselves or perform transactions to get the divs
6 // 1% will be set aside to buy P3D with Masternode reward for UI builders
7 // 100% of vanity change sales will go to buying P3D with (UIdev MN reward)
8 
9 // Game Concept: (inspired by a hill type idea for kotch https://kotch.dvx.me/#/)
10 // - Divide: Convert eth spent to buy shares factor eth value *3 
11 // - Drain : Drain someones shares, enemy loses shares eth value *2, you gain these
12 // - Destroy : Burn an enemies stack of shares at rate of eth value *5
13 
14 // Steps of the transactions
15 // 1: update total divs with payed amount
16 // 2: fetchdivs from accounts in the transactions
17 // 3: update shares
18 
19 // no matter your innitial shares amount, 
20 // you'll still get eth for getting destroyed according to your shares owned
21 
22 
23 // Thank you for playing Spielleys contract creations.
24 // speilley is not liable for any contract bugs known and unknown.
25 //
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 library SafeMath {
31     function add(uint a, uint b) internal pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     function sub(uint a, uint b) internal pure returns (uint c) {
36         require(b <= a);
37         c = a - b;
38     }
39     function mul(uint a, uint b) internal pure returns (uint c) {
40         c = a * b;
41         require(a == 0 || c / a == b);
42     }
43     function div(uint a, uint b) internal pure returns (uint c) {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // Owned contract
51 // ----------------------------------------------------------------------------
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     constructor() public {
59         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 // ----------------------------------------------------------------------------
78 // ERC Token Standard #20 Interface
79 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
80 // ----------------------------------------------------------------------------
81 contract ERC20Interface {
82     function totalSupply() public constant returns (uint);
83     function balanceOf(address tokenOwner) public constant returns (uint balance);
84     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
85     function transfer(address to, uint tokens) public returns (bool success);
86     function approve(address spender, uint tokens) public returns (bool success);
87     function transferFrom(address from, address to, uint tokens) public returns (bool success);
88 
89     event Transfer(address indexed from, address indexed to, uint tokens);
90     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
91 }
92 
93 interface HourglassInterface  {
94     function() payable external;
95     function buy(address _playerAddress) payable external returns(uint256);
96     function sell(uint256 _amountOfTokens) external;
97     function reinvest() external;
98     function withdraw() external;
99     function exit() external;
100     function dividendsOf(address _playerAddress) external view returns(uint256);
101     function balanceOf(address _playerAddress) external view returns(uint256);
102     function transfer(address _toAddress, uint256 _amountOfTokens) external returns(bool);
103     function stakingRequirement() external view returns(uint256);
104 }
105 interface SPASMInterface  {
106     function() payable external;
107     function disburse() external  payable;
108 }
109 // ----------------------------------------------------------------------------
110 // Contract function to receive approval and execute function in one call
111 //
112 // Borrowed from MiniMeToken
113 // ----------------------------------------------------------------------------
114 contract ApproveAndCallFallBack {
115     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
116 }
117 
118 // ----------------------------------------------------------------------------
119 // ERC20 Token, with the addition of symbol, name and decimals and a
120 // fixed supply
121 // ----------------------------------------------------------------------------
122 contract DivideDrainDestroy is ERC20Interface, Owned {
123     using SafeMath for uint;
124 
125     string public symbol;
126     string public  name;
127     uint8 public decimals;
128     uint _totalSupply;
129 
130     mapping(address => uint) balances;
131     mapping(address => mapping(address => uint)) allowed;
132 
133 
134     // ------------------------------------------------------------------------
135     // Constructor
136     // ------------------------------------------------------------------------
137     constructor() public {
138         symbol = "DDD";
139         name = "Divide Drain and Destroy";
140         decimals = 0;
141         _totalSupply = 1;
142         balances[owner] = _totalSupply;
143         emit Transfer(address(0),owner, _totalSupply);
144         
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Total supply
150     // ------------------------------------------------------------------------
151     function totalSupply() public view returns (uint) {
152         return _totalSupply.sub(balances[address(0)]);
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Get the token balance for account `tokenOwner`
158     // ------------------------------------------------------------------------
159     function balanceOf(address tokenOwner) public view returns (uint balance) {
160         return balances[tokenOwner];
161     }
162 
163 
164     // ------------------------------------------------------------------------
165     // Transfer the balance from token owner's account to `to` account
166     // - Owner's account must have sufficient balance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transfer(address to, uint tokens) updateAccount(to) updateAccount(msg.sender) public returns (bool success) {
170         balances[msg.sender] = balances[msg.sender].sub(tokens);
171         balances[to] = balances[to].add(tokens);
172         emit Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176 
177     // ------------------------------------------------------------------------
178     // Token owner can approve for `spender` to transferFrom(...) `tokens`
179     // from the token owner's account
180     //
181     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
182     // recommends that there are no checks for the approval double-spend attack
183     // as this should be implemented in user interfaces 
184     // ------------------------------------------------------------------------
185     function approve(address spender, uint tokens) public returns (bool success) {
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Transfer `tokens` from the `from` account to the `to` account
194     // 
195     // The calling account must already have sufficient tokens approve(...)-d
196     // for spending from the `from` account and
197     // - From account must have sufficient balance to transfer
198     // - Spender must have sufficient allowance to transfer
199     // - 0 value transfers are allowed
200     // ------------------------------------------------------------------------
201     function transferFrom(address from, address to, uint tokens)updateAccount(to) updateAccount(from) public returns (bool success) {
202         balances[from] = balances[from].sub(tokens);
203         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
204         balances[to] = balances[to].add(tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     // ------------------------------------------------------------------------
211     // Returns the amount of tokens approved by the owner that can be
212     // transferred to the spender's account
213     // ------------------------------------------------------------------------
214     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
215         return allowed[tokenOwner][spender];
216     }
217 
218 
219     // ------------------------------------------------------------------------
220     // Token owner can approve for `spender` to transferFrom(...) `tokens`
221     // from the token owner's account. The `spender` contract function
222     // `receiveApproval(...)` is then executed
223     // ------------------------------------------------------------------------
224     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
225         allowed[msg.sender][spender] = tokens;
226         emit Approval(msg.sender, spender, tokens);
227         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
228         return true;
229     }
230 
231 
232 
233 
234 
235     // ------------------------------------------------------------------------
236     // Owner can transfer out any accidentally sent ERC20 tokens
237     // ------------------------------------------------------------------------
238     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
239         return ERC20Interface(tokenAddress).transfer(owner, tokens);
240     }
241 
242 // divfunctions
243 HourglassInterface constant P3Dcontract_ = HourglassInterface(0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe);
244 SPASMInterface constant SPASM_ = SPASMInterface(0xfaAe60F2CE6491886C9f7C9356bd92F688cA66a1);
245 // view functions
246 function harvestabledivs()
247         view
248         public
249         returns(uint256)
250     {
251         return ( P3Dcontract_.dividendsOf(address(this)))  ;
252     }
253 function amountofp3d() external view returns(uint256){
254     return ( P3Dcontract_.balanceOf(address(this)))  ;
255 }
256 //divsection
257 uint256 public pointMultiplier = 10e18;
258 struct Account {
259   uint balance;
260   uint lastDividendPoints;
261 }
262 mapping(address=>Account) accounts;
263 mapping(address => uint256) public ETHtoP3Dbymasternode;
264 mapping(address => string) public Vanity;
265 uint public ethtotalSupply;
266 uint public totalDividendPoints;
267 uint public unclaimedDividends;
268 
269 function dividendsOwing(address account) public view returns(uint256) {
270   uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
271   return (balances[account] * newDividendPoints) / pointMultiplier;
272 }
273 modifier updateAccount(address account) {
274   uint256 owing = dividendsOwing(account);
275   if(owing > 0) {
276     unclaimedDividends = unclaimedDividends.sub(owing);
277     
278     account.transfer(owing);
279   }
280   accounts[account].lastDividendPoints = totalDividendPoints;
281   _;
282 }
283 function () external payable{}
284 function fetchdivs(address toupdate) public updateAccount(toupdate){}
285 function disburse(address masternode) public  payable {
286     uint256 amount = msg.value;
287     uint256 base = amount.div(100);
288     uint256 amt2 = amount.sub(base);
289   totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
290  unclaimedDividends = unclaimedDividends.add(amt2);
291  ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(base);
292 }
293 function Divide(address masternode) public  payable{
294     uint256 amount = msg.value.mul(3);
295     address sender = msg.sender;
296     uint256 sup = _totalSupply;//totalSupply
297     require(amount >= 1);
298     sup = sup.add(amount);
299     disburse(masternode);
300     fetchdivs(msg.sender);
301     balances[msg.sender] = balances[sender].add(amount);
302     emit Transfer(0,sender, amount);
303      _totalSupply =  sup;
304 
305 }
306 function Drain(address drainfrom, address masternode) public  payable{
307     uint256 amount = msg.value.mul(2);
308     address sender = msg.sender;
309     uint256 sup = _totalSupply;//totalSupply
310     require(amount >= 1);
311     require(amount <= balances[drainfrom]);
312     
313     disburse(masternode);
314     fetchdivs(msg.sender);
315     fetchdivs(drainfrom);
316     balances[msg.sender] = balances[sender].add(amount);
317     balances[drainfrom] = balances[drainfrom].sub(amount);
318     emit Transfer(drainfrom,sender, amount);
319      _totalSupply =  sup.add(amount);
320     
321 }
322 function Destroy(address destroyfrom, address masternode) public  payable{
323     uint256 amount = msg.value.mul(5);
324     uint256 sup = _totalSupply;//totalSupply
325     require(amount >= 1);
326     require(amount <= balances[destroyfrom]);
327         disburse(masternode);
328         fetchdivs(msg.sender);
329     fetchdivs(destroyfrom);
330     balances[destroyfrom] = balances[destroyfrom].sub(amount);
331     emit Transfer(destroyfrom,0x0, amount);
332      _totalSupply =  sup.sub(amount);
333 
334 }
335 function Expand(address masternode) public {
336     
337     uint256 amt = ETHtoP3Dbymasternode[masternode];
338     ETHtoP3Dbymasternode[masternode] = 0;
339     if(masternode == 0x0){masternode = 0x989eB9629225B8C06997eF0577CC08535fD789F9;}// raffle3d's address
340     P3Dcontract_.buy.value(amt)(masternode);
341     
342 }
343 function changevanity(string van , address masternode) public payable{
344     require(msg.value >= 100  finney);
345     Vanity[msg.sender] = van;
346     ETHtoP3Dbymasternode[masternode] = ETHtoP3Dbymasternode[masternode].add(msg.value);
347 }
348 function P3DDivstocontract() public payable{
349     uint256 divs = harvestabledivs();
350     require(divs > 0);
351  
352 P3Dcontract_.withdraw();
353     //1% to owner
354     uint256 base = divs.div(100);
355     uint256 amt2 = divs.sub(base);
356     SPASM_.disburse.value(base)();// to dev fee sharing contract
357    totalDividendPoints = totalDividendPoints.add(amt2.mul(pointMultiplier).div(_totalSupply));
358  unclaimedDividends = unclaimedDividends.add(amt2);
359 }
360 }