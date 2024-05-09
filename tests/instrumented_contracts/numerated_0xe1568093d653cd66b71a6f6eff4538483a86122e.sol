1 pragma solidity ^0.4.22;
2 
3 // ----------------------------------------------------------------------------
4 
5 // Symbol      : FREE
6 // Name        : Webfree
7 // Total supply: 777,777,777.000000000000000000
8 // Decimals    : 18
9 
10 // ----------------------------------------------------------------------------
11 
12 library SafeMath {
13     function add(uint a, uint b) internal pure returns (uint c) {
14         c = a + b;
15         require(c >= a);
16     }
17     function sub(uint a, uint b) internal pure returns (uint c) {
18         require(b <= a);
19         c = a - b;
20     }
21     function mul(uint a, uint b) internal pure returns (uint c) {
22         c = a * b;
23         require(a == 0 || c / a == b);
24     }
25     function div(uint a, uint b) internal pure returns (uint c) {
26         require(b > 0);
27         c = a / b;
28     }
29 }
30 
31 
32 contract ERC20Interface {
33     function totalSupply() public constant returns (uint);
34     function balanceOf(address tokenOwner) public constant returns (uint balance);
35     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
36     function transfer(address to, uint tokens) public returns (bool success);
37     function approve(address spender, uint tokens) public returns (bool success);
38     function transferFrom(address from, address to, uint tokens) public returns (bool success);
39 
40     event Transfer(address indexed from, address indexed to, uint tokens);
41     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
42 }
43 
44 
45 contract ApproveAndCallFallBack {
46     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
47 }
48 
49 
50 contract Owned {
51     address public owner;
52     address public newOwner;
53 
54     event OwnershipTransferred(address indexed _from, address indexed _to);
55    
56     constructor() public {
57         owner = msg.sender;
58     }
59 
60     modifier onlyOwner {
61         require(msg.sender == owner);
62         _;
63     }
64 
65     function transferOwnership(address _newOwner) public onlyOwner {
66         newOwner = _newOwner;
67     }
68     function acceptOwnership() public {
69         require(msg.sender == newOwner);
70         emit OwnershipTransferred(owner, newOwner);
71         owner = newOwner;
72         newOwner = address(0);
73     }
74 }
75 
76 
77 contract WebFreeToken is ERC20Interface, Owned {
78     using SafeMath for uint;
79 
80     string public symbol;
81     string public  name;
82     uint8 public decimals;
83     uint _totalSupply;
84     bool freezed = true;
85     
86     address SupernodesNodesOwnersFREE = 
87         0x2CAadf019F6a5F557c552a33ED9a2Ce36C982d70;
88 
89     address WebfreeFoundationFREE = 
90         0x0E1EA5831d0d2c1745D583dd93B9114222416372;
91 
92     address WebfreePrivateContributionFREE = 
93         0x89cE7309953124caCbdCe6CcC1E23aF927d8e703;
94  
95     address WebfreePublicContributionFREE = 
96         0x5E911c5A41A60c23C2836eedc80E1Bdeb2991Eb2;
97 
98     address WebfreeCommunityRewardsFREE = 
99         0xBeA8E036eb401C1d01526cAFb6cb1dd6e3ea122E;
100 
101     address WebfreeTeamFREE = 
102         0x5da594967B254c1bA3E816C99D691439EE1dDD76;
103     
104 
105     mapping(address => uint) balances;
106     mapping(address => mapping(address => uint)) allowed;
107 
108 
109     constructor() public {
110         symbol = "FREE";
111         name = "Webfree";
112         decimals = 18;
113         uint dec = 10**uint(decimals);
114         
115         balances[SupernodesNodesOwnersFREE] = 311111111 * dec;
116         balances[WebfreeFoundationFREE] = 155555555 * dec;
117         balances[WebfreePrivateContributionFREE] = 77777777 * dec;
118         balances[WebfreePublicContributionFREE] = 77777777 * dec;
119         balances[WebfreeCommunityRewardsFREE] = 77777777 * dec;
120         balances[WebfreeTeamFREE] = 77777780 * dec;
121         
122         _totalSupply = uint(0)
123             .add(balances[SupernodesNodesOwnersFREE])
124             .add(balances[WebfreeFoundationFREE])
125             .add(balances[WebfreePrivateContributionFREE])
126             .add(balances[WebfreePublicContributionFREE])
127             .add(balances[WebfreeCommunityRewardsFREE])
128             .add(balances[WebfreeTeamFREE]);
129         
130         
131         emit Transfer(address(0), SupernodesNodesOwnersFREE, 311111111 * dec);
132         emit Transfer(address(0), WebfreeFoundationFREE, 155555555 * dec);
133         emit Transfer(address(0), WebfreePrivateContributionFREE, 77777777 * dec);
134         emit Transfer(address(0), WebfreePublicContributionFREE, 77777777 * dec);
135         emit Transfer(address(0), WebfreeCommunityRewardsFREE, 77777777 * dec);
136         emit Transfer(address(0), WebfreeTeamFREE, 77777780 * dec);
137         transferOwnership(0x5da594967B254c1bA3E816C99D691439EE1dDD76);
138     }
139 
140 
141     function totalSupply() public view returns (uint) {
142         return _totalSupply.sub(balances[address(0)]);
143     }
144 
145 
146     function balanceOf(address tokenOwner) public view returns (uint balance) {
147         return balances[tokenOwner];
148     }
149 
150 
151     function transfer(address to, uint tokens) public returns (bool success) {
152         bool req = !freezed || 
153             msg.sender == SupernodesNodesOwnersFREE ||
154             msg.sender == WebfreeFoundationFREE ||
155             msg.sender == WebfreePrivateContributionFREE ||
156             msg.sender == WebfreePublicContributionFREE ||
157             msg.sender == WebfreeCommunityRewardsFREE ||
158             msg.sender == WebfreeTeamFREE;
159         require(req);
160         
161         balances[msg.sender] = balances[msg.sender].sub(tokens);
162         balances[to] = balances[to].add(tokens);
163         emit Transfer(msg.sender, to, tokens);
164         return true;
165     }
166 
167     function approve(address spender, uint tokens) public returns (bool success) {
168         require(!freezed);
169         allowed[msg.sender][spender] = tokens;
170         emit Approval(msg.sender, spender, tokens);
171         return true;
172     }
173     
174     function unfreez() public onlyOwner {
175         freezed = false;
176     }
177 
178     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
179         balances[from] = balances[from].sub(tokens);
180         allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
181         balances[to] = balances[to].add(tokens);
182         emit Transfer(from, to, tokens);
183         return true;
184     }
185 
186 
187     function allowance(address tokenOwner, address spender) public view returns (uint remaining) {
188         return allowed[tokenOwner][spender];
189     }
190 
191 
192     function approveAndCall(address spender, uint tokens, bytes data) public returns (bool success) {
193         allowed[msg.sender][spender] = tokens;
194         emit Approval(msg.sender, spender, tokens);
195         ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
196         return true;
197     }
198 
199 
200     function () public payable {
201         revert();
202     }
203 
204 
205     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {
206         return ERC20Interface(tokenAddress).transfer(owner, tokens);
207     }
208 }