1 pragma solidity ^0.4.18;
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
15     //function transferOwnership(address newOwner) onlyOwner public {
16     //    owner = newOwner;
17     //}
18 } 
19 
20 contract GoldTokenERC20 is owned {
21     string public name;
22     string public symbol;
23     uint8 public decimals = 8; 
24     uint256 public totalSupply;
25     mapping (address => bool) public frozenAccount;
26     
27     /* This generates a public event on the blockchain that will notify clients */
28     event FrozenFunds(address target, bool frozen);
29 
30     mapping (address => uint256) public balanceOf;
31     mapping (address => mapping (address => uint256)) public allowance;
32 
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Burn(address indexed from, uint256 value);
35 
36 
37     function GoldTokenERC20() public {
38         totalSupply = 100000000 * 10 ** uint256(decimals); 
39         balanceOf[msg.sender] = totalSupply;              
40         name = "GoldToken";                                 
41         symbol = "GOLD";                            
42     }
43 
44     function _transfer(address _from, address _to, uint _value) internal {
45   
46         require(_to != 0x0);
47 
48         require(balanceOf[_from] >= _value);
49 
50         require(balanceOf[_to] + _value > balanceOf[_to]);
51         require(!frozenAccount[_from]);                     
52         require(!frozenAccount[_to]);  
53         
54         uint previousBalances = balanceOf[_from] + balanceOf[_to];
55         // Subtract from the sender
56         balanceOf[_from] -= _value;
57         // Add the same to the recipient
58         balanceOf[_to] += _value;
59         Transfer(_from, _to, _value);
60 
61         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
62     }
63 
64     function transfer(address _to, uint256 _value) public {
65         _transfer(msg.sender, _to, _value);
66     }
67 
68 
69     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
70         require(_value <= allowance[_from][msg.sender]);     // Check allowance
71         allowance[_from][msg.sender] -= _value;
72         _transfer(_from, _to, _value);
73         return true;
74     }
75 
76     function approve(address _spender, uint256 _value) public
77         returns (bool success) {
78         allowance[msg.sender][_spender] = _value;
79         return true;
80     }
81 
82     function burn(uint256 _value) public returns (bool success) {
83         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
84         balanceOf[msg.sender] -= _value;            // Subtract from the sender
85         totalSupply -= _value;                      // Updates totalSupply
86         Burn(msg.sender, _value);
87         return true;
88     }
89 
90     function burnFrom(address _from, uint256 _value) onlyOwner public returns (bool success) {
91         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
92         require(_value <= allowance[_from][msg.sender]);    // Check allowance
93         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
94         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
95         totalSupply -= _value;                              // Update totalSupply
96         Burn(_from, _value);
97         return true;
98     }
99     
100     function mintToken(address target, uint256 initialSupply) onlyOwner public {
101         balanceOf[target] += initialSupply;
102         totalSupply += initialSupply;
103         Transfer(0, this, initialSupply);
104         Transfer(this, target, initialSupply);
105     } 
106    
107    
108     function freezeAccount(address target, bool freeze) onlyOwner public {
109         frozenAccount[target] = freeze;
110         FrozenFunds(target, freeze);
111     }
112 
113 
114 
115 }