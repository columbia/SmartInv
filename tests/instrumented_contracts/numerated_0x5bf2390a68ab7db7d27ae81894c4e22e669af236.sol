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
22 // ----------------------------------------------------------------------------
23 // ERC Token Standard #20 Interface
24 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
25 // ----------------------------------------------------------------------------
26 contract ERC20Interface {
27     function totalSupply() public constant returns (uint);
28     function balanceOf(address tokenOwner) public constant returns (uint balance);
29     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
30     function transfer(address to, uint tokens) public returns (bool success);
31     function approve(address spender, uint tokens) public returns (bool success);
32     function transferFrom(address from, address to, uint tokens) public returns (bool success);
33 
34     event Transfer(address indexed from, address indexed to, uint tokens);
35     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36 }
37 
38 // ----------------------------------------------------------------------------
39 contract Owned {
40     address public owner;
41     address public newOwner;
42 
43     event OwnershipTransferred(address indexed _from, address indexed _to);
44 
45     constructor() public {
46         owner = msg.sender;
47     }
48 
49     modifier onlyOwner {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     function transferOwnership(address _newOwner) public onlyOwner {
55         newOwner = _newOwner;
56     }
57     function acceptOwnership() public {
58         require(msg.sender == newOwner);
59         emit OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61         newOwner = address(0);
62     }
63 }
64 
65 // ----------------------------------------------------------------------------
66 contract CoffeeToken is ERC20Interface, Owned {
67     using SafeMath for uint;
68 
69     string public symbol;
70     string public  name;
71     uint8 public decimals;
72     uint _totalSupply;
73 
74     mapping(address => uint) balances;
75     mapping(address => mapping(address => uint)) allowed;
76 
77     constructor() public {
78         symbol = "CFT";
79         name = "Coffee Token";
80         decimals = 18;
81         _totalSupply = 7000000 * 10**uint(decimals);
82         balances[owner] = _totalSupply;
83         emit Transfer(address(0), owner, _totalSupply);
84     }
85 
86     function () public payable {
87         revert();
88     }
89 
90     function totalSupply() public view returns (uint) {
91         return _totalSupply.sub(balances[address(0)]);
92     }
93 
94     function balanceOf(address tokenOwner) public view returns (uint balance) {
95         return balances[tokenOwner];
96     }
97 
98     function transfer(address to, uint tokens) public returns (bool success) {
99         balances[msg.sender] = balances[msg.sender].sub(tokens);
100         balances[to] = balances[to].add(tokens);
101         emit Transfer(msg.sender, to, tokens);
102         return true;
103     }
104 
105     function approve(address spender, uint tokens) public returns (bool success) {
106         allowed[msg.sender][spender] = tokens;
107         emit Approval(msg.sender, spender, tokens);
108         return true;
109     }
110 
111     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
112         balances[from] = balances[from].sub(tokens);
113         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
114         balances[to] = balances[to].add(tokens);
115         emit Transfer(from, to, tokens);
116         return true;
117     }
118 
119     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
120         return allowed[tokenOwner][spender];
121     }
122 
123     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
124         return ERC20Interface(tokenAddress).transfer(owner, tokens);
125     }
126 }