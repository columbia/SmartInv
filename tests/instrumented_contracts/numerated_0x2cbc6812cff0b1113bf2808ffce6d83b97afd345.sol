1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9     function mul(uint256 a, uint256 b) internal constant returns (uint256) {
10         uint256 c = a * b;
11         if (a != 0 && c / a != b) revert();
12         return c;
13     }
14 
15     function div(uint256 a, uint256 b) internal constant returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21 
22     function sub(uint256 a, uint256 b) internal constant returns (uint256) {
23         if (b > a) revert();
24         return a - b;
25     }
26 
27     function add(uint256 a, uint256 b) internal constant returns (uint256) {
28         uint256 c = a + b;
29         if (c < a) revert();
30         return c;
31     }
32 }
33 contract Ownable {
34     address public owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     /**
38      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
39      * account.
40      */
41     function Ownable() {
42         owner = msg.sender;
43     }
44 
45     /**
46      * @dev Throws if called by any account other than the owner.
47      */
48     modifier onlyOwner() {
49         require(msg.sender == owner);
50         _;
51     }
52 
53     /**
54      * @dev Allows the current owner to transfer control of the contract to a newOwner.
55      * @param newOwner The address to transfer ownership to.
56      */
57     function transferOwnership(address newOwner) onlyOwner public {
58         require(newOwner != address(0));
59         OwnershipTransferred(owner, newOwner);
60         owner = newOwner;
61     }
62 
63 }
64 contract VLBRefundVault is Ownable {
65     using SafeMath for uint256;
66 
67     enum State {Active, Refunding, Closed}
68     State public state;
69 
70     mapping (address => uint256) public deposited;
71 
72     address public wallet;
73 
74     event Closed();
75     event FundsDrained(uint256 weiAmount);
76     event RefundsEnabled();
77     event Refunded(address indexed beneficiary, uint256 weiAmount);
78 
79     function VLBRefundVault(address _wallet) public {
80         require(_wallet != address(0));
81         wallet = _wallet;
82         state = State.Active;
83     }
84 
85     function deposit(address investor) onlyOwner public payable {
86         require(state == State.Active);
87         deposited[investor] = deposited[investor].add(msg.value);
88     }
89 
90     function unhold() onlyOwner public {
91         require(state == State.Active);
92         FundsDrained(this.balance);
93         wallet.transfer(this.balance);
94     }
95 
96     function close() onlyOwner public {
97         require(state == State.Active);
98         state = State.Closed;
99         Closed();
100         FundsDrained(this.balance);
101         wallet.transfer(this.balance);
102     }
103 
104     function enableRefunds() onlyOwner public {
105         require(state == State.Active);
106         state = State.Refunding;
107         RefundsEnabled();
108     }
109 
110     function refund(address investor) public {
111         require(state == State.Refunding);
112         uint256 depositedValue = deposited[investor];
113         deposited[investor] = 0;
114         investor.transfer(depositedValue);
115         Refunded(investor, depositedValue);
116     }
117 }