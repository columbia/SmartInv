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
34 
35   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36   event SetManager(address indexed _manager);
37 
38   constructor () public {
39     owner = msg.sender;
40   }
41 
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46   
47   modifier onlyManager() {
48       require(msg.sender == manager);
49       _;
50   }
51   
52   function setManager(address _manager)public onlyOwner returns (bool) {
53       manager = _manager;
54       return true;
55   }
56 
57   function transferOwnership(address newOwner) public onlyOwner {
58     require(newOwner != address(0));
59     emit OwnershipTransferred(owner, newOwner);
60     owner = newOwner;
61   }
62 }
63 
64 contract Pausable is Ownable {
65   event Pause();
66   event Unpause();
67 
68   bool public paused = false;
69 
70   modifier whenNotPaused() {
71     require(!paused);
72     _;
73   }
74 
75   modifier whenPaused() {
76     require(paused);
77     _;
78   }
79 
80   function pause() onlyOwner whenNotPaused public {
81     paused = true;
82     emit Pause();
83   }
84 
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     emit Unpause();
88   }
89 }
90 
91 contract BasicBF is Pausable {
92     using SafeMath for uint256;
93     
94     mapping (address => uint256) public balances;
95     // match -> team -> amount
96     mapping (uint256 => mapping (uint256 => uint256)) public betMatchBalances;
97     // match -> team -> user -> amount
98     mapping (uint256 => mapping (uint256 => mapping (address => uint256))) public betMatchRecords;
99 
100     event Withdraw(address indexed user, uint256 indexed amount);
101     event WithdrawOwner(address indexed user, uint256 indexed amount);
102     event Issue(address indexed user, uint256 indexed amount);
103     event BetMatch(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);
104     event BehalfBet(address indexed user, uint256 indexed matchNo, uint256 indexed teamNo, uint256 amount);
105 }
106 
107 contract BF is BasicBF {
108     constructor () public {}
109     
110     function betMatch(uint256 _matchNo, uint256 _teamNo) public whenNotPaused payable returns (bool) {
111         uint256 amount = msg.value;
112         betMatchRecords[_matchNo][_teamNo][msg.sender] = betMatchRecords[_matchNo][_teamNo][msg.sender].add(amount);
113         betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);
114         balances[this] = balances[this].add(amount);
115         emit BetMatch(msg.sender, _matchNo, _teamNo, amount);
116         return true;
117     }
118     
119     function behalfBet(address _user, uint256 _matchNo, uint256 _teamNo) public whenNotPaused onlyManager payable returns (bool) {
120         uint256 amount = msg.value;
121         betMatchRecords[_matchNo][_teamNo][_user] = betMatchRecords[_matchNo][_teamNo][_user].add(amount);
122         betMatchBalances[_matchNo][_teamNo] = betMatchBalances[_matchNo][_teamNo].add(amount);
123         balances[this] = balances[this].add(amount);
124         emit BehalfBet(_user, _matchNo, _teamNo, amount);
125         return true;
126     }
127     
128     function issue(address[] _addrLst, uint256[] _amtLst) public whenNotPaused onlyManager returns (bool) {
129         require(_addrLst.length == _amtLst.length);
130         for (uint i=0; i<_addrLst.length; i++) {
131             balances[_addrLst[i]] = balances[_addrLst[i]].add(_amtLst[i]);
132             balances[this] = balances[this].sub(_amtLst[i]);
133             emit Issue(_addrLst[i], _amtLst[i]);
134         }
135         return true;
136     }
137     
138     function withdraw(uint256 _value) public whenNotPaused returns (bool) {
139         require(_value <= balances[msg.sender]);
140         balances[msg.sender] = balances[msg.sender].sub(_value);
141         msg.sender.transfer(_value);
142         emit Withdraw(msg.sender, _value);
143         return true;
144     }
145     
146     function withdrawOwner(uint256 _value) public onlyManager returns (bool) {
147         require(_value <= balances[this]);
148         balances[this] = balances[this].sub(_value);
149         msg.sender.transfer(_value);
150         emit WithdrawOwner(msg.sender, _value);
151         return true;
152     }
153     
154     function () public payable {}
155 }