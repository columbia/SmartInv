1 pragma solidity ^0.4.11;
2 
3 contract ERC20 
4 {
5     function totalSupply() constant returns (uint);
6     function balanceOf(address who) constant returns (uint);
7     function allowance(address owner, address spender) constant returns (uint);
8     function transfer(address to, uint value) returns (bool ok);
9     function transferFrom(address from, address to, uint value) returns (bool ok);
10     function approve(address spender, uint value) returns (bool ok);
11     event Transfer(address indexed from, address indexed to, uint value);
12     event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 
16 contract workForce
17 {
18     modifier onlyOwner()
19     {
20         require(msg.sender == owner);
21         _;
22     }
23 
24     modifier onlyEmployee()
25     {
26         require(workcrew[ employeeAddressIndex[msg.sender] ].yearlySalaryUSD > 0);
27          _;
28     }
29 
30     /* Oracle address and owner address are the same */
31     modifier onlyOracle()
32     {
33         require(msg.sender == owner);
34         _;
35     }
36 
37     struct Employee
38     {
39         uint employeeId;
40         string employeeName;
41         address employeeAddress;
42         uint[3] usdEthAntTokenDistribution;
43         uint yearlySalaryUSD;
44         uint startDate;
45         uint lastPayday;
46         uint lastTokenConfigDay;
47     }
48 
49     
50     /* Using a dynamic array because can't iterate mappings, or use push,length,delete cmds? */
51     Employee[] workcrew;
52     uint employeeIndex;
53     mapping( uint => uint ) employeeIdIndex;
54     mapping( string => uint ) employeeNameIndex;
55     mapping( address => uint ) employeeAddressIndex;
56     
57     mapping( address => uint ) public exchangeRates;
58     address owner;
59     uint creationDate;
60 
61     /* ANT token is Catnip */
62     address antAddr = 0x529ae9b61c174a3e005eda67eb755342558a1c3f;
63     /* USD token is Space Dollars */
64     address usdAddr = 0x41f1dcb0d41bf1e143461faf42c577a9219da415;
65 
66     ERC20 antToken = ERC20(antAddr);
67     ERC20 usdToken = ERC20(usdAddr);
68     uint oneUsdToEtherRate;
69 
70 
71     /* Constructor sets 1USD to equal 3.2 Finney or 2 Catnip */
72     function workForce() public
73     {
74         owner = msg.sender;
75         creationDate = now;
76         employeeIndex = 1000;
77 
78         exchangeRates[antAddr] = 2;
79         oneUsdToEtherRate = 3200000000000000;
80     }
81 
82     function indexTheWorkcrew() private
83     {
84         for( uint x = 0; x < workcrew.length; x++ )
85         {
86             employeeIdIndex[ workcrew[x].employeeId ] = x;
87             employeeNameIndex[ workcrew[x].employeeName ] = x;
88             employeeAddressIndex[ workcrew[x].employeeAddress ] = x;
89         }
90     }
91 
92     function incompletePercent(uint[3] _distribution) internal returns (bool)
93     {
94         uint sum;
95         for( uint x = 0; x < 3; x++ ){ sum += _distribution[x]; }
96         if( sum != 100 ){ return true; }
97         else{ return false; }
98     }
99 
100     function addEmployee(address _employeeAddress, string _employeeName, uint[3] _tokenDistribution, uint _initialUSDYearlySalary) onlyOwner
101     {
102         if( incompletePercent( _tokenDistribution)){ revert; }
103         employeeIndex++;
104         Employee memory newEmployee;
105         newEmployee.employeeId = employeeIndex;
106         newEmployee.employeeName = _employeeName;
107         newEmployee.employeeAddress = _employeeAddress;
108         newEmployee.usdEthAntTokenDistribution = _tokenDistribution;
109         newEmployee.yearlySalaryUSD = _initialUSDYearlySalary;
110         newEmployee.startDate = now;
111         newEmployee.lastPayday = now;
112         newEmployee.lastTokenConfigDay = now;
113         workcrew.push(newEmployee);
114         indexTheWorkcrew();
115     }
116 
117     function setEmployeeSalary(uint _employeeID, uint _yearlyUSDSalary) onlyOwner
118     {
119         workcrew[ employeeIdIndex[_employeeID] ].yearlySalaryUSD = _yearlyUSDSalary;
120     }
121 
122     function removeEmployee(uint _employeeID) onlyOwner
123     {
124         delete workcrew[ employeeIdIndex[_employeeID] ];
125         indexTheWorkcrew();
126     }
127 
128     function addFunds() payable onlyOwner returns (uint) 
129     {
130         return this.balance;
131     }
132 
133     function getTokenBalance() constant returns (uint, uint)
134     {
135         return ( usdToken.balanceOf(address(this)), antToken.balanceOf(address(this)) );
136     }
137 
138     function scapeHatch() onlyOwner
139     {
140         selfdestructTokens();
141         delete workcrew;
142         selfdestruct(owner);
143     }
144 
145     function selfdestructTokens() private
146     {
147         antToken.transfer( owner,(antToken.balanceOf(address(this))));
148         usdToken.transfer( owner, (usdToken.balanceOf(address(this))));
149     }
150 
151     function getEmployeeCount() constant returns (uint)
152     {
153         return workcrew.length;
154     }
155 
156     function getEmployeeInfoById(uint _employeeId) constant returns (uint, string, uint, address, uint)
157     {
158         uint x = employeeIdIndex[_employeeId];
159         return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
160                 workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
161     }
162     
163     function getEmployeeInfoByName(string _employeeName) constant returns (uint, string, uint, address, uint)
164     {
165         uint x = employeeNameIndex[_employeeName];
166         return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
167                 workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
168     }
169 
170     function calculatePayrollBurnrate() constant returns (uint)
171     {
172         uint monthlyPayout;
173         for( uint x = 0; x < workcrew.length; x++ )
174         {
175             monthlyPayout += workcrew[x].yearlySalaryUSD / 12;
176         }
177         return monthlyPayout;
178     }
179 
180     function calculatePayrollRunway() constant returns (uint)
181     {
182         uint dailyPayout = calculatePayrollBurnrate() / 30;
183         
184         uint UsdBalance = usdToken.balanceOf(address(this));
185         UsdBalance += this.balance / oneUsdToEtherRate;
186         UsdBalance += antToken.balanceOf(address(this)) / exchangeRates[antAddr];
187         
188         uint daysRemaining = UsdBalance / dailyPayout;
189         return daysRemaining;
190     }
191 
192     function setPercentTokenAllocation(uint _usdTokens, uint _ethTokens, uint _antTokens) onlyEmployee
193     {
194         if( _usdTokens + _ethTokens + _antTokens != 100 ){revert;}
195         
196         uint x = employeeAddressIndex[msg.sender];
197 
198         /* change from 1 hours to 24 weeks */
199         if( now < workcrew[x].lastTokenConfigDay + 1 hours ){revert;}
200         workcrew[x].lastTokenConfigDay = now;
201         workcrew[x].usdEthAntTokenDistribution[0] = _usdTokens;
202         workcrew[x].usdEthAntTokenDistribution[1] = _ethTokens;
203         workcrew[x].usdEthAntTokenDistribution[2] = _antTokens;
204     }
205 
206     /* Eventually change this so that a missed payday will carry owed pay over to next payperiod */
207     function payday(uint _employeeId) public onlyEmployee
208     {
209         uint x = employeeIdIndex[_employeeId];
210 
211         /* Change to 4 weeks for monthly pay period */
212         if( now < workcrew[x].lastPayday + 15 minutes ){ revert; }
213         if( msg.sender != workcrew[x].employeeAddress ){ revert; }
214         workcrew[x].lastPayday = now;
215 
216         /* 7680 is for 15min pay periods. Change to 12 for monthly pay period */
217         uint paycheck = workcrew[x].yearlySalaryUSD / 7680;
218         uint usdTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[0] / 100;
219         uint ethTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[1] / 100;
220         uint antTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[2] / 100;
221         
222         ethTransferAmount = ethTransferAmount * oneUsdToEtherRate;
223         msg.sender.transfer(ethTransferAmount);
224         antTransferAmount = antTransferAmount * exchangeRates[antAddr];
225         antToken.transfer( workcrew[x].employeeAddress, antTransferAmount );
226         usdToken.transfer( workcrew[x].employeeAddress, usdTransferAmount );
227     }
228     
229     /* setting 1 USD equals X amount of tokens */
230     function setTokenExchangeRate(address _token, uint _tokenValue) onlyOracle
231     {
232         exchangeRates[_token] = _tokenValue;
233     }
234 
235     /* setting 1 USD equals X amount of wei */
236     function setUsdToEtherExchangeRate(uint _weiValue) onlyOracle
237     {
238         oneUsdToEtherRate = _weiValue;
239     }
240 
241     function UsdToEtherConvert(uint _UsdAmount) constant returns (uint)
242     {
243         uint etherVal = _UsdAmount * oneUsdToEtherRate;
244         return etherVal;
245     }
246 
247     function UsdToTokenConvert(address _token, uint _UsdAmount) constant returns (uint)
248     {
249         uint tokenAmount = _UsdAmount * exchangeRates[_token];
250         return tokenAmount;
251     }
252 }