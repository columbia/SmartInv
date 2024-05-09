1 /**
2  *  CanYaCoin Presale contract (3780 ether)
3  */
4 
5 pragma solidity 0.4.15;
6 
7 library SafeMath {
8 
9   function div(uint256 a, uint256 b) internal constant returns (uint256) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint256 c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15 }
16 
17 contract ERC20TokenInterface {
18     /// @return The total amount of tokens
19     function totalSupply() constant returns (uint256 supply);
20 
21     /// @param _owner The address from which the balance will be retrieved
22     /// @return The balance
23     function balanceOf(address _owner) constant public returns (uint256 balance);
24 
25     /// @notice send `_value` token to `_to` from `msg.sender`
26     /// @param _to The address of the recipient
27     /// @param _value The amount of token to be transferred
28     /// @return Whether the transfer was successful or not
29     function transfer(address _to, uint256 _value) public returns (bool success);
30 
31     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
32     /// @param _from The address of the sender
33     /// @param _to The address of the recipient
34     /// @param _value The amount of token to be transferred
35     /// @return Whether the transfer was successful or not
36     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
37 
38     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
39     /// @param _spender The address of the account able to transfer the tokens
40     /// @param _value The amount of tokens to be approved for transfer
41     /// @return Whether the approval was successful or not
42     function approve(address _spender, uint256 _value) public returns (bool success);
43 
44     /// @param _owner The address of the account owning tokens
45     /// @param _spender The address of the account able to transfer the tokens
46     /// @return Amount of remaining tokens allowed to spent
47     function allowance(address _owner, address _spender) constant public returns (uint256 remaining);
48 
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 contract CanYaCoin is ERC20TokenInterface {
54 
55     string public constant name = "CanYaCoin";
56     string public constant symbol = "CAN";
57     uint256 public constant decimals = 6;
58     uint256 public constant totalTokens = 100000000 * (10 ** decimals);
59 
60     mapping (address => uint256) public balances;
61     mapping (address => mapping (address => uint256)) public allowed;
62 
63     function CanYaCoin() {
64         balances[msg.sender] = totalTokens;
65     }
66 
67     function totalSupply() constant returns (uint256) {
68         return totalTokens;
69     }
70 
71     function transfer(address _to, uint256 _value) public returns (bool) {
72         if (balances[msg.sender] >= _value) {
73             balances[msg.sender] -= _value;
74             balances[_to] += _value;
75             Transfer(msg.sender, _to, _value);
76             return true;
77         }
78         return false;
79     }
80 
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value) {
83             balances[_from] -= _value;
84             allowed[_from][msg.sender] -= _value;
85             balances[_to] += _value;
86             Transfer(_from, _to, _value);
87             return true;
88         }
89         return false;
90     }
91 
92     function balanceOf(address _owner) constant public returns (uint256) {
93         return balances[_owner];
94     }
95 
96     function approve(address _spender, uint256 _value) public returns (bool) {
97         allowed[msg.sender][_spender] = _value;
98         Approval(msg.sender, _spender, _value);
99         return true;
100     }
101 
102     function allowance(address _owner, address _spender) constant public returns (uint256 remaining) {
103         return allowed[_owner][_spender];
104     }
105 }
106 
107 
108 contract Presale {
109     using SafeMath for uint256;
110 
111     CanYaCoin public CanYaCoinToken;
112     bool public ended = false;
113     uint256 internal refundAmount = 0;
114     uint256 public constant MAX_CONTRIBUTION = 3780 ether;
115     uint256 public constant MIN_CONTRIBUTION = 1 ether;
116     address public owner;
117     address public multisig;
118     uint256 public constant pricePerToken = 400000000; // (wei per CAN)
119     uint256 public tokensAvailable = 9450000 * (10**6); // Whitepaper 9.45mil * 10^6
120 
121     event LogRefund(uint256 _amount);
122     event LogEnded(bool _soldOut);
123     event LogContribution(uint256 _amount, uint256 _tokensPurchased);
124 
125     modifier notEnded() {
126         require(!ended);
127         _;
128     }
129 
130     modifier onlyOwner() {
131         require(msg.sender == owner);
132         _;
133     }
134 
135     /// @dev Sets up the amount of tokens available as per the whitepaper
136     /// @param _token Address of the CanYaCoin contract
137     function Presale(address _token, address _multisig) {
138         require (_token != address(0) && _multisig != address(0));
139         owner = msg.sender;
140         CanYaCoinToken = CanYaCoin(_token);
141         multisig = _multisig;
142     }
143 
144     /// @dev Fallback function, this allows users to purchase tokens by simply sending ETH to the
145     /// contract; they will however need to specify a higher amount of gas than the default (21000)
146     function () notEnded payable public {
147         require(msg.value >= MIN_CONTRIBUTION && msg.value <= MAX_CONTRIBUTION);
148         uint256 tokensPurchased = msg.value.div(pricePerToken);
149         if (tokensPurchased > tokensAvailable) {
150             ended = true;
151             LogEnded(true);
152             refundAmount = (tokensPurchased - tokensAvailable) * pricePerToken;
153             tokensPurchased = tokensAvailable;
154         }
155         tokensAvailable -= tokensPurchased;
156         
157         //Refund the difference
158         if (ended && refundAmount > 0) {
159             uint256 toRefund = refundAmount;
160             refundAmount = 0;
161             // reentry should not be possible
162             msg.sender.transfer(toRefund);
163             LogRefund(toRefund);
164         }
165         LogContribution(msg.value, tokensPurchased);
166         CanYaCoinToken.transfer(msg.sender, tokensPurchased);
167         multisig.transfer(msg.value - toRefund);
168     }
169 
170     /// @dev Ends the crowdsale and withdraws any remaining tokens
171     /// @param _to Address to withdraw the tokens to
172     function withdrawTokens(address _to) onlyOwner public {
173         require(_to != address(0));
174         if (!ended) {
175             LogEnded(false);
176         }
177         ended = true;
178         CanYaCoinToken.transfer(_to, tokensAvailable);
179     }
180 }