1 pragma solidity ^0.4.18;
2 
3 // ----------------------------------------------------------------------------
4 // 'BithubCommunityToken' token contract
5 //
6 // Symbol      : BHCx
7 // Name        : BithubCommunity Token
8 // Total supply: 1,000,000,000
9 // Decimals    : 18
10 
11 
12 
13 // ----------------------------------------------------------------------------
14 // Safe maths
15 // ----------------------------------------------------------------------------
16 contract SafeMath {
17     function safeAdd(uint a, uint b) public pure returns (uint c) {
18         c = a + b;
19         require(c >= a);
20     }
21     function safeSub(uint a, uint b) public pure returns (uint c) {
22         require(b <= a);
23         c = a - b;
24     }
25     function safeMul(uint a, uint b) public pure returns (uint c) {
26         c = a * b;
27         require(a == 0 || c / a == b);
28     }
29     function safeDiv(uint a, uint b) public pure returns (uint c) {
30         require(b > 0);
31         c = a / b;
32     }
33 }
34 
35 
36 // ----------------------------------------------------------------------------
37 // ERC Token Standard #20 Interface
38 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
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
54 
55 // ----------------------------------------------------------------------------
56 contract ApproveAndCallFallBack {
57     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Owned contract
63 // ----------------------------------------------------------------------------
64 contract Owned {
65     address public owner;
66     address public newOwner;
67 
68     event OwnershipTransferred(address indexed _from, address indexed _to);
69 
70     function Owned() public {
71         owner = msg.sender;
72     }
73 
74     modifier onlyOwner {
75         require(msg.sender == owner);
76         _;
77     }
78   function transferOwnership(address _newOwner) public onlyOwner {
79         newOwner = _newOwner;
80     }
81     function acceptOwnership() public {
82         require(msg.sender == newOwner);
83         OwnershipTransferred(owner, newOwner);
84         owner = newOwner;
85         newOwner = address(0);
86     }
87 }
88 
89 
90 // ----------------------------------------------------------------------------
91 
92 // ----------------------------------------------------------------------------
93 contract BithubCommunityToken is ERC20Interface, Owned, SafeMath {
94     string public symbol;
95     string public  name;
96     uint8 public decimals;
97     uint public _totalSupply;
98     uint public startDate;
99     uint public bonusEnds;
100     uint public endDate;
101 
102     mapping(address => uint) balances;
103     mapping(address => mapping(address => uint)) allowed;
104 
105 
106     // ------------------------------------------------------------------------
107 
108     // ------------------------------------------------------------------------
109     function BithubCommunityToken() public {
110         symbol = "BHCx";
111         name = "Bithubcommunity Token";
112         decimals = 18;
113         _totalSupply = 1000000000000000000000000000;
114         balances[0xbfde0299a76e9437df7242d090c73ba709834ba5] = 734750000000000000000000000;
115         Transfer(address(0), 0xbfde0299a76e9437df7242d090c73ba709834ba5, 734750000000000000000000000);
116     
117          bonusEnds = now + 9 weeks;
118         endDate = now + 14 weeks;
119         
120     }
121 
122 
123     // ------------------------------------------------------------------------
124 
125     // ------------------------------------------------------------------------
126     function totalSupply() public constant returns (uint) {
127         return _totalSupply  - balances[address(0)];
128     }
129 
130 
131     // ------------------------------------------------------------------------
132 
133     // ------------------------------------------------------------------------
134     function balanceOf(address tokenOwner) public constant returns (uint balance) {
135         return balances[tokenOwner];
136     }
137 
138 
139     // ------------------------------------------------------------------------
140 
141     // ------------------------------------------------------------------------
142     function transfer(address to, uint tokens) public returns (bool success) {
143         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
144         balances[to] = safeAdd(balances[to], tokens);
145         Transfer(msg.sender, to, tokens);
146         return true;
147     }
148 
149 
150     // ------------------------------------------------------------------------
151 
152     // ------------------------------------------------------------------------
153     function approve(address spender, uint tokens) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         Approval(msg.sender, spender, tokens);
156         return true;
157     }
158 
159 
160     // ------------------------------------------------------------------------
161    
162     // ------------------------------------------------------------------------
163     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
164         balances[from] = safeSub(balances[from], tokens);
165         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
166         balances[to] = safeAdd(balances[to], tokens);
167         Transfer(from, to, tokens);
168         return true;
169     }
170 
171 
172     // ------------------------------------------------------------------------
173 
174     // ------------------------------------------------------------------------
175     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
176         return allowed[tokenOwner][spender];
177     }
178 
179 
180     // ------------------------------------------------------------------------
181   
182     // ------------------------------------------------------------------------
183     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
184         allowed[msg.sender][spender] = tokens;
185         Approval(msg.sender, spender, tokens);
186         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
187         return true;
188     }
189 
190 
191     // ------------------------------------------------------------------------
192     // 100,000 BHCx Tokens per 1 ETH
193     // ------------------------------------------------------------------------
194     function () public payable {
195         require(now >= startDate && now <= endDate);
196         uint tokens;
197         if (now <= bonusEnds) {
198             tokens = msg.value *  130000; //30% Bonus
199         } else {
200             tokens = msg.value *  115000; //15% Bonus
201         }
202         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
203         Transfer(address(0), msg.sender, tokens);
204         owner.transfer(msg.value);
205     }
206 
207 
208     // ------------------------------------------------------------------------
209     // Owner can transfer out any accidentally sent ERC20 tokens
210     // ------------------------------------------------------------------------
211     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
212         return ERC20Interface(tokenAddress).transfer(owner, tokens);
213     }
214 }