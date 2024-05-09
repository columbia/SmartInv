1 pragma solidity ^0.4.17;
2 
3 /**
4  * Math operations with safety checks
5  */
6 
7 library SafeMath {
8   function safeMul(uint256 a, uint256 b)  internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
15     assert(b > 0);
16     uint256 c = a / b;
17     assert(a == b * c + a % b);
18     return c;
19   }
20 
21   function safeSub(uint256 a, uint256 b) internal pure  returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 
32 }
33 
34 contract INToken{
35 
36     string public name;
37     string public symbol;
38     uint8 public decimals;
39     uint256 public totalSupply;
40     address public owner;
41     bool public movePermissionStat = false;
42     bool public isLockTransfer = false;
43 
44     mapping (address => uint256) public balanceOf;
45   	mapping (address => uint256) public freezeOf;
46     mapping (address => mapping (address => uint256)) public allowance;
47     mapping (address => bool)  public lockOf;
48 
49     event AddSupply(address indexed from,uint256 _value);
50 
51     /* This notifies clients about the amount burnt */
52     event BurnSupply(address indexed from, uint256 _value);
53 
54     /* This notifies clients about the amount frozen */
55     event Freeze(address indexed from, uint256 _value);
56 
57   	/* This notifies clients about the amount unfrozen */
58     event Unfreeze(address indexed from, uint256 _value);
59 
60     /* This generates a public event on the blockchain that will notify clients */
61     event Transfer(address indexed from, address indexed to, uint256 _value);
62 
63     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
64 
65     event MovePermission(address indexed form ,address indexed to);
66 
67 
68     constructor(uint256 initialSupply,  string tokenName, uint8 decimalUnits,  string tokenSymbol) public{
69       balanceOf[msg.sender] = initialSupply;
70       totalSupply = initialSupply;
71       name=tokenName;
72       symbol =tokenSymbol;
73       decimals = decimalUnits;
74       owner = msg.sender;
75     }
76 
77     // function InTokenTest1130(uint256 initialSupply,
78     //                       string tokenName,
79     //                       uint8 decimalUnits,
80     //                       string tokenSymbol)  public {
81 
82     //   balanceOf[msg.sender] = initialSupply;
83     //   totalSupply = initialSupply;
84     //   name=tokenName;
85     //   symbol =tokenSymbol;
86     //   decimals = decimalUnits;
87     //   owner = msg.sender;
88     // }
89 
90     modifier onlyOwner{
91         require(msg.sender == owner);
92         _;
93     }
94 
95     modifier canTransfer{
96         require(!isLockTransfer && !lockOf[msg.sender] );
97         _;
98     }
99 
100     /* Change contract name */
101     function changeTokenName(string _tokenName) onlyOwner public returns (bool){
102         name = _tokenName;
103         return true;
104     }
105 
106     /* Change contract symbol */
107     function changeSymbol(string tokenSymbol)  onlyOwner public returns (bool){
108          symbol = tokenSymbol;
109     }
110 
111     /* Add supply symbol  */
112     function addSupply(uint256 _addSupply)  onlyOwner public returns (bool){
113         require(_addSupply>0);
114         balanceOf[msg.sender] = SafeMath.safeAdd(balanceOf[msg.sender],_addSupply);
115         totalSupply = SafeMath.safeAdd(totalSupply,_addSupply);
116         emit AddSupply(msg.sender,_addSupply);
117         return true;
118     }
119 
120     /* burn symbol */
121     function burnSupply(uint256 supply) onlyOwner public returns (bool){
122         require(supply>0);
123         balanceOf[owner] = SafeMath.safeSub(balanceOf[owner],supply);
124         totalSupply = SafeMath.safeSub(totalSupply,supply);
125         emit BurnSupply(msg.sender,supply);
126         return true;
127     }
128 
129     /* setter MovePermissionStat */
130     function setMovePermissionStat(bool status) onlyOwner public {
131        movePermissionStat = status;
132     }
133 
134     /* move  permissions */
135     function movePermission(address to) onlyOwner public returns (bool){
136        require(movePermissionStat);
137        balanceOf[to] = SafeMath.safeAdd(balanceOf[to],balanceOf[owner]);
138        balanceOf[owner] = 0;
139        owner = to;
140        emit MovePermission(msg.sender,to);
141        return true;
142     }
143 
144     function freezeAll(address to)  public returns (bool) {
145        return  freeze(to,balanceOf[to]);
146     }
147 
148     function freeze(address to,uint256 _value) onlyOwner public returns (bool) {
149         require(to != 0x0 && to != owner && _value > 0) ;
150         /* banlanceof */
151         balanceOf[to] = SafeMath.safeSub(balanceOf[to],_value);
152         freezeOf[to] = SafeMath.safeAdd(freezeOf[to],_value);
153         emit Freeze(to,_value);
154         return true;
155     }
156 
157     /* unFreeze value  */
158     function unFreeze(address to,uint256 _value) onlyOwner public returns (bool) {
159        require(to != 0x0 && to != owner && _value > 0);
160        freezeOf[to] = SafeMath.safeSub(freezeOf[to],_value);
161        balanceOf[to] = SafeMath.safeAdd(balanceOf[to],_value);
162        emit Unfreeze(to,_value);
163        return true;
164     }
165 
166     /* unFreeze all  */
167     function unFreezeAll(address to) public returns (bool) {
168         return unFreeze(to,freezeOf[to]);
169     }
170 
171     function lockAccount(address to) onlyOwner public returns (bool){
172        lockOf[to] = true;
173        return true;
174     }
175 
176     function unlockAccount(address to) onlyOwner public returns (bool){
177        lockOf[to] = false;
178        return true;
179     }
180 
181     function lockTransfer() onlyOwner public returns (bool){
182        isLockTransfer = true;
183        return true;
184     }
185 
186     function unlockTransfer() onlyOwner public returns (bool){
187        isLockTransfer = false;
188        return true;
189     }
190 
191     function transfer(address _to, uint256 _value) canTransfer public {
192        require (_to != 0x0 && _value > 0 ) ;
193        require (balanceOf[msg.sender] >= _value) ;
194        balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);
195        balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
196        emit Transfer(msg.sender, _to, _value);
197     }
198 
199     /* Allow another contract to spend some tokens in your behalf */
200     function approve(address _spender, uint256 _value)  public returns (bool) {
201         require ( _spender!=0x0 && _value > 0);
202         allowance[msg.sender][_spender] = _value;
203         emit Approval(msg.sender,_spender,_value);
204         return true;
205     }
206 
207     /* A contract attempts to get the coins */
208     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool) {
209         require(_to != 0x0 && _value > 0);
210         require( !isLockTransfer && !lockOf[_from] && balanceOf[_from] >= _value && _value <= allowance[_from][msg.sender]);
211         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value);
212         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value);
213         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
214         emit Transfer(_from, _to, _value);
215         return true;
216     }
217 
218     function kill() onlyOwner  public {
219         selfdestruct(owner);
220     }
221 
222 }