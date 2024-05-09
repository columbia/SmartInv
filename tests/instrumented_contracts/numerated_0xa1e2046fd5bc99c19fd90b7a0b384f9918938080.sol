1 pragma solidity ^0.4.22;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         // assert(b > 0); // Solidity automatically throws when dividing by 0
16         uint256 c = a / b;
17         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18         return c;       
19     }       
20 
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         assert(c >= a);
29         return c;
30     }
31 }
32 
33 
34 contract Ownable {
35     address public owner;
36     address public newOwner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39 
40     constructor() public {
41         owner = msg.sender;
42         newOwner = address(0);
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49     modifier onlyNewOwner() {
50         require(msg.sender != address(0));
51         require(msg.sender == newOwner);
52         _;
53     }
54 
55     function transferOwnership(address _newOwner) public onlyOwner {
56         require(_newOwner != address(0));
57         newOwner = _newOwner;
58     }
59 
60     function acceptOwnership() public onlyNewOwner returns(bool) {
61         emit OwnershipTransferred(owner, newOwner);        
62         owner = newOwner;
63         newOwner = 0x0;
64     }
65 }
66 
67 contract Pausable is Ownable {
68     event Pause();
69     event Unpause();
70 
71     bool public paused = false;
72 
73     modifier whenNotPaused() {
74         require(!paused);
75         _;
76     }
77 
78     modifier whenPaused() {
79         require(paused);
80         _;
81     }
82 
83     function pause() onlyOwner whenNotPaused public {
84         paused = true;
85         emit Pause();
86     }
87 
88     function unpause() onlyOwner whenPaused public {
89         paused = false;
90         emit Unpause();
91     }
92 }
93 
94 
95 contract Whitelist is Ownable {
96     uint256 public count;
97     using SafeMath for uint256;
98 
99     //mapping (uint256 => address) public whitelist;
100     mapping (address => bool) public whitelist;
101     mapping (uint256 => address) public indexlist;
102     mapping (address => uint256) public reverseWhitelist;
103 
104 
105     constructor() public {
106         count = 0;
107     }
108     
109     function AddWhitelist(address account) public onlyOwner returns(bool) {
110         require(account != address(0));
111         whitelist[account] = true;
112         if( reverseWhitelist[account] == 0 ) {
113             count = count.add(1);
114             indexlist[count] = account;
115             reverseWhitelist[account] = count;
116         }
117         return true;
118     }
119 
120     function GetLengthofList() public view returns(uint256) {
121         return count;
122     }
123 
124     function RemoveWhitelist(address account) public onlyOwner {
125         require( reverseWhitelist[account] != 0 );
126         whitelist[account] = false;
127     }
128 
129     function GetWhitelist(uint256 index) public view returns(address) {
130         return indexlist[index];        
131     }
132     
133     function IsWhite(address account) public view returns(bool) {
134         return whitelist[account];
135     }
136 }
137 
138 
139 contract Formysale is Ownable, Pausable, Whitelist {    
140     uint256 public weiRaised;         // 현재까지의 Ether 모금액
141     uint256 public personalMincap;    // 최소 모금 참여 가능 Ether
142     uint256 public personalMaxcap;    // 최대 모금 참여 가능 Ether
143     uint256 public startTime;         // 프리세일 시작시간
144     uint256 public endTime;           // 프리세일 종료시간
145     uint256 public exchangeRate;      // 1 Ether 당 SYNCO 교환비율
146     uint256 public remainToken;       // 판매 가능한 토큰의 수량
147     bool    public isFinalized;       // 종료여부
148 
149     uint256 public mtStartTime;       // 교환비율 조정 시작 시간
150     uint256 public mtEndTime;         // 교환비율 조정 종료 시간
151 
152 
153     mapping (address => uint256) public beneficiaryFunded; //구매자 : 지불한 이더
154     mapping (address => uint256) public beneficiaryBought; //구매자 : 구매한 토큰
155 
156     event Buy(address indexed beneficiary, uint256 payedEther, uint256 tokenAmount);
157 
158     constructor(uint256 _rate) public { 
159         startTime = 1532919600;           // 2018년 7월 30일 월요일 오후 12:00:00 KST    (2018년 7월 30일 Mon AM 3:00:00 GMT)
160         endTime = 1534647600;             // 2018년 8월 19일 일요일 오후 12:00:00 KST    (2018년 8월 19일 Sun AM 3:00:00 GMT)
161         remainToken = 6500000000 * 10 ** 18; // 6,500,000,000 개의 토큰 판매
162 
163         exchangeRate = _rate;
164         personalMincap = (1 ether);
165         personalMaxcap = (1000 ether);
166         isFinalized = false;
167         weiRaised = 0x00;
168         mtStartTime = 28800;  //오후 5시 KST
169         mtEndTime = 32400;    //오후 6시 KST
170     }    
171 
172     function buyPresale() public payable whenNotPaused {
173         address beneficiary = msg.sender;
174         uint256 toFund = msg.value;     // 유저가 보낸 이더리움 양(펀딩 할 이더)
175 
176         // 현재 비율에서 구매하게 될 토큰의 수량
177         uint256 tokenAmount = SafeMath.mul(toFund,exchangeRate);
178         // check validity
179         require(!isFinalized);
180         require(validPurchase());       // 판매조건 검증(최소 이더량 && 판매시간 준수 && gas량 && 개인하드캡 초과)
181         require(whitelist[beneficiary]);// WhitList 등록되어야만 세일에 참여 가능
182         require(remainToken >= tokenAmount);// 남은 토큰이 교환해 줄 토큰의 양보다 많아야 한다.
183                 
184 
185         weiRaised = SafeMath.add(weiRaised, toFund);            //현재까지지 모금액에 펀딩금액 합산
186         remainToken = SafeMath.sub(remainToken, tokenAmount);   //남은 판매 수량에서 구매량만큼 차감
187         beneficiaryFunded[beneficiary] = SafeMath.add(beneficiaryFunded[msg.sender], toFund);
188         beneficiaryBought[beneficiary] = SafeMath.add(beneficiaryBought[msg.sender], tokenAmount);
189 
190         emit Buy(beneficiary, toFund, tokenAmount);
191         
192     }
193 
194     function validPurchase() internal view returns (bool) {
195         //보내준 이더양이 0.1 이상인지 그리고 전체 지불한 Ethere가 1,000을 넘어가는지 체크 
196         bool validValue = msg.value >= personalMincap && beneficiaryFunded[msg.sender].add(msg.value) <= personalMaxcap;
197 
198         //현재 판매기간인지 체크 && 정비시간이 아닌지 체크 
199         bool validTime = now >= startTime && now <= endTime && !checkMaintenanceTime();
200 
201         return validValue && validTime;
202     }
203 
204     function checkMaintenanceTime() public view returns (bool){
205         uint256 datetime = now % (60 * 60 * 24);
206         return (datetime >= mtStartTime && datetime < mtEndTime);
207     }
208 
209     function getNowTime() public view returns(uint256) {
210         return now;
211     }
212 
213     // Owner only Functions
214     function changeStartTime( uint64 newStartTime ) public onlyOwner {
215         startTime = newStartTime;
216     }
217 
218     function changeEndTime( uint64 newEndTime ) public onlyOwner {
219         endTime = newEndTime;
220     }
221 
222     function changePersonalMincap( uint256 newpersonalMincap ) public onlyOwner {
223         personalMincap = newpersonalMincap * (1 ether);
224     }
225 
226     function changePersonalMaxcap( uint256 newpersonalMaxcap ) public onlyOwner {
227         personalMaxcap = newpersonalMaxcap * (1 ether);
228     }
229 
230     function FinishTokenSale() public onlyOwner {
231         require(now > endTime || remainToken == 0);
232         isFinalized = true;        
233         owner.transfer(weiRaised); //현재까지의 모금액을 Owner지갑으로 전송.
234     }
235 
236     function changeRate(uint256 _newRate) public onlyOwner {
237         require(checkMaintenanceTime());
238         exchangeRate = _newRate; 
239     }
240 
241     function changeMaintenanceTime(uint256 _startTime, uint256 _endTime) public onlyOwner{
242         mtStartTime = _startTime;
243         mtEndTime = _endTime;
244     }
245 
246     // Fallback Function. 구매자가 컨트랙트 주소로 그냥 이더를 쏜경우 바이프리세일 수행함
247     function () public payable {
248         buyPresale();
249     }
250 
251 }