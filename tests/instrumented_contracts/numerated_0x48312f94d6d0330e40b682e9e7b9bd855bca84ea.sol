1 pragma solidity ^0.5.10;
2 
3 // ----------------------------------------------------------------------------
4 // Safe maths
5 // ----------------------------------------------------------------------------
6 library SafeMath {
7     function add(uint a, uint b) internal pure returns (uint c) {
8         c = a + b;
9         require(c >= a, "Add error");
10     }
11     function sub(uint a, uint b) internal pure returns (uint c) {
12         require(b <= a, "Sub error");
13         c = a - b;
14     }
15     function mul(uint a, uint b) internal pure returns (uint c) {
16         c = a * b;
17         require(a == 0 || c / a == b, "Mul error");
18     }
19     function div(uint a, uint b) internal pure returns (uint c) {
20         require(b > 0, "Div error");
21         c = a / b;
22     }
23 }
24 
25 // ----------------------------------------------------------------------------
26 // ERC Token Standard #20 Interface
27 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
28 // ----------------------------------------------------------------------------
29 contract ERC20 {
30     function totalSupply() external returns (uint);
31     function balanceOf(address tokenOwner) external returns (uint balance);
32     function allowance(address tokenOwner, address spender) external returns (uint remaining);
33     function transfer(address to, uint tokens) external returns (bool success);
34     function approve(address spender, uint tokens) external returns (bool success);
35     function transferFrom(address from, address to, uint tokens) external returns (bool success);
36 
37     event Transfer(address indexed from, address indexed to, uint tokens);
38     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
39 }
40 
41 // ----------------------------------------------------------------------------
42 // Owned contract
43 // ----------------------------------------------------------------------------
44 contract Owned {
45     address public owner;
46     address public newOwner;
47 
48     event OwnershipTransferred(address indexed _from, address indexed _to);
49 
50     constructor() public {
51         owner = msg.sender;
52     }
53 
54     modifier onlyOwner {
55         require(msg.sender == owner);
56         _;
57     }
58 
59     function transferOwnership(address _newOwner) public onlyOwner {
60         newOwner = _newOwner;
61     }
62     function acceptOwnership() public {
63         require(msg.sender == newOwner);
64         emit OwnershipTransferred(owner, newOwner);
65         owner = newOwner;
66         newOwner = address(0);
67     }
68 }
69 
70 // ----------------------------------------------------------------------------
71 // Airdropper contract
72 // ----------------------------------------------------------------------------
73 contract Airdropper is Owned {
74     using SafeMath for uint;
75 
76     ERC20 public token;
77 
78     /**
79      * @dev Constructor.
80      * @param tokenAddress Address of the token contract.
81      */
82     constructor(address tokenAddress) public {
83         token = ERC20(tokenAddress);
84     }
85     
86      /**
87       * @dev Airdrop.
88       * @ !important Before using, send needed token amount to this contract
89       */
90     function airdrop(address[] memory dests, uint[] memory values) public onlyOwner {
91         // This simple validation will catch most mistakes without consuming
92         // too much gas.
93         require(dests.length == values.length);
94 
95         for (uint256 i = 0; i < dests.length; i++) {
96             token.transfer(dests[i], values[i]);
97         }
98     }
99 
100     /**
101      * @dev Return all tokens back to owner, in case any were accidentally
102      *   transferred to this contract.
103      */
104     function returnTokens() public onlyOwner {
105         token.transfer(owner, token.balanceOf(address(this)));
106     }
107 
108     /**
109      * @dev Destroy this contract and recover any ether to the owner.
110      */
111     function destroy() public onlyOwner {
112         selfdestruct(msg.sender);
113     }
114 }