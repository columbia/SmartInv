1 pragma solidity ^0.4.17;
2 
3 contract ERC20Interface {
4 	function totalSupply() public constant returns (uint256);
5 	function balanceOf(address _owner) public constant returns (uint256);
6 	function transfer(address _to, uint256 _value) public returns (bool);
7 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
8 	function approve(address _spender, uint256 _value) public returns (bool);
9 	function allowance(address _owner, address _spender) public constant returns (uint256);
10 	event Transfer(address indexed _from, address indexed _to, uint256 _value);
11 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
12 }
13 
14 contract SafeMath {
15   function safeMul(uint a, uint b) internal pure returns (uint) {
16     uint c = a * b;
17     assert(a == 0 || c / a == b);
18     return c;
19   }
20 
21   function safeSub(uint a, uint b) internal pure returns (uint) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function safeAdd(uint a, uint b) internal pure returns (uint) {
27     uint c = a + b;
28     assert(c>=a && c>=b);
29     return c;
30   }
31 }
32 
33 contract RandomToken {
34     function balanceOf(address _owner) public view returns (uint256);
35     function transfer(address _to, uint256 _value) public returns (bool);
36 }
37 
38 contract HalloweenCollectorToken is ERC20Interface, SafeMath {
39     string constant token_name = "Halloween Limited Edition Token";
40     string constant token_symbol = "HALW";
41     uint8 constant token_decimals = 0;
42     uint256 public constant ether_per_token = 0.0035 * 1 ether;
43     uint public constant TOKEN_SWAP_DURATION_HOURS = 1 * 24;
44     uint256 public constant token_airdrop_cnt_max = 1000;
45     uint256 public constant token_airdrop_amount_each = 10;
46     uint256 public constant token_swap_supply = 40000;
47 
48     uint public time_of_token_swap_start;
49     uint public time_of_token_swap_end;
50     uint256 totSupply;
51     uint256 public airdrop_cnt;
52 
53     address owner;
54     mapping(address => uint256) balances;
55     mapping(address => mapping(address => uint256)) allowed;
56     mapping(address => bool) is_airdropped;
57     
58     
59     modifier onlyOwner() {
60         if (msg.sender != owner) { revert(); }
61         _;
62     }
63     
64     modifier transferAllowed() {
65         _;
66     }
67     
68     modifier purchaseAllowed() {
69         if (now > time_of_token_swap_end) { revert(); }
70         _;
71     }
72     
73     function HalloweenCollectorToken() public {
74         owner = msg.sender;
75         uint256 airdrop_supply = safeMul(token_airdrop_cnt_max, token_airdrop_amount_each);
76         totSupply = safeAdd(token_swap_supply, airdrop_supply);
77         time_of_token_swap_start = now;
78         time_of_token_swap_end = time_of_token_swap_start + TOKEN_SWAP_DURATION_HOURS * 1 hours;
79         airdrop_cnt = 0;
80         balances[owner] = totSupply;
81     }
82 
83     function name() public pure returns (string)    { return token_name; }
84     function symbol() public pure returns (string)  { return token_symbol; }
85     function decimals() public pure returns (uint8) { return token_decimals; }
86     
87     function totalSupply() public view returns (uint256) {
88         return totSupply;
89     }
90     
91     function balanceOf(address a) public view returns (uint256) {
92         return balances[a];
93     }
94 
95     function transfer(address _to, uint256 _amount) public transferAllowed returns (bool) {
96         if ( 
97                 _amount > 0
98             &&  balances[msg.sender] >= _amount
99             &&  balances[_to] + _amount > balances[_to]
100         ) {
101             balances[msg.sender] -= _amount;
102             balances[_to] += _amount;
103             Transfer(msg.sender, _to, _amount);
104             return true;
105         } else {
106             return false;
107         }
108     }
109 
110     function transferFrom(
111         address _from,
112         address _to,
113         uint256 _amount
114     ) public transferAllowed returns (bool) {
115         if (
116                 _amount > 0
117             &&  balances[_from] >= _amount
118             &&  allowed[_from][msg.sender] >= _amount
119             &&  balances[_to] + _amount > balances[_to]
120         ) {
121             balances[_from] -= _amount;
122             allowed[_from][msg.sender] -= _amount;
123             balances[_to] += _amount;
124             Transfer(_from, _to, _amount);
125             return true;
126         }
127         else {
128             return false;
129         }
130     }
131  
132     function approve(address _spender, uint256 _amount) public returns (bool) {
133         allowed[msg.sender][_spender] = _amount;
134         Approval(msg.sender, _spender, _amount);
135         return true;
136     }
137  
138     function allowance(address _owner, address _spender) public view returns (uint256) {
139         return allowed[_owner][_spender];
140     }
141     
142     function() public payable purchaseAllowed {
143         if (msg.value == 0) {
144             if (airdrop_cnt >= token_airdrop_cnt_max || is_airdropped[msg.sender]) {
145                 //  airdrop already received
146                 return;
147             }
148             else {
149                 //  airdrop
150                 airdrop_cnt++;
151                 is_airdropped[msg.sender] = true;
152                 balances[owner] = safeSub(balances[owner], token_airdrop_amount_each);
153                 balances[msg.sender] = safeAdd(balances[msg.sender], token_airdrop_amount_each);
154                 Transfer(address(this), msg.sender, token_airdrop_amount_each);
155             }
156         }
157         else {
158             //  normal swap
159             uint256 tokenRequested = msg.value / ether_per_token;
160             assert(tokenRequested > 0 && tokenRequested <= balances[owner]);
161             uint256 cost = safeMul(tokenRequested, ether_per_token);
162             uint256 change = safeSub(msg.value, cost);
163             
164             owner.transfer(cost);
165             msg.sender.transfer(change);
166             balances[owner] = safeSub(balances[owner], tokenRequested);
167             balances[msg.sender] = safeAdd(balances[msg.sender], tokenRequested);
168     
169             Transfer(address(this), msg.sender, tokenRequested);
170         }
171     }
172     
173     function withdrawForeignTokens(address _tokenContract) public onlyOwner returns (bool) {
174         RandomToken token = RandomToken(_tokenContract);
175         uint256 amount = token.balanceOf(address(this));
176         return token.transfer(owner, amount);
177     }
178 }