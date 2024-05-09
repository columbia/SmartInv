1 pragma solidity 0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6  */
7 
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
10         if (a == 0) {
11             return 0;
12         }
13         c = a * b;
14         assert(c / a == b);
15         return c;
16     }
17 
18     function div(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a / b;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
28         c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 /**
35  * @title Ownable
36  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol */
37 contract Ownable {
38     address public owner;
39 
40     constructor() public {
41         owner = msg.sender;
42     }
43 
44     modifier onlyOwner() {
45         require(msg.sender == owner);
46         _;
47     }
48 }
49 
50 /**
51  * @title Pausable
52  * @dev Base contract which allows children to implement an emergency stop mechanism. */
53 contract Pausable is Ownable {
54     event Pause();
55     event Unpause();
56 
57     bool public paused = false;
58 
59     modifier whenNotPaused() {
60         require(!paused);
61         _;
62     }
63 
64     modifier whenPaused() {
65         require(paused);
66         _;
67     }
68 
69     function pause() onlyOwner whenNotPaused public {
70         paused = true;
71         emit Pause();
72     }
73 
74     function unpause() onlyOwner whenPaused public {
75         paused = false;
76         emit Unpause();
77     }
78 }
79 /**
80  * @title ERC20Basic
81  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
82  */
83 contract ERC20Basic {
84     function totalSupply() public view returns (uint256);
85     function balanceOf(address who) public view returns (uint256);
86     function transfer(address to, uint256 value) public returns (bool);
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 /**
90  * @title Basic token
91  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
92  */
93 contract BasicToken is ERC20Basic {
94     using SafeMath for uint256;
95 
96     mapping(address => uint256) balances;
97 
98     uint256 totalSupply_;
99 
100     function totalSupply() public view returns (uint256) {
101         return totalSupply_;
102     }
103 
104     function transfer(address _to, uint256 _value) public returns (bool) {
105         require(_to != address(0));
106         require(_value <= balances[msg.sender]);
107 
108         balances[msg.sender] = balances[msg.sender].sub(_value);
109         balances[_to] = balances[_to].add(_value);
110         emit Transfer(msg.sender, _to, _value);
111         return true;
112     }
113 
114     function balanceOf(address _owner) public view returns (uint256) {
115         return balances[_owner];
116     }
117 }
118 /**
119  * @title ERC20 interface
120  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
121  */
122 contract ERC20 is ERC20Basic {
123     function allowance(address owner, address spender) public view returns (uint256);
124     function transferFrom(address from, address to, uint256 value) public returns (bool);
125     function approve(address spender, uint256 value) public returns (bool);
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 /**
130  * @title Standard ERC20 token
131  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
132  */
133 contract StandardToken is ERC20, BasicToken {
134 
135     mapping (address => mapping (address => uint256)) internal allowed;
136 
137     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
138         require(_to != address(0));
139         require(_value <= balances[_from]);
140         require(_value <= allowed[_from][msg.sender]);
141 
142         balances[_from] = balances[_from].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
145         emit Transfer(_from, _to, _value);
146         return true;
147     }
148 
149     function approve(address _spender, uint256 _value) public returns (bool) {
150         allowed[msg.sender][_spender] = _value;
151         emit Approval(msg.sender, _spender, _value);
152         return true;
153     }
154 
155     function allowance(address _owner, address _spender) public view returns (uint256) {
156         return allowed[_owner][_spender];
157     }
158 
159     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
160         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
161         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
162         return true;
163     }
164 
165     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
166         uint oldValue = allowed[msg.sender][_spender];
167         if (_subtractedValue > oldValue) {
168             allowed[msg.sender][_spender] = 0;
169         } else {
170             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
171         }
172         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
173         return true;
174     }
175 }
176 
177 /**
178  * @title Pausable token
179  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/PausableToken.sol
180  **/
181 contract PausableToken is StandardToken, Pausable {
182 
183     function transfer(
184         address _to,
185         uint256 _value
186     ) public  whenNotPaused returns (bool)
187     {
188         return super.transfer(_to, _value);
189     }
190 
191     function transferFrom(
192         address _from,
193         address _to,
194         uint256 _value
195     ) public whenNotPaused returns (bool)
196     {
197         return super.transferFrom(_from, _to, _value);
198     }
199 
200     function approve(
201         address _spender,
202         uint256 _value
203     ) public whenNotPaused returns (bool)
204     {
205         return super.approve(_spender, _value);
206     }
207 
208     function increaseApproval(
209         address _spender,
210         uint _addedValue
211     ) public whenNotPaused returns (bool success)
212     {
213         return super.increaseApproval(_spender, _addedValue);
214     }
215 
216     function decreaseApproval(
217         address _spender,
218         uint _subtractedValue
219     ) public whenNotPaused returns (bool success)
220     {
221         return super.decreaseApproval(_spender, _subtractedValue);
222     }
223 }
224 
225 /**
226  * @title Burnable Token
227  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
228  */
229 contract BurnableToken is BasicToken {
230 
231     event Burn(address indexed burner, uint256 value);
232 
233     function burn(uint256 _value) public {
234         _burn(msg.sender, _value);
235     }
236 
237     function _burn(address _who, uint256 _value) internal {
238         require(_value <= balances[_who]);
239 
240         balances[_who] = balances[_who].sub(_value);
241         totalSupply_ = totalSupply_.sub(_value);
242         emit Burn(_who, _value);
243         emit Transfer(_who, address(0), _value);
244     }
245 }
246 /**
247  * @title Mintable token
248  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/MintableToken.sol
249  */
250 contract MintableToken is PausableToken {
251     event Mint(address indexed to, uint256 amount);
252     event MintFinished();
253 
254     bool public mintingFinished = false;
255 
256     modifier canMint() {
257         require(!mintingFinished);
258         _;
259     }
260 
261     modifier hasMintPermission() {
262         require(msg.sender == owner);
263         _;
264     }
265 
266     function finishMinting() onlyOwner canMint public returns (bool) {
267         mintingFinished = true;
268         emit MintFinished();
269         return true;
270     }
271 }
272 
273 /**
274 * @title VIONcoinToken
275 */
276 contract VIONcoin is MintableToken, BurnableToken {
277 
278     using SafeMath for uint256;
279 
280     string  public name = "VIONcoin";
281     string  public symbol = "VION";
282     uint256 constant public decimals = 18;
283     uint256 constant dec = 10**decimals;
284     uint256 public constant initialSupply = 570000000*dec; // 570,000,000 VION
285     address public crowdsaleAddress;
286 
287     modifier onlyICO() {
288         require(msg.sender == crowdsaleAddress);
289         _;
290     }
291 
292     constructor() public {
293         pause();
294     }
295 
296     function setSaleAddress(address _saleaddress) public onlyOwner{
297         crowdsaleAddress = _saleaddress;
298     }
299 
300     function mintFromICO(address _to, uint256 _amount) onlyICO canMint public returns (bool) {
301         require(balances[_to].add(_amount) != 0);
302         require(balances[_to].add(_amount) > balances[_to]);
303         require(totalSupply_ <= initialSupply);
304         totalSupply_ = totalSupply_.add(_amount);
305         balances[_to] = balances[_to].add(_amount);
306         emit Mint(_to, _amount);
307         emit Transfer(address(0), _to, _amount);
308         return true;
309     }
310 }