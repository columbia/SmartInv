1 pragma solidity >=0.4.22 <0.6.0;
2 contract owned {
3     address public owner;
4     constructor() public {
5         owner = msg.sender;
6     }
7     modifier onlyOwner {
8         require(msg.sender == owner);
9         _;
10     }
11     function transferOwnership(address newOwner) onlyOwner public {
12         owner = newOwner;
13     }
14 }
15 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes calldata _extraData) external; }
16 contract TokenERC20 {
17     string public name;
18     string public symbol;
19     uint8 public decimals = 18;
20     uint256 public totalSupply;
21     mapping (address => uint256) public balanceOf;
22     mapping (address => mapping (address => uint256)) public allowance;
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
25     event Burn(address indexed from, uint256 value);
26     constructor(
27         uint256 initialSupply,
28         string memory tokenName,
29         string memory tokenSymbol
30     ) public {
31         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
32         balanceOf[msg.sender] = totalSupply;                    // Give the creator all initial tokens
33         name = tokenName;                                       // Set the name for display purposes
34         symbol = tokenSymbol;                                   // Set the symbol for display purposes
35     }
36     function _transfer(address _from, address _to, uint _value) internal {
37         require(_to != address(0x0));
38         require(balanceOf[_from] >= _value);
39         require(balanceOf[_to] + _value > balanceOf[_to]);
40         uint previousBalances = balanceOf[_from] + balanceOf[_to];
41         balanceOf[_from] -= _value;
42         balanceOf[_to] += _value;
43         emit Transfer(_from, _to, _value);
44         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
45     }
46     function transfer(address _to, uint256 _value) public returns (bool success) {
47         _transfer(msg.sender, _to, _value);
48         return true;
49     }
50     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
51         require(_value <= allowance[_from][msg.sender]);     // Check allowance
52         allowance[_from][msg.sender] -= _value;
53         _transfer(_from, _to, _value);
54         return true;
55     }
56     function approve(address _spender, uint256 _value) public
57         returns (bool success) {
58         allowance[msg.sender][_spender] = _value;
59         emit Approval(msg.sender, _spender, _value);
60         return true;
61     }
62     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData)
63         public
64         returns (bool success) {
65         tokenRecipient spender = tokenRecipient(_spender);
66         if (approve(_spender, _value)) {
67             spender.receiveApproval(msg.sender, _value, address(this), _extraData);
68             return true;
69         }
70     }
71     function burn(uint256 _value) public returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);  
73         balanceOf[msg.sender] -= _value;            
74         totalSupply -= _value;                     
75         emit Burn(msg.sender, _value);
76         return true;
77     }
78     function burnFrom(address _from, uint256 _value) public returns (bool success) {
79         require(balanceOf[_from] >= _value);             
80         require(_value <= allowance[_from][msg.sender]);    
81         balanceOf[_from] -= _value;                         
82         allowance[_from][msg.sender] -= _value;           
83         totalSupply -= _value;                             
84         emit Burn(_from, _value);
85         return true;
86     }
87 }contract DCCBToken is owned, TokenERC20 {
88     uint256 public sellPrice;
89     uint256 public buyPrice;
90     mapping (address => bool) public frozenAccount;
91     event FrozenFunds(address target, bool frozen);
92     constructor(
93         uint256 initialSupply,
94         string memory tokenName,
95         string memory tokenSymbol
96     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
97     function _transfer(address _from, address _to, uint _value) internal {
98         require (_to != address(0x0));                         
99         require (balanceOf[_from] >= _value);                  
100         require (balanceOf[_to] + _value >= balanceOf[_to]);    
101         require(!frozenAccount[_from]);                        
102         require(!frozenAccount[_to]);                         
103         balanceOf[_from] -= _value;                          
104         balanceOf[_to] += _value;                              
105         emit Transfer(_from, _to, _value);
106     }function freezeAccount(address target, bool freeze) onlyOwner public {
107         frozenAccount[target] = freeze;
108         emit FrozenFunds(target, freeze);
109     }function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
110         sellPrice = newSellPrice;
111         buyPrice = newBuyPrice;
112     } function buy() payable public {
113         uint amount = msg.value / buyPrice;                 
114         _transfer(address(this), msg.sender, amount); 
115     } function sell(uint256 amount) public {
116         address myAddress = address(this);
117         require(myAddress.balance >= amount * sellPrice);  
118         _transfer(msg.sender, address(this), amount);     
119         msg.sender.transfer(amount * sellPrice);          
120     }
121 }