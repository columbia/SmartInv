1 pragma solidity 0.4.24;
2 
3 /** Contact help@concepts.io or visit http://concepts.io for questions about this token contract */
4 
5 /** 
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a * b;
13     assert(a == 0 || c / a == b);
14     return c;
15   }
16 
17   function div(uint256 a, uint256 b) internal pure returns (uint256) {
18     uint256 c = a / b;
19     return c;
20   }
21 
22   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23     assert(b <= a);
24     return a - b;
25   }
26 
27   function add(uint256 a, uint256 b) internal pure returns (uint256) {
28     uint256 c = a + b;
29     assert(c >= a);
30     return c;
31   }
32 }
33 interface ERC20 {
34     function transferFrom(address _from, address _to, uint _value) external returns (bool);
35     function approve(address _spender, uint _value) external returns (bool);
36     function allowance(address _owner, address _spender) external constant returns (uint);
37     event Approval(address indexed _owner, address indexed _spender, uint _value);
38 }
39 /**
40  * @title Ownable
41  * @dev The Ownable contract has an owner address, and provides basic authorization control
42  * functions, this simplifies the implementation of "user permissions".
43  */
44 contract Ownable {
45 
46   address public owner;
47 
48   /**
49    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
50    * account.
51    */
52   constructor () internal{
53     owner = msg.sender;
54   }
55 
56   /**
57    * @dev Throws if called by any account other than the owner.
58    */
59   modifier onlyOwner() {
60     require(msg.sender == owner);
61     _;
62   }
63 
64   /**
65    * @dev Allows the current owner to transfer control of the contract to a newOwner.
66    * @param newOwner The address to transfer ownership to.
67    */
68   function transferOwnership(address newOwner) onlyOwner public {
69     require(newOwner != address(0) && msg.sender==owner);
70     owner = newOwner;
71   }
72 }
73 contract tokenCreator is Ownable{
74 
75     string internal _symbol;
76     string internal _name;
77     uint8 internal _decimals;
78     uint internal _totalSupply = 500000000;
79     mapping (address => uint256) internal _balanceOf;
80     mapping (address => mapping (address => uint256)) internal _allowed;
81 
82     constructor(string symbol, string name, uint8 decimals, uint totalSupply) public {
83         _symbol = symbol;
84         _name = name;
85         _decimals = decimals;
86         _totalSupply = _calcTokens(decimals,totalSupply);
87     }
88 
89    function _calcTokens(uint256 decimals, uint256 amount) internal pure returns (uint256){
90       uint256 c = amount * 10**decimals;
91       return c;
92    }
93 
94     function name() public constant returns (string) {
95         return _name;
96     }
97 
98     function symbol() public constant returns (string) {
99         return _symbol;
100     }
101 
102     function decimals() public constant returns (uint8) {
103         return _decimals;
104     }
105 
106     function totalSupply() public constant returns (uint) {
107         return _totalSupply;
108     }
109 
110     function balanceOf(address _addr) public constant returns (uint);
111     function transfer(address _to, uint _value) public returns (bool);
112     event Transfer(address indexed _from, address indexed _to, uint _value);
113 }
114 contract supTokenMaker is tokenCreator("REPLY", "True Reply Research Token", 18, 500000000), ERC20 {
115     using SafeMath for uint256;
116 
117     event TokenTransferRequest(string method,address from, address backer, uint amount);
118 
119     constructor() public {
120         _balanceOf[msg.sender] = _totalSupply;
121     }
122 
123     function totalSupply() public constant returns (uint) {
124         return _totalSupply;
125     }
126 
127     function balanceOf(address _addr) public constant returns (uint) {
128         return _balanceOf[_addr];
129     }
130 
131     function transfer(address _to, uint _value) public returns (bool) {
132         emit TokenTransferRequest("transfer",msg.sender, _to, _value);
133         require(_value > 0 && _value <= _balanceOf[msg.sender]);
134 
135         _balanceOf[msg.sender] = _balanceOf[msg.sender].sub(_value);
136         _balanceOf[_to] = _balanceOf[_to].add(_value);
137         emit Transfer(msg.sender, _to, _value);
138         return true;
139     }
140     function transferFrom(address _from, address _to, uint _value) public returns (bool) {
141         emit TokenTransferRequest("transferFrom",_from, _to, _value);
142         require(_to != address(0) && _value <= _balanceOf[_from] && _value <= _allowed[_from][msg.sender] && _value > 0);
143 
144         _balanceOf[_from] =  _balanceOf[_from].sub(_value);
145         _balanceOf[_to] = _balanceOf[_to].add(_value);
146         _allowed[_from][msg.sender] = _allowed[_from][msg.sender].sub(_value);
147 
148         emit Transfer(_from, _to, _value);
149         return true;
150     }
151 
152     function approve(address _spender, uint _value) public returns (bool) {
153         _allowed[msg.sender][_spender] = _value;
154         emit Approval(msg.sender, _spender, _value);
155         return true;
156     }
157 
158     function allowance(address _owner, address _spender) public constant returns (uint) {
159         return _allowed[_owner][_spender];
160     }
161 }