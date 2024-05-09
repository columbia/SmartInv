1 pragma solidity ^0.4.24;
2 
3 contract WorldByEth {
4     using SafeMath for *;
5     using NameFilter for string;
6     
7 
8     string constant public name = "ETH world cq";
9     string constant public symbol = "ecq";
10     uint256 public rID_;
11     uint256 public pID_;
12     uint256 public com_;
13     address public comaddr = 0x9ca974f2c49d68bd5958978e81151e6831290f57;
14     mapping(uint256 => uint256) public pot_;
15     mapping(uint256 => mapping(uint256 => Ctry)) public ctry_;
16     uint public gap = 1 hours;
17     uint public timeleft;
18     address public lastplayer = 0x9ca974f2c49d68bd5958978e81151e6831290f57;
19     address public lastwinner;
20     uint[] public validplayers;
21 
22     struct Ctry {
23         uint256 id;
24         uint256 price;
25         bytes32 name;
26         bytes32 mem;
27         address owner;
28     }
29 
30     mapping(uint256 => uint256) public totalinvest_;
31 
32     //===========
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
47         pID_++;
48         rID_++;
49         validplayers.length = 0;
50         timeleft = now + 24 hours;
51     }
52 
53     function getvalid()
54     public
55     returns(uint[]){
56         return validplayers;
57     }
58     
59     function changemem(uint id, bytes32 mem)
60     isHuman
61     public
62     payable
63     {
64         require(msg.value >= 0.1 ether);
65         require(msg.sender == ctry_[rID_][id].owner);
66         com_ += msg.value;
67         if (mem != ""){
68             ctry_[rID_][id].mem = mem;
69         }
70     }
71 
72     function buy(uint id, bytes32 mem)
73     isHuman
74     public
75     payable
76     {
77         require(msg.value >= 0.01 ether);
78         require(msg.value >=ctry_[rID_][id].price);
79 
80         if (mem != ""){
81             ctry_[rID_][id].mem = mem;
82         }
83 
84         if (update() == true) {
85             uint com = (msg.value).div(100);
86             com_ += com;
87 
88             uint pot = (msg.value).mul(9).div(100);
89             pot_[rID_] += pot;
90 
91             uint pre = msg.value - com - pot;
92         
93             if (ctry_[rID_][id].owner != address(0x0)){
94                 ctry_[rID_][id].owner.transfer(pre);
95             }else{
96                 validplayers.push(id);
97             }    
98             ctry_[rID_][id].owner = msg.sender;
99             ctry_[rID_][id].price = (msg.value).mul(14).div(10);
100         }else{
101             rID_++;
102             validplayers.length = 0;
103             ctry_[rID_][id].owner = msg.sender;
104             ctry_[rID_][id].price = (0.01 ether).mul(14).div(10);
105             validplayers.push(id);
106             (msg.sender).transfer(msg.value - 0.01 ether);
107         }
108 
109         lastplayer = msg.sender;
110         totalinvest_[rID_] += msg.value;
111         ctry_[rID_][id].id = id;
112     }
113 
114     function update()
115     private
116     returns(bool)
117     {
118         if (now > timeleft) {
119             lastplayer.transfer(pot_[rID_].mul(6).div(10));
120             lastwinner = lastplayer;
121             com_ += pot_[rID_].div(10);
122             pot_[rID_+1] += pot_[rID_].mul(3).div(10);
123             timeleft = now + 24 hours;
124             return false;
125         }
126 
127         timeleft += gap;
128         if (timeleft > now + 24 hours) {
129             timeleft = now + 24 hours;
130         }
131         return true;
132     }
133 
134     function()
135     public
136     payable
137     {
138         com_ += msg.value;
139     }
140 
141     modifier onlyDevs() {
142         require(
143             msg.sender == 0x9ca974f2c49d68bd5958978e81151e6831290f57,
144             "only team just can activate"
145         );
146         _;
147     }
148 
149     // upgrade withdraw com_ and clear it to 0
150     function withcom()
151     onlyDevs
152     public
153     {
154         if (com_ <= address(this).balance){
155             comaddr.transfer(com_);
156             com_ = 0;
157         }else{
158             comaddr.transfer(address(this).balance);
159         }
160     }
161 }
162 
163 library NameFilter {
164     /**
165      * @dev filters name strings
166      * -converts uppercase to lower case.  
167      * -makes sure it does not start/end with a space
168      * -makes sure it does not contain multiple spaces in a row
169      * -cannot be only numbers
170      * -cannot start with 0x 
171      * -restricts characters to A-Z, a-z, 0-9, and space.
172      * @return reprocessed string in bytes32 format
173      */
174     function nameFilter(string _input)
175         internal
176         pure
177         returns(bytes32)
178     {
179         bytes memory _temp = bytes(_input);
180         uint256 _length = _temp.length;
181         
182         //sorry limited to 32 characters
183         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
184         // make sure it doesnt start with or end with space
185         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
186         // make sure first two characters are not 0x
187         if (_temp[0] == 0x30)
188         {
189             require(_temp[1] != 0x78, "string cannot start with 0x");
190             require(_temp[1] != 0x58, "string cannot start with 0X");
191         }
192         
193         // create a bool to track if we have a non number character
194         bool _hasNonNumber;
195         
196         // convert & check
197         for (uint256 i = 0; i < _length; i++)
198         {
199             // if its uppercase A-Z
200             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
201             {
202                 // convert to lower case a-z
203                 _temp[i] = byte(uint(_temp[i]) + 32);
204                 
205                 // we have a non number
206                 if (_hasNonNumber == false)
207                     _hasNonNumber = true;
208             } else {
209                 require
210                 (
211                     // require character is a space
212                     _temp[i] == 0x20 || 
213                     // OR lowercase a-z
214                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
215                     // or 0-9
216                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
217                     "string contains invalid characters"
218                 );
219                 // make sure theres not 2x spaces in a row
220                 if (_temp[i] == 0x20)
221                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
222                 
223                 // see if we have a character other than a number
224                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
225                     _hasNonNumber = true;    
226             }
227         }
228         
229         require(_hasNonNumber == true, "string cannot be only numbers");
230         
231         bytes32 _ret;
232         assembly {
233             _ret := mload(add(_temp, 32))
234         }
235         return (_ret);
236     }
237 }
238 
239 // File: contracts/library/SafeMath.sol
240 
241 /**
242  * @title SafeMath v0.1.9
243  * @dev Math operations with safety checks that throw on error
244  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
245  * - added sqrt
246  * - added sq
247  * - added pwr 
248  * - changed asserts to requires with error log outputs
249  * - removed div, its useless
250  */
251 library SafeMath {
252     
253     /**
254     * @dev Multiplies two numbers, throws on overflow.
255     */
256     function mul(uint256 a, uint256 b) 
257         internal 
258         pure 
259         returns (uint256 c) 
260     {
261         if (a == 0) {
262             return 0;
263         }
264         c = a * b;
265         require(c / a == b, "SafeMath mul failed");
266         return c;
267     }
268 
269     /**
270     * @dev Integer division of two numbers, truncating the quotient.
271     */
272     function div(uint256 a, uint256 b) internal pure returns (uint256) {
273         // assert(b > 0); // Solidity automatically throws when dividing by 0
274         uint256 c = a / b;
275         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
276         return c;
277     }
278     
279     /**
280     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
281     */
282     function sub(uint256 a, uint256 b)
283         internal
284         pure
285         returns (uint256) 
286     {
287         require(b <= a, "SafeMath sub failed");
288         return a - b;
289     }
290 
291     /**
292     * @dev Adds two numbers, throws on overflow.
293     */
294     function add(uint256 a, uint256 b)
295         internal
296         pure
297         returns (uint256 c) 
298     {
299         c = a + b;
300         require(c >= a, "SafeMath add failed");
301         return c;
302     }
303     
304     /**
305      * @dev gives square root of given x.
306      */
307     function sqrt(uint256 x)
308         internal
309         pure
310         returns (uint256 y) 
311     {
312         uint256 z = ((add(x,1)) / 2);
313         y = x;
314         while (z < y) 
315         {
316             y = z;
317             z = ((add((x / z),z)) / 2);
318         }
319     }
320     
321     /**
322      * @dev gives square. multiplies x by x
323      */
324     function sq(uint256 x)
325         internal
326         pure
327         returns (uint256)
328     {
329         return (mul(x,x));
330     }
331     
332     /**
333      * @dev x to the power of y 
334      */
335     function pwr(uint256 x, uint256 y)
336         internal 
337         pure 
338         returns (uint256)
339     {
340         if (x==0)
341             return (0);
342         else if (y==0)
343             return (1);
344         else 
345         {
346             uint256 z = x;
347             for (uint256 i=1; i < y; i++)
348                 z = mul(z,x);
349             return (z);
350         }
351     }
352 }