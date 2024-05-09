1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14  
15     function div(uint256 a, uint256 b) internal pure returns(uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21  
22     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26  
27     function add(uint256 a, uint256 b) internal pure returns(uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32  
33 }
34 
35 
36 library Address {
37     function toAddress(bytes source) internal pure returns(address addr) {
38         assembly { addr := mload(add(source,0x14)) }
39         return addr;
40     }
41 }
42 
43 
44 /**
45 */
46 contract SInv {
47     //use of library of safe mathematical operations    
48     using SafeMath for uint;
49     using Address for *;
50 
51     // array containing information about beneficiaries
52     mapping(address => uint) public userDeposit;
53     //Mapping for how much the User got from Refs
54     mapping(address=>uint) public RefBonus;
55     //How much the user earned to date
56     mapping(address=>uint) public UserEarnings;
57     //array containing information about the time of payment
58     mapping(address => uint) public userTime;
59     //array containing information on interest paid
60     mapping(address => uint) public persentWithdraw;
61     //fund fo transfer percent
62     address public projectFund =  0xB3cE9796aCDC1855bd6Cec85a3403f13C918f1F2;
63     //percentage deducted to the advertising fund
64     uint projectPercent = 5; // 0,5%
65     //time through which you can take dividends
66     uint public chargingTime = 24 hours;
67     uint public startPercent = 250*10;
68     uint public countOfInvestors;
69     uint public daysOnline;
70     uint public dividendsPaid;
71 
72     constructor() public {
73         daysOnline = block.timestamp;
74     }    
75     
76     modifier isIssetUser() {
77         require(userDeposit[msg.sender] > 0, "Deposit not found");
78         _;
79     }
80  
81     modifier timePayment() {
82         require(now >= userTime[msg.sender].add(chargingTime), "Too fast payout request");
83         _;
84     }
85     
86     function() external payable {
87         if (msg.value > 0) {
88             //makeDeposit(MyPersonalRefName[msg.data.toAddress()]);
89             makeDepositA(msg.data.toAddress());
90         }
91         else {
92             collectPercent();
93         }
94     }
95 
96     //return of interest on the deposit
97     function collectPercent() isIssetUser timePayment public {
98             uint payout;
99             uint multipl;
100             (payout,multipl) = payoutAmount(msg.sender);
101             userTime[msg.sender] += multipl*chargingTime;
102             persentWithdraw[msg.sender] += payout;
103             msg.sender.transfer(payout);
104             UserEarnings[msg.sender]+=payout;
105             dividendsPaid += payout;
106             uint UserInitDeposit=userDeposit[msg.sender];
107             projectFund.transfer(UserInitDeposit.mul(projectPercent).div(1000));
108     }
109 
110     //When User decides to reinvest instead of paying out (to get more dividends per day)
111     function Reinvest() isIssetUser timePayment external {
112         uint payout;
113         uint multipl;
114         (payout,multipl) = payoutAmount(msg.sender);
115         userTime[msg.sender] += multipl*chargingTime;
116         userDeposit[msg.sender]+=payout;
117         UserEarnings[msg.sender]+=payout;
118         uint UserInitDeposit=userDeposit[msg.sender];
119         projectFund.transfer(UserInitDeposit.mul(projectPercent).div(1000));
120     }
121  
122     //make a contribution to the system
123     function makeDeposit(bytes32 referrer) public payable {
124         if (msg.value > 0) {
125             if (userDeposit[msg.sender] == 0) {
126                 countOfInvestors += 1;
127 
128                 //only give ref bonus if the customer gave a valid ref information
129                 if((RefNameToAddress[referrer] != address(0x0) && referrer > 0 && TheGuyWhoReffedMe[msg.sender] == address(0x0) && RefNameToAddress[referrer] != msg.sender)) {
130                     //get the Address of the guy who reffed mit through his _Ref String and save it in the mapping
131                     TheGuyWhoReffedMe[msg.sender] = RefNameToAddress[referrer];
132                     newRegistrationwithRef();
133                 }
134             }
135             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
136                 collectPercent();
137             }
138 
139             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
140             userTime[msg.sender] = now;
141 
142         } else {
143             collectPercent();
144         }
145     }
146     
147     //function call for fallback
148     function makeDepositA(address referrer) public payable {
149         if (msg.value > 0) {
150             if (userDeposit[msg.sender] == 0) {
151                 countOfInvestors += 1;
152                 //only give ref bonus if the customer gave a valid ref information //or has already a ref
153                 if((referrer != address(0x0) && referrer > 0 && TheGuyWhoReffedMe[msg.sender] == address(0x0) && referrer != msg.sender)) {
154                     //get the Address of the guy who reffed mit through his _Ref String and save it in the mapping
155                     TheGuyWhoReffedMe[msg.sender] = referrer;
156                     newRegistrationwithRef();
157                 }
158             }
159             if (userDeposit[msg.sender] > 0 && now > userTime[msg.sender].add(chargingTime)) {
160                 collectPercent();
161             }
162             userDeposit[msg.sender] = userDeposit[msg.sender].add(msg.value);
163             userTime[msg.sender] = now;
164 
165         } else {
166             collectPercent();
167         }
168     }
169      
170     function getUserEarnings(address addr) public view returns(uint)
171     {
172         return UserEarnings[addr];
173     }
174  
175     //calculation of the current interest rate on the deposit
176     function persentRate() public view returns(uint) {
177         return(startPercent);
178  
179     }
180  
181     // Withdraw of your referral earnings
182     function PayOutRefBonus() external
183     {       
184         //Check if User has Bonus
185         require(RefBonus[msg.sender]>0,"You didn't earn any bonus");
186         uint payout = RefBonus[msg.sender];
187         //payout the Refbonus
188         msg.sender.transfer(payout);
189         //Set to 0 since its payed out
190         RefBonus[msg.sender]=0;
191     }
192  
193  
194     //refund of the amount available for withdrawal on deposit
195     function payoutAmount(address addr) public view returns(uint,uint) {
196         uint rate = userDeposit[addr].mul(startPercent).div(100000);
197         uint interestRate = now.sub(userTime[addr]).div(chargingTime);
198         uint withdrawalAmount = rate.mul(interestRate);
199         return (withdrawalAmount, interestRate);
200     }
201 
202  
203     mapping (address=>address) public TheGuyWhoReffedMe;
204  
205     mapping (address=>bytes32) public MyPersonalRefName;
206     //for bidirectional search
207     mapping (bytes32=>address) public RefNameToAddress;
208     
209     // referral counter
210     mapping (address=>uint256) public referralCounter;
211     // referral earnings counter
212     mapping (address=>uint256) public referralEarningsCounter;
213 
214     //public function to register your ref
215     function createMyPersonalRefName(bytes32 _RefName) external payable
216     {  
217         //ref name shouldn't be 0
218         require(_RefName > 0);
219 
220         //Check if RefName is already registered
221         require(RefNameToAddress[_RefName]==0, "Somebody else owns this Refname");
222  
223         //check if User already has a ref Name
224         require(MyPersonalRefName[msg.sender] == 0, "You already registered a Ref");  
225  
226         //If not registered
227         MyPersonalRefName[msg.sender]= _RefName;
228 
229         RefNameToAddress[_RefName]=msg.sender;
230 
231     }
232  
233     function newRegistrationwithRef() private
234     {
235         //Give Bonus to refs
236         CheckFirstGradeRefAdress();
237         CheckSecondGradeRefAdress();
238         CheckThirdGradeRefAdress();
239     }
240  
241     //first grade ref gets 1% extra
242     function CheckFirstGradeRefAdress() private
243     {  
244         //   3 <-- This one
245         //  /
246         // 4
247  
248         //Check if Exist
249         if(TheGuyWhoReffedMe[msg.sender]>0) {
250         //Send the Ref his 1%
251             RefBonus[TheGuyWhoReffedMe[msg.sender]] += msg.value * 2/100;
252             referralEarningsCounter[TheGuyWhoReffedMe[msg.sender]] += msg.value * 2/100;
253             referralCounter[TheGuyWhoReffedMe[msg.sender]]++;
254         }
255     }
256  
257     //second grade ref gets 0,5% extra
258     function CheckSecondGradeRefAdress() private
259     {
260         //     2 <-- This one
261         //    /
262         //   3
263         //  /
264         // 4
265         //Check if Exist
266         if(TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]>0) {
267         //Send the Ref his 0,5%
268             RefBonus[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]] += msg.value * 2/200;
269             referralEarningsCounter[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]] += msg.value * 2/200;
270             referralCounter[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]]++;
271         }
272     }
273  
274     //third grade ref gets 0,25% extra
275     function CheckThirdGradeRefAdress() private
276     {
277         //       1 <-- This one
278         //      /
279         //     2
280         //    /
281         //   3
282         //  /
283         // 4
284         //Check if Exist
285         if (TheGuyWhoReffedMe[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]]>0) {
286 
287             RefBonus[TheGuyWhoReffedMe[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]]] += msg.value * 2/400;
288             referralEarningsCounter[TheGuyWhoReffedMe[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]]] += msg.value * 2/400;
289             referralCounter[TheGuyWhoReffedMe[TheGuyWhoReffedMe[TheGuyWhoReffedMe[msg.sender]]]]++;
290         }
291     }
292     
293     //Returns your personal RefName, when it is registered
294     function getMyRefName(address addr) public view returns(bytes32)
295     {
296         return (MyPersonalRefName[addr]);
297     }
298 
299     function getMyRefNameAsString(address addr) public view returns(string) {
300         return bytes32ToString(MyPersonalRefName[addr]);
301     }
302 
303     function bytes32ToString(bytes32 x) internal pure returns (string) {
304         bytes memory bytesString = new bytes(32);
305         uint charCount = 0;
306         for (uint j = 0; j < 32; j++) {
307             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
308             if (char != 0) {
309                 bytesString[charCount] = char;
310                 charCount++;
311             }
312         }
313         bytes memory bytesStringTrimmed = new bytes(charCount);
314         for (j = 0; j < charCount; j++) {
315             bytesStringTrimmed[j] = bytesString[j];
316         }
317         return string(bytesStringTrimmed);
318     }
319 }