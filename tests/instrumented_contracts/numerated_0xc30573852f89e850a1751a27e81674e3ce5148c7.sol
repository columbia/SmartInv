1 pragma solidity ^0.4.25;
2 //CONTRACT BUILD ALPHA_01
3 
4 contract Ownable {
5     address public owner;
6 
7     constructor() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner, "Is not owner");
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0), "Invalid address");
18         emit OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 }
24 
25 library SafeMath {
26     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27         if (a == 0) {
28             return 0;
29         }
30         uint256 c = a * b;
31         assert(c / a == b);
32         return c;
33     }
34 
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         // assert(b > 0); // Solidity automatically throws when dividing by 0
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         assert(b <= a);
44         return a - b;
45     }
46 
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         assert(c >= a);
50         return c;
51     }
52 }
53 
54 contract WhiteList is Ownable {
55 
56     mapping(address => address) whiteList;
57 
58     constructor() public {
59         whiteList[msg.sender] = msg.sender;
60     }
61 
62     function add(address who) public onlyOwner() {
63         require(who != address(0), "Invalid address");
64         whiteList[who] = who;
65     }
66 
67     function remove(address who) public onlyOwner() {
68         require(who != address(0), "Invalid address");
69         delete whiteList[who];
70     }
71 
72     function isWhiteListed(address who) public view returns (bool) {
73         return whiteList[who] != address(0);
74     }
75 }
76 
77 // import "./Ownable.sol";
78 // import "./SafeMath.sol";
79 // import "./WhiteList.sol";
80 
81 contract Sh8pe is Ownable, WhiteList {
82     using SafeMath for uint;
83 
84     string public name;
85     string public symbol;
86     uint8 public decimals;
87     uint256 public totalSupply;
88 
89     mapping (address => uint256) balances;
90     mapping (address => mapping (address => uint256)) allowed;
91 
92     constructor () public {
93 
94         name = "Angel Token";
95         symbol = "Angels";
96         decimals = 18;
97         totalSupply = 100000000;
98 
99         balances[msg.sender] = totalSupply;
100         emit Transfer(this, msg.sender, totalSupply);
101     }
102 
103     function balanceOf(address who) public view returns (uint256) {
104         return balances[who];
105     }
106 
107     //THIS IS A FUNCTION USED BE THE MASTER WALLET TO TRANSFER FUNDS BETWEEN ACCOUNTS ON THE NETWORK
108     function transfer(address from, address to, uint256 value) public returns (bool) {
109         require(isWhiteListed(msg.sender) == true, "Not white listed");
110         require(balances[from] >= value, "Insufficient balance"); //CHECK IF FROM ADDRESS HAS ENOUGH BALANCE
111 
112         balances[from] = balances[from].sub(value); //SUB FROM SENDING ADDRESS
113         balances[to] = balances[to].add(value); //ADD TO OTHER ADDRESS
114 
115         emit Transfer(msg.sender, to, value);
116         return true;
117     }
118 
119     event Approval(address indexed owner, address indexed spender, uint256 value);
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 }