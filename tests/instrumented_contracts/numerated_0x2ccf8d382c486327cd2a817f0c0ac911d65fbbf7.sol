1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5     
6     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7         if (a == 0) {
8             return 0;
9         }
10         c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a / b;
17     }
18  
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25         c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract ERC20plus {
32     function totalSupply() public view returns (uint); 
33     function balanceOf(address tokenOwner) public view returns (uint balance);  
34     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
35     function transfer(address to, uint tokens) public returns (bool success);
36     function approve(address spender, uint tokens) public returns (bool success);
37     function transferFrom(address from, address to, uint tokens) public returns (bool success);
38     function name() public view returns (string _name);
39     function symbol() public view returns (string _symbol);
40     function decimals() public view returns (uint8 _decimals);
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 
45 contract Owned {
46     address public owner;
47     address public newOwner;
48 
49     event OwnershipTransferred(address indexed _from, address indexed _to);
50 
51     constructor() public {
52         owner = msg.sender;
53     }
54 
55     modifier onlyOwner {
56         require(msg.sender == owner);
57         _;
58     }
59 
60     function transferOwnership(address _newOwner) public onlyOwner {
61         newOwner = _newOwner;
62     }
63     function acceptOwnership() public {
64         require(msg.sender == newOwner);
65         emit OwnershipTransferred(owner, newOwner);
66         owner = newOwner;
67         newOwner = address(0);
68     }
69 }
70 
71 contract Nakama is ERC20plus, Owned {
72     using SafeMath for uint;
73  
74     string public symbol;
75     string public name;
76     uint8 public decimals;
77     uint public _totalSupply;
78     bool public stopped = false;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83     constructor() public {
84         symbol = "NKM"; 
85         name = "Nakama";
86         decimals = 18;
87         _totalSupply = 10422698937 * 10**uint(decimals);
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91 
92     modifier ifRunning {
93         assert (!stopped);
94         _;
95     }
96 
97     function totalSupply() public view returns (uint) {
98         return _totalSupply.sub(balances[address(0)]);
99     }
100 
101 
102     function balanceOf(address tokenOwner) public view returns (uint balance) {
103         return balances[tokenOwner];
104     }
105 
106     function name() public view returns (string _name) {
107         return name;
108     }
109 
110     function symbol() public view returns (string _symbol) {
111         return symbol;
112     }
113 
114     function decimals() public view returns (uint8 _decimals) {
115         return decimals;
116     }
117 
118     function transfer(address to, uint tokens) public ifRunning returns (bool success) {
119         balances[msg.sender] = balances[msg.sender].sub(tokens);
120         balances[to] = balances[to].add(tokens);
121         emit Transfer(msg.sender, to, tokens);
122         return true;
123     }
124 
125     function approve(address spender, uint tokens) public ifRunning returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         emit Approval(msg.sender, spender, tokens);
128         return true;
129     }
130 
131     function transferFrom(address from, address to, uint tokens) public ifRunning returns (bool success) {
132         balances[from] = balances[from].sub(tokens);
133         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
134         balances[to] = balances[to].add(tokens);
135         emit Transfer(from, to, tokens);
136         return true;
137     }
138 
139     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
140         return allowed[tokenOwner][spender];
141     }
142 
143     function stop() public onlyOwner {
144         stopped = true;
145     }
146 
147     function start() public onlyOwner {
148         stopped = false;
149     }
150 
151     function setName(string _name) public onlyOwner {
152         name = _name;
153     }
154 
155     function setSymbol(string _symbol) public onlyOwner {
156         symbol = _symbol;
157     }
158 
159     function () public payable {
160         revert();
161     }
162 }