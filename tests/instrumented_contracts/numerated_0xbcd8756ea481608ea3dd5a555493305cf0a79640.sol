1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 // ----------------------------------------------------------------------------
27 // ERC Token Standard #20 Interface
28 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
43 // ----------------------------------------------------------------------------
44 // Owned contract
45 // ----------------------------------------------------------------------------
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         var oldOwner = owner;
63         owner = _newOwner;
64         OwnershipTransferred(oldOwner, owner);
65     }
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ERC20 Token, with the addition of symbol, name and decimals and assisted
71 // token transfers
72 // ----------------------------------------------------------------------------
73 contract PazziToken is ERC20Interface, Owned, SafeMath {
74     string public name = "Pazzi";
75     string public symbol = "PAZZI";
76     uint8 public decimals = 18;
77     uint public _totalSupply;
78     uint public startDate;
79     bool public isLocked;
80 
81     address[]   private     vaultList;
82     mapping(address => uint) vaultAmount;
83     mapping(address => uint) vaultReleaseTime;
84 
85     mapping(address => uint) balances;
86     mapping(address => mapping(address => uint)) allowed;
87 
88 
89     // ------------------------------------------------------------------------
90     // Constructor
91     // ------------------------------------------------------------------------
92     function PazziToken(address multisig, uint tokens) public {
93         _totalSupply = tokens;
94         balances[multisig] = safeAdd(balances[multisig], tokens);
95         isLocked = false;
96     }
97 
98     modifier isNotLocked {
99         require(!isLocked);
100         _;
101     }
102 
103     function setIsLocked(bool _isLocked) public onlyOwner{
104         isLocked = _isLocked;
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Total supply
110     // ------------------------------------------------------------------------
111     function totalSupply() public view returns (uint) {
112         return _totalSupply  - balances[address(0)];
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Get the token balance for account `tokenOwner`
118     // ------------------------------------------------------------------------
119     function balanceOf(address tokenOwner) public view returns (uint balance) {
120         return balances[tokenOwner];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Transfer the balance from token owner's account to `to` account
126     // - Owner's account must have sufficient balance to transfer
127     // - 0 value transfers are allowed
128     // ------------------------------------------------------------------------
129     function transfer(address to, uint tokens) public isNotLocked returns (bool success) {
130         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
131         balances[to] = safeAdd(balances[to], tokens);
132         Transfer(msg.sender, to, tokens);
133         return true;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Token owner can approve for `spender` to transferFrom(...) `tokens`
139     // from the token owner's account
140     //
141     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
142     // recommends that there are no checks for the approval double-spend attack
143     // as this should be implemented in user interfaces
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer `tokens` from the `from` account to the `to` account
154     //
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the `from` account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public isNotLocked returns (bool success) {
162         balances[from] = safeSub(balances[from], tokens);
163         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
164         balances[to] = safeAdd(balances[to], tokens);
165         Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     function () external payable {
180         revert();
181     }
182 
183     // ------------------------------------------------------------------------
184     // INCREASE token supply
185     // ------------------------------------------------------------------------
186     function mint(address to, uint value) public onlyOwner returns (bool) {
187         require(value > 0);
188         _totalSupply = safeAdd(_totalSupply, value);
189         balances[to] = safeAdd(balances[to], value);
190         Transfer(0, to, value);
191         return true;
192     }
193 
194     function _burn(address account, uint256 amount) internal {
195         require(account != address(0));
196 
197         balances[account] = safeSub(balances[account], amount);
198         _totalSupply = safeSub(_totalSupply, amount);
199         Transfer(account, address(0), amount);
200     }
201 
202     // ------------------------------------------------------------------------
203     // DECREASE token supply
204     // ------------------------------------------------------------------------
205     function burn(uint amount) public {
206         require(amount > 0);
207         _burn(msg.sender, amount);
208     }
209 
210     // ------------------------------------------------------------------------
211     // DECREASE token supply
212     // ------------------------------------------------------------------------
213     function burnFrom(address from, uint amount) public {
214         require(allowance(from, msg.sender) >= amount);
215         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], amount);
216         _burn(from, amount);
217     }
218 
219     function tokenToVault(address to, uint amount, uint releastTime) public onlyOwner {
220         require(to != address(0x0));
221         vaultAmount[to] = safeAdd(vaultAmount[to], amount);
222         vaultReleaseTime[to] = releastTime;
223         _totalSupply = safeAdd(_totalSupply, amount);
224         balances[address(this)] = safeAdd(balances[address(this)], amount);
225         vaultList.push(to);
226     }
227 
228     function releaseToken() public {
229         require(vaultAmount[msg.sender] > 0);
230         require(block.timestamp >= vaultReleaseTime[msg.sender]);
231         require(balances[address(this)] >= vaultAmount[msg.sender]);
232 
233         balances[msg.sender] = safeAdd(balances[msg.sender], vaultAmount[msg.sender]);
234         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[msg.sender]);
235         vaultAmount[msg.sender] = 0;
236         _removeFromVault(msg.sender);
237     }
238 
239     function releateTokenTo(address to) public onlyOwner {
240         require(vaultAmount[to] > 0);
241         require(block.timestamp >= vaultReleaseTime[to]);
242         require(balances[address(this)] >= vaultAmount[to]);
243 
244         balances[to] = safeAdd(balances[to], vaultAmount[to]);
245         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[to]);
246         vaultAmount[to] = 0;
247         _removeFromVault(to);
248     }
249 
250     function _removeFromVault(address addr) internal {
251         uint index;
252         uint length = vaultList.length;
253         for (index = 0; index < length; index++){
254             if (vaultList[index] == addr) {
255               break;
256             }
257         }
258 
259         /// There is no use-case for inexistent
260         assert(index < length);
261         /// Remove out of list and map
262         if ( index + 1 != length ) {
263             /// Move the last to the current
264             vaultList[index] = vaultList[length - 1];
265         }
266         delete vaultList[length - 1];
267         vaultList.length--;
268         delete vaultReleaseTime[addr];
269         delete vaultAmount[addr];
270     }
271 
272     function getVaultAmountFrom(address from) public view onlyOwner returns (uint amount) {
273         return vaultAmount[from];
274     }
275 
276     function getVaultAmount() public view returns (uint amount) {
277         return vaultAmount[msg.sender];
278     }
279 
280     function getVaultReleaseTimeFrom(address from) public view onlyOwner returns (uint releaseTime) {
281         return vaultReleaseTime[from];
282     }
283 
284     function getVaultReleaseTime() public view returns (uint releaseTime) {
285         return vaultReleaseTime[msg.sender];
286     }
287 
288     function getVaultList() public view onlyOwner returns (address[] list) {
289         return vaultList;
290     }
291 }