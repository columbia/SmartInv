1 pragma solidity ^0.4.24;
2 // ----------------------------------------------------------------------------
3 // Safe maths
4 // ----------------------------------------------------------------------------
5 library SafeMath {
6     function add(uint a, uint b) internal pure returns (uint c) {
7         c = a + b;
8         require(c >= a);
9     }
10     function sub(uint a, uint b) internal pure returns (uint c) {
11         require(b <= a);
12         c = a - b;
13     }
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18     function div(uint a, uint b) internal pure returns (uint c) {
19         require(b > 0);
20         c = a / b;
21     }
22 }
23 
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     function totalSupply() public constant returns (uint);
30     function balanceOf(address tokenOwner) public constant returns (uint balance);
31     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
32     function transfer(address to, uint tokens) public returns (bool success);
33     function approve(address spender, uint tokens) public returns (bool success);
34     function transferFrom(address from, address to, uint tokens) public returns (bool success);
35 
36     event Transfer(address indexed from, address indexed to, uint tokens);
37     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
38 }
39 
40 
41 // ----------------------------------------------------------------------------
42 // Contract function to receive approval and execute function in one call
43 //
44 // Borrowed from MiniMeToken
45 // ----------------------------------------------------------------------------
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55     address public owner;
56     address public newOwner;
57 
58     event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60     constructor() public {
61         owner = msg.sender;
62     }
63 
64     modifier onlyOwner {
65         require(msg.sender == owner);
66         _;
67     }
68 
69     function transferOwnership(address _newOwner) public onlyOwner {
70         newOwner = _newOwner;
71     }
72     function acceptOwnership() public {
73         require(msg.sender == newOwner);
74         emit OwnershipTransferred(owner, newOwner);
75         owner = newOwner;
76         newOwner = address(0);
77     }
78 }
79 
80 
81 // ----------------------------------------------------------------------------
82 // ERC20 Token, with the addition of symbol, name and decimals and a
83 // fixed supply
84 // ----------------------------------------------------------------------------
85 contract FixedSupplyToken is ERC20Interface, Owned {
86     using SafeMath for uint;
87 
88     string public symbol;
89     string public  name;
90     uint8 public decimals;
91     uint _totalSupply;
92 
93     mapping(address => uint) balances;
94     mapping(address => mapping(address => uint)) allowed;
95 
96 
97     // ------------------------------------------------------------------------
98     // Constructor
99     // ------------------------------------------------------------------------
100     constructor() public {
101         symbol = "BITE";
102         name = "Bit Ecoin";
103         decimals = 18;
104         _totalSupply = 200000000 * 10**uint(decimals);
105         balances[owner] = _totalSupply;
106         emit Transfer(address(0), owner, _totalSupply);
107     }
108 
109 
110     // ------------------------------------------------------------------------
111     // Total supply
112     // ------------------------------------------------------------------------
113     function totalSupply() public view returns (uint) {
114         return _totalSupply.sub(balances[address(0)]);
115     }
116 
117 
118     // ------------------------------------------------------------------------
119     // Get the token balance for account `tokenOwner`
120     // ------------------------------------------------------------------------
121     function balanceOf(address tokenOwner) public view returns (uint balance) {
122         return balances[tokenOwner];
123     }
124 
125 
126     // ------------------------------------------------------------------------
127     // Transfer the balance from token owner's account to `to` account
128     // - Owner's account must have sufficient balance to transfer
129     // - 0 value transfers are allowed
130     // ------------------------------------------------------------------------
131     function transfer(address to, uint tokens) public returns (bool success) {
132         balances[msg.sender] = balances[msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(msg.sender, to, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Token owner can approve for `spender` to transferFrom(...) `tokens`
141     // from the token owner's account
142     //
143     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
144     // recommends that there are no checks for the approval double-spend attack
145     // as this should be implemented in user interfaces 
146     // ------------------------------------------------------------------------
147     function approve(address spender, uint tokens) public returns (bool success) {
148         allowed[msg.sender][spender] = tokens;
149         emit Approval(msg.sender, spender, tokens);
150         return true;
151     }
152 
153 
154     // ------------------------------------------------------------------------
155     // Transfer `tokens` from the `from` account to the `to` account
156     // 
157     // The calling account must already have sufficient tokens approve(...)-d
158     // for spending from the `from` account and
159     // - From account must have sufficient balance to transfer
160     // - Spender must have sufficient allowance to transfer
161     // - 0 value transfers are allowed
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = balances[from].sub(tokens);
165         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
166         balances[to] = balances[to].add(tokens);
167         emit Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Returns the amount of tokens approved by the owner that can be
174     // transferred to the spender's account
175     // ------------------------------------------------------------------------
176     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
177         return allowed[tokenOwner][spender];
178     }
179 
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
193 
194     // ------------------------------------------------------------------------
195     // Don't accept ETH
196     // ------------------------------------------------------------------------
197     function () public payable {
198         revert();
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Owner can transfer out any accidentally sent ERC20 tokens
204     // ------------------------------------------------------------------------
205     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
206         return ERC20Interface(tokenAddress).transfer(owner, tokens);
207     }
208 }