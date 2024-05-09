1 pragma solidity ^0.4.23;
2 
3 
4 
5 
6 contract ERC20Basic {
7   
8   
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 library SafeMath {
16 
17   /**
18   * @dev Multiplies two numbers, reverts on overflow.
19   */
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
22     // benefit is lost if 'b' is also tested.
23     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
24     if (a == 0) {
25       return 0;
26     }
27 
28     uint256 c = a * b;
29     require(c / a == b);
30 
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     require(b > 0); // Solidity only automatically asserts when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41 
42     return c;
43   }
44 
45   /**
46   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     require(b <= a);
50     uint256 c = a - b;
51 
52     return c;
53   }
54 
55   /**
56   * @dev Adds two numbers, reverts on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     require(c >= a);
61 
62     return c;
63   }
64 
65   /**
66   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
67   * reverts when dividing by zero.
68   */
69   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
70     require(b != 0);
71     return a % b;
72   }
73 }
74 
75 /**
76  * @title 实现ERC20基本合约的接口
77  * @dev 基本的StandardToken，不包含allowances.
78  */
79 contract BasicToken is ERC20Basic {
80   using SafeMath for uint256;
81 
82   mapping(address => uint256) balances;
83 
84   uint256 totalSupply_;
85   string public name;
86   string public symbol;
87   uint8 public decimals;
88 
89   constructor(string _name, string _symbol, uint8 _decimals,uint256 totalSupply) public {
90     
91     balances[msg.sender] = totalSupply;
92     totalSupply_ = totalSupply;
93     name = _name;
94     symbol = _symbol;
95     decimals = _decimals;
96   } 
97   
98   /**
99   * @dev 返回存在的token总数
100   */
101   function totalSupply() public view returns (uint256) {
102     return totalSupply_;
103   }
104 
105   /**
106   * @dev 给特定的address转token
107   * @param _to 要转账到的address
108   * @param _value 要转账的金额
109   */
110   function transfer(address _to, uint256 _value) public returns (bool) {
111     //做相关的合法验证
112     require(_to != address(0));
113     require(_value <= balances[msg.sender]);
114     // msg.sender余额中减去额度，_to余额加上相应额度
115     balances[msg.sender] = balances[msg.sender].sub(_value);
116     balances[_to] = balances[_to].add(_value);
117     //触发Transfer事件
118     emit Transfer(msg.sender, _to, _value);
119     return true;
120   }
121 
122   /**
123   * @dev 获取指定address的余额
124   * @param _owner 查询余额的address.
125   * @return An uint256 representing the amount owned by the passed address.
126   */
127   function balanceOf(address _owner) public view returns (uint256) {
128     return balances[_owner];
129   }
130 
131 }