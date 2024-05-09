1 pragma solidity 0.7.1;
2 
3 // ----------------------------------------------------------------------------
4 // TBCC token main contract (2020) 
5 //
6 // Symbol       : TBCC
7 // Name         : TBCC
8 // Total supply : 2.000.000.000
9 // Decimals     : 18
10 // ----------------------------------------------------------------------------
11 // SPDX-License-Identifier: MIT
12 // ----------------------------------------------------------------------------
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) { c = a + b; require(c >= a); }
16     function sub(uint a, uint b) internal pure returns (uint c) { require(b <= a); c = a - b; }
17     function mul(uint a, uint b) internal pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); }
18     function div(uint a, uint b) internal pure returns (uint c) { require(b > 0); c = a / b; }
19 }
20 
21 abstract contract ERC20Interface {
22     function totalSupply() public virtual view returns (uint);
23     function balanceOf(address tokenOwner) public virtual view returns (uint balance);
24     function allowance(address tokenOwner, address spender) public virtual view returns (uint remaining);
25     function transfer(address to, uint tokens) public virtual returns (bool success);
26     function approve(address spender, uint tokens) public virtual returns (bool success);
27     function transferFrom(address from, address to, uint tokens) public virtual returns (bool success);
28 
29     event Transfer(address indexed from, address indexed to, uint tokens);
30     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
31 }
32 
33 abstract contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint tokens, address token, bytes memory data) public virtual;
35 }
36 
37 contract Owned {
38     address public owner;
39     address public newOwner;
40 
41     event OwnershipTransferred(address indexed from, address indexed to);
42 
43     constructor() {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address transferOwner) public onlyOwner {
53         require(transferOwner != newOwner);
54         newOwner = transferOwner;
55     }
56 
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 // ----------------------------------------------------------------------------
66 // TBCC ERC20 Token 
67 // ----------------------------------------------------------------------------
68 contract TBCC is ERC20Interface, Owned {
69     using SafeMath for uint;
70 
71     bool public running = true;
72     string public symbol;
73     string public name;
74     uint8 public decimals;
75     uint _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     constructor() {
81         symbol = "TBCC";
82         name = "TBCC";
83         decimals = 18;
84         _totalSupply = 2000000000 * 10**uint(decimals);
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89     modifier isRunning {
90         require(running);
91         _;
92     }
93 
94     function startStop () public onlyOwner returns (bool success) {
95         if (running) { running = false; } else { running = true; }
96         return true;
97     }
98 
99     function totalSupply() public override  view returns (uint) {
100         return _totalSupply;
101     }
102 
103     function balanceOf(address tokenOwner) public override view returns (uint balance) {
104         return balances[tokenOwner];
105     }
106 
107     function transfer(address to, uint tokens) public override isRunning returns (bool success) {
108         require(tokens <= balances[msg.sender]);
109         require(to != address(0));
110         _transfer(msg.sender, to, tokens);
111         return true;
112     }
113 
114     function _transfer(address from, address to, uint256 tokens) internal {
115         balances[from] = balances[from].sub(tokens);
116         balances[to] = balances[to].add(tokens);
117         emit Transfer(from, to, tokens);
118     }
119 
120     function approve(address spender, uint tokens) public override isRunning returns (bool success) {
121         _approve(msg.sender, spender, tokens);
122         return true;
123     }
124 
125     function increaseAllowance(address spender, uint addedTokens) public isRunning returns (bool success) {
126         _approve(msg.sender, spender, allowed[msg.sender][spender].add(addedTokens));
127         return true;
128     }
129 
130     function decreaseAllowance(address spender, uint subtractedTokens) public isRunning returns (bool success) {
131         _approve(msg.sender, spender, allowed[msg.sender][spender].sub(subtractedTokens));
132         return true;
133     }
134 
135     function approveAndCall(address spender, uint tokens, bytes memory data) public isRunning returns (bool success) {
136         _approve(msg.sender, spender, tokens);
137         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
138         return true;
139     }
140 
141     function _approve(address owner, address spender, uint256 value) internal {
142         require(owner != address(0));
143         require(spender != address(0));
144         allowed[owner][spender] = value;
145         emit Approval(owner, spender, value);
146     }
147 
148     function transferFrom(address from, address to, uint tokens) public override isRunning returns (bool success) {
149         require(to != address(0));
150         _approve(from, msg.sender, allowed[from][msg.sender].sub(tokens));
151         _transfer(from, to, tokens);
152         return true;
153     }
154 
155     function allowance(address tokenOwner, address spender) public override view returns (uint remaining) {
156         return allowed[tokenOwner][spender];
157     }
158 
159     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
160         return ERC20Interface(tokenAddress).transfer(owner, tokens);
161     }
162     
163     function burnTokens(uint tokens) public returns (bool success) {
164         require(tokens <= balances[msg.sender]);
165         balances[msg.sender] = balances[msg.sender].sub(tokens);
166         _totalSupply = _totalSupply.sub(tokens);
167         emit Transfer(msg.sender, address(0), tokens);
168         return true;
169     }
170 
171     function multisend(address[] memory to, uint[] memory values) public onlyOwner returns (uint) {
172         require(to.length == values.length);
173         require(to.length < 100);
174         uint sum;
175         for (uint j; j < values.length; j++) {
176             sum += values[j];
177         }
178         balances[owner] = balances[owner].sub(sum);
179         for (uint i; i < to.length; i++) {
180             balances[to[i]] = balances[to[i]].add(values[i]);
181             emit Transfer(owner, to[i], values[i]);
182         }
183         return(to.length);
184     }
185 }