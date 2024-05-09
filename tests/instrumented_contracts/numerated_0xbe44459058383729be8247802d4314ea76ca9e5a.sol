1 pragma solidity ^0.4.16;
2 
3 
4 contract BMICOAffiliateProgramm {
5     mapping (address => uint256) referralsInfo;
6 
7     mapping (bytes32 => address) partnersPromo;
8     struct itemPartners {
9         uint256 attracted_investments;
10         bytes32 promo;
11         uint16 personal_percent;
12         bool create;
13     }
14     mapping (address => itemPartners) partnersInfo;
15 
16     uint16 public ref_percent = 100; //1 = 0.01%, 10000 = 100%
17 
18     struct itemHistory {
19         uint256 datetime;
20         address referral;
21         uint256 amount_invest;
22     }
23     mapping(address => itemHistory[]) history;
24 
25     uint256 public amount_referral_invest;
26 
27     address public owner;
28     address public contractICO;
29 
30     function BMICOAffiliateProgramm(){
31         owner = msg.sender;
32         contractICO = address(0x0);
33     }
34 
35     modifier isOwner()
36     {
37         assert(msg.sender == owner);
38         _;
39     }
40 
41     function changeOwner(address new_owner) isOwner {
42         assert(new_owner!=address(0x0));
43         assert(new_owner!=address(this));
44 
45         owner = new_owner;
46     }
47 
48     function setPartnerFromPreICOAffiliate(address[] partners, bytes32[] promo_codes, uint256[] attracted_invests) isOwner {
49         assert(partners.length==promo_codes.length && partners.length==attracted_invests.length);
50 
51         for(uint256 i=0; i<partners.length; i++){
52             if(!partnersInfo[partners[i]].create){
53                 partnersPromo[promo_codes[i]] = partners[i];
54                 partnersInfo[partners[i]].attracted_investments = attracted_invests[i];
55                 partnersInfo[partners[i]].promo = promo_codes[i];
56                 partnersInfo[partners[i]].create = true;
57             }
58         }
59     }
60 
61     function setReferralPercent(uint16 new_percent) isOwner {
62         ref_percent = new_percent;
63     }
64 
65     function setPartnerPercent(address partner, uint16 new_percent) isOwner {
66         assert(partner!=address(0x0));
67         assert(partner!=address(this));
68         assert(partnersInfo[partner].create==true);
69         assert(new_percent<=1500);
70         partnersInfo[partner].personal_percent = new_percent;
71     }
72 
73     function setContractICO(address new_address) isOwner {
74         assert(contractICO==address(0x0));
75         assert(new_address!=address(0x0));
76         assert(new_address!=address(this));
77 
78         contractICO = new_address;
79     }
80 
81     function stringTobytes32(string str) constant returns (bytes32){
82         bytes32 result;
83         assembly {
84             result := mload(add(str, 6))
85         }
86         return result;
87     }
88 
89     function str_length(string x) constant internal returns (uint256) {
90         return bytes(x).length;
91     }
92 
93     function setPromoToPartner(string code) {
94         bytes32 promo = stringTobytes32(code);
95         assert(partnersPromo[promo]==address(0x0));
96         assert(partnersInfo[msg.sender].create==false);
97         assert(str_length(code)>0 && str_length(code)<=6);
98 
99         partnersPromo[promo] = msg.sender;
100         partnersInfo[msg.sender].attracted_investments = 0;
101         partnersInfo[msg.sender].promo = promo;
102         partnersInfo[msg.sender].create = true;
103     }
104 
105     function checkPromo(string promo) constant returns(bool){
106         bytes32 result = stringTobytes32(promo);
107         return partnersPromo[result]!=address(0x0);
108     }
109 
110     function checkPartner(address partner_address) constant returns(bool isPartner, bytes32 promo){
111         isPartner = partnersInfo[partner_address].create;
112         promo = '-1';
113         if(isPartner){
114             promo = partnersInfo[partner_address].promo;
115         }
116     }
117 
118     function calc_partnerPercent(address partner) constant internal returns(uint16 percent){
119         percent = 0;
120         if(partnersInfo[partner].personal_percent > 0){
121             percent = partnersInfo[partner].personal_percent;
122         }
123         else{
124             uint256 attracted_investments = partnersInfo[partner].attracted_investments;
125             if(attracted_investments > 0){
126                 if(attracted_investments < 3 ether){
127                     percent = 300; //1 = 0.01%, 10000 = 100%
128                 }
129                 else if(attracted_investments >= 3 ether && attracted_investments < 10 ether){
130                     percent = 500;
131                 }
132                 else if(attracted_investments >= 10 ether && attracted_investments < 100 ether){
133                     percent = 700;
134                 }
135                 else if(attracted_investments >= 100 ether){
136                     percent = 1000;
137                 }
138             }
139         }
140     }
141 
142     function partnerInfo(address partner_address) isOwner constant returns(bytes32 promo, uint256 attracted_investments, uint256[] h_datetime, uint256[] h_invest, address[] h_referrals){
143         if(partner_address != address(0x0) && partnersInfo[partner_address].create){
144             promo = partnersInfo[partner_address].promo;
145             attracted_investments = partnersInfo[partner_address].attracted_investments;
146 
147             h_datetime = new uint256[](history[partner_address].length);
148             h_invest = new uint256[](history[partner_address].length);
149             h_referrals = new address[](history[partner_address].length);
150 
151             for(uint256 i=0; i<history[partner_address].length; i++){
152                 h_datetime[i] = history[partner_address][i].datetime;
153                 h_invest[i] = history[partner_address][i].amount_invest;
154                 h_referrals[i] = history[partner_address][i].referral;
155             }
156         }
157         else{
158             promo = '-1';
159             attracted_investments = 0;
160             h_datetime = new uint256[](0);
161             h_invest = new uint256[](0);
162             h_referrals = new address[](0);
163         }
164     }
165 
166     function referralAmountInvest(address referral) constant external returns (uint256 amount){
167         amount = referralsInfo[referral];
168     }
169 
170     function add_referral(address referral, string promo, uint256 amount) external returns(address partner, uint256 p_partner, uint256 p_referral){
171         bytes32 promo_code = stringTobytes32(promo);
172 
173         p_partner = 0;
174         p_referral = 0;
175         partner = address(0x0);
176         if(partnersPromo[promo_code] != address(0x0) && partnersPromo[promo_code] != referral){
177             partner = partnersPromo[promo_code];
178             if (msg.sender == contractICO){
179                 referralsInfo[referral] += amount;
180                 amount_referral_invest += amount;
181                 partnersInfo[partner].attracted_investments += amount;
182                 history[partner].push(itemHistory(now, referral, amount));
183                 p_partner = (amount*uint256(calc_partnerPercent(partner)))/10000;
184                 p_referral = (amount*uint256(ref_percent))/10000;
185             }
186         }
187     }
188 }