1 pragma solidity ^0.4.20;
2 
3 interface ERC20 {
4     function totalSupply() constant returns (uint _totalSupply);
5     function balanceOf(address _owner) constant returns (uint balance);
6     function transfer(address _to, uint _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) returns (bool success);
8     function approve(address _spender, uint _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 library SafeMath {
15 
16   /**
17   * @dev Multiplies two numbers, throws on overflow.
18   */
19   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20     if (a == 0) {
21       return 0;
22     }
23     uint256 c = a * b;
24     assert(c / a == b);
25     return c;
26   }
27 
28   /**
29   * @dev Integer division of two numbers, truncating the quotient.
30   */
31   function div(uint256 a, uint256 b) internal pure returns (uint256) {
32     // assert(b > 0); // Solidity automatically throws when dividing by 0
33     uint256 c = a / b;
34     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
35     return c;
36   }
37 
38   /**
39   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
40   */
41   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42     assert(b <= a);
43     return a - b;
44   }
45 
46   /**
47   * @dev Adds two numbers, throws on overflow.
48   */
49   function add(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a + b;
51     assert(c >= a);
52     return c;
53   }
54 }
55 
56 
57 contract StandardToken is ERC20 {
58 
59     using SafeMath for uint256;
60     mapping (address => uint256) balances;
61     mapping (address => mapping (address => uint256)) allowed;
62     uint256 public totalSupply;
63 
64    function transfer(address _to, uint256 _value) public returns (bool) {
65         require(_to != address(0));
66         require(_value <= balances[msg.sender]);
67 
68         // SafeMath.sub will throw if there is not enough balance.
69         balances[msg.sender] = balances[msg.sender].sub(_value);
70         balances[_to] = balances[_to].add(_value);
71         Transfer(msg.sender, _to, _value);
72         return true;
73     }
74 
75     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76         require(_to != address(0));
77         require(_value <= balances[_from]);
78         require(_value <= allowed[_from][msg.sender]);
79 
80         balances[_from] = balances[_from].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function balanceOf(address _owner) public constant returns (uint256 balance) {
88         return balances[_owner];
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96 
97     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
98         return allowed[_owner][_spender];
99     }
100 
101     function totalSupply() public constant returns (uint _totalSupply) {
102         _totalSupply = totalSupply;
103     }
104 
105 
106 }
107 
108 
109 contract ByThePeople is StandardToken {
110 
111     string public name ="ByThePeople";
112     uint8 public decimals = 18;
113     string public symbol = "BTP";
114     uint256 public initialSupply = 14000000;
115 
116     function ByThePeople(address _receiver) public {
117         require(_receiver != address(0));
118         totalSupply = initialSupply * 10 ** uint256(decimals);
119         balances[_receiver] = totalSupply;               // Give the receiver all initial tokens
120 
121     }
122 
123 
124 }