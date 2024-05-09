1 pragma solidity ^0.4.24;
2 
3 contract owned {
4     address public owner;
5 
6     constructor () public {
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
25     uint8 public decimals = 18;
26     uint256 public totalSupply;
27 
28     mapping (address => uint256) public balanceOf;
29     mapping (address => mapping (address => uint256)) public allowance;
30 
31     event Transfer(address indexed from, address indexed to, uint256 value);
32 
33     event Burn(address indexed from, uint256 value);
34 
35     constructor () public {
36         totalSupply = 100000000000000000000000000;  
37         balanceOf[msg.sender] = totalSupply;                
38         name = "SensusNetwork";                                 
39         symbol = "SENX";                             
40     }
41 
42     function _transfer(address _from, address _to, uint _value) internal {
43         require(_to != 0x0);
44         require(balanceOf[_from] >= _value);
45         require(balanceOf[_to] + _value > balanceOf[_to]);
46         uint previousBalances = balanceOf[_from] + balanceOf[_to];
47         balanceOf[_from] -= _value;
48         balanceOf[_to] += _value;
49         emit Transfer(_from, _to, _value);
50         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
51     }
52 
53     function transfer(address _to, uint256 _value) public {
54         _transfer(msg.sender, _to, _value);
55     }
56 
57     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
58         require(_value <= allowance[_from][msg.sender]);     // Check allowance
59         allowance[_from][msg.sender] -= _value;
60         _transfer(_from, _to, _value);
61         return true;
62     }
63 
64     function approve(address _spender, uint256 _value) public
65         returns (bool success) {
66         allowance[msg.sender][_spender] = _value;
67         return true;
68     }
69 
70     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
71         public
72         returns (bool success) {
73         tokenRecipient spender = tokenRecipient(_spender);
74         if (approve(_spender, _value)) {
75             spender.receiveApproval(msg.sender, _value, this, _extraData);
76             return true;
77         }
78     }
79 }
80 
81 contract SensusNetwork is owned, TokenERC20 {
82 
83     function _transfer(address _from, address _to, uint _value) internal {
84         require (_to != 0x0);                               
85         require (balanceOf[_from] >= _value);              
86         require (balanceOf[_to] + _value >= balanceOf[_to]);
87         balanceOf[_from] -= _value;                       
88         balanceOf[_to] += _value;                         
89         emit Transfer(_from, _to, _value);
90     }
91 }