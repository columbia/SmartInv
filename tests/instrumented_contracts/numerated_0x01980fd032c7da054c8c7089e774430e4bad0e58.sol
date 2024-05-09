1 pragma solidity ^0.5.2;
2 
3 contract Ownable {
4     address public owner;
5 
6     constructor () public {
7         owner = msg.sender;
8     }
9     modifier onlyOwner() {
10         require(msg.sender == owner);
11         _;
12     }
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 contract UULATokenCoin is Ownable {
19     using SafeMath for uint256; // use SafeMath for uint256 variables
20 
21     string public constant name = "Uulala";
22     string public constant symbol = "UULA";
23     uint32 public constant decimals = 2;
24     uint public constant INITIAL_SUPPLY = 7500000000000;
25     uint public totalSupply = 0;
26     mapping(address => uint256) balances;
27     mapping(address => mapping(address => uint256)) allowed;
28 
29     constructor () public {
30         totalSupply = INITIAL_SUPPLY;
31         balances[msg.sender] = INITIAL_SUPPLY;
32     }
33 
34     function balanceOf(address _owner) public view returns (uint256 balance) {
35         return balances[_owner];
36     }
37 
38     function transfer(address _to, uint256 _value) public returns (bool success) {
39         if (balances[msg.sender] < _value || balances[msg.sender].add(_value) < balances[msg.sender]) {
40             return false;
41         }
42 
43         balances[msg.sender] = balances[msg.sender].sub(_value);
44         balances[_to] = balances[_to].add(_value);
45         emit Transfer(msg.sender, _to, _value);
46 
47         return true;
48     }
49 
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         if (allowed[_from][msg.sender] < _value || balances[_from] < _value && balances[_to].add(_value) >= balances[_to]) {
52             return false;
53         }
54 
55         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
56         balances[_from] = balances[_from].sub(_value);
57         balances[_to] = balances[_to].add(_value);
58         emit Transfer(_from, _to, _value);
59 
60         return true;
61     }
62 
63     function approve(address _spender, uint256 _value) public returns (bool success) {
64         allowed[msg.sender][_spender] = _value;
65         emit Approval(msg.sender, _spender, _value);
66 
67         return true;
68     }
69 
70     function allowance(address _owner, address _spender) public view returns (uint remaining) {
71         return allowed[_owner][_spender];
72     }
73 
74     function transferWise(address[] memory recipients, uint256[] memory values) public {
75         require(recipients.length == values.length);
76 
77         uint256 sum = 0;
78         uint256 i = 0;
79 
80         for (i = 0; i < recipients.length; i++) {
81             sum = sum.add(values[i]);
82         }
83         require(sum <= balances[msg.sender]);
84 
85         for (i = 0; i < recipients.length; i++) {
86             transfer(recipients[i], values[i]);
87         }
88     }
89 
90     event Transfer(address indexed _from, address indexed _to, uint _value);
91     event Approval(address indexed _owner, address indexed _spender, uint _value);
92 }
93 
94 /**
95  * @title SafeMath
96  * @dev Unsigned math operations with safety checks that revert on error
97  */
98 library SafeMath {
99     /**
100      * @dev Multiplies two unsigned integers, reverts on overflow.
101      */
102     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
103         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
104         // benefit is lost if 'b' is also tested.
105         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
106         if (a == 0) {
107             return 0;
108         }
109 
110         uint256 c = a * b;
111         require(c / a == b);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
118      */
119     function div(uint256 a, uint256 b) internal pure returns (uint256) {
120         // Solidity only automatically asserts when dividing by 0
121         require(b > 0);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         require(b <= a);
133         uint256 c = a - b;
134 
135         return c;
136     }
137 
138     /**
139      * @dev Adds two unsigned integers, reverts on overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a);
144 
145         return c;
146     }
147 
148     /**
149      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
150      * reverts when dividing by zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b != 0);
154         return a % b;
155     }
156 }