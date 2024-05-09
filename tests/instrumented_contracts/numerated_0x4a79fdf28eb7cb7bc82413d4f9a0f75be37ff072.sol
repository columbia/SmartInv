1 pragma solidity ^0.4.24;
2 
3 // File: /rhem/contracts/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11     address public owner;
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner`
15      * of the contract to the sender account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the current owner
23      */
24     modifier onlyOwner {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner
31      * @param newOwner The address to transfer ownership to
32      */
33     function transferOwnership(address newOwner) public onlyOwner {
34         require(newOwner != address(0));
35         owner = newOwner;
36     }
37 }
38 
39 // File: contracts/Locker2.sol
40 
41 contract RHEM {
42     function balanceOf(address _owner) public view returns (uint256 balance);
43     function transfer(address _to, uint256 _value) public returns (bool success);
44 }
45 
46 contract Locker2 is Ownable {
47     RHEM private _rhem;
48     mapping(address => uint256) private _lockedBalances;
49     bool private _isLocked = true;
50     uint256 private _totalLockedBalance;
51 
52     event Add(address indexed to, uint256 value);
53     event Unlock();
54 
55     constructor(address _t) public {
56         require(_t != address(0));
57         _rhem = RHEM(_t);
58     }
59 
60     /**
61      * @dev RHEM contract
62      */
63     function rhem() public view returns(RHEM) {
64         return _rhem;
65     }
66 
67     /**
68      * @dev Check if locked
69      */
70     function isLocked() public view returns(bool) {
71         return _isLocked;
72     }
73 
74     /**
75      * @dev Get total locked balance
76      */
77     function totalLockedBalance() public view returns(uint256 balance) {
78         return _totalLockedBalance;
79     }
80 
81     /**
82      * @dev Get Rhem Balance of Contract Address
83      */
84     function getContractRhemBalance() public view returns(uint256 balance) {
85         return _rhem.balanceOf(address(this));
86     }
87 
88     /**
89      * @dev Get locked balance of specific address
90      */
91     function lockedBalanceOf(address _beneficiary) public view returns(uint256 lockedBalance) {
92         return _lockedBalances[_beneficiary];
93     }
94 
95     /**
96      * @dev Get locked balance of specific addresses
97      */
98     function lockedBalancesOf(address[] _beneficiaries) public view returns(uint256[] lockedBalances) {
99         uint i = 0;
100         uint256[] memory amounts = new uint256[](_beneficiaries.length);
101 
102         for (i; i < _beneficiaries.length; i++) {
103             amounts[i] = _lockedBalances[_beneficiaries[i]];
104         }
105 
106         return amounts;
107     }
108 
109     /* Adding operations */
110 
111     /**
112      * @dev Add Address with Lock Rhem Token
113      */
114     function addLockedBalance(address _beneficiary, uint256 _value) public onlyOwner returns(bool success) {
115         require(_isLocked);
116         require(_beneficiary != address(0));
117         require(_value > 0);
118 
119         uint256 amount = _lockedBalances[_beneficiary];
120         amount += _value;
121         require(amount > 0);
122 
123         uint256 currentBalance = getContractRhemBalance();
124         _totalLockedBalance += _value;
125         require(_totalLockedBalance > 0);
126         require(_totalLockedBalance <= currentBalance);
127 
128         _lockedBalances[_beneficiary] = amount;
129         emit Add(_beneficiary, _value);
130 
131         return true;
132     }
133 
134     function addLockedBalances(address[] _beneficiaries, uint256[] _amounts) public onlyOwner returns(bool success) {
135         require(_isLocked);
136 
137         uint i = 0;
138 
139         for (i; i < _beneficiaries.length; i++) {
140             addLockedBalance(_beneficiaries[i], _amounts[i]);
141         }
142 
143         return true;
144     }
145 
146     /* Unlocking */
147 
148     /**
149      * @dev Unlock
150      */
151     function unlock() public onlyOwner {
152         require(_isLocked);
153 
154         _isLocked = false;
155 
156         emit Unlock();
157     }
158 
159     /* Releasing */
160 
161     /**
162      * @dev Release ones own locked balance
163      */
164     function releaseBalance() public returns(bool success) {
165         require(!_isLocked);
166         require(_lockedBalances[msg.sender] > 0);
167 
168         uint256 amount = _lockedBalances[msg.sender];
169         delete _lockedBalances[msg.sender];
170 
171         _totalLockedBalance -= amount;
172 
173         require(_rhem.transfer(msg.sender, amount));
174 
175         return true;
176     }
177 
178     /**
179      * @dev Release beneficiary's locked balance
180      */
181     function releaseBalanceFrom(address _beneficiary) public onlyOwner returns(bool success) {
182         require(!_isLocked);
183         require(_lockedBalances[_beneficiary] > 0);
184 
185         uint256 amount = _lockedBalances[_beneficiary];
186         delete _lockedBalances[_beneficiary];
187 
188         _totalLockedBalance -= amount;
189 
190         require(_rhem.transfer(_beneficiary, amount));
191 
192         return true;
193     }
194 
195     /**
196      * @dev Release beneficiaries' locked balance
197      */
198     function releaseBalancesFrom(address[] _beneficiaries) public onlyOwner returns(bool success) {
199         require(!_isLocked);
200 
201         uint i = 0;
202 
203         for (i; i < _beneficiaries.length; i++) {
204             releaseBalanceFrom(_beneficiaries[i]);
205         }
206 
207         return true;
208     }
209 }