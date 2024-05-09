1 pragma solidity ^0.4.23;
2 
3 
4 library Math {
5 
6 
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         
9         if(a == 0) { return 0; }
10         uint256 c = a * b;
11         assert(c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16 
17         uint256 c = a / b;
18         return c;
19     }
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22 
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28 
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 
36 contract ERC20 {
37 
38 
39     function totalSupply() public view returns (uint256);
40     function balanceOf(address who) public view returns (uint256);
41     function transfer(address to, uint256 value) public returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43 
44     function allowance(address owner, address spender) public view returns (uint256);
45     function transferFrom(address from, address to, uint256 value) public returns (bool);
46     function approve(address spender, uint256 value) public returns (bool);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 
51 contract Ownable {
52     
53 
54     address public owner_;
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     constructor() public {
58         
59         owner_ = msg.sender;
60     }
61 
62     modifier onlyOwner() {
63         
64         require(msg.sender == owner_);
65         _;
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         
70         require(newOwner != address(0));
71         emit OwnershipTransferred(owner_, newOwner);
72         owner_ = newOwner;
73     }
74 }
75 
76 
77 contract BasicToken is ERC20 {
78     
79 
80     using Math for uint256;
81     
82     event Burn(address indexed burner, uint256 value);
83 
84     uint256 totalSupply_;
85     mapping(address => uint256) balances_;
86     mapping (address => mapping (address => uint256)) internal allowed_;    
87 
88     function totalSupply() public view returns (uint256) {
89         
90         return totalSupply_;
91     }
92 
93     function transfer(address to, uint256 value) public returns (bool) {
94 
95         require(to != address(0));
96         require(value <= balances_[msg.sender]);
97 
98         balances_[msg.sender] = balances_[msg.sender].sub(value);
99         balances_[to] = balances_[to].add(value);
100         emit Transfer(msg.sender, to, value);
101         return true;
102     }
103 
104     function balanceOf(address owner) public view returns (uint256 balance) {
105 
106         return balances_[owner];
107     }
108 
109     function transferFrom(address from, address to, uint256 value) public returns (bool) {
110 
111         require(to != address(0));
112         require(value <= balances_[from]);
113         require(value <= allowed_[from][msg.sender]);
114 
115         balances_[from] = balances_[from].sub(value);
116         balances_[to] = balances_[to].add(value);
117         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
118         emit Transfer(from, to, value);
119         return true;
120     }
121 
122     function approve(address spender, uint256 value) public returns (bool) {
123         
124         allowed_[msg.sender][spender] = value;
125         emit Approval(msg.sender, spender, value);
126         return true;
127     }
128 
129     function allowance(address owner, address spender) public view returns (uint256) {
130         
131         return allowed_[owner][spender];
132     }
133 
134     function burn(uint256 value) public {
135 
136         require(value <= balances_[msg.sender]);
137         address burner = msg.sender;
138         balances_[burner] = balances_[burner].sub(value);
139         totalSupply_ = totalSupply_.sub(value);
140         emit Burn(burner, value);
141     }    
142 }
143 
144 
145 
146 contract TUNEToken is BasicToken, Ownable {
147 
148     
149     using Math for uint;
150 
151     string constant public name     = "TUNEToken";
152     string constant public symbol   = "TUNE";
153     uint8 constant public decimals  = 18;
154     uint256 constant TOTAL_SUPPLY   = 1000000000e18;
155 
156     address constant comany = 0x70745487A80e21ec7ba9aad971d13aBb8a3d8104;
157     
158     constructor() public {
159 
160         totalSupply_ = TOTAL_SUPPLY;
161         allowTo(comany, totalSupply_);
162     }
163 
164     function allowTo(address addr, uint amount) internal returns (bool) {
165         
166         balances_[addr] = amount;
167         emit Transfer(address(0x0), addr, amount);
168         return true;
169     }
170 
171     function transfer(address to, uint256 value) public returns (bool) {
172 
173         return super.transfer(to, value);
174     }
175 
176     function transferFrom(address from, address to, uint256 value) public returns (bool) {
177 
178         return super.transferFrom(from, to, value);
179     }
180 
181     function withdrawTokens(address tokenContract) external onlyOwner {
182         
183         TUNEToken tc = TUNEToken(tokenContract);
184         tc.transfer(owner_, tc.balanceOf(this));
185     }
186 
187     function withdrawEther() external onlyOwner {
188 
189         owner_.transfer(address(this).balance);
190     }
191 }