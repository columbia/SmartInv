1 pragma solidity ^0.4.8;
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
15 
16 contract Ownable {
17   address public owner;
18 
19   function Ownable() {
20     owner = msg.sender;
21   }
22 
23   modifier onlyOwner() {
24     if (msg.sender == owner)
25       _;
26   }
27 
28   function transferOwnership(address newOwner) onlyOwner {
29     if (newOwner != address(0)) owner = newOwner;
30   }
31 
32 }
33 
34 
35 contract TokenSpender {
36     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData);
37 }
38 
39 contract SafeMath {
40   function safeMul(uint a, uint b) internal returns (uint) {
41     uint c = a * b;
42     assert(a == 0 || c / a == b);
43     return c;
44   }
45 
46   function safeDiv(uint a, uint b) internal returns (uint) {
47     assert(b > 0);
48     uint c = a / b;
49     assert(a == b * c + a % b);
50     return c;
51   }
52 
53   function safeSub(uint a, uint b) internal returns (uint) {
54     assert(b <= a);
55     return a - b;
56   }
57 
58   function safeAdd(uint a, uint b) internal returns (uint) {
59     uint c = a + b;
60     assert(c>=a && c>=b);
61     return c;
62   }
63 
64   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
65     return a >= b ? a : b;
66   }
67 
68   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
69     return a < b ? a : b;
70   }
71 
72   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
73     return a >= b ? a : b;
74   }
75 
76   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
77     return a < b ? a : b;
78   }
79 
80   function assert(bool assertion) internal {
81     if (!assertion) {
82       throw;
83     }
84   }
85 }
86 
87 
88 contract YEARS is ERC20, SafeMath, Ownable {
89 
90     /* Public variables of the token */
91   string public name;       //fancy name
92   string public symbol;
93   uint8 public decimals;    //How many decimals to show.
94   string public version = 'v0.1'; 
95   uint public initialSupply;
96   uint public totalSupply;
97   bool public locked;
98   //uint public unlockBlock;
99 
100   mapping(address => uint) balances;
101   mapping (address => mapping (address => uint)) allowed;
102 
103   // lock transfer during the ICO
104   modifier onlyUnlocked() {
105     if (msg.sender != owner && locked) throw;
106     _;
107   }
108 
109   /*
110    *  The YERS Token created with the time at which the crowdsale end
111    */
112 
113   function YEARS() {
114     // lock the transfer function during the crowdsale
115     locked = true;
116     //unlockBlock=  now + 15 days; // (testnet) - for mainnet put the block number
117 
118     initialSupply = 10000000000000000;
119     totalSupply = initialSupply;
120     balances[msg.sender] = initialSupply;// Give the creator all initial tokens                    
121     name = 'LIGHTYEARS';        // Set the name for display purposes     
122     symbol = 'LYS';                       // Set the symbol for display purposes  
123     decimals = 8;                        // Amount of decimals for display purposes
124   }
125 
126   function unlock() onlyOwner {
127     locked = false;
128   }
129 
130   function burn(uint256 _value) returns (bool){
131     balances[msg.sender] = safeSub(balances[msg.sender], _value) ;
132     totalSupply = safeSub(totalSupply, _value);
133     Transfer(msg.sender, 0x0, _value);
134     return true;
135   }
136 
137   function transfer(address _to, uint _value) onlyUnlocked returns (bool) {
138     balances[msg.sender] = safeSub(balances[msg.sender], _value);
139     balances[_to] = safeAdd(balances[_to], _value);
140     Transfer(msg.sender, _to, _value);
141     return true;
142   }
143 
144   function transferFrom(address _from, address _to, uint _value) onlyUnlocked returns (bool) {
145     var _allowance = allowed[_from][msg.sender];
146     
147     balances[_to] = safeAdd(balances[_to], _value);
148     balances[_from] = safeSub(balances[_from], _value);
149     allowed[_from][msg.sender] = safeSub(_allowance, _value);
150     Transfer(_from, _to, _value);
151     return true;
152   }
153 
154   function balanceOf(address _owner) constant returns (uint balance) {
155     return balances[_owner];
156   }
157 
158   function approve(address _spender, uint _value) returns (bool) {
159     allowed[msg.sender][_spender] = _value;
160     Approval(msg.sender, _spender, _value);
161     return true;
162   }
163 
164     /* Approve and then comunicate the approved contract in a single tx */
165   function approveAndCall(address _spender, uint256 _value, bytes _extraData){    
166       TokenSpender spender = TokenSpender(_spender);
167       if (approve(_spender, _value)) {
168           spender.receiveApproval(msg.sender, _value, this, _extraData);
169       }
170   }
171 
172   function allowance(address _owner, address _spender) constant returns (uint remaining) {
173     return allowed[_owner][_spender];
174   }
175   
176 }