1 pragma solidity ^0.4.21;
2 
3 // ----------------------------------------------------------------------------
4 // ZAN token contract
5 //
6 // Symbol      : ZAN
7 // Name        : ZAN Coin
8 // Total supply: 17,148,385.000000000000000000
9 // Decimals    : 18
10 //
11 // ----------------------------------------------------------------------------
12 
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         assert(c >= a);
21     }
22 
23     function sub(uint a, uint b) internal pure returns (uint c) {
24         assert(b <= a);
25         c = a - b;
26     }
27 
28     function mul(uint a, uint b) internal pure returns (uint c) {
29         c = a * b;
30         assert(a == 0 || c / a == b);
31     }
32 
33     function div(uint a, uint b) internal pure returns (uint c) {
34         assert(b > 0);
35         c = a / b;
36     }
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // ERC Token Standard #20 Interface
42 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
43 // ----------------------------------------------------------------------------
44 contract ERC20Interface {
45     function totalSupply() public constant returns (uint);
46     function balanceOf(address tokenOwner) public constant returns (uint balance);
47     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
48     function transfer(address to, uint tokens) public returns (bool success);
49     function approve(address spender, uint tokens) public returns (bool success);
50     function transferFrom(address from, address to, uint tokens) public returns (bool success);
51 
52     event Transfer(address indexed from, address indexed to, uint tokens);
53     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
54 }
55 
56 
57 // ----------------------------------------------------------------------------
58 // Contract function to receive approval and execute function in one call
59 //
60 // Borrowed from MiniMeToken
61 // ----------------------------------------------------------------------------
62 contract ApproveAndCallFallBack {
63     function receiveApproval(address from, uint tokens, address token, bytes data) public;
64 }
65 
66 
67 // ----------------------------------------------------------------------------
68 // Owned contract
69 // ----------------------------------------------------------------------------
70 contract Owned {
71     address public owner;
72     address public newOwner;
73 
74     event OwnershipTransferred(address indexed _from, address indexed _to);
75 
76     function Owned() public {
77         owner = msg.sender;
78     }
79 
80     modifier onlyOwner {
81         require(msg.sender == owner);
82         _;
83     }
84 
85     function transferOwnership(address _newOwner) public onlyOwner {
86         newOwner = _newOwner;
87     }
88     
89     function acceptOwnership() public {
90         require(msg.sender == newOwner);
91         emit OwnershipTransferred(owner, newOwner);
92         owner = newOwner;
93         newOwner = address(0);
94     }
95 }
96 
97 
98 // ----------------------------------------------------------------------------
99 // ERC20 Token, with the addition of symbol, name and decimals and an
100 // initial fixed supply
101 // ----------------------------------------------------------------------------
102 contract ZanCoin is ERC20Interface, Owned {
103     using SafeMath for uint;
104     
105     // ------------------------------------------------------------------------
106     // Metadata
107     // ------------------------------------------------------------------------
108     string public symbol;
109     string public  name;
110     uint8 public decimals;
111     uint public _totalSupply;
112 
113     mapping(address => uint) public balances;
114     mapping(address => mapping(address => uint)) public allowed;
115     
116     // ------------------------------------------------------------------------
117     // Crowdsale data
118     // ------------------------------------------------------------------------
119     bool public isInPreSaleState;
120     bool public isInRoundOneState;
121     bool public isInRoundTwoState;
122     bool public isInFinalState;
123     uint public stateStartDate;
124     uint public stateEndDate;
125     uint public saleCap;
126     uint public exchangeRate;
127     
128     uint public burnedTokensCount;
129 
130     event SwitchCrowdSaleStage(string stage, uint exchangeRate);
131     event BurnTokens(address indexed burner, uint amount);
132     event PurchaseZanTokens(address indexed contributor, uint eth_sent, uint zan_received);
133 
134     // ------------------------------------------------------------------------
135     // Constructor
136     // ------------------------------------------------------------------------
137     function ZanCoin() public {
138         symbol = "ZAN";
139         name = "ZAN Coin";
140         decimals = 18;
141         _totalSupply = 17148385 * 10**uint(decimals);
142         balances[owner] = _totalSupply;
143         
144         isInPreSaleState = false;
145         isInRoundOneState = false;
146         isInRoundTwoState = false;
147         isInFinalState = false;
148         burnedTokensCount = 0;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Total supply
154     // ------------------------------------------------------------------------
155     function totalSupply() public constant returns (uint) {
156         return _totalSupply - balances[address(0)];
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Get the token balance for account `tokenOwner`
162     // ------------------------------------------------------------------------
163     function balanceOf(address tokenOwner) public constant returns (uint balance) {
164         return balances[tokenOwner];
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer the balance from token owner's account to `to` account
170     // - Owner's account must have sufficient balance to transfer
171     // - 0 value transfers are allowed
172     // ------------------------------------------------------------------------
173     function transfer(address to, uint tokens) public returns (bool success) {
174         balances[msg.sender] = balances[msg.sender].sub(tokens);
175         balances[to] = balances[to].add(tokens);
176         emit Transfer(msg.sender, to, tokens);
177         return true;
178     }
179 
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for `spender` to transferFrom(...) `tokens`
183     // from the token owner's account
184     //
185     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
186     // recommends that there are no checks for the approval double-spend attack
187     // as this should be implemented in user interfaces 
188     // ------------------------------------------------------------------------
189     function approve(address spender, uint tokens) public returns (bool success) {
190         allowed[msg.sender][spender] = tokens;
191         emit Approval(msg.sender, spender, tokens);
192         return true;
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Transfer `tokens` from the `from` account to the `to` account
198     // 
199     // The calling account must already have sufficient tokens approve(...)-d
200     // for spending from the `from` account and
201     // - From account must have sufficient balance to transfer
202     // - Spender must have sufficient allowance to transfer
203     // - 0 value transfers are allowed
204     // ------------------------------------------------------------------------
205     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
206         balances[from] = balances[from].sub(tokens);
207         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
208         balances[to] = balances[to].add(tokens);
209         emit Transfer(from, to, tokens);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Returns the amount of tokens approved by the owner that can be
216     // transferred to the spender's account
217     // ------------------------------------------------------------------------
218     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
219         return allowed[tokenOwner][spender];
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Token owner can approve for `spender` to transferFrom(...) `tokens`
225     // from the token owner's account. The `spender` contract function
226     // `receiveApproval(...)` is then executed
227     // ------------------------------------------------------------------------
228     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
229         allowed[msg.sender][spender] = tokens;
230         emit Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
232         return true;
233     }
234 
235 
236     // ------------------------------------------------------------------------
237     // Accepts ETH and transfers ZAN tokens based on exchage rate and state
238     // ------------------------------------------------------------------------
239     function () public payable {
240         uint eth_sent = msg.value;
241         uint tokens_amount = eth_sent.mul(exchangeRate);
242         
243         require(eth_sent > 0);
244         require(exchangeRate > 0);
245         require(stateStartDate < now && now < stateEndDate);
246         require(balances[owner] >= tokens_amount);
247         require(_totalSupply - (balances[owner] - tokens_amount) <= saleCap);
248         
249         // Don't accept ETH in the final state
250         require(!isInFinalState);
251         require(isInPreSaleState || isInRoundOneState || isInRoundTwoState);
252         
253         balances[owner] = balances[owner].sub(tokens_amount);
254         balances[msg.sender] = balances[msg.sender].add(tokens_amount);
255         emit PurchaseZanTokens(msg.sender, eth_sent, tokens_amount);
256     }
257     
258     // ------------------------------------------------------------------------
259     // Switches crowdsale stages: PreSale -> Round One -> Round Two
260     // ------------------------------------------------------------------------
261     function switchCrowdSaleStage() external onlyOwner {
262         require(!isInFinalState && !isInRoundTwoState);
263         
264         if (!isInPreSaleState) {
265             isInPreSaleState = true;
266             exchangeRate = 1500;
267             saleCap = (3 * 10**6) * (uint(10) ** decimals);
268             emit SwitchCrowdSaleStage("PreSale", exchangeRate);
269         }
270         else if (!isInRoundOneState) {
271             isInRoundOneState = true;
272             exchangeRate = 1200;
273             saleCap = saleCap + ((4 * 10**6) * (uint(10) ** decimals));
274             emit SwitchCrowdSaleStage("RoundOne", exchangeRate);
275         }
276         else if (!isInRoundTwoState) {
277             isInRoundTwoState = true;
278             exchangeRate = 900;
279             saleCap = saleCap + ((5 * 10**6) * (uint(10) ** decimals));
280             emit SwitchCrowdSaleStage("RoundTwo", exchangeRate);
281         }
282         
283         stateStartDate = now + 5 minutes;
284         stateEndDate = stateStartDate + 7 days;
285     }
286     
287     // ------------------------------------------------------------------------
288     // Switches to Complete stage of the contract. Sends all funds collected
289     // to the contract owner.
290     // ------------------------------------------------------------------------
291     function completeCrowdSale() external onlyOwner {
292         require(!isInFinalState);
293         require(isInPreSaleState && isInRoundOneState && isInRoundTwoState);
294         
295         owner.transfer(address(this).balance);
296         exchangeRate = 0;
297         isInFinalState = true;
298         emit SwitchCrowdSaleStage("Complete", exchangeRate);
299     }
300 
301     // ------------------------------------------------------------------------
302     // Token holders are able to burn their tokens.
303     // ------------------------------------------------------------------------
304     function burn(uint amount) public {
305         require(amount > 0);
306         require(amount <= balances[msg.sender]);
307 
308         balances[msg.sender] = balances[msg.sender].sub(amount);
309         _totalSupply = _totalSupply.sub(amount);
310         burnedTokensCount = burnedTokensCount + amount;
311         emit BurnTokens(msg.sender, amount);
312     }
313 
314     // ------------------------------------------------------------------------
315     // Owner can transfer out any accidentally sent ERC20 tokens
316     // ------------------------------------------------------------------------
317     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
318         return ERC20Interface(tokenAddress).transfer(owner, tokens);
319     }
320 }