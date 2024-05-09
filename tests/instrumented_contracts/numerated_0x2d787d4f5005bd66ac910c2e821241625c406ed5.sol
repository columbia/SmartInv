1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.10;
3 
4 
5 library Math {
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if(a == 0) { return 0; }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18 
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23 
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 
32 contract Ownable {
33     
34     address public owner_;
35     mapping(address => bool) public locked_;
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     modifier onlyOwner() {
39         require(msg.sender == owner_);
40         _;
41     }
42 
43     modifier locked() {
44         require(!locked_[msg.sender]);
45         _;
46     }    
47 
48     function transferOwnership(address newOwner) public onlyOwner {
49         require(newOwner != address(0));
50         emit OwnershipTransferred(owner_, newOwner);
51         owner_ = newOwner;
52     }
53 
54     function lock(address owner) public onlyOwner {
55         locked_[owner] = true;
56     }
57 
58     function unlock(address owner) public onlyOwner {
59         locked_[owner] = false;
60     }    
61 }
62 
63 
64 contract ERC20Token {
65     
66     using Math for uint256;
67     
68     event Burn(address indexed burner, uint256 value);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 
72     uint256 totalSupply_;
73     mapping(address => uint256) balances_;
74     mapping (address => mapping (address => uint256)) internal allowed_;
75 
76     function totalSupply() public view returns (uint256) { return totalSupply_; }
77 
78     function transfer(address to, uint256 value) public virtual returns (bool) {
79         require(to != address(0));
80         require(value <= balances_[msg.sender]);
81 
82         balances_[msg.sender] = balances_[msg.sender].sub(value);
83         balances_[to] = balances_[to].add(value);
84         emit Transfer(msg.sender, to, value);
85         return true;
86     }
87 
88     function balanceOf(address owner) public view returns (uint256 balance) { return balances_[owner]; }
89 
90     function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
91 
92         require(to != address(0));
93         require(value <= balances_[from]);
94         require(value <= allowed_[from][msg.sender]);
95 
96         balances_[from] = balances_[from].sub(value);
97         balances_[to] = balances_[to].add(value);
98         emit Transfer(from, to, value);
99         
100         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
101         emit Approval(from, msg.sender, allowed_[from][msg.sender]);
102         return true;
103     }
104 
105     function approve(address spender, uint256 value) public returns (bool) {
106         allowed_[msg.sender][spender] = value;
107         emit Approval(msg.sender, spender, value);
108         return true;
109     }
110 
111     function allowance(address owner, address spender) public view returns (uint256) {
112         return allowed_[owner][spender];
113     }
114 
115     function burn(uint256 value) public {
116         require(value <= balances_[msg.sender]);
117         address burner = msg.sender;
118         balances_[burner] = balances_[burner].sub(value);
119         emit Transfer(burner, burner, value);
120         totalSupply_ = totalSupply_.sub(value);
121         emit Burn(burner, value);
122     }    
123 }
124 
125 contract Berry is Ownable, ERC20Token {
126 
127     using Math for uint;
128 
129     uint8 constant public decimals = 18;
130     string constant public symbol = "BERRY";
131     string constant public name = "Berry";
132     
133     constructor(address company, uint amount) {
134         owner_ = company;
135         totalSupply_ = amount * 1000000000000000000;
136         initSetting(company, totalSupply_);
137     }
138 
139     function initSetting(address addr, uint amount) internal returns (bool) {
140         
141         balances_[addr] = amount;
142         emit Transfer(address(0x0), addr, balances_[addr]);
143         return true;
144     }
145 
146     function transfer(address to, uint256 value) public override returns (bool) {
147         return super.transfer(to, value);
148     }
149 
150     function transferFrom(address from, address to, uint256 value) public override returns (bool) {
151         return super.transferFrom(from, to, value);
152     }
153 }