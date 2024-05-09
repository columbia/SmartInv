1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         if (a == 0) {
10           return 0;
11         }
12         uint256 c = a * b;
13         assert(c / a == b);
14         return c;
15     }
16 
17     function div(uint256 a, uint256 b) internal pure returns (uint256) {
18         // assert(b > 0); // Solidity automatically throws when dividing by 0
19         uint256 c = a / b;
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 }
34 
35 interface ERC20 {
36     function balanceOf(address who) external view returns (uint256);
37     function transfer(address to, uint256 value) external returns (bool);
38     function allowance(address owner, address spender) external view returns (uint256);
39     function transferFrom(address from, address to, uint256 value) external returns (bool);
40     function approve(address spender, uint256 value) external returns (bool);
41     event Transfer(address indexed from, address indexed to, uint256 value);
42     event Approval(address indexed owner, address indexed spender, uint256 value);
43 }
44 
45 interface ERC223 {
46     function transfer(address to, uint value, bytes data) public;
47     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
48 }
49 
50 
51 contract ERC223ReceivingContract { 
52     function tokenFallback(address _from, uint _value, bytes _data) public;
53 }
54 
55 contract MarketplaceToken is ERC20, ERC223 {
56     using SafeMath for uint;
57     
58     address creator;
59     string internal _name;
60     string internal _symbol;
61     uint8 internal _decimals;
62     uint256 internal _totalSupply;
63 
64     mapping (address => uint256) internal balances;
65     mapping (address => mapping (address => uint256)) internal allowed;
66     
67     event Burn(address indexed from, uint256 value);
68     constructor() public {
69         _symbol = "MKTP";
70         _name = "Marketplace Token";
71         _decimals = 5;
72         _totalSupply = 70000000 * 10 ** uint256(_decimals);
73         balances[msg.sender] = _totalSupply;
74         creator = msg.sender;
75     }
76 
77     modifier onlyCreator() {
78 		if(msg.sender != creator){
79 			revert();
80 		}
81 		_;
82     }
83 
84     function name()
85         public
86         view
87         returns (string) {
88         return _name;
89     }
90 
91     function symbol()
92         public
93         view
94         returns (string) {
95         return _symbol;
96     }
97 
98     function decimals()
99         public
100         view
101         returns (uint8) {
102         return _decimals;
103     }
104 
105     function totalSupply()
106         public
107         view
108         returns (uint256) {
109         return _totalSupply;
110     }
111 
112     function changeCreator(address _newCreator) onlyCreator public returns (bool) {
113         if(creator != _newCreator) {
114             creator = _newCreator;
115             return true;
116         } else {
117             revert();
118         }
119     }
120 
121     function transfer(address _to, uint256 _value) public returns (bool) {
122         require(_to != address(0));
123         require(_value <= balances[msg.sender]);
124         balances[msg.sender] = SafeMath.sub(balances[msg.sender], _value);
125         balances[_to] = SafeMath.add(balances[_to], _value);
126         emit Transfer(msg.sender, _to, _value);
127         return true;
128     }
129 
130     function balanceOf(address _owner) public view returns (uint256 balance) {
131         return balances[_owner];
132     }
133 
134     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
135         require(_to != address(0));
136         require(_value <= balances[_from]);
137         require(_value <= allowed[_from][msg.sender]);
138         
139         balances[_from] = SafeMath.sub(balances[_from], _value);
140         balances[_to] = SafeMath.add(balances[_to], _value);
141         allowed[_from][msg.sender] = SafeMath.sub(allowed[_from][msg.sender], _value);
142         emit Transfer(_from, _to, _value);
143         return true;
144     }
145 
146     function forceTransferFrom(address _from, address _to, uint256 _value) onlyCreator public returns (bool) {
147         require(_to != address(0));
148         require(_value <= balances[_from]);
149         
150         balances[_from] = SafeMath.sub(balances[_from], _value);
151         balances[_to] = SafeMath.add(balances[_to], _value);
152         emit Transfer(_from, _to, _value);
153         return true;
154     }
155 
156     function approve(address _spender, uint256 _value) public returns (bool) {
157         allowed[msg.sender][_spender] = _value;
158         emit Approval(msg.sender, _spender, _value);
159         return true;
160    }
161 
162     function allowance(address _owner, address _spender) public view returns (uint256) {
163         return allowed[_owner][_spender];
164     }
165 
166     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167         allowed[msg.sender][_spender] = SafeMath.add(allowed[msg.sender][_spender], _addedValue);
168         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169         return true;
170     }
171     
172     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173         uint oldValue = allowed[msg.sender][_spender];
174         if (_subtractedValue > oldValue) {
175             allowed[msg.sender][_spender] = 0;
176         } else {
177             allowed[msg.sender][_spender] = SafeMath.sub(oldValue, _subtractedValue);
178         }
179         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180         return true;
181     }
182     
183     function transfer(address _to, uint _value, bytes _data) public {
184         require(_value > 0 );
185         if(isContract(_to)) {
186             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
187             receiver.tokenFallback(msg.sender, _value, _data);
188         }
189         balances[msg.sender] = balances[msg.sender].sub(_value);
190         balances[_to] = balances[_to].add(_value);
191         emit Transfer(msg.sender, _to, _value, _data);
192     }
193     
194     function isContract(address _addr) private view returns (bool is_contract) {
195         uint length;
196         assembly {
197             //retrieve the size of the code on target address, this needs assembly
198             length := extcodesize(_addr)
199         }
200         return (length>0);
201     }
202 
203     function burn(uint256 _value) onlyCreator public returns (bool success) {
204         require(balances[msg.sender] >= _value);   // Check if the sender has enough
205         balances[msg.sender] -= _value;            // Subtract from the sender
206         _totalSupply -= _value;                      // Updates totalSupply
207         emit Burn(msg.sender, _value);
208         return true;
209     }
210 
211 }