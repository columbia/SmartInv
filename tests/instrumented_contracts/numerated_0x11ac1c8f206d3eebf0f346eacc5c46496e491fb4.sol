1 /*! payment_processor.sol | (c) 2018 Develop by BelovITLab LLC (smartcontract.ru), author @stupidlovejoy | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 library SafeMath {
6     function mul(uint256 a, uint256 b) internal pure returns(uint256) {
7         if(a == 0) return 0;
8 
9         uint256 c = a * b;
10         require(c / a == b, "NaN");
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns(uint256) {
15         require(b > 0, "NaN");
16         uint256 c = a / b;
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns(uint256) {
21         require(b <= a, "NaN");
22         uint256 c = a - b;
23         return c;
24     }
25 
26     function add(uint256 a, uint256 b) internal pure returns(uint256) {
27         uint256 c = a + b;
28         require(c >= a, "NaN");
29         return c;
30     }
31 
32     function mod(uint256 a, uint256 b) internal pure returns(uint256) {
33         require(b != 0, "NaN");
34         return a % b;
35     }
36 }
37 
38 contract Ownable {
39     address private _owner;
40 
41     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43     constructor() internal {
44         _owner = msg.sender;
45 
46         emit OwnershipTransferred(address(0), _owner);
47     }
48 
49     function owner() public view returns(address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(isOwner(), "Access denied");
55         _;
56     }
57 
58     function isOwner() public view returns(bool) {
59         return msg.sender == _owner;
60     }
61 
62     function renounceOwnership() public onlyOwner {
63         emit OwnershipTransferred(_owner, address(0));
64 
65         _owner = address(0);
66     }
67 
68     function transferOwnership(address newOwner) public onlyOwner {
69         _transferOwnership(newOwner);
70     }
71 
72     function _transferOwnership(address newOwner) internal {
73         require(newOwner != address(0), "Zero address");
74 
75         emit OwnershipTransferred(_owner, newOwner);
76 
77         _owner = newOwner;
78     }
79 }
80 
81 contract PaymentProcessor is Ownable {
82     using SafeMath for uint;
83 
84     uint public commission = 10;
85     address public recepient = 0x0000000000000000000000000000000000000000;      // при деплое надо указать получателя
86     uint public min_payment = 0.001 ether;
87 
88     mapping(address => uint) public buyers;
89 
90     event NewCommission(uint previousCommission, uint newCommission);
91     event NewRecepient(address previousRecepient, address newRecepient);
92     event NewMinPayment(uint previousMinPayment, uint newMinPayment);
93     event Payment(address indexed submiter, address indexed recepient, address indexed middleman, uint amount, uint commission);
94 
95     function() payable public {
96         require(msg.value >= min_payment, "Too small amount");
97 
98         address middleman = bytesToAddress(msg.data);
99 
100         require(middleman != address(0), "Zero address middleman");
101         require(middleman == recepient || buyers[middleman] > 0, "The mediator did not make purchases");
102 
103         uint com = msg.value.mul(commission).div(100);
104         uint value = msg.value.sub(com);
105 
106         recepient.transfer(value);
107         middleman.transfer(com);
108 
109         buyers[msg.sender] = buyers[msg.sender].add(msg.value);
110 
111         emit Payment(msg.sender, recepient, middleman, value, com);
112     }
113 
114     function bytesToAddress(bytes bys) pure private returns(address addr) {
115         assembly {
116             addr := mload(add(bys, 20))
117         }
118     }
119 
120     function setCommission(uint new_commission) onlyOwner public {
121         emit NewCommission(commission, new_commission);
122 
123         commission = new_commission;
124     }
125 
126     function setRecepient(address new_recepient) onlyOwner public {
127         require(new_recepient != address(0), "Zero address");
128 
129         emit NewRecepient(recepient, new_recepient);
130 
131         recepient = new_recepient;
132     }
133 
134     function setMinPayment(uint new_min_payment) onlyOwner public {
135         emit NewMinPayment(min_payment, new_min_payment);
136 
137         min_payment = new_min_payment;
138     }
139 }