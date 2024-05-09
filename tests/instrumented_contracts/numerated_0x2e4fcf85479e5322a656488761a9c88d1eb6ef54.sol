1 pragma solidity ^0.4.25;
2 
3 interface ERC20TokenInterface {
4     function balanceOf(address _who) external view returns (uint256);
5     function transfer(address _to, uint256 _value) external returns (bool);
6 }
7 
8 contract WorldByEth {
9 
10     using SafeMath for *;
11     string constant public name = "ETH world top";
12     string constant public symbol = "cqwt";
13     uint public gap = 2 minutes;
14     uint public ctnum = 217;
15     uint public deadline;
16     bool public active = false;
17     uint public max = 1 hours;
18     uint constant min_purchase = 0.05 ether;
19     address public owner;
20     address private nextOwner;
21     address public lastplayer = 0x8F92200Dd83E8f25cB1daFBA59D5532507998307;
22     address public comaddr = 0x8F92200Dd83E8f25cB1daFBA59D5532507998307;
23     address public lastwinner;
24     uint[] public validplayers;
25     uint256 public rID_;
26     mapping(uint256 => uint256) public pot_;
27     mapping(uint256 => mapping(uint256 => Ctry)) public ctry_;
28     mapping(uint256 => uint256) public totalinvest_;
29 
30     uint public _rate = 1000;
31 
32     struct Ctry {
33         uint256 id;
34         uint256 price;
35         bytes32 name;
36         bytes32 mem;
37         address owner;
38     }
39 
40     event LOG_Winner(address addr, uint amount);
41     constructor()
42     public {
43         rID_++;
44         validplayers.length = 0;
45         deadline = now + max;
46         owner = msg.sender;
47     }
48     modifier isActive {
49         if (!active) revert();
50         _;
51     }
52 
53     modifier isHuman() {
54         address _addr = msg.sender;
55         require(_addr == tx.origin);
56 
57         uint256 _codeLength;
58 
59         assembly {
60             _codeLength: = extcodesize(_addr)
61         }
62         require(_codeLength == 0, "sorry humans only");
63         _;
64     }
65 
66     modifier onlyDevs() {
67         require(
68             msg.sender == 0x4E10a18A23d1BD1DF6331C48CFD75d31F125cA30 ||
69             msg.sender == 0x8F92200Dd83E8f25cB1daFBA59D5532507998307,
70             "only team just can activate"
71         );
72         _;
73     }
74 
75     function getvalid() constant
76     public
77     returns(uint[]) {
78         return validplayers;
79     }
80 
81     function changeRemark(uint id, bytes32 mem) isActive
82     isHuman
83     public
84     payable {
85         require(msg.sender == ctry_[rID_][id].owner, "msgSender should be countryOwner.");
86         if (mem != "") {
87             ctry_[rID_][id].mem = mem;
88         }
89     }
90 
91     function pot() isActive
92     public
93     payable {
94         pot_[rID_] += msg.value;
95     }
96 
97     function setActive(uint idnum)
98     onlyDevs
99     public {
100         if (active) {
101             return;
102         }
103         active = true;
104         ctnum = idnum;
105     }
106 
107     function withcom()
108     onlyDevs
109     public {
110         if (address(this).balance > pot_[rID_]) {
111             comaddr.transfer(address(this).balance - pot_[rID_]);
112         }
113     }
114 
115     function settimmer(uint _gap)
116     private {
117         deadline += _gap;
118         if (deadline > now + max) {
119             deadline = now + max;
120         }
121     }
122 
123     function turnover()
124     private
125     returns(bool) {
126         if (validplayers.length < ctnum) {
127             settimmer(max);
128             return true;
129         }
130 
131         if (now > deadline) {
132             uint win = pot_[rID_].mul(6).div(10);
133             lastplayer.transfer(win);
134             lastwinner = lastplayer;
135             emit LOG_Winner(lastwinner, win);
136             pot_[rID_ + 1] += pot_[rID_] - win;
137             pot_[rID_] = 0;
138             deadline = now + max;
139             return false;
140         }
141 
142         settimmer(gap);
143         return true;
144     }
145 
146     function ()
147     public
148     payable {}
149 
150     function buyOne(uint id, bytes32 memo) isHuman external payable {
151         require(msg.value >= min_purchase, "Amount should be within range.");
152         require(msg.value >= ctry_[rID_][id].price, "Price should be within range.");
153         require(id>0 && id <= ctnum, "CountryNum should be within ctnum.");
154         buy(id, memo, msg.value);
155     }
156     
157     function buyManyCountries(uint[] countryIds) isHuman
158     external
159     payable {
160         uint restValue = msg.value;
161         require(restValue >= countryIds.length.mul(min_purchase), "Amount should be within range.");
162 
163         for (uint i = 0; i < countryIds.length; i++) {
164             uint countryid = countryIds[i];
165             if (countryid == 0 || countryid > ctnum) {
166                 continue;
167             }
168 
169             uint buyprice = min_purchase;
170             if (ctry_[rID_][countryid].price > 0) {
171                 buyprice = ctry_[rID_][countryid].price;
172             }
173 
174             if (restValue < buyprice) {
175                 continue;
176             }
177 
178             buy(countryid, "", buyprice);
179             restValue = restValue.sub(buyprice);
180         }
181 
182         if (restValue > 0 ){
183             (msg.sender).transfer(restValue);
184         }
185     }
186 
187     function devi(uint id,uint _price)
188     private
189     {
190         if( rID_ <= 1){
191             return;
192         }
193 
194         if (rID_ > 2){
195             if (ctry_[rID_ - 1][id].owner != address(0x0)) {
196                 ctry_[rID_ - 1][id].owner.transfer((_price).mul(15).div(1000));
197             }
198         }
199 
200         if (ctry_[1][id].owner != address(0x0)) {
201             ctry_[1][id].owner.transfer((_price).mul(15).div(1000));
202         }
203     }
204 
205     function buy(uint id, bytes32 memo, uint _price) isActive private {
206         if (memo != "") {
207             ctry_[rID_][id].mem = memo;
208         }
209 
210         if (turnover() == true) {
211             uint gamepot = (_price).mul(7).div(100);
212             pot_[rID_] += gamepot;
213 
214             devi(id,_price);
215             
216             if (ctry_[rID_][id].owner != address(0x0)) {
217                 ctry_[rID_][id].owner.transfer((_price).mul(88).div(100)); 
218             } else {
219                 validplayers.push(id);
220             }
221 
222             ctry_[rID_][id].owner = msg.sender;
223             ctry_[rID_][id].price = (_price).mul(14).div(10);
224             
225         } else {
226             rID_++;
227             validplayers.length = 0;
228             ctry_[rID_][id].owner = msg.sender;
229             ctry_[rID_][id].price = 0.07 ether;
230             validplayers.push(id);
231             (msg.sender).transfer(_price - min_purchase);
232             _price = min_purchase;
233         }
234         lastplayer = msg.sender;
235         totalinvest_[rID_] += _price;
236         ctry_[rID_][id].id = id;
237     }
238 }
239 
240 library SafeMath {
241     function mul(uint256 a, uint256 b)
242     internal
243     pure
244     returns(uint256 c) {
245         if (a == 0) {
246             return 0;
247         }
248         c = a * b;
249         require(c / a == b, "SafeMath mul failed");
250         return c;
251     }
252 
253     function div(uint256 a, uint256 b) internal pure returns(uint256) {
254         uint256 c = a / b;
255         return c;
256     }
257 
258     function sub(uint256 a, uint256 b)
259     internal
260     pure
261     returns(uint256) {
262         require(b <= a, "SafeMath sub failed");
263         return a - b;
264     }
265 
266     function add(uint256 a, uint256 b)
267     internal
268     pure
269     returns(uint256 c) {
270         c = a + b;
271         require(c >= a, "SafeMath add failed");
272         return c;
273     }
274 
275     function sqrt(uint256 x)
276     internal
277     pure
278     returns(uint256 y) {
279         uint256 z = ((add(x, 1)) / 2);
280         y = x;
281         while (z < y) {
282             y = z;
283             z = ((add((x / z), z)) / 2);
284         }
285     }
286 
287 
288     function sq(uint256 x)
289     internal
290     pure
291     returns(uint256) {
292         return (mul(x, x));
293     }
294 
295 
296     function pwr(uint256 x, uint256 y)
297     internal
298     pure
299     returns(uint256) {
300         if (x == 0)
301             return (0);
302         else if (y == 0)
303             return (1);
304         else {
305             uint256 z = x;
306             for (uint256 i = 1; i < y; i++)
307                 z = mul(z, x);
308             return (z);
309         }
310     }
311 }