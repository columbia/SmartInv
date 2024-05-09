1 /*** 
2 
3 d.RAY Rendering Service | Visit d.Ray @ https://dray.digital/
4 
5 ***/
6 
7 pragma solidity ^0.4.23;
8 
9 
10 
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 contract ERC20 is ERC20Basic {
19   function allowance(address owner, address spender)
20     public view returns (uint256);
21 
22   function transferFrom(address from, address to, uint256 value)
23     public returns (bool);
24 
25   function approve(address spender, uint256 value) public returns (bool);
26   event Approval(
27     address indexed owner,
28     address indexed spender,
29     uint256 value
30   );
31 }
32 
33 contract BasicToken is ERC20Basic {
34   using SafeMath for uint256;
35 
36   mapping(address => uint256) balances;
37 
38   uint256 totalSupply_;
39 
40   function totalSupply() public view returns (uint256) {
41     return totalSupply_;
42   }
43 
44   function transfer(address _to, uint256 _value) public returns (bool) {
45     require(_to != address(0));
46     require(_value <= balances[msg.sender]);
47 
48     balances[msg.sender] = balances[msg.sender].sub(_value);
49     balances[_to] = balances[_to].add(_value);
50     emit Transfer(msg.sender, _to, _value);
51     return true;
52   }
53 
54   function balanceOf(address _owner) public view returns (uint256) {
55     return balances[_owner];
56   }
57 
58 }
59 
60 contract BurnableToken is BasicToken {
61 
62   event Burn(address indexed burner, uint256 value);
63 
64   function burn(uint256 _value) public {
65     _burn(msg.sender, _value);
66   }
67 
68   function _burn(address _who, uint256 _value) internal {
69     require(_value <= balances[_who]);
70 
71     balances[_who] = balances[_who].sub(_value);
72     totalSupply_ = totalSupply_.sub(_value);
73     emit Burn(_who, _value);
74     emit Transfer(_who, address(0), _value);
75   }
76 }
77 
78 contract Ownable {
79   address public owner;
80 
81 
82   event OwnershipRenounced(address indexed previousOwner);
83   event OwnershipTransferred(
84     address indexed previousOwner,
85     address indexed newOwner
86   );
87 
88   constructor() public {
89     owner = msg.sender;
90   }
91 
92   modifier onlyOwner() {
93     require(msg.sender == owner);
94     _;
95   }
96 
97   function renounceOwnership() public onlyOwner {
98     emit OwnershipRenounced(owner);
99     owner = address(0);
100   }
101 
102   function transferOwnership(address _newOwner) public onlyOwner {
103     _transferOwnership(_newOwner);
104   }
105 
106   function _transferOwnership(address _newOwner) internal {
107     require(_newOwner != address(0));
108     emit OwnershipTransferred(owner, _newOwner);
109     owner = _newOwner;
110   }
111   
112   
113   
114 }
115 
116 contract StandardToken is ERC20, BasicToken {
117 
118   mapping (address => mapping (address => uint256)) internal allowed;
119 
120   function transferFrom(
121     address _from,
122     address _to,
123     uint256 _value
124   )
125     public
126     returns (bool)
127   {
128     require(_to != address(0));
129     require(_value <= balances[_from]);
130     require(_value <= allowed[_from][msg.sender]);
131 
132     balances[_from] = balances[_from].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   function approve(address _spender, uint256 _value) public returns (bool) {
140     allowed[msg.sender][_spender] = _value;
141     emit Approval(msg.sender, _spender, _value);
142     return true;
143   }
144 
145   function allowance(
146     address _owner,
147     address _spender
148    )
149     public
150     view
151     returns (uint256)
152   {
153     return allowed[_owner][_spender];
154   }
155 
156   function increaseApproval(
157     address _spender,
158     uint _addedValue
159   )
160     public
161     returns (bool)
162   {
163     allowed[msg.sender][_spender] = (
164       allowed[msg.sender][_spender].add(_addedValue));
165     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
166     return true;
167   }
168 
169   function decreaseApproval(
170     address _spender,
171     uint _subtractedValue
172   )
173     public
174     returns (bool)
175   {
176     uint oldValue = allowed[msg.sender][_spender];
177     if (_subtractedValue > oldValue) {
178       allowed[msg.sender][_spender] = 0;
179     } else {
180       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
181     }
182     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183     return true;
184   }
185 
186 }
187 
188 contract MintableToken is StandardToken, Ownable {
189   event Mint(address indexed to, uint256 amount);
190   event MintFinished();
191 
192   bool public mintingFinished = false;
193 
194 
195   modifier canMint() {
196     require(!mintingFinished);
197     _;
198   }
199 
200   modifier hasMintPermission() {
201     require(msg.sender == owner);
202     _;
203   }
204 
205   function mint(
206     address _to,
207     uint256 _amount
208   )
209     hasMintPermission
210     canMint
211     public
212     returns (bool)
213   {
214     totalSupply_ = totalSupply_.add(_amount);
215     balances[_to] = balances[_to].add(_amount);
216     emit Mint(_to, _amount);
217     emit Transfer(address(0), _to, _amount);
218     return true;
219   }
220 
221   function finishMinting() onlyOwner canMint public returns (bool) {
222     mintingFinished = true;
223     emit MintFinished();
224     return true;
225   }
226 }
227 
228 library SafeERC20 {
229   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
230     require(token.transfer(to, value));
231   }
232 
233   function safeTransferFrom(
234     ERC20 token,
235     address from,
236     address to,
237     uint256 value
238   )
239     internal
240   {
241     require(token.transferFrom(from, to, value));
242   }
243 
244   function safeApprove(ERC20 token, address spender, uint256 value) internal {
245     require(token.approve(spender, value));
246   }
247 }
248 
249 library SafeMath {
250 
251   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
252     if (a == 0) {
253       return 0;
254     }
255 
256     c = a * b;
257     assert(c / a == b);
258     return c;
259   }
260 
261 
262   function div(uint256 a, uint256 b) internal pure returns (uint256) {
263 
264     return a / b;
265   }
266 
267   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268     assert(b <= a);
269     return a - b;
270   }
271 
272   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
273     c = a + b;
274     assert(c >= a);
275     return c;
276   }
277 }
278 
279 contract dRAY is StandardToken, BurnableToken, MintableToken {
280   string public name = "dRAY"; 
281   string public symbol = "DRAY";
282   uint public decimals = 4;
283   uint public INITIAL_SUPPLY = 3000000000;
284 
285 
286 constructor() public {
287   totalSupply_ = 30000000000;
288   balances[msg.sender] = INITIAL_SUPPLY;
289 }
290 }
291 
292 contract TokenTimelock {
293   using SafeERC20 for ERC20Basic;
294   ERC20Basic public token;
295   address public beneficiary;
296   uint256 public releaseTime;
297 
298   constructor(
299     ERC20Basic _token,
300     address _beneficiary,
301     uint256 _releaseTime
302   )
303     public
304   {
305     require(_releaseTime > block.timestamp);
306     token = _token;
307     beneficiary = _beneficiary;
308     releaseTime = _releaseTime;
309   }
310 
311   function release() public {
312     require(block.timestamp >= releaseTime);
313 
314     uint256 amount = 1000;
315     require(amount > 0);
316 
317     token.safeTransfer(beneficiary, amount);
318   }
319 }