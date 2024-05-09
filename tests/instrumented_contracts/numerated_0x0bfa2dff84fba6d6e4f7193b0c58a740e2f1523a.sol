1 pragma solidity ^0.4.25;
2 
3 // ----------------------------------------------------------------------------
4 // 'IMOCOIN' token contract
5 //
6 // Symbol      : IMO
7 // Name        : IMOCOIN
8 // Total supply: 21000000
9 // Decimals    : 8
10 // ----------------------------------------------------------------------------
11 
12 // ----------------------------------------------------------------------------
13 // Safe maths
14 // ----------------------------------------------------------------------------
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 // ----------------------------------------------------------------------------
35 // ERC Token Standard #20 Interface
36 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
37 // ----------------------------------------------------------------------------
38 contract ERC20Interface {
39     function totalSupply() public constant returns (uint);
40     function balanceOf(address tokenOwner) public constant returns (uint balance);
41     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
42     function transfer(address to, uint tokens) public returns (bool success);
43     function approve(address spender, uint tokens) public returns (bool success);
44     function transferFrom(address from, address to, uint tokens) public returns (bool success);
45 
46     event Transfer(address indexed from, address indexed to, uint tokens);
47     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
48 }
49 
50 // ----------------------------------------------------------------------------
51 // Contract function to receive approval and execute function in one call
52 //
53 // Borrowed from MiniMeToken
54 // ----------------------------------------------------------------------------
55 contract ApproveAndCallFallBack {
56     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
57 }
58 
59 // ----------------------------------------------------------------------------
60 // Owned contract
61 // ----------------------------------------------------------------------------
62 contract Owned {
63     address public owner;
64     address public newOwner;
65 
66     event OwnershipTransferred(address indexed _from, address indexed _to);
67 
68     constructor() public {
69         owner = msg.sender;
70     }
71 
72     modifier onlyOwner {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     function transferOwnership(address _newOwner) public onlyOwner {
78         newOwner = _newOwner;
79     }
80     function acceptOwnership() public {
81         require(msg.sender == newOwner);
82         emit OwnershipTransferred(owner, newOwner);
83         owner = newOwner;
84         newOwner = address(0);
85     }
86 }
87 
88 // ----------------------------------------------------------------------------
89 // ERC20 Token, with the addition of symbol, name and decimals and a
90 // fixed supply
91 // ----------------------------------------------------------------------------
92 contract Imocoin is ERC20Interface, Owned {
93     using SafeMath for uint;
94 
95     string public symbol;
96     string public  name;
97     uint8 public decimals;
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
108         symbol = "IMO";
109         name = "Imocoin";
110         decimals = 8;
111         _totalSupply = 21000000 * 10**uint(decimals);
112         balances[owner] = _totalSupply;
113         emit Transfer(address(0), owner, _totalSupply);
114     }
115 
116     // ------------------------------------------------------------------------
117     // Total supply
118     // ------------------------------------------------------------------------
119     function totalSupply() public view returns (uint) {
120         return _totalSupply.sub(balances[address(0)]);
121     }
122 
123     // ------------------------------------------------------------------------
124     // Get the token balance for account `tokenOwner`
125     // ------------------------------------------------------------------------
126     function balanceOf(address tokenOwner) public view returns (uint balance) {
127         return balances[tokenOwner];
128     }
129 
130     // ------------------------------------------------------------------------
131     // Transfer the balance from token owner's account to `to` account
132     // - Owner's account must have sufficient balance to transfer
133     // - 0 value transfers are allowed
134     // ------------------------------------------------------------------------
135     function transfer(address to, uint tokens) public returns (bool success) {
136         balances[msg.sender] = balances[msg.sender].sub(tokens);
137         balances[to] = balances[to].add(tokens);
138         emit Transfer(msg.sender, to, tokens);
139         return true;
140     }
141 
142     // ------------------------------------------------------------------------
143     // Token owner can approve for `spender` to transferFrom(...) `tokens`
144     // from the token owner's account
145     //
146     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
147     // recommends that there are no checks for the approval double-spend attack
148     // as this should be implemented in user interfaces
149     // ------------------------------------------------------------------------
150     function approve(address spender, uint tokens) public returns (bool success) {
151         allowed[msg.sender][spender] = tokens;
152         emit Approval(msg.sender, spender, tokens);
153         return true;
154     }
155 
156     // ------------------------------------------------------------------------
157     // Transfer `tokens` from the `from` account to the `to` account
158     //
159     // The calling account must already have sufficient tokens approve(...)-d
160     // for spending from the `from` account and
161     // - From account must have sufficient balance to transfer
162     // - Spender must have sufficient allowance to transfer
163     // - 0 value transfers are allowed
164     // ------------------------------------------------------------------------
165     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
166         balances[from] = balances[from].sub(tokens);
167         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
168         balances[to] = balances[to].add(tokens);
169         emit Transfer(from, to, tokens);
170         return true;
171     }
172 
173     // ------------------------------------------------------------------------
174     // Returns the amount of tokens approved by the owner that can be
175     // transferred to the spender's account
176     // ------------------------------------------------------------------------
177     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
178         return allowed[tokenOwner][spender];
179     }
180 
181     // ------------------------------------------------------------------------
182     // Token owner can approve for `spender` to transferFrom(...) `tokens`
183     // from the token owner's account. The `spender` contract function
184     // `receiveApproval(...)` is then executed
185     // ------------------------------------------------------------------------
186     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
187         allowed[msg.sender][spender] = tokens;
188         emit Approval(msg.sender, spender, tokens);
189         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
190         return true;
191     }
192 
193     // ------------------------------------------------------------------------
194     // Don't accept ETH
195     // ------------------------------------------------------------------------
196     function () public payable {
197         revert();
198     }
199 
200     // ------------------------------------------------------------------------
201     // Owner can transfer out any accidentally sent ERC20 tokens
202     // ------------------------------------------------------------------------
203     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
204         return ERC20Interface(tokenAddress).transfer(owner, tokens);
205     }
206 }