1 pragma solidity ^0.5.0;
2 
3 contract ZTY {
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
14     address payable public  owner;
15     uint256 public totalSupply;
16 
17     constructor () public {
18         balances[msg.sender] = 4485600000000000000000000000;
19         totalSupply = 4485600000000000000000000000;
20         name = "Zity";
21         decimals = 18;
22         symbol = "ZTY";
23         owner = msg.sender;
24         sellPrice = 8;
25         numDecimalsSellPrice = 10000;
26         buyPrice = 8;
27         numDecimalsBuyPrice = 10000;
28     }
29 
30     function recieveFunds() external payable {
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
48     function transferOwnership(address payable newOwner) public onlyOwner {
49         owner = newOwner;
50         emit TransferOwnership(newOwner); 
51     }
52     
53     function setPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice) public onlyOwner {
54         sellPrice = newSellPrice;
55         buyPrice = newBuyPrice;
56         numDecimalsBuyPrice = newnumDecimalsBuyPrice;
57         numDecimalsSellPrice = newnumDecimalsSellPrice;
58         emit SetPrices(newSellPrice, newnumDecimalsSellPrice, newBuyPrice, newnumDecimalsBuyPrice);
59     }
60 
61     function buy()public payable  returns (uint256 _value){
62         _value = (msg.value * numDecimalsBuyPrice) / buyPrice;
63         require (balances[address (this)] >= _value);
64         balances[msg.sender] += _value;
65         balances[address (this)] -= _value;
66         emit Buy(address (this), msg.sender, _value);
67         return _value;
68     }  
69 
70     function sell(uint256 _value) public returns (uint256 revenue){
71         require(balances[msg.sender] >= _value);
72         balances[address (this)] += _value;         
73         balances[msg.sender] -= _value;                  
74         revenue =   (_value * sellPrice) /numDecimalsSellPrice;
75         msg.sender.transfer(revenue);
76         emit Sell(msg.sender, address (this), _value);             
77         return revenue;                                   
78     }   
79 
80     function transfer(address _to, uint256 _value) public returns (bool success) {
81         require (_to != address(0x0));
82         require(balances[msg.sender] >= _value);
83         balances[msg.sender] -= _value;
84         balances[_to] += _value;
85         emit Transfer(msg.sender, _to, _value); 
86         return true;
87     }
88 
89     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
90         uint256 allowance = allowed[_from][msg.sender];
91         require (_to != address(0x0));
92         require(balances[_from] >= _value && allowance >= _value);
93         balances[_to] += _value;
94         balances[_from] -= _value;
95         allowed[_from][msg.sender] -= _value;
96         emit Transfer(_from, _to, _value); 
97         return true;
98     }
99 
100     function balanceOf(address _owner) public view returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         allowed[msg.sender][_spender] = _value;
106         emit Approval(msg.sender, _spender, _value); 
107         return true;
108     }
109 
110     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
111         return allowed[_owner][_spender];
112     }
113  
114     function burn(uint256 _value) public onlyOwner returns (bool success) {
115         require(balances[msg.sender] >= _value);   // Check if the sender has enough
116         balances[msg.sender] -= _value;            // Subtract from the sender
117         totalSupply -= _value;                      // Updates totalSupply
118         emit Burn(msg.sender, _value);
119         return true;
120     }
121     
122     function selfdestructcontract () public onlyOwner {
123         selfdestruct(owner);
124         
125     }
126     
127     event Transfer(address indexed _from, address indexed _to, uint256 _value);
128     event Sell(address indexed _from, address indexed _to, uint256 _value);
129     event Buy(address indexed _from, address indexed _to, uint256 _value);
130     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
131     event Burn(address indexed _from, uint256 value);
132     event SetPrices(uint256 newSellPrice, uint256 newnumDecimalsSellPrice, uint256 newBuyPrice, uint256 newnumDecimalsBuyPrice);
133     event TransferOwnership(address indexed newOwner);
134     event ReturnFunds(address indexed _from, uint256 _value);
135     event ReciveFunds(address indexed _from, uint256 _value);
136 }