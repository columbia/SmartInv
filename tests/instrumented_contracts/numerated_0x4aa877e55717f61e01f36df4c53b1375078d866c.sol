1 pragma solidity ^0.4.24;
2 
3 /**
4  * Math operations to avoid overflows
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15 
16     function div(uint256 a, uint256 b) internal pure returns (uint256) {
17         // assert(b > 0); // Solidity automatically throws when dividing by 0
18         uint256 c = a / b;
19         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
20         return c;
21     }
22 
23     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
24         assert(b <= a);
25         return a - b;
26     }
27 
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         assert(c >= a);
31         return c;
32     }
33 
34 }
35 
36 contract FarmChain {
37     /*using the SafeMath keep from the up/down overflows*/
38     using SafeMath for uint256;
39     
40     /*the name of the token*/
41     string public name;
42     
43     /*the token's symbol*/
44     string public symbol;
45     /*the decimal of the token */
46     
47     uint8 public decimals;
48     
49     /* the totalSupply of token */
50     uint256 public totalSupply;
51 
52     /*the owner of the contract*/
53 	address public owner;
54 	
55 	address[] public ownerables;
56 	
57 	bool  public isRunning = false;
58 	
59 //	uint startTime;
60 	
61 	address public burnAddress;
62 	
63 	mapping(address => bool) public isOwner;
64 	
65 	mapping (address => bool) public isFrezze;
66 	
67 //	address public LockBinAddress;
68 
69     /* The hot_balance of users , users' totalBalance = balanceOf + freezeOf */
70     mapping (address => uint256) public balanceOf;
71     /*the Lock-bin balance of users */
72 //	mapping (address => uint256) public lockbinOf;
73 	
74     mapping (address => mapping (address => uint256)) public allowance;
75 
76     event Transfer(address indexed _from, address indexed _to, uint256 value);
77     
78     event Approval(address indexed _from, address indexed _spender, uint256 _value);
79 	
80     event Freeze(address indexed _who, address indexed _option);
81     
82     event UnFrezze(address indexed _who, address indexed _option);
83     
84     event Burn(address indexed _from, uint256 _amount);
85     
86     modifier onlyOwnerable() {
87         assert(isOwner[msg.sender]);
88         _;
89     }
90     modifier onlyOwner() {
91         assert(msg.sender == owner);
92         _;
93     }
94     /*Let the contract keep from the short-address attack*/
95     modifier onlyPayloadSize(uint size) {
96         assert((msg.data.length >= size + 4));
97         _;
98     }
99     modifier onlyRuning {
100         require(isRunning, "the contract has been stoped");
101         _;
102     }
103     modifier onlyUnFrezze {
104         assert(!isFrezze[msg.sender]);
105         _;
106     }
107   
108 
109     /* the constructor of the contract */
110 constructor() public {
111         
112         totalSupply = 100000000000000000;
113        
114         balanceOf[msg.sender] = totalSupply;
115         
116         name = "Farm Chain";                                  
117         
118         symbol = "FAC";                               
119       
120         decimals = 8;                            
121 	
122 		owner = msg.sender;
123 		
124 		isOwner[owner] = true;
125 	
126 		isRunning = true;
127 		
128 		//addOwners(_admins);
129 		
130     }
131 
132     /* Send coins */
133     function transfer(address _to, uint256 _value) public onlyRuning onlyUnFrezze onlyPayloadSize(32 * 2) returns (bool success){
134         require(_to != 0x0);
135         require( balanceOf[msg.sender] >= _value);
136         require(balanceOf[_to] + _value > balanceOf[_to]); 
137         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                     
138         balanceOf[_to] = balanceOf[_to].add(_value);                            
139         emit Transfer(msg.sender, _to, _value); 
140         return true;
141     }
142 
143     
144     function approve(address _spender , uint256 _value) public onlyUnFrezze onlyRuning returns (bool success) {
145 		allowance[msg.sender][_spender] = _value;
146         emit Approval(msg.sender, _spender, _value);
147         return true;
148     }
149        
150 
151     
152     function transferFrom(address _from, address _to, uint256 _value) public onlyUnFrezze onlyRuning returns (bool success) {
153             
154             assert(balanceOf[_from] >= _value);
155             assert(allowance[_from][msg.sender] >= _value);
156             balanceOf[_from] = balanceOf[_from].sub(_value);
157             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
158             balanceOf[_to] = balanceOf[_to].add(_value);
159             emit Transfer(_from, _to, _value);
160             return true;
161     }
162     
163     function stopContract() public onlyOwnerable {
164         require(isRunning,"the contract has been stoped");
165         
166         isRunning = false;
167     }
168     
169     function startContract() public onlyOwnerable {
170         require(!isRunning,"the contract has been started");
171         
172         isRunning = true;
173     }
174     
175     function freeze (address _option) public onlyOwnerable {
176         require(!isFrezze[_option],"the account has been feezed");
177        
178         isFrezze[_option] = true;
179        
180         emit Freeze(msg.sender, _option);
181     }
182    
183     function unFreeze(address _option) public onlyOwnerable {
184         
185         require(isFrezze[_option],"the account has been unFrezzed");
186        
187         isFrezze[_option] = false;
188         
189         emit UnFrezze(msg.sender, _option);
190     }
191 
192     function setOwners(address[] _admin) public onlyOwner {
193         uint len = _admin.length;
194         for(uint i= 0; i< len; i++) {
195             require(!isContract(_admin[i]),"not support contract address as owner");
196             require(!isOwner[_admin[i]],"the address is admin already");
197             isOwner[_admin[i]] = true;
198         }
199     }
200 
201     function deletOwners(address[] _todel) public onlyOwner {
202         uint len = _todel.length;
203         for(uint i= 0; i< len; i++) {
204             require(isOwner[_todel[i]],"the address is not a admin");
205             isOwner[_todel[i]] = false;
206         }
207         
208     }
209 
210     function setBurnAddress(address _toBurn) public onlyOwnerable returns(bool success) {
211         
212         burnAddress = _toBurn;
213         return true;
214     }
215 
216     function burn(uint256 _amount)  public onlyOwnerable {
217         require(balanceOf[burnAddress] >= _amount,"there is no enough money to burn");
218         balanceOf[burnAddress] = balanceOf[burnAddress].sub(_amount);
219         totalSupply = totalSupply.sub(_amount);
220         emit Burn(burnAddress, _amount);
221     }
222 
223     function isContract(address _addr) constant internal returns(bool) {
224         require(_addr != 0x0);
225         uint size;
226          assembly {
227             /*:= reference external variable*/
228             size := extcodesize(_addr)
229         }
230         return size > 0;
231     }
232 }