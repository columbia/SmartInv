1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         assert(b > 0);
15         uint256 c = a / b;
16         assert(a == b * c);
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         uint256 c = a - b;
22         assert(b <= a);
23         assert(a == c + b);
24         return c;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         assert(a == c - b);
31         return c;
32     }
33 }
34 
35 contract owned {
36     address public owner;
37     
38     constructor() public{
39         owner = msg.sender;
40     }
41     
42     modifier onlyOwner {
43         require(msg.sender == owner);
44         _;
45     }
46     
47     function transferOwnership(address newOwner) public onlyOwner {
48         owner = newOwner;
49     }
50 }
51 
52 contract EducationTokens is owned{
53     using SafeMath for uint256;
54 
55     bool private transferFlag;
56     string public name;
57     uint256 public decimals;
58     string public symbol;
59     string public version;
60     uint256 public totalSupply;
61     uint256 public deployTime;
62 
63     mapping(address => uint256) public balances;
64     mapping(address => mapping(address => uint256)) public allowed;
65     mapping(address => uint256) private userLockedTokens;
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69     event Lock(address userAddress, uint256 amount);
70     event Unlock(address userAddress,uint256 amount);
71     event SetFlag(bool flag);
72 
73     //constructor(string tokenName, string tokenSymbol) public {
74     constructor() public {
75         transferFlag = true;
76         //name = tokenName;
77         name = "sniperyao";
78         decimals = 4;
79         //symbol = tokenSymbol;
80         symbol = "sy";
81         version = "V1.0";
82         totalSupply = 2100000000 * 10 ** decimals;
83         owner = msg.sender;
84         deployTime = block.timestamp;
85         
86         balances[msg.sender] = totalSupply;
87     }
88     
89     modifier canTransfer() {
90         require(transferFlag);
91         _;
92     }
93     
94     function name()constant public returns (string token_name){
95         return name;
96     }
97     
98     function symbol() constant public returns (string _symbol){
99         return symbol;
100     }
101     
102     function decimals() constant public returns (uint256 _decimals){
103         return decimals;
104     }
105     
106     function totalSupply() constant public returns (uint256 _totalSupply){
107         return totalSupply;
108     }
109     
110     function setTransferFlag(bool transfer_flag) public onlyOwner{
111         transferFlag = transfer_flag;
112         emit SetFlag(transferFlag);
113     }
114     
115     function tokenLock(address _userAddress, uint256 _amount) public onlyOwner {
116         require(balanceOf(_userAddress) >= _amount);
117         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].add(_amount);
118         emit Lock(_userAddress, _amount);
119     }
120 
121     function tokenUnlock(address _userAddress, uint256 _amount) public onlyOwner {
122         require(userLockedTokens[_userAddress] >= _amount);
123         userLockedTokens[_userAddress] = userLockedTokens[_userAddress].sub(_amount);
124         emit Unlock(_userAddress, _amount);
125     }
126 
127     function balanceOf(address _owner) view public returns (uint256 balance) {
128         return balances[_owner] - userLockedTokens[_owner];
129     }
130     
131     function transfer(address _to, uint256 _value) public canTransfer returns (bool success) {
132         require(balanceOf(msg.sender) >= _value);
133         balances[msg.sender] = balances[msg.sender].sub(_value);
134         balances[_to] = balances[_to].add(_value);
135         emit Transfer(msg.sender, _to, _value);
136         return true;
137     }
138 
139     function transferFrom(address _from, address _to, uint256 _value) public canTransfer returns (bool success) {
140         require(balanceOf(_from) >= _value && allowed[_from][msg.sender] >= _value);
141         balances[_from] = balances[_from].sub(_value);
142         balances[_to] = balances[_to].add(_value);
143         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
144         emit Transfer(_from, _to, _value);
145         return true;
146     }
147 
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157 }