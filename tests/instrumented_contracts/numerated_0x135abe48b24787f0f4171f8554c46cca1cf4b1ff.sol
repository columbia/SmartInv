1 pragma solidity ^0.5.2;
2 
3 // ----------------------------------------------------------------------------
4 // 'TGC' 'TurnGreen' token contract
5 //
6 // Symbol      : TGC
7 // Name        : TurnGreen
8 // Total supply: 210000000
9 // Decimals    : 8
10 //
11 // (c) by TurnGreen. All Rights Reserved.
12 // ----------------------------------------------------------------------------
13 
14 // ----------------------------------------------------------------------------
15 // Safe maths
16 // ----------------------------------------------------------------------------
17 library SafeMath {
18     function add(uint a, uint b) internal pure returns (uint c) {
19         c = a + b;
20         require(c >= a);
21     }
22     function sub(uint a, uint b) internal pure returns (uint c) {
23         require(b <= a);
24         c = a - b;
25     }
26     function mul(uint a, uint b) internal pure returns (uint c) {
27         c = a * b;
28         require(a == 0 || c / a == b);
29     }
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require(b > 0);
32         c = a / b;
33     }
34 }
35 
36 
37 // ----------------------------------------------------------------------------
38 // ERC Token Standard #20 Interface
39 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
40 // ----------------------------------------------------------------------------
41 contract ERC20Interface {
42     function totalSupply() public view returns (uint);
43     function balanceOf(address tokenOwner) public view returns (uint balance);
44     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
45     function transfer(address to, uint tokens) public returns (bool success);
46     function approve(address spender, uint tokens) public returns (bool success);
47     function transferFrom(address from, address to, uint tokens) public returns (bool success);
48 
49     event Transfer(address indexed from, address indexed to, uint tokens);
50     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
51 }
52 
53 
54 // ----------------------------------------------------------------------------
55 // Contract function to receive approval and execute function in one call
56 // ----------------------------------------------------------------------------
57 contract ApproveAndCallFallBack {
58     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Owned contract
64 // ----------------------------------------------------------------------------
65 contract Owned {
66     address public owner;
67     address public newOwner;
68 
69     event OwnershipTransferred(address indexed _from, address indexed _to);
70 
71     constructor() public {
72         owner = msg.sender;
73     }
74 
75     modifier onlyOwner {
76         require(msg.sender == owner);
77         _;
78     }
79 
80     function transferOwnership(address _newOwner) public onlyOwner {
81         newOwner = _newOwner;
82     }
83     function acceptOwnership() public {
84         require(msg.sender == newOwner);
85         emit OwnershipTransferred(owner, newOwner);
86         owner = newOwner;
87         newOwner = address(0);
88     }
89 }
90 
91 
92 // ----------------------------------------------------------------------------
93 // ERC20 Token, with the addition of symbol, name and decimals and a
94 // fixed supply
95 // ----------------------------------------------------------------------------
96 contract TurnGreen is ERC20Interface, Owned {
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
112         symbol = "TGC";
113         name = "TurnGreen";
114         decimals = 8;
115         _totalSupply = 210000000 * 10**uint(decimals);
116         balances[0xcaDe3a45735Db7e4982B3DD8cd26114A5a755f68] = _totalSupply;
117         emit Transfer(address(0), 0xcaDe3a45735Db7e4982B3DD8cd26114A5a755f68, _totalSupply);
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
197     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
198         allowed[msg.sender][spender] = tokens;
199         emit Approval(msg.sender, spender, tokens);
200         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
201         return true;
202     }
203 
204 
205     // ------------------------------------------------------------------------
206     // Don't accept ETH
207     // ------------------------------------------------------------------------
208     function () external payable {
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