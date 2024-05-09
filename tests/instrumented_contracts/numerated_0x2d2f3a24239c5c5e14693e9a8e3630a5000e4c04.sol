1 pragma solidity ^0.4.21;
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
36     function transferFrom(address from, uint256 value) public returns (bool);
37     function approve(address spender, uint256 value) public returns (bool);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 contract MOEToken is ERC20 {
42 
43     using SafeMath for uint256;
44 
45     address public owner;
46 
47     mapping (address => uint256) balances;
48 
49     mapping (address => mapping (address => uint256)) allowed;
50 
51     string public name = "MOE's game art foundation";
52     string public constant symbol = "MOE";
53     uint public constant decimals = 18;
54     bool public stopped;
55     
56     modifier stoppable {
57         assert(!stopped);
58         _;
59     }
60     
61     uint256 public totalSupply = 1000000000*(10**18);
62 
63     event Transfer(address indexed _from, address indexed _to, uint256 _value);
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     event LOCK(address indexed _owner, uint256 _value);
66 
67     mapping (address => uint256) public lockAddress;
68     
69     modifier lock(address _add){
70         require(_add != address(0));
71         uint256 releaseTime = lockAddress[_add];
72         if(releaseTime > 0){
73              require(block.timestamp >= releaseTime);
74               _;
75         }else{
76              _;
77         }
78     }
79     
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     function MOEToken() public {
86         owner = msg.sender;
87         balances[msg.sender] = totalSupply;
88     }
89 
90     function stop() onlyOwner public {
91         stopped = true;
92     }
93     function start() onlyOwner public {
94         stopped = false;
95     }
96     
97     function lockTime(address _to,uint256 _value) onlyOwner public {
98        if(_value > block.timestamp){
99          lockAddress[_to] = _value;
100          emit LOCK(_to, _value);
101        }
102     }
103     
104     function lockOf(address _owner) constant public returns (uint256) {
105 	    return lockAddress[_owner];
106     }
107     
108     function transferOwnership(address _newOwner) onlyOwner public {
109         if (_newOwner != address(0)) {
110             owner = _newOwner;
111         }
112     }
113     
114     function () public payable {
115         address myAddress = this;
116         emit Transfer(msg.sender, myAddress, msg.value);
117      }
118 
119     function balanceOf(address _owner) constant public returns (uint256) {
120 	    return balances[_owner];
121     }
122     
123     function transfer(address _to, uint256 _amount) stoppable lock(msg.sender) public returns (bool success) {
124         require(_to != address(0));
125         require(_amount <= balances[msg.sender]);
126         
127         balances[msg.sender] = balances[msg.sender].sub(_amount);
128         balances[_to] = balances[_to].add(_amount);
129         emit Transfer(msg.sender, _to, _amount);
130         return true;
131     }
132     
133     function transferFrom(address _from, uint256 _amount) stoppable lock(_from) public returns (bool success) {
134         require(_amount <= balances[_from]);
135         require(_amount <= allowed[_from][msg.sender]);
136         
137         balances[_from] = balances[_from].sub(_amount);
138         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
139         balances[msg.sender] = balances[msg.sender].add(_amount);
140         emit Transfer(_from, msg.sender, _amount);
141         return true;
142     }
143     
144     function approve(address _spender, uint256 _value) stoppable lock(_spender) public returns (bool success) {
145         if (_value != 0 && allowed[msg.sender][_spender] != 0) { return false; }
146         allowed[msg.sender][_spender] = _value;
147         emit Approval(msg.sender, _spender, _value);
148         return true;
149     }
150     
151     function allowance(address _owner, address _spender)  constant public returns (uint256) {
152         return allowed[_owner][_spender];
153     }
154     
155     function withdraw() onlyOwner public {
156         address myAddress = this;
157         uint256 etherBalance = myAddress.balance;
158         owner.transfer(etherBalance);
159     }
160     
161     function kill() onlyOwner public {
162        selfdestruct(msg.sender);
163     }
164     
165     function setName(string _name) onlyOwner public  {
166         name = _name;
167     }
168 
169 }