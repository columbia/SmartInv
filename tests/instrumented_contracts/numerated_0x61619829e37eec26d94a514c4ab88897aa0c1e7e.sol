1 pragma solidity 0.4.18;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a * b;
11         assert(a == 0 || c / a == b);
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal pure returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
23         assert(b <= a);
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         assert(c >= a);
30         return c;
31     }
32 }
33 
34 
35 contract TelcoinSaleCapEscrow {
36     using SafeMath for uint256;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     event WalletChanged(address indexed previousWallet, address indexed newWallet);
40     event ValuePlaced(address indexed purchaser, address indexed beneficiary, uint256 amount);
41     event Approved(address indexed participant, uint256 amount);
42     event Rejected(address indexed participant);
43     event Closed();
44 
45     /// The owner of the contract.
46     address public owner;
47 
48     /// The wallet that will receive funds on approval after the token
49     /// sale's  registerAltPurchase() has been called.
50     address public wallet;
51 
52     /// Whether the escrow has closed.
53     bool public closed = false;
54 
55     /// The amount of wei deposited by each participant. This value
56     /// can change with new deposits, approvals and rejections.
57     mapping(address => uint256) public deposited;
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     modifier escrowOpen() {
65         require(!closed);
66         _;
67     }
68 
69     function TelcoinSaleCapEscrow(address _wallet) public payable {
70         require(msg.value > 0);
71         require(_wallet != address(0));
72 
73         owner = msg.sender;
74         wallet = _wallet;
75 
76         wallet.transfer(msg.value);
77     }
78 
79     function () public payable {
80         placeValue(msg.sender);
81     }
82 
83     /// By the time approve() is called by the owner, a matching call for
84     /// registerAltPurchase(_participant, "ETH", tx.id, _weiAmount) shall
85     /// have been called in the main token sale.
86     function approve(address _participant, uint256 _weiAmount) onlyOwner public {
87         uint256 depositedAmount = deposited[_participant];
88         require(depositedAmount > 0);
89         require(_weiAmount <= depositedAmount);
90 
91         deposited[_participant] = depositedAmount.sub(_weiAmount);
92         Approved(_participant, _weiAmount);
93         wallet.transfer(_weiAmount);
94     }
95 
96     function approveMany(address[] _participants, uint256[] _weiAmounts) onlyOwner public {
97         require(_participants.length == _weiAmounts.length);
98 
99         for (uint256 i = 0; i < _participants.length; i++) {
100             approve(_participants[i], _weiAmounts[i]);
101         }
102     }
103 
104     function changeWallet(address _wallet) onlyOwner public payable {
105         require(_wallet != 0x0);
106         require(msg.value > 0);
107 
108         WalletChanged(wallet, _wallet);
109         wallet = _wallet;
110         wallet.transfer(msg.value);
111     }
112 
113     function close() onlyOwner public {
114         require(!closed);
115 
116         closed = true;
117         Closed();
118     }
119 
120     function placeValue(address _beneficiary) escrowOpen public payable {
121         require(_beneficiary != address(0));
122 
123         uint256 weiAmount = msg.value;
124         require(weiAmount > 0);
125 
126         uint256 newDeposited = deposited[_beneficiary].add(weiAmount);
127         deposited[_beneficiary] = newDeposited;
128 
129         ValuePlaced(
130             msg.sender,
131             _beneficiary,
132             weiAmount
133         );
134     }
135 
136     function reject(address _participant) onlyOwner public {
137         uint256 weiAmount = deposited[_participant];
138         require(weiAmount > 0);
139 
140         deposited[_participant] = 0;
141         Rejected(_participant);
142         require(_participant.call.value(weiAmount)());
143     }
144 
145     function rejectMany(address[] _participants) onlyOwner public {
146         for (uint256 i = 0; i < _participants.length; i++) {
147             reject(_participants[i]);
148         }
149     }
150 
151     function transferOwnership(address _to) onlyOwner public {
152         require(_to != address(0));
153         OwnershipTransferred(owner, _to);
154         owner = _to;
155     }
156 }