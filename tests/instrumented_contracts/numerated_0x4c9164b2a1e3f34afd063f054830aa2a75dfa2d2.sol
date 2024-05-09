1 pragma solidity ^0.4.24;
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
54     
55     event Burn(address indexed _from, uint _value);
56 }
57 
58 
59 contract StandardToken is ERC20 {
60 
61     using SafeMath for uint;
62 
63     uint public totalSupply;
64 
65     mapping (address => uint) balances;
66     
67     mapping (address => mapping (address => uint)) allowed;
68 
69     function totalSupply() public constant returns (uint) {
70         return totalSupply;
71     }
72 
73     function balanceOf(address _owner) public constant returns (uint balance) {
74         return balances[_owner];
75     }
76 
77     function transfer(address _to, uint _value) public returns (bool success) {
78         require(balances[msg.sender] >= _value && _value > 0);
79         
80         balances[msg.sender] = balances[msg.sender].sub(_value);
81         balances[_to] = balances[_to].add(_value);
82         emit Transfer(msg.sender, _to, _value);
83         
84         return true;
85     }
86 
87     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
88         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0);
89         
90         balances[_from] = balances[_from].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
93         emit Transfer(_from, _to, _value);
94         
95         return true;
96     }
97 
98     function approve(address _spender, uint _value) public returns (bool success) {
99         // https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100         if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) {
101             revert();
102         }
103         allowed[msg.sender][_spender] = _value;
104         emit Approval(msg.sender, _spender, _value);
105         return true;
106     }
107 
108     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
109         return allowed[_owner][_spender];
110     }
111 
112 }
113 
114 contract Controlled {
115 
116     address public controller;
117 
118     constructor() public {
119         controller = msg.sender;
120     }
121 
122     function changeController(address _newController) public only_controller {
123         controller = _newController;
124     }
125     
126     function getController() constant public returns (address) {
127         return controller;
128     }
129 
130     modifier only_controller { 
131         require(msg.sender == controller);
132         _; 
133     }
134 
135 }
136 
137 
138 contract IVTToken is StandardToken, Controlled {
139     
140     using SafeMath for uint;
141 
142     string public constant name = "IVT Token";
143 
144     string public constant symbol = "IVT";
145 
146     uint8 public constant decimals = 2;
147     
148     // for token circulation on platforms that integrate Theta before unlockTime
149     mapping (address => bool) internal frozenAccount;
150 
151     constructor() public {
152         totalSupply = 200*10000*10000 * 10 ** uint256(decimals); 
153         balances[msg.sender] = totalSupply; 
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
164     function burn(uint _amount) public returns (bool) {
165     	require(balances[msg.sender] >= _amount && _amount > 0);
166     	
167     	totalSupply = totalSupply.sub(_amount);
168     	balances[msg.sender] = balances[msg.sender].sub(_amount);
169     	
170         emit Burn(msg.sender, _amount);
171         return true;
172     }
173 
174     function burnFrom(address _from, uint _amount) public returns (bool) {
175     	require(balances[_from] >= _amount && _amount > 0 && allowed[_from][msg.sender] >= _amount);
176     	
177     	totalSupply = totalSupply.sub(_amount);
178     	balances[_from] = balances[_from].sub(_amount);
179     	allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
180     	
181         emit Burn(_from, _amount);
182         return true;
183     }
184     
185     function freezeAccount(address _addr, bool _isFrozen) only_controller public {
186     	frozenAccount[_addr] = _isFrozen;
187     }
188 
189     function isFrozenAccount(address _addr) constant public returns(bool) {
190         return frozenAccount[_addr];
191     }
192 
193     modifier can_transfer(address _from, address _to) {
194         require(!isFrozenAccount(_from) && !isFrozenAccount(_to));
195         _;
196     }
197 
198 }