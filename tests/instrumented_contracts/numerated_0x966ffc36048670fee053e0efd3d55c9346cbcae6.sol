1 pragma solidity ^0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 contract SafeMath {
7    function safeAdd(uint a, uint b) public pure returns (uint c) {
8        c = a + b;
9        require(c >= a);
10    }
11    function safeSub(uint a, uint b) public pure returns (uint c) {
12        require(b <= a);
13        c = a - b;
14    }
15    function safeMul(uint a, uint b) public pure returns (uint c) {
16        c = a * b;
17        require(a == 0 || c / a == b);
18    }
19    function safeDiv(uint a, uint b) public pure returns (uint c) {
20        require(b > 0);
21        c = a / b;
22    }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
28 // ----------------------------------------------------------------------------
29 contract ERC20Interface {
30    function totalSupply() public constant returns (uint);
31    function balanceOf(address tokenOwner) public constant returns (uint balance);
32    function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
33    function transfer(address to, uint tokens) public returns (bool success);
34    function burn(uint _tokens) public returns (bool success);
35    function approve(address spender, uint tokens) public returns (bool success);
36    function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38    event Transfer(address indexed from, address indexed to, uint tokens);
39    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 // ----------------------------------------------------------------------------
43 // Contract function to receive approval and execute function in one call
44 //
45 // Borrowed from MiniMeToken
46 // ----------------------------------------------------------------------------
47 contract ApproveAndCallFallBack {
48    function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
49 }
50 
51 // ----------------------------------------------------------------------------
52 // Owned contract
53 // ----------------------------------------------------------------------------
54 contract Owned {
55    address public owner;
56    address public newOwner;
57 
58    event OwnershipTransferred(address indexed _from, address indexed _to);
59 
60    constructor() public {
61        owner = msg.sender;
62    }
63 
64    modifier onlyOwner {
65        require(msg.sender == owner);
66        _;
67    }
68 
69    function transferOwnership(address _newOwner) public onlyOwner {
70        newOwner = _newOwner;
71    }
72    function acceptOwnership() public {
73        require(msg.sender == newOwner);
74        emit OwnershipTransferred(owner, newOwner);
75        owner = newOwner;
76        newOwner = address(0);
77    }
78 }
79 
80 // ----------------------------------------------------------------------------
81 // ERC20 Token, with the addition of symbol, name and decimals and assisted
82 // token transfers
83 // ----------------------------------------------------------------------------
84 contract USDSVToken is ERC20Interface, Owned, SafeMath {
85    string public symbol;
86    string public  name;
87    uint8 public decimals;
88    uint public _totalSupply;
89 
90    mapping(address => uint) balances;
91    mapping(address => mapping(address => uint)) allowed;
92 
93    // ------------------------------------------------------------------------
94    // Constructor
95    // ------------------------------------------------------------------------
96    constructor() public {
97        symbol = "USDSV";
98        name = "USD Satoshi Vision Token";
99        decimals = 18;
100        _totalSupply = 1000000000000000000000000000;
101        balances[msg.sender] = _totalSupply;
102        emit Transfer(address(0), msg.sender, _totalSupply);
103    }
104 
105    // ------------------------------------------------------------------------
106    // Total supply
107    // ------------------------------------------------------------------------
108    function totalSupply() public constant returns (uint) {
109        return _totalSupply  - balances[address(0)];
110    }
111 
112    // ------------------------------------------------------------------------
113    // Get the token balance for account tokenOwner
114    // ------------------------------------------------------------------------
115    function balanceOf(address tokenOwner) public constant returns (uint balance) {
116        return balances[tokenOwner];
117    }
118 
119    // ------------------------------------------------------------------------
120    // Transfer the balance from token owner's account to to account
121    // - Owner's account must have sufficient balance to transfer
122    // - 0 value transfers are allowed
123    // ------------------------------------------------------------------------
124    function transfer(address to, uint tokens) public returns (bool success) {
125        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
126        balances[to] = safeAdd(balances[to], tokens);
127        emit Transfer(msg.sender, to, tokens);
128        return true;
129    }
130    
131    // ------------------------------------------------------------------------
132    // Burn the balance from token owner's account to to account
133    // 
134    // 
135    // ------------------------------------------------------------------------
136    function burn(uint tokens) public returns (bool success) {
137        require(msg.sender == owner);
138        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
139        _totalSupply = safeSub(_totalSupply, tokens);
140        return true;
141    }
142    
143 
144    // ------------------------------------------------------------------------
145    // Token owner can approve for spender to transferFrom(...) tokens
146    // from the token owner's account
147    //
148    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149    // recommends that there are no checks for the approval double-spend attack
150    // as this should be implemented in user interfaces 
151    // ------------------------------------------------------------------------
152    function approve(address spender, uint _tokens) public returns (bool success) {
153        require(_tokens > 0);
154        require(_tokens <= balances[msg.sender]);
155        allowed[msg.sender][spender] = _tokens;
156        emit Approval(msg.sender, spender, _tokens);
157        return true;
158    }
159 
160    // ------------------------------------------------------------------------
161    // Transfer tokens from the from account to the to account
162    // 
163    // The calling account must already have sufficient tokens approve(...)-d
164    // for spending from the from account and
165    // - From account must have sufficient balance to transfer
166    // - Spender must have sufficient allowance to transfer
167    // - 0 value transfers are allowed
168    // ------------------------------------------------------------------------
169    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
170        balances[from] = safeSub(balances[from], tokens);
171        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
172        balances[to] = safeAdd(balances[to], tokens);
173        emit Transfer(from, to, tokens);
174        return true;
175    }
176 
177    // ------------------------------------------------------------------------
178    // Returns the amount of tokens approved by the owner that can be
179    // transferred to the spender's account
180    // ------------------------------------------------------------------------
181    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
182        return allowed[tokenOwner][spender];
183    }
184 
185    // ------------------------------------------------------------------------
186    // Token owner can approve for spender to transferFrom(...) tokens
187    // from the token owner's account. The spender contract function
188    // receiveApproval(...) is then executed
189    // ------------------------------------------------------------------------
190    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
191        allowed[msg.sender][spender] = tokens;
192        emit Approval(msg.sender, spender, tokens);
193        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
194        return true;
195    }
196 
197    // ------------------------------------------------------------------------
198    // Don't accept ETH
199    // ------------------------------------------------------------------------
200    function () public payable {
201        revert();
202    }
203 
204    // ------------------------------------------------------------------------
205    // Owner can transfer out any accidentally sent ERC20 tokens
206    // ------------------------------------------------------------------------
207    function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
208        return ERC20Interface(tokenAddress).transfer(owner, tokens);
209    }
210 }