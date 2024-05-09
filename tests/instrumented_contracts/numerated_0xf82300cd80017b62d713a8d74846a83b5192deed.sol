1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18 }
19 
20 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; }
21 
22 contract TokenERC20 {
23     string public name;
24     string public symbol;
25     uint8 public decimals = 8;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Burn(address indexed from, uint256 value);
31 
32     function TokenERC20(
33         uint256 initialSupply,
34         string tokenName,
35         string tokenSymbol
36     ) public {
37         totalSupply = initialSupply * 10 ** uint256(decimals);  
38         balanceOf[msg.sender] = totalSupply;               
39         name = tokenName;                                   
40         symbol = tokenSymbol;                              
41     }
42 
43     function _transfer(address _from, address _to, uint _value) internal {
44         require(_to != 0x0);
45         require(balanceOf[_from] >= _value);
46         require(balanceOf[_to] + _value > balanceOf[_to]);
47         uint previousBalances = balanceOf[_from] + balanceOf[_to];
48         balanceOf[_from] -= _value;
49         balanceOf[_to] += _value;
50         Transfer(_from, _to, _value);
51         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
52     }
53 
54     function transfer(address _to, uint256 _value) public {
55         _transfer(msg.sender, _to, _value);
56     }
57 
58     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
59         _transfer(_from, _to, _value);
60         return true;
61     }
62 
63     function burn(uint256 _value) public returns (bool success) {
64         require(balanceOf[msg.sender] >= _value);   
65         balanceOf[msg.sender] -= _value;           
66         totalSupply -= _value;                    
67         Burn(msg.sender, _value);
68         return true;
69     }
70 
71 }
72 
73 contract PussyToken is owned, TokenERC20 {
74 
75     uint256 public buyPrice;
76     mapping (address => bool) public frozenAccount;
77     event FrozenFunds(address target, bool frozen);
78 
79     function PussyToken(
80         uint256 initialSupply,
81         string tokenName,
82         string tokenSymbol
83     ) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
84 
85     function _transfer(address _from, address _to, uint _value) internal {
86         require (_to != 0x0);                              
87         require (balanceOf[_from] >= _value);               
88         require (balanceOf[_to] + _value >= balanceOf[_to]); 
89         require(!frozenAccount[_from]);                     
90         require(!frozenAccount[_to]);                    
91         balanceOf[_from] -= _value;                        
92         balanceOf[_to] += _value;                           
93         Transfer(_from, _to, _value);
94     }
95 
96     function freezeAccount(address target, bool freeze) onlyOwner public {
97         frozenAccount[target] = freeze;
98         FrozenFunds(target, freeze);
99     }
100 
101     function setPrices(  uint256 newBuyPrice) onlyOwner public {
102         buyPrice = newBuyPrice;
103     }
104 
105     function withdraw() onlyOwner public {
106         msg.sender.transfer(this.balance);
107     }
108     function () payable public {
109         uint amount = msg.value / buyPrice;               
110         _transfer(this, msg.sender, amount);             
111     }
112 }