1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal constant returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16 
17   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 
29 contract ERC223 {
30   uint public totalSupply;
31   function balanceOf(address who) constant returns (uint);
32 
33   function name() constant returns (string _name);
34   function symbol() constant returns (string _symbol);
35   function decimals() constant returns (uint8 _decimals);
36   function totalSupply() constant returns (uint256 _supply);
37 
38   function transfer(address to, uint value) returns (bool ok);
39   function transfer(address to, uint value, bytes data) returns (bool ok);
40   event Transfer(address indexed _from, address indexed _to, uint256 _value);
41   event ERC223Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
42 }
43 
44 contract ContractReceiver {
45   function tokenFallback(address _from, uint _value, bytes _data);
46 }
47 
48 contract ERC223Token is ERC223 {
49   using SafeMath for uint;
50 
51   mapping(address => uint) balances;
52 
53   string public name;
54   string public symbol;
55   uint8 public decimals;
56   uint256 public totalSupply;
57 
58 
59   // Function to access name of token .
60   function name() constant returns (string _name) {
61       return name;
62   }
63   // Function to access symbol of token .
64   function symbol() constant returns (string _symbol) {
65       return symbol;
66   }
67   // Function to access decimals of token .
68   function decimals() constant returns (uint8 _decimals) {
69       return decimals;
70   }
71   // Function to access total supply of tokens .
72   function totalSupply() constant returns (uint256 _totalSupply) {
73       return totalSupply;
74   }
75 
76   // Function that is called when a user or another contract wants to transfer funds .
77   function transfer(address _to, uint _value, bytes _data) returns (bool success) {
78     if(isContract(_to)) {
79         return transferToContract(_to, _value, _data);
80     }
81     else {
82         return transferToAddress(_to, _value, _data);
83     }
84 }
85 
86   // Standard function transfer similar to ERC20 transfer with no _data .
87   // Added due to backwards compatibility reasons .
88   function transfer(address _to, uint _value) returns (bool success) {
89 
90     //standard function transfer similar to ERC20 transfer with no _data
91     //added due to backwards compatibility reasons
92     bytes memory empty;
93     if(isContract(_to)) {
94         return transferToContract(_to, _value, empty);
95     }
96     else {
97         return transferToAddress(_to, _value, empty);
98     }
99 }
100 
101 //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
102   function isContract(address _addr) private returns (bool is_contract) {
103       uint length;
104       assembly {
105             //retrieve the size of the code on target address, this needs assembly
106             length := extcodesize(_addr)
107         }
108         if(length>0) {
109             return true;
110         }
111         else {
112             return false;
113         }
114     }
115 
116   //function that is called when transaction target is an address
117   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
118     if (balanceOf(msg.sender) < _value) revert();
119     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
120     balances[_to] = balanceOf(_to).add(_value);
121     Transfer(msg.sender, _to, _value);
122     ERC223Transfer(msg.sender, _to, _value, _data);
123     return true;
124   }
125 
126   //function that is called when transaction target is a contract
127   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
128     if (balanceOf(msg.sender) < _value) revert();
129     balances[msg.sender] = balanceOf(msg.sender).sub(_value);
130     balances[_to] = balanceOf(_to).add(_value);
131     ContractReceiver reciever = ContractReceiver(_to);
132     reciever.tokenFallback(msg.sender, _value, _data);
133     Transfer(msg.sender, _to, _value);
134     ERC223Transfer(msg.sender, _to, _value, _data);
135     return true;
136   }
137 
138 
139   function balanceOf(address _owner) constant returns (uint balance) {
140     return balances[_owner];
141   }
142 }
143 
144 
145 contract INZEI is ERC223Token {
146   string public name = "INZEI";
147   string public symbol = "INZ";
148   uint public decimals = 18;
149   uint public INITIAL_SUPPLY = 10000000000 * (10**uint256(decimals));
150 
151   function INZEI() {
152     totalSupply = INITIAL_SUPPLY;
153     balances[msg.sender] = INITIAL_SUPPLY;
154   }
155 }