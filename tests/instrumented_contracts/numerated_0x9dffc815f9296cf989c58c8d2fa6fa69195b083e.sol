1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a * b;
6         assert(a == 0 || c / a == b);
7         return c;
8     }
9 
10     function div(uint256 a, uint256 b) internal pure returns (uint256) {
11         assert(b > 0); 
12         uint256 c = a / b;
13         assert(a == b * c + a % b); 
14         return c;
15     }
16 
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21 
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         assert(c >= a);
25         return c;
26     }
27 }
28 
29 contract owned {
30     address public owner;
31 
32     constructor() public {
33         owner = msg.sender;
34     }
35 
36     modifier onlyOwner {
37         require(msg.sender == owner);
38         _;
39     }
40 
41     function transferOwnership(address newOwner) onlyOwner public {
42         owner = newOwner;
43     }
44 }
45 
46 interface TokenRecipient { 
47     function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
48 }
49 
50 contract TokenERC20 is owned{
51     using SafeMath for uint256;
52     
53     string public name;
54     string public symbol;
55     uint8 public decimals = 18;
56     uint256 public totalSupply;
57 
58     mapping (address => uint256) public balanceOf;
59     mapping (address => mapping (address => uint256)) public allowance;
60     mapping (address => bool) public frozenAccount;
61 
62     event Transfer(address indexed from, address indexed to, uint256 value);
63     
64     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
65     
66     event FrozenFunds(address target, bool frozen);
67 
68     constructor(
69         uint256 initialSupply,
70         string tokenName,
71         string tokenSymbol
72     ) public {
73         totalSupply = initialSupply * 10 ** uint256(decimals);  
74         balanceOf[msg.sender] = totalSupply;                
75         name = tokenName;                                   
76         symbol = tokenSymbol;                               
77     }
78 
79 
80     function _transfer(address _from, address _to, uint _value) internal {
81         require(_to != 0x0);
82         require(balanceOf[_from] >= _value);
83         require(balanceOf[_to].add(_value) > balanceOf[_to]);
84         require(!frozenAccount[_from]);                     
85         require(!frozenAccount[_to]);  
86         
87         uint previousBalances = balanceOf[_from].add(balanceOf[_to]);
88    
89         balanceOf[_from] = balanceOf[_from].sub(_value);
90         balanceOf[_to] = balanceOf[_to].add(_value);
91         emit Transfer(_from, _to, _value);
92         
93         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
94     }
95 
96 
97     function transfer(address _to, uint256 _value) public returns (bool success) {
98         _transfer(msg.sender, _to, _value);
99         return true;
100     }
101 
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
103         require(_value <= allowance[_from][msg.sender]);     
104         allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
105         _transfer(_from, _to, _value);
106         return true;
107     }
108 
109     function approve(address _spender, uint256 _value) public
110         returns (bool success) {
111         allowance[msg.sender][_spender] = _value;
112         emit Approval(msg.sender, _spender, _value);
113         return true;
114     }
115     
116     function approveAndCall(address _spender, uint256 _value, bytes _extraData)
117         public
118         returns (bool success) {
119         TokenRecipient spender = TokenRecipient(_spender);
120         if (approve(_spender, _value)) {
121             spender.receiveApproval(msg.sender, _value, this, _extraData);
122             return true;
123         }
124     }
125     
126     function freezeAccount(address target, bool freeze) onlyOwner public {
127         frozenAccount[target] = freeze;
128         emit FrozenFunds(target, freeze);
129     }
130 
131 }