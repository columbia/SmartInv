1 pragma solidity ^0.5.1;
2 
3 contract ERC20Standard {
4     using SafeMath for uint256;
5 	uint256 public totalSupply;
6 	string public name;
7 	uint8 public decimals;
8 	string public symbol;
9 	address public owner;
10 
11 	mapping (address => uint256) balances;
12 	mapping (address => mapping (address => uint256)) allowed;
13 
14    constructor(uint256 _totalSupply, string memory _symbol, string memory _name, uint8 _decimals) public {
15 		symbol = _symbol;
16 		name = _name;
17         decimals = _decimals;
18 		owner = msg.sender;
19         totalSupply = SafeMath.mul(_totalSupply ,(10 ** uint256(decimals)));
20         balances[owner] = totalSupply;
21   }
22 	//Fix for short address attack against ERC20
23 	modifier onlyPayloadSize(uint size) {
24 		assert(msg.data.length == SafeMath.add(size,4));
25 		_;
26 	} 
27 
28 	function balanceOf(address _owner) view public returns (uint256) {
29 		return balances[_owner];
30 	}
31 
32 	function transfer(address _recipient, uint256 _value) onlyPayloadSize(2*32) public returns(bool){
33 	    require(_recipient!=address(0));
34 		require(balances[msg.sender] >= _value && _value >= 0);
35 	    require(balances[_recipient].add(_value)>= balances[_recipient]);
36 	    balances[msg.sender] = balances[msg.sender].sub(_value) ;
37 	    balances[_recipient] = balances[_recipient].add(_value) ;
38 	    emit Transfer(msg.sender, _recipient, _value);  
39 	    return true;
40     }
41 
42 	function transferFrom(address _from, address _to, uint256 _value) public returns(bool){
43 	    require(_to!=address(0));
44 		require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value >= 0);
45 		require(balances[_to].add(_value) >= balances[_to]);
46         balances[_to] = balances[_to].add(_value);
47         balances[_from] = balances[_from].sub(_value) ;
48         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value) ;
49         emit Transfer(_from, _to, _value);
50         return true;
51     }
52 
53 	function approve(address _spender, uint256 _value) public returns(bool){
54 	    require((_value==0)||(allowed[msg.sender][_spender]==0));
55     	allowed[msg.sender][_spender] = _value;
56 		emit Approval(msg.sender, _spender, _value);
57 		return true;
58 	}
59 
60 	function allowance(address _owner, address _spender) view public returns (uint256) {
61 		return allowed[_owner][_spender];
62 	}
63 
64 	//Event which is triggered to log all transfers to this contract's event log
65 	event Transfer(
66 		address indexed _from,
67 		address indexed _to,
68 		uint256 _value
69 		);
70 		
71 	//Event which is triggered whenever an owner approves a new allowance for a spender.
72 	event Approval(
73 		address indexed _owner,
74 		address indexed _spender,
75 		uint256 _value
76 		);
77 
78 }
79 library SafeMath {
80     /**
81      * @dev Multiplies two unsigned integers, reverts on overflow.
82      */
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
85         // benefit is lost if 'b' is also tested.
86         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
87         if (a == 0) {
88             return 0;
89         }
90 
91         uint256 c = a * b;
92         require(c / a == b, "SafeMath: multiplication overflow");
93 
94         return c;
95     }
96 
97     /**
98      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         // Solidity only automatically asserts when dividing by 0
102         require(b > 0, "SafeMath: division by zero");
103         uint256 c = a / b;
104         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
105 
106         return c;
107     }
108 
109     /**
110      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         require(b <= a, "SafeMath: subtraction overflow");
114         uint256 c = a - b;
115 
116         return c;
117     }
118 
119     /**
120      * @dev Adds two unsigned integers, reverts on overflow.
121      */
122     function add(uint256 a, uint256 b) internal pure returns (uint256) {
123         uint256 c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128 
129     /**
130      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
131      * reverts when dividing by zero.
132      */
133     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
134         require(b != 0, "SafeMath: modulo by zero");
135         return a % b;
136     }
137 }