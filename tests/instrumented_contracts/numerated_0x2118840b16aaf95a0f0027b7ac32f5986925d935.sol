1 pragma solidity ^0.4.19;
2 
3 
4 contract BasicAccessControl {
5     address public owner;
6     // address[] public moderators;
7     uint16 public totalModerators = 0;
8     mapping (address => bool) public moderators;
9     bool public isMaintaining = true;
10 
11     function BasicAccessControl() public {
12         owner = msg.sender;
13     }
14 
15     modifier onlyOwner {
16         require(msg.sender == owner);
17         _;
18     }
19 
20     modifier onlyModerators() {
21         require(msg.sender == owner || moderators[msg.sender] == true);
22         _;
23     }
24 
25     modifier isActive {
26         require(!isMaintaining);
27         _;
28     }
29 
30     function ChangeOwner(address _newOwner) onlyOwner public {
31         if (_newOwner != address(0)) {
32             owner = _newOwner;
33         }
34     }
35 
36 
37     function AddModerator(address _newModerator) onlyOwner public {
38         if (moderators[_newModerator] == false) {
39             moderators[_newModerator] = true;
40             totalModerators += 1;
41         }
42     }
43 
44     function RemoveModerator(address _oldModerator) onlyOwner public {
45         if (moderators[_oldModerator] == true) {
46             moderators[_oldModerator] = false;
47             totalModerators -= 1;
48         }
49     }
50 
51     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
52         isMaintaining = _isMaintaining;
53     }
54 }
55 
56 interface TokenRecipient {
57     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;
58 }
59 
60 contract TokenERC20 {
61     uint256 public totalSupply;
62 
63     mapping (address => uint256) public balanceOf;
64     mapping (address => mapping (address => uint256)) public allowance;
65 
66     event Transfer(address indexed from, address indexed to, uint256 value);
67     event Burn(address indexed from, uint256 value);
68 
69     function _transfer(address _from, address _to, uint _value) internal {
70         require(_to != 0x0);
71         require(balanceOf[_from] >= _value);
72         require(balanceOf[_to] + _value > balanceOf[_to]);
73         uint previousBalances = balanceOf[_from] + balanceOf[_to];
74         balanceOf[_from] -= _value;
75         balanceOf[_to] += _value;
76         Transfer(_from, _to, _value);
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);
86         allowance[_from][msg.sender] -= _value;
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 
96     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
97         TokenRecipient spender = TokenRecipient(_spender);
98         if (approve(_spender, _value)) {
99             spender.receiveApproval(msg.sender, _value, this, _extraData);
100             return true;
101         }
102     }
103 
104     function burn(uint256 _value) public returns (bool success) {
105         require(balanceOf[msg.sender] >= _value);
106         balanceOf[msg.sender] -= _value;
107         totalSupply -= _value;
108         Burn(msg.sender, _value);
109         return true;
110     }
111 
112     function burnFrom(address _from, uint256 _value) public returns (bool success) {
113         require(balanceOf[_from] >= _value);
114         require(_value <= allowance[_from][msg.sender]);
115         balanceOf[_from] -= _value;
116         allowance[_from][msg.sender] -= _value;
117         totalSupply -= _value;
118         Burn(_from, _value);
119         return true;
120     }
121 }
122 
123 contract PaymentInterface {
124     function buyBlueStarEgg(address _master, uint _tokens, uint16 _amount) public returns(uint);
125 }
126 
127 contract DragonTreasureToken is BasicAccessControl, TokenERC20 {
128     // metadata
129     string public constant name = "DragonTreasureToken";
130     string public constant symbol = "DTT";
131     uint256 public constant decimals = 8;
132     string public version = "1.0";
133 
134     // deposit address
135     address public inGameRewardAddress;
136     address public userGrowPoolAddress;
137     address public developerAddress;
138     address public paymentContract;
139 
140     // for future feature
141     uint256 public sellPrice;
142     uint256 public buyPrice;
143     bool public trading = false;
144     mapping (address => bool) public frozenAccount;
145     event FrozenFunds(address target, bool frozen);
146 
147     modifier isTrading {
148         require(trading == true || msg.sender == owner);
149         _;
150     }
151 
152     modifier requirePaymentContract {
153         require(paymentContract != address(0));
154         _;
155     }
156 
157     function () payable public {}
158 
159     // constructor
160     function DragonTreasureToken(address _inGameRewardAddress, address _userGrowPoolAddress, address _developerAddress) public {
161         require(_inGameRewardAddress != address(0));
162         require(_userGrowPoolAddress != address(0));
163         require(_developerAddress != address(0));
164         inGameRewardAddress = _inGameRewardAddress;
165         userGrowPoolAddress = _userGrowPoolAddress;
166         developerAddress = _developerAddress;
167 
168         balanceOf[inGameRewardAddress] = 14000000 * 10**uint(decimals);
169         balanceOf[userGrowPoolAddress] = 5000000 * 10**uint(decimals);
170         balanceOf[developerAddress] = 1000000 * 10**uint(decimals);
171         totalSupply = balanceOf[inGameRewardAddress] + balanceOf[userGrowPoolAddress] + balanceOf[developerAddress];
172     }
173 
174     // moderators
175     function setAddress(address _inGameRewardAddress, address _userGrowPoolAddress, address _developerAddress, address _paymentContract) onlyModerators external {
176         inGameRewardAddress = _inGameRewardAddress;
177         userGrowPoolAddress = _userGrowPoolAddress;
178         developerAddress = _developerAddress;
179         paymentContract = _paymentContract;
180     }
181 
182     // public
183     function withdrawEther(address _sendTo, uint _amount) onlyModerators external {
184         if (_amount > this.balance) {
185             revert();
186         }
187         _sendTo.transfer(_amount);
188     }
189 
190     function _transfer(address _from, address _to, uint _value) internal {
191         require (_to != 0x0);
192         require (balanceOf[_from] >= _value);
193         require (balanceOf[_to] + _value > balanceOf[_to]);
194         require(!frozenAccount[_from]);
195         require(!frozenAccount[_to]);
196         balanceOf[_from] -= _value;
197         balanceOf[_to] += _value;
198         Transfer(_from, _to, _value);
199     }
200 
201     function freezeAccount(address _target, bool _freeze) onlyOwner public {
202         frozenAccount[_target] = _freeze;
203         FrozenFunds(_target, _freeze);
204     }
205 
206     function buy() payable isTrading public {
207         uint amount = msg.value / buyPrice;
208         _transfer(this, msg.sender, amount);
209     }
210 
211     function sell(uint256 amount) isTrading public {
212         require(this.balance >= amount * sellPrice);
213         _transfer(msg.sender, this, amount);
214         msg.sender.transfer(amount * sellPrice);
215     }
216 
217     function buyBlueStarEgg(uint _tokens, uint16 _amount) isActive requirePaymentContract external {
218         if (_tokens > balanceOf[msg.sender])
219             revert();
220         PaymentInterface payment = PaymentInterface(paymentContract);
221         uint deductedTokens = payment.buyBlueStarEgg(msg.sender, _tokens, _amount);
222         if (deductedTokens == 0 || deductedTokens > _tokens)
223             revert();
224         _transfer(msg.sender, inGameRewardAddress, deductedTokens);
225     }
226 }