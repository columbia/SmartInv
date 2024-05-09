1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9         uint256 c = a * b;
10         assert(a == 0 || c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 /**
31  * @title Owned
32  * @dev Ownership model
33  */
34 contract Owned {
35     address public owner;
36 
37     event OwnershipTransfered(address indexed owner);
38 
39     function Owned() public {
40         owner = msg.sender;
41     }
42 
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47 
48     function transferOwnership(address newOwner) onlyOwner public {
49         owner = newOwner;
50         OwnershipTransfered(owner);
51     }
52 }
53 
54 /**
55  * @title ERC20Token
56  * @dev Interface for erc20 standard
57  */
58 contract ERC20Token {
59 
60     using SafeMath for uint256;
61 
62     string public constant name = "Mithril Token";
63     string public constant symbol = "MITH";
64     uint8 public constant decimals = 18;
65     uint256 public totalSupply;
66 
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowance;
69 
70     event Transfer(address indexed from, address indexed to, uint256 value);
71     event Approval(address indexed from, uint256 value, address indexed to, bytes extraData);
72 
73     function ERC20Token() public {
74     }
75 
76     /**
77      * Internal transfer, only can be called by this contract
78      */
79     function _transfer(address from, address to, uint256 value) internal {
80         // Check if the sender has enough balance
81         require(balanceOf[from] >= value);
82 
83         // Check for overflow
84         require(balanceOf[to] + value > balanceOf[to]);
85 
86         // Save this for an amount double check assertion
87         uint256 previousBalances = balanceOf[from].add(balanceOf[to]);
88 
89         balanceOf[from] = balanceOf[from].sub(value);
90         balanceOf[to] = balanceOf[to].add(value);
91 
92         Transfer(from, to, value);
93 
94         // Asserts for duplicate check. Should never fail.
95         assert(balanceOf[from].add(balanceOf[to]) == previousBalances);
96     }
97 
98     /**
99      * Transfer tokens
100      *
101      * Send `value` tokens to `to` from your account
102      *
103      * @param to The address of the recipient
104      * @param value the amount to send
105      */
106     function transfer(address to, uint256 value) public {
107         _transfer(msg.sender, to, value);
108     }
109 
110     /**
111      * Transfer tokens from other address
112      *
113      * Send `value` tokens to `to` in behalf of `from`
114      *
115      * @param from The address of the sender
116      * @param to The address of the recipient
117      * @param value the amount to send
118      */
119     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
120         require(value <= allowance[from][msg.sender]);
121         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
122         _transfer(from, to, value);
123         return true;
124     }
125 
126     /**
127      * Set allowance for other address
128      *
129      * Allows `spender` to spend no more than `value` tokens in your behalf
130      *
131      * @param spender The address authorized to spend
132      * @param value the max amount they can spend
133      * @param extraData some extra information to send to the approved contract
134      */
135     function approve(address spender, uint256 value, bytes extraData) public returns (bool success) {
136         allowance[msg.sender][spender] = value;
137         Approval(msg.sender, value, spender, extraData);
138         return true;
139     }
140 }
141 
142 /**
143  * @title MithrilToken
144  * @dev MithrilToken
145  */
146 contract MithrilToken is Owned, ERC20Token {
147 
148     // Address where funds are collected.
149     address public vault;
150 
151     function MithrilToken() public {
152     }
153 
154     function init(uint256 _supply, address _vault) public onlyOwner {
155         require(vault == 0x0);
156         require(_vault != 0x0);
157 
158         totalSupply = _supply;
159         vault = _vault;
160         balanceOf[vault] = totalSupply;
161     }
162 
163     function () payable public {
164     }
165 }