1 pragma solidity ^0.5.2;
2 
3 // Kotlo Mordo is a great open source alcoholic board game (yes, a physical board game, 
4 // not everything has to be online :) This token belongs to players, who are earning it by
5 // participating on the development of the game. For this token they can buy some cool additional
6 // stuff as a reward for their great job. Thanks to them, this game can grow itself. 
7 // more information about this game -> kotlomordo.sk or info[at]kotlomordo.sk
8 //
9 // This is not any pump and dump ICO, this is a real exchange token between participation
10 // and cool rewards. Do not HODL this token, this token will never go MOON. No Lambos here.
11 // 
12 // This code was inspired by https://theethereum.wiki/w/index.php/ERC20_Token_Standard
13 
14 library SafeMath {
15     function add(uint a, uint b) internal pure returns (uint c) {
16         c = a + b;
17         require(c >= a);
18     }
19     function sub(uint a, uint b) internal pure returns (uint c) {
20         require(b <= a);
21         c = a - b;
22     }
23     function mul(uint a, uint b) internal pure returns (uint c) {
24         c = a * b;
25         require(a == 0 || c / a == b);
26     }
27     function div(uint a, uint b) internal pure returns (uint c) {
28         require(b > 0);
29         c = a / b;
30     }
31 }
32 
33 contract ERC20Interface {
34     function totalSupply() public view returns (uint);
35     function balanceOf(address tokenOwner) public view returns (uint balance);
36     function allowance(address tokenOwner, address spender) public view returns (uint remaining);
37     function transfer(address to, uint tokens) public returns (bool success);
38     function approve(address spender, uint tokens) public returns (bool success);
39     function transferFrom(address from, address to, uint tokens) public returns (bool success);
40 
41     event Transfer(address indexed from, address indexed to, uint tokens);
42     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
43 }
44 contract ApproveAndCallFallBack {
45     function receiveApproval(address from, uint256 tokens, address token, bytes memory data) public;
46 }
47 contract Owned {
48     address public owner;
49     address public newOwner;
50 
51     event OwnershipTransferred(address indexed _from, address indexed _to);
52 
53     constructor() public {
54         owner = msg.sender;
55     }
56 
57     modifier onlyOwner {
58         require(msg.sender == owner);
59         _;
60     }
61 
62     function transferOwnership(address _newOwner) public onlyOwner {
63         newOwner = _newOwner;
64     }
65     function acceptOwnership() public {
66         require(msg.sender == newOwner);
67         emit OwnershipTransferred(owner, newOwner);
68         owner = newOwner;
69         newOwner = address(0);
70     }
71 }
72 contract KotloMordo is ERC20Interface, Owned {
73     using SafeMath for uint;
74 
75     string public symbol;
76     string public  name;
77     uint8 public decimals;
78     uint _totalSupply;
79 
80     mapping(address => uint) balances;
81     mapping(address => mapping(address => uint)) allowed;
82 
83     constructor() public {
84         symbol = "KM";
85         name = "Kotlo Mordo";
86         decimals = 2;
87         _totalSupply = 10000 * 10**uint(decimals);
88         balances[owner] = _totalSupply;
89         emit Transfer(address(0), owner, _totalSupply);
90     }
91 
92     function totalSupply() public view returns (uint) {
93         return _totalSupply.sub(balances[address(0)]);
94     }
95 
96     function balanceOf(address tokenOwner) public view returns (uint balance) {
97         return balances[tokenOwner];
98     }
99     function transfer(address to, uint tokens) public returns (bool success) {
100         balances[msg.sender] = balances[msg.sender].sub(tokens);
101         balances[to] = balances[to].add(tokens);
102         emit Transfer(msg.sender, to, tokens);
103         return true;
104     }
105     function approve(address spender, uint tokens) public returns (bool success) {
106         allowed[msg.sender][spender] = tokens;
107         emit Approval(msg.sender, spender, tokens);
108         return true;
109     }
110     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
111         balances[from] = balances[from].sub(tokens);
112         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
113         balances[to] = balances[to].add(tokens);
114         emit Transfer(from, to, tokens);
115         return true;
116     }
117     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
118         return allowed[tokenOwner][spender];
119     }
120     function approveAndCall(address spender, uint tokens, bytes memory data) public returns (bool success) {
121         allowed[msg.sender][spender] = tokens;
122         emit Approval(msg.sender, spender, tokens);
123         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, address(this), data);
124         return true;
125     }
126 
127     // Don't accept ETH
128     function () external payable {
129         revert();
130     }
131 
132     // Owner can transfer out any accidentally sent ERC20 token
133     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
134         return ERC20Interface(tokenAddress).transfer(owner, tokens);
135     }
136 }