1 pragma solidity ^0.4.11;
2  
3 contract ERC223 {
4     uint public totalSupply;
5     function balanceOf(address who) public view returns (uint);
6   
7     function name() public view returns (string _name);
8     function symbol() public view returns (string _symbol);
9     function decimals() public view returns (uint8 _decimals);
10     function totalSupply() public view returns (uint256 _supply);
11  
12     function transfer(address to, uint value) public returns (bool ok);
13     function transfer(address to, uint value, bytes data) public returns (bool ok);
14     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
15   
16     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
17 }
18  
19  
20 contract ContractReceiver {                
21     function tokenFallback(address _from, uint _value, bytes _data) public;
22 }
23  
24  /**
25  * ERC223 token by Dexaran
26  *
27  * https://github.com/Dexaran/ERC223-token-standard
28  */
29  
30  
31 contract SafeMath {
32     uint256 constant public MAX_UINT256 =
33     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
34  
35     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
36         if (x > MAX_UINT256 - y) revert();
37         return x + y;
38     }
39  
40     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
41         if (x < y) revert();
42         return x - y;
43     }
44  
45     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
46         if (y == 0) return 0;
47         if (x > MAX_UINT256 / y) revert();
48         return x * y;
49     }
50 }
51  
52 contract TstToken is ERC223, SafeMath {
53  
54     mapping(address => uint) balances;
55     
56     string public name = "Test";
57     string public symbol = "TST";
58     uint8 public decimals = 8;
59     uint256 public totalSupply = 3000000000000000;
60  
61     // ERC20 compatible event
62     event Transfer(address indexed from, address indexed to, uint value);
63     
64     constructor () public {
65         balances[tx.origin] = totalSupply;
66     }
67  
68     // Function to access name of token .
69     function name() public view returns (string _name) {
70         return name;
71     }
72     // Function to access symbol of token .
73     function symbol() public view returns (string _symbol) {
74         return symbol;
75     }
76     // Function to access decimals of token .
77     function decimals() public view returns (uint8 _decimals) {
78         return decimals;
79     }
80     // Function to access total supply of tokens .
81     function totalSupply() public view returns (uint256 _totalSupply) {
82         return totalSupply;
83     }
84  
85     
86     // Function that is called when a user or another contract wants to transfer funds .
87     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {        
88         if(isContract(_to)) {
89             if (balanceOf(msg.sender) < _value) revert();
90             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
91             balances[_to] = safeAdd(balanceOf(_to), _value);
92             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
93             emit Transfer(msg.sender, _to, _value, _data);
94             return true;
95         }
96         else {
97             return transferToAddress(_to, _value, false, _data);
98         }
99     }  
100     
101   
102     // Function that is called when a user or another contract wants to transfer funds .
103     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {        
104         if(isContract(_to)) {
105             return transferToContract(_to, _value, false, _data);
106         }
107         else {
108             return transferToAddress(_to, _value, false, _data);
109         }
110     }  
111     
112     // Standard function transfer similar to ERC20 transfer with no _data .
113     // Added due to backwards compatibility reasons .
114     function transfer(address _to, uint _value) public returns (bool success) {
115         
116       //standard function transfer similar to ERC20 transfer with no _data
117       //added due to backwards compatibility reasons
118         bytes memory empty;
119         if(isContract(_to)) {
120             return transferToContract(_to, _value, true, empty);
121         }
122         else {
123             return transferToAddress(_to, _value, true, empty);
124         }
125     }  
126   
127     
128   
129     //function that is called when transaction target is an address
130     function transferToAddress(address _to, uint _value, bool isErc20Transfer, bytes _data) private returns (bool success) {
131         if (balanceOf(msg.sender) < _value) revert();
132         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
133         balances[_to] = safeAdd(balanceOf(_to), _value);
134         if (isErc20Transfer)
135             emit Transfer(msg.sender, _to, _value);
136         else
137             emit Transfer(msg.sender, _to, _value, _data);
138         return true;
139     }
140     
141     //function that is called when transaction target is a contract
142     function transferToContract(address _to, uint _value, bool isErc20Transfer, bytes _data) private returns (bool success) {
143         if (balanceOf(msg.sender) < _value) revert();
144         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
145         balances[_to] = safeAdd(balanceOf(_to), _value);
146         ContractReceiver receiver = ContractReceiver(_to);
147         receiver.tokenFallback(msg.sender, _value, _data);
148         if (isErc20Transfer)
149             emit Transfer(msg.sender, _to, _value);
150         else
151             emit Transfer(msg.sender, _to, _value, _data);
152         return true;
153     }  
154   
155     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
156     function isContract(address _addr) private view returns (bool is_contract) {
157         uint length;
158         assembly {
159               //retrieve the size of the code on target address, this needs assembly
160               length := extcodesize(_addr)
161         }
162         return (length>0);
163     }
164   
165     function balanceOf(address _owner) public view returns (uint balance) {
166       return balances[_owner];
167     }
168 }