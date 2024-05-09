1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 library SafeMath {
18 
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal pure returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 contract Ownable {
48   address public owner;
49 
50 
51   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 
54   constructor() public {
55     owner = msg.sender;
56   }
57 
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   function transferOwnership(address newOwner) public onlyOwner {
64     require(newOwner != address(0));
65     emit OwnershipTransferred(owner, newOwner);
66     owner = newOwner;
67   }
68 
69 }
70 
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78 
79   function totalSupply() public view returns (uint256) {
80     return totalSupply_;
81   }
82 
83 
84   function transfer(address _to, uint256 _value) public returns (bool) {
85     require(_to != address(0));
86     require(_value <= balances[msg.sender]);
87 
88     // SafeMath.sub will throw if there is not enough balance.
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     emit Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95 
96   function balanceOf(address _owner) public view returns (uint256 balance) {
97     return balances[_owner];
98   }
99 
100 }
101 
102 contract BurnableToken is BasicToken {
103 
104   event Burn(address indexed burner, uint256 value);
105 
106   function burn(uint256 _value) public {
107     _burn(msg.sender, _value);
108   }
109 
110   function _burn(address _who, uint256 _value) internal {
111     require(_value <= balances[_who]);
112 
113     balances[_who] = balances[_who].sub(_value);
114     totalSupply_ = totalSupply_.sub(_value);
115     emit Burn(_who, _value);
116     emit Transfer(_who, address(0), _value);
117   }
118 }
119 
120 contract ERC20Implementation is ERC20, BurnableToken, Ownable {
121 
122   mapping (address => mapping (address => uint256)) internal allowed;
123 
124   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
125     require(_to != address(0));
126     require(_value <= balances[_from]);
127     require(_value <= allowed[_from][msg.sender]);
128 
129     balances[_from] = balances[_from].sub(_value);
130     balances[_to] = balances[_to].add(_value);
131     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
132     emit Transfer(_from, _to, _value);
133     return true;
134   }
135 
136   function approve(address _spender, uint256 _value) public returns (bool) {
137     allowed[msg.sender][_spender] = _value;
138     emit Approval(msg.sender, _spender, _value);
139     return true;
140   }
141 
142   function allowance(address _owner, address _spender) public view returns (uint256) {
143     return allowed[_owner][_spender];
144   }
145 
146   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
147     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
148     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
149     return true;
150   }
151 
152   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 }
163 
164 
165 
166 contract BasicFreezableToken is ERC20Implementation {
167 
168   address[] internal investors;
169   mapping (address => bool) internal isInvestor;
170   bool frozen;
171 
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(!frozen);
174     require(_to != address(0));
175     require(_value <= balances[msg.sender]);
176     
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183 }
184 
185 contract ERC20FreezableImplementation is BasicFreezableToken {
186 
187   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
188     require(!frozen);
189     require(_to != address(0));
190     require(_value <= balances[_from]);
191     require(_value <= allowed[_from][msg.sender]);
192 
193     balances[_from] = balances[_from].sub(_value);
194     balances[_to] = balances[_to].add(_value);
195     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
196     emit Transfer(_from, _to, _value);
197     return true;
198   }
199 
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     require(!frozen);
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
208     require(!frozen);
209     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
215     require(!frozen);
216     uint oldValue = allowed[msg.sender][_spender];
217     if (_subtractedValue > oldValue) {
218       allowed[msg.sender][_spender] = 0;
219     } else {
220       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
221     }
222     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223     return true;
224   }
225 
226 
227   function freeze() onlyOwner public {
228     frozen = true;
229   }
230 
231 
232   function unFreeze() onlyOwner public {
233     frozen = false;
234   }
235 
236 }
237 
238 contract OIOToken is ERC20FreezableImplementation {
239 
240   string public name;
241   string public symbol;
242   uint8 public decimals;
243   
244   
245   constructor(address[] _investors, uint256[] _tokenAmount, uint256 _totalSupply, string _name, string _symbol, uint8 _decimals) public {
246     require(_investors.length == _tokenAmount.length);
247 
248     name = _name;
249     symbol = _symbol;
250     decimals = _decimals;
251     
252     uint256 dif = 0;
253     totalSupply_ = _totalSupply;
254     for (uint i=0; i<_investors.length; i++) {
255       balances[_investors[i]] = balances[_investors[i]].add(_tokenAmount[i]);
256       isInvestor[_investors[i]] = true;
257       investors.push(_investors[i]);
258       dif = dif.add(_tokenAmount[i]);
259     }
260     balances[msg.sender] = totalSupply_.sub(dif);
261     isInvestor[msg.sender] = true;
262     investors.push(msg.sender);
263     frozen = false;
264   }
265 
266   
267   function transferBack(address _from, uint256 _tokenAmount) onlyOwner public {
268     require(_from != address(0));
269     require(_tokenAmount <= balances[_from]);
270     
271     balances[_from] = balances[_from].sub(_tokenAmount);
272     balances[msg.sender] = balances[msg.sender].add(_tokenAmount);
273     emit Transfer(_from, msg.sender, _tokenAmount);
274   }
275 
276  
277   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
278     require(!frozen);
279     require(_to != address(0));
280     require(_value <= balances[_from]);
281     require(_value <= allowed[_from][msg.sender]);
282 
283     balances[_from] = balances[_from].sub(_value);
284     balances[_to] = balances[_to].add(_value);
285     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
286     if (!isInvestor[_to]) {
287       isInvestor[_to] = true;
288       investors.push(_to);
289     }
290     emit Transfer(_from, _to, _value);
291     return true;
292   }
293 
294  
295   function transfer(address _to, uint256 _value) public returns (bool) {
296     require(!frozen);
297     require(_to != address(0));
298     require(_value <= balances[msg.sender]);
299 
300     balances[msg.sender] = balances[msg.sender].sub(_value);
301     balances[_to] = balances[_to].add(_value);
302     if (!isInvestor[_to]) {
303       isInvestor[_to] = true;
304       investors.push(_to);
305     }
306     emit Transfer(msg.sender, _to, _value);
307     return true;
308   }
309 
310   
311   function transferBulk(address[] _toAccounts, uint256[] _tokenAmount) onlyOwner public {
312     require(_toAccounts.length == _tokenAmount.length);
313     for(uint i=0; i<_toAccounts.length; i++) {
314       balances[msg.sender] = balances[msg.sender].sub(_tokenAmount[i]); 
315       balances[_toAccounts[i]] = balances[_toAccounts[i]].add(_tokenAmount[i]);
316       if(!isInvestor[_toAccounts[i]]){
317         isInvestor[_toAccounts[i]] = true;
318         investors.push(_toAccounts[i]);
319       }
320     }
321   }
322 
323   
324   function getInvestorsAndTheirBalances() public view returns (address[], uint[]) {
325       uint[] memory tempBalances = new uint[](investors.length);
326       for(uint i=0; i<investors.length; i++) {
327         tempBalances[i] = balances[investors[i]];
328       }
329        return (investors, tempBalances);
330   }
331 
332 }