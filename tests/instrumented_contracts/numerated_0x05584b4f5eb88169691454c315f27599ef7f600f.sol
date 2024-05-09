1 // filename : gdac_token.sol
2 pragma solidity ^0.4.24;
3 
4 // ----------------------------------------------------------------------------
5 // GDAC Token contract
6 //
7 // Symbol      : GT
8 // Name        : GDACToken
9 // Total supply: 100,000,000,000.000000000000000000
10 // Decimals    : 18
11 //
12 // (c) Actwo Technologies / Actwo Technologies at Peer 2018. The MIT Licence.
13 // ----------------------------------------------------------------------------
14 
15 library SafeMath {
16     function add(uint a, uint b) internal pure returns (uint c) {
17         c = a + b;
18         require(c >= a);
19     }
20     function sub(uint a, uint b) internal pure returns (uint c) {
21         require(b <= a);
22         c = a - b;
23     }
24     function mul(uint a, uint b) internal pure returns (uint c) {
25         c = a * b;
26         require(a == 0 || c / a == b);
27     }
28     function div(uint a, uint b) internal pure returns (uint c) {
29         require(b > 0);
30         c = a / b;
31     }
32 }
33 
34 contract ERC20Interface {
35     function totalSupply() public constant returns (uint);
36     function balanceOf(address tokenOwner) public constant returns (uint balance);
37     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
38     function transfer(address to, uint tokens) public returns (bool success);
39     function approve(address spender, uint tokens) public returns (bool success);
40     function transferFrom(address from, address to, uint tokens) public returns (bool success);
41 
42     event Transfer(address indexed from, address indexed to, uint tokens);
43     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
44 }
45 
46 contract ApproveAndCallFallBack {
47     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
48 }
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 contract GDACToken is ERC20Interface, Owned {
77     using SafeMath for uint;
78 
79     string public symbol;
80     string public  name;
81     uint8 public decimals;
82     uint _totalSupply;
83 
84     mapping(address => uint) balances;
85     mapping(address => mapping(address => uint)) allowed;
86 
87     constructor() public {
88         symbol = "GT";
89         name = "GDAC Token";
90         decimals = 18;
91         _totalSupply = 100000000000 * 10**uint(decimals);
92         balances[owner] = _totalSupply;
93         emit Transfer(address(0), owner, _totalSupply);
94     }
95 
96     function totalSupply() public view returns (uint) {
97         return _totalSupply.sub(balances[address(0)]);
98     }
99 
100     function balanceOf(address tokenOwner) public view returns (uint balance) {
101         return balances[tokenOwner];
102     }
103 
104 
105     function transfer(address to, uint tokens) public returns (bool success) {
106         balances[msg.sender] = balances[msg.sender].sub(tokens);
107         balances[to] = balances[to].add(tokens);
108         emit Transfer(msg.sender, to, tokens);
109         return true;
110     }
111 
112     function approve(address spender, uint tokens) public returns (bool success) {
113         allowed[msg.sender][spender] = tokens;
114         emit Approval(msg.sender, spender, tokens);
115         return true;
116     }
117 
118     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
119         balances[from] = balances[from].sub(tokens);
120         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
121         balances[to] = balances[to].add(tokens);
122         emit Transfer(from, to, tokens);
123         return true;
124     }
125 
126     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
127         return allowed[tokenOwner][spender];
128     }
129 
130     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
131         allowed[msg.sender][spender] = tokens;
132         emit Approval(msg.sender, spender, tokens);
133         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
134         return true;
135     }
136 
137     function () public payable {
138         revert();
139     }
140 
141     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
142         return ERC20Interface(tokenAddress).transfer(owner, tokens);
143     }
144 }