1 pragma solidity ^0.5.0;
2 
3 /* 
4    ----------------------------------------------------------------------------
5    ERC-20 Token: Fixed supply with ICO 
6    
7 */
8 
9 
10 // -- Safe Math library - integer overflow prevention (OpenZeppelin) --
11 
12 library SafeMath {
13     
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         require(b > 0);
27         uint256 c = a / b;
28 
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         require(b <= a);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a);
42 
43         return c;
44     }
45 
46     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
47         require(b != 0);
48         return a % b;
49     }
50 }
51 
52 
53 // -- ERC-20 Token Standard interface --
54 // based on https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
55 
56 contract ERC20Interface {
57     function totalSupply() public view returns (uint);
58     function balanceOf(address tokenOwner) public view returns (uint balance);
59     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
60     function transfer(address to, uint tokens) public returns (bool success);
61     function approve(address spender, uint tokens) public returns (bool success);
62     function transferFrom(address from, address to, uint tokens) public returns (bool success);
63 
64     event Transfer(address indexed from, address indexed to, uint tokens);
65     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
66 }
67 
68 
69 // -- Contract function - receive approval and execute function in one call --
70 
71 contract ApproveAndCallFallBack {
72     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
73 }
74 
75 
76 // -- Owned Contract --
77 
78 contract Owned {
79     
80     address public owner;
81     address public newOwner;
82 
83     event OwnershipTransferred(address indexed _from, address indexed _to);
84 
85     constructor() public {
86         owner = msg.sender;
87     }
88 
89     modifier onlyOwner {
90         require(msg.sender == owner);
91         _;
92     }
93 
94     function transferOwnership(address _newOwner) public onlyOwner {
95         newOwner = _newOwner;
96     }
97     
98     function acceptOwnership() public {
99         require(msg.sender == newOwner);
100         emit OwnershipTransferred(owner, newOwner);
101         owner = newOwner;
102         newOwner = address(0);
103     }
104 }
105 
106 
107 // -- ERC20 Token + fixed supply --
108 
109 contract LibertyEcoToken is ERC20Interface, Owned {
110     using SafeMath for uint;
111 
112     string public symbol;
113     string public name;
114     uint8 public decimals;
115     
116     uint256 _totalSupply;
117     uint256 public reserveCap = 0;                                  // Amount of tokens to reserve for owner (constructor) 
118     uint256 public tokensRemain = 0;                                // Amount of tokens to sell (constructor)
119     uint256 public tokensSold = 0;                                  // Amount of tokens sold
120     uint256 public tokensDistributed = 0;                           // Amount of tokens distributed
121 
122     uint256 public tokensPerEth = 100;                               // Units of token can be bought with 1 ETH
123     uint256 public EtherInWei = 0;                                  // Store the total ETH raised via ICO 
124     address payable public fundsWallet;
125 
126     mapping(address => uint) balances;
127     mapping(address => mapping(address => uint)) allowed;
128 
129 
130     // -- Constructor --
131     
132     constructor() public {
133         symbol = "LES";                                            // Token symbol / abbreviation
134         name = "Liberty EcoToken";                                         // Token name
135         decimals = 18;                                              
136         _totalSupply = 100000000000 * 10**uint(decimals);               // Initial token supply deployed (in wei) -- 100 tokens
137         
138         balances[owner] = _totalSupply;                             // Give all token supply to owner
139         emit Transfer(address(0), owner, _totalSupply);
140         
141         fundsWallet = msg.sender;                                   // To be funded on owner's wallet
142         
143         tokensRemain = _totalSupply.sub(reserveCap);
144     }
145 
146 
147     // -- Total Supply --
148     
149     function totalSupply() public view returns (uint256) {
150         return _totalSupply.sub(balances[address(0)]);
151     }
152 
153 
154     // -- Get token balance for account `tokenOwner` --
155     
156     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
157         return balances[tokenOwner];
158     }
159 
160 
161     /*
162       -- Transfer balance from token owner's account to other account --
163         - Owner's account must have sufficient balance to transfer
164         - 0 value transfers are allowed
165     */
166     
167     function transfer(address to, uint256 tokens) public returns (bool success) {
168         balances[msg.sender] = balances[msg.sender].sub(tokens);
169         balances[to] = balances[to].add(tokens);
170         emit Transfer(msg.sender, to, tokens);
171         return true;
172     }
173 
174 
175     /* 
176       -- Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account --
177      
178         ERC-20 Token Standard recommends that there are no checks for the approval 
179         double-spend attack as this should be implemented in user interfaces
180     */
181     
182     function approve(address spender, uint256 tokens) public returns (bool success) {
183         allowed[msg.sender][spender] = tokens;
184         emit Approval(msg.sender, spender, tokens);
185         return true;
186     }
187 
188 
189     /*
190       -- Transfer `tokens` from the `from` account to the `to` account --
191     
192         The calling account must already have sufficient tokens approve(...)-d
193         for spending from the `from` account and:
194         
195         - From account must have sufficient balance to transfer
196         - Spender must have sufficient allowance to transfer
197         - 0 value transfers are allowed
198     */
199     
200     function transferFrom(address from, address to, uint256 tokens) public returns (bool success) {
201         
202         balances[from] = balances[from].sub(tokens);
203         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
204         balances[to] = balances[to].add(tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209 
210     //  -- Returns the amount of tokens approved by the owner that can be transferred to the spender's account --
211     
212     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
213         return allowed[tokenOwner][spender];
214     }
215 
216 
217     /*
218       -- Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account -- 
219         - The `spender` contract function `receiveApproval(...)` is then executed
220     */
221     
222     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
223         allowed[msg.sender][spender] = tokens;
224         emit Approval(msg.sender, spender, tokens);
225         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
226         return true;
227     }
228 
229 
230     // -- 100 tokens given per 1 ETH but revert if owner reserve limit reached --
231     
232     function () external payable {
233         if(balances[owner] >= reserveCap) {
234             EtherInWei = EtherInWei + msg.value;
235             uint256 amount = msg.value * tokensPerEth;
236             
237             require(balances[fundsWallet] >= amount);
238             
239             balances[fundsWallet] = balances[fundsWallet].sub(amount);
240             balances[msg.sender] = balances[msg.sender].add(amount);
241             
242             emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
243             
244             //Transfer ether to fundsWallet
245             fundsWallet.transfer(msg.value);
246             
247             deductToken(amount);
248         }
249         
250         else {
251             revert("Token balance reaches reserve capacity, no more tokens will be given out.");
252         }
253     }
254 
255 
256     // -- Owner can transfer out any accidentally sent ERC20 tokens --
257     
258     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
259         return ERC20Interface(tokenAddress).transfer(owner, tokens);
260     }
261     
262     // -- Mini function to deduct remaining tokens to sell and add in amount of tokens sold
263     function deductToken(uint256 amt) private {
264         tokensRemain = tokensRemain.sub(amt);
265         tokensSold = tokensSold.add(amt);
266     }
267     
268     // -- Set reserve cap by amount 
269     
270     function setReserveCap(uint256 tokenAmount) public onlyOwner {
271         reserveCap = tokenAmount * 10**uint(decimals);
272         tokensRemain = balances[owner].sub(reserveCap);
273     }
274     
275     // -- Set reserve cap by percentage
276     
277     function setReserveCapPercentage (uint percentage) public onlyOwner {
278         reserveCap = calcSupplyPercentage(percentage);
279         tokensRemain = balances[owner].sub(reserveCap);
280     }
281     
282     // -- Mini function for calculating token percentage from whole supply --
283     
284     function calcSupplyPercentage(uint256 percent) public view returns (uint256){
285         uint256 total = _totalSupply.mul(percent.mul(100)).div(10000);
286         
287         return total;
288     }
289     
290     // -- Distribute tokens to other address (with amount of tokens) --
291     
292     function distributeTokenByAmount(address dist_address, uint256 tokens)public payable onlyOwner returns (bool success){
293         require(balances[owner] > 0 && tokens <= tokensRemain, "Token distribution fail due to insufficient selling token.");
294         uint256 tokenToDistribute = tokens * 10**uint(decimals);
295         
296         balances[owner] = balances[owner].sub(tokenToDistribute);
297         balances[dist_address] = balances[dist_address].add(tokenToDistribute);
298         
299         emit Transfer(owner, dist_address, tokenToDistribute);
300         
301         tokensRemain = tokensRemain.sub(tokenToDistribute);
302         tokensDistributed = tokensDistributed.add(tokenToDistribute);
303         
304         return true;
305     }
306     
307     // -- Release reserve cap from owner for token sell by amount of tokens
308     
309     function releaseCapByAmount(uint256 tokenAmount) public onlyOwner {
310         tokenAmount = tokenAmount * 10**uint(decimals);
311         
312         require(balances[owner] >= tokenAmount);
313         reserveCap = reserveCap.sub(tokenAmount);
314         tokensRemain = tokensRemain.add(tokenAmount);
315     }
316 }