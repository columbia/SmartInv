1 pragma solidity ^0.4.25;
2 
3 /*----------------------------------------------------------------------------
4    ERC-20 Token: Fixed supply with ICO 
5         + owner distribution upon deployment 
6         + limit on token reserve amount function
7   ----------------------------------------------------------------------------*/
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
124     
125     bool reserveCapped = false;
126     address public fundsWallet;
127 
128     mapping(address => uint) balances;
129     mapping(address => mapping(address => uint)) allowed;
130 
131 
132     // -- Constructor --
133     
134     constructor() public {
135         symbol = "LES";                                            // Token symbol / abbreviation
136         name = "Liberty EcoToken";                                         // Token name
137         decimals = 18;                                              
138         _totalSupply = 10000000000 * 10**uint(decimals);               // Initial token supply deployed (in wei) -- 100 tokens
139         
140         balances[owner] = _totalSupply;                             // give all token supply to owner
141         emit Transfer(address(0), owner, _totalSupply);
142         
143         fundsWallet = msg.sender;                                   // To be funded on owner's wallet
144         
145         tokensRemain = _totalSupply.sub(reserveCap);
146     }
147 
148 
149     // -- Total Supply --
150     
151     function totalSupply() public view returns (uint256) {
152         return _totalSupply.sub(balances[address(0)]);
153     }
154 
155 
156     // -- Get token balance for account `tokenOwner` - use wei --
157     
158     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
159         return balances[tokenOwner];
160     }
161 
162     /*
163       -- Transfer balance from token owner's account to other account - use wei --
164         - Owner's account must have sufficient balance to transfer
165         - 0 value transfers are allowed
166     */
167     
168     function transfer(address to, uint256 tokens) public returns (bool success) {
169         require(to != address(0));
170         balances[msg.sender] = balances[msg.sender].sub(tokens);
171         balances[to] = balances[to].add(tokens);
172         emit Transfer(msg.sender, to, tokens);
173         return true;
174     }
175 
176 
177     /* 
178       -- Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account - use wei --
179      
180         ERC-20 Token Standard recommends that there are no checks for the approval 
181         double-spend attack as this should be implemented in user interfaces
182     */
183     
184     function approve(address spender, uint256 tokens) public returns (bool success) {
185         require(spender != address(0));
186         allowed[msg.sender][spender] = tokens;
187         emit Approval(msg.sender, spender, tokens);
188         return true;
189     }
190 
191 
192     /*
193       -- Transfer `tokens` from the `from` account to the `to` account - use wei --
194     
195         The calling account must already have sufficient tokens approve(...)-d
196         for spending from the `from` account and:
197         
198         - From account must have sufficient balance to transfer
199         - Spender must have sufficient allowance to transfer
200         - 0 value transfers are allowed
201     */
202     
203     function transferFrom(address _from, address to, uint256 tokens) public returns (bool success) {
204         require(_from != address(0) && to != address(0));
205         balances[_from] = balances[_from].sub(tokens);
206         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(tokens);
207         balances[to] = balances[to].add(tokens);
208         emit Transfer(_from, to, tokens);
209         return true;
210     }
211 
212 
213     //  -- Returns the amount of tokens approved by the owner that can be transferred to the spender's account - use wei --
214     
215     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
216         return allowed[tokenOwner][spender];
217     }
218 
219 
220     /*
221       -- Token owner can approve for `spender` to transferFrom(...) `tokens` from the token owner's account - use wei -- 
222         - The `spender` contract function `receiveApproval(...)` is then executed
223     */
224     
225     function approveAndCall(address spender, uint256 tokens, bytes memory data) public returns (bool success) {
226         require(spender != address(0));
227         require(tokens != 0);
228         
229         allowed[msg.sender][spender] = tokens;
230         emit Approval(msg.sender, spender, tokens);
231         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
232         return true;
233     }
234 
235 
236     // -- 100 tokens given per 1 ETH but revert if owner reserve limit reached --
237     
238     function () external payable {
239         require(msg.value != 0);
240         if(balances[owner] >= reserveCap) {
241             EtherInWei = EtherInWei.add(msg.value);
242             uint256 amount = tokensPerEth.mul(msg.value);
243             
244             require(balances[fundsWallet] >= amount);
245             
246             balances[fundsWallet] = balances[fundsWallet].sub(amount);
247             balances[msg.sender] = balances[msg.sender].add(amount);
248             
249             emit Transfer(fundsWallet, msg.sender, amount); // Broadcast a message to the blockchain
250             
251             //Transfer ether to fundsWallet
252             fundsWallet.transfer(msg.value);
253             
254             deductToken(amount);
255         }
256         
257         else {
258             revert("Token balance reaches reserve capacity, no more tokens will be given out.");
259         }
260     }
261 
262 
263     // -- Owner can transfer out any accidentally sent ERC20 tokens - use wei --
264     
265     function transferAnyERC20Token(address tokenAddress, uint256 tokens) public onlyOwner returns (bool success) {
266         return ERC20Interface(tokenAddress).transfer(owner, tokens);
267     }
268     
269     // -- Mini function to deduct remaining tokens to sell and add in amount of tokens sold
270     function deductToken(uint256 amt) private {
271         tokensRemain = tokensRemain.sub(amt);
272         tokensSold = tokensSold.add(amt);
273     }
274     
275     // -- Set reserve cap by amount (only once)
276     
277     function setReserveCap(uint256 tokenAmount) public onlyOwner {
278         require(tokenAmount != 0 && reserveCapped != true);
279         
280         reserveCap = tokenAmount * 10**uint(decimals);
281         tokensRemain = balances[owner].sub(reserveCap);
282         
283         reserveCapped = true;
284     }
285     
286     // -- Set reserve cap by percentage (only once)
287     
288     function setReserveCapPercentage (uint percentage) public onlyOwner {
289         require(percentage != 0 && reserveCapped != true);
290         reserveCap = calcSupplyPercentage(percentage);
291         tokensRemain = balances[owner].sub(reserveCap);
292         
293         reserveCapped = true;
294     }
295     
296     // -- Mini function for calculating token percentage from whole supply --
297     
298     function calcSupplyPercentage(uint256 percent) public view returns (uint256){
299         uint256 total = _totalSupply.mul(percent.mul(100)).div(10000);
300         
301         return total;
302     }
303     
304     // -- Distribute tokens to other address (with amount of tokens) --
305     
306     function distributeTokenByAmount(address dist_address, uint256 tokens)public payable onlyOwner returns (bool success){
307         require(balances[owner] > 0);
308         uint256 tokenToDistribute = tokens * 10**uint(decimals);
309         
310         require(tokensRemain >= tokenToDistribute);
311         
312         balances[owner] = balances[owner].sub(tokenToDistribute);
313         balances[dist_address] = balances[dist_address].add(tokenToDistribute);
314         
315         emit Transfer(owner, dist_address, tokenToDistribute);
316         
317         tokensRemain = tokensRemain.sub(tokenToDistribute);
318         tokensDistributed = tokensDistributed.add(tokenToDistribute);
319         
320         return true;
321     }
322     
323     // -- Release reserve cap from owner for token sell by amount of tokens
324     
325     function releaseCapByAmount(uint256 tokenAmount) public onlyOwner {
326         require(tokenAmount != 0 && reserveCapped == true);
327         tokenAmount = tokenAmount * 10**uint(decimals);
328         
329         require(balances[owner] >= tokenAmount);
330         reserveCap = reserveCap.sub(tokenAmount);
331         tokensRemain = tokensRemain.add(tokenAmount);
332     }
333     
334     
335 }