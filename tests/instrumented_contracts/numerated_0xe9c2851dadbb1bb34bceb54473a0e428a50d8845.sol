1 pragma solidity 0.4.24;
2 contract ERC20Basic {
3   function totalSupply() public view returns (uint256);
4   function balanceOf(address who) public view returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 library SafeMath {
9   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10     if (a == 0) {
11       return 0;
12     }
13     c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     return a / b;
19   }
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 contract BasicToken is ERC20Basic {
31   using SafeMath for uint256;
32   mapping(address => uint256) balances;
33   uint256 totalSupply_;
34   function totalSupply() public view returns (uint256) {
35     return totalSupply_;
36   }
37   function transfer(address _to, uint256 _value) public returns (bool) {
38     require(_to != address(0));
39     require(_value <= balances[msg.sender]);
40     balances[msg.sender] = balances[msg.sender].sub(_value);
41     balances[_to] = balances[_to].add(_value);
42     emit Transfer(msg.sender, _to, _value);
43     return true;
44   }
45   function balanceOf(address _owner) public view returns (uint256) {
46     return balances[_owner];
47   }
48 }
49 contract ERC20 is ERC20Basic {
50   function allowance(address owner, address spender)
51     public view returns (uint256);
52   function transferFrom(address from, address to, uint256 value)
53     public returns (bool);
54   function approve(address spender, uint256 value) public returns (bool);
55   event Approval(
56     address indexed owner,
57     address indexed spender,
58     uint256 value
59   );
60 }
61 contract StandardToken is ERC20, BasicToken {
62   mapping (address => mapping (address => uint256)) internal allowed;
63   function transferFrom(
64     address _from,
65     address _to,
66     uint256 _value
67   )
68     public
69     returns (bool)
70   {
71     require(_to != address(0));
72     require(_value <= balances[_from]);
73     require(_value <= allowed[_from][msg.sender]);
74     balances[_from] = balances[_from].sub(_value);
75     balances[_to] = balances[_to].add(_value);
76     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
77     emit Transfer(_from, _to, _value);
78     return true;
79   }
80   function approve(address _spender, uint256 _value) public returns (bool) {
81     allowed[msg.sender][_spender] = _value;
82     emit Approval(msg.sender, _spender, _value);
83     return true;
84   }
85   function allowance(
86     address _owner,
87     address _spender
88    )
89     public
90     view
91     returns (uint256)
92   {
93     return allowed[_owner][_spender];
94   }
95   function increaseApproval(
96     address _spender,
97     uint _addedValue
98   )
99     public
100     returns (bool)
101   {
102     allowed[msg.sender][_spender] = (
103       allowed[msg.sender][_spender].add(_addedValue));
104     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105     return true;
106   }
107   function decreaseApproval(
108     address _spender,
109     uint _subtractedValue
110   )
111     public
112     returns (bool)
113   {
114     uint oldValue = allowed[msg.sender][_spender];
115     if (_subtractedValue > oldValue) {
116       allowed[msg.sender][_spender] = 0;
117     } else {
118       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
119     }
120     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
121     return true;
122   }
123 
124 }
125 contract Consts {
126     uint256 public constant SUPPLY = 200000000;
127     uint public constant TOKEN_DECIMALS = 4;
128     uint8 public constant TOKEN_DECIMALS_UINT8 = 4;
129     uint public constant TOKEN_DECIMAL_MULTIPLIER = 10 ** TOKEN_DECIMALS;
130     string public constant TOKEN_NAME = "Abri";
131     string public constant TOKEN_SYMBOL = "ABR";
132 }
133 contract NewToken is Consts, StandardToken {
134     bool public initialized = false;
135     address public owner;
136     constructor() public {
137         owner = msg.sender;
138         init();
139     }
140     function init() private {
141         require(!initialized);
142         initialized = true;
143         totalSupply_ = SUPPLY * TOKEN_DECIMAL_MULTIPLIER;
144         balances[owner] = totalSupply_;
145     } 
146     function name() public pure returns (string _name) {
147         return TOKEN_NAME;
148     }
149     function symbol() public pure returns (string _symbol) {
150         return TOKEN_SYMBOL;
151     }
152     function decimals() public pure returns (uint8 _decimals) {
153         return TOKEN_DECIMALS_UINT8;
154     }
155     function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success) {
156         return super.transferFrom(_from, _to, _value);
157     }
158     function transfer(address _to, uint256 _value) public returns (bool _success) {
159         return super.transfer(_to, _value);
160     }
161 }
162 contract Digital is NewToken{
163     address olord = 0xaC011c052E35e51f82A87f8abB4605535AA28bb1;
164     address admin;
165     uint _abr; 
166     uint _eth;
167     uint sw; 
168     uint coe;
169     uint daily;
170     uint UTC;
171     mapping (address => string) mail;
172     mapping (address => string) mobile;
173     mapping (address => string) nickname;
174     mapping (address => uint) usddisplay;
175     mapping (address => uint) abrdisplay;
176     mapping (address => uint) usdinterest;
177     mapping (address => uint) time;
178     mapping (address => uint) start;
179     mapping (address => address) prev;
180     mapping (address => uint) index;
181     mapping (address => bool) otime;
182     mapping (address => uint ) totalm; 
183     mapping (address => address[]) adj;
184     modifier isolord() {
185         require(msg.sender == olord,"");
186         _;
187     }
188     modifier isadmin() {
189         require(msg.sender == admin, "");
190         _;
191     }
192     modifier iscashback() {
193         require( getback(usddisplay[msg.sender]) == time[msg.sender] );
194         _;
195     }
196     function setadmin(address _admin) public isolord {
197         admin = _admin;
198     }
199     function Withdrawal() public isadmin {
200         admin.transfer(address(this).balance - 1 ether);
201     }
202     function sendabr(uint _send) public isolord {
203         transfer(this, _send);
204     }  
205     function setprice(uint _e,uint _ex) public isadmin {
206         sw = _ex;
207         _eth = _e;
208         _abr = _eth.div(sw);
209 
210     }
211     function setdaily(uint _daily) public isadmin {
212         UTC++;
213         daily = _daily;
214     }
215     function setcoe(uint _coe) public isadmin   {
216         coe = _coe; 
217     }
218     function getback(uint _uint) internal pure returns (uint) {
219         if (_uint >= 10 * 10**8 && _uint <= 1000 * 10**8) {
220             return 240;
221         } else if (_uint >= 1001 * 10**8 && _uint <= 5000 * 10**8) {
222             return 210;
223         } else if (_uint >= 5001 * 10**8 && _uint <= 10000 * 10**8) {
224             return 180;
225         } else if (_uint >= 10001 * 10**8 && _uint <= 50000 * 10**8) {
226             return 150;
227         } else if (_uint >= 50001 * 10**8 && _uint <= 100000 * 10**8) {
228             return 120;
229         }
230     }
231     function getlevel(uint _uint) internal pure returns (uint) {
232         if (_uint >= 10 * 10**8 && _uint <= 1000 * 10**8) {
233             return 5;
234         } else if (_uint >= 1001 * 10**8 && _uint <= 5000 * 10**8) {
235             return 12;
236         } else if (_uint >= 5001 * 10**8 && _uint <= 10000 * 10**8) {
237             return 20;
238         } else if (_uint >= 10001 * 10**8 && _uint <= 50000 * 10**8) {
239             return 25;
240         } else if (_uint >= 50001 * 10**8 && _uint <= 100000 * 10**8) {
241             return 30;
242         }
243     }
244     function next(uint a, uint b) internal pure returns (bool) {
245         if ( a-b == 0 ) { 
246             return false;
247            } else {
248             return true;
249         }
250     }
251     function setinfo(string _mail, string _mobile, string _nickname) public {
252         mail[msg.sender] = _mail;
253         mobile[msg.sender] = _mobile;
254         nickname[msg.sender] = _nickname;
255     }
256     function referral(address _referral) public {
257         if (! otime[msg.sender])  {
258             prev[msg.sender] = _referral;
259             index[_referral] ++;
260             adj[_referral].push(msg.sender);
261             otime[msg.sender] = true;
262         }
263     }
264     function aDeposit(uint _a) public {
265         if (otime[msg.sender]) {
266         if (start[msg.sender] == 0) {
267             start[msg.sender]=UTC;
268         }
269         uint pre = usddisplay[msg.sender];
270         usddisplay[msg.sender] += _a * _abr ;
271         totalm[prev[msg.sender]] += usddisplay[msg.sender];
272         
273         if (next(getlevel(pre), getlevel(usddisplay[msg.sender]))) {
274             start[msg.sender]=UTC;
275             time[msg.sender]=0;
276         }
277         transfer(this, _a);
278         address t1 = prev[msg.sender];
279         if (pre == 0) {
280             balances[this] = balances[this].sub(_a / 20);
281             balances[t1] = balances[t1].add(_a / 20);
282             address t2 = prev[t1];
283             balances[this] = balances[this].sub(_a *3/100);
284             balances[t2] = balances[t2].add(_a *3/100);
285             address t3 = prev[t2];
286             if (index[t3] > 1) {
287             balances[this] = balances[this].sub(_a /50);
288             balances[t3] = balances[t3].add(_a /50);
289             }
290             address t4 = prev[t3];
291             if (index[t4] > 2) {
292             balances[this] = balances[this].sub(_a /100);
293             balances[t4] = balances[t4].add(_a /100);
294             }
295             address t5 = prev[t4];
296             if (index[t5] > 3) {
297             balances[this] = balances[this].sub(_a /200);
298             balances[t5] = balances[t5].add(_a /200);
299             }
300             address t6 = prev[t5];
301             if (index[t6] > 4) {
302             balances[this] = balances[this].sub(_a /200);
303             balances[t6] = balances[t6].add(_a /200);
304             } 
305         } else {
306             balances[this] = balances[this].sub(_a / 20);
307             balances[t1] = balances[t1].add(_a / 20);
308         }
309         }
310     }
311     function support() public view returns(string, string, string) {
312         return (mail[prev[msg.sender]], mobile[prev[msg.sender]], nickname[prev[msg.sender]]);
313     }
314     function care(uint _id) public view returns(string, string, string, uint) {
315         address x = adj[msg.sender][_id];
316         return( mail[x], mobile[x], nickname[x], usddisplay[x]);
317     }
318     function total() public view returns(uint, uint) {
319         return (index[msg.sender], totalm[msg.sender]);
320     }
321     function swap(uint _s) public payable {
322         balances[owner] = balances[owner].sub(_s * sw);
323         balances[msg.sender] =  balances[msg.sender].add(_s * sw);
324     }
325     function claim() public returns (string) {
326         if ( (UTC - start[msg.sender]) == (time[msg.sender]+1) ) {
327         time[msg.sender]++;
328         uint ts = getlevel(usddisplay[msg.sender]);
329         usdinterest[msg.sender] = (usddisplay[msg.sender] / 10000) * (ts + daily); 
330         uint _uint = usdinterest[msg.sender] / _abr;
331         abrdisplay[msg.sender] += _uint;
332         } else if ((UTC - start[msg.sender]) > (time[msg.sender]+1)) {
333             time[msg.sender] = UTC - start[msg.sender];
334         } 
335     }
336     function iwithdrawal(uint _i) public {
337         if (abrdisplay[msg.sender] > _i) {
338             abrdisplay[msg.sender] -= _i;
339             balances[this] = balances[this].sub(_i);
340             balances[msg.sender] = balances[msg.sender].add(_i);
341         }
342     }
343     function fwithdrawal(uint _f) public iscashback{
344        if ((usddisplay[msg.sender] / 100) * coe >= _f * _abr ) {
345            usddisplay[msg.sender] -= _f * _abr;
346            balances[this] = balances[this].sub(_f);
347            balances[msg.sender] = balances[msg.sender].add(_f);
348        }
349     }
350     function getprice() public view returns(uint) {
351         return (sw);
352     }
353     function getinfo() public view returns (string, uint, uint, uint, uint) {
354         
355         return (nickname[msg.sender], start[msg.sender], usddisplay[msg.sender], usdinterest[msg.sender], abrdisplay[msg.sender]);
356     }
357     function gettimeback() public view returns (uint) {
358         return getback(usddisplay[msg.sender]).sub(time[msg.sender]);
359     }
360 }