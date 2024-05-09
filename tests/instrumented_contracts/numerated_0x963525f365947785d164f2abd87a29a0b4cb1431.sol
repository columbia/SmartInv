1 pragma solidity ^0.4.8;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 
32   function toUINT112(uint256 a) internal constant returns(uint112) {
33     assert(uint112(a) == a);
34     return uint112(a);
35   }
36 
37   function toUINT120(uint256 a) internal constant returns(uint120) {
38     assert(uint120(a) == a);
39     return uint120(a);
40   }
41 
42   function toUINT128(uint256 a) internal constant returns(uint128) {
43     assert(uint128(a) == a);
44     return uint128(a);
45   }
46 }
47 contract Token{
48 
49 
50     function totalSupply() constant returns (uint256 supply) {}
51     function balanceOf(address _owner) constant returns (uint256 balance) {}
52     function transfer(address _to, uint256 _value) returns (bool success) {}
53     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
54     function approve(address _spender, uint256 _value) returns (bool success) {}
55     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
56     event Transfer(address indexed _from, address indexed _to, uint256 _value);
57     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
58 }
59 
60 
61 
62 contract StandardToken is Token {
63     using SafeMath for uint256;
64     function transfer(address _to, uint256 _value) returns (bool success) {
65         //Default assumes totalSupply can't be over max (2^256 - 1).
66         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
67         //Replace the if with this one instead.
68         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
69 
70         if (_to == 0x0) throw;   
71         if (_value <= 0) throw;
72         if (balances[msg.sender] >= _value && _value > 0) {
73             balances[msg.sender] -= _value;
74 
75             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      
76 
77             balances[_to] += SafeMath.add(balances[_to], _value);     
78             Transfer(msg.sender, _to, _value);
79             return true;
80         } else { return false; }
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
84         //same as above. Replace this line with the following if you want to protect against wrapping uints.
85         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
86         if (_to == 0x0) throw;
87         if (_value <= 0) throw;
88         if (balances[_from] < _value) throw;                  // Check if the sender has enough
89 
90 
91         if ( SafeMath.sub(balances[_to], _value) < balances[_to] ) throw;    // Check for overflows
92 
93         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
94             balances[_to] = SafeMath.add( balances[_to],_value);
95             balances[_from] = SafeMath.sub(balances[_from], _value);
96             allowed[_from][msg.sender]  = SafeMath.sub(allowed[_from][msg.sender], _value);
97             Transfer(_from, _to, _value);
98             return true;
99         } else { return false; }
100     }
101 
102     function balanceOf(address _owner) constant returns (uint256 balance) {
103         return balances[_owner];
104     }
105 
106     function approve(address _spender, uint256 _value) returns (bool success) {
107         allowed[msg.sender][_spender] = _value;
108         Approval(msg.sender, _spender, _value);
109         return true;
110     }
111 
112     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
113       return allowed[_owner][_spender];
114     }
115 
116     mapping (address => uint256) balances;
117     mapping (address => mapping (address => uint256)) allowed;
118     uint256 public totalSupply;
119 }
120 
121 
122 
123 
124 contract HumanStandardToken is StandardToken {
125     using SafeMath for uint256;
126     function () {
127         //if ether is sent to this address, send it back.
128         throw;
129     }
130 
131 
132 
133     /* Public variables of the token */
134 
135     /*
136     NOTE:
137     The following variables are OPTIONAL vanities. One does not have to include them.
138     They allow one to customise the token contract & in no way influences the core functionality.
139     Some wallets/interfaces might not even bother to look at this information.
140     */
141     string public name;                   //fancy name: eg Simon Bucks
142     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
143     string public symbol;                 //An identifier: eg SBX
144     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
145 
146     function HumanStandardToken(
147         uint256 _initialAmount,
148         string _tokenName,
149         uint8 _decimalUnits,
150         string _tokenSymbol
151         ) {
152         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
153         totalSupply = _initialAmount;                        // Update total supply
154         name = _tokenName;                                   // Set the name for display purposes
155         decimals = _decimalUnits;                            // Amount of decimals for display purposes
156         symbol = _tokenSymbol;                               // Set the symbol for display purposes
157     }
158 
159     /* Approves and then calls the receiving contract */
160     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
161         allowed[msg.sender][_spender] = _value;
162         Approval(msg.sender, _spender, _value);
163 
164         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
165         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
166         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
167         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
168         return true;
169     }
170 }