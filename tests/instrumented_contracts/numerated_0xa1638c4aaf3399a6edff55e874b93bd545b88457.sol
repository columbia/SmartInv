1 pragma solidity 0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9  
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     // assert(b > 0); // Solidity automatically throws when dividing by 0
12     uint256 c = a / b;
13     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14     return c;
15   }
16  
17   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21  
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28  
29 contract StandardToken {
30  
31     using SafeMath for uint256;
32    
33     string public name;
34      
35     string public symbol;
36 	 
37     uint8 public  decimals;
38 	 
39 	  uint256 public totalSupply;
40    
41 	 
42     function transfer(address _to, uint256 _value) public returns (bool success);
43      
44     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
45 	 
46     function approve(address _spender, uint256 _value) public returns (bool success);
47 	 
48     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
49 	 
50     event Transfer(address indexed _from, address indexed _to, uint256 _value);
51 	 
52     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
53 }
54  
55 contract Owned {
56  
57      
58     modifier onlyOwner() {
59         require(msg.sender == owner);
60         _; 
61     }
62  
63 	 
64     address public owner;
65  
66  
67     constructor() public {
68         owner = msg.sender;
69     }
70 	 
71     address newOwner=0x0;
72  
73 	 
74     event OwnerUpdate(address _prevOwner, address _newOwner);
75  
76      
77     function changeOwner(address _newOwner) public onlyOwner {
78         require(_newOwner != owner);
79         newOwner = _newOwner;
80     }
81  
82      
83     function acceptOwnership() public{
84         require(msg.sender == newOwner);
85         emit OwnerUpdate(owner, newOwner);
86         owner = newOwner;
87         newOwner = 0x0;
88     }
89 }
90  
91  
92 contract Controlled is Owned{
93  
94 	 
95     constructor() public {
96        setExclude(msg.sender,true);
97     }
98  
99     
100     bool public transferEnabled = true;
101  
102      
103     bool lockFlag=true;
104 	 
105     mapping(address => bool) locked;
106 	 
107     mapping(address => bool) exclude;
108  
109 	 
110     function enableTransfer(bool _enable) public onlyOwner returns (bool success){
111         transferEnabled=_enable;
112 		return true;
113     }
114  
115 	 
116     function disableLock(bool _enable) public onlyOwner returns (bool success){
117         lockFlag=_enable;
118         return true;
119     }
120  
121  
122     function addLock(address _addr) public onlyOwner returns (bool success){
123         require(_addr!=msg.sender);
124         locked[_addr]=true;
125         return true;
126     }
127  
128 	 
129     function setExclude(address _addr,bool _enable) public onlyOwner returns (bool success){
130         exclude[_addr]=_enable;
131         return true;
132     }
133  
134 	 
135     function removeLock(address _addr) public onlyOwner returns (bool success){
136         locked[_addr]=false;
137         return true;
138     }
139 	 
140     modifier transferAllowed(address _addr) {
141         if (!exclude[_addr]) {
142             require(transferEnabled,"transfer is not enabeled now!");
143             if(lockFlag){
144                 require(!locked[_addr],"you are locked!");
145             }
146         }
147         _;
148     }
149  
150 }
151  
152  
153 contract GECToken is StandardToken,Controlled {
154  
155 	 
156 	mapping (address => uint256) public balanceOf;
157 	mapping (address => mapping (address => uint256)) internal allowed;
158     	
159 	constructor() public {
160         totalSupply = 1000000000;//10亿
161         name = "GECToken";
162         symbol = "GECT";
163         decimals = 8;
164         balanceOf[msg.sender] = totalSupply;
165     }
166           
167     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
168         balanceOf[target] = balanceOf[target].add(mintedAmount);
169         totalSupply = totalSupply.add(mintedAmount);
170         emit Transfer(0, owner, mintedAmount);
171         emit Transfer(owner, target, mintedAmount);
172     }
173 
174 
175     function transfer(address _to, uint256 _value) public transferAllowed(msg.sender) returns (bool success) {
176 		require(_to != address(0));
177 		require(_value <= balanceOf[msg.sender]);
178  
179         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
180         balanceOf[_to] = balanceOf[_to].add(_value);
181         emit Transfer(msg.sender, _to, _value);
182         return true;
183     }
184  
185     function transferFrom(address _from, address _to, uint256 _value) public transferAllowed(_from) returns (bool success) {
186 		require(_to != address(0));
187         require(_value <= balanceOf[_from]);
188         require(_value <= allowed[_from][msg.sender]);
189  
190         balanceOf[_from] = balanceOf[_from].sub(_value);
191         balanceOf[_to] = balanceOf[_to].add(_value);
192         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
193         emit Transfer(_from, _to, _value);
194         return true;
195     }
196  
197     function approve(address _spender, uint256 _value) public returns (bool success) {
198         allowed[msg.sender][_spender] = _value;
199         emit Approval(msg.sender, _spender, _value);
200         return true;
201     }
202  
203     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
204       return allowed[_owner][_spender];
205     }
206  
207 }