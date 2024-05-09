1 pragma solidity ^0.5.16;
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
52     constructor() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         address oldOwner = owner;
63         owner = _newOwner;
64         emit OwnershipTransferred(oldOwner, owner);
65     }
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // ERC20 Token, with the addition of symbol, name and decimals and assisted
71 // token transfers
72 // ----------------------------------------------------------------------------
73 contract PazziToken is ERC20Interface, Owned, SafeMath {
74     string public name = "PAPARAZZI-NEW";
75     string public symbol = "PAZZI-N";
76     uint8 public decimals = 18;
77     uint public _totalSupply = 168717761e18;
78     uint public startDate;
79     bool public isLocked;
80     
81     address[]   private     blackList;
82     address[]   private     vaultList;
83     mapping(address => uint) vaultAmount;
84     mapping(address => uint) vaultReleaseTime;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89 
90     // ------------------------------------------------------------------------
91     // Constructor
92     // ------------------------------------------------------------------------
93     constructor(address multisig) public {
94         balances[multisig] = safeAdd(balances[multisig], _totalSupply);
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
124     function isBlacklisted(address account) private view returns(bool) {
125         uint i;
126         for (i = 0; i < blackList.length; i++) {
127             if (blackList[i] == account)
128                 return true;
129         }
130         return false;
131     }
132     
133     
134     function addBlacklist(address account) public onlyOwner {
135         require(account != address(0));
136         blackList.push(account);
137     }
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public isNotLocked returns (bool success) {
144         require(isBlacklisted(msg.sender) == false);
145         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
146         balances[to] = safeAdd(balances[to], tokens);
147         emit Transfer(msg.sender, to, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Token owner can approve for `spender` to transferFrom(...) `tokens`
154     // from the token owner's account
155     //
156     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
157     // recommends that there are no checks for the approval double-spend attack
158     // as this should be implemented in user interfaces
159     // ------------------------------------------------------------------------
160     function approve(address spender, uint tokens) public returns (bool success) {
161         require(isBlacklisted(msg.sender) == false);
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167 
168     // ------------------------------------------------------------------------
169     // Transfer `tokens` from the `from` account to the `to` account
170     //
171     // The calling account must already have sufficient tokens approve(...)-d
172     // for spending from the `from` account and
173     // - From account must have sufficient balance to transfer
174     // - Spender must have sufficient allowance to transfer
175     // - 0 value transfers are allowed
176     // ------------------------------------------------------------------------
177     function transferFrom(address from, address to, uint tokens) public isNotLocked returns (bool success) {
178         require(isBlacklisted(msg.sender) == false);
179         balances[from] = safeSub(balances[from], tokens);
180         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
181         balances[to] = safeAdd(balances[to], tokens);
182         emit Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Returns the amount of tokens approved by the owner that can be
189     // transferred to the spender's account
190     // ------------------------------------------------------------------------
191     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
192         return allowed[tokenOwner][spender];
193     }
194 
195 
196     function () external payable {
197         revert();
198     }
199 
200     // ------------------------------------------------------------------------
201     // INCREASE token supply
202     // ------------------------------------------------------------------------
203     function mint(address to, uint value) public onlyOwner returns (bool) {
204         require(isBlacklisted(to) == false);
205         require(value > 0);
206         _totalSupply = safeAdd(_totalSupply, value);
207         balances[to] = safeAdd(balances[to], value);
208         emit Transfer(address(0) , to, value);
209         return true;
210     }
211 
212     function _burn(address account, uint256 amount) internal {
213         require(account != address(0));
214 
215         balances[account] = safeSub(balances[account], amount);
216         _totalSupply = safeSub(_totalSupply, amount);
217         emit Transfer(account, address(0), amount);
218     }
219 
220     // ------------------------------------------------------------------------
221     // DECREASE token supply
222     // ------------------------------------------------------------------------
223     function burn(uint amount) public {
224         require(amount > 0);
225         _burn(msg.sender, amount);
226     }
227 
228     // ------------------------------------------------------------------------
229     // DECREASE token supply
230     // ------------------------------------------------------------------------
231     function burnFrom(address from, uint amount) public {
232         require(allowance(from, msg.sender) >= amount);
233         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], amount);
234         _burn(from, amount);
235     }
236 
237     function tokenToVault(address to, uint amount, uint releastTime) public onlyOwner {
238         require(to != address(0x0));
239         vaultAmount[to] = safeAdd(vaultAmount[to], amount);
240         vaultReleaseTime[to] = releastTime;
241         _totalSupply = safeAdd(_totalSupply, amount);
242         balances[address(this)] = safeAdd(balances[address(this)], amount);
243         vaultList.push(to);
244     }
245 
246     function releaseToken() public {
247         require(vaultAmount[msg.sender] > 0);
248         require(block.timestamp >= vaultReleaseTime[msg.sender]);
249         require(balances[address(this)] >= vaultAmount[msg.sender]);
250 
251         balances[msg.sender] = safeAdd(balances[msg.sender], vaultAmount[msg.sender]);
252         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[msg.sender]);
253         vaultAmount[msg.sender] = 0;
254         _removeFromVault(msg.sender);
255     }
256 
257     function releateTokenTo(address to) public onlyOwner {
258         require(vaultAmount[to] > 0);
259         require(block.timestamp >= vaultReleaseTime[to]);
260         require(balances[address(this)] >= vaultAmount[to]);
261 
262         balances[to] = safeAdd(balances[to], vaultAmount[to]);
263         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[to]);
264         vaultAmount[to] = 0;
265         _removeFromVault(to);
266     }
267 
268     function _removeFromVault(address addr) internal {
269         uint index;
270         uint length = vaultList.length;
271         for (index = 0; index < length; index++){
272             if (vaultList[index] == addr) {
273               break;
274             }
275         }
276 
277         /// There is no use-case for inexistent
278         assert(index < length);
279         /// Remove out of list and map
280         if ( index + 1 != length ) {
281             /// Move the last to the current
282             vaultList[index] = vaultList[length - 1];
283         }
284         delete vaultList[length - 1];
285         vaultList.length--;
286         delete vaultReleaseTime[addr];
287         delete vaultAmount[addr];
288     }
289 
290     function getVaultAmountFrom(address from) public view onlyOwner returns (uint amount) {
291         return vaultAmount[from];
292     }
293 
294     function getVaultAmount() public view returns (uint amount) {
295         return vaultAmount[msg.sender];
296     }
297 
298     function getVaultReleaseTimeFrom(address from) public view onlyOwner returns (uint releaseTime) {
299         return vaultReleaseTime[from];
300     }
301 
302     function getVaultReleaseTime() public view returns (uint releaseTime) {
303         return vaultReleaseTime[msg.sender];
304     }
305 
306     function getVaultList() public view onlyOwner returns (address[] memory list) {
307         return vaultList;
308     }
309 }