1 pragma solidity ^0.4.24;
2 // We announced each .sol file and omitted the verbose comments.
3 // Gas limit : 5,000,000
4 
5 library SafeMath {                             //SafeMath.sol
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) { return 0; }
8     c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     return a / b;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
23     c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract Token {
30   using SafeMath for uint256;
31   address public owner;                                              //Ownable.sol
32   string public name = "FDEX";                                      //DetailedERC20.sol
33   string public symbol = "DESIA";                                    //DetailedERC20.sol
34   string public version = "DESIA v1.1";              // new
35   uint256 public decimals = 18;                                        //DetailedERC20.sol  
36   uint256 totalSupply_ = 12e8 * (10**18);             //BasicToken.sol
37   uint256 public cap = totalSupply_;                                 //CappedToken.sol
38   bool public paused = false;                                         //Pausable.sol
39   bool public mintingFinished = false;                                //MintableToken.sol
40   mapping(address => uint256) balances;                              //BasicToken.sol
41   mapping(address => mapping (address => uint256)) internal allowed; //StandardToken.sol
42   mapping(address => uint256) internal locked;          // new
43   event Burn(address indexed burner, uint256 value);                               //BurnableToken.sol
44   event Approval(address indexed owner, address indexed spender,uint256 value);    //ERC20.sol
45   event Transfer(address indexed from, address indexed to, uint256 value);         //ERC20Basic.sol
46   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //Ownable.sol
47   event Pause();                                                                   //Pausable.sol
48   event Unpause();                                                                 //Pausable.sol
49   event Mint(address indexed to, uint256 amount, string reason);                   //MintableToken.sol, "reason" added
50   event MintFinished();                                                            //MintableToken.sol
51   event Lock(address indexed LockedAddress, uint256 LockAmount);             // new. lock each address
52   event Unlock(address indexed LockedAddress);           // new
53   event CapChange(uint256 Cap, string reason);           // new
54 
55   constructor() public { 
56     owner = msg.sender;
57     balances[owner] = totalSupply_ ;
58   }
59 
60   modifier onlyOwner()         {require(msg.sender == owner); _;}  //Ownable.sol
61   modifier whenPaused()        {require(paused); _; }              //Pausable.sol
62   modifier whenNotPaused()     {require(!paused); _;}              //Pausable.sol
63   modifier canMint()           {require(!mintingFinished); _;}     //MintableToken.sol
64   modifier cannotMint()        {require(mintingFinished); _;}      // new
65   modifier hasMintPermission() {require(msg.sender == owner);  _;} //MintableToken.sol
66 
67   function balanceOf(address _owner) public view returns (uint256) {  //BasicToken.sol
68     return balances[_owner];
69   }
70 
71   function totalSupply() public view returns (uint256) {  //BasicToken.sol
72     return totalSupply_;
73   }
74   
75   function burn(uint256 _value) public { //BurnableToken.sol
76     _burn(msg.sender, _value);
77   }
78 
79   function _burn(address _who, uint256 _value) internal {  //BurnableToken.sol
80     require(_value <= balances[_who]);
81     balances[_who] = balances[_who].sub(_value);
82     totalSupply_ = totalSupply_.sub(_value);
83     emit Burn(_who, _value);
84     emit Transfer(_who, address(0), _value);
85   }
86   
87   function burnFrom(address _from, uint256 _value) public {  //StandardBurnableToken.sol
88     require(_value <= allowed[_from][msg.sender]);
89     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
90     _burn(_from, _value);
91   }
92   
93   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
94       //StandardToken.sol, PausableToken.sol
95     allowed[msg.sender][_spender] = _value;
96     emit Approval(msg.sender, _spender, _value);
97     return true;
98   }
99 
100   function allowance(address _owner, address _spender) public view returns (uint256) { //StandardToken.sol
101     return allowed[_owner][_spender];
102   }
103 
104   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns(bool){
105       //StandardToken.sol, PausableToken.sol
106     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
107     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108     return true;
109   }
110 
111   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns(bool) {
112       //StandardToken.sol, PausableToken.sol
113     uint256 oldValue = allowed[msg.sender][_spender];
114     if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0;
115     } else                           { allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
116     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
117     return true;
118   }
119 
120   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {//BasicToken.sol, PausableToken.sol
121     require(_to != address(0));
122     require(locked[msg.sender].add(_value) <= balances[msg.sender]);  //Added
123     balances[msg.sender] = balances[msg.sender].sub(_value);
124     balances[_to] = balances[_to].add(_value);
125     emit Transfer(msg.sender, _to, _value);
126     return true;
127   }
128 
129   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {  
130       //StandardToken.sol, PausableToken.sol
131     require(_to != address(0));
132     require(_value <= balances[_from]);
133     require(_value <= allowed[_from][msg.sender]);
134     require(locked[_from].add(_value) <= balances[_from]); //Added
135     balances[_from] = balances[_from].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
138     emit Transfer(_from, _to, _value);
139     return true;
140   }
141 
142   function transferOwnership(address _newOwner) public onlyOwner {   //Ownable.sol
143     _transferOwnership(_newOwner);
144   }
145 
146   function _transferOwnership(address _newOwner) internal {   //Ownable.sol
147     require(_newOwner != address(0));
148     emit OwnershipTransferred(owner, _newOwner);
149     owner = _newOwner;
150   }
151 
152   function pause() onlyOwner whenNotPaused public {   //Pausable.sol, stop whole transfer
153     paused = true;
154     emit Pause();
155   }
156 
157   function unpause() onlyOwner whenPaused public {   //Pausable.sol
158     paused = false;
159     emit Unpause();
160   }
161 
162   function mint(address _to, uint256 _amount, string _reason) hasMintPermission canMint public returns (bool)  { 
163       //MintableToken.sol, CappedToken.sol
164     require(totalSupply_.add(_amount) <= cap);
165     totalSupply_ = totalSupply_.add(_amount);
166     balances[_to] = balances[_to].add(_amount);
167     emit Mint(_to, _amount, _reason);
168     emit Transfer(address(0), _to, _amount);
169     return true;
170   }
171 
172   function finishMinting() onlyOwner canMint public returns (bool) { //MintableToken.sol
173     mintingFinished = true;
174     emit MintFinished();
175     return true;
176   }
177 
178   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
179     selfdestruct(_recipient);
180   }
181   
182 /* new functions */
183 
184   function burnOf(address _who, uint256 _value) public onlyOwner { // burn by owner
185     _burn(_who, _value);
186   }
187 
188   function setCap(uint256 _cap, string _reason) public onlyOwner {
189     _setCap(_cap, _reason);
190   }
191 
192   function _setCap(uint256 _cap, string _reason) internal onlyOwner { // change the limit of cap
193     cap = _cap;
194     emit CapChange(_cap, _reason);
195   }
196   
197   function multiTransfer(address[] _to, uint256[] _amount) whenNotPaused public returns (bool) {
198     require(_to.length == _amount.length);
199     uint256 i;
200     uint256 amountSum = 0;
201     for (i=0; i < _amount.length; i++){
202       require(_amount[i] > 0);
203       require(_to[i] != address(0));
204       amountSum = amountSum.add(_amount[i]);
205     }
206     require(locked[msg.sender].add(amountSum) <= balances[msg.sender]);  //Added
207     require(amountSum <= balances[msg.sender]);
208     for (i=0; i < _to.length; i++){
209       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
210       emit Transfer(msg.sender, _to[i], _amount[i]);
211     }
212     balances[msg.sender] = balances[msg.sender].sub(amountSum);
213     return true;
214   }
215   
216   function multiMint(address[] _to, uint256[] _amount, string _reason) hasMintPermission canMint public returns (bool) {
217     require(_to.length == _amount.length);
218     uint16 i;              // less than 65536 at one time
219     uint256 amountSum = 0;
220     for (i=0; i < _amount.length; i++){
221       require(_amount[i] > 0);
222       require(_to[i] != address(0));
223       amountSum = amountSum.add(_amount[i]);
224     }
225     require(totalSupply_.add(amountSum) <= cap);
226     for (i=0; i < _to.length; i++){
227       mint(_to[i], _amount[i], _reason);
228     }
229     return true;
230   }
231   
232   function lock(address _lockAddress, uint256 _lockAmount) public onlyOwner returns (bool) {  // stop _lockAddress's transfer
233     require(_lockAddress != address(0));
234     require(_lockAddress != owner);
235     locked[_lockAddress] = _lockAmount; //Added
236     emit Lock(_lockAddress, _lockAmount);
237     return true;
238   }
239 
240   function unlock(address _lockAddress) public onlyOwner returns (bool) {
241     require(_lockAddress != address(0));
242     require(_lockAddress != owner);
243     locked[_lockAddress] = 0; //Added
244     emit Unlock(_lockAddress);
245     return true;
246   }
247 
248   function multiLock(address[] _lockAddress, uint256[] _lockAmount) public onlyOwner {
249     require(_lockAmount.length == _lockAddress.length);
250     for (uint i=0; i < _lockAddress.length; i++){
251       lock(_lockAddress[i], _lockAmount[i]);
252     }
253   }
254 
255   function multiUnlock(address[] _lockAddress) public onlyOwner {
256     for (uint i=0; i < _lockAddress.length; i++){
257       unlock(_lockAddress[i]);
258     }
259   }
260 
261   function checkLock(address _address) public view onlyOwner returns (uint256) { //Added
262     return locked[_address];
263   }
264 
265 }