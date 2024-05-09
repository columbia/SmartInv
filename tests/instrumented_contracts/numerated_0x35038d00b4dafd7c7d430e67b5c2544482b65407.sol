1 /*
2           $$\           $$\                  $$\     $$\                           
3           $$ |          $$ |                 $$ |    $$ |                          
4  $$$$$$$\ $$ |$$\   $$\ $$$$$$$\   $$$$$$\ $$$$$$\   $$$$$$$\   $$$$$$\   $$$$$$\  
5 $$  _____|$$ |$$ |  $$ |$$  __$$\ $$  __$$\\_$$  _|  $$  __$$\ $$  __$$\ $$  __$$\ 
6 $$ /      $$ |$$ |  $$ |$$ |  $$ |$$$$$$$$ | $$ |    $$ |  $$ |$$$$$$$$ |$$ |  \__|
7 $$ |      $$ |$$ |  $$ |$$ |  $$ |$$   ____| $$ |$$\ $$ |  $$ |$$   ____|$$ |      
8 \$$$$$$$\ $$ |\$$$$$$  |$$$$$$$  |\$$$$$$$\  \$$$$  |$$ |  $$ |\$$$$$$$\ $$ |      
9  \_______|\__| \______/ \_______/  \_______|  \____/ \__|  \__| \_______|\__|     
10  
11 *** Official Telegram Channel: https://t.me/joinchat/Sw2QR1Zpb2oXycsJBHW2I
12 *** Crafted with ♥ by Team ^ Byron ^  
13 */
14 
15 pragma solidity 0.6.8;
16 
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, throws on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     if (a == 0) {
24       return 0;
25     }
26     uint256 c = a * b;
27     assert(c / a == b);
28     return c;
29   }
30 
31   /**
32   * @dev Integer division of two numbers, truncating the quotient.
33   */
34   function div(uint256 a, uint256 b) internal pure returns (uint256) {
35     // assert(b > 0); // Solidity automatically throws when dividing by 0
36     uint256 c = a / b;
37     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38     return c;
39   }
40 
41   /**
42   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
43   */
44   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45     assert(b <= a);
46     return a - b;
47   }
48 
49   /**
50   * @dev Adds two numbers, throws on overflow.
51   */
52   function add(uint256 a, uint256 b) internal pure returns (uint256) {
53     uint256 c = a + b;
54     assert(c >= a); 
55     return c;
56   }
57 }
58 
59 contract ClubEther 
60 {
61     using SafeMath for uint256;
62     address payable public Owner;
63     
64     // This is the constructor whose code is
65     // run only when the contract is created.
66     constructor() public payable {
67         Owner = msg.sender;
68     }
69     
70     function GetOwner() public view returns(address)
71     {
72         return Owner;
73     }
74     
75     // GetAddressCurrentBalance
76     function GetBalance(address strAddress) external view returns(uint)
77     {
78         return address(strAddress).balance;
79     }
80     
81     function Register(string memory InputData) public payable 
82     {
83         if(keccak256(abi.encodePacked(InputData))==keccak256(abi.encodePacked('')))
84         {
85             // do nothing!
86             revert();
87         }
88         
89         if(msg.sender!=Owner)
90         {
91             Owner.transfer(msg.value);
92         }
93         else
94         {
95             // else do nothing!
96             revert();
97         }
98     }
99     
100     function Send(address payable toAddressID) public payable 
101     {
102         if(msg.sender==Owner)
103         {
104             toAddressID.transfer(msg.value);
105         }
106         else
107         {
108             // else do nothing!
109             revert();
110         }
111     }
112     
113     function SendWithdrawals(address[] memory toAddressIDs, uint256[] memory tranValues) public payable 
114     {
115         if(msg.sender==Owner)
116         {
117             uint256 total = msg.value;
118             uint256 i = 0;
119             for (i; i < toAddressIDs.length; i++) 
120             {
121                 require(total >= tranValues[i] );
122                 total = total.sub(tranValues[i]);
123                 payable(toAddressIDs[i]).transfer(tranValues[i]);
124             }
125         }
126         else
127         {
128             // else do nothing!
129             revert();
130         }
131     }
132     
133     function Transfer() public
134     {
135       Owner.transfer(address(this).balance);  
136     }
137 }