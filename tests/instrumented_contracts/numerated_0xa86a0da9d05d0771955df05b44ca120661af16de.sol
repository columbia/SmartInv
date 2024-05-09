1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6           return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12     
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     
18     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19         assert(b <= a);
20         return a - b;
21     }
22     
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         assert(c >= a);
26         return c;
27     }
28 }
29 
30 contract Owned {
31     address public owner;
32     address public newOwner;
33     modifier onlyOwner { require(msg.sender == owner); _; }
34     event OwnerUpdate(address _prevOwner, address _newOwner);
35 
36     function Owned() public {
37         owner = msg.sender;
38     }
39 
40     function transferOwnership(address _newOwner) public onlyOwner {
41         require(_newOwner != owner);
42         newOwner = _newOwner;
43     }
44 
45     function acceptOwnership() public {
46         require(msg.sender == newOwner);
47         OwnerUpdate(owner, newOwner);
48         owner = newOwner;
49         newOwner = 0x0;
50     }
51 }
52 
53 // ERC20 Interface
54 contract ERC20 {
55     function totalSupply() public view returns (uint _totalSupply);
56     function balanceOf(address _owner) public view returns (uint balance);
57     function transfer(address _to, uint _value) public returns (bool success);
58     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
59     function approve(address _spender, uint _value) public returns (bool success);
60     function allowance(address _owner, address _spender) public view returns (uint remaining);
61     event Transfer(address indexed _from, address indexed _to, uint _value);
62     event Approval(address indexed _owner, address indexed _spender, uint _value);
63 }
64 
65 // ERC20Token
66 contract ERC20Token is ERC20 {
67     using SafeMath for uint256;
68     mapping(address => uint256) balances;
69     mapping (address => mapping (address => uint256)) allowed;
70     uint256 public totalToken; 
71 
72     function transfer(address _to, uint256 _value) public returns (bool success) {
73         if (balances[msg.sender] >= _value && _value > 0) {
74             balances[msg.sender] = balances[msg.sender].sub(_value);
75             balances[_to] = balances[_to].add(_value);
76             Transfer(msg.sender, _to, _value);
77             return true;
78         } else {
79             return false;
80         }
81     }
82 
83     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
84         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
85             balances[_from] = balances[_from].sub(_value);
86             balances[_to] = balances[_to].add(_value);
87             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88             Transfer(_from, _to, _value);
89             return true;
90         } else {
91             return false;
92         }
93     }
94 
95     function totalSupply() public view returns (uint256) {
96         return totalToken;
97     }
98 
99     function balanceOf(address _owner) public view returns (uint256 balance) {
100         return balances[_owner];
101     }
102 
103     function approve(address _spender, uint256 _value) public returns (bool success) {
104         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
105         allowed[msg.sender][_spender] = _value;
106         Approval(msg.sender, _spender, _value);
107         return true;
108     }
109 
110     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
111         return allowed[_owner][_spender];
112     }
113 
114 }
115 
116 contract OTCBTC is ERC20Token, Owned {
117 
118     string  public constant name = "OTCBTC Token";
119     string  public constant symbol = "OTB";
120     uint256 public constant decimals = 18;
121     uint256 public tokenDestroyed;
122 	event Burn(address indexed _from, uint256 _tokenDestroyed, uint256 _timestamp);
123 
124     function OTCBTC() public {
125 		totalToken = 200000000000000000000000000;
126 		balances[msg.sender] = totalToken;
127     }
128 
129     function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
130         return ERC20(_tokenAddress).transfer(_recipient, _amount);
131     }
132 
133     function burn (uint256 _burntAmount) public returns (bool success) {
134     	require(balances[msg.sender] >= _burntAmount && _burntAmount > 0);
135     	balances[msg.sender] = balances[msg.sender].sub(_burntAmount);
136     	totalToken = totalToken.sub(_burntAmount);
137     	tokenDestroyed = tokenDestroyed.add(_burntAmount);
138     	require (tokenDestroyed <= 100000000000000000000000000);
139     	Transfer(address(this), 0x0, _burntAmount);
140     	Burn(msg.sender, _burntAmount, block.timestamp);
141     	return true;
142 	}
143 
144 }