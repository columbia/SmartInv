1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 
28 
29 }
30 contract ERC20 {
31     uint256 public totalSupply;
32     function balanceOf(address _owner)public constant returns (uint256 balance);
33     function transfer(address _to, uint256 _value)public returns (bool success);
34     function transferFrom(address _from, address _to, uint256 _value)public returns (bool success);
35     function approve(address _spender, uint256 _value)public returns (bool success);
36     function allowance(address _owner, address _spender)public constant returns (uint256 remaining);
37 
38     event Transfer(address indexed _from, address indexed _to, uint256 _value);
39     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
40 
41 }
42 
43 
44 contract StdToken is ERC20,SafeMath {
45 
46     // validates an address - currently only checks that it isn't null
47    modifier validAddress(address _address) {
48         require(_address != 0x0);
49         _;
50     }
51 
52   mapping(address => uint) balances;
53   mapping (address => mapping (address => uint)) allowed;
54   
55   event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     
57   function transfer(address _to, uint _value) public validAddress(_to)  returns (bool success){
58     if(msg.sender != _to){
59     balances[msg.sender] = safeSub(balances[msg.sender], _value);
60     balances[_to] = safeAdd(balances[_to], _value);
61     Transfer(msg.sender, _to, _value);
62     return true;
63     }
64   }
65 
66     function transferFrom(address _from, address _to, uint256 _value)public validAddress(_to)  returns (bool success) {
67         if (_value <= 0) revert();
68         if (balances[_from] < _value) revert();
69         if (balances[_to] + _value < balances[_to]) revert();
70         if (_value > allowed[_from][msg.sender]) revert();
71         balances[_from] = safeSub(balances[_from], _value);                           
72         balances[_to] = safeAdd(balances[_to], _value);
73         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
74         Transfer(_from, _to, _value);
75         return true;
76     }
77 
78   function balanceOf(address _owner)public constant returns (uint balance) {
79     return balances[_owner];
80   }
81 
82   function approve(address _spender, uint _value)public returns (bool success) {
83     allowed[msg.sender][_spender] = _value;
84     Approval(msg.sender, _spender, _value);
85     return true;
86   }
87 
88   function allowance(address _owner, address _spender)public constant returns (uint remaining) {
89     return allowed[_owner][_spender];
90   }
91 }
92 
93 
94 contract Ownable {
95   address public owner;
96 
97   function Ownable()public {
98     owner = msg.sender;
99   }
100 
101   modifier onlyOwner() {
102     require(msg.sender == owner);
103     _;
104   }
105 
106   function transferOwnership(address newOwner)public onlyOwner {
107     if (newOwner != owner) {
108       owner = newOwner;
109     }
110   }
111 }
112 
113 
114 contract RAM_Token is StdToken,Ownable{
115     string public name="RAM Token";
116     string public symbol="RAM";
117     uint public decimals = 18;
118     uint256 TokenValue;
119     uint256 public minToken=1000;
120     uint256 public rate;
121     address stockWallet=0x7F5C9d6C36AB4BCC7Abd0054809bA88CF9Fed513;
122     address EthWallet=0x82FF0759301dd646C2bE5e27FDEcDF53a43568fd;
123     uint256 public limit;
124     uint public startTime;
125     uint public endTime;
126     bool public active;
127 
128     
129     modifier isActive{
130         if(now>=startTime && now<=endTime && limit>0){
131         _;
132         }else{ if(now>endTime  || limit==0){
133                 active=false;
134             }
135         revert();
136         }
137     }
138     function changeRate(uint _rate)external onlyOwner{
139         rate= _rate;
140     }
141     function changeMinToken(uint _minToken)external onlyOwner{
142         minToken=_minToken;
143     }
144     function activeEnd()external onlyOwner{
145         active=false;
146         startTime=0;
147         endTime=0;
148         limit=0;
149     }
150     
151     function RAM_Token()public onlyOwner{
152         rate=15000;
153         totalSupply= 700 * (10**6) * (10**decimals);
154         balances[stockWallet]= 200 * (10**6) * (10**decimals);
155         balances[owner] = 500 * (10**6) * (10**decimals);
156     }    
157     
158     function Mint(uint _value)public onlyOwner returns(uint256){
159         if(_value>0){
160         balances[owner] = safeAdd(balances[owner],_value);
161         totalSupply =safeAdd(totalSupply, _value);
162         return totalSupply;
163         }
164     }
165         
166     function burn(uint _value)public onlyOwner returns(uint256){
167         if(_value>0 && balances[msg.sender] >= _value){
168             balances[owner] = safeSub(balances[owner],_value);
169             totalSupply = safeSub(totalSupply,_value);
170             return totalSupply;
171         }
172     }
173    
174     function wihtdraw()public onlyOwner returns(bool success){
175         if(this.balance > 0){
176             msg.sender.transfer(this.balance);
177             return true;
178         }
179     }
180     
181     function crowdsale(uint256 _limit,uint _startTime,uint _endTime)external onlyOwner{
182     if(active){ revert();}
183         endTime = _endTime;
184     if(now>=endTime){ revert();}
185     if(_limit==0 || _limit > balances[owner]){revert();}
186         startTime= _startTime;
187         limit = _limit * (10**decimals);
188         active=true;
189     }
190 
191     function ()public isActive payable{
192         if(!active)revert();
193         if(msg.value<=0)revert();
194         TokenValue=msg.value*rate;
195         if(TokenValue<minToken*(10**decimals))revert();
196         if(limit -TokenValue<0)revert();
197         balances[msg.sender]=safeAdd(balances[msg.sender],TokenValue);
198         balances[owner]=safeSub(balances[owner],TokenValue);
199         limit = safeSub(limit,TokenValue);
200         Transfer(owner,msg.sender,TokenValue);
201         EthWallet.transfer(msg.value);
202     }
203 }