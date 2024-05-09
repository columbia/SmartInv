1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public constant returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 contract ERC20 is ERC20Basic {
9   function allowance(address owner, address spender) public constant returns (uint256);
10   function transferFrom(address from, address to, uint256 value) public returns (bool);
11   function approve(address spender, uint256 value) public returns (bool);
12   event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
17     uint256 c = a * b;
18     assert(a == 0 || c / a == b);
19     return c;
20   }
21 
22   function div(uint256 a, uint256 b) internal constant returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
30     assert(b <= a);
31     return a - b;
32   }
33 
34   function add(uint256 a, uint256 b) internal constant returns (uint256) {
35     uint256 c = a + b;
36     assert(c >= a);
37     return c;
38   }
39 }
40 
41 contract BasicToken is ERC20Basic {
42   using SafeMath for uint256;
43 
44   mapping(address => uint256) balances;
45 
46   function transfer(address _to, uint256 _value) public returns (bool) {
47     require(_to != address(0));
48     require(_value <= balances[msg.sender]);
49 
50     // SafeMath.sub will throw if there is not enough balance.
51     balances[msg.sender] = balances[msg.sender].sub(_value);
52     balances[_to] = balances[_to].add(_value);
53     Transfer(msg.sender, _to, _value);
54     return true;
55   }
56 
57   function balanceOf(address _owner) public constant returns (uint256 balance) {
58     return balances[_owner];
59   }
60 
61 }
62 contract StandardToken is ERC20, BasicToken {
63 
64   mapping (address => mapping (address => uint256)) internal allowed;
65 
66 
67   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
68     require(_to != address(0));
69     require(_value <= balances[_from]);
70     require(_value <= allowed[_from][msg.sender]);
71 
72     balances[_from] = balances[_from].sub(_value);
73     balances[_to] = balances[_to].add(_value);
74     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
75     Transfer(_from, _to, _value);
76     return true;
77   }
78 
79   function approve(address _spender, uint256 _value) public returns (bool) {
80     allowed[msg.sender][_spender] = _value;
81     Approval(msg.sender, _spender, _value);
82     return true;
83   }
84 
85   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
86     return allowed[_owner][_spender];
87   }
88 
89   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
90     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
91     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
92     return true;
93   }
94 
95   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
96     uint oldValue = allowed[msg.sender][_spender];
97     if (_subtractedValue > oldValue) {
98       allowed[msg.sender][_spender] = 0;
99     } else {
100       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
101     }
102     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
103     return true;
104   }
105 
106 }
107 contract Ownable {
108   address public owner;
109   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
110   function Ownable() public{
111     owner = msg.sender;
112   }
113   modifier onlyOwner() {
114     require(msg.sender == owner);
115     _;
116   }
117   function transferOwnership(address newOwner) onlyOwner public {
118     require(newOwner != address(0));
119     OwnershipTransferred(owner, newOwner);
120     owner = newOwner;
121   }
122 
123 }
124 contract MintableToken is StandardToken, Ownable {
125   event Mint(address indexed to, uint256 amount);
126   event MintFinished();
127 
128   bool public mintingFinished = false;
129 
130 
131   modifier canMint() {
132     require(!mintingFinished);
133     _;
134   }
135 
136   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
137     totalSupply = totalSupply.add(_amount);
138     balances[_to] = balances[_to].add(_amount);
139     Mint(_to, _amount);
140     Transfer(address(0), _to, _amount);
141     return true;
142   }
143   function finishMinting() onlyOwner public returns (bool) {
144     mintingFinished = true;
145     MintFinished();
146     return true;
147   }
148 }
149 contract BurnableToken is StandardToken {
150 
151   function burn(uint _value) public {
152     require(_value > 0);
153     address burner = msg.sender;
154     balances[burner] = balances[burner].sub(_value);
155     totalSupply = totalSupply.sub(_value);
156     Burn(burner, _value);
157   }
158 
159   event Burn(address indexed burner, uint indexed value);
160 
161 }
162 
163 
164 contract EWA is MintableToken, BurnableToken {
165     
166     string public constant name = "EWAcoin";
167     
168     string public constant symbol = "EWA";
169     
170     uint32 public constant decimals = 0;
171     
172     struct Trnsaction {
173         address addr;
174         uint time;
175         uint value;
176     }
177     
178     mapping (uint => Trnsaction) TrnsactionLog;
179     
180     mapping (address => uint256) securities;
181      
182     mapping (address => uint256) production;
183     
184     uint public startsecurities;
185     
186     uint public startproduction;
187     
188     uint public starteth;
189     
190     address public moneybackaddr;
191     
192     uint public i;
193     
194     function EWA() public{
195 		owner = msg.sender;
196 		startsecurities = 1546214400;
197 		startproduction = 1546214400;
198 		starteth = 1514764800;
199 		moneybackaddr = 0x0F99f33cD5a6B1b77eD905C229FC1962D05fE74F;
200     }
201     
202     function destroyforsecurities (uint _value) public {
203         require (_value > 99999);
204         require (now > startsecurities);
205         if(balances[msg.sender] >= _value && securities[msg.sender] + _value >= securities[msg.sender]) {
206             burn (_value);
207             securities[msg.sender] += _value;
208         }
209     }
210     
211     function securitiesOf(address _owner) public constant returns (uint balance) {
212         return securities[_owner];
213     }
214     
215     function destroyforproduction (uint _value) public {
216         require (_value > 0);
217         require (now > startproduction);
218         if(balances[msg.sender] >= _value && production[msg.sender] + _value >= production[msg.sender]) {
219             burn (_value);
220             production[msg.sender] += _value;
221         }
222     }
223     
224     function productionOf(address _owner) public constant returns (uint balance) {
225         return production[_owner];
226     }
227     
228     function destroyforeth (uint _value) public {
229         require (_value > 0);
230         require (now > starteth);
231         require (this.balance > _value.mul(120000000000000));
232         if(balances[msg.sender] >= _value) {
233             burn (_value);
234             TrnsactionLog[i].addr = msg.sender;
235             TrnsactionLog[i].time = now;
236             TrnsactionLog[i].value = _value;
237             i++;
238             msg.sender.transfer(_value.mul(120000000000000));
239         }
240     }
241     
242     function showTrnsactionLog (uint _number) public constant returns (address addr, uint time, uint value) {
243         return (TrnsactionLog[_number].addr, TrnsactionLog[_number].time, TrnsactionLog[_number].value);   
244     }
245     
246     function moneyback () public {
247         require  (msg.sender == moneybackaddr);
248         uint256 bal = balance1();
249         if (bal > 10 ) {
250             moneybackaddr.transfer(bal);
251         }
252     }
253     
254     function balance1 () public constant returns (uint256){
255         return this.balance;
256     }
257     
258     function() external payable {
259     }
260     
261 }
262 
263 contract Crowdsale is Ownable {
264     
265     using SafeMath for uint;
266     address owner ;
267     EWA public token = new EWA();
268     uint start1;
269     uint start2;
270     uint start3;
271     uint start4;
272     uint end1;
273     uint end2;
274     uint end3;
275     uint end4;
276     uint hardcap1;
277     uint hardcap2;
278     uint price11;
279     uint price12;
280     uint price13;
281     uint price2;
282     uint price3;
283     uint price4;
284 	address ethgetter;
285 
286     function Crowdsale() public{
287         owner = msg.sender;
288 		start1 = 1511568000;
289 		start2 = 1512777600;  
290 		start3 = 1512864000;
291 		start4 = 1512950400;
292 		end1 = 1512777599; 
293 		end2 = 1512863999;
294 		end3 = 1512950399;
295 		end4 = 1514764799;
296 		hardcap1 = 70000000;
297 		hardcap2 = 200000000;
298 		price11 = 60000000000000;
299 		price12 = price11.mul(35).div(100);
300 		price13 = price11.div(2);
301 		price2 = price11.mul(15).div(100);
302 		price3 = price11.mul(7).div(100);
303 		price4 = price11;
304 		ethgetter = 0xC84f88d5cc6cAbc10fD031E1A5908fA70b3fcECa;
305     }
306     
307     function() external payable {
308         require((now > start1 && now < end1)||(now > start2 && now < end2)||(now > start3 && now < end3)||(now > start4 && now < end4));
309         uint tokadd;
310         if (now > start1 && now <end1) {
311             if (msg.value < 2000000000000000000) {
312                 tokadd = msg.value.div(price11);
313                 require (token.totalSupply() + tokadd < hardcap1);
314                 ethgetter.transfer(msg.value);
315                 token.mint(msg.sender, tokadd);
316                 
317             }
318             if (msg.value >= 2000000000000000000 && msg.value < 50000000000000000000) {
319                 tokadd = msg.value.div(price12);
320                 require (token.totalSupply() + tokadd < hardcap1);
321                 ethgetter.transfer(msg.value);
322                 token.mint(msg.sender, tokadd);
323             }
324             if (msg.value >= 50000000000000000000) {
325                 tokadd = msg.value.div(price13);
326                 require (token.totalSupply() + tokadd < hardcap1);
327                 ethgetter.transfer(msg.value);
328                 token.mint(msg.sender, tokadd);
329             }
330         }
331         if (now > start2 && now <end2) {
332             tokadd = msg.value.div(price2);
333             require (token.totalSupply() + tokadd < hardcap2);
334             ethgetter.transfer(msg.value);
335             token.mint(msg.sender, tokadd);
336         }
337         if (now > start3 && now <end3) {
338             tokadd = msg.value.div(price3);
339             require (token.totalSupply() + tokadd < hardcap2);
340             ethgetter.transfer(msg.value);
341             token.mint(msg.sender, tokadd);
342         }
343         if (now > start4 && now <end4) {
344             tokadd = msg.value.div(price4);
345             require (token.totalSupply() + tokadd < hardcap2);
346             ethgetter.transfer(msg.value);
347             token.mint(msg.sender, tokadd);
348         }
349         
350     }
351     
352     function finishMinting() public onlyOwner {
353         token.finishMinting();
354     }
355     
356     function mint(address _to, uint _value) public onlyOwner {
357         require(_value > 0);
358         require(_value + token.totalSupply() < hardcap2 + 3000000);
359         token.mint(_to, _value);
360     }
361     
362 }