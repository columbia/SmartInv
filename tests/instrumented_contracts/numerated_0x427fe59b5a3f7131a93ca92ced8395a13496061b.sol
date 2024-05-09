1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 contract SafeMath {
7   function mul(uint256 _a, uint256 _b) internal pure returns (uint256){
8     if (_a == 0) {
9       return 0;
10     }
11     uint256 c = _a * _b;
12     assert(c / _a == _b);
13     return c;
14   }
15 
16   function div(uint256 _a, uint256 _b) internal pure returns (uint256){
17     uint256 c = _a / _b;
18     // assert(b > 0); // Solidity automatically throws when dividing by 0
19     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20     return c;
21   }
22 
23   function sub(uint256 _a, uint256 _b) internal pure returns (uint256){
24     assert(_b <= _a);
25     return _a - _b;
26   }
27 
28   function add(uint256 _a,uint256 _b) internal pure returns (uint256){
29     uint256 c = _a + _b;
30     assert(c >= _a);
31     return c;
32   }
33 
34 }
35 
36 contract Ownable {
37   address public owner;
38 
39   event OwnershipTransferred(
40     address indexed previousOwner,
41     address indexed newOwner
42   );
43 
44   constructor () public{
45     owner = msg.sender;
46   }
47 
48   modifier onlyOwner {
49     require(msg.sender == owner);
50     _;
51   }
52   function transferOwnership(
53     address _newOwner
54   )
55     onlyOwner
56     public
57   {
58     require(_newOwner != address(0));
59     emit OwnershipTransferred(owner, _newOwner);
60     owner = _newOwner;
61   }
62 }
63 
64 contract ERC20StdToken is Ownable, SafeMath {
65   uint256 public totalSupply;
66 	string  public name;
67 	uint8   public decimals;
68 	string  public symbol;
69 	bool    public isMint;     // 是否可增发
70     bool    public isBurn;    // 是否可销毁
71     bool    public isFreeze; // 是否可冻结
72 
73   mapping (address => uint256) public balanceOf;
74   mapping (address => uint256) public freezeOf;
75   mapping (address => mapping (address => uint256)) public allowance;
76 
77   constructor(
78     address _owner,
79     string _name,
80     string _symbol,
81     uint8 _decimals,
82     uint256 _initialSupply,
83     bool _isMint,
84     bool _isBurn,
85     bool _isFreeze) public {
86     require(_owner != address(0));
87     owner             = _owner;
88   	decimals          = _decimals;
89   	symbol            = _symbol;
90   	name              = _name;
91   	isMint            = _isMint;
92     isBurn            = _isBurn;
93     isFreeze          = _isFreeze;
94   	totalSupply       = _initialSupply * 10 ** uint256(decimals);
95     balanceOf[_owner] = totalSupply;
96  }
97 
98  // This generates a public event on the blockchain that will notify clients
99  event Transfer(address indexed _from, address indexed _to, uint256 _value);
100  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
101 
102  /* This notifies clients about the amount burnt */
103  event Burn(address indexed _from, uint256 value);
104 
105   /* This notifies clients about the amount frozen */
106  event Freeze(address indexed _from, uint256 value);
107 
108   /* This notifies clients about the amount unfrozen */
109  event Unfreeze(address indexed _from, uint256 value);
110 
111  function approve(address _spender, uint256 _value) public returns (bool success) {
112    allowance[msg.sender][_spender] = _value;
113    emit Approval(msg.sender, _spender, _value);
114    success = true;
115  }
116 
117  /// @notice send `_value` token to `_to` from `msg.sender`
118  /// @param _to The address of the recipient
119  /// @param _value The amount of token to be transferred
120  /// @return Whether the transfer was successful or not
121  function transfer(address _to, uint256 _value) public returns (bool success) {
122    require(_to != 0);
123    require(balanceOf[msg.sender] >= _value);
124    require(balanceOf[_to] + _value >= balanceOf[_to]);
125    // balanceOf[msg.sender] -= _value;
126    balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);
127 
128    // balanceOf[_to] += _value;
129    balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
130 
131    emit Transfer(msg.sender, _to, _value);
132    success = true;
133  }
134 
135  /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
136  /// @param _from The address of the sender
137  /// @param _to The address of the recipient
138  /// @param _value The amount of token to be transferred
139  /// @return Whether the transfer was successful or not
140  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
141    require(_to != 0);
142    require(balanceOf[_from] >= _value);
143    require(allowance[_from][msg.sender] >= _value);
144    require(balanceOf[_to] + _value >= balanceOf[_to]);
145    // balanceOf[_from] -= _value;
146    balanceOf[_from] = SafeMath.sub(balanceOf[_from], _value);
147    // balanceOf[_to] += _value;
148    balanceOf[_to] = SafeMath.add(balanceOf[_to], _value);
149 
150    // allowance[_from][msg.sender] -= _value;
151    allowance[_from][msg.sender] = SafeMath.sub(allowance[_from][msg.sender], _value);
152 
153    emit Transfer(_from, _to, _value);
154    success = true;
155  }
156 
157   function mint(uint256 amount) onlyOwner public {
158   	require(isMint);
159   	require(amount >= 0);
160   	// balanceOf[msg.sender] += amount;
161     balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], amount);
162   	// totalSupply += amount;
163     totalSupply = SafeMath.add(totalSupply, amount);
164   }
165 
166   function burn(uint256 _value) public returns (bool success) {
167     require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
168     require(_value > 0);
169     balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                      // Subtract from the sender
170     totalSupply = SafeMath.sub(totalSupply, _value);                                // Updates totalSupply
171     emit Burn(msg.sender, _value);
172     success = true;
173  }
174 
175   function freeze(uint256 _value) public returns (bool success) {
176     require(balanceOf[msg.sender] >= _value);            // Check if the sender has enough
177     require(_value > 0);
178     balanceOf[msg.sender] = SafeMath.sub(balanceOf[msg.sender], _value);                      // Subtract from the sender
179     freezeOf[msg.sender] = SafeMath.add(freezeOf[msg.sender], _value);                                // Updates totalSupply
180     emit Freeze(msg.sender, _value);
181     success = true;
182   }
183 
184   function unfreeze(uint256 _value) public returns (bool success) {
185     require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
186     require(_value > 0);
187     freezeOf[msg.sender] = SafeMath.sub(freezeOf[msg.sender], _value);                      // Subtract from the sender
188     balanceOf[msg.sender] = SafeMath.add(balanceOf[msg.sender], _value);
189     emit Unfreeze(msg.sender, _value);
190     success = true;
191   }
192 }