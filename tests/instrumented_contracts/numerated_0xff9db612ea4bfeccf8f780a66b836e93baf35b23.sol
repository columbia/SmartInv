1 pragma solidity 0.5.7;
2 
3 contract InternetCoin {
4     using SafeMath for uint256;
5 
6     string constant public name = "Internet Coin" ;                               
7     string constant public symbol = "ITN";           
8     uint8 constant public decimals = 18;            
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12 
13     uint256 public constant totalSupply = 200*10**24; //200 million with 18 decimals
14 
15     address public owner  = address(0x000000000000000000000000000000000000dEaD);
16 
17     modifier validAddress {
18         assert(address(0x000000000000000000000000000000000000dEaD) != msg.sender);
19         assert(address(0x0) != msg.sender);
20         assert(address(this) != msg.sender);
21         _;
22     }
23 
24     constructor (address _addressFounder) validAddress public {
25         require(owner == address(0x000000000000000000000000000000000000dEaD), "Owner cannot be re-assigned");
26         owner = _addressFounder;
27         balanceOf[_addressFounder] = totalSupply;
28         emit Transfer(0x000000000000000000000000000000000000dEaD, _addressFounder, totalSupply);
29     }
30 
31     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
32         require(balanceOf[msg.sender] >= _value);
33         require(balanceOf[_to].add(_value) >= balanceOf[_to]);
34         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
35         balanceOf[_to] = balanceOf[_to].add(_value);
36         emit Transfer(msg.sender, _to, _value);
37         return true;
38     }
39 
40     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
41         require(balanceOf[_from] >= _value);
42         require(balanceOf[_to].add(_value)>= balanceOf[_to]);
43         require(allowance[_from][msg.sender] >= _value);
44         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
45         balanceOf[_from] = balanceOf[_from].sub(_value);
46         balanceOf[_to] = balanceOf[_to].add(_value);
47         emit Transfer(_from, _to, _value);
48         return true;
49     }
50 
51     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
52         require(_value == 0 || allowance[msg.sender][_spender] == 0);
53         allowance[msg.sender][_spender] = _value;
54         emit Approval(msg.sender, _spender, _value);
55         return true;
56     }
57 
58     event Transfer(address indexed _from, address indexed _to, uint256 _value);
59     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60 }
61 
62 /**
63  * @title SafeMath
64  * @dev Unsigned math operations with safety checks that revert on error.
65  */
66 library SafeMath {
67     /**
68      * @dev Multiplies two unsigned integers, reverts on overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b);
80 
81         return c;
82     }
83 
84     /**
85      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
86      */
87     function div(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Solidity only automatically asserts when dividing by 0
89         require(b > 0);
90         uint256 c = a / b;
91         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
92 
93         return c;
94     }
95 
96     /**
97      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
98      */
99     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
100         require(b <= a);
101         uint256 c = a - b;
102 
103         return c;
104     }
105 
106     /**
107      * @dev Adds two unsigned integers, reverts on overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a);
112 
113         return c;
114     }
115 
116     /**
117      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
118      * reverts when dividing by zero.
119      */
120     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
121         require(b != 0);
122         return a % b;
123     }
124 }