1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9   function mul(uint a, uint b) internal pure returns (uint) {
10     if (a == 0) {
11       return 0;
12     }
13     uint c = a * b;
14     assert(c / a == b);
15     return c;
16   }
17 
18   function div(uint a, uint b) internal pure returns (uint) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     uint c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return c;
23   }
24 
25   function sub(uint a, uint b) internal pure returns (uint) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30   function add(uint a, uint b) internal pure returns (uint) {
31     uint c = a + b;
32     assert(c >= a);
33     return c;
34   }
35 }
36 
37 contract ERC20 {
38 
39     function totalSupply() public constant returns (uint supply);
40     
41     function balanceOf(address _owner) public constant returns (uint balance);
42     
43     function transfer(address _to, uint _value) public returns (bool success);
44     
45     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
46     
47     function approve(address _spender, uint _value) public returns (bool success);
48     
49     function allowance(address _owner, address _spender) public constant returns (uint remaining);
50 
51     event Transfer(address indexed _from, address indexed _to, uint _value);
52     
53     event Approval(address indexed _owner, address indexed _spender, uint _value);
54 }
55 
56 
57 contract StandardToken is ERC20 {
58 
59     using SafeMath for uint;
60 
61     uint public totalSupply;
62 
63     mapping (address => uint) balances;
64     
65     mapping (address => mapping (address => uint)) allowed;
66 
67     function totalSupply() public constant returns (uint) {
68         return totalSupply;
69     }
70 
71     function balanceOf(address _owner) public constant returns (uint balance) {
72         return balances[_owner];
73     }
74 
75     function transfer(address _to, uint _value) public returns (bool success) {
76         require(balances[msg.sender] >= _value && _value > 0);
77         
78         balances[msg.sender] = balances[msg.sender].sub(_value);
79         balances[_to] = balances[_to].add(_value);
80         Transfer(msg.sender, _to, _value);
81         
82         return true;
83     }
84 
85     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
86         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
87         
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         
93         return true;
94     }
95 
96     function approve(address _spender, uint _value) public returns (bool success) {
97         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
98         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
99             revert();
100         }
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
107         return allowed[_owner][_spender];
108     }
109 
110 }
111 
112 contract Controlled {
113 
114     address public controller;
115 
116     function Controlled() public {
117         controller = msg.sender;
118     }
119 
120     function changeController(address _newController) public only_controller {
121         controller = _newController;
122     }
123     
124     function getController() constant public returns (address) {
125         return controller;
126     }
127 
128     modifier only_controller { 
129         require(msg.sender == controller);
130         _; 
131     }
132 
133 }
134 
135 
136 contract ThetaToken is StandardToken, Controlled {
137     
138     using SafeMath for uint;
139 
140     string public constant name = "Theta Token";
141 
142     string public constant symbol = "THETA";
143 
144     uint8 public constant decimals = 18;
145 
146     // tokens can be transferred amoung holders only after unlockTime
147     uint unlockTime;
148     
149     // for token circulation on platforms that integrate Theta before unlockTime
150     mapping (address => bool) internal precirculated;
151 
152     function ThetaToken(uint _unlockTime) public {
153         unlockTime = _unlockTime;
154     }
155 
156     function transfer(address _to, uint _amount) can_transfer(msg.sender, _to) public returns (bool success) {
157         return super.transfer(_to, _amount);
158     }
159 
160     function transferFrom(address _from, address _to, uint _amount) can_transfer(_from, _to) public returns (bool success) {
161         return super.transferFrom(_from, _to, _amount);
162     }
163 
164     function mint(address _owner, uint _amount) external only_controller returns (bool) {
165         totalSupply = totalSupply.add(_amount);
166         balances[_owner] = balances[_owner].add(_amount);
167 
168         Transfer(0, _owner, _amount);
169         return true;
170     }
171 
172     function allowPrecirculation(address _addr) only_controller public {
173         precirculated[_addr] = true;
174     }
175 
176     function disallowPrecirculation(address _addr) only_controller public {
177         precirculated[_addr] = false;
178     }
179 
180     function isPrecirculationAllowed(address _addr) constant public returns(bool) {
181         return precirculated[_addr];
182     }
183     
184     function changeUnlockTime(uint _unlockTime) only_controller public {
185         unlockTime = _unlockTime;
186     }
187 
188     function getUnlockTime() constant public returns (uint) {
189         return unlockTime;
190     }
191 
192     modifier can_transfer(address _from, address _to) {
193         require((block.number >= unlockTime) || (isPrecirculationAllowed(_from) && isPrecirculationAllowed(_to)));
194         _;
195     }
196 
197 }