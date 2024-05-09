1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : INCH0
5 // Name        : InchWorm 300 POC
6 // Total supply: 1000
7 // Decimals    : 18
8 // ----------------------------------------------------------------------------
9 
10 
11 // ----------------------------------------------------------------------------
12 // Safe math
13 // ----------------------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public view returns (uint);
40     function balanceOf(address tokenOwner) public view returns (uint balance);
41     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Contract function to receive approval and execute function in one call
53 //
54 // Borrowed from MiniMeToken
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     constructor() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78 
79     function transferOwnership(address _newOwner) public onlyOwner {
80         newOwner = _newOwner;
81     }
82     function acceptOwnership() public {
83         require(msg.sender == newOwner);
84         emit OwnershipTransferred(owner, newOwner);
85         owner = newOwner;
86         newOwner = address(0);
87     }
88 }
89 
90 
91 // ----------------------------------------------------------------------------
92 /// @notice This contract is a proof of concept only. I appreciate anyone who wants to test it, but the transfer of 
93 ///         is real. I am not responsible for lost funds, so please use only small test amounts with this contract
94 /// @dev    The INCH0 token itself is a completely boilerplate ERC20 implementation. All functionality comes from the
95 ///         vaultPOC concract
96 //
97 // InchWorm 300 allows peer to peer betting on the price of Ethereum at 350 Dai. INCH tokens can be traded in 
98 // at a constant ratio of ETH/Dai. Buying INCH with Dai is equivalent of shorting, as tokens can always be 
99 // traded in for ETH at the same ratio. Unlike Dai, INCH is deflationary, and will always yield the same or 
100 // more than the original value in the target token. 
101 // ----------------------------------------------------------------------------
102 contract InchWormPOC is ERC20Interface, Owned {
103     using SafeMath for uint;
104 
105     string public symbol;
106     string public  name;
107     uint8 public decimals;
108     uint _totalSupply;
109 
110     mapping(address => uint) balances;
111     mapping(address => mapping(address => uint)) allowed;
112 
113 
114     // ------------------------------------------------------------------------
115     // Constructor
116     // ------------------------------------------------------------------------
117     constructor() public {
118         symbol = "INCH0";
119         name = "InchWorm 300 POC";
120         decimals = 18;
121         _totalSupply = 1000 * 10**uint(decimals);
122         balances[owner] = _totalSupply;
123         emit Transfer(address(0), owner, _totalSupply);
124     }
125 
126     
127     // ------------------------------------------------------------------------
128     // returns total supply, not counting what has been sent to the burn address, 0x0
129     // ------------------------------------------------------------------------
130     function totalSupply() public view returns(uint) {
131         return _totalSupply.sub(balances[address(0)]);
132     }
133 
134 
135     // ------------------------------------------------------------------------
136     // Get the token balance for account `tokenOwner`
137     // ------------------------------------------------------------------------
138     function balanceOf(address tokenOwner) public view returns(uint balance) {
139         return balances[tokenOwner];
140     }
141 
142 
143     // ------------------------------------------------------------------------
144     // Transfer the balance from token owner's account to `to` account
145     // - Owner's account must have sufficient balance to transfer
146     // - 0 value transfers are allowed
147     // ------------------------------------------------------------------------
148     function transfer(address to, uint tokens) public returns(bool success) {
149         balances[msg.sender] = balances[msg.sender].sub(tokens);
150         balances[to] = balances[to].add(tokens);
151         emit Transfer(msg.sender, to, tokens);
152         return true;
153     }
154 
155 
156     // ------------------------------------------------------------------------
157     // Token owner can approve for `spender` to transferFrom(...) `tokens`
158     // from the token owner's account
159     //
160     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
161     // recommends that there are no checks for the approval double-spend attack
162     // as this should be implemented in user interfaces
163     /// @notice This function has been modified to only allow tho approval of 100 INCH tokens. This is to encourage 
164     ///         the use of small amounts when testing the contract
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns(bool success) {
167         require(tokens <= 100000000000000000000);
168         allowed[msg.sender][spender] = tokens;
169         emit Approval(msg.sender, spender, tokens);
170         return true;
171     }
172 
173 
174     // ------------------------------------------------------------------------
175     // Transfer `tokens` from the `from` account to the `to` account
176     //
177     // The calling account must already have sufficient tokens approve(...)-d
178     // for spending from the `from` account and
179     // - From account must have sufficient balance to transfer
180     // - Spender must have sufficient allowance to transfer
181     // - 0 value transfers are allowed
182     // ------------------------------------------------------------------------
183     function transferFrom(address from, address to, uint tokens) public returns(bool success) {
184         balances[from] = balances[from].sub(tokens);
185         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
186         balances[to] = balances[to].add(tokens);
187         emit Transfer(from, to, tokens);
188         return true;
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Returns the amount of tokens approved by the owner that can be
194     // transferred to the spender's account
195     // ------------------------------------------------------------------------
196     function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
197         return allowed[tokenOwner][spender];
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Token owner can approve for `spender` to transferFrom(...) `tokens`
203     // from the token owner's account. The `spender` contract function
204     // `receiveApproval(...)` is then executed
205     // ------------------------------------------------------------------------
206     function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
207         allowed[msg.sender][spender] = tokens;
208         emit Approval(msg.sender, spender, tokens);
209         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
210         return true;
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Don't accept ETH
216     // ------------------------------------------------------------------------
217     function () external payable {
218         revert();
219     }
220 
221 
222     // ------------------------------------------------------------------------
223     // Owner can transfer out any accidentally sent ERC20 tokens
224     // ------------------------------------------------------------------------
225     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
226         return ERC20Interface(tokenAddress).transfer(owner, tokens);
227     }
228 }