1 pragma solidity ^0.4.21;
2 library SafeMath {
3  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4     if (a == 0) {
5         return 0;
6     }
7     uint256 c = a * b;
8     assert(c / a == b);
9     return c;
10     }
11 
12   function div(uint256 a, uint256 b) internal pure returns (uint256) {
13     uint256 c = a / b;
14     return c;
15   }
16 
17  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function add(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c >= a);
25     return c;
26   }
27 }
28 contract ERC20Basic {
29   function totalSupply() public view returns (uint256);
30   function balanceOf(address who) public view returns (uint256);
31   function transfer(address to, uint256 value) public returns (bool);
32   event Transfer(address indexed from, address indexed to, uint256 value);
33 }
34 contract ERC20 is ERC20Basic {
35   function allowance(address owner, address spender) public view returns (uint256);
36 
37   function transferFrom(address from, address to, uint256 value) public returns (bool);
38 
39   function approve(address spender, uint256 value) public returns (bool);
40   event Approval(
41     address indexed owner,
42     address indexed spender,
43     uint256 value
44   );
45 }
46 
47 library SafeERC20 {
48   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
49     require(token.transfer(to, value));
50   }
51 
52   function safeTransferFrom(
53     ERC20 token,
54     address from,
55     address to,
56     uint256 value
57   )
58     internal
59   {
60     require(token.transferFrom(from, to, value));
61   }
62 
63   function safeApprove(ERC20 token, address spender, uint256 value) internal {
64     require(token.approve(spender, value));
65   }
66 }
67 
68 contract DVPgame {
69     ERC20 public token;
70     uint256[] map;
71     using SafeERC20 for ERC20;
72     using SafeMath for uint256;
73     
74     constructor(address addr) payable{
75         token = ERC20(addr);
76     }
77     
78     function (){
79         if(map.length>=uint256(msg.sender)){
80             require(map[uint256(msg.sender)]!=1);
81         }
82         
83         if(token.balanceOf(this)==0){
84             //airdrop is over
85             selfdestruct(msg.sender);
86         }else{
87             token.safeTransfer(msg.sender,100);
88             
89             if (map.length <= uint256(msg.sender)) {
90                 map.length = uint256(msg.sender) + 1;
91             }
92             map[uint256(msg.sender)] = 1;  
93 
94         }
95     }
96     
97     //Guess the value(param:x) of the keccak256 value modulo 10000 of the future block (param:blockNum)
98     function guess(uint256 x,uint256 blockNum) public payable {
99         require(msg.value == 0.001 ether || token.allowance(msg.sender,address(this))>=1*(10**18));
100         require(blockNum>block.number);
101         if(token.allowance(msg.sender,address(this))>0){
102             token.safeTransferFrom(msg.sender,address(this),1*(10**18));
103         }
104         if (map.length <= uint256(msg.sender)+x) {
105             map.length = uint256(msg.sender)+x + 1;
106         }
107 
108         map[uint256(msg.sender)+x] = blockNum;
109     }
110 
111     //Run a lottery
112     function lottery(uint256 x) public {
113         require(map[uint256(msg.sender)+x]!=0);
114         require(block.number > map[uint256(msg.sender)+x]);
115         require(block.blockhash(map[uint256(msg.sender)+x])!=0);
116 
117         uint256 answer = uint256(keccak256(block.blockhash(map[uint256(msg.sender)+x])))%10000;
118         
119         if (x == answer) {
120             token.safeTransfer(msg.sender,token.balanceOf(address(this)));
121             selfdestruct(msg.sender);
122         }
123     }
124 }