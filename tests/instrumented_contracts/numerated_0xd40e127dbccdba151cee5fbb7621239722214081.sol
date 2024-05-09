1 pragma solidity ^0.4.25;
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
41 contract IPCoin is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner = msg.sender; 
45 
46     mapping (address => uint256) balances; 
47     mapping (address => mapping (address => uint256)) allowed;
48     mapping (address => uint256) times;//投放次数T
49     mapping (address => mapping (uint256 => uint256)) dorpnum;//对应T序号的投放数目
50     mapping (address => mapping (uint256 => uint256)) dorptime;//对应T序号的投放时间戳
51     mapping (address => mapping (uint256 => uint256)) freeday;//对应T序号的冻结时间
52     mapping (address => mapping (uint256 => bool)) unlock;//对应T序号的解锁
53     
54     mapping (address => bool) public frozenAccount;
55     mapping (address => bool) public airlist;
56 
57     string public constant name = "IPCoin";
58     string public constant symbol = "IPC";
59     uint public constant decimals = 8;
60     uint256 _Rate = 10 ** decimals; 
61     uint256 public totalSupply = 2000000000 * _Rate;
62 
63 //    uint256 public totalDistributed = 0;
64 //    uint256 public totalRemaining = totalSupply.sub(totalDistributed);
65     uint256 public _value;
66     uint256 public _per = 1;
67     uint256 public _freeday = 90;
68     bool public distributionClosed = true;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     event FrozenFunds(address target, bool frozen);
73     event Distr(address indexed to, uint256 amount);
74     event DistrClosed(bool Closed);
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner);
78         _;
79     }
80 
81     modifier onlyPayloadSize(uint size) {
82         assert(msg.data.length >= size + 4);
83         _;
84     }
85 
86      function IPCoin () public {
87         owner = msg.sender;
88         balances[owner] = totalSupply;
89         _value = 200 * _Rate;
90     }
91      function nowInSeconds() constant public returns (uint256){
92         return now;
93     }
94     function transferOwnership(address newOwner) onlyOwner public {
95         if (newOwner != address(0) && newOwner != owner) {
96              owner = newOwner; 
97         }
98     }
99 
100     function closeDistribution(bool Closed) onlyOwner public returns (bool) {
101         distributionClosed = Closed;
102         emit DistrClosed(Closed);
103         return true;
104     }
105 
106    function Set_distr(uint256 per,uint256 freeday,uint256 value) onlyOwner public returns (bool) {
107    require(per <= 100 && per >= 1);
108    require(value <= 2000000000 && value >= 0);
109         _freeday = freeday;
110         _per  = per;
111         _value = value * _Rate;
112         return true;
113     }
114 
115     function distr(address _to, uint256 _amount, bool _unlock) private returns (bool) {
116          if (_amount > balances[owner]) {
117             _amount = balances[owner];
118         }
119 //        totalDistributed = totalDistributed.add(_amount);
120         balances[owner] = balances[owner].sub(_amount);
121         balances[_to] = balances[_to].add(_amount);
122         times[_to] += 1;
123         dorptime[_to][times[_to]] = now;
124         freeday[_to][times[_to]] = _freeday * 1 days;
125         dorpnum[_to][times[_to]] = _amount;
126         unlock[_to][times[_to]] = _unlock;
127         if (balances[owner] == 0) {
128             distributionClosed = true;
129         }        
130         emit Distr(_to, _amount);
131 //        Transfer(owner, _to, _amount);
132         return true;
133         
134 
135     }
136  
137 
138     function distribute(address[] addresses, uint256[] amounts, bool _unlock) onlyOwner public {
139 
140         require(addresses.length <= 255);
141         require(addresses.length == amounts.length);
142         
143         for (uint8 i = 0; i < addresses.length; i++) {
144             require(amounts[i] * _Rate <= balances[owner]);
145             distr(addresses[i], amounts[i] * _Rate, _unlock);
146         }
147     }
148 
149     function () external payable {
150             getTokens();
151      }
152 
153     function getTokens() payable public {
154         if(!distributionClosed){
155         address investor = msg.sender;
156         uint256 toGive = _value; 
157         if (toGive > balances[owner]) {
158             toGive = balances[owner];
159         }
160         
161         if(!airlist[investor]){
162 //        totalDistributed = totalDistributed.add(toGive);
163         balances[owner] = balances[owner].sub(toGive);
164         balances[investor] = balances[investor].add(toGive);
165         times[investor] += 1;
166         dorptime[investor][times[investor]] = now;
167         freeday[investor][times[investor]] = _freeday * 1 days;
168         dorpnum[investor][times[investor]] = toGive;
169         unlock[investor][times[investor]] = false;
170         airlist[investor] = true;
171         if (_value > balances[owner]) {
172             distributionClosed = true;
173         }        
174         emit Distr(investor, toGive);
175 //        Transfer(address(0), investor, toGive);
176         }
177         }
178     }
179     function unlocked(address _owner) onlyOwner public returns (bool) {
180     for (uint8 i = 1; i < times[_owner] + 1; i++){
181         unlock[_owner][i] = true;
182               }
183 	    return true;
184     }
185     //
186     function freeze(address[] addresses,bool locked) onlyOwner public {
187         
188         require(addresses.length <= 255);
189         
190         for (uint i = 0; i < addresses.length; i++) {
191             freezeAccount(addresses[i], locked);
192         }
193     }
194     
195     function freezeAccount(address target, bool B) private {
196         frozenAccount[target] = B;
197         emit FrozenFunds(target, B);
198     }
199 
200     function balanceOf(address _owner) constant public returns (uint256) {
201       if(!distributionClosed && !airlist[_owner] && _owner!=owner){
202        return balances[_owner] + _value;
203        }
204 	    return balances[_owner];
205     }
206 //查询地址锁定币数
207     function lockOf(address _owner) constant public returns (uint256) {
208     uint locknum = 0;
209     for (uint8 i = 1; i < times[_owner] + 1; i++){
210         if(unlock[_owner][i]){
211                locknum += 0;
212               }
213         else{
214                
215             if(now < dorptime[_owner][i] + freeday[_owner][i] + 1* 1 days){
216             locknum += dorpnum[_owner][i];
217             }
218             else{
219                 if(now < dorptime[_owner][i] + freeday[_owner][i] + 100/_per* 1 days){
220                 locknum += ((now - dorptime[_owner][i] - freeday[_owner][i] )/(1 * 1 days)*dorpnum[_owner][i]*_per/100);
221                 }
222                 else{
223                  locknum += 0;
224                 }
225             }
226         }
227     }
228 	    return locknum;
229     }
230 
231     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
232 
233         require(_to != address(0));
234         require(_amount <= (balances[msg.sender].sub(lockOf(msg.sender))));
235         require(!frozenAccount[msg.sender]);                     
236         require(!frozenAccount[_to]);                      
237         balances[msg.sender] = balances[msg.sender].sub(_amount);
238         balances[_to] = balances[_to].add(_amount);
239         emit Transfer(msg.sender, _to, _amount);
240         return true;
241     }
242   
243     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
244 
245         require(_to != address(0));
246         require(_amount <= balances[_from]);
247         require(_amount <= (allowed[_from][msg.sender].sub(lockOf(msg.sender))));
248 
249         
250         balances[_from] = balances[_from].sub(_amount);
251         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
252         balances[_to] = balances[_to].add(_amount);
253         emit Transfer(_from, _to, _amount);
254         return true;
255     }
256 
257     function approve(address _spender, uint256 _value) public returns (bool success) {
258         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
259         allowed[msg.sender][_spender] = _value;
260         emit Approval(msg.sender, _spender, _value);
261         return true;
262     }
263 
264     function allowance(address _owner, address _spender) constant public returns (uint256) {
265         return allowed[_owner][_spender];
266     }
267 
268     function withdraw() onlyOwner public {
269         uint256 etherBalance = this.balance;
270         address owner = msg.sender;
271         owner.transfer(etherBalance);
272     }
273 }