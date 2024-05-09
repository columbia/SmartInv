1 pragma solidity ^0.4.24;
2  
3 contract SafeMath {
4     uint256 constant public MAX_UINT256 =
5     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
6 
7     function safeAdd(uint256 x, uint256 y) constant internal returns (uint256 z) {
8         if (x > MAX_UINT256 - y) revert();
9         return x + y;
10     }
11 
12     function safeSub(uint256 x, uint256 y) constant internal returns (uint256 z) {
13         if (x < y) revert();
14         return x - y;
15     }
16 
17     function safeMul(uint256 x, uint256 y) constant internal returns (uint256 z) {
18         if (y == 0) return 0;
19         if (x > MAX_UINT256 / y) revert();
20         return x * y;
21     }
22 }
23 
24 // ----------------------------------------------------------------------------
25 // Owned contract
26 // ----------------------------------------------------------------------------
27 contract Owned {
28     address public owner;
29     address public newOwner;
30 
31     event OwnershipTransferred(address indexed _from, address indexed _to);
32 
33     constructor() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner {
38         require(msg.sender == owner);
39         _;
40     }
41 
42     function transferOwnership(address _newOwner) public onlyOwner {
43         newOwner = _newOwner;
44     }
45     
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         emit OwnershipTransferred(owner, newOwner);
49         owner = newOwner;
50         newOwner = address(0);
51     }
52 }
53 
54 contract ContractReceiver {
55     function tokenFallback(address _from, uint _value, bytes _data);
56 }
57  
58 contract MelonBitIndex_Erc223Token is SafeMath, Owned {    
59     //event Transfer(address indexed from, address indexed to, uint tokens);
60     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
61 
62     mapping(address => uint) balances;
63     
64     string public name    = "MelonBit Market Index Erc223Token";
65     string public symbol  = "MMX";
66     uint8 public decimals = 8;
67     uint256 public totalSupply;
68     
69     //function MelonBitIndex_Erc223Token()
70     constructor() public
71     {
72         totalSupply = 10000000000 * 10**uint(decimals);
73         balances[owner] = totalSupply;      
74         //emit Transfer(address(0), owner, totalSupply);  
75     }
76         
77     // Function to access name of token .
78     function name() constant returns (string _name) { return name; }
79     // Function to access symbol of token .
80     function symbol() constant returns (string _symbol) { return symbol; }
81     // Function to access decimals of token .
82     function decimals() constant returns (uint8 _decimals) { return decimals; }
83     // Function to access total supply of tokens .
84     function totalSupply() constant returns (uint256 _totalSupply) { return totalSupply; }
85         
86     // Function that is called when a user or another contract wants to transfer funds .
87     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) returns (bool success) {       
88         if(isContract(_to)) {
89             if (balanceOf(msg.sender) < _value) revert();
90             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
91             balances[_to] = safeAdd(balanceOf(_to), _value);
92             assert(_to.call.value(0)(bytes4(sha3(_custom_fallback)), msg.sender, _value, _data));
93             Transfer(msg.sender, _to, _value, _data);
94             return true;
95         }
96         else {
97             return transferToAddress(_to, _value, _data);
98         }
99     }
100   
101     // Function that is called when a user or another contract wants to transfer funds .
102     function transfer(address _to, uint _value, bytes _data) returns (bool success) {       
103         if(isContract(_to)) {
104             return transferToContract(_to, _value, _data);
105         }
106         else {
107             return transferToAddress(_to, _value, _data);
108         }
109     }
110   
111     // Standard function transfer similar to ERC20 transfer with no _data .
112     // Added due to backwards compatibility reasons .
113     function transfer(address _to, uint _value) returns (bool success) {        
114         //standard function transfer similar to ERC20 transfer with no _data
115         //added due to backwards compatibility reasons
116         bytes memory empty;
117         if(isContract(_to)) {
118             return transferToContract(_to, _value, empty);
119         }
120         else {
121             return transferToAddress(_to, _value, empty);
122         }
123     }
124 
125     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
126     function isContract(address _addr) private returns (bool is_contract) {
127         uint length;
128         assembly {
129                 //retrieve the size of the code on target address, this needs assembly
130                 length := extcodesize(_addr)
131         }
132         return (length>0);
133     }
134 
135     //function that is called when transaction target is an address
136     function transferToAddress(address _to, uint _value, bytes _data) private returns (bool success) {
137         if (balanceOf(msg.sender) < _value) revert();
138         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
139         balances[_to] = safeAdd(balanceOf(_to), _value);
140         Transfer(msg.sender, _to, _value, _data);
141         return true;
142     }
143     
144     //function that is called when transaction target is a contract
145     function transferToContract(address _to, uint _value, bytes _data) private returns (bool success) {
146         if (balanceOf(msg.sender) < _value) revert();
147         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
148         balances[_to] = safeAdd(balanceOf(_to), _value);
149         ContractReceiver receiver = ContractReceiver(_to);
150         receiver.tokenFallback(msg.sender, _value, _data);
151         Transfer(msg.sender, _to, _value, _data);
152         return true;
153     }
154 
155     function balanceOf(address _owner) constant returns (uint balance) {
156         return balances[_owner];
157     }
158 }