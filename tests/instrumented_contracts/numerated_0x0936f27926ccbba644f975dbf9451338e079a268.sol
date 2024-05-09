1 pragma solidity ^0.4.25;
2 
3 contract Utils {
4     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
5         uint256 _z = _x + _y;
6         assert(_z >= _x);
7         return _z;
8     }
9 
10     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
11         assert(_x >= _y);
12         return _x - _y;
13     }
14 
15     function safeMul(uint256 _x, uint256 _y) internal pure returns (uint256) {
16         uint256 _z = _x * _y;
17         assert(_x == 0 || _z / _x == _y);
18         return _z;
19     }
20     
21     function safeDiv(uint256 _x, uint256 _y) internal pure returns (uint256) {
22         assert(_y != 0); 
23         uint256 _z = _x / _y;
24         assert(_x == _y * _z + _x % _y); 
25         return _z;
26     }
27 
28 }
29 
30 contract Ownable {
31     address public owner;
32 
33     function Ownable() public {
34         owner = msg.sender;
35     }
36 
37     modifier onlyOwner() {
38         require(msg.sender == owner);
39         _;
40     }
41     function transferOwnership(address newOwner) onlyOwner public {
42         require(newOwner != address(0));
43         owner = newOwner;
44     }
45 }
46 
47 contract ERC20Token {
48     function balanceOf(address who) public constant returns (uint256);
49     function transfer(address to, uint256 value) public returns (bool);
50     function approve(address _spender, uint256 _value) returns (bool success);
51     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
52     
53     event Transfer(address indexed _from, address indexed _to, uint256 _value);
54     
55 }
56 
57 contract StandardToken is ERC20Token, Utils, Ownable {
58 
59     mapping (address => uint256) public balanceOf;
60     mapping (address => mapping (address => uint256)) public allowed;
61     mapping (address => mapping (address => uint256)) public allowance;
62     
63     function transfer(address _to, uint256 _value) public returns (bool success){
64         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value > balanceOf[_to]); 
65         
66         balanceOf[msg.sender] = safeSub(balanceOf[msg.sender], _value);
67         balanceOf[_to] = safeAdd(balanceOf[_to], _value);
68         Transfer(msg.sender, _to, _value);
69         return true;
70     }
71 
72     function balanceOf(address _owner) public constant returns (uint256 balance) {
73         return balanceOf[_owner];
74     }
75     
76     
77     function approve(address _spender, uint256 _value) returns (bool success) {
78 		require (_value > 0); 
79         allowance[msg.sender][_spender] = _value;
80         return true;
81     }
82       
83 
84     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
85         require (_value > 0 && balanceOf[_from] >= _value && _value <= allowance[_from][msg.sender] && balanceOf[_to] + _value > balanceOf[_to]);     
86         
87         balanceOf[_from] = safeSub(balanceOf[_from], _value);                          
88         balanceOf[_to] = safeAdd(balanceOf[_to], _value);                           
89         allowance[_from][msg.sender] = safeSub(allowance[_from][msg.sender], _value);
90         Transfer(_from, _to, _value);
91         return true;
92     }
93 
94 }
95 
96 contract YouFoxToken is StandardToken {
97 
98     string public constant name = "YouFoxToken";
99     string public constant symbol = "YFT"; 
100     uint8 public constant decimals = 18;
101     uint256 public totalSupply = 2 * 10**26;
102     address public constant OwnerWallet = 0xCB1Df93fE09772D8d5f52263e6b2DE7ca3adFF7e;
103     
104     function YouFoxToken(){
105         balanceOf[OwnerWallet] = totalSupply;
106         
107         Transfer(0x0, OwnerWallet, balanceOf[OwnerWallet]);
108     }
109 }