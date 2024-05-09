1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal pure returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal pure returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal pure returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal pure returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 contract IERC20 {
50       function totalSupply() public constant returns (uint256);
51       function balanceOf(address _owner) public constant returns (uint balance);
52       function transfer(address _to, uint _value) public returns (bool success);
53       function transferFrom(address _from, address _to, uint _value) public returns (bool success);
54       function approve(address _spender, uint _value) public returns (bool success);
55       function allowance(address _owner, address _spender) public constant returns (uint remaining);
56      event Transfer(address indexed _from, address indexed _to, uint256 _value);
57      event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58  }
59  
60 contract Brightwood is IERC20 {
61     
62        using SafeMath for uint256;
63        
64        uint public _totalSupply = 0;
65        
66        bool public executed = false;
67        
68        address public owner;
69        string public symbol;
70        string public name;
71        uint8 public decimals;
72        uint256 public RATE;
73        
74        mapping(address => uint256) balances;
75        mapping(address => mapping(address => uint256)) allowed;
76        
77        function () public payable {
78            createTokens();
79        }
80        
81        constructor (string _symbol, string _name, uint8 _decimals, uint256 _RATE) public {
82            owner = msg.sender;
83            symbol = _symbol;
84            name = _name;
85            decimals = _decimals;
86            RATE = _RATE;
87        }
88        
89        function createTokens() public payable {
90            require(msg.value > 0);
91            uint256 tokens = msg.value.mul(RATE);
92            _totalSupply = _totalSupply.add(tokens);
93            balances[msg.sender] = balances[msg.sender].add(tokens);
94            owner.transfer(msg.value);
95 		   executed = true;
96        }
97        
98        function totalSupply() public constant returns (uint256) {
99            return _totalSupply;
100        }
101        
102        function balanceOf (address _owner) public constant returns (uint256) {
103            return balances[_owner];
104        }
105        
106        function transfer(address _to, uint256 _value) public returns (bool) {
107            require(balances[msg.sender] >= _value && _value > 0);
108            balances[msg.sender] = balances[msg.sender].sub(_value);
109            balances[_to] = balances[_to].add(_value);
110            emit Transfer(msg.sender, _to, _value);
111            return true;
112        }
113        
114        function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
115            require (allowed[_from][msg.sender] >= _value && balances[_from] >= _value && _value > 0);
116            balances[_from] = balances[_from].sub(_value);
117            balances[_to] = balances[_to].add(_value);
118            allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119            emit Transfer(_from, _to, _value);
120            return true;
121        }
122        
123        function approve (address _spender, uint256 _value) public returns (bool) {
124            allowed[msg.sender][_spender] = _value;
125            emit Approval(msg.sender, _spender, _value);
126            return true;
127        }
128        
129        function allowance(address _owner, address _spender) public constant returns (uint256) {
130            return allowed[_owner][_spender];
131        }
132        
133        event Transfer(address indexed _from, address indexed _to, uint256 _value);
134        event Approval(address indexed _owner, address indexed _spender, uint256 _value);
135 
136 }