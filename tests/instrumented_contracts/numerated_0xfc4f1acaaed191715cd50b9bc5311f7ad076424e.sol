1 pragma solidity ^0.4.15;
2 
3 
4 contract BMICOAffiliateProgramm {
5     mapping (string => address) partnersPromo;
6     mapping (address => uint256) referrals;
7 
8     struct itemPartners {
9         uint256 balance;
10         string promo;
11         bool create;
12     }
13     mapping (address => itemPartners) partnersInfo;
14 
15     uint256 public ref_percent = 100; //1 = 0.01%, 10000 = 100%
16 
17 
18     struct itemHistory {
19     uint256 datetime;
20     address referral;
21     uint256 amount_invest;
22     }
23     mapping(address => itemHistory[]) history;
24 
25     uint256 public amount_referral_invest;
26 
27     address public owner;
28     address public contractPreICO;
29     address public contractICO;
30 
31     function BMICOAffiliateProgramm(){
32         owner = msg.sender;
33         contractPreICO = address(0x0);
34         contractICO = address(0x0);
35     }
36 
37     modifier isOwner()
38     {
39         assert(msg.sender == owner);
40         _;
41     }
42 
43     function str_length(string x) constant internal returns (uint256) {
44         bytes32 str;
45         assembly {
46             str := mload(add(x, 32))
47         }
48         bytes memory bytesString = new bytes(32);
49         uint256 charCount = 0;
50         for (uint j = 0; j < 32; j++) {
51             byte char = byte(bytes32(uint(str) * 2 ** (8 * j)));
52             if (char != 0) {
53                 bytesString[charCount] = char;
54                 charCount++;
55             }
56         }
57         return charCount;
58     }
59 
60     function changeOwner(address new_owner) isOwner {
61         assert(new_owner!=address(0x0));
62         assert(new_owner!=address(this));
63 
64         owner = new_owner;
65     }
66 
67     function setReferralPercent(uint256 new_percent) isOwner {
68         ref_percent = new_percent;
69     }
70 
71     function setContractPreICO(address new_address) isOwner {
72         assert(contractPreICO==address(0x0));
73         assert(new_address!=address(0x0));
74         assert(new_address!=address(this));
75 
76         contractPreICO = new_address;
77     }
78 
79     function setContractICO(address new_address) isOwner {
80         assert(contractICO==address(0x0));
81         assert(new_address!=address(0x0));
82         assert(new_address!=address(this));
83 
84         contractICO = new_address;
85     }
86 
87     function setPromoToPartner(string promo) {
88         assert(partnersPromo[promo]==address(0x0));
89         assert(partnersInfo[msg.sender].create==false);
90         assert(str_length(promo)>0 && str_length(promo)<=6);
91 
92         partnersPromo[promo] = msg.sender;
93         partnersInfo[msg.sender].balance = 0;
94         partnersInfo[msg.sender].promo = promo;
95         partnersInfo[msg.sender].create = true;
96     }
97 
98     function checkPromo(string promo) constant returns(bool){
99         return partnersPromo[promo]!=address(0x0);
100     }
101 
102     function checkPartner(address partner_address) constant returns(bool isPartner, string promo){
103         isPartner = partnersInfo[partner_address].create;
104         promo = '-1';
105         if(isPartner){
106             promo = partnersInfo[partner_address].promo;
107         }
108     }
109 
110     function calc_partnerPercent(uint256 ref_amount_invest) constant internal returns(uint16 percent){
111         percent = 0;
112         if(ref_amount_invest > 0){
113             if(ref_amount_invest < 2 ether){
114                 percent = 100; //1 = 0.01%, 10000 = 100%
115             }
116             else if(ref_amount_invest >= 2 ether && ref_amount_invest < 3 ether){
117                 percent = 200;
118             }
119             else if(ref_amount_invest >= 3 ether && ref_amount_invest < 4 ether){
120                 percent = 300;
121             }
122             else if(ref_amount_invest >= 4 ether && ref_amount_invest < 5 ether){
123                 percent = 400;
124             }
125             else if(ref_amount_invest >= 5 ether){
126                 percent = 500;
127             }
128         }
129     }
130 
131     function partnerInfo(address partner_address) constant internal returns(string promo, uint256 balance, uint256[] h_datetime, uint256[] h_invest, address[] h_referrals){
132         if(partner_address != address(0x0) && partnersInfo[partner_address].create){
133             promo = partnersInfo[partner_address].promo;
134             balance = partnersInfo[partner_address].balance;
135 
136             h_datetime = new uint256[](history[partner_address].length);
137             h_invest = new uint256[](history[partner_address].length);
138             h_referrals = new address[](history[partner_address].length);
139 
140             for(var i=0; i<history[partner_address].length; i++){
141                 h_datetime[i] = history[partner_address][i].datetime;
142                 h_invest[i] = history[partner_address][i].amount_invest;
143                 h_referrals[i] = history[partner_address][i].referral;
144             }
145         }
146         else{
147             promo = '-1';
148             balance = 0;
149             h_datetime = new uint256[](0);
150             h_invest = new uint256[](0);
151             h_referrals = new address[](0);
152         }
153     }
154 
155     function partnerInfo_for_Partner(bytes32 hash, uint8 v, bytes32 r, bytes32 s) constant returns(string, uint256, uint256[], uint256[], address[]){
156         address partner_address = ecrecover(hash, v, r, s);
157         return partnerInfo(partner_address);
158     }
159 
160     function partnerInfo_for_Owner (address partner) isOwner constant returns(string, uint256, uint256[], uint256[], address[]){
161         return partnerInfo(partner);
162     }
163 
164     function add_referral(address referral, string promo, uint256 amount) external returns(address partner, uint256 p_partner, uint256 p_referral){
165         p_partner = 0;
166         p_referral = 0;
167         partner = address(0x0);
168         if (msg.sender == contractPreICO || msg.sender == contractICO){
169             if(partnersPromo[promo] != address(0x0) && partnersPromo[promo] != referral){
170                 partner = partnersPromo[promo];
171                 referrals[referral] += amount;
172                 amount_referral_invest += amount;
173                 partnersInfo[partner].balance += amount;
174                 history[partner].push(itemHistory(now, referral, amount));
175                 p_partner = (amount*uint256(calc_partnerPercent(amount)))/10000;
176                 p_referral = (amount*ref_percent)/10000;
177             }
178         }
179     }
180 }