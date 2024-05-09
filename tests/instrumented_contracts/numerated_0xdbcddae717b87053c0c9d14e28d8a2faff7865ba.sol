1 pragma solidity ^0.5.7;
2 
3 // ----------------------------------------------------------------------------
4 // 'Sincerity' token contract
5 //
6 // Symbol      : XXX
7 // Name        : XXXname
8 // Total supply: xxxxxxx
9 // Decimals    : xx
10 //
11 // ----------------------------------------------------------------------------
12 // Safe maths
13 // ----------------------------------------------------------------------------
14 contract SafeMath {
15     function safeAdd(uint a, uint b) public pure returns (uint c) {
16         c = a + b;
17         require(c >= a, "Addition failed");
18     }
19     function safeSub(uint a, uint b) public pure returns (uint c) {
20         require(b <= a, "Subtraction failed");
21         c = a - b;
22     }
23     function safeMul(uint a, uint b) public pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function safeDiv(uint a, uint b) public pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 
34 contract ERC20Interface {
35     function totalSupply() public view returns (uint);
36     function balanceOf(address tokenOwner) public view returns (uint balance);
37     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 
47 contract ApproveAndCallFallBack {
48     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
49 }
50 
51 
52 // ----------------------------------------------------------------------------
53 // Owned contract
54 // ----------------------------------------------------------------------------
55 contract Owned {
56     address public owner;
57     address public newOwner;
58 
59     event OwnershipTransferred(address indexed _from, address indexed _to);
60 
61     constructor() public {
62         owner = msg.sender;
63     }
64 
65     modifier onlyOwner {
66         require(msg.sender == owner);
67         _;
68     }
69 
70     function transferOwnership(address _newOwner) public onlyOwner {
71         newOwner = _newOwner;
72     }
73     function acceptOwnership() public {
74         require(msg.sender == newOwner);
75         emit OwnershipTransferred(owner, newOwner);
76         owner = newOwner;
77         newOwner = address(0);
78     }
79 }
80 
81 
82 // ----------------------------------------------------------------------------
83 // ERC20 Token, with the addition of symbol, name and decimals and assisted
84 // token transfers
85 // ----------------------------------------------------------------------------
86 contract RidsCoin is ERC20Interface, Owned, SafeMath {
87     string public symbol;
88     string public  name;
89     uint public decimals;
90     uint public _totalSupply;
91 
92     mapping(address => uint) balances;
93     mapping(address => mapping(address => uint)) allowed;
94     
95     mapping(uint => string) scripts;
96 
97 
98 
99     // ------------------------------------------------------------------------
100     // Constructor
101     // ------------------------------------------------------------------------
102     constructor(string memory _symbol,string memory _name,
103             uint _decimals,uint totalSupply) public {
104         symbol = _symbol;
105         name = _name;
106         decimals = _decimals;
107         _totalSupply = totalSupply * 10**decimals;
108         balances[msg.sender] = _totalSupply;
109         emit Transfer(address(0), msg.sender, _totalSupply);
110     }
111     
112      function isContract(address _addr) public view returns(bool){
113         uint32 size;
114         assembly{
115             size := extcodesize(_addr)
116         }
117         return (size > 0);
118     }   
119 
120     function totalSupply() public view returns (uint) {
121         return _totalSupply  - balances[address(0)];
122     }
123 
124     function balanceOf(address tokenOwner) public view returns (uint balance) {
125         return balances[tokenOwner];
126     }
127 
128     function transfer(address to, uint tokens) public returns (bool success) {
129         
130         require(balances[msg.sender] >= tokens, "Sender doesn't have enough tokens");
131         require(!isContract(to) && to != address(0), "To address cannot be contract address or zero address");
132         
133         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
134         balances[to] = safeAdd(balances[to], tokens);
135         emit Transfer(msg.sender, to, tokens);
136         return true;
137     }
138 
139 
140     function approve(address spender, uint tokens) public returns (bool success) {
141         
142         require(balances[msg.sender] >= tokens, "Sender doesn't have enough tokens");
143         require(!isContract(spender) && spender != address(0), "To address cannot be contract address or zero address");
144         
145         allowed[msg.sender][spender] = tokens;
146         emit Approval(msg.sender, spender, tokens);
147         return true;
148     }
149 
150 
151     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
152         
153         require(balances[from] >= tokens, "From doesn't have enough tokens");
154         require(allowed[from][msg.sender] >= tokens, "You are not approved tokens");
155         require(!isContract(to) && to != address(0), "To address cannot be contract address or zero address");
156 
157         
158         balances[from] = safeSub(balances[from], tokens);
159         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
160         balances[to] = safeAdd(balances[to], tokens);
161         emit Transfer(from, to, tokens);
162         return true;
163     }
164 
165 
166     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
167         return allowed[tokenOwner][spender];
168     }
169 
170 
171     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
172         allowed[msg.sender][spender] = tokens;
173         emit Approval(msg.sender, spender, tokens);
174         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
175         return true;
176     }
177     
178     
179     function getScript(uint id) public view returns(string memory) {
180         return scripts[id];
181     }
182     
183     function setScript(uint id, string memory url) public {
184         scripts[id] = url;
185     }
186    
187     
188     // ------------------------------------------------------------------------
189     // Don't accept ETH
190     // ------------------------------------------------------------------------
191     function () external payable {
192         revert();
193     }
194 
195 
196     // ------------------------------------------------------------------------
197     // Owner can transfer out any accidentally sent ERC20 tokens
198     // ------------------------------------------------------------------------
199     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
200         return ERC20Interface(tokenAddress).transfer(owner, tokens);
201     }
202    
203     function destruct() onlyOwner public{
204         selfdestruct(msg.sender);
205     }
206 }