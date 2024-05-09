1 pragma solidity ^0.4.11;
2 
3 interface ERC20 {
4     function totalSupply() public constant returns (uint256 totalSup);
5     function balanceOf(address _owner) public constant returns (uint256 balance);
6     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
7     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
8     function approve(address _spender, uint256 _value) public returns (bool success);
9     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
10 }
11 
12 interface ERC223 {
13     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success);
14     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
15 }
16 
17 contract ERC223ReceivingContract {
18     function tokenFallback(address _from, uint _value, bytes _data) public;
19 }
20 
21 contract Joe223 is ERC223, ERC20 {
22     
23     using SafeMath for uint256;
24     
25     uint public constant _totalSupply = 2100000000e18;
26     //starting supply of Token
27     
28     string public constant symbol = "JOE223";
29     string public constant name = "JOE223 Token";
30     uint8 public constant decimals = 18;
31     
32     mapping(address => uint256) balances;
33     mapping(address => mapping(address => uint256)) allowed;
34     
35     function Joe223() public{
36         balances[msg.sender] = _totalSupply;
37     }
38 
39     function totalSupply() public constant returns (uint256 totalSup) {
40         return _totalSupply;
41     }
42     
43     function balanceOf(address _owner) public constant returns (uint256 balance) {
44         return balances[_owner];
45     }
46     
47     function transfer(address _to, uint256 _value) public returns (bool success) {
48         require(
49             balances[msg.sender] >= _value
50             && _value > 0
51             && !isContract(_to)
52         );
53         balances[msg.sender] = balances[msg.sender].sub(_value);
54         balances[_to] = balances[_to].add(_value);
55         Transfer(msg.sender, _to, _value);
56         return true;
57     }
58     
59     function transfer(address _to, uint256 _value, bytes _data) public returns (bool success){
60         require(
61             balances[msg.sender] >= _value
62             && _value > 0
63             && isContract(_to)
64         );
65         balances[msg.sender] = balances[msg.sender].sub(_value);
66         balances[_to] = balances[_to].add(_value);
67         ERC223ReceivingContract(_to).tokenFallback(msg.sender, _value, _data);
68         Transfer(msg.sender, _to, _value, _data);
69         return true;
70     }
71     
72     function isContract(address _from) private constant returns (bool) {
73         uint256 codeSize;
74         assembly {
75             codeSize := extcodesize(_from)
76         }
77         return codeSize > 0;
78     }
79     
80     
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
82         require(
83             allowed[_from][msg.sender] >= _value  
84             && balances[_from] >= _value
85             && _value > 0
86             && allowed[_from][msg.sender] > 0
87         );
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94     
95     function approve(address _spender, uint256 _value) public returns (bool success) {
96         allowed[msg.sender][_spender] = _value;
97         Approval(msg.sender, _spender, _value);
98         return true;
99     }
100     
101     function allowance(address _owner, address _spender) public constant returns (uint256 remaing) {
102         return allowed[_owner][_spender];
103     }
104     
105     event Transfer(address indexed _from, address indexed _to, uint256 _value);
106     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
107     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
108 
109 }
110 
111 /**
112  * @title SafeMath
113  * @dev Math operations with safety checks that throw on error
114  */
115 library SafeMath {
116   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117     if (a == 0) {
118       return 0;
119     }
120     uint256 c = a * b;
121     assert(c / a == b);
122     return c;
123   }
124 
125   function div(uint256 a, uint256 b) internal pure returns (uint256) {
126     // assert(b > 0); // Solidity automatically throws when dividing by 0
127     uint256 c = a / b;
128     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
129     return c;
130   }
131 
132   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133     assert(b <= a);
134     return a - b;
135   }
136 
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     assert(c >= a);
140     return c;
141   }
142 }