1 pragma solidity 0.4.24;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function safeAdd(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a);
10     }
11     function safeSub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a);
13         c = a - b;
14     }
15     function safeMul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b);
18     }
19     function safeDiv(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0);
21         c = a / b;
22     }
23 }
24 
25 
26 interface token {
27     function transfer(address to, uint tokens) external;
28     function balanceOf(address tokenOwner) external returns(uint balance);
29 }
30 
31 
32 // ----------------------------------------------------------------------------
33 // Owned contract
34 // ----------------------------------------------------------------------------
35 contract Owned {
36     address public owner;
37 
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39     event tokensBought(address _addr, uint _amount);
40     event tokensCalledBack(uint _amount);
41     event privateSaleEnded(uint _time);
42 
43     constructor() public {
44         owner = msg.sender;
45     }
46 
47     modifier onlyOwner {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     function transferOwnership(address _newOwner) public onlyOwner {
53         owner = _newOwner;
54         emit OwnershipTransferred(owner, _newOwner);
55     }
56 
57 }
58 
59 
60 contract Crowdsale is Owned{
61     using SafeMath for uint;
62     
63     uint public start;
64     uint public end;
65     uint public phaseOneLimit;
66     uint public phaseTwoLimit;
67     uint public phaseThreeLimit;
68     uint public levelOneBonus;
69     uint public levelTwoBonus;
70     uint public levelThreeBonus;
71     uint public softCap;
72     uint public hardCap;
73     bool public hardCapReached;
74     
75     mapping (address => address) public refers;
76     
77     mapping (address => uint) public etherHoldings;
78     mapping (address => uint) public tokenHoldings;
79     
80     token public rewardToken;
81     
82     constructor() public{
83         start = now;
84         end = now.safeAdd(112 days);
85         rewardToken = token(0x64d431354f27009965b163f7e6cdb60700ad5d12);
86         phaseOneLimit = 10000 ether;
87         phaseTwoLimit = 30000 ether;
88         phaseThreeLimit = 50000 ether;
89         levelOneBonus = 3;
90         levelTwoBonus = 2;
91         levelThreeBonus = 1;
92         softCap = 10000 ether;
93         hardCap = 50000 ether;
94     }
95     
96     modifier stillActive{
97         require(address(this).balance <= phaseThreeLimit && now <= end);
98         _;
99     }
100     
101     function returnETher(address _addr) view public returns(uint){
102         return etherHoldings[_addr];
103     }
104     
105     function () public payable stillActive{
106         require(msg.value != 0);
107         uint cb = address(this).balance;
108         address buyer = msg.sender;
109         uint buyamount = msg.value;
110         uint tokens;
111         if(cb <= phaseOneLimit){
112             tokens = buyamount * 2000;
113         }
114         if(cb <= phaseTwoLimit && cb > phaseOneLimit){
115             tokens = buyamount * 1500;
116         }
117         if(cb <= phaseThreeLimit && cb > phaseTwoLimit ){
118             tokens = buyamount * 1000;
119         }
120         etherHoldings[buyer] += msg.value;
121         tokenHoldings[buyer] += tokens;
122         
123     }
124     
125     
126     function buyWithReferral(address _addr) public payable stillActive{
127         require(msg.sender != _addr);
128         require(msg.value != 0);
129         uint cb = address(this).balance;
130         address buyer = msg.sender;
131         uint buyamount = msg.value;
132         uint tokens;
133         refers[buyer] = _addr;
134         address ref1 = _addr;
135         address ref2 = refers[ref1];
136         address ref3 = refers[ref2];
137         
138         
139         if(cb <= phaseOneLimit){
140             tokens = buyamount * 2000;
141         }
142         if(cb <= phaseTwoLimit && cb > phaseOneLimit){
143             tokens = buyamount * 1500;
144         }
145         if(cb <= phaseThreeLimit && cb > phaseTwoLimit ){
146             tokens = buyamount * 1000;
147         }
148         
149         etherHoldings[buyer] += buyamount;
150         tokenHoldings[buyer] += tokens;
151 
152         uint reftok1 = tokens/uint(100);
153         reftok1 = reftok1 * 5;
154         reftok1 = reftok1;
155         tokenHoldings[ref1] += reftok1;
156 
157         
158         if(ref2 != 0){
159         uint reftok2 = tokens/uint(100);
160         reftok2 = reftok2 * 3;
161         reftok2 = reftok2;
162         tokenHoldings[ref2] += reftok2;
163         }
164         
165         if(ref3 != 0){
166         uint reftok3 = tokens/uint(100);
167         reftok3 = reftok3 * 1;
168         reftok3 = reftok3;
169         tokenHoldings[ref3] += reftok3;
170         }
171         
172     }
173     
174     modifier saleSuccessful{
175         require(now > end);
176         _;
177     }
178     
179     modifier saleFailed{
180         require (now > end && address(this).balance < softCap );
181         _;
182     }
183     
184     function releaseTokens() public {
185         uint tokens = tokenHoldings[msg.sender];
186         if(tokens <= 0){
187             revert();
188         }
189         rewardToken.transfer(msg.sender, tokens);
190         tokenHoldings[msg.sender] = 0;
191     }
192     
193     
194     function releaseEthers() public saleFailed{
195         uint ethers = etherHoldings[msg.sender];
196         if(ethers <= 0){
197             revert();
198         }
199         msg.sender.transfer(ethers);
200         etherHoldings[msg.sender] = 0;
201         
202     }
203     
204     modifier softCapReached{
205         require(address(this).balance >= softCap);
206         _;
207     }
208     
209     function safeWithdrawal() public onlyOwner softCapReached {
210         uint amount = address(this).balance;
211         owner.transfer(amount);
212         
213     }
214     
215 
216     function withdrawTokens() public onlyOwner saleSuccessful{
217         uint Ownerbalance = rewardToken.balanceOf(this);
218     	rewardToken.transfer(owner, Ownerbalance);
219     }
220     
221     
222 }