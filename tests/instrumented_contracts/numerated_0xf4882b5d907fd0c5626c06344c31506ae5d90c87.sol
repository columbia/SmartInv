1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function add(uint a, uint b) internal pure returns (uint c) {
5         c = a + b;
6         require(c >= a);
7     }
8 
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13 
14     function mul(uint a, uint b) internal pure returns (uint c) {
15         c = a * b;
16         require(a == 0 || c / a == b);
17     }
18 
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 contract ERC20Interface {
26     function totalSupply() public constant returns (uint);
27     function balanceOf(address tokenOwner) public constant returns (uint balance);
28     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
29     function transfer(address to, uint tokens) public returns (bool success);
30     function approve(address spender, uint tokens) public returns (bool success);
31     function transferFrom(address from, address to, uint tokens) public returns (bool success);
32 
33     event Transfer(address indexed from, address indexed to, uint tokens);
34     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
35 }
36 
37 contract ApproveAndCallFallBack {
38     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39 }
40 
41 contract Owned {
42     address public owner;
43     address public newOwner;
44 
45     event OwnershipTransferred(address indexed _from, address indexed _to);
46 
47     constructor() public {
48         owner = msg.sender;
49     }
50 
51     modifier onlyOwner {
52         require(msg.sender == owner);
53         _;
54     }
55 
56     function transferOwnership(address _newOwner) public onlyOwner {
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public {
61         require(msg.sender == newOwner);
62         emit OwnershipTransferred(owner, newOwner);
63         owner = newOwner;
64         newOwner = address(0);
65     }
66 }
67 
68 contract Masacoin is ERC20Interface, Owned {
69 
70     using SafeMath for uint;
71     string public constant symbol = "MASA";
72     string public constant name = "Masacoin";
73     uint8 public constant decimals = 18;
74     uint _totalSupply = 100000000 * 10**uint(decimals);
75 
76     mapping(address => uint) balances;
77     mapping(address => mapping(address => uint)) allowed;
78 
79 	
80     constructor() public {
81         balances[owner] = _totalSupply;
82         emit Transfer(address(0), owner, _totalSupply);
83     }
84 
85     function totalSupply() public view returns (uint) {
86         return _totalSupply.sub(balances[address(0)]);
87     }
88 
89     function balanceOf(address tokenOwner) public view returns (uint balance) {
90         return balances[tokenOwner];
91     }
92 	
93 	function _burn(address account, uint256 value) internal {
94 		require(account != address(0));
95 
96 		_totalSupply = _totalSupply.sub(value);
97 		balances[account] = balances[account].sub(value);
98 		emit Transfer(account, address(0), value);
99 	}
100 	
101 	function burn(uint256 value) public {
102 		_burn(msg.sender, value);
103 	}
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