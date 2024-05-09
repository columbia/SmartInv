1 pragma solidity ^0.4.13;
2 
3 contract IERC223 {
4   uint public totalSupply;
5   function balanceOf(address who) public view returns (uint);
6   
7   function name() public view returns (string _name);
8   function symbol() public view returns (string _symbol);
9   function decimals() public view returns (uint8 _decimals);
10   function totalSupply() public view returns (uint256 _supply);
11 
12   function transfer(address to, uint value) public returns (bool ok);
13   function transfer(address to, uint value, bytes data) public returns (bool ok);
14   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
15   
16   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
17 }
18 
19 
20  /* https://github.com/LykkeCity/EthereumApiDotNetCore/blob/master/src/ContractBuilder/contracts/token/SafeMath.sol */
21 contract SafeMath {
22     uint256 constant public MAX_UINT256 =
23     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
24 
25     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
26         if (x > MAX_UINT256 - y) revert();
27         return x + y;
28     }
29 
30     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
31         if (x < y) revert();
32         return x - y;
33     }
34 
35     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
36         if (y == 0) return 0;
37         if (x > MAX_UINT256 / y) revert();
38         return x * y;
39     }
40 }
41 
42  /**
43  * @title Contract that will work with ERC223 tokens.
44  */
45  
46 contract ContractReceiver { 
47 /**
48  * @dev Standard ERC223 function that will handle incoming token transfers.
49  *
50  * @param _from  Token sender address.
51  * @param _value Amount of tokens.
52  * @param _data  Transaction metadata.
53  */
54     function tokenFallback(address _from, uint _value, bytes _data);
55 }
56 
57 contract ERC223Token is IERC223, SafeMath {
58 
59   mapping(address => uint) balances;
60   
61   string public name = "Tradetex";
62   string public symbol = "TDX";
63   uint8 public decimals = 8;
64   uint256 public totalSupply = 35000000 * 10**8;
65   
66   function ERC223Token() {
67       balances[msg.sender] = totalSupply;
68   }
69   
70   // Function to access name of token .
71   function name() public view returns (string _name) {
72       return name;
73   }
74   // Function to access symbol of token .
75   function symbol() public view returns (string _symbol) {
76       return symbol;
77   }
78   // Function to access decimals of token .
79   function decimals() public view returns (uint8 _decimals) {
80       return decimals;
81   }
82   // Function to access total supply of tokens .
83   function totalSupply() public view returns (uint256 _totalSupply) {
84       return totalSupply;
85   }
86   
87   
88   // Function that is called when a user or another contract wants to transfer funds .
89   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
90       
91     if(isContract(_to)) {
92         if (balanceOf(msg.sender) < _value) revert();
93         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
94         balances[_to] = safeAdd(balanceOf(_to), _value);
95         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
96         Transfer(msg.sender, _to, _value, _data);
97         return true;
98     }
99     else {
100         return transferToAddress(_to, _value, _data);
101     }
102 }
103   
104 
105   // Function that is called when a user or another contract wants to transfer funds .
106   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
107       
108     if(isContract(_to)) {
109         return transferToContract(_to, _value, _data);
110     }
111     else {
112         return transferToAddress(_to, _value, _data);
113     }
114 }
115   
116   // Standard function transfer similar to ERC20 transfer with no _data .
117   // Added due to backwards compatibility reasons .
118   function transfer(address _to, uint _value) public returns (bool success) {
119       
120     //standard function transfer similar to ERC20 transfer with no _data
121     //added due to backwards compatibility reasons
122     bytes memory empty;
123     if(isContract(_to)) {
124         return transferToContract(_to, _value, empty);
125     }
126     else {
127         return transferToAddress(_to, _value, empty);
128     }
129 }
130 
131   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
132   function isContract(address _addr) private view returns (bool is_contract) {
133       uint length;
134       assembly {
135             //retrieve the size of the code on target address, this needs assembly
136             length := extcodesize(_addr)
137       }
138       return (length>0);
139     }
140 
141   //function that is called when transaction target is an address
142   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
143     if (balanceOf(msg.sender) < _value) revert();
144     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
145     balances[_to] = safeAdd(balanceOf(_to), _value);
146     Transfer(msg.sender, _to, _value, _data);
147     return true;
148   }
149   
150   //function that is called when transaction target is a contract
151   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
152     if (balanceOf(msg.sender) < _value) revert();
153     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
154     balances[_to] = safeAdd(balanceOf(_to), _value);
155     ContractReceiver receiver = ContractReceiver(_to);
156     receiver.tokenFallback(msg.sender, _value, _data);
157     Transfer(msg.sender, _to, _value, _data);
158     return true;
159 }
160 
161 
162   function balanceOf(address _owner) public view returns (uint balance) {
163     return balances[_owner];
164   }
165 }