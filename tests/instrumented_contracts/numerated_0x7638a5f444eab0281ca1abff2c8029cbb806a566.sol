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
41 contract XOXOCoin is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner1 = msg.sender; 
45     address owner2; 
46 
47     mapping (address => uint256) balances; 
48     mapping (address => mapping (address => uint256)) allowed;
49     mapping (address => uint256) times;//Ͷ�Ŵ���T
50     mapping (address => mapping (uint256 => uint256)) dorpnum;//��ӦT��ŵ�Ͷ����Ŀ
51     mapping (address => mapping (uint256 => uint256)) dorptime;//��ӦT��ŵ�Ͷ��ʱ���
52     mapping (address => mapping (uint256 => uint256)) freeday;//��ӦT��ŵĶ���ʱ��
53     
54     
55     mapping (address => bool) public frozenAccount;
56     mapping (address => bool) public airlist;
57 
58     string public constant name = "XOXOCoin";
59     string public constant symbol = "XOX";
60     uint public constant decimals = 8;
61     uint256 _Rate = 10 ** decimals; 
62     uint256 public totalSupply = 200000000 * _Rate;
63 
64     uint256 public totalDistributed = 0;
65     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
66     uint256 public value;
67     uint256 public _per = 1;
68     bool public distributionClosed = true;
69 
70     event Transfer(address indexed _from, address indexed _to, uint256 _value);
71     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
72     event FrozenFunds(address target, bool frozen);
73     event Distr(address indexed to, uint256 amount);
74     event DistrClosed(bool Closed);
75 
76     modifier onlyOwner() {
77         require(msg.sender == owner1 || msg.sender == owner2);
78         _;
79     }
80 
81     modifier onlyPayloadSize(uint size) {
82         assert(msg.data.length >= size + 4);
83         _;
84     }
85 
86      function XOXOCoin (address _owner) public {
87         owner1 = msg.sender;
88         owner2 = _owner;
89         value = 200 * _Rate;
90     }
91      function nowInSeconds() returns (uint256){
92         return now;
93     }
94     function transferOwnership(address newOwner) onlyOwner public {
95         if (newOwner != address(0) && newOwner != owner1 && newOwner != owner2) {
96             if(msg.sender == owner1){
97              owner1 = newOwner;   
98             }
99             if(msg.sender == owner2){
100              owner2 = newOwner;   
101             }
102         }
103     }
104 
105     function closeDistribution(bool Closed) onlyOwner public returns (bool) {
106         distributionClosed = Closed;
107         DistrClosed(Closed);
108         return true;
109     }
110 
111    function Set_per(uint256 per) onlyOwner public returns (bool) {
112    require(per <= 100 && per >= 1);
113 
114         _per  = per;
115         return true;
116     }
117 
118     function distr(address _to, uint256 _amount, uint256 _freeday) private returns (bool) {
119          if (_amount > totalRemaining) {
120             _amount = totalRemaining;
121         }
122         totalDistributed = totalDistributed.add(_amount);
123         totalRemaining = totalRemaining.sub(_amount);
124         balances[_to] = balances[_to].add(_amount);
125         if (_freeday>0) {times[_to] += 1;
126         dorptime[_to][times[_to]] = now;
127         freeday[_to][times[_to]] = _freeday * 1 days;
128         dorpnum[_to][times[_to]] = _amount;}
129 
130         if (totalDistributed >= totalSupply) {
131             distributionClosed = true;
132         }        
133         Distr(_to, _amount);
134         Transfer(address(0), _to, _amount);
135         return true;
136         
137 
138     }
139  
140 
141     function distribute(address[] addresses, uint256[] amounts, uint256 _freeday) onlyOwner public {
142 
143         require(addresses.length <= 255);
144         require(addresses.length == amounts.length);
145         
146         for (uint8 i = 0; i < addresses.length; i++) {
147             require(amounts[i] * _Rate <= totalRemaining);
148             distr(addresses[i], amounts[i] * _Rate, _freeday);
149         }
150     }
151 
152     function () external payable {
153             getTokens();
154      }
155 
156     function getTokens() payable public {
157         if(!distributionClosed){
158         if (value > totalRemaining) {
159             value = totalRemaining;
160         }
161         address investor = msg.sender;
162         uint256 toGive = value;
163         require(value <= totalRemaining);
164         
165         if(!airlist[investor]){
166         totalDistributed = totalDistributed.add(toGive);
167         totalRemaining = totalRemaining.sub(toGive);
168         balances[investor] = balances[investor].add(toGive);
169         times[investor] += 1;
170         dorptime[investor][times[investor]] = now;
171         freeday[investor][times[investor]] = 180 * 1 days;
172         dorpnum[investor][times[investor]] = toGive;
173         airlist[investor] = true;
174         if (totalDistributed >= totalSupply) {
175             distributionClosed = true;
176         }        
177         Distr(investor, toGive);
178         Transfer(address(0), investor, toGive);
179         }
180         }
181     }
182     //
183     function freeze(address[] addresses,bool locked) onlyOwner public {
184         
185         require(addresses.length <= 255);
186         
187         for (uint i = 0; i < addresses.length; i++) {
188             freezeAccount(addresses[i], locked);
189         }
190     }
191     
192     function freezeAccount(address target, bool B) private {
193         frozenAccount[target] = B;
194         FrozenFunds(target, B);
195     }
196 
197     function balanceOf(address _owner) constant public returns (uint256) {
198       if(!distributionClosed && !airlist[_owner]){
199        return balances[_owner] + value;
200        }
201 	    return balances[_owner];
202     }
203 //��ѯ��ַ��������
204     function lockOf(address _owner) constant public returns (uint256) {
205     uint locknum = 0;
206     for (uint8 i = 1; i < times[_owner] + 1; i++){
207       if(now < dorptime[_owner][i] + freeday[_owner][i] + 1* 1 days){
208             locknum += dorpnum[_owner][i];
209         }
210        else{
211             if(now < dorptime[_owner][i] + freeday[_owner][i] + 100/_per* 1 days){
212                locknum += ((now - dorptime[_owner][i] - freeday[_owner][i] )/(1 * 1 days)*dorpnum[_owner][i]*_per/100);
213               }
214               else{
215                  locknum += 0;
216               }
217         }
218     }
219 	    return locknum;
220     }
221 
222     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
223 
224         require(_to != address(0));
225         require(_amount <= (balances[msg.sender] - lockOf(msg.sender)));
226         require(!frozenAccount[msg.sender]);                     
227         require(!frozenAccount[_to]);                      
228         balances[msg.sender] = balances[msg.sender].sub(_amount);
229         balances[_to] = balances[_to].add(_amount);
230         Transfer(msg.sender, _to, _amount);
231         return true;
232     }
233   
234     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
235 
236         require(_to != address(0));
237         require(_amount <= balances[_from]);
238         require(_amount <= (allowed[_from][msg.sender] - lockOf(msg.sender)));
239 
240         
241         balances[_from] = balances[_from].sub(_amount);
242         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
243         balances[_to] = balances[_to].add(_amount);
244         Transfer(_from, _to, _amount);
245         return true;
246     }
247 
248     function approve(address _spender, uint256 _value) public returns (bool success) {
249         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
250         allowed[msg.sender][_spender] = _value;
251         Approval(msg.sender, _spender, _value);
252         return true;
253     }
254 
255     function allowance(address _owner, address _spender) constant public returns (uint256) {
256         return allowed[_owner][_spender];
257     }
258 
259     function withdraw() onlyOwner public {
260         uint256 etherBalance = this.balance;
261         address owner = msg.sender;
262         owner.transfer(etherBalance);
263     }
264 }