1 pragma solidity ^0.4.8;
2 
3 contract OwnedByWinsome {
4 
5   address public owner;
6   mapping (address => bool) allowedWorker;
7 
8   function initOwnership(address _owner, address _worker) internal{
9     owner = _owner;
10     allowedWorker[_owner] = true;
11     allowedWorker[_worker] = true;
12   }
13 
14   function allowWorker(address _new_worker) onlyOwner{
15     allowedWorker[_new_worker] = true;
16   }
17   function removeWorker(address _old_worker) onlyOwner{
18     allowedWorker[_old_worker] = false;
19   }
20   function changeOwner(address _new_owner) onlyOwner{
21     owner = _new_owner;
22   }
23 						    
24   modifier onlyAllowedWorker{
25     if (!allowedWorker[msg.sender]){
26       throw;
27     }
28     _;
29   }
30 
31   modifier onlyOwner{
32     if (msg.sender != owner){
33       throw;
34     }
35     _;
36   }
37 
38   
39 }
40 
41 /**
42  * Math operations with safety checks
43  */
44 library SafeMath {
45   function mul(uint a, uint b) internal returns (uint) {
46     uint c = a * b;
47     assert(a == 0 || c / a == b);
48     return c;
49   }
50 
51   function div(uint a, uint b) internal returns (uint) {
52     assert(b > 0);
53     uint c = a / b;
54     assert(a == b * c + a % b);
55     return c;
56   }
57 
58   function sub(uint a, uint b) internal returns (uint) {
59     assert(b <= a);
60     return a - b;
61   }
62 
63   function add(uint a, uint b) internal returns (uint) {
64     uint c = a + b;
65     assert(c >= a);
66     return c;
67   }
68 
69   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
70     return a >= b ? a : b;
71   }
72 
73   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
74     return a < b ? a : b;
75   }
76 
77   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
78     return a >= b ? a : b;
79   }
80 
81   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
82     return a < b ? a : b;
83   }
84 
85   function assert(bool assertion) internal {
86     if (!assertion) {
87       throw;
88     }
89   }
90 }
91 
92 
93 /*
94  * Basic token
95  * Basic version of StandardToken, with no allowances
96  */
97 contract BasicToken {
98   using SafeMath for uint;
99   event Transfer(address indexed from, address indexed to, uint value);
100   mapping(address => uint) balances;
101   uint public     totalSupply =    0;    			 // Total supply of 500 million Tokens
102   
103   /*
104    * Fix for the ERC20 short address attack  
105    */
106   modifier onlyPayloadSize(uint size) {
107      if(msg.data.length < size + 4) {
108        throw;
109      }
110      _;
111   }
112 
113   function transfer(address _to, uint _value) onlyPayloadSize(2 * 32) {
114     balances[msg.sender] = balances[msg.sender].sub(_value);
115     balances[_to] = balances[_to].add(_value);
116     Transfer(msg.sender, _to, _value);
117   }
118 
119   function balanceOf(address _owner) constant returns (uint balance) {
120     return balances[_owner];
121   }
122   
123 }
124 
125 
126 contract StandardToken is BasicToken{
127   
128   event Approval(address indexed owner, address indexed spender, uint value);
129 
130   
131   mapping (address => mapping (address => uint)) allowed;
132 
133   function transferFrom(address _from, address _to, uint _value) {
134     var _allowance = allowed[_from][msg.sender];
135 
136     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
137     // if (_value > _allowance) throw;
138 
139     balances[_to] = balances[_to].add(_value);
140     balances[_from] = balances[_from].sub(_value);
141     allowed[_from][msg.sender] = _allowance.sub(_value);
142     Transfer(_from, _to, _value);
143   }
144 
145   function approve(address _spender, uint _value) {
146     allowed[msg.sender][_spender] = _value;
147     Approval(msg.sender, _spender, _value);
148   }
149 
150   function allowance(address _owner, address _spender) constant returns (uint remaining) {
151     return allowed[_owner][_spender];
152   }
153 
154 }
155 
156 
157 contract WinToken is StandardToken, OwnedByWinsome{
158 
159   string public   name =           "Winsome.io Token";
160   string public   symbol =         "WIN";
161   uint public     decimals =       18;
162   
163   mapping (address => bool) allowedMinter;
164 
165   function WinToken(address _owner){
166     allowedMinter[_owner] = true;
167     initOwnership(_owner, _owner);
168   }
169 
170   function allowMinter(address _new_minter) onlyOwner{
171     allowedMinter[_new_minter] = true;
172   }
173   function removeMinter(address _old_minter) onlyOwner{
174     allowedMinter[_old_minter] = false;
175   }
176 
177   modifier onlyAllowedMinter{
178     if (!allowedMinter[msg.sender]){
179       throw;
180     }
181     _;
182   }
183   function mintTokens(address _for, uint _value_wei) onlyAllowedMinter {
184     balances[_for] = balances[_for].add(_value_wei);
185     totalSupply = totalSupply.add(_value_wei) ;
186     Transfer(address(0), _for, _value_wei);
187   }
188   function destroyTokens(address _for, uint _value_wei) onlyAllowedMinter {
189     balances[_for] = balances[_for].sub(_value_wei);
190     totalSupply = totalSupply.sub(_value_wei);
191     Transfer(_for, address(0), _value_wei);    
192   }
193   
194 }