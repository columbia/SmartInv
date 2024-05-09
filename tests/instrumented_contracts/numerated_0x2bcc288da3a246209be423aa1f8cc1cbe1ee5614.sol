1 pragma solidity ^0.4.25;
2 
3 contract G2X {
4 
5     mapping (address => uint256) public balances;
6     mapping (address => mapping (address => uint256)) public allowed;
7     uint256 public sellPrice;
8     uint256 public buyPrice;
9     uint256 public numDecimalsBuyPrice;
10     uint256 public numDecimalsSellPrice;
11     string public name;                   
12     uint8 public decimals;                
13     string public symbol;                 
14     address public owner;
15     uint256 public totalSupply;
16 
17     constructor () public {
18         balances[msg.sender] = 72313360000000000000000000;
19         totalSupply = 72313360000000000000000000;
20         name = "GOW2X";
21         decimals = 18;
22         symbol = "G2X";
23         owner = msg.sender;
24         sellPrice = 6;
25         numDecimalsSellPrice = 100000;
26         buyPrice = 6;
27         numDecimalsBuyPrice = 100000;
28     }
29 
30     function recieveFunds() public payable {
31         emit ReciveFunds(msg.sender,msg.value);   
32     } 
33     
34     function returnFunds(uint256 _value) public onlyOwner {
35         require (address (this).balance >= _value);
36         owner.transfer (_value);
37         emit ReturnFunds(msg.sender, _value);
38     }
39     
40     function getBalance() public view returns(uint256) { 
41         return address(this).balance; 
42     }    
43 
44     modifier onlyOwner {
45         require(msg.sender == owner);
46         _;
47     }
48 
49     function transferOwnership(address newOwner) public onlyOwner {
50         owner = newOwner;
51         emit TransferOwnership(newOwner); 
52     }  
53 
54     function setPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice) public onlyOwner {
55         sellPrice = newSellPrice;
56         buyPrice = newBuyPrice;
57         numDecimalsBuyPrice = newnumDecimalsBuyPrice;
58         numDecimalsSellPrice = newnumDecimalsSellPrice;
59         emit SetPrices(newSellPrice, newnumDecimalsSellPrice, newBuyPrice, newnumDecimalsBuyPrice);
60     }
61 
62     function buy()public payable  returns (uint256 _value){
63         _value = (msg.value * numDecimalsBuyPrice) / buyPrice;
64         require(balances[this] >= _value);
65         balances[msg.sender] += _value;
66         balances[this] -= _value;
67         emit Buy(this, msg.sender, _value);
68         return _value;
69     }  
70 
71     function sell(uint256 _value) public returns (uint256 revenue){
72         require(balances[msg.sender] >= _value);
73         balances[this] += _value;         
74         balances[msg.sender] -= _value;                  
75         revenue =   (_value * sellPrice) /numDecimalsSellPrice;
76         msg.sender.transfer(revenue);
77         emit Sell(msg.sender, this, _value);             
78         return revenue;                                   
79     }   
80 
81     function transfer(address _to, uint256 _value) public returns (bool success) {
82         require (_to != (0x0));
83         require(balances[msg.sender] >= _value);
84         balances[msg.sender] -= _value;
85         balances[_to] += _value;
86         emit Transfer(msg.sender, _to, _value); 
87         return true;
88     }
89 
90     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
91         uint256 allowance = allowed[_from][msg.sender];
92         require (_to != (0x0));
93         require(balances[_from] >= _value && allowance >= _value);
94         balances[_to] += _value;
95         balances[_from] -= _value;
96         allowed[_from][msg.sender] -= _value;
97         emit Transfer(_from, _to, _value); 
98         return true;
99     }
100 
101     function balanceOf(address _owner) public view returns (uint256 balance) {
102         return balances[_owner];
103     }
104 
105     function approve(address _spender, uint256 _value) public returns (bool success) {
106         allowed[msg.sender][_spender] = _value;
107         emit Approval(msg.sender, _spender, _value); 
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }
114  
115     function burn(uint256 _value) public onlyOwner returns (bool success) {
116         require(balances[msg.sender] >= _value);   // Check if the sender has enough
117         balances[msg.sender] -= _value;            // Subtract from the sender
118         totalSupply -= _value;                      // Updates totalSupply
119         emit Burn(msg.sender, _value);
120         return true;
121     }
122 
123     event Transfer(address indexed _from, address indexed _to, uint256 _value);
124     event Sell(address indexed _from, address indexed _to, uint256 _value);
125     event Buy(address indexed _from, address indexed _to, uint256 _value);
126     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
127     event Burn(address indexed _from, uint256 value);
128     event SetPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice);
129     event TransferOwnership(address indexed newOwner);
130     event ReturnFunds(address indexed _from, uint256 _value);
131     event ReciveFunds(address indexed _from, uint256 _value);
132 }