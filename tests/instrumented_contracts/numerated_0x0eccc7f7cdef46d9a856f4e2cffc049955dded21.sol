1 pragma solidity ^0.5.0;
2 /*
3  * @title: SafeMath
4  * @dev: Helper contract functions to arithmatic operations safely.
5  */
6 
7 library SafeMath {
8 
9     function add(uint256 a, uint256 b) internal pure returns (uint256) {
10         uint256 c = a + b;
11         require(c >= a, "SafeMath: addition overflow");
12 
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         require(b <= a, "SafeMath: subtraction overflow");
18         uint256 c = a - b;
19 
20         return c;
21     }
22 
23 }
24 
25  /*
26  * @title: Token
27  * @dev: Interface contract for ERC20 tokens
28  */
29 contract Token {
30     function totalSupply() public view returns (uint256 supply);
31 
32     function balanceOf(address _owner) public view returns (uint256 balance);
33 
34     function transfer(address _to, uint256 _value)
35         public
36         returns (bool success);
37 
38     function transferFrom(
39         address _from,
40         address _to,
41         uint256 _value
42     ) public returns (bool success);
43 
44     function approve(address _spender, uint256 _value)
45         public
46         returns (bool success);
47 
48     function allowance(address _owner, address _spender)
49         public
50         view
51         returns (uint256 remaining);
52     
53     function burn(uint256 amount) public;
54 
55     event Transfer(address indexed _from, address indexed _to, uint256 _value);
56     event Approval(
57         address indexed _owner,
58         address indexed _spender,
59         uint256 _value
60     );
61 }
62 
63 
64 contract TokenSwapBridge {
65     using SafeMath for uint256;
66 
67     constructor() public {
68         owner = msg.sender;
69         paused = false;
70     }
71     
72     event SwapKAI(address _from, address _addr, uint256 _amount);
73     address constant KAI_ADDRESS = 0xD9Ec3ff1f8be459Bb9369b4E79e9Ebcf7141C093;
74 
75     address private owner;
76     address[] public depositors;
77     bool public paused;
78     mapping (address => uint256) public amount;
79 
80     // Functions with this modifier can only be executed by the owner
81     modifier onlyOwner() {
82         require(msg.sender == owner);
83         _;
84     }
85     
86     function swapKAI(address _toAddress,  uint256 _amount) public {
87         require(paused == false, "SwapToken paused");
88         require(Token(KAI_ADDRESS).transferFrom(msg.sender, address(this), _amount));
89         
90         if (amount[_toAddress] == 0) {
91             depositors.push(_toAddress);
92         }
93         
94         amount[_toAddress] += _amount;
95         
96         emit SwapKAI(msg.sender, _toAddress, _amount);
97     }
98     
99     function burnKAI() public onlyOwner {
100         Token(KAI_ADDRESS).burn(getBalanceKAIContract());
101     }
102     
103     function getBalanceKAIContract() public view returns (uint256) {
104         return Token(KAI_ADDRESS).balanceOf(address(this));
105     }
106 
107     function setPause() public onlyOwner {
108         paused = true;
109     }
110     
111     function setUnpause() public onlyOwner {
112         paused = false;
113     }
114     
115     function getDepositors() public view returns (address[] memory) {
116         return depositors;
117     }
118     
119     function emergencyWithdrawalKAI(uint256 _amount) public onlyOwner {
120         Token(KAI_ADDRESS).transfer(msg.sender, _amount);
121     }  
122 }