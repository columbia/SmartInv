1 pragma solidity ^0.5.0;
2 
3 
4 library SafeMath {
5     function add(uint a, uint b) internal pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function sub(uint a, uint b) internal pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function mul(uint a, uint b) internal pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function div(uint a, uint b) internal pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 
23 
24 contract ERC20Interface {
25     function totalSupply() public view returns (uint);
26     function balanceOf(address tokenOwner) public view returns (uint balance);
27     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
28     function transfer(address to, uint tokens) public returns (bool success);
29     function approve(address spender, uint tokens) public returns (bool success);
30     function transferFrom(address _from, address to, uint tokens) public returns (bool success);
31 
32     event Transfer(address indexed from, address indexed to, uint tokens);
33     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
34 
35 
36 }
37 
38 
39 contract UnicaCoin is ERC20Interface {
40     using SafeMath for uint;
41 
42     string public symbol;
43     string public  name;
44     uint8 public decimals;
45     uint _totalSupply;
46 
47     mapping(address => uint) balances;
48     mapping(address => mapping(address => uint)) allowed;
49 
50 
51 
52     constructor() public {
53         symbol = "UNI";
54         name = "Unica Coin";
55         decimals = 18;
56         _totalSupply = 50000000000 * 10**uint(decimals);
57         balances[msg.sender] = _totalSupply;
58     }
59 
60 
61 
62     function totalSupply() public view returns (uint) {
63         return _totalSupply.sub(balances[address(0)]);
64     }
65     
66  
67     function balanceOf(address tokenOwner) public view returns (uint balance) {
68         return balances[tokenOwner];
69     }
70 
71 
72 
73     function transfer(address to, uint tokens) public returns (bool success) {
74         require(balances[msg.sender] >= tokens);
75         
76         balances[msg.sender] = balances[msg.sender].sub(tokens);
77         balances[to] = balances[to].add(tokens);
78         emit Transfer(msg.sender, to, tokens);
79         return true;
80     }
81 
82 
83     function approve(address spender, uint tokens) public returns (bool success) {
84         allowed[msg.sender][spender] = tokens;
85         emit Approval(msg.sender, spender, tokens);
86         return true;
87     }
88 
89 
90    
91     function transferFrom(address _from, address to, uint tokens) public returns (bool success) {
92         require(tokens <= balances[_from]);
93         require(tokens <= allowed[_from][msg.sender]);
94         
95         balances[_from] = balances[_from].sub(tokens);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(tokens);
97         balances[to] = balances[to].add(tokens);
98         emit Transfer(_from, to, tokens);
99         return true;
100     }
101 
102 
103 
104     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
105         return allowed[tokenOwner][spender];
106     }
107 
108     
109     function () external payable {
110         revert();
111     }
112 
113 
114 }