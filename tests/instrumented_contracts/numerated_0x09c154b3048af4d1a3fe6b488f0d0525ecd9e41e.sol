1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4     function add(uint a,uint b) internal pure returns(uint c){
5         c = a + b;
6         require(c>=a);
7     }
8     function sub(uint a,uint b) internal pure returns(uint c){
9         require(b<=a);
10         c = a - b;
11     }
12     function mul(uint a,uint b) internal pure returns(uint c){
13         c = a * b;
14         require (a ==0 || c / a ==b);
15     }
16     function div(uint a,uint b) internal pure returns(uint c){
17         require(b>0);
18         c = a / b;
19     }
20 }
21 
22 interface ERC20Interface{
23     //总发行量
24     function totalSupply() external returns(uint);
25     //查询数量
26     function balanceOf(address tokenOwner) external returns(uint balance);
27     //查询授权数量
28     function allowance(address tokenOwner,address spender) external returns(uint remaining);
29     //转账
30     function transfer(address to,uint tokens) external returns(bool success);
31     //授权
32     function approve(address spender,uint tokens) external returns(bool success);
33     //授权转账
34     function transferFrom(address from,address to,uint tokens) external returns(bool success);
35     
36     event Transfer(address indexed from,address indexed to,uint tokens);
37     event Approval(address indexed tokenOwner,address indexed spender,uint tokens);
38 }
39 
40 contract ContractRecevier{
41     function tokenFallback(address _from,uint _value,bytes _data) public returns(bool ok);
42 }
43 
44 
45 interface ERC223{
46     function transfer(address to,uint value,bytes data) public returns (bool ok);
47     event Transfer(address indexed from,address indexed to,uint value,bytes indexed data);
48 }
49 
50 contract Owned{
51     address public owner;
52     address public newOwner;
53     
54     event OwnershipTransferred(address indexed _from,address indexed _to);
55     
56     constructor() public{
57         owner = msg.sender;
58     }
59     
60     modifier onlyOwner {
61         require (msg.sender == owner);
62         _;
63     }
64     
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public  {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner,newOwner);
71         owner = newOwner ;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 contract SeahighToken is ERC20Interface,ERC223,Owned {
78     using SafeMath for uint;
79     
80     string public symbol;
81     string public name;
82     uint8 public decimals;
83     uint _totalSupply;
84     
85     mapping(address => uint ) balances;
86     mapping(address =>mapping(address =>uint)) allowed;
87     
88     constructor() public{
89         symbol = "SEAH";
90         name = "Seahigh Token";
91         decimals = 18;
92         _totalSupply = 100000000 * 10 **18;
93         balances[owner] = _totalSupply;
94         
95         emit Transfer(address(0),owner,_totalSupply);
96     }
97     
98     function isContract(address _addr)public view returns(bool is_contract){
99         uint length;
100         assembly{
101             length := extcodesize(_addr)
102         }
103         return (length>0);
104     }
105     
106     
107     function totalSupply() public view returns(uint){
108 //        return _totalSupply;
109           return _totalSupply.sub(balances[address(0)]);
110     }
111     
112     function balanceOf(address tokenOwner) public view  returns(uint balance){
113         return balances[tokenOwner];
114     }
115     
116     function transfer(address to,uint tokens) public returns(bool success){
117         balances[msg.sender] = balances[msg.sender].sub(tokens);
118          balances[to] = balances[to].add(tokens);
119          emit Transfer(msg.sender,to,tokens);
120          return true;
121          
122     }
123     
124     function transfer(address to,uint value,bytes data) public returns(bool ok){
125         if(isContract(to)){
126          balances[msg.sender] = balances[msg.sender].sub(value);
127          balances[to] = balances[to].add(value);
128          ContractRecevier c = ContractRecevier(to);
129          c.tokenFallback(msg.sender,value,data);
130          emit Transfer(msg.sender,to,value,data);
131          return true; 
132         }
133     }
134     
135     
136     function approve(address spender, uint tokens) public returns (bool success){
137         allowed[msg.sender][spender] = tokens;
138         emit Approval(msg.sender,spender,tokens);
139         return true;
140     }
141     
142     function transferFrom(address from,address to,uint tokens) public returns(bool success){
143         balances[from] = balances[from].sub(tokens);
144         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
145         
146         balances[to] = balances[to].add(tokens);
147         
148         emit Transfer(from,to,tokens);
149         return true;
150     }
151     
152     function allowance(address tokenOwner,address spender) public view  returns(uint remaining){
153         return allowed[tokenOwner][spender];
154     }
155 }