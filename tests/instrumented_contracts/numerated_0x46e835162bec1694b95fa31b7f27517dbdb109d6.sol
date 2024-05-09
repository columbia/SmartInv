1 pragma solidity ^0.4.17;
2 
3 library SafeCalc {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract Ownable {
29   address public owner;
30 
31   function Ownable() public {
32     owner = msg.sender;
33   }
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     owner = newOwner;
43   }
44 }
45 
46 contract Migrations {
47   address public owner;
48   uint public last_completed_migration;
49 
50   modifier restricted() {
51     if (msg.sender == owner) _;
52   }
53 
54   function Migrations() public {
55     owner = msg.sender;
56   }
57 
58   function setCompleted(uint completed) public restricted {
59     last_completed_migration = completed;
60   }
61 
62   function upgrade(address new_address) public restricted {
63     Migrations upgraded = Migrations(new_address);
64     upgraded.setCompleted(last_completed_migration);
65   }
66 }
67 
68 contract ERC20Standard {
69 
70     // total amount of tokens
71     function totalSupply() public constant returns (uint256) ;
72 
73     /*
74      *  Events
75      */
76     event Transfer(address indexed _from, address indexed _to, uint256 _value);
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78 
79     /*
80      *  Public functions
81      */
82     function transfer(address _to, uint256 _value) public returns (bool);
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
85 
86     function approve(address _spender, uint256 _value) public returns (bool);
87 
88     function balanceOf(address _owner) public constant returns (uint256);
89 
90     function allowance(address _owner, address _spender) public constant returns (uint256);
91 }
92 
93 contract ERC20StandardToken is ERC20Standard {
94     using SafeCalc for uint256;
95 
96     /*
97      *  ERC20StandardToken
98      */
99     mapping (address => uint256) balances;
100     mapping (address => mapping (address => uint256)) allowances;
101 
102     function transfer(address to, uint256 value) public returns (bool){
103         require(to !=address(0));
104 
105         balances[msg.sender]=balances[msg.sender].sub(value);
106         balances[to] = balances[to].add(value);
107         Transfer(msg.sender,to,value);
108         return true;
109     }
110 
111     function transferFrom(address from, address to, uint256 value) public returns (bool){
112         require(to != address(0));
113 
114         var allowanceAmount = allowances[from][msg.sender];
115 
116         balances[from] = balances[from].sub(value);
117         balances[to] = balances[to].add(value);
118         allowances[from][msg.sender] = allowanceAmount.sub(value);
119         Transfer(from, to, value);
120         return true;
121 
122     }
123 
124     function approve(address spender, uint256 value) public returns (bool){
125         require((value == 0) || (allowances[msg.sender][spender] == 0));
126         allowances[msg.sender][spender] = value;
127         Approval(msg.sender, spender, value);
128         return true;
129     }
130 
131     function allowance(address owner, address spender) public constant returns (uint256){
132         return allowances[owner][spender];
133     }
134 
135     function balanceOf(address owner) public constant returns (uint256){
136         return balances[owner];
137     }
138 }
139 
140 contract IAMToken is ERC20StandardToken, Ownable {
141 
142     // token information
143     string public constant name = "IAM Token";
144     string public constant symbol = "IAM";
145     uint256 public constant decimals = 18;
146     uint TotalTokenSupply=1*(10**8)* (10**decimals);
147 
148      function totalSupply() public constant returns (uint256 ) {
149           return TotalTokenSupply;
150       }
151 
152     /// transfer all tokens to holders
153     address public constant MAIN_HOLDER_ADDR=0x48B7995cA6C311add45071D2267d97a46Aa02a0A;
154 
155     function IAMToken() public onlyOwner{
156         balances[MAIN_HOLDER_ADDR]+=TotalTokenSupply;
157         Transfer(0,MAIN_HOLDER_ADDR,TotalTokenSupply);
158       }
159 
160 }