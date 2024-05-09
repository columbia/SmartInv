1 pragma solidity ^0.4.24;
2 
3 /**
4 * < 헬스메디 토큰 >
5 * Symbol : HM
6 * Name : HealthMediToken
7 * Total Supply : 10,000,000,000.000000000000000000
8 * 작성일 : 2018.05.31 
9 * 수정일 : 2018.08.23 
10 **/
11 
12 contract ERC20Basic {
13   function totalSupply() public view returns (uint256);
14   function balanceOf(address who) public view returns (uint256);
15   function transfer(address to, uint256 value) public returns (bool);
16   event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender)
21     public view returns (uint256);
22 
23   function transferFrom(address from, address to, uint256 value)
24     public returns (bool);
25 
26   function approve(address spender, uint256 value) public returns (bool);
27   event Approval(
28     address indexed owner,
29     address indexed spender,
30     uint256 value
31   );
32 }
33 
34 library SafeMath {
35 
36   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
37     if (a == 0) {
38       return 0;
39     }
40     c = a * b;
41     assert(c / a == b);
42     return c;
43   }
44 
45   function div(uint256 a, uint256 b) internal pure returns (uint256) {
46     return a / b;
47   }
48 
49   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50     assert(b <= a);
51     return a - b;
52   }
53 
54   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     c = a + b;
56     assert(c >= a);
57     return c;
58   }
59 }
60 
61 contract BasicToken is ERC20Basic {
62   using SafeMath for uint256;
63 
64   mapping(address => uint256) balances;
65 
66   uint256 totalSupply_;
67   
68   modifier onlyPayloadSize(uint size) {
69       assert(msg.data.length >= size + 4);
70       _;
71   }
72 
73   function totalSupply() public view returns (uint256) {
74     return totalSupply_;
75   }
76 
77   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     emit Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   function balanceOf(address _owner) public view returns (uint256) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract StandardToken is ERC20, BasicToken {
94 
95   mapping (address => mapping (address => uint256)) internal allowed;
96 
97   function transferFrom(
98     address _from,
99     address _to,
100     uint256 _value
101   )
102     public
103     returns (bool)
104   {
105     require(_to != address(0));
106     require(_value <= balances[_from]);
107     require(_value <= allowed[_from][msg.sender]);
108 
109     balances[_from] = balances[_from].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112     emit Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   function approve(address _spender, uint256 _value) public returns (bool) {
117     allowed[msg.sender][_spender] = _value;
118     emit Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   function allowance(
123     address _owner,
124     address _spender
125    )
126     public
127     view
128     returns (uint256)
129   {
130     return allowed[_owner][_spender];
131   }
132 
133   function increaseApproval(
134     address _spender,
135     uint _addedValue
136   )
137     public
138     returns (bool)
139   {
140     allowed[msg.sender][_spender] = (
141       allowed[msg.sender][_spender].add(_addedValue));
142     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
143     return true;
144   }
145 
146   function decreaseApproval(
147     address _spender,
148     uint _subtractedValue
149   )
150     public
151     returns (bool)
152   {
153     uint oldValue = allowed[msg.sender][_spender];
154     if (_subtractedValue > oldValue) {
155       allowed[msg.sender][_spender] = 0;
156     } else {
157       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
158     }
159     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160     return true;
161   }
162 
163 }
164 
165 contract BurnableToken is BasicToken {
166 
167   event Burn(address indexed burner, uint256 value);
168 
169   function burn(uint256 _value) public {
170     _burn(msg.sender, _value);
171   }
172 
173   function _burn(address _who, uint256 _value) internal {
174     require(_value <= balances[_who]);
175 
176     balances[_who] = balances[_who].sub(_value);
177     totalSupply_ = totalSupply_.sub(_value);
178     emit Burn(_who, _value);
179     emit Transfer(_who, address(0), _value);
180   }
181 }
182 
183 contract StandardBurnableToken is BurnableToken, StandardToken {
184 
185   function burnFrom(address _from, uint256 _value) public {
186     require(_value <= allowed[_from][msg.sender]);
187     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
188     _burn(_from, _value);
189   }
190 }
191 
192 
193 contract Ownable {
194   address public owner;
195 
196   event OwnershipRenounced(address indexed previousOwner);
197   event OwnershipTransferred(
198     address indexed previousOwner,
199     address indexed newOwner
200   );
201 
202   constructor() public {
203     owner = msg.sender;
204   }
205 
206   modifier onlyOwner() {
207     require(msg.sender == owner);
208     _;
209   }
210 
211   function transferOwnership(address newOwner) public onlyOwner {
212     require(newOwner != address(0));
213     emit OwnershipTransferred(owner, newOwner);
214     owner = newOwner;
215   }
216 
217   function renounceOwnership() public onlyOwner {
218     emit OwnershipRenounced(owner);
219     owner = address(0);
220   }
221 }
222 
223 contract MintableToken is StandardToken, Ownable {
224   event Mint(address indexed to, uint256 amount);
225   event MintFinished();
226 
227   bool public mintingFinished = false;
228 
229 
230   modifier canMint() {
231     require(!mintingFinished);
232     _;
233   }
234 
235   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
236     totalSupply_ = totalSupply_.add(_amount);
237     balances[_to] = balances[_to].add(_amount);
238     emit Mint(_to, _amount);
239     emit Transfer(address(0), _to, _amount);
240     return true;
241   }
242 
243   function finishMinting() onlyOwner canMint public returns (bool) {
244     mintingFinished = true;
245     emit MintFinished();
246     return true;
247   }
248 }
249 
250 contract Blacklisted is Ownable {
251 
252   mapping(address => bool) public blacklist;
253 
254   /**
255   * @dev Throws if called by any account other than the owner.
256   */
257   modifier notBlacklisted() {
258     require(blacklist[msg.sender] == false);
259     _;
260   }
261 
262   /**
263    * @dev Adds single address to blacklist.
264    * @param _villain Address to be added to the blacklist
265    */
266   function addToBlacklist(address _villain) external onlyOwner {
267     blacklist[_villain] = true;
268   }
269 
270   /**
271    * @dev Adds list of addresses to blacklist. Not overloaded due to limitations with truffle testing.
272    * @param _villains Addresses to be added to the blacklist
273    */
274   function addManyToBlacklist(address[] _villains) external onlyOwner {
275     for (uint256 i = 0; i < _villains.length; i++) {
276       blacklist[_villains[i]] = true;
277     }
278   }
279 
280   /**
281    * @dev Removes single address from blacklist.
282    * @param _villain Address to be removed to the blacklist
283    */
284   function removeFromBlacklist(address _villain) external onlyOwner {
285     blacklist[_villain] = false;
286   }
287 }
288 
289 contract HealthMediToken is Ownable, StandardBurnableToken, MintableToken, Blacklisted {
290     
291     string public name = "HealthMediToken";
292     string public symbol = "HM";
293     uint public decimals = 18;
294     uint public INITIAL_SUPPLY = 10000000000 * 10 ** uint(decimals);
295     
296     bool public isUnlocked = false;
297     
298     constructor() public {
299         totalSupply_ = INITIAL_SUPPLY;
300         balances[msg.sender] = totalSupply_;
301     }
302     
303     modifier onlyTransferable() {
304         require(isUnlocked);
305         _;
306     }
307 
308     function transferFrom(address _from, address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
309       return super.transferFrom(_from, _to, _value);
310     }
311     
312     function transfer(address _to, uint256 _value) public onlyTransferable notBlacklisted returns (bool) {
313       return super.transfer(_to, _value);
314     }
315     
316     function unlockTransfer() public onlyOwner {
317       isUnlocked = true;
318     }
319     
320     function lockTransfer() public onlyOwner {
321       isUnlocked = false;
322     }
323 }