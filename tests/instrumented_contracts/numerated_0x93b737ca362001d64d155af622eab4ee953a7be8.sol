1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
9         assert(a >= b);
10         return a - b;
11     }
12     function add(uint256 a, uint256 b) internal pure returns (uint256) {
13         uint256 c = a + b;
14         assert(c >= a);
15         return c;
16     }
17 }
18 
19 /**
20  * @title Owned
21  * @dev Ownership model
22  */
23 contract Owned {
24     address public owner;
25 
26     event OwnershipTransfered(address indexed owner);
27 
28     constructor() public {
29         owner = msg.sender;
30         emit OwnershipTransfered(owner);
31     }
32 
33     modifier onlyOwner {
34         require(msg.sender == owner);
35         _;
36     }
37 
38     function transferOwnership(address newOwner) onlyOwner public {
39         owner = newOwner;
40         emit OwnershipTransfered(owner);
41     }
42 }
43 
44 /**
45  * @title ERC20Token
46  * @dev Interface for erc20 standard
47  */
48 contract ERC20Token {
49     using SafeMath for uint256;
50 
51     string public constant name = "Ansforce Network Token";
52     string public constant symbol = "ANT";
53     uint8 public constant decimals = 18;
54     uint256 public totalSupply = 0;
55 
56     mapping (address => uint256) public balanceOf;
57     mapping (address => mapping (address => uint256)) public allowance;
58 
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed from, uint256 value, address indexed to, bytes extraData);
61 
62     constructor() public {
63     }
64 
65     /**
66      * Internal transfer, only can be called by this contract
67      */
68     function _transfer(address from, address to, uint256 value) internal {
69         // Check if the sender has enough balance
70         require(balanceOf[from] >= value);
71 
72         // Check for overflow
73         require(balanceOf[to] + value > balanceOf[to]);
74 
75         // Save this for an amount double check assertion
76         uint256 previousBalances = balanceOf[from].add(balanceOf[to]);
77 
78         balanceOf[from] = balanceOf[from].sub(value);
79         balanceOf[to] = balanceOf[to].add(value);
80 
81         emit Transfer(from, to, value);
82 
83         // Asserts for duplicate check. Should never fail.
84         assert(balanceOf[from].add(balanceOf[to]) == previousBalances);
85     }
86 
87     /**
88      * Transfer tokens
89      *
90      * Send `value` tokens to `to` from your account
91      *
92      * @param to The address of the recipient
93      * @param value the amount to send
94      */
95     function transfer(address to, uint256 value) public {
96         _transfer(msg.sender, to, value);
97     }
98 
99     /**
100      * Transfer tokens from other address
101      *
102      * Send `value` tokens to `to` in behalf of `from`
103      *
104      * @param from The address of the sender
105      * @param to The address of the recipient
106      * @param value the amount to send
107      */
108     function transferFrom(address from, address to, uint256 value) public returns (bool success) {
109         require(value <= allowance[from][msg.sender]);
110         allowance[from][msg.sender] = allowance[from][msg.sender].sub(value);
111         _transfer(from, to, value);
112         return true;
113     }
114 
115     /**
116      * Set allowance for other address
117      *
118      * Allows `spender` to spend no more than `value` tokens in your behalf
119      *
120      * @param spender The address authorized to spend
121      * @param value the max amount they can spend
122      * @param extraData some extra information to send to the approved contract
123      */
124     function approve(address spender, uint256 value, bytes extraData) public returns (bool success) {
125         allowance[msg.sender][spender] = value;
126         emit Approval(msg.sender, value, spender, extraData);
127         return true;
128     }
129 }
130 
131 
132 contract AnsforceNetworkToken is Owned, ERC20Token {
133     constructor() public {
134     }
135     
136     function init(uint256 _supply, address _vault) public onlyOwner {
137         require(totalSupply == 0);
138         require(_supply > 0);
139         require(_vault != address(0));
140         totalSupply = _supply;
141         balanceOf[_vault] = totalSupply;
142     }
143     
144     
145     bool public stopped = false;
146     
147     modifier isRunning {
148         require (!stopped);
149         _;
150     }
151     
152     function transfer(address to, uint256 value) isRunning public {
153         ERC20Token.transfer(to, value);
154     }
155     
156     function stop() public onlyOwner {
157         stopped = true;
158     }
159 
160     function start() public onlyOwner {
161         stopped = false;
162     }
163     
164     
165     mapping (address => uint256) public freezeOf;
166     
167     /* This notifies clients about the amount frozen */
168     event Freeze(address indexed target, uint256 value);
169 
170     /* This notifies clients about the amount unfrozen */
171     event Unfreeze(address indexed target, uint256 value);
172     
173     function freeze(address target, uint256 _value) public onlyOwner returns (bool success) {
174         require( _value > 0 );
175         balanceOf[target] = SafeMath.sub(balanceOf[target], _value);
176         freezeOf[target] = SafeMath.add(freezeOf[target], _value);
177         emit Freeze(target, _value);
178         return true;
179     }
180 
181     function unfreeze(address target, uint256 _value) public onlyOwner returns (bool success) {
182         require( _value > 0 );
183         freezeOf[target] = SafeMath.sub(freezeOf[target], _value);
184         balanceOf[target] = SafeMath.add(balanceOf[target], _value);
185         emit Unfreeze(target, _value);
186         return true;
187     }
188 }