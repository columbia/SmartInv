1 pragma solidity ^0.4.21;
2 
3 contract Token {
4     string internal _symbol;
5     string internal _name;
6     uint8 internal _decimals;
7     uint internal _totalSupply;
8     mapping (address => uint) internal _balanceOf;
9     mapping (address => mapping (address => uint)) internal _allowances;
10    
11     function Token(string symbol, string name, uint8 decimals, uint totalSupply) public {
12         _symbol = symbol;
13         _name = name;
14         _decimals = decimals;
15         _totalSupply = totalSupply;
16     }
17    
18     function name() public constant returns (string) {
19         return _name;
20     }
21    
22     function symbol() public constant returns (string) {
23         return _symbol;
24     }
25    
26     function decimals() public constant returns (uint8) {
27         return _decimals;
28     }
29    
30     function totalSupply() public constant returns (uint) {
31         return _totalSupply;
32     }
33    
34     function balanceOf(address _addr) public constant returns (uint);
35     function transfer(address _to, uint _value) public returns (bool);
36     event Transfer(address indexed _from, address indexed _to, uint _value);
37 }
38 
39 interface ERC20 {
40     function transferFrom(address _from, address _to, uint _value) external returns (bool);
41     function approve(address _spender, uint _value) external returns (bool);
42     function allowance(address _owner, address _spender) external constant returns (uint);
43     event Approval(address indexed _owner, address indexed _spender, uint _value);
44 }
45 pragma solidity ^0.4.19;
46 
47 interface ERC223 {
48     function transfer(address _to, uint _value, bytes _data) public returns (bool);
49     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
50 }
51 contract ERC223ReceivingContract {
52     function tokenFallback(address _from, uint _value, bytes _data) public;
53 }
54 
55 pragma solidity ^0.4.18;
56 
57 contract Ownable {
58   address public owner;
59 
60 
61   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   function Ownable() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80    function isOwner(address _address) internal view returns (bool) {
81         return (_address == owner);
82     }
83    
84   /**
85    * @dev Allows the current owner to transfer control of the contract to a newOwner.
86    * @param newOwner The address to transfer ownership to.
87    */
88   function transferOwnership(address newOwner) public onlyOwner {
89     require(newOwner != address(0));
90     emit OwnershipTransferred(owner, newOwner);
91     owner = newOwner;
92   }
93 
94 }
95 
96 
97 library SafeMath {
98   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99     if (a == 0) {
100       return 0;
101     }
102     uint256 c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   function div(uint256 a, uint256 b) internal pure returns (uint256) {
108     // assert(b > 0); // Solidity automatically throws when dividing by 0
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111     return c;
112   }
113 
114   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115     assert(b <= a);
116     return a - b;
117   }
118 
119   function add(uint256 a, uint256 b) internal pure returns (uint256) {
120     uint256 c = a + b;
121     assert(c >= a);
122     return c;
123   }
124 
125 }
126 
127 // create a Flix token with a supply of 100 million
128 // using the ERC223 protocol
129 contract FlixToken is Ownable,Token("FLIX", "FLIX Token", 18, 0), ERC20, ERC223 {
130 
131     using SafeMath for uint256;
132     using SafeMath for uint;
133 
134     address owner;
135 
136     bool airdrop_funded = false;
137     bool crowdsale_funded = false;
138     bool bounty_campaign_funded = false;
139     bool vest_funded = false;
140     bool reserve_funded = false;
141 
142 
143     event Mint(address indexed to, uint256 amount);
144    
145     event Burn(address indexed burner, uint256 value);
146 
147     function FlixToken() public {
148         owner = msg.sender;
149         _balanceOf[owner] = 0;
150     }
151 
152     function totalSupply() public constant returns (uint) {
153         return _totalSupply;
154     }
155 
156     function balanceOf(address _addr) public constant returns (uint) {
157         return _balanceOf[_addr];
158     }
159 
160 
161 
162   /**
163   * @dev transfer token for a specified address
164   * @param _to The address to transfer to.
165   * @param _value The amount to be transferred.
166   */
167   function transfer(address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= _balanceOf[msg.sender]);
170    
171     bytes memory empty;
172 
173     _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
174     _balanceOf[_to] = _balanceOf[_to].add(_value);
175    
176     emit Transfer(msg.sender, _to, _value);
177    
178     if(isContract(_to)){
179         ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
180         _contract.tokenFallback(msg.sender, _value, empty);
181     }
182 
183     return true;
184   }
185 
186    function transfer(address _to, uint _value, bytes _data) public returns (bool) {
187         require(_to != address(0));
188         require(_value > 0);
189         require(_value <= _balanceOf[msg.sender]);
190        
191         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
192         _balanceOf[_to] = _balanceOf[_to].add(_value);
193         emit Transfer(msg.sender, _to, _value, _data);
194         if(isContract(_to)){
195             ERC223ReceivingContract _contract = ERC223ReceivingContract(_to);
196             _contract.tokenFallback(msg.sender, _value, _data);
197         }        
198         return true;
199     }
200    
201 
202     function isContract(address _addr) internal view returns (bool) {
203         uint codeSize;
204         assembly {
205             codeSize := extcodesize(_addr)
206         }
207         return codeSize > 0;
208     }
209    
210     function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
211         require(_to != address(0));
212         require(_value <= _balanceOf[_from]);
213         require(_value <= _allowances[_from][msg.sender]);
214 
215         _balanceOf[_from] = _balanceOf[_from].sub(_value);
216     _balanceOf[_to] = _balanceOf[_to].add(_value);
217     _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
218     emit Transfer(_from, _to, _value);
219     return true;
220   }
221 
222 
223     function approve(address _spender, uint _value) external returns (bool) {
224         _allowances[msg.sender][_spender] = _value;
225         emit Approval(msg.sender, _spender, _value);
226         return true;
227     }
228 
229     function allowance(address _owner, address _spender) external constant returns (uint) {
230         return _allowances[_owner][_spender];
231     }
232  
233   /**
234    * @dev Burns a specific amount of tokens.
235    * @param _value The amount of token to be burned.
236    */
237   function burn(uint256 _value,address _who) onlyOwner public {
238     require((now <= 1526637600));      
239     _burn(_who, _value);
240   }
241 
242   function _burn(address _who, uint256 _value) internal {
243     require((now <= 1526637600));
244     require(_value <= _balanceOf[_who]);
245     // no need to require value <= totalSupply, since that would imply the
246     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
247 
248     _balanceOf[_who] = _balanceOf[_who].sub(_value);
249     _totalSupply = _totalSupply.sub(_value);
250     emit Burn(_who, _value);
251     emit Transfer(_who, address(0), _value);
252   }
253  
254 function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
255     require((now <= 1526637600));
256     _totalSupply = _totalSupply.add(_amount);
257     _balanceOf[_to] = _balanceOf[_to].add(_amount);
258     emit Mint(_to, _amount);
259     emit Transfer(address(0), _to, _amount);
260     return true;
261   }
262 
263 
264   /**
265    * Mint tokens and allocate to wallet
266      Reversible until presale launch
267    *
268    */
269   function mintToContract(bytes32 mintType,address _to) onlyOwner public returns (bool) {
270     require((now <= 1526635600));
271     require((mintType == "Crowdsale") || (mintType == "Airdrop") || (mintType == "BountyCampaign") || (mintType =="Vesting") || (mintType =="Reserved"));
272     uint256 amount = 0;
273     if(mintType == "Crowdsale"){
274         require(!crowdsale_funded);
275         amount = 59000000000000000000000000;
276         crowdsale_funded = true;
277     }
278      if(mintType == "BountyCampaign"){
279         require(!bounty_campaign_funded);
280         amount = 2834000000000000000000000;
281         bounty_campaign_funded = true;
282 
283     }
284     if(mintType == "Vesting"){
285         require(!vest_funded);
286         amount = 18000000000000000000000000;
287         vest_funded = true;
288     }
289     if(mintType == "Reserved"){
290         require(!reserve_funded);
291         amount = 20000000000000000000000000;
292         reserve_funded = true;
293     }
294     _totalSupply = _totalSupply.add(amount);
295     _balanceOf[_to] = _balanceOf[_to].add(amount);
296     emit Mint(_to, amount);
297     emit Transfer(address(0), _to, amount);
298     return true;
299   }
300 }