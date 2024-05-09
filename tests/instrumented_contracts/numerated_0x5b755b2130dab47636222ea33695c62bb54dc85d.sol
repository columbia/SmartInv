1 pragma solidity ^0.4.21;
2 // ----------------------------------------------------------------------------
3 // ERC Token Standard #20 Interface
4 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
5 // ----------------------------------------------------------------------------
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 // ----------------------------------------------------------------------------
19 // Contract function to receive approval and execute function in one call
20 //
21 // Borrowed from MiniMeToken
22 // ----------------------------------------------------------------------------
23 contract ApproveAndCallFallBack {
24     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
25 }
26 
27 // ----------------------------------------------------------------------------
28 // Safe maths
29 // ----------------------------------------------------------------------------
30 library SafeMath {
31     function add(uint a, uint b) internal pure returns (uint c) {
32         c = a + b;
33         require(c >= a);
34     }
35     function sub(uint a, uint b) internal pure returns (uint c) {
36         require(b <= a);
37         c = a - b;
38     }
39     function mul(uint a, uint b) internal pure returns (uint c) {
40         c = a * b;
41         require(a == 0 || c / a == b);
42     }
43     function div(uint a, uint b) internal pure returns (uint c) {
44         require(b > 0);
45         c = a / b;
46     }
47 }
48 
49 // ----------------------------------------------------------------------------
50 // ERC20 Token, with the addition of symbol, name and decimals and an
51 // initial fixed supply
52 // ----------------------------------------------------------------------------
53 contract GoblinChainToken is ERC20Interface{
54     using SafeMath for uint;
55 
56     string public symbol;
57     string public  name;
58     uint8 public decimals;
59     uint _totalSupply;
60 
61     mapping(address => uint) balances;
62     mapping(address => mapping(address => uint)) allowed;
63     // ------------------------------------------------------------------------
64     // Constructor
65     // ------------------------------------------------------------------------
66     function GoblinChainToken() public {
67         symbol = "GOBC";
68         name = "Goblin Chain";
69         decimals = 18;
70         _totalSupply = 7000000000 * 10**uint(decimals);
71         balances[msg.sender] = _totalSupply;
72         emit Transfer(address(0), msg.sender, _totalSupply);
73     }
74 
75     // ------------------------------------------------------------------------
76     // Total supply
77     // ------------------------------------------------------------------------
78     function totalSupply() public constant returns (uint) {
79         return _totalSupply  - balances[address(0)];
80     }
81 
82     // ------------------------------------------------------------------------
83     // Get the token balance for account `tokenOwner`
84     // ------------------------------------------------------------------------
85     function balanceOf(address tokenOwner) public constant returns (uint balance) {
86         return balances[tokenOwner];
87     }
88 
89     // ------------------------------------------------------------------------
90     // Transfer the balance from token owner's account to `to` account
91     // - Owner's account must have sufficient balance to transfer
92     // - 0 value transfers are allowed
93     // ------------------------------------------------------------------------
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = balances[msg.sender].sub(tokens);
96         balances[to] = balances[to].add(tokens);
97         emit Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     // ------------------------------------------------------------------------
102     // Token owner can approve for `spender` to transferFrom(...) `tokens`
103     // from the token owner's account
104     //
105     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
106     // recommends that there are no checks for the approval double-spend attack
107     // as this should be implemented in user interfaces
108     // ------------------------------------------------------------------------
109     function approve(address spender, uint tokens) public returns (bool success) {
110         allowed[msg.sender][spender] = tokens;
111         emit Approval(msg.sender, spender, tokens);
112         return true;
113     }
114 
115     // ------------------------------------------------------------------------
116     // Transfer `tokens` from the `from` account to the `to` account
117     //
118     // The calling account must already have sufficient tokens approve(...)-d
119     // for spending from the `from` account and
120     // - From account must have sufficient balance to transfer
121     // - Spender must have sufficient allowance to transfer
122     // - 0 value transfers are allowed
123     // ------------------------------------------------------------------------
124     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
125         balances[from] = balances[from].sub(tokens);
126         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
127         balances[to] = balances[to].add(tokens);
128         emit Transfer(from, to, tokens);
129         return true;
130     }
131 
132     // ------------------------------------------------------------------------
133     // Returns the amount of tokens approved by the owner that can be
134     // transferred to the spender's account
135     // ------------------------------------------------------------------------
136     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
137         return allowed[tokenOwner][spender];
138     }
139 
140     // ------------------------------------------------------------------------
141     // Token owner can approve for `spender` to transferFrom(...) `tokens`
142     // from the token owner's account. The `spender` contract function
143     // `receiveApproval(...)` is then executed
144     // ------------------------------------------------------------------------
145     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
149         return true;
150     }
151 
152     // ------------------------------------------------------------------------
153     // send ERC20 Token to multi address
154     // ------------------------------------------------------------------------
155     function multiTransfer(address[] _addresses, uint256[] amounts) public returns (bool success){
156         for (uint256 i = 0; i < _addresses.length; i++) {
157             transfer(_addresses[i], amounts[i]);
158         }
159         return true;
160     }
161 
162     // ------------------------------------------------------------------------
163     // send ERC20 Token to multi address with decimals
164     // ------------------------------------------------------------------------
165     function multiTransferDecimals(address[] _addresses, uint256[] amounts) public returns (bool success){
166         for (uint256 i = 0; i < _addresses.length; i++) {
167             transfer(_addresses[i], amounts[i] * 10**uint(decimals));
168         }
169         return true;
170     }
171     // ------------------------------------------------------------------------
172     // Don't accept ETH
173     // ------------------------------------------------------------------------
174     function () public payable {
175         revert();
176     }
177 }