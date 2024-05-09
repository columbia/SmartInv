1 pragma solidity ^0.4.20;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31   modifier onlyPayloadSize(uint numWords){
32     assert(msg.data.length >= numWords * 32 + 4);
33     _;
34   }
35 }
36 
37 contract Token{ // ERC20 standard
38 
39     event Transfer(address indexed _from, address indexed _to, uint256 _value);
40     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
41     function balanceOf(address _owner) public constant returns (uint256 balance);
42     function transfer(address _to, uint256 _value) public returns (bool success);
43     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
44     function approve(address _spender, uint256 _value) public returns (bool success);
45     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
46 
47 }
48 
49 contract StandardToken is Token, SafeMath{
50 
51     uint256 public totalSupply;
52 
53     function transfer(address _to, uint256 _value) public onlyPayloadSize(2) returns (bool success){
54         require(_to != address(0));
55         require(balances[msg.sender] >= _value && _value > 0);
56         balances[msg.sender] = safeSub(balances[msg.sender], _value);
57         balances[_to] = safeAdd(balances[_to], _value);
58         Transfer(msg.sender, _to, _value);
59         return true;
60     }
61 
62     function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3) returns (bool success){
63         require(_to != address(0));
64         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
65         balances[_from] = safeSub(balances[_from], _value);
66         balances[_to] = safeAdd(balances[_to], _value);
67         allowed[_from][msg.sender] = safeSub(allowed[_from][msg.sender], _value);
68         Transfer(_from, _to, _value);
69         return true;
70     }
71 
72     function balanceOf(address _owner) public constant returns (uint256 balance){
73         return balances[_owner];
74     }
75     
76     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77     function approve(address _spender, uint256 _value) public onlyPayloadSize(2) returns (bool success){
78         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
79         allowed[msg.sender][_spender] = _value;
80         Approval(msg.sender, _spender, _value);
81         return true;
82     }
83 
84     function changeApproval(address _spender, uint256 _oldValue, uint256 _newValue) public onlyPayloadSize(3) returns (bool success){
85         require(allowed[msg.sender][_spender] == _oldValue);
86         allowed[msg.sender][_spender] = _newValue;
87         Approval(msg.sender, _spender, _newValue);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
92         return allowed[_owner][_spender];
93     }
94 
95     // this creates an array with all balances
96     mapping (address => uint256) balances;
97     mapping (address => mapping (address => uint256)) allowed;
98 
99 }
100 
101 contract LC is StandardToken {
102     
103 
104     // public variables of the token
105 
106     string public constant name = "libra";
107     string public constant symbol = "LC";
108     uint256 public constant decimals = 18;
109     
110     // reachable if max amount raised
111    
112 
113 
114     address mainWallet;
115 
116 
117     modifier onlyMainWallet{
118         require(msg.sender == mainWallet);
119         _;
120     }
121 
122     function LC() public {
123         totalSupply = 2000000000e18;
124         mainWallet = msg.sender;
125         balances[mainWallet] = totalSupply;
126         
127     }
128 
129     modifier onlyOwner() {
130     require(msg.sender == mainWallet);
131     _;
132   }
133 
134    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135   /**
136    * @dev Allows the current owner to transfer control of the contract to a newOwner.
137    * @param newOwner The address to transfer ownership to.
138    */
139   function transferOwnership(address newOwner) onlyOwner public {
140     require(newOwner != address(0));
141     OwnershipTransferred(mainWallet, newOwner);
142     balances[newOwner]=balances[mainWallet];
143     balances[mainWallet] = 0;
144     mainWallet = newOwner;
145   }
146 
147     function sendBatchCS(address[] _recipients, uint[] _values) external returns (bool) {
148         require(_recipients.length == _values.length);
149 
150         uint senderBalance = balances[msg.sender];
151         for (uint i = 0; i < _values.length; i++) {
152             uint value = _values[i];
153             address to = _recipients[i];
154             require(senderBalance >= value);
155             if(msg.sender != _recipients[i]){
156                 senderBalance = senderBalance - value;
157                 balances[to] += value;
158             }
159 		     Transfer(msg.sender, to, value);
160         }
161         balances[msg.sender] = senderBalance;
162         return true;
163     } 
164 }