1 pragma solidity ^0.4.24;
2 
3 contract BaseContract {
4     bool public TokensAreFrozen = true;
5     address public owner;
6 
7     constructor () public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyByOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) external onlyByOwner {
17         if (newOwner != address(0)) {
18             owner = newOwner;
19         }
20     }
21 }
22 
23 contract ERC20Contract is BaseContract {
24     function balanceOf(address _owner) public view returns (uint256 balance);
25     function transfer(address _to, uint256 _value) public returns (bool success);
26     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
27     function approve(address _spender, uint256 _value) public returns (bool success);
28     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
29 
30     event Transfer(address indexed _from, address indexed _to, uint256 _value);
31     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
32     event BurnTokens(address indexed from, uint256 value);
33     event FreezeTokensFrom(address indexed _owner);
34     event UnfreezeTokensFrom(address indexed _owner);
35 }
36 
37 library SafeMath {
38     function Mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42 
43         uint256 c = a * b;
44         return c;
45     }
46 
47     function Sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a - b;
49     }
50 
51     function Add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint c = a + b;
53         return c;
54     }
55 
56     function Div(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a / b;
58         return c;
59     }
60 }
61 
62 contract Freedom is ERC20Contract {
63     
64     using SafeMath for uint256;
65 
66     uint256 constant private MAX_UINT256 = 2**256 - 1;
67     mapping (address => uint256) public balanceOf;
68     mapping (address => mapping (address => uint256)) public allowed;
69     
70     string public constant tokenName = "Freedom";
71     string public constant tokenSymbol = "FREE";
72     uint256 public totalSupply = 1000000000e8;
73     uint8 public decimals = 8;
74 
75     constructor () public {
76         balanceOf[msg.sender] = totalSupply;
77         totalSupply = totalSupply;
78         decimals = decimals;
79     }
80 
81     modifier onlyPayloadSize(uint256 _size) {
82         require(msg.data.length >= _size + 4);
83         _;
84     }
85 
86     function transfer(address _to, uint256 _value) onlyPayloadSize(2 * 32) public returns (bool success) {
87         require(!TokensAreFrozen);
88         require(_to != 0x0);
89         require(_value > 0);
90         require(balanceOf[msg.sender] >= _value);
91         require(balanceOf[_to] + _value >= balanceOf[_to]);
92         balanceOf[msg.sender] = balanceOf[msg.sender].Sub(_value);
93         balanceOf[_to] = balanceOf[_to].Add(_value);
94         emit Transfer(msg.sender, _to, _value);
95         return true;
96     }
97 
98     function transferFrom(address _from, address _to, uint256 _value) onlyPayloadSize(3 * 32) public returns (bool success) {
99         uint256 allowance = allowed[_from][msg.sender];
100         require(!TokensAreFrozen);
101         require(_to != 0x0);
102         require(_value > 0);
103         require(balanceOf[_from] >= _value && allowance >= _value);
104         balanceOf[_to]   = balanceOf[_to].Add(_value);
105         balanceOf[_from] = balanceOf[_from].Sub(_value);
106         if (allowance < MAX_UINT256) {
107             allowed[_from][msg.sender] = allowed[_from][msg.sender].Sub(_value);
108         }
109         emit Transfer(_from, _to, _value);
110         return true;
111     }
112 
113     function balanceOf(address _owner) public view returns (uint256 balance) {
114         return balanceOf[_owner];
115     }
116     
117     function approve(address _spender, uint256 _value) public returns (bool success) {
118         require(!TokensAreFrozen);
119         require(_spender != address(0));
120         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
121         allowed[msg.sender][_spender] = _value;
122         emit Approval(msg.sender, _spender, _value);
123         return true;
124     }
125     
126     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
127         return allowed[_owner][_spender];
128     }
129     
130     function freezeTokens(address _owner) external onlyByOwner {
131         require(TokensAreFrozen == false);
132         TokensAreFrozen = true;
133         emit FreezeTokensFrom(_owner);
134     }
135     
136     function unfreezeTokens(address _owner) external onlyByOwner {
137         require(TokensAreFrozen == true);
138         TokensAreFrozen = false;
139         emit UnfreezeTokensFrom(_owner);
140     }
141     
142     function burnTokens(address _owner, uint256 _value) external onlyByOwner {
143         require(!TokensAreFrozen);
144         require(balanceOf[_owner] >= _value);
145         balanceOf[_owner] -= _value;
146         totalSupply -= _value;
147         emit BurnTokens(_owner, _value);
148     }
149     
150     function withdraw() external onlyByOwner {
151         owner.transfer(address(this).balance);
152     }
153     
154     function() payable public {
155     }
156 }