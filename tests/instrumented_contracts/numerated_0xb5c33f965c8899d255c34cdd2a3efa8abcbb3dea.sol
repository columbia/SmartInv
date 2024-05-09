1 pragma solidity ^0.4.11;
2 
3 contract ERC20Basic
4 {
5     uint256 public totalSupply;
6     function balanceOf(address who) public constant returns(uint256);
7     function transfer(address to,uint256 value) public returns(bool);
8     event Transfer(address indexedfrom,address indexedto,uint256 value);
9 }
10 contract IERC20 is ERC20Basic
11 {
12     function allowance(address owner,address spender) public constant returns(uint256);
13     function transferFrom(address from,address to,uint256 value) public returns(bool);
14     function approve(address spender,uint256 value) public returns(bool);
15     event Approval(address indexedowner,address indexedspender,uint256 value);
16 }
17 
18 library SafeMath {
19     function mul(uint256 a, uint256 b) internal constant returns (uint256){
20         uint256 c=a*b;
21         assert(a==0||c/a==b);
22         return c;
23     }
24     function div(uint256 a,uint256 b) internal constant returns(uint256)
25     {
26         //assert(b>0);//Solidityautomaticallythrowswhendividingby0
27         uint256 c=a/b;
28         //assert(a==b*c+a%b);//Thereisnocaseinwhichthisdoesn'thold
29         return c;
30     }
31     function sub(uint256 a,uint256 b) internal constant returns(uint256)
32     {
33         assert(b<=a);
34         return a-b;
35     }
36     function add(uint256 a,uint256 b) internal constant returns(uint256)
37     {
38         uint256 c=a+b;
39         assert(c>=a);
40         return c;
41     }
42 }
43 
44 contract KPRToken is IERC20 {
45     
46     using SafeMath for uint256;
47     
48 
49     
50     //public variables
51     string public constant symbol="KPR"; 
52     string public constant name="KPR Coin"; 
53     uint8 public constant decimals=18;
54 
55     //1 ETH = 2,500 KPR
56     uint56 public  RATE = 2500;
57 
58     //totalsupplyoftoken 
59     uint public totalSupply = 100000000 * 10 ** uint(decimals);
60     
61     uint public buyabletoken = 90000000 * 10 ** uint(decimals);
62     //where the ETH goes 
63     address public owner;
64     
65     //map the addresses
66     mapping(address => uint256) balances;
67     mapping(address => mapping(address => uint256)) allowed;
68     // 1514764800 : Jan 1 2018
69     uint phase1starttime = 1517443200; // Phase 1 Start Date Feb 1 2018
70     uint phase1endtime = 1519257600;  // Phase 1 End Date Feb 22 2018
71     uint phase2starttime = 1519862400;  // Phase 2 Start Date March 1 2018
72     uint phase2endtime = 1521676800; // Phase 2 End Date March 22 2018
73     uint phase3starttime = 1522540800;  // Phase 3 Start Date May 1 2018
74     uint phase3endtime = 1524355200; // Phase 3 End Date May 22 2018
75     
76   
77     //create token function = check
78 
79     function() payable {
80         buyTokens();
81     }
82 
83     function KPRToken() {
84         owner = msg.sender;
85         balances[owner] = totalSupply;
86     }
87 
88     function buyTokens() payable {
89         
90         require(msg.value > 0);
91         require(now > phase1starttime && now < phase3endtime);
92         uint256 tokens;
93     
94         if (now > phase1starttime && now < phase1endtime){
95             
96             RATE = 3000;
97             setPrice(msg.sender, msg.value);
98         } else if(now > phase2starttime && now < phase2endtime){
99             RATE = 2000;
100             setPrice(msg.sender, msg.value);
101             // tokens = msg.value.mul(RATE);
102             // require(tokens < buyabletoken);
103             // balances[msg.sender]=balances[msg.sender].add(tokens);
104             // balances[owner] = balances[owner].sub(tokens);
105             // buyabletoken = buyabletoken.sub(tokens);
106             // owner.transfer(msg.value);
107             
108         } else if(now > phase3starttime && now < phase3endtime){
109             
110             RATE = 1000;
111             setPrice(msg.sender, msg.value);
112         }
113     }
114     
115     function setPrice(address receipt, uint256 value){
116         uint256 tokens;
117         tokens = value.mul(RATE);
118         require(tokens < buyabletoken);
119         balances[receipt]=balances[receipt].add(tokens);
120         balances[owner] = balances[owner].sub(tokens);
121         buyabletoken = buyabletoken.sub(tokens);
122         owner.transfer(value);
123     }
124 
125     function balanceOf(address _owner) constant returns(uint256 balance) {
126         
127         return balances[_owner];
128         
129     }
130 
131     function transfer(address _to, uint256 _value) returns(bool success) {
132         
133         //require is the same as an if statement = checks 
134         require(balances[msg.sender] >= _value && _value > 0 );
135         
136         balances[msg.sender] = balances[msg.sender].sub(_value);
137         balances[_to] = balances[_to].add(_value);
138         
139         Transfer(msg.sender, _to, _value);
140         return true;
141     }
142 
143     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
144         
145         //checking if the spender has permission to spend and how much 
146         require( allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
147         
148         //updating the spenders balance 
149         balances[_from] = balances[_from].sub(_value); 
150         balances[_to] = balances[_to].add(_value); 
151         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value); 
152         Transfer(_from, _to, _value); 
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) returns(bool success) {
157         
158         //if above require is true,approve the spending 
159         allowed[msg.sender][_spender] = _value; 
160         Approval(msg.sender, _spender, _value); 
161         return true;
162     }
163 
164     function allowance(address _owner, address _spender) constant returns(uint256 remaining) {
165         
166         return allowed[_owner][_spender];
167         
168     }
169     
170     event Transfer(address indexed_from, address indexed_to, uint256 _value);
171     event Approval(address indexed_owner, address indexed_spender, uint256 _value);
172     
173     
174 }