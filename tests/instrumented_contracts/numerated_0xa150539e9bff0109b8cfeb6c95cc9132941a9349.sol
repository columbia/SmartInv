1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
14     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
15     // benefit is lost if 'b' is also tested.
16     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
17     if (_a == 0) {
18       return 0;
19     }
20 
21     uint256 c = _a * _b;
22     assert(c / _a == _b);
23 
24     return c;
25   }
26 
27   /**
28   * @dev Integer division of two numbers, truncating the quotient.
29   */
30   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
31     // assert(_b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = _a / _b;
33     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
34 
35     return c;
36   }
37 
38   /**
39   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
42     assert(_b <= _a);
43     uint256 c = _a - _b;
44 
45     return c;
46   }
47 
48   /**
49   * @dev Adds two numbers, throws on overflow.
50   */
51   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
52     uint256 c = _a + _b;
53     assert(c >= _a);
54 
55     return c;
56   }
57 }
58 
59 
60 contract PasswordEscrow {
61 
62   using SafeMath for uint256;
63 
64   address public owner;
65   uint256 public commissionFee;
66   uint256 public totalFee;
67 
68   uint256 private randSeed = 50;
69 
70   //data
71   struct Transfer {
72     address from;
73     uint256 amount;
74   }
75 
76   mapping(bytes32 => Transfer) private password;
77   mapping(address => uint256) private randToAddress;
78 
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84   event LogChangeCommissionFee(uint256 fee);
85   event LogChangeOwner(address indexed exOwner, address indexed newOwner);
86   event LogDeposit(address indexed from, uint256 amount);
87   event LogGetTransfer(address indexed from, address indexed recipient, uint256 amount);
88 
89 
90   constructor(uint256 _fee) public {
91     commissionFee = _fee;
92     owner = msg.sender;
93   }
94 
95   function changeCommissionFee(uint256 _fee) public onlyOwner {
96     commissionFee = _fee;
97     emit LogChangeCommissionFee(_fee);
98   }
99 
100   function changeOwner(address _newOwner) public onlyOwner {
101     emit LogChangeOwner(owner, _newOwner);
102     owner = _newOwner;
103   }
104 
105   //escrow
106   function deposit(bytes32 _password) public payable {
107     require(msg.value > commissionFee);
108 
109     uint256 rand = _rand();
110     bytes32 pass = sha3(_password, rand);
111     randToAddress[msg.sender] = rand;
112     password[pass].from = msg.sender;
113     password[pass].amount = password[pass].amount.add(msg.value);
114 
115     _updateSeed();
116 
117     emit LogDeposit(msg.sender, msg.value);
118   }
119 
120   function _rand() private view returns(uint256) {
121     uint256 rand = uint256(sha3(now, block.number, randSeed));
122     return rand %= (10 ** 6);
123   }
124 
125   function _updateSeed() private {
126     randSeed = _rand();
127   }
128 
129   function viewRand() public view returns(uint256) {
130     return randToAddress[msg.sender];
131   }
132 
133   function getTransfer(bytes32 _password, uint256 _number) public {
134     require(password[sha3(_password, _number)].amount > 0);
135 
136     bytes32 pass = sha3(_password, _number);
137     address from = password[pass].from;
138     uint256 amount = password[pass].amount;
139     amount = amount.sub(commissionFee);
140     totalFee = totalFee.add(commissionFee);
141 
142     _updateSeed();
143 
144     password[pass].amount = 0;
145 
146     msg.sender.transfer(amount);
147 
148     emit LogGetTransfer(from, msg.sender, amount);
149   }
150 
151   function withdrawFee() public payable onlyOwner {
152     require( totalFee > 0);
153 
154     uint256 fee = totalFee;
155     totalFee = 0;
156 
157     owner.transfer(fee);
158   }
159 
160   function withdraw() public payable onlyOwner {
161     owner.transfer(this.balance);
162   }
163 
164 
165 }