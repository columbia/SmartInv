1 pragma solidity ^0.4.15;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     // uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return a / b;
30   }
31 
32   /**
33   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 // HODL YOUR COINS HERE!! THE SAFEST WALLET!!
51 
52 contract HODLWallet {
53     using SafeMath for uint256;
54     
55     address internal owner;
56     mapping(address => uint256) public balances;
57     mapping(address => uint256) public withdrawalCount;
58     mapping(address => mapping(address => bool)) public approvals;
59     
60     uint256 public constant MAX_WITHDRAWAL = 0.002 * 1000000000000000000;
61 
62     modifier onlyOwner() {
63         require(msg.sender == owner);
64         _;
65     }
66 
67     function HODLWallet(address[] addrs, uint256[] _balances) public payable {
68         require(addrs.length == _balances.length);
69         
70         owner = msg.sender;
71         
72         for (uint256 i = 0; i < addrs.length; i++) {
73             balances[addrs[i]] = _balances[i];
74             withdrawalCount[addrs[i]] = 0;
75         }
76     }
77 
78     function doWithdraw(address from, address to, uint256 amount) internal {
79         // only use in emergencies!
80         // you can only get a little at a time.
81         // we will hodl the rest for you.
82         
83         require(amount <= MAX_WITHDRAWAL);
84         require(balances[from] >= amount);
85         require(withdrawalCount[from] < 3);
86 
87         balances[from] = balances[from].sub(amount);
88 
89         to.call.value(amount)();
90 
91         withdrawalCount[from] = withdrawalCount[from].add(1);
92     }
93     
94     function () payable public{
95         deposit();
96     }
97 
98     function doDeposit(address to) internal {
99         require(msg.value > 0);
100         
101         balances[to] = balances[to].add(msg.value);
102     }
103     
104     function deposit() payable public {
105         // deposit as much as you want, my dudes
106         doDeposit(msg.sender);
107     }
108     
109     function depositTo(address to) payable public {
110         // you can even deposit for someone else!
111         doDeposit(to);
112     }
113     
114     function withdraw(uint256 amount) public {
115         doWithdraw(msg.sender, msg.sender, amount);
116     }
117     
118     function withdrawTo(address to, uint256 amount) public {
119         doWithdraw(msg.sender, to, amount);
120     }
121     
122     function withdrawFor(address from, uint256 amount) public {
123         require(approvals[from][msg.sender]);
124         doWithdraw(from, msg.sender, amount);
125     }
126     
127     function withdrawForTo(address from, address to, uint256 amount) public {
128         require(approvals[from][msg.sender]);
129         doWithdraw(from, to, amount);
130     }
131     
132     function destroy() public onlyOwner {
133         // we will withdraw for you when we think it's time to stop HODLing
134         // probably in two weeks or so after moon and/or lambo
135         
136         selfdestruct(owner);
137     }
138     
139     function getBalance(address toCheck) public constant returns (uint256) {
140         return balances[toCheck];
141     }
142     
143     function addBalances(address[] addrs, uint256[] _balances) public payable onlyOwner {
144         // in case more idio^H^H^H^HHODLers want to join
145         
146         require(addrs.length == _balances.length);
147         for (uint256 i = 0; i < addrs.length; i++) {
148             balances[addrs[i]] = _balances[i];
149             withdrawalCount[addrs[i]] = 0;
150         }
151     }
152     
153     function approve(address toApprove) public {
154         // in case you want to do your business from other addresses
155         
156         require(balances[msg.sender] > 0);
157         
158         approvals[msg.sender][toApprove] = true;
159     }
160     
161     function unapprove(address toUnapprove) public {
162         // in case trusting that address was a bad idea
163         
164         require(balances[msg.sender] > 0);
165         
166         approvals[msg.sender][toUnapprove] = false;
167     }
168 }