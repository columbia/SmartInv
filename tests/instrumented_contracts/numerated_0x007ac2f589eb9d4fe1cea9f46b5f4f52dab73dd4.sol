1 pragma solidity ^0.4.11;
2 
3 
4 library SafeMath {
5     
6   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
7     if (a == 0) {
8       return 0;
9     }
10     uint256 c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   function div(uint256 a, uint256 b) internal pure returns (uint256) {
16     uint256 c = a / b;
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 
32 contract SKWToken {
33     
34     using SafeMath for uint256;
35     
36     string public name = "SKW";      //  token name
37     
38     string public symbol = "SKW";           //  token symbol
39     
40     uint256 public decimals = 8;            //  token digit
41 
42     mapping (address => uint256) public balanceOf;
43     
44     mapping (address => mapping (address => uint256)) public allowance;
45     
46     mapping (address => uint256) public frozenBalances;
47     
48     mapping (address => uint256) public initTimes;
49     
50     mapping (address => uint) public initTypes;
51     
52     uint256 public totalSupply = 0;
53 
54     uint256 constant valueFounder = 5000000000000000000;
55     
56     address owner = 0x0;
57     
58     address operator = 0x0;
59 
60     modifier isOwner {
61         assert(owner == msg.sender);
62         _;
63     }
64     
65     modifier isOperator {
66         assert(operator == msg.sender);
67         _;
68     }
69 
70     modifier validAddress {
71         assert(0x0 != msg.sender);
72         _;
73     }
74     
75     event Transfer(address indexed _from, address indexed _to, uint256 _value);
76     
77     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
78     
79     event Burn(address indexed from, uint256 value);
80 
81     constructor() public {
82         owner = msg.sender;
83         operator = msg.sender;
84         totalSupply = valueFounder;
85         balanceOf[msg.sender] = valueFounder;
86         emit Transfer(0x0, msg.sender, valueFounder);
87     }
88     
89     function _transfer(address _from, address _to, uint256 _value) private {
90         require(_to != 0x0);
91         require(canTransferBalance(_from) >= _value);
92         balanceOf[_from] = balanceOf[_from].sub(_value);
93         balanceOf[_to] = balanceOf[_to].add(_value);
94         emit Transfer(_from, _to, _value);
95     }
96     
97     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
98         _transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);
104         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
110         require(canTransferBalance(msg.sender) >= _value);
111         allowance[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115     
116     function burn(uint256 _value) validAddress public  returns (bool success) {
117         require(canTransferBalance(msg.sender) >= _value);   // Check if the sender has enough
118         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
119         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
120         emit Burn(msg.sender, _value);
121         emit Transfer(msg.sender, 0x0, _value);
122         return true;
123     }
124 
125     function initTransferArr(address[] _arr_addr, uint256[] _arr_value,uint[] _arr_initType) validAddress isOperator public returns (bool success) {
126         require(_arr_addr.length == _arr_value.length && _arr_value.length == _arr_initType.length);
127         require(_arr_addr.length > 0 && _arr_addr.length < 100);
128         for (uint i = 0; i < _arr_addr.length ; ++i) {
129             initTransfer(_arr_addr[i],_arr_value[i],_arr_initType[i]);
130         }
131         return true;
132     }
133 
134     function initTransfer(address _to, uint256 _value, uint _initType) validAddress isOperator public returns (bool success) {
135         require(_initType == 0x1 || _initType == 0x2);
136         require(initTypes[_to]==0x0);
137         frozenBalances[_to] = _value;
138         initTimes[_to] = now;
139         initTypes[_to] = _initType;
140         _transfer(msg.sender, _to, _value);
141         return true;
142     }
143     
144     function canTransferBalance(address addr) public view returns (uint256){
145         if(initTypes[addr]==0x0){
146             return balanceOf[addr];
147         }else{
148             uint256 s = now.sub(initTimes[addr]);
149             if(initTypes[addr]==0x1){
150                 if(s >= 513 days){
151                     return balanceOf[addr];    
152                 }else if(s >= 183 days){
153                     return balanceOf[addr].sub(frozenBalances[addr]).add(frozenBalances[addr].div(12).mul((s.sub(183 days).div(30 days) + 1)));
154                 }else{
155                     return balanceOf[addr].sub(frozenBalances[addr]);
156                 }
157             }else if(initTypes[addr]==0x2){
158                 if(s >= 243 days){
159                     return balanceOf[addr];    
160                 }else if(s >= 93 days){
161                     return balanceOf[addr].sub(frozenBalances[addr]).add(frozenBalances[addr].div(6).mul((s.sub(93 days).div(30 days) + 1)));
162                 }else{
163                     return balanceOf[addr].sub(frozenBalances[addr]);
164                 }
165             }else{
166                 return 0;
167             }
168         }
169     }
170     
171     function setOperator(address addr) validAddress isOwner public {
172         operator = addr;
173     }
174     
175 }