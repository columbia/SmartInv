1 pragma solidity ^0.4.11;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     require(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     require(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     require(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     require(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     require(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC223 {
30   uint public totalSupply;
31   function balanceOf(address who) public constant returns (uint);
32 
33   function name() public constant returns (string _name);
34   function symbol() public constant returns (string _symbol);
35   function decimals() public constant returns (uint8 _decimals);
36   function totalSupply() public constant returns (uint256 _supply);
37 
38   function approve(address _spender, uint _value) external returns (bool);
39   function allowance(address _owner, address _spender) external constant returns (uint); 
40   function transfer(address to, uint value) public returns (bool ok);
41   function transfer(address to, uint value, bytes data) public returns (bool ok);
42   function transferFrom(address _from, address _to, uint _value) external returns (bool);
43   
44   event Approval(address indexed _owner, address indexed _spender, uint _value);
45   event Transfer(address indexed _from, address indexed _to, uint256 _value);
46   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
47 }
48 
49 contract ContractReceiver {
50   function tokenFallback(address _from, uint _value, bytes _data) public;
51 }
52 
53 contract Tacoin is ERC223 {
54   using SafeMath for uint;
55 
56   mapping(address => uint) balances;
57   mapping (address => mapping (address => uint)) internal _allowances;
58 
59   string public name = "Tacoin";
60   string public symbol = "TACO";
61   uint8 public decimals = 18;
62   uint256 public totalSupply = 10000000000000000000000000;
63 
64 function Tacoin (
65         uint256 initialSupply, 
66         string tokenName,
67         string tokenSymbol
68     ) public {
69         totalSupply = initialSupply * 10000000000000000000000000  ** uint256(18);  
70         balances[msg.sender] = totalSupply = 10000000000000000000000000;                
71         name = tokenName = "Tacoin";                                   
72         symbol = tokenSymbol = "TACO";                               
73     }
74 
75   // Function to access name of token .
76   function name() public constant returns (string _name) {
77       return name;
78   }
79   // Function to access symbol of token .
80   function symbol() public constant returns (string _symbol) {
81       return symbol;
82   }
83   // Function to access decimals of token .
84   function decimals() public constant returns (uint8 _decimals) {
85       return decimals;
86   }
87   // Function to access total supply of tokens .
88   function totalSupply() public constant returns (uint256 _totalSupply) {
89       return totalSupply;
90   }
91   
92   function approve(address _spender, uint _value) external returns (bool) {
93         _allowances[msg.sender][_spender] = _allowances[msg.sender][_spender].add(_value);
94         Approval(msg.sender, _spender, _value);
95         return true;
96   
97   }
98   function allowance(address _owner, address _spender) external constant returns (uint) {
99         return _allowances[_owner][_spender];
100     }
101 
102   // Function that is called when a user or another contract wants to transfer funds .
103   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
104     if(isContract(_to)) {
105         return transferToContract(_to, _value, _data);
106     }
107     else {
108         return transferToAddress(_to, _value, _data);
109     }
110 }
111 
112   // Standard function transfer similar to ERC20 transfer with no _data .
113   // Added due to backwards compatibility reasons .
114   function transfer(address _to, uint _value) public returns (bool success) {
115     bytes memory empty;
116     if(isContract(_to)) {
117         return transferToContract(_to, _value, empty);
118     }
119     else {
120         return transferToAddress(_to, _value, empty);
121     }
122 }
123 
124 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
125   function isContract(address _addr) private constant returns (bool is_contract) {
126       uint length;
127       assembly {
128             //retrieve the size of the code on target address, this needs assembly
129             length := extcodesize(_addr)
130         }
131         if(length>0) {
132             return true;
133         }
134         else {
135             return false;
136         }
137     }
138 
139   //function that is called when transaction target is an address
140   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
141     if (balanceOf(msg.sender) < _value) revert();
142     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
143     balances[_to] = balanceOf(_to).add(_value);
144     Transfer(msg.sender, _to, _value);
145     ERC223Transfer(msg.sender, _to, _value, _data);
146     return true;
147   }
148 
149   //function that is called when transaction target is a contract
150   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
151     if (balanceOf(msg.sender) < _value) revert();
152     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
153     balances[_to] = balanceOf(_to).add(_value);
154     ContractReceiver reciever = ContractReceiver(_to);
155     reciever.tokenFallback(msg.sender, _value, _data);
156     Transfer(msg.sender, _to, _value);
157     ERC223Transfer(msg.sender, _to, _value, _data);
158     return true;
159   }
160 
161   function balanceOf(address _owner) public constant returns (uint balance) {
162     return balances[_owner];
163   }
164   
165   function transferFrom(address _from, address _to, uint _value) external returns (bool) {
166         if (_allowances[_from][msg.sender] > 0 &&
167             _value > 0 &&
168             _allowances[_from][msg.sender] >= _value &&
169             balances[_from] >= _value) {
170             balances[_from] = balances[_from].sub(_value);
171             _allowances[_from][msg.sender] = _allowances[_from][msg.sender].sub(_value);
172             balances[_to] = balances[_to].add(_value);
173             Transfer(_from, _to, _value);
174             return true;
175         }
176         return false;
177     }
178   
179 }