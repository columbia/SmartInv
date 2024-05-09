1 pragma solidity ^0.4.17;
2 
3 library SafeMath {
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
31 
32   function Ownable() public {
33     owner = msg.sender;
34   }
35 
36 
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     owner = newOwner;
45   }
46 }
47 
48 contract Migrations {
49   address public owner;
50   uint public last_completed_migration;
51 
52   modifier restricted() {
53     if (msg.sender == owner) _;
54   }
55 
56   function Migrations() public {
57     owner = msg.sender;
58   }
59 
60   function setCompleted(uint completed) public restricted {
61     last_completed_migration = completed;
62   }
63 
64   function upgrade(address new_address) public restricted {
65     Migrations upgraded = Migrations(new_address);
66     upgraded.setCompleted(last_completed_migration);
67   }
68 }
69 
70 contract ERC20Standard {
71 
72 
73     // total amount of tokens
74     function totalSupply() public constant returns (uint256) ;
75 
76     /*
77      *  Events
78      */
79     event Transfer(address indexed _from, address indexed _to, uint256 _value);
80     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
81 
82     /*
83      *  Public functions
84      */
85     function transfer(address _to, uint256 _value) public returns (bool);
86 
87     function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
88 
89 
90     function approve(address _spender, uint256 _value) public returns (bool);
91 
92     function balanceOf(address _owner) public constant returns (uint256);
93 
94     function allowance(address _owner, address _spender) public constant returns (uint256);
95 }
96 
97 contract ERC20StandardToken is ERC20Standard {
98     using SafeMath for uint256;
99 
100     /*
101      *  Storage
102      */
103     mapping (address => uint256) balances;
104     mapping (address => mapping (address => uint256)) allowances;
105 
106 
107     function transfer(address to, uint256 value) public returns (bool){
108         require(to !=address(0));
109 
110         balances[msg.sender]=balances[msg.sender].sub(value);
111         balances[to] = balances[to].add(value);
112         Transfer(msg.sender,to,value);
113         return true;
114     }
115 
116 
117     function transferFrom(address from, address to, uint256 value) public returns (bool){
118         require(to != address(0));
119 
120         var allowanceAmount = allowances[from][msg.sender];
121 
122         balances[from] = balances[from].sub(value);
123         balances[to] = balances[to].add(value);
124         allowances[from][msg.sender] = allowanceAmount.sub(value);
125         Transfer(from, to, value);
126         return true;
127 
128     }
129 
130     function approve(address spender, uint256 value) public returns (bool){
131         require((value == 0) || (allowances[msg.sender][spender] == 0));
132         allowances[msg.sender][spender] = value;
133         Approval(msg.sender, spender, value);
134         return true;
135     }
136 
137     function allowance(address owner, address spender) public constant returns (uint256){
138         return allowances[owner][spender];
139     }
140 
141 
142     function balanceOf(address owner) public constant returns (uint256){
143         return balances[owner];
144     }
145 }
146 
147 contract MYCareCoin is ERC20StandardToken, Ownable {
148 
149     // token information
150     string public constant name = "MY Care Coin";
151     string public constant symbol = "MYCC";
152     uint256 public constant decimals = 18;
153     uint TotalTokenSupply=3.65*(10**8)* (10**decimals);
154 
155      function totalSupply() public constant returns (uint256 ) {
156           return TotalTokenSupply;
157       }
158 
159     /// transfer all tokens to holders
160     address public constant MAIN_HOLDER_ADDR=0xfe5fCd09979DE1CC2D51CBaeeB7829bEB8CEbFe3;
161 
162 
163     function MYCareCoin() public onlyOwner{
164         balances[MAIN_HOLDER_ADDR]+=TotalTokenSupply;
165         Transfer(0,MAIN_HOLDER_ADDR,TotalTokenSupply);
166       }
167 }