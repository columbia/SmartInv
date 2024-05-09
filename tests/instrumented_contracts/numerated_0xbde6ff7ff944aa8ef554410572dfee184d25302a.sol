1 pragma solidity ^0.4.18;
2 
3 contract SafeMath {
4   function safeMul(uint256 a, uint256 b) internal pure returns (uint256) {
5     uint256 c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9 
10   function safeDiv(uint256 a, uint256 b) internal pure returns (uint256) {
11     assert(b > 0);
12     uint256 c = a / b;
13     assert(a == b * c + a % b);
14     return c;
15   }
16 
17   function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
18     assert(b <= a);
19     return a - b;
20   }
21 
22   function safeAdd(uint256 a, uint256 b) internal pure returns (uint256) {
23     uint256 c = a + b;
24     assert(c>=a && c>=b);
25     return c;
26   }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     function owned() public {
35         owner = msg.sender;
36     }
37 
38     modifier onlyOwner {
39         require(msg.sender == owner);
40         _;
41     }
42 
43     function transferOwnership(address newOwner) onlyOwner public {
44        require(newOwner != address(0));
45        OwnershipTransferred(owner, newOwner);
46        owner = newOwner;
47     }
48 }
49 
50 contract TokenERC20 is SafeMath {
51 
52     string public name;
53     string public symbol;
54     uint8 public decimals = 18;
55     uint256 public totalSupply;
56 
57     mapping (address => uint256) public balanceOf;
58     mapping (address => mapping (address => uint256)) public allowance;
59 
60     event Transfer(address indexed from, address indexed to, uint256 value);
61 
62     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
63         totalSupply = initialSupply * 10 ** uint256(decimals); 
64         balanceOf[msg.sender] = totalSupply;                
65         name = tokenName;                                   
66         symbol = tokenSymbol;  
67     }                             
68 
69     function _transfer(address _from, address _to, uint256 _value) private {
70         require(_to != 0x0);	
71         require(balanceOf[_from] >= _value); 
72         require(balanceOf[_to] + _value > balanceOf[_to]); 
73         uint256 previousBalances = SafeMath.safeAdd(balanceOf[_from],balanceOf[_to]); 
74         balanceOf[_from] = SafeMath.safeSub(balanceOf[_from], _value); 
75         balanceOf[_to] = SafeMath.safeAdd(balanceOf[_to], _value); 
76         Transfer(_from, _to, _value);
77         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
78     }
79 
80     function transfer(address _to, uint256 _value) public {
81         _transfer(msg.sender, _to, _value);
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         require(_value <= allowance[_from][msg.sender]);
86         allowance[_from][msg.sender] = SafeMath.safeSub(allowance[_from][msg.sender], _value);
87         _transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public returns (bool success) {
92         allowance[msg.sender][_spender] = _value;
93         return true;
94     }
95 }
96 
97 contract ABBToken is owned, TokenERC20 {
98 
99     mapping (address => bool) public frozenAccount;
100 	
101     event FrozenFunds(address target, bool frozen);
102     event Burn(address indexed from, uint256 value);
103 
104     function ABBToken(uint256 initialSupply, string tokenName, string tokenSymbol) TokenERC20(initialSupply, tokenName, tokenSymbol) public {}
105     
106 	function burn(uint256 _value) onlyOwner public returns (bool success) {
107         require(balanceOf[msg.sender] >= _value);  
108         balanceOf[msg.sender] = SafeMath.safeSub(balanceOf[msg.sender], _value);          
109         totalSupply = SafeMath.safeSub(totalSupply, _value);                     
110         Burn(msg.sender, _value);
111         return true;
112     }
113  
114     function freezeAccount(address target, bool freeze) onlyOwner public {
115         frozenAccount[target] = freeze;
116         FrozenFunds(target, freeze);
117     }
118 }