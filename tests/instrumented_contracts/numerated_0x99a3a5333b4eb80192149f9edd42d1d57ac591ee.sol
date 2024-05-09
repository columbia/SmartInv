1 pragma solidity ^0.4.24;
2 
3 //
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Owned contract
29 // ----------------------------------------------------------------------------
30 contract Owned {
31     address public owner;
32     address public newOwner;
33 
34     event OwnershipTransferred(address indexed _from, address indexed _to);
35 
36     constructor() public {
37         owner = 0x0B0eFad4aE088a88fFDC50BCe5Fb63c6936b9220;
38     }
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 // ----------------------------------------------------------------------------
56 // ERC Token Standard #20 Interface
57 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
58 // ----------------------------------------------------------------------------
59 contract ERC20Interface {
60     function totalSupply() public constant returns (uint);
61     function balanceOf(address tokenOwner) public constant returns (uint balance);
62     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
63     function transfer(address to, uint tokens) public returns (bool success);
64     function approve(address spender, uint tokens) public returns (bool success);
65     function transferFrom(address from, address to, uint tokens) public returns (bool success);
66 
67     event Transfer(address indexed from, address indexed to, uint tokens);
68     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Contract function to receive approval and execute function in one call
74 //
75 // Borrowed from MiniMeToken
76 // ----------------------------------------------------------------------------
77 contract ApproveAndCallFallBack {
78     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
79 }
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and a
83 // fixed supply
84 // ----------------------------------------------------------------------------
85 contract CELT is ERC20Interface, Owned {
86     using SafeMath for uint;
87 
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     constructor() public {
101         symbol = "CELT";
102         name = "COSS Exchange Liquidity Token";
103         decimals = 18;
104         _totalSupply = 10000000 ether;
105         balances[owner] = _totalSupply;
106         emit Transfer(address(0),owner, _totalSupply);
107         Hub_.setAuto(10);
108     }
109 
110 
111     // ------------------------------------------------------------------------
112     // Total supply
113     // ------------------------------------------------------------------------
114     function totalSupply() public view returns (uint) {
115         return _totalSupply.sub(balances[address(0)]);
116     }
117 
118 
119     // ------------------------------------------------------------------------
120     // Get the token balance for account `tokenOwner`
121     // ------------------------------------------------------------------------
122     function balanceOf(address tokenOwner) public view returns (uint balance) {
123         return balances[tokenOwner];
124     }
125 
126 
127     // ------------------------------------------------------------------------
128     // Transfer the balance from token owner's account to `to` account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ------------------------------------------------------------------------
132     function transfer(address to, uint tokens) updateAccount(to) updateAccount(msg.sender) public returns (bool success) {
133         balances[msg.sender] = balances[msg.sender].sub(tokens);
134         balances[to] = balances[to].add(tokens);
135         emit Transfer(msg.sender, to, tokens);
136         return true;
137     }
138 
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account
143     //
144     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
145     // recommends that there are no checks for the approval double-spend attack
146     // as this should be implemented in user interfaces 
147     // ------------------------------------------------------------------------
148     function approve(address spender, uint tokens) public returns (bool success) {
149         allowed[msg.sender][spender] = tokens;
150         emit Approval(msg.sender, spender, tokens);
151         return true;
152     }
153 
154 
155     // ------------------------------------------------------------------------
156     // Transfer `tokens` from the `from` account to the `to` account
157     // 
158     // The calling account must already have sufficient tokens approve(...)-d
159     // for spending from the `from` account and
160     // - From account must have sufficient balance to transfer
161     // - Spender must have sufficient allowance to transfer
162     // - 0 value transfers are allowed
163     // ------------------------------------------------------------------------
164     function transferFrom(address from, address to, uint tokens)updateAccount(to) updateAccount(from) public returns (bool success) {
165         balances[from] = balances[from].sub(tokens);
166         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
167         balances[to] = balances[to].add(tokens);
168         emit Transfer(from, to, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Returns the amount of tokens approved by the owner that can be
175     // transferred to the spender's account
176     // ------------------------------------------------------------------------
177     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Token owner can approve for `spender` to transferFrom(...) `tokens`
184     // from the token owner's account. The `spender` contract function
185     // `receiveApproval(...)` is then executed
186     // ------------------------------------------------------------------------
187     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
188         allowed[msg.sender][spender] = tokens;
189         emit Approval(msg.sender, spender, tokens);
190         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
191         return true;
192     }
193 
194     // ------------------------------------------------------------------------
195     // Owner can transfer out any accidentally sent ERC20 tokens
196     // ------------------------------------------------------------------------
197     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
198         return ERC20Interface(tokenAddress).transfer(owner, tokens);
199     }
200     
201     // Hub_
202     PlincInterface constant Hub_ = PlincInterface(0xd5D10172e8D8B84AC83031c16fE093cba4c84FC6);
203     uint256 public ethPendingDistribution;
204 
205     // plinc functions
206     function fetchHubVault() public{
207         
208         uint256 value = Hub_.playerVault(address(this));
209         require(value >0);
210         Hub_.vaultToWallet();
211         ethPendingDistribution = ethPendingDistribution.add(value);
212     }
213     function fetchHubPiggy() public{
214         
215         uint256 value = Hub_.piggyBank(address(this));
216         require(value >0);
217         Hub_.piggyToWallet();
218         ethPendingDistribution = ethPendingDistribution.add(value);
219     }
220     function disburseHub() public  {
221     uint256 amount = ethPendingDistribution;
222     ethPendingDistribution = 0;
223     totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
224     unclaimedDividends = unclaimedDividends.add(amount);
225     }
226     // PSAfunctions
227     // PSAsection
228     uint256 public pointMultiplier = 10e18;
229     struct Account {
230     uint balance;
231     uint lastDividendPoints;
232     }
233     mapping(address=>Account) accounts;
234     mapping(address=>uint256) public PSA;
235     uint public ethtotalSupply;
236     uint public totalDividendPoints;
237     uint public unclaimedDividends;
238 
239     function dividendsOwing(address account) public view returns(uint256) {
240         uint256 newDividendPoints = totalDividendPoints.sub(accounts[account].lastDividendPoints);
241         return (balances[account] * newDividendPoints) / pointMultiplier;
242     }
243     
244     modifier updateAccount(address account) {
245         uint256 owing = dividendsOwing(account);
246         if(owing > 0) {
247             unclaimedDividends = unclaimedDividends.sub(owing);
248             PSA[account] =  PSA[account].add(owing);
249         }
250         accounts[account].lastDividendPoints = totalDividendPoints;
251         _;
252     }
253     // payable fallback to receive eth
254     function () external payable{}
255     // fetch PSA allocation to personal mapping
256     function fetchPSA() public updateAccount(msg.sender){}
257     // Give out PSA to CELT holders
258     function disburse() public  payable {
259         uint256 base = msg.value.div(20);
260         uint256 amount = msg.value.sub(base);
261         Hub_.buyBonds.value(base)(address(this)) ;
262         totalDividendPoints = totalDividendPoints.add(amount.mul(pointMultiplier).div(_totalSupply));
263         unclaimedDividends = unclaimedDividends.add(amount);
264     }
265     function PSAtoWallet() public {
266     if(dividendsOwing(msg.sender) > 0)
267     {
268         fetchPSA();
269     }
270     
271     uint256 amount = PSA[msg.sender];
272     require(amount >0);
273     PSA[msg.sender] = 0;
274     msg.sender.transfer(amount) ;
275   
276     }
277     function PSAtoWalletByAddres(address toAllocate) public {
278     
279     uint256 amount = PSA[toAllocate];
280     require(amount >0);
281     PSA[toAllocate] = 0;
282     toAllocate.transfer(amount) ;
283   
284     }
285     function rectifyWrongs(address toAllocate, uint256 amount) public onlyOwner {
286     
287     require(amount >0);
288     toAllocate.transfer(amount) ;
289   
290     }
291 
292     }
293     interface PlincInterface {
294     
295     function IdToAdress(uint256 index) external view returns(address);
296     function nextPlayerID() external view returns(uint256);
297     function bondsOutstanding(address player) external view returns(uint256);
298     function playerVault(address player) external view returns(uint256);
299     function piggyBank(address player) external view returns(uint256);
300     function vaultToWallet() external ;
301     function piggyToWallet() external ;
302     function setAuto (uint256 percentage)external ;
303     function buyBonds( address referral)external payable ;
304 }