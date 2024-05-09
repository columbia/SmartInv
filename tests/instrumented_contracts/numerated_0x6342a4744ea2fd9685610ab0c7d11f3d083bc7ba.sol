1 pragma solidity ^0.4.16;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
6         if (a == 0) {
7             return 0;
8         }
9         c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13 
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a / b;
16     }
17 
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22 
23     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
24         c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
34 
35     constructor () public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         require(newOwner != address(0));
46         emit OwnershipTransferred(owner, newOwner);
47         owner = newOwner;
48     }
49 }
50 
51 
52 interface tokenRecipient {function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external;}
53 
54 contract TokenERC20 {
55     using SafeMath for uint256;
56 
57     string public name;
58     string public symbol;
59     uint8 public decimals = 18;
60     uint256 public totalSupply;
61 
62     mapping(address => uint256) public balanceOf;
63     mapping(address => mapping(address => uint256)) public allowance;
64 
65     event Transfer(address indexed from, address indexed to, uint256 value);
66 
67     event Burn(address indexed from, uint256 value);
68 
69     constructor (
70         uint256 initialSupply,
71         string tokenName,
72         string tokenSymbol
73     ) public {
74         totalSupply = initialSupply * 10 ** uint256(decimals);
75         balanceOf[msg.sender] = totalSupply;
76         name = tokenName;
77         symbol = tokenSymbol;
78     }
79 
80     function _transfer(address _from, address _to, uint _value) internal {
81         require(_to != 0x0);
82         require(balanceOf[_from] >= _value && _value > 0);
83         require(balanceOf[_to] + _value > balanceOf[_to]);
84         uint previousBalances = balanceOf[_from] + balanceOf[_to];
85         balanceOf[_from] = balanceOf[_from].sub(_value);
86         balanceOf[_to] = balanceOf[_to].add(_value);
87         emit Transfer(_from, _to, _value);
88         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
89     }
90 
91     function transfer(address _to, uint256 _value) public returns (bool success) {
92         _transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function batchTransfer(address[] _to, uint _value) public returns (bool success) {
97         require(_to.length > 0 && _to.length <= 20);
98         for (uint i = 0; i < _to.length; i++) {
99             _transfer(msg.sender, _to[i], _value);
100         }
101         return true;
102     }
103 
104     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
105         require(_value <= allowance[_from][msg.sender]);
106         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
107         _transfer(_from, _to, _value);
108         return true;
109     }
110 
111     function approve(address _spender, uint256 _value) public
112     returns (bool success) {
113         allowance[msg.sender][_spender] = _value;
114         return true;
115     }
116 
117     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
118     public
119     returns (bool success) {
120         tokenRecipient spender = tokenRecipient(_spender);
121         if (approve(_spender, _value)) {
122             spender.receiveApproval(msg.sender, _value, this, _extraData);
123             return true;
124         }
125     }
126 
127     function burn(uint256 _value) public returns (bool success) {
128         require(balanceOf[msg.sender] >= _value);
129         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
130         totalSupply = totalSupply.sub(_value);
131         emit Burn(msg.sender, _value);
132         return true;
133     }
134 
135     function burnFrom(address _from, uint256 _value) public returns (bool success) {
136         require(balanceOf[_from] >= _value);
137         require(_value <= allowance[_from][msg.sender]);
138         balanceOf[_from] = balanceOf[_from].sub(_value);
139         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
140         totalSupply = totalSupply.sub(_value);
141         emit Burn(_from, _value);
142         return true;
143     }
144 }
145 
146 contract JTCToken is Ownable, TokenERC20 {
147 
148     uint256 public sellPrice;
149     uint256 public buyPrice;
150 
151     uint minBalanceForAccounts;
152 
153     mapping(address => bool) public frozenAccount;
154 
155     event FrozenFunds(address target, bool frozen);
156 
157     constructor (
158         uint256 initialSupply,
159         string tokenName,
160         string tokenSymbol
161     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
162 
163     function _transfer(address _from, address _to, uint _value) internal {
164         require(_to != 0x0);
165         require(balanceOf[_from] >= _value);
166         require(balanceOf[_to] + _value >= balanceOf[_to]);
167         require(!frozenAccount[_from]);
168         require(!frozenAccount[_to]);
169 
170         if (msg.sender.balance < minBalanceForAccounts)
171             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
172 
173         balanceOf[_from] = balanceOf[_from].sub(_value);
174         balanceOf[_to] = balanceOf[_to].add(_value);
175         emit Transfer(_from, _to, _value);
176     }
177 
178     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
179         balanceOf[target] = balanceOf[target].add(mintedAmount);
180         totalSupply = totalSupply.add(mintedAmount);
181         emit Transfer(0, this, mintedAmount);
182         emit Transfer(this, target, mintedAmount);
183     }
184 
185     function freezeAccount(address target, bool freeze) onlyOwner public {
186         frozenAccount[target] = freeze;
187         emit FrozenFunds(target, freeze);
188     }
189 
190     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
191         sellPrice = newSellPrice;
192         buyPrice = newBuyPrice;
193     }
194 
195     function buy() payable public {
196         uint amount = msg.value.div(buyPrice);
197         _transfer(this, msg.sender, amount);
198     }
199 
200     function sell(uint256 amount) public {
201         address myAddress = this;
202         require(myAddress.balance >= amount * sellPrice);
203         _transfer(msg.sender, this, amount);
204         msg.sender.transfer(amount.mul(sellPrice));
205     }
206 
207     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
208         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
209     }
210 }