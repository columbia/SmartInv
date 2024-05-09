1 pragma solidity ^0.4.15;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
6         uint256 c = a * b;
7         if (a != 0 && c / a != b) revert();
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal constant returns (uint256) {
12         // assert(b > 0); // Solidity automatically throws when dividing by 0
13         uint256 c = a / b;
14         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
15         return c;
16     }
17 
18     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
19         if (b > a) revert();
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal constant returns (uint256) {
24         uint256 c = a + b;
25         if (c < a) revert();
26         return c;
27     }
28 }
29 
30 /**
31  * @title Ownable
32  * @dev The Ownable contract has an owner address, and provides basic authorization control
33  * functions, this simplifies the implementation of "user permissions".
34  */
35 contract Ownable {
36     address public owner;
37 
38     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
39     /**
40      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
41      * account.
42      */
43     function Ownable() {
44         owner = msg.sender;
45     }
46 
47     /**
48      * @dev Throws if called by any account other than the owner.
49      */
50     modifier onlyOwner() {
51         require(msg.sender == owner);
52         _;
53     }
54 
55     /**
56      * @dev Allows the current owner to transfer control of the contract to a newOwner.
57      * @param newOwner The address to transfer ownership to.
58      */
59     function transferOwnership(address newOwner) onlyOwner public {
60         require(newOwner != address(0));
61         OwnershipTransferred(owner, newOwner);
62         owner = newOwner;
63     }
64 
65 }
66 
67 /**
68  * @title RefundVault.
69  * @dev This contract is used for storing funds while a crowdsale
70  * is in progress. Supports refunding the money if crowdsale fails,
71  * and forwarding it if crowdsale is successful.
72  */
73 contract IRBPreRefundVault is Ownable {
74     using SafeMath for uint256;
75 
76     enum State {Active, Refunding, Closed}
77     State public state;
78 
79     mapping (address => uint256) public deposited;
80 
81     uint256 public totalDeposited;
82 
83     address public constant wallet = 0x26dB9eF39Bbfe437f5b384c3913E807e5633E7cE;
84 
85     address preCrowdsaleContractAddress;
86 
87     event Closed();
88 
89     event RefundsEnabled();
90 
91     event Refunded(address indexed beneficiary, uint256 weiAmount);
92 
93     event Withdrawal(address indexed receiver, uint256 weiAmount);
94 
95     function IRBPreRefundVault() {
96         state = State.Active;
97     }
98 
99     modifier onlyCrowdsaleContract() {
100         require(msg.sender == preCrowdsaleContractAddress);
101         _;
102     }
103 
104     function setPreCrowdsaleAddress(address _preCrowdsaleAddress) external onlyOwner {
105         require(_preCrowdsaleAddress != address(0));
106         preCrowdsaleContractAddress = _preCrowdsaleAddress;
107     }
108 
109     function deposit(address investor) onlyCrowdsaleContract external payable {
110         require(state == State.Active);
111         uint256 amount = msg.value;
112         deposited[investor] = deposited[investor].add(amount);
113         totalDeposited = totalDeposited.add(amount);
114     }
115 
116     function close() onlyCrowdsaleContract external {
117         require(state == State.Active);
118         state = State.Closed;
119         totalDeposited = 0;
120         Closed();
121         wallet.transfer(this.balance);
122     }
123 
124     function enableRefunds() onlyCrowdsaleContract external {
125         require(state == State.Active);
126         state = State.Refunding;
127         RefundsEnabled();
128     }
129 
130     function refund(address investor) public {
131         require(state == State.Refunding);
132         uint256 depositedValue = deposited[investor];
133         deposited[investor] = 0;
134         investor.transfer(depositedValue);
135         Refunded(investor, depositedValue);
136     }
137 
138     /**
139      * @dev withdraw method that can be used by crowdsale contract's owner
140      *      for the withdrawal funds to the owner
141      */
142     function withdraw(uint value) onlyCrowdsaleContract external returns (bool success) {
143         require(state == State.Active);
144         require(totalDeposited >= value);
145         totalDeposited = totalDeposited.sub(value);
146         wallet.transfer(value);
147         Withdrawal(wallet, value);
148         return true;
149     }
150 
151     /**
152      * @dev killer method that can be used by owner to
153      *      kill the contract and send funds to owner
154      */
155     function kill() onlyOwner {
156         require(state == State.Closed);
157         selfdestruct(owner);
158     }
159 }