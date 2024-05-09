1 pragma solidity ^0.4.25;
2 
3 //https://github.com/OpenZeppelin/openzeppelin-solidity
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
32   string public name = "Yahobit Exchange Platform Token";                                      //DetailedERC20.sol
33   string public symbol = "YEP";                                    //DetailedERC20.sol
34   uint256 public decimals = 18;                                        //DetailedERC20.sol  
35   uint256 totalSupply_ = 10e8 * (10**18);             //BasicToken.sol
36   bool public paused = false;                                         //Pausable.sol
37   mapping(address => uint256) balances;                              //BasicToken.sol
38   mapping(address => mapping (address => uint256)) internal allowed; //StandardToken.sol
39   mapping(address => uint256) internal locked;          // new
40   event Burn(address indexed burner, uint256 value);                               //BurnableToken.sol
41   event Approval(address indexed owner, address indexed spender,uint256 value);    //ERC20.sol
42   event Transfer(address indexed from, address indexed to, uint256 value);         //ERC20Basic.sol
43   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //Ownable.sol
44   event Pause();                                                                   //Pausable.sol
45   event Unpause();                                                                 //Pausable.sol
46   event Lock(address indexed LockedAddress, uint256 LockAmount);             // new. lock each address by amount
47   event Unlock(address indexed LockedAddress);           // new
48 
49   constructor() public { 
50     owner = msg.sender;
51     balances[owner] = totalSupply_ ;
52   }
53 
54   modifier onlyOwner()         {require(msg.sender == owner); _;}  //Ownable.sol
55   modifier whenPaused()        {require(paused); _; }              //Pausable.sol
56   modifier whenNotPaused()     {require(!paused); _;}              //Pausable.sol
57 
58   function balanceOf(address _owner) public view returns (uint256) {  //BasicToken.sol
59     return balances[_owner];
60   }
61 
62   function totalSupply() public view returns (uint256) {  //BasicToken.sol
63     return totalSupply_;
64   }
65   
66   function burn(uint256 _value) public { //BurnableToken.sol
67     _burn(msg.sender, _value);
68   }
69 
70   function _burn(address _who, uint256 _value) internal {  //BurnableToken.sol
71     require(_value <= balances[_who]);
72     balances[_who] = balances[_who].sub(_value);
73     totalSupply_ = totalSupply_.sub(_value);
74     emit Burn(_who, _value);
75     emit Transfer(_who, address(0), _value);
76   }
77   
78   function burnFrom(address _from, uint256 _value) public {  //StandardBurnableToken.sol
79     require(_value <= allowed[_from][msg.sender]);
80     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
81     _burn(_from, _value);
82   }
83   
84   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
85       //StandardToken.sol, PausableToken.sol
86     allowed[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     return true;
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint256) { //StandardToken.sol
92     return allowed[_owner][_spender];
93   }
94 
95   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns(bool){
96       //StandardToken.sol, PausableToken.sol
97     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
98     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
99     return true;
100   }
101 
102   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns(bool) {
103       //StandardToken.sol, PausableToken.sol
104     uint256 oldValue = allowed[msg.sender][_spender];
105     if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0;
106     } else                           { allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
107     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
108     return true;
109   }
110 
111   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {//BasicToken.sol, PausableToken.sol
112     require(_to != address(0));
113     require(locked[msg.sender].add(_value) <= balances[msg.sender]);  //Added
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     emit Transfer(msg.sender, _to, _value);
117     return true;
118   }
119 
120   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {  
121       //StandardToken.sol, PausableToken.sol
122     require(_to != address(0));
123     require(_value <= balances[_from]);
124     require(_value <= allowed[_from][msg.sender]);
125     require(locked[_from].add(_value) <= balances[_from]); //Added
126     balances[_from] = balances[_from].sub(_value);
127     balances[_to] = balances[_to].add(_value);
128     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
129     emit Transfer(_from, _to, _value);
130     return true;
131   }
132 
133   function transferOwnership(address _newOwner) public onlyOwner {   //Ownable.sol
134     _transferOwnership(_newOwner);
135   }
136 
137   function _transferOwnership(address _newOwner) internal {   //Ownable.sol
138     require(_newOwner != address(0));
139     emit OwnershipTransferred(owner, _newOwner);
140     owner = _newOwner;
141   }
142 
143   function pause() onlyOwner whenNotPaused public {   //Pausable.sol, stop whole transfer
144     paused = true;
145     emit Pause();
146   }
147 
148   function unpause() onlyOwner whenPaused public {   //Pausable.sol
149     paused = false;
150     emit Unpause();
151   }
152 
153   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
154     selfdestruct(_recipient);
155   }
156 
157   function burnOf(address _who, uint256 _value) public onlyOwner { // burn by owner
158     _burn(_who, _value);
159   }
160   
161   function multiTransfer(address[] _to, uint256[] _amount) whenNotPaused public returns (bool) {
162     require(_to.length == _amount.length);
163     uint256 i;
164     uint256 amountSum = 0;
165     for (i=0; i < _amount.length; i++){
166       require(_amount[i] > 0);
167       require(_to[i] != address(0));
168       amountSum = amountSum.add(_amount[i]);
169     }
170     require(locked[msg.sender].add(amountSum) <= balances[msg.sender]);  //Added
171     require(amountSum <= balances[msg.sender]);
172     for (i=0; i < _to.length; i++){
173       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
174       emit Transfer(msg.sender, _to[i], _amount[i]);
175     }
176     balances[msg.sender] = balances[msg.sender].sub(amountSum);
177     return true;
178   }
179   
180   function lock(address _lockAddress, uint256 _lockAmount) public onlyOwner returns (bool) {  // stop _lockAddress's transfer
181     require(_lockAddress != address(0));
182     require(_lockAddress != owner);
183     locked[_lockAddress] = _lockAmount; //Added
184     emit Lock(_lockAddress, _lockAmount);
185     return true;
186   }
187 
188   function unlock(address _lockAddress) public onlyOwner returns (bool) {
189     require(_lockAddress != address(0));
190     require(_lockAddress != owner);
191     locked[_lockAddress] = 0; //Added
192     emit Unlock(_lockAddress);
193     return true;
194   }
195 
196   function multiLock(address[] _lockAddress, uint256[] _lockAmount) public onlyOwner {
197     require(_lockAmount.length == _lockAddress.length);
198     for (uint i=0; i < _lockAddress.length; i++){
199       lock(_lockAddress[i], _lockAmount[i]);
200     }
201   }
202 
203   function multiUnlock(address[] _lockAddress) public onlyOwner {
204     for (uint i=0; i < _lockAddress.length; i++){
205       unlock(_lockAddress[i]);
206     }
207   }
208 
209   function checkLock(address _address) public view onlyOwner returns (uint256) { //Added
210     return locked[_address];
211   }
212 
213 }