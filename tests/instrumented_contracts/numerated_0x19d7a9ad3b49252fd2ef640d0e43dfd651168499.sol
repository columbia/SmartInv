1 pragma solidity ^0.4.16;
2 
3 contract BMToken
4 {
5     function totalSupply() constant external returns (uint256);
6     function mintTokens(address holder, uint256 amount) external;
7 }
8 
9 contract BMmkPreICO
10 {
11     function getDataHolders(address holder) external constant returns(uint256);
12 }
13 
14 contract BMPreICO
15 {
16     function getDataHolders(address holder) external constant returns(uint256);
17 }
18 
19 contract BMPreICOAffiliateProgramm
20 {
21     function refferalPreICOBonus(address referral) constant external returns (uint256 bonus);
22     function partnerPreICOBonus(address partner) constant external returns (uint256 bonus);
23 }
24 
25 contract BMICOAffiliateProgramm
26 {
27     function add_referral(address referral, string promo, uint256 amount) external returns(address, uint256, uint256);
28 }
29 
30 contract BM_ICO
31 {
32     BMToken    contractTokens;
33     BMmkPreICO contractMKPreICO;
34     BMPreICO   contractPreICO;
35     BMPreICOAffiliateProgramm contractAffiliatePreICO;
36     BMICOAffiliateProgramm contractAffiliateICO;
37 
38     address public owner;
39     address public exchangesOwner;
40 
41     mapping (uint8 => uint256)                       public holdersBonus;
42     mapping (address => bool)                        public claimedMK;
43     mapping (address => bool)                        public claimedPreICO;
44 
45     mapping (uint8 => uint256)                       public partnerBonus;
46     mapping (address => bool)                        public claimedPartnerPreICO;
47 
48     uint256 public startDate      = 1505001600; //10.09.2017 00:00 GMT
49     uint256 public endDate        = 1507593600; //10.10.2017 00:00 GMT
50 
51     bool isOwnerEmit = false;
52 
53     uint256 public icoTokenSupply = 7*(10**26);
54 
55     mapping (uint8 => uint256) public priceRound;
56 
57     mapping(address => bool) exchanges;
58 
59     function BM_ICO()
60     {
61         owner          = msg.sender;
62         exchangesOwner = address(0xCa92b75B7Ada1B460Eb5C012F1ebAd72c27B19D9);
63 
64         contractTokens          = BMToken(0xf028adee51533b1b47beaa890feb54a457f51e89);
65         contractAffiliatePreICO = BMPreICOAffiliateProgramm(0x6203188c0dd1a4607614dbc8af409e91ed46def0);
66         contractAffiliateICO    = BMICOAffiliateProgramm(0xbe44459058383729be8247802d4314ea76ca9e5a);
67         contractMKPreICO        = BMmkPreICO(0xe9958afac6a3e16d32d3cb62a82f84d3c43c8012);
68         contractPreICO          = BMPreICO(0x7600431745bd5bb27315f8376971c81cc8026a78);
69 
70         priceRound[0] = 0.000064 ether; //MK
71         priceRound[1] = 0.000071 ether; //PreICO
72         priceRound[2] = 0.000107 ether; //1 round 10.09.2017-20.09.2017
73         priceRound[3] = 0.000114 ether; //2 round 20.09.2017-25.09.2017
74         priceRound[4] = 0.000121 ether; //3 round 25.09.2017-30.09.2017
75         priceRound[5] = 0.000143 ether; //4 round 30.09.2017-10.10.2017
76     }
77 
78     modifier isOwner()
79     {
80         assert(msg.sender == owner);
81         _;
82     }
83 
84     function changeOwner(address new_owner) isOwner {
85         assert(new_owner!=address(0x0));
86         assert(new_owner!=address(this));
87         owner = new_owner;
88     }
89 
90     function addExchange(address new_exchange) isOwner
91     {
92         assert(new_exchange!=address(0x0));
93         assert(new_exchange!=address(this));
94         assert(exchanges[new_exchange]==false);
95         exchanges[new_exchange] = true;
96     }
97 
98     function cast(uint256 x) constant internal returns (uint128 z)
99     {
100         assert((z = uint128(x)) == x);
101     }
102 
103     function etherToTokens(uint256 etherAmount, uint256 tokenPrice) constant returns(uint256)
104     {
105         return uint256(cast((etherAmount * (10**18) + cast(tokenPrice) / 2) / cast(tokenPrice)));
106     }
107 
108     function tokensToEther(uint256 tokenAmount, uint256 tokenPrice) constant returns(uint256)
109     {
110         return uint256(cast((tokenPrice * cast(tokenAmount) + (10**18) / 2) / (10**18)));
111     }
112 
113     function periodNow() constant returns (uint8 period) {
114         if(now >= 1505001600 && now < 1505865600){
115             period = 2;
116         }
117         else if(now >= 1505865600 && now < 1506297600){
118             period = 3;
119         }
120         else if(now >= 1506297600 && now < 1506729600){
121             period = 4;
122         }
123         else if(now >= 1506729600 && now < 1507593600){
124             period = 5;
125         }
126         else {
127             period = 6;
128         }
129     }
130 
131     function claim_PreICOTokens(address holder)
132     {
133         uint256 reward = 0;
134 
135         if(claimedMK[holder]==false){
136             reward = etherToTokens(contractMKPreICO.getDataHolders(holder), priceRound[0]);
137             icoTokenSupply -= reward;
138             claimedMK[holder] = true;
139         }
140 
141         if(claimedPreICO[holder]==false){
142             uint256 preico_reward = etherToTokens(contractPreICO.getDataHolders(holder), priceRound[1]);
143             reward += preico_reward;
144             icoTokenSupply -= preico_reward;
145             reward += etherToTokens(contractAffiliatePreICO.refferalPreICOBonus(holder), priceRound[1]);
146             claimedPreICO[holder] = true;
147         }
148 
149         assert(reward>0);
150 
151         if(exchanges[holder] == true)
152         {
153             contractTokens.mintTokens(exchangesOwner, reward);
154         }
155         else
156         {
157             contractTokens.mintTokens(holder, reward);
158         }
159     }
160 
161     function claim_partnerPreICOTokens(address partner)
162     {
163         assert(claimedPartnerPreICO[partner]==false);
164         uint256 reward = etherToTokens(contractAffiliatePreICO.partnerPreICOBonus(partner), priceRound[1]);
165 
166         assert(reward>0);
167 
168         contractTokens.mintTokens(partner, reward);
169         claimedPartnerPreICO[partner] = true;
170     }
171 
172     function buy(string promo) payable
173     {
174         uint8 period_number = periodNow();
175         assert(exchanges[msg.sender]==false);
176         assert(period_number >= 2 && period_number <= 5);
177         assert(icoTokenSupply > 0);
178         assert(msg.value >= 0.1 ether);
179 
180         uint256 amount_invest = msg.value;
181         uint256 reward = etherToTokens(amount_invest, priceRound[period_number]);
182 
183         if(reward > icoTokenSupply)
184         {
185             reward = icoTokenSupply;
186             amount_invest = tokensToEther(reward, priceRound[period_number]);
187             assert(msg.value > amount_invest);
188             msg.sender.transfer(msg.value - amount_invest);
189         }
190 
191         icoTokenSupply -= reward;
192 
193         if (bytes(promo).length > 0)
194 		{
195             var (partner_address, partner_bonus, referral_bonus) = contractAffiliateICO.add_referral(msg.sender, promo, amount_invest);
196 
197             if(partner_bonus > 0 && partner_address != address(0x0))
198             {
199                 uint256 p_bonus = etherToTokens(partner_bonus, priceRound[period_number]);
200                 partnerBonus[period_number] += p_bonus;
201                 contractTokens.mintTokens(partner_address, p_bonus);
202             }
203 
204             if(referral_bonus > 0)
205             {
206                 uint256 bonus = etherToTokens(referral_bonus, priceRound[period_number]);
207                 holdersBonus[period_number] += bonus;
208                 reward += bonus;
209             }
210         }
211         contractTokens.mintTokens(msg.sender, reward);
212     }
213 
214     function () payable
215     {
216         buy('');
217     }
218 
219     function collect() isOwner
220     {
221         assert(this.balance > 0);
222         msg.sender.transfer(this.balance);
223     }
224 
225     function ownerEmit() isOwner
226     {
227         assert(now > endDate);
228         assert(isOwnerEmit==false);
229 
230         uint256 users_emit = ((7*(10**26))-icoTokenSupply); // 700 000 000
231         // ico amount   - 70% supply
232         // funds amount - 30% supply
233         // funds amount = ico amount * 3 / 7
234         uint256 dev_emit = users_emit * 30 / 70;
235 
236         // contractTokens.totalSupply() = users_emit + partner_rewards + users_bouns
237         // uint256 partner_and_bouns_rewards = contractTokens.totalSupply() - users_emit;
238         // dev_emit = dev_emit - partner_and_bouns_rewards;
239         dev_emit = dev_emit + users_emit - contractTokens.totalSupply();
240 
241         isOwnerEmit = true;
242         contractTokens.mintTokens(msg.sender, dev_emit);
243     }
244 }