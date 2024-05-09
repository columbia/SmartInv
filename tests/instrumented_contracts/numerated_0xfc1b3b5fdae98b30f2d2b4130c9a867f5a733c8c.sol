1 pragma solidity ^0.4.24;
2 
3 contract WorldByEth {
4     using SafeMath for *;
5 
6     string constant public name = "ETH world cq";
7     string constant public symbol = "ecq";
8     uint256 public rID_;
9     address public comaddr = 0x9ca974f2c49d68bd5958978e81151e6831290f57;
10     mapping(uint256 => uint256) public pot_;
11     mapping(uint256 => mapping(uint256 => Ctry)) public ctry_;
12     uint public gap = 1 hours;
13     address public lastplayer = 0x9ca974f2c49d68bd5958978e81151e6831290f57;
14     address public lastwinner;
15     uint[] public validplayers;
16     uint public ctnum = 180;
17     uint public timeleft;
18     bool public active = true;
19     bool public autobegin = true;
20     uint public max = 24 hours;
21     //mapping(uint256 => address) public lastrdowner;
22 
23     struct Ctry {
24         uint256 id;
25         uint256 price;
26         bytes32 name;
27         bytes32 mem;
28         address owner;
29     }
30 
31     mapping(uint256 => uint256) public totalinvest_;
32 
33     modifier isHuman() {
34         address _addr = msg.sender;
35         require(_addr == tx.origin);
36         
37         uint256 _codeLength;
38         
39         assembly {_codeLength := extcodesize(_addr)}
40         require(_codeLength == 0, "sorry humans only");
41         _;
42     }
43     
44     constructor()
45     public
46     {
47         rID_++;
48         validplayers.length = 0;
49         timeleft = now + max;
50     }
51 
52     function getvalid()
53     public
54     returns(uint[]){
55         return validplayers;
56     }
57     
58     function changemem(uint id, bytes32 mem)
59     isHuman
60     public
61     payable
62     {
63         require(msg.sender == ctry_[rID_][id].owner);
64         if (mem != ""){
65             ctry_[rID_][id].mem = mem;
66         }
67     }
68 
69     function buy(uint id, bytes32 mem)
70     isHuman
71     public
72     payable
73     {
74         require(active == true);
75         require(msg.value >= 0.02 ether);
76         require(msg.value >= ctry_[rID_][id].price);
77         require(id <= ctnum);
78 
79         if (validplayers.length <= 50) {
80             timeleft = now + max;
81         }
82         
83         if (mem != ""){
84             ctry_[rID_][id].mem = mem;
85         }
86 
87         if (update() == true) {
88             uint pot = (msg.value).div(10);
89             pot_[rID_] += pot;
90 
91             if (rID_> 1){
92                 if (ctry_[rID_-1][id].owner != address(0x0)) {
93                     ctry_[rID_-1][id].owner.send((msg.value).div(50));
94                 }
95             }
96         
97             if (ctry_[rID_][id].owner != address(0x0)){
98                 ctry_[rID_][id].owner.transfer((msg.value).mul(86).div(100));
99             }else{
100                 validplayers.push(id);
101             }
102             ctry_[rID_][id].owner = msg.sender;
103             ctry_[rID_][id].price = (msg.value).mul(14).div(10);
104         }else{
105             rID_++;
106             validplayers.length = 0;
107             ctry_[rID_][id].owner = msg.sender;
108             ctry_[rID_][id].price = 0.028 ether;
109             validplayers.push(id);
110             (msg.sender).send(msg.value - 0.02 ether);
111         }
112 
113         lastplayer = msg.sender;
114         totalinvest_[rID_] += msg.value;
115         ctry_[rID_][id].id = id;
116     }
117 
118     function update()
119     private
120     returns(bool)
121     {
122         if (now > timeleft) {
123             uint win = pot_[rID_].mul(6).div(10);
124             lastplayer.transfer(win);
125             lastwinner = lastplayer;
126             pot_[rID_+1] += pot_[rID_].div(5);
127             pot_[rID_] = 0;
128             timeleft = now + max;
129             if (autobegin == false){
130                 active = false;  // waiting for set open again
131             }
132             return false;
133         }
134 
135         if (validplayers.length < ctnum) {
136             timeleft += gap;
137         }
138         
139         if (timeleft > now + max) {
140             timeleft = now + max;
141         }
142         return true;
143     }
144 
145     function()
146     public
147     payable
148     {
149         
150     }
151     
152     // add to pot
153     function pot()
154     public
155     payable
156     {
157         pot_[rID_] += msg.value;
158     }
159 
160     modifier onlyDevs() {
161         require(
162             msg.sender == 0x9ca974f2c49d68bd5958978e81151e6831290f57,
163             "only team just can activate"
164         );
165         _;
166     }
167 
168     // add more countries
169     function setctnum(uint id)
170     onlyDevs
171     public
172     {
173         require(id > 180);
174         ctnum = id;
175     }
176     
177     // withdraw unreachable eth
178     function withcom()
179     onlyDevs
180     public
181     {
182         if (address(this).balance > pot_[rID_]){
183             uint left = address(this).balance - pot_[rID_];
184             comaddr.transfer(left);
185         }
186     }
187     
188     function setActive(bool _auto)
189     onlyDevs
190     public
191     {
192         active = true;
193         autobegin = _auto;
194     }
195 }
196 
197 /**
198  * @title SafeMath v0.1.9
199  * @dev Math operations with safety checks that throw on error
200  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
201  * - added sqrt
202  * - added sq
203  * - added pwr 
204  * - changed asserts to requires with error log outputs
205  * - removed div, its useless
206  */
207 library SafeMath {
208     
209     /**
210     * @dev Multiplies two numbers, throws on overflow.
211     */
212     function mul(uint256 a, uint256 b) 
213         internal 
214         pure 
215         returns (uint256 c) 
216     {
217         if (a == 0) {
218             return 0;
219         }
220         c = a * b;
221         require(c / a == b, "SafeMath mul failed");
222         return c;
223     }
224 
225     /**
226     * @dev Integer division of two numbers, truncating the quotient.
227     */
228     function div(uint256 a, uint256 b) internal pure returns (uint256) {
229         // assert(b > 0); // Solidity automatically throws when dividing by 0
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232         return c;
233     }
234     
235     /**
236     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
237     */
238     function sub(uint256 a, uint256 b)
239         internal
240         pure
241         returns (uint256) 
242     {
243         require(b <= a, "SafeMath sub failed");
244         return a - b;
245     }
246 
247     /**
248     * @dev Adds two numbers, throws on overflow.
249     */
250     function add(uint256 a, uint256 b)
251         internal
252         pure
253         returns (uint256 c) 
254     {
255         c = a + b;
256         require(c >= a, "SafeMath add failed");
257         return c;
258     }
259     
260     /**
261      * @dev gives square root of given x.
262      */
263     function sqrt(uint256 x)
264         internal
265         pure
266         returns (uint256 y) 
267     {
268         uint256 z = ((add(x,1)) / 2);
269         y = x;
270         while (z < y) 
271         {
272             y = z;
273             z = ((add((x / z),z)) / 2);
274         }
275     }
276     
277     /**
278      * @dev gives square. multiplies x by x
279      */
280     function sq(uint256 x)
281         internal
282         pure
283         returns (uint256)
284     {
285         return (mul(x,x));
286     }
287     
288     /**
289      * @dev x to the power of y 
290      */
291     function pwr(uint256 x, uint256 y)
292         internal 
293         pure 
294         returns (uint256)
295     {
296         if (x==0)
297             return (0);
298         else if (y==0)
299             return (1);
300         else 
301         {
302             uint256 z = x;
303             for (uint256 i=1; i < y; i++)
304                 z = mul(z,x);
305             return (z);
306         }
307     }
308 }