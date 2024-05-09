1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * A standard interface allows any tokens on Ethereum to be re-used by 
32  * other applications: from wallets to decentralized exchanges.
33  */
34 contract ERC20 {
35 
36     // optional functions
37     function name() public view returns (string);
38     function symbol() public view returns (string);
39     function decimals() public view returns (uint8);
40 
41     // required functios
42     function balanceOf(address user) public view returns (uint256);
43     function allowance(address user, address spender) public view returns (uint256);
44     function totalSupply() public view returns (uint256);
45     function transfer(address to, uint256 value) public returns (bool);
46     function transferFrom(address from, address to, uint256 value) public returns (bool); 
47     function approve(address spender, uint256 value) public returns (bool); 
48 
49     // required events
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed user, address indexed spender, uint256 value);
52 }
53 
54 contract TokenCC is ERC20 {
55     using SafeMath for uint256;
56 
57     address private _owner;
58     bool private _isStopped = false;
59     string private _name = "CChain CCHN";
60     string private _symbol = "CCHN";
61     uint8 private _decimals = 18;
62     uint256 private _totalSupply;
63 
64     mapping (address => uint256) private _balanceOf;
65     mapping (address => mapping (address => uint256)) private _allowance;
66 
67     event Mint(address indexed from, uint256 value);
68     event Burn(address indexed from, uint256 value);
69 
70     constructor(uint256 tokenSupply) public {
71         _owner = msg.sender;
72         _totalSupply = tokenSupply * 10 ** uint256(_decimals);
73         _balanceOf[msg.sender] = _totalSupply;
74     }
75 
76     modifier onlyOwner {
77         require(msg.sender == _owner);
78         _;
79     }
80 
81     modifier unstopped() {
82         require(msg.sender == _owner || _isStopped == false);
83         _;
84     }
85 
86     function owner() public view returns (address){
87         return _owner;
88     }
89 
90     function start() public onlyOwner {
91         if(_isStopped) {
92             _isStopped = false;
93         }
94     }
95 
96     function stop() public onlyOwner {
97         if(_isStopped == false) {
98             _isStopped = true;
99         }
100     }
101 
102     function isStopped() public view returns (bool) {
103         return _isStopped;
104     }
105 
106     function name() public view returns (string) {
107         return _name;
108     }
109 
110     function symbol() public view returns (string) {
111         return _symbol;
112     }
113 
114     function decimals() public view returns (uint8) {
115         return _decimals;
116     }
117 
118     function balanceOf(address user) public view returns (uint256) {
119         return _balanceOf[user];
120     }
121 
122     function allowance(address user, address spender) public view returns (uint256) {
123         return _allowance[user][spender];
124     }
125     
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     function transferImpl(address from, address to, uint256 value) internal {
131         require(to != 0x0);
132         require(value > 0);
133         require(_balanceOf[from] >= value);
134         _balanceOf[from] = _balanceOf[from].sub(value);
135         _balanceOf[to] = _balanceOf[to].add(value);
136         emit Transfer(from, to, value);
137     }
138 
139     function transfer(address to, uint256 value) public unstopped returns (bool) {
140         transferImpl(msg.sender, to, value);
141         return true;
142     }
143 
144     function transferFrom(address from, address to, uint256 value) public unstopped returns (bool) {
145         require(value <= _allowance[from][msg.sender]);
146         _allowance[from][msg.sender] = _allowance[from][msg.sender].sub(value);
147         transferImpl(from, to, value);
148         return true;
149     }
150 
151     function approve(address spender, uint256 value) public unstopped returns (bool) {
152         _allowance[msg.sender][spender] = value;
153         emit Approval(msg.sender, spender, value);
154         return true;
155     }
156     
157     function mint(uint256 value) public onlyOwner {
158         _totalSupply = _totalSupply.add(value);
159         _balanceOf[owner()] = _balanceOf[owner()].add(value);
160         emit Mint(owner(), value);
161     }
162 
163     function burn(uint256 value) public unstopped returns (bool) {
164         require(_balanceOf[msg.sender] >= value);
165         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(value);
166         _totalSupply = _totalSupply.sub(value);
167         emit Burn(msg.sender, value);
168         return true;
169     }
170 }