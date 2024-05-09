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
34 contract Owned {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     modifier onlyOwner {
41         require(msg.sender == owner);
42         _;
43     }
44 
45     function transferOwnership(address _newOwner) public onlyOwner {
46         newOwner = _newOwner;
47     }
48     function acceptOwnership() public {
49         require(msg.sender == newOwner);
50         emit OwnershipTransferred(owner, newOwner);
51         owner = newOwner;
52         newOwner = address(0);
53     }
54 }
55 
56 contract ERC20Token is ERC20Interface, Owned {
57     using SafeMath for uint;
58 
59     string public symbol;
60     string public  name;
61     uint8 public decimals;
62     uint _totalSupply;
63 
64     mapping(address => uint) balances;
65     mapping(address => mapping(address => uint)) allowed;
66 
67     constructor(string _name, string _symbol, uint8 _decimals, uint _supply, address _owner) public {
68         symbol = _symbol;
69         name = _name;
70         decimals = _decimals;
71         _totalSupply = _supply * 10**uint(decimals);
72         owner = _owner;
73         balances[owner] = _totalSupply;
74         emit Transfer(address(0), owner, _totalSupply);
75     }
76 
77     function totalSupply() public view returns (uint) {
78         return _totalSupply.sub(balances[address(0)]);
79     }
80 
81     function balanceOf(address tokenOwner) public view returns (uint balance) {
82         return balances[tokenOwner];
83     }
84 
85     function transfer(address to, uint tokens) public returns (bool success) {
86         balances[msg.sender] = balances[msg.sender].sub(tokens);
87         balances[to] = balances[to].add(tokens);
88         emit Transfer(msg.sender, to, tokens);
89         return true;
90     }
91 
92     function approve(address spender, uint tokens) public returns (bool success) {
93         allowed[msg.sender][spender] = tokens;
94         emit Approval(msg.sender, spender, tokens);
95         return true;
96     }
97 
98     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
99         balances[from] = balances[from].sub(tokens);
100         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
101         balances[to] = balances[to].add(tokens);
102         emit Transfer(from, to, tokens);
103         return true;
104     }
105 
106     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
107         return allowed[tokenOwner][spender];
108     }
109 
110     function () public payable {
111         revert();
112     }
113 
114     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
115         return ERC20Interface(tokenAddress).transfer(owner, tokens);
116     }
117 }
118 
119 contract ERC20TokenConstructor {
120     event ERC20TokenCreated(address contractAddress, address contractOwner);
121     
122     function createERC20Token(string _name, string _symbol, uint8 _decimals, uint _supply, address _owner) public {
123         ERC20Token ERC20 = new ERC20Token(_name, _symbol, _decimals, _supply, _owner);
124         emit ERC20TokenCreated(address(ERC20), _owner);
125     }
126 }