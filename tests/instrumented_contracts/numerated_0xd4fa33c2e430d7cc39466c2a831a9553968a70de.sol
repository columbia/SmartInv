1 //@ create by ETU LAB, INC.
2 pragma solidity ^0.4.19;
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7           return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     
14     function div(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a / b;
16         return c;
17     }
18     
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         assert(b <= a);
21         return a - b;
22     }
23     
24     function add(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a + b;
26         assert(c >= a);
27         return c;
28     }
29 }
30 
31 contract Owned {
32     address public owner;
33     address public newOwner;
34     modifier onlyOwner { require(msg.sender == owner); _; }
35     event OwnerUpdate(address _prevOwner, address _newOwner);
36 
37     function Owned() public {
38         owner = msg.sender;
39     }
40 
41     function transferOwnership(address _newOwner) public onlyOwner {
42         require(_newOwner != owner);
43         newOwner = _newOwner;
44     }
45 
46     function acceptOwnership() public {
47         require(msg.sender == newOwner);
48         OwnerUpdate(owner, newOwner);
49         owner = newOwner;
50         newOwner = 0x0;
51     }
52 }
53 
54 // ERC20 Interface
55 contract ERC20 {
56     function totalSupply() public view returns (uint _totalSupply);
57     function balanceOf(address _owner) public view returns (uint balance);
58     function transfer(address _to, uint _value) public returns (bool success);
59     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
60     function approve(address _spender, uint _value) public returns (bool success);
61     function allowance(address _owner, address _spender) public view returns (uint remaining);
62     event Transfer(address indexed _from, address indexed _to, uint _value);
63     event Approval(address indexed _owner, address indexed _spender, uint _value);
64 }
65 
66 // ERC20Token
67 contract ERC20Token is ERC20 {
68     using SafeMath for uint256;
69     mapping(address => uint256) balances;
70     mapping (address => mapping (address => uint256)) allowed;
71     uint256 public totalToken; 
72 
73     function transfer(address _to, uint256 _value) public returns (bool success) {
74         if (balances[msg.sender] >= _value && _value > 0) {
75             balances[msg.sender] = balances[msg.sender].sub(_value);
76             balances[_to] = balances[_to].add(_value);
77             Transfer(msg.sender, _to, _value);
78             return true;
79         } else {
80             return false;
81         }
82     }
83 
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
85         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
86             balances[_from] = balances[_from].sub(_value);
87             balances[_to] = balances[_to].add(_value);
88             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
89             Transfer(_from, _to, _value);
90             return true;
91         } else {
92             return false;
93         }
94     }
95 
96     function totalSupply() public view returns (uint256) {
97         return totalToken;
98     }
99 
100     function balanceOf(address _owner) public view returns (uint256 balance) {
101         return balances[_owner];
102     }
103 
104     function approve(address _spender, uint256 _value) public returns (bool success) {
105         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
112         return allowed[_owner][_spender];
113     }
114 
115 }
116 
117 contract ETU is ERC20Token, Owned {
118 
119     string  public constant name = "ETU Token";
120     string  public constant symbol = "ETU";
121     uint256 public constant decimals = 18;
122     uint256 public tokenDestroyed;
123 	event Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);
124 
125     function ETU() public {
126 		totalToken = 1000000000000000000000000000;
127 		balances[msg.sender] = totalToken;
128     }
129 
130     function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
131         return ERC20(_tokenAddress).transfer(_recipient, _amount);
132     }
133 
134     function burn (uint256 _burntAmount) public returns (bool success) {
135     	require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
136     	balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
137     	totalToken = totalToken.sub(_burntAmount);
138     	tokenDestroyed = tokenDestroyed.add(_burntAmount);
139     	require (tokenDestroyed <= 500000000000000000000000000);
140     	Transfer(address(this), 0x0, _burntAmount);
141     	Burn(msg.sender, _burntAmount, block.timestamp);
142     	return true;
143 	}
144 
145 }