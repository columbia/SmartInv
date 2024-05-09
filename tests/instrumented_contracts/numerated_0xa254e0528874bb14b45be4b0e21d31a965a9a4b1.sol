1 pragma solidity 0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     if (a == 0) {
10       return 0;
11     }
12     uint256 c = a * b;
13     assert(c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     uint256 c = a / b;
20     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
21     return c;
22   }
23 
24   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
25     assert(b <= a);
26     return a - b;
27   }
28 
29   function add(uint256 a, uint256 b) internal pure returns (uint256) {
30     uint256 c = a + b;
31     assert(c >= a);
32     return c;
33   }
34 }
35 
36 contract ERC20 {
37   function totalSupply()public view returns (uint total_Supply);
38   function balanceOf(address who)public view returns (uint256);
39   function allowance(address owner, address spender)public view returns (uint);
40   function transferFrom(address from, address to, uint value)public returns (bool ok);
41   function approve(address spender, uint value)public returns (bool ok);
42   function transfer(address to, uint value)public returns (bool ok);
43   event Transfer(address indexed from, address indexed to, uint value);
44   event Approval(address indexed owner, address indexed spender, uint value);
45 }
46 
47 
48 contract SATCoin is ERC20
49 { using SafeMath for uint256;
50     // Name of the token
51     string public constant name = "SATCoin";
52 
53     // Symbol of token
54     string public constant symbol = "SAT";
55     uint8 public constant decimals = 8;
56     uint public _totalsupply = 1000000000 * 10 ** 8; // 1 billion SAT Coins
57     address public owner;
58     uint256 public _price_tokn = 7000 ; // 1 Ether = 7000 coins
59     uint256 no_of_tokens;
60     uint256 bonus_token;
61     uint256 total_token;
62     bool stopped = false;
63     uint256 public startdate;
64     uint256 ico_first;
65     uint256 ico_second;
66     uint256 ico_third;
67     uint256 ico_fourth;
68     address central_account;
69     mapping(address => uint) balances;
70     mapping(address => mapping(address => uint)) allowed;
71 
72     
73      enum Stages {
74         NOTSTARTED,
75         ICO,
76         PAUSED,
77         ENDED
78     }
79     Stages public stage;
80     
81     modifier atStage(Stages _stage) {
82         if (stage != _stage)
83             // Contract not in expected state
84             revert();
85         _;
86     }
87     
88      modifier onlyOwner() {
89         if (msg.sender != owner) {
90             revert();
91         }
92         _;
93     }
94     modifier onlycentralAccount {
95         require(msg.sender == central_account);
96         _;
97     }
98 
99     function SATCoin() public
100     {
101         owner = msg.sender;
102         balances[owner] = 350000000 * 10 **8;
103         balances[address(this)] = 650000000 *10**8;
104         stage = Stages.NOTSTARTED;
105         Transfer(0, owner, balances[owner]);
106         Transfer(0, owner, balances[address(this)]);
107     }
108   
109     function () public payable atStage(Stages.ICO)
110     {
111         require(!stopped && msg.sender != owner);
112         require (now <= ico_fourth);
113             if( now < ico_first )
114             { 
115                 no_of_tokens =((msg.value).mul(_price_tokn)).div(10 **10);
116                
117                 if(no_of_tokens >= (5000 * 10**8) && no_of_tokens <= 15000 * 10 **8)
118                 {
119                     bonus_token = ((no_of_tokens).mul(50)).div(100);  //50% bonus
120                     total_token = no_of_tokens + bonus_token;
121                     transferTokens(msg.sender,total_token);
122                 }
123                 else if(no_of_tokens > (15000 * 10**8) && no_of_tokens <= 50000 * 10 **8)
124                 {
125                     bonus_token = ((no_of_tokens).mul(55)).div(100);  //55% bonus
126                     total_token = no_of_tokens + bonus_token;
127                     transferTokens(msg.sender,total_token);
128                 }
129                else if (no_of_tokens > (50000 * 10**8)){
130                    
131                   bonus_token = ((no_of_tokens).mul(60)).div(100); //60% bonus
132                     total_token = no_of_tokens + bonus_token;
133                     transferTokens(msg.sender,total_token);
134                }
135                 
136                 else{
137                     bonus_token = ((no_of_tokens).mul(45)).div(100); // 45% bonus
138                     total_token = no_of_tokens + bonus_token;
139                     transferTokens(msg.sender,total_token);
140                }
141                
142             }
143             else if(now >= ico_first && now < ico_second)
144             {
145              
146                 no_of_tokens =((msg.value).mul(_price_tokn)).div(10 **10);
147                if(no_of_tokens >= (5000 * 10**8) && no_of_tokens <= 15000 * 10 **8)
148                 {
149                     bonus_token = ((no_of_tokens).mul(40)).div(100);  //40% bonus
150                     total_token = no_of_tokens + bonus_token;
151                     transferTokens(msg.sender,total_token);
152                 }
153                 else if(no_of_tokens > (15000 * 10**8) && no_of_tokens <= 50000 * 10 **8)
154                 {
155                     bonus_token = ((no_of_tokens).mul(45)).div(100);  //45% bonus
156                     total_token = no_of_tokens + bonus_token;
157                     transferTokens(msg.sender,total_token);
158                 }
159                else if (no_of_tokens > (50000 * 10**8)){
160                    
161                   bonus_token = ((no_of_tokens).mul(50)).div(100); //50% bonus
162                     total_token = no_of_tokens + bonus_token;
163                     transferTokens(msg.sender,total_token);
164                }
165                 
166                 else{
167                     bonus_token = ((no_of_tokens).mul(35)).div(100); // 35% bonus
168                     total_token = no_of_tokens + bonus_token;
169                     transferTokens(msg.sender,total_token);
170                }
171                
172             }
173             else if(now >= ico_second && now < ico_third)
174             {
175                 no_of_tokens =((msg.value).mul(_price_tokn)).div(10 **10);
176                 if(no_of_tokens >= (5000 * 10**8) && no_of_tokens <= 15000 * 10 **8)
177                 {
178                     bonus_token = ((no_of_tokens).mul(30)).div(100);  //30% bonus
179                     total_token = no_of_tokens + bonus_token;
180                     transferTokens(msg.sender,total_token);
181                 }
182                 else if(no_of_tokens > (15000 * 10**8) && no_of_tokens <= 50000 * 10 **8)
183                 {
184                     bonus_token = ((no_of_tokens).mul(35)).div(100);  //35% bonus
185                     total_token = no_of_tokens + bonus_token;
186                     transferTokens(msg.sender,total_token);
187                 }
188                else if (no_of_tokens > (50000 * 10**8)){
189                    
190                   bonus_token = ((no_of_tokens).mul(40)).div(100); //40% bonus
191                     total_token = no_of_tokens + bonus_token;
192                     transferTokens(msg.sender,total_token);
193                }
194                 
195                 else{
196                     bonus_token = ((no_of_tokens).mul(25)).div(100); // 25% bonus
197                     total_token = no_of_tokens + bonus_token;
198                     transferTokens(msg.sender,total_token);
199                }
200                
201             }
202         
203         else if(now >= ico_third && now < ico_fourth)
204             {
205                 no_of_tokens =((msg.value).mul(_price_tokn)).div(10 **10);
206                 if(no_of_tokens >= (5000 * 10**8) && no_of_tokens <= 15000 * 10 **8)
207                 {
208                     bonus_token = ((no_of_tokens).mul(20)).div(100);  //20% bonus
209                     total_token = no_of_tokens + bonus_token;
210                     transferTokens(msg.sender,total_token);
211                 }
212                 else if(no_of_tokens > (15000 * 10**8) && no_of_tokens <= 50000 * 10 **8)
213                 {
214                     bonus_token = ((no_of_tokens).mul(25)).div(100);  //25% bonus
215                     total_token = no_of_tokens + bonus_token;
216                     transferTokens(msg.sender,total_token);
217                 }
218                else if (no_of_tokens > (50000 * 10**8)){
219                    
220                   bonus_token = ((no_of_tokens).mul(30)).div(100); //30% bonus
221                     total_token = no_of_tokens + bonus_token;
222                     transferTokens(msg.sender,total_token);
223                }
224                 
225                 else{
226                     bonus_token = ((no_of_tokens).mul(15)).div(100); // 15% bonus
227                     total_token = no_of_tokens + bonus_token;
228                     transferTokens(msg.sender,total_token);
229                }
230                
231             }
232         else{
233             revert();
234         }
235     }
236      function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED)
237       {
238           stage = Stages.ICO;
239           stopped = false;
240           startdate = now;
241           ico_first = now + 14 days;
242           ico_second = ico_first + 14 days;
243           ico_third = ico_second + 14 days;
244           ico_fourth = ico_third + 14 days;
245       }
246     
247     // called by the owner, pause ICO
248     function StopICO() external onlyOwner atStage(Stages.ICO) {
249         stopped = true;
250         stage = Stages.PAUSED;
251     }
252 
253     // called by the owner , resumes ICO
254     function releaseICO() external onlyOwner atStage(Stages.PAUSED)
255     {
256         stopped = false;
257         stage = Stages.ICO;
258     }
259     
260      function end_ICO() external onlyOwner atStage(Stages.ICO)
261      {
262          require(now > ico_fourth);
263          stage = Stages.ENDED;
264          _totalsupply = (_totalsupply).sub(balances[address(this)]);
265          balances[address(this)] = 0;
266          Transfer(address(this), 0 , balances[address(this)]);
267          
268      }
269      
270      function set_centralAccount(address central_Acccount) external onlyOwner
271     {
272         central_account = central_Acccount;
273     }
274 
275 
276 
277     // what is the total supply of the ech tokens
278      function totalSupply() public view returns (uint256 total_Supply) {
279          total_Supply = _totalsupply;
280      }
281     
282     // What is the balance of a particular account?
283      function balanceOf(address _owner)public view returns (uint256 balance) {
284          return balances[_owner];
285      }
286     
287     // Send _value amount of tokens from address _from to address _to
288      // The transferFrom method is used for a withdraw workflow, allowing contracts to send
289      // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
290      // fees in sub-currencies; the command should fail unless the _from account has
291      // deliberately authorized the sender of the message via some mechanism; we propose
292      // these standardized APIs for approval:
293      function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
294      require( _to != 0x0);
295      require(balances[_from] >= _amount && allowed[_from][msg.sender] >= _amount && _amount >= 0);
296      balances[_from] = (balances[_from]).sub(_amount);
297      allowed[_from][msg.sender] = (allowed[_from][msg.sender]).sub(_amount);
298      balances[_to] = (balances[_to]).add(_amount);
299      Transfer(_from, _to, _amount);
300      return true;
301          }
302     
303    // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
304      // If this function is called again it overwrites the current allowance with _value.
305      function approve(address _spender, uint256 _amount)public returns (bool success) {
306          require( _spender != 0x0);
307          allowed[msg.sender][_spender] = _amount;
308          Approval(msg.sender, _spender, _amount);
309          return true;
310      }
311   
312      function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
313          require( _owner != 0x0 && _spender !=0x0);
314          return allowed[_owner][_spender];
315    }
316 
317      // Transfer the balance from owner's account to another account
318      function transfer(address _to, uint256 _amount)public returns (bool success) {
319         require( _to != 0x0);
320         require(balances[msg.sender] >= _amount && _amount >= 0);
321         balances[msg.sender] = (balances[msg.sender]).sub(_amount);
322         balances[_to] = (balances[_to]).add(_amount);
323         Transfer(msg.sender, _to, _amount);
324              return true;
325          }
326     
327           // Transfer the balance from owner's account to another account
328     function transferTokens(address _to, uint256 _amount) private returns(bool success) {
329         require( _to != 0x0);       
330         require(balances[address(this)] >= _amount && _amount > 0);
331         balances[address(this)] = (balances[address(this)]).sub(_amount);
332         balances[_to] = (balances[_to]).add(_amount);
333         Transfer(address(this), _to, _amount);
334         return true;
335         }
336     
337     function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
338         require( _to != 0x0); 
339         require (balances[_from] >= _amount && _amount > 0);
340         balances[_from] = (balances[_from]).sub(_amount);
341         balances[_to] = (balances[_to]).add(_amount);
342         Transfer(_from, _to, _amount);
343         return true;
344     }
345     	//In case the ownership needs to be transferred
346 	function transferOwnership(address newOwner)public onlyOwner
347 	{
348 	    balances[newOwner] = (balances[newOwner]).add(balances[owner]);
349 	    balances[owner] = 0;
350 	    owner = newOwner;
351 	}
352 
353     
354     function drain() external onlyOwner {
355         owner.transfer(this.balance);
356     }
357     
358 }