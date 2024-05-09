1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------
4 // Fixed supply ERC20 Token Contract
5 // symbol	        : PBR
6 // name	            : PBR
7 // total supply     : 100,000,000.000000000000000000
8 // decimals	        : 18
9 // ----------------------------------------------------------------
10 
11 // ----------------------------------------------------------------
12 // Safe Math
13 // ----------------------------------------------------------------
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a, "c must be >= a");
18     }
19 
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a, "b must be <= a");
22         c = a - b;
23     }
24 
25     function mul(uint a, uint b) internal pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b, "a must = 0 or c / a must = b");
28     }
29 
30     function div(uint a, uint b) internal pure returns (uint c) {
31         require (b > 0, "b must be > 0");
32         c = a / b;
33     }
34 }
35 
36 // ----------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // ----------------------------------------------------------------
39 contract ERC20Interface {
40     function totalSupply() public view returns (uint);
41     function balanceOf(address tokenOwner) public view returns (uint balance);
42     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
43     function transfer(address to, uint tokens) public returns (bool success);
44     function approve(address spender, uint tokens) public returns (bool success);
45     function transferFrom(address from, address to, uint tokens) public returns (bool success);
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);    
48 }
49 
50 // ----------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 // ----------------------------------------------------------------
53 contract ApproveAndCallFallBack {
54     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
55 }
56 
57 // ----------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63     
64     event OwnershipTransferred(address indexed _from, address indexed _to);
65     
66     constructor() public {
67         owner = msg.sender;
68     }
69 
70     modifier onlyOwner {
71         require(msg.sender == owner, "only the contract owner can perform this function");
72         _;
73     }
74 
75     function transferOwnership(address _newOwner) public onlyOwner {
76         newOwner = _newOwner;
77     }
78 
79     function acceptOwnership() public {
80         require(msg.sender == newOwner, "only the new contract owner can perform this function");
81         emit OwnershipTransferred(owner, newOwner);
82         owner = newOwner;
83         newOwner = address(0);
84     }
85 }
86 
87 // ----------------------------------------------------------------
88 // ERC20 Token, with the addition of symbol, name and decimals and
89 // a fixed supply
90 // ----------------------------------------------------------------
91 contract PBR is ERC20Interface, Owned {
92     using SafeMath for uint;
93 
94     string public symbol;
95     string public name;
96     string public url;
97     uint8 public decimals;
98     uint _totalSupply;
99 
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103     // ----------------------------------------------------------------
104     // Constructor
105     // ----------------------------------------------------------------
106     constructor() public {
107         symbol = "PBR";
108         name = "PBR";
109         url = "https://pbrcoin.com";
110         decimals = 18;
111         _totalSupply = 100000000 * 10**uint(decimals);
112         balances[owner] = _totalSupply;
113         emit Transfer(address(0), owner, _totalSupply);
114     }
115 
116     // ----------------------------------------------------------------
117     // Total token supply
118     // ----------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply.sub(balances[address(0)]);
121     }
122 
123     // ----------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ----------------------------------------------------------------
126     function balanceOf(address tokenOwner) public view returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130     // ----------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ----------------------------------------------------------------
135     function transfer(address to, uint tokens) public returns (bool success) {
136         balances[msg.sender] = balances[msg.sender].sub(tokens);
137         balances[to] = balances[to].add(tokens);
138         emit Transfer(msg.sender, to, tokens);
139         return true;
140     }
141 
142     // ----------------------------------------------------------------
143     // Token owner can approve for `spender` to transferFrom(...) `tokens`
144     // from the token owner's account
145     // ----------------------------------------------------------------
146     function approve(address spender, uint tokens) public returns (bool success) {
147         allowed[msg.sender][spender] = tokens;
148         emit Approval(msg.sender, spender, tokens);
149         return true;
150     }
151 
152     // ----------------------------------------------------------------
153     // Transfer `tokens` from the `from` account to the `to` account
154     // The calling account must already have sufficient tokens approve(...)-d
155     // for spending from the `from` account and
156     // - From account must have sufficient balance to transfer
157     // - Spender must have sufficient allowance to transfer
158     // - 0 value transfers are allowed
159     // ----------------------------------------------------------------
160     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
161         balances[from] = balances[from].sub(tokens);
162         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
163         balances[to] = balances[to].add(tokens);
164         emit Transfer(from, to, tokens);
165         return true;
166     }
167 
168     // ----------------------------------------------------------------
169     // Returns the amount of tokens approved by the owner that can be
170     // transferred to the spender's account
171     // ----------------------------------------------------------------
172     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
173         return allowed[tokenOwner][spender];
174     }
175 
176     // ----------------------------------------------------------------
177     // Token owner can approve for `spender` to transferFrom(...) `tokens`
178     // from the token owner's account. The `spender` contract function
179     // `receiveApproval(...)` is then executed
180     // ----------------------------------------------------------------
181     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
182         allowed[msg.sender][spender] = tokens;
183         emit Approval(msg.sender, spender, tokens);
184         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
185         return true;
186     }
187 
188     // ----------------------------------------------------------------
189     // Owner can transfer out any accidentally sent ERC20 tokens
190     // ----------------------------------------------------------------
191     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
192         return ERC20Interface(tokenAddress).transfer(owner, tokens);
193     }
194 
195     // ----------------------------------------------------------------
196     // Accept ether
197     // ----------------------------------------------------------------
198     function () public payable {
199     }
200 
201     // ----------------------------------------------------------------
202     // Owner can withdraw ether that was sent to this contract
203     // ----------------------------------------------------------------
204     function withdrawEther(uint amount) public onlyOwner returns (bool success) {
205         owner.transfer(amount);
206         return true;
207     }
208 
209 }