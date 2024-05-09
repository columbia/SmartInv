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
22 contract FancyAssetsCoin {
23     string public constant _myTokeName = 'Fancy Assets Coin';
24     string public constant _mySymbol = 'FNAC';
25     uint public constant _myinitialSupply = 21000000;
26     uint8 public constant _myDecimal = 0;
27 
28     string public name;
29     string public symbol;
30     uint8 public decimals;
31    
32     uint256 public totalSupply;
33 
34    
35     mapping (address => uint256) public balanceOf;
36     mapping (address => mapping (address => uint256)) public allowance;
37 
38     
39     event Transfer(address indexed from, address indexed to, uint256 value);
40 
41     function FancyAssetsCoin(
42         uint256 initialSupply,
43         string TokeName,
44         string Symbol
45     ) public {
46         decimals = _myDecimal;
47         totalSupply = _myinitialSupply * (10 ** uint256(_myDecimal)); 
48         balanceOf[msg.sender] = initialSupply;               
49         name = TokeName;                                   
50         symbol = Symbol;                               
51     }
52 
53 
54     function _transfer(address _from, address _to, uint _value) internal {
55 
56         require(_to != 0x0);
57 
58         require(balanceOf[_from] >= _value);
59 
60         require(balanceOf[_to] + _value > balanceOf[_to]);
61 
62         uint previousBalances = balanceOf[_from] + balanceOf[_to];
63 
64         balanceOf[_from] -= _value;
65 
66         balanceOf[_to] += _value;
67         Transfer(_from, _to, _value);
68 
69         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
70     }
71 
72     function transfer(address _to, uint256 _value) public {
73         _transfer(msg.sender, _to, _value);
74     }
75 
76     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
77         require(_value <= allowance[_from][msg.sender]);     
78         allowance[_from][msg.sender] -= _value;
79         _transfer(_from, _to, _value);
80         return true;
81     }
82 
83     function approve(address _spender, uint256 _value) public
84         returns (bool success) {
85         allowance[msg.sender][_spender] = _value;
86         return true;
87     }
88 
89     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
90         public
91         returns (bool success) {
92         tokenRecipient spender = tokenRecipient(_spender);
93         if (approve(_spender, _value)) {
94             spender.receiveApproval(msg.sender, _value, this, _extraData);
95             return true;
96         }
97     }
98 }