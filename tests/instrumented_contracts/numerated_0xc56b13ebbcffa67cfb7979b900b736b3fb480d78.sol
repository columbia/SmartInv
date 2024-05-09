1 /*
2 Social Activity Token (SAT) - Official Smart Contract
3 Sphere Social LTD
4 https://sphere.social
5 */
6 pragma solidity 0.4.19;
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             return 0;
17         }
18         uint256 c = a * b;
19         assert(c / a == b);
20         return c;
21     }
22 
23     function div(uint256 a, uint256 b) internal pure returns (uint256) {
24         // assert(b > 0); // Solidity automatically throws when dividing by 0
25         uint256 c = a / b;
26         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27         return c;
28     }
29 
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b <= a);
32         return a - b;
33     }
34 
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         assert(c >= a);
38         return c;
39     }
40 }
41 
42 contract ERC20 {
43 
44     function totalSupply()public view returns (uint total_Supply);
45     function balanceOf(address who)public view returns (uint256);
46     function allowance(address owner, address spender)public view returns (uint);
47     function transferFrom(address from, address to, uint value)public returns (bool ok);
48     function approve(address spender, uint value)public returns (bool ok);
49     function transfer(address to, uint value)public returns (bool ok);
50 
51     event Transfer(address indexed from, address indexed to, uint value);
52     event Approval(address indexed owner, address indexed spender, uint value);
53 
54 }
55 
56 contract FiatContract
57 {
58     function USD(uint _id) constant returns (uint256);
59 }
60 
61 
62 contract SocialActivityToken is ERC20
63 { 
64     using SafeMath for uint256;
65 
66     FiatContract price = FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
67 
68     // Name of the token
69     string public constant name = "Social Activity Token";
70     // Symbol of token
71     string public constant symbol = "SAT";
72     uint8 public constant decimals = 8;
73     uint public _totalsupply = 1000000000 * (uint256(10) ** decimals); // 1 billion SAT
74     address public owner;
75     bool stopped = false;
76     uint256 public startdate;
77     uint256 ico_first;
78     uint256 ico_second;
79     uint256 ico_third;
80     uint256 ico_fourth;
81     address central_account;
82     mapping(address => uint) balances;
83     mapping(address => mapping(address => uint)) allowed;
84 
85     
86     enum Stages {
87         NOTSTARTED,
88         ICO,
89         PAUSED,
90         ENDED
91     }
92 
93     Stages public stage;
94     
95     modifier atStage(Stages _stage) {
96         if (stage != _stage)
97             // Contract not in expected state
98             revert();
99         _;
100     }
101     
102     modifier onlyOwner() {
103         if (msg.sender != owner) {
104             revert();
105         }
106         _;
107     }
108 
109     modifier onlycentralAccount {
110         require(msg.sender == central_account);
111         _;
112     }
113 
114     function SocialActivityToken() public
115     {
116         owner = msg.sender;
117         balances[owner] = 350000000 * (uint256(10) ** decimals);
118         balances[address(this)] = 650000000 * (uint256(10) ** decimals);
119         stage = Stages.NOTSTARTED;
120         Transfer(0, owner, balances[owner]);
121         Transfer(0, address(this), balances[address(this)]);
122     }
123     
124     function () public payable atStage(Stages.ICO)
125     {
126         require(msg.value >= 1 finney); //for round up and security measures
127         require(!stopped && msg.sender != owner);
128 
129         uint256 ethCent = price.USD(0); //one USD cent in wei
130         uint256 tokPrice = ethCent.mul(14); //1Sat = 14 USD cent
131         
132         tokPrice = tokPrice.div(10 ** 8); //limit to 10 places
133         uint256 no_of_tokens = msg.value.div(tokPrice);
134         
135         uint256 bonus_token = 0;
136         
137         // Determine the bonus based on the time and the purchased amount
138         if (now < ico_first)
139         {
140             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
141                 no_of_tokens <= 19999 * (uint256(10)**decimals))
142             {
143                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
144             }
145             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
146                      no_of_tokens <= 149999 * (uint256(10)**decimals))
147             {
148                 bonus_token = no_of_tokens.mul(55).div(100); // 55% bonus
149             }
150             else if (no_of_tokens > 149999 * (uint256(10)**decimals))
151             {
152                 bonus_token = no_of_tokens.mul(60).div(100); // 60% bonus
153             }
154             else
155             {
156                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
157             }
158         }
159         else if (now >= ico_first && now < ico_second)
160         {
161             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
162                 no_of_tokens <= 19999 * (uint256(10)**decimals))
163             {
164                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
165             }
166             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
167                      no_of_tokens <= 149999 * (uint256(10)**decimals))
168             {
169                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
170             }
171             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
172             {
173                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
174             }
175             else
176             {
177                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
178             }
179         }
180         else if (now >= ico_second && now < ico_third)
181         {
182             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
183                 no_of_tokens <= 19999 * (uint256(10)**decimals))
184             {
185                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
186             }
187             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
188                      no_of_tokens <= 149999 * (uint256(10)**decimals))
189             {
190                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
191             }
192             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
193             {
194                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
195             }
196             else
197             {
198                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
199             }
200         }
201         else if (now >= ico_third && now < ico_fourth)
202         {
203             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
204                 no_of_tokens <= 19999 * (uint256(10)**decimals))
205             {
206                 bonus_token = no_of_tokens.mul(20).div(100); // 20% bonus
207             }
208             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
209                      no_of_tokens <= 149999 * (uint256(10)**decimals))
210             {
211                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
212             }
213             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
214             {
215                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
216             }
217             else
218             {
219                 bonus_token = no_of_tokens.mul(15).div(100); // 15% bonus
220             }
221         }
222         
223         uint256 total_token = no_of_tokens + bonus_token;
224         this.transfer(msg.sender, total_token);
225     }
226     
227     function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED) {
228 
229         stage = Stages.ICO;
230         stopped = false;
231         startdate = now;
232         ico_first = now + 14 days;
233         ico_second = ico_first + 14 days;
234         ico_third = ico_second + 14 days;
235         ico_fourth = ico_third + 14 days;
236     
237     }
238     
239     // called by the owner, pause ICO
240     function StopICO() external onlyOwner atStage(Stages.ICO) {
241     
242         stopped = true;
243         stage = Stages.PAUSED;
244     
245     }
246 
247     // called by the owner , resumes ICO
248     function releaseICO() external onlyOwner atStage(Stages.PAUSED) {
249     
250         stopped = false;
251         stage = Stages.ICO;
252     
253     }
254     
255     function end_ICO() external onlyOwner atStage(Stages.ICO) {
256     
257         require(now > ico_fourth);
258         stage = Stages.ENDED;
259    
260     }
261     
262     function burn(uint256 _amount) external onlyOwner
263     {
264         require(_amount <= balances[address(this)]);
265         
266         _totalsupply = _totalsupply.sub(_amount);
267         balances[address(this)] = balances[address(this)].sub(_amount);
268         balances[0x0] = balances[0x0].add(_amount);
269         Transfer(address(this), 0x0, _amount);
270     }
271      
272     function set_centralAccount(address central_Acccount) external onlyOwner {
273     
274         central_account = central_Acccount;
275     
276     }
277 
278 
279 
280     // what is the total supply of SAT
281     function totalSupply() public view returns (uint256 total_Supply) {
282     
283         total_Supply = _totalsupply;
284     
285     }
286     
287     // What is the balance of a particular account?
288     function balanceOf(address _owner)public view returns (uint256 balance) {
289     
290         return balances[_owner];
291     
292     }
293     
294     // Send _value amount of tokens from address _from to address _to
295     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
296     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
297     // fees in sub-currencies; the command should fail unless the _from account has
298     // deliberately authorized the sender of the message via some mechanism; we propose
299     // these standardized APIs for approval:
300     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
301     
302         require( _to != 0x0);
303     
304         balances[_from] = balances[_from].sub(_amount);
305         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
306         balances[_to] = balances[_to].add(_amount);
307     
308         Transfer(_from, _to, _amount);
309     
310         return true;
311     }
312     
313     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
314     // If this function is called again it overwrites the current allowance with _value.
315     function approve(address _spender, uint256 _amount)public returns (bool success) {
316         require(_amount == 0 || allowed[msg.sender][_spender] == 0);
317         require( _spender != 0x0);
318     
319         allowed[msg.sender][_spender] = _amount;
320     
321         Approval(msg.sender, _spender, _amount);
322     
323         return true;
324     }
325   
326     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
327     
328         require( _owner != 0x0 && _spender !=0x0);
329     
330         return allowed[_owner][_spender];
331    
332    }
333 
334     // Transfer the balance from owner's account to another account
335     function transfer(address _to, uint256 _amount)public returns (bool success) {
336     
337         require( _to != 0x0);
338         
339         balances[msg.sender] = balances[msg.sender].sub(_amount);
340         balances[_to] = balances[_to].add(_amount);
341     
342         Transfer(msg.sender, _to, _amount);
343     
344         return true;
345     }
346     
347     function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
348     
349         require( _to != 0x0);
350         
351         // Only allow transferby() to transfer from 0x0 and the ICO account
352         require(_from == address(this));
353         
354         balances[_from] = (balances[_from]).sub(_amount);
355         balances[_to] = (balances[_to]).add(_amount);
356         if (_from == 0x0)
357         {
358             _totalsupply = _totalsupply.add(_amount);
359         }
360     
361         Transfer(_from, _to, _amount);
362     
363         return true;
364     }
365 
366     //In case the ownership needs to be transferred
367     function transferOwnership(address newOwner)public onlyOwner {
368 
369         balances[newOwner] = balances[newOwner].add(balances[owner]);
370         balances[owner] = 0;
371         owner = newOwner;
372     
373     }
374 
375     function drain() external onlyOwner {
376     
377         owner.transfer(this.balance);
378     
379     }
380     
381 }