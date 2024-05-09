1 pragma solidity ^0.5.0;
2 
3 
4 
5 // NextGeneration Code
6 
7 // ----------------------------------------------------------------------------
8 
9 // ----------------------------------------------------------------------------
10 // Safe maths
11 // ----------------------------------------------------------------------------
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // ERC Token Standard #20 Interface
34 // ----------------------------------------------------------------------------
35 contract ERC20Interface {
36     function totalSupply() public view returns (uint);
37     function balanceOf(address tokenOwner) public view returns (uint balance);
38     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
39     function transfer(address to, uint tokens) public returns (bool success);
40     function approve(address spender, uint tokens) public returns (bool success);
41     function transferFrom(address from, address to, uint tokens) public returns (bool success);
42 
43     event Transfer(address indexed from, address indexed to, uint tokens);
44     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Contract function to receive approval and execute function in one call
50 //
51 // Borrowed from MiniMeToken
52 // ----------------------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
55 }
56 
57 
58 // ----------------------------------------------------------------------------
59 // Owned contract
60 // ----------------------------------------------------------------------------
61 contract Owned {
62     address public owner;
63     address public newOwner;
64 
65     event OwnershipTransferred(address indexed _from, address indexed _to);
66 
67     constructor() public {
68         owner = msg.sender;
69     }
70 
71     modifier onlyOwner {
72         require(msg.sender == owner);
73         _;
74     }
75 
76     function transferOwnership(address _newOwner) public onlyOwner {
77         newOwner = _newOwner;
78     }
79     function acceptOwnership() public {
80         require(msg.sender == newOwner);
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and a
90 // fixed supply
91 // ----------------------------------------------------------------------------
92 contract NextGeneration is ERC20Interface, Owned {
93     using SafeMath for uint;
94 
95     string public symbol ="Next Geeration";
96     string public  name = "NXTGEN";
97     uint8 public decimals = 2;
98     uint _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103 
104     // ------------------------------------------------------------------------
105     // Constructor
106     // ------------------------------------------------------------------------
107     constructor() public {
108         symbol = "NXTGEN";
109         name = "NextGeneration";
110         decimals = 2;
111         _totalSupply = 100000001 * 1**uint(decimals);
112         balances[owner] = _totalSupply;
113         emit Transfer(address(0), owner, _totalSupply);
114     }
115 
116 
117     // ------------------------------------------------------------------------
118     // Total supply
119     // ------------------------------------------------------------------------
120     function totalSupply() public view returns (uint) {
121         return _totalSupply.sub(balances[address(0)]);
122     }
123 
124 
125     // ------------------------------------------------------------------------
126     // Get the token balance for account `tokenOwner`
127     // ------------------------------------------------------------------------
128     function balanceOf(address tokenOwner) public view returns (uint balance) {
129         return balances[tokenOwner];
130     }
131 
132 
133     // ------------------------------------------------------------------------
134     // Transfer the balance from token owner's account to `to` account
135     // - Owner's account must have sufficient balance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transfer(address to, uint tokens) public returns (bool success) {
139         balances[msg.sender] = balances[msg.sender].sub(tokens);
140         balances[to] = balances[to].add(tokens);
141         emit Transfer(msg.sender, to, tokens);
142         return true;
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Token owner can approve for `spender` to transferFrom(...) `tokens`
148     // from the token owner's account
149     //
150     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
151     // recommends that there are no checks for the approval double-spend attack
152     // as this should be implemented in user interfaces
153     // ------------------------------------------------------------------------
154     function approve(address spender, uint tokens) public returns (bool success) {
155         allowed[msg.sender][spender] = tokens;
156         emit Approval(msg.sender, spender, tokens);
157         return true;
158     }
159 
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
170     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
171         balances[from] = balances[from].sub(tokens);
172         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
173         balances[to] = balances[to].add(tokens);
174         emit Transfer(from, to, tokens);
175         return true;
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Returns the amount of tokens approved by the owner that can be
181     // transferred to the spender's account
182     // ------------------------------------------------------------------------
183     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
184         return allowed[tokenOwner][spender];
185     }
186 
187 
188     // ------------------------------------------------------------------------
189     // Token owner can approve for `spender` to transferFrom(...) `tokens`
190     // from the token owner's account. The `spender` contract function
191     // `receiveApproval(...)` is then executed
192     // ------------------------------------------------------------------------
193     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
194         allowed[msg.sender][spender] = tokens;
195         emit Approval(msg.sender, spender, tokens);
196         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
197         return true;
198     }
199 
200 
201     // ------------------------------------------------------------------------
202     // Don't accept ETH
203     // ------------------------------------------------------------------------
204     function () external payable {
205         revert();
206     }
207 
208 
209     // ------------------------------------------------------------------------
210     // Owner can transfer out any accidentally sent ERC20 tokens
211     // ------------------------------------------------------------------------
212     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
213         return ERC20Interface(tokenAddress).transfer(owner, tokens);
214     }
215 }