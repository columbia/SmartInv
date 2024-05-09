1 pragma solidity ^0.4.20;
2 
3 contract owned {
4     address public owner;
5     
6     event Log(string s);
7     
8     constructor() public payable{
9         owner = msg.sender;
10     }
11 
12     modifier onlyOwner {
13         require(msg.sender == owner);
14         _;
15     }
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19     function isOwner()public{
20         if(msg.sender==owner)emit Log("Owner");
21         else{
22             emit Log("Not Owner");
23         }
24     }
25 }
26 contract ERC20 is owned{
27 
28     string public name;
29     string public symbol;
30 
31     uint256 public totalSupply;
32     uint8 public constant decimals = 4;
33 
34     mapping(address => uint256) balances;
35     mapping(address => mapping (address => uint256)) allowed;
36     
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 
40     constructor(uint256 _totalSupply,string tokenName,string tokenSymbol) public {
41         symbol = tokenSymbol;
42         name = tokenName;
43         totalSupply = _totalSupply;
44         balances[owner] = totalSupply;
45         emit Transfer(address(0), owner, totalSupply);
46     }
47 
48     function totalSupply() public view returns (uint){
49         return totalSupply;
50     }
51 
52     function balanceOf(address tokenOwner) public view returns (uint balance) {
53         return balances[tokenOwner];
54     }
55 
56     function transfer(address to, uint tokens) public returns (bool success) {
57         balances[msg.sender] = balances[msg.sender ]- tokens;
58         balances[to] = balances[to] + tokens;
59         emit Transfer(msg.sender, to, tokens);
60         return true;
61     }
62 
63     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
64         balances[from] = balances[from] - tokens;
65         allowed[from][msg.sender] = allowed[from][msg.sender] - (tokens);
66         balances[to] = balances[to]+(tokens);
67         emit Transfer(from, to, tokens);
68         return true;
69     }
70 
71     function approve(address spender, uint tokens) public returns (bool success) {
72         allowed[msg.sender][spender] = tokens;
73         emit Approval(msg.sender, spender, tokens);
74         return true;
75     }
76 
77     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
78         return allowed[tokenOwner][spender];
79     }
80 }
81 
82 contract EPLAY is ERC20 {
83     
84     uint256 activeUsers;
85 
86     mapping(address => bool) isRegistered;
87     mapping(address => uint256) accountID;
88     mapping(uint256 => address) accountFromID;
89     mapping(address => bool) isTrusted;
90 
91     event Burn(address _from,uint256 _value);
92     
93     modifier isTrustedContract{
94         require(isTrusted[msg.sender]);
95         _;
96     }
97     
98     modifier registered{
99         require(isRegistered[msg.sender]);
100         _;
101     }
102     
103     constructor(
104         string tokenName,
105         string tokenSymbol) public payable
106         ERC20(74145513585,tokenName,tokenSymbol)
107     {
108        
109     }
110     
111     function distribute(address[] users,uint256[] balances) public onlyOwner {
112          uint i;
113         for(i = 0;i <users.length;i++){
114             transferFrom(owner,users[i],balances[i]);
115         }
116     }
117 
118     function burnFrom(address _from, uint256 _value) internal returns (bool success) {
119         require(balances[_from] >= _value);
120         balances[_from] -= _value;
121         totalSupply -= _value;
122         emit Burn(_from, _value);
123         return true;
124     }
125 
126     function contractBurn(address _for,uint256 value)external isTrustedContract{
127         burnFrom(_for,value);
128     }
129 
130     function burn(uint256 val)public{
131         burnFrom(msg.sender,val);
132     }
133 
134     function registerAccount(address user)internal{
135         if(!isRegistered[user]){
136             isRegistered[user] = true;
137             activeUsers += 1;
138             accountID[user] = activeUsers;
139             accountFromID[activeUsers] = user;
140         }
141     }
142     
143     function registerExternal()external{
144         registerAccount(msg.sender);
145     }
146     
147     function register() public {
148         registerAccount(msg.sender);
149     }
150 
151     function testConnection() external {
152         emit Log("CONNECTED");
153     }
154 }