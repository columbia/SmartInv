1 pragma solidity ^0.4.19;
2 
3 
4 // ERC Token Standard #20 Interface
5 // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
6 contract ERC20Interface {
7     function totalSupply() public constant returns (uint);
8     function balanceOf(address tokenOwner) public constant returns (uint balance);
9     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
10     function transfer(address to, uint tokens) public returns (bool success);
11     function approve(address spender, uint tokens) public returns (bool success);
12     function transferFrom(address from, address to, uint tokens) public returns (bool success);
13 
14     event Transfer(address indexed from, address indexed to, uint tokens);
15     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
16 }
17 
18 
19 
20 
21 contract Owned {
22     address public owner;
23 
24     event OwnershipTransferred(address indexed from, address indexed to);
25 
26     function Owned() public {
27         owner = msg.sender;
28     }
29 
30     modifier onlyOwner() {
31         require(msg.sender == owner);
32         _;
33     }
34 
35     function setOwner(address _newOwner) public onlyOwner {
36         owner = _newOwner;
37         OwnershipTransferred(owner, _newOwner);
38     }
39 }
40 
41 
42 
43 // ----------------------------------------------------------------------------
44 // Safe maths
45 // ----------------------------------------------------------------------------
46 library SafeMath {
47     function add(uint a, uint b) internal pure returns (uint c) {
48         c = a + b;
49         require(c >= a);
50     }
51     function sub(uint a, uint b) internal pure returns (uint c) {
52         require(b <= a);
53         c = a - b;
54     }
55     function mul(uint a, uint b) internal pure returns (uint c) {
56         c = a * b;
57         require(a == 0 || c / a == b);
58     }
59     function div(uint a, uint b) internal pure returns (uint c) {
60         require(b > 0);
61         c = a / b;
62     }
63 }
64 
65 
66 
67 contract VotingToken is ERC20Interface, Owned {
68     using SafeMath for uint;
69 
70 
71     // ------------------------------------------------------------------------
72     // ERC 20 fields
73     // ------------------------------------------------------------------------
74     string public symbol;
75     string public name;
76     uint8 public decimals;
77     uint public totalSupply;
78 
79     mapping(address => uint) balances;
80     mapping(address => mapping(address => uint)) allowed;
81 
82     // ------------------------------------------------------------------------
83     // Fields required for the referendum
84     // ------------------------------------------------------------------------
85     Description public description;
86     Props public props;
87     Reward public reward;
88     bool public open;
89     
90     struct Description {
91         string question;
92         string firstProp;
93         string secondProp;
94     }
95 
96     struct Props {
97         address firstPropAddress;
98         address secondPropAddress;
99         address blankVoteAddress;
100     }
101 
102     struct Reward {
103         address tokenAddress;
104         address refundWalletAddress; 
105     }
106 
107     event VoteRewarded(address indexed to, uint amount);
108     event Finish(string question, 
109         string firstProp, uint firstPropCount, 
110         string secondProp, uint secondPropCount, uint blankVoteCount);
111 
112 
113     // ------------------------------------------------------------------------
114     // Constructor
115     // ------------------------------------------------------------------------
116     function VotingToken(
117         string _symbol, string _name, uint _totalSupply, 
118         string _question, string _firstProp, string _secondProp,
119         address _firstPropAddress, address _secondPropAddress, address _blankVoteAddress,
120         address _tokenAddress) public {
121 
122         symbol = _symbol;
123         name = _name;
124         decimals = 8;
125         totalSupply = _totalSupply;
126         balances[owner] = _totalSupply;
127         Transfer(address(0), owner, totalSupply);
128 
129         description = Description(_question, _firstProp, _secondProp);
130         props = Props(_firstPropAddress, _secondPropAddress, _blankVoteAddress);
131         reward = Reward(_tokenAddress, owner);
132         open = true;
133     }
134 
135     function close() public onlyOwner returns (bool success) {
136         require(open);
137         open = false;
138         Finish(description.question, 
139             description.firstProp, balanceOf(props.firstPropAddress), 
140             description.firstProp, balanceOf(props.secondPropAddress), 
141             balanceOf(props.blankVoteAddress));
142 
143         ERC20Interface rewardToken = ERC20Interface(reward.tokenAddress);
144         uint leftBalance = rewardToken.balanceOf(address(this));
145         rewardToken.transfer(reward.refundWalletAddress, leftBalance);
146 
147         return true;
148     }
149 
150     function updateRefundWalletAddress(address _wallet) public onlyOwner returns (bool success) {
151         reward.refundWalletAddress = _wallet;
152         return true;
153     }
154 
155     function getResults() public view returns (uint firstPropCount, uint secondPropCount, uint blankVoteCount) {
156         return (
157             balanceOf(props.firstPropAddress), 
158             balanceOf(props.secondPropAddress), 
159             balanceOf(props.blankVoteAddress));
160     }
161 
162     function totalSupply() public constant returns (uint) {
163         return totalSupply - balances[address(0)];
164     }
165 
166     function balanceOf(address _tokenOwner) public constant returns (uint balance) {
167         return balances[_tokenOwner];
168     }
169 
170     function rewardVote(address _from, address _to, uint _tokens) private {
171         if(_to == props.firstPropAddress || 
172            _to == props.secondPropAddress || 
173            _to == props.blankVoteAddress) {
174             ERC20Interface rewardToken = ERC20Interface(reward.tokenAddress);
175             uint rewardTokens = _tokens.div(100);
176             rewardToken.transfer(_from, rewardTokens);
177             VoteRewarded(_from, _tokens);
178         }
179     }
180 
181     // ------------------------------------------------------------------------
182     // Transfer the balance from token owner's account to `to` account
183     // - Owner's account must have sufficient balance to transfer
184     // - 0 value transfers are allowed
185     // ------------------------------------------------------------------------
186     function transfer(address to, uint tokens) public returns (bool success) {
187         return transferFrom(msg.sender, to, tokens);
188     }
189 
190     // ------------------------------------------------------------------------
191     // Transfer `tokens` from the `from` account to the `to` account
192     // 
193     // The calling account must already have sufficient tokens approve(...)-d
194     // for spending from the `from` account and
195     // - From account must have sufficient balance to transfer
196     // - Spender must have sufficient allowance to transfer
197     // - 0 value transfers are allowed
198     // ------------------------------------------------------------------------
199     function transferFrom(address from, address to, uint tokens) public returns (bool success) {
200         require(open);
201         balances[from] = balances[from].sub(tokens);
202         if(from != msg.sender) {
203             allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
204         }
205         balances[to] = balances[to].add(tokens);
206         Transfer(from, to, tokens);
207         rewardVote(from, to, tokens);
208         return true;
209     }
210 
211     // ------------------------------------------------------------------------
212     // Token owner can approve for `spender` to transferFrom(...) `tokens`
213     // from the token owner's account
214     //
215     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
216     // recommends that there are no checks for the approval double-spend attack
217     // as this should be implemented in user interfaces 
218     // ------------------------------------------------------------------------
219     function approve(address spender, uint tokens) public returns (bool success) {
220         require(open);
221         allowed[msg.sender][spender] = tokens;
222         Approval(msg.sender, spender, tokens);
223         return true;
224     }
225 
226     // ------------------------------------------------------------------------
227     // Returns the amount of tokens approved by the owner that can be
228     // transferred to the spender's account
229     // ------------------------------------------------------------------------
230     function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
231         return allowed[tokenOwner][spender];
232     }
233 
234     // ------------------------------------------------------------------------
235     // Don't accept ETH
236     // ------------------------------------------------------------------------
237     function () public payable {
238         revert();
239     }
240 }