1 pragma solidity 0.5.11;
2 
3 // ----------------------------------------------------------------------------
4 // 'MES' token contract
5 
6 // Symbol      : MES
7 // Name        : MesChain
8 // Total supply: 7.000.000.000
9 // Decimals    : 8
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256 c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public view returns (uint256);
42     function balanceOf(address tokenOwner) public view returns (uint256 balance);
43     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
44     function transfer(address to, uint256 tokens) public returns (bool success);
45     function approve(address spender, uint256 tokens) public returns (bool success);
46     function transferFrom(address payable from, address to, uint256 tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint256 tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Owned contract
55 // ----------------------------------------------------------------------------
56 contract Owned {
57     address public owner;
58     address public newOwner;
59 
60     event OwnershipTransferred(address indexed _from, address indexed _to);
61 
62     constructor() public {
63         owner = msg.sender;
64     }
65 
66     modifier onlyOwner {
67         require(msg.sender == owner);
68         _;
69     }
70 
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74 }
75 
76 
77 // ----------------------------------------------------------------------------
78 // ERC20 Token, with the addition of symbol, name and decimals and assisted
79 // token transfers
80 // ----------------------------------------------------------------------------
81 contract MesChain is ERC20Interface, Owned {
82     using SafeMath for uint256;
83     string public symbol = "MES";
84     string public  name = "MesChain";
85     uint256 public decimals = 8;
86     uint256 _totalSupply = 7e9* 10 ** uint(decimals);
87     
88     mapping(address => uint256) balances;
89     mapping(address => mapping(address => uint256)) allowed;
90     
91     mapping(address => walletDetail) walletsAllocation;
92 
93     struct walletDetail{
94         uint256 tokens;
95         bool lock;
96     }
97 
98     // ------------------------------------------------------------------------
99     // Constructor
100     // ------------------------------------------------------------------------
101     constructor() public {
102         owner = address(0x51a8d35f1eF9835950D0EA0e1151203BfD537d26);
103         balances[address(this)] = totalSupply();
104         emit Transfer(address(0),address(this), totalSupply());
105 
106         _makeAllocations();
107     }
108 
109     function _makeAllocations() private{
110         // ICO Wallet 
111         _transfer(0xe7DfFc4B83e4F70A28eC4eFB36c4e2703Abcf6d0, 1e9 * 10 ** uint(decimals));
112         walletsAllocation[0xe7DfFc4B83e4F70A28eC4eFB36c4e2703Abcf6d0] = walletDetail(1e9 * 10 ** uint(decimals), false);
113         //IEO Wallet
114         _transfer(0x932A34B04712F8B2eEC3818754413262d19d2deA, 1e9 * 10 ** uint(decimals));
115         walletsAllocation[0x932A34B04712F8B2eEC3818754413262d19d2deA] = walletDetail(1e9 * 10 ** uint(decimals), false);
116         //Team Wallet
117         walletsAllocation[0x9f83a70b2F40c5fC3068bb4d6F72B36aCEb7EAFE] = walletDetail(1e9 * 10 ** uint(decimals), true);
118         //Project Development Wallet
119         walletsAllocation[0x9E79CA12AA7EfBF7DA72fE4177e00f6154Ce1849] = walletDetail(1e9 * 10 ** uint(decimals), true);
120         //Stock Market and Promotion Wallet
121         walletsAllocation[0x7498fFa99dD8eEe28946985757dAac366BC1A0A2] = walletDetail(13e8 * 10 ** uint(decimals), true);
122         //Agents Wallet
123         walletsAllocation[0x7a2A0Be3352ca8D9d0EbB3Bdc1e73bBB504e195A] = walletDetail(5e8 * 10 ** uint(decimals), true);
124         //Marketing Wallet
125         _transfer(0xE60B984Aa73f92D0c687Cff7Ed4869ca871Af04E, 5e8 * 10 ** uint(decimals));
126         walletsAllocation[0xE60B984Aa73f92D0c687Cff7Ed4869ca871Af04E] = walletDetail(5e8 * 10 ** uint(decimals), false);
127         //Award Distribution Wallet
128         _transfer(0x569D39944c179F5c82914a0BAd2c684A8090f063, 35e7 * 10 ** uint(decimals));
129         walletsAllocation[0x569D39944c179F5c82914a0BAd2c684A8090f063] = walletDetail(35e7 * 10 ** uint(decimals), false);
130         //Stake Wallet
131         _transfer(0x23dC2A8EaEba7711A613E0F06a409dBC30eCAdb5, 35e7 * 10 ** uint(decimals));
132         walletsAllocation[0x23dC2A8EaEba7711A613E0F06a409dBC30eCAdb5] = walletDetail(35e7 * 10 ** uint(decimals), false);
133     }
134     
135     /** ERC20Interface function's implementation **/
136     
137     function totalSupply() public view returns (uint256){
138        return _totalSupply; 
139     }
140     
141     // ------------------------------------------------------------------------
142     // Get the token balance for account `tokenOwner`
143     // ------------------------------------------------------------------------
144     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
145         return balances[tokenOwner];
146     }
147 
148     // ------------------------------------------------------------------------
149     // Transfer the balance from token owner's account to `to` account
150     // - Owner's account must have sufficient balance to transfer
151     // - 0 value transfers are allowed
152     // ------------------------------------------------------------------------
153     function transfer(address to, uint256 tokens) public returns (bool success) {
154         // prevent transfer to 0x0, use burn instead
155         require(address(to) != address(0));
156         require(balances[msg.sender] >= tokens );
157         require(balances[to] + tokens >= balances[to]);
158 
159         balances[msg.sender] = balances[msg.sender].sub(tokens);
160         balances[to] = balances[to].add(tokens);
161         emit Transfer(msg.sender,to,tokens);
162         return true;
163     }
164     
165     // ------------------------------------------------------------------------
166     // Token owner can approve for `spender` to transferFrom(...) `tokens`
167     // from the token owner's account
168     // ------------------------------------------------------------------------
169     function approve(address spender, uint256 tokens) public returns (bool success){
170         allowed[msg.sender][spender] = tokens;
171         emit Approval(msg.sender,spender,tokens);
172         return true;
173     }
174 
175     // ------------------------------------------------------------------------
176     // Transfer `tokens` from the `from` account to the `to` account
177     // 
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the `from` account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address payable from, address to, uint256 tokens) public returns (bool success){
185         require(tokens <= allowed[from][msg.sender]); //check allowance
186         require(balances[from] >= tokens);
187 
188         balances[from] = balances[from].sub(tokens);
189         balances[to] = balances[to].add(tokens);
190         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
191         emit Transfer(from,to,tokens);
192         return true;
193     }
194     
195     // ------------------------------------------------------------------------
196     // Returns the amount of tokens approved by the owner that can be
197     // transferred to the spender's account
198     // ------------------------------------------------------------------------
199     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
200         return allowed[tokenOwner][spender];
201     }
202     
203     function transferFromContract(address to, uint256 tokens) public onlyOwner returns (bool success){
204         _transfer(to,tokens);
205         return true;
206     }
207 
208     function _transfer(address to, uint256 tokens) internal {
209         // prevent transfer to 0x0, use burn instead
210         require(address(to) != address(0));
211         require(balances[address(this)] >= tokens );
212         require(balances[to] + tokens >= balances[to]);
213         
214         balances[address(this)] = balances[address(this)].sub(tokens);
215         balances[to] = balances[to].add(tokens);
216         emit Transfer(address(this),to,tokens);
217     }
218 
219     function openLock(address _address) public onlyOwner{
220         // open lock and transfer to respective address
221         require(walletsAllocation[_address].lock);
222         require(walletsAllocation[_address].tokens > 0);
223         require(balances[_address] == 0);
224 
225         _transfer(_address, walletsAllocation[_address].tokens);
226         walletsAllocation[_address].lock = false;
227     }
228     
229     // ------------------------------------------------------------------------
230     // Don't Accepts ETH
231     // ------------------------------------------------------------------------
232     function () external payable {
233         revert();
234     }
235 }