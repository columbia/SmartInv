1 pragma solidity >=0.5.0 <0.8.0;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender)external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom( address sender, address recipient, uint256 amount ) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval( address indexed owner, address indexed spender, uint256 value );
12 }
13 contract DtaPool{
14     address public _owner;
15     IERC20 public _token;
16     bool public _isRun;
17 
18     constructor(IERC20 addressToken) public {
19         _token = addressToken;
20         _owner = msg.sender;
21         _isRun = true;
22     }
23     struct Pledgor{
24         uint amount;
25         address superiorAddr;
26         uint date;
27         uint profit;
28         uint invitarionDta;
29         uint8 exist;
30         uint lastDate;
31         uint lastAmount;
32         uint startPledgeDate;
33         uint receiveDate;
34     }
35     Pledgor[] public pledgor;
36     mapping(address => Pledgor) public pledgors;
37     mapping(address => mapping(uint => uint)) public userDayAmount;
38     mapping(address => mapping(uint => uint)) public userDfAmount;
39     address[] public pllist;
40     struct Snapshot {
41         uint date;
42         uint totalNewPledge;
43         uint teamProfitPeopleA;
44         uint teamProfitPeopleB;
45         uint teamProfitPeopleC;
46         uint teamProfitC;
47         uint dtaPrice;
48         uint totalPeople;
49     }
50     Snapshot[] public snapshot;
51     mapping(uint => Snapshot) public snapshots;
52     uint[] public dateList;
53     function snapshotCreate(
54         uint _date,
55         uint _totalNewPledge,
56         uint teamProfitPeopleA,
57         uint teamProfitPeopleB,
58         uint teamProfitPeopleC,
59         uint _teamProfitC,
60         uint _dtaPrice,
61         uint _totalPeople
62     ) public {
63         require(_owner == msg.sender, "Not an administrator");
64         snapshots[_date] = Snapshot({
65                 date: _date,
66                 totalNewPledge: _totalNewPledge,
67                 teamProfitPeopleA: teamProfitPeopleA,
68                 teamProfitPeopleB: teamProfitPeopleB,
69                 teamProfitPeopleC: teamProfitPeopleC,
70                 teamProfitC: _teamProfitC,
71                 dtaPrice: _dtaPrice,
72                 totalPeople: _totalPeople
73             });
74         dateList.push(_date);
75     }
76     function parseInt(string memory _a) internal pure returns (uint256 _parsedInt){
77         return parseInt(_a, 0);
78     }
79     function parseInt(string memory _a, uint256 _b) internal pure returns (uint256 _parsedInt) {
80         bytes memory bresult = bytes(_a);
81         uint256 mint = 0;
82         bool decimals = false;
83         for (uint256 i = 0; i < bresult.length; i++) {
84             if (
85                 (uint256(uint8(bresult[i])) >= 48) &&
86                 (uint256(uint8(bresult[i])) <= 57)
87             ) {
88                 if (decimals) {
89                     if (_b == 0) {
90                         break;
91                     } else {
92                         _b--;
93                     }
94                 }
95                 mint *= 10;
96                 mint += uint256(uint8(bresult[i])) - 48;
97             } else if (uint256(uint8(bresult[i])) == 46) {
98                 decimals = true;
99             }
100         }
101         if (_b > 0) {
102             mint *= 10**_b;
103         }
104         return mint;
105     }
106     function stake(string memory amount, uint _date,address superiorAddr) public {
107         require(_isRun == true, "It doesn't work");
108         uint totalBalanceSender = _token.balanceOf(msg.sender);
109         uint _amount = parseInt(amount);
110         require(
111             totalBalanceSender >= _amount,
112             "ERC20: msg transfer amount exceeds balance"
113         );
114         if(pledgors[msg.sender].amount == 0 ){
115             pledgors[msg.sender].startPledgeDate = _date;
116         }
117         if(pledgors[msg.sender].exist == 0){
118           pllist.push(msg.sender);
119           pledgors[msg.sender].exist = 1;
120           pledgors[msg.sender].lastDate = _date;
121           pledgors[msg.sender].lastAmount = _amount;
122           pledgors[msg.sender].receiveDate = _date;
123         }else{
124           pledgors[msg.sender].lastAmount = pledgors[msg.sender].amount;
125         }
126         if(pledgors[msg.sender].superiorAddr == address(0x0)){
127           _acceptInvitation(superiorAddr);
128         }
129         _token.transferFrom(msg.sender, address(this), _amount);
130         userDayAmount[msg.sender][_date] += _amount;
131         userDfAmount[msg.sender][_date] += _amount;
132         uint8 f = 0;
133         _treeAdd(msg.sender, _amount, f);
134         pledgors[msg.sender].date = _date;
135         pledgors[msg.sender].amount += _amount;
136     }
137     function _acceptInvitation(address addr) internal {
138       require(addr != msg.sender, "You can't invite yourself");
139       require(pledgors[addr].superiorAddr != msg.sender, "Your subordinates can't be your superiors");
140       pledgors[msg.sender].superiorAddr = addr;
141     }
142     function _treeAdd(address addr,uint _amount,uint8 f) internal {
143         pledgors[addr].invitarionDta += _amount;
144         address s = pledgors[addr].superiorAddr;
145         if (s != address(0x0) && f < 10) {
146             f += 1;
147             _treeAdd(s, _amount, f);
148         }
149     }
150     function leave(string memory amount, uint256 _date) public {
151         require(_isRun == true, "It doesn't work");
152         uint _amount = parseInt(amount);
153         require(
154             pledgors[msg.sender].amount >= _amount,
155             "ERC20: msg transfer amount exceeds balance"
156         );
157         if(userDayAmount[msg.sender][_date] != 0){
158            userDayAmount[msg.sender][_date] -= _amount;
159         }
160         userDfAmount[msg.sender][_date] = pledgors[msg.sender].amount - _amount;
161         pledgors[msg.sender].lastDate = pledgors[msg.sender].startPledgeDate;
162         pledgors[msg.sender].startPledgeDate = _date;
163         uint8 f = 0;
164         _treeSub(msg.sender, _amount, f);
165         pledgors[msg.sender].lastAmount = pledgors[msg.sender].amount;
166         pledgors[msg.sender].date = _date;
167         pledgors[msg.sender].amount -= _amount;
168         _token.transfer(msg.sender, _amount);
169     }
170     function _treeSub(address addr,uint _amount,uint8 f) internal {
171       pledgors[addr].invitarionDta -= _amount;
172       address s = pledgors[addr].superiorAddr;
173       if (s != address(0x0) && f < 10) {
174           f += 1;
175           _treeSub(s, _amount, f);
176       }
177     }
178     function changeIsRun() public{
179       require(_owner == msg.sender, "Not an administrator");
180       _isRun = false;
181     }
182     function approveUser(address addr) public {
183        _token.approve(addr,21000000);
184     }
185     function userPledgeNum(address addr) public view returns(uint256){
186       return pledgors[addr].amount;
187     }
188     function totalDtaNumber() public view returns(uint256){
189       return _token.balanceOf(address(this));
190     }
191     function _totalDta() public view returns (uint) {
192         uint totalDta = 0;
193         for (uint i = 0; i < pllist.length; i++) {
194             address s = pllist[i];
195             totalDta += pledgors[s].amount;
196         }
197         return totalDta;
198     }
199     function allAddress() public view returns (address[] memory) {
200         return pllist;
201     }
202     function allDate() public view returns (uint[] memory) {
203         return dateList;
204     }
205     function allUserAddress(address addr) public view returns (address[] memory) {
206         address[] memory addrList = new address[](100);
207         uint8 flag = 0;
208         for (uint i = 0; i < pllist.length; i++) {
209             address s = pllist[i];
210             if(pledgors[s].superiorAddr == addr && flag < 99){
211               addrList[flag] = s;
212               flag += 1;
213             }
214         }
215         return addrList;
216     }
217     function transferAmount(address addr,uint _date,string memory amount) public {
218         require(_owner == msg.sender, "Not an administrator");
219         require(pledgors[addr].receiveDate != _date, "Not an administrator");
220         uint _amount = parseInt(amount);
221         _token.transfer(addr, _amount);
222         pledgors[addr].receiveDate = _date;
223         pledgors[addr].profit += _amount;
224     }
225   }