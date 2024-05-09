1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // ⚙️'name' token contract, onLEXpa.com (onLEXpa)
5 //
6 // Deployed to : 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4
7 // Symbol      : onLEXpa.com
8 // Name        : onLEXpa
9 // Total supply: 586000000.000000000000000000
10 // Decimals    : 18
11 //
12 // 💶Exciting Opportunity:
13 // 🌐onLEXpa.com is specialized in the development of Online Courses and Projects!
14 
15 // 👉Forget About Countries Borders:
16 //Our goal is to make education around the world more and more accessible through blockchain technology!
17 
18 // 👉Our achievements:
19 //onLEXpa.com is leader on the European market for Online Learning!
20 
21 // 🧐see our site for more information: www.onLEXpa.com by / (c) Online Lex Partners LTD™️
22 // ----------------------------------------------------------------------------
23 
24 // ----------------------------------------------------------------------------
25 // Safe maths
26 // ----------------------------------------------------------------------------
27 contract SafeMath {
28     function safeAdd(uint a, uint b) public pure returns (uint c) {
29         c = a + b;
30         require(c >= a);
31     }
32     function safeSub(uint a, uint b) public pure returns (uint c) {
33         require(b <= a);
34         c = a - b;
35     }
36     function safeMul(uint a, uint b) public pure returns (uint c) {
37         c = a * b;
38         require(a == 0 || c / a == b);
39     }
40     function safeDiv(uint a, uint b) public pure returns (uint c) {
41         require(b > 0);
42         c = a / b;
43     }
44 }
45 
46 
47 // ----------------------------------------------------------------------------
48 // ERC Token Standard #20 Interface
49 // ----------------------------------------------------------------------------
50 contract ERC20Interface {
51     function totalSupply() public constant returns (uint);
52     function balanceOf(address tokenOwner) public constant returns (uint balance);
53     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
54     function transfer(address to, uint tokens) public returns (bool success);
55     function approve(address spender, uint tokens) public returns (bool success);
56     function transferFrom(address from, address to, uint tokens) public returns (bool success);
57 
58     event Transfer(address indexed from, address indexed to, uint tokens);
59     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
60 }
61 
62 
63 // ----------------------------------------------------------------------------
64 // Contract function to receive approval and execute function in one call
65 //
66 // Borrowed from MiniMeToken
67 // ----------------------------------------------------------------------------
68 contract ApproveAndCallFallBack {
69     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
70 }
71 
72 
73 // ----------------------------------------------------------------------------
74 // Owned contract
75 // ----------------------------------------------------------------------------
76 contract Owned {
77     address public owner;
78     address public newOwner;
79 
80     event OwnershipTransferred(address indexed _from, address indexed _to);
81 
82     function Owned() public {
83         owner = msg.sender;
84     }
85 
86     modifier onlyOwner {
87         require(msg.sender == owner);
88         _;
89     }
90 
91     function transferOwnership(address _newOwner) public onlyOwner {
92         newOwner = _newOwner;
93     }
94     function acceptOwnership() public {
95         require(msg.sender == newOwner);
96         OwnershipTransferred(owner, newOwner);
97         owner = newOwner;
98         newOwner = address(0);
99     }
100 }
101 
102 
103 // ----------------------------------------------------------------------------
104 // ERC20 Token, with the addition of symbol, name and decimals and assisted
105 // token transfers
106 // ----------------------------------------------------------------------------
107 contract onLEXpa is ERC20Interface, Owned, SafeMath {
108     string public symbol;
109     string public  name;
110     uint8 public decimals;
111     uint public _totalSupply;
112 
113     mapping(address => uint) balances;
114     mapping(address => mapping(address => uint)) allowed;
115 
116 
117     // ------------------------------------------------------------------------
118     // Constructor
119     // ------------------------------------------------------------------------
120     function onLEXpa () public {
121         symbol = "onLEXpa.com";
122         name = "onLEXpa";
123         decimals = 18;
124         _totalSupply = 586000000000000000000000000;
125         balances[0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4] = _totalSupply; //MEW address here
126         Transfer(address(0), 0xed0b26224D4629264B02f994Dcc4375DA3e6F9e4, _totalSupply);//MEW address here
127     }
128 
129 
130     // ------------------------------------------------------------------------
131     // Total supply
132     // ------------------------------------------------------------------------
133     function totalSupply() public constant returns (uint) {
134         return _totalSupply  - balances[address(0)];
135     }
136 
137 
138     // ------------------------------------------------------------------------
139     // Get the token balance for account tokenOwner
140     // ------------------------------------------------------------------------
141     function balanceOf(address tokenOwner) public constant returns (uint balance) {
142         return balances[tokenOwner];
143     }
144 
145 
146     // ------------------------------------------------------------------------
147     // Transfer the balance from token owner's account to to account
148     // - Owner's account must have sufficient balance to transfer
149     // - 0 value transfers are allowed
150     // ------------------------------------------------------------------------
151     function transfer(address to, uint tokens) public returns (bool success) {
152         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
153         balances[to] = safeAdd(balances[to], tokens);
154         Transfer(msg.sender, to, tokens);
155         return true;
156     }
157 
158 
159     // ------------------------------------------------------------------------
160     // Token owner can approve for spender to transferFrom(...) tokens
161     // from the token owner's account
162     //
163     // recommends that there are no checks for the approval double-spend attack
164     // as this should be implemented in user interfaces 
165     // ------------------------------------------------------------------------
166     function approve(address spender, uint tokens) public returns (bool success) {
167         allowed[msg.sender][spender] = tokens;
168         Approval(msg.sender, spender, tokens);
169         return true;
170     }
171 
172 
173     // ------------------------------------------------------------------------
174     // Transfer tokens from the from account to the to account
175     // 
176     // The calling account must already have sufficient tokens approve(...)-d
177     // for spending from the from account and
178     // - From account must have sufficient balance to transfer
179     // - Spender must have sufficient allowance to transfer
180     // - 0 value transfers are allowed
181     // ------------------------------------------------------------------------
182     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
183         balances[from] = safeSub(balances[from], tokens);
184         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
185         balances[to] = safeAdd(balances[to], tokens);
186         Transfer(from, to, tokens);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // Returns the amount of tokens approved by the owner that can be
193     // transferred to the spender's account
194     // ------------------------------------------------------------------------
195     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
196         return allowed[tokenOwner][spender];
197     }
198 
199 
200     // ------------------------------------------------------------------------
201     // Token owner can approve for spender to transferFrom(...) tokens
202     // from the token owner's account. The spender contract function
203     // receiveApproval(...) is then executed
204     // ------------------------------------------------------------------------
205     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
206         allowed[msg.sender][spender] = tokens;
207         Approval(msg.sender, spender, tokens);
208         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
209         return true;
210     }
211 
212 
213     // ------------------------------------------------------------------------
214     // Don't accept ETH
215     // ------------------------------------------------------------------------
216     function () public payable {
217         revert();
218     }
219 
220 
221     // ------------------------------------------------------------------------
222     // Owner can transfer out any accidentally sent ERC20 tokens
223     // ------------------------------------------------------------------------
224     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
225         return ERC20Interface(tokenAddress).transfer(owner, tokens);
226     }
227 }