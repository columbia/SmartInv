1 pragma solidity ^0.4.24;
2 
3 /*
4  * Contract that is working with ERC223 tokens
5  */
6 contract ContractReceiver {
7   function tokenFallback(address _from, uint256 _value, bytes _data) public;
8 }
9 
10 /* New ERC223 contract interface */
11 contract ERC223 {
12   uint public totalSupply;
13   function balanceOf(address who) public view returns (uint);
14 
15   function name() public view returns (string _name);
16   function symbol() public view returns (string _symbol);
17   function decimals() public view returns (uint8 _decimals);
18   function totalSupply() public view returns (uint256 _supply);
19 
20   function transfer(address to, uint value) public returns (bool ok);
21   function transfer(address to, uint value, bytes data) public returns (bool ok);
22   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
23 
24   // solhint-disable-next-line
25   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
26 }
27 
28  /**
29  * ERC223 token by Dexaran
30  *
31  * https://github.com/Dexaran/ERC223-token-standard
32  */
33 
34  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
35 contract SafeMathERC223 {
36   uint256 constant public MAX_UINT256 =
37   0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
38 
39   function safeAdd(uint256 x, uint256 y) internal pure returns (uint256 z) {
40     if (x > MAX_UINT256 - y) revert();
41     return x + y;
42   }
43 
44   function safeSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
45     if (x < y) revert();
46     return x - y;
47   }
48 
49   function safeMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
50     if (y == 0) return 0;
51     if (x > MAX_UINT256 / y) revert();
52     return x * y;
53   }
54 }
55 
56 
57 contract ERC223Token is ERC223, SafeMathERC223 {
58   mapping(address => uint) public balances;
59 
60   string public name;
61   string public symbol;
62   uint8 public decimals;
63   uint256 public totalSupply;
64 
65   // Constractor
66   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) public {
67         symbol = _symbol;
68         name = _name;
69         decimals = _decimals;
70         totalSupply = _totalSupply;
71         balances[msg.sender] = _totalSupply;
72   }
73 
74   // Function to access name of token .
75   function name() public view returns (string _name) {
76     return name;
77   }
78 
79   // Function to access symbol of token .
80   function symbol() public view returns (string _symbol) {
81     return symbol;
82   }
83 
84   // Function to access decimals of token .
85   function decimals() public view returns (uint8 _decimals) {
86     return decimals;
87   }
88 
89   // Function to access total supply of tokens .
90   function totalSupply() public view returns (uint256 _totalSupply) {
91     return totalSupply;
92   }
93 
94   // Function that is called when a user or another contract wants to transfer funds .
95   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
96     if (isContract(_to)) {
97       return transferToContractCustom(msg.sender, _to, _value, _data, _custom_fallback);
98     } else {
99       return transferToAddress(msg.sender, _to, _value, _data);
100     }
101   }
102 
103   // Function that is called when a user or another contract wants to transfer funds .
104   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
105     if (isContract(_to)) {
106       return transferToContract(msg.sender, _to, _value, _data);
107     } else {
108       return transferToAddress(msg.sender, _to, _value, _data);
109     }
110   }
111 
112   // Standard function transfer similar to ERC20 transfer with no _data .
113   // Added due to backwards compatibility reasons .
114   function transfer(address _to, uint _value) public returns (bool success) {
115     //standard function transfer similar to ERC20 transfer with no _data
116     //added due to backwards compatibility reasons
117     bytes memory empty;
118     if (isContract(_to)) {
119       return transferToContract(msg.sender, _to, _value, empty);
120     } else {
121       return transferToAddress(msg.sender, _to, _value, empty);
122     }
123   }
124 
125   function balanceOf(address _owner) public view returns (uint balance) {
126     return balances[_owner];
127   }
128 
129   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
130   function isContract(address _addr) internal view returns (bool is_contract) {
131     uint length;
132     assembly { // solhint-disable-line
133           //retrieve the size of the code on target address, this needs assembly
134           length := extcodesize(_addr)
135     }
136     return (length > 0);
137   }
138 
139   //function that is called when transaction target is an address
140   function transferToAddress(address _from, address _to, uint _value, bytes _data) internal returns (bool success) {
141     if (balanceOf(_from) < _value) revert();
142     balances[_from] = safeSub(balanceOf(_from), _value);
143     balances[_to] = safeAdd(balanceOf(_to), _value);
144     emit Transfer(_from, _to, _value, _data);
145     return true;
146   }
147 
148   //function that is called when transaction target is a contract
149   function transferToContract(address _from, address _to, uint _value, bytes _data) internal returns (bool success) {
150     if (balanceOf(_from) < _value) revert();
151     balances[_from] = safeSub(balanceOf(_from), _value);
152     balances[_to] = safeAdd(balanceOf(_to), _value);
153     ContractReceiver receiver = ContractReceiver(_to);
154     receiver.tokenFallback(_from, _value, _data);
155     emit Transfer(_from, _to, _value, _data);
156     return true;
157   }
158 
159   //function that is called when transaction target is a contract
160   function transferToContractCustom(address _from, address _to, uint _value, bytes _data, string _custom_fallback) internal returns (bool success) {
161     if (balanceOf(_from) < _value) revert();
162     balances[_from] = safeSub(balanceOf(_from), _value);
163     balances[_to] = safeAdd(balanceOf(_to), _value);
164     // solhint-disable-next-line
165     assert(_to.call.value(0)(abi.encodeWithSignature(_custom_fallback, _from, _value, _data)));
166     emit Transfer(_from, _to, _value, _data);
167     return true;
168   }
169 }