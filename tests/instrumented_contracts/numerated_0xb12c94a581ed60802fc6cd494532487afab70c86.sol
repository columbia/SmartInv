1 pragma solidity ^0.4.18;
2 
3 contract Token {
4     function totalSupply() constant public returns (uint supply);
5     function balanceOf(address _owner) public constant returns (uint balance);
6     function transfer(address _to, uint _value) public returns (bool success);
7     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
8     function approve(address _spender, uint _value) public returns (bool success);
9     function allowance(address _owner, address _spender) public constant returns (uint remaining);
10     event Transfer(address indexed _from, address indexed _to, uint _value);
11     event Approval(address indexed _owner, address indexed _spender, uint _value);
12 }
13 
14 contract TestIco {
15     uint public constant ETH_PRICE = 1;
16 
17     address public manager;
18     address public reserveManager;
19     
20     address public escrow;
21     address public reserveEscrow;
22     
23     address[] public allowedTokens;
24     mapping(address => bool) public tokenAllowed;
25     mapping(address => uint) public tokenPrice;
26     mapping(address => uint) public tokenAmount;
27     
28     mapping(address => uint) public ethBalances;
29     mapping(address => uint) public balances;
30     
31     // user => token[]
32     mapping(address => address[]) public userTokens;
33     //  user => token => amount
34     mapping(address => mapping(address => uint)) public userTokensValues;
35     
36     modifier onlyManager {
37         assert(msg.sender == manager || msg.sender == reserveManager);
38         _;
39     }
40     modifier onlyManagerOrContract {
41         assert(msg.sender == manager || msg.sender == reserveManager || msg.sender == address(this));
42         _;
43     }
44 
45     function TestIco(
46         address _manager, 
47         address _reserveManager, 
48         address _escrow, 
49         address _reserveEscrow
50     ) public {
51         manager = _manager;
52         reserveManager = _reserveManager;
53         escrow = _escrow;
54         reserveEscrow = _reserveEscrow;
55     }
56     
57     // _price is price of amount of token
58     function addToken(address _token, uint _amount, uint _price) onlyManager public {
59         assert(_token != 0x0);
60         assert(_amount > 0);
61         assert(_price > 0);
62         
63         bool isNewToken = true;
64         for (uint i = 0; i < allowedTokens.length; i++) {
65             if (allowedTokens[i] == _token) {
66                 isNewToken = false;
67             }
68         }
69         if (isNewToken) {
70             allowedTokens.push(_token);
71         }
72         
73         tokenAllowed[_token] = true;
74         tokenPrice[_token] = _price;
75         tokenAmount[_token] = _amount;
76     }
77     
78     function removeToken(address _token) onlyManager public {
79         for (uint i = 0; i < allowedTokens.length; i++) {
80             if (_token == allowedTokens[i]) {
81                 if (i < allowedTokens.length - 1) {
82                     allowedTokens[i] = allowedTokens[allowedTokens.length - 1];
83                 }
84                 allowedTokens[allowedTokens.length - 1] = 0x0;
85                 allowedTokens.length--;
86                 break;
87             }
88         }
89     
90         tokenAllowed[_token] = false;
91         tokenPrice[_token] = 0;
92         tokenAmount[_token] = 0;
93     }
94     
95     function buyWithTokens(address _token) public {
96         buyWithTokensBy(msg.sender, _token);
97     }
98     function addTokenToUser(address _user, address _token) private {
99         for (uint i = 0; i < userTokens[_user].length; i++) {
100             if (userTokens[_user][i] == _token) {
101                 return;
102             }
103         }
104         userTokens[_user].push(_token);
105     }
106     function buyWithTokensBy(address _user, address _token) public {
107         assert(tokenAllowed[_token]);
108     
109         Token token = Token(_token);
110         
111         uint tokensToSend = token.allowance(_user, address(this));
112         assert(tokensToSend > 0);
113         uint prevBalance = token.balanceOf(address(this));
114         assert(token.transferFrom(_user, address(this), tokensToSend));
115         assert(token.balanceOf(address(this)) - prevBalance == tokensToSend);
116         balances[_user] += tokensToSend * tokenPrice[_token] / tokenAmount[_token];
117         addTokenToUser(_user, _token);
118         userTokensValues[_user][_token] += tokensToSend;
119     }
120     
121     function returnFundsFor(address _user) public onlyManagerOrContract returns(bool) {
122         if (ethBalances[_user] > 0) {
123             _user.transfer(ethBalances[_user]);
124             ethBalances[_user] = 0;
125         }
126         
127         for (uint i = 0; i < userTokens[_user].length; i++) {
128             address tokenAddress = userTokens[_user][i];
129             uint userTokenValue = userTokensValues[_user][tokenAddress];
130             if (userTokenValue > 0) {
131                 Token token = Token(tokenAddress);
132                 assert(token.transfer(_user, userTokenValue));
133                 userTokensValues[_user][tokenAddress] = 0;
134             }
135         }
136     }
137     
138     
139     function returnFundsForUsers(address[] _users) public onlyManager {
140         for (uint i = 0; i < _users.length; i++) {
141             returnFundsFor(_users[i]);
142         }
143     }
144     
145     function buyTokens(address _user, uint _value) private {
146         assert(_user != 0x0);
147         
148         ethBalances[_user] += _value;
149         balances[_user] += _value * ETH_PRICE;
150     }
151     
152     function() public payable {
153         assert(msg.value > 0);
154         buyTokens(msg.sender, msg.value);
155     }
156     
157     function withdrawEtherTo(address _escrow) private {
158         if (this.balance > 0) {
159             _escrow.transfer(this.balance);
160         }
161         
162         for (uint i = 0; i < allowedTokens.length; i++) {
163             Token token = Token(allowedTokens[i]);
164             uint tokenBalance = token.balanceOf(address(this));
165             if (tokenBalance > 0) {
166                 assert(token.transfer(_escrow, tokenBalance));
167             }
168         }
169     }
170     
171     function withdrawEther() public onlyManager {
172         withdrawEtherTo(escrow);
173     }
174     
175     function withdrawEtherToReserveEscrow() public onlyManager {
176         withdrawEtherTo(reserveEscrow);
177     }
178 }