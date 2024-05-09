1 pragma solidity ^0.4.16;
2 
3 
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 
32 contract Owned {
33     address internal owner;
34 
35     function Owned() public {
36         owner = msg.sender;
37     }
38 
39     modifier onlyOwner {
40         require(msg.sender == owner);
41         _;
42     }
43 
44     function transferOwnership(address newOwner) onlyOwner public {
45         owner = newOwner;
46     }
47 }
48 
49 contract TokenERC20  is Owned {
50     
51     using SafeMath for uint256;
52     
53     string public name;
54     string public symbol;
55   
56     uint8 public decimals = 18;  
57     uint256 public totalSupply;
58 
59     mapping (address => uint256) public balanceOf;
60     mapping (address => uint256) public modelOf;
61     mapping (address => uint256) public lockBalance;
62     mapping (address => mapping (address => uint256)) public allowance;
63     event Transfer(address indexed from, address indexed to, uint256 value);
64     event Approval(address indexed tokenOwner, address indexed spender, uint value);
65 
66     function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
67         totalSupply = initialSupply * 10 ** uint256(decimals);
68   
69         balanceOf[msg.sender] = totalSupply;
70         name = tokenName;
71         symbol = tokenSymbol;
72         
73     }
74 
75     function setModel(address _addr,uint256 _value) onlyOwner public {
76         modelOf[_addr] = _value;
77     }
78 
79     function setlockBalance(address _addr, uint256 _value) onlyOwner public {
80         lockBalance[_addr] = now + (_value * 1 days);
81     }
82 
83     function _transfer(address _from, address _to, uint _value) internal {
84         require(_to != 0x0);
85          
86         require(lockBalance[_from] < now);
87 
88         require(balanceOf[_from] >= _value);
89         require(balanceOf[_to].add(_value) > balanceOf[_to]);
90 
91         if(modelOf[_from] != 0 && modelOf[_to] == 0 && _to != owner && lockBalance[_to] == 0){
92             lockBalance[_to] = now + (modelOf[_from] * 1 days);
93         }
94 
95         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
96         balanceOf[_from] = balanceOf[_from].sub(_value);
97         balanceOf[_to] = balanceOf[_to].add(_value);
98         emit Transfer(_from, _to, _value);
99         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
100     }
101 
102     function transfer(address _to, uint256 _value) public returns (bool){
103         _transfer(msg.sender, _to, _value);
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
108         require(_value <= allowance[_from][msg.sender]);     
109         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
110         _transfer(_from, _to, _value);
111         return true;
112     }
113 
114     function approve(address _spender, uint256 _value) public returns (bool) {
115         require(balanceOf[msg.sender] >= _value);
116         allowance[msg.sender][_spender] = _value;
117         emit Approval(msg.sender,_spender,_value);
118         return true;
119     }
120 
121 }