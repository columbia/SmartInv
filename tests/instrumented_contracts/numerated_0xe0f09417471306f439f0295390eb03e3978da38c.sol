1 pragma solidity ^0.4.20;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function div(uint256 a, uint256 b) internal pure returns (uint256) {
11     uint256 c = a / b;
12     return c;
13   }
14 
15   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
16     assert(b <= a);
17     return a - b;
18   }
19 
20   function add(uint256 a, uint256 b) internal pure returns (uint256) {
21     uint256 c = a + b;
22     assert(c >= a);
23     return c;
24   }
25 }
26 
27 contract ERC20Basic {
28     uint256 public totalSupply;
29     function balanceOf(address who) public constant returns (uint256);
30     function transfer(address to, uint256 value) public returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 }
33 
34 contract ERC20 is ERC20Basic {
35     function allowance(address owner, address spender) public constant returns (uint256);
36     function transferFrom(address from, address to, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract RETC is ERC20 {
42     
43     using SafeMath for uint256; 
44     address owner = msg.sender; 
45 	address locker15 = msg.sender;
46 	address locker10 = msg.sender;	
47 	address locker05 = msg.sender;	
48 	
49     mapping (address => uint256) balances; 
50     mapping (address => mapping (address => uint256)) allowed;
51 
52     mapping (address => uint256) times;//次数T
53 
54     mapping (address => mapping (uint256 => uint256)) lockdata;//数目
55     mapping (address => mapping (uint256 => uint256)) locktime;//时间戳
56     mapping (address => mapping (uint256 => uint256)) lockday;//时间
57     
58     
59 
60     string public constant name = "RealEstatePublicBlockchain";
61     string public constant symbol = "RETC";
62     uint public constant decimals = 3;
63     uint256 _Rate = 10 ** decimals; 
64     uint256 public totalSupply = 10000000000 * _Rate;
65 
66 
67     event Transfer(address indexed _from, address indexed _to, uint256 _value);
68     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70 
71 
72     modifier onlyOwner() {
73         require(msg.sender == owner);
74         _;
75     }
76 
77     modifier onlyPayloadSize(uint size) {
78         assert(msg.data.length >= size + 4);
79         _;
80     }
81 
82      function RETC () public {
83         owner = msg.sender;
84   
85         balances[owner] = totalSupply;
86     }
87      function nowInSeconds() public view returns (uint256){
88         return now;
89     }
90     function transferOwnership(address newOwner) onlyOwner public {
91         if (newOwner != address(0) && newOwner != owner) {          
92              owner = newOwner;   
93         }
94     }
95 
96     function locked(address _from, address _to, uint256 _amount) private {
97 		uint lockmon;
98 		uint lockper;
99 		if (_from == locker15) {
100             lockmon = 60 * 30 * 1 days;
101 			lockper = (_amount.div(100)).mul(15);
102         }
103 		if (_from == locker10) {
104 		    lockmon = 48 * 30 * 1 days;
105 			lockper = (_amount.div(100)).mul(10);
106         }
107 		if (_from == locker05 ) {
108             lockmon = 36 * 30 * 1 days;
109 			lockper = (_amount.div(100)).mul(5);
110         }		
111 		times[_to] += 1;
112         locktime[_to][times[_to]] = now;
113         lockday[_to][times[_to]] = lockmon;
114         lockdata[_to][times[_to]] = lockper;
115         
116     }
117  
118 
119     function set_locker(address _locker15, address _locker10, address _locker05) onlyOwner public {
120 		require(_locker15 != _locker10 && _locker15 != _locker05 && _locker05 != _locker10 );
121 		locker15 = _locker15;
122 		locker10 = _locker10;	
123 		locker05 = _locker05;
124 	
125     }
126 
127 
128     function balanceOf(address _owner) constant public returns (uint256) {
129 	    return balances[_owner];
130     }
131 //查询地址锁定币数
132     function lockOf(address _owner) constant public returns (uint256) {
133     uint locknum = 0;
134     for (uint8 i = 1; i < times[_owner] + 1; i++){
135        if(now < locktime[_owner][i] + 30* 1 days){
136             locknum += lockdata[_owner][i];
137         }
138        else{
139             if(now < locktime[_owner][i] + lockday[_owner][i] + 1* 1 days){
140 				uint lockmon = lockday[_owner][i].div(30 * 1 days);
141 				uint locknow = (now - locktime[_owner][i]).div(30 * 1 days);
142                 locknum += ((lockmon-locknow).mul(lockdata[_owner][i])).div(lockmon);
143               }
144               else{
145                  locknum += 0;
146               }
147         }
148     }
149 
150 
151 	    return locknum;
152     }
153 
154     function transfer(address _to, uint256 _amount) onlyPayloadSize(2 * 32) public returns (bool success) {
155 
156         require(_to != address(0));
157         require(_amount <= (balances[msg.sender].sub(lockOf(msg.sender))));
158                       
159         balances[msg.sender] = balances[msg.sender].sub(_amount);
160         balances[_to] = balances[_to].add(_amount);
161 		
162 		if (msg.sender == locker15 || msg.sender == locker10 || msg.sender == locker05 ) {
163             locked(msg.sender, _to, _amount);
164         }
165         Transfer(msg.sender, _to, _amount);
166         return true;
167     }
168   
169     function transferFrom(address _from, address _to, uint256 _amount) onlyPayloadSize(3 * 32) public returns (bool success) {
170 
171         require(_to != address(0));
172         require(_amount <= balances[_from]);
173         require(_amount <= (allowed[_from][msg.sender].sub(lockOf(msg.sender))));
174 
175         
176         balances[_from] = balances[_from].sub(_amount);
177         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
178         balances[_to] = balances[_to].add(_amount);
179         Transfer(_from, _to, _amount);
180         return true;
181     }
182 
183     function approve(address _spender, uint256 _value) public returns (bool success) {
184         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
185         allowed[msg.sender][_spender] = _value;
186         Approval(msg.sender, _spender, _value);
187         return true;
188     }
189 
190     function allowance(address _owner, address _spender) constant public returns (uint256) {
191         return allowed[_owner][_spender];
192     }
193 
194     function withdraw() onlyOwner public {
195         uint256 etherBalance = this.balance;
196         address theowner = msg.sender;
197         theowner.transfer(etherBalance);
198     }
199 }