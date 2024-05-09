1 pragma solidity ^0.4.19;
2 /**
3  * Math operations with safety checks
4  */
5 library SafeMath {
6   function mul(uint256 a, uint256 b) internal returns (uint256) {
7     uint c = a * b;
8     assert(a == 0 || c / a == b);
9     return c;
10   }
11 
12   function div(uint256 a, uint256 b) internal returns (uint256) {
13     // assert(b > 0); // Solidity automatically throws when dividing by 0
14     uint256 c = a / b;
15     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 
30   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
31     return a >= b ? a : b;
32   }
33 
34   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
35     return a < b ? a : b;
36   }
37 
38   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
39     return a >= b ? a : b;
40   }
41 
42   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
43     return a < b ? a : b;
44   }
45 
46   function assert(bool assertion) internal {
47     if (!assertion) {
48       throw;
49     }
50   }
51 }
52 
53 contract Token {
54 
55     uint256 public totalSupply;
56 
57     function balanceOf(address _owner) constant public returns (uint256 balance);
58 
59     function transfer(address _to, uint256 _value) public returns (bool success);
60 
61     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
62 
63     function approve(address _spender, uint256 _value) public returns (bool success);
64 
65     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 }
70 
71 contract StandardToken is Token {
72     using SafeMath for uint;
73 
74     mapping (address => uint256) balances;
75     mapping (address => mapping (address => uint256)) allowed;
76 
77     function transfer(address _to, uint256 _value) public returns (bool success) {
78         require(_to != address(0));
79         require(_value <= balances[msg.sender]);
80         
81         /**
82         * update 425
83         */
84         require(balances[_to].add(_value) > balances[_to]);
85         balances[msg.sender] = balances[msg.sender].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         
88         Transfer(msg.sender, _to, _value);
89         return true;
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
93         require(_to != address(0));
94         require(_value <= balances[_from]);
95         require(_value <= allowed[_from][msg.sender]);
96         /**
97         * update 425
98         */
99         require(balances[_to].add(_value) > balances[_to]);
100         balances[_to] = balances[_to].add(_value);
101         balances[_from] = balances[_from].sub(_value);
102         
103         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
104         Transfer(_from, _to, _value);
105         return true;
106     }
107 
108     function balanceOf(address _owner) constant public returns (uint256 balance) {
109         return balances[_owner];
110     }
111 
112     function approve(address _spender, uint256 _value) public returns (bool success) {
113         allowed[msg.sender][_spender] = _value;
114         Approval(msg.sender, _spender, _value);
115         return true;
116     }
117 
118     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
119         return allowed[_owner][_spender];
120     }
121 }
122 
123 contract CryptoStrategiesIntelligence is StandardToken {
124 
125     function () public {
126         revert();
127     }
128 
129     string public name = "CryptoStrategies Intelligence";
130     uint8 public decimals = 18;
131     uint256 private supplyDecimals = 1 * 10 ** uint256(decimals);
132     string public symbol = "CSI";
133     string public version = 'v0.1';
134     address public founder;
135 
136     function CryptoStrategiesIntelligence () public {
137         founder = msg.sender;
138         totalSupply = 100000000000 * supplyDecimals;
139         balances[founder] = totalSupply;
140     }
141 
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
143         allowed[msg.sender][_spender] = _value;
144         Approval(msg.sender, _spender, _value);
145         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
146         return true;
147     }
148 
149     function approveAndCallcode(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
150         allowed[msg.sender][_spender] = _value;
151         Approval(msg.sender, _spender, _value);
152         if(!_spender.call(_extraData)) { revert(); }
153         return true;
154     }
155 }