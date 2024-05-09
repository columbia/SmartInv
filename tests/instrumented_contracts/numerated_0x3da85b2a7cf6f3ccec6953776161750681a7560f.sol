1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol
6  */
7 library SafeMath {
8 
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
36  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/ownership/Ownable.sol
37  */
38 contract Ownable {
39     address public owner;
40 
41     constructor() public {
42         owner = msg.sender;
43     }
44 
45     modifier onlyOwner() {
46         require(msg.sender == owner);
47         _;
48     }
49 }
50 
51 /**
52  * @title Pausable
53  * @dev Base contract which allows children to implement an emergency stop mechanism.
54  */
55 contract Pausable is Ownable {
56     event Pause();
57     event Unpause();
58 
59     bool public paused = false;
60 
61     modifier whenNotPaused() {
62         require(!paused);
63         _;
64     }
65 
66     modifier whenPaused() {
67         require(paused);
68         _;
69     }
70 
71     function pause() onlyOwner whenNotPaused public {
72         paused = true;
73         emit Pause();
74     }
75 
76     function unpause() onlyOwner whenPaused public {
77         paused = false;
78         emit Unpause();
79     }
80 }
81 
82 /**
83  * @title ERC20Basic
84  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20Basic.sol
85  */
86 contract ERC20Basic {
87     function totalSupply() public view returns (uint256);
88     function balanceOf(address who) public view returns (uint256);
89     function transfer(address to, uint256 value) public returns (bool);
90     event Transfer(address indexed from, address indexed to, uint256 value);
91 }
92 
93 /**
94  * @title Basic token
95  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BasicToken.sol
96  */
97 contract BasicToken is ERC20Basic {
98     using SafeMath for uint256;
99 
100     mapping(address => uint256) balances;
101 
102     uint256 totalSupply_;
103 
104     function totalSupply() public view returns (uint256) {
105         return totalSupply_;
106     }
107 
108     function transfer(address _to, uint256 _value) public returns (bool) {
109         require(_to != address(0));
110         require(_value <= balances[msg.sender]);
111         balances[msg.sender] = balances[msg.sender].sub(_value);
112         balances[_to] = balances[_to].add(_value);
113         emit Transfer(msg.sender, _to, _value);
114         return true;
115     }
116 
117     function balanceOf(address _owner) public view returns (uint256) {
118         return balances[_owner];
119     }
120 }
121 
122 /**
123  * @title ERC20 interface
124  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
125  */
126 contract ERC20 is ERC20Basic {
127     function allowance(address owner, address spender) public view returns (uint256);
128     function transferFrom(address from, address to, uint256 value) public returns (bool);
129     function approve(address spender, uint256 value) public returns (bool);
130     event Approval(address indexed owner, address indexed spender, uint256 value);
131 }
132 
133 /**
134  * @title Standard ERC20 token
135  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/StandardToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139     mapping (address => mapping (address => uint256)) internal allowed;
140 
141     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
142         require(_to != address(0));
143         require(_value <= balances[_from]);
144         require(_value <= allowed[_from][msg.sender]);
145         balances[_from] = balances[_from].sub(_value);
146         balances[_to] = balances[_to].add(_value);
147         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function allowance(address _owner, address _spender) public view returns (uint256) {
159         return allowed[_owner][_spender];
160     }
161 
162     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
163         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
164         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
165         return true;
166     }
167 
168     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
169         uint oldValue = allowed[msg.sender][_spender];
170         if (_subtractedValue > oldValue) {
171             allowed[msg.sender][_spender] = 0;
172         } else {
173             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
174         }
175         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
176         return true;
177     }
178 }
179 
180 /**
181  * @title Pausable token
182  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/PausableToken.sol
183  **/
184 contract PausableToken is StandardToken, Pausable {
185 
186     function transfer(
187         address _to,
188         uint256 _value
189     ) public  whenNotPaused returns (bool)
190     {
191         return super.transfer(_to, _value);
192     }
193 
194     function transferFrom(
195         address _from,
196         address _to,
197         uint256 _value
198     ) public whenNotPaused returns (bool)
199     {
200         return super.transferFrom(_from, _to, _value);
201     }
202 
203     function approve(
204         address _spender,
205         uint256 _value
206     ) public whenNotPaused returns (bool)
207     {
208         return super.approve(_spender, _value);
209     }
210 
211     function increaseApproval(
212         address _spender,
213         uint _addedValue
214     ) public whenNotPaused returns (bool success)
215     {
216         return super.increaseApproval(_spender, _addedValue);
217     }
218 
219     function decreaseApproval(
220         address _spender,
221         uint _subtractedValue
222     ) public whenNotPaused returns (bool success)
223     {
224         return super.decreaseApproval(_spender, _subtractedValue);
225     }
226 }
227 
228 /**
229  * @title Burnable Token
230  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
231  */
232 contract BurnableToken is BasicToken {
233 
234     event Burn(address indexed burner, uint256 value);
235 
236     function burn(uint256 _value) public {
237         _burn(msg.sender, _value);
238     }
239 
240     function _burn(address _who, uint256 _value) internal {
241         require(_value <= balances[_who]);
242         balances[_who] = balances[_who].sub(_value);
243         totalSupply_ = totalSupply_.sub(_value);
244         emit Burn(_who, _value);
245         emit Transfer(_who, address(0), _value);
246     }
247 }
248 
249 /**
250  * @title Mintable token
251  * @dev https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/MintableToken.sol
252  */
253 contract MintableToken is PausableToken {
254     event Mint(address indexed to, uint256 amount);
255     event MintFinished();
256 
257     bool public mintingFinished = false;
258 
259     modifier canMint() {
260         require(!mintingFinished);
261         _;
262     }
263 
264     modifier hasMintPermission() {
265         require(msg.sender == owner);
266         _;
267     }
268 
269     function finishMinting() onlyOwner canMint public returns (bool) {
270         mintingFinished = true;
271         emit MintFinished();
272         return true;
273     }
274 }
275 
276 /**
277 * @title INMToken token
278 */
279 contract SPCToken is MintableToken, BurnableToken {
280 
281     using SafeMath for uint256;
282 
283     string  public name = "Sp estate token";
284     string  public symbol = "SPC";
285     uint256 constant public decimals = 18;
286     uint256 constant dec = 10**decimals;
287     uint256 public constant initialSupply = 10500000*dec; // 10,500,000 SPC
288     address public crowdsaleAddress;
289 
290     modifier onlyICO() {
291         require(msg.sender == crowdsaleAddress);
292         _;
293     }
294 
295     constructor() public {
296         pause();
297     }
298 
299     function setSaleAddress(address _saleaddress) public onlyOwner{
300         crowdsaleAddress = _saleaddress;
301     }
302 
303     function mintFromICO(address _to, uint256 _amount) onlyICO canMint public returns (bool) {
304         require(totalSupply_ <= initialSupply);
305         require(balances[_to].add(_amount) != 0);
306         require(balances[_to].add(_amount) > balances[_to]);
307         totalSupply_ = totalSupply_.add(_amount);
308         require(totalSupply_ <= initialSupply);
309         balances[_to] = balances[_to].add(_amount);
310         emit Mint(_to, _amount);
311         emit Transfer(address(0), _to, _amount);
312         return true;
313     }
314 }