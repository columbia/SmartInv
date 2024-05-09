1 pragma solidity ^0.5.0;
2 
3 
4 contract IOwnable {
5 
6     address public owner;
7     address public newOwner;
8 
9     event OwnerChanged(address _oldOwner, address _newOwner);
10 
11     function changeOwner(address _newOwner) public;
12     function acceptOwnership() public;
13 }
14 
15 contract Ownable is IOwnable {
16 
17     modifier onlyOwner() {
18         require(msg.sender == owner);
19         _;
20     }
21 
22     constructor() public {
23         owner = msg.sender;
24         emit OwnerChanged(address(0), owner);
25     }
26 
27     function changeOwner(address _newOwner) public onlyOwner {
28         newOwner = _newOwner;
29     }
30 
31     function acceptOwnership() public {
32         require(msg.sender == newOwner);
33         emit OwnerChanged(owner, newOwner);
34         owner = newOwner;
35         newOwner = address(0);
36     }
37 }
38 
39 
40 contract IERC20Token {
41     string public name;
42     string public symbol;
43     uint8 public decimals;
44     uint256 public totalSupply;
45 
46     function balanceOf(address _owner) public view returns (uint256 balance);
47     function transfer(address _to, uint256 _value)  public returns (bool success);
48     function transferFrom(address _from, address _to, uint256 _value)  public returns (bool success);
49     function approve(address _spender, uint256 _value)  public returns (bool success);
50     function allowance(address _owner, address _spender)  public view returns (uint256 remaining);
51 
52     event Transfer(address indexed _from, address indexed _to, uint256 _value);
53     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
54 }
55 
56 
57 contract IWinbixToken is IERC20Token {
58 
59     uint256 public votableTotal;
60     uint256 public accruableTotal;
61     address public issuer;
62     bool public transferAllowed;
63 
64     mapping (address => bool) public isPayable;
65 
66     event SetIssuer(address _address);
67     event TransferAllowed(bool _newState);
68     event FreezeWallet(address _address);
69     event UnfreezeWallet(address _address);
70     event IssueTokens(address indexed _to, uint256 _value);
71     event IssueVotable(address indexed _to, uint256 _value);
72     event IssueAccruable(address indexed _to, uint256 _value);
73     event BurnTokens(address indexed _from, uint256 _value);
74     event BurnVotable(address indexed _from, uint256 _value);
75     event BurnAccruable(address indexed _from, uint256 _value);
76     event SetPayable(address _address, bool _state);
77 
78     function setIssuer(address _address) public;
79     function allowTransfer(bool _allowTransfer) public;
80     function freeze(address _address) public;
81     function unfreeze(address _address) public;
82     function isFrozen(address _address) public returns (bool);
83     function issue(address _to, uint256 _value) public;
84     function issueVotable(address _to, uint256 _value) public;
85     function issueAccruable(address _to, uint256 _value) public;
86     function votableBalanceOf(address _address) public view returns (uint256);
87     function accruableBalanceOf(address _address) public view returns (uint256);
88     function burn(uint256 _value) public;
89     function burnAll() public;
90     function increaseApproval(address _spender, uint256 _addedValue) public returns (bool);
91     function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool);
92     function setMePayable(bool _state) public;
93 }
94 
95 contract ITap is IOwnable {
96 
97     uint8[12] public tapPercents = [2, 2, 3, 11, 11, 17, 11, 11, 8, 8, 8, 8];
98     uint8 public nextTapNum;
99     uint8 public nextTapPercent = tapPercents[nextTapNum];
100     uint public nextTapDate;
101     uint public remainsForTap;
102     uint public baseEther;
103 
104     function init(uint _baseEther, uint _startDate) public;
105     function changeNextTap(uint8 _newPercent) public;
106     function getNext() public returns (uint);
107     function subRemainsForTap(uint _delta) public;
108 }
109 
110 contract IRefund is IOwnable {
111     
112     ITap public tap;
113     uint public refundedTokens;
114     uint public tokensBase;
115 
116     function init(uint _tokensBase, address _tap, uint _startDate) public;
117     function refundEther(uint _value) public returns (uint);
118     function calculateEtherForRefund(uint _tokensAmount) public view returns (uint);
119 }
120 
121 contract Refund is IRefund, Ownable {
122 
123     uint startDate;
124 
125     function init(uint _tokensBase, address _tap, uint _startDate) public onlyOwner {
126         tap = ITap(_tap);
127         tokensBase = _tokensBase;
128         startDate = _startDate;
129     }
130 
131     function refundEther(uint _value) public onlyOwner returns (uint) {
132         uint etherForRefund = calculateEtherForRefund(_value);
133         refundedTokens += _value;
134         return etherForRefund;
135     }
136 
137     function calculateEtherForRefund(uint _tokensAmount) public view returns (uint) {
138         require(startDate > 0 && now > startDate && tokensBase > 0);
139         uint etherRemains = tap.remainsForTap();
140         if (_tokensAmount == 0 || etherRemains == 0) {
141             return 0;
142         }
143 
144         uint etherForRefund;
145 
146         uint startPart = refundedTokens + 1;
147         uint endValue = refundedTokens + _tokensAmount;
148         require(endValue <= tokensBase);
149 
150         uint refundCoeff;
151         uint nextStart;
152         uint endPart;
153         uint partTokensValue;
154         uint tokensRemains = tokensBase - refundedTokens;
155 
156         while (true) {
157             refundCoeff = _refundCoeff(startPart);
158             nextStart = _nextStart(refundCoeff);
159             endPart = nextStart - 1;
160             if (endPart > endValue) endPart = endValue;
161             partTokensValue = endPart - startPart + 1;
162             etherForRefund += refundCoeff * (etherRemains - etherForRefund) * partTokensValue / tokensRemains / 100;
163             if (nextStart > endValue) break;
164             startPart = nextStart;
165             tokensRemains -= partTokensValue;
166         }
167         return etherForRefund;
168     }
169 
170     function _refundCoeff(uint _tokensValue) private view returns (uint) {
171         uint refundedPercent = 100 * _tokensValue / tokensBase;
172         if (refundedPercent < 10) {
173             return 80;
174         } else if (refundedPercent < 20) {
175             return 85;
176         } else if (refundedPercent < 30) {
177             return 90;
178         } else if (refundedPercent < 40) {
179             return 95;
180         } else {
181             return 100;
182         }
183     }
184 
185     function _nextStart(uint _refundCoefficient) private view returns (uint) {
186         uint res;
187         if (_refundCoefficient == 80) {
188             res = tokensBase * 10 / 100;
189         } else if (_refundCoefficient == 85) {
190             res = tokensBase * 20 / 100;
191         } else if (_refundCoefficient == 90) {
192             res = tokensBase * 30 / 100;
193         } else if (_refundCoefficient == 95) {
194             res = tokensBase * 40 / 100;
195         } else {
196             return tokensBase+1;
197         }
198         if (_refundCoeff(res) == _refundCoefficient) res += 1;
199         return res;
200     }
201 }