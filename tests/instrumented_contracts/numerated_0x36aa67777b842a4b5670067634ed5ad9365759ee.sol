1 pragma solidity ^0.5.0;
2 
3 
4 
5 // ----------------------------------------------------------------------------
6 // Safe maths
7 // ----------------------------------------------------------------------------
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 
28 // ----------------------------------------------------------------------------
29 // ERC Token Standard #20 Interface
30 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
31 // ----------------------------------------------------------------------------
32 contract ERC20Interface {
33     function totalSupply() public view returns (uint);
34     function balanceOf(address tokenOwner) public view returns (uint balance);
35     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // Contract function to receive approval and execute function in one call
47 //
48 // Borrowed from MiniMeToken
49 // ----------------------------------------------------------------------------
50 contract ApproveAndCallFallBack {
51     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Owned contract
57 // ----------------------------------------------------------------------------
58 contract Owned {
59     address public owner;
60     address public newOwner;
61 
62     event OwnershipTransferred(address indexed _from, address indexed _to);
63 
64     constructor() public {
65         owner = msg.sender;
66     }
67 
68     modifier onlyOwner {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     function transferOwnership(address _newOwner) public onlyOwner {
74         newOwner = _newOwner;
75     }
76     function acceptOwnership() public {
77         require(msg.sender == newOwner);
78         emit OwnershipTransferred(owner, newOwner);
79         owner = newOwner;
80         newOwner = address(0);
81     }
82 }
83 
84 
85 // ----------------------------------------------------------------------------
86 // ERC20 Token, with the addition of symbol, name and decimals and a
87 // fixed supply
88 // ----------------------------------------------------------------------------
89 contract FixedSupplyToken is ERC20Interface, Owned {
90     using SafeMath for uint;
91 
92     string public symbol;
93     string public  name;
94     uint8 public decimals;
95     uint _totalSupply;
96 
97     mapping(address => uint) balances;
98     mapping(address => mapping(address => uint)) allowed;
99 
100 
101     // ------------------------------------------------------------------------
102     // Constructor
103     // ------------------------------------------------------------------------
104     constructor() public {
105         symbol = "ICCOIN";
106         name = "iCoach Coin";
107         decimals = 18;
108         _totalSupply = 100000000 * 10**uint(decimals);
109         
110         balances[owner] = _totalSupply;
111         
112         emit Transfer(address(0), owner, _totalSupply);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply.sub(balances[address(0)]);
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Get the token balance for account `tokenOwner`
126     // ------------------------------------------------------------------------
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130 
131 
132     // ------------------------------------------------------------------------
133     // Transfer the balance from token owner's account to `to` account
134     // - Owner's account must have sufficient balance to transfer
135     // - 0 value transfers are allowed
136     // ------------------------------------------------------------------------
137     function transfer(address to, uint tokens) public returns (bool success) {
138         balances[msg.sender] = balances[msg.sender].sub(tokens);
139         balances[to] = balances[to].add(tokens);
140         emit Transfer(msg.sender, to, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Token owner can approve for `spender` to transferFrom(...) `tokens`
147     // from the token owner's account
148     //
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
150     // recommends that there are no checks for the approval double-spend attack
151     // as this should be implemented in user interfaces
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Transfer `tokens` from the `from` account to the `to` account
162     //
163     // The calling account must already have sufficient tokens approve(...)-d
164     // for spending from the `from` account and
165     // - From account must have sufficient balance to transfer
166     // - Spender must have sufficient allowance to transfer
167     // - 0 value transfers are allowed
168     // ------------------------------------------------------------------------
169     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170         balances[from] = balances[from].sub(tokens);
171         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
172         balances[to] = balances[to].add(tokens);
173         emit Transfer(from, to, tokens);
174         return true;
175     }
176 
177 
178     // ------------------------------------------------------------------------
179     // Returns the amount of tokens approved by the owner that can be
180     // transferred to the spender's account
181     // ------------------------------------------------------------------------
182     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
183         return allowed[tokenOwner][spender];
184     }
185 
186 
187     // ------------------------------------------------------------------------
188     // Token owner can approve for `spender` to transferFrom(...) `tokens`
189     // from the token owner's account. The `spender` contract function
190     // `receiveApproval(...)` is then executed
191     // ------------------------------------------------------------------------
192     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         emit Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
196         return true;
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Don't accept ETH
202     // ------------------------------------------------------------------------
203     function () external payable {
204         revert();
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }