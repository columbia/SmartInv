1 pragma solidity ^0.4.13;
2 
3 contract ForeignToken {
4     function balanceOf(address _owner) constant returns (uint256);
5     function transfer(address _to, uint256 _value) returns (bool);
6 }
7 
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10     uint256 c = a * b;
11     assert(a == 0 || c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal constant returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal constant returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 interface Token { 
33     function transfer(address _to, uint256 _value) returns (bool);
34     function totalSupply() constant returns (uint256 supply);
35     function balanceOf(address _owner) constant returns (uint256 balance);
36 }
37 
38 contract FuddCrowdsale {
39 
40     using SafeMath for uint256;
41     mapping (address => uint256) balances;
42     Token public fuddToken;
43 
44     // Crowdsale details
45     address public beneficiary;                     
46     address public creator;                         
47     address public confirmedBy;                     
48     uint256 public maxSupply;    
49     bool public purchasingAllowed = false;
50     uint256 public totalSupplied = 0;
51     uint256 public startTimestamp;
52     uint256 public rate;
53     uint256 public firstBonus;
54     uint256 public secondBonus;
55     uint256 public firstTimer;
56     uint256 public secondTimer;
57     uint256 public endTimer;
58     
59     /**
60     * Constructor
61     *
62     * @param _tokenAddress The address of the token contact
63     * @param _beneficiary  The address of the wallet for the beneficiary  
64     * @param _creator      The address of the wallet for the creator 
65     */
66     function FuddCrowdsale(address _tokenAddress, address _beneficiary, address _creator) {
67         fuddToken = Token(_tokenAddress);
68         beneficiary = _beneficiary;
69         creator = _creator;
70     }
71 
72     enum Stages {
73         PreSale,     //0
74         InProgress,  //1
75         Ended,       //2 
76         Withdrawn    //3
77     }
78 
79     Stages public stage = Stages.PreSale;
80 
81     /**
82     * Throw if at stage other than current stage
83     * 
84     * @param _stage expected stage to test for
85     */
86     modifier atStage(Stages _stage) {
87         require(stage == _stage);
88         _;
89     }
90 
91     /**
92     * Throw if sender is not beneficiary
93     */
94     modifier onlyBeneficiary() {
95         require(beneficiary == msg.sender);
96         _;
97     }
98 
99     /** 
100     * Get balance of `_investor` 
101     * 
102     * @param _investor The address from which the balance will be retrieved
103     * @return The balance
104     */
105     function balanceOf(address _investor) constant returns (uint256 balance) {
106         return balances[_investor];
107     }
108     
109     function enablePurchasing(uint256 _firstTimer, uint256 _secondTimer, uint256 _endTimer,
110     uint256 _maxSupply, uint256 _rate, uint256 _firstBonus, uint256 _secondBonus) onlyBeneficiary atStage(Stages.PreSale) {
111         firstTimer = _firstTimer;
112         secondTimer = _secondTimer;
113         endTimer = _endTimer;
114         maxSupply = _maxSupply;
115         rate = _rate;
116         firstBonus = _firstBonus;
117         secondBonus = _secondBonus;
118         purchasingAllowed = true;
119         startTimestamp = now;
120         stage = Stages.InProgress;
121     }
122 
123     function disablePurchasing() onlyBeneficiary atStage(Stages.InProgress) {
124         purchasingAllowed = false;
125         stage = Stages.Ended;
126     }
127     
128     function hasEnded() atStage(Stages.InProgress) {
129         if (now >= startTimestamp.add(endTimer)){
130             purchasingAllowed = false;
131             stage = Stages.Ended;
132         }
133     }
134 
135     function enableNewPurchasing(uint256 _firstTimer, uint256 _secondTimer, uint256 _endTimer,
136     uint256 _maxSupply, uint256 _rate, uint256 _firstBonus, uint256 _secondBonus) onlyBeneficiary atStage(Stages.Withdrawn) {
137         firstTimer = _firstTimer;
138         secondTimer = _secondTimer;
139         endTimer = _endTimer;
140         maxSupply = _maxSupply;
141         rate = _rate;
142         firstBonus = _firstBonus;
143         secondBonus = _secondBonus;
144         totalSupplied = 0;
145         startTimestamp = now;
146         purchasingAllowed = true;
147         stage = Stages.InProgress;
148     }
149     
150     /**
151     * Transfer raised amount to the beneficiary address
152     */
153     function withdraw() onlyBeneficiary atStage(Stages.Ended) {
154         uint256 ethBalance = this.balance;
155         beneficiary.transfer(ethBalance);
156         stage = Stages.Withdrawn;
157     }
158 
159     /**
160     * For testing purposes
161     *
162     * @return The beneficiary address
163     */
164     function confirmBeneficiary() onlyBeneficiary {
165         confirmedBy = msg.sender;
166     }
167     
168     event sendTokens(address indexed to, uint256 value);
169 
170     /**
171     * Receives Eth and issue tokens to the sender
172     */
173     function () payable atStage(Stages.InProgress) {
174         hasEnded();
175         require(purchasingAllowed);
176         if (msg.value == 0) { return; }
177         uint256 weiAmount = msg.value;
178         address investor = msg.sender;
179         uint256 received = weiAmount.div(10e7);
180         uint256 tokens = (received).mul(rate);
181 
182         if (msg.value >= 10 finney) {
183             if (now <= startTimestamp.add(firstTimer)){
184                 uint256 firstBonusToken = (tokens.div(100)).mul(firstBonus);
185                 tokens = tokens.add(firstBonusToken);
186             }
187             
188             if (startTimestamp.add(firstTimer) < now && 
189             now <= startTimestamp.add(secondTimer)){
190                 uint256 secondBonusToken = (tokens.div(100)).mul(secondBonus);
191                 tokens = tokens.add(secondBonusToken);
192             }
193         }
194         
195         sendTokens(msg.sender, tokens);
196         fuddToken.transfer(investor, tokens);
197         totalSupplied = (totalSupplied).add(tokens);
198             
199         if (totalSupplied >= maxSupply) {
200             purchasingAllowed = false;
201             stage = Stages.Ended;
202         }
203     }
204     
205     function tokensAvailable() constant returns (uint256) {
206         return fuddToken.balanceOf(this);
207     }
208     
209     function withdrawForeignTokens(address _tokenContract) onlyBeneficiary public returns (bool) {
210         ForeignToken token = ForeignToken(_tokenContract);
211         uint256 amount = token.balanceOf(address(this));
212         return token.transfer(beneficiary, amount);
213     }
214 }