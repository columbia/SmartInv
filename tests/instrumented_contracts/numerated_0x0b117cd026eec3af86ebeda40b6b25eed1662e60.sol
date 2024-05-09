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
41 contract UBlockChain is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner1 = msg.sender; 
45     address owner2; 
46 
47     mapping (address => uint256) balances; 
48     mapping (address => mapping (address => uint256)) allowed;
49     mapping (address => bool) public frozenAccount;
50     mapping (address => bool) public blacklist;
51 
52     string public constant name = "UBlockChain";
53     string public constant symbol = "UBCoin";
54     uint public constant decimals = 18;
55     
56     uint256 public totalSupply = 32000000000e18;
57 
58     uint256 public totalDistributed = 0;
59     uint256 public totalRemaining = totalSupply.sub(totalDistributed);
60     uint256 public value;
61     bool public distributionClosed = true;
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event FrozenFunds(address target, bool frozen);
66     event Distr(address indexed to, uint256 amount);
67     event DistrClosed(bool Closed);
68 
69     modifier onlyOwner() {
70         require(msg.sender == owner1 || msg.sender == owner2);
71         _;
72     }
73 
74     modifier onlyPayloadSize(uint size) {
75         assert(msg.data.length >= size + 4);
76         _;
77     }
78 
79      function UBlockChain (address _owner) public {
80         owner1 = msg.sender;
81         owner2 = _owner;
82         value = 200e18;
83     }
84 
85     function transferOwnership(address newOwner) onlyOwner public {
86         if (newOwner != address(0) && newOwner != owner1 && newOwner != owner2) {
87             if(msg.sender == owner1){
88              owner1 = newOwner;   
89             }
90             if(msg.sender == owner2){
91              owner2 = newOwner;   
92             }
93         }
94     }
95 
96     function closeDistribution(bool Closed) onlyOwner public returns (bool) {
97         distributionClosed = Closed;
98         DistrClosed(Closed);
99         return true;
100     }
101 
102     function distr(address _to, uint256 _amount) private returns (bool) {
103         totalDistributed = totalDistributed.add(_amount);
104         totalRemaining = totalRemaining.sub(_amount);
105         balances[_to] = balances[_to].add(_amount);
106 
107         if (_amount > 0) {
108             blacklist[_to] = true;
109         }
110         if (totalDistributed >= totalSupply) {
111             distributionClosed = true;
112         }        
113         Distr(_to, _amount);
114         Transfer(address(0), _to, _amount);
115         return true;
116         
117 
118     }
119 
120     function airdrop(address[] addresses) onlyOwner public {
121         
122         require(addresses.length <= 255);
123         require(value <= totalRemaining);
124         
125         for (uint i = 0; i < addresses.length; i++) {
126             require(value <= totalRemaining);
127             distr(addresses[i], value);
128         }
129     }
130  
131     function distribute(address[] addresses, uint256[] amounts) onlyOwner public {
132 
133         require(addresses.length <= 255);
134         require(addresses.length == amounts.length);
135         
136         for (uint8 i = 0; i < addresses.length; i++) {
137             require(amounts[i] <= totalRemaining);
138             distr(addresses[i], amounts[i]);
139         }
140     }
141 
142     function () external payable {
143             getTokens();
144      }
145 
146     function getTokens() payable public {
147         if(!distributionClosed){
148         if (value > totalRemaining) {
149             value = totalRemaining;
150         }
151         address investor = msg.sender;
152         uint256 toGive = value;
153         require(value <= totalRemaining);
154         
155         if(!blacklist[investor]){
156           distr(investor, toGive);   
157         }
158         }
159     }
160     //
161     function freeze(address[] addresses,bool locked) onlyOwner public {
162         
163         require(addresses.length <= 255);
164         
165         for (uint i = 0; i < addresses.length; i++) {
166             freezeAccount(addresses[i], locked);
167         }
168     }
169     
170     function freezeAccount(address target, bool B) private {
171         frozenAccount[target] = B;
172         FrozenFunds(target, B);
173     }
174 
175     function balanceOf(address _owner) constant public returns (uint256) {
176 	    return balances[_owner];
177     }
178 
179     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
180 
181         require(_to != address(0));
182         require(_amount <= balances[msg.sender]);
183         require(!frozenAccount[msg.sender]);                     
184         require(!frozenAccount[_to]);                      
185         balances[msg.sender] = balances[msg.sender].sub(_amount);
186         balances[_to] = balances[_to].add(_amount);
187         Transfer(msg.sender, _to, _amount);
188         return true;
189     }
190   
191     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
192 
193         require(_to != address(0));
194         require(_amount <= balances[_from]);
195         require(_amount <= allowed[_from][msg.sender]);
196         
197         balances[_from] = balances[_from].sub(_amount);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
199         balances[_to] = balances[_to].add(_amount);
200         Transfer(_from, _to, _amount);
201         return true;
202     }
203 
204     function approve(address _spender, uint256 _value) public returns (bool success) {
205         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
206         allowed[msg.sender][_spender] = _value;
207         Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function allowance(address _owner, address _spender) constant public returns (uint256) {
212         return allowed[_owner][_spender];
213     }
214 
215     function withdraw() onlyOwner public {
216         uint256 etherBalance = this.balance;
217         address owner = msg.sender;
218         owner.transfer(etherBalance);
219     }
220 }