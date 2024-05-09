1 pragma solidity ^0.5.4;
2 
3 // ----------------------------------------------------------------------------
4 // 'RNBW' token contract
5 //
6 // Deployed to : 
7 // Symbol      : RNBW
8 // Name        : RNBW Token
9 // Description : Virtual Geospatial Networking Asset
10 // Total supply: Dynamic ITO
11 // Decimals    : 18
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 contract SafeMath {
18     function safeAdd(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21         
22     }
23     function safeSub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public view returns (uint);
44     function balanceOf(address tokenOwner) public view returns (uint balance);
45     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address payable token, bytes memory data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address payable public _owner;
68     address payable private _newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     constructor() public {
73         _owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == _owner);
78         _;
79     }
80 
81     function transferOwnership(address payable newOwner) public onlyOwner {
82         _newOwner = newOwner;
83     }
84 
85     function acceptOwnership() public {
86         require(msg.sender == _newOwner);
87         emit OwnershipTransferred(_owner, _newOwner);
88         _owner = _newOwner;
89         _newOwner = address(0);
90     }
91 }
92 
93 
94 // ----------------------------------------------------------------------------
95 // ERC20 Token, with the addition of symbol, name and decimals and assisted
96 // token transfers
97 // ----------------------------------------------------------------------------
98 contract RNBW is ERC20Interface, Owned, SafeMath {
99     string public symbol;
100     string public name;
101     string public description;
102     uint8 public decimals;    
103     uint private _startDate;
104     uint private _bonusEnds;
105     uint private _endDate;
106     
107     uint256 private _internalCap;
108     uint256 private _softCap;
109     uint256 private _totalSupply;
110 
111     mapping(address => uint256) _balances;
112     mapping(address => mapping(address => uint256)) _allowed;
113     mapping(address => bool) _freezeState;
114 
115 
116     // ------------------------------------------------------------------------
117     // Constructor
118     // ------------------------------------------------------------------------
119     constructor(
120         address payable minter) public {
121         
122         name   = "RNBW Token";
123         description = "Virtual Geospatial Networking Asset";
124         symbol = "RNBW";
125         decimals = 18;
126         _internalCap = 25000000 * 1000000000000000000;
127         _softCap     = _internalCap * 2;
128         
129         _bonusEnds = now + 3 days;
130         _endDate = now + 1 weeks;
131             
132         _owner = minter;
133         _balances[_owner] = _internalCap;  
134         _totalSupply = _internalCap;
135         emit Transfer(address(0), _owner, _internalCap);
136     }
137 
138     modifier IcoSuccessful {
139         require(now >= _endDate);
140         require(_totalSupply >= _softCap);
141         _;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Total supply
147     // ------------------------------------------------------------------------
148     function totalSupply() public view returns (uint) {
149         return _totalSupply - _balances[address(0)];
150     }
151 
152 
153     // ------------------------------------------------------------------------
154     // Get the token balance for account `tokenOwner`
155     // ------------------------------------------------------------------------
156     function balanceOf(address tokenOwner) public view returns (uint balance) {
157         return _balances[tokenOwner];
158     }
159     
160     function isFreezed(address tokenOwner) public view returns (bool freezed) {
161         return _freezeState[tokenOwner];
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer the balance from token owner's account to `to` account
167     // - Owner's account must have sufficient balance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transfer(address to, uint256 tokens) public IcoSuccessful returns (bool success) {
171         require(_freezeState[msg.sender] == false);
172         
173         _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);
174         _balances[to] = safeAdd(_balances[to], tokens);
175         emit Transfer(msg.sender, to, tokens);
176         return true;
177     }
178     
179 
180     // ------------------------------------------------------------------------
181     // Token owner can approve for `spender` to transferFrom(...) `tokens`
182     // from the token owner's account
183     //
184     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
185     // recommends that there are no checks for the approval double-spend attack
186     // as this should be implemented in user interfaces
187     // ------------------------------------------------------------------------
188     function approve(address spender, uint tokens) public IcoSuccessful returns (bool success) {
189         require( _freezeState[spender] == false);
190         _allowed[msg.sender][spender] = tokens;
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
205     function transferFrom(address from, address to, uint tokens) public IcoSuccessful returns (bool success) {
206         require( _freezeState[from] == false && _freezeState[to] == false);
207         
208         _balances[from] = safeSub(_balances[from], tokens);
209         _allowed[from][msg.sender] = safeSub(_allowed[from][msg.sender], tokens);
210         _balances[to] = safeAdd(_balances[to], tokens);
211         emit Transfer(from, to, tokens);
212         return true;
213     }
214 
215 
216     // ------------------------------------------------------------------------
217     // Returns the amount of tokens approved by the owner that can be
218     // transferred to the spender's account
219     // ------------------------------------------------------------------------
220     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
221         require(_freezeState[spender] == false);
222         return _allowed[tokenOwner][spender];
223     }
224 
225     // ------------------------------------------------------------------------
226     // Token owner can approve for `spender` to transferFrom(...) `tokens`
227     // from the token owner's account. The `spender` contract function
228     // `receiveApproval(...)` is then executed
229     // ------------------------------------------------------------------------
230     function approveAndCall(address spender, uint tokens, bytes memory data) public IcoSuccessful returns (bool success) {
231         require(_freezeState[spender] == false);
232         _allowed[msg.sender][spender] = tokens;
233         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, _owner, data);
234         emit Approval(msg.sender, spender, tokens);
235         return true;
236     }
237 
238     // ------------------------------------------------------------------------
239     // 1 RNBW Tokens per 1 Wei
240     // ------------------------------------------------------------------------
241     function buy() public payable {
242     
243         require(msg.value >= 1 finney);
244         require(now >= _startDate && now <= _endDate);
245 
246         uint256 weiValue = msg.value;
247         uint256 tokens = 0;
248         
249         if (now <= _bonusEnds) {
250             tokens = safeMul(weiValue, 2);
251         } else {
252             tokens = safeMul(weiValue, 1);
253         }
254         
255         _freezeState[msg.sender] = true;
256         _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);
257         _totalSupply = safeAdd(_totalSupply, tokens);
258         emit Transfer(address(0), msg.sender, tokens);
259         _owner.transfer(address(this).balance);
260     }
261     
262     function () payable external {
263         buy();
264     }
265 
266     function burn(uint256 tokens) public onlyOwner returns (bool success) {
267         require(_balances[msg.sender] >= tokens);   // Check if the sender has enough
268         address burner = msg.sender;
269         _balances[burner] = safeSub(_balances[burner], tokens);
270         _totalSupply = safeSub(_totalSupply, tokens);
271         emit Transfer(burner, address(0), tokens);
272         return true;
273     }
274     
275     function burnFrom(address account, uint256 tokens) public onlyOwner returns (bool success) {
276         require(_balances[account] >= tokens);   // Check if the sender has enough
277         address burner = account;
278         _balances[burner] = safeSub(_balances[burner], tokens);
279         _totalSupply = safeSub(_totalSupply, tokens);
280         emit Transfer(burner, address(0), tokens);
281         return true;
282     }
283     
284     function freeze(address account) public onlyOwner returns (bool success) {
285         require(account != _owner && account != address(0));
286         _freezeState[account] = true;
287         return true;
288     }
289     
290     function unfreeze(address account) public onlyOwner returns (bool success) {
291         require(account != _owner && account != address(0));
292         _freezeState[account] = false;
293         return true;
294     }
295     
296     function mint(uint256 tokens) public onlyOwner returns (bool success)
297     {
298         require(now >= _startDate && now <= _endDate);
299         _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);
300         _totalSupply = safeAdd(_totalSupply, tokens);
301         emit Transfer(address(0), msg.sender, tokens);
302         return true;
303     }
304 
305     // ------------------------------------------------------------------------
306     // Owner can transfer out any accidentally sent ERC20 tokens
307     // ------------------------------------------------------------------------
308     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
309         return ERC20Interface(tokenAddress).transfer(_owner, tokens);
310     }
311 }