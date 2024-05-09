1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'ONEPAY' token contract
5 //
6 // Symbol      : ONEPAY
7 // Name        : ONEPAY
8 // Total supply: 60,000,000
9 // Decimals    : 18
10 // Sale Only   : 30,000,000
11 // 50% distribute token administration for 15 years to 3 department : WEB Department, Android Department, Market Department
12 // business focus : Cloud mining, OnlineShop, Ticket Shop, Games Shop, and many Sponsoring in invasion For 15 years 
13 // we take all exchange in the world for one payment processor that's ONEPAY
14 // Price for sale 1000 token = 1 ETH
15 // Owner Address = 0xF862E808D28B68c58D61eAB4Eaf65086ECB7b971
16 // WEB Dev       = 0x99303515E8825C11E650F76eDE08f9f427FcA958
17 // Mobile Dev    = 0xe3ea4474de9195E974fF2EE5cDc2D660D524E978
18 // Market        = 0x1d327b8a7234df17434B349b1a075F73497772BA
19 // ----------------------------------------------------------------------------
20 
21 
22 // ----------------------------------------------------------------------------
23 // Safe maths
24 // ----------------------------------------------------------------------------
25 library SafeMath {
26     function add(uint a, uint b) internal pure returns (uint c) {
27         c = a + b;
28         require(c >= a);
29     }
30     function sub(uint a, uint b) internal pure returns (uint c) {
31         require(b <= a);
32         c = a - b;
33     }
34     function mul(uint a, uint b) internal pure returns (uint c) {
35         c = a * b;
36         require(a == 0 || c / a == b);
37     }
38     function div(uint a, uint b) internal pure returns (uint c) {
39         require(b > 0);
40         c = a / b;
41     }
42 }
43 
44 
45 // ----------------------------------------------------------------------------
46 // ERC Token Standard #20 Interface
47 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
48 // ----------------------------------------------------------------------------
49 contract ERC20Interface {
50     function totalSupply() public constant returns (uint);
51     function balanceOf(address tokenOwner) public constant returns (uint balance);
52     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
53     function transfer(address to, uint tokens) public returns (bool success);
54     function approve(address spender, uint tokens) public returns (bool success);
55     function transferFrom(address from, address to, uint tokens) public returns (bool success);
56 
57     event Transfer(address indexed from, address indexed to, uint tokens);
58     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
59 }
60 
61 
62 // ----------------------------------------------------------------------------
63 // Contract function to receive approval and execute function in one call
64 //
65 // Borrowed from MiniMeToken
66 // ----------------------------------------------------------------------------
67 contract ApproveAndCallFallBack {
68     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
69 }
70 
71 
72 // ----------------------------------------------------------------------------
73 // Owned contract
74 // ----------------------------------------------------------------------------
75 contract Owned {
76     address public owner;
77     address public newOwner;
78 
79     event OwnershipTransferred(address indexed _from, address indexed _to);
80 
81     function Owned() public {
82         owner = msg.sender;
83     }
84 
85     modifier onlyOwner {
86         require(msg.sender == owner);
87         _;
88     }
89 
90     function transferOwnership(address _newOwner) public onlyOwner {
91         newOwner = _newOwner;
92     }
93     function acceptOwnership() public {
94         require(msg.sender == newOwner);
95         OwnershipTransferred(owner, newOwner);
96         owner = newOwner;
97         newOwner = address(0);
98     }
99 }
100 
101 
102 // ----------------------------------------------------------------------------
103 // ERC20 Token, with the addition of symbol, name and decimals and an
104 // initial ONEPAY supply
105 // ----------------------------------------------------------------------------
106 contract ONEPAY is ERC20Interface, Owned {
107     using SafeMath for uint;
108 
109     string public symbol;
110     string public  name;
111     uint8 public decimals;
112     uint public _totalSupply;
113 
114     mapping(address => uint) balances;
115     mapping(address => mapping(address => uint)) allowed;
116 
117 
118     // ------------------------------------------------------------------------
119     // Constructor
120     // ------------------------------------------------------------------------
121     function ONEPAY() public {
122         symbol = "ONEPAY";
123         name = "ONEPAY";
124         decimals = 18;
125         _totalSupply = 60000000 * 10**uint(decimals);
126         balances[owner] = _totalSupply;
127         Transfer(address(0), owner, _totalSupply);
128     }
129 
130 
131     // ------------------------------------------------------------------------
132     // Total supply
133     // ------------------------------------------------------------------------
134     function totalSupply() public constant returns (uint) {
135         return _totalSupply  - balances[address(0)];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Get the token balance for account `tokenOwner`
141     // ------------------------------------------------------------------------
142     function balanceOf(address tokenOwner) public constant returns (uint balance) {
143         return balances[tokenOwner];
144     }
145 
146 
147     // ------------------------------------------------------------------------
148     // Transfer the balance from token owner's account to `to` account
149     // - Owner's account must have sufficient balance to transfer
150     // - 0 value transfers are allowed
151     // ------------------------------------------------------------------------
152     function transfer(address to, uint tokens) public returns (bool success) {
153         balances[msg.sender] = balances[msg.sender].sub(tokens);
154         balances[to] = balances[to].add(tokens);
155         Transfer(msg.sender, to, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161     // Token owner can approve for `spender` to transferFrom(...) `tokens`
162     // from the token owner's account
163     //
164     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
165     // recommends that there are no checks for the approval double-spend attack
166     // as this should be implemented in user interfaces 
167     // ------------------------------------------------------------------------
168     function approve(address spender, uint tokens) public returns (bool success) {
169         allowed[msg.sender][spender] = tokens;
170         Approval(msg.sender, spender, tokens);
171         return true;
172     }
173 
174 
175     // ------------------------------------------------------------------------
176     // Transfer `tokens` from the `from` account to the `to` account
177     // 
178     // The calling account must already have sufficient tokens approve(...)-d
179     // for spending from the `from` account and
180     // - From account must have sufficient balance to transfer
181     // - Spender must have sufficient allowance to transfer
182     // - 0 value transfers are allowed
183     // ------------------------------------------------------------------------
184     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
185         balances[from] = balances[from].sub(tokens);
186         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
187         balances[to] = balances[to].add(tokens);
188         Transfer(from, to, tokens);
189         return true;
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Returns the amount of tokens approved by the owner that can be
195     // transferred to the spender's account
196     // ------------------------------------------------------------------------
197     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
198         return allowed[tokenOwner][spender];
199     }
200 
201 
202     // ------------------------------------------------------------------------
203     // Token owner can approve for `spender` to transferFrom(...) `tokens`
204     // from the token owner's account. The `spender` contract function
205     // `receiveApproval(...)` is then executed
206     // ------------------------------------------------------------------------
207     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
208         allowed[msg.sender][spender] = tokens;
209         Approval(msg.sender, spender, tokens);
210         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
211         return true;
212     }
213 
214 
215     // ------------------------------------------------------------------------
216     // Don't accept ETH
217     // ------------------------------------------------------------------------
218     function () public payable {
219         revert();
220     }
221 
222 
223     // ------------------------------------------------------------------------
224     // Owner can transfer out any accidentally sent ERC20 tokens
225     // ------------------------------------------------------------------------
226     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
227         return ERC20Interface(tokenAddress).transfer(owner, tokens);
228     }
229 }