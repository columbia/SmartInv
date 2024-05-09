1 pragma solidity ^0.4.19;
2 interface IERC20 {
3     function totalSupply() public constant returns (uint256 total);
4     function balanceOf(address _owner) public constant returns (uint256 balance);
5     function transfer(address _to, uint256 _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function approve(address _spender, uint256 _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
9     
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 contract SPARKToken is IERC20 {
61     
62     using SafeMath for uint256;
63     
64     uint256 public constant _totalSupply = 1000000000; // One billion
65     mapping (address => uint256) _balances;
66     // Tracks who can spend money on another's behalf.
67     //       owner               spender    limit
68     mapping (address => mapping (address => uint256)) _allowed;
69 
70     string public constant symbol = "SPARK";
71     string public constant name = "SPARK Token";
72     uint8 public decimals = 0;
73     
74     function SPARKToken() public {
75         _balances[msg.sender] = _totalSupply;
76     }
77 
78     function totalSupply() public constant returns (uint256) {
79         return _totalSupply;
80     }
81 
82     function balanceOf(address _owner) public constant returns (uint256) {
83         return _balances[_owner];   
84     }
85 
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         require(
88             _balances[msg.sender] >= _value && 
89             _value > 0);
90         _balances[msg.sender] = _balances[msg.sender].sub(_value);
91         _balances[_to] = _balances[_to].add(_value);
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
97         require(
98             _balances[_from] >= _value && 
99             _allowed[_from][msg.sender] >= _value &&
100             _value > 0);
101         _balances[_from] = _balances[_from].sub(_value);
102         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
103         _balances[_to] = _balances[_to].add(_value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107     
108     function approve(address _spender, uint256 _value) public returns (bool) {
109         _allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     function allowance(address _owner, address _spender) public constant returns (uint256) {
115         return _allowed[_owner][_spender];
116     }
117     
118     event Transfer(address indexed _from, address indexed _to, uint256 _value);
119     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
120 }