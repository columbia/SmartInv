1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Symbol      : INCH.1
5 // Name        : InchWorm Version 0.1
6 // Total supply: 100000000000 (100 billion)
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
92 /// @notice This contract is a test version only. I appreciate anyone who wants to test it, but the transfer of 
93 ///         is real. I am not responsible for lost funds, so please use only small test amounts with this contract
94 /// @dev    The INCH.1 token itself is a completely boilerplate ERC20 implementation. All functionality comes from the
95 ///         vaultPOC concract
96 // ----------------------------------------------------------------------------
97 contract InchWormToken is ERC20Interface, Owned {
98     using SafeMath for uint;
99 
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint _totalSupply;
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     // ------------------------------------------------------------------------
110     // Constructor
111     // ------------------------------------------------------------------------
112     constructor() public {
113         symbol = "INCH.1";
114         name = "InchWorm Version 0.1";
115         decimals = 18;
116         _totalSupply = 100000000000 * 10**uint(decimals);
117         balances[owner] = _totalSupply;
118         emit Transfer(address(0), owner, _totalSupply);
119     }
120 
121     
122     // ------------------------------------------------------------------------
123     // returns total supply, not counting what has been sent to the burn address, 0x0
124     // ------------------------------------------------------------------------
125     function totalSupply() public view returns(uint) {
126         return _totalSupply.sub(balances[address(0)]);
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Get the token balance for account `tokenOwner`
132     // ------------------------------------------------------------------------
133     function balanceOf(address tokenOwner) public view returns(uint balance) {
134         return balances[tokenOwner];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Transfer the balance from token owner's account to `to` account
140     // - Owner's account must have sufficient balance to transfer
141     // - 0 value transfers are allowed
142     // ------------------------------------------------------------------------
143     function transfer(address to, uint tokens) public returns(bool success) {
144         balances[msg.sender] = balances[msg.sender].sub(tokens);
145         balances[to] = balances[to].add(tokens);
146         emit Transfer(msg.sender, to, tokens);
147         return true;
148     }
149 
150 
151     // ------------------------------------------------------------------------
152     // Token owner can approve for `spender` to transferFrom(...) `tokens`
153     // from the token owner's account
154     //
155     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
156     // recommends that there are no checks for the approval double-spend attack
157     // as this should be implemented in user interfaces
158     // ------------------------------------------------------------------------
159     function approve(address spender, uint tokens) public returns(bool success) {
160         allowed[msg.sender][spender] = tokens;
161         emit Approval(msg.sender, spender, tokens);
162         return true;
163     }
164 
165 
166     // ------------------------------------------------------------------------
167     // Transfer `tokens` from the `from` account to the `to` account
168     //
169     // The calling account must already have sufficient tokens approve(...)-d
170     // for spending from the `from` account and
171     // - From account must have sufficient balance to transfer
172     // - Spender must have sufficient allowance to transfer
173     // - 0 value transfers are allowed
174     // ------------------------------------------------------------------------
175     function transferFrom(address from, address to, uint tokens) public returns(bool success) {
176         balances[from] = balances[from].sub(tokens);
177         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
178         balances[to] = balances[to].add(tokens);
179         emit Transfer(from, to, tokens);
180         return true;
181     }
182 
183 
184     // ------------------------------------------------------------------------
185     // Returns the amount of tokens approved by the owner that can be
186     // transferred to the spender's account
187     // ------------------------------------------------------------------------
188     function allowance(address tokenOwner, address spender) public view returns(uint remaining) {
189         return allowed[tokenOwner][spender];
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Token owner can approve for `spender` to transferFrom(...) `tokens`
195     // from the token owner's account. The `spender` contract function
196     // `receiveApproval(...)` is then executed
197     // ------------------------------------------------------------------------
198     function approveAndCall(address spender, uint tokens, bytes memory data) public returns(bool success) {
199         allowed[msg.sender][spender] = tokens;
200         emit Approval(msg.sender, spender, tokens);
201         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
202         return true;
203     }
204 
205 
206     // ------------------------------------------------------------------------
207     // Don't accept ETH
208     // ------------------------------------------------------------------------
209     function () external payable {
210         revert();
211     }
212 
213 
214     // ------------------------------------------------------------------------
215     // Owner can transfer out any accidentally sent ERC20 tokens
216     // ------------------------------------------------------------------------
217     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns(bool success) {
218         return ERC20Interface(tokenAddress).transfer(owner, tokens);
219     }
220 }