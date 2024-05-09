1 pragma solidity ^0.4.18;
2 
3 // sol to CIC Coin
4 // 
5 // Senior Development Engineer  CHIEH-HSUAN WANG of Lucas. 
6 // Jason Wang  <ixhxpns@gmail.com>
7 // reference https://ethereum.org/token
8 
9 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
10 contract owned {
11     address public owner;
12     
13 
14     constructor()public{
15        owner = msg.sender; 
16     }
17     
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22     
23     // 实现所有权转移
24     function transferOwnership(address newOwner) public onlyOwner {
25         owner = newOwner;
26     }
27 }
28 
29 //Only owner can use
30 contract CIC is owned {
31     address public deployer;
32     
33     string public name;
34     
35     string public symbol;
36     
37     uint8 public decimals = 4; 
38     
39     uint256 public totalSupply;
40     
41     mapping (address => uint256) public balanceOf; 
42     
43     mapping (address => mapping (address => uint256)) public allowance;
44 
45     event Transfer(address indexed from, address indexed to, uint256 value);
46 
47     event Burn(address indexed from, uint256 value);
48 
49     constructor(uint256 initialSupply, string tokenName, string tokenSymbol, address centralMinter) public {
50         if(centralMinter != 0 ) owner = centralMinter;
51         totalSupply = initialSupply * 10 ** uint256(decimals);
52         balanceOf[msg.sender] = totalSupply;
53         name = tokenName;
54         symbol = tokenSymbol;
55         deployer = msg.sender;
56     }
57     
58     function mintToken(address target, uint256 mintedAmount) public onlyOwner {
59         balanceOf[target] += mintedAmount;
60         totalSupply += mintedAmount;
61         emit Transfer(0, owner, mintedAmount);
62         emit Transfer(owner, target, mintedAmount);
63     }
64 
65     /*uint minBalanceForAccounts;
66 
67     function setMinBalance(uint minimumBalanceInFinney) public onlyOwner {
68          minBalanceForAccounts = minimumBalanceInFinney * 1 finney;
69     }*/
70     
71     function _transfer(address _from, address _to, uint _value) internal {
72         require(_to != 0x0);
73         require(balanceOf[_from] >= _value);
74         require(balanceOf[_to] + _value > balanceOf[_to]);
75         uint previousBalances = balanceOf[_from] + balanceOf[_to];
76         balanceOf[_from] -= _value;
77         balanceOf[_to] += _value;
78         emit Transfer(_from, _to, _value);
79         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
80     }
81 
82     function transfer(address _to, uint256 _value) public {
83         if (_to == 0x0) revert();
84 		if (_value <= 0) revert();
85         if (balanceOf[msg.sender] < _value) revert();
86         if (balanceOf[_to] + _value < balanceOf[_to]) revert();
87         emit Transfer(msg.sender, _to, _value);                  
88 
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
92         require(_value <= allowance[_from][msg.sender]);     
93         allowance[_from][msg.sender] -= _value;
94         _transfer(_from, _to, _value);
95         return true;
96     }
97 
98     function approve(address _spender, uint256 _value) public
99         returns (bool success) {
100         allowance[msg.sender][_spender] = _value;
101         return true;
102     }
103 
104     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
105         tokenRecipient spender = tokenRecipient(_spender);
106         if (approve(_spender, _value)) {
107             spender.receiveApproval(msg.sender, _value, this, _extraData);
108             return true;
109         }
110     }
111 
112     function burn(uint256 _value) public returns (bool success) {
113         require(balanceOf[msg.sender] >= _value);
114         balanceOf[msg.sender] -= _value;
115         totalSupply -= _value;
116         emit Burn(msg.sender, _value);
117         return true;
118     }
119 
120     function burnFrom(address _from, uint256 _value) public returns (bool success) {
121         require(balanceOf[_from] >= _value);
122         require(_value <= allowance[_from][msg.sender]);
123         balanceOf[_from] -= _value;
124         allowance[_from][msg.sender] -= _value;
125         totalSupply -= _value;
126         emit Burn(_from, _value);
127         return true;
128     }
129 }