1 contract owned {
2     address public owner;
3 
4     constructor() public {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         require(msg.sender == owner);
10         _;
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner public {
14         owner = newOwner;
15     }
16 }
17 
18 contract Botcash is owned {
19     uint256 totalSupply;
20     string public name;
21     string public symbol;
22     uint8 public decimals;
23     uint public minBalanceForAccounts;
24     uint256 sellPrice;
25     uint256 buyPrice;
26 
27     mapping (address => uint256) public balanceOf;
28     mapping (address => bool) public frozenAccount;
29     event FrozenFunds(address target, bool frozen);
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     constructor(uint256 initialSupply, string memory tokenName, string memory tokenSymbol, uint8 decimalUnits, address centralMinter) public {
34         if (centralMinter != 0) owner = centralMinter;
35         totalSupply = initialSupply * 10 ** uint256(decimals);
36         balanceOf[msg.sender] = totalSupply;
37         name = tokenName;
38         symbol = tokenSymbol;
39         decimals = decimalUnits;
40     }
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != address(0x0));
44         require (balanceOf[_from] >= _value);
45         require (balanceOf[_to] + _value >= balanceOf[_to]);
46         require(!frozenAccount[_from]);
47         require(!frozenAccount[_to]);
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         emit Transfer(_from, _to, _value);
51     }
52 
53     function transfer(address _to, uint256 _value) public {
54         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
55 
56         balanceOf[msg.sender] -= _value;
57         balanceOf[_to] += _value;
58 
59         if (msg.sender.balance < minBalanceForAccounts)
60             sell((minBalanceForAccounts - msg.sender.balance) / sellPrice);
61 
62 
63         emit Transfer(msg.sender, _to, _value);
64     }
65 
66     function mintToken(address target, uint256 mintedAmount) onlyOwner public{
67         balanceOf[target] += mintedAmount;
68         totalSupply += mintedAmount;
69         emit Transfer(0, owner, mintedAmount);
70         emit Transfer(owner, target, mintedAmount);
71     }
72 
73     function freezeAccount(address target, bool freeze) onlyOwner public {
74         frozenAccount[target] = freeze;
75         emit FrozenFunds(target, freeze);
76     }
77 
78     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
79         sellPrice = newSellPrice;
80         buyPrice = newBuyPrice;
81     }
82 
83 
84     function buy() public payable returns (uint amount) {
85         amount = msg.value / buyPrice;
86         _transfer(address(this), msg.sender, amount);
87         return amount;
88     }
89 
90     function sell(uint amount) public returns (uint revenue) {
91         require(balanceOf[msg.sender] >= amount);
92         balanceOf[address(this)] += amount;
93         balanceOf[msg.sender] -= amount;
94         revenue = amount * sellPrice;
95         msg.sender.transfer(revenue);
96         emit Transfer(msg.sender, address(this), amount);
97         return revenue;
98     }
99 
100     function setMinBalance(uint minimumBalanceInFinney) onlyOwner public {
101         minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
102     }
103 
104 }