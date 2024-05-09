1 pragma solidity ^0.4.4;
2 
3 
4 contract owned {
5     address public owner;
6 
7     function owned() public{
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) onlyOwner public {
17         owner = newOwner;
18     }
19 }
20 
21 
22 contract ERC20Token {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 
34 contract StandardToken is ERC20Token {
35 
36     function transfer(address _to, uint _value) public returns (bool success) {
37         //Default assumes totalSupply can't be over max (2^256 - 1).
38         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
39         //Replace the if with this one instead.
40         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
41 
42         if (balances[msg.sender] >= _value && _value > 0) {
43             balances[msg.sender] -= _value;
44             balances[_to] += _value;
45             Transfer(msg.sender, _to, _value);
46             return true;
47         } else { return false; }
48     }
49 
50     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
51         //same as above. Replace this line with the following if you want to protect against wrapping uints.
52         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
53         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
54             balances[_to] += _value;
55             balances[_from] -= _value;
56             allowed[_from][msg.sender] -= _value;
57             Transfer(_from, _to, _value);
58             return true;
59         } else { return false; }
60     }
61 
62     function balanceOf(address _owner) public constant  returns (uint balance) {
63         return balances[_owner];
64     }
65 
66     function approve(address _spender, uint _value) public returns (bool success) {
67         allowed[msg.sender][_spender] = _value;
68         Approval(msg.sender, _spender, _value);
69         return true;
70     }
71 
72     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
73       return allowed[_owner][_spender];
74     }
75 
76     mapping (address => uint) balances;
77     mapping (address => mapping (address => uint)) allowed;
78     uint public _supply;
79 
80     function totalSupply() public constant returns (uint supply) {
81     return _supply;
82   }
83 
84 }
85 
86 
87 contract CWVToken is StandardToken,owned {
88 
89 
90     uint public time_on_trademarket; // when to lock , the day when cwv on trade market
91 
92     uint public time_end_sale; // day when finished open sales, time to calc team lock day.
93     
94     uint public angels_lock_days; // days  to lock angel , 90 days
95 
96     uint public team_total_lock_days; // days to local team , 24 month
97 
98     uint public team_release_epoch; // epoch to release teams
99 
100     string public name = "CryptoWorldVip  Token";
101     string public symbol = "CWV";
102     string public version = "V1.0.0";
103     uint public decimals = 18;
104 
105 
106     mapping (address => uint) angels_locks;//all lock 3 months,
107     
108 
109     
110     address public team_address;
111     
112     uint public team_lock_count ; // team lock count
113     uint public last_release_date ; // last team lock date
114     uint public epoch_release_count; // total release epoch count
115 
116     uint calc_unit = 1 days ;// days
117 
118     function CWVToken() public{
119         
120         time_on_trademarket = 0;
121         time_end_sale = 0;
122 
123 
124 //change times
125         
126 
127         angels_lock_days = 90 * calc_unit; //lock 3 mongth ,
128 
129         team_total_lock_days = 720 * calc_unit;
130 
131         team_release_epoch = 90  * calc_unit;
132 
133         _supply = 10000000000 * 10 ** uint256(decimals);
134 
135         balances[msg.sender] = _supply;
136 
137         team_lock_count = _supply * 15 / 100;
138 
139         owner = msg.sender;
140 
141         last_release_date = now;
142         
143         epoch_release_count = team_lock_count/(team_total_lock_days/team_release_epoch);//10000, 360*2=730, 30*3=90
144 
145     }
146 
147     function setOnlineTime() public onlyOwner {
148         //require (time_on_trademarket == 0);
149         time_on_trademarket = now;
150     
151     }
152 
153     function transfer(address _to, uint _value) public returns (bool success) {
154 
155         require (_to != 0x0 && msg.sender != team_address && _value >0 );
156 
157         if (angels_locks[msg.sender] != 0 )
158         { // before lock days 
159             if(time_on_trademarket == 0)
160             {
161                 //cannot transfer before time_on_trademarket
162                 return false;
163             }
164             if( now < time_on_trademarket + angels_lock_days &&
165                  balances[msg.sender] - angels_locks[msg.sender] < _value )
166             {
167                 // not have enough values to sender
168                 return false;
169             }
170         }
171 
172         require (balances[msg.sender] >= _value && _value > 0);
173         balances[msg.sender] -= _value;
174         balances[_to] += _value;
175         Transfer(msg.sender, _to, _value);
176         return true;
177     }
178     
179     //3 month lock up
180     function earlyAngelSales(address _to, uint256 _value) public onlyOwner returns (bool success)   {
181         require (_to != 0x0 && _value > 0 && _to !=team_address);
182         
183         uint v = _value * 10 ** uint256(decimals);
184         require (balances[msg.sender] >= v && v > 0) ;
185 
186         balances[msg.sender] -= v;
187         balances[_to] += v;
188         angels_locks [ _to ]  += v;
189 
190         Transfer(msg.sender, _to, v);
191 
192         return true;
193     }
194 
195 
196     function batchEarlyAngelSales(address []_tos, uint256 []_values) public onlyOwner returns (bool success)   {
197         require( _tos.length == _values.length );
198         for (uint256 i = 0; i < _tos.length; i++) {
199             earlyAngelSales(_tos[i], _values[i]);
200         }
201         return true;
202     }
203 
204 
205     function angelSales(address _to, uint256 _value) public onlyOwner returns (bool success)   {
206         require (_to != 0x0 && _value > 0 && _to !=team_address);
207         
208         uint v = _value * 10 ** uint256(decimals);
209         require (balances[msg.sender] >= v && v > 0) ;
210 
211         balances[msg.sender] -= v;
212         balances[_to] += v;
213         angels_locks[_to] += v/2;
214 
215         Transfer(msg.sender, _to, v);
216 
217         return true;
218     }
219 
220     function batchAngelSales(address []_tos, uint256 []_values) public onlyOwner returns (bool success)   {
221         require( _tos.length == _values.length );
222         for (uint256 i = 0; i < _tos.length; i++) {
223             angelSales(_tos[i], _values[i]);
224         }
225         return true;
226     }
227 
228     function unlockAngelAccounts(address[] _batchOfAddresses) public onlyOwner returns (bool success)   {
229         
230         require( time_on_trademarket != 0 );
231         require( now > time_on_trademarket + angels_lock_days );//after 3months
232 
233         address holder;
234 
235         for (uint256 i = 0; i < _batchOfAddresses.length; i++) {
236             holder = _batchOfAddresses[i];
237             if(angels_locks[holder]>0){                
238                 angels_locks[holder] = 0;
239             }
240         }
241         return true;
242     }
243 
244 
245     function frozen_team(address _to) public onlyOwner returns (bool success)   {
246 
247         require (team_address == 0);
248 
249         team_address = _to;
250         
251         uint v = team_lock_count;
252 
253         balances[msg.sender] -= v;
254         balances[_to] += v;
255         Transfer(msg.sender, _to, v);
256         return true;
257     }
258 
259     function changeTeamAddress(address _new)  public onlyOwner returns (bool success)   {
260 
261         require (_new != 0 && team_address != 0);
262         address old_team_address = team_address;
263 
264         uint team_remains = balances[team_address];
265         balances[team_address] -= team_remains;
266         balances[_new] += team_remains;
267 
268         team_address = _new;
269         Transfer(old_team_address, _new, team_remains);
270 
271         return true;
272     }
273 
274     function epochReleaseTeam(address _to) public onlyOwner returns (bool success)   {
275         require (balances[team_address] > 0);
276         require (now > last_release_date + team_release_epoch );
277         
278         uint current_release_count = (now - last_release_date)  / (team_release_epoch ) * epoch_release_count;
279        
280         if(balances[team_address]>current_release_count){
281             current_release_count = current_release_count;
282         }else{
283             current_release_count = balances[team_address];
284         }
285         
286         balances[team_address] -= current_release_count;
287         balances[_to] += current_release_count;
288 
289         last_release_date += (current_release_count / epoch_release_count ) * team_release_epoch;
290 
291         team_lock_count -= current_release_count;
292 
293         Transfer(team_address, _to, current_release_count);
294         return true;
295     }
296 
297 }