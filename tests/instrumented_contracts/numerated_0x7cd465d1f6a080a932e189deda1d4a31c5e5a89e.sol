1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, reverts on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (a == 0) {
17       return 0;
18     }
19 
20     uint256 c = a * b;
21     require(c / a == b);
22 
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     require(b > 0); // Solidity only automatically asserts when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34     return c;
35   }
36 
37   /**
38   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39   */
40   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41     require(b <= a);
42     uint256 c = a - b;
43 
44     return c;
45   }
46 
47   /**
48   * @dev Adds two numbers, reverts on overflow.
49   */
50   function add(uint256 a, uint256 b) internal pure returns (uint256) {
51     uint256 c = a + b;
52     require(c >= a);
53 
54     return c;
55   }
56 
57   /**
58   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59   * reverts when dividing by zero.
60   */
61   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62     require(b != 0);
63     return a % b;
64   }
65 }
66 
67 interface IERC20{
68     function totalSupply() constant returns (uint256 totalSupply);
69     function balanceOf(address _owner) constant returns (uint256 balance);
70     function transfer(address _to, uint256 _value) returns (bool success);
71     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
72     function approve(address _spender, uint256 _value) returns (bool success);
73     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
74     event Transfer(address indexed _from, address indexed _to, uint256 _value);
75     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
76 }
77 
78 contract UBToken is IERC20{
79     
80     using SafeMath for uint256;
81     
82     uint public constant _totalSupply = 0;
83     
84     string public constant symbol = "UB";
85     string public constant name = "UNIFIED BET";
86     uint8 public constant decimals = 18;
87     
88     //1 ether = 1 UB
89     uint256 public constant RATE = 1;
90     
91     address public owner;
92     
93     mapping (address => uint256) balances;
94     mapping (address => mapping(address => uint256)) allowed;
95     
96     function () payable{
97         createToken();
98     }
99     
100     constructor (){
101         owner = msg.sender;
102         
103     }
104     
105     function createToken() payable {
106         require(msg.value > 0);
107         
108         uint256 tokens = msg.value;
109         balances[msg.sender] = balances[msg.sender].add(tokens);
110         
111         owner.transfer(msg.value);
112     }
113     
114     function totalSupply() constant returns (uint256 totalSupply){
115         return _totalSupply;
116     }
117     
118     function balanceOf(address _owner) constant returns (uint256 balance){
119         return balances[_owner];
120     }
121     
122     function transfer(address _to, uint256 _value) returns (bool success){
123         require (
124             balances[msg.sender] >= _value
125             && _value > 0
126             );
127             balances[msg.sender] = balances[msg.sender].sub(_value);
128             balances[_to] = balances[_to].add(_value);
129             Transfer(msg.sender, _to, _value);
130             return true;
131             
132     }
133     
134     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
135         require(
136             allowed[_from][msg.sender] >= _value
137             && balances[_from] >= _value
138             && _value > 0
139             );
140             
141             balances[_from] = balances[_from].sub(_value);
142             balances[_to] = balances[_to].add(_value);
143             allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value);
144             Transfer(_from, _to, _value);
145             return true;
146     }
147     
148     function approve(address _spender, uint256 _value) returns (bool success){
149         allowed[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153     
154     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
155         return allowed[_owner][_spender];
156     }
157     
158 }