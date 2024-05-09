1 pragma solidity 0.4.26;
2 
3 library SafeMath {
4     
5     function add(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a + b;
7         require(c >= a, "SafeMath: addition overflow");
8 
9         return c;
10     }
11     
12     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
13         return sub(a, b, "SafeMath: subtraction overflow");
14     }
15     
16     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
17         require(b <= a, errorMessage);
18         uint256 c = a - b;
19 
20         return c;
21     }
22     
23     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24         if (a == 0) {
25             return 0;
26         }
27 
28         uint256 c = a * b;
29         require(c / a == b, "SafeMath: multiplication overflow");
30 
31         return c;
32     }
33 
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         return div(a, b, "SafeMath: division by zero");
36     }
37     
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         return c;
42     }
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         return mod(a, b, "SafeMath: modulo by zero");
45     }
46     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b != 0, errorMessage);
48         return a % b;
49     }
50 }
51 
52 contract EParadise {
53     
54   address private owner; 
55   address insuranceAddr = address(0x84152212d2c139300A3271B86aE1F27c95645360);
56   address teamAddr = address(0x83db40eE5A3C1bbdf30a392201d8cA0A9BdBC13b);
57   address saintAddr = address(0xA028822B0425e61AF155f089cB6837deEffaddf1);
58    
59   struct Account {
60         address user;
61         uint256 depositTotal;
62         uint256 creditBalance;
63     }
64    
65   mapping (address => Account) public accounts;
66    
67   constructor() public {
68         owner = msg.sender;
69     }
70     
71    
72   modifier isRegister(address _user) {
73         require(accounts[_user].user!=address(0), "Address not register!");
74         _;
75     }
76    
77   modifier onlyOwner() {
78         require(msg.sender == owner, "Caller is not owner");
79         _;
80   }
81     
82   function doInvest() public payable {
83     
84     if (accounts[msg.sender].user != 0) {
85         accounts[msg.sender].depositTotal += msg.value;
86         
87     }
88     else {
89         accounts[msg.sender].user = msg.sender;
90         accounts[msg.sender].depositTotal = msg.value;
91     }
92     
93     sendFee(msg.value);
94   }
95   
96   function sendFee(uint amount) private {
97         
98         uint256 c = amount * 10 / 100;
99         saintAddr.transfer(c);
100         
101         c = amount * 2 / 100;
102         insuranceAddr.transfer(c);
103         
104         c = amount * 5 / 100;
105         teamAddr.transfer(c);
106   }
107   
108   function sendRewards(address _user,uint256 amount) public onlyOwner returns(bool) {
109         if(_user==address(0)){
110             _user=owner;
111         }
112         
113         accounts[_user].creditBalance += amount;
114         return true;
115   }
116   
117   function getBalance(address _user) public view returns (uint256 balance, uint256 depositTotal) {
118      balance = accounts[_user].creditBalance;
119      depositTotal = accounts[_user].depositTotal;
120   }
121   
122   function WithdrawReward() public payable {
123      if(address(this).balance > accounts[msg.sender].creditBalance){
124         msg.sender.transfer(accounts[msg.sender].creditBalance);
125         accounts[msg.sender].creditBalance=0;
126     }
127   }
128   
129   function getTime() public view returns(uint256) {
130     return block.timestamp; 
131   }
132   
133 }