1 pragma solidity ^0.5.10;
2 
3 
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11     /**
12      * @dev Multiplies two numbers, throws on overflow.
13      */
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15         if (a == 0) {
16             
17             return 0;
18         }
19         uint256 c = a * b;
20         assert(c / a == b);
21         return c;
22     }
23 
24     /**
25      * @dev Integer division of two numbers, truncating the quotient.
26      */
27     function div(uint256 a, uint256 b) internal pure returns (uint256) {
28         // assert(b > 0); // Solidity automatically throws when dividing by 0
29         uint256 c = a / b;
30         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31         return c;
32     }
33 
34     /**
35      * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36      */
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     /**
43      * @dev Adds two numbers, throws on overflow.
44      */
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         assert(c >= a);
48         return c;
49     }
50 }
51 contract Ownable {
52    address payable public owner;
53 
54    event OwnershipTransferred(address indexed _from, address indexed _to);
55 
56    constructor() public {
57        owner = msg.sender;
58    }
59 
60    modifier onlyOwner {
61        require(msg.sender == owner);
62        _;
63    }
64 
65    function transferOwnership(address payable _newOwner) public onlyOwner {
66        owner = _newOwner;
67    }
68 }
69 
70 
71 contract Pausable is Ownable{
72  
73     bool private _paused = false;
74 
75   
76   
77 
78     /**
79      * @dev Returns true if the contract is paused, and false otherwise.
80      */
81     function paused() public view returns (bool) {
82         return _paused;
83     }
84 
85     /**
86      * @dev Modifier to make a function callable only when the contract is not paused.
87      */
88     modifier whenNotPaused() {
89         require(!_paused, "Pausable: paused");
90         _;
91     }
92 
93     /**
94      * @dev Modifier to make a function callable only when the contract is paused.
95      */
96     modifier whenPaused() {
97         require(_paused, "Pausable: not paused");
98         _;
99     }
100 
101     /**
102      * @dev Called by a pauser to pause, triggers stopped state.
103      */
104     function pause() public onlyOwner whenNotPaused {
105         _paused = true;
106     }
107 
108     /**
109      * @dev Called by a pauser to unpause, returns to normal state.
110      */
111     function unpause() public onlyOwner whenPaused {
112         _paused = false;
113     }
114 }
115 
116 contract ERC20 {
117     function totalSupply() public view returns (uint256);
118     function balanceOf(address who) public view returns (uint256);
119     function transfer(address to, uint256 value) public returns (bool);
120     function allowance(address owner, address spender) public view returns (uint256);
121     function transferFrom(address from, address to, uint256 value) public returns (bool);
122     function approve(address spender, uint256 value) public returns (bool);
123     event Transfer(address indexed from, address indexed to, uint256 value);
124     event Approval(address indexed owner, address indexed spender, uint256 value);
125 }
126 
127     
128 contract TokenSwap is Ownable ,Pausable  {
129     
130     using SafeMath for uint256;
131     ERC20 public oldToken;
132     ERC20 public newToken;
133 
134     address ownerAddress = 0x202Abc6cF98863ee0126C182CA325a33A867ACbA;
135 
136     constructor (address _oldToken , address _newToken ) public {
137         oldToken = ERC20(_oldToken);
138         newToken = ERC20(_newToken);
139     
140     }
141     
142     function swapTokens() public whenNotPaused{
143         uint tokenAllowance = oldToken.allowance(msg.sender, address(this));
144         require(tokenAllowance>0 , "token allowence is");
145         require(newToken.balanceOf(address(this)) >= tokenAllowance , "not enough balance");
146         oldToken.transferFrom(msg.sender,ownerAddress, tokenAllowance);
147         newToken.transfer(msg.sender, tokenAllowance);
148 
149     }
150     
151 
152     function kill() public onlyOwner {
153     selfdestruct(msg.sender);
154   }
155   
156       /**
157      * @dev Return all tokens back to owner, in case any were accidentally
158      *   transferred to this contract.
159      */
160     function returnNewTokens() public onlyOwner whenNotPaused {
161         newToken.transfer(owner, newToken.balanceOf(address(this)));
162     }
163     
164        
165     
166       /**
167      * @dev Return all tokens back to owner, in case any were accidentally
168      *   transferred to this contract.
169      */
170     function returnOldTokens() public onlyOwner whenNotPaused {
171         oldToken.transfer(owner, oldToken.balanceOf(address(this)));
172     }
173     
174     
175 }