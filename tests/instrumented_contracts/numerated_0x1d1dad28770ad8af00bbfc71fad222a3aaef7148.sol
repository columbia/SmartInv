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
94 contract LunaCoreToken is Ownable {
95   using SafeMath for uint256;
96 
97   // standard ERC20 variables. 
98   string public constant name = "LunaCore";
99   string public constant symbol = "LUCO";
100   uint256 public constant decimals = 18;
101   // the supply will not exceed 25,000
102   uint256 private constant _maximumSupply = 25000 * 10 ** decimals;
103   // owner of the contract
104   uint256 public _totalSupply;
105 
106   // events
107   event Transfer(address indexed from, address indexed to, uint256 value);
108   event Approval(address indexed owner, address indexed spender, uint256 value);
109 
110   // mappings
111   mapping(address => uint256) public _balanceOf;
112   mapping(address => mapping(address => uint256)) public allowance;
113 
114   constructor() public override {
115     // transfer the entire supply into the address of the Contract creator.
116     _owner = msg.sender;
117     _totalSupply = _maximumSupply;
118     _balanceOf[msg.sender] = _maximumSupply;
119     emit Transfer(address(0), msg.sender, _maximumSupply);
120   }
121 
122   function totalSupply () public view returns (uint256) {
123     return _totalSupply; 
124   }
125 
126   function balanceOf (address who) public view returns (uint256) {
127     return _balanceOf[who];
128   }
129 
130   // ensure the address is valid.
131   function _transfer(address _from, address _to, uint256 _value) internal {
132     _balanceOf[_from] = _balanceOf[_from].sub(_value);
133     _balanceOf[_to] = _balanceOf[_to].add(_value);
134     emit Transfer(_from, _to, _value);
135   }
136 
137   // send tokens
138   function transfer(address _to, uint256 _value) public returns (bool success) {
139     require(_balanceOf[msg.sender] >= _value);
140     _transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   // handles presale burn + staking burn.
145   function burn (uint256 _burnAmount) public onlyOwner returns (bool success) {
146     _transfer(_owner, address(0), _burnAmount);
147     _totalSupply = _totalSupply.sub(_burnAmount);
148     return true;
149   }
150 
151   // approve tokens
152   function approve(address _spender, uint256 _value) public returns (bool success) {
153     require(_spender != address(0));
154     allowance[msg.sender][_spender] = _value;
155     emit Approval(msg.sender, _spender, _value);
156     return true;
157   }
158 
159   // transfer from
160   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
161     require(_value <= _balanceOf[_from]);
162     require(_value <= allowance[_from][msg.sender]);
163     allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
164     _transfer(_from, _to, _value);
165     return true;
166   }
167 }