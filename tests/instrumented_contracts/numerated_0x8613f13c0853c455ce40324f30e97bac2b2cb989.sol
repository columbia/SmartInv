1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
29 // ----------------------------------------------------------------------------
30 contract ERC20Interface {
31     function totalSupply() public view returns (uint);
32     function balanceOf(address tokenOwner) public view returns (uint balance);
33     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
34     function transfer(address to, uint tokens) public returns (bool success);
35     function approve(address spender, uint tokens) public returns (bool success);
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 
43 contract CrowdsaleInterface {
44 
45     bool fundingGoalReached = false;
46     bool crowdsaleClosed = false;
47 
48     mapping(address => bool) whitelist;
49     mapping(uint256 => address) holders;
50     uint256 _totalHolders; // you should initialize this to 0 in the constructor
51 
52     function enableWhitelist(address[] _addresses) public returns (bool success);
53 
54     modifier onlyWhitelist() {
55         require(whitelist[msg.sender] == true);
56         _;
57     }
58 
59 
60 
61 
62 }
63 
64 // ----------------------------------------------------------------------------
65 // Contract function to receive approval and execute function in one call
66 //
67 // Borrowed from MiniMeToken
68 // ----------------------------------------------------------------------------
69 contract ApproveAndCallFallBack {
70     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
71 }
72 
73 
74 // ----------------------------------------------------------------------------
75 // Owned contract
76 // ----------------------------------------------------------------------------
77 contract Owned {
78     address public owner;
79     address public newOwner;
80 
81     event OwnershipTransferred(address indexed _from, address indexed _to);
82 
83     constructor() public {
84         owner = msg.sender;
85     }
86 
87     modifier onlyOwner {
88         require(msg.sender == owner);
89         _;
90     }
91 
92     function transferOwnership(address _newOwner) public onlyOwner {
93         newOwner = _newOwner;
94     }
95     function acceptOwnership() public {
96         require(msg.sender == newOwner);
97         emit OwnershipTransferred(owner, newOwner);
98         owner = newOwner;
99         newOwner = address(0);
100     }
101 }
102 
103 contract TokenTemplate is ERC20Interface, CrowdsaleInterface, Owned {
104     using SafeMath for uint;
105 
106     bytes32 public symbol;
107     uint public price;
108     bytes32 public  name;
109     uint8 public decimals;
110     uint _totalSupply;
111     uint amountRaised;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     constructor(bytes32 _name, bytes32 _symbol, uint _total, uint _gweiCostOfEachToken) public {
121         symbol = _symbol;
122         name = _name;
123         decimals = 18;
124         price= _gweiCostOfEachToken * 1e9;
125         _totalSupply = _total * 10**uint(decimals);
126 
127         _totalHolders = 0;
128         balances[owner] = _totalSupply;
129         holders[_totalHolders] = owner;
130         _totalHolders++;
131 
132         emit Transfer(address(0), owner, _totalSupply);
133 
134 
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Total supply
140     // ------------------------------------------------------------------------
141     function totalSupply() public view returns (uint) {
142         return _totalSupply.sub(balances[address(0)]);
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Get the token balance for account `tokenOwner`
148     // ------------------------------------------------------------------------
149     function balanceOf(address tokenOwner) public view returns (uint balance) {
150         return balances[tokenOwner];
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer the balance from token owner's account to `to` account
156     // - Owner's account must have sufficient balance to transfer
157     // - 0 value transfers are allowed
158     // ------------------------------------------------------------------------
159     function transfer(address to, uint tokens) public returns (bool success) {
160         balances[msg.sender] = balances[msg.sender].sub(tokens);
161         balances[to] = balances[to].add(tokens);
162         emit Transfer(msg.sender, to, tokens);
163         return true;
164     }
165 
166 
167     // ------------------------------------------------------------------------
168     // Token owner can approve for `spender` to transferFrom(...) `tokens`
169     // from the token owner's account
170     //
171     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
172     // recommends that there are no checks for the approval double-spend attack
173     // as this should be implemented in user interfaces
174     // ------------------------------------------------------------------------
175     function approve(address spender, uint tokens) public returns (bool success) {
176         allowed[msg.sender][spender] = tokens;
177         emit Approval(msg.sender, spender, tokens);
178         return true;
179     }
180 
181 
182     // ------------------------------------------------------------------------
183     // Transfer `tokens` from the `from` account to the `to` account
184     //
185     // The calling account must already have sufficient tokens approve(...)-d
186     // for spending from the `from` account and
187     // - From account must have sufficient balance to transfer
188     // - Spender must have sufficient allowance to transfer
189     // - 0 value transfers are allowed
190     // ------------------------------------------------------------------------
191     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
192         balances[from] = balances[from].sub(tokens);
193         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
194         balances[to] = balances[to].add(tokens);
195         emit Transfer(from, to, tokens);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Returns the amount of tokens approved by the owner that can be
202     // transferred to the spender's account
203     // ------------------------------------------------------------------------
204     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
205         return allowed[tokenOwner][spender];
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Token owner can approve for `spender` to transferFrom(...) `tokens`
211     // from the token owner's account. The `spender` contract function
212     // `receiveApproval(...)` is then executed
213     // ------------------------------------------------------------------------
214     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
215         allowed[msg.sender][spender] = tokens;
216         emit Approval(msg.sender, spender, tokens);
217         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
218         return true;
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 
229 
230    function enableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
231         for (uint i = 0; i < _addresses.length; i++) {
232             if (whitelist[_addresses[i]] == true) {
233 
234             } else {
235                 whitelist[_addresses[i]] = true;
236                 holders[_totalHolders] = _addresses[i];
237                 _totalHolders++;
238             }
239         }
240         return true;
241     }
242 
243     function getWhitelist() public view returns (address[] addresses) {
244 
245         address[] memory wlist = new address[](_totalHolders);
246 
247         for (uint256 j=0; j<_totalHolders; j++) {
248             wlist[j] = holders[j];
249         }
250         return wlist;
251     }
252 
253     function getBalances() public view returns (address[] _addresses, uint256[] _balances) {
254         address[] memory wlist1 = new address[](_totalHolders);
255         uint256[] memory wlist2 = new uint256[](_totalHolders);
256 
257         for (uint256 j=0; j<_totalHolders; j++) {
258             wlist1[j] = holders[j];
259             wlist2[j] = balances[holders[j]];
260         }
261         return (wlist1,wlist2);
262     }
263 
264     function closeCrowdsale() public onlyOwner  {
265 
266         crowdsaleClosed = true;
267     }
268 
269     function safeWithdrawal() public onlyOwner {
270         require(crowdsaleClosed);
271         require(!fundingGoalReached);
272 
273         if (msg.sender.send(amountRaised)) {
274             fundingGoalReached = true;
275         } else {
276             fundingGoalReached = false;
277         }
278 
279     }
280 
281 
282 
283     function () payable onlyWhitelist public {
284 
285         require(!crowdsaleClosed);
286         uint amount = msg.value;
287         uint token_amount = amount.div(price);
288 
289         amountRaised = amountRaised.add(amount);
290 
291 
292         balances[owner] = balances[owner].sub(token_amount);
293         balances[msg.sender] = balances[msg.sender].add(token_amount);
294         emit Transfer(owner, msg.sender, token_amount);
295 
296 
297         // whitelist[investor] = false;
298     }
299 
300 
301 }