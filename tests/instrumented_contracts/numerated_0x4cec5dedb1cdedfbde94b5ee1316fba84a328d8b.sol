1 /*
2 PDOne (P1) - Official Smart Contract
3 Kitpay Fintech 
4 https://pd1sto.com
5 */
6 pragma solidity 0.4.19;
7 
8 library SafeMath {
9 
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         if (a == 0) {
12             return 0;
13         }
14         uint256 c = a * b;
15         assert(c / a == b);
16         return c;
17     }
18 
19     function div(uint256 a, uint256 b) internal pure returns (uint256) {
20       
21         uint256 c = a / b;
22         
23         return c;
24     }
25 
26     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
27         assert(b <= a);
28         return a - b;
29     }
30 
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         assert(c >= a);
34         return c;
35     }
36 }
37 
38 contract ERC20 {
39 
40     function totalSupply()public view returns (uint total_Supply);
41     function balanceOf(address who)public view returns (uint256);
42     function allowance(address owner, address spender)public view returns (uint);
43     function transferFrom(address from, address to, uint value)public returns (bool ok);
44     function approve(address spender, uint value)public returns (bool ok);
45     function transfer(address to, uint value)public returns (bool ok);
46 
47     event Transfer(address indexed from, address indexed to, uint value);
48     event Approval(address indexed owner, address indexed spender, uint value);
49 
50 }
51 
52 contract FiatContract
53 {
54     function USD(uint _id) public constant returns (uint256);
55 }
56 
57 
58 contract PDOne is ERC20
59 { 
60     using SafeMath for uint256;
61 
62     FiatContract price = FiatContract(0x2CDe56E5c8235D6360CCbb0c57Ce248Ca9C80909); // MAINNET FIAT ADDRESS
63 
64     // Name of the token
65     string public constant name = "PDOne";
66     // Symbol of token
67     string public constant symbol = "P1";
68     uint8 public constant decimals = 8;
69     uint public _totalsupply = 250000000 * (uint256(10) ** decimals); // 250 million P1
70     address public owner;
71     bool stopped = false;
72     uint256 public startdate;
73     uint256 ico_first;
74     uint256 ico_second;
75     uint256 ico_third;
76     uint256 ico_fourth;
77     address central_account;
78     mapping(address => uint) balances;
79     mapping(address => mapping(address => uint)) allowed;
80 
81     
82     enum Stages {
83         NOTSTARTED,
84         ICO,
85         PAUSED,
86         ENDED
87     }
88 
89     Stages public stage;
90     
91     modifier atStage(Stages _stage) {
92         if (stage != _stage)
93             // Contract not in expected state
94             revert();
95         _;
96     }
97     
98     modifier onlyOwner() {
99         if (msg.sender != owner) {
100             revert();
101         }
102         _;
103     }
104 
105     modifier onlycentralAccount {
106         require(msg.sender == central_account);
107         _;
108     }
109 
110     function PDOne() public
111     {
112         owner = msg.sender;
113         balances[owner] = 90000000 * (uint256(10) ** decimals);
114         balances[address(this)] = 160000000 * (uint256(10) ** decimals);
115         stage = Stages.NOTSTARTED;
116         Transfer(0, owner, balances[owner]);
117         Transfer(0, address(this), balances[address(this)]);
118     }
119     
120     function () public payable atStage(Stages.ICO)
121     {
122         require(msg.value >= 1 finney); //for round up and security measures
123         require(!stopped && msg.sender != owner);
124 
125         uint256 ethCent = price.USD(0); //one USD cent in wei
126         uint256 tokPrice = ethCent.mul(80); //1P1 = 80 USD cent
127         
128         tokPrice = tokPrice.div(10 ** 8); //limit to 10 places
129         uint256 no_of_tokens = msg.value.div(tokPrice);
130         
131         uint256 bonus_token = 0;
132         
133         // Determine the bonus based on the time and the purchased amount
134         if (now < ico_first)
135         {
136             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
137                 no_of_tokens <= 19999 * (uint256(10)**decimals))
138             {
139                 bonus_token = no_of_tokens.mul(30).div(100); 
140             }
141             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
142                      no_of_tokens <= 149999 * (uint256(10)**decimals))
143             {
144                 bonus_token = no_of_tokens.mul(30).div(100); 
145             }
146             else if (no_of_tokens > 149999 * (uint256(10)**decimals))
147             {
148                 bonus_token = no_of_tokens.mul(30).div(100); 
149             }
150             else
151             {
152                 bonus_token = no_of_tokens.mul(30).div(100); 
153             }
154         }
155         else if (now >= ico_first && now < ico_second)
156         {
157             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
158                 no_of_tokens <= 19999 * (uint256(10)**decimals))
159             {
160                 bonus_token = no_of_tokens.mul(25).div(100); 
161             }
162             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
163                      no_of_tokens <= 149999 * (uint256(10)**decimals))
164             {
165                 bonus_token = no_of_tokens.mul(25).div(100); 
166             }
167             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
168             {
169                 bonus_token = no_of_tokens.mul(25).div(100); 
170             }
171             else
172             {
173                 bonus_token = no_of_tokens.mul(25).div(100); 
174             }
175         }
176         else if (now >= ico_second && now < ico_third)
177         {
178             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
179                 no_of_tokens <= 19999 * (uint256(10)**decimals))
180             {
181                 bonus_token = no_of_tokens.mul(20).div(100); 
182             }
183             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
184                      no_of_tokens <= 149999 * (uint256(10)**decimals))
185             {
186                 bonus_token = no_of_tokens.mul(20).div(100); 
187             }
188             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
189             {
190                 bonus_token = no_of_tokens.mul(20).div(100); 
191             }
192             else
193             {
194                 bonus_token = no_of_tokens.mul(20).div(100); //
195             }
196         }
197         else if (now >= ico_third && now < ico_fourth)
198         {
199             if (no_of_tokens >=  2000 * (uint256(10)**decimals) &&
200                 no_of_tokens <= 19999 * (uint256(10)**decimals))
201             {
202                 bonus_token = no_of_tokens.mul(20).div(100); 
203             }
204             else if (no_of_tokens >   19999 * (uint256(10)**decimals) &&
205                      no_of_tokens <= 149999 * (uint256(10)**decimals))
206             {
207                 bonus_token = no_of_tokens.mul(20).div(100); 
208             }
209             else if (no_of_tokens >  149999 * (uint256(10)**decimals))
210             {
211                 bonus_token = no_of_tokens.mul(20).div(100); 
212             }
213             else
214             {
215                 bonus_token = no_of_tokens.mul(20).div(100); 
216             }
217         }
218         
219         uint256 total_token = no_of_tokens + bonus_token;
220         this.transfer(msg.sender, total_token);
221     }
222     
223     function start_ICO() public onlyOwner atStage(Stages.NOTSTARTED) {
224 
225         stage = Stages.ICO;
226         stopped = false;
227         startdate = now;
228         ico_first = now + 9 days;
229         ico_second = ico_first + 21 days;
230         ico_third = ico_second + 15 days;
231         ico_fourth = ico_third + 14 days;
232     
233     }
234     
235     // called by the owner, pause ICO
236     function StopICO() external onlyOwner atStage(Stages.ICO) {
237     
238         stopped = true;
239         stage = Stages.PAUSED;
240     
241     }
242 
243     // called by the owner , resumes ICO
244     function releaseICO() external onlyOwner atStage(Stages.PAUSED) {
245     
246         stopped = false;
247         stage = Stages.ICO;
248     
249     }
250     
251     function end_ICO() external onlyOwner atStage(Stages.ICO) {
252     
253         require(now > ico_fourth);
254         stage = Stages.ENDED;
255    
256     }
257     
258     function burn(uint256 _amount) external onlyOwner
259     {
260         require(_amount <= balances[address(this)]);
261         
262         _totalsupply = _totalsupply.sub(_amount);
263         balances[address(this)] = balances[address(this)].sub(_amount);
264         balances[0x0] = balances[0x0].add(_amount);
265         Transfer(address(this), 0x0, _amount);
266     }
267      
268     function set_centralAccount(address central_Acccount) external onlyOwner {
269     
270         central_account = central_Acccount;
271     
272     }
273 
274 
275 
276     // what is the total supply of PDOne
277     function totalSupply() public view returns (uint256 total_Supply) {
278     
279         total_Supply = _totalsupply;
280     
281     }
282     
283     // What is the balance of a particular account?
284     function balanceOf(address _owner)public view returns (uint256 balance) {
285     
286         return balances[_owner];
287     
288     }
289     
290 
291     function transferFrom( address _from, address _to, uint256 _amount )public returns (bool success) {
292     
293         require( _to != 0x0);
294     
295         balances[_from] = balances[_from].sub(_amount);
296         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
297         balances[_to] = balances[_to].add(_amount);
298     
299         Transfer(_from, _to, _amount);
300     
301         return true;
302     }
303     
304 
305     function approve(address _spender, uint256 _amount)public returns (bool success) {
306         require(_amount == 0 || allowed[msg.sender][_spender] == 0);
307         require( _spender != 0x0);
308     
309         allowed[msg.sender][_spender] = _amount;
310     
311         Approval(msg.sender, _spender, _amount);
312     
313         return true;
314     }
315   
316     function allowance(address _owner, address _spender)public view returns (uint256 remaining) {
317     
318         require( _owner != 0x0 && _spender !=0x0);
319     
320         return allowed[_owner][_spender];
321    
322    }
323 
324     function transfer(address _to, uint256 _amount)public returns (bool success) {
325     
326         require( _to != 0x0);
327         
328         balances[msg.sender] = balances[msg.sender].sub(_amount);
329         balances[_to] = balances[_to].add(_amount);
330     
331         Transfer(msg.sender, _to, _amount);
332     
333         return true;
334     }
335     
336     function transferby(address _from,address _to,uint256 _amount) external onlycentralAccount returns(bool success) {
337     
338         require( _to != 0x0);
339         
340         require(_from == address(this));
341         
342         balances[_from] = (balances[_from]).sub(_amount);
343         balances[_to] = (balances[_to]).add(_amount);
344         if (_from == 0x0)
345         {
346             _totalsupply = _totalsupply.add(_amount);
347         }
348     
349         Transfer(_from, _to, _amount);
350     
351         return true;
352     }
353 
354     function transferOwnership(address newOwner)public onlyOwner {
355 
356         balances[newOwner] = balances[newOwner].add(balances[owner]);
357         balances[owner] = 0;
358         owner = newOwner;
359     
360     }
361 
362     function drain() external onlyOwner {
363     
364         owner.transfer(this.balance);
365     
366     }
367     
368 }