1 pragma solidity ^0.4.18;
2 
3 
4 contract ERC20Basic {
5   uint256 public totalSupply;
6   function balanceOf(address who) constant returns (uint256);
7   function transfer(address to, uint256 value) returns (bool);
8   event Transfer(address indexed from, address indexed to, uint256 value);
9 }
10 
11 
12 contract ERC20 is ERC20Basic {
13   function allowance(address owner, address spender) constant returns (uint256);
14   function transferFrom(address from, address to, uint256 value) returns (bool);
15   function approve(address spender, uint256 value) returns (bool);
16   event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 
20 library SafeMath {
21     
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); 
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); 
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45   
46 }
47 
48 contract Ownable {
49     
50   address public owner;
51 
52   
53   function Ownable() {
54     owner = msg.sender;
55   }
56   
57   modifier onlyOwner() {
58     require(msg.sender == owner);
59     _;
60   }
61 }
62 
63 contract Crowdsale is Ownable {
64     
65     using SafeMath for uint256;
66     
67     address public multisig;
68 
69    
70 
71    
72 
73    
74  ERC20 public token;
75     uint public startTime;
76     
77   
78     uint public endTime;
79 
80     uint256 public hardcap;
81 
82     uint public rate;
83     
84     uint public bonusPercent;
85     
86   
87     
88   
89   uint256 public tokensSold = 0;
90 
91  
92   uint256 public weiRaised = 0;
93   
94   
95   uint public investorCount = 0;
96     
97   mapping (address => uint256) public investedAmountOf;
98 
99  
100   mapping (address => uint256) public tokenAmountOf;
101  
102 
103   
104   struct Promo {
105         uint bonus;
106         uint EndTime;
107     }
108  
109  mapping (address => Promo) PromoList;
110  mapping (uint=>uint) amountBonus;
111  uint public level_1_amount=50 ether;
112  uint public level_2_amount=100 ether;
113  uint public level_3_amount=250 ether;
114  uint public level_4_amount=500 ether;
115  uint public level_5_amount=1000 ether;
116  uint public level_6_amount=100000 ether;
117  uint public level_7_amount=1000000 ether;
118  uint public level_8_amount=1000000 ether;
119  uint public level_9_amount=1000000 ether;
120  uint public level_1_percent=20;
121  uint public level_2_percent=25;
122  uint public level_3_percent=30;
123  uint public level_4_percent=35;
124  uint public level_5_percent=40;
125  uint public level_6_percent=40;
126  uint public level_7_percent=40;
127  uint public level_8_percent=40;
128  uint public level_9_percent=40;
129  bool public canExchange=true;
130     function Crowdsale() {
131         multisig =0x7c27f68b0d5afffb668da3e046adfba6ea1f6bc3;
132      
133        bonusPercent=130;
134         rate =5000;
135         startTime =1510704000;
136         endTime=1513382399;
137      
138         hardcap = 1000000000000000;
139         token=ERC20(0x292317a267adfb97d1b4e3ffd04f9da399cf973b);
140         
141     }
142 
143 
144 
145   
146     function setEndTime(uint _endTime) public onlyOwner{
147          require(_endTime>=now&&_endTime>=startTime);
148         endTime=_endTime;
149     }
150     
151      function setHardcap(uint256 _hardcap) public onlyOwner{
152        
153         hardcap=_hardcap;
154     }
155     
156    function setPromo(address _address,uint _amount,uint _endtime) public onlyOwner{
157        
158        PromoList[_address].bonus=_amount;
159         PromoList[_address].EndTime=_endtime;
160     }
161      function resetAmountBonuses() public onlyOwner
162      {
163  level_1_amount=0;
164  level_2_amount=0;
165  level_3_amount=0;
166  level_4_amount=0;
167  level_5_amount=0;
168  level_6_amount=0;
169  level_7_amount=0;
170  level_8_amount=0;
171  level_9_amount=0;
172  level_1_percent=0;
173  level_2_percent=0;
174  level_3_percent=0;
175  level_4_percent=0;
176  level_5_percent=0;
177  level_6_percent=0;
178  level_7_percent=0;
179  level_8_percent=0;
180  level_9_percent=0;
181     }
182      function setAmountBonuses(uint _level,uint _amount,uint _percent) public onlyOwner
183      {
184          if (_level==1) 
185          {
186            level_1_amount=(_amount).mul(1 ether);
187           level_1_percent=_percent;
188          }
189         else if (_level==2) 
190          {
191            level_2_amount=_amount.mul(1 ether);
192           level_2_percent=_percent;
193          }
194        else  if (_level==3) 
195          {
196            level_3_amount=_amount.mul(1 ether);
197           level_3_percent=_percent;
198          }
199       else   if (_level==4) 
200          {
201            level_4_amount=_amount.mul(1 ether);
202           level_4_percent=_percent;
203          }
204       else   if (_level==5) 
205          {
206            level_5_amount=_amount.mul(1 ether);
207           level_5_percent=_percent;
208          }
209      else    if (_level==6) 
210          {
211            level_6_amount=_amount.mul(1 ether);
212           level_6_percent=_percent;
213          }
214        else  if (_level==7) 
215          {
216            level_7_amount=_amount.mul(1 ether);
217           level_7_percent=_percent;
218          }
219       else   if (_level==8) 
220          {
221            level_8_amount=_amount.mul(1 ether);
222           level_8_percent=_percent;
223          }
224        else  if (_level==9) 
225          {
226            level_9_amount=_amount.mul(1 ether);
227           level_9_percent=_percent;
228          }
229      }
230  
231     
232 
233     
234     
235     
236     modifier saleIsOn(){
237          require(now > startTime && now <= endTime);
238          _;
239     }
240     
241     modifier isUnderHardCap() {
242    
243        require(tokensSold <= hardcap);
244         _;
245     }
246     
247     modifier isCanExchange(){
248        require(canExchange);
249        _;
250        }
251    
252    function calcToken()
253       
254         returns (uint256)
255     {
256          uint bonus;
257         uint256  tokens=0;
258          bonus=bonusPercent;
259        if (PromoList[msg.sender].EndTime >=now)
260         {
261            bonus += PromoList[msg.sender].bonus; 
262         }
263        
264         
265            
266             if (msg.value>=level_1_amount && msg.value<level_2_amount )
267             {
268             bonus+=level_1_percent;
269             }
270             else
271              if (msg.value>=level_2_amount && msg.value<level_3_amount )
272             {
273             bonus+=level_2_percent;
274             }
275              else
276              if (msg.value>=level_3_amount && msg.value<level_4_amount )
277             {
278             bonus+=level_3_percent;
279             }
280              else
281              if (msg.value>=level_4_amount && msg.value<level_5_amount )
282             {
283             bonus+=level_4_percent;
284             }
285              else
286              if (msg.value>=level_5_amount && msg.value<level_6_amount )
287             {
288             bonus+=level_5_percent;
289             }
290          else
291              if (msg.value>=level_6_amount && msg.value<level_7_amount )
292             {
293             bonus+=level_6_percent;
294             }
295             else
296              if (msg.value>=level_7_amount && msg.value<level_8_amount )
297             {
298             bonus+=level_7_percent;
299             }
300              else
301              if (msg.value>=level_8_amount && msg.value<level_9_amount )
302             {
303             bonus+=level_8_percent;
304             }
305        else
306              if (msg.value>=level_9_amount)
307             {
308             bonus+=level_9_percent;
309             }
310              uint256 multiplier = 10 **6;
311          tokens = multiplier.mul(msg.value).div(1 ether).mul(rate).div(100).mul(bonus);
312         
313         
314        
315         return tokens;
316     }
317        function exchange() public isCanExchange {
318      // address myAdrress=this;
319      ERC20  oldToken=ERC20(0x12a35383cA24ceb44cdcBBecbEb7baCcB5F3754A);
320     ERC20   newToken=ERC20(0x292317a267AdFb97d1b4E3Ffd04f9Da399cf973b);
321        
322 
323      uint  oldTokenAmount=oldToken.balanceOf(msg.sender);
324      //oldToken.approve(myAdrress,oldTokenAmount);
325       oldToken.transferFrom(msg.sender,0x0a6d9df476577C0D4A24EB50220fad007e444db8,oldTokenAmount);
326  newToken.transferFrom(0x0a6d9df476577C0D4A24EB50220fad007e444db8,msg.sender,oldTokenAmount*105/40);
327     
328        
329    }
330     function createTokens() payable saleIsOn isUnderHardCap {
331         
332       
333       
334       uint256 tokens=calcToken();
335         
336          
337         assert (tokens >= 10000);
338     
339         
340        
341        token.transferFrom(0x0a6d9df476577C0D4A24EB50220fad007e444db8,msg.sender, tokens);
342         if(investedAmountOf[msg.sender] == 0) {
343       
344        investorCount++;
345         }
346         investedAmountOf[msg.sender] = investedAmountOf[msg.sender].add(msg.value);
347         tokenAmountOf[msg.sender] = tokenAmountOf[msg.sender].add(tokens);
348         
349         weiRaised = weiRaised.add(msg.value);
350     tokensSold = tokensSold.add(tokens);  
351     
352      multisig.transfer(msg.value);
353     }
354 
355     function() external payable {
356         createTokens();
357     }
358     
359 }