1 pragma solidity ^0.4.9;
2 
3 
4 contract ERC223 {
5     uint public totalSupply;
6     function balanceOf(address who) public view returns (uint);
7   
8     function name() public view returns (string _name);
9     function symbol() public view returns (string _symbol);
10     function decimals() public view returns (uint8 _decimals);
11     function totalSupply() public view returns (uint256 _supply);
12 
13     function transfer(address to, uint value) public returns (bool ok);
14     function transfer(address to, uint value, bytes data) public returns (bool ok);
15     function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);
16   
17     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
18 }
19 
20 
21 contract ContractReceiver {                
22     function tokenFallback(address _from, uint _value, bytes _data) public;
23 }
24 
25  /**
26  * ERC223 token by Dexaran
27  *
28  * https://github.com/Dexaran/ERC223-token-standard
29  */
30  
31  
32 contract SafeMath {
33     uint256 constant public MAX_UINT256 =
34     0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
35 
36     function safeAdd(uint256 x, uint256 y) pure internal returns (uint256 z) {
37         if (x > MAX_UINT256 - y) revert();
38         return x + y;
39     }
40 
41     function safeSub(uint256 x, uint256 y) pure internal returns (uint256 z) {
42         if (x < y) revert();
43         return x - y;
44     }
45 
46     function safeMul(uint256 x, uint256 y) pure internal returns (uint256 z) {
47         if (y == 0) return 0;
48         if (x > MAX_UINT256 / y) revert();
49         return x * y;
50     }
51 }
52  
53 contract GwbToken is ERC223, SafeMath {
54 
55     mapping(address => uint) balances;
56     
57     string public name = "GoWeb";
58     string public symbol = "GWB";
59     uint8 public decimals = 8;
60     uint256 public totalSupply = 7500000000000000;
61 
62     // ERC20 compatible event
63     event Transfer(address indexed from, address indexed to, uint value);
64     
65     constructor () public {
66 		balances[tx.origin] = totalSupply;
67 	}
68 
69     // Function to access name of token .
70     function name() public view returns (string _name) {
71         return name;
72     }
73     // Function to access symbol of token .
74     function symbol() public view returns (string _symbol) {
75         return symbol;
76     }
77     // Function to access decimals of token .
78     function decimals() public view returns (uint8 _decimals) {
79         return decimals;
80     }
81     // Function to access total supply of tokens .
82     function totalSupply() public view returns (uint256 _totalSupply) {
83         return totalSupply;
84     }
85 
86     
87     // Function that is called when a user or another contract wants to transfer funds .
88     function transfer(address _to, uint _value, bytes _data, string _custom_fallback) public returns (bool success) {        
89         if(isContract(_to)) {
90             if (balanceOf(msg.sender) < _value) revert();
91             balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
92             balances[_to] = safeAdd(balanceOf(_to), _value);
93             assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
94             emit Transfer(msg.sender, _to, _value, _data);
95             return true;
96         }
97         else {
98             return transferToAddress(_to, _value, false, _data);
99         }
100     }  
101     
102   
103     // Function that is called when a user or another contract wants to transfer funds .
104     function transfer(address _to, uint _value, bytes _data) public returns (bool success) {        
105         if(isContract(_to)) {
106             return transferToContract(_to, _value, false, _data);
107         }
108         else {
109             return transferToAddress(_to, _value, false, _data);
110         }
111     }  
112     
113     // Standard function transfer similar to ERC20 transfer with no _data .
114     // Added due to backwards compatibility reasons .
115     function transfer(address _to, uint _value) public returns (bool success) {
116         
117       //standard function transfer similar to ERC20 transfer with no _data
118       //added due to backwards compatibility reasons
119         bytes memory empty;
120         if(isContract(_to)) {
121             return transferToContract(_to, _value, true, empty);
122         }
123         else {
124             return transferToAddress(_to, _value, true, empty);
125         }
126     }  
127   
128     
129   
130     //function that is called when transaction target is an address
131     function transferToAddress(address _to, uint _value, bool isErc20Transfer, bytes _data) private returns (bool success) {
132         if (balanceOf(msg.sender) < _value) revert();
133         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
134         balances[_to] = safeAdd(balanceOf(_to), _value);
135         if (isErc20Transfer)
136             emit Transfer(msg.sender, _to, _value);
137         else
138             emit Transfer(msg.sender, _to, _value, _data);
139         return true;
140     }
141     
142     //function that is called when transaction target is a contract
143     function transferToContract(address _to, uint _value, bool isErc20Transfer, bytes _data) private returns (bool success) {
144         if (balanceOf(msg.sender) < _value) revert();
145         balances[msg.sender] = safeSub(balanceOf(msg.sender), _value);
146         balances[_to] = safeAdd(balanceOf(_to), _value);
147         ContractReceiver receiver = ContractReceiver(_to);
148         receiver.tokenFallback(msg.sender, _value, _data);
149         if (isErc20Transfer)
150             emit Transfer(msg.sender, _to, _value);
151         else
152             emit Transfer(msg.sender, _to, _value, _data);
153         return true;
154     }  
155   
156     //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
157     function isContract(address _addr) private view returns (bool is_contract) {
158         uint length;
159         assembly {
160               //retrieve the size of the code on target address, this needs assembly
161               length := extcodesize(_addr)
162         }
163         return (length>0);
164     }
165   
166     function balanceOf(address _owner) public view returns (uint balance) {
167       return balances[_owner];
168     }
169 }