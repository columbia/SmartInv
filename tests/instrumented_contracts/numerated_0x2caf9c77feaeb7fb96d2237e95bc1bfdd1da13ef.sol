1 pragma solidity ^0.4.24;
2 
3 library Math {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if(a == 0) { return 0; }
7         uint256 c = a * b;
8         assert(c / a == b);
9         return c;
10     }
11 
12     function div(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a / b;
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30     
31     address public owner_;
32     mapping(address => bool) locked_;
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor() public { owner_ = msg.sender; }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner_);
39         _;
40     }
41 
42     modifier locked() {
43         require(!locked_[msg.sender]);
44         _;
45     }
46 
47     function transferOwnership(address newOwner) public onlyOwner {
48         require(newOwner != address(0));
49         emit OwnershipTransferred(owner_, newOwner);
50         owner_ = newOwner;
51     }
52 
53     function lock(address owner) public onlyOwner {
54         locked_[owner] = true;
55     }
56 
57     function unlock(address owner) public onlyOwner {
58         locked_[owner] = false;
59     }
60 }
61 
62 
63 contract ERC20Token {
64     
65     using Math for uint256;
66     
67     event Burn(address indexed burner, uint256 value);
68     event Transfer(address indexed from, address indexed to, uint256 value);
69     event Approval(address indexed owner, address indexed spender, uint256 value);
70 
71     uint256 totalSupply_;
72     mapping(address => uint256) balances_;
73     mapping (address => mapping (address => uint256)) internal allowed_;
74 
75     function totalSupply() public view returns (uint256) { return totalSupply_; }
76 
77     function transfer(address to, uint256 value) public returns (bool) {
78         require(to != address(0));
79         require(value <= balances_[msg.sender]);
80 
81         balances_[msg.sender] = balances_[msg.sender].sub(value);
82         balances_[to] = balances_[to].add(value);
83         emit Transfer(msg.sender, to, value);
84         return true;
85     }
86 
87     function balanceOf(address owner) public view returns (uint256 balance) { return balances_[owner]; }
88 
89     function transferFrom(address from, address to, uint256 value) public returns (bool) {
90         require(to != address(0));
91         require(value <= balances_[from]);
92         require(value <= allowed_[from][msg.sender]);
93 
94         balances_[from] = balances_[from].sub(value);
95         balances_[to] = balances_[to].add(value);
96         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
97         emit Transfer(from, to, value);
98         return true;
99     }
100 
101     function approve(address spender, uint256 value) public returns (bool) {
102         allowed_[msg.sender][spender] = value;
103         emit Approval(msg.sender, spender, value);
104         return true;
105     }
106 
107     function allowance(address owner, address spender) public view returns (uint256) {
108         return allowed_[owner][spender];
109     }
110 
111     function burn(uint256 value) public {
112         require(value <= balances_[msg.sender]);
113         address burner = msg.sender;
114         balances_[burner] = balances_[burner].sub(value);
115         totalSupply_ = totalSupply_.sub(value);
116         emit Burn(burner, value);
117     }    
118 }
119 
120 contract SmartCloudBroadcast is Ownable, ERC20Token {
121 
122     using Math for uint;
123 
124     uint8 constant public decimals  = 18;
125     string constant public symbol   = "SCB";
126     string constant public name     = "SmartCloudBroadcast";
127     
128     address constant comany = 0x3275d334E2FAb4367159967a0845f4030cc85963;
129     
130     constructor(uint amount) public {
131         totalSupply_ = amount;
132         initSetting(comany, totalSupply_);
133     }
134 
135     function withdrawTokens(address cont) external onlyOwner {
136         SmartCloudBroadcast tc = SmartCloudBroadcast(cont);
137         tc.transfer(owner_, tc.balanceOf(this));
138     }
139 
140     function initSetting(address addr, uint amount) internal returns (bool) {
141         balances_[addr] = amount;
142         emit Transfer(address(0x0), addr, amount);
143         return true;
144     }
145 
146     function transfer(address to, uint256 value) public locked returns (bool) {
147         return super.transfer(to, value);
148     }
149 
150     function transferFrom(address from, address to, uint256 value) public locked returns (bool) {
151         return super.transferFrom(from, to, value);
152     }
153 }