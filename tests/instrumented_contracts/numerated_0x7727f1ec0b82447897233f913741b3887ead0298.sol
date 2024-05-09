1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         // assert(b > 0); // Solidity automatically throws when dividing by 0
12         uint256 c = a / b;
13         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract Ownable {
30   address public owner;
31 
32 
33   /** 
34    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
35    * account.
36    */
37   constructor () public{
38     owner = msg.sender;
39   }
40 
41 
42   /**
43    * @dev Throws if called by any account other than the owner. 
44    */
45   modifier onlyOwner() {
46     require(owner==msg.sender);
47     _;
48  }
49 
50   /**
51    * @dev Allows the current owner to transfer control of the contract to a newOwner.
52    * @param newOwner The address to transfer ownership to. 
53    */
54   function transferOwnership(address newOwner) public onlyOwner {
55       owner = newOwner;
56   }
57  
58 }
59   
60 contract ERC20 {
61 
62     function totalSupply() public returns (uint256);
63     function balanceOf(address who) public returns (uint256);
64     function transfer(address to, uint256 value) public returns (bool success);
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Approval(address indexed owner, address indexed spender, uint256 value);
68 
69 }
70 
71 contract BTNYToken is Ownable, ERC20 {
72 
73     using SafeMath for uint256;
74 
75     // Token properties
76     string public name = "Bitney";                //Token name
77     string public symbol = "BTNY";                  //Token symbol
78     uint256 public decimals = 18;
79 
80     uint256 public _totalSupply = 1000000000e18;
81 
82     // Balances for each account
83     mapping (address => uint256) balances;
84 
85     // Owner of account approves the transfer of an amount to another account
86     mapping (address => mapping(address => uint256)) allowed;
87 
88     // Wallet Address of Token
89     address public multisig;
90 
91     constructor () public payable {
92         // Initial Owner Wallet Address
93         multisig = msg.sender;
94 
95         balances[multisig] = _totalSupply;
96 
97         owner = msg.sender;
98     }
99 
100     function withdraw(address to, uint256 value) public onlyOwner {
101         require(to != 0x0);
102         uint256 transferValue = value.mul(10e18);
103         to.transfer(transferValue);
104         emit Transfer(owner, to, transferValue);
105     }
106 
107     function () external payable {
108         tokensale(msg.sender);
109     }
110 
111     function tokensale(address recipient) public payable {
112         require(recipient != 0x0);
113     }
114 
115     function totalSupply() public returns (uint256) {
116         return _totalSupply;
117     }
118 
119     function balanceOf(address who) public returns (uint256) {
120         return balances[who];
121     }
122 
123     function transfer(address to, uint256 value) public returns (bool success)  {
124         uint256 transferValue = value.mul(1e18);
125         require (balances[msg.sender] >= transferValue && transferValue > 0);
126 
127         balances[msg.sender] = balances[msg.sender].sub(transferValue);
128         balances[to] = balances[to].add(transferValue);
129         emit Transfer(msg.sender, to, transferValue);
130         return true;
131     }
132 }