1 pragma solidity 0.4.24;
2 
3 // File: contracts\misc\Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable 
11 {
12     address public owner;
13 
14     event OwnershipRenounced(address indexed previousOwner);
15     event OwnershipTransferred(
16       address indexed previousOwner,
17       address indexed newOwner
18     );
19 
20     constructor() public 
21     {
22         owner = msg.sender;
23     }
24 
25     modifier onlyOwner() 
26     {
27         require(msg.sender == owner, "Incorrect Owner");
28         _;
29     }
30 
31     function transferOwnership(address _newOwner) public
32     onlyOwner 
33     {
34         require(_newOwner != address(0), "Address should not be 0x0");
35         emit OwnershipTransferred(owner, _newOwner);
36         owner = _newOwner;
37     }
38 
39     function renounceOwnership() public 
40     onlyOwner 
41     {
42         emit OwnershipRenounced(owner);
43         owner = address(0);
44     }
45 }
46 
47 // File: contracts\misc\SafeMath.sol
48 
49 /**
50  * @title SafeMath
51  * @dev Math operations with safety checks that revert on error
52  */
53 library SafeMath 
54 {
55     function mul(uint256 a, uint256 b) internal pure 
56     returns (uint256 c) 
57     {
58         if (a == 0) 
59         {
60             return 0;
61         }
62 
63         c = a * b;
64         assert(c / a == b);
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure 
69     returns (uint256) 
70     {
71         return a / b;
72     }
73 
74     function sub(uint256 a, uint256 b) internal pure 
75     returns (uint256) 
76     {
77         assert(b <= a);
78         return a - b;
79     }
80 
81     function add(uint256 a, uint256 b) internal pure 
82     returns (uint256 c) 
83     {
84         c = a + b;
85         assert(c >= a);
86         return c;
87     }
88 }
89 
90 // File: contracts\token\ERC20Basic.sol
91 
92 /**
93  * @title ERC20 Basic interface
94  * @dev see https://github.com/ethereum/EIPs/issues/20
95  */
96 contract ERC20Basic 
97 {
98     function totalSupply() public view returns (uint256);
99     function balanceOf(address who) public view returns (uint256);
100     function transfer(address to, uint256 value) public returns (bool);
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 // File: contracts\token\BasicToken.sol
105 
106 contract BasicToken is ERC20Basic 
107 {
108     using SafeMath for uint256;
109     mapping(address => uint256) public balances;
110     
111     uint256 public totalSupply_;
112 
113     function totalSupply() public view 
114     returns (uint256) 
115     {
116         return totalSupply_;
117     }
118 
119     function transfer(address _to, uint256 _value) public 
120     returns (bool) 
121     {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124 
125         balances[msg.sender] = balances[msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         emit Transfer(msg.sender, _to, _value);
128         return true;
129     }
130 
131     function balanceOf(address _owner) public view 
132     returns (uint256) 
133     {
134         return balances[_owner];
135     }
136 }
137 
138 // File: contracts\token\BurnableToken.sol
139 
140 /**
141  * @title Burnable Token
142  * @dev Token that can be irreversibly burned (destroyed).
143  */
144 contract BurnableToken is BasicToken, Ownable
145 {
146     event Burn(address indexed burner, uint256 value);
147 
148     function burn(uint256 value) public
149     onlyOwner
150     {
151         address burnAddress = msg.sender;
152         require(value <= balances[burnAddress]);
153 
154         balances[burnAddress] = balances[burnAddress].sub(value);
155         totalSupply_ = totalSupply_.sub(value);
156 
157         emit Burn(burnAddress, value);
158     }
159 }
160 
161 // File: contracts\token\ERC20.sol
162 
163 /**
164  * @title ERC20 interface
165  * @dev see https://github.com/ethereum/EIPs/issues/20
166  */
167 contract ERC20 is ERC20Basic 
168 {
169     function allowance(address owner, address spender) public view returns (uint256);
170     function transferFrom(address from, address to, uint256 value) public returns (bool);
171     function approve(address spender, uint256 value) public returns (bool); 
172     
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 // File: contracts\token\StandardToken.sol
177 
178 /**
179  * @title Standard ERC20 token
180  *
181  * @dev Implementation of the basic standard token.
182  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
183  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
184  */
185 contract StandardToken is ERC20, BasicToken 
186 {
187     mapping (address => mapping (address => uint256)) internal allowed;
188 
189     function transferFrom(address _from, address _to, uint256 _value) public
190     returns (bool)
191     {
192         require(_to != address(0));
193         require(_value <= balances[_from]);
194         require(_value <= allowed[_from][msg.sender]);
195 
196         balances[_from] = balances[_from].sub(_value);
197         balances[_to] = balances[_to].add(_value);
198         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
199         emit Transfer(_from, _to, _value);
200         return true;
201     }
202 
203     function approve(address _spender, uint256 _value) public 
204     returns (bool) 
205     {
206         allowed[msg.sender][_spender] = _value;
207         emit Approval(msg.sender, _spender, _value);
208         return true;
209     }
210 
211     function allowance(address _owner, address _spender) public view
212     returns (uint256)
213     {
214         return allowed[_owner][_spender];
215     }
216 
217     function increaseApproval(address _spender, uint256 _addedValue) public
218     returns (bool)
219     {
220         allowed[msg.sender][_spender] = (
221         allowed[msg.sender][_spender].add(_addedValue));
222         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
223         return true;
224     }
225 
226     function decreaseApproval(address _spender, uint256 _subtractedValue) public
227     returns (bool)
228     {
229         uint256 oldValue = allowed[msg.sender][_spender];
230 
231         if (_subtractedValue > oldValue) 
232         {
233             allowed[msg.sender][_spender] = 0;
234         } 
235         else 
236         {
237             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238         }
239 
240         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
241         return true;
242     }
243 
244 }
245 
246 // File: contracts\token\MintableToken.sol
247 
248 /**
249  * @title Mintable token
250  * @dev Simple ERC20 Token example, with mintable token creation
251  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
252  */
253 contract MintableToken is StandardToken, Ownable 
254 {
255     event Mint(address indexed to, uint256 amount);
256 
257     function mint(address _to, uint256 _amount) public
258     onlyOwner
259     returns (bool)
260     {
261         totalSupply_ = totalSupply_.add(_amount);
262         balances[_to] = balances[_to].add(_amount);
263         emit Mint(_to, _amount);
264         emit Transfer(address(0), _to, _amount);
265         return true;
266     }
267 }
268 
269 // File: contracts\misc\Pausable.sol
270 
271 /**
272  * @title Pausable
273  * @dev Base contract which allows children to implement an emergency stop mechanism.
274  */
275 contract Pausable is Ownable 
276 {
277     event Pause();
278     event Unpause();
279 
280     bool public paused = false;
281 
282     modifier whenNotPaused() {
283         require(!paused);
284         _;
285     }
286 
287     modifier whenPaused() {
288         require(paused);
289         _;
290     }
291 
292     function pause() public
293     onlyOwner 
294     whenNotPaused  
295     {
296         paused = true;
297         emit Pause();
298     }
299 
300     function unpause() public
301     onlyOwner 
302     whenPaused  
303     {
304         paused = false;
305         emit Unpause();
306     }
307 }
308 
309 // File: contracts\token\PausableToken.sol
310 
311 /**
312  * @title Pausable token
313  * @dev StandardToken modified with pausable transfers.
314  **/
315 contract PausableToken is StandardToken, Pausable 
316 {
317     function transfer(address _to, uint256 _value) public
318     whenNotPaused
319     returns (bool)
320     {
321         return super.transfer(_to, _value);
322     }
323 
324     function transferFrom(address _from, address _to, uint256 _value) public
325     whenNotPaused
326     returns (bool)
327     {
328         return super.transferFrom(_from, _to, _value);
329     }
330 
331     function approve(address _spender, uint256 _value) public
332     whenNotPaused
333     returns (bool)
334     {
335         return super.approve(_spender, _value);
336     }
337 
338     function increaseApproval(address _spender, uint _addedValue) public
339     whenNotPaused
340     returns (bool success)
341     {
342         return super.increaseApproval(_spender, _addedValue);
343     }
344 
345     function decreaseApproval(address _spender, uint _subtractedValue) public
346     whenNotPaused
347     returns (bool success)
348     {
349         return super.decreaseApproval(_spender, _subtractedValue);
350     }
351 }
352 
353 // File: contracts\IndexToken.sol
354 
355 contract IndexToken is BurnableToken, MintableToken, PausableToken
356 {
357     string constant public name = "T30";
358     string constant public symbol = "T30";
359 
360     uint public decimals = 18;
361 }