1 pragma solidity 0.4.25;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8     function sub(uint a, uint b) internal pure returns (uint c) {
9         require(b <= a);
10         c = a - b;
11     }
12     function mul(uint a, uint b) internal pure returns (uint c) {
13         c = a * b;
14         require(a == 0 || c / a == b);
15     }
16     function div(uint a, uint b) internal pure returns (uint c) {
17         require(b > 0);
18         c = a / b;
19     }
20 }
21 
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract ApproveAndCallFallBack {
35     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
36 }
37 
38 contract Owned {
39     address public owner;
40     address public newOwner;
41 
42     event OwnershipTransferred(address indexed _from, address indexed _to);
43 
44     constructor() public {
45         owner = msg.sender;
46     }
47 
48     modifier onlyOwner {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     function transferOwnership(address _newOwner) public onlyOwner {
54         newOwner = _newOwner;
55     }
56     function acceptOwnership() public {
57         require(msg.sender == newOwner);
58         emit OwnershipTransferred(owner, newOwner);
59         owner = newOwner;
60         newOwner = address(0);
61     }
62 }
63 
64 contract AICoin is ERC20Interface, Owned {
65     using SafeMath for uint;
66 
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint public _totalSupply;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     constructor() public {
76         symbol = "AIC";
77         name = "AICoin";
78         decimals = 18;
79         _totalSupply = 210000000 * 10**uint(decimals);
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83 
84     function totalSupply() public constant returns (uint) {
85         return _totalSupply  - balances[address(0)];
86     }
87 
88     function balanceOf(address tokenOwner) public constant returns (uint balance) {
89         return balances[tokenOwner];
90     }
91 
92 
93     // ------------------------------------------------------------------------
94     // Transfer the balance from token owner's account to `to` account
95     // - Owner's account must have sufficient balance to transfer
96     // - 0 value transfers are allowed
97     // ------------------------------------------------------------------------
98     function transfer(address to, uint tokens) public returns (bool success) {
99         balances[msg.sender] = balances[msg.sender].sub(tokens);
100         balances[to] = balances[to].add(tokens);
101        emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105 
106     // ------------------------------------------------------------------------
107     // Token owner can approve for `spender` to transferFrom(...) `tokens`
108     // from the token owner's account
109     //
110     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
111     // recommends that there are no checks for the approval double-spend attack
112     // as this should be implemented in user interfaces
113     // ------------------------------------------------------------------------
114     function approve(address spender, uint tokens) public returns (bool success) {
115         allowed[msg.sender][spender] = tokens;
116         emit Approval(msg.sender, spender, tokens);
117         return true;
118     }
119 
120 
121     // ------------------------------------------------------------------------
122     // Transfer `tokens` from the `from` account to the `to` account
123     //
124     // The calling account must already have sufficient tokens approve(...)-d
125     // for spending from the `from` account and
126     // - From account must have sufficient balance to transfer
127     // - Spender must have sufficient allowance to transfer
128     // - 0 value transfers are allowed
129     // ------------------------------------------------------------------------
130     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
131         balances[from] = balances[from].sub(tokens);
132         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
133         balances[to] = balances[to].add(tokens);
134         emit Transfer(from, to, tokens);
135         return true;
136     }
137 
138 
139     // ------------------------------------------------------------------------
140     // Returns the amount of tokens approved by the owner that can be
141     // transferred to the spender's account
142     // ------------------------------------------------------------------------
143     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
144         return allowed[tokenOwner][spender];
145     }
146 
147 
148     // ------------------------------------------------------------------------
149     // Token owner can approve for `spender` to transferFrom(...) `tokens`
150     // from the token owner's account. The `spender` contract function
151     // `receiveApproval(...)` is then executed
152     // ------------------------------------------------------------------------
153     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
154         allowed[msg.sender][spender] = tokens;
155         emit Approval(msg.sender, spender, tokens);
156         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
157         return true;
158     }
159 
160 
161     // ------------------------------------------------------------------------
162     // Don't accept ETH
163     // ------------------------------------------------------------------------
164     function () public payable {
165         revert();
166     }
167 
168 
169     // ------------------------------------------------------------------------
170     // Owner can transfer out any accidentally sent ERC20 tokens
171     // ------------------------------------------------------------------------
172     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
173         return ERC20Interface(tokenAddress).transfer(owner, tokens);
174     }
175 }