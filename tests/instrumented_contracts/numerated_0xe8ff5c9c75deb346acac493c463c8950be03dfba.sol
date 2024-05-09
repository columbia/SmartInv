1 contract SafeMath {
2 
3     function safeAdd(uint256 x, uint256 y) internal returns(uint256) {
4         uint256 z = x + y;
5         assert((z >= x) && (z >= y));
6         return z;
7     }
8 
9     function safeSubtract(uint256 x, uint256 y) internal returns(uint256) {
10         assert(x >= y);
11         uint256 z = x - y;
12         return z;
13     }
14 
15     function safeMult(uint256 x, uint256 y) internal returns(uint256) {
16         uint256 z = x * y;
17         assert((x == 0)||(z/x == y));
18         return z;
19     }
20 }
21 
22 contract Token {
23     uint256 public totalSupply;
24 
25     function balanceOf(address _owner) constant returns (uint256 balance);
26     function transfer(address _to, uint256 _value) returns (bool success);
27     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
28     function approve(address _spender, uint256 _value) returns (bool success);
29     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
30 
31     event Transfer(address indexed _from, address indexed _to, uint256 _value);
32     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
33 }
34 
35 /*  ERC 20 token */
36 contract StandardToken is Token, SafeMath {
37 
38     mapping (address => uint256) balances;
39     mapping (address => mapping (address => uint256)) allowed;
40 
41     modifier onlyPayloadSize(uint numwords) {
42         assert(msg.data.length == numwords * 32 + 4);
43         _;
44     }
45 
46     function transfer(address _to, uint256 _value)
47     returns (bool success)
48     {
49         if (balances[msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
50             balances[msg.sender] = safeSubtract(balances[msg.sender], _value);
51             balances[_to] = safeAdd(balances[_to], _value);
52             Transfer(msg.sender, _to, _value);
53             return true;
54         } else {
55             return false;
56         }
57     }
58 
59     function transferFrom(address _from, address _to, uint256 _value)
60     returns (bool success)
61     {
62         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0 && balances[_to] + _value > balances[_to]) {
63             balances[_to] = safeAdd(balances[_to], _value);
64             balances[_from] = safeSubtract(balances[_from], _value);
65             allowed[_from][msg.sender] = safeSubtract(allowed[_from][msg.sender], _value);
66             Transfer(_from, _to, _value);
67             return true;
68         } else {
69             return false;
70         }
71     }
72 
73     function balanceOf(address _owner) constant returns (uint256 balance) {
74         return balances[_owner];
75     }
76 
77     function approve(address _spender, uint256 _value)
78     onlyPayloadSize(2)
79     returns (bool success)
80     {
81         allowed[msg.sender][_spender] = _value;
82         Approval(msg.sender, _spender, _value);
83         return true;
84     }
85 
86     function allowance(address _owner, address _spender)
87     constant
88     onlyPayloadSize(2)
89     returns (uint256 remaining)
90     {
91         return allowed[_owner][_spender];
92     }
93 }
94 /**
95  * @title VIBECoin
96  * @dev ERC20 Token, where all tokens are pre-assigned to the creator.
97  * Note they can later distribute these tokens as they wish using `transfer` and other
98  * `StandardToken` functions.
99  */
100 contract VibeCoin is StandardToken {
101 
102   string public name = "Vibe Coin";
103   string public symbol = "VIBE";
104   uint256 public decimals = 18;
105   uint256 public INITIAL_SUPPLY = 267000000 * 1 ether;
106 
107   /**
108    * @dev Contructor that gives msg.sender all of existing tokens.
109    */
110   function VibeCoin() {
111     totalSupply = INITIAL_SUPPLY;
112     balances[msg.sender] = INITIAL_SUPPLY;
113   }
114 
115 }