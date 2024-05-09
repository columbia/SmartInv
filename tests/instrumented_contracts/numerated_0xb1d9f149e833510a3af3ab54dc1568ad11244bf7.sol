1 pragma solidity ^ 0.4 .8;
2 
3 
4 contract ERC20 {
5 
6     function totalSupply() constant returns(uint total_Supply);
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
33       string public symbol = "BOP";
34     
35       //To store decimal places for token
36       uint8 public decimals = 8;    
37     
38       //To store current supply of BOP
39       uint public _totalSupply=20000000 * 10**decimals;
40       
41        uint pre_ico_start;
42        uint pre_ico_end;
43        uint ico_start;
44        uint ico_end;
45        mapping(uint => address) investor;
46        mapping(uint => uint) weireceived;
47        mapping(uint => uint) optsSent;
48       
49         event preico(uint counter,address investors,uint weiReceived,uint bopsent);
50         event ico(uint counter,address investors,uint weiReceived,uint bopsent);
51         uint counter=0;
52         uint profit_sent=0;
53         bool stopped = false;
54         
55       function blockoptions() payable{
56           owner = msg.sender;
57           balances[owner] = _totalSupply ; //to handle 8 decimal places
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
72        modifier onlyOwner() {
73         if (msg.sender != owner) 
74         {
75             revert();
76         }
77         _;
78     }
79     
80       //ownership can be transferred to provided newOwner. Function can only be initiated by contract owner's account
81       function transferOwnership(address newOwner) onlyOwner {
82           balances[newOwner] = balances[owner];
83           balances[owner]=0;
84           owner = newOwner;
85       }
86 
87         /**
88         * Multiplication with safety check
89         */
90         function Mul(uint a, uint b) internal returns (uint) {
91           uint c = a * b;
92           //check result should not be other wise until a=0
93           assert(a == 0 || c / a == b);
94           return c;
95         }
96     
97         /**
98         * Division with safety check
99         */
100         function Div(uint a, uint b) internal returns (uint) {
101           //overflow check; b must not be 0
102           assert(b > 0);
103           uint c = a / b;
104           assert(a == b * c + a % b);
105           return c;
106         }
107     
108         /**
109         * Subtraction with safety check
110         */
111         function Sub(uint a, uint b) internal returns (uint) {
112           //b must be greater that a as we need to store value in unsigned integer
113           assert(b <= a);
114           return a - b;
115         }
116     
117         /**
118         * Addition with safety check
119         */
120         function Add(uint a, uint b) internal returns (uint) {
121           uint c = a + b;
122           //result must be greater as a or b can not be negative
123           assert(c>=a && c>=b);
124           return c;
125         }
126     
127       /**
128         * assert used in different Math functions
129         */
130         function assert(bool assertion) internal {
131           if (!assertion) {
132             throw;
133           }
134         }
135     
136     //Implementation for transferring BOP to provided address 
137       function transfer(address _to, uint _value) returns (bool){
138 
139         uint check = balances[owner] - _value;
140         if(msg.sender == owner && now>=pre_ico_start && now<=pre_ico_end && check < 1900000000000000)
141         {
142             return false;
143         }
144         else if(msg.sender ==owner && now>=pre_ico_end && now<=(pre_ico_end + 16 days) && check < 1850000000000000)
145         {
146             return false;
147         }
148         else if(msg.sender == owner && check < 130000000000000 && now < ico_start + 180 days)
149         {
150             return false;
151         }
152         else if (msg.sender == owner && check < 97500000000000 && now < ico_start + 360 days)
153         {
154             return false;
155         }
156         else if (msg.sender == owner && check < 43000000000000 && now < ico_start + 540 days)
157         {
158             return false;
159         }
160         //Check provided BOP should not be 0
161        else if (_value > 0) {
162           //deduct BOP amount from transaction initiator
163           balances[msg.sender] = Sub(balances[msg.sender],_value);
164           //Add BOP to balace of target account
165           balances[_to] = Add(balances[_to],_value);
166           //Emit event for transferring BOP
167           Transfer(msg.sender, _to, _value);
168           return true;
169         }
170         else{
171           return false;
172         }
173       }
174       
175       //Transfer initiated by spender 
176       function transferFrom(address _from, address _to, uint _value) returns (bool) {
177     
178         //Check provided BOP should not be 0
179         if (_value > 0) {
180           //Get amount of BOP for which spender is authorized
181           var _allowance = allowed[_from][msg.sender];
182           //Add amount of BOP in target account's balance
183           balances[_to] = Add(balances[_to], _value);
184           //Deduct BOPT amount from _from account
185           balances[_from] = Sub(balances[_from], _value);
186           //Deduct Authorized amount for spender
187           allowed[_from][msg.sender] = Sub(_allowance, _value);
188           //Emit event for Transfer
189           Transfer(_from, _to, _value);
190           return true;
191         }else{
192           return false;
193         }
194       }
195       
196       //Get BOP balance for provided address
197       function balanceOf(address _owner) constant returns (uint balance) {
198         return balances[_owner];
199       }
200       
201       //Add spender to authorize for spending specified amount of BOP 
202       function approve(address _spender, uint _value) returns (bool) {
203         allowed[msg.sender][_spender] = _value;
204         //Emit event for approval provided to spender
205         Approval(msg.sender, _spender, _value);
206         return true;
207       }
208       
209       //Get BOP amount that spender can spend from provided owner's account 
210       function allowance(address _owner, address _spender) constant returns (uint remaining) {
211         return allowed[_owner][_spender];
212       }
213       
214        /*	
215        * Failsafe drain
216        */
217     	function drain() onlyOwner {
218     		owner.send(this.balance);
219     	}
220 	
221     	function() payable 
222     	{   
223     	    if(stopped && msg.sender != owner)
224     	    revert();
225     	     else if(msg.sender == owner)
226     	    {
227     	        profit_sent = msg.value;
228     	    }
229     	   else if(now>=pre_ico_start && now<=pre_ico_end)
230     	    {
231     	        uint check = balances[owner]-((400*msg.value)/10000000000);
232     	        if(check >= 1900000000000000)
233                 pre_ico(msg.sender,msg.value);
234     	    }
235             else if (now>=ico_start && now<ico_end)
236             {
237                 main_ico(msg.sender,msg.value);
238             }
239             
240         }
241        
242        function pre_ico(address sender, uint value)private
243        {
244           counter = counter+1;
245 	      investor[counter]=sender;
246           weireceived[counter]=value;
247           optsSent[counter] = (400*value)/10000000000;
248           balances[owner]=balances[owner]-optsSent[counter];
249           balances[investor[counter]]+=optsSent[counter];
250           preico(counter,investor[counter],weireceived[counter],optsSent[counter]);
251        }
252        
253        function  main_ico(address sender, uint value)private
254        {
255            if(now >= ico_start && now <= (ico_start + 7 days)) //20% discount on BOPT
256            {
257               counter = counter+1;
258     	      investor[counter]=sender;
259               weireceived[counter]=value;
260               optsSent[counter] = (250*value)/10000000000;
261               balances[owner]=balances[owner]-optsSent[counter];
262               balances[investor[counter]]+=optsSent[counter];
263               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
264            }
265            else if (now >= (ico_start + 7 days) && now <= (ico_start + 14 days)) //10% discount on BOPT
266            {
267               counter = counter+1;
268     	      investor[counter]=sender;
269               weireceived[counter]=value;
270               optsSent[counter] = (220*value)/10000000000;
271               balances[owner]=balances[owner]-optsSent[counter];
272               balances[investor[counter]]+=optsSent[counter];
273               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
274            }
275            else if (now >= (ico_start + 14 days) && now <= (ico_start + 31 days)) //no discount on BOPT
276            {
277               counter = counter+1;
278     	      investor[counter]=sender;
279               weireceived[counter]=value;
280               optsSent[counter] = (200*value)/10000000000;
281               balances[owner]=balances[owner]-optsSent[counter];
282               balances[investor[counter]]+=optsSent[counter];
283               ico(counter,investor[counter],weireceived[counter],optsSent[counter]);
284            }
285        }
286        
287        function startICO()onlyOwner
288        {
289            ico_start = now;
290            ico_end=ico_start + 31 days;
291            pre_ico_start = 0;
292            pre_ico_end = 0;
293            
294        }
295        
296         function totalSupply() constant returns(uint256 totalSupply) 
297         {
298         totalSupply = _totalSupply;
299         }
300       
301         function endICO()onlyOwner
302        {
303           stopped=true;
304           if(balances[owner] > 130000000000000)
305           {
306               uint burnedTokens = balances[owner]-130000000000000;
307            _totalSupply = _totalSupply-burnedTokens;
308            balances[owner] = 130000000000000;
309           }
310        }
311 }