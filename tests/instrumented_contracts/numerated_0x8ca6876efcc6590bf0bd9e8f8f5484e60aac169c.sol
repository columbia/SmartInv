1 pragma solidity ^0.4.24;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public constant returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title SafeMath
12  * @dev Math operations with safety checks that revert on error
13  */
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, reverts on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
21     // benefit is lost if 'b' is also tested.
22     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
23     if (a == 0) {
24       return 0;
25     }
26 
27     uint256 c = a * b;
28     require(c / a == b);
29 
30     return c;
31   }
32 
33   /**
34   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
35   */
36   function div(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b > 0); // Solidity only automatically asserts when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40 
41     return c;
42   }
43 
44   /**
45   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     require(b <= a);
49     uint256 c = a - b;
50 
51     return c;
52   }
53 
54   /**
55   * @dev Adds two numbers, reverts on overflow.
56   */
57   function add(uint256 a, uint256 b) internal pure returns (uint256) {
58     uint256 c = a + b;
59     require(c >= a);
60 
61     return c;
62   }
63 
64   /**
65   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
66   * reverts when dividing by zero.
67   */
68   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69     require(b != 0);
70     return a % b;
71   }
72 }
73 
74 contract SEcoinAbstract {function unlock() public;}
75 
76 contract SECrowdsale {
77         
78         using SafeMath for uint256;
79         
80         // The token being sold
81         address constant public SEcoin = 0xe45b7cd82ac0f3f6cfc9ecd165b79d6f87ed2875;//"SEcoin address"
82         
83         // start and end timestamps where investments are allowed (both inclusive)
84         uint256 public startTime;
85         uint256 public endTime;
86           
87         // address where funds are collected
88         address public SEcoinWallet = 0x5C737AdC09a0cFA1C9b83E199971a677163ddd07;//"SEcoin all token inside & ICO ether";
89         address public SEcoinsetWallet = 0x52873e9191f21a26ddc8b65e5dddbac6b73b69e8;//"control SEcoin SmartContract address"
90           
91         // how many token units a buyer gets per wei
92         uint256 public rate = 6000;//"ICO start rate"
93         
94         // amount of raised money in wei
95         uint256 public weiRaised;
96         uint256 public weiSold;
97           
98         //storage address and amount
99         address public SEcoinbuyer;
100         address[] public SEcoinbuyerevent;
101         uint256[] public SEcoinAmountsevent;
102         uint256[] public SEcoinmonth;
103         uint public firstbuy;
104         uint SEcoinAmounts ;
105         uint SEcoinAmountssend;
106 
107           
108         mapping(address => uint) public icobuyer;
109         mapping(address => uint) public icobuyer2;
110           
111         event TokenPurchase(address indexed purchaser, address indexed SEcoinbuyer, uint256 value, uint256 amount,uint SEcoinAmountssend);
112         
113      // fallback function can be used to buy tokens
114     function () external payable {buyTokens(msg.sender);}
115       
116     //check buyer
117     function buyer(address SEcoinbuyer) internal{
118           
119         if(icobuyer[msg.sender]==0){
120             icobuyer[msg.sender] = firstbuy;
121             icobuyer2[msg.sender] = firstbuy;
122             firstbuy++;
123             //event buyer 
124             SEcoinbuyerevent.push(SEcoinbuyer);
125             SEcoinAmountsevent.push(SEcoinAmounts);
126             SEcoinmonth.push(0);
127     
128         }else if(icobuyer[msg.sender]!=0){
129             uint i = icobuyer2[msg.sender];
130             SEcoinAmountsevent[i]=SEcoinAmountsevent[i]+SEcoinAmounts;
131             icobuyer2[msg.sender]=icobuyer[msg.sender];}
132         }
133     
134       // low level token purchase function
135     function buyTokens(address SEcoinbuyer) public payable {
136         require(SEcoinbuyer != address(0x0));
137         require(selltime());
138         require(msg.value>=1*1e16 && msg.value<=200*1e18);
139         
140         // calculate token amount to be created
141         SEcoinAmounts = calculateObtainedSEcoin(msg.value);
142         SEcoinAmountssend= calculateObtainedSEcoinsend(SEcoinAmounts);
143         
144         // update state
145         weiRaised = weiRaised.add(msg.value);
146         weiSold = weiSold.add(SEcoinAmounts);
147             
148         //sendtoken
149         require(ERC20Basic(SEcoin).transfer(SEcoinbuyer, SEcoinAmountssend));
150             
151         //call function
152         buyer(msg.sender);
153         checkRate();
154         forwardFunds();
155             
156         //write event 
157         emit TokenPurchase(msg.sender, SEcoinbuyer, msg.value, SEcoinAmounts,SEcoinAmountssend);
158     }
159     
160     // send ether to the fund collection wallet
161     // override to create custom fund forwarding mechanisms
162     function forwardFunds() internal {
163         SEcoinWallet.transfer(msg.value);
164     }
165     //calculate Amount
166     function calculateObtainedSEcoin(uint256 amountEtherInWei) public view returns (uint256) {
167         checkRate();
168         return amountEtherInWei.mul(rate);
169     }
170     function calculateObtainedSEcoinsend (uint SEcoinAmounts)public view returns (uint){
171         return SEcoinAmounts.div(10);
172     }
173     
174     // return true if the transaction can buy tokens
175     function selltime() internal view returns (bool) {
176         bool withinPeriod = now >= startTime && now <= endTime;
177         return withinPeriod;
178     }
179     
180     // return true if crowdsale event has ended
181     function hasEnded() public view returns (bool) {
182         bool isEnd = now > endTime || weiRaised >= 299600000*1e18;//ico max token
183         return isEnd;
184     }
185     
186     //releaseSEcoin only admin 
187     function releaseSEcoin() public returns (bool) {
188         require (msg.sender == SEcoinsetWallet);
189         require (hasEnded() && startTime != 0);
190         SEcoinAbstract(SEcoin).unlock();
191     }
192     
193     //getunselltoken only admin
194     function getunselltoken()public returns(bool){
195         require (msg.sender == SEcoinsetWallet);
196         require (hasEnded() && startTime != 0);
197         uint256 remainedSEcoin = ERC20Basic(SEcoin).balanceOf(this)-weiSold;
198         ERC20Basic(SEcoin).transfer(SEcoinWallet, remainedSEcoin);    
199     }
200     
201     //backup
202     function getunselltokenB()public returns(bool){
203         require (msg.sender == SEcoinsetWallet);
204         require (hasEnded() && startTime != 0);
205         uint256 remainedSEcoin = ERC20Basic(SEcoin).balanceOf(this);
206         ERC20Basic(SEcoin).transfer(SEcoinWallet, remainedSEcoin);    
207     }
208     
209     // be sure to get the token ownerships
210     function start() public returns (bool) {
211         require (msg.sender == SEcoinsetWallet);
212         require (firstbuy==0);
213         startTime = 1541001600;//startTime
214         endTime = 1543593599;//endTime
215         SEcoinbuyerevent.push(SEcoinbuyer);
216         SEcoinAmountsevent.push(SEcoinAmounts);
217         SEcoinmonth.push(0);
218         firstbuy=1;
219     }
220     
221     //Change setting Wallet
222     function changeSEcoinWallet(address _SEcoinsetWallet) public returns (bool) {
223         require (msg.sender == SEcoinsetWallet);
224         SEcoinsetWallet = _SEcoinsetWallet;
225     }
226       
227     //ckeckRate
228     function checkRate() public returns (bool) {
229         if (now>=startTime && now< 1541433599){
230             rate = 6000;//section one
231         }else if (now >= 1541433599 && now < 1542297599) {
232             rate = 5000;//section two
233         }else if (now >= 1542297599 && now < 1543161599) {
234             rate = 4000;//section three
235         }else if (now >= 1543161599)  {
236             rate = 3500;//section four
237         }
238     }
239       
240     //get ICOtoken in everyMonth
241     function getICOtoken(uint number)public returns(string){
242         require(SEcoinbuyerevent[number] == msg.sender);
243         require(now>=1543593600&&now<=1567267199);
244         uint  _month;
245         
246         //December 2018 two
247         if(now>=1543593600 && now<=1546271999 && SEcoinmonth[number]==0){
248             require(SEcoinmonth[number]==0);
249             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
250             SEcoinmonth[number]=1;
251         }
252         
253         //February January 2019 three
254         else if(now>=1546272000 && now<=1548950399 && SEcoinmonth[number]<=1){
255             if(SEcoinmonth[number]==1){
256             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
257             SEcoinmonth[number]=2;
258             }else if(SEcoinmonth[number]<1){
259             _month = 2-SEcoinmonth[number];
260             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
261             SEcoinmonth[number]=2;}
262         }
263         
264         //February 2019 four
265         else if(now>=1548950400 && now<=1551369599 && SEcoinmonth[number]<=2){
266             if(SEcoinmonth[number]==2){
267             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
268             SEcoinmonth[number]=3;
269             }else if(SEcoinmonth[number]<2){
270             _month = 3-SEcoinmonth[number];
271             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
272             SEcoinmonth[number]=3;}
273         }
274         
275         //March 2019 five
276         else if(now>=1551369600 && now<=1554047999 && SEcoinmonth[number]<=3){
277             if(SEcoinmonth[number]==3){
278             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
279             SEcoinmonth[number]=4;
280             }else if(SEcoinmonth[number]<3){
281             _month = 4-SEcoinmonth[number];
282             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
283             SEcoinmonth[number]=4;}
284         }
285         
286         //April 2019 six
287         else if(now>=1554048000 && now<=1556639999 && SEcoinmonth[number]<=4){
288             if(SEcoinmonth[number]==4){
289             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
290             SEcoinmonth[number]=5;
291             }else if(SEcoinmonth[number]<4){
292             _month = 5-SEcoinmonth[number];
293             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
294            SEcoinmonth[number]=5;}
295         }
296         
297         //May 2019 seven
298         else if(now>=1556640000 && now<=1559318399 && SEcoinmonth[number]<=5){
299             if(SEcoinmonth[number]==5){
300             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
301             SEcoinmonth[number]=6;
302             }else if(SEcoinmonth[number]<5){
303             _month = 6-SEcoinmonth[number];
304             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
305             SEcoinmonth[number]=6;}
306         }
307         
308         //June 2019 eight
309         else if(now>=1559318400 && now<=1561910399 && SEcoinmonth[number]<=6){
310             if(SEcoinmonth[number]==6){
311             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
312             SEcoinmonth[number]=7;
313             }else if(SEcoinmonth[number]<6){
314             _month = 7-SEcoinmonth[number];
315             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
316             SEcoinmonth[number]=7;}
317         }
318         
319         //July 2019 nine August
320         else if(now>=1561910400 && now<=1564588799 && SEcoinmonth[number]<=7){
321             if(SEcoinmonth[number]==7){
322             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
323             SEcoinmonth[number]=8;
324             }else if(SEcoinmonth[number]<7){
325             _month = 8-SEcoinmonth[number];
326             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
327             SEcoinmonth[number]=8;}
328         }
329             
330         //August 2019 ten
331         else if(now>=1564588800 && now<=1567267199 && SEcoinmonth[number]<=8){
332             if(SEcoinmonth[number]==8){
333             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], SEcoinAmountsevent[number].div(10));
334             SEcoinmonth[number]=9;
335             }else if(SEcoinmonth[number]<8){
336             _month = 9-SEcoinmonth[number];
337             ERC20Basic(SEcoin).transfer(SEcoinbuyerevent[number], (SEcoinAmountsevent[number].div(10))*_month); 
338             SEcoinmonth[number]=9;}
339         }    
340         
341         //get all token
342         else if(now<1543593600 || now>1567267199 || SEcoinmonth[number]>=9){
343             revert("Get all tokens or endtime");
344         }
345     }
346 }