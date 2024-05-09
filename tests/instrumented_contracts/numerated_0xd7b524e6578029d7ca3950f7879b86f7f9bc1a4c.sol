1 pragma solidity ^0.4.16;
2 
3 /// @title SafeMath
4 /// @dev Math operations with safety checks that throw on error
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
7         uint256 c = a * b;
8         assert(a == 0 || c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal constant returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal constant returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 /// @title ERC20 Standard Token interface
30 contract IERC20Token {
31     function name() public constant returns (string) { name; }
32     function symbol() public constant returns (string) { symbol; }
33     function decimals() public constant returns (uint8) { decimals; }
34     function totalSupply() public constant returns (uint256) { totalSupply; }
35     function balanceOf(address _owner) public constant returns (uint256 balance) { _owner; balance; }
36     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) { _owner; _spender; remaining; }
37 
38     function transfer(address _to, uint256 _value) public returns (bool);
39     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
40     function approve(address _spender, uint256 _value) public returns (bool);
41 }
42 
43 /// @title ERC20 Standard Token implementation
44 contract ERC20Token is IERC20Token {
45     using SafeMath for uint256;
46 
47     string public standard = 'Token 0.1';
48     string public name = '';
49     string public symbol = '';
50     uint8 public decimals = 0;
51     uint256 public totalSupply = 0;
52     mapping (address => uint256) public balanceOf;
53     mapping (address => mapping (address => uint256)) public allowance;
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 
58     function ERC20Token(string _name, string _symbol, uint8 _decimals) {
59         require(bytes(_name).length > 0 && bytes(_symbol).length > 0);
60         name = _name;
61         symbol = _symbol;
62         decimals = _decimals;
63     }
64 
65     modifier validAddress(address _address) {
66         require(_address != 0x0);
67         _;
68     }
69 
70     function transfer(address _to, uint256 _value) public validAddress(_to) returns (bool) {
71         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
72         balanceOf[_to] = balanceOf[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         
75         return true;
76     }
77 
78     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) returns (bool) {
79         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
80         balanceOf[_from] = balanceOf[_from].sub(_value);
81         balanceOf[_to] = balanceOf[_to].add(_value);
82         Transfer(_from, _to, _value);
83         return true;
84     }
85 
86     function approve(address _spender, uint256 _value) public validAddress(_spender) returns (bool) {
87         require(_value == 0 || allowance[msg.sender][_spender] == 0);
88         allowance[msg.sender][_spender] = _value;
89         Approval(msg.sender, _spender, _value);
90         return true;
91     }
92 }
93 
94 contract IOwned {
95     function owner() public constant returns (address) { owner; }
96     function transferOwnership(address _newOwner) public;
97 }
98 
99 contract Owned is IOwned {
100     address public owner;
101     function Owned() {
102         owner = msg.sender;
103     }
104     modifier validAddress(address _address) {
105         require(_address != 0x0);
106         _;
107     }
108     modifier onlyOwner {
109         assert(msg.sender == owner);
110         _;
111     }
112     function transferOwnership(address _newOwner) validAddress(_newOwner) onlyOwner {
113         require(_newOwner != owner);
114         
115         owner = _newOwner;
116     }
117 }
118 
119 /// @title BXN contract interface
120 contract ISmartToken {
121     function initialSupply() public constant returns (uint256) { initialSupply; }
122 
123     function totalSoldTokens() public constant returns (uint256) { totalSoldTokens; }
124     function totalProjectToken() public constant returns (uint256) { totalProjectToken; }
125 
126     function fundingEnabled() public constant returns (bool) { fundingEnabled; }
127     function transfersEnabled() public constant returns (bool) { transfersEnabled; }
128 }
129 
130 /// @title BXN contract - crowdfunding code for BXN Project
131 contract SmartToken is ISmartToken, ERC20Token, Owned {
132     using SafeMath for uint256;
133  
134     // The current initial token supply.
135     uint256 public initialSupply = 80000000 ether;
136 
137     // Cold wallet for distribution of tokens.
138     address public fundingWallet;
139 
140     // The flag indicates if the BXN contract is in Funding state.
141     bool public fundingEnabled = true;
142 
143     // The maximum tokens available for sale.
144     uint256 public maxSaleToken;
145 
146     // Total number of tokens sold.
147     uint256 public totalSoldTokens;
148     // Total number of tokens for BXN Project.
149     uint256 public totalProjectToken;
150     uint256 private totalLockToken;
151 
152     // The flag indicates if the BXN contract is in eneble / disable transfers.
153     bool public transfersEnabled = true; 
154 
155     // Wallets, which allowed the transaction during the crowdfunding.
156     mapping (address => bool) private fundingWallets;
157     // Wallets B2BX Project, which will be locked the tokens
158     mapping (address => allocationLock) public allocations;
159 
160     struct allocationLock {
161         uint256 value;
162         uint256 end;
163         bool locked;
164     }
165 
166     event Finalize(address indexed _from, uint256 _value);
167     event Lock(address indexed _from, address indexed _to, uint256 _value, uint256 _end);
168     event Unlock(address indexed _from, address indexed _to, uint256 _value);
169     event DisableTransfers(address indexed _from);
170 
171     /// @notice BXN Project - Initializing crowdfunding.
172     /// @dev Constructor.
173     function SmartToken() ERC20Token("BITTXN", "BXN", 18) {
174         // The main, cold wallet for the distribution of tokens.
175         fundingWallet = msg.sender; 
176 
177         maxSaleToken = initialSupply.mul(100).div(100);
178 
179         balanceOf[fundingWallet] = maxSaleToken;
180         totalSupply = initialSupply;
181 
182         fundingWallets[fundingWallet] = true;
183         fundingWallets[0x39ee193486cC7A1A24bBaF84a301e8DD1265c11D] = true;
184         fundingWallets[0xBc5814406436173aCc1BD17398110b4F405C124A] = true;
185         fundingWallets[0xFc3aCeB2e8Bf624F0A924a6106fBC9e5FfBccD45] = true;
186         fundingWallets[0x6da56D0c21F7B2D32a1b411E806A6b4Ce4b51034] = true;
187         fundingWallets[0xc55c8D13CD5DA748c30918f899447983B53d896b] = true;
188     }
189 
190     // Validates an address - currently only checks that it isn't null.
191     modifier validAddress(address _address) {
192         require(_address != 0x0);
193         _;
194     }
195 
196     modifier transfersAllowed(address _address) {
197         if (fundingEnabled) {
198             require(fundingWallets[_address]);
199         }
200 
201         require(transfersEnabled);
202         _;
203     }
204 
205     /// @notice This function is disabled during the crowdfunding.
206     /// @dev Send tokens.
207     /// @param _to address      The address of the tokens recipient.
208     /// @param _value _value    The amount of token to be transferred.
209     function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
210         return super.transfer(_to, _value);
211     }
212 
213     /// @notice This function is disabled during the crowdfunding.
214     /// @dev Send from tokens.
215     /// @param _from address    The address of the sender of the token
216     /// @param _to address      The address of the tokens recipient.
217     /// @param _value _value    The amount of token to be transferred.
218     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
219         return super.transferFrom(_from, _to, _value);
220     }
221 
222     /// @notice This function can accept for blocking no more than "totalProjectToken".
223     /// @dev Lock tokens to a specified address.
224     /// @param _to address      The address to lock tokens to.
225     /// @param _value uint256   The amount of tokens to be locked.
226     /// @param _end uint256     The end of the lock period.
227     function lock(address _to, uint256 _value, uint256 _end) internal validAddress(_to) onlyOwner returns (bool) {
228         require(_value > 0);
229 
230         assert(totalProjectToken > 0);
231 
232         // Check that this lock doesn't exceed the total amount of tokens currently available for totalProjectToken.
233         totalLockToken = totalLockToken.add(_value);
234         assert(totalProjectToken >= totalLockToken);
235 
236         // Make sure that a single address can be locked tokens only once.
237         require(allocations[_to].value == 0);
238 
239         // Assign a new lock.
240         allocations[_to] = allocationLock({
241             value: _value,
242             end: _end,
243             locked: true
244         });
245 
246         Lock(this, _to, _value, _end);
247 
248         return true;
249     }
250 
251     /// @notice Only the owner of a locked wallet can unlock the tokens.
252     /// @dev Unlock tokens at the address to the caller function.
253     function unlock() external {
254         require(allocations[msg.sender].locked);
255         require(now >= allocations[msg.sender].end);
256         
257         balanceOf[msg.sender] = balanceOf[msg.sender].add(allocations[msg.sender].value);
258 
259         allocations[msg.sender].locked = false;
260 
261         Transfer(this, msg.sender, allocations[msg.sender].value);
262         Unlock(this, msg.sender, allocations[msg.sender].value);
263     }
264 
265     /// @notice BXN Allocation - finalize crowdfunding & time-locked vault of tokens allocated
266     /// to BXN company, developers and Airdrop program.
267     function finalize() external onlyOwner {
268         require(fundingEnabled);
269 
270         // Get total sold tokens on the fundingWallet.
271         // totalSoldTokens is 80% of the total number of tokens.
272         totalSoldTokens = maxSaleToken.sub(balanceOf[fundingWallet]);
273 
274         // totalProjectToken = totalSoldTokens * 50 / 50 (50% this is BXN Project & 50% this is totalSoldTokens)
275         //
276         // |----------totalSoldTokens-----totalProjectToken|
277         // |================50%====|================50%====|
278         // |totalSupply=(totalSoldTokens+totalProjectToken)|
279         totalProjectToken = totalSoldTokens.mul(50).div(50);
280 
281         // BXN Prodject allocations tokens.
282         // 90% of the totalProjectToken tokens (== 45% totalSupply) go to BXN Company.
283         lock(0xf03eb5eD89Da5ccAC43498A2C56434e30505AB09, totalProjectToken.mul(90).div(100), now);
284         // 10% of the totalProjectToken tokens (== 5% totalSupply) go to Airdrop program.
285         lock(0xCAF7149Ef61E54F72ACdC7f44a05E5d7D1Db134B, totalProjectToken.mul(10).div(100), now);
286         
287         // Zeroing a cold wallet.
288         balanceOf[fundingWallet] = 0;
289 
290         // End of crowdfunding.
291         fundingEnabled = false;
292 
293         // End of crowdfunding.
294         Transfer(this, fundingWallet, 0);
295         Finalize(msg.sender, totalSupply);
296     }
297     /// @notice Disable all transfers in case of a vulnerability found in the contract or other systems.
298     /// @dev Disable transfers in BXN contract.
299     function disableTransfers() external onlyOwner {
300         require(transfersEnabled);
301 
302         transfersEnabled = false;
303 
304         DisableTransfers(msg.sender);
305     }
306 
307     function enableTransfers() external onlyOwner {
308         require(!transfersEnabled);
309 
310         transfersEnabled = !false;
311 
312         DisableTransfers(msg.sender);
313     }
314     /// @dev Disable the hot wallets for transfers.
315     /// @param _address address Address in fundingWallets[]
316     function disableFundingWallets(address _address) external onlyOwner {
317         require(fundingEnabled);
318         require(fundingWallet != _address);
319         require(fundingWallets[_address]);
320 
321         fundingWallets[_address] = false;
322     }
323 
324 }