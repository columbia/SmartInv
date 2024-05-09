1 pragma solidity ^0.5.0;
2 /**
3  * @title SafeMath
4  * @dev Unsigned math operations with safety checks that revert on error.
5  */
6 library SafeMath {
7     /**
8      * @dev Multiplies two unsigned integers, reverts on overflow.
9      */
10     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
12         // benefit is lost if 'b' is also tested.
13         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
14         if (a == 0) {
15             return 0;
16         }
17 
18         uint256 c = a * b;
19         require(c / a == b, "SafeMath: multiplication overflow");
20 
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // Solidity only automatically asserts when dividing by 0
29         require(b > 0, "SafeMath: division by zero");
30         uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32 
33         return c;
34     }
35 
36     /**
37      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         require(b <= a, "SafeMath: subtraction overflow");
41         uint256 c = a - b;
42 
43         return c;
44     }
45 
46     /**
47      * @dev Adds two unsigned integers, reverts on overflow.
48      */
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52 
53         return c;
54     }
55 
56     /**
57      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
58      * reverts when dividing by zero.
59      */
60     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
61         require(b != 0, "SafeMath: modulo by zero");
62         return a % b;
63     }
64 }
65 
66 /**
67  * @title Standard ERC20 token
68  *
69  * @dev Implementation of the basic standard token.
70  * https://eips.ethereum.org/EIPS/eip-20
71  * Originally based on code by FirstBlood:
72  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
73  *
74  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
75  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
76  * compliant implementations may not do it.
77  */
78  
79  interface ERC20 {
80     function balanceOf(address _owner) external view returns (uint balance);
81     function transfer(address _to, uint _value) external returns (bool success);
82     function transferFrom(address _from, address _to, uint _value) external returns (bool success);
83     function approve(address _spender, uint _value) external returns (bool success);
84     function allowance(address _owner, address _spender) external view returns (uint remaining);
85     event Transfer(address indexed _from, address indexed _to, uint256 _value);
86     event Approval(address indexed _owner, address indexed _spender, uint _value);
87 }
88  
89  
90  contract Token is ERC20 {
91     using SafeMath for uint256;
92     string public name;
93     string public symbol;
94     uint256 public totalSupply;
95     uint8 public decimals;
96     mapping (address => uint256) private balances;
97     mapping (address => mapping (address => uint256)) private allowed;
98 
99     constructor(string memory _tokenName, string memory _tokenSymbol,uint256 _initialSupply,uint8 _decimals) public {
100         decimals = _decimals;
101         totalSupply = _initialSupply * 10 ** uint256(decimals);  // 这里确定了总发行量
102         name = _tokenName;
103         symbol = _tokenSymbol;
104         balances[msg.sender] = totalSupply;
105     }
106 
107     function transfer(address _to, uint256 _value) public returns (bool) {
108         require(_to != address(0));
109         require(_value <= balances[msg.sender]);
110         balances[msg.sender] = balances[msg.sender].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         emit Transfer(msg.sender, _to, _value);
113         return true;
114     }
115 
116     function balanceOf(address _owner) public view returns (uint256 balance) {
117         return balances[_owner];
118     }
119 
120     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
121         require(_to != address(0));
122         require(_value <= balances[_from]);
123         require(_value <= allowed[_from][msg.sender]);
124         balances[_from] = balances[_from].sub(_value);
125         balances[_to] = balances[_to].add(_value);
126         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
127         emit Transfer(_from, _to, _value);
128         return true;
129     }
130 
131     function approve(address _spender, uint256 _value) public returns (bool) {
132         allowed[msg.sender][_spender] = _value;
133         emit Approval(msg.sender, _spender, _value);
134         return true;
135     }
136 
137     function allowance(address _owner, address _spender) public view returns (uint256) {
138         return allowed[_owner][_spender];
139     }
140 
141 }