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
68     /* set to 1 Ether equals 275.00 USD */
69     uint oneUsdToEtherRate;
70 
71 
72     /* Constructor sets 1USD to equal 3.2 Finney or 2 Catnip */
73     function workForce() public
74     {
75         owner = msg.sender;
76         creationDate = now;
77         employeeIndex = 1000;
78 
79         exchangeRates[antAddr] = 2;
80         oneUsdToEtherRate = 3200000000000000;
81     }
82 
83     function indexTheWorkcrew() private
84     {
85         for( uint x = 0; x < workcrew.length; x++ )
86         {
87             employeeIdIndex[ workcrew[x].employeeId ] = x;
88             employeeNameIndex[ workcrew[x].employeeName ] = x;
89             employeeAddressIndex[ workcrew[x].employeeAddress ] = x;
90         }
91     }
92 
93     function incompletePercent(uint[3] _distribution) internal returns (bool)
94     {
95         uint sum;
96         for( uint x = 0; x < 3; x++ ){ sum += _distribution[x]; }
97         if( sum != 100 ){ return true; }
98         else{ return false; }
99     }
100 
101     function addEmployee(address _employeeAddress, string _employeeName, uint[3] _tokenDistribution, uint _initialUSDYearlySalary) onlyOwner
102     {
103         if( incompletePercent( _tokenDistribution)){ revert; }
104         employeeIndex++;
105         Employee memory newEmployee;
106         newEmployee.employeeId = employeeIndex;
107         newEmployee.employeeName = _employeeName;
108         newEmployee.employeeAddress = _employeeAddress;
109         newEmployee.usdEthAntTokenDistribution = _tokenDistribution;
110         newEmployee.yearlySalaryUSD = _initialUSDYearlySalary;
111         newEmployee.startDate = now;
112         newEmployee.lastPayday = now;
113         newEmployee.lastTokenConfigDay = now;
114         workcrew.push(newEmployee);
115         indexTheWorkcrew();
116     }
117 
118     function setEmployeeSalary(uint _employeeID, uint _yearlyUSDSalary) onlyOwner
119     {
120         workcrew[ employeeIdIndex[_employeeID] ].yearlySalaryUSD = _yearlyUSDSalary;
121     }
122 
123     function removeEmployee(uint _employeeID) onlyOwner
124     {
125         delete workcrew[ employeeIdIndex[_employeeID] ];
126         indexTheWorkcrew();
127     }
128 
129     function addFunds() payable onlyOwner returns (uint) 
130     {
131         return this.balance;
132     }
133 
134     function getTokenBalance() constant returns (uint, uint)
135     {
136         return ( usdToken.balanceOf(address(this)), antToken.balanceOf(address(this)) );
137     }
138 
139     function scapeHatch() onlyOwner
140     {
141         selfdestructTokens();
142         delete workcrew;
143         selfdestruct(owner);
144     }
145 
146     function selfdestructTokens() private
147     {
148         antToken.transfer( owner,(antToken.balanceOf(address(this))));
149         usdToken.transfer( owner, (usdToken.balanceOf(address(this))));
150     }
151 
152     function getEmployeeCount() constant onlyOwner returns (uint)
153     {
154         return workcrew.length;
155     }
156 
157     function getEmployeeInfoById(uint _employeeId) constant onlyOwner returns (uint, string, uint, address, uint)
158     {
159         uint x = employeeIdIndex[_employeeId];
160         return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
161                 workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
162     }
163     
164     function getEmployeeInfoByName(string _employeeName) constant onlyOwner returns (uint, string, uint, address, uint)
165     {
166         uint x = employeeNameIndex[_employeeName];
167         return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
168                 workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
169     }
170 
171     function calculatePayrollBurnrate() constant onlyOwner returns (uint)
172     {
173         uint monthlyPayout;
174         for( uint x = 0; x < workcrew.length; x++ )
175         {
176             monthlyPayout += workcrew[x].yearlySalaryUSD / 12;
177         }
178         return monthlyPayout;
179     }
180 
181     function calculatePayrollRunway() constant onlyOwner returns (uint)
182     {
183         uint dailyPayout = calculatePayrollBurnrate() / 30;
184         
185         uint UsdBalance = usdToken.balanceOf(address(this));
186         UsdBalance += this.balance / oneUsdToEtherRate;
187         UsdBalance += antToken.balanceOf(address(this)) / exchangeRates[antAddr];
188         
189         uint daysRemaining = UsdBalance / dailyPayout;
190         return daysRemaining;
191     }
192 
193     function setPercentTokenAllocation(uint _usdTokens, uint _ethTokens, uint _antTokens) onlyEmployee
194     {
195         if( _usdTokens + _ethTokens + _antTokens != 100 ){revert;}
196         
197         uint x = employeeAddressIndex[msg.sender];
198 
199         /* change from 1 hours to 24 weeks */
200         if( now < workcrew[x].lastTokenConfigDay + 1 hours ){revert;}
201         workcrew[x].lastTokenConfigDay = now;
202         workcrew[x].usdEthAntTokenDistribution[0] = _usdTokens;
203         workcrew[x].usdEthAntTokenDistribution[1] = _ethTokens;
204         workcrew[x].usdEthAntTokenDistribution[2] = _antTokens;
205     }
206 
207     /* Eventually change this so that a missed payday will carry owed pay over to next payperiod */
208     function payday(uint _employeeId) public onlyEmployee
209     {
210         uint x = employeeIdIndex[_employeeId];
211 
212         /* Change to 4 weeks for monthly pay period */
213         if( now < workcrew[x].lastPayday + 15 minutes ){ revert; }
214         if( msg.sender != workcrew[x].employeeAddress ){ revert; }
215         workcrew[x].lastPayday = now;
216 
217         /* 7680 is for 15min pay periods. Change to 12 for monthly pay period */
218         uint paycheck = workcrew[x].yearlySalaryUSD / 7680;
219         uint usdTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[0] / 100;
220         uint ethTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[1] / 100;
221         uint antTransferAmount = paycheck * workcrew[x].usdEthAntTokenDistribution[2] / 100;
222         
223         ethTransferAmount = ethTransferAmount * oneUsdToEtherRate;
224         msg.sender.transfer(ethTransferAmount);
225         antTransferAmount = antTransferAmount * exchangeRates[antAddr];
226         antToken.transfer( workcrew[x].employeeAddress, antTransferAmount );
227         usdToken.transfer( workcrew[x].employeeAddress, usdTransferAmount );
228     }
229     
230     /* setting 1 USD equals X amount of tokens */
231     function setTokenExchangeRate(address _token, uint _tokenValue) onlyOracle
232     {
233         exchangeRates[_token] = _tokenValue;
234     }
235 
236     /* setting 1 USD equals X amount of wei */
237     function setUsdToEtherExchangeRate(uint _weiValue) onlyOracle
238     {
239         oneUsdToEtherRate = _weiValue;
240     }
241 
242     function UsdToEtherConvert(uint _UsdAmount) constant returns (uint)
243     {
244         uint etherVal = _UsdAmount * oneUsdToEtherRate;
245         return etherVal;
246     }
247 
248     function UsdToTokenConvert(address _token, uint _UsdAmount) constant returns (uint)
249     {
250         uint tokenAmount = _UsdAmount * exchangeRates[_token];
251         return tokenAmount;
252     }
253 }