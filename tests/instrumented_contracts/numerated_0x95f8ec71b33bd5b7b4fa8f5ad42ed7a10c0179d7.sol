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
38     function transfer(address _to, uint256 _value) public returns (bool) {
39         require(_to != address(0) && _value != 0 &&_value <= balances[msg.sender],"Please check the amount of transmission error and the amount you send.");
40         balances[msg.sender] = balances[msg.sender].sub(_value);
41         balances[_to] = balances[_to].add(_value);
42         emit Transfer(msg.sender, _to, _value);
43         
44         return true;
45     }
46     function balanceOf(address _owner) public view returns (uint256 balance) {
47         return balances[_owner];
48     }
49 }
50 
51 contract ERC20Token is BasicToken, ERC20 {
52     using SafeMath for uint256;
53     event Approval(address indexed owner, address indexed spender, uint256 value);
54     mapping (address => mapping (address => uint256))  allowed;
55     mapping (address => uint256) public freezeOf;
56 
57     function approve(address _spender, uint256 _value) public returns (bool) {
58         
59         require(_value == 0 || allowed[msg.sender][_spender] == 0,"Please check the amount you want to approve.");
60         allowed[msg.sender][_spender] = _value;
61         emit Approval(msg.sender, _spender, _value);
62         return true;
63     }
64     
65     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
66         return allowed[_owner][_spender];
67     }
68     
69     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool success) {
70         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
71         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
72         return true;
73     }
74     
75     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool success) {
76         uint256 oldValue = allowed[msg.sender][_spender];
77         if (_subtractedValue >= oldValue) {
78             allowed[msg.sender][_spender] = 0;
79         } else {
80             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
81         }
82         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
83         return true;
84     }
85 }
86 
87 contract Ownable {
88     address public owner;
89     mapping (address => bool) public admin;
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91     
92     constructor() public {
93         owner = msg.sender;
94     }
95     
96     modifier onlyOwner() {
97         require(msg.sender == owner,"I am not the owner of the wallet.");
98         _;
99     }
100     modifier onlyOwnerOrAdmin() {
101         require(msg.sender == owner || admin[msg.sender] == true,"It is not the owner or manager wallet address.");
102         _;
103     }
104     function transferOwnership(address newOwner) onlyOwner public {
105         require(newOwner != address(0) && newOwner != owner && admin[newOwner] == true,"It must be the existing manager wallet, not the existing owner's wallet.");
106         emit OwnershipTransferred(owner, newOwner);
107         owner = newOwner;
108     }
109     function setAdmin(address newAdmin) onlyOwner public {
110         require(admin[newAdmin] != true && owner != newAdmin,"It is not an existing administrator wallet, and it must not be the owner wallet of the token.");
111         admin[newAdmin] = true;
112     }
113     function unsetAdmin(address Admin) onlyOwner public {
114         require(admin[Admin] != false && owner != Admin,"This is an existing admin wallet, it must not be a token holder wallet.");
115         admin[Admin] = false;
116     }
117 
118 }
119 
120 contract Pausable is Ownable {
121     event Pause();
122     event Unpause();
123     bool public paused = false;
124     
125     modifier whenNotPaused() {
126         require(!paused,"There is a pause.");
127         _;
128     }
129     modifier whenPaused() {
130         require(paused,"It is not paused.");
131         _;
132     }
133     function pause() onlyOwner whenNotPaused public {
134         paused = true;
135         emit Pause();
136     }
137     function unpause() onlyOwner whenPaused public {
138         paused = false;
139         emit Unpause();
140     }
141 
142 }
143 
144 library SafeMath {
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         if (a == 0) {return 0; }	
147         uint256 c = a * b;
148         require(c / a == b,"An error occurred in the calculation process");
149         return c;
150     }
151     function div(uint256 a, uint256 b) internal pure returns (uint256) {
152         require(b !=0,"The number you want to divide must be non-zero.");
153         uint256 c = a / b;
154         require(c * b == a,"An error occurred in the calculation process");
155         return c;
156     }
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         require(b <= a,"There are more to deduct.");
159         return a - b;
160     }
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         uint256 c = a + b;
163         require(c >= a,"The number did not increase.");
164         return c;
165     }
166 }
167 
168 contract BurnableToken is BasicToken, Ownable {
169     
170     event Burn(address indexed burner, uint256 amount);
171 
172     function burn(uint256 _value) onlyOwner public {
173         balances[msg.sender] = balances[msg.sender].sub(_value);
174         _totalSupply = _totalSupply.sub(_value);
175         emit Burn(msg.sender, _value);
176         emit Transfer(msg.sender, address(0), _value);
177     }
178 }
179 
180 
181 
182 
183 contract FreezeToken is BasicToken, Ownable {
184     
185     event Freezen(address indexed freezer, uint256 amount);
186     event UnFreezen(address indexed freezer, uint256 amount);
187     mapping (address => uint256) freezeOf;
188     
189     function freeze(uint256 _value) onlyOwner public {
190         balances[msg.sender] = balances[msg.sender].sub(_value);
191         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);
192         _totalSupply = _totalSupply.sub(_value);
193         emit Freezen(msg.sender, _value);
194     }
195     function unfreeze(uint256 _value) onlyOwner public {
196         require(freezeOf[msg.sender] >= _value,"The number to be processed is more than the total amount and the number currently frozen.");
197         balances[msg.sender] = balances[msg.sender].add(_value);
198         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);
199         _totalSupply = _totalSupply.add(_value);
200         emit Freezen(msg.sender, _value);
201     }
202 }
203 
204 
205 contract KoreaBlackHole is BurnableToken,FreezeToken, DetailedERC20, ERC20Token,Pausable{
206     using SafeMath for uint256;
207     
208     event Approval(address indexed owner, address indexed spender, uint256 value);
209     event LockerChanged(address indexed owner, uint256 amount);
210     mapping(address => uint) locker;
211     
212     string  private _symbol = "KBH";
213     string  private _name = "Korea Blackhole";
214     uint8  private _decimals = 18;
215     uint256 private TOTAL_SUPPLY = 40*(10**8)*(10**uint256(_decimals));
216     
217     constructor() DetailedERC20(_name, _symbol, _decimals) public {
218         _totalSupply = TOTAL_SUPPLY;
219         balances[owner] = _totalSupply;
220         emit Transfer(address(0x0), msg.sender, _totalSupply);
221     }
222     
223     function transfer(address _to, uint256 _value)  public whenNotPaused returns (bool){
224         require(balances[msg.sender].sub(_value) >= locker[msg.sender],"Attempting to send more than the locked number");
225         return super.transfer(_to, _value);
226     }
227     function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool){
228     
229         require(_to > address(0) && _from > address(0),"Please check the address" );
230         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value,"Please check the amount of transmission error and the amount you send.");
231         require(balances[_from].sub(_value) >= locker[_from],"Attempting to send more than the locked number" );
232         
233         balances[_from] = balances[_from].sub(_value);
234         balances[_to] = balances[_to].add(_value);
235         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
236         
237         emit Transfer(_from, _to, _value);
238         
239         return true;
240     }
241     function lockOf(address _address) public view returns (uint256 _locker) {
242         return locker[_address];
243     }
244     function setLock(address _address, uint256 _value) public onlyOwnerOrAdmin {
245         require(_value <= _totalSupply &&_address != address(0),"It is the first wallet or attempted to lock an amount greater than the total holding.");
246         locker[_address] = _value;
247         emit LockerChanged(_address, _value);
248     }
249     function setLockList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
250         require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
251         
252         for (uint i=0; i < _recipients.length; i++) {
253             require(_recipients[i] != address(0),'Please check the address');
254             
255             locker[_recipients[i]] = _balances[i];
256             emit LockerChanged(_recipients[i], _balances[i]);
257         }
258     }
259     function transferList(address[] _recipients, uint256[] _balances) public onlyOwnerOrAdmin{
260         require(_recipients.length == _balances.length,"The number of wallet arrangements and the number of amounts are different.");
261         
262         for (uint i=0; i < _recipients.length; i++) {
263             balances[msg.sender] = balances[msg.sender].sub(_balances[i]);
264             balances[_recipients[i]] = balances[_recipients[i]].add(_balances[i]);
265             emit Transfer(msg.sender,_recipients[i],_balances[i]);
266         }
267     }
268     function() public payable {
269         revert();
270     }
271 }