1 pragma solidity ^0.5.0;
2 
3 contract ERC20 {
4     function transfer(address _to, uint256 _value) public returns (bool success);
5     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
6     function approve(address _spender, uint256 _value) public returns (bool success);
7 
8     event Transfer(address indexed _from, address indexed _to, uint256 _value);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 
12 contract BlockMiracleToken is ERC20 {
13     string public name = "BlockMiracleToken";
14     string public symbol = "BMT";
15     uint8 public decimals = 10;
16     uint256 public totalSupply = 100000000000000000000;
17 	
18     using SafeMath for uint256;
19 
20     mapping (address => uint256) public balanceOf;
21     mapping (address => mapping (address => uint256)) public allowance;
22 
23     constructor() public {
24         balanceOf[msg.sender] = totalSupply;
25     }
26 
27     function transfer(address _to, uint256 _value) public returns (bool success) {
28         require (_to != address(0x0) && _value > 0);
29         require (balanceOf[msg.sender] >= _value);
30         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
31         balanceOf[_to] = balanceOf[_to].add(_value);
32         emit Transfer(msg.sender, _to, _value);
33         return true;
34     }
35 
36     function approve(address _spender, uint256 _value) public returns (bool success) {
37         require (_value > 0);
38         allowance[msg.sender][_spender] = _value;
39         emit Approval(msg.sender, _spender, _value);
40         return true;
41     }
42     
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
44         require (_to != address(0x0) && _value > 0);
45         require (balanceOf[_from] >= _value && _value <= allowance[_from][msg.sender]);
46         balanceOf[_from] = balanceOf[_from].sub(_value);
47         balanceOf[_to] = balanceOf[_to].add(_value);
48         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
49         emit Transfer(_from, _to, _value);
50         return true;
51     }
52 }
53 
54 /**
55  * @title SafeMath
56  * @dev Math operations with safety checks that throw on error
57  */
58 library SafeMath {
59 
60   /**
61   * @dev Multiplies two numbers, throws on overflow.
62   */
63   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
64     if (a == 0) {
65       return 0;
66     }
67     c = a * b;
68     assert(c / a == b);
69     return c;
70   }
71 
72   /**
73   * @dev Integer division of two numbers, truncating the quotient.
74   */
75   function div(uint256 a, uint256 b) internal pure returns (uint256) {
76     // assert(b > 0); // Solidity automatically throws when dividing by 0
77     // uint256 c = a / b;
78     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
79     return a / b;
80   }
81 
82   /**
83   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
84   */
85   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
86     assert(b <= a);
87     return a - b;
88   }
89 
90   /**
91   * @dev Adds two numbers, throws on overflow.
92   */
93   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
94     c = a + b;
95     assert(c >= a);
96     return c;
97   }
98 }