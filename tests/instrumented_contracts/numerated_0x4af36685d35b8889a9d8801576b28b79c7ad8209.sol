1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     
11     event Transfer(address indexed _from, address indexed _to, uint256 _value);
12     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
13 }
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19  
20 library SafeMath {
21   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
22     uint256 c = a * b;
23     assert(a == 0 || c / a == b);
24     return c;
25   }
26 
27   function div(uint256 a, uint256 b) internal constant returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return c;
32   }
33 
34   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   function add(uint256 a, uint256 b) internal constant returns (uint256) {
40     uint256 c = a + b;
41     assert(c >= a);
42     return c;
43   }
44 }
45 
46 contract hashCoin is IERC20 {
47     
48     using SafeMath for uint256;
49     
50     uint public _totalSupply = 0;
51 
52     string public constant symbol = "HASH";
53     string public constant name = "Hash Coin";
54     string public version = "HASH_0.1";
55     uint8 public constant decimals = 18;
56     
57     // 1 ETH = 5,000 Hash Coins
58     uint256 public constant RATE = 5000;
59     
60     address public owner;
61     
62     mapping(address => uint256) balances;
63     mapping(address => mapping(address => uint256)) allowed;
64     
65     function () payable {
66         createTokens();
67     }
68     
69     function hashCoin() {
70         owner = msg.sender;
71     }
72     
73     event Burn(address indexed from, uint256 value);
74     
75     function createTokens() payable {
76         require(msg.value > 0);
77         
78         uint256 tokens = msg.value.mul(RATE);
79         balances[msg.sender] = balances[msg.sender].add(tokens);
80         _totalSupply = _totalSupply.add(tokens);
81         
82         owner.transfer(msg.value);
83     }
84     
85     function totalSupply() constant returns (uint256 totalSupply) {
86         return _totalSupply;
87     }
88     
89     function balanceOf(address _owner) constant returns (uint256 balance) {
90         return balances[_owner];
91     }
92     
93     function transfer(address _to, uint256 _value) returns (bool success) {
94         require(
95             balances[msg.sender] >= _value
96             && _value > 0
97             );
98             balances[msg.sender] = balances[msg.sender].sub(_value);
99             balances[_to] = balances[_to].add(_value);
100             Transfer(msg.sender, _to, _value);
101             return true;
102     }
103     
104     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
105         require (
106             allowed[_from][msg.sender] >= _value
107             && balances[_from] >= _value
108             && _value > 0
109             );
110             balances[_from] = balances[_from].sub(_value);
111             balances [_to] = balances[_to].add(_value);
112             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113             Transfer(_from, _to, _value);
114             return true;
115     }
116     
117     function approve(address _spender, uint256 _value) returns (bool success) {
118         allowed[msg.sender][_spender] = _value;
119         Approval(msg.sender, _spender, _value);
120         return true;
121     }
122     
123     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
124         return allowed[_owner][_spender];
125     }
126     
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
129     
130 
131 }