1 pragma solidity ^0.4.11;
2 
3 interface IERC20 {
4     function totalSupply() constant returns (uint256 totalSupply);
5     function balanceOf(address _owner) constant returns (uint256 balance);
6     function transfer(address _to, uint256 _value) returns (bool success);
7     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
8     function approve (address _spender, uint256 _value) returns (bool success);
9     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
10     event Transfer(address indexed _from, address indexed_to, uint256 _value);
11     event Approval(address indexed_owner, address indexed_spender, uint256 _value);
12 }
13 contract CrowdToken is IERC20 {
14     
15     using SafeMath for uint256;
16     uint private _totalSupply = 10000000;
17     
18     string public constant symbol ="CRCN";
19     string public constant name = "Crowd Token";
20     uint8 public constant decimals = 3;
21     
22     //1 ether = 350 CRCN
23     uint256 public constant RATE = 350;
24     
25     address public owner;
26     
27     
28     mapping(address => uint256) balances;
29     mapping(address => mapping(address => uint256)) allowed;
30     
31     function () payable {
32         createTokens();
33     }
34     
35     function CrowdToken () {
36         owner = msg.sender;
37     }
38     
39     function createTokens() payable {
40         require(msg.value > 0);
41         
42         uint256 tokens = msg.value.mul(RATE);
43         balances[msg.sender] = balances[msg.sender].add(tokens);
44         _totalSupply = _totalSupply.add(tokens);
45         
46         owner.transfer(msg.value);
47     }
48         
49    function totalSupply() constant returns (uint256) {
50         return _totalSupply;
51     }
52         
53 
54     
55     function balanceOf(address _owner) constant returns (uint256 balance) {
56         return balances[_owner]; 
57     }
58     
59     function transfer(address _to, uint256 _value) returns (bool success) {
60         require(
61           balances[msg.sender] >= _value
62           && _value > 0
63         );
64         balances[msg.sender] -= balances[msg.sender].sub(_value);
65         balances[_to] = balances[_to].add(_value);
66         Transfer(msg.sender, _to, _value);
67         return true;
68     }
69     
70     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
71         require(
72             allowed[_from][msg.sender] >= _value
73             && balances[_from] >= _value
74             && _value > 0
75         );
76         balances[_from] = balances[_from].sub( _value);
77         balances[_to] = balances [_to].add(_value);
78         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
79         Transfer(_from, _to, _value);
80         return true;
81     }
82     
83     function approve (address _spender, uint256 _value) returns (bool success) {
84         allowed[msg.sender][_spender] =_value;
85         Approval(msg.sender, _spender, _value);
86         return true;
87     }
88     
89     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
90         return allowed[_owner][_spender];
91     }
92     
93     event Transfer(address indexed _from, address indexed_to, uint256 _value);
94     event Approval(address indexed_owner, address indexed_spender, uint256 _value);
95     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
96     uint256 c = a * b;
97     assert(a == 0 || c / a == b);
98     return c;
99   }
100   function bytes32ToString(bytes32 x) constant returns (string) {
101         bytes memory bytesString = new bytes(32);
102         uint charCount = 0;
103         for (uint j = 0; j < 32; j++) {
104             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
105             if (char != 0) {
106                 bytesString[charCount] = char;
107                 charCount++;
108             }
109         }
110         bytes memory bytesStringTrimmed = new bytes(charCount);
111         for (j = 0; j < charCount; j++) {
112             bytesStringTrimmed[j] = bytesString[j];
113         }
114         return string(bytesStringTrimmed);
115     }
116     
117 }
118 
119 library SafeMath {
120   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
121     uint256 c = a * b;
122     assert(a == 0 || c / a == b);
123     return c;
124   }
125 
126   function div(uint256 a, uint256 b) internal constant returns (uint256) {
127     // assert(b > 0); // Solidity automatically throws when dividing by 0
128     uint256 c = a / b;
129     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
130     return c;
131   }
132 
133   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   function add(uint256 a, uint256 b) internal constant returns (uint256) {
139     uint256 c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }