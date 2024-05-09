1 // CCS TOKEN AIRDROP
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 interface IERC20 {
8     
9     function totalSupply() external view returns (uint256);
10     function balanceOf(address account) external view returns (uint256);
11     function transfer(address recipient, uint256 amount) external returns (bool);
12     function allowance(address owner, address spender) external view returns (uint256);
13     function approve(address spender, uint256 amount) external returns (bool);
14     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 library SafeMath {
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         require(c >= a, "SafeMath: addition overflow");
24         return c;
25     }
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         require(b <= a, "SafeMath: subtraction overflow");
29         uint256 c = a - b;
30         return c;
31     }
32 
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         if (a == 0) {
35             return 0;
36         }
37 
38         uint256 c = a * b;
39         require(c / a == b, "SafeMath: multiplication overflow");
40         return c;
41     }
42 
43     function div(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b > 0, "SafeMath: division by zero");
45         uint256 c = a / b;
46         return c;
47     }
48 
49 }
50 
51 
52 contract Ownable   {
53     address public _owner;
54 
55     event OwnershipTransferred(
56         address indexed previousOwner,
57         address indexed newOwner
58     );
59 
60    
61 
62     constructor()  {
63         _owner = msg.sender;
64 
65         emit OwnershipTransferred(address(0), _owner);
66     }
67 
68       function owner() public view returns (address) {
69         return _owner;
70     }
71 
72      modifier onlyOwner() {
73         require(_owner == msg.sender, "Ownable: caller is not the owner");
74 
75         _;
76     }
77 
78     /**
79 
80      * @dev Transfers ownership of the contract to a new account (newOwner).
81 
82      * Can only be called by the current owner.
83 
84      */
85 
86     function transferOwnership(address newOwner) public onlyOwner {
87         require(
88             newOwner != address(0),
89             "Ownable: new owner is the zero address"
90         );
91 
92         emit OwnershipTransferred(_owner, newOwner);
93 
94         _owner = newOwner;
95     }
96 }
97 
98 contract CCSAirdrop is Ownable {
99     
100      using SafeMath for uint256;
101     mapping(address => bool) public processedAirdrops;
102     mapping(address => bool) public whitelisted;
103     bool public whitelist = false;
104     uint256 public decimal = 10e0;
105     uint256 public airdropAmount = 1;
106     IERC20 public tokenAddress;
107     
108    event AirdropProcessed(
109     address recipient,
110     uint amount,
111     uint date
112   );
113     
114     
115     constructor(IERC20 _token)  
116     {
117         tokenAddress = _token;
118     }
119 
120 
121     function whitelistAddress(address[] memory _recipients) public onlyOwner returns (bool) {
122         require(_recipients.length <= 100); 
123         for (uint i = 0; i < _recipients.length; i++) {
124             whitelisted[_recipients[i]] = true;
125         }
126         return true;
127     }
128 
129         function airdrop() public  {
130             require(processedAirdrops[msg.sender] == false, 'airdrop already processed');
131             processedAirdrops[msg.sender] = true;
132             tokenAddress.transfer(msg.sender,airdropAmount * decimal);
133             emit AirdropProcessed(
134             msg.sender,
135             airdropAmount * decimal,
136             block.timestamp
137            );
138             address userAdd = msg.sender;
139             if(whitelist){
140             require(whitelisted[userAdd],"User is not Whitelisted");
141              }
142 
143         }
144 
145      function CheckContractBalance() public view  returns(uint256)
146     {
147         return  address(this).balance;
148     }
149  
150      function withdrawToken(uint256 amount) public onlyOwner 
151     {
152         require(amount >= 0 , "not have Balance");
153         tokenAddress.transfer(msg.sender,  amount);
154     }
155 
156          function withdrawaBNB(uint256 amount) public onlyOwner 
157     {
158         payable(msg.sender).transfer(amount);
159     }
160 
161 
162     function turnWhitelist() public onlyOwner returns (bool success)  {
163         if (whitelist) {
164             whitelist = false;
165         } else {
166             whitelist = true;
167         }
168         return true;
169         
170     }
171 
172     //Owner only Function
173      function changeToken(address newToken) public onlyOwner  {
174         tokenAddress= IERC20(newToken);
175         
176     }
177 
178     function changeDecimal(uint256 newDecimal) public onlyOwner {
179        decimal = newDecimal;
180 
181     }
182 
183     function changeAirdropAmount(uint256 newAmount) public onlyOwner {
184         airdropAmount = newAmount;
185     }
186 
187 }