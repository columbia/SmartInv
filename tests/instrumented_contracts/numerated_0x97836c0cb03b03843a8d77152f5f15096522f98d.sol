1 pragma solidity 0.4.25;
2 
3 contract ERC20Basic {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address who) public view returns (uint256);
6     function transfer(address  to, uint256 value) public returns (bool);
7     event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address  to, uint256 value) public returns (bool);
13     function approve(address  spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract DetailedERC20 is ERC20 {
18     string public name;
19     string public symbol;
20     uint8 public decimals;
21     
22     constructor(string _name, string _symbol, uint8 _decimals) public {
23         name = _name;
24         symbol = _symbol;
25         decimals = _decimals;
26     }
27 }
28 
29 contract BasicToken is ERC20Basic {
30     using SafeMath for uint256;
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32     mapping(address => uint256)  balances;
33     uint256  _totalSupply;
34     
35     function totalSupply() public view returns (uint256) {
36         return _totalSupply;
37     }
38     
39     
40     function transfer(address _to, uint256 _value) public returns (bool) {
41         require(_to != address(0) && _value != 0 &&_value <= balances[msg.sender],"Please check the amount of transmission error and the amount you send.");
42         balances[msg.sender] = balances[msg.sender].sub(_value);
43         balances[_to] = balances[_to].add(_value);
44         emit Transfer(msg.sender, _to, _value);
45         
46         return true;
47     }
48     
49     function balanceOf(address _owner) public view returns (uint256 balance) {
50         return balances[_owner];
51     }
52 }
53 
54 contract ERC20Token is BasicToken, ERC20 {
55     using SafeMath for uint256;
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57     mapping (address => mapping (address => uint256))  allowed;
58     mapping (address => uint256) public freezeOf;
59 
60     function approve(address _spender, uint256 _value) public returns (bool) {
61         
62         require(_value == 0 || allowed[msg.sender][_spender] == 0,"Please check the amount you want to approve.");
63         allowed[msg.sender][_spender] = _value;
64         emit Approval(msg.sender, _spender, _value);
65         return true;
66     }
67     
68     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
69         return allowed[_owner][_spender];
70     }
71     
72     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
73         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
74         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
75         return true;
76     }
77     
78     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
79         uint256 oldValue = allowed[msg.sender][_spender];
80         if (_subtractedValue >= oldValue) {
81             allowed[msg.sender][_spender] = 0;
82         } else {
83             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
84         }
85         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
86         return true;
87     }
88 }
89 
90 contract Ownable {
91     
92     address public owner;
93     mapping (address => bool) public admin;
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95     
96     constructor() public {
97         owner = msg.sender;
98     }
99     
100     modifier onlyOwner() {
101         require(msg.sender == owner,"I am not the owner of the wallet.");
102         _;
103     }
104     
105     modifier onlyOwnerOrAdmin() {
106         require(msg.sender == owner || admin[msg.sender] == true,"It is not the owner or manager wallet address.");
107         _;
108     }
109     
110     function transferOwnership(address newOwner) onlyOwner public {
111         require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true,"It must be the existing manager wallet, not the existing owner's wallet.");
112         emit OwnershipTransferred(owner, newOwner);
113         owner = newOwner;
114     }
115     
116     function setAdmin(address newAdmin) onlyOwner public {
117         require(admin[newAdmin] != true && owner != newAdmin,"It is not an existing administrator wallet, and it must not be the owner wallet of the token.");
118         admin[newAdmin] = true;
119     }
120     
121     function unsetAdmin(address Admin) onlyOwner public {
122         require(admin[Admin] != false && owner != Admin,"This is an existing admin wallet, it must not be a token holder wallet.");
123         admin[Admin] = false;
124     }
125 
126 }
127 
128 contract Pausable is Ownable {
129     event Pause();
130     event Unpause();
131     bool public paused = false;
132     
133     modifier whenNotPaused() {
134         require(!paused,"There is a pause.");
135         _;
136     }
137     
138     modifier whenPaused() {
139         require(paused,"It is not paused.");
140         _;
141     }
142     
143     function pause() onlyOwner whenNotPaused public {
144         paused = true;
145         emit Pause();
146     }
147     
148     function unpause() onlyOwner whenPaused public {
149         paused = false;
150         emit Unpause();
151     }
152 
153 }
154 
155 library SafeMath {
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         if (a == 0) {return 0; }	
158         uint256 c = a * b;
159         require(c / a == b,"An error occurred in the calculation process");
160         return c;
161     }
162     
163     function div(uint256 a, uint256 b) internal pure returns (uint256) {
164         require(b !=0,"The number you want to divide must be non-zero.");
165         uint256 c = a / b;
166         require(c * b == a,"An error occurred in the calculation process");
167         return c;
168     }
169     
170     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b <= a,"There are more to deduct.");
172         return a - b;
173     }
174     
175     function add(uint256 a, uint256 b) internal pure returns (uint256) {
176         uint256 c = a + b;
177         require(c >= a,"The number did not increase.");
178         return c;
179     }
180 }
181 
182 contract BurnableToken is BasicToken, Ownable {
183     
184     event Burn(address indexed burner, uint256 amount);
185 
186     function burn(uint256 _value) onlyOwner public {
187         balances[msg.sender] = balances[msg.sender].sub(_value);
188         _totalSupply = _totalSupply.sub(_value);
189         emit Burn(msg.sender, _value);
190         emit Transfer(msg.sender, address(0), _value);
191     }
192 
193   
194 }
195 
196 
197 
198 
199 contract FreezeToken is BasicToken, Ownable {
200     
201     event Freezen(address indexed freezer, uint256 amount);
202     event UnFreezen(address indexed freezer, uint256 amount);
203     mapping (address => uint256) freezeOf;
204     
205     function freeze(uint256 _value) onlyOwner public {
206         balances[msg.sender] = balances[msg.sender].sub(_value);
207         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
208         _totalSupply = _totalSupply.sub(_value);
209         emit Freezen(msg.sender, _value);
210     }
211     
212     function unfreeze(uint256 _value) onlyOwner public {
213         require(freezeOf[msg.sender] >= _value,"The number to be processed is more than the total amount and the number currently frozen.");
214         balances[msg.sender] = balances[msg.sender].add(_value);
215         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
216         _totalSupply = _totalSupply.add(_value);
217         emit Freezen(msg.sender, _value);
218     }
219 }
220 
221 
222 contract AsiaInfluencerPlatform is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{
223     using SafeMath for uint256;
224     
225     event Approval(address indexed owner, address indexed spender, uint256 value);
226     event LockerChanged(address indexed owner, uint256 amount);
227     mapping(address => uint) locker;
228     
229     string  private _symbol = "AIP";
230     string  private _name = "Asia Influencer Platform";
231     uint8  private _decimals = 18;
232     uint256 private TOTAL_SUPPLY = 40*(10**8)*(10**uint256(_decimals));
233     
234     constructor() DetailedERC20(_name, _symbol, _decimals) public {
235         _totalSupply = TOTAL_SUPPLY;
236         balances[owner] = _totalSupply;
237         emit Transfer(address(0x0), msg.sender, _totalSupply);
238     }
239     
240     function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
241         require(balances[msg.sender].sub(_value) >= locker[msg.sender],"Attempting to send more than the locked number");
242         return super.transfer(_to, _value);
243     }
244     
245     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
246     
247         require(_to > address(0) && _from > address(0),"Please check the address" );
248         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value,"Please check the amount of transmission error and the amount you send.");
249         require(balances[_from].sub(_value) >= locker[_from],"Attempting to send more than the locked number" );
250         
251         balances[_from] = balances[_from].sub(_value);
252         balances[_to] = balances[_to].add(_value);
253         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
254         
255         emit Transfer(_from, _to, _value);
256         
257         return true;
258         
259     }
260     
261     function lockOf(address _address) public view returns (uint256 _locker) {
262         return locker[_address];
263     }
264     
265     function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {
266         require(_value <= _totalSupply &&_address != address(0),"It is the first wallet or attempted to lock an amount greater than the total holding.");
267         locker[_address] = _value;
268         emit LockerChanged(_address, _value);
269     }
270     function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
271         require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
272         
273         for (uint i=0; i < _recipients.length; i++) {
274             require(_recipients[i] != address(0),'Please check the address');
275             
276             locker[_recipients[i]] = _balances[i];
277             emit LockerChanged(_recipients[i], _balances[i]);
278         }
279     }
280     
281   
282     function transferList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
283         require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
284         
285         for (uint i=0; i < _recipients.length; i++) {
286             balances[msg.sender] = balances[msg.sender].sub(_balances[i]);
287             balances[_recipients[i]] = balances[_recipients[i]].add(_balances[i]);
288             emit Transfer(msg.sender,_recipients[i],_balances[i]);
289         }
290     }
291     
292  
293     function() public payable {
294         revert();
295     }
296 }