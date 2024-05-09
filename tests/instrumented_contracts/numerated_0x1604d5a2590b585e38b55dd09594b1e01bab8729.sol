1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract FANCO is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner = msg.sender; 
45 	
46     mapping (address => uint256) balances; 
47     mapping (address => mapping (address => uint256)) allowed;
48 
49     mapping (address => uint256) times;
50 
51     mapping (address => mapping (uint256 => uint256)) lockdata;
52     mapping (address => mapping (uint256 => uint256)) locktime;
53     mapping (address => mapping (uint256 => uint256)) lockday;
54     mapping (address => mapping (uint256 => uint256)) frozenday;
55     
56 
57     string public constant name = "FANCO";
58     string public constant symbol = "FANCO";
59     uint public constant decimals = 3;
60     uint256 _Rate = 10 ** decimals; 
61     uint256 public totalSupply = 5000000000 * _Rate;
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65 
66 
67 
68     modifier onlyOwner() {
69         require(msg.sender == owner);
70         _;
71     }
72 
73     modifier onlyPayloadSize(uint size) {
74         assert(msg.data.length >= size + 4);
75         _;
76     }
77 
78      function FANCO() public {
79         owner = msg.sender;
80         balances[owner] = totalSupply;
81     }
82     
83      function nowInSeconds() public view returns (uint256){
84         return now;
85     }
86     
87     function transferOwnership(address newOwner) onlyOwner public {
88         if (newOwner != address(0) && newOwner != owner) {          
89              owner = newOwner;   
90         }
91     }
92 
93     function locked(address _to,uint256 _frozenmonth, uint256 _month, uint256 _amount) private {
94 		uint lockmon;
95         uint frozenmon;
96         lockmon = _month * 30 * 1 days;
97         frozenmon =  _frozenmonth * 30 * 1 days;
98 		times[_to] += 1;
99         locktime[_to][times[_to]] = now;
100         lockday[_to][times[_to]] = lockmon;
101         lockdata[_to][times[_to]] = _amount;
102         frozenday[_to][times[_to]] = frozenmon;
103         
104         balances[msg.sender] = balances[msg.sender].sub(_amount);
105         balances[_to] = balances[_to].add(_amount);
106     }
107 
108 
109     function balanceOf(address _owner) constant public returns (uint256) {
110 	    return balances[_owner];
111     }
112 
113     function lockOf(address _owner) constant public returns (uint256) {
114     uint locknum = 0;
115     uint unlocknum;
116     
117     for (uint8 i = 1; i < times[_owner] + 1; i++){
118         if(frozenday[_owner][i]==0){
119             unlocknum = 30* 1 days;
120         }
121         else{
122             unlocknum = 1* 1 days;
123         }
124         if(now < locktime[_owner][i] + frozenday[_owner][i] + unlocknum){
125             locknum += lockdata[_owner][i];
126         }
127         else{
128             if(now < locktime[_owner][i] + lockday[_owner][i] + frozenday[_owner][i] + 1* 1 days){
129 				uint lockmon = lockday[_owner][i].div(unlocknum);
130 				uint locknow = (now - locktime[_owner][i] - frozenday[_owner][i]).div(unlocknum);
131                 locknum += ((lockmon-locknow).mul(lockdata[_owner][i])).div(lockmon);
132               }
133               else{
134                  locknum += 0;
135               }
136         }
137     }
138 
139 
140 	    return locknum;
141     }
142 
143     function locktransfer(address _to, uint256 _month,uint256 _point) onlyOwner onlyPayloadSize(2 * 32) public returns (bool success) {
144         require( _point>= 0 && _point<= 10000);
145         uint256 amount; 
146         amount = (totalSupply.div(10000)).mul( _point);
147         
148         require(_to != address(0));
149         require(amount <= (balances[msg.sender].sub(lockOf(msg.sender))));
150         uint256 _frozenmonth = 0;              
151         locked(_to,_frozenmonth, _month, amount);
152         
153         Transfer(msg.sender, _to, amount);
154         return true;
155     }
156     
157         function frozentransfer(address _to,uint256 _frozenmonth, uint256 _month,uint256 _point) onlyOwner onlyPayloadSize(2 * 32) public returns (bool success) {
158         require( _point>= 0 && _point<= 10000);
159         require( _frozenmonth> 0);
160         uint256 amount; 
161         amount = (totalSupply.div(10000)).mul( _point);
162         
163         require(_to != address(0));
164         require(amount <= (balances[msg.sender].sub(lockOf(msg.sender))));
165                       
166         locked(_to,_frozenmonth, _month, amount);
167         
168         Transfer(msg.sender, _to, amount);
169         return true;
170     }
171 
172     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
173 
174         require(_to != address(0));
175         require(_amount <= (balances[msg.sender].sub(lockOf(msg.sender))));
176                       
177         balances[msg.sender] = balances[msg.sender].sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179 		
180         Transfer(msg.sender, _to, _amount);
181         return true;
182     }
183   
184     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
185 
186         require(_to != address(0));
187         require(_amount <= balances[_from]);
188         require(_amount <= balances[_from].sub(lockOf(msg.sender)));
189         require(_amount <= allowed[_from][msg.sender]);
190 
191         
192         balances[_from] = balances[_from].sub(_amount);
193         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
194         balances[_to] = balances[_to].add(_amount);
195         Transfer(_from, _to, _amount);
196         return true;
197     }
198 
199     function approve(address _spender, uint256 _value) public returns (bool success) {
200         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
201         allowed[msg.sender][_spender] = _value;
202         Approval(msg.sender, _spender, _value);
203         return true;
204     }
205 
206     function allowance(address _owner, address _spender) constant public returns (uint256) {
207         return allowed[_owner][_spender];
208     }
209 
210     function withdraw() onlyOwner public {
211         uint256 etherBalance = this.balance;
212         address theowner = msg.sender;
213         theowner.transfer(etherBalance);
214     }
215 }