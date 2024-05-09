1 pragma solidity 0.4.24;
2 
3 contract owned {
4     address public owner;
5     constructor() public {
6         owner = msg.sender;
7     }
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12     function transferOwnership(address newOwner) onlyOwner public {
13         owner = newOwner;
14     }
15 }
16 
17 interface tokenRecipient {
18     function receiveApproval(
19         address _from,
20         uint256 _value,
21         address _token,
22         bytes _extraData
23     ) external;
24 }
25 
26 contract TokenERC20 {
27     string public name;
28     string public symbol;
29     uint8 public decimals = 18;
30     uint256 public totalSupply;
31     mapping (address => uint256) public balanceOf;
32     mapping (address => mapping (address => uint256)) public allowance;
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
35     event Burn(address indexed from, uint256 value);
36     constructor(
37         uint256 initialSupply,
38         string memory tokenName,
39         string memory tokenSymbol
40     ) public {
41         totalSupply = initialSupply * 10 ** uint256(decimals);
42         balanceOf[msg.sender] = totalSupply;
43         name = tokenName;
44         symbol = tokenSymbol;
45     }
46     function _transfer(address _from, address _to, uint _value) internal {
47         require(_to != address(0x0));
48         require(balanceOf[_from] >= _value);
49         require(balanceOf[_to] + _value > balanceOf[_to]);
50         uint previousBalances = balanceOf[_from] + balanceOf[_to];
51         balanceOf[_from] -= _value;
52         balanceOf[_to] += _value;
53         emit Transfer(_from, _to, _value);
54         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
55     }
56     function transfer(address _to, uint256 _value) public returns (bool success) {
57         _transfer(msg.sender, _to, _value);
58         return true;
59     }
60     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61         require(_value <= allowance[_from][msg.sender]);
62         allowance[_from][msg.sender] -= _value;
63         _transfer(_from, _to, _value);
64         return true;
65     }
66     function approve(address _spender, uint256 _value) public
67         returns (bool success) {
68         allowance[msg.sender][_spender] = _value;
69         emit Approval(msg.sender, _spender, _value);
70         return true;
71     }
72     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
73         public
74         returns (bool success) {
75         tokenRecipient spender = tokenRecipient(_spender);
76         if (approve(_spender, _value)) {
77             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
78             return true;
79         }
80     }
81     function burn(uint256 _value) public returns (bool success) {
82         require(balanceOf[msg.sender] >= _value);
83         balanceOf[msg.sender] -= _value;
84         totalSupply -= _value;
85         emit Burn(msg.sender, _value);
86         return true;
87     }
88     function burnFrom(address _from, uint256 _value) public returns (bool success) {
89         require(balanceOf[_from] >= _value);
90         require(_value <= allowance[_from][msg.sender]);
91         balanceOf[_from] -= _value;
92         allowance[_from][msg.sender] -= _value;
93         totalSupply -= _value;
94         emit Burn(_from, _value);
95         return true;
96     }
97 }
98 
99 contract ModenEnt is owned, TokenERC20 {
100     uint256 public sellPrice;
101     uint256 public buyPrice;
102     mapping (address => bool) public frozenAccount;
103     event FrozenFunds(address target, bool frozen);
104     constructor(
105         uint256 initialSupply,
106         string memory tokenName,
107         string memory tokenSymbol
108     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
109     function _transfer(address _from, address _to, uint _value) internal {
110         require (_to != address(0x0));
111         require (balanceOf[_from] >= _value);
112         require (balanceOf[_to] + _value >= balanceOf[_to]);
113         require(!frozenAccount[_from]);
114         require(!frozenAccount[_to]);
115         balanceOf[_from] -= _value;
116         balanceOf[_to] += _value;
117         emit Transfer(_from, _to, _value);
118     }
119     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
120         balanceOf[target] += mintedAmount;
121         totalSupply += mintedAmount;
122         emit Transfer(address(0), address(this), mintedAmount);
123         emit Transfer(address(this), target, mintedAmount);
124     }
125     function freezeAccount(address target, bool freeze) onlyOwner public {
126         frozenAccount[target] = freeze;
127         emit FrozenFunds(target, freeze);
128     }
129     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
130         sellPrice = newSellPrice;
131         buyPrice = newBuyPrice;
132     }
133     function buy() payable public {
134         uint amount = msg.value / buyPrice;
135         _transfer(address(this), msg.sender, amount);
136     }
137     function sell(uint256 amount) public {
138         address myAddress = address(this);
139         require(myAddress.balance >= amount * sellPrice);
140         _transfer(msg.sender, address(this), amount);
141         msg.sender.transfer(amount * sellPrice);
142     }
143     function giveBlockReward() public {
144         balanceOf[block.coinbase] += 10;
145     }
146 }