1 pragma solidity ^0.4.15;
2 
3 /*********************************************************************************
4  *********************************************************************************
5  *
6  * Name of the project: ERC20 Basic Token
7  * Author: Juan Livingston 
8  *
9  *********************************************************************************
10  ********************************************************************************/
11 
12  /* New ERC20 contract interface */
13 
14 contract ERC20Basic {
15     uint256 public totalSupply;
16     function balanceOf(address who) constant returns (uint256);
17     function transfer(address to, uint256 value) returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19 }
20 
21 // The Token
22 
23 contract Token {
24 
25     // Token public variables
26     string public name;
27     string public symbol;
28     uint8 public decimals; 
29     string public version = 'v1';
30     uint256 public totalSupply;
31     uint public price;
32     bool locked;
33 
34     address rootAddress;
35     address Owner;
36     uint multiplier; // For 0 decimals
37 
38     mapping(address => uint256) balances;
39     mapping(address => mapping(address => uint256)) allowed;
40     mapping(address => bool) freezed;
41 
42 
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 
46 
47     // Modifiers
48 
49     modifier onlyOwner() {
50         if ( msg.sender != rootAddress && msg.sender != Owner ) revert();
51         _;
52     }
53 
54     modifier onlyRoot() {
55         if ( msg.sender != rootAddress ) revert();
56         _;
57     }
58 
59     modifier isUnlocked() {
60     	if ( locked && msg.sender != rootAddress && msg.sender != Owner ) revert();
61 		_;    	
62     }
63 
64     modifier isUnfreezed(address _to) {
65     	if ( freezed[msg.sender] || freezed[_to] ) revert();
66     	_;
67     }
68 
69 
70     // Safe math
71     function safeAdd(uint x, uint y) internal returns (uint z) {
72         require((z = x + y) >= x);
73     }
74     function safeSub(uint x, uint y) internal returns (uint z) {
75         require((z = x - y) <= x);
76     }
77 
78 
79     // Token constructor
80     function Token() {        
81         locked = false;
82         name = 'Token name'; 
83         symbol = 'SYMBOL'; 
84         decimals = 18; 
85         multiplier = 10 ** uint(decimals);
86         totalSupply = 1000000 * multiplier; // 1,000,000 tokens
87         rootAddress = msg.sender;        
88         Owner = msg.sender;
89         balances[rootAddress] = totalSupply; 
90     }
91 
92 
93     // Only root function
94 
95     function changeRoot(address _newrootAddress) onlyRoot returns(bool){
96         rootAddress = _newrootAddress;
97         return true;
98     }
99 
100     // Only owner functions
101 
102     // To send ERC20 tokens sent accidentally
103     function sendToken(address _token,address _to , uint _value) onlyOwner returns(bool) {
104         ERC20Basic Token = ERC20Basic(_token);
105         require(Token.transfer(_to, _value));
106         return true;
107     }
108 
109     function changeOwner(address _newOwner) onlyOwner returns(bool) {
110         Owner = _newOwner;
111         return true;
112     }
113        
114     function unlock() onlyOwner returns(bool) {
115         locked = false;
116         return true;
117     }
118 
119     function lock() onlyOwner returns(bool) {
120         locked = true;
121         return true;
122     }
123 
124 
125     function burn(uint256 _value) onlyOwner returns(bool) {
126         if ( balances[rootAddress] < _value ) revert();
127         balances[rootAddress] = safeSub( balances[rootAddress] , _value );
128         totalSupply = safeSub( totalSupply,  _value );
129         Transfer(rootAddress, 0x0,_value);
130         return true;
131     }
132 
133 
134     // Public getters
135 
136     function isLocked() constant returns(bool) {
137         return locked;
138     }
139 
140 
141     // Standard function transfer
142     function transfer(address _to, uint _value) isUnlocked returns (bool success) {
143         if (balances[msg.sender] < _value) return false;
144         balances[msg.sender] = safeSub(balances[msg.sender], _value);
145         balances[_to] = safeAdd(balances[_to], _value);
146         Transfer(msg.sender,_to,_value);
147         return true;
148         }
149 
150 
151     function transferFrom(address _from, address _to, uint256 _value) public returns(bool) {
152 
153         if ( locked && msg.sender != Owner && msg.sender != rootAddress ) return false; 
154         if ( freezed[_from] || freezed[_to] ) return false; // Check if destination address is freezed
155         if ( balances[_from] < _value ) return false; // Check if the sender has enough
156     	if ( _value > allowed[_from][msg.sender] ) return false; // Check allowance
157 
158         balances[_from] = safeSub(balances[_from] , _value); // Subtract from the sender
159         balances[_to] = safeAdd(balances[_to] , _value); // Add the same to the recipient
160 
161         allowed[_from][msg.sender] = safeSub( allowed[_from][msg.sender] , _value );
162 
163         Transfer(_from,_to,_value);
164         return true;
165     }
166 
167 
168     function balanceOf(address _owner) constant returns(uint256 balance) {
169         return balances[_owner];
170     }
171 
172 
173     function approve(address _spender, uint _value) returns(bool) {
174         allowed[msg.sender][_spender] = _value;
175         Approval(msg.sender, _spender, _value);
176         return true;
177     }
178 
179 
180     function allowance(address _owner, address _spender) constant returns(uint256) {
181         return allowed[_owner][_spender];
182     }
183 }