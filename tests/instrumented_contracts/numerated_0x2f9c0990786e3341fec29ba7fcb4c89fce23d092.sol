1 pragma solidity ^0.4.21;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10     /**
11     * @dev Multiplies two numbers, throws on overflow.
12     */
13     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14         if (a == 0) {
15             return 0;
16         }
17         uint256 c = a * b;
18         assert(c / a == b);
19         return c;
20     }
21 
22     /**
23     * @dev Integer division of two numbers, truncating the quotient.
24     */
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         // assert(b > 0); // Solidity automatically throws when dividing by 0
27         // uint256 c = a / b;
28         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29         return a / b;
30     }
31 
32     /**
33     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34     */
35     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36         assert(b <= a);
37         return a - b;
38     }
39 
40     /**
41     * @dev Adds two numbers, throws on overflow.
42     */
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 
51 contract Ownable {
52 
53     address public owner;
54 
55     function Ownable() public {
56         owner = msg.sender;
57     }
58 
59     modifier onlyOwner() {
60         require(msg.sender == owner);
61         _;
62     }
63 
64     function transferOwnership(address newOwner) public onlyOwner {
65         require(newOwner != address(0));
66         owner = newOwner;
67     }
68 }
69 
70 interface smartContract {
71     function transfer(address _to, uint256 _value) payable external;
72     function approve(address _spender, uint256 _value) external returns (bool success);
73 }
74 
75 contract Basic is Ownable {
76     using SafeMath for uint256;
77 
78     // This creates an array with all balances
79     mapping(address => uint256) public totalAmount;
80     mapping(address => uint256) public availableAmount;
81     mapping(address => uint256) public withdrawedAmount;
82     uint[] public periods;
83     uint256 public currentPeriod;
84     smartContract public contractAddress;
85     uint256 public ownerWithdrawalDate;
86 
87     // fix for short address attack
88     modifier onlyPayloadSize(uint size) {
89         assert(msg.data.length == size + 4);
90         _;
91     }
92 
93     /**
94      * Constructor function
95      *
96      * transfer tokens to the smart contract here
97      */
98     function Basic(address _contractAddress) public onlyOwner {
99         contractAddress = smartContract(_contractAddress);
100     }
101 
102     function _recalculateAvailable(address _addr) internal {
103         _updateCurrentPeriod();
104         uint256 available;
105         uint256 calcPeriod = currentPeriod + 1;
106         if (calcPeriod < periods.length) {
107             available = totalAmount[_addr].div(periods.length).mul(calcPeriod);
108             //you don't have anything to withdraw
109             require(available > withdrawedAmount[_addr]);
110             //remove already withdrawed tokens
111             available = available.sub(withdrawedAmount[_addr]);
112         } else {
113             available = totalAmount[_addr].sub(withdrawedAmount[_addr]);
114         }
115         availableAmount[_addr] = available;
116     }
117 
118     function addRecipient(address _from, uint256 _amount) external onlyOwner onlyPayloadSize(2 * 32) {
119         require(_from != 0x0);
120         require(totalAmount[_from] == 0);
121         totalAmount[_from] = _amount;
122         availableAmount[_from] = 0;
123         withdrawedAmount[_from] = 0;
124     }
125 
126     function withdraw() public payable {
127         _withdraw(msg.sender);
128     }
129 
130     function _withdraw(address _addr) internal {
131         require(_addr != 0x0);
132         require(totalAmount[_addr] > 0);
133 
134         //Recalculate available balance if time has come
135         _recalculateAvailable(_addr);
136         require(availableAmount[_addr] > 0);
137         uint256 available = availableAmount[_addr];
138         withdrawedAmount[_addr] = withdrawedAmount[_addr].add(available);
139         availableAmount[_addr] = 0;
140 
141         contractAddress.transfer(_addr, available);
142     }
143 
144     function triggerWithdraw(address _addr) public payable onlyOwner {
145         _withdraw(_addr);
146     }
147 
148     // owner may withdraw funds after some period of time
149     function withdrawToOwner(uint256 _amount) external onlyOwner {
150         // no need to create modifier for one case
151         require(now > ownerWithdrawalDate);
152         contractAddress.transfer(msg.sender, _amount);
153     }
154 
155     function _updateCurrentPeriod() internal {
156         require(periods.length >= 1);
157         for (uint i = 0; i < periods.length; i++) {
158             if (periods[i] <= now && i >= currentPeriod) {
159                 currentPeriod = i;
160             }
161         }
162     }
163 }
164 
165 contract Partners is Basic{
166     function Partners(address _contractAddress) Basic(_contractAddress) public {
167         periods = [
168             now + 61 days
169         ];
170         ownerWithdrawalDate = now + 91 days;
171     }
172 }