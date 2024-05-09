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
49 
50     function enableWhitelist(address[] _addresses) public returns (bool success);
51 
52     modifier onlyWhitelist() {
53         require(whitelist[msg.sender] == true);
54         _;
55     }
56 
57 
58 
59 
60 }
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     constructor() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         emit OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 contract TokenTemplate is ERC20Interface, CrowdsaleInterface, Owned {
102     using SafeMath for uint;
103 
104     bytes32 public symbol;
105     uint public price;
106     bytes32 public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109     uint amountRaised;
110 
111     mapping(address => uint) balances;
112     mapping(address => mapping(address => uint)) allowed;
113 
114 
115     // ------------------------------------------------------------------------
116     // Constructor
117     // ------------------------------------------------------------------------
118     constructor(bytes32 _name, bytes32 _symbol, uint _total, uint _gweiCostOfEachToken) public {
119         symbol = _symbol;
120         name = _name;
121         decimals = 18;
122         price= _gweiCostOfEachToken * 1e9;
123         _totalSupply = _total * 10**uint(decimals);
124         balances[owner] = _totalSupply;
125         emit Transfer(address(0), owner, _totalSupply);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Total supply
131     // ------------------------------------------------------------------------
132     function totalSupply() public view returns (uint) {
133         return _totalSupply.sub(balances[address(0)]);
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Get the token balance for account `tokenOwner`
139     // ------------------------------------------------------------------------
140     function balanceOf(address tokenOwner) public view returns (uint balance) {
141         return balances[tokenOwner];
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer the balance from token owner's account to `to` account
147     // - Owner's account must have sufficient balance to transfer
148     // - 0 value transfers are allowed
149     // ------------------------------------------------------------------------
150     function transfer(address to, uint tokens) public returns (bool success) {
151         balances[msg.sender] = balances[msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         emit Transfer(msg.sender, to, tokens);
154         return true;
155     }
156 
157 
158     // ------------------------------------------------------------------------
159     // Token owner can approve for `spender` to transferFrom(...) `tokens`
160     // from the token owner's account
161     //
162     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         emit Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer `tokens` from the `from` account to the `to` account
175     //
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the `from` account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = balances[from].sub(tokens);
184         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
185         balances[to] = balances[to].add(tokens);
186         emit Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for `spender` to transferFrom(...) `tokens`
202     // from the token owner's account. The `spender` contract function
203     // `receiveApproval(...)` is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         emit Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Owner can transfer out any accidentally sent ERC20 tokens
215     // ------------------------------------------------------------------------
216     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
217         return ERC20Interface(tokenAddress).transfer(owner, tokens);
218     }
219 
220 
221    function enableWhitelist(address[] _addresses) public onlyOwner returns (bool success) {
222         for (uint i = 0; i < _addresses.length; i++) {
223             whitelist[_addresses[i]] = true;
224         }
225     }
226 
227     function closeCrowdsale() public onlyOwner  {
228 
229         crowdsaleClosed = true;
230     }
231 
232     function safeWithdrawal() public onlyOwner {
233         require(crowdsaleClosed);
234         require(!fundingGoalReached);
235 
236         if (msg.sender.send(amountRaised)) {
237             fundingGoalReached = true;
238         } else {
239             fundingGoalReached = false;
240         }
241 
242     }
243 
244     function () payable onlyWhitelist public {
245         address investor = msg.sender;
246         //do something
247 
248         require(!crowdsaleClosed);
249         uint amount = msg.value;
250         uint token_amount = amount.div(price);
251 
252         amountRaised = amountRaised.add(amount);
253 
254 
255         balances[owner] = balances[owner].sub(token_amount);
256         balances[investor] = balances[investor].add(token_amount);
257         emit Transfer(owner, investor, token_amount);
258 
259 
260         // whitelist[investor] = false;
261     }
262 
263 
264 }