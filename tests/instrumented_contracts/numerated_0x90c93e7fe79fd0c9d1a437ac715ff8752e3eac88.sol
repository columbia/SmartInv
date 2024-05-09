1 pragma solidity ^0.4.24;
2 // This is based on https://github.com/OpenZeppelin/openzeppelin-solidity.
3 // We announced each .sol file and omitted the verbose comments.
4 // Gas limit : 5,000,000
5 
6 library SafeMath {                             //SafeMath.sol
7   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
8     if (a == 0) { return 0; }
9     c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     return a / b;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24     c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract QurozToken {
31   using SafeMath for uint256;
32   address public owner;                                              //Ownable.sol
33   string public name = "Qfora";                                      //DetailedERC20.sol
34   string public symbol = "Quroz";                                    //DetailedERC20.sol
35   string public version = "Quroz v1.1";              // new
36   uint256 public decimals = 18;                                        //DetailedERC20.sol  
37   uint256 totalSupply_ = 12e8 * (10**uint256(decimals));             //BasicToken.sol
38   uint256 public cap = totalSupply_;                                 //CappedToken.sol
39   bool public paused = false;                                         //Pausable.sol
40   bool public mintingFinished = true;                                //MintableToken.sol
41   mapping(address => uint256) balances;                              //BasicToken.sol
42   mapping(address => mapping (address => uint256)) internal allowed; //StandardToken.sol
43   mapping(address => bool) internal locked;          // new
44   event Burn(address indexed burner, uint256 value);                               //BurnableToken.sol
45   event Approval(address indexed owner, address indexed spender,uint256 value);    //ERC20.sol
46   event Transfer(address indexed from, address indexed to, uint256 value);         //ERC20Basic.sol
47   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //Ownable.sol
48   event Pause();                                                                   //Pausable.sol
49   event Unpause();                                                                 //Pausable.sol
50   event Mint(address indexed to, uint256 amount, string reason);                   //MintableToken.sol, "reason" added
51   event MintFinished();                                                            //MintableToken.sol
52   event MintStarted(string reason);                      // new
53   event Lock(address indexed LockedAddress);             // new. lock each address
54   event Unlock(address indexed LockedAddress);           // new
55   event CapChange(uint256 Cap, string reason);           // new
56 
57   constructor() public { 
58     owner = msg.sender;
59     balances[owner] = totalSupply_ ;
60   }
61 
62   modifier onlyOwner()         {require(msg.sender == owner); _;}  //Ownable.sol
63   modifier whenPaused()        {require(paused); _; }              //Pausable.sol
64   modifier whenNotPaused()     {require(!paused); _;}              //Pausable.sol
65   modifier canMint()           {require(!mintingFinished); _;}     //MintableToken.sol
66   modifier cannotMint()        {require(mintingFinished); _;}      // new
67   modifier hasMintPermission() {require(msg.sender == owner);  _;} //MintableToken.sol
68 
69   function balanceOf(address _owner) public view returns (uint256) {  //BasicToken.sol
70     return balances[_owner];
71   }
72 
73   function totalSupply() public view returns (uint256) {  //BasicToken.sol
74     return totalSupply_;
75   }
76   
77   function burn(uint256 _value) public { //BurnableToken.sol
78     _burn(msg.sender, _value);
79   }
80 
81   function _burn(address _who, uint256 _value) internal {  //BurnableToken.sol
82     require(_value <= balances[_who]);
83     balances[_who] = balances[_who].sub(_value);
84     totalSupply_ = totalSupply_.sub(_value);
85     emit Burn(_who, _value);
86     emit Transfer(_who, address(0), _value);
87   }
88   
89   function burnFrom(address _from, uint256 _value) public {  //StandardBurnableToken.sol
90     require(_value <= allowed[_from][msg.sender]);
91     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
92     _burn(_from, _value);
93   }
94   
95   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
96       //StandardToken.sol, PausableToken.sol
97     allowed[msg.sender][_spender] = _value;
98     emit Approval(msg.sender, _spender, _value);
99     return true;
100   }
101 
102   function allowance(address _owner, address _spender) public view returns (uint256) { //StandardToken.sol
103     return allowed[_owner][_spender];
104   }
105 
106   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns(bool){
107       //StandardToken.sol, PausableToken.sol
108     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
109     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
110     return true;
111   }
112 
113   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns(bool) {
114       //StandardToken.sol, PausableToken.sol
115     uint256 oldValue = allowed[msg.sender][_spender];
116     if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0;
117     } else                           { allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
118     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
119     return true;
120   }
121 
122   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {//BasicToken.sol, PausableToken.sol
123     require(_to != address(0));
124     require(_value <= balances[msg.sender]);
125     require(locked[msg.sender] != true);                                                             // new
126     require(locked[_to] != true);                                                                    // new
127     balances[msg.sender] = balances[msg.sender].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     emit Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {  
134       //StandardToken.sol, PausableToken.sol
135     require(_to != address(0));
136     require(_value <= balances[_from]);
137     require(_value <= allowed[_from][msg.sender]);
138     require(locked[_from] != true);                                                             // new
139     require(locked[_to] != true);                                                               // new
140     balances[_from] = balances[_from].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
143     emit Transfer(_from, _to, _value);
144     return true;
145   }
146 
147   function transferOwnership(address _newOwner) public onlyOwner {   //Ownable.sol
148     _transferOwnership(_newOwner);
149   }
150 
151   function _transferOwnership(address _newOwner) internal {   //Ownable.sol
152     require(_newOwner != address(0));
153     emit OwnershipTransferred(owner, _newOwner);
154     owner = _newOwner;
155   }
156 
157   function pause() onlyOwner whenNotPaused public {   //Pausable.sol, stop whole transfer
158     paused = true;
159     emit Pause();
160   }
161 
162   function unpause() onlyOwner whenPaused public {   //Pausable.sol
163     paused = false;
164     emit Unpause();
165   }
166 
167   function mint(address _to, uint256 _amount, string _reason) hasMintPermission canMint public returns (bool)  { 
168       //MintableToken.sol, CappedToken.sol
169     require(totalSupply_.add(_amount) <= cap);
170     totalSupply_ = totalSupply_.add(_amount);
171     balances[_to] = balances[_to].add(_amount);
172     emit Mint(_to, _amount, _reason);
173     emit Transfer(address(0), _to, _amount);
174     return true;
175   }
176 
177   function finishMinting() onlyOwner canMint public returns (bool) { //MintableToken.sol
178     mintingFinished = true;
179     emit MintFinished();
180     return true;
181   }
182 
183   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
184     selfdestruct(_recipient);
185   }
186   
187 /* new functions */
188   function startMinting(string reason) onlyOwner cannotMint public returns (bool) {
189     mintingFinished = false;
190     emit MintStarted(reason);
191     return true;
192   }
193 
194   function burnOf(address _who, uint256 _value) public onlyOwner { // burn by owner
195     _burn(_who, _value);
196   }
197 
198   function setCap(uint256 _cap, string _reason) public onlyOwner {
199     _setCap(_cap, _reason);
200   }
201 
202   function _setCap(uint256 _cap, string _reason) internal onlyOwner { // change the limit of cap
203     cap = _cap;
204     emit CapChange(_cap, _reason);
205   }
206   
207   function multiTransfer(address[] _to, uint256[] _amount) whenNotPaused public returns (bool) {
208     require(locked[msg.sender] != true);
209     require(_to.length == _amount.length);
210     uint256 i;
211     uint256 amountSum = 0;
212     for (i=0; i < _amount.length; i++){
213       require(_amount[i] > 0);
214       require(_to[i] != address(0));
215       require(locked[_to[i]] != true);                                                            
216       amountSum = amountSum.add(_amount[i]);
217     }
218     require(amountSum <= balances[msg.sender]);
219     for (i=0; i < _to.length; i++){
220       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
221       emit Transfer(msg.sender, _to[i], _amount[i]);
222     }
223     balances[msg.sender] = balances[msg.sender].sub(amountSum);
224     return true;
225   }
226   
227   function multiMint(address[] _to, uint256[] _amount, string _reason) hasMintPermission canMint public returns (bool) {
228     require(_to.length == _amount.length);
229     uint16 i;              // less than 65536 at one time
230     uint256 amountSum = 0;
231     for (i=0; i < _amount.length; i++){
232       require(_amount[i] > 0);
233       require(_to[i] != address(0));
234       amountSum = amountSum.add(_amount[i]);
235     }
236     require(totalSupply_.add(amountSum) <= cap);
237     for (i=0; i < _to.length; i++){
238       mint(_to[i], _amount[i], _reason);
239     }
240     return true;
241   }
242   
243   function lock(address _lockAddress) public onlyOwner returns (bool) {  // stop _lockAddress's transfer
244     require(_lockAddress != address(0));
245     require(_lockAddress != owner);
246     require(locked[_lockAddress] != true);
247     locked[_lockAddress] = true;
248     emit Lock(_lockAddress);
249     return true;
250   }
251 
252   function unlock(address _lockAddress) public onlyOwner returns (bool) {
253     require(_lockAddress != address(0));
254     require(_lockAddress != owner);
255     require(locked[_lockAddress] ==  true);
256     locked[_lockAddress] = false;
257     emit Unlock(_lockAddress);
258     return true;
259   }
260 
261   function multiLock(address[] _lockAddress) public onlyOwner {
262     for (uint i=0; i < _lockAddress.length; i++){
263       lock(_lockAddress[i]);
264     }
265   }
266 
267   function multiUnlock(address[] _lockAddress) public onlyOwner {
268     for (uint i=0; i < _lockAddress.length; i++){
269       unlock(_lockAddress[i]);
270     }
271   }
272   
273   function checkLock(address _address) public view onlyOwner returns (bool) {
274     return locked[_address];
275   }
276 
277 }