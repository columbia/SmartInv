1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         assert(b <= a);
11         return a - b;
12     }
13 
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         assert(c >= a);
17         return c;
18     }
19 }
20 
21 /**
22  * @title Owned
23  * @dev Ownership model
24  */
25 contract Owned {
26     address public owner;
27 
28     event OwnershipTransfered(address indexed owner);
29 
30     function Owned() public {
31         owner = msg.sender;
32     }
33 
34     modifier onlyOwner {
35         require(msg.sender == owner);
36         _;
37     }
38 
39     function transferOwnership(address newOwner) onlyOwner public {
40         owner = newOwner;
41         OwnershipTransfered(owner);
42     }
43 }
44 
45 /**
46  * @title ERC20Token
47  * @dev Interface for erc20 standard
48  */
49 contract ERC20Token {
50 
51     using SafeMath for uint256;
52 
53     string public constant name = "Mithril Token";
54     string public constant symbol = "MITH";
55     uint8 public constant decimals = 18;
56     uint256 public totalSupply;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed from, uint256 value, address indexed to, bytes extraData);
63 
64     function ERC20Token() public {
65     }
66 
67     /**
68      * Internal transfer, only can be called by this contract
69      */
70     function _transfer(address from, address to, uint256 value) internal {
71         // Check if the sender has enough balance
72         require(balanceOf[from] >= value);
73 
74         // Check for overflow
75         require(balanceOf[to] + value > balanceOf[to]);
76 
77         // Save this for an amount double check assertion
78         uint256 previousBalances = balanceOf[from].add(balanceOf[to]);
79 
80         balanceOf[from] = balanceOf[from].sub(value);
81         balanceOf[to] = balanceOf[to].add(value);
82 
83         Transfer(from, to, value);
84 
85         // Asserts for duplicate check. Should never fail.
86         assert(balanceOf[from].add(balanceOf[to]) == previousBalances);
87     }
88 
89     /**
90      * Transfer tokens
91      *
92      * Send `value` tokens to `to` from your account
93      *
94      * @param to The address of the recipient
95      * @param value the amount to send
96      */
97     function transfer(address to, uint256 value) public {
98         _transfer(msg.sender, to, value);
99     }
100 
101     /**
102      * Transfer tokens from other address
103      *
104      * Send `value` tokens to `to` in behalf of `from`
105      *
106      * @param from The address of the sender
107      * @param to The address of the recipient
108      * @param value the amount to send
109      */
110     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
111         require(value <= allowance[from][msg.sender]);
112         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
113         _transfer(from, to, value);
114         return true;
115     }
116 
117     /**
118      * Set allowance for other address
119      *
120      * Allows `spender` to spend no more than `value` tokens in your behalf
121      *
122      * @param spender The address authorized to spend
123      * @param value the max amount they can spend
124      * @param extraData some extra information to send to the approved contract
125      */
126     function approve(address spender, uint256 value, bytes extraData) public returns (bool success) {
127         allowance[msg.sender][spender] = value;
128         Approval(msg.sender, value, spender, extraData);
129         return true;
130     }
131 }
132 
133 /**
134  * @title MithrilToken
135  * @dev MithrilToken
136  */
137 contract MithrilToken is Owned, ERC20Token {
138 
139     // Address where funds are collected.
140     address public vault;
141     address public wallet;
142 
143     function MithrilToken() public {
144     }
145 
146     function init(uint256 _supply, address _vault, address _wallet) public onlyOwner {
147         require(vault == 0x0);
148         require(_vault != 0x0);
149 
150         totalSupply = _supply;
151         vault = _vault;
152         wallet = _wallet;
153         balanceOf[vault] = totalSupply;
154     }
155 
156     function () payable public {
157         wallet.transfer(msg.value);
158     }
159 }