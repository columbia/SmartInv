1 pragma solidity ^0.4.24;
2 
3 // ****************************************************************************
4 //
5 // Symbol          : AIC20
6 // Name            : Agricultural industrial chain 20
7 // Decimals        : 8
8 // Total supply    : 1,000,000,000.00000000
9 //
10 // ****************************************************************************
11 
12 
13 // ****************************************************************************
14 // ERC Token Standard #20 Interface
15 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
16 // ****************************************************************************
17 contract ERC20 {
18     function totalSupply() public constant returns (uint);
19     function balanceOf(address tokenOwner) public constant returns (uint balance);
20     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
21     function transfer(address to, uint tokens) public returns (bool success);
22     function approve(address spender, uint tokens) public returns (bool success);
23     function transferFrom(address from, address to, uint tokens) public returns (bool success);
24 
25     event Transfer(address indexed from, address indexed to, uint tokens);
26     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
27 }
28 
29 // ****************************************************************************
30 // Contract function to receive approval and execute function
31 // ****************************************************************************
32 contract ApproveAndCallFallBack {
33     function receiveApproval(address from, uint tokens, address token, bytes data) public;
34 }
35 
36 // ****************************************************************************
37 // Owned contract
38 // ****************************************************************************
39 contract Owned {
40     
41     address public owner;
42     address public newOwner;
43 
44     event OwnershipTransferred(address indexed _from, address indexed _to);
45 
46     constructor() public {
47         owner = msg.sender;
48     }
49 
50     modifier onlyOwner {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         newOwner = _newOwner;
57     }
58     
59     function acceptOwnership() public {
60         require(msg.sender == newOwner);
61         emit OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63         newOwner = address(0);
64     }
65 }
66 
67 // ****************************************************************************
68 // BECC Token, with the addition of symbol, name and decimals and a fixed supply
69 // ****************************************************************************
70 contract AIC20Token is ERC20, Owned {
71     using SafeMath for uint;
72     
73     event Pause();
74     event Unpause();
75 
76     bool public paused = false;
77     string public symbol;
78     string public name;
79     uint8 public decimals;
80     uint private _totalSupply;
81 
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85     // ************************************************************************
86     // Modifier to make a function callable only when the contract is not paused.
87     // ************************************************************************
88     modifier whenNotPaused() {
89         require(!paused);
90         _;
91     }
92 
93     // ************************************************************************
94     // Modifier to make a function callable only when the contract is paused.
95     // ************************************************************************
96     modifier whenPaused() {
97         require(paused);
98         _;
99     }
100   
101     // ************************************************************************
102     // Constructor
103     // ************************************************************************
104     constructor() public {
105         symbol = "AIC20";
106         name = "Agricultural industrial chain 20";
107         decimals = 8;
108         _totalSupply = 1000000000 * 10**uint(decimals);
109         balances[owner] =  _totalSupply;
110         emit Transfer(address(0), owner, _totalSupply);
111     }
112 
113     // ************************************************************************
114     // Total supply
115     // ************************************************************************
116     function totalSupply() public view returns (uint) {
117         return _totalSupply.sub(balances[address(0)]);
118     }
119 
120     // ************************************************************************
121     // Get the token balance for account `tokenOwner`
122     // ************************************************************************
123     function balanceOf(address tokenOwner) public view returns (uint balance) {
124         return balances[tokenOwner];
125     }
126 
127     // ************************************************************************
128     // Transfer the balance from token owner's account to `to` account
129     // - Owner's account must have sufficient balance to transfer
130     // - 0 value transfers are allowed
131     // ************************************************************************
132     function transfer(address to, uint tokens) public whenNotPaused returns (bool success) {
133         require(address(0) != to && tokens <= balances[msg.sender]);
134         balances[msg.sender] = balances[msg.sender].sub(tokens);
135         balances[to] = balances[to].add(tokens);
136         emit Transfer(msg.sender, to, tokens);
137         return true;
138     }
139 
140     // ************************************************************************
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account
143     // ************************************************************************
144     function approve(address spender, uint tokens) public whenNotPaused returns (bool success) {
145         require(address(0) != spender && 0 <= tokens);
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ************************************************************************
153     // Transfer `tokens` from the `from` account to the `to` account
154     // 
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the `from` account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ************************************************************************
161     function transferFrom(address from, address to, uint tokens) public whenNotPaused returns (bool success) {
162         require(address(0) != to && tokens <= balances[msg.sender] && tokens <= allowed[from][msg.sender]);
163         balances[from] = balances[from].sub(tokens);
164         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
165         balances[to] = balances[to].add(tokens);
166         emit Transfer(from, to, tokens);
167         return true;
168     }
169 
170     // ************************************************************************
171     // Batch transfer for owner.
172     // ************************************************************************
173     function batchTransfer(address[] toAddresses, uint tokens) public onlyOwner whenNotPaused returns (bool success) {
174 		uint len = toAddresses.length;
175 		require(0 < len);
176 		uint amount = tokens.mul(len);
177 		require(amount <= balances[msg.sender]);
178         for (uint i = 0; i < len; i++) {
179             address _to = toAddresses[i];
180             require(address(0) != _to);
181             balances[_to] = balances[_to].add(tokens);
182             balances[msg.sender] = balances[msg.sender].sub(tokens);
183             emit Transfer(msg.sender, _to, tokens);
184         }
185         return true;
186     }
187 
188     // ************************************************************************
189     // Returns the amount of tokens approved by the owner that can be
190     // transferred to the spender's account
191     // ************************************************************************
192     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
193         return allowed[tokenOwner][spender];
194     }
195 
196     // ************************************************************************
197     // Token owner can approve for `spender` to transferFrom(...) `tokens`
198     // from the token owner's account. The `spender` contract function
199     // `receiveApproval(...)` is then executed
200     // ************************************************************************
201     function approveAndCall(address spender, uint tokens, bytes data) public whenNotPaused returns (bool success) {
202         allowed[msg.sender][spender] = tokens;
203         emit Approval(msg.sender, spender, tokens);
204         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
205         return true;
206     }
207 
208     // ************************************************************************
209     // Don't accept ETH
210     // ************************************************************************
211     function () public payable {
212         revert();
213     }
214 
215     // ************************************************************************
216     // called by the owner to pause, triggers stopped state
217     // ************************************************************************
218     function pause() public onlyOwner whenNotPaused {
219         paused = true;
220         emit Pause();
221     }
222 
223     // ************************************************************************
224     // called by the owner to unpause, returns to normal state
225     // ************************************************************************
226     function unpause() public onlyOwner whenPaused {
227         paused = false;
228         emit Unpause();
229     }
230 }
231 
232 // ****************************************************************************
233 // Safe math
234 // ****************************************************************************
235 
236 library SafeMath {
237     
238   function mul(uint _a, uint _b) internal pure returns (uint c) {
239     if (_a == 0) {
240       return 0;
241     }
242     c = _a * _b;
243     assert(c / _a == _b);
244     return c;
245   }
246 
247   function div(uint _a, uint _b) internal pure returns (uint) {
248     return _a / _b;
249   }
250 
251   function sub(uint _a, uint _b) internal pure returns (uint) {
252     assert(_b <= _a);
253     return _a - _b;
254   }
255 
256   function add(uint _a, uint _b) internal pure returns (uint c) {
257     c = _a + _b;
258     assert(c >= _a);
259     return c;
260   }
261 }