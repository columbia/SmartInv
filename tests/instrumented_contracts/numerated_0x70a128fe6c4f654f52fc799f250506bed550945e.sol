1 pragma solidity ^0.4.24;
2 /**
3  * @title ERC20Basic
4  * @dev Simpler version of ERC20 interface
5  * See https://github.com/ethereum/EIPs/issues/179
6  */
7 contract ERC20Basic {
8   function totalSupply() public view returns (uint256);
9   function balanceOf(address who) public view returns (uint256);
10   function transfer(address to, uint256 value) public returns (bool);
11   event Transfer(address indexed from, address indexed to, uint256 value);
12 }
13 /**
14  * @title ERC20 interface
15  * @dev see https://github.com/ethereum/EIPs/issues/20
16  */
17 contract ERC20Interface {
18     function totalSupply() public constant returns (uint);
19     function balanceOf(address tokenOwner) public constant returns (uint balance);
20     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
21     function transfer(address to, uint tokens) public returns (bool success);
22     function approve(address spender, uint tokens) public returns (bool success);
23     function transferFrom(address from, address to, uint tokens) public returns (bool success);
24     event Transfer(address indexed from, address indexed to, uint tokens);
25     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
26 }
27 /** 
28  * Contract function to receive approval and execute function in one call
29  */
30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
32 }
33 /**
34  * @title SafeMath
35  * @dev Math operations with safety checks that throw on error
36  */
37 contract SafeMath {
38     function safeAdd(uint a, uint b) public pure returns (uint c) {
39         c = a + b;
40         require(c >= a);
41     }
42     function safeSub(uint a, uint b) public pure returns (uint c) {
43         require(b <= a);
44         c = a - b;
45     }
46     function safeMul(uint a, uint b) public pure returns (uint c) {
47         c = a * b;
48         require(a == 0 || c / a == b);
49     }
50     function safeDiv(uint a, uint b) public pure returns (uint c) {
51         require(b > 0);
52         c = a / b;
53     }
54 }
55 /**
56  * @title Ownable
57  * @dev The Ownable contract has an owner address, and provides basic authorization control
58  * functions, this simplifies the implementation of "user permissions".
59  */
60 contract Owned {
61     address public owner;
62     address public newOwner;
63     event OwnershipTransferred(address indexed _from, address indexed _to);
64     function Owned() public {
65         owner = msg.sender;
66     }
67     modifier onlyOwner {
68         require(msg.sender == owner);
69         _;
70     }
71     function transferOwnership(address _newOwner) public onlyOwner {
72         newOwner = _newOwner;
73     }
74     function acceptOwnership() public {
75         require(msg.sender == newOwner);
76         emit OwnershipTransferred(owner, newOwner);
77         owner = newOwner;
78         newOwner = address(0);
79     }
80 }
81 contract CpublicGold is ERC20Interface, Owned, SafeMath {
82     string public symbol;
83     string public  name;
84     uint8 public decimals;
85     uint public _totalSupply;
86     mapping(address => uint) balances;
87     mapping(address => mapping(address => uint)) allowed;
88     /**
89      * Constructor
90      */
91     function CpublicGold() public {
92         symbol = "CPG";
93         name = "Cpublic Gold";
94         decimals = 18;
95         _totalSupply = 6000000000000000000000000000;
96         balances[0xA031d2564caf3327d5688cA559dDcF8e6f75C6C3] = _totalSupply;
97         emit Transfer(address(0), 0xA031d2564caf3327d5688cA559dDcF8e6f75C6C3, _totalSupply);
98     }
99     /**
100      * Total supply
101      */
102     function totalSupply() public constant returns (uint) {
103         return _totalSupply  - balances[address(0)];
104     }
105     /**
106      * Get the token balance for account tokenOwner
107      */
108     function balanceOf(address tokenOwner) public constant returns (uint balance) {
109         return balances[tokenOwner];
110     }
111     /** Transfer the balance from token owner's account to to account
112     * - Owner's account must have sufficient balance to transfer
113     * - 0 value transfers are allowed
114     */
115     function transfer(address to, uint tokens) public returns (bool success) {
116         balances[msg.sender] = safeSub(balances[msg.sender], tokens);
117         balances[to] = safeAdd(balances[to], tokens);
118         emit Transfer(msg.sender, to, tokens);
119         return true;
120     }
121     /** 
122      * Token owner can approve for spender to transferFrom(...) tokens
123      * from the token owner's account
124      */
125     function approve(address spender, uint tokens) public returns (bool success) {
126         allowed[msg.sender][spender] = tokens;
127         emit Approval(msg.sender, spender, tokens);
128         return true;
129     }
130     /** 
131     * Transfer tokens from the from account to the to account
132     * 
133     * - From account must have sufficient balance to transfer
134     * - Spender must have sufficient allowance to transfer
135     * - 0 value transfers are allowed
136     */
137     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
138         balances[from] = safeSub(balances[from], tokens);
139         allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
140         balances[to] = safeAdd(balances[to], tokens);
141         emit Transfer(from, to, tokens);
142         return true;
143     }
144     /** 
145     * Returns the amount of tokens approved by the owner that can be
146     * transferred to the spender's account
147     */
148     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
149         return allowed[tokenOwner][spender];
150     }
151     /** 
152      * Token owner can approve for spender to transferFrom(...) tokens
153      * from the token owner's account. The spender contract function
154      * receiveApproval(...) is then executed
155      */
156     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
157         allowed[msg.sender][spender] = tokens;
158         emit Approval(msg.sender, spender, tokens);
159         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
160         return true;
161     }
162     /**
163      * Don't accept ETH
164      */
165     function () public payable {
166         revert();
167     }
168     /**
169      * Owner can transfer out any accidentally sent ERC20 tokens
170      */
171     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
172         return ERC20Interface(tokenAddress).transfer(owner, tokens);
173     }
174 }