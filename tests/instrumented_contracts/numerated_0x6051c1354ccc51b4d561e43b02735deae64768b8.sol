1 /**
2         _____________             
3 _____  ____  __ \__(_)___________ 
4 __  / / /_  /_/ /_  /__  ___/  _ \
5 _  /_/ /_  _, _/_  / _(__  )/  __/
6 _\__, / /_/ |_| /_/  /____/ \___/ 
7 /____/                            
8 
9 */
10 
11 pragma solidity 0.6.0;
12 
13 library SafeMath {
14   /**
15   * @dev Multiplies two unsigned integers, reverts on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
19     // benefit is lost if 'b' is also tested.
20     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
21     if (a == 0) {
22         return 0;
23     }
24 
25     uint256 c = a * b;
26     require(c / a == b);
27 
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // Solidity only automatically asserts when dividing by 0
36     require(b > 0);
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40     return c;
41   }
42 
43   /**
44   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
45   */
46   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47     require(b <= a);
48     uint256 c = a - b;
49 
50     return c;
51   }
52 
53   /**
54   * @dev Adds two unsigned integers, reverts on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     require(c >= a);
59 
60     return c;
61   }
62 
63   /**
64   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
65   * reverts when dividing by zero.
66   */
67   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68     require(b != 0);
69     return a % b;
70   }
71 }
72 
73 contract Ownable {
74   address public _owner;
75 
76   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
77 
78   constructor () public {
79     _owner = msg.sender;
80     emit OwnershipTransferred(address(0), msg.sender);
81   }
82 
83   function owner() public view returns (address) {
84     return _owner;
85   }
86 
87   modifier onlyOwner() {
88     require(_owner == msg.sender, "Ownable: caller is not the owner");
89     _;
90   }
91 
92   function renounceOwnership() public virtual onlyOwner {
93     emit OwnershipTransferred(_owner, address(0));
94     _owner = address(0);
95   }
96 
97   function transferOwnership(address newOwner) public virtual onlyOwner {
98     require(newOwner != address(0), "Ownable: new owner is the zero address");
99     emit OwnershipTransferred(_owner, newOwner);
100     _owner = newOwner;
101   }
102 }
103 
104 contract yRiseToken is Ownable {
105   using SafeMath for uint256;
106 
107   // standard ERC20 variables. 
108   string public constant name = "yRise.Finance";
109   string public constant symbol = "yRise";
110   uint256 public constant decimals = 18;
111   // the supply will not exceed 30,000 yRise
112   uint256 private constant _maximumSupply = 30000 * 10 ** decimals;
113   uint256 private constant _maximumPresaleBurnAmount = 9000 * 10 ** decimals;
114   uint256 public _presaleBurnTotal = 0;
115   uint256 public _stakingBurnTotal = 0;
116   // owner of the contract
117   uint256 public _totalSupply;
118 
119   // events
120   event Transfer(address indexed from, address indexed to, uint256 value);
121   event Approval(address indexed owner, address indexed spender, uint256 value);
122 
123   // mappings
124   mapping(address => uint256) public _balanceOf;
125   mapping(address => mapping(address => uint256)) public allowance;
126 
127   constructor() public override {
128     // transfer the entire supply into the address of the Contract creator.
129     _owner = msg.sender;
130     _totalSupply = _maximumSupply;
131     _balanceOf[msg.sender] = _maximumSupply;
132     emit Transfer(address(0x0), msg.sender, _maximumSupply);
133   }
134 
135   function totalSupply () public view returns (uint256) {
136     return _totalSupply; 
137   }
138 
139   function balanceOf (address who) public view returns (uint256) {
140     return _balanceOf[who];
141   }
142 
143   // ensure the address is valid.
144   function _transfer(address _from, address _to, uint256 _value) internal {
145     _balanceOf[_from] = _balanceOf[_from].sub(_value);
146     _balanceOf[_to] = _balanceOf[_to].add(_value);
147     emit Transfer(_from, _to, _value);
148   }
149 
150   // send tokens
151   function transfer(address _to, uint256 _value) public returns (bool success) {
152     require(_balanceOf[msg.sender] >= _value);
153     _transfer(msg.sender, _to, _value);
154     return true;
155   }
156 
157   // handles presale burn + staking burn.
158   function burn (uint256 _burnAmount, bool _presaleBurn) public onlyOwner returns (bool success) {
159     if (_presaleBurn) {
160       require(_presaleBurnTotal.add(_burnAmount) <= _maximumPresaleBurnAmount);
161       require(_balanceOf[msg.sender] >= _burnAmount);
162       _presaleBurnTotal = _presaleBurnTotal.add(_burnAmount);
163       _transfer(_owner, address(0), _burnAmount);
164       _totalSupply = _totalSupply.sub(_burnAmount);
165     } else {
166       require(_balanceOf[msg.sender] >= _burnAmount);
167       _transfer(_owner, address(0), _burnAmount);
168       _totalSupply = _totalSupply.sub(_burnAmount);
169     }
170     return true;
171   }
172 
173   // approve tokens
174   function approve(address _spender, uint256 _value) public returns (bool success) {
175     require(_spender != address(0));
176     allowance[msg.sender][_spender] = _value;
177     emit Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   // transfer from
182   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
183     require(_value <= _balanceOf[_from]);
184     require(_value <= allowance[_from][msg.sender]);
185     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
186     _transfer(_from, _to, _value);
187     return true;
188   }
189 }