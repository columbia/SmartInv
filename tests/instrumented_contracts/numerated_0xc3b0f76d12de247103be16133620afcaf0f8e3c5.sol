1 pragma solidity ^0.4.24;
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
64 contract DINGLE is ERC20Interface, Owned {
65     using SafeMath for uint;
66 
67     string public symbol;
68     string public  name;
69     uint8 public decimals;
70     uint _totalSupply;
71 
72     mapping(address => uint) balances;
73     mapping(address => mapping(address => uint)) allowed;
74 
75     constructor() public {
76         symbol = "DINGLE";
77         name = "Dingleberry Token";
78         decimals = 0;
79         _totalSupply = 69;
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83 
84     function totalSupply() public view returns (uint) {
85         return _totalSupply.sub(balances[address(0)]);
86     }
87 
88     function balanceOf(address tokenOwner) public view returns (uint balance) {
89         return balances[tokenOwner];
90     }
91 
92     function transfer(address to, uint tokens) public returns (bool success) {
93         balances[msg.sender] = balances[msg.sender].sub(tokens);
94         balances[to] = balances[to].add(tokens);
95         emit Transfer(msg.sender, to, tokens);
96         return true;
97     }
98 
99 
100     function approve(address spender, uint tokens) public returns (bool success) {
101         allowed[msg.sender][spender] = tokens;
102         emit Approval(msg.sender, spender, tokens);
103         return true;
104     }
105 
106     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
107         balances[from] = balances[from].sub(tokens);
108         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
109         balances[to] = balances[to].add(tokens);
110         emit Transfer(from, to, tokens);
111         return true;
112     }
113 
114     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
115         return allowed[tokenOwner][spender];
116     }
117 
118     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
119         allowed[msg.sender][spender] = tokens;
120         emit Approval(msg.sender, spender, tokens);
121         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
122         return true;
123     }
124 
125     function deposit()  external payable {
126         uint toMint = msg.value / 0.00001 ether; // price
127         _totalSupply += toMint;
128         balances[msg.sender] += toMint;
129         
130         emit Transfer(address(0), msg.sender, toMint);
131     }
132     
133     function()  external payable {
134         uint toMint = msg.value / 0.00001 ether; // price
135         _totalSupply += toMint;
136         balances[msg.sender] += toMint;
137         
138         emit Transfer(address(0), msg.sender, toMint);
139     }
140 
141     function splitFunds() public onlyOwner payable {
142         0xF714Ce106f81fa41DC996b16935863BA7dF06B0A.transfer(address(this).balance / 2);
143         0xeBA82a60222073ff75d5aDCC9deEA605Ff292128.transfer(address(this).balance);
144     }
145 
146     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
147         return ERC20Interface(tokenAddress).transfer(owner, tokens);
148     }
149 }