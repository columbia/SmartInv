1 pragma solidity ^0.4.18;
2 
3 contract MigrationAgent {
4     function migrateFrom(address _from, uint256 _value);
5 }
6 
7 contract ERC20Interface {
8      function totalSupply() constant returns (uint256 totalSupply);
9      function balanceOf(address _owner) constant returns (uint256 balance);
10      function transfer(address _to, uint256 _value) returns (bool success);
11      function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
12      function approve(address _spender, uint256 _value) returns (bool success);
13      function allowance(address _owner, address _spender) constant returns (uint256 remaining);
14      event Transfer(address indexed _from, address indexed _to, uint256 _value);
15      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
16 }
17 
18 /// ETH (EEE)
19 contract ETHToken is ERC20Interface {
20     string public constant name = "ETHToken";
21     string public constant symbol = "EEE";
22     uint8 public constant decimals = 18;  // 18 decimal places, the same as ETH.
23     uint256 public constant tokenCreationCap = 3000000* 10**18;
24     uint256 public constant tokenCreationMin = 1* 10**18;
25     mapping(address => mapping (address => uint256)) allowed;
26     uint public fundingStart;
27     uint public fundingEnd;
28     bool public funding = true;
29     address public master;
30     uint256 totalTokens;
31     uint256 soldAfterPowerHour;
32     mapping (address => uint256) balances;
33     mapping (address => uint) lastTransferred;
34     mapping (address => uint256) balancesEther;
35     address public migrationAgent;
36     uint256 public totalMigrated;
37     event Migrate(address indexed _from, address indexed _to, uint256 _value);
38     event Refund(address indexed _from, uint256 _value);
39     uint totalParticipants;
40 
41     function ETHToken() {
42         master = msg.sender;
43         fundingStart = 1511654250;
44         fundingEnd = 1511663901;
45     }
46     
47     function getAmountofTotalParticipants() constant returns (uint){
48         return totalParticipants;
49     }
50     
51     function getAmountSoldAfterPowerDay() constant external returns(uint256){
52         return soldAfterPowerHour;
53     }
54 
55     function transfer(address _to, uint256 _value) returns (bool success) {
56         if(funding) throw;
57 
58         var senderBalance = balances[msg.sender];
59         if (senderBalance >= _value && _value > 0) {
60             senderBalance -= _value;
61             balances[msg.sender] = senderBalance;
62             
63             balances[_to] += _value;
64             
65             lastTransferred[msg.sender]=block.timestamp;
66             Transfer(msg.sender, _to, _value);
67             return true;
68         }
69         return false;
70     }
71     function totalSupply() constant returns (uint256 totalSupply) {
72         return totalTokens;
73     }
74     function balanceOf(address _owner) constant returns (uint256 balance) {
75         return balances[_owner];
76     }
77     function EtherBalanceOf(address _owner) constant returns (uint256) {
78         return balancesEther[_owner];
79     }
80     function TimeLeft() external constant returns (uint256) {
81         if(fundingEnd>block.timestamp)
82             return fundingEnd-block.timestamp;
83         else
84             return 0;
85     }
86     function TimeLeftBeforeCrowdsale() external constant returns (uint256) {
87         if(fundingStart>block.timestamp)
88             return fundingStart-block.timestamp;
89         else
90             return 0;
91     }
92 function migrate(uint256 _value) external {
93         if(funding) throw;
94         if(migrationAgent == 0) throw;
95         if(_value == 0) throw;
96         if(_value > balances[msg.sender]) throw;
97         balances[msg.sender] -= _value;
98         totalTokens -= _value;
99         totalMigrated += _value;
100         MigrationAgent(migrationAgent).migrateFrom(msg.sender, _value);
101         Migrate(msg.sender, migrationAgent, _value);
102     }
103 
104     function setMigrationAgent(address _agent) external {
105         if(funding) throw;
106         
107         if(migrationAgent != 0) throw;
108         
109         if(msg.sender != master) throw;
110         
111         migrationAgent = 0x52918621C4bFcdb65Bb683ba5bDC03e398451Afd;
112     }
113     
114     function getExchangeRate() constant returns(uint){
115             return 30000; // 30000 
116     }
117     
118     function ICOopen() constant returns(bool){
119         if(!funding) return false;
120         else if(block.timestamp < fundingStart) return false;
121         else if(block.timestamp > fundingEnd) return false;
122         else if(tokenCreationCap <= totalTokens) return false;
123         else return true;
124     }
125 
126     function() payable external {
127         if(!funding) throw;
128         if(block.timestamp < fundingStart) throw;
129         if(block.timestamp > fundingEnd) throw;
130         if(msg.value == 0) throw;
131         if((msg.value  * getExchangeRate()) > (tokenCreationCap - totalTokens)) throw;
132         var numTokens = msg.value * getExchangeRate();
133         totalTokens += numTokens;
134         
135         if(getExchangeRate()!=30000){
136             soldAfterPowerHour += numTokens;
137         }
138         balances[msg.sender] += numTokens;
139         balancesEther[msg.sender] += msg.value;
140         totalParticipants+=1;
141         Transfer(0, msg.sender, numTokens);
142     }
143 
144     function finalize() external {
145         if(!funding) throw;
146         funding = false;
147         uint256 percentOfTotal = 25;
148         uint256 additionalTokens = totalTokens * percentOfTotal / (37 + percentOfTotal);
149         totalTokens += additionalTokens;
150         balances[master] += additionalTokens;
151         Transfer(0, master, additionalTokens);
152         if (!master.send(this.balance)) throw;
153     }
154 
155     function refund() external {
156         if(!funding) throw;
157         if(block.timestamp <= fundingEnd) throw;
158         if(totalTokens >= tokenCreationMin) throw;
159 
160         var ethuValue = balances[msg.sender];
161         var ethValue = balancesEther[msg.sender];
162         if (ethuValue == 0) throw;
163         balances[msg.sender] = 0;
164         balancesEther[msg.sender] = 0;
165         totalTokens -= ethuValue;
166 
167         Refund(msg.sender, ethValue);
168         if (!msg.sender.send(ethValue)) throw;
169     }
170   
171      function transferFrom(address _from,address _to,uint256 _amount) returns (bool success) {
172          if(funding) throw;
173          if (balances[_from] >= _amount
174              && allowed[_from][msg.sender] >= _amount
175              && _amount > 0
176              && balances[_to] + _amount > balances[_to]) {
177              balances[_from] -= _amount;
178              allowed[_from][msg.sender] -= _amount;
179              balances[_to] += _amount;
180              Transfer(_from, _to, _amount);
181              return true;
182          } else {
183              return false;
184          }
185      }
186   
187      function approve(address _spender, uint256 _amount) returns (bool success) {
188          if(funding) throw;
189          allowed[msg.sender][_spender] = _amount;
190          Approval(msg.sender, _spender, _amount);
191          return true;
192      }
193   
194      function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
195          return allowed[_owner][_spender];
196      }
197 }