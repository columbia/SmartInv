1 pragma solidity ^0.4.15;
2 
3 
4 contract BMICOAffiliateProgramm {
5     struct itemReferrals {
6         uint256 amount_investments;
7         uint256 preico_holdersBonus;
8     }
9     mapping (address => itemReferrals) referralsInfo;
10     uint256 public preico_holdersAmountInvestWithBonus = 0;
11 
12     mapping (string => address) partnersPromo;
13     struct itemPartners {
14         uint256 attracted_investments;
15         string promo;
16         uint16 personal_percent;
17         uint256 preico_partnerBonus;
18         bool create;
19     }
20     mapping (address => itemPartners) partnersInfo;
21 
22     uint16 public ref_percent = 100; //1 = 0.01%, 10000 = 100%
23 
24     struct itemHistory {
25         uint256 datetime;
26         address referral;
27         uint256 amount_invest;
28     }
29     mapping(address => itemHistory[]) history;
30 
31     uint256 public amount_referral_invest;
32 
33     address public owner;
34     address public contractPreICO;
35     address public contractICO;
36 
37     function BMICOAffiliateProgramm(){
38         owner = msg.sender;
39         contractPreICO = address(0x0);
40         contractICO = address(0x0);
41     }
42 
43     modifier isOwner()
44     {
45         assert(msg.sender == owner);
46         _;
47     }
48 
49     function str_length(string x) constant internal returns (uint256) {
50         bytes32 str;
51         assembly {
52         str := mload(add(x, 32))
53         }
54         bytes memory bytesString = new bytes(32);
55         uint256 charCount = 0;
56         for (uint j = 0; j < 32; j++) {
57             byte char = byte(bytes32(uint(str) * 2 ** (8 * j)));
58             if (char != 0) {
59                 bytesString[charCount] = char;
60                 charCount++;
61             }
62         }
63         return charCount;
64     }
65 
66     function changeOwner(address new_owner) isOwner {
67         assert(new_owner!=address(0x0));
68         assert(new_owner!=address(this));
69 
70         owner = new_owner;
71     }
72 
73     function setReferralPercent(uint16 new_percent) isOwner {
74         ref_percent = new_percent;
75     }
76 
77     function setPartnerPercent(address partner, uint16 new_percent) isOwner {
78         assert(partner!=address(0x0));
79         assert(partner!=address(this));
80         assert(partnersInfo[partner].create==true);
81         partnersInfo[partner].personal_percent = new_percent;
82     }
83 
84     function setContractPreICO(address new_address) isOwner {
85         assert(contractPreICO==address(0x0));
86         assert(new_address!=address(0x0));
87         assert(new_address!=address(this));
88 
89         contractPreICO = new_address;
90     }
91 
92     function setContractICO(address new_address) isOwner {
93         assert(contractICO==address(0x0));
94         assert(new_address!=address(0x0));
95         assert(new_address!=address(this));
96 
97         contractICO = new_address;
98     }
99 
100     function setPromoToPartner(string promo) {
101         assert(partnersPromo[promo]==address(0x0));
102         assert(partnersInfo[msg.sender].create==false);
103         assert(str_length(promo)>0 && str_length(promo)<=6);
104 
105         partnersPromo[promo] = msg.sender;
106         partnersInfo[msg.sender].attracted_investments = 0;
107         partnersInfo[msg.sender].promo = promo;
108         partnersInfo[msg.sender].create = true;
109     }
110 
111     function checkPromo(string promo) constant returns(bool){
112         return partnersPromo[promo]!=address(0x0);
113     }
114 
115     function checkPartner(address partner_address) constant returns(bool isPartner, string promo){
116         isPartner = partnersInfo[partner_address].create;
117         promo = '-1';
118         if(isPartner){
119             promo = partnersInfo[partner_address].promo;
120         }
121     }
122 
123     function calc_partnerPercent(address partner) constant internal returns(uint16 percent){
124         percent = 0;
125         if(partnersInfo[partner].personal_percent > 0){
126             percent = partnersInfo[partner].personal_percent;
127         }
128         else{
129             uint256 attracted_investments = partnersInfo[partner].attracted_investments;
130             if(attracted_investments > 0){
131                 if(attracted_investments < 3 ether){
132                     percent = 300; //1 = 0.01%, 10000 = 100%
133                 }
134                 else if(attracted_investments >= 3 ether && attracted_investments < 10 ether){
135                     percent = 500;
136                 }
137                 else if(attracted_investments >= 10 ether && attracted_investments < 100 ether){
138                     percent = 700;
139                 }
140                 else if(attracted_investments >= 100 ether){
141                     percent = 1000;
142                 }
143             }
144         }
145     }
146 
147     function partnerInfo(address partner_address) isOwner constant returns(string promo, uint256 attracted_investments, uint256[] h_datetime, uint256[] h_invest, address[] h_referrals){
148         if(partner_address != address(0x0) && partnersInfo[partner_address].create){
149             promo = partnersInfo[partner_address].promo;
150             attracted_investments = partnersInfo[partner_address].attracted_investments;
151 
152             h_datetime = new uint256[](history[partner_address].length);
153             h_invest = new uint256[](history[partner_address].length);
154             h_referrals = new address[](history[partner_address].length);
155 
156             for(uint256 i=0; i<history[partner_address].length; i++){
157                 h_datetime[i] = history[partner_address][i].datetime;
158                 h_invest[i] = history[partner_address][i].amount_invest;
159                 h_referrals[i] = history[partner_address][i].referral;
160             }
161         }
162         else{
163             promo = '-1';
164             attracted_investments = 0;
165             h_datetime = new uint256[](0);
166             h_invest = new uint256[](0);
167             h_referrals = new address[](0);
168         }
169     }
170 
171     function refferalPreICOBonus(address referral) constant external returns (uint256 bonus){
172         bonus = referralsInfo[referral].preico_holdersBonus;
173     }
174 
175     function partnerPreICOBonus(address partner) constant external returns (uint256 bonus){
176         bonus = partnersInfo[partner].preico_partnerBonus;
177     }
178 
179     function referralAmountInvest(address referral) constant external returns (uint256 amount){
180         amount = referralsInfo[referral].amount_investments;
181     }
182 
183     function add_referral(address referral, string promo, uint256 amount) external returns(address partner, uint256 p_partner, uint256 p_referral){
184         p_partner = 0;
185         p_referral = 0;
186         partner = address(0x0);
187         if(partnersPromo[promo] != address(0x0) && partnersPromo[promo] != referral){
188             partner = partnersPromo[promo];
189             if(msg.sender == contractPreICO){
190                 referralsInfo[referral].amount_investments += amount;
191                 amount_referral_invest += amount;
192                 partnersInfo[partner].attracted_investments += amount;
193                 history[partner].push(itemHistory(now, referral, amount));
194 
195                 uint256 partner_bonus = (amount*uint256(calc_partnerPercent(partner)))/10000;
196                 if(partner_bonus > 0){
197                     partnersInfo[partner].preico_partnerBonus += partner_bonus;
198                 }
199                 uint256 referral_bonus = (amount*uint256(ref_percent))/10000;
200                 if(referral_bonus > 0){
201                     referralsInfo[referral].preico_holdersBonus += referral_bonus;
202                     preico_holdersAmountInvestWithBonus += amount;
203                 }
204             }
205             if (msg.sender == contractICO){
206                 referralsInfo[referral].amount_investments += amount;
207                 amount_referral_invest += amount;
208                 partnersInfo[partner].attracted_investments += amount;
209                 history[partner].push(itemHistory(now, referral, amount));
210                 p_partner = (amount*uint256(calc_partnerPercent(partner)))/10000;
211                 p_referral = (amount*uint256(ref_percent))/10000;
212             }
213         }
214     }
215 }