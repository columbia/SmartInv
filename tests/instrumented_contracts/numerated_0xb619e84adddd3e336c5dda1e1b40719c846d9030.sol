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
16     uint public ctynum = 0;
17     uint public gap = 1 hours;
18     uint public timeleft;
19     address public lastplayer = 0x9ca974f2c49d68bd5958978e81151e6831290f57;
20     address public lastwinner;
21     uint[] public validplayers;
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
33     //===========
34     modifier isHuman() {
35         address _addr = msg.sender;
36         require(_addr == tx.origin);
37         
38         uint256 _codeLength;
39         
40         assembly {_codeLength := extcodesize(_addr)}
41         require(_codeLength == 0, "sorry humans only");
42         _;
43     }
44     
45     constructor()
46     public
47     {
48         pID_++;
49         rID_++;
50         validplayers.length = 0;
51         timeleft = now + gap;
52     }
53 
54     function getvalid()
55     public
56     returns(uint[]){
57         return validplayers;
58     }
59     
60 
61     function buy(uint id, bytes32 mem)
62     isHuman
63     public
64     payable
65     {
66         require(msg.value >= 0.01 ether);
67         require(msg.value >=ctry_[rID_][id].price);
68 
69         if (mem != ""){
70             ctry_[rID_][id].mem = mem;
71         }
72 
73         if (update() == true) {
74             uint com = (msg.value).div(100);
75             com_ += com;
76 
77             uint pot = (msg.value).mul(9).div(100);
78             pot_[rID_] += pot;
79 
80             uint pre = msg.value - com - pot;
81         
82             if (ctry_[rID_][id].owner != address(0x0)){
83                 ctry_[rID_][id].owner.transfer(pre);
84             }else{
85                 validplayers.push(id);
86             }    
87             ctry_[rID_][id].owner = msg.sender;
88             ctry_[rID_][id].price = (msg.value).mul(14).div(10);
89         }else{
90             rID_++;
91             validplayers.length = 0;
92             ctry_[rID_][id].owner = msg.sender;
93             ctry_[rID_][id].price = (0.01 ether).mul(14).div(10);
94             validplayers.push(id);
95             (msg.sender).transfer(msg.value - 0.01 ether);
96         }
97 
98         lastplayer = msg.sender;
99         totalinvest_[rID_] += msg.value;
100         ctry_[rID_][id].id = id;
101     }
102 
103     function update()
104     private
105     returns(bool)
106     {
107         if (now > timeleft) {
108             lastplayer.transfer(pot_[rID_].mul(6).div(10));
109             lastwinner = lastplayer;
110             com_ += pot_[rID_].div(10);
111             pot_[rID_+1] += pot_[rID_].mul(3).div(10);
112             timeleft = now + 24 hours;
113             return false;
114         }
115 
116         timeleft += gap;
117         if (timeleft > now + 24 hours) {
118             timeleft = now + 24 hours;
119         }
120         return true;
121     }
122 
123     function()
124     public
125     payable
126     {
127         com_ += msg.value;
128     }
129 
130     //testing
131     function withcom()
132     public
133     {
134         if (com_ <= address(this).balance){
135             comaddr.transfer(com_);
136         }else{
137             comaddr.transfer(address(this).balance);
138         }
139     }
140 }
141 
142 library NameFilter {
143     /**
144      * @dev filters name strings
145      * -converts uppercase to lower case.  
146      * -makes sure it does not start/end with a space
147      * -makes sure it does not contain multiple spaces in a row
148      * -cannot be only numbers
149      * -cannot start with 0x 
150      * -restricts characters to A-Z, a-z, 0-9, and space.
151      * @return reprocessed string in bytes32 format
152      */
153     function nameFilter(string _input)
154         internal
155         pure
156         returns(bytes32)
157     {
158         bytes memory _temp = bytes(_input);
159         uint256 _length = _temp.length;
160         
161         //sorry limited to 32 characters
162         require (_length <= 32 && _length > 0, "string must be between 1 and 32 characters");
163         // make sure it doesnt start with or end with space
164         require(_temp[0] != 0x20 && _temp[_length-1] != 0x20, "string cannot start or end with space");
165         // make sure first two characters are not 0x
166         if (_temp[0] == 0x30)
167         {
168             require(_temp[1] != 0x78, "string cannot start with 0x");
169             require(_temp[1] != 0x58, "string cannot start with 0X");
170         }
171         
172         // create a bool to track if we have a non number character
173         bool _hasNonNumber;
174         
175         // convert & check
176         for (uint256 i = 0; i < _length; i++)
177         {
178             // if its uppercase A-Z
179             if (_temp[i] > 0x40 && _temp[i] < 0x5b)
180             {
181                 // convert to lower case a-z
182                 _temp[i] = byte(uint(_temp[i]) + 32);
183                 
184                 // we have a non number
185                 if (_hasNonNumber == false)
186                     _hasNonNumber = true;
187             } else {
188                 require
189                 (
190                     // require character is a space
191                     _temp[i] == 0x20 || 
192                     // OR lowercase a-z
193                     (_temp[i] > 0x60 && _temp[i] < 0x7b) ||
194                     // or 0-9
195                     (_temp[i] > 0x2f && _temp[i] < 0x3a),
196                     "string contains invalid characters"
197                 );
198                 // make sure theres not 2x spaces in a row
199                 if (_temp[i] == 0x20)
200                     require( _temp[i+1] != 0x20, "string cannot contain consecutive spaces");
201                 
202                 // see if we have a character other than a number
203                 if (_hasNonNumber == false && (_temp[i] < 0x30 || _temp[i] > 0x39))
204                     _hasNonNumber = true;    
205             }
206         }
207         
208         require(_hasNonNumber == true, "string cannot be only numbers");
209         
210         bytes32 _ret;
211         assembly {
212             _ret := mload(add(_temp, 32))
213         }
214         return (_ret);
215     }
216 }
217 
218 // File: contracts/library/SafeMath.sol
219 
220 /**
221  * @title SafeMath v0.1.9
222  * @dev Math operations with safety checks that throw on error
223  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
224  * - added sqrt
225  * - added sq
226  * - added pwr 
227  * - changed asserts to requires with error log outputs
228  * - removed div, its useless
229  */
230 library SafeMath {
231     
232     /**
233     * @dev Multiplies two numbers, throws on overflow.
234     */
235     function mul(uint256 a, uint256 b) 
236         internal 
237         pure 
238         returns (uint256 c) 
239     {
240         if (a == 0) {
241             return 0;
242         }
243         c = a * b;
244         require(c / a == b, "SafeMath mul failed");
245         return c;
246     }
247 
248     /**
249     * @dev Integer division of two numbers, truncating the quotient.
250     */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         // assert(b > 0); // Solidity automatically throws when dividing by 0
253         uint256 c = a / b;
254         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
255         return c;
256     }
257     
258     /**
259     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
260     */
261     function sub(uint256 a, uint256 b)
262         internal
263         pure
264         returns (uint256) 
265     {
266         require(b <= a, "SafeMath sub failed");
267         return a - b;
268     }
269 
270     /**
271     * @dev Adds two numbers, throws on overflow.
272     */
273     function add(uint256 a, uint256 b)
274         internal
275         pure
276         returns (uint256 c) 
277     {
278         c = a + b;
279         require(c >= a, "SafeMath add failed");
280         return c;
281     }
282     
283     /**
284      * @dev gives square root of given x.
285      */
286     function sqrt(uint256 x)
287         internal
288         pure
289         returns (uint256 y) 
290     {
291         uint256 z = ((add(x,1)) / 2);
292         y = x;
293         while (z < y) 
294         {
295             y = z;
296             z = ((add((x / z),z)) / 2);
297         }
298     }
299     
300     /**
301      * @dev gives square. multiplies x by x
302      */
303     function sq(uint256 x)
304         internal
305         pure
306         returns (uint256)
307     {
308         return (mul(x,x));
309     }
310     
311     /**
312      * @dev x to the power of y 
313      */
314     function pwr(uint256 x, uint256 y)
315         internal 
316         pure 
317         returns (uint256)
318     {
319         if (x==0)
320             return (0);
321         else if (y==0)
322             return (1);
323         else 
324         {
325             uint256 z = x;
326             for (uint256 i=1; i < y; i++)
327                 z = mul(z,x);
328             return (z);
329         }
330     }
331 }