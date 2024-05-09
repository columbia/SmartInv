1 pragma solidity ^0.4.24;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 // ----------------------------------------------------------------------------
25 // ERC Token Standard #20 Interface
26 // ----------------------------------------------------------------------------
27 contract ERC20Interface {
28     function totalSupply() public constant returns (uint);
29     function balanceOf(address tokenOwner) public constant returns (uint balance);
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 
40 // ----------------------------------------------------------------------------
41 // Contract function to receive approval and execute function in one call
42 // ----------------------------------------------------------------------------
43 contract ApproveAndCallFallBack {
44     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
45 }
46 
47 
48 // ----------------------------------------------------------------------------
49 // Owned contract
50 // ----------------------------------------------------------------------------
51 contract Owned {
52     address public owner;
53     address public newOwner;
54 
55     event OwnershipTransferred(address indexed _from, address indexed _to);
56 
57     constructor() public {
58         owner = msg.sender;
59     }
60 
61     modifier onlyOwner {
62         require(msg.sender == owner);
63         _;
64     }
65 
66     function transferOwnership(address _newOwner) public onlyOwner {
67         newOwner = _newOwner;
68     }
69     function acceptOwnership() public {
70         require(msg.sender == newOwner);
71         emit OwnershipTransferred(owner, newOwner);
72         owner = newOwner;
73         newOwner = address(0);
74     }
75 }
76 
77 
78 // ----------------------------------------------------------------------------
79 // ERC20 Token, with the addition of symbol, name and decimals and assisted
80 // token transfers
81 // ----------------------------------------------------------------------------
82 contract SodaCoin is ERC20Interface, Owned, SafeMath {
83     string public symbol;
84     string public  name;
85     uint8 public decimals;
86     uint public _totalSupply;
87 
88     mapping(address => uint) balances;
89     mapping(address => mapping(address => uint)) allowed;
90 
91 
92     // ------------------------------------------------------------------------
93     // Constructor
94     // ------------------------------------------------------------------------
95     constructor() public {
96         symbol = "SOC";
97         name = "SODA Coin";
98         decimals = 18;
99         _totalSupply = 2000000000000000000000000000;
100         balances[0xC713b7c600Bb0e70c2d4b466b923Cab1E45e7c76] = _totalSupply;
101         emit Transfer(address(0), 0xC713b7c600Bb0e70c2d4b466b923Cab1E45e7c76, _totalSupply);
102     }
103 
104 
105     // ------------------------------------------------------------------------
106     // Total supply
107     // ------------------------------------------------------------------------
108     function totalSupply() public constant returns (uint) {
109         return _totalSupply  - balances[address(0)];
110     }
111 
112 
113     // ------------------------------------------------------------------------
114     // Get the token balance for account tokenOwner
115     // ------------------------------------------------------------------------
116     function balanceOf(address tokenOwner) public constant returns (uint balance) {
117         return balances[tokenOwner];
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Transfer the balance from token owner's account to to account
123     // - Owner's account must have sufficient balance to transfer
124     // - 0 value transfers are allowed
125     // ------------------------------------------------------------------------
126     function transfer(address to, uint tokens) public returns (bool success) {
127         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
128         balances[to] = safeAdd(balances[to], tokens);
129         emit Transfer(msg.sender, to, tokens);
130         return true;
131     }
132 
133 
134     // ------------------------------------------------------------------------
135     // Token owner can approve for spender to transferFrom(...) tokens
136     // from the token owner's account
137     // ------------------------------------------------------------------------
138     function approve(address spender, uint tokens) public returns (bool success) {
139         allowed[msg.sender][spender] = tokens;
140         emit Approval(msg.sender, spender, tokens);
141         return true;
142     }
143 
144 
145     // ------------------------------------------------------------------------
146     // Transfer tokens from the from account to the to account
147     // 
148     // The calling account must already have sufficient tokens approve(...)-d
149     // for spending from the from account and
150     // - From account must have sufficient balance to transfer
151     // - Spender must have sufficient allowance to transfer
152     // - 0 value transfers are allowed
153     // ------------------------------------------------------------------------
154     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
155         balances[from] = safeSub(balances[from], tokens);
156         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
157         balances[to] = safeAdd(balances[to], tokens);
158         emit Transfer(from, to, tokens);
159         return true;
160     }
161 
162 
163     // ------------------------------------------------------------------------
164     // Returns the amount of tokens approved by the owner that can be
165     // transferred to the spender's account
166     // ------------------------------------------------------------------------
167     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
168         return allowed[tokenOwner][spender];
169     }
170 
171 
172     // ------------------------------------------------------------------------
173     // Token owner can approve for spender to transferFrom(...) tokens
174     // from the token owner's account. The spender contract function
175     // receiveApproval(...) is then executed
176     // ------------------------------------------------------------------------
177     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
178         allowed[msg.sender][spender] = tokens;
179         emit Approval(msg.sender, spender, tokens);
180         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
181         return true;
182     }
183 
184 
185     // ------------------------------------------------------------------------
186     // Don't accept ETH
187     // ------------------------------------------------------------------------
188     function () public payable {
189         revert();
190     }
191 
192 
193     // ------------------------------------------------------------------------
194     // Owner can transfer out any accidentally sent ERC20 tokens
195     // ------------------------------------------------------------------------
196     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
197         return ERC20Interface(tokenAddress).transfer(owner, tokens);
198     }
199     // Increase issuance.
200 	function totalSupplyIncrease(uint256 _supply) public onlyOwner{
201 		_totalSupply = _totalSupply + _supply;
202 		balances[msg.sender] = balances[msg.sender] + _supply;
203 	}
204 }