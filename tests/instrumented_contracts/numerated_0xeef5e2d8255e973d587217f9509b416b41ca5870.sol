1 pragma solidity ^0.5.4;
2 
3 // ----------------------------------------------------------------------------
4 // 'XEENUS' 'Xeenus 💪' token contract with a faucet minting for testing
5 //
6 // Send an 0 value transaction with no data to mint 1,000 new tokens
7 //
8 // Symbol      : XEENUS
9 // Name        : Xeenus 💪
10 // Total supply: 1,000,000.000000000000000000 + faucet minting
11 // Decimals    : 18
12 // Deployed to : Mainnet 0xeEf5E2d8255E973d587217f9509B416b41CA5870
13 //
14 //
15 // Enjoy.
16 //
17 // (c) BokkyPooBah / Bok Consulting Pty Ltd 2019. The MIT Licence.
18 // ----------------------------------------------------------------------------
19 
20 
21 // ----------------------------------------------------------------------------
22 // Safe maths
23 // ----------------------------------------------------------------------------
24 library SafeMath {
25     function add(uint a, uint b) internal pure returns (uint c) {
26         c = a + b;
27         require(c >= a);
28     }
29     function sub(uint a, uint b) internal pure returns (uint c) {
30         require(b <= a);
31         c = a - b;
32     }
33     function mul(uint a, uint b) internal pure returns (uint c) {
34         c = a * b;
35         require(a == 0 || c / a == b);
36     }
37     function div(uint a, uint b) internal pure returns (uint c) {
38         require(b > 0);
39         c = a / b;
40     }
41 }
42 
43 
44 // ----------------------------------------------------------------------------
45 // ERC Token Standard #20 Interface
46 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
47 // ----------------------------------------------------------------------------
48 contract ERC20Interface {
49     function totalSupply() public view returns (uint);
50     function balanceOf(address tokenOwner) public view returns (uint balance);
51     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
52     function transfer(address to, uint tokens) public returns (bool success);
53     function approve(address spender, uint tokens) public returns (bool success);
54     function transferFrom(address from, address to, uint tokens) public returns (bool success);
55 
56     event Transfer(address indexed from, address indexed to, uint tokens);
57     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
58 }
59 
60 
61 // ----------------------------------------------------------------------------
62 // Contract function to receive approval and execute function in one call
63 // ----------------------------------------------------------------------------
64 contract ApproveAndCallFallBack {
65     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
66 }
67 
68 
69 // ----------------------------------------------------------------------------
70 // Owned contract
71 // ----------------------------------------------------------------------------
72 contract Owned {
73     address public owner;
74     address public newOwner;
75 
76     event OwnershipTransferred(address indexed _from, address indexed _to);
77 
78     constructor() public {
79         owner = msg.sender;
80     }
81 
82     modifier onlyOwner {
83         require(msg.sender == owner);
84         _;
85     }
86 
87     function transferOwnership(address _newOwner) public onlyOwner {
88         newOwner = _newOwner;
89     }
90     function acceptOwnership() public {
91         require(msg.sender == newOwner);
92         emit OwnershipTransferred(owner, newOwner);
93         owner = newOwner;
94         newOwner = address(0);
95     }
96 }
97 
98 
99 // ----------------------------------------------------------------------------
100 // ERC20 Token, with the addition of symbol, name and decimals and a
101 // fixed supply
102 // ----------------------------------------------------------------------------
103 contract XeenusToken is ERC20Interface, Owned {
104     using SafeMath for uint;
105 
106     string public symbol;
107     string public  name;
108     uint8 public decimals;
109     uint _totalSupply;
110     uint _drop;
111 
112     mapping(address => uint) balances;
113     mapping(address => mapping(address => uint)) allowed;
114 
115     constructor() public {
116         symbol = "XEENUS";
117         name = "Xeenus 💪";
118         decimals = 18;
119         _totalSupply = 1000000 * 10**uint(decimals);
120         _drop = 1000 * 10**uint(decimals);
121         balances[owner] = _totalSupply;
122         emit Transfer(address(0), owner, _totalSupply);
123     }
124     function totalSupply() public view returns (uint) {
125         return _totalSupply.sub(balances[address(0)]);
126     }
127     function balanceOf(address tokenOwner) public view returns (uint balance) {
128         return balances[tokenOwner];
129     }
130     function transfer(address to, uint tokens) public returns (bool success) {
131         balances[msg.sender] = balances[msg.sender].sub(tokens);
132         balances[to] = balances[to].add(tokens);
133         emit Transfer(msg.sender, to, tokens);
134         return true;
135     }
136     function approve(address spender, uint tokens) public returns (bool success) {
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender, spender, tokens);
139         return true;
140     }
141     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
142         balances[from] = balances[from].sub(tokens);
143         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
144         balances[to] = balances[to].add(tokens);
145         emit Transfer(from, to, tokens);
146         return true;
147     }
148     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
152         allowed[msg.sender][spender] = tokens;
153         emit Approval(msg.sender, spender, tokens);
154         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
155         return true;
156     }
157     function mint(address tokenOwner, uint tokens) internal returns (bool success) {
158         balances[tokenOwner] = balances[tokenOwner].add(tokens);
159         _totalSupply = _totalSupply.add(tokens);
160         emit Transfer(address(0), tokenOwner, tokens);
161         return true;
162     }
163     function drip() public {
164         mint(msg.sender, _drop);
165     }
166 
167     function () external payable {
168         mint(msg.sender, _drop);
169         if (msg.value > 0) {
170             msg.sender.transfer(msg.value);
171         }
172     }
173     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
174         return ERC20Interface(tokenAddress).transfer(owner, tokens);
175     }
176 }