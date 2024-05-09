1 pragma solidity ^0.4.18;
2 
3 /*
4          _     _                                               _         
5    ___  | |_  | |__     ___   _ __   _ __     ___  __  __     (_)   ___  
6   / _ \ | __| | '_ \   / _ \ | '__| | '_ \   / _ \ \ \/ /     | |  / _ \ 
7  |  __/ | |_  | | | | |  __/ | |    | | | | |  __/  >  <   _  | | | (_) |
8   \___|  \__| |_| |_|  \___| |_|    |_| |_|  \___| /_/\_\ (_) |_|  \___/ 
9 
10 https://ethernex.io/
11 */
12 
13 contract ethernex {
14     using SafeMath for uint256;
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19     
20     struct MemberInfo { uint userID; uint activeEntry; address referrer; uint[] entriesId; address[] referrals; }
21     struct RegInfo { bool isActive; uint amount; uint totalIncome; uint startDate; uint maturityDays; uint withdrawnAmount; }
22     mapping (address => MemberInfo)  memberInfos;
23     mapping(uint => mapping(uint => RegInfo))  RegistrationInfo;
24     mapping(address => uint) public balance;
25     uint256 public totalEntries;
26     address owner;
27     uint public lastMemberID = 2;
28     uint public lastEntryID = 2;
29     
30     constructor() public {
31         owner = msg.sender;
32         MemberInfo storage _memberInfo = memberInfos[owner];
33         _memberInfo.userID = 1;
34     }
35 
36     function register(address uplineAddress) external payable {
37         require(msg.value >= 0.1 ether, "registration starts at 0.1");
38         uint _totalDays = getMaturityDays(msg.value);
39         require(_totalDays > 0, "invalid entry amount.");
40         uint uplineUserId = getUserId(uplineAddress);
41         require(uplineUserId > 0, "upline address not found");
42          uint memberId = getUserId(msg.sender);
43          require(memberId == 0,"address already registered.");
44         memberId = lastMemberID++;   
45         MemberInfo storage _memberInfo = memberInfos[msg.sender]; 
46         _memberInfo.referrer = uplineAddress;
47         _memberInfo.userID = memberId;
48         uint newEntryId = lastEntryID++;
49         _memberInfo.activeEntry += 1;
50         _memberInfo.entriesId.push(newEntryId);
51         RegInfo storage _regInfo = RegistrationInfo[memberId][newEntryId];
52         _regInfo.isActive = true;
53         _regInfo.amount = msg.value;
54         _regInfo.totalIncome = msg.value.mul(10).mul(_totalDays).div(100);
55         _regInfo.startDate = now;
56         _regInfo.maturityDays = _totalDays;
57         MemberInfo storage _uplineInfo = memberInfos[uplineAddress];
58         _uplineInfo.referrals.push(msg.sender);
59         uint _directIncome = msg.value.mul(10).div(100);
60         if(uplineAddress != address(0)){
61             uplineAddress.transfer(_directIncome);
62             balance[uplineAddress] += _directIncome;
63         }
64         owner.transfer(msg.value.mul(8).div(100));
65         totalEntries += msg.value;
66     }
67     
68     function addentry() external payable {
69         require(msg.value >= 0.1 ether, "registration starts at 0.1");
70         uint _totalDays = getMaturityDays(msg.value);
71         require(_totalDays > 0, "invalid entry amount.");
72         uint memberId = getUserId(msg.sender);
73         require(memberId > 0, "address is not yet registered.");
74         address uplineAddress = getUpline(msg.sender);
75         MemberInfo storage _memberInfo = memberInfos[msg.sender]; 
76         uint newEntryId = lastEntryID++;
77         _memberInfo.activeEntry += 1;
78         _memberInfo.entriesId.push(newEntryId);
79         RegInfo storage _regInfo = RegistrationInfo[memberId][newEntryId];
80         _regInfo.isActive = true;
81         _regInfo.amount = msg.value;
82         _regInfo.totalIncome = msg.value.mul(10).mul(_totalDays).div(100);
83         _regInfo.startDate = now;
84         _regInfo.maturityDays = _totalDays;
85         uint _directIncome = msg.value.mul(10).div(100);
86         if(uplineAddress != address(0)){
87             uplineAddress.transfer(_directIncome);
88             balance[uplineAddress] += _directIncome;
89         }
90         owner.transfer(msg.value.mul(8).div(100));
91         totalEntries += msg.value;
92     }
93     
94     function withdrawincome(uint amount, uint entryId) public{
95         uint _userId = getUserId(msg.sender);
96         require(_userId > 0, "invalid account address");
97         uint _balance = getAvailableIncome(_userId, entryId);
98         require(_balance >= amount, "you don't have enough balance");
99         require(address(this).balance >= amount, "source has insufficient fund, try again later.");
100         RegInfo storage _regInfo =  RegistrationInfo[_userId][entryId];
101         _regInfo.withdrawnAmount += amount;
102         balance[msg.sender] += amount;
103         if(_regInfo.withdrawnAmount >= _regInfo.totalIncome){
104             _regInfo.isActive = false;
105         }
106         msg.sender.transfer(amount);
107     }
108     
109     
110     function getMaturityDays(uint amount) pure internal  returns (uint) {
111         uint _days = 20;
112         if(amount == 1 ether){
113             _days = 22;
114         }else if(amount == 10 ether){
115             _days = 25;
116         }
117         return _days;
118     }
119     
120     function getAvailableIncome(uint _userId, uint _entryId) view public returns (uint AvailableBalance) { 
121         RegInfo storage _regInfo =  RegistrationInfo[_userId][_entryId];
122         if(_regInfo.isActive){
123             
124             uint _totalDays = (now - _regInfo.startDate).div(60).div(60).div(24);
125             if(_totalDays > _regInfo.maturityDays){
126                 _totalDays = _regInfo.maturityDays;
127             }
128             uint _dailyIncome = _regInfo.amount.mul(10).div(100);
129             uint _totalIncome = _dailyIncome.mul(_totalDays);
130             uint _balance = _totalIncome.sub(_regInfo.withdrawnAmount);
131             return _balance;
132         }
133         
134         return 0;
135     }
136     
137     function getGrowthDays(uint _userId, uint _entryId) view public returns (uint TotalDays) { 
138         RegInfo storage _regInfo =  RegistrationInfo[_userId][_entryId];
139         if(_regInfo.isActive){
140             
141             uint _totalDays = (now - _regInfo.startDate).div(60).div(60).div(24);
142             if(_totalDays > _regInfo.maturityDays){
143                 _totalDays = _regInfo.maturityDays;
144             }
145             
146             return _totalDays;
147         }
148         
149         return 0;
150     }
151     
152     function getUserId(address _address) view public returns (uint UserId) { 
153         return (memberInfos[_address].userID);
154     }
155     function getEntriesId(address _address) view public returns (uint[] Entries) { 
156         return (memberInfos[_address].entriesId);
157     }
158     
159     function getUpline(address _address) view public returns (address UplineAddress) { 
160         return (memberInfos[_address].referrer);
161     }
162     
163     function getEntryDetails(uint userId, uint entryId) view public returns (bool isActive, uint amountEntry, uint expectedIncome, uint dateStarted, uint maturityDays,  uint withdrawnAmount) {
164         RegInfo storage _regInfo = RegistrationInfo[userId][entryId];
165         return (_regInfo.isActive, _regInfo.amount, _regInfo.totalIncome, _regInfo.startDate,  _regInfo.maturityDays, _regInfo.withdrawnAmount);
166     }
167     
168     function getAllReferrals(address _address) view public returns (address[] Referrals) {
169         return (memberInfos[_address].referrals);
170     }
171 
172 }
173 
174 library SafeMath {
175   function mul(uint256 a, uint256 b) pure internal  returns (uint256) {
176     uint256 c = a * b;
177     assert(a == 0 || c / a == b);
178     return c;
179   }
180  
181   function div(uint256 a, uint256 b) pure internal  returns (uint256) {
182     uint256 c = a / b;
183     return c;
184   }
185  
186   function sub(uint256 a, uint256 b) pure internal  returns (uint256) {
187     assert(b <= a);
188     return a - b;
189   }
190  
191   function add(uint256 a, uint256 b) pure internal  returns (uint256) {
192     uint256 c = a + b;
193     assert(c >= a);
194     return c;
195   }
196 }