1 pragma solidity 0.6.0;
2 
3 library SafeMath {
4   /**
5   * @dev Multiplies two unsigned integers, reverts on overflow.
6   */
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9     // benefit is lost if 'b' is also tested.
10     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11     if (a == 0) {
12         return 0;
13     }
14 
15     uint256 c = a * b;
16     require(c / a == b);
17 
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // Solidity only automatically asserts when dividing by 0
26     require(b > 0);
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30     return c;
31   }
32 
33   /**
34   * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     require(b <= a);
38     uint256 c = a - b;
39 
40     return c;
41   }
42 
43   /**
44   * @dev Adds two unsigned integers, reverts on overflow.
45   */
46   function add(uint256 a, uint256 b) internal pure returns (uint256) {
47     uint256 c = a + b;
48     require(c >= a);
49 
50     return c;
51   }
52 
53   /**
54   * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55   * reverts when dividing by zero.
56   */
57   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58     require(b != 0);
59     return a % b;
60   }
61 }
62 
63 contract Ownable {
64   address public _owner;
65 
66   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68   constructor () public {
69     _owner = msg.sender;
70     emit OwnershipTransferred(address(0), msg.sender);
71   }
72 
73   function owner() public view returns (address) {
74     return _owner;
75   }
76 
77   modifier onlyOwner() {
78     require(_owner == msg.sender, "Ownable: caller is not the owner");
79     _;
80   }
81 
82   function renounceOwnership() public virtual onlyOwner {
83     emit OwnershipTransferred(_owner, address(0));
84     _owner = address(0);
85   }
86 
87   function transferOwnership(address newOwner) public virtual onlyOwner {
88     require(newOwner != address(0), "Ownable: new owner is the zero address");
89     emit OwnershipTransferred(_owner, newOwner);
90     _owner = newOwner;
91   }
92 }
93 
94 contract YFMSToken is Ownable {
95   using SafeMath for uint256;
96 
97   // standard ERC20 variables. 
98   string public constant name = "YFMoonshot";
99   string public constant symbol = "YFMS";
100   uint256 public constant decimals = 18;
101   // the supply will not exceed 35,000 YFMS
102   uint256 private constant _maximumSupply = 35000 * 10 ** decimals;
103   uint256 private constant _maximumPresaleBurnAmount = 10000 * 10 ** decimals;
104   uint256 public _presaleBurnTotal = 0;
105   uint256 public _stakingBurnTotal = 0;
106   // owner of the contract
107   uint256 public _totalSupply;
108 
109   // events
110   event Transfer(address indexed from, address indexed to, uint256 value);
111   event Approval(address indexed owner, address indexed spender, uint256 value);
112 
113   // mappings
114   mapping(address => uint256) public _balanceOf;
115   mapping(address => mapping(address => uint256)) public allowance;
116 
117   constructor() public override {
118     // transfer the entire supply into the address of the Contract creator.
119     _owner = msg.sender;
120     _totalSupply = _maximumSupply;
121     _balanceOf[msg.sender] = _maximumSupply;
122     emit Transfer(address(0x0), msg.sender, _maximumSupply);
123   }
124 
125   function totalSupply () public view returns (uint256) {
126     return _totalSupply; 
127   }
128 
129   function balanceOf (address who) public view returns (uint256) {
130     return _balanceOf[who];
131   }
132 
133   // ensure the address is valid.
134   function _transfer(address _from, address _to, uint256 _value) internal {
135     _balanceOf[_from] = _balanceOf[_from].sub(_value);
136     _balanceOf[_to] = _balanceOf[_to].add(_value);
137     emit Transfer(_from, _to, _value);
138   }
139 
140   // send tokens
141   function transfer(address _to, uint256 _value) public returns (bool success) {
142     require(_balanceOf[msg.sender] >= _value);
143     _transfer(msg.sender, _to, _value);
144     return true;
145   }
146 
147   // handles presale burn + staking burn.
148   function burn (uint256 _burnAmount, bool _presaleBurn) public onlyOwner returns (bool success) {
149     if (_presaleBurn) {
150       require(_presaleBurnTotal.add(_burnAmount) <= _maximumPresaleBurnAmount);
151       require(_balanceOf[msg.sender] >= _burnAmount);
152       _presaleBurnTotal = _presaleBurnTotal.add(_burnAmount);
153       _transfer(_owner, address(0), _burnAmount);
154       _totalSupply = _totalSupply.sub(_burnAmount);
155     } else {
156       require(_balanceOf[msg.sender] >= _burnAmount);
157       _transfer(_owner, address(0), _burnAmount);
158       _totalSupply = _totalSupply.sub(_burnAmount);
159     }
160     return true;
161   }
162 
163   // approve tokens
164   function approve(address _spender, uint256 _value) public returns (bool success) {
165     require(_spender != address(0));
166     allowance[msg.sender][_spender] = _value;
167     emit Approval(msg.sender, _spender, _value);
168     return true;
169   }
170 
171   // transfer from
172   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
173     require(_value <= _balanceOf[_from]);
174     require(_value <= allowance[_from][msg.sender]);
175     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
176     _transfer(_from, _to, _value);
177     return true;
178   }
179 }