1 pragma solidity ^0.4.18;
2 interface IERC20 {
3  function totalSupply() constant returns (uint256 totalSupply);
4  function balanceOf(address _owner) constant returns (uint256 balance);
5  function transfer(address _to, uint256 _value) returns (bool success);
6  function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
7  function approve(address _spender, uint256 _value) returns (bool success);
8  function allowance(address _owner, address _spender) constant returns (uint256 remaining);
9  event Transfer(address indexed _from, address indexed _to, uint256 _value);
10  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
11  }
12 
13 library SafeMath {
14   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   function div(uint256 a, uint256 b) internal constant returns (uint256) {
24     // assert(b > 0); // Solidity automatically throws when dividing by 0
25     uint256 c = a / b;
26     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
27     return c;
28   }
29 
30   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
31     assert(b <= a);
32     return a - b;
33   }
34 
35   function add(uint256 a, uint256 b) internal constant returns (uint256) {
36     uint256 c = a + b;
37     assert(c >= a);
38     return c;
39   }
40 }
41 
42 contract Electra is IERC20 {
43     
44     using SafeMath for uint256;
45     
46     uint public  _totalSupply=0;
47     
48       string public constant symbol="ECT";
49     string public constant name="ElectraToken";
50     uint8 public constant decimals=18;
51     uint256 public constant RATE=500;
52  
53     address public owner;
54     mapping(address => uint256) balances;
55     mapping(address => mapping(address => uint256)) allowed;
56     
57   
58     
59     function() payable{
60         createTokens();
61     }
62     
63     function SucToken()
64     {
65        owner=msg.sender;
66     }
67     
68     function createTokens() payable
69     {
70         require(msg.value>0);
71         
72         uint256 tokens=msg.value.mul(RATE);
73         
74         balances[msg.sender]=balances[msg.sender].add(tokens);
75         
76         _totalSupply=_totalSupply.add(tokens);
77         
78         owner.transfer(msg.value);
79     }
80     
81     function totalSupply() constant returns (uint256 totalSupply){
82         
83         return _totalSupply;
84     }
85  function balanceOf(address _owner) constant returns (uint256 balance){
86       return balances[_owner];
87  }
88  function transfer(address _to, uint256 _value) returns (bool success){
89      require(
90          balances[msg.sender] >= _value
91          && _value > 0
92          );
93           balances[msg.sender]=balances[msg.sender].sub(_value);
94            balances[_to]=balances[_to].add(_value);
95           Transfer(msg.sender,_to,_value);
96           return true;
97  }
98  function transferFrom(address _from, address _to, uint256 _value) returns (bool success)
99  {
100      require(
101          allowed[_from][msg.sender] >= _value
102          &&  balances[_from]>=_value
103          &&  _value > 0
104          );
105           balances[_from]= balances[_from].sub(_value);
106            balances[_to]=balances[_to].add(_value);
107          allowed[_from][msg.sender] = allowed[_from][msg.sender].sub( _value);
108         Transfer(_from,_to,_value);
109           return true;
110  }
111  function approve(address _spender, uint256 _value) returns (bool success)
112  {
113       allowed[msg.sender][_spender] = _value;
114       Approval(msg.sender,_spender,_value);
115       return true;
116  }
117  function allowance(address _owner, address _spender) constant returns (uint256 remaining){
118      return allowed[_owner][_spender];
119  }
120  event Transfer(address indexed _from, address indexed _to, uint256 _value);
121  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
122 }