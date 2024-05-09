1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath
8 {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256)
10     {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20         // assert(b > 0); // Solidity automatically throws when dividing by 0
21         uint256 c = a / b;
22         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract ERC20
39 {
40     function totalSupply()public view returns (uint total_Supply);
41     function balanceOf(address who)public view returns (uint256);
42     function allowance(address owner, address spender)public view returns (uint);
43     function transferFrom(address from, address to, uint value)public returns (bool ok);
44     function approve(address spender, uint value)public returns (bool ok);
45     function transfer(address to, uint value)public returns (bool ok);
46     
47     event Transfer(address indexed from, address indexed to, uint value);
48     event Approval(address indexed owner, address indexed spender, uint value);
49 }
50 
51 contract FiatContract
52 {
53     function USD(uint _id) external constant returns (uint256);
54 }
55 
56 contract SATCrowdsale
57 {
58     using SafeMath for uint256;
59     
60     address public owner;
61     bool stopped = false;
62     uint256 public startdate;
63     uint256 ico_first;
64     uint256 ico_second;
65     uint256 ico_third;
66     uint256 ico_fourth;
67     
68     enum Stages
69     {
70         NOTSTARTED,
71         ICO,
72         PAUSED,
73         ENDED
74     }
75     
76     Stages public stage;
77     
78     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591);
79     ERC20 public constant tokenContract = ERC20(0xc56b13ebbCFfa67cFb7979b900b736b3fb480D78);
80     
81     modifier atStage(Stages _stage)
82     {
83         require(stage == _stage);
84         _;
85     }
86     
87     modifier onlyOwner()
88     {
89         require(msg.sender == owner);
90         _;
91     }
92     
93     function SATCrowdsale() public
94     {
95         owner = msg.sender;
96         stage = Stages.NOTSTARTED;
97     }
98     
99     function () external payable atStage(Stages.ICO)
100     {
101         require(msg.value >= 1 finney); //for round up and security measures
102         require(!stopped && msg.sender != owner);
103         
104         uint256 ethCent = price.USD(0); //one USD cent in wei
105         uint256 tokPrice = ethCent.mul(9); // 1Sat = 9 USD cent
106         
107         tokPrice = tokPrice.div(10 ** 8); //limit to 10 places
108         uint256 no_of_tokens = msg.value.div(tokPrice);
109         
110         uint256 bonus_token = 0;
111         
112         // Determine the bonus based on the time and the purchased amount
113         if (now < ico_first)
114         {
115             if (no_of_tokens >=  2000 * (uint256(10)**8) &&
116                 no_of_tokens <= 19999 * (uint256(10)**8))
117             {
118                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
119             }
120             else if (no_of_tokens >   19999 * (uint256(10)**8) &&
121                      no_of_tokens <= 149999 * (uint256(10)**8))
122             {
123                 bonus_token = no_of_tokens.mul(55).div(100); // 55% bonus
124             }
125             else if (no_of_tokens > 149999 * (uint256(10)**8))
126             {
127                 bonus_token = no_of_tokens.mul(60).div(100); // 60% bonus
128             }
129             else
130             {
131                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
132             }
133         }
134         else if (now >= ico_first && now < ico_second)
135         {
136             if (no_of_tokens >=  2000 * (uint256(10)**8) &&
137                 no_of_tokens <= 19999 * (uint256(10)**8))
138             {
139                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
140             }
141             else if (no_of_tokens >   19999 * (uint256(10)**8) &&
142                      no_of_tokens <= 149999 * (uint256(10)**8))
143             {
144                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
145             }
146             else if (no_of_tokens >  149999 * (uint256(10)**8))
147             {
148                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
149             }
150             else
151             {
152                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
153             }
154         }
155         else if (now >= ico_second && now < ico_third)
156         {
157             if (no_of_tokens >=  2000 * (uint256(10)**8) &&
158                 no_of_tokens <= 19999 * (uint256(10)**8))
159             {
160                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
161             }
162             else if (no_of_tokens >   19999 * (uint256(10)**8) &&
163                      no_of_tokens <= 149999 * (uint256(10)**8))
164             {
165                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
166             }
167             else if (no_of_tokens >  149999 * (uint256(10)**8))
168             {
169                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
170             }
171             else
172             {
173                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
174             }
175         }
176         else if (now >= ico_third && now < ico_fourth)
177         {
178             if (no_of_tokens >=  2000 * (uint256(10)**8) &&
179                 no_of_tokens <= 19999 * (uint256(10)**8))
180             {
181                 bonus_token = no_of_tokens.mul(20).div(100); // 20% bonus
182             }
183             else if (no_of_tokens >   19999 * (uint256(10)**8) &&
184                      no_of_tokens <= 149999 * (uint256(10)**8))
185             {
186                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
187             }
188             else if (no_of_tokens >  149999 * (uint256(10)**8))
189             {
190                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
191             }
192             else
193             {
194                 bonus_token = no_of_tokens.mul(15).div(100); // 15% bonus
195             }
196         }
197         
198         uint256 total_token = no_of_tokens + bonus_token;
199         tokenContract.transfer(msg.sender, total_token);
200     }
201     
202     function startICO(uint256 _startDate) public onlyOwner atStage(Stages.NOTSTARTED)
203     {
204         stage = Stages.ICO;
205         stopped = false;
206         startdate = _startDate;
207         ico_first = _startDate + 14 days;
208         ico_second = ico_first + 14 days;
209         ico_third = ico_second + 14 days;
210         ico_fourth = ico_third + 14 days;
211     }
212     
213     function pauseICO() external onlyOwner atStage(Stages.ICO)
214     {
215         stopped = true;
216         stage = Stages.PAUSED;
217     }
218     
219     function resumeICO() external onlyOwner atStage(Stages.PAUSED)
220     {
221         stopped = false;
222         stage = Stages.ICO;
223     }
224     
225     function endICO() external onlyOwner atStage(Stages.ICO)
226     {
227         require(now > ico_fourth);
228         stage = Stages.ENDED;
229         tokenContract.transfer(0x1, tokenContract.balanceOf(address(this)));
230     }
231     
232     function transferAllUnsoldTokens(address _destination) external onlyOwner 
233     {
234         require(_destination != 0x0);
235         tokenContract.transfer(_destination, tokenContract.balanceOf(address(this)));
236     }
237     
238     function transferPartOfUnsoldTokens(address _destination, uint256 _amount) external onlyOwner
239     {
240         require(_destination != 0x0);
241         tokenContract.transfer(_destination, _amount);
242     }
243     
244     function transferOwnership(address _newOwner) external onlyOwner
245     {
246         owner = _newOwner;
247     }
248     
249     function drain() external onlyOwner
250     {
251         owner.transfer(this.balance);
252     }
253 }