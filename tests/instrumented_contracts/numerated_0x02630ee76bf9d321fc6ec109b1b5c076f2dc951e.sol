1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'Techgoldology Token' token contract
4 //
5 // Symbol      : TGY
6 // Name        : Techgoldology Token
7 // Total supply: 5,000,000,000.000000000000000000
8 // Decimals    : 18
9 //
10 // Enjoy.
11 //
12 // (c) TGY / TechgoldologyToken 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
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
35 // ----------------------------------------------------------------------------
36 // ERC Token Standard #20 Interface
37 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
38 // ----------------------------------------------------------------------------
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
49 // ----------------------------------------------------------------------------
50 // Contract function to receive approval and execute function in one call
51 //
52 // Borrowed from MiniMeToken
53 // ----------------------------------------------------------------------------
54 contract ApproveAndCallFallBack {
55     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
56 }
57 // ----------------------------------------------------------------------------
58 // Owned contract
59 // ----------------------------------------------------------------------------
60 contract Owned {
61     address public owner;
62     address public newOwner;
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64     constructor() public {
65         owner = msg.sender;
66     }
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and a
83 // fixed supply
84 // ----------------------------------------------------------------------------
85 contract TechgoldologyToken is ERC20Interface, Owned {
86     using SafeMath for uint;
87     string public symbol;
88     string public  name;
89     uint8 public decimals;
90     uint _totalSupply;
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93     // ------------------------------------------------------------------------
94     // Constructor
95     // ------------------------------------------------------------------------
96     constructor() public {
97         symbol = "TGY";
98         name = "Techgoldology Token";
99         decimals = 18;
100         _totalSupply = 5000000000 * 10**uint(decimals);
101         balances[owner] = _totalSupply;
102         emit Transfer(address(0), owner, _totalSupply);
103     }
104     // ------------------------------------------------------------------------
105     // Total supply
106     // ------------------------------------------------------------------------
107     function totalSupply() public view returns (uint) {
108         return _totalSupply.sub(balances[address(0)]);
109     }
110     // ------------------------------------------------------------------------
111     // Get the token balance for account `tokenOwner`
112     // ------------------------------------------------------------------------
113     function balanceOf(address tokenOwner) public view returns (uint balance) {
114         return balances[tokenOwner];
115     }
116     // ------------------------------------------------------------------------
117     // Transfer the balance from token owner's account to `to` account
118     // - Owner's account must have sufficient balance to transfer
119     // - 0 value transfers are allowed
120     // ------------------------------------------------------------------------
121     function transfer(address to, uint tokens) public returns (bool success) {
122         balances[msg.sender] = balances[msg.sender].sub(tokens);
123         balances[to] = balances[to].add(tokens);
124         emit Transfer(msg.sender, to, tokens);
125         return true;
126     }
127     // ------------------------------------------------------------------------
128     // Token owner can approve for `spender` to transferFrom(...) `tokens`
129     // from the token owner's account
130     //
131     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
132     // recommends that there are no checks for the approval double-spend attack
133     // as this should be implemented in user interfaces
134     // ------------------------------------------------------------------------
135     function approve(address spender, uint tokens) public returns (bool success) {
136         allowed[msg.sender][spender] = tokens;
137         emit Approval(msg.sender, spender, tokens);
138         return true;
139     }
140     // ------------------------------------------------------------------------
141     // Transfer `tokens` from the `from` account to the `to` account
142     //
143     // The calling account must already have sufficient tokens approve(...)-d
144     // for spending from the `from` account and
145     // - From account must have sufficient balance to transfer
146     // - Spender must have sufficient allowance to transfer
147     // - 0 value transfers are allowed
148     // ------------------------------------------------------------------------
149     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
150         balances[from] = balances[from].sub(tokens);
151         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
152         balances[to] = balances[to].add(tokens);
153         emit Transfer(from, to, tokens);
154         return true;
155     }
156     // ------------------------------------------------------------------------
157     // Returns the amount of tokens approved by the owner that can be
158     // transferred to the spender's account
159     // ------------------------------------------------------------------------
160     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
161         return allowed[tokenOwner][spender];
162     }
163     // ------------------------------------------------------------------------
164     // Token owner can approve for `spender` to transferFrom(...) `tokens`
165     // from the token owner's account. The `spender` contract function
166     // `receiveApproval(...)` is then executed
167     // ------------------------------------------------------------------------
168     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
172         return true;
173     }
174     // ------------------------------------------------------------------------
175     // Don't accept ETH
176     // ------------------------------------------------------------------------
177     function () external payable {
178         revert();
179     }
180     // ------------------------------------------------------------------------
181     // Owner can transfer out any accidentally sent ERC20 tokens
182     // ------------------------------------------------------------------------
183     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
184         return ERC20Interface(tokenAddress).transfer(owner, tokens);
185     }
186 }