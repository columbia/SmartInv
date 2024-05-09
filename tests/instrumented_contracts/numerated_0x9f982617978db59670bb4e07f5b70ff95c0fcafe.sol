1 pragma solidity ^0.4.25;
2 
3 /**
4     Hi this is an hyip contract Golden Ratio Percent
5     it is based on 200percent project code
6     
7     Official site ->  call meth.site_url()
8 
9     How to use:
10     1. Send from ETH wallet to the smart contract address any amount ETH.
11     2. Claim your profit by sending 0 ether transaction (1 time per hour)
12     3. If you earn more than 1,618x100%, you can withdraw only one finish time
13     and will get only 161.8% of deposite no more
14 
15 
16     Bounty program:
17     for startups, decrease your losses on commission via airdrop.
18     1. At first go to your promo token call approve needed amount from owner wallet,
19     for this contract
20     2. Add your promo token address, amount of users which could be able
21     to claim this token
22 
23     !!! User who has positive balance can execute function “claim Tokens” by promo
24     token address and claim bonus
25  */
26 
27 /**
28  * @title SafeMath
29  * @dev Math operations with safety checks that throw on error
30  */
31 library SafeMath {
32     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
33         if (a == 0) {
34             return 0;
35         }
36         uint256 c = a * b;
37         assert(c / a == b);
38         return c;
39     }
40 
41     function div(uint256 a, uint256 b) internal pure returns (uint256) {
42         // assert(b > 0); // Solidity automatically throws when dividing by 0
43         uint256 c = a / b;
44         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         assert(b <= a);
50         return a - b;
51     }
52 
53     function add(uint256 a, uint256 b) internal pure returns (uint256) {
54         uint256 c = a + b;
55         assert(c >= a);
56         return c;
57     }
58 }
59 
60 /// @title Abstract Token, ERC20 token interface
61 interface ERC20 {
62 
63     function name() external returns (string);
64     function symbol() external returns (string);
65     function decimals() external returns (uint8);
66     function totalSupply() external returns (uint256);
67     function balanceOf(address owner) external view returns (uint256);
68     function transfer(address to, uint256 value) external returns (bool);
69     function transferFrom(address from, address to, uint256 value) external returns (bool);
70     function approve(address spender, uint256 value) external returns (bool);
71     function allowance(address owner, address spender) external view returns (uint256);
72 
73     event Transfer(address indexed from, address indexed to, uint256 value);
74     event Approval(address indexed owner, address indexed spender, uint256 value);
75 }
76 
77 interface IOwnable {
78     function owner() external returns(address);
79 }
80 
81 contract Ownable {
82     address public owner;
83 
84     event OwnershipRenounced(address indexed previousOwner);
85     event OwnershipTransferred(
86         address indexed previousOwner,
87         address indexed newOwner
88     );
89 
90     constructor() public {
91         owner = msg.sender;
92     }
93 
94     modifier onlyOwner() {
95         require(msg.sender == owner);
96         _;
97     }
98 
99     /*  function owner() public returns(address) {
100       return owner;
101     }*/
102 
103     function renounceOwnership() public onlyOwner {
104         emit OwnershipRenounced(owner);
105         owner = address(0);
106     }
107 
108     function transferOwnership(address _newOwner) public onlyOwner {
109         _transferOwnership(_newOwner);
110     }
111 
112     function _transferOwnership(address _newOwner) internal {
113         require(_newOwner != address(0));
114         emit OwnershipTransferred(owner, _newOwner);
115         owner = _newOwner;
116     }
117 }
118 
119 contract GoldenRatioPercent is Ownable {
120     using SafeMath for uint;
121 
122     event Invested(address Investedor, uint256 amount);
123     event Withdrawn(address Investedor, uint256 amount);
124     event Commission(address owner, uint256 amount);
125     event BountyList(address tokenAddress);
126 
127     mapping(address => uint) public balance;
128     mapping(address => uint) public time;
129     mapping(address => uint) public percentWithdraw;
130     mapping(address => uint) public allPercentWithdraw;
131 
132     mapping(address => uint) public lastDeposit;
133 
134     uint public totalRaised = 0;
135     uint public stepTime = 1 hours;
136     uint public countOfInvestedors = 0;
137     uint projectPercent = 9;
138     uint public minDeposit = 10 finney;
139 
140     string public site_url = "";
141 
142     modifier isUser() {
143         require(balance[msg.sender] > 0, "User`s address not found");
144         _;
145     }
146 
147     modifier isTime() {
148         require(now >= time[msg.sender].add(stepTime), "Not time it is now");
149         _;
150     }
151 
152     /**
153      * @dev dependece of bonus by contract balance from 30 to 70%
154      */
155     function amendmentByRate() private view returns(uint) {
156         uint contractBalance = address(this).balance;
157 
158         if (contractBalance < 1000 ether) {
159             return (30);
160         }
161         if (contractBalance >= 1000 ether && contractBalance < 2500 ether) {
162             return (40);
163         }
164         if (contractBalance >= 2500 ether && contractBalance < 5000 ether) {
165             return (50);
166         }
167         if (contractBalance >= 5000 ether && contractBalance < 10000 ether) {
168             return (60);
169         }
170         if (contractBalance >= 10000 ether) {
171             return (70);
172         }
173     }
174 
175     /**
176      * @dev dependece of bonus by users deposite from 3 to 10%
177      */
178     function amendmentByLastDeposit(uint amount) private view returns(uint) {
179 
180         if (lastDeposit[msg.sender] < 10 ether) {
181             return amount;
182         }
183         if (lastDeposit[msg.sender] >= 10 ether && lastDeposit[msg.sender] < 25 ether) {
184             return amount.mul(103).div(100);
185         }
186         if (lastDeposit[msg.sender] >= 25 ether && lastDeposit[msg.sender] < 50 ether) {
187            return amount.mul(104).div(100);
188         }
189         if (lastDeposit[msg.sender] >= 50 ether && lastDeposit[msg.sender] < 100 ether) {
190             return amount.mul(106).div(100);
191         }
192         if (lastDeposit[msg.sender] >= 100 ether) {
193             return amount.mul(110).div(100);
194         }
195     }
196 
197     /**
198      * @dev dependece of bonus by users current depsite rate from 0 to 28%
199      */
200     function amendmentByDepositRate() private view returns(uint) {
201 
202         if (balance[msg.sender] < 10 ether) {
203             return (0);
204         }
205         if (balance[msg.sender] >= 10 ether && balance[msg.sender] < 25 ether) {
206             return (10);
207         }
208         if (balance[msg.sender] >= 25 ether && balance[msg.sender] < 50 ether) {
209             return (18);
210         }
211         if (balance[msg.sender] >= 50 ether && balance[msg.sender] < 100 ether) {
212             return (22);
213         }
214         if (balance[msg.sender] >= 100 ether) {
215             return (28);
216         }
217     }
218 
219     function balance() public view returns (uint256) {
220         return address(this).balance;
221     }
222 
223     // below address must be contact address
224     mapping(address => uint) public bountyAmount;
225     mapping(address => mapping(address => uint)) public bountyUserWithdrawns;
226     mapping(address => uint) public bountyUserCounter;
227     mapping(address => uint) public bountyReward;
228     uint public bountierCounter = 0;
229     mapping(uint => address) public bountyList;
230     mapping(address => uint) public bountyListIndex;
231 
232     /**
233      * @dev if you are user you can call it function and get your bounty tokens
234      */
235     function claimTokens(ERC20 token) public isUser returns(bool) {
236         if(bountyUserWithdrawns[token][msg.sender] == 0 &&
237             token.balanceOf(this) >= bountyReward[token])
238         {
239             bountyUserWithdrawns[token][msg.sender] = bountyReward[token];
240             if(token.balanceOf(this) <= bountyReward[token]) {
241                 token.transfer(msg.sender, token.balanceOf(this));
242                 bountyList[bountyListIndex[token]] = address(0);
243                 return true;
244             } else {
245                 token.transfer(msg.sender, bountyReward[token]);
246                 return true;
247             }
248         }
249     }
250 
251     /**
252      * @dev function for bountiers
253      *      At first go to your promo token call approve from owner wallet, put this contract address and
254      *      amount of tokens which you want send to the contract
255      *      Add your promo token address, amount of users which could be able to claim this token
256      */
257     function makeBounty(ERC20 token, uint amountOfUsers) public payable {
258         // must be only owner of contract
259         require(IOwnable(token).owner() == msg.sender);
260         uint amount = token.allowance(msg.sender, this);
261         token.transferFrom(msg.sender, this, amount);
262         require(token.balanceOf(msg.sender) >= amount.mul(1)**token.decimals());
263         require(msg.value >= amountOfUsers.mul(1 ether).div(10000)); // one user cost 0.0001
264 
265         bountyAmount[token] = amount;
266         bountyUserCounter[token] = amountOfUsers;
267         bountierCounter = bountierCounter.add(1);
268         bountyList[bountierCounter] = token;
269         bountyListIndex[token] = bountierCounter;
270         bountyReward[token] = amount.div(amountOfUsers);
271     }
272 
273     // get all contract address what was in bounty
274     function getBountyList() public {
275         for(uint i= 1; i <= 200 && i < bountierCounter; i++) {
276             emit BountyList(bountyList[bountierCounter]);
277         }
278     }
279 
280     function payout() public view returns(uint256) {
281         uint256 percent = amendmentByRate().sub(amendmentByDepositRate());
282         uint256 different = now.sub(time[msg.sender]).div(stepTime);
283         uint256 rate = balance[msg.sender].mul(percent).div(1000);
284         uint256 withdrawalAmount = rate.mul(different).div(24).sub(percentWithdraw[msg.sender]);
285         return amendmentByLastDeposit(withdrawalAmount);
286     }
287 
288     function setSiteUrl(string _url) public onlyOwner {
289         site_url = _url;
290     }
291 
292     function _deposit() private {
293         if (msg.value > 0) {
294 
295             require(msg.value >= minDeposit);
296 
297             lastDeposit[msg.sender] = msg.value;
298 
299             if (balance[msg.sender] == 0) {
300                 countOfInvestedors += 1;
301             }
302             if (balance[msg.sender] > 0 && now > time[msg.sender].add(stepTime)) {
303                 _reward();
304                 percentWithdraw[msg.sender] = 0;
305             }
306 
307             balance[msg.sender] = balance[msg.sender].add(msg.value);
308             time[msg.sender] = now;
309 
310             totalRaised = totalRaised.add(msg.value);
311 
312             uint256 commission = msg.value.mul(projectPercent).div(100);
313             owner.transfer(commission);
314 
315             emit Invested(msg.sender, msg.value);
316             emit Commission(owner, commission);
317         } else {
318             _reward();
319         }
320     }
321 
322     // 1.618 - max profite
323     function _reward() private isUser isTime {
324 
325         if ((balance[msg.sender].mul(1618).div(1000)) <= allPercentWithdraw[msg.sender]) {
326             balance[msg.sender] = 0;
327             time[msg.sender] = 0;
328             percentWithdraw[msg.sender] = 0;
329         } else {
330             uint256 pay = payout();
331             if(allPercentWithdraw[msg.sender].add(pay) >= balance[msg.sender].mul(1618).div(1000)) {
332                 pay = (balance[msg.sender].mul(1618).div(1000)).sub(allPercentWithdraw[msg.sender]);
333             }
334             percentWithdraw[msg.sender] = percentWithdraw[msg.sender].add(pay);
335             allPercentWithdraw[msg.sender] = allPercentWithdraw[msg.sender].add(pay);
336             msg.sender.transfer(pay);
337             emit Withdrawn(msg.sender, pay);
338         }
339     }
340 
341     function() external payable {
342         _deposit();
343     }
344 }