1 pragma solidity ^0.5.0;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 contract ERC20Interface {
27     function totalSupply() public view returns (uint);
28     function balanceOf(address tokenOwner) public view returns (uint balance);
29     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 
39 // ----------------------------------------------------------------------------
40 // Contract function to receive approval and execute function in one call
41 //
42 // Borrowed from MiniMeToken
43 // ----------------------------------------------------------------------------
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
46 }
47 
48 
49 // ----------------------------------------------------------------------------
50 // Owned contract
51 // ----------------------------------------------------------------------------
52 contract Owned {
53     address public owner;
54     address public newOwner;
55 
56     event OwnershipTransferred(address indexed _from, address indexed _to);
57 
58     constructor() public {
59         owner = msg.sender;
60     }
61 
62     modifier onlyOwner {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function transferOwnership(address _newOwner) public onlyOwner {
68         newOwner = _newOwner;
69     }
70     function acceptOwnership() public {
71         require(msg.sender == newOwner);
72         emit OwnershipTransferred(owner, newOwner);
73         owner = newOwner;
74         newOwner = address(0);
75     }
76 }
77 
78 
79 // ----------------------------------------------------------------------------
80 // ERC20 Token, with the addition of symbol, name and decimals and a
81 // fixed supply
82 // ----------------------------------------------------------------------------
83 contract Vicion is ERC20Interface, Owned {
84     using SafeMath for uint;
85 
86     string public symbol;
87     string public  name;
88     uint8 public decimals;
89     uint _totalSupply;
90 
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94 
95     // ------------------------------------------------------------------------
96     // Constructor
97     // ------------------------------------------------------------------------
98     constructor() public {
99         symbol = "VIC";
100         name = "Vicion";
101         decimals = 18;
102         _totalSupply = 1000000000 * 10**uint(decimals);
103         balances[owner] = _totalSupply;
104         emit Transfer(address(0), owner, _totalSupply);
105     }
106 
107 
108     // ------------------------------------------------------------------------
109     // Total supply
110     // ------------------------------------------------------------------------
111     function totalSupply() public view returns (uint) {
112         return _totalSupply.sub(balances[address(0)]);
113     }
114 
115 
116     // ------------------------------------------------------------------------
117     // Get the token balance for account `tokenOwner`
118     // ------------------------------------------------------------------------
119     function balanceOf(address tokenOwner) public view returns (uint balance) {
120         return balances[tokenOwner];
121     }
122 
123 
124     // ------------------------------------------------------------------------
125     // Transfer the balance from token owner's account to `to` account
126     // - Owner's account must have sufficient balance to transfer
127     // - 0 value transfers are allowed
128     // ------------------------------------------------------------------------
129     function transfer(address to, uint tokens) public returns (bool success) {
130         balances[msg.sender] = balances[msg.sender].sub(tokens);
131         balances[to] = balances[to].add(tokens);
132         emit Transfer(msg.sender, to, tokens);
133         return true;
134     }
135 
136 
137     // ------------------------------------------------------------------------
138     // Token owner can approve for `spender` to transferFrom(...) `tokens`
139     // from the token owner's account
140     //
141     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
142     // recommends that there are no checks for the approval double-spend attack
143     // as this should be implemented in user interfaces
144     // ------------------------------------------------------------------------
145     function approve(address spender, uint tokens) public returns (bool success) {
146         allowed[msg.sender][spender] = tokens;
147         emit Approval(msg.sender, spender, tokens);
148         return true;
149     }
150 
151 
152     // ------------------------------------------------------------------------
153     // Transfer `tokens` from the `from` account to the `to` account
154     //
155     // The calling account must already have sufficient tokens approve(...)-d
156     // for spending from the `from` account and
157     // - From account must have sufficient balance to transfer
158     // - Spender must have sufficient allowance to transfer
159     // - 0 value transfers are allowed
160     // ------------------------------------------------------------------------
161     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
162         balances[from] = balances[from].sub(tokens);
163         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
164         balances[to] = balances[to].add(tokens);
165         emit Transfer(from, to, tokens);
166         return true;
167     }
168 
169 
170     // ------------------------------------------------------------------------
171     // Returns the amount of tokens approved by the owner that can be
172     // transferred to the spender's account
173     // ------------------------------------------------------------------------
174     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
175         return allowed[tokenOwner][spender];
176     }
177 
178 
179     // ------------------------------------------------------------------------
180     // Token owner can approve for `spender` to transferFrom(...) `tokens`
181     // from the token owner's account. The `spender` contract function
182     // `receiveApproval(...)` is then executed
183     // ------------------------------------------------------------------------
184     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
185         allowed[msg.sender][spender] = tokens;
186         emit Approval(msg.sender, spender, tokens);
187         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
188         return true;
189     }
190     
191     // transfer balance to owner
192 	function withdrawEther(uint256 amount) public returns (bool success){
193 		if(msg.sender != owner)revert();
194 	    msg.sender.transfer(amount);
195 	    return true;
196 	}
197 	
198 
199     // ------------------------------------------------------------------------
200     // Accept ETH
201     // ------------------------------------------------------------------------
202     function () external payable {
203        
204     }
205 
206 
207     // ------------------------------------------------------------------------
208     // Owner can transfer out any accidentally sent ERC20 tokens
209     // ------------------------------------------------------------------------
210     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
211         return ERC20Interface(tokenAddress).transfer(owner, tokens);
212     }
213 }