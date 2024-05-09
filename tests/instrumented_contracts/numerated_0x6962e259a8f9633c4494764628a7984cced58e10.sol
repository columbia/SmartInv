1 pragma solidity ^0.4.16;
2 
3 contract AztraToken {
4     string public name;
5     string public symbol;
6     uint8 public decimals = 18;
7     uint256 public totalSupply;
8     address public owner;
9 
10     mapping (address => uint256) public balanceOf;
11     mapping (address => mapping (address => uint256)) public allowance;
12     mapping (address => bool) public frozenAccount;
13 
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Burn(address indexed from, uint256 value);
16     event FrozenFunds(address target, bool frozen);
17 
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     function AztraToken() public {
24         totalSupply = 5000000000 * 10 ** uint256(decimals);
25         balanceOf[msg.sender] = totalSupply;
26         name = "Aztra";
27         symbol = "AztraCoin";
28         owner = msg.sender;
29     }
30 
31     function _transfer(address _from, address _to, uint _value) internal {
32         require(_to != 0x0);
33         require(balanceOf[_from] >= _value);
34         require(balanceOf[_to] + _value > balanceOf[_to]);
35         require(!frozenAccount[_from]);
36         require(!frozenAccount[_to]);
37         uint previousBalances = balanceOf[_from] + balanceOf[_to];
38         balanceOf[_from] -= _value;
39         balanceOf[_to] += _value;
40         Transfer(_from, _to, _value);
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
42     }
43 
44     function transfer(address _to, uint256 _value) public {
45         _transfer(msg.sender, _to, _value);
46     }
47 
48     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
49         require(_value <= allowance[_from][msg.sender]);     
50         allowance[_from][msg.sender] -= _value;
51         _transfer(_from, _to, _value);
52         return true;
53     }
54 
55     function approve(address _spender, uint256 _value) public returns (bool success) {
56         allowance[msg.sender][_spender] = _value;
57         return true;
58     }
59 
60     function burn(uint256 _value) public returns (bool success) {
61         require(balanceOf[msg.sender] >= _value);   
62         balanceOf[msg.sender] -= _value;            
63         totalSupply -= _value;                      
64         Burn(msg.sender, _value);
65         return true;
66     }
67 
68     function burnFrom(address _from, uint256 _value) public returns (bool success) {
69         require(balanceOf[_from] >= _value);                
70         require(_value <= allowance[_from][msg.sender]);    
71         balanceOf[_from] -= _value;                         
72         allowance[_from][msg.sender] -= _value;             
73         totalSupply -= _value;                              
74         Burn(_from, _value);
75         return true;
76     }
77 
78     function mintToken(address target, uint256 mintedAmount) onlyOwner public {
79         balanceOf[target] += mintedAmount;
80         totalSupply += mintedAmount;
81         Transfer(0, this, mintedAmount);
82         Transfer(this, target, mintedAmount);
83     }
84 
85     function freezeAccount(address target, bool freeze) onlyOwner public {
86         frozenAccount[target] = freeze;
87         FrozenFunds(target, freeze);
88     }
89 
90     function transferOwnership(address newOwner) onlyOwner public {
91         owner = newOwner;
92     }
93 }