1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 contract SafeMath {
8     uint256 constant public MAX_UINT256 =
9     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
10 
11     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
12         if (x > MAX_UINT256 - y) revert();
13         return x + y;
14     }
15 
16     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
17         if (x < y) revert();
18         return x - y;
19     }
20 
21     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
22         if (y == 0) return 0;
23         if (x > MAX_UINT256 / y) revert();
24         return x * y;
25     }
26 }
27 
28 /**
29  * @title Ownable
30  * @dev The Ownable contract has an owner address, and provides basic authorization
31  *      control functions, this simplifies the implementation of "user permissions".
32  */
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     /**
39      * @dev The Ownable constructor sets the original `owner` of the contract to the
40      *      sender account.
41      */
42     function Ownable() public {
43         owner = msg.sender;
44     }
45 
46     /**
47      * @dev Throws if called by any account other than the owner.
48      */
49     modifier onlyOwner() {
50         require(msg.sender == owner);
51         _;
52     }
53 
54     /**
55      * @dev Allows the current owner to transfer control of the contract to a newOwner.
56      * @param newOwner The address to transfer ownership to.
57      */
58     function transferOwnership(address newOwner) onlyOwner public {
59         require(newOwner != address(0));
60         OwnershipTransferred(owner, newOwner);
61         owner = newOwner;
62     }
63 }
64 
65 contract ERC223 {
66   uint public totalSupply;
67   function balanceOf(address who) public view returns (uint);
68   
69   function name() public view returns (string _name);
70   function symbol() public view returns (string _symbol);
71   function decimals() public view returns (uint8 _decimals);
72   function totalSupply() public view returns (uint256 _supply);
73 
74   function transfer(address to, uint value) public returns (bool ok);
75   function transfer(address to, uint value, bytes data) public returns (bool ok);
76   function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
77   
78   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
79 }
80 
81 /*
82  * Contract that is working with ERC223 tokens
83  */
84 contract ContractReceiver {
85      
86     struct TKN {
87         address sender;
88         uint value;
89         bytes data;
90         bytes4 sig;
91     }
92     
93     
94     function tokenFallback(address _from, uint _value, bytes _data) public pure {
95       TKN memory tkn;
96       tkn.sender = _from;
97       tkn.value = _value;
98       tkn.data = _data;
99       uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
100       tkn.sig = bytes4(u);
101       
102       /* tkn variable is analogue of msg variable of Ether transaction
103       *  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
104       *  tkn.value the number of tokens that were sent   (analogue of msg.value)
105       *  tkn.data is data of token transaction   (analogue of msg.data)
106       *  tkn.sig is 4 bytes signature of function
107       *  if data of token transaction is a function execution
108       */
109     }
110 }
111 
112 contract ERC223Token is ERC223, SafeMath {
113 
114   mapping(address => uint) balances;
115   
116   string public name = "NIJIGEN";
117   string public symbol = "NIJ";
118   uint8 public decimals = 8;
119   uint256 public totalSupply = 24e9 * 1e8;
120   
121   
122   // Function to access name of token .
123   function name() public view returns (string _name) {
124       return name;
125   }
126   // Function to access symbol of token .
127   function symbol() public view returns (string _symbol) {
128       return symbol;
129   }
130   // Function to access decimals of token .
131   function decimals() public view returns (uint8 _decimals) {
132       return decimals;
133   }
134   // Function to access total supply of tokens .
135   function totalSupply() public view returns (uint256 _totalSupply) {
136       return totalSupply;
137   }
138   
139   
140   // Function that is called when a user or another contract wants to transfer funds .
141   function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {
142       
143     if(isContract(_to)) {
144         if (balanceOf(msg.sender) < _value) revert();
145         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
146         balances[_to] = safeAdd(balanceOf(_to), _value);
147         assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
148         Transfer(msg.sender, _to, _value, _data);
149         return true;
150     }
151     else {
152         return transferToAddress(_to, _value, _data);
153     }
154 }
155   
156 
157   // Function that is called when a user or another contract wants to transfer funds .
158   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
159       
160     if(isContract(_to)) {
161         return transferToContract(_to, _value, _data);
162     }
163     else {
164         return transferToAddress(_to, _value, _data);
165     }
166 }
167   
168   // Standard function transfer similar to ERC20 transfer with no _data .
169   // Added due to backwards compatibility reasons .
170   function transfer(address _to, uint _value) public returns (bool success) {
171       
172     //standard function transfer similar to ERC20 transfer with no _data
173     //added due to backwards compatibility reasons
174     bytes memory empty;
175     if(isContract(_to)) {
176         return transferToContract(_to, _value, empty);
177     }
178     else {
179         return transferToAddress(_to, _value, empty);
180     }
181 }
182 
183   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
184   function isContract(address _addr) private view returns (bool is_contract) {
185       uint length;
186       assembly {
187             //retrieve the size of the code on target address, this needs assembly
188             length := extcodesize(_addr)
189       }
190       return (length>0);
191     }
192 
193   //function that is called when transaction target is an address
194   function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
195     if (balanceOf(msg.sender) < _value) revert();
196     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
197     balances[_to] = safeAdd(balanceOf(_to), _value);
198     Transfer(msg.sender, _to, _value, _data);
199     return true;
200   }
201   
202   //function that is called when transaction target is a contract
203   function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
204     if (balanceOf(msg.sender) < _value) revert();
205     balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
206     balances[_to] = safeAdd(balanceOf(_to), _value);
207     ContractReceiver receiver = ContractReceiver(_to);
208     receiver.tokenFallback(msg.sender, _value, _data);
209     Transfer(msg.sender, _to, _value, _data);
210     return true;
211 }
212 
213 
214   function balanceOf(address _owner) public view returns (uint balance) {
215     return balances[_owner];
216   }
217 }