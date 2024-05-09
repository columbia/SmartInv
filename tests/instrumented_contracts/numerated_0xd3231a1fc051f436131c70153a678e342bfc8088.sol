1 /*
2 Official Social Activity Token (SAT) of Sphere Social
3 https://sphere.social
4 Sphere Social LTD
5 */
6 
7 pragma solidity 0.4.19;
8 
9 /**
10  * @title SafeMath
11  * @dev Math operations with safety checks that throw on error
12  */
13 library SafeMath {
14 
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         if (a == 0) {
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         assert(b <= a);
33         return a - b;
34     }
35 
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         assert(c >= a);
39         return c;
40     }
41 }
42 
43 contract ERC20 {
44 
45     function totalSupply()public view returns (uint total_Supply);
46     function balanceOf(address who)public view returns (uint256);
47     function allowance(address owner, address spender)public view returns (uint);
48     function transferFrom(address from, address to, uint value)public returns (bool ok);
49     function approve(address spender, uint value)public returns (bool ok);
50     function transfer(address to, uint value)public returns (bool ok);
51 
52     event Transfer(address indexed from, address indexed to, uint value);
53     event Approval(address indexed owner, address indexed spender, uint value);
54 
55 }
56 
57 contract FiatContract
58 {
59     function USD(uint _id) constant returns (uint256);
60 }
61 
62 contract TestFiatContract
63 {
64     function USD(uint) constant returns (uint256)
65     {
66         return 12305041990000;
67     }
68 }
69 
70 
71 contract SocialActivityToken is ERC20
72 { 
73     using SafeMath for uint256;
74 
75     FiatContract price = FiatContract(new TestFiatContract()); //FiatContract(0x8055d0504666e2B6942BeB8D6014c964658Ca591); // MAINNET ADDRESS
76 
77     // Name of the token
78     string public constant name = "Social Activity Token";
79     // Symbol of token
80     string public constant symbol = "SAT";
81     uint8 public constant decimals = 8;
82     uint public _totalsupply = 1000000000 * (uint256(10) ** decimals); // 1 billion SAT
83     address public owner;
84     bool stopped = false;
85     uint256 public startdate;
86     uint256 ico_first;
87     uint256 ico_second;
88     uint256 ico_third;
89     uint256 ico_fourth;
90     address central_account;
91     mapping(address => uint) balances;
92     mapping(address => mapping(address => uint)) allowed;
93 
94     
95     enum Stages {
96         NOTSTARTED,
97         ICO,
98         PAUSED,
99         ENDED
100     }
101 
102     Stages public stage;
103     
104     modifier atStage(Stages _stage) {
105         if (stage != _stage)
106             // Contract not in expected state
107             revert();
108         _;
109     }
110     
111     modifier onlyOwner() {
112         if (msg.sender != owner) {
113             revert();
114         }
115         _;
116     }
117 
118     modifier onlycentralAccount {
119         require(msg.sender == central_account);
120         _;
121     }
122 
123     function SocialActivityToken() public
124     {
125         owner = msg.sender;
126         balances[owner] = 350000000 * (uint256(10) ** decimals);
127         balances[address(this)] = 650000000 * (uint256(10) ** decimals);
128         stage = Stages.NOTSTARTED;
129         Transfer(0, owner, balances[owner]);
130         Transfer(0, address(this), balances[address(this)]);
131     }
132     
133     function () public payable atStage(Stages.ICO)
134     {
135         require(msg.value >= 1 finney); //for round up and security measures
136         require(!stopped && msg.sender != owner);
137 
138         uint256 ethCent = price.USD(0); //one USD cent in wei
139         uint256 tokPrice = ethCent.mul(14); //1Sat = 14 USD cent
140         
141         tokPrice = tokPrice.div(10 ** 8); //limit to 10 places
142         uint256 no_of_tokens = msg.value.div(tokPrice);
143         
144         uint256 bonus_token = 0;
145         
146         // Determine the bonus based on the time and the purchased amount
147         if (now < ico_first)
148         {
149             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
150                 no_of_tokens <= 19999 * (uint256(10)**decimals))
151             {
152                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
153             }
154             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
155                      no_of_tokens <= 149999 * (uint256(10)**decimals))
156             {
157                 bonus_token = no_of_tokens.mul(55).div(100); // 55% bonus
158             }
159             else if (no_of_tokens > 149999 * (uint256(10)**decimals))
160             {
161                 bonus_token = no_of_tokens.mul(60).div(100); // 60% bonus
162             }
163             else
164             {
165                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
166             }
167         }
168         else if (now >= ico_first && now < ico_second)
169         {
170             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
171                 no_of_tokens <= 19999 * (uint256(10)**decimals))
172             {
173                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
174             }
175             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
176                      no_of_tokens <= 149999 * (uint256(10)**decimals))
177             {
178                 bonus_token = no_of_tokens.mul(45).div(100); // 45% bonus
179             }
180             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
181             {
182                 bonus_token = no_of_tokens.mul(50).div(100); // 50% bonus
183             }
184             else
185             {
186                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
187             }
188         }
189         else if (now >= ico_second && now < ico_third)
190         {
191             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
192                 no_of_tokens <= 19999 * (uint256(10)**decimals))
193             {
194                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
195             }
196             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
197                      no_of_tokens <= 149999 * (uint256(10)**decimals))
198             {
199                 bonus_token = no_of_tokens.mul(35).div(100); // 35% bonus
200             }
201             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
202             {
203                 bonus_token = no_of_tokens.mul(40).div(100); // 40% bonus
204             }
205             else
206             {
207                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
208             }
209         }
210         else if (now >= ico_third && now < ico_fourth)
211         {
212             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
213                 no_of_tokens <= 19999 * (uint256(10)**decimals))
214             {
215                 bonus_token = no_of_tokens.mul(20).div(100); // 20% bonus
216             }
217             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
218                      no_of_tokens <= 149999 * (uint256(10)**decimals))
219             {
220                 bonus_token = no_of_tokens.mul(25).div(100); // 25% bonus
221             }
222             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
223             {
224                 bonus_token = no_of_tokens.mul(30).div(100); // 30% bonus
225             }
226             else
227             {
228                 bonus_token = no_of_tokens.mul(15).div(100); // 15% bonus
229             }
230         }
231         
232         uint256 total_token = no_of_tokens + bonus_token;
233         this.transfer(msg.sender, total_token);
234     }
235     
236     function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED) {
237 
238         stage = Stages.ICO;
239         stopped = false;
240         startdate = now;
241         ico_first = now + 5 minutes; //14 days;
242         ico_second = ico_first + 5 minutes; //14 days;
243         ico_third = ico_second + 5 minutes; //14 days;
244         ico_fourth = ico_third + 5 minutes; //14 days;
245     
246     }
247     
248     // called by the owner, pause ICO
249     function StopICO() external onlyOwner atStage(Stages.ICO) {
250     
251         stopped = true;
252         stage = Stages.PAUSED;
253     
254     }
255 
256     // called by the owner , resumes ICO
257     function releaseICO() external onlyOwner atStage(Stages.PAUSED) {
258     
259         stopped = false;
260         stage = Stages.ICO;
261     
262     }
263     
264     function end_ICO() external onlyOwner atStage(Stages.ICO) {
265     
266         require(now > ico_fourth);
267         stage = Stages.ENDED;
268    
269     }
270     
271     function burn(uint256 _amount) external onlyOwner
272     {
273         require(_amount <= balances[address(this)]);
274         
275         _totalsupply = _totalsupply.sub(_amount);
276         balances[address(this)] = balances[address(this)].sub(_amount);
277         balances[0x0] = balances[0x0].add(_amount);
278         Transfer(address(this), 0x0, _amount);
279     }
280      
281     function set_centralAccount(address central_Acccount) external onlyOwner {
282     
283         central_account = central_Acccount;
284     
285     }
286 
287 
288 
289     // what is the total supply of SAT
290     function totalSupply() public view returns (uint256 total_Supply) {
291     
292         total_Supply = _totalsupply;
293     
294     }
295     
296     // What is the balance of a particular account?
297     function balanceOf(address _owner)public view returns (uint256 balance) {
298     
299         return balances[_owner];
300     
301     }
302     
303     // Send _value amount of tokens from address _from to address _to
304     // The transferFrom method is used for a withdraw workflow, allowing contracts to send
305     // tokens on your behalf, for example to "deposit" to a contract address and/or to charge
306     // fees in sub-currencies; the command should fail unless the _from account has
307     // deliberately authorized the sender of the message via some mechanism; we propose
308     // these standardized APIs for approval:
309     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
310     
311         require( _to != 0x0);
312     
313         balances[_from] = balances[_from].sub(_amount);
314         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
315         balances[_to] = balances[_to].add(_amount);
316     
317         Transfer(_from, _to, _amount);
318     
319         return true;
320     }
321     
322     // Allow _spender to withdraw from your account, multiple times, up to the _value amount.
323     // If this function is called again it overwrites the current allowance with _value.
324     function approve(address _spender, uint256 _amount)public returns (bool success) {
325         require(_amount == 0 || allowed[msg.sender][_spender] == 0);
326         require( _spender != 0x0);
327     
328         allowed[msg.sender][_spender] = _amount;
329     
330         Approval(msg.sender, _spender, _amount);
331     
332         return true;
333     }
334   
335     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
336     
337         require( _owner != 0x0 && _spender !=0x0);
338     
339         return allowed[_owner][_spender];
340    
341    }
342 
343     // Transfer the balance from owner's account to another account
344     function transfer(address _to, uint256 _amount)public returns (bool success) {
345     
346         require( _to != 0x0);
347         
348         balances[msg.sender] = balances[msg.sender].sub(_amount);
349         balances[_to] = balances[_to].add(_amount);
350     
351         Transfer(msg.sender, _to, _amount);
352     
353         return true;
354     }
355     
356     function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
357     
358         require( _to != 0x0);
359         
360         // Only allow transferby() to transfer from 0x0 and the ICO account
361         require(_from == 0x0 || _from == address(this));
362         
363         balances[_from] = (balances[_from]).sub(_amount);
364         balances[_to] = (balances[_to]).add(_amount);
365         if (_from == 0x0)
366         {
367             _totalsupply = _totalsupply.add(_amount);
368         }
369     
370         Transfer(_from, _to, _amount);
371     
372         return true;
373     }
374 
375     //In case the ownership needs to be transferred
376     function transferOwnership(address newOwner)public onlyOwner {
377 
378         balances[newOwner] = balances[newOwner].add(balances[owner]);
379         balances[owner] = 0;
380         owner = newOwner;
381     
382     }
383 
384     function drain() external onlyOwner {
385     
386         owner.transfer(this.balance);
387     
388     }
389     
390 }