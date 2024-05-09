1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // ‘GRT’ token contract
5 
6 // Symbol      : GRT
7 // Name        : Global Rental Token
8 // Total supply: 9.000.000.000
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
81 contract GlobalRentalToken is ERC20Interface, Owned {
82     using SafeMath for uint256;
83     string public symbol = "GRT";
84     string public  name = "Global Rental Token";
85     uint256 public decimals = 8;
86     uint256 _totalSupply = 9e9* 10 ** uint(decimals);
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
102         owner = address(0x736c327e2D2609f4C8f04F7EDc859efB47A09A34);
103         balances[address(this)] = totalSupply();
104         emit Transfer(address(0),address(this), totalSupply());
105 
106         _makeAllocations();
107     }
108 
109  function _makeAllocations() private{
110         //Team Wallet (Locted 2 years)
111         _transfer (0x80109a3F80E15f73D84eF3b93B645B52e5664d42, 2e9 * 10 ** uint(decimals));
112         walletsAllocation [0x80109a3F80E15f73D84eF3b93B645B52e5664d42] = walletDetail(2e9 * 10 ** uint(decimals), false);
113         //Development Wallet (Locted 1 year)
114         _transfer (0x2941DbaAD206381DE71433fef63Fe4245dfc8D6b, 3e9 * 10 ** uint(decimals));
115         walletsAllocation [0x2941DbaAD206381DE71433fef63Fe4245dfc8D6b] = walletDetail(3e9 * 10 ** uint(decimals), false);
116         //Airdrop&Marketing Wallet
117         _transfer (0x9df33769022349F3EBcA7bBc74ceB54D352aD488, 4e9 * 10 ** uint(decimals));
118         walletsAllocation [0x9df33769022349F3EBcA7bBc74ceB54D352aD488] = walletDetail(4e9 * 10 ** uint(decimals), false);
119     }
120     
121     /** ERC20Interface function's implementation **/
122     
123     function totalSupply() public view returns (uint256){
124        return _totalSupply; 
125     }
126     
127     // ------------------------------------------------------------------------
128     // Get the token balance for account `tokenOwner`
129     // ------------------------------------------------------------------------
130     function balanceOf(address tokenOwner) public view returns (uint256 balance) {
131         return balances[tokenOwner];
132     }
133 
134     // ------------------------------------------------------------------------
135     // Transfer the balance from token owner's account to `to` account
136     // - Owner's account must have sufficient balance to transfer
137     // - 0 value transfers are allowed
138     // ------------------------------------------------------------------------
139     function transfer(address to, uint256 tokens) public returns (bool success) {
140         // prevent transfer to 0x0, use burn instead
141         require(address(to) != address(0));
142         require(balances[msg.sender] >= tokens );
143         require(balances[to] + tokens >= balances[to]);
144 
145         balances[msg.sender] = balances[msg.sender].sub(tokens);
146         balances[to] = balances[to].add(tokens);
147         emit Transfer(msg.sender,to,tokens);
148         return true;
149     }
150     
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     // ------------------------------------------------------------------------
155     function approve(address spender, uint256 tokens) public returns (bool success){
156         allowed[msg.sender][spender] = tokens;
157         emit Approval(msg.sender,spender,tokens);
158         return true;
159     }
160 
161     // ------------------------------------------------------------------------
162     // Transfer `tokens` from the `from` account to the `to` account
163     // 
164     // The calling account must already have sufficient tokens approve(...)-d
165     // for spending from the `from` account and
166     // - From account must have sufficient balance to transfer
167     // - Spender must have sufficient allowance to transfer
168     // - 0 value transfers are allowed
169     // ------------------------------------------------------------------------
170     function transferFrom(address payable from, address to, uint256 tokens) public returns (bool success){
171         require(tokens <= allowed[from][msg.sender]); //check allowance
172         require(balances[from] >= tokens);
173 
174         balances[from] = balances[from].sub(tokens);
175         balances[to] = balances[to].add(tokens);
176         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
177         emit Transfer(from,to,tokens);
178         return true;
179     }
180     
181     // ------------------------------------------------------------------------
182     // Returns the amount of tokens approved by the owner that can be
183     // transferred to the spender's account
184     // ------------------------------------------------------------------------
185     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining) {
186         return allowed[tokenOwner][spender];
187     }
188     
189     function transferFromContract(address to, uint256 tokens) public onlyOwner returns (bool success){
190         _transfer(to,tokens);
191         return true;
192     }
193 
194     function _transfer(address to, uint256 tokens) internal {
195         // prevent transfer to 0x0, use burn instead
196         require(address(to) != address(0));
197         require(balances[address(this)] >= tokens );
198         require(balances[to] + tokens >= balances[to]);
199         
200         balances[address(this)] = balances[address(this)].sub(tokens);
201         balances[to] = balances[to].add(tokens);
202         emit Transfer(address(this),to,tokens);
203     }
204 
205     function openLock(address _address) public onlyOwner{
206         // open lock and transfer to respective address
207         require(walletsAllocation[_address].lock);
208         require(walletsAllocation[_address].tokens > 0);
209         require(balances[_address] == 0);
210 
211         _transfer(_address, walletsAllocation[_address].tokens);
212         walletsAllocation[_address].lock = false;
213     }
214     
215     // ------------------------------------------------------------------------
216     // Don't Accepts ETH
217     // ------------------------------------------------------------------------
218     function () external payable {
219         revert();
220     }
221 }