1 pragma solidity ^0.4.24;
2 
3 contract TokenRelay {
4     using SafeMath for uint256;
5     
6     uint256 constant Ilen = 5;
7     
8     struct Interval {
9         uint256 start;
10         address contractAddr;
11         uint256[Ilen] tick;
12         uint256[Ilen] fee; // for example, 100 means 100%
13     }
14     
15     mapping (address => uint256) private balances;
16     mapping (address => Interval) private position;
17     address private feeOwner;
18     
19     event Deposit(address _tokenAddr, address _beneficary, uint256 _amount);
20     event Redeem(address _addr, uint256 _amount, uint256 _fee);
21     
22     constructor() public {
23         feeOwner = msg.sender;
24     }
25     
26     function tokenStorage(
27         address _tokenAddr,
28         address _beneficary,
29         uint256 _amount,
30         uint256[Ilen] _tick,
31         uint256[Ilen] _fee
32     ) public {
33         require(balances[_beneficary] <= 0, "Require balance of this address is zero.");
34         balances[_beneficary] = 0;
35         ERC20Token erc20 = ERC20Token(_tokenAddr);
36         if (erc20.transferFrom(msg.sender, address(this), _amount) == true) {
37             balances[_beneficary] = _amount;
38             position[_beneficary] = Interval(block.timestamp, _tokenAddr, _tick, _fee);
39         }
40         emit Deposit(_tokenAddr, _beneficary, _amount);
41     }
42     
43     function redeem(uint256 _amount) public {
44         require(_amount > 0, "You should give a number more than zero!");
45         require(balances[msg.sender] > _amount, "You don't have enough balance to redeem!");
46         
47         uint256 feeRatio = getRedeemFee(msg.sender);
48         uint256 total = _amount;
49         balances[msg.sender] =  balances[msg.sender].sub(_amount);
50         uint256 fee = total.mul(feeRatio).div(100);
51         uint256 left = total.sub(fee);
52         
53         ERC20Token erc20 = ERC20Token(position[msg.sender].contractAddr);
54         if (erc20.transfer(msg.sender, left) == true) {
55             balances[feeOwner].add(fee);
56         }
57         emit Redeem(msg.sender, left, fee);
58     }
59     
60     /* internal function */
61     function getRedeemFee(address _addr) internal view returns(uint256) {
62         for (uint i = 0; i < Ilen; i++) {
63             if (block.timestamp <= position[_addr].tick[i]) {
64                 return position[_addr].fee[i];
65             }
66         }
67         return position[_addr].fee[4];
68     }
69 
70     /* readonly */
71     function balanceOf(address _addr) public view returns(uint256) {
72         return balances[_addr];
73     }
74     
75     function redeemFee(address _addr) public view returns(uint256 feeInRatio) {
76         return getRedeemFee(_addr);
77     }
78     
79     function redeemInterval(address _addr) public view returns(uint256 start, uint256[5] tick, uint256[5] fee) {
80         start = position[_addr].start;
81         tick = position[_addr].tick;
82         fee = position[_addr].fee;
83     }
84     
85 }
86 
87 interface ERC20Token {
88     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
89     function transfer(address _to, uint256 _value) external returns (bool success);
90 }
91 
92 
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that revert on error
96  */
97 library SafeMath {
98 
99   /**
100   * @dev Multiplies two numbers, reverts on overflow.
101   */
102   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104     // benefit is lost if 'b' is also tested.
105     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106     if (a == 0) {
107       return 0;
108     }
109 
110     uint256 c = a * b;
111     require(c / a == b);
112 
113     return c;
114   }
115 
116   /**
117   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
118   */
119   function div(uint256 a, uint256 b) internal pure returns (uint256) {
120     require(b > 0); // Solidity only automatically asserts when dividing by 0
121     uint256 c = a / b;
122     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
123 
124     return c;
125   }
126 
127   /**
128   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     require(b <= a);
132     uint256 c = a - b;
133 
134     return c;
135   }
136 
137   /**
138   * @dev Adds two numbers, reverts on overflow.
139   */
140   function add(uint256 a, uint256 b) internal pure returns (uint256) {
141     uint256 c = a + b;
142     require(c >= a);
143 
144     return c;
145   }
146 
147   /**
148   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
149   * reverts when dividing by zero.
150   */
151   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
152     require(b != 0);
153     return a % b;
154   }
155 }