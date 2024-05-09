1 pragma solidity ^0.4.18;
2 
3     interface IERC20 {
4         
5         function totalSupply() constant returns (uint256 totalSupply);
6         function balanceOf(address _owner) constant returns (uint256 balance);
7         function transfer(address _to, uint256 _value) returns (bool success);
8         function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
9         function approve(address _spender, uint256 _value) returns (bool success);
10         function allowance(address _owner, address _spender) constant returns (uint256 remaining);
11         event Transfer(address indexed _from, address indexed _to, uint256 _value);
12         event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13         
14     }
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
22     if (a == 0) {
23       return 0;
24     }
25     uint256 c = a * b;
26     assert(c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal pure returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract BobCoin is IERC20{
50     
51     using SafeMath for uint256;
52     
53     uint256 public constant _totalSupply = 1000000000;
54     
55     string public constant symbol = "BOB";
56     string public constant name = "BobCoin";
57     uint8 public constant decimals = 3;
58     
59     //uint256 public constant RATE = 1000;
60     
61     //address public owner;
62     
63     mapping(address => uint256) balances;
64     mapping(address => mapping(address => uint256)) allowed;
65     
66     
67     //function () payable{
68     //    createTokens();
69     //}
70     
71     function BobCoin(){
72         balances[msg.sender] = _totalSupply;
73         //owner = msg.sender;
74     }
75     
76     //function createTokens() payable{
77     //    require(msg.value > 0);
78     //    
79     //    uint256 tokens = msg.value.mul(RATE);
80     //    balances[msg.sender] = balances[msg.sender].add(tokens);
81     //    _totalSupply = _totalSupply = _totalSupply.add(tokens);
82     //    owner.transfer(msg.value);
83     //}
84     
85     function totalSupply() constant returns (uint256 totalSupply){
86         return _totalSupply;
87     }
88     
89     function balanceOf(address _owner) constant returns (uint256 balance){
90         return balances[_owner];
91     }
92     
93     function transfer(address _to, uint256 _value) returns (bool sucess){
94         require(
95             balances[msg.sender] >= _value
96             && _value > 0
97         );
98         balances[msg.sender] = balances[msg.sender].sub(_value);
99         balances[_to] = balances[_to].add(_value);
100         Transfer(msg.sender, _to, _value);
101         return true;
102     }
103     
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success){
105         require(
106             allowed[_from][msg.sender] >= _value
107             && balances[_from] >= _value
108             && _value > 0
109         );
110         balances[_from] = balances[_from].sub(_value);
111         balances[_to] = balances[_to].add(_value);
112         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113         Transfer(_from, _to, _value);
114         return true;
115     }
116     
117     function approve(address _spender, uint256 _value) returns (bool success){
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122     
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining){
124         return allowed[_owner][_spender];
125     }
126     
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129 }