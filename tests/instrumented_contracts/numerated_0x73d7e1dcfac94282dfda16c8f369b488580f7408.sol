1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function add(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a + b;
7     assert(c >= a);
8     return c;
9   }
10 
11   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
12     assert(b <= a);
13     return a - b;
14   }
15 
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17       if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24   
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     require(b > 0);
27     uint256 c = a / b;
28     assert(a == b * c + a % b); 
29     return c;
30   }
31 }
32 
33 contract Ownable {
34 
35   address public owner;
36   event SetOwner(address indexed oldOwner, address indexed newOwner);
37   
38   constructor() internal {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47   function setOwner(address _newOwner) external onlyOwner {
48     emit SetOwner(owner, _newOwner);
49     owner = _newOwner;
50   }
51 }
52 
53 contract Saleable is Ownable {
54 
55   address public saler;
56   event SetSaler(address indexed oldSaler, address indexed newSaler);
57 
58   modifier onlySaler() {
59     require(msg.sender == saler);
60     _;
61   }
62 
63   function setSaler(address _newSaler) external onlyOwner {
64     emit SetSaler(saler, _newSaler);
65     saler = _newSaler;
66   }
67 }
68 
69 contract Pausable is Ownable {
70 
71   bool public paused = false;
72 
73   event Pause();
74   event Unpause();
75 
76   modifier notPaused() {
77     require(!paused);
78     _;
79   }
80 
81   modifier isPaused() {
82     require(paused);
83     _;
84   }
85 
86   function pause() onlyOwner notPaused public {
87     paused = true;
88     emit Pause();
89   }
90 
91   function unpause() onlyOwner isPaused public {
92     paused = false;
93     emit Unpause();
94   }
95 }
96 
97 contract ERC20Interface {
98     
99   function totalSupply() public view returns (uint256);
100   function decimals() public view returns (uint8);
101   function balanceOf(address _owner) public view returns (uint256);
102   function transfer(address _to, uint256 _value) public returns (bool);
103  
104   function allowance(address _owner, address _spender) public view returns (uint256);
105   function approve(address _spender, uint256 _value) public returns (bool);
106   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
107 
108   event Transfer(address indexed from, address indexed to, uint256 value);
109   event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 contract StandToken is ERC20Interface {
113 
114   using SafeMath for uint256;
115 
116   string public name;
117   string public symbol;
118   uint8 public decimals;
119   uint256 public totalSupply;
120 
121   mapping(address => uint256) balances;
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124   function totalSupply() public view returns (uint256) {
125     return totalSupply;
126   }
127   
128   function decimals() public view returns (uint8) {
129     return decimals;
130   }
131   
132   function balanceOf(address _owner) public view returns (uint256) {
133     return balances[_owner];
134   }
135 
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_to != address(0));
138     require(_value <= balances[msg.sender]);
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   function allowance(address _owner, address _spender) public view returns (uint256) {
147     return allowed[_owner][_spender];
148   }
149 
150   function approve(address _spender, uint256 _value) public returns (bool) {
151     allowed[msg.sender][_spender] = _value;
152     emit Approval(msg.sender, _spender, _value);
153     return true;
154   }
155 
156   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
157     require(_to != address(0));
158     require(_value <= balances[_from]);
159     require(_value <= allowed[_from][msg.sender]);
160 
161     balances[_from] = balances[_from].sub(_value);
162     balances[_to] = balances[_to].add(_value);
163     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
164     emit Transfer(_from, _to, _value);
165     return true;
166   }
167 }
168 
169 contract BurnableToken is StandToken {
170 
171   event Burn(address indexed burner, uint256 value);
172 
173   function burn(uint256 _value) public {
174     require(_value <= balances[msg.sender]);
175 
176     address burner = msg.sender;
177     balances[burner] = balances[burner].sub(_value);
178     totalSupply = totalSupply.sub(_value);
179     emit Burn(burner, _value);
180   }
181 }
182 
183 contract IDCToken is BurnableToken, Pausable, Saleable {
184 
185   address public addrTeam;
186   address public addrSale;
187   address public addrMine;
188 
189   mapping(address => uint256) public tokenAngel;
190   mapping(address => uint256) public tokenPrivate;
191   mapping(address => uint256) public tokenCrowd;
192 
193   uint256 public release = 0;
194   uint256 private teamLocked = 0;
195   
196   uint256 constant private DAY_10 = 10 days;
197   uint256 constant private DAY_90 = 90 days;
198   uint256 constant private DAY_120 = 120 days;
199   uint256 constant private DAY_150 = 150 days;
200   uint256 constant private DAY_180 = 180 days;
201   uint256 constant private DAY_360 = 360 days;
202   uint256 constant private DAY_720 = 720 days;
203   
204   event TransferToken(uint8 stage, address indexed to, uint256 value);
205   event TokenRelease(address caller, uint256 time);
206 
207   constructor(address _team, address _sale, address _mine) public {
208     name = "IDC Token";
209     symbol = "IT";
210     decimals = 18;
211     totalSupply = 3*10**9*10**uint256(decimals); //3 billion        
212     
213     addrTeam = _team;
214     addrSale = _sale;
215     addrMine = _mine;
216     
217     balances[_team] = totalSupply.mul(2).div(5); //40% for team
218     balances[_sale] = totalSupply.mul(1).div(5); //20% for sale
219     balances[_mine] = totalSupply.mul(2).div(5); //40% for mining
220     teamLocked = balances[_team];    
221     
222     emit Transfer(0,_team,balances[_team]);
223     emit Transfer(0,_sale,balances[_sale]);
224     emit Transfer(0,_mine,balances[_mine]);
225   }
226 
227   function transfer(address _to, uint256 _value) notPaused public returns (bool) {
228     if(msg.sender == addrTeam || tokenAngel[msg.sender] > 0 || tokenPrivate[msg.sender] > 0) {
229       require(balanceOfUnlocked(msg.sender) >= _value);
230     }
231     StandToken.transfer(_to, _value);
232     return true;
233   }
234   
235   function transferFrom(address _from, address _to, uint256 _value) notPaused public returns (bool) {
236     if(_from == addrTeam || tokenAngel[_from] > 0 || tokenPrivate[_from] > 0) {
237       require(balanceOfUnlocked(_from) >= _value);
238     }
239     StandToken.transferFrom(_from, _to, _value);
240     return true;
241   }  
242   
243   function balanceOfUnlocked(address _sender) public view returns (uint256) {
244     require(release > 0 && now > release);
245     uint256 tmPast = now.sub(release);
246     uint256 balance = balanceOf(_sender);
247     
248     if(_sender == addrTeam) {
249       if(tmPast < DAY_180) {
250         balance = balance.sub(teamLocked);
251       }
252       else if(tmPast >= DAY_180 && tmPast < DAY_360) {
253         balance = balance.sub(teamLocked.mul(7).div(10));
254       }
255       else if(tmPast >= DAY_360 && tmPast < DAY_720) {
256         balance = balance.sub(teamLocked.mul(4).div(10));
257       }
258     }
259     if(tokenAngel[_sender] > 0) {
260       if(tmPast < DAY_120) {
261         balance = balance.sub(tokenAngel[_sender]);
262       }
263       else if(tmPast >= DAY_120 && tmPast < DAY_150) {
264         balance = balance.sub(tokenAngel[_sender].mul(7).div(10));
265       }
266       else if(tmPast >= DAY_150 && tmPast < DAY_180) {
267         balance = balance.sub(tokenAngel[_sender].mul(4).div(10));
268       }
269     }
270     if(tokenPrivate[_sender] > 0) {
271       if(tmPast < DAY_90) {
272         balance = balance.sub(tokenPrivate[_sender].div(2));
273       }
274     }
275     return balance;
276   }
277   
278   function transferToken(uint8 _stage, address _to, uint256 _tokens) onlySaler external payable {
279     require(_stage >= 0 && _stage <= 2);
280     if(_stage == 0) { 
281       tokenAngel[_to] = tokenAngel[_to].add(_tokens);
282     }
283     else if(_stage == 1) {
284       tokenPrivate[_to] = tokenPrivate[_to].add(_tokens);
285     }
286     else if(_stage == 2) { 
287       tokenCrowd[_to] = tokenCrowd[_to].add(_tokens);
288     }
289     balances[addrSale] = balances[addrSale].sub(_tokens);
290     balances[_to] = balances[_to].add(_tokens);
291     emit Transfer(addrSale, _to, _tokens);
292     emit TransferToken(_stage, _to, _tokens);
293   }
294 
295   function burnToken(uint256 _tokens) onlySaler external returns (bool) {
296     require(_tokens > 0);
297     balances[addrSale] = balances[addrSale].sub(_tokens);
298     totalSupply = totalSupply.sub(_tokens);
299     emit Burn(addrSale, _tokens);
300   }
301   
302   function tokenRelease() onlySaler external returns (bool) {
303     require(release == 0);
304     release = now + DAY_10;
305     emit TokenRelease(msg.sender, release);
306     return true;
307   }
308 }