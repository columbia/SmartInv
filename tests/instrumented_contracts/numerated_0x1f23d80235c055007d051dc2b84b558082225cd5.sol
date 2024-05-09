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
36   uint256 totalSupply_ = 12e8 * (10**uint256(decimals));             //BasicToken.sol
37   uint256 public cap = totalSupply_;                                 //CappedToken.sol
38   bool public paused = false;                                         //Pausable.sol
39   bool public mintingFinished = true;                                //MintableToken.sol
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
51   event MintStarted(string reason);                      // new
52   event Lock(address indexed LockedAddress, uint256 LockAmount);             // new. lock each address
53   event Unlock(address indexed LockedAddress);           // new
54   event CapChange(uint256 Cap, string reason);           // new
55 
56   constructor() public { 
57     owner = msg.sender;
58     balances[owner] = totalSupply_ ;
59   }
60 
61   modifier onlyOwner()         {require(msg.sender == owner); _;}  //Ownable.sol
62   modifier whenPaused()        {require(paused); _; }              //Pausable.sol
63   modifier whenNotPaused()     {require(!paused); _;}              //Pausable.sol
64   modifier canMint()           {require(!mintingFinished); _;}     //MintableToken.sol
65   modifier cannotMint()        {require(mintingFinished); _;}      // new
66   modifier hasMintPermission() {require(msg.sender == owner);  _;} //MintableToken.sol
67 
68   function balanceOf(address _owner) public view returns (uint256) {  //BasicToken.sol
69     return balances[_owner];
70   }
71 
72   function totalSupply() public view returns (uint256) {  //BasicToken.sol
73     return totalSupply_;
74   }
75   
76   function burn(uint256 _value) public { //BurnableToken.sol
77     _burn(msg.sender, _value);
78   }
79 
80   function _burn(address _who, uint256 _value) internal {  //BurnableToken.sol
81     require(_value <= balances[_who]);
82     balances[_who] = balances[_who].sub(_value);
83     totalSupply_ = totalSupply_.sub(_value);
84     emit Burn(_who, _value);
85     emit Transfer(_who, address(0), _value);
86   }
87   
88   function burnFrom(address _from, uint256 _value) public {  //StandardBurnableToken.sol
89     require(_value <= allowed[_from][msg.sender]);
90     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91     _burn(_from, _value);
92   }
93   
94   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
95       //StandardToken.sol, PausableToken.sol
96     allowed[msg.sender][_spender] = _value;
97     emit Approval(msg.sender, _spender, _value);
98     return true;
99   }
100 
101   function allowance(address _owner, address _spender) public view returns (uint256) { //StandardToken.sol
102     return allowed[_owner][_spender];
103   }
104 
105   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns(bool){
106       //StandardToken.sol, PausableToken.sol
107     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
108     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns(bool) {
113       //StandardToken.sol, PausableToken.sol
114     uint256 oldValue = allowed[msg.sender][_spender];
115     if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0;
116     } else                           { allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
117     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
118     return true;
119   }
120 
121   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {//BasicToken.sol, PausableToken.sol
122     require(_to != address(0));
123     require(locked[msg.sender].add(_value) <= balances[msg.sender]);  //Added
124     balances[msg.sender] = balances[msg.sender].sub(_value);
125     balances[_to] = balances[_to].add(_value);
126     emit Transfer(msg.sender, _to, _value);
127     return true;
128   }
129 
130   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {  
131       //StandardToken.sol, PausableToken.sol
132     require(_to != address(0));
133     require(_value <= balances[_from]);
134     require(_value <= allowed[_from][msg.sender]);
135     require(locked[_from].add(_value) <= balances[_from]); //Added
136     balances[_from] = balances[_from].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
139     emit Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   function transferOwnership(address _newOwner) public onlyOwner {   //Ownable.sol
144     _transferOwnership(_newOwner);
145   }
146 
147   function _transferOwnership(address _newOwner) internal {   //Ownable.sol
148     require(_newOwner != address(0));
149     emit OwnershipTransferred(owner, _newOwner);
150     owner = _newOwner;
151   }
152 
153   function pause() onlyOwner whenNotPaused public {   //Pausable.sol, stop whole transfer
154     paused = true;
155     emit Pause();
156   }
157 
158   function unpause() onlyOwner whenPaused public {   //Pausable.sol
159     paused = false;
160     emit Unpause();
161   }
162 
163   function mint(address _to, uint256 _amount, string _reason) hasMintPermission canMint public returns (bool)  { 
164       //MintableToken.sol, CappedToken.sol
165     require(totalSupply_.add(_amount) <= cap);
166     totalSupply_ = totalSupply_.add(_amount);
167     balances[_to] = balances[_to].add(_amount);
168     emit Mint(_to, _amount, _reason);
169     emit Transfer(address(0), _to, _amount);
170     return true;
171   }
172 
173   function finishMinting() onlyOwner canMint public returns (bool) { //MintableToken.sol
174     mintingFinished = true;
175     emit MintFinished();
176     return true;
177   }
178 
179   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
180     selfdestruct(_recipient);
181   }
182   
183 /* new functions */
184   function startMinting(string reason) onlyOwner cannotMint public returns (bool) {
185     mintingFinished = false;
186     emit MintStarted(reason);
187     return true;
188   }
189 
190   function burnOf(address _who, uint256 _value) public onlyOwner { // burn by owner
191     _burn(_who, _value);
192   }
193 
194   function setCap(uint256 _cap, string _reason) public onlyOwner {
195     _setCap(_cap, _reason);
196   }
197 
198   function _setCap(uint256 _cap, string _reason) internal onlyOwner { // change the limit of cap
199     cap = _cap;
200     emit CapChange(_cap, _reason);
201   }
202   
203   function multiTransfer(address[] _to, uint256[] _amount) whenNotPaused public returns (bool) {
204     require(_to.length == _amount.length);
205     uint256 i;
206     uint256 amountSum = 0;
207     for (i=0; i < _amount.length; i++){
208       require(_amount[i] > 0);
209       require(_to[i] != address(0));
210       amountSum = amountSum.add(_amount[i]);
211     }
212     require(locked[msg.sender].add(amountSum) <= balances[msg.sender]);  //Added
213     require(amountSum <= balances[msg.sender]);
214     for (i=0; i < _to.length; i++){
215       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
216       emit Transfer(msg.sender, _to[i], _amount[i]);
217     }
218     balances[msg.sender] = balances[msg.sender].sub(amountSum);
219     return true;
220   }
221   
222   function multiMint(address[] _to, uint256[] _amount, string _reason) hasMintPermission canMint public returns (bool) {
223     require(_to.length == _amount.length);
224     uint16 i;              // less than 65536 at one time
225     uint256 amountSum = 0;
226     for (i=0; i < _amount.length; i++){
227       require(_amount[i] > 0);
228       require(_to[i] != address(0));
229       amountSum = amountSum.add(_amount[i]);
230     }
231     require(totalSupply_.add(amountSum) <= cap);
232     for (i=0; i < _to.length; i++){
233       mint(_to[i], _amount[i], _reason);
234     }
235     return true;
236   }
237   
238   function lock(address _lockAddress, uint256 _lockAmount) public onlyOwner returns (bool) {  // stop _lockAddress's transfer
239     require(_lockAddress != address(0));
240     require(_lockAddress != owner);
241     locked[_lockAddress] = _lockAmount; //Added
242     emit Lock(_lockAddress, _lockAmount);
243     return true;
244   }
245 
246   function unlock(address _lockAddress) public onlyOwner returns (bool) {
247     require(_lockAddress != address(0));
248     require(_lockAddress != owner);
249     locked[_lockAddress] = 0; //Added
250     emit Unlock(_lockAddress);
251     return true;
252   }
253 
254   function multiLock(address[] _lockAddress, uint256[] _lockAmount) public onlyOwner {
255     require(_lockAmount.length == _lockAddress.length);
256     for (uint i=0; i < _lockAddress.length; i++){
257       lock(_lockAddress[i], _lockAmount[i]);
258     }
259   }
260 
261   function multiUnlock(address[] _lockAddress) public onlyOwner {
262     for (uint i=0; i < _lockAddress.length; i++){
263       unlock(_lockAddress[i]);
264     }
265   }
266 
267   function checkLock(address _address) public view onlyOwner returns (uint256) { //Added
268     return locked[_address];
269   }
270 
271 }