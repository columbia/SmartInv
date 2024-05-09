1 pragma solidity ^0.4.18;
2 library SafeMath {
3     function add(uint a, uint b) internal pure returns (uint c) {
4         c = a + b;
5         require(c >= a);
6     }
7     function sub(uint a, uint b) internal pure returns (uint c) {
8         require(b <= a);
9         c = a - b;
10     }
11     function mul(uint a, uint b) internal pure returns (uint c) {
12         c = a * b;
13         require(a == 0 || c / a == b);
14     }
15     function div(uint a, uint b) internal pure returns (uint c) {
16         require(b > 0);
17         c = a / b;
18     }
19 }
20 contract ERC20Interface {
21     function totalSupply() public constant returns (uint);
22     function balanceOf(address tokenOwner) public constant returns (uint balance);
23     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
24     function transfer(address to, uint tokens) public returns (bool success);
25     function approve(address spender, uint tokens) public returns (bool success);
26     function transferFrom(address from, address to, uint tokens) public returns (bool success);
27     event Transfer(address indexed from, address indexed to, uint tokens);
28     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
29 }
30 contract ApproveAndCallFallBack {
31     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
32 }
33 
34 // Owned contract
35 contract Owned {
36     address public owner;
37     address public newOwner;
38     event OwnershipTransferred(address indexed _from, address indexed _to);
39 
40     function Owned() public {
41         owner = msg.sender;
42     }
43     modifier onlyOwner {
44         require(msg.sender == owner);
45         _;
46     }
47     
48     //Transfer owner rights, can use only owner (the best practice of secure for the contracts)
49     function transferOwnership(address _newOwner) public onlyOwner {
50         newOwner = _newOwner;
51     }
52     
53     //Accept tranfer owner rights
54     function acceptOwnership() public onlyOwner {
55         OwnershipTransferred(owner, newOwner);
56         owner = newOwner;
57         newOwner = address(0);
58     }
59 }
60 
61 contract NSCDistributionContract is ERC20Interface, Owned {
62     using SafeMath for uint;
63     string public symbol;
64     string public  name;
65     uint8 public decimals;
66     uint public _initialDistribution;
67     uint private _totalSupply;
68     uint256 public unitsOneEthCanBuy;
69     uint256 private totalEthInWei;
70     address private fundsWallet;
71     mapping(address => uint) balances;
72     mapping(address => mapping(address => uint)) allowed;
73 
74     function NSCDistributionContract() public {
75         symbol = 'Pobeda';
76         name = 'PB';
77         decimals = 18;
78         _totalSupply = 500000000 * 10**uint(decimals);
79         _initialDistribution = 1000000 * 10**uint(decimals);
80         balances[owner] = _totalSupply;
81         Transfer(address(0), owner, _totalSupply);
82         unitsOneEthCanBuy = 692;
83         fundsWallet = msg.sender;
84     }
85 
86     function totalSupply() public constant returns (uint) {
87         return _totalSupply  - balances[address(0)];
88     }
89 
90     function balanceOf(address tokenOwner) public constant returns (uint balance) {
91         return balances[tokenOwner];
92     }
93 
94     function transfer(address to, uint tokens) public returns (bool success) {
95         balances[msg.sender] = balances[msg.sender].sub(tokens);
96         balances[to] = balances[to].add(tokens);
97         Transfer(msg.sender, to, tokens);
98         return true;
99     }
100 
101     function approve(address spender, uint tokens) public returns (bool success) {
102         allowed[msg.sender][spender] = tokens;
103         Approval(msg.sender, spender, tokens);
104         return true;
105     }
106 
107     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
108         balances[from] = balances[from].sub(tokens);
109         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
110         balances[to] = balances[to].add(tokens);
111         Transfer(from, to, tokens);
112         return true;
113     }
114 
115     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
116         return allowed[tokenOwner][spender];
117     }
118 
119     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
120         allowed[msg.sender][spender] = tokens;
121         Approval(msg.sender, spender, tokens);
122         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
123         return true;
124     }
125 
126     function () public payable {
127         totalEthInWei = totalEthInWei + msg.value;
128         uint256 amount = msg.value * unitsOneEthCanBuy;
129         if (balances[fundsWallet] < amount) {
130             return;
131         }
132         balances[fundsWallet] = balances[fundsWallet] - amount;
133         balances[msg.sender] = balances[msg.sender] + amount;
134         Transfer(fundsWallet, msg.sender, amount);
135         fundsWallet.transfer(msg.value);
136     }
137     
138     //Send tokens to users from the exel file
139     function send(address[] receivers, uint[] values) public payable {
140       for (uint i = 0; receivers.length > i; i++) {
141            sendTokens(receivers[i], values[i]);
142         }
143     }
144     
145     //Send tokens to specific user
146     function sendTokens (address receiver, uint token) public onlyOwner {
147         require(balances[msg.sender] >= token);
148         balances[msg.sender] -= token;
149         balances[receiver] += token;
150         Transfer(msg.sender, receiver, token);
151     }
152     
153     //Send initial tokens
154     function sendInitialTokens (address user) public onlyOwner {
155         sendTokens(user, balanceOf(owner));
156     }
157 }