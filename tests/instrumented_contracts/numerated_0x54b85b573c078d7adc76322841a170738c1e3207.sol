1 pragma solidity 0.4.24;
2 /**
3  * @title ERC20 Interface
4  */
5 contract ERC20 {
6     function totalSupply() public view returns (uint256);
7     function balanceOf(address who) public view returns (uint256);
8     function transfer(address to, uint256 value) public returns (bool);
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 
11     function allowance(address owner, address spender) public view returns (uint256);
12     function transferFrom(address from, address to, uint256 value) public returns (bool);
13     function approve(address spender, uint256 value) public returns (bool);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23     /**
24     * @dev Multiplies two numbers, throws on overflow.
25     */
26     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
27     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
28     // benefit is lost if 'b' is also tested.
29     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
30         if (a == 0) {
31             return 0;
32         }
33 
34         c = a * b;
35         assert(c / a == b);
36         return c;
37     }
38 
39     /**
40     * @dev Integer division of two numbers, truncating the quotient.
41     */
42     function div(uint256 a, uint256 b) internal pure returns (uint256) {
43         // assert(b > 0); // Solidity automatically throws when dividing by 0
44         // uint256 c = a / b;
45         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46         return a / b;
47     }
48 
49     /**
50     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51     */
52     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53         assert(b <= a);
54         return a - b;
55     }
56 
57     /**
58     * @dev Adds two numbers, throws on overflow.
59     */
60     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61         c = a + b;
62         assert(c >= a);
63         return c;
64     }
65 }
66 
67 /**
68  * @title SwapToken
69  */
70 contract  SwapToken{
71     using SafeMath for uint256;
72     ERC20 public oldToken;
73     ERC20 public newToken;
74     address public tokenOwner;
75 
76     address public owner;
77     bool public swap_able;
78     bool public setup_token;
79 
80     event Swap(address sender, uint256 amount);
81     event SwapAble(bool swapable);
82 
83     modifier isOwner() {
84         require (msg.sender == owner);
85         _;
86     }
87 
88     modifier isSwap() {
89         require (swap_able);
90         _;
91     }
92 
93     modifier isNotSetup() {
94         require (!setup_token);
95         _;
96     }
97 
98     constructor()
99     public
100     {
101         owner = msg.sender;
102         swap_able = false;
103     }
104 
105     function setupToken(address _oldToken, address _newToken, address _tokenOwner)
106     public
107     isNotSetup
108     isOwner
109     {
110         require(_oldToken != 0 && _newToken != 0 && _tokenOwner != 0);
111         oldToken = ERC20(_oldToken);
112         newToken = ERC20(_newToken);
113         tokenOwner = _tokenOwner;
114         setup_token = true;
115     }
116 
117     function swapAble(bool _swap_able)
118     public
119     isOwner
120     {
121         swap_able = _swap_able;
122         emit SwapAble(_swap_able);
123     }
124 
125     function withdrawOldToken(address to, uint256 amount)
126     public
127     isOwner
128     returns (bool success)
129     {
130         require(oldToken.transfer(to, amount));
131         return true;
132     }
133 
134     function swapAbleToken()
135     public
136     view
137     returns (uint256)
138     {
139         return newToken.allowance(tokenOwner, this);
140     }
141 
142     function swapToken(uint256 amount)
143     public
144     isSwap
145     returns (bool success)
146     {
147         require(newToken.allowance(tokenOwner, this) >= amount);
148         require(oldToken.transferFrom(msg.sender, this, amount));
149         require(newToken.transferFrom(tokenOwner, msg.sender, amount));
150         emit Swap(msg.sender, amount);
151         return true;
152     }
153 }