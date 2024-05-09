1 pragma solidity >=0.4.22 <0.6.0;
2 
3 /**
4  * @title SafeMath
5  * @dev Unsigned math operations with safety checks that revert on error.
6  */
7 library SafeMath {
8     /**
9      * @dev Multiplies two unsigned integers, reverts on overflow.
10      */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b, "SafeMath: multiplication overflow");
21 
22         return c;
23     }
24 
25     /**
26      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
27      */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0, "SafeMath: division by zero");
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39      */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a, "SafeMath: subtraction overflow");
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48      * @dev Adds two unsigned integers, reverts on overflow.
49      */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53 
54         return c;
55     }
56 
57     /**
58      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
59      * reverts when dividing by zero.
60      */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0, "SafeMath: modulo by zero");
63         return a % b;
64     }
65 }
66 
67 
68 /// Buy OurERC20 don't miss the oportunity
69 contract OurERC20 {
70 
71   using SafeMath for uint256;
72   string _name;
73   string _symbol;
74   mapping (address => uint256) _balances;
75   uint256 _totalSupply;
76   uint8 private _decimals;
77   event Transfer(address indexed from, address indexed to, uint tokens);
78   
79   constructor() public {
80     _name = "HOLA";
81     _symbol = "HL";
82     _decimals = 0;
83   }
84   
85   function decimals() public view returns(uint8) {
86       return _decimals;
87   }
88   
89   function totalSupply() public view returns (uint256) {
90       return _totalSupply;
91   }
92   
93   function name() public view returns (string memory) {
94      return _name;
95   }
96   
97   function symbol() public view returns (string memory) {
98      return _symbol;
99   }
100   
101   function mint(uint256 amount) public payable {
102       require(msg.value == amount.mul(0.006 ether));
103       _balances[msg.sender] = _balances[msg.sender].add(amount);
104       _totalSupply = _totalSupply + amount;
105   }
106   
107   function burn(uint256 amount) public {
108       require(_balances[msg.sender] == amount);
109       _balances[msg.sender] = _balances[msg.sender].sub(amount);
110       msg.sender.transfer(amount.mul(0.006 ether));
111       _totalSupply = _totalSupply - amount;
112   }
113   
114   function transfer(address _to, uint256 value) public returns (bool success) {
115       require(_balances[msg.sender] >= value);
116       _balances[msg.sender] = _balances[msg.sender].sub(value);
117       _balances[_to] = _balances[_to].add(value);
118       emit Transfer(msg.sender, _to, value);      
119       return true;
120   }
121   
122   
123   
124   
125   
126   
127 }