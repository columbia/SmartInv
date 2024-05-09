1 pragma solidity ^0.4.24;
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
55     mapping(address => bool) locked_;
56     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
57 
58     constructor() public {
59         
60         owner_ = msg.sender;
61     }
62 
63     modifier onlyOwner() {
64         
65         require(msg.sender == owner_);
66         _;
67     }
68 
69     modifier locked() {
70         require(!locked_[msg.sender]);
71         _;
72     }    
73 
74     function transferOwnership(address newOwner) public onlyOwner {
75         
76         require(newOwner != address(0));
77         emit OwnershipTransferred(owner_, newOwner);
78         owner_ = newOwner;
79     }
80 
81     function lock(address owner) public onlyOwner {
82         locked_[owner] = true;
83     }
84 
85     function unlock(address owner) public onlyOwner {
86         locked_[owner] = false;
87     }    
88 }
89 
90 
91 contract BasicToken is ERC20 {
92     
93 
94     using Math for uint256;
95     
96     event Burn(address indexed burner, uint256 value);
97 
98     uint256 totalSupply_;
99     mapping(address => uint256) balances_;
100     mapping (address => mapping (address => uint256)) internal allowed_;    
101 
102     function totalSupply() public view returns (uint256) {
103         
104         return totalSupply_;
105     }
106 
107     function transfer(address to, uint256 value) public returns (bool) {
108 
109         require(to != address(0));
110         require(value <= balances_[msg.sender]);
111 
112         balances_[msg.sender] = balances_[msg.sender].sub(value);
113         balances_[to] = balances_[to].add(value);
114         emit Transfer(msg.sender, to, value);
115         return true;
116     }
117 
118     function balanceOf(address owner) public view returns (uint256 balance) {
119 
120         return balances_[owner];
121     }
122 
123     function transferFrom(address from, address to, uint256 value) public returns (bool) {
124 
125         require(to != address(0));
126         require(value <= balances_[from]);
127         require(value <= allowed_[from][msg.sender]);
128 
129         balances_[from] = balances_[from].sub(value);
130         balances_[to] = balances_[to].add(value);
131         allowed_[from][msg.sender] = allowed_[from][msg.sender].sub(value);
132         emit Transfer(from, to, value);
133         return true;
134     }
135 
136     function approve(address spender, uint256 value) public returns (bool) {
137         
138         allowed_[msg.sender][spender] = value;
139         emit Approval(msg.sender, spender, value);
140         return true;
141     }
142 
143     function allowance(address owner, address spender) public view returns (uint256) {
144         
145         return allowed_[owner][spender];
146     }
147 
148     function burn(uint256 value) public {
149 
150         require(value <= balances_[msg.sender]);
151         address burner = msg.sender;
152         balances_[burner] = balances_[burner].sub(value);
153         totalSupply_ = totalSupply_.sub(value);
154         emit Burn(burner, value);
155     }    
156 }
157 
158 
159 
160 contract DLOToken is BasicToken, Ownable {
161 
162     
163     using Math for uint;
164 
165     string constant public name     = "Delio";
166     string constant public symbol   = "DLO";
167     uint8 constant public decimals  = 18;
168     uint256 constant TOTAL_SUPPLY   = 5000000000e18;
169     
170     address constant company1 = 0xa4Fb2C681A51e52930467109d990BbB21857EaCE; // 40
171     address constant company2 = 0x0Cc7b6c24f5546a4938F67A3C7A8c29Eba2a0f9d; // 20
172     address constant company3 = 0x7c0b9BdA7cAaE0015F17F2664B46DFE293C85BAb; // 20
173     address constant company4 = 0x5ca06ad3E9141818049e8fDF6731Ab639A8832AD; // 10
174     address constant company5 = 0x3444E9FC958e2e0e706f71ACC7F06211E0580CD2; // 10   
175 
176 
177     uint constant rate40 = 2000000000e18;
178     uint constant rate20 = 1000000000e18;
179     uint constant rate10 = 500000000e18;
180     
181     constructor() public {
182 
183         totalSupply_ = TOTAL_SUPPLY;
184         allowTo(company1, rate40);
185         allowTo(company2, rate20);
186         allowTo(company3, rate20);
187         allowTo(company4, rate10);
188         allowTo(company5, rate10);
189     }
190 
191     function allowTo(address addr, uint amount) internal returns (bool) {
192         
193         balances_[addr] = amount;
194         emit Transfer(address(0x0), addr, amount);
195         return true;
196     }
197 
198     function transfer(address to, uint256 value) public locked returns (bool) {
199         return super.transfer(to, value);
200     }
201 
202     function transferFrom(address from, address to, uint256 value) public locked returns (bool) {
203         return super.transferFrom(from, to, value);
204     }
205 }