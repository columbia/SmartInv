1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'AIO Token' TokenSale token contract
5 //
6 // Deployed to : 0xd0823c151d23678c6efe2b73b70aedf25be469fa
7 // Symbol      : AIO
8 // Name        : AIO Token
9 // Total supply: 870,000.000000000000000000
10 // Decimals    : 18
11 //
12 // ----------------------------------------------------------------------------
13 
14 
15 // ----------------------------------------------------------------------------
16 // Safe maths
17 // ----------------------------------------------------------------------------
18 contract SafeMath {
19     function safeAdd(uint a, uint b) internal pure returns (uint c) {
20         c = a + b;
21         require(c >= a);
22     }
23     function safeSub(uint a, uint b) internal pure returns (uint c) {
24         require(b <= a);
25         c = a - b;
26     }
27     function safeMul(uint a, uint b) internal pure returns (uint c) {
28         c = a * b;
29         require(a == 0 || c / a == b);
30     }
31     function safeDiv(uint a, uint b) internal pure returns (uint c) {
32         require(b > 0);
33         c = a / b;
34     }
35 }
36 
37 
38 // ----------------------------------------------------------------------------
39 // ERC Token Standard #20 Interface
40 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
41 // ----------------------------------------------------------------------------
42 contract ERC20Interface {
43     function totalSupply() public constant returns (uint);
44     function balanceOf(address tokenOwner) public constant returns (uint balance);
45     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
46     function transfer(address to, uint tokens) public returns (bool success);
47     function approve(address spender, uint tokens) public returns (bool success);
48     function transferFrom(address from, address to, uint tokens) public returns (bool success);
49 
50     event Transfer(address indexed from, address indexed to, uint tokens);
51     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
52 }
53 
54 
55 // ----------------------------------------------------------------------------
56 // Contract function to receive approval and execute function in one call
57 //
58 // Borrowed from MiniMeToken
59 // ----------------------------------------------------------------------------
60 contract ApproveAndCallFallBack {
61     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
62 }
63 
64 
65 // ----------------------------------------------------------------------------
66 // Owned contract
67 // ----------------------------------------------------------------------------
68 contract Owned {
69     address public owner;
70     address public newOwner;
71 
72     event OwnershipTransferred(address indexed _from, address indexed _to);
73 
74     function Owned() public {
75         owner = msg.sender;
76     }
77 
78     modifier onlyOwner {
79         require(msg.sender == owner);
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public onlyOwner {
84         newOwner = _newOwner;
85     }
86     function acceptOwnership() public {
87         require(msg.sender == newOwner);
88         emit OwnershipTransferred(owner, newOwner);
89         owner = newOwner;
90         newOwner = address(0);
91     }
92 }
93 
94 
95 // ----------------------------------------------------------------------------
96 // ERC20 Token, with the addition of symbol, name and decimals and assisted
97 // token transfers
98 // ----------------------------------------------------------------------------
99 contract AIOToken is ERC20Interface, Owned, SafeMath {
100     string public symbol;
101     string public  name;
102     uint8 public decimals;
103     uint public totalSupply;
104     uint public startDate;
105     uint public bonusEnds;
106     uint public endDate;
107 
108     mapping(address => uint) balances;
109     mapping(address => mapping(address => uint)) allowed;
110 
111 
112     // ------------------------------------------------------------------------
113     // Constructor
114     // ------------------------------------------------------------------------
115     function AIOToken() public {
116         symbol = "AIO";
117         name = "AIO Token";
118         decimals = 18;
119         totalSupply = 870000 * 10**uint(decimals);
120         balances[owner] = totalSupply;
121         emit Transfer(address(0), owner, totalSupply);
122         bonusEnds = now + 3 weeks;
123         endDate = now + 8 weeks;
124 
125     }
126 
127 
128     // ------------------------------------------------------------------------
129     // Total supply
130     // ------------------------------------------------------------------------
131     function totalSupply() public constant returns (uint) {
132         return totalSupply  - balances[address(0)];
133     }
134 
135 
136     // ------------------------------------------------------------------------
137     // Get the token balance for account `tokenOwner`
138     // ------------------------------------------------------------------------
139     function balanceOf(address tokenOwner) public constant returns (uint balance) {
140         return balances[tokenOwner];
141     }
142 
143 
144     // ------------------------------------------------------------------------
145     // Transfer the balance from token owner's account to `to` account
146     // - Owner's account must have sufficient balance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transfer(address to, uint tokens) public returns (bool success) {
150         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
151         balances[to] = safeAdd(balances[to], tokens);
152         emit Transfer(msg.sender, to, tokens);
153         return true;
154     }
155 
156 
157     // ------------------------------------------------------------------------
158     // Token owner can approve for `spender` to transferFrom(...) `tokens`
159     // from the token owner's account
160     // ------------------------------------------------------------------------
161     function approve(address spender, uint tokens) public returns (bool success) {
162         allowed[msg.sender][spender] = tokens;
163         emit Approval(msg.sender, spender, tokens);
164         return true;
165     }
166 
167     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
168         balances[from] = safeSub(balances[from], tokens);
169         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
170         balances[to] = safeAdd(balances[to], tokens);
171         emit Transfer(from, to, tokens);
172         return true;
173     }
174 
175 
176     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
180     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
181         allowed[msg.sender][spender] = tokens;
182         emit Approval(msg.sender, spender, tokens);
183         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
184         return true;
185     }
186 	
187     function () public payable {
188         require(now >= startDate && now <= endDate);
189         uint tokens;
190         if (now <= bonusEnds) {
191             tokens = msg.value * 1293;
192         } else {
193             tokens = msg.value * 821;
194         }
195         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
196         totalSupply = safeAdd(totalSupply, tokens);
197         emit Transfer(address(0), msg.sender, tokens);
198         owner.transfer(msg.value);
199     }
200 
201     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
202         return ERC20Interface(tokenAddress).transfer(owner, tokens);
203     }
204 }