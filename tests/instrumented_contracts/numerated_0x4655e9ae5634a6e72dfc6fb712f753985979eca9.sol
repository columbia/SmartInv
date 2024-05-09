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
32 contract HZI {
33     
34     using SafeMath for uint256;
35     
36     string public name = "HZI";      //  token name
37     
38     string public symbol = "HZI";           //  token symbol
39     
40     uint256 public decimals = 8;            //  token digit
41 
42     mapping (address => uint256) public balanceOf;
43     
44     mapping (address => mapping (address => uint256)) public allowance;
45     
46     mapping (address => uint256) public frozenBalances;
47     mapping (address => uint256) public lockedBalances;
48     
49     mapping (address => uint256) public initTimes;
50     
51     mapping (address => uint) public initTypes;
52     
53     uint256 public totalSupply = 0;
54 
55     uint256 constant valueFounder = 1000000000000000000;
56     
57     address owner = 0x0;
58     
59     address operator = 0x0;
60     bool inited = false;
61 
62     modifier isOwner {
63         assert(owner == msg.sender);
64         _;
65     }
66     
67     modifier isOperator {
68         assert(operator == msg.sender);
69         _;
70     }
71 
72     modifier validAddress {
73         assert(0x0 != msg.sender);
74         _;
75     }
76     
77     event Transfer(address indexed _from, address indexed _to, uint256 _value);
78     
79     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
80     
81     event Burn(address indexed from, uint256 value);
82     event Frozen(address indexed from, uint256 value);
83     event UnFrozen(address indexed from, uint256 value);
84 
85 
86     constructor() public {
87         owner = msg.sender;
88         operator = msg.sender;
89         totalSupply = valueFounder;
90         balanceOf[msg.sender] = valueFounder;
91         emit Transfer(0x0, msg.sender, valueFounder);
92     }
93     
94     function _transfer(address _from, address _to, uint256 _value) private {
95         require(_to != 0x0);
96         require(canTransferBalance(_from) >= _value);
97         balanceOf[_from] = balanceOf[_from].sub(_value);
98         balanceOf[_to] = balanceOf[_to].add(_value);
99         emit Transfer(_from, _to, _value);
100     }
101     
102     function transfer(address _to, uint256 _value) validAddress public returns (bool success) {
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) validAddress public returns (bool success) {
108         require(_value <= allowance[_from][msg.sender]);
109         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function approve(address _spender, uint256 _value) validAddress public returns (bool success) {
115         require(canTransferBalance(msg.sender) >= _value);
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender, _spender, _value);
118         return true;
119     }
120     
121     function burn(uint256 _value) validAddress public  returns (bool success) {
122         require(canTransferBalance(msg.sender) >= _value);   // Check if the sender has enough
123         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);            // Subtract from the sender
124         totalSupply = totalSupply.sub(_value);                      // Updates totalSupply
125         emit Burn(msg.sender, _value);
126         emit Transfer(msg.sender, 0x0, _value);
127         return true;
128     }
129 
130     function initTransferArr(address[] _arr_addr, uint256[] _arr_value,uint[] _arr_initType) validAddress isOperator public returns (bool success) {
131         require(_arr_addr.length == _arr_value.length && _arr_value.length == _arr_initType.length);
132         require(_arr_addr.length > 0 && _arr_addr.length < 100);
133         require(!inited);
134         for (uint i = 0; i < _arr_addr.length ; ++i) {
135             initTransfer(_arr_addr[i],_arr_value[i],_arr_initType[i]);
136         }
137         inited = true;
138         return true;
139     }
140 
141     function initTransfer(address _to, uint256 _value, uint _initType) validAddress isOperator public returns (bool success) {
142         require(_initType == 0x1 || _initType == 0x2 || _initType == 0x3);
143         require(initTypes[_to]==0x0);
144         lockedBalances[_to] = _value;
145         initTimes[_to] = now;
146         initTypes[_to] = _initType;
147         _transfer(msg.sender, _to, _value);
148         return true;
149     }
150     
151     function canTransferBalance(address addr) public view returns (uint256){
152         if(initTypes[addr]==0x0){
153             return balanceOf[addr].sub(frozenBalances[addr]);
154         }else{
155             uint256 s = now.sub(initTimes[addr]);
156             if(initTypes[addr]==0x1){
157                 if(s >= 11825 days){
158                     return balanceOf[addr].sub(frozenBalances[addr]);    
159                 }else if(s >= 1825 days){
160                     return balanceOf[addr].sub(lockedBalances[addr]).add(lockedBalances[addr].div(10000).mul((s.sub(1825 days).div(1 days) + 1))).sub(frozenBalances[addr]);
161                 }else{
162                     return balanceOf[addr].sub(lockedBalances[addr]).sub(frozenBalances[addr]);
163                 }
164             }else if(initTypes[addr]==0x2){
165                 if(s >= 11460 days){
166                     return balanceOf[addr].sub(frozenBalances[addr]);    
167                 }else if(s >= 1460 days){
168                     return balanceOf[addr].sub(lockedBalances[addr]).add(lockedBalances[addr].div(10000).mul((s.sub(1460 days).div(1 days) + 1))).sub(frozenBalances[addr]);
169                 }else{
170                     return balanceOf[addr].sub(lockedBalances[addr]).sub(frozenBalances[addr]);
171                 }
172             }else if(initTypes[addr]==0x3){
173                 if(s >= 11095 days){
174                     return balanceOf[addr].sub(frozenBalances[addr]);    
175                 }else if(s >= 1095 days){
176                     return balanceOf[addr].sub(lockedBalances[addr]).add(lockedBalances[addr].div(10000).mul((s.sub(1095 days).div(1 days) + 1))).sub(frozenBalances[addr]);
177                 }else{
178                     return balanceOf[addr].sub(lockedBalances[addr]).sub(frozenBalances[addr]);
179                 }
180             }else{
181                 return 0;
182             }
183       
184         }
185     }
186 
187     function frozen(address from,  uint256 value) validAddress isOperator public {
188         require(from != 0x0);
189         require(canTransferBalance(from) >= value);
190         frozenBalances[from] = frozenBalances[from].add(value);
191         emit Frozen(from, value);
192     }
193 
194     function unFrozen(address from,  uint256 value) validAddress isOperator public {
195         require(from != 0x0);
196         require(frozenBalances[from] >= value);
197         frozenBalances[from] = frozenBalances[from].sub(value);
198         emit UnFrozen(from, value);
199     }
200 
201     function setOperator(address addr) validAddress isOwner public {
202         operator = addr;
203     }
204     
205 }