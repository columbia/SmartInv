1 pragma solidity ^0.4.11;
2 
3  /* Receiver must implement this function to receive tokens
4  *  otherwise token transaction will fail
5  */
6  
7  contract ContractReceiver {
8     function tokenFallback(address _from, uint256 _value, bytes _data){
9       _from = _from;
10       _value = _value;
11       _data = _data;
12       // Incoming transaction code here
13     }
14 }
15  
16  /* New ERC23 contract interface */
17 
18 contract ERC23 {
19   uint256 public totalSupply;
20   function balanceOf(address who) constant returns (uint256);
21   function allowance(address owner, address spender) constant returns (uint256);
22 
23   function name() constant returns (string _name);
24   function symbol() constant returns (string _symbol);
25   function decimals() constant returns (uint8 _decimals);
26   function totalSupply() constant returns (uint256 _supply);
27 
28   function transfer(address to, uint256 value) returns (bool ok);
29   function transfer(address to, uint256 value, bytes data) returns (bool ok);
30   function transferFrom(address from, address to, uint256 value) returns (bool ok);
31   function approve(address spender, uint256 value) returns (bool ok);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33   event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 
38  /**
39  * ERC23 token by Dexaran
40  *
41  * https://github.com/Dexaran/ERC23-tokens
42  */
43  
44 contract ERC23Token is ERC23 {
45 
46   mapping(address => uint256) balances;
47   mapping (address => mapping (address => uint256)) allowed;
48 
49   string public name;
50   string public symbol;
51   uint8 public decimals;
52   uint256 public totalSupply;
53 
54   // Function to access name of token .
55   function name() constant returns (string _name) {
56       return name;
57   }
58   // Function to access symbol of token .
59   function symbol() constant returns (string _symbol) {
60       return symbol;
61   }
62   // Function to access decimals of token .
63   function decimals() constant returns (uint8 _decimals) {
64       return decimals;
65   }
66   // Function to access total supply of tokens .
67   function totalSupply() constant returns (uint256 _totalSupply) {
68       return totalSupply;
69   }
70 
71   //function that is called when a user or another contract wants to transfer funds
72   function transfer(address _to, uint256 _value, bytes _data) returns (bool success) {
73   
74     //filtering if the target is a contract with bytecode inside it
75     if(isContract(_to)) {
76         transferToContract(_to, _value, _data);
77     }
78     else {
79         transferToAddress(_to, _value, _data);
80     }
81     return true;
82   }
83   
84   function transfer(address _to, uint256 _value) returns (bool success) {
85       
86     //standard function transfer similar to ERC20 transfer with no _data
87     //added due to backwards compatibility reasons
88     bytes memory empty;
89     if(isContract(_to)) {
90         transferToContract(_to, _value, empty);
91     }
92     else {
93         transferToAddress(_to, _value, empty);
94     }
95     return true;
96   }
97 
98   //function that is called when transaction target is an address
99   function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
100     balances[msg.sender] -= _value;
101     balances[_to] += _value;
102     Transfer(msg.sender, _to, _value);
103     Transfer(msg.sender, _to, _value, _data);
104     return true;
105   }
106   
107   //function that is called when transaction target is a contract
108   function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
109     balances[msg.sender] -= _value;
110     balances[_to] += _value;
111     ContractReceiver reciever = ContractReceiver(_to);
112     reciever.tokenFallback(msg.sender, _value, _data);
113     Transfer(msg.sender, _to, _value);
114     Transfer(msg.sender, _to, _value, _data);
115     return true;
116   }
117   
118   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
119   function isContract(address _addr) private returns (bool is_contract) {
120       _addr = _addr;
121       uint256 length;
122       assembly {
123             //retrieve the size of the code on target address, this needs assembly
124             length := extcodesize(_addr)
125         }
126         if(length>0) {
127             return true;
128         }
129         else {
130             return false;
131         }
132     }
133 
134   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
135     var _allowance = allowed[_from][msg.sender];
136     
137     if(_value > _allowance) {
138         throw;
139     }
140 
141     balances[_to] += _value;
142     balances[_from] -= _value;
143     allowed[_from][msg.sender] -= _value;
144     Transfer(_from, _to, _value);
145     return true;
146   }
147 
148   function balanceOf(address _owner) constant returns (uint256 balance) {
149     return balances[_owner];
150   }
151 
152   function approve(address _spender, uint256 _value) returns (bool success) {
153     allowed[msg.sender][_spender] = _value;
154     Approval(msg.sender, _spender, _value);
155     return true;
156   }
157 
158   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
159     return allowed[_owner][_spender];
160   }
161 }
162 
163 contract ABCToken is ERC23Token {
164     // Constructor
165     function ABCToken(
166             string _name,
167             string _symbol,
168             uint8 _decimals,
169             uint256 _totalSupply,
170             address _initialTokensHolder) {
171         name = _name;
172         symbol = _symbol;
173         decimals = _decimals;
174         totalSupply = _totalSupply;
175         balances[_initialTokensHolder] = _totalSupply;
176     }
177 }