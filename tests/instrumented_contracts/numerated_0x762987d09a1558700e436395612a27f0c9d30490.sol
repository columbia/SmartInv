1 pragma solidity ^0.4.23;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Ownable {
32   address public owner;
33   address public manager;
34   address public behalfer;
35 
36   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37   event SetManager(address indexed _manager);
38 
39   constructor () public {
40     owner = msg.sender;
41   }
42 
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47   
48   modifier onlyManager() {
49       require(msg.sender == manager);
50       _;
51   }
52   
53   modifier onlyBehalfer() {
54       require(msg.sender == behalfer);
55       _;
56   }
57   
58   function setManager(address _manager)public onlyOwner returns (bool) {
59       manager = _manager;
60       return true;
61   }
62   
63   function setBehalfer(address _behalfer)public onlyOwner returns (bool) {
64       behalfer = _behalfer;
65       return true;
66   }
67 
68   function transferOwnership(address newOwner) public onlyOwner {
69     require(newOwner != address(0));
70     emit OwnershipTransferred(owner, newOwner);
71     owner = newOwner;
72   }
73 }
74 
75 contract Pausable is Ownable {
76   event Pause();
77   event Unpause();
78 
79   bool public paused = false;
80 
81   modifier whenNotPaused() {
82     require(!paused);
83     _;
84   }
85 
86   modifier whenPaused() {
87     require(paused);
88     _;
89   }
90 
91   function pause() onlyOwner whenNotPaused public {
92     paused = true;
93     emit Pause();
94   }
95 
96   function unpause() onlyOwner whenPaused public {
97     paused = false;
98     emit Unpause();
99   }
100 }
101 
102 contract BasicBF is Pausable {
103     using SafeMath for uint256;
104     
105     mapping (address => uint256) public balances;
106     // match -> team -> amount
107     mapping (uint256 => mapping (uint256 => uint256)) public betMatchBalances;
108     // match -> team -> user -> amount
109     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public betMatchRecords;
110 
111     event Withdraw(address indexed user, uint256 indexed amount);
112     event WithdrawOwner(address indexed user, uint256 indexed amount);
113     event Issue(address indexed user, uint256 indexed amount);
114     event BetMatch(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);
115     event BehalfBet(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);
116 }
117 
118 contract BF is BasicBF {
119     constructor () public {}
120     
121     function betMatch(uint256 _matchNo, uint256 _teamNo) public whenNotPaused payable returns (bool) {
122         uint256 amount = msg.value;
123         betMatchRecords[_matchNo][_teamNo][msg.sender] = betMatchRecords[_matchNo][_teamNo][msg.sender].add(amount);
124         betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);
125         balances[this] = balances[this].add(amount);
126         emit BetMatch(msg.sender, _matchNo, _teamNo, amount);
127         return true;
128     }
129     
130     function behalfBet(address _user, uint256 _matchNo, uint256 _teamNo) public whenNotPaused onlyBehalfer payable returns (bool) {
131         uint256 amount = msg.value;
132         betMatchRecords[_matchNo][_teamNo][_user] = betMatchRecords[_matchNo][_teamNo][_user].add(amount);
133         betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);
134         balances[this] = balances[this].add(amount);
135         emit BehalfBet(_user, _matchNo, _teamNo, amount);
136         return true;
137     }
138     
139     function issue(address[] _addrLst, uint256[] _amtLst) public whenNotPaused onlyManager returns (bool) {
140         require(_addrLst.length == _amtLst.length);
141         for (uint i=0; i<_addrLst.length; i++) {
142             balances[_addrLst[i]] = balances[_addrLst[i]].add(_amtLst[i]);
143             balances[this] = balances[this].sub(_amtLst[i]);
144             emit Issue(_addrLst[i], _amtLst[i]);
145         }
146         return true;
147     }
148     
149     function withdraw(uint256 _value) public whenNotPaused returns (bool) {
150         require(_value <= balances[msg.sender]);
151         balances[msg.sender] = balances[msg.sender].sub(_value);
152         msg.sender.transfer(_value);
153         emit Withdraw(msg.sender, _value);
154         return true;
155     }
156     
157     function withdrawOwner(uint256 _value) public onlyManager returns (bool) {
158         require(_value <= balances[this]);
159         balances[this] = balances[this].sub(_value);
160         msg.sender.transfer(_value);
161         emit WithdrawOwner(msg.sender, _value);
162         return true;
163     }
164     
165     function () public payable {}
166 }