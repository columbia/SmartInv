1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'BMX' 'BitMaxPro Token' contract
5 // Symbol      : BMX
6 // Name        : BitMaxPro Token
7 // Total supply: 100,000,000
8 // Decimals    : 2
9 // (c) Stefan Nagies / BitMaxPro 2019. 
10 // ----------------------------------------------------------------------------
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 library SafeMath {
17     function add(uint a, uint b) internal pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function sub(uint a, uint b) internal pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function div(uint a, uint b) internal pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
39 // ----------------------------------------------------------------------------
40 contract ERC20Interface {
41     function totalSupply() public constant returns (uint);
42     function balanceOf(address tokenOwner) public constant returns (uint balance);
43     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
44     function transfer(address to, uint tokens) public returns (bool success);
45     function approve(address spender, uint tokens) public returns (bool success);
46     function transferFrom(address from, address to, uint tokens) public returns (bool success);
47 
48     event Transfer(address indexed from, address indexed to, uint tokens);
49     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
50 }
51 
52 
53 // ----------------------------------------------------------------------------
54 // Contract function to receive approval and execute function in one call
55 //
56 // Borrowed from MiniMeToken
57 // ----------------------------------------------------------------------------
58 contract ApproveAndCallFallBack {
59     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Owned contract
65 // ----------------------------------------------------------------------------
66 contract Owned {
67     address public owner;
68     address public newOwner;
69 
70     event OwnershipTransferred(address indexed _from, address indexed _to);
71 
72     constructor() public {
73         owner = msg.sender;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     function transferOwnership(address _newOwner) public onlyOwner {
82         newOwner = _newOwner;
83     }
84     function acceptOwnership() public {
85         require(msg.sender == newOwner);
86         emit OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88         newOwner = address(0);
89     }
90 }
91 
92 
93 // ----------------------------------------------------------------------------
94 // BitMaxPro ERC20 Token, with the addition of symbol, name and decimals
95 // ----------------------------------------------------------------------------
96 contract BitMaxProToken is ERC20Interface, Owned {
97     using SafeMath for uint;
98 
99     string public symbol;
100     string public  name;
101     uint8 public decimals;
102     uint _totalSupply;
103 
104     mapping(address => uint) balances;
105     mapping(address => mapping(address => uint)) allowed;
106 
107 
108     // ------------------------------------------------------------------------
109     // Constructor
110     // ------------------------------------------------------------------------
111     constructor() public {
112         symbol = "BMX";
113         name = "BitMaxPro Token";
114         decimals = 2;
115         _totalSupply = 100000000 * 10**uint(decimals);
116         balances[owner] = _totalSupply;
117         emit Transfer(address(0), owner, _totalSupply);
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Total supply
123     // ------------------------------------------------------------------------
124     function totalSupply() public view returns (uint) {
125         return _totalSupply.sub(balances[address(0)]);
126     }
127 
128 
129     // ------------------------------------------------------------------------
130     // Get the token balance for account `tokenOwner`
131     // ------------------------------------------------------------------------
132     function balanceOf(address tokenOwner) public view returns (uint balance) {
133         return balances[tokenOwner];
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Transfer the balance from token owner's account to `to` account
139     // - Owner's account must have sufficient balance to transfer
140     // - 0 value transfers are allowed
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         balances[msg.sender] = balances[msg.sender].sub(tokens);
144         balances[to] = balances[to].add(tokens);
145         emit Transfer(msg.sender, to, tokens);
146         return true;
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
160         emit Approval(msg.sender, spender, tokens);
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
174     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
175         balances[from] = balances[from].sub(tokens);
176         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
177         balances[to] = balances[to].add(tokens);
178         emit Transfer(from, to, tokens);
179         return true;
180     }
181 
182 
183     // ------------------------------------------------------------------------
184     // Returns the amount of tokens approved by the owner that can be
185     // transferred to the spender's account
186     // ------------------------------------------------------------------------
187     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
188         return allowed[tokenOwner][spender];
189     }
190 
191 
192     // ------------------------------------------------------------------------
193     // Token owner can approve for `spender` to transferFrom(...) `tokens`
194     // from the token owner's account. The `spender` contract function
195     // `receiveApproval(...)` is then executed
196     // ------------------------------------------------------------------------
197     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
198         allowed[msg.sender][spender] = tokens;
199         emit Approval(msg.sender, spender, tokens);
200         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Don't accept ETH
207     // ------------------------------------------------------------------------
208     function () public payable {
209         revert();
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Owner can transfer out any accidentally sent ERC20 tokens
215     // ------------------------------------------------------------------------
216     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
217         return ERC20Interface(tokenAddress).transfer(owner, tokens);
218     }
219 }