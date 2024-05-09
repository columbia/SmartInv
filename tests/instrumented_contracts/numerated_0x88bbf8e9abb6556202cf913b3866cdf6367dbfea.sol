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
49     function totalSupply() constant returns (uint256 supply) {}
50     function balanceOf(address _owner) constant returns (uint256 balance) {}
51     function transfer(address _to, uint256 _value) returns (bool success) {}
52     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {}
53     function approve(address _spender, uint256 _value) returns (bool success) {}
54     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {}
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
57 }
58 
59 
60 
61 contract StandardToken is Token {
62     using SafeMath for uint256;
63     function transfer(address _to, uint256 _value) returns (bool success) {
64         //Default assumes totalSupply can't be over max (2^256 - 1).
65         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
66         //Replace the if with this one instead.
67         //if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
68 
69         if (_to == 0x0) throw;   
70         if (_value <= 0) throw;
71         //if (balances[msg.sender] >= _value && _value > 0) {
72           if (balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
73             balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);      
74 
75             balances[_to] += SafeMath.add(balances[_to], _value);     
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else { return false; }
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
82         //same as above. Replace this line with the following if you want to protect against wrapping uints.
83         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
84         if (_to == 0x0) throw;
85         if (_value <= 0) throw;
86         if (balances[_from] < _value) throw;                  // Check if the sender has enough
87 
88 
89         if ( SafeMath.sub(balances[_to], _value) < balances[_to] ) throw;    // Check for overflows
90 
91         // if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
92         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
93             balances[_to] = SafeMath.add( balances[_to],_value);
94             balances[_from] = SafeMath.sub(balances[_from], _value);
95             allowed[_from][msg.sender]  = SafeMath.sub(allowed[_from][msg.sender], _value);
96             Transfer(_from, _to, _value);
97             return true;
98         } else { return false; }
99     }
100 
101     function balanceOf(address _owner) constant returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     function approve(address _spender, uint256 _value) returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
112       return allowed[_owner][_spender];
113     }
114 
115     mapping (address => uint256) balances;
116     mapping (address => mapping (address => uint256)) allowed;
117     uint256 public totalSupply;
118 }
119 
120 
121 
122 
123 contract PRVTToken is StandardToken {
124     using SafeMath for uint256;
125     function () {
126         //if ether is sent to this address, send it back.
127         throw;
128     }
129 
130 
131 
132     /* Public variables of the token */
133 
134     /*
135     NOTE:
136     The following variables are OPTIONAL vanities. One does not have to include them.
137     They allow one to customise the token contract & in no way influences the core functionality.
138     Some wallets/interfaces might not even bother to look at this information.
139     */
140     string public name;                   //fancy name: eg Simon Bucks
141     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
142     string public symbol;                 //An identifier: eg SBX
143     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
144 
145     function PRVTToken(
146         uint256 _initialAmount,
147         string _tokenName,
148         uint8 _decimalUnits,
149         string _tokenSymbol
150         ) {
151         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
152         totalSupply = _initialAmount;                        // Update total supply
153         name = _tokenName;                                   // Set the name for display purposes
154         decimals = _decimalUnits;                            // Amount of decimals for display purposes
155         symbol = _tokenSymbol;                               // Set the symbol for display purposes
156     }
157 
158     /* Approves and then calls the receiving contract */
159     function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
160         allowed[msg.sender][_spender] = _value;
161         Approval(msg.sender, _spender, _value);
162 
163         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
164         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
165         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
166         if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { throw; }
167         return true;
168     }
169 }