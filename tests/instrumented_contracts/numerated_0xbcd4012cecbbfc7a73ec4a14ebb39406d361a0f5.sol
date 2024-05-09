1 pragma solidity ^0.4.21;
2  
3 contract SafeMath {
4     function safeAdd(uint a, uint b) public pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function safeMul(uint a, uint b) public pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function safeDiv(uint a, uint b) public pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27 
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29 
30     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31 
32     function transfer(address to, uint tokens) public returns (bool success);
33 
34     function approve(address spender, uint tokens) public returns (bool success);
35 
36     function transferFrom(address from, address to, uint tokens) public returns (bool success);
37 
38     event Transfer(address indexed from, address indexed to, uint tokens);
39     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
40 }
41 
42 contract ApproveAndCallFallBack {
43     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
44 }
45 
46 contract Owned {
47     address public owner;
48     address public newOwner;
49 
50     event OwnershipTransferred(address indexed _from, address indexed _to);
51 
52     function Owned() public {
53         owner = msg.sender;
54     }
55 
56     modifier onlyOwner {
57         require(msg.sender == owner);
58         _;
59     }
60 
61     function transferOwnership(address _newOwner) public onlyOwner {
62         newOwner = _newOwner;
63     }
64 
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 
73 contract Lockable is Owned {
74     bool public isLocked = false;
75     
76     modifier checkLock(address from) {
77         require(!isLocked || from == owner);
78         _;
79     }
80     
81     function lock() public onlyOwner returns (bool success) {
82         isLocked = true;
83 
84         return true;
85     }
86     function unLock() public onlyOwner returns (bool success) {
87         isLocked = false;
88 
89         return true;
90     }
91 }
92 
93 contract DreamToken is ERC20Interface, Owned, Lockable, SafeMath {
94     string public symbol;
95     string public name;
96     uint8 public decimals;
97     uint public totalSupply;
98     uint public maxSupply;
99     
100     mapping(address => uint) balances;
101     mapping(address => mapping(address => uint)) allowed;
102 
103     function DreamToken() public {
104         symbol = "DREAM";
105         name = "Dream";
106         decimals = 8;
107         maxSupply = 21000000 * 10**8;
108         totalSupply = maxSupply;
109         balances[msg.sender] = maxSupply;
110     }
111 
112     function totalSupply() public constant returns (uint) {
113         return totalSupply - balances[address(0)];
114     }
115 
116     function balanceOf(address tokenOwner) public constant returns (uint balance) {
117         return balances[tokenOwner];
118     }
119 
120     // ------------------------------------------------------------------------
121     // Transfer the balance from token owner's account to to account
122     // - Owner's account must have sufficient balance to transfer
123     // - 0 value transfers are allowed
124     // ------------------------------------------------------------------------
125     function transfer(address to, uint tokens) public checkLock(msg.sender) returns (bool success) {
126         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
127         balances[to] = safeAdd(balances[to], tokens);
128         emit Transfer(msg.sender, to, tokens);
129         return true;
130     }
131 
132     // ------------------------------------------------------------------------
133     // Token owner can approve for spender to transferFrom(...) tokens
134     // from the token owner's account
135     //
136     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
137     // recommends that there are no checks for the approval double-spend attack
138     // as this should be implemented in user interfaces
139     // ------------------------------------------------------------------------
140     function approve(address spender, uint tokens) public returns (bool success) {
141         allowed[msg.sender][spender] = tokens;
142         emit Approval(msg.sender, spender, tokens);
143         return true;
144     }
145 
146     // ------------------------------------------------------------------------
147     // Transfer tokens from the from account to the to account
148     //
149     // The calling account must already have sufficient tokens approve(...)-d
150     // for spending from the from account and
151     // - From account must have sufficient balance to transfer
152     // - Spender must have sufficient allowance to transfer
153     // - 0 value transfers are allowed
154     // ------------------------------------------------------------------------
155     function transferFrom(address from, address to, uint tokens) public checkLock(from) returns (bool success) {
156         balances[from] = safeSub(balances[from], tokens);
157         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
158         balances[to] = safeAdd(balances[to], tokens);
159         emit Transfer(from, to, tokens);
160         return true;
161     }
162 
163     // ------------------------------------------------------------------------
164     // Returns the amount of tokens approved by the owner that can be
165     // transferred to the spender's account
166     // ------------------------------------------------------------------------
167     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
168         return allowed[tokenOwner][spender];
169     }
170 
171     // ------------------------------------------------------------------------
172     // Token owner can approve for spender to transferFrom(...) tokens
173     // from the token owner's account. The spender contract function
174     // receiveApproval(...) is then executed
175     // ------------------------------------------------------------------------
176     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
177         allowed[msg.sender][spender] = tokens;
178         emit Approval(msg.sender, spender, tokens);
179         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
180         return true;
181     }
182 
183     // ------------------------------------------------------------------------
184     // Don't accept ETH
185     // ------------------------------------------------------------------------
186     function() public payable {
187         revert();
188     }
189 
190     // ------------------------------------------------------------------------
191     // Owner can transfer out any accidentally sent ERC20 tokens
192     // ------------------------------------------------------------------------
193     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
194         return ERC20Interface(tokenAddress).transfer(owner, tokens);
195     }
196 }