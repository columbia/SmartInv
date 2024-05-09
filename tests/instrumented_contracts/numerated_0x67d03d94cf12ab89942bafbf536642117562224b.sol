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
51 
52 
53     function balanceOf(address _owner) constant returns (uint256 balance) {}
54 
55 
56     function transfer(address _to, uint256 _value) returns (bool success) {}
57 
58 
59     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
60 
61     function approve(address _spender, uint256 _value) returns (bool success) {}
62 
63     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
64 
65     event Transfer(address indexed _from, address indexed _to, uint256 _value);
66     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
67 }
68 
69 
70 
71 contract StandardToken is Token {
72     using SafeMath for uint256;
73     function transfer(address _to, uint256 _value) returns (bool success) {
74         //Default assumes totalSupply can't be over max (2^256 - 1).
75         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
76         //Replace the if with this one instead.
77         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
78 
79         if (_to == 0x0) throw;   
80         if (_value <= 0) throw;
81         if (balances[msg.sender] >= _value && _value > 0) {
82             balances[msg.sender] -= _value;
83 
84             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      
85 
86             balances[_to] += SafeMath.add(balances[_to], _value);     
87             Transfer(msg.sender, _to, _value);
88             return true;
89         } else { return false; }
90     }
91 
92     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
93         //same as above. Replace this line with the following if you want to protect against wrapping uints.
94         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
95         if (_to == 0x0) throw;
96         if (_value <= 0) throw;
97         if (balances[_from] < _value) throw;                  // Check if the sender has enough
98 
99 
100         if ( SafeMath.sub(balances[_to], _value) < balances[_to] ) throw;    // Check for overflows
101 
102         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
103             balances[_to] = SafeMath.add( balances[_to],_value);
104             balances[_from] = SafeMath.sub(balances[_from], _value);
105             allowed[_from][msg.sender]  = SafeMath.sub(allowed[_from][msg.sender], _value);
106             Transfer(_from, _to, _value);
107             return true;
108         } else { return false; }
109     }
110 
111     function balanceOf(address _owner) constant returns (uint256 balance) {
112         return balances[_owner];
113     }
114 
115     function approve(address _spender, uint256 _value) returns (bool success) {
116         allowed[msg.sender][_spender] = _value;
117         Approval(msg.sender, _spender, _value);
118         return true;
119     }
120 
121     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
122       return allowed[_owner][_spender];
123     }
124 
125     mapping (address => uint256) balances;
126     mapping (address => mapping (address => uint256)) allowed;
127     uint256 public totalSupply;
128 }
129 
130 
131 
132 
133 contract HumanStandardToken is StandardToken {
134     using SafeMath for uint256;
135     function () {
136         //if ether is sent to this address, send it back.
137         throw;
138     }
139 
140 
141 
142     /* Public variables of the token */
143 
144     /*
145     NOTE:
146     The following variables are OPTIONAL vanities. One does not have to include them.
147     They allow one to customise the token contract & in no way influences the core functionality.
148     Some wallets/interfaces might not even bother to look at this information.
149     */
150     string public name;                   //fancy name: eg Simon Bucks
151     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
152     string public symbol;                 //An identifier: eg SBX
153     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
154 
155     function HumanStandardToken(
156         uint256 _initialAmount,
157         string _tokenName,
158         uint8 _decimalUnits,
159         string _tokenSymbol
160         ) {
161         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
162         totalSupply = _initialAmount;                        // Update total supply
163         name = _tokenName;                                   // Set the name for display purposes
164         decimals = _decimalUnits;                            // Amount of decimals for display purposes
165         symbol = _tokenSymbol;                               // Set the symbol for display purposes
166     }
167 
168     /* Approves and then calls the receiving contract */
169     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
170         allowed[msg.sender][_spender] = _value;
171         Approval(msg.sender, _spender, _value);
172 
173         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
174         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
175         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
176         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
177         return true;
178     }
179 }