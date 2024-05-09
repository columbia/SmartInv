1 pragma solidity ^0.4.0;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     function Owned() public {
10         owner = msg.sender;
11     }
12 
13     modifier onlyOwner {
14         require(msg.sender == owner);
15         _;
16     }
17 
18     function transferOwnership(address _newOwner) public onlyOwner {
19         newOwner = _newOwner;
20     }
21     
22     function acceptOwnership() public {
23         require(msg.sender == newOwner);
24         emit OwnershipTransferred(owner, newOwner);
25         owner = newOwner;
26         newOwner = address(0);
27     }
28 }
29 
30 contract Greedy is Owned {
31     //A scam Game, 资金盘, 老鼠會, Ponzi scheme.
32     //The Game like Fomo3D, But more simple and more short time.
33     //Audit & be responsible for yourself.
34     //The code is really simple, so don't ask idiot question.
35     
36     //Round Global Info
37     uint public Round = 1;
38     mapping(uint => uint) public RoundHeart;
39     mapping(uint => uint) public RoundETH; // Pot
40     mapping(uint => uint) public RoundTime;
41     mapping(uint => uint) public RoundPayMask;
42     mapping(uint => address) public RoundLastGreedyMan;
43     
44     //Globalinfo
45     uint256 public Luckybuy;
46     
47     //Round Personal Info
48     mapping(uint => mapping(address => uint)) public RoundMyHeart;
49     mapping(uint => mapping(address => uint)) public RoundMyPayMask;
50     mapping(address => uint) public MyreferredRevenue;
51     
52     //Lucky Buy Tracker
53     uint256 public luckybuyTracker_ = 0;
54     
55     uint256 constant private RoundIncrease = 1 seconds; // every heart purchased adds this much to the timer
56     uint256 constant private RoundMaxTime = 10 minutes; // max length a round timer can be
57     
58     //Owner fee
59     uint256 public onwerfee;
60     
61     using SafeMath for *;
62     using GreedyHeartCalcLong for uint256;
63     
64     event winnerEvent(address winnerAddr, uint256 newPot, uint256 round);
65     event luckybuyEvent(address luckyAddr, uint256 amount, uint256 round);
66     event buyheartEvent(address Addr, uint256 Heartamount, uint256 ethvalue, uint256 round, address ref);
67     event referredEvent(address Addr, address RefAddr, uint256 ethvalue);
68     
69     event withdrawEvent(address Addr, uint256 ethvalue, uint256 Round);
70     event withdrawRefEvent(address Addr, uint256 ethvalue);
71     event withdrawOwnerEvent(uint256 ethvalue);
72 
73     //Get Heart Price
74     function getHeartPrice() public view returns(uint256)
75     {  
76         return ( (RoundHeart[Round].add(1000000000000000000)).ethRec(1000000000000000000) );
77     }
78     
79     //Get My Revenue
80     function getMyRevenue(uint _round) public view returns(uint256)
81     {
82         return(  (((RoundPayMask[_round]).mul(RoundMyHeart[_round][msg.sender])) / (1000000000000000000)).sub(RoundMyPayMask[_round][msg.sender])  );
83     }
84     
85     //Get Time Left
86     function getTimeLeft() public view returns(uint256)
87     {
88         if(RoundTime[Round] == 0 || RoundTime[Round] < now) 
89             return 0;
90         else 
91             return( (RoundTime[Round]).sub(now) );
92     }
93 
94     function updateTimer(uint256 _hearts) private
95     {
96         if(RoundTime[Round] == 0)
97             RoundTime[Round] = RoundMaxTime.add(now);
98         
99         uint _newTime = (((_hearts) / (1000000000000000000)).mul(RoundIncrease)).add(RoundTime[Round]);
100         
101         // compare to max and set new end time
102         if (_newTime < (RoundMaxTime).add(now))
103             RoundTime[Round] = _newTime;
104         else
105             RoundTime[Round] = RoundMaxTime.add(now);
106     }
107 
108     //Buy some greedy heart
109     function buyHeart(address referred) public payable {
110         
111         require(msg.value >= 1000000000, "pocket lint: not a valid currency");
112         require(msg.value <= 100000000000000000000000, "no vitalik, no");
113         
114         address _addr = msg.sender;
115         uint256 _codeLength;
116         assembly {_codeLength := extcodesize(_addr)}
117         require(_codeLength == 0, "sorry humans only");
118 
119         //bought at least 1 whole key
120         uint256 _hearts = (RoundETH[Round]).keysRec(msg.value);
121         uint256 _pearn;
122         require(_hearts >= 1000000000000000000);
123         
124         require(RoundTime[Round] > now || RoundTime[Round] == 0);
125         
126         updateTimer(_hearts);
127         
128         RoundHeart[Round] += _hearts;
129         RoundMyHeart[Round][msg.sender] += _hearts;
130 
131         if (referred != address(0) && referred != msg.sender)
132         {
133              _pearn = (((msg.value.mul(30) / 100).mul(1000000000000000000)) / (RoundHeart[Round])).mul(_hearts)/ (1000000000000000000);
134 
135             onwerfee += (msg.value.mul(4) / 100);
136             RoundETH[Round] += msg.value.mul(54) / 100;
137             Luckybuy += msg.value.mul(2) / 100;
138             MyreferredRevenue[referred] += (msg.value.mul(10) / 100);
139             
140             RoundPayMask[Round] += ((msg.value.mul(30) / 100).mul(1000000000000000000)) / (RoundHeart[Round]);
141             RoundMyPayMask[Round][msg.sender] = (((RoundPayMask[Round].mul(_hearts)) / (1000000000000000000)).sub(_pearn)).add(RoundMyPayMask[Round][msg.sender]);
142 
143             emit referredEvent(msg.sender, referred, msg.value.mul(10) / 100);
144         } else {
145              _pearn = (((msg.value.mul(40) / 100).mul(1000000000000000000)) / (RoundHeart[Round])).mul(_hearts)/ (1000000000000000000);
146 
147             RoundETH[Round] += msg.value.mul(54) / 100;
148             Luckybuy += msg.value.mul(2) / 100;
149             onwerfee +=(msg.value.mul(4) / 100);
150             
151             RoundPayMask[Round] += ((msg.value.mul(40) / 100).mul(1000000000000000000)) / (RoundHeart[Round]);
152             RoundMyPayMask[Round][msg.sender] = (((RoundPayMask[Round].mul(_hearts)) / (1000000000000000000)).sub(_pearn)).add(RoundMyPayMask[Round][msg.sender]);
153 
154         }
155         
156         // manage airdrops
157         if (msg.value >= 100000000000000000){
158             luckybuyTracker_++;
159             if (luckyBuy() == true)
160             {
161                 msg.sender.transfer(Luckybuy);
162                 emit luckybuyEvent(msg.sender, Luckybuy, Round);
163                 luckybuyTracker_ = 0;
164                 Luckybuy = 0;
165             }
166         }
167         
168         RoundLastGreedyMan[Round] = msg.sender;
169         emit buyheartEvent(msg.sender, _hearts, msg.value, Round, referred);
170     }
171     
172     function win() public {
173         require(now > RoundTime[Round] && RoundTime[Round] != 0);
174         //Round End 
175         RoundLastGreedyMan[Round].transfer(RoundETH[Round]);
176         emit winnerEvent(RoundLastGreedyMan[Round], RoundETH[Round], Round);
177         Round++;
178     }
179     
180     //withdrawEarnings
181     function withdraw(uint _round) public {
182         uint _revenue = getMyRevenue(_round);
183         uint _revenueRef = MyreferredRevenue[msg.sender];
184 
185         RoundMyPayMask[_round][msg.sender] += _revenue;
186         MyreferredRevenue[msg.sender] = 0;
187         
188         msg.sender.transfer(_revenue + _revenueRef); 
189         
190         emit withdrawRefEvent( msg.sender, _revenue);
191         emit withdrawEvent(msg.sender, _revenue, _round);
192     }
193     
194     function withdrawOwner()  public onlyOwner {
195         uint _revenue = onwerfee;
196         msg.sender.transfer(_revenue);    
197         onwerfee = 0;
198         emit withdrawOwnerEvent(_revenue);
199     }
200     
201     //LuckyBuy
202     function luckyBuy() private view returns(bool)
203     {
204         uint256 seed = uint256(keccak256(abi.encodePacked(
205             
206             (block.timestamp).add
207             (block.difficulty).add
208             ((uint256(keccak256(abi.encodePacked(block.coinbase)))) / (now)).add
209             (block.gaslimit).add
210             ((uint256(keccak256(abi.encodePacked(msg.sender)))) / (now)).add
211             (block.number)
212             
213         )));
214         
215         if((seed - ((seed / 1000) * 1000)) < luckybuyTracker_)
216             return(true);
217         else
218             return(false);
219     }
220     
221     function getFullround()public view returns(uint[] round,uint[] pot, address[] whowin,uint[] mymoney) {
222         uint[] memory whichRound = new uint[](Round);
223         uint[] memory totalPool = new uint[](Round);
224         address[] memory winner = new address[](Round);
225         uint[] memory myMoney = new uint[](Round);
226         uint counter = 0;
227 
228         for (uint i = 1; i <= Round; i++) {
229             whichRound[counter] = i;
230             totalPool[counter] = RoundETH[i];
231             winner[counter] = RoundLastGreedyMan[i];
232             myMoney[counter] = getMyRevenue(i);
233             counter++;
234         }
235    
236         return (whichRound,totalPool,winner,myMoney);
237     }
238 }
239 
240 library GreedyHeartCalcLong {
241     using SafeMath for *;
242     /**
243      * @dev calculates number of keys received given X eth 
244      * @param _curEth current amount of eth in contract 
245      * @param _newEth eth being spent
246      * @return amount of ticket purchased
247      */
248     function keysRec(uint256 _curEth, uint256 _newEth)
249         internal
250         pure
251         returns (uint256)
252     {
253         return(keys((_curEth).add(_newEth)).sub(keys(_curEth)));
254     }
255     
256     /**
257      * @dev calculates amount of eth received if you sold X keys 
258      * @param _curKeys current amount of keys that exist 
259      * @param _sellKeys amount of keys you wish to sell
260      * @return amount of eth received
261      */
262     function ethRec(uint256 _curKeys, uint256 _sellKeys)
263         internal
264         pure
265         returns (uint256)
266     {
267         return((eth(_curKeys)).sub(eth(_curKeys.sub(_sellKeys))));
268     }
269 
270     /**
271      * @dev calculates how many keys would exist with given an amount of eth
272      * @param _eth eth "in contract"
273      * @return number of keys that would exist
274      */
275     function keys(uint256 _eth) 
276         internal
277         pure
278         returns(uint256)
279     {
280         return ((((((_eth).mul(1000000000000000000)).mul(312500000000000000000000000)).add(5624988281256103515625000000000000000000000000000000000000000000)).sqrt()).sub(74999921875000000000000000000000)) / (156250000);
281     }
282     
283     /**
284      * @dev calculates how much eth would be in contract given a number of keys
285      * @param _keys number of keys "in contract" 
286      * @return eth that would exists
287      */
288     function eth(uint256 _keys) 
289         internal
290         pure
291         returns(uint256)  
292     {
293         return ((78125000).mul(_keys.sq()).add(((149999843750000).mul(_keys.mul(1000000000000000000))) / (2))) / ((1000000000000000000).sq());
294     }
295 }
296 
297 /**
298  * @title SafeMath v0.1.9
299  * @dev Math operations with safety checks that throw on error
300  * change notes:  original SafeMath library from OpenZeppelin modified by Inventor
301  * - added sqrt
302  * - added sq
303  * - added pwr 
304  * - changed asserts to requires with error log outputs
305  * - removed div, its useless
306  */
307 library SafeMath {
308     
309     /**
310     * @dev Multiplies two numbers, throws on overflow.
311     */
312     function mul(uint256 a, uint256 b) 
313         internal 
314         pure 
315         returns (uint256 c) 
316     {
317         if (a == 0) {
318             return 0;
319         }
320         c = a * b;
321         require(c / a == b, "SafeMath mul failed");
322         return c;
323     }
324 
325     /**
326     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
327     */
328     function sub(uint256 a, uint256 b)
329         internal
330         pure
331         returns (uint256) 
332     {
333         require(b <= a, "SafeMath sub failed");
334         return a - b;
335     }
336 
337     /**
338     * @dev Adds two numbers, throws on overflow.
339     */
340     function add(uint256 a, uint256 b)
341         internal
342         pure
343         returns (uint256 c) 
344     {
345         c = a + b;
346         require(c >= a, "SafeMath add failed");
347         return c;
348     }
349     
350     /**
351      * @dev gives square root of given x.
352      */
353     function sqrt(uint256 x)
354         internal
355         pure
356         returns (uint256 y) 
357     {
358         uint256 z = ((add(x,1)) / 2);
359         y = x;
360         while (z < y) 
361         {
362             y = z;
363             z = ((add((x / z),z)) / 2);
364         }
365     }
366     
367     /**
368      * @dev gives square. multiplies x by x
369      */
370     function sq(uint256 x)
371         internal
372         pure
373         returns (uint256)
374     {
375         return (mul(x,x));
376     }
377     
378     /**
379      * @dev x to the power of y 
380      */
381     function pwr(uint256 x, uint256 y)
382         internal 
383         pure 
384         returns (uint256)
385     {
386         if (x==0)
387             return (0);
388         else if (y==0)
389             return (1);
390         else 
391         {
392             uint256 z = x;
393             for (uint256 i=1; i < y; i++)
394                 z = mul(z,x);
395             return (z);
396         }
397     }
398     
399 }