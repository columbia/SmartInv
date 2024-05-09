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
26 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
27 // ----------------------------------------------------------------------------
28 contract ERC20Interface {
29     function totalSupply() public view returns (uint);
30     function balanceOf(address tokenOwner) public view returns (uint balance);
31     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
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
51 contract Owned {
52     address public owner;
53     // address public newOwner;
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
66     // function transferOwnership(address _newOwner) public onlyOwner {
67     //     newOwner = _newOwner;
68     // }
69 
70     // function acceptOwnership() public {
71     //     require(msg.sender == newOwner);
72     //     emit OwnershipTransferred(owner, newOwner);
73     //     owner = newOwner;
74     //     newOwner = address(0);
75     // }
76 }
77 
78 
79 contract VXV is ERC20Interface, Owned, SafeMath {
80     string public symbol;
81     string public name;
82     uint8 public decimals;
83     uint public totalSupply;
84     uint public rate;
85 
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88 
89     constructor() public {
90         symbol = "VXV";
91         name = "VectorspaceAI";
92         decimals = 18;
93         totalSupply = 50000000 * 10 ** uint256(decimals);
94         rate = 203;
95         balances[owner] = totalSupply;
96         emit Transfer(address(0), owner, totalSupply);
97     }
98 
99     function changeRate(uint newRate) public onlyOwner {
100         require(newRate > 0);
101         rate = newRate;
102     }
103 
104     function totalSupply() public view returns (uint) {
105         return totalSupply - balances[address(0)];
106     }
107 
108     function balanceOf(address tokenOwner) public view returns (uint balance) {
109         return balances[tokenOwner];
110     }
111 
112     modifier validTo(address to) {
113         require(to != address(0));
114         require(to != address(this));
115         _;
116     }
117 
118     function transferInternal(address from, address to, uint tokens) internal {
119         balances[from] = safeSub(balances[from], tokens);
120         balances[to] = safeAdd(balances[to], tokens);
121         emit Transfer(from, to, tokens);
122     }
123 
124     function transfer(address to, uint tokens) public validTo(to) returns (bool success) {
125         transferInternal(msg.sender, to, tokens);
126         return true;
127     }
128 
129     // ------------------------------------------------------------------------
130     // Transfer `tokens` from the `from` account to the `to` account
131     //
132     // The calling account must already have sufficient tokens approve(...)-d
133     // for spending from the `from` account and
134     // - From account must have sufficient balance to transfer
135     // - Spender must have sufficient allowance to transfer
136     // - 0 value transfers are allowed
137     // ------------------------------------------------------------------------
138     function transferFrom(address from, address to, uint tokens) public validTo(to) returns (bool success) {
139         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
140         transferInternal(from, to, tokens);
141         return true;
142     }
143 
144     // ------------------------------------------------------------------------
145     // Token owner can approve for `spender` to transferFrom(...) `tokens`
146     // from the token owner's account
147     //
148     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
149     // recommends that there are no checks for the approval double-spend attack
150     // as this should be implemented in user interfaces
151     // ------------------------------------------------------------------------
152     function approve(address spender, uint tokens) public returns (bool success) {
153         allowed[msg.sender][spender] = tokens;
154         emit Approval(msg.sender, spender, tokens);
155         return true;
156     }
157 
158     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
159         return allowed[tokenOwner][spender];
160     }
161 
162     // ------------------------------------------------------------------------
163     // Token owner can approve for `spender` to transferFrom(...) `tokens`
164     // from the token owner's account. The `spender` contract function
165     // `receiveApproval(...)` is then executed
166     // ------------------------------------------------------------------------
167     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
168         if (approve(spender, tokens)) {
169             ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
170             return true;
171         }
172     }
173 
174     function () public payable {
175         uint tokens;
176         tokens = safeMul(msg.value, rate);
177 
178         balances[owner] = safeSub(balances[owner], tokens);
179         balances[msg.sender] = safeAdd(balances[msg.sender], tokens);
180 
181         emit Transfer(address(0), msg.sender, tokens);
182         owner.transfer(msg.value);
183     }
184 
185     // ------------------------------------------------------------------------
186     // Owner can transfer out any accidentally sent ERC20 tokens
187     // ------------------------------------------------------------------------
188     // function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
189     //     return ERC20Interface(tokenAddress).transfer(owner, tokens);
190     // }
191 }