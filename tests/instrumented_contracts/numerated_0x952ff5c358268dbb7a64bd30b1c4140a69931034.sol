1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         
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
31 contract BasicTokenERC20 {  
32     using SafeMath for uint256;
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35     
36     mapping(address => uint256) balances;
37     mapping (address => mapping (address => uint256)) internal allowed;
38     mapping (uint8 => mapping (address => uint256)) internal whitelist;
39 
40     uint256 totalSupply_;
41     address public owner_;
42     
43     constructor() public {
44         owner_ = msg.sender;
45     }
46 
47     function totalSupply() public view returns (uint256) {
48         return totalSupply_;
49     }
50 
51     function balanceOf(address owner) public view returns (uint256) {
52         return balances[owner];
53     }
54 
55     function transfer(address to, uint256 value) public returns (bool) {
56         require(to != address(0));
57         require(value <= balances[msg.sender]);
58 
59         balances[msg.sender] = balances[msg.sender].sub(value);
60         balances[to] = balances[to].add(value);
61         emit Transfer(msg.sender, to, value);
62         return true;
63     } 
64                
65     function transferFrom(address from, address to, uint256 value) public returns (bool){
66         require(to != address(0));
67         require(value <= balances[from]);
68         require(value <= allowed[from][msg.sender]);
69 
70         balances[from] = balances[from].sub(value);
71         balances[to] = balances[to].add(value);
72         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
73         emit Transfer(from, to, value);
74         return true;
75     }
76 
77     function approve(address spender, uint256 value) public returns (bool) {
78         allowed[msg.sender][spender] = value;
79         emit Approval(msg.sender, spender, value);
80         return true;
81     }
82 
83     function allowance(address owner, address spender) public view returns (uint256){
84         return allowed[owner][spender];
85     }
86 
87     modifier onlyOwner() {
88         require(msg.sender == owner_);
89         _;
90     }
91 }
92 
93 contract Seba is BasicTokenERC20 {    
94 
95     string public constant name = "SebaToken"; 
96     string public constant symbol = "SEBA";
97     uint public decimals = 18; 
98     uint256 public milion = 1000000;
99     bool public takeToken = false;
100 
101     uint256 public INITIAL_SUPPLY = 24 * milion * (uint256(10) ** decimals);
102     mapping (address => bool) internal friendList;
103 
104     constructor() public {        
105         totalSupply_ = INITIAL_SUPPLY;
106         balances[msg.sender] = totalSupply_;
107     }     
108 
109     function setFriend(address friendWallet) public onlyOwner{
110         friendList[friendWallet] = true;        
111     }
112 
113     function isFriend(address friendWallet) public view returns (bool) {
114         return friendList[friendWallet];
115     }
116 
117     function withdraw(uint256 value) public onlyOwner {
118         require(value > 0);
119         require(owner_ != 0x0);        
120         owner_.transfer(value);
121     } 
122 
123     function () public payable {
124         require(takeToken == true);        
125         require(msg.sender != 0x0);
126 
127         uint256 tokens = 100 * (uint256(10) ** decimals);
128         require(balances[msg.sender] >= tokens);
129 
130         require(balances[owner_] >= tokens);
131         
132         balances[owner_] = balances[owner_].sub(tokens);
133         balances[msg.sender] = balances[msg.sender].add(tokens); 
134         
135         emit Transfer(owner_, msg.sender, tokens);
136     }
137 
138     function startTakeToken() public onlyOwner {
139         takeToken = true;
140     }
141 
142     function stopTakeToken() public onlyOwner {
143         takeToken = false;
144     } 
145 }