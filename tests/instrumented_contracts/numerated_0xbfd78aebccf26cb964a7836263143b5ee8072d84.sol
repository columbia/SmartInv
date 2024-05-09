1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6     if (a == 0) {
7       return 0;
8     }
9 
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     return a / b;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
25     c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Ownable {
32   address public owner;
33 
34   event OwnershipRenounced(address indexed previousOwner);
35   event OwnershipTransferred(
36     address indexed previousOwner,
37     address indexed newOwner
38   );
39 
40 
41   constructor() public {
42     owner = msg.sender;
43   }
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   function renounceOwnership() public onlyOwner {
51     emit OwnershipRenounced(owner);
52     owner = address(0);
53   }
54 
55   function transferOwnership(address _newOwner) public onlyOwner {
56     _transferOwnership(_newOwner);
57   }
58 
59   function _transferOwnership(address _newOwner) internal {
60     require(_newOwner != address(0));
61     emit OwnershipTransferred(owner, _newOwner);
62     owner = _newOwner;
63   }
64 }
65 
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72   modifier whenNotPaused() {
73     require(!paused);
74     _;
75   }
76 
77   modifier whenPaused() {
78     require(paused);
79     _;
80   }
81 
82   function pause() onlyOwner whenNotPaused public {
83     paused = true;
84     emit Pause();
85   }
86 
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     emit Unpause();
90   }
91 }
92 
93 contract ERC20Basic {
94   function totalSupply() public view returns (uint256);
95   function balanceOf(address who) public view returns (uint256);
96   function transfer(address to, uint256 value) public returns (bool);
97   event Transfer(address indexed from, address indexed to, uint256 value);
98 }
99 
100 contract ERC20 is ERC20Basic {
101   function allowance(address owner, address spender)
102     public view returns (uint256);
103 
104   function transferFrom(address from, address to, uint256 value)
105     public returns (bool);
106 
107   function approve(address spender, uint256 value) public returns (bool);
108   event Approval(
109     address indexed owner,
110     address indexed spender,
111     uint256 value
112   );
113 }
114 
115 
116 contract BasicToken is ERC20Basic {
117   using SafeMath for uint256;
118 
119   mapping(address => uint256) balances;
120 
121   uint256 totalSupply_;
122 
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_value <= balances[msg.sender]);
129     require(_to != address(0));
130 
131     balances[msg.sender] = balances[msg.sender].sub(_value);
132     balances[_to] = balances[_to].add(_value);
133     emit Transfer(msg.sender, _to, _value);
134     return true;
135   }
136 
137   function balanceOf(address _owner) public view returns (uint256) {
138     return balances[_owner];
139   }
140 
141 }
142 
143 
144 contract StandardToken is ERC20, BasicToken {
145 
146   mapping (address => mapping (address => uint256)) internal allowed;
147 
148   function transferFrom(
149     address _from,
150     address _to,
151     uint256 _value
152   )
153     public
154     returns (bool)
155   {
156     require(_value <= balances[_from]);
157     require(_value <= allowed[_from][msg.sender]);
158     require(_to != address(0));
159 
160     balances[_from] = balances[_from].sub(_value);
161     balances[_to] = balances[_to].add(_value);
162     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
163     emit Transfer(_from, _to, _value);
164     return true;
165   }
166 
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     emit Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   function allowance(
174     address _owner,
175     address _spender
176    )
177     public
178     view
179     returns (uint256)
180   {
181     return allowed[_owner][_spender];
182   }
183 
184   function increaseApproval(
185     address _spender,
186     uint256 _addedValue
187   )
188     public
189     returns (bool)
190   {
191     allowed[msg.sender][_spender] = (
192       allowed[msg.sender][_spender].add(_addedValue));
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197   function decreaseApproval(
198     address _spender,
199     uint256 _subtractedValue
200   )
201     public
202     returns (bool)
203   {
204     uint256 oldValue = allowed[msg.sender][_spender];
205     if (_subtractedValue >= oldValue) {
206       allowed[msg.sender][_spender] = 0;
207     } else {
208       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
209     }
210     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
211     return true;
212   }
213 
214 }
215 
216 contract PausableToken is StandardToken, Pausable {
217 
218   function transfer(
219     address _to,
220     uint256 _value
221   )
222     public
223     whenNotPaused
224     returns (bool)
225   {
226     return super.transfer(_to, _value);
227   }
228 
229   function transferFrom(
230     address _from,
231     address _to,
232     uint256 _value
233   )
234     public
235     whenNotPaused
236     returns (bool)
237   {
238     return super.transferFrom(_from, _to, _value);
239   }
240 
241   function approve(
242     address _spender,
243     uint256 _value
244   )
245     public
246     whenNotPaused
247     returns (bool)
248   {
249     return super.approve(_spender, _value);
250   }
251 
252   function increaseApproval(
253     address _spender,
254     uint _addedValue
255   )
256     public
257     whenNotPaused
258     returns (bool success)
259   {
260     return super.increaseApproval(_spender, _addedValue);
261   }
262 
263   function decreaseApproval(
264     address _spender,
265     uint _subtractedValue
266   )
267     public
268     whenNotPaused
269     returns (bool success)
270   {
271     return super.decreaseApproval(_spender, _subtractedValue);
272   }
273 }
274 
275 
276 contract PeraToken is PausableToken {
277 
278   string public constant name = "PERA";
279   string public constant symbol = "PERA";
280   uint8 public constant decimals = 8;
281   uint256 public constant INITIAL_SUPPLY = 92853735500000000;
282 
283   mapping (address => bool) public frozenAccount;
284 
285   event FrozenFunds(address target, bool frozen);
286 
287   event Transfer(
288         address indexed _from,
289         address indexed _to,
290         uint256 _value
291     );
292 
293   event Approval(
294         address indexed _owner,
295         address indexed _spender,
296         uint256 _value
297     );
298 
299   constructor() public {
300     totalSupply_ = INITIAL_SUPPLY;
301     balances[msg.sender] = INITIAL_SUPPLY;
302     emit Transfer(address(0), msg.sender, INITIAL_SUPPLY);
303   }
304 
305   //implemented the functionality, which checks whether a transfer goes to a contract
306   function transfer(address _to, uint256 _value) public returns (bool)
307   {
308     require(!isContract(_to));
309     require(!frozenAccount[msg.sender]);                     // Check if sender is frozen
310     require(!frozenAccount[_to]);                       // Check if recipient is frozen
311     return super.transfer(_to, _value);
312   }
313 
314   //this function specifies the possibility of a complete data set transfer
315   //the web3_batch_function explains how you use this function
316   function batchTransfer(address[] _tos, uint256[] _amount) onlyOwner public whenNotPaused returns (bool success) {
317     require(_tos.length == _amount.length);
318     uint256 i;
319     uint256 sum = 0;
320 
321     for(i = 0; i < _amount.length; i++){
322         sum = sum.add(_amount[i]);
323         require(_tos[i] != address(0));
324     }
325 
326     require(balances[msg.sender] >= sum);
327 
328     for(i = 0; i < _tos.length; i++){
329         transfer(_tos[i], _amount[i]);
330     }
331 
332     return true;
333   }
334 
335   //false and true as arguments for freeze
336   function freezeAccount(address target, bool freeze) onlyOwner public {
337         frozenAccount[target] = freeze;
338         emit FrozenFunds(target, freeze);
339     }
340 
341   //as mentioned in the erc223 standard you need a function that checks whether an receiving wallet address is a contract
342   function isContract(address _addr) internal view returns(bool is_contract){
343         uint length;
344         assembly {
345             //retrieve the code length/size on target address
346             length := extcodesize(_addr)
347         }
348       return (length>0);
349   }
350 }