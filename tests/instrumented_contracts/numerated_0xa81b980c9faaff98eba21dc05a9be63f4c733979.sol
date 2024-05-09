1 pragma solidity ^0.4.16;
2 
3 contract ERC20 {
4   uint public totalSupply;
5   function balanceOf(address who) constant returns (uint);
6   function allowance(address owner, address spender) constant returns (uint);
7 
8   function transfer(address to, uint value) returns (bool ok);
9   function transferFrom(address from, address to, uint value) returns (bool ok);
10   function approve(address spender, uint value) returns (bool ok);
11   event Transfer(address indexed from, address indexed to, uint value);
12   event Approval(address indexed owner, address indexed spender, uint value);
13 }
14 
15 contract Ownable {
16   address public owner;
17 
18   function Ownable() {
19     owner = msg.sender;
20   }
21 
22   modifier onlyOwner() {
23     if (msg.sender == owner)
24       _;
25   }
26 
27   function transferOwnership(address newOwner) onlyOwner {
28     if (newOwner != address(0)) owner = newOwner;
29   }
30 
31 }
32 
33 contract TokenSpender {
34     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
35 }
36 
37 contract SafeMath {
38   function safeMul(uint a, uint b) internal returns (uint) {
39     uint c = a * b;
40     assert(a == 0 || c / a == b);
41     return c;
42   }
43 
44   function safeDiv(uint a, uint b) internal returns (uint) {
45     assert(b > 0);
46     uint c = a / b;
47     assert(a == b * c + a % b);
48     return c;
49   }
50 
51   function safeSub(uint a, uint b) internal returns (uint) {
52     assert(b <= a);
53     return a - b;
54   }
55 
56   function safeAdd(uint a, uint b) internal returns (uint) {
57     uint c = a + b;
58     assert(c>=a && c>=b);
59     return c;
60   }
61 
62   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
63     return a >= b ? a : b;
64   }
65 
66   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
67     return a < b ? a : b;
68   }
69 
70   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
71     return a >= b ? a : b;
72   }
73 
74   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
75     return a < b ? a : b;
76   }
77 
78   function assert(bool assertion) internal {
79     if (!assertion) {
80       throw;
81     }
82   }
83 }
84 
85 contract iToken is ERC20, SafeMath, Ownable {
86 
87     /* Public variables of the token */
88   string public name;       //fancy name
89   string public symbol;
90   uint8 public decimals;    //How many decimals to show.
91   string public version = 'v0.1'; 
92   uint public initialSupply;
93   uint public totalSupply;
94   bool public locked;
95   //uint public unlockBlock;
96 
97   mapping(address => uint) balances;
98   mapping (address => mapping (address => uint)) allowed;
99 
100   // lock transfer during the ICO
101   modifier onlyUnlocked() {
102     if (msg.sender != owner && locked) throw;
103     _;
104   }
105 
106   /*
107    *  The RLC Token created with the time at which the crowdsale end
108    */
109 
110   function iToken() {
111 
112     initialSupply = 100000000000;
113     totalSupply = initialSupply;
114     balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
115     name = 'myToken';        // Set the name for display purposes     
116     symbol = 'TKN';                       // Set the symbol for display purposes  
117     decimals = 9;                        // Amount of decimals for display purposes
118   }
119 
120   function burn(uint256 _value) returns (bool){
121     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
122     totalSupply = safeSub(totalSupply, _value);
123     Transfer(msg.sender, 0x0, _value);
124     return true;
125   }
126 
127   function transfer(address _to, uint _value) returns (bool) {
128     balances[msg.sender] = safeSub(balances[msg.sender], _value);
129     balances[_to] = safeAdd(balances[_to], _value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   function transferFrom(address _from, address _to, uint _value) returns (bool) {
135     var _allowance = allowed[_from][msg.sender];
136     
137     balances[_to] = safeAdd(balances[_to], _value);
138     balances[_from] = safeSub(balances[_from], _value);
139     allowed[_from][msg.sender] = safeSub(_allowance, _value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function balanceOf(address _owner) constant returns (uint balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint _value) returns (bool) {
149     allowed[msg.sender][_spender] = _value;
150     Approval(msg.sender, _spender, _value);
151     return true;
152   }
153 
154     /* Approve and then comunicate the approved contract in a single tx */
155   function approveAndCall(address _spender, uint256 _value, bytes _extraData){    
156       TokenSpender spender = TokenSpender(_spender);
157       if (approve(_spender, _value)) {
158           spender.receiveApproval(msg.sender, _value, this, _extraData);
159       }
160   }
161 
162   function allowance(address _owner, address _spender) constant returns (uint remaining) {
163     return allowed[_owner][_spender];
164   }
165   
166 }