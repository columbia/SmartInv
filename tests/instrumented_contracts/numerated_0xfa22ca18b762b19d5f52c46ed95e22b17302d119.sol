1 pragma solidity ^0.4.16;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 
9 contract Ownable {
10     
11     address[] public owners;
12     
13     mapping(address => bool) bOwner;
14     
15     /**
16     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17     * account.
18     */
19     function Ownable() public {
20         owners = [ 0x315C082246FFF04c9E790620867E6e0AD32f2FE3 ];
21                     
22         for (uint i=0; i< owners.length; i++){
23             bOwner[owners[i]]=true;
24         }
25     }
26     
27     /**
28     * @dev Throws if called by any account other than the owner.
29     */
30     modifier onlyOwner() {
31         
32         require(bOwner[msg.sender]);
33         _;
34     }
35     
36     /**
37     * @dev Allows the current owner to transfer control of the contract to a newOwner.
38     * @param newOwner The address to transfer ownership to.
39     */
40 
41 }
42 
43 
44 contract ClothingToken is Ownable {
45     
46 
47     uint256 public totalSupply;
48     uint256 public totalSupplyMarket;
49     uint256 public totalSupplyYear;
50     mapping(address => uint256) balances;
51     mapping(address => mapping(address => uint256)) allowed;
52     
53     string public constant name = "ClothingCoin";
54     string public constant symbol = "CC";
55     uint32 public constant decimals = 0;
56 
57     uint256 public constant hardcap = 300000000;
58     uint256 public constant marketCap= 150000000;
59     uint256 public yearCap=75000000 ;
60     
61     uint currentyear=2018;
62     
63     mapping (address => bool) public frozenAccount;
64 
65     /* This generates a public event on the blockchain that will notify clients */
66     event FrozenFunds(address target, bool frozen);
67     
68     struct DateTime {
69         uint16 year;
70         uint8 month;
71         uint8 day;
72         uint8 hour;
73         uint8 minute;
74         uint8 second;
75         uint8 weekday;
76     }
77 
78     uint constant DAY_IN_SECONDS = 86400;
79     uint constant YEAR_IN_SECONDS = 31536000;
80     uint constant LEAP_YEAR_IN_SECONDS = 31622400;
81 
82     uint constant HOUR_IN_SECONDS = 3600;
83     uint constant MINUTE_IN_SECONDS = 60;
84 
85     uint16 constant ORIGIN_YEAR = 1970;
86 
87     function isLeapYear(uint16 year) constant returns (bool) {
88         if (year % 4 != 0) {
89             return false;
90         }
91         if (year % 100 != 0) {
92             return true;
93         }
94         if (year % 400 != 0) {
95             return false;
96         }
97         return true;
98     }
99 
100 
101     function parseTimestamp(uint timestamp) internal returns (DateTime dt) {
102         uint secondsAccountedFor = 0;
103         uint buf;
104         uint8 i;
105 
106         dt.year = ORIGIN_YEAR;
107 
108         // Year
109         while (true) {
110             if (isLeapYear(dt.year)) {
111                     buf = LEAP_YEAR_IN_SECONDS;
112             }
113             else {
114                     buf = YEAR_IN_SECONDS;
115             }
116 
117             if (secondsAccountedFor + buf > timestamp) {
118                     break;
119             }
120             dt.year += 1;
121             secondsAccountedFor += buf;
122         }
123 
124         // Month
125         uint8[12] monthDayCounts;
126         monthDayCounts[0] = 31;
127         if (isLeapYear(dt.year)) {
128             monthDayCounts[1] = 29;
129         }
130         else {
131             monthDayCounts[1] = 28;
132         }
133         monthDayCounts[2] = 31;
134         monthDayCounts[3] = 30;
135         monthDayCounts[4] = 31;
136         monthDayCounts[5] = 30;
137         monthDayCounts[6] = 31;
138         monthDayCounts[7] = 31;
139         monthDayCounts[8] = 30;
140         monthDayCounts[9] = 31;
141         monthDayCounts[10] = 30;
142         monthDayCounts[11] = 31;
143 
144         uint secondsInMonth;
145         for (i = 0; i < monthDayCounts.length; i++) {
146             secondsInMonth = DAY_IN_SECONDS * monthDayCounts[i];
147             if (secondsInMonth + secondsAccountedFor > timestamp) {
148                     dt.month = i + 1;
149                     break;
150             }
151             secondsAccountedFor += secondsInMonth;
152         }
153 
154         // Day
155         for (i = 0; i < monthDayCounts[dt.month - 1]; i++) {
156             if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
157                     dt.day = i + 1;
158                     break;
159             }
160             secondsAccountedFor += DAY_IN_SECONDS;
161         }
162 
163         // Hour
164         for (i = 0; i < 24; i++) {
165             if (HOUR_IN_SECONDS + secondsAccountedFor > timestamp) {
166                     dt.hour = i;
167                     break;
168             }
169             secondsAccountedFor += HOUR_IN_SECONDS;
170         }
171 
172         // Minute
173         for (i = 0; i < 60; i++) {
174             if (MINUTE_IN_SECONDS + secondsAccountedFor > timestamp) {
175                     dt.minute = i;
176                     break;
177             }
178             secondsAccountedFor += MINUTE_IN_SECONDS;
179         }
180 
181         if (timestamp - secondsAccountedFor > 60) {
182             __throw();
183         }
184         
185         // Second
186         dt.second = uint8(timestamp - secondsAccountedFor);
187 
188         // Day of week.
189         buf = timestamp / DAY_IN_SECONDS;
190         dt.weekday = uint8((buf + 3) % 7);
191     }
192         
193     function __throw() {
194         uint[] arst;
195         arst[1];
196     }
197     
198     function getYear(uint timestamp) constant returns (uint16) {
199         return parseTimestamp(timestamp).year;
200     }
201     
202     modifier canYearMint() {
203         if(getYear(now) != currentyear){
204             currentyear=getYear(now);
205             yearCap=yearCap/2;
206             totalSupplyYear=0;
207         }
208         require(totalSupply <= marketCap);
209         require(totalSupplyYear <= yearCap);
210         _;
211         
212     }
213     
214     modifier canMarketMint(){
215         require(totalSupplyMarket <= marketCap);
216         _;
217     }
218 
219     function mintForMarket (address _to, uint256 _value) public onlyOwner canMarketMint returns (bool){
220         
221         if (_value + totalSupplyMarket <= marketCap) {
222         
223             totalSupplyMarket = totalSupplyMarket + _value;
224             
225             assert(totalSupplyMarket >= _value);
226              
227             balances[msg.sender] = balances[msg.sender] + _value;
228             assert(balances[msg.sender] >= _value);
229             Mint(msg.sender, _value);
230         
231             _transfer(_to, _value);
232             
233         }
234         return true;
235     }
236 
237     function _transfer( address _to, uint256 _value) internal {
238         require(_to != address(0));
239         require(_value <= balances[msg.sender]);
240         require(!frozenAccount[_to]);
241 
242         balances[msg.sender] = balances[msg.sender] - _value;
243         balances[_to] = balances[_to] + _value;
244 
245         Transfer(msg.sender, _to, _value);
246 
247     }
248     
249     function transfer(address _to, uint256 _value) public  returns (bool) {
250         require(_to != address(0));
251         require(_value <= balances[msg.sender]);
252         require(!frozenAccount[msg.sender]);
253         require(!frozenAccount[_to]);
254 
255         balances[msg.sender] = balances[msg.sender] - _value;
256         balances[_to] = balances[_to] + _value;
257 
258         Transfer(msg.sender, _to, _value);
259         return true;
260     }
261 
262     function balanceOf(address _owner) public constant returns (uint256 balance) {
263         return balances[_owner];
264     }
265     
266     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
267         require(_to != address(0));
268         require(_value <= balances[_from]);
269         require(_value <= allowed[_from][msg.sender]);
270         require(!frozenAccount[_from]);
271         require(!frozenAccount[_to]);
272         balances[_from] = balances[_from] - _value;
273         balances[_to] = balances[_to] + _value;
274         //assert(balances[_to] >= _value); no need to check, since mint has limited hardcap
275         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
276         Transfer(_from, _to, _value);
277         return true;
278     }
279 
280     function approve(address _spender, uint256 _value) public returns (bool) {
281     
282         allowed[msg.sender][_spender] = _value;
283         Approval(msg.sender, _spender, _value);
284         return true;
285     }
286 
287     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
288         return allowed[_owner][_spender];
289     }
290 
291     
292     function mintForYear(address _to, uint256 _value) public onlyOwner canYearMint returns (bool) {
293         require(_to != address(0));
294         
295         if (_value + totalSupplyYear <= yearCap) {
296             
297             totalSupply = totalSupply + _value;
298         
299             totalSupplyYear = totalSupplyYear + _value;
300             
301             assert(totalSupplyYear >= _value);
302              
303             balances[msg.sender] = balances[msg.sender] + _value;
304             assert(balances[msg.sender] >= _value);
305             Mint(msg.sender, _value);
306         
307             _transfer(_to, _value);
308             
309         }
310         return true;
311     }
312 
313 
314 
315     /**
316      * @dev Burns a specific amount of tokens.
317      * @param _value The amount of token to be burned.
318      */
319 
320     function burn(uint256 _value) public returns (bool) {
321         require(_value <= balances[msg.sender]);
322         // no need to require value <= totalSupply, since that would imply the
323         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
324         balances[msg.sender] = balances[msg.sender] - _value;
325         totalSupply = totalSupply - _value;
326         Burn(msg.sender, _value);
327         return true;
328     }
329     
330     function burnFrom(address _from, uint256 _value) public returns (bool success) {
331         require(_value <= balances[_from]);
332         require(_value <= allowed[_from][msg.sender]);   
333         balances[_from] = balances[_from] - _value;
334         allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
335         totalSupply = totalSupply - _value;
336         Burn(_from, _value);
337         return true;
338     }
339     
340     /// @notice `freeze? Prevent | Allow` `target` from sending & receiving tokens
341     /// @param target Address to be frozen
342     /// @param freeze either to freeze it or not
343     function freezeAccount(address target, bool freeze) public onlyOwner {
344         frozenAccount[target] = freeze;
345         FrozenFunds(target, freeze);
346     }
347  
348     event Transfer(address indexed from, address indexed to, uint256 value);
349 
350     event Approval(address indexed owner, address indexed spender, uint256 value);
351 
352     event Mint(address indexed to, uint256 amount);
353 
354     event Burn(address indexed burner, uint256 value);
355 
356 }