1 pragma solidity ^0.4.15;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   uint256 public totalSupply;
10   function balanceOf(address who) public constant returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title ERC20 interface
17  * @dev see https://github.com/ethereum/EIPs/issues/20
18  */
19 contract ERC20 is ERC20Basic {
20   function allowance(address owner, address spender) public constant returns (uint256);
21   function transferFrom(address from, address to, uint256 value) public returns (bool);
22   function approve(address spender, uint256 value) public returns (bool);
23   event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 /**
26  * @title SafeMath
27  * @dev Math operations with safety checks that throw on error
28  */
29 library SafeMath {
30   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
31     uint256 c = a * b;
32     assert(a == 0 || c / a == b);
33     return c;
34   }
35 
36   function div(uint256 a, uint256 b) internal constant returns (uint256) {
37     // assert(b > 0); // Solidity automatically throws when dividing by 0
38     uint256 c = a / b;
39     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
40     return c;
41   }
42 
43   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
44     assert(b <= a);
45     return a - b;
46   }
47 
48   function add(uint256 a, uint256 b) internal constant returns (uint256) {
49     uint256 c = a + b;
50     assert(c >= a);
51     return c;
52   }
53 }
54 
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Ownable {
61   address public owner;
62 
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66 
67   /**
68    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
69    * account.
70    */
71   function Ownable() {
72     owner = msg.sender;
73   }
74 
75 
76   /**
77    * @dev Throws if called by any account other than the owner.
78    */
79   modifier onlyOwner() {
80     require(msg.sender == owner);
81     _;
82   }
83 
84 
85   /**
86    * @dev Allows the current owner to transfer control of the contract to a newOwner.
87    * @param newOwner The address to transfer ownership to.
88    */
89   function transferOwnership(address newOwner) onlyOwner public {
90     require(newOwner != address(0));
91     OwnershipTransferred(owner, newOwner);
92     owner = newOwner;
93   }
94 
95 }
96 
97 contract ClaimableTokens is Ownable {
98 
99     address public claimedTokensWallet;
100 
101     function ClaimableTokens(address targetWallet) {
102         claimedTokensWallet = targetWallet;
103     }
104 
105     function claimTokens(address tokenAddress) public onlyOwner {
106         require(tokenAddress != 0x0);
107         ERC20 claimedToken = ERC20(tokenAddress);
108         uint balance = claimedToken.balanceOf(this);
109         claimedToken.transfer(claimedTokensWallet, balance);
110     }
111 }
112 
113 contract CromToken is Ownable, ERC20, ClaimableTokens {
114     using SafeMath for uint256;
115     string public constant name = "CROM Token";
116     string public constant symbol = "CROM";
117     uint8 public constant decimals = 0;
118     uint256 public constant INITIAL_SUPPLY = 10 ** 7;
119     mapping (address => uint256) internal balances;
120     mapping (address => mapping (address => uint256)) internal allowed;
121 
122     function CromToken() Ownable() ClaimableTokens(msg.sender) {
123         totalSupply = INITIAL_SUPPLY;
124         balances[msg.sender] = totalSupply;
125     }
126 
127     function transfer(address to, uint256 value) public returns (bool success) {
128         require(to != 0x0);
129         require(balances[msg.sender] >= value);
130         balances[msg.sender] = balances[msg.sender].sub(value);
131         balances[to] = balances[to].add(value);
132         Transfer(msg.sender, to, value);
133         return true;
134     }
135 
136     function approve(address spender, uint256 value) public returns (bool success) {
137         allowed[msg.sender][spender] = value;
138         Approval(msg.sender, spender, value);
139         return true;
140     }
141 
142     function allowance(address owner, address spender) public constant returns (uint256 remaining) {
143         return allowed[owner][spender];
144     }
145 
146     function balanceOf(address who) public constant returns (uint256) {
147         return balances[who];
148     }
149 
150     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
151         require(to != 0x0);
152         require(balances[from] >= value);
153         require(value <= allowed[from][msg.sender]);
154         balances[from] = balances[from].sub(value);
155         balances[to] = balances[to].add(value);
156         allowed[from][msg.sender] = allowed[from][msg.sender].sub(value);
157         Transfer(from, to, value);
158         return true;
159     }
160 }