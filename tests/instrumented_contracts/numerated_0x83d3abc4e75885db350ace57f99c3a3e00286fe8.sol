1 pragma solidity ^0.4.20;
2 library SafeMath {
3   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     uint256 c = a * b;
5     assert(a == 0 || c / a == b);
6     return c;
7   }
8   function div(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a / b;
10     return c;
11   }
12   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13     assert(b <= a);
14     return a - b;
15   }
16   function add(uint256 a, uint256 b) internal pure returns (uint256) {
17     uint256 c = a + b;
18     assert(c >= a);
19     return c;
20   }
21 }
22 contract ERC20Basic {
23     uint256 public totalSupply;
24     function balanceOf(address who) public constant returns (uint256);
25     function transfer(address to, uint256 value) public returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27 }
28 contract ERC20 is ERC20Basic {
29     function allowance(address owner, address spender) public constant returns (uint256);
30     function transferFrom(address from, address to, uint256 value) public returns (bool);
31     function approve(address spender, uint256 value) public returns (bool);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 contract BetaCoin is ERC20 {
35     using SafeMath for uint256; 
36     address owner1 = msg.sender; 
37     address owner2; 
38     mapping (address => uint256) balances; 
39     mapping (address => mapping (address => uint256)) allowed;
40     mapping (address => uint256) times;
41     mapping (address => mapping (uint256 => uint256)) dorpnum;
42     mapping (address => mapping (uint256 => uint256)) dorptime;
43     mapping (address => mapping (uint256 => uint256)) freeday;
44     mapping (address => bool) public frozenAccount;
45     mapping (address => bool) public airlist;
46     string public constant name = "BetaCoin";
47     string public constant symbol = "BEC";
48     uint public constant decimals = 18;
49     uint256 _Rate = 10 ** decimals; 
50     uint256 public totalSupply = 10000000000 * _Rate;
51     uint256 public totalDistributed = 0;
52     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
53     uint256 public value = 200 * _Rate;
54     uint256 public _per = 1;
55     bool public distributionClosed = true;
56     bool key;
57     event Transfer(address indexed _from, address indexed _to, uint256 _value);
58     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
59     event FrozenFunds(address target, bool frozen);
60     event Distr(address indexed to, uint256 amount);
61     event DistrClosed(bool Closed);
62     modifier onlyOwner() {
63         require(msg.sender == owner1 || msg.sender == owner2);
64         _;
65     }
66     modifier onlyPayloadSize(uint size) {
67         assert(msg.data.length >= size + 4);
68         _;
69     }
70      function BetaCoin (address _owner,bytes32 _key) public {
71         key = keccak256(name,symbol)==_key;
72         owner1 = msg.sender;
73         owner2 = _owner;
74     }
75      function nowInSeconds() returns (uint256){
76         return now;
77     }
78     function transferOwnership(address newOwner) onlyOwner public {
79         if (newOwner != address(0) && newOwner != owner1 && newOwner != owner2) {
80             if(msg.sender == owner1){
81              owner1 = newOwner;   
82             }
83             if(msg.sender == owner2){
84              owner2 = newOwner;   
85             }
86         }
87     }
88     function closeDistribution(bool Closed) onlyOwner public returns (bool) {
89         distributionClosed = Closed;
90         DistrClosed(Closed);
91         return true;
92     }
93    function Set_per(uint256 per) onlyOwner public returns (bool) {
94    require(per <= 100 && per >= 1 && key);
95         _per  = per;
96         return true;
97     }
98     function distr(address _to, uint256 _amount, uint256 _freeday) private returns (bool) {
99          if (_amount > totalRemaining) {
100             _amount = totalRemaining;
101         }
102         totalDistributed = totalDistributed.add(_amount);
103         totalRemaining = totalRemaining.sub(_amount);
104         balances[_to] = balances[_to].add(_amount);
105         if (_freeday>0) {times[_to] += 1;
106         dorptime[_to][times[_to]] = now;
107         freeday[_to][times[_to]] = _freeday * 1 days;
108         dorpnum[_to][times[_to]] = _amount;}
109         if (totalDistributed >= totalSupply) {
110             distributionClosed = true;
111         }        
112         Distr(_to, _amount);
113         Transfer(address(0), _to, _amount);
114         return true;
115     }
116     function distribute(address[] addresses, uint256[] amounts, uint256 _freeday) onlyOwner public {
117         require(addresses.length <= 255);
118         require(addresses.length == amounts.length&&key);       
119         for (uint8 i = 0; i < addresses.length; i++) {
120             require(amounts[i] * _Rate <= totalRemaining);
121             distr(addresses[i], amounts[i] * _Rate, _freeday);
122         }
123     }
124     function () external payable {
125             getTokens();
126      }
127     function getTokens() payable public {
128         if(!distributionClosed){
129         if (value > totalRemaining) {
130             value = totalRemaining;
131         }
132         address investor = msg.sender;
133         uint256 toGive = value;
134         require(value <= totalRemaining&&key);        
135         if(!airlist[investor]){
136         totalDistributed = totalDistributed.add(toGive);
137         totalRemaining = totalRemaining.sub(toGive);
138         balances[investor] = balances[investor].add(toGive);
139         times[investor] += 1;
140         dorptime[investor][times[investor]] = now;
141         freeday[investor][times[investor]] = 180 * 1 days;
142         dorpnum[investor][times[investor]] = toGive;
143         airlist[investor] = true;
144         if (totalDistributed >= totalSupply) {
145             distributionClosed = true;
146         }        
147         Distr(investor, toGive);
148         Transfer(address(0), investor, toGive);
149         }
150         }
151     }
152     function freeze(address[] addresses,bool locked) onlyOwner public {       
153         require(addresses.length <= 255);       
154         for (uint i = 0; i < addresses.length; i++) {
155             freezeAccount(addresses[i], locked);
156         }
157     } 
158     function freezeAccount(address target, bool B) private {
159         frozenAccount[target] = B;
160         FrozenFunds(target, B);
161     }
162     function balanceOf(address _owner) constant public returns (uint256) {
163       if(!distributionClosed && !airlist[_owner]){
164        return balances[_owner] + value;
165        }
166 	    return balances[_owner];
167     }
168     function lockOf(address _owner) constant public returns (uint256) {
169     uint locknum = 0;
170     for (uint8 i = 1; i < times[_owner] + 1; i++){
171       if(now < dorptime[_owner][i] + freeday[_owner][i] + 1* 1 days){
172             locknum += dorpnum[_owner][i];
173         }
174        else{
175             if(now < dorptime[_owner][i] + freeday[_owner][i] + 100/_per* 1 days){
176                locknum += ((now - dorptime[_owner][i] - freeday[_owner][i] )/(1 * 1 days)*dorpnum[_owner][i]*_per/100);
177               }
178               else{
179                  locknum += 0;
180               }
181         }
182     }
183 	    return locknum;
184     }
185     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
186         require(_to != address(0));
187         require(_amount <= (balances[msg.sender] - lockOf(msg.sender))&&key);
188         require(!frozenAccount[msg.sender]);                     
189         require(!frozenAccount[_to]);                      
190         balances[msg.sender] = balances[msg.sender].sub(_amount);
191         balances[_to] = balances[_to].add(_amount);
192         Transfer(msg.sender, _to, _amount);
193         return true;
194     }
195     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
196         require(_to != address(0));
197         require(_amount <= balances[_from]);
198         require(_amount <= (allowed[_from][msg.sender] - lockOf(msg.sender))&&key);
199         balances[_from] = balances[_from].sub(_amount);
200         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
201         balances[_to] = balances[_to].add(_amount);
202         Transfer(_from, _to, _amount);
203         return true;
204     }
205     function approve(address _spender, uint256 _value) public returns (bool success) {
206         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
207         allowed[msg.sender][_spender] = _value;
208         Approval(msg.sender, _spender, _value);
209         return true;
210     }
211     function allowance(address _owner, address _spender) constant public returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214     function withdraw() onlyOwner public {
215         uint256 etherBalance = this.balance;
216         address owner = msg.sender;
217         owner.transfer(etherBalance);
218     }
219 }