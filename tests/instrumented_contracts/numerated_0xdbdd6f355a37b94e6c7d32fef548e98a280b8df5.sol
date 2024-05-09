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
73 contract UniWhales is ERC20Interface, Owned, SafeMath {
74     string public name = "UniWhales.io";
75     string public symbol = "UWL";
76     uint8 public decimals = 18;
77     uint public _totalSupply;
78     uint public startDate;
79     bool public isLocked;
80     bool public limitTradeByOwner;
81 
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
93     function UniWhales(address multisig, uint tokens) public {
94         _totalSupply = tokens;
95         balances[multisig] = safeAdd(balances[multisig], tokens);
96         isLocked = false;
97         limitTradeByOwner = false;
98     }
99 
100     modifier isNotLocked {
101         require(!isLocked);
102         _;
103     }
104 
105     function setIsLocked(bool _isLocked) public onlyOwner{
106         isLocked = _isLocked;
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113     function totalSupply() public view returns (uint) {
114         return _totalSupply  - balances[address(0)];
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public view returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public isNotLocked returns (bool success) {
132         if(limitTradeByOwner == false)
133         {
134         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
135         balances[to] = safeAdd(balances[to], tokens);
136         Transfer(msg.sender, to, tokens);
137         return true;
138         }
139         else if (limitTradeByOwner == true)
140         {
141         require(tokens <= 20000*1000000000000000000);
142         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
143         balances[to] = safeAdd(balances[to], tokens);
144         Transfer(msg.sender, to, tokens);
145         return true;
146         }
147     }
148 
149 
150     // ------------------------------------------------------------------------
151     // Token owner can approve for `spender` to transferFrom(...) `tokens`
152     // from the token owner's account
153     //
154     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
155     // recommends that there are no checks for the approval double-spend attack
156     // as this should be implemented in user interfaces
157     // ------------------------------------------------------------------------
158     function approve(address spender, uint tokens) public returns (bool success) {
159         allowed[msg.sender][spender] = tokens;
160         Approval(msg.sender, spender, tokens);
161         return true;
162     }
163 
164 
165     // ------------------------------------------------------------------------
166     // Transfer `tokens` from the `from` account to the `to` account
167     //
168     // The calling account must already have sufficient tokens approve(...)-d
169     // for spending from the `from` account and
170     // - From account must have sufficient balance to transfer
171     // - Spender must have sufficient allowance to transfer
172     // - 0 value transfers are allowed
173     // ------------------------------------------------------------------------
174     function transferFrom(address from, address to, uint tokens) public isNotLocked returns (bool success) {
175         if(limitTradeByOwner == false){
176         balances[from] = safeSub(balances[from], tokens);
177         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
178         balances[to] = safeAdd(balances[to], tokens);
179         Transfer(from, to, tokens);
180         return true;
181         }
182         else if(limitTradeByOwner == true)
183         {
184         require(tokens <= 20000*1000000000000000000);
185         balances[from] = safeSub(balances[from], tokens);
186         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
187         balances[to] = safeAdd(balances[to], tokens);
188         Transfer(from, to, tokens);
189         return true;
190         }
191     }
192 
193 
194     // ------------------------------------------------------------------------
195     // Returns the amount of tokens approved by the owner that can be
196     // transferred to the spender's account
197     // ------------------------------------------------------------------------
198     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
199         return allowed[tokenOwner][spender];
200     }
201 
202 
203     function () external payable {
204         revert();
205     }
206 
207     function tokenToVault(address to, uint amount, uint releastTime) public onlyOwner {
208         require(to != address(0x0));
209         vaultAmount[to] = safeAdd(vaultAmount[to], amount);
210         vaultReleaseTime[to] = releastTime;
211         _totalSupply = safeAdd(_totalSupply, amount);
212         balances[address(this)] = safeAdd(balances[address(this)], amount);
213         vaultList.push(to);
214     }
215 
216     function releaseToken() public {
217         require(vaultAmount[msg.sender] > 0);
218         require(block.timestamp >= vaultReleaseTime[msg.sender]);
219         require(balances[address(this)] >= vaultAmount[msg.sender]);
220 
221         balances[msg.sender] = safeAdd(balances[msg.sender], vaultAmount[msg.sender]);
222         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[msg.sender]);
223         vaultAmount[msg.sender] = 0;
224         _removeFromVault(msg.sender);
225     }
226 
227     function releateTokenTo(address to) public onlyOwner {
228         require(vaultAmount[to] > 0);
229         require(block.timestamp >= vaultReleaseTime[to]);
230         require(balances[address(this)] >= vaultAmount[to]);
231 
232         balances[to] = safeAdd(balances[to], vaultAmount[to]);
233         balances[address(this)] = safeSub(balances[address(this)], vaultAmount[to]);
234         vaultAmount[to] = 0;
235         _removeFromVault(to);
236     }
237     
238     function limitTrade()public onlyOwner{
239         limitTradeByOwner = true;
240     }
241     
242     function RemoveLimitTrade()public onlyOwner{
243         limitTradeByOwner = false;
244     }
245 
246     function _removeFromVault(address addr) internal {
247         uint index;
248         uint length = vaultList.length;
249         for (index = 0; index < length; index++){
250             if (vaultList[index] == addr) {
251               break;
252             }
253         }
254 
255         /// There is no use-case for inexistent
256         assert(index < length);
257         /// Remove out of list and map
258         if ( index + 1 != length ) {
259             /// Move the last to the current
260             vaultList[index] = vaultList[length - 1];
261         }
262         delete vaultList[length - 1];
263         vaultList.length--;
264         delete vaultReleaseTime[addr];
265         delete vaultAmount[addr];
266     }
267 
268     function getVaultAmountFrom(address from) public view returns (uint amount) {
269         return vaultAmount[from];
270     }
271 
272     function getVaultAmount() public view returns (uint amount) {
273         return vaultAmount[msg.sender];
274     }
275 
276     function getVaultReleaseTimeFrom(address from) public view onlyOwner returns (uint releaseTime) {
277         return vaultReleaseTime[from];
278     }
279 
280     function getVaultReleaseTime() public view returns (uint releaseTime) {
281         return vaultReleaseTime[msg.sender];
282     }
283 
284     function getVaultList() public view onlyOwner returns (address[] list) {
285         return vaultList;
286     }
287 }