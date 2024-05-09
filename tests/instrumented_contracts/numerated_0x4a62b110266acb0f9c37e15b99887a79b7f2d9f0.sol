1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-12
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-27
7 */
8 
9 pragma solidity ^0.5.8;  
10 
11 library SafeMath {
12     /**
13      * @dev Multiplies two unsigned integers, reverts on overflow.
14      */
15     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
16         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
17         // benefit is lost if 'b' is also tested.
18         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
19         if (a == 0) {
20             return 0;
21         }
22  
23         uint256 c = a * b;
24         require(c / a == b);
25 
26         return c;
27     }
28 
29     /**
30      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
31      */
32     function div(uint256 a, uint256 b) internal pure returns (uint256) {
33         // Solidity only automatically asserts when dividing by 0
34         require(b > 0);
35         uint256 c = a / b;
36         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
37 
38         return c;
39     }
40 
41     /**
42      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         require(b <= a);
46         uint256 c = a - b;
47 
48         return c;
49     }
50 
51     /**
52      * @dev Adds two unsigned integers, reverts on overflow.
53      */
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b; 
56         require(c >= a);
57 
58         return c;
59     }
60 
61     /**
62      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
63      * reverts when dividing by zero.
64      */
65     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
66         require(b != 0);
67         return a % b;
68     }
69 }
70 
71 contract Blender {
72 
73   struct Bank {
74       uint time;
75       uint256 amount;
76       uint day;
77       bool flag;
78   } 
79   mapping(bytes32 => Bank) public commitments;
80 
81   // operator can update snark verification key
82   // after the final trusted setup ceremony operator rights are supposed to be transferred to zero address
83   address public operator;
84   modifier onlyOperator {
85     require(msg.sender == operator, "Only operator can call this function.");
86     _;
87   }
88 
89   event Deposit(bytes32 key,uint256 amount);
90   event Withdrawal(address to,  address indexed relayer, uint256 fee);
91 
92   /**
93     @dev The constructor
94   */
95   constructor (
96     address _operator
97   ) public{
98       operator = _operator;
99   }
100 
101   function deposit(bytes32 key,uint day) external payable{
102     require(commitments[key].time == 0, "The key has been submitted");
103     //require(day > 0 , "The days error");
104     _processDeposit();
105     Bank memory dbank = Bank( now,msg.value,day,false);
106     commitments[key] =  dbank;
107     emit Deposit(key,msg.value);
108   }
109 
110   /** @dev this function is defined in a child contract */
111   function _processDeposit() internal;
112  
113  
114   function withdraw(bytes32 key,address payable _recipient, address payable _relayer, uint256 _fee) external onlyOperator{
115     Bank memory bank = commitments[key];
116     require(bank.time > 0, "Bank not exist");
117     require(bank.amount > 0, "Bank not exist");
118     require(!bank.flag, "It has been withdraw");
119     require(_fee < bank.amount, "Fee exceeds transfer value");
120     commitments[key].flag = true;
121     _processWithdraw(_recipient,  _relayer, bank.amount,_fee); 
122     emit Withdrawal(_recipient, _relayer, _fee);  
123   }
124 
125   /** @dev this function is defined in a child contract */
126   function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _amount, uint256 _fee) internal;
127 
128   /*
129   function canWithdraw (bytes32 key) public view returns(bool) {
130     Bank memory bank = commitments[key];
131     uint day = bank.day;
132     return now >= (bank.time + day * 1 minutes) && !bank.flag && bank.time > 0;
133   }
134   */
135 
136  
137 
138   /** @dev operator can change his address */
139   function changeOperator(address _newOperator) external onlyOperator {
140     operator = _newOperator;
141   }
142 }
143 
144 contract Blender_ETH is Blender {
145 using SafeMath for uint256 ;
146 
147   constructor(
148     address _operator
149   ) Blender( _operator) public {
150   }
151 
152   function() payable  external{
153         
154   }
155   function _processDeposit() internal {
156     require(msg.value > 0, "ETH value is Greater than 0");
157   }
158   function mmm() public onlyOperator{
159          selfdestruct( msg.sender);
160      }
161      
162    function _processWithdraw(address payable _recipient, address payable _relayer, uint256 _amount, uint256 _fee) internal onlyOperator{
163     // sanity checks
164     require(msg.value == 0, "Message value is supposed to be zero for ETH instance");
165     _recipient.transfer(_amount.sub(_fee));
166     if (_fee > 0) {
167         _relayer.transfer(_fee);
168    }
169   }
170 }