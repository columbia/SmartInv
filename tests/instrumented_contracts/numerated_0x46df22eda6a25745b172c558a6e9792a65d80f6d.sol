1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve(address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed _to, uint256 _value);
11     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 /**
15  * Math operations with safety checks
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41   
42   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
43       return a >= b ? a : b;
44   }
45   
46   function min64(uint64 a, uint64 b) internal constant returns (uint256) {
47       return a < b ? a : b;
48   }
49   
50   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
51       return a >= b ? a : b;
52   }
53   
54   function min256(uint256 a, uint256 b)  internal constant returns (uint256) {
55       return a < b ? a : b;
56   }
57   
58 }
59 
60 contract ETHYOLO is IERC20 {
61     
62     using SafeMath for uint256;
63     
64     uint public _totalSupply = 99994138888;
65     uint public INITIAL_SUPPLY = 4999706944;
66     string public constant symbol = "EYO";
67     string public constant name = "ETHYOLO COIN";
68     uint8 public constant decimals = 18;
69     // replace with your fund collection multisig address
70     address public constant multisig = "0x82Ee855ecA88c30029582917a536d1A7ce3886d2";
71     
72     // 1 ether = 75000000 EYO
73     uint256 public constant RATE = 75000000;
74     
75     address public owner;
76     
77     mapping(address => uint256) balances;
78     mapping(address => mapping(address => uint256)) allowed;
79     
80     function ETHYOLO() {
81         owner = msg.sender;
82     }
83     
84     function () payable {
85         createTokens();
86     }
87     
88     function createTokens() payable {
89         require(msg.value > 0);
90         
91         uint256 tokens= msg.value.mul(RATE);
92         balances[msg.sender] = balances[msg.sender].add(tokens);
93         _totalSupply = _totalSupply.add(tokens);
94         
95         
96         owner.transfer(msg.value);
97         
98     }
99     
100     function totalSupply() constant returns (uint256 _totalSupply) {
101         return _totalSupply;
102     }
103     
104     function INITIAL_SUPPLY() {
105         INITIAL_SUPPLY = INITIAL_SUPPLY;
106         balances[msg.sender] = INITIAL_SUPPLY;
107     }
108     
109     function balanceOf(address _owner) constant returns (uint256 balance) {
110         return balances[_owner];
111     }
112     
113     function transfer(address _to, uint256 _value) returns (bool success) {
114         require(
115             balances[msg.sender] >= _value
116             && _value > 0
117         );
118         balances[msg.sender] = balances[msg.sender].sub(_value);
119         balances[_to] = balances[_to].add(_value);
120         Transfer(msg.sender, _to, _value);
121         return true;
122     }
123     
124     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
125         require(
126             allowed[_from][msg.sender] >= _value
127             && balances[_from] >= _value
128             && _value > 0
129         );
130         balances[_from] = balances[_from].sub(_value);
131         balances[_to] = balances[_to].add(_value);
132         allowed[_from][msg.sender] = allowed [_from][msg.sender].sub(_value);
133         Transfer(_from, _to, _value);
134         return true;
135     }
136     
137     function approve(address _spender, uint256 _value) returns (bool success) {
138         allowed[msg.sender][_spender] = _value;
139         approval(msg.sender, _spender, _value);
140         return true;
141     }
142     
143     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
144         return allowed[_owner][_spender];
145     }
146     
147     event Transfer(address indexed _from, address indexed _to, uint256 _value);
148     event approval(address indexed _owner, address indexed _spender, uint256 _value);
149 }