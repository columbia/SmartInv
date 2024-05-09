1 pragma solidity ^0.5.5;
2 
3 // ----------------------------------------------------------------------------
4 // 'RNBW2' token contract
5 //
6 // Deployed to : 
7 // Symbol      : RNBW2
8 // Name        : RNBW2 Token
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
21     }
22     function safeSub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function safeMul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function safeDiv(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint);
42     function balanceOf(address tokenOwner) public view returns (uint balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 // ----------------------------------------------------------------------------
53 // Contract function to receive approval and execute function in one call
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address payable token, bytes memory data) public;
57 }
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address payable public _owner;
64     address payable private _newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         _owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == _owner);
74         _;
75     }
76 
77     function transferOwnership(address payable newOwner) public onlyOwner {
78         _newOwner = newOwner;
79     }
80 
81     function acceptOwnership() public {
82         require(msg.sender == _newOwner);
83         emit OwnershipTransferred(_owner, _newOwner);
84         _owner = _newOwner;
85         _newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 // ERC20 Token, with the addition of symbol, name and decimals and assisted
92 // token transfers
93 // ----------------------------------------------------------------------------
94 contract RNBW2 is ERC20Interface, Owned, SafeMath {
95 
96     string public symbol;
97     string public name;
98     string public description;
99     uint8 public decimals;    
100     uint private _startDate;
101     uint private _bonusOneEnds;
102     uint private _bonusTwoEnds;
103     uint private _endDate;
104     
105     uint256 private _internalCap;
106     uint256 private _softCap;
107     uint256 private _totalSupply;
108 
109     mapping(address => uint256) _balances;
110     mapping(address => mapping(address => uint256)) _allowed;
111     mapping(address => bool) _freezeState;
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     constructor(
117         address payable minter) public {
118         
119         name   = "RNBW2 Token";
120         description = "RNBW2 Token for PowerBrain.shop appliance";
121         symbol = "RNBW2";
122         decimals = 18;
123         _internalCap = 25000000 * 1000000000000000000; //18 decimals
124         _softCap = _internalCap * 2;
125         
126         _startDate = now;        
127         _bonusOneEnds = now + 4 days ;
128         _bonusTwoEnds = now + 12 days;
129         _endDate = now + 26 days;
130             
131         _owner = minter;
132         _balances[_owner] = _internalCap;  
133         _totalSupply = _internalCap;
134         emit Transfer(address(0), _owner, _internalCap);
135     }
136 
137     modifier IcoSuccessful {
138         require(now >= _endDate);
139         require(_totalSupply >= _softCap);
140         _;
141     }
142 
143     // ------------------------------------------------------------------------
144     // Total supply
145     // ------------------------------------------------------------------------
146     function totalSupply() public view returns (uint) {
147         return _totalSupply - _balances[address(0)];
148     }
149 
150     // ------------------------------------------------------------------------
151     // Get the token balance for account `tokenOwner`
152     // ------------------------------------------------------------------------
153     function balanceOf(address tokenOwner) public view returns (uint balance) {
154         return _balances[tokenOwner];
155     }
156     
157     function isFreezed(address tokenOwner) public view returns (bool freezed) {
158         return _freezeState[tokenOwner];
159     }
160 
161     // ------------------------------------------------------------------------
162     // Transfer the balance from token owner's account to `to` account
163     // - Owner's account must have sufficient balance to transfer
164     // - 0 value transfers are allowed
165     // ------------------------------------------------------------------------
166     function transfer(address to, uint256 tokens) public IcoSuccessful returns (bool success) {
167         require(_freezeState[msg.sender] == false);
168         
169         _balances[msg.sender] = safeSub(_balances[msg.sender], tokens);
170         _balances[to] = safeAdd(_balances[to], tokens);
171         emit Transfer(msg.sender, to, tokens);
172         return true;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Token owner can approve for `spender` to transferFrom(...) `tokens`
177     // from the token owner's account
178     //
179     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
180     // recommends that there are no checks for the approval double-spend attack
181     // as this should be implemented in user interfaces
182     // ------------------------------------------------------------------------
183     function approve(address spender, uint tokens) public IcoSuccessful returns (bool success) {
184         require( _freezeState[spender] == false);
185         _allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         return true;
188     }
189 
190     // ------------------------------------------------------------------------
191     // Transfer `tokens` from the `from` account to the `to` account
192     //
193     // The calling account must already have sufficient tokens approve(...)-d
194     // for spending from the `from` account and
195     // - From account must have sufficient balance to transfer
196     // - Spender must have sufficient allowance to transfer
197     // - 0 value transfers are allowed
198     // ------------------------------------------------------------------------
199     function transferFrom(address from, address to, uint tokens) public IcoSuccessful returns (bool success) {
200         require( _freezeState[from] == false && _freezeState[to] == false);
201         
202         _balances[from] = safeSub(_balances[from], tokens);
203         _allowed[from][msg.sender] = safeSub(_allowed[from][msg.sender], tokens);
204         _balances[to] = safeAdd(_balances[to], tokens);
205         emit Transfer(from, to, tokens);
206         return true;
207     }
208 
209     // ------------------------------------------------------------------------
210     // Returns the amount of tokens approved by the owner that can be
211     // transferred to the spender's account
212     // ------------------------------------------------------------------------
213     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
214         require(_freezeState[spender] == false);
215         return _allowed[tokenOwner][spender];
216     }
217 
218     // ------------------------------------------------------------------------
219     // Token owner can approve for `spender` to transferFrom(...) `tokens`
220     // from the token owner's account. The `spender` contract function
221     // `receiveApproval(...)` is then executed
222     // ------------------------------------------------------------------------
223     function approveAndCall(address spender, uint tokens, bytes memory data) public IcoSuccessful returns (bool success) {
224         require(_freezeState[spender] == false);
225         _allowed[msg.sender][spender] = tokens;
226         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, _owner, data);
227         emit Approval(msg.sender, spender, tokens);
228         return true;
229     }
230 
231     // ------------------------------------------------------------------------
232     // 1 RNBW2 Tokens per 1 finney
233     // ------------------------------------------------------------------------
234     function purchase() public payable {
235     
236         require(now >= _startDate && now <= _endDate);
237         /*require(msg.value >= 500);*/
238         
239         uint256 weiValue = msg.value;
240         uint256 tokens = safeMul(weiValue, 1);// 1 finney = 1000000000000000 wei
241         
242         if (now <= _bonusOneEnds) {
243             tokens = safeDiv(safeMul(tokens, 15) , 10);
244         } else {
245             if (now <= _bonusTwoEnds) {
246                 tokens = safeDiv(safeMul( tokens, 12) , 10);
247             }
248         }        
249         _freezeState[msg.sender] = false;
250         _balances[msg.sender] = safeAdd(_balances[msg.sender], tokens);
251         _totalSupply = safeAdd(_totalSupply, tokens);
252         emit Transfer(address(0), msg.sender, tokens);
253     }
254     
255     function () payable external {
256         purchase();
257     }
258 
259     function withdraw() public onlyOwner returns (bool success) {
260         _owner.transfer(address(this).balance);
261         return true;
262     }
263 
264     function freeze(address account) public onlyOwner returns (bool success) {
265         require(account != _owner && account != address(0));
266         _freezeState[account] = true;
267         return true;
268     }
269     
270     function unfreeze(address account) public onlyOwner returns (bool success) {
271         require(account != _owner && account != address(0));
272         _freezeState[account] = false;
273         return true;
274     }
275    
276     // ------------------------------------------------------------------------
277     // Owner can transfer out any accidentally sent ERC20 tokens
278     // ------------------------------------------------------------------------
279     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
280         return ERC20Interface(tokenAddress).transfer(_owner, tokens);
281     }
282 }