1 pragma solidity ^ 0.4 .8;
2 
3 
4 contract ERC20 {
5 
6     uint public totalSupply;
7 
8     function balanceOf(address who) constant returns(uint256);
9 
10     function allowance(address owner, address spender) constant returns(uint);
11 
12     function transferFrom(address from, address to, uint value) returns(bool ok);
13 
14     function approve(address spender, uint value) returns(bool ok);
15 
16     function transfer(address to, uint value) returns(bool ok);
17 
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     event Approval(address indexed owner, address indexed spender, uint value);
21 
22 }
23 
24 contract blockoptions is ERC20
25 
26 {
27 
28        /* Public variables of the token */
29       //To store name for token
30       string public name = "blockoptions";
31     
32       //To store symbol for token       
33       string public symbol = "BOPT";
34     
35       //To store decimal places for token
36       uint8 public decimals = 8;    
37     
38       //To store current supply of BOPT
39       uint public totalSupply=20000000 * 100000000;
40       
41        uint pre_ico_start;
42        uint pre_ico_end;
43        uint ico_start;
44        uint ico_end;
45        mapping(uint => address) investor;
46        mapping(uint => uint) weireceived;
47        mapping(uint => uint) optsSent;
48       
49         event preico(uint counter,address investors,uint weiReceived,uint boptsent);
50         event ico(uint counter,address investors,uint weiReceived,uint boptsent);
51         uint counter=0;
52         uint profit_sent=0;
53         bool stopped = false;
54         
55       function blockoptions() payable{
56           owner = msg.sender;
57           balances[owner] = totalSupply ; //to handle 8 decimal places
58           pre_ico_start = now;
59           pre_ico_end = pre_ico_start + 7 days;
60           
61         }
62       //map to store BOPT balance corresponding to address
63       mapping(address => uint) balances;
64     
65       //To store spender with allowed amount of BOPT to spend corresponding to BOPTs holder's account
66       mapping (address => mapping (address => uint)) allowed;
67     
68       //owner variable to store contract owner account
69       address public owner;
70       
71       //modifier to check transaction initiator is only owner
72       modifier onlyOwner() {
73         if (msg.sender == owner)
74           _;
75       }
76     
77       //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
78       function transferOwnership(address newOwner) onlyOwner {
79           balances[newOwner] = balances[owner];
80           balances[owner]=0;
81           owner = newOwner;
82       }
83 
84         /**
85         * Multiplication with safety check
86         */
87         function Mul(uint a, uint b) internal returns (uint) {
88           uint c = a * b;
89           //check result should not be other wise until a=0
90           assert(a == 0 || c / a == b);
91           return c;
92         }
93     
94         /**
95         * Division with safety check
96         */
97         function Div(uint a, uint b) internal returns (uint) {
98           //overflow check; b must not be 0
99           assert(b > 0);
100           uint c = a / b;
101           assert(a == b * c + a % b);
102           return c;
103         }
104     
105         /**
106         * Subtraction with safety check
107         */
108         function Sub(uint a, uint b) internal returns (uint) {
109           //b must be greater that a as we need to store value in unsigned integer
110           assert(b <= a);
111           return a - b;
112         }
113     
114         /**
115         * Addition with safety check
116         */
117         function Add(uint a, uint b) internal returns (uint) {
118           uint c = a + b;
119           //result must be greater as a or b can not be negative
120           assert(c>=a && c>=b);
121           return c;
122         }
123     
124       /**
125         * assert used in different Math functions
126         */
127         function assert(bool assertion) internal {
128           if (!assertion) {
129             throw;
130           }
131         }
132     
133     //Implementation for transferring BOPT to provided address 
134       function transfer(address _to, uint _value) returns (bool){
135 
136         uint check = balances[owner] - _value;
137         if(msg.sender == owner && now>=pre_ico_start && now<=pre_ico_end && check < 1900000000000000)
138         {
139             return false;
140         }
141         else if(msg.sender ==owner && now>=pre_ico_end && now<=(pre_ico_end + 16 days) && check < 1850000000000000)
142         {
143             return false;
144         }
145         else if(msg.sender == owner && check < 150000000000000 && now < ico_start + 180 days)
146         {
147             return false;
148         }
149         else if (msg.sender == owner && check < 100000000000000 && now < ico_start + 360 days)
150         {
151             return false;
152         }
153         else if (msg.sender == owner && check < 50000000000000 && now < ico_start + 540 days)
154         {
155             return false;
156         }
157         //Check provided BOPT should not be 0
158        else if (_value > 0) {
159           //deduct OPTS amount from transaction initiator
160           balances[msg.sender] = Sub(balances[msg.sender],_value);
161           //Add OPTS to balace of target account
162           balances[_to] = Add(balances[_to],_value);
163           //Emit event for transferring BOPT
164           Transfer(msg.sender, _to, _value);
165           return true;
166         }
167         else{
168           return false;
169         }
170       }
171       
172       //Transfer initiated by spender 
173       function transferFrom(address _from, address _to, uint _value) returns (bool) {
174     
175         //Check provided BOPT should not be 0
176         if (_value > 0) {
177           //Get amount of BOPT for which spender is authorized
178           var _allowance = allowed[_from][msg.sender];
179           //Add amount of BOPT in trarget account's balance
180           balances[_to] = Add(balances[_to], _value);
181           //Deduct BOPT amount from _from account
182           balances[_from] = Sub(balances[_from], _value);
183           //Deduct Authorized amount for spender
184           allowed[_from][msg.sender] = Sub(_allowance, _value);
185           //Emit event for Transfer
186           Transfer(_from, _to, _value);
187           return true;
188         }else{
189           return false;
190         }
191       }
192       
193       //Get BOPT balance for provided address
194       function balanceOf(address _owner) constant returns (uint balance) {
195         return balances[_owner];
196       }
197       
198       //Add spender to authorize for spending specified amount of BOPT 
199       function approve(address _spender, uint _value) returns (bool) {
200         allowed[msg.sender][_spender] = _value;
201         //Emit event for approval provided to spender
202         Approval(msg.sender, _spender, _value);
203         return true;
204       }
205       
206       //Get BOPT amount that spender can spend from provided owner's account 
207       function allowance(address _owner, address _spender) constant returns (uint remaining) {
208         return allowed[_owner][_spender];
209       }
210       
211        /*	
212        * Failsafe drain
213        */
214     	function drain() onlyOwner {
215     		owner.send(this.balance);
216     	}
217 	
218     	function() payable 
219     	{   
220     	    if(stopped && msg.sender != owner)
221     	    revert();
222     	     else if(msg.sender == owner)
223     	    {
224     	        profit_sent = msg.value;
225     	    }
226     	   else if(now>=pre_ico_start && now<=pre_ico_end)
227     	    {
228     	        uint check = balances[owner]-((400*msg.value)/10000000000);
229     	        if(check >= 1900000000000000)
230                 pre_ico(msg.sender,msg.value);
231     	    }
232             else if (now>=ico_start && now<ico_end)
233             {
234                 main_ico(msg.sender,msg.value);
235             }
236             
237         }
238        
239        function pre_ico(address sender, uint value)payable
240        {
241           counter = counter+1;
242 	      investor[counter]=sender;
243           weireceived[counter]=value;
244           optsSent[counter] = (400*value)/10000000000;
245           balances[owner]=balances[owner]-optsSent[counter];
246           balances[investor[counter]]+=optsSent[counter];
247           preico(counter,investor[counter],weireceived[counter],optsSent[counter]);
248        }
249        
250        function  main_ico(address sender, uint value)payable
251        {
252            if(now >= ico_start && now <= (ico_start + 7 days)) //20% discount on BOPT
253            {
254               counter = counter+1;
255     	      investor[counter]=sender;
256               weireceived[counter]=value;
257               optsSent[counter] = (250*value)/10000000000;
258               balances[owner]=balances[owner]-optsSent[counter];
259               balances[investor[counter]]+=optsSent[counter];
260               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
261            }
262            else if (now >= (ico_start + 7 days) && now <= (ico_start + 14 days)) //10% discount on BOPT
263            {
264               counter = counter+1;
265     	      investor[counter]=sender;
266               weireceived[counter]=value;
267               optsSent[counter] = (220*value)/10000000000;
268               balances[owner]=balances[owner]-optsSent[counter];
269               balances[investor[counter]]+=optsSent[counter];
270               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
271            }
272            else if (now >= (ico_start + 14 days) && now <= (ico_start + 31 days)) //no discount on BOPT
273            {
274               counter = counter+1;
275     	      investor[counter]=sender;
276               weireceived[counter]=value;
277               optsSent[counter] = (200*value)/10000000000;
278               balances[owner]=balances[owner]-optsSent[counter];
279               balances[investor[counter]]+=optsSent[counter];
280               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
281            }
282        }
283        
284        function startICO()onlyOwner
285        {
286            ico_start = now;
287            ico_end=ico_start + 31 days;
288            pre_ico_start = 0;
289            pre_ico_end = 0;
290            
291        }
292        
293       
294         function endICO()onlyOwner
295        {
296           stopped=true;
297           if(balances[owner] > 150000000000000)
298           {
299               uint burnedTokens = balances[owner]-150000000000000;
300            totalSupply = totalSupply-burnedTokens;
301            balances[owner] = 150000000000000;
302           }
303        }
304 
305         struct distributionStruct
306         {
307             uint divident;
308             bool dividentStatus;
309         }   
310         mapping(address => distributionStruct) dividentsMap;
311         mapping(uint => address)requestor;
312    
313          event dividentSent(uint requestNumber,address to,uint divi);
314          uint requestCount=0;
315           
316           function distribute()onlyOwner
317           {
318               for(uint i=1; i <= counter;i++)
319               {
320                 dividentsMap[investor[i]].divident = (balanceOf(investor[i])*profit_sent)/(totalSupply*100000000);
321                 dividentsMap[investor[i]].dividentStatus = true;
322               }
323           }
324            
325           function requestDivident()payable
326           {
327               requestCount = requestCount + 1;
328               requestor[requestCount] = msg.sender;
329                   if(dividentsMap[requestor[requestCount]].dividentStatus == true)
330                   {   
331                       dividentSent(requestCount,requestor[requestCount],dividentsMap[requestor[requestCount]].divident);
332                       requestor[requestCount].send(dividentsMap[requestor[requestCount]].divident);
333                       dividentsMap[requestor[requestCount]].dividentStatus = false;
334                   }
335                
336           }
337 
338 }