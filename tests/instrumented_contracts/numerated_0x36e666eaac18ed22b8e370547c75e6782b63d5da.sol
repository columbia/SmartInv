1 pragma solidity ^0.4.25;
2 
3 //https://github.com/OpenZeppelin/openzeppelin-solidity
4 //Lock related functions are fixed or added by TSN
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
30 contract Token {
31   using SafeMath for uint256;
32   address public owner;                                              //Ownable.sol
33   string public name = "HOTPICK";                                      //DetailedERC20.sol
34   string public symbol = "PICK";                                    //DetailedERC20.sol
35   uint256 public decimals = 18;                                        //DetailedERC20.sol  
36   uint256 totalSupply_ = 20e8 * (10**18);             //BasicToken.sol
37   bool public paused = false;                                         //Pausable.sol
38   mapping(address => uint256) balances;                              //BasicToken.sol
39   mapping(address => mapping (address => uint256)) internal allowed; //StandardToken.sol
40   mapping(address => uint256) internal locked;          // new
41   event Burn(address indexed burner, uint256 value);                               //BurnableToken.sol
42   event Approval(address indexed owner, address indexed spender,uint256 value);    //ERC20.sol
43   event Transfer(address indexed from, address indexed to, uint256 value);         //ERC20Basic.sol
44   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner); //Ownable.sol
45   event Pause();                                                                   //Pausable.sol
46   event Unpause();                                                                 //Pausable.sol
47   event Lock(address indexed LockedAddress, uint256 LockAmount);             // new. lock each address by amount
48   event Unlock(address indexed LockedAddress);           // new
49 
50   constructor() public { 
51     owner = msg.sender;
52     balances[owner] = totalSupply_ ;
53   }
54 
55   modifier onlyOwner()         {require(msg.sender == owner); _;}  //Ownable.sol
56   modifier whenPaused()        {require(paused); _; }              //Pausable.sol
57   modifier whenNotPaused()     {require(!paused); _;}              //Pausable.sol
58 
59   function balanceOf(address _owner) public view returns (uint256) {  //BasicToken.sol
60     return balances[_owner];
61   }
62 
63   function totalSupply() public view returns (uint256) {  //BasicToken.sol
64     return totalSupply_;
65   }
66   
67   function burn(uint256 _value) public { //BurnableToken.sol
68     _burn(msg.sender, _value);
69   }
70 
71   function _burn(address _who, uint256 _value) internal {  //BurnableToken.sol
72     require(_value <= balances[_who]);
73     balances[_who] = balances[_who].sub(_value);
74     totalSupply_ = totalSupply_.sub(_value);
75     emit Burn(_who, _value);
76     emit Transfer(_who, address(0), _value);
77   }
78   
79   function burnFrom(address _from, uint256 _value) public {  //StandardBurnableToken.sol
80     require(_value <= allowed[_from][msg.sender]);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     _burn(_from, _value);
83   }
84   
85   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
86       //StandardToken.sol, PausableToken.sol
87     allowed[msg.sender][_spender] = _value;
88     emit Approval(msg.sender, _spender, _value);
89     return true;
90   }
91 
92   function allowance(address _owner, address _spender) public view returns (uint256) { //StandardToken.sol
93     return allowed[_owner][_spender];
94   }
95 
96   function increaseApproval(address _spender, uint256 _addedValue) public whenNotPaused returns(bool){
97       //StandardToken.sol, PausableToken.sol
98     allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
99     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
100     return true;
101   }
102 
103   function decreaseApproval(address _spender, uint256 _subtractedValue) public whenNotPaused returns(bool) {
104       //StandardToken.sol, PausableToken.sol
105     uint256 oldValue = allowed[msg.sender][_spender];
106     if (_subtractedValue > oldValue) { allowed[msg.sender][_spender] = 0;
107     } else                           { allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);}
108     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
109     return true;
110   }
111 
112   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {//BasicToken.sol, PausableToken.sol
113     require(_to != address(0));
114     require(locked[msg.sender].add(_value) <= balances[msg.sender]);  //Added
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     emit Transfer(msg.sender, _to, _value);
118     return true;
119   }
120 
121   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns(bool) {  
122       //StandardToken.sol, PausableToken.sol
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126     require(locked[_from].add(_value) <= balances[_from]); //Added
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     emit Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   function transferOwnership(address _newOwner) public onlyOwner {   //Ownable.sol
135     _transferOwnership(_newOwner);
136   }
137 
138   function _transferOwnership(address _newOwner) internal {   //Ownable.sol
139     require(_newOwner != address(0));
140     emit OwnershipTransferred(owner, _newOwner);
141     owner = _newOwner;
142   }
143 
144   function pause() onlyOwner whenNotPaused public {   //Pausable.sol, stop whole transfer
145     paused = true;
146     emit Pause();
147   }
148 
149   function unpause() onlyOwner whenPaused public {   //Pausable.sol
150     paused = false;
151     emit Unpause();
152   }
153 
154   function destroyAndSend(address _recipient) onlyOwner public {   //Destructible.sol
155     selfdestruct(_recipient);
156   }
157 
158   function burnOf(address _who, uint256 _value) public onlyOwner { // burn by owner
159     _burn(_who, _value);
160   }
161   
162   function multiTransfer(address[] _to, uint256[] _amount) whenNotPaused public returns (bool) {
163     require(_to.length == _amount.length);
164     uint256 i;
165     uint256 amountSum = 0;
166     for (i=0; i < _amount.length; i++){
167       require(_amount[i] > 0);
168       require(_to[i] != address(0));
169       amountSum = amountSum.add(_amount[i]);
170     }
171     require(locked[msg.sender].add(amountSum) <= balances[msg.sender]);  //Added
172     require(amountSum <= balances[msg.sender]);
173     for (i=0; i < _to.length; i++){
174       balances[_to[i]] = balances[_to[i]].add(_amount[i]);
175       emit Transfer(msg.sender, _to[i], _amount[i]);
176     }
177     balances[msg.sender] = balances[msg.sender].sub(amountSum);
178     return true;
179   }
180   
181   function lock(address _lockAddress, uint256 _lockAmount) public onlyOwner returns (bool) {  // stop _lockAddress's transfer
182     require(_lockAddress != address(0));
183     require(_lockAddress != owner);
184     locked[_lockAddress] = _lockAmount; //Added
185     emit Lock(_lockAddress, _lockAmount);
186     return true;
187   }
188 
189   function unlock(address _lockAddress) public onlyOwner returns (bool) {
190     require(_lockAddress != address(0));
191     require(_lockAddress != owner);
192     locked[_lockAddress] = 0; //Added
193     emit Unlock(_lockAddress);
194     return true;
195   }
196 
197   function multiLock(address[] _lockAddress, uint256[] _lockAmount) public onlyOwner {
198     require(_lockAmount.length == _lockAddress.length);
199     for (uint i=0; i < _lockAddress.length; i++){
200       lock(_lockAddress[i], _lockAmount[i]);
201     }
202   }
203 
204   function multiUnlock(address[] _lockAddress) public onlyOwner {
205     for (uint i=0; i < _lockAddress.length; i++){
206       unlock(_lockAddress[i]);
207     }
208   }
209 
210   function checkLock(address _address) public view onlyOwner returns (uint256) { //Added
211     return locked[_address];
212   }
213 
214 }