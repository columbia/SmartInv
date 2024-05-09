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
119 /// @title B2BX contract interface
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
130 /// @title B2BX contract - crowdfunding code for B2BX Project
131 contract SmartToken is ISmartToken, ERC20Token, Owned {
132     using SafeMath for uint256;
133  
134     // The current initial token supply.
135     uint256 public initialSupply = 50000000 ether;
136 
137     // Cold wallet for distribution of tokens.
138     address public fundingWallet;
139 
140     // The flag indicates if the B2BX contract is in Funding state.
141     bool public fundingEnabled = true;
142 
143     // The maximum tokens available for sale.
144     uint256 public maxSaleToken;
145 
146     // Total number of tokens sold.
147     uint256 public totalSoldTokens;
148     // Total number of tokens for B2BX Project.
149     uint256 public totalProjectToken;
150     uint256 private totalLockToken;
151 
152     // The flag indicates if the B2BX contract is in eneble / disable transfers.
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
171     /// @notice B2BX Project - Initializing crowdfunding.
172     /// @dev Constructor.
173     function SmartToken() ERC20Token("B2BX", "B2BX", 18) {
174         // The main, cold wallet for the distribution of tokens.
175         fundingWallet = msg.sender; 
176 
177         // Initializing 80% of tokens for sale.
178         // maxSaleToken = initialSupply * 80 / 100 (80% this is maxSaleToken & 100% this is initialSupply)
179         // totalProjectToken will be calculated in function finalize()
180         // 
181         // |------------maxSaleToken------totalProjectToken|
182         // |================80%================|====20%====|
183         // |-----------------initialSupply-----------------|
184         maxSaleToken = initialSupply.mul(80).div(100);
185 
186         balanceOf[fundingWallet] = maxSaleToken;
187         totalSupply = initialSupply;
188 
189         fundingWallets[fundingWallet] = true;
190         fundingWallets[0xEF02E1a87c91435349437f035F85F5a85f6b39ae] = true;
191         fundingWallets[0xb0e5E17B43dAEcE47ABe3e81938063432A8D683d] = true;
192         fundingWallets[0x67805701A5045092882cB4c7b066FF78Bb365938] = true;
193         fundingWallets[0x80CD4388E7C54758aB2B3f1c810630aa653Ac932] = true;
194         fundingWallets[0xfE51555Aea91768F0aA2fCb55705bd1C330Fb973] = true;
195     }
196 
197     // Validates an address - currently only checks that it isn't null.
198     modifier validAddress(address _address) {
199         require(_address != 0x0);
200         _;
201     }
202 
203     modifier transfersAllowed(address _address) {
204         if (fundingEnabled) {
205             require(fundingWallets[_address]);
206         }
207 
208         require(transfersEnabled);
209         _;
210     }
211 
212     /// @notice This function is disabled during the crowdfunding.
213     /// @dev Send tokens.
214     /// @param _to address      The address of the tokens recipient.
215     /// @param _value _value    The amount of token to be transferred.
216     function transfer(address _to, uint256 _value) public validAddress(_to) transfersAllowed(msg.sender) returns (bool) {
217         return super.transfer(_to, _value);
218     }
219 
220     /// @notice This function is disabled during the crowdfunding.
221     /// @dev Send from tokens.
222     /// @param _from address    The address of the sender of the token
223     /// @param _to address      The address of the tokens recipient.
224     /// @param _value _value    The amount of token to be transferred.
225     function transferFrom(address _from, address _to, uint256 _value) public validAddress(_to) transfersAllowed(_from) returns (bool) {
226         return super.transferFrom(_from, _to, _value);
227     }
228 
229     /// @notice This function can accept for blocking no more than "totalProjectToken".
230     /// @dev Lock tokens to a specified address.
231     /// @param _to address      The address to lock tokens to.
232     /// @param _value uint256   The amount of tokens to be locked.
233     /// @param _end uint256     The end of the lock period.
234     function lock(address _to, uint256 _value, uint256 _end) internal validAddress(_to) onlyOwner returns (bool) {
235         require(_value > 0);
236 
237         assert(totalProjectToken > 0);
238 
239         // Check that this lock doesn't exceed the total amount of tokens currently available for totalProjectToken.
240         totalLockToken = totalLockToken.add(_value);
241         assert(totalProjectToken >= totalLockToken);
242 
243         // Make sure that a single address can be locked tokens only once.
244         require(allocations[_to].value == 0);
245 
246         // Assign a new lock.
247         allocations[_to] = allocationLock({
248             value: _value,
249             end: _end,
250             locked: true
251         });
252 
253         Lock(this, _to, _value, _end);
254 
255         return true;
256     }
257 
258     /// @notice Only the owner of a locked wallet can unlock the tokens.
259     /// @dev Unlock tokens at the address to the caller function.
260     function unlock() external {
261         require(allocations[msg.sender].locked);
262         require(now >= allocations[msg.sender].end);
263         
264         balanceOf[msg.sender] = balanceOf[msg.sender].add(allocations[msg.sender].value);
265 
266         allocations[msg.sender].locked = false;
267 
268         Transfer(this, msg.sender, allocations[msg.sender].value);
269         Unlock(this, msg.sender, allocations[msg.sender].value);
270     }
271 
272     /// @notice B2BX Allocation - finalize crowdfunding & time-locked vault of tokens allocated
273     /// to B2BX company, developers and bounty program.
274     function finalize() external onlyOwner {
275         require(fundingEnabled);
276 
277         // Get total sold tokens on the fundingWallet.
278         // totalSoldTokens is 80% of the total number of tokens.
279         totalSoldTokens = maxSaleToken.sub(balanceOf[fundingWallet]);
280 
281         // totalProjectToken = totalSoldTokens * 20 / 80 (20% this is B2BX Project & 80% this is totalSoldTokens)
282         //
283         // |----------totalSoldTokens-----totalProjectToken|
284         // |================80%================|====20%====|
285         // |totalSupply=(totalSoldTokens+totalProjectToken)|
286         totalProjectToken = totalSoldTokens.mul(20).div(80);
287 
288         totalSupply = totalSoldTokens.add(totalProjectToken);
289 
290         // B2BX Prodject allocations tokens.
291         // 40% of the totalProjectToken tokens (== 10% totalSupply) go to B2BX Company.
292         lock(0x324044e0fB93A2D0274345Eba0E604B6F35826d2, totalProjectToken.mul(50).div(100), now);
293         // 40% of the totalProjectToken tokens (== 8% totalSupply) go to developers.
294         lock(0x6653f5e04ED6Ec6f004D345868f47f4CebAA095e, totalProjectToken.mul(40).div(100), (now + 6 * 30 days));
295         // 10% of the totalProjectToken tokens (== 2% totalSupply) go to bounty program.
296         lock(0x591e7CF52D6b3ccC452Cd435E3eA88c1032b0DE3, totalProjectToken.mul(10).div(100), now);
297         
298         // Zeroing a cold wallet.
299         balanceOf[fundingWallet] = 0;
300 
301         // End of crowdfunding.
302         fundingEnabled = false;
303 
304         // End of crowdfunding.
305         Transfer(this, fundingWallet, 0);
306         Finalize(msg.sender, totalSupply);
307     }
308 
309     /// @notice Disable all transfers in case of a vulnerability found in the contract or other systems.
310     /// @dev Disable transfers in B2BX contract.
311     function disableTransfers() external onlyOwner {
312         require(transfersEnabled);
313 
314         transfersEnabled = false;
315 
316         DisableTransfers(msg.sender);
317     }
318 
319     /// @dev Disable the hot wallets for transfers.
320     /// @param _address address Address in fundingWallets[]
321     function disableFundingWallets(address _address) external onlyOwner {
322         require(fundingEnabled);
323         require(fundingWallet != _address);
324         require(fundingWallets[_address]);
325 
326         fundingWallets[_address] = false;
327     }
328 }