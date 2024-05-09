1 pragma solidity ^0.4.13;
2 
3 library SafeMath {
4 
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         uint256 c = a * b;
7         assert(a == 0 || c / a == b);
8         return c;
9     }
10 
11     function div(uint256 a, uint256 b) internal pure returns (uint256) {
12         uint256 c = a / b;
13         return c;
14     }
15 
16     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17         assert(b <= a);
18         return a - b;
19     }
20 
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 
27 }
28 
29 contract Ownable {
30 
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
41 
42     function ChangeOwner(address newOwner) onlyOwner public {
43         require(newOwner != address(0));
44         owner = newOwner;
45     }
46 
47 }
48 
49 contract BaseMPHToken is Ownable {
50 
51     using SafeMath for uint256;
52 
53     mapping(address => uint256) balances;
54     mapping (address => mapping (address => uint256)) allowed;
55     uint256 public totalSupply;
56     uint256 public maxtokens;
57     address public owner;
58 
59     function BaseMPHToken() public {
60         owner = msg.sender;
61         maxtokens = 200000000000000;
62     }
63 
64     modifier IsNoMax() {
65         require(totalSupply <= maxtokens);
66         _;
67     }
68 
69 
70     function transfer(address _to, uint256 _value) public returns (bool) {
71         balances[msg.sender] = balances[msg.sender].sub(_value);
72         balances[_to] = balances[_to].add(_value);
73         Transfer(msg.sender, _to, _value);
74         return true;
75     }
76 
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
78         var _allowance = allowed[_from][msg.sender];
79         require (_value <= _allowance); 
80         balances[_to] = balances[_to].add(_value);
81         balances[_from] = balances[_from].sub(_value);
82         allowed[_from][msg.sender] = _allowance.sub(_value);
83         Transfer(_from, _to, _value);
84         return true;
85     }
86 
87     function approve(address _spender, uint256 _value) public returns (bool) {
88         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
89         allowed[msg.sender][_spender] = _value;
90         Approval(msg.sender, _spender, _value);
91         return true;
92     }
93 
94     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
95         return allowed[_owner][_spender];
96     }
97 
98     function balanceOf(address _owner) public constant returns (uint256 balance) {
99         return balances[_owner];
100     }
101 
102     function mint(address _to, uint256 _amount) onlyOwner IsNoMax public returns (bool) {
103         totalSupply = totalSupply.add(_amount);
104         balances[_to] = balances[_to].add(_amount);
105         mint0(_to, _amount);
106         return true;
107     }
108 
109     event Transfer(address indexed from, address indexed to, uint256 value);
110     event Approval(address indexed Apowner, address indexed spender, uint256 value);
111     event mint0(address indexed to, uint256 amount);
112 }
113 
114 
115 contract MPhoneToken is BaseMPHToken {
116 
117     string public constant name = "MPhone Token";
118     string public constant symbol = "MPH";
119     uint32 public constant decimals = 6;
120 
121 }
122 
123 contract MPhoneSeller is Ownable {
124 
125     using SafeMath for uint256;
126 
127     address public mainwallet;
128     uint public rate;
129     uint256 public MaxTokens;
130     MPhoneToken public token = new MPhoneToken();
131 
132     function MPhoneSeller() public {
133         rate = 1000000;
134         owner = msg.sender;
135         MaxTokens = token.maxtokens();
136         mainwallet = msg.sender;
137     }
138 
139     function ChangeMainWallet(address newWallet) onlyOwner public {
140         require(newWallet != address(0));
141         mainwallet = newWallet;
142     }
143 
144     function ChangeRate(uint newrate) onlyOwner public {
145         require(newrate > 0 );
146         rate = newrate;
147     }
148 
149     function MintTokens(address _to, uint256 _amount) onlyOwner public returns (bool) {
150         Mint(_to,_amount);
151         return token.mint(_to,_amount);
152     }
153 
154     function GetBalance(address _owner) constant public returns (uint256 balance) {
155         return token.balanceOf(_owner);
156     }
157 
158     function GetTotal() constant public returns (uint256 Total) {
159         return token.totalSupply();
160     }
161 
162     function CreateTokens() payable public {
163         mainwallet.transfer(msg.value);
164         uint tokens = rate.mul(msg.value).div(1 ether);
165         token.mint(msg.sender, tokens);
166         SaleToken(msg.sender, tokens);
167     }
168 
169     function() external payable {
170         CreateTokens();
171     }
172 
173     event SaleToken( address indexed to, uint amount);
174     event Mint(address indexed to, uint256 amount);
175 }