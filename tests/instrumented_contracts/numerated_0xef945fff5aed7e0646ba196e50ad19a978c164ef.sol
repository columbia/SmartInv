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
64 contract TokenSwapPhase2 {
65     using SafeMath for uint256;
66 
67     constructor() public {
68         owner = msg.sender;
69         isEnd = false;
70     }
71     
72     address constant KAI_ADDRESS = 0xD9Ec3ff1f8be459Bb9369b4E79e9Ebcf7141C093;
73 
74     address private owner;
75     address[] public depositors;
76     bool public isEnd;
77     mapping (address => uint256) public amount;
78 
79     // Functions with this modifier can only be executed by the owner
80     modifier onlyOwner() {
81         require(msg.sender == owner);
82         _;
83     }
84     
85     function depositKAI(address _toAddress,  uint256 _amount) public {
86         require(isEnd == false, "The campaign is ended");
87         require(Token(KAI_ADDRESS).transferFrom(msg.sender, address(this), _amount));
88         
89         if (amount[_toAddress] == 0) {
90             depositors.push(_toAddress);
91         }
92         
93         amount[_toAddress] += _amount;
94     }
95     
96 
97     function burnKAI() public onlyOwner {
98         Token(KAI_ADDRESS).burn(getBalanceKAIContract());
99     }
100     
101     function getBalanceKAIContract() public view returns (uint256) {
102         return Token(KAI_ADDRESS).balanceOf(address(this));
103     }
104 
105     function setIsEnd() public onlyOwner {
106         isEnd = true;
107     }
108     
109     function getNumberDepositors() public view returns (uint256) {
110         return depositors.length;
111     }
112     
113     function emergencyWithdrawalKAI(uint256 _amount) public onlyOwner {
114         Token(KAI_ADDRESS).transfer(msg.sender, _amount);
115     }  
116 }