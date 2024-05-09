1 pragma solidity ^0.5.8;
2 
3 // Name        : Cryptotech Network
4 // Symbol      : CTN
5 // Total Supply: 21,000,000.000000000000000000
6 // Decimals    : 18
7 
8 library SafeMath {
9     function add(uint a, uint b) internal pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function sub(uint a, uint b) internal pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function mul(uint a, uint b) internal pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function div(uint a, uint b) internal pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 contract ERC20Interface {
28     function totalSupply() public view returns (uint);
29     function balanceOf(address tokenOwner) public view returns (uint balance);
30     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
31     function transfer(address to, uint tokens) public returns (bool success);
32     function approve(address spender, uint tokens) public returns (bool success);
33     function transferFrom(address from, address to, uint tokens) public returns (bool success);
34 
35     event Transfer(address indexed from, address indexed to, uint tokens);
36     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
37 }
38 
39 contract ApproveAndCallFallBack {
40     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
41 }
42 
43 contract Owned {
44     address public owner;
45     address public newOwner;
46 
47     event OwnershipTransferred(address indexed _from, address indexed _to);
48 
49     constructor() public {
50         owner = msg.sender;
51     }
52 
53     modifier onlyOwner {
54         require(msg.sender == owner);
55         _;
56     }
57 
58     function transferOwnership(address _newOwner) public onlyOwner {
59         newOwner = _newOwner;
60     }
61     function acceptOwnership() public {
62         require(msg.sender == newOwner);
63         emit OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65         newOwner = address(0);
66     }
67 }
68 
69 contract CryptotechNetworkToken is ERC20Interface, Owned {
70     using SafeMath for uint;
71 
72     string public symbol;
73     string public  name;
74     uint8 public decimals;
75     uint _totalSupply;
76 
77     mapping(address => uint) balances;
78     mapping(address => mapping(address => uint)) allowed;
79 
80     constructor() public {
81         symbol = "CTN";
82         name = "Cryptotech Network";
83         decimals = 18;
84         _totalSupply = 21000000 * 10**uint(decimals);
85         balances[owner] = _totalSupply;
86         emit Transfer(address(0), owner, _totalSupply);
87     }
88 
89     function totalSupply() public view returns (uint) {
90         return _totalSupply.sub(balances[address(0)]);
91     }
92 
93     function balanceOf(address tokenOwner) public view returns (uint balance) {
94         return balances[tokenOwner];
95     }
96 
97     function transfer(address to, uint tokens) public returns (bool success) {
98         balances[msg.sender] = balances[msg.sender].sub(tokens);
99         balances[to] = balances[to].add(tokens);
100         emit Transfer(msg.sender, to, tokens);
101         return true;
102     }
103 
104     function approve(address spender, uint tokens) public returns (bool success) {
105         allowed[msg.sender][spender] = tokens;
106         emit Approval(msg.sender, spender, tokens);
107         return true;
108     }
109 
110     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
111         balances[from] = balances[from].sub(tokens);
112         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(from, to, tokens);
115         return true;
116     }
117 
118     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
119         return allowed[tokenOwner][spender];
120     }
121 
122     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
123         allowed[msg.sender][spender] = tokens;
124         emit Approval(msg.sender, spender, tokens);
125         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
126         return true;
127     }
128 
129     function () external payable {
130         revert();
131     }
132 
133     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
134         return ERC20Interface(tokenAddress).transfer(owner, tokens);
135     }
136 }
137 
138 // @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
139 // © CRYPTOTECH 2018 https://cryptotech.network