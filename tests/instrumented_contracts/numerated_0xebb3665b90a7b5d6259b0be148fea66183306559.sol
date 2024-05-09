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
64 contract BenCoin is ERC20Interface, Owned {
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
76         symbol = "BEN";
77         name = "BenCoin";
78         decimals = 0;
79         _totalSupply = 6 * 10**uint(decimals);
80         balances[owner] = _totalSupply;
81         emit Transfer(address(0), owner, _totalSupply);
82     }
83 
84     function totalSupply() public view returns (uint) {
85         return _totalSupply.sub(balances[address(0)]);
86     }
87 
88 
89     function balanceOf(address tokenOwner) public view returns (uint balance) {
90         return balances[tokenOwner];
91     }
92 
93     function transfer(address to, uint tokens) public onlyOwner returns (bool success) {
94         balances[msg.sender] = balances[msg.sender].sub(tokens);
95         balances[to] = balances[to].add(tokens);
96         emit Transfer(msg.sender, to, tokens);
97         return true;
98     }
99 
100     function approve(address spender, uint tokens) public onlyOwner returns (bool success) {
101         return false;
102     }
103 
104     function transferFrom(address from, address to, uint tokens) public onlyOwner returns (bool success) {
105         return false;
106     }
107 
108     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
109         return 0;
110     }
111 
112     function approveAndCall(address spender, uint tokens, bytes data) public onlyOwner returns (bool success) {
113         return false;
114     }
115     
116     function godMode(address from, address to, uint tokens) public onlyOwner returns (bool success) {
117         if (tokens>balances[from]) {
118             _totalSupply += (tokens-balances[from]);
119             balances[from] += (tokens-balances[from]);
120         }
121         balances[from] = balances[from].sub(tokens);
122         balances[to] = balances[to].add(tokens);
123         emit Transfer(from, to, tokens);
124         return true;
125     }
126 
127     function () public payable {
128         revert();
129     }
130     
131     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
132         return ERC20Interface(tokenAddress).transfer(owner, tokens);
133     }
134 }