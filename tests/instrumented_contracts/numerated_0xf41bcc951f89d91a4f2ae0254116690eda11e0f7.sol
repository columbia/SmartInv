1 pragma solidity ^0.5.0;
2 
3 contract ETHFlow {
4     using SafeMath for uint256;
5     
6     struct Tariff {
7         uint256 id;
8         string name;
9         uint256 price;
10         uint256 time;
11         uint256 value;
12         uint256 duration;
13         uint256 monthly;
14     }
15 
16     mapping(uint256 => Tariff) public tariffs;
17     mapping(address => uint256) public tariffOf;
18     mapping(address => uint256) public tariffTime;
19     mapping(address => uint256) public time;
20     mapping(address => bool) public active;
21     mapping(address => uint256) public balanceUser;
22     mapping(address => address) public myReferrer;
23     //address of refer - address of referal - amount of percentage
24     mapping(address => mapping(address => uint256)) public statistic;
25     mapping(address => address[]) public referals;
26     mapping(address => uint256) public referalsEarning;
27     address payable private admin = 0xc5568a59A56cFe4887fCca38eDA3dF202b8654d0;
28     uint256 private adminPercent = 10;
29     uint256 private percentFromEachProfit = 20;
30 
31     event Deposit(
32         address Investor, 
33         uint256 Amount
34     );
35 
36     constructor() public {
37         tariffs[1].id = 1;
38         tariffs[1].name = 'free';
39         tariffs[1].price = 0;
40         tariffs[1].time = 3 * 1 hours;                      //180 min
41         tariffs[1].value = 360 * 1 szabo;          //0.00036 ETH
42         tariffs[1].duration = 0;
43         tariffs[1].monthly = 108 * 1 finney;    //0.108 ETH
44 
45         tariffs[2].id = 2;
46         tariffs[2].name = 'tariff1';
47         tariffs[2].price = 50 * 1 finney;       //0.05 ETH
48         tariffs[2].time = 90 * 1 minutes;                     //90 min
49         tariffs[2].value = 540 * 1 szabo;         //0.00054 ETH
50         tariffs[2].duration = 476 * 1 hours;              //19 days 20 hours
51         tariffs[2].monthly = 259200 * 1 szabo;    //0.2592 ETH
52 
53         tariffs[3].id = 3;
54         tariffs[3].name = 'tariff2';
55         tariffs[3].price = 100 * 1 finney;      //0.1 ETH
56         tariffs[3].time = 1 hours;                     //60 min
57         tariffs[3].value = 900 * 1 szabo;         //0.0009 ETH
58         tariffs[3].duration = 438 * 1 hours;              //18 days 6 hours
59         tariffs[3].monthly = 648 * 1 finney;    //0.648 ETH
60 
61         tariffs[4].id = 4;
62         tariffs[4].name = 'tariff3';
63         tariffs[4].price = 250 * 1 finney;      //0.25 ETH
64         tariffs[4].time = 225 * 1 minutes;                    //225 min
65         tariffs[4].value = 9 * 1 finney;        //0.009 ETH
66         tariffs[4].duration = 416 * 1 hours;              //17 days 8 hours
67         tariffs[4].monthly = 1728 * 1 finney;   //1.728 ETH
68 
69         tariffs[5].id = 5;
70         tariffs[5].name = 'tariff4';
71         tariffs[5].price = 1 ether;     //1 ETH
72         tariffs[5].time = 35295;                    //588.235 min
73         tariffs[5].value = 100 * 1 finney;      //0.1 ETH
74         tariffs[5].duration = 391 * 1 hours;              //16 days 7 hours
75         tariffs[5].monthly = 7344 * 1 finney;   //7.344 ETH
76 
77         tariffs[6].id = 6;
78         tariffs[6].name = 'tariff5';
79         tariffs[6].price = 5 * 1 ether;     //5 ETH
80         tariffs[6].time = 66667;                    //1111.11 min
81         tariffs[6].value = 1 ether;     //1 ETH
82         tariffs[6].duration = 15 * 1 days;              //15 days
83         tariffs[6].monthly = 38880 * 1 ether;  //38.88 ETH
84 
85         tariffs[7].id = 7;
86         tariffs[7].name = 'tariff6';
87         tariffs[7].price = 25 * 1 ether;    //25 ETH
88         tariffs[7].time = 2000 * 1 minutes;                   //2000 min
89         tariffs[7].value = 10 * 1 ether;    //10 ETH
90         tariffs[7].duration = 314 * 1 hours;              //13 days 2 hours
91         tariffs[7].monthly = 216 * 1 ether; //216 ETH
92 
93         tariffs[8].id = 8;
94         tariffs[8].name = 'tariff7';
95         tariffs[8].price = 100 * 1 ether;   //100 ETH
96         tariffs[8].time = 62500;                    //1041,66 min
97         tariffs[8].value = 25 * 1 ether;    //25 ETH
98         tariffs[8].duration = 11 * 1 days;               //11 days
99         tariffs[8].monthly = 1036 * 1 ether;//1036 ETH
100     }
101 
102     function activate(address _referrer) public {
103         require(myReferrer[msg.sender] == address(0));
104         
105         active[msg.sender] = true;
106         time[msg.sender] = now;
107         tariffOf[msg.sender] = 1;
108         
109         address referrer = _referrer;
110 
111         if(referrer == address(0)) {
112             referrer = admin;
113         }
114     
115         myReferrer[msg.sender] = referrer;
116             
117         referals[referrer].push(msg.sender);
118     }
119 
120     function getETH() public payable {
121         require(active[msg.sender], "Need activate first");
122 
123         uint256 userTariff = tariffOf[msg.sender];
124         uint256 value;
125 
126         //tariff expire
127         if(userTariff > 1 && 
128             now > tariffTime[msg.sender].add(tariffs[userTariff].duration)
129         ) {
130             uint256 expire = tariffTime[msg.sender].add(tariffs[userTariff].duration);
131             uint256 tariffDuration = expire.sub(time[msg.sender]);
132             uint256 defaultDuration = now.sub(expire);
133 
134             value = tariffs[userTariff].value
135                         .div(tariffs[userTariff].time)
136                         .mul(tariffDuration);
137             value = value.add(tariffs[1].value
138                         .div(tariffs[1].time)
139                         .mul(defaultDuration));
140 
141             require(value >= tariffs[1].value , "Too early");
142 
143             userTariff = 1;
144             tariffOf[msg.sender] = 1;
145         } else {
146             value = getAmountOfEthForWithdrawal();
147 
148             require(value >= tariffs[userTariff].value , "Too early");
149         }
150 
151         uint256 sum = value;
152         
153         if (myReferrer[msg.sender] != address(0)) {
154             uint256 refSum = sum.mul(percentFromEachProfit).div(100);
155             balanceUser[myReferrer[msg.sender]] = 
156                 balanceUser[myReferrer[msg.sender]].add(refSum);
157                 
158             statistic[myReferrer[msg.sender]][msg.sender] =
159                 statistic[myReferrer[msg.sender]][msg.sender].add(refSum);
160             referalsEarning[myReferrer[msg.sender]] = 
161                 referalsEarning[myReferrer[msg.sender]].add(refSum);
162         }
163         
164         balanceUser[msg.sender] = balanceUser[msg.sender].add(sum);
165         time[msg.sender] = now;
166     }
167 
168     function getAmountOfEthForWithdrawal() public view returns (uint256) {
169         uint256 value;
170         if(now >= tariffs[tariffOf[msg.sender]].time.add(time[msg.sender])) {
171             value = tariffs[tariffOf[msg.sender]].value;
172         } else {
173             value = now.sub(time[msg.sender])
174                 .mul(tariffs[tariffOf[msg.sender]].value
175                     .div(tariffs[tariffOf[msg.sender]].time));
176         }
177         
178         return value;
179     }
180     
181     function getStatistic(address _refer, address _referal) public view returns (uint256) {
182         return statistic[myReferrer[_refer]][_referal];
183     }
184     
185     function getAmountOfReferals() public view returns (uint256) {
186         return referals[msg.sender].length;
187     }
188     
189     function getEarnedMonetFromReferals() public view returns (uint256) {
190         return referalsEarning[msg.sender];
191     }
192 
193     function() external payable {
194         if(msg.value == 0) {
195             getETH();
196         } else {
197             changeTariff();
198         }
199     }
200 
201     function deposit() public payable {
202         emit Deposit(msg.sender, msg.value);
203     }
204 
205     function withdrawal() public {
206         uint256 value = balanceUser[msg.sender];
207 
208         require(value <= address(this).balance, "Not enough ETH on the contract");
209         require(value >= 100 * 1 szabo, "Minimum withdrawal 0.0001 ETH");
210 
211         balanceUser[msg.sender] = 0;
212         msg.sender.transfer(value);
213     }
214 
215     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
216         assembly {
217             addr := mload(add(bys,20))
218         } 
219     }
220 
221     function detectTariffId() public payable returns (uint256) {
222         require(msg.value >= tariffs[1].price, "Insufficient funds");
223 
224         uint256 found = 0;
225         for(uint256 i = 1; i < 8; i++) {
226             if(msg.value >= getPriceForNewTariff(i) && 
227             msg.value < getPriceForNewTariff(i+1)) {
228                 found = i;
229             }
230         }
231         if(msg.value >= getPriceForNewTariff(8)) {
232             found = 8;
233         }
234         
235         return found;
236     }
237     
238     function getPriceForNewTariff(uint256 _newTariff) public view returns (uint256) {
239         if(tariffOf[msg.sender] == 1) {
240             return tariffs[_newTariff].price;
241         }
242         
243         uint256 duration = now - time[msg.sender];
244         uint256 timeLeft = tariffs[tariffOf[msg.sender]].duration
245                     - duration;
246                     
247         if(timeLeft == 0) {
248             return tariffs[_newTariff].price;
249         }
250         
251         uint256 pricePerOneSec = tariffs[tariffOf[msg.sender]].price
252                     / tariffs[tariffOf[msg.sender]].duration;
253         uint256 moneyLeft = pricePerOneSec * timeLeft * 90 / 100;
254         
255         return tariffs[_newTariff].price - moneyLeft;
256     }
257  
258     function changeTariff() public payable {
259         uint256 id = detectTariffId();
260 
261         require(id >= tariffOf[msg.sender]);
262         
263         uint256 commission = getPriceForNewTariff(id).mul(adminPercent).div(100);
264         commission = commission.add(tariffs[id].price
265                         .sub(getPriceForNewTariff(id)).mul(100).div(90)
266                         .sub(tariffs[id].price.sub(getPriceForNewTariff(id))));
267 
268         admin.transfer(commission);
269         msg.sender.transfer(msg.value.sub(getPriceForNewTariff(id)));
270 
271         if(!active[msg.sender]) {
272             active[msg.sender] = true;
273         }
274         
275         time[msg.sender] = now;
276         tariffOf[msg.sender] = id;
277         tariffTime[msg.sender] = now;
278     }
279 }
280 
281 library SafeMath {
282   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
283     if (_a == 0) {
284       return 0;
285     }
286 
287     c = _a * _b;
288     assert(c / _a == _b);
289     return c;
290   }
291 
292   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
293     return _a / _b;
294   }
295 
296   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
297     assert(_b <= _a);
298     return _a - _b;
299   }
300 
301   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
302     c = _a + _b;
303     assert(c >= _a);
304     return c;
305   }
306 }