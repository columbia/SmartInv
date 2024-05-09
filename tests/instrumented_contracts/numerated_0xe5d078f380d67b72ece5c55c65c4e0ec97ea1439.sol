1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 library DateTime {
31         /*
32          *  Date and Time utilities for ethereum contracts
33          *
34          */
35         struct MyDateTime {
36                 uint16 year;
37                 uint8 month;
38                 uint8 day;
39                 uint8 hour;
40                 uint8 minute;
41                 uint8 second;
42                 uint8 weekday;
43         }
44         uint constant DAY_IN_SECONDS = 86400;
45         uint constant YEAR_IN_SECONDS = 31536000;
46         uint constant LEAP_YEAR_IN_SECONDS = 31622400;
47         uint constant HOUR_IN_SECONDS = 3600;
48         uint constant MINUTE_IN_SECONDS = 60;
49         uint16 constant ORIGIN_YEAR = 1970;
50         function isLeapYear(uint16 year) public pure returns (bool) {
51                 if (year % 4 != 0) {
52                         return false;
53                 }
54                 if (year % 100 != 0) {
55                         return true;
56                 }
57                 if (year % 400 != 0) {
58                         return false;
59                 }
60                 return true;
61         }
62         function leapYearsBefore(uint year) public pure returns (uint) {
63                 year -= 1;
64                 return year / 4 - year / 100 + year / 400;
65         }
66         function getDaysInMonth(uint8 month, uint16 year) public pure returns (uint8) {
67                 if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
68                         return 31;
69                 }
70                 else if (month == 4 || month == 6 || month == 9 || month == 11) {
71                         return 30;
72                 }
73                 else if (isLeapYear(year)) {
74                         return 29;
75                 }
76                 else {
77                         return 28;
78                 }
79         }
80         function parseTimestamp(uint timestamp) internal pure returns (MyDateTime memory dt) {
81                 uint secondsAccountedFor = 0;
82                 uint buf;
83                 uint8 i;
84                 // Year
85                 dt.year = getYear(timestamp);
86                 buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
87                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
88                 secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
89                 // Month
90                 uint secondsInMonth;
91                 for (i = 1; i <= 12; i++) {
92                         secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
93                         if (secondsInMonth + secondsAccountedFor > timestamp) {
94                                 dt.month = i;
95                                 break;
96                         }
97                         secondsAccountedFor += secondsInMonth;
98                 }
99                 // Day
100                 for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
101                         if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
102                                 dt.day = i;
103                                 break;
104                         }
105                         secondsAccountedFor += DAY_IN_SECONDS;
106                 }
107                 // Hour
108                 dt.hour = 0;//getHour(timestamp);
109                 // Minute
110                 dt.minute = 0;//getMinute(timestamp);
111                 // Second
112                 dt.second = 0;//getSecond(timestamp);
113                 // Day of week.
114                 dt.weekday = 0;//getWeekday(timestamp);
115         }
116         function getYear(uint timestamp) public pure returns (uint16) {
117                 uint secondsAccountedFor = 0;
118                 uint16 year;
119                 uint numLeapYears;
120                 // Year
121                 year = uint16(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
122                 numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
123                 secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
124                 secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
125                 while (secondsAccountedFor > timestamp) {
126                         if (isLeapYear(uint16(year - 1))) {
127                                 secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
128                         }
129                         else {
130                                 secondsAccountedFor -= YEAR_IN_SECONDS;
131                         }
132                         year -= 1;
133                 }
134                 return year;
135         }
136         function getMonth(uint timestamp) public pure returns (uint8) {
137                 return parseTimestamp(timestamp).month;
138         }
139         function getDay(uint timestamp) public pure returns (uint8) {
140                 return parseTimestamp(timestamp).day;
141         }
142         function getHour(uint timestamp) public pure returns (uint8) {
143                 return uint8((timestamp / 60 / 60) % 24);
144         }
145         function getMinute(uint timestamp) public pure returns (uint8) {
146                 return uint8((timestamp / 60) % 60);
147         }
148         function getSecond(uint timestamp) public pure returns (uint8) {
149                 return uint8(timestamp % 60);
150         }
151         function toTimestamp(uint16 year, uint8 month, uint8 day) public pure returns (uint timestamp) {
152                 return toTimestamp(year, month, day, 0, 0, 0);
153         }
154 
155         function toDay(uint256 timestamp) internal pure returns (uint256) {
156                 MyDateTime memory d = parseTimestamp(timestamp);
157                 return uint256(d.year) * 10000 + uint256(d.month) * 100 + uint256(d.day);
158         }
159         function toTimestamp(uint16 year, uint8 month, uint8 day, uint8 hour, uint8 minute, uint8 second) public pure returns (uint timestamp) {
160                 uint16 i;
161                 // Year
162                 for (i = ORIGIN_YEAR; i < year; i++) {
163                         if (isLeapYear(i)) {
164                                 timestamp += LEAP_YEAR_IN_SECONDS;
165                         }
166                         else {
167                                 timestamp += YEAR_IN_SECONDS;
168                         }
169                 }
170                 // Month
171                 uint8[12] memory monthDayCounts;
172                 monthDayCounts[0] = 31;
173                 if (isLeapYear(year)) {
174                         monthDayCounts[1] = 29;
175                 }
176                 else {
177                         monthDayCounts[1] = 28;
178                 }
179                 monthDayCounts[2] = 31;
180                 monthDayCounts[3] = 30;
181                 monthDayCounts[4] = 31;
182                 monthDayCounts[5] = 30;
183                 monthDayCounts[6] = 31;
184                 monthDayCounts[7] = 31;
185                 monthDayCounts[8] = 30;
186                 monthDayCounts[9] = 31;
187                 monthDayCounts[10] = 30;
188                 monthDayCounts[11] = 31;
189                 for (i = 1; i < month; i++) {
190                         timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
191                 }
192                 // Day
193                 timestamp += DAY_IN_SECONDS * (day - 1);
194                 // Hour
195                 timestamp += HOUR_IN_SECONDS * (hour);
196                 // Minute
197                 timestamp += MINUTE_IN_SECONDS * (minute);
198                 // Second
199                 timestamp += second;
200                 return timestamp;
201         }
202 }
203 
204 contract Controlled{
205     address public owner;
206     address public operator;
207     mapping (address => bool) public blackList;
208 
209     constructor() public {
210         owner = msg.sender;
211         operator = msg.sender;
212     }
213 
214     modifier onlyOwner {
215         require(msg.sender == owner);
216         _;
217     }
218 
219     modifier onlyOperator() {
220         require(msg.sender == operator || msg.sender == owner);
221         _;
222     }
223 
224     modifier isNotBlack(address _addr) {
225         require(blackList[_addr] == false);
226         _;
227     }
228 
229     function transferOwnership(address _newOwner) public onlyOwner {
230         require(_newOwner != address(0));
231         owner = _newOwner;
232     }
233 
234     function transferOperator(address _newOperator) public onlyOwner {
235         require(_newOperator != address(0));
236         operator = _newOperator;
237     }
238 
239     function addBlackList(address _blackAddr) public onlyOperator {
240         blackList[_blackAddr] = true;
241     }
242     
243     function removeBlackList(address _blackAddr) public onlyOperator {
244         delete blackList[_blackAddr];
245     }
246     
247 }
248 
249 contract TokenERC20 is Controlled{
250     using SafeMath for uint;
251     // Public variables of the token
252     string public name;
253     string public symbol;
254     uint8 public decimals;
255     uint256 public totalSupply;
256 
257     // This creates an array with all balances
258     mapping (address => uint256) public balanceOf;
259     mapping (address => mapping (address => uint256)) public allowance;
260 
261     // This generates a public event on the blockchain that will notify clients
262     event Transfer(address indexed _from, address indexed _to, uint256 _value);
263     
264     // This generates a public event on the blockchain that will notify clients
265     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
266     
267     // This generates a public event on the blockchain that will notify clients
268     event Burn(address indexed burner, uint256 value);
269     
270     /**
271      * Internal transfer, only can be called by this contract
272      */
273     function _transfer(address _from, address _to, uint _value) internal {
274         // Prevent transfer to 0x0 address. Use burn() instead
275         require(_to != address(0x0));
276         // Check if the sender has enough
277         require(balanceOf[_from] >= _value);
278         // Check for overflows
279         require(balanceOf[_to] + _value >= balanceOf[_to]);
280         // Save this for an assertion in the future
281         uint previousBalances = balanceOf[_from] + balanceOf[_to];
282         // Subtract from the sender
283         balanceOf[_from] = balanceOf[_from].sub(_value);
284         // Add the same to the recipient
285         balanceOf[_to] = balanceOf[_to].add(_value);
286         emit Transfer(_from, _to, _value);
287         // Asserts are used to use static analysis to find bugs in your code. They should never fail
288         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
289     }
290 
291     /**
292      * Transfer tokens
293      *
294      * Send `_value` tokens to `_to` from your account
295      *
296      * @param _to The address of the recipient
297      * @param _value the amount to send
298      */
299     function transfer(address _to, uint256 _value) public isNotBlack(msg.sender) returns (bool success) {
300         _transfer(msg.sender, _to, _value);
301         return true;
302     }
303 
304     /**
305      * Transfer tokens from other address
306      *
307      * Send `_value` tokens to `_to` on behalf of `_from`
308      *
309      * @param _from The address of the sender
310      * @param _to The address of the recipient
311      * @param _value the amount to send
312      */
313     function transferFrom(address _from, address _to, uint256 _value) public isNotBlack(msg.sender) returns (bool success) {
314         require(_value <= allowance[_from][msg.sender]);     // Check allowance
315         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
316         _transfer(_from, _to, _value);
317         return true;
318     }
319 
320     /**
321      * Set allowance for other address
322      *
323      * Allows `_spender` to spend no more than `_value` tokens on your behalf
324      *
325      * @param _spender The address authorized to spend
326      * @param _value the max amount they can spend
327      */
328     function approve(address _spender, uint256 _value) public isNotBlack(msg.sender) returns (bool success) {
329         require(_value <= balanceOf[msg.sender]);     // Check balance
330         allowance[msg.sender][_spender] = _value;
331         emit Approval(msg.sender, _spender, _value);
332         return true;
333     }
334 
335      /**
336      * @dev Burns a specific amount of tokens.
337      * @param _value The amount of token to be burned.
338      */
339     function burn(uint256 _value) public returns (bool) {
340         require(_value > 0);
341         require(_value <= balanceOf[msg.sender]);
342         // no need to require value <= totalSupply, since that would imply the
343         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
344         address burner = msg.sender;
345         balanceOf[burner] = balanceOf[burner].sub(_value);
346         totalSupply = totalSupply.sub(_value);
347         emit Burn(burner, _value);
348         return true;
349     }
350 }
351 
352 contract FrozenableToken is TokenERC20{
353     using SafeMath for uint;
354     using DateTime for uint256;
355 
356     uint256 public totalFrozen;
357 
358     struct UnfreezeRecord {
359         address to;
360         uint256 amount; // release amount
361         uint256 unfreezeTime;
362     }
363     mapping (uint256 => UnfreezeRecord) public unfreezeRecords;
364 
365     event Unfreeze(address indexed receiver, uint256 value, uint256 unfreezeTime);
366 
367     function unfreeze(address _receiver, uint256 _value) public onlyOwner returns (bool) {
368         require(_value > 0);
369         require(_value <= totalFrozen);
370         balanceOf[owner] = balanceOf[owner].add(_value);
371         totalFrozen = totalFrozen.sub(_value);
372         totalSupply = totalSupply.add(_value);
373         uint256 timestamp = block.timestamp;
374         uint256 releasedDay = timestamp.toDay();
375         _transfer(owner,_receiver,_value);
376         unfreezeRecords[releasedDay] = UnfreezeRecord(_receiver, _value, timestamp);
377         emit Unfreeze(_receiver, _value, timestamp);
378         return true;
379     }
380 }
381 
382 contract CasinoTkoen is FrozenableToken{
383     /**
384      * Constructor function
385      *
386      * Initializes contract with initial supply tokens to the creator of the contract
387      */
388     constructor() public {
389         name = 'CasinoToken';                        // Set the name for display purposes
390         symbol = 'CT';                               // Set the symbol for display purposes
391         decimals = 18;
392         totalFrozen = 100000000 * 10 ** uint256(decimals);
393         totalSupply = 0;
394         balanceOf[msg.sender] = 0;
395     }
396 }