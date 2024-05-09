1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10     address public owner;
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     function Ownable() {
18         owner = msg.sender;
19     }
20 
21     /**
22      * @dev Throws if called by any account other than the owner.
23      */
24     modifier onlyOwner() {
25         require(msg.sender == owner);
26         _;
27     }
28 
29     /**
30      * @dev Allows the current owner to transfer control of the contract to a newOwner.
31      * @param newOwner The address to transfer ownership to.
32      */
33     function transferOwnership(address newOwner) onlyOwner public {
34         require(newOwner != address(0));
35         OwnershipTransferred(owner, newOwner);
36         owner = newOwner;
37     }
38 
39 }
40 
41 
42 
43 
44 
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52         uint256 c = a * b;
53         if (a != 0 && c / a != b) revert();
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal constant returns (uint256) {
58         // assert(b > 0); // Solidity automatically throws when dividing by 0
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61         return c;
62     }
63 
64     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
65         if (b > a) revert();
66         return a - b;
67     }
68 
69     function add(uint256 a, uint256 b) internal constant returns (uint256) {
70         uint256 c = a + b;
71         if (c < a) revert();
72         return c;
73     }
74 }
75 
76 
77 
78 /*
79  * !!!IMPORTANT!!!
80  * Based on Open Zeppelin Refund Vault contract
81  * https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/crowdsale/RefundVault.sol
82  * the only thing that differs is a hardcoded wallet address
83  */
84 
85 /**
86  * @title RefundVault.
87  * @dev This contract is used for storing funds while a crowdsale
88  * is in progress. Supports refunding the money if crowdsale fails,
89  * and forwarding it if crowdsale is successful.
90  */
91 contract VLBRefundVault is Ownable {
92     using SafeMath for uint256;
93 
94     enum State {Active, Refunding, Closed}
95     State public state;
96 
97     mapping (address => uint256) public deposited;
98 
99     address public constant wallet = 0x02D408bc203921646ECA69b555524DF3c7f3a8d7;
100 
101     address crowdsaleContractAddress;
102 
103     event Closed();
104     event RefundsEnabled();
105     event Refunded(address indexed beneficiary, uint256 weiAmount);
106 
107     function VLBRefundVault() {
108         state = State.Active;
109     }
110 
111     modifier onlyCrowdsaleContract() {
112         require(msg.sender == crowdsaleContractAddress);
113         _;
114     }
115 
116     function setCrowdsaleAddress(address _crowdsaleAddress) external onlyOwner {
117         require(_crowdsaleAddress != address(0));
118         crowdsaleContractAddress = _crowdsaleAddress;
119     }
120 
121     function deposit(address investor) onlyCrowdsaleContract external payable {
122         require(state == State.Active);
123         deposited[investor] = deposited[investor].add(msg.value);
124     }
125 
126     function close(address _wingsWallet) onlyCrowdsaleContract external {
127         require(_wingsWallet != address(0));
128         require(state == State.Active);
129         state = State.Closed;
130         Closed();
131         uint256 wingsReward = this.balance.div(100);
132         _wingsWallet.transfer(wingsReward);
133         wallet.transfer(this.balance);
134     }
135 
136     function enableRefunds() onlyCrowdsaleContract external {
137         require(state == State.Active);
138         state = State.Refunding;
139         RefundsEnabled();
140     }
141 
142     function refund(address investor) public {
143         require(state == State.Refunding);
144         uint256 depositedValue = deposited[investor];
145         deposited[investor] = 0;
146         investor.transfer(depositedValue);
147         Refunded(investor, depositedValue);
148     }
149 
150     /**
151      * @dev killer method that can bu used by owner to
152      *      kill the contract and send funds to owner
153      */
154     function kill() onlyOwner {
155         require(state == State.Closed);
156         selfdestruct(owner);
157     }
158 }