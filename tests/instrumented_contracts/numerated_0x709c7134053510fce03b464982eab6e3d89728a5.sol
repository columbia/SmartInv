1 pragma solidity ^0.4.4;
2 
3 contract PixelSelling {
4 
5     struct Location{
6         address owner;
7         string image;
8         string message;
9         bool sale;
10         address saleTo;
11         uint price;
12     }
13 
14     struct Share{
15         address owner;
16         uint lastCashout;
17         bool sale;
18         address saleTo;
19         uint price;
20     }
21 
22     uint public latestprice;
23     uint public noShares;
24     uint public noSales;
25     mapping (address=>uint) public balances;
26 
27     uint emptyLocationProvision;
28     uint privSaleProvision;
29     uint priceRise;
30     address creator;
31 
32     mapping (uint=>Location) public locations;
33     mapping (uint=>Share) public shares;
34 
35     uint[] provisions;
36 
37     event Change(uint id, string eventType);
38 
39     modifier isValidLocId(uint id){
40         if(!(id>=0 && id<10000))
41             throw;
42         _;
43     }
44 
45     function PixelSelling() {
46         creator=msg.sender;
47         latestprice=10000000000000000;
48         priceRise  =20000000000000000;
49         noShares=0;
50         noSales=0;
51         emptyLocationProvision=90;
52         privSaleProvision=9;
53     }
54 
55     function(){throw;}
56 
57     function buyEmptyLocation(uint id) isValidLocId(id) payable{
58         Location l=locations[id];
59         if(l.owner==0x0 && msg.value==latestprice){
60             l.owner=msg.sender;
61             l.image='';
62             l.message='';
63 
64             l.sale=false;
65             l.saleTo=0x0;
66             l.price=latestprice;
67 
68             shares[id] = Share(msg.sender,noSales,false,0x0,latestprice);
69 
70             if(noShares>0){
71                 balances[creator]+=(latestprice/100)*(100-emptyLocationProvision);
72                 creditShareProvision(latestprice, emptyLocationProvision);
73             }else{
74                 balances[creator]+=latestprice;
75                 provisions.push(0);
76                 noSales+=1;
77             }
78 
79             noShares+=1;
80 
81             latestprice+=priceRise;
82 
83             Change(id,'owner');
84         }else{
85             throw;
86         }
87     }
88 
89     function buyImagePriv(uint id) isValidLocId(id) payable{
90         Location l=locations[id];
91         if(
92             l.owner!=0x0 &&
93             l.sale==true &&
94             (l.saleTo==msg.sender||l.saleTo==0x0) &&
95             msg.value==l.price
96         ){
97             l.image='';
98             l.message='';
99             l.sale=false;
100             l.saleTo=0x0;
101 
102             balances[creator]+=(msg.value/100);
103             balances[l.owner]+=(msg.value/100)*(99-privSaleProvision);
104 
105             l.owner=msg.sender;
106 
107             creditShareProvision(msg.value, privSaleProvision);
108 
109             Change(id,'img owner');
110         }else{
111             throw;
112         }
113     }
114 
115     function buySharePriv(uint id) isValidLocId(id) payable{
116         Share s=shares[id];
117 		if(
118 			s.owner!=0x0 &&
119 			s.sale==true &&
120 			(s.saleTo==msg.sender||s.saleTo==0x0) &&
121 			msg.value==s.price
122 		){
123             s.sale=false;
124             s.saleTo=0x0;
125 
126             balances[creator]+=(msg.value/100);
127             balances[shares[id].owner]+=(msg.value/100)*(99-privSaleProvision);
128 
129             shares[id].owner=msg.sender;
130 
131             creditShareProvision(msg.value, privSaleProvision);
132 
133             Change(id,'share owner');
134         }else{
135             throw;
136         }
137     }
138 
139     function setImage(uint id, string img) isValidLocId(id) {
140 		Location l=locations[id];
141         if(l.owner==msg.sender && bytes(img).length<5001){
142             l.image=img;
143             Change(id,'image');
144         }else{
145             throw;
146         }
147     }
148 
149     function setMessage(uint id, string mssg) isValidLocId(id) {
150 		Location l=locations[id];
151         if(l.owner==msg.sender && bytes(mssg).length<501){
152             l.message=mssg;
153             Change(id,'message');
154         }else{
155 			throw;
156 		}
157     }
158 
159     function setSaleImg(uint id, bool setSale, address to, uint p) isValidLocId(id) {
160         Location l=locations[id];
161 		if(l.owner==msg.sender){
162             l.sale=setSale;
163             l.price=p;
164             l.saleTo=to;
165             Change(id,'img sale');
166         }else{
167 			throw;
168 		}
169     }
170 
171     function setSaleShare(uint id, bool setSale, address to, uint p) isValidLocId(id) {
172         Share s=shares[id];
173 		if(s.owner==msg.sender){
174             s.sale=setSale;
175             s.price=p;
176             s.saleTo=to;
177             Change(id,'share sale');
178         }else{
179 			throw;
180 		}
181     }
182 
183     function creditShareProvision(uint price, uint provision) private {
184         provisions.push(provisions[noSales-1]+(((price/100)*provision)/noShares));
185         noSales+=1;
186     }
187 
188     function getProvisionBalance(uint id) isValidLocId(id) constant returns (uint balance) {
189         Share s=shares[id];
190         if(s.owner!=0x0){
191             return provisions[noSales-1]-provisions[s.lastCashout];
192         }else{
193             return 0;
194         }
195     }
196 
197     function collectProvisions(uint id) isValidLocId(id) {
198         Share s=shares[id];
199         if(s.owner==msg.sender){
200             balances[s.owner]+=provisions[noSales-1]-provisions[s.lastCashout];
201             s.lastCashout=noSales-1;
202         }else{
203             throw;
204         }
205     }
206 
207     function withdrawBalance() {
208         if(balances[msg.sender]>0){
209             uint amtToWithdraw=balances[msg.sender];
210             balances[msg.sender]=0;
211             if(!msg.sender.send(amtToWithdraw)) throw;
212         }else{
213             throw;
214         }
215     }
216 }