1 pragma solidity ^0.4.20;
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
30 
31 // ERC20 Interface
32 contract ERC20 {
33     function totalSupply() public view returns (uint _totalSupply);
34     function balanceOf(address _owner) public view returns (uint balance);
35     function transfer(address _to, uint _value) public returns (bool success);
36     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
37     function approve(address _spender, uint _value) public returns (bool success);
38     function allowance(address _owner, address _spender) public view returns (uint remaining);
39     event Transfer(address indexed _from, address indexed _to, uint _value);
40     event Approval(address indexed _owner, address indexed _spender, uint _value);
41 }
42 
43 
44 
45 contract Owned {
46     address public owner;
47     modifier onlyOwner { require(msg.sender == owner); _; }
48     function Owned() public {
49         owner = msg.sender;
50     }
51 }
52 
53 // ERC20Token
54 contract ERC20Token is ERC20 {
55     using SafeMath for uint256;
56     mapping(address => uint256) balances;
57     mapping (address => mapping (address => uint256)) allowed;
58     uint256 public totalToken; 
59 
60 
61      /* Send coins */
62     function transfer(address _to, uint256 _value) public returns (bool success) {
63         if (balances[msg.sender] >= _value && _value > 0) 
64         {
65             balances[msg.sender] = balances[msg.sender].sub(_value);
66             balances[_to] = balances[_to].add(_value);
67             Transfer(msg.sender, _to, _value);
68             return true;
69         } 
70         else 
71         {
72             return false;
73         }
74     }
75 
76     /* A contract attempts to get the coins */
77     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
78         if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
79             balances[_from] = balances[_from].sub(_value);
80             balances[_to] = balances[_to].add(_value);
81             allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82             Transfer(_from, _to, _value);
83             return true;
84         } 
85         else 
86         {
87             return false;
88         }
89     }
90 
91     function totalSupply() public view returns (uint256) {
92         return totalToken;
93     }
94 
95     function balanceOf(address _owner) public view returns (uint256 balance) {
96         return balances[_owner];
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool success) {
100         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
101         allowed[msg.sender][_spender] = _value;
102         Approval(msg.sender, _spender, _value);
103         return true;
104     }
105 
106     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
107         return allowed[_owner][_spender];
108     }
109 
110 }
111 
112 contract DouDou is ERC20Token, Owned {
113 
114     string  public constant name = "DouDou Token";
115     string  public constant symbol = "DouDou";
116     uint256 public constant decimals = 18;
117     uint256 public tokenDestroyed;
118     address public yearteam;
119     address public halfyearteam;
120     uint public normal_trade_date = 1519837167; //new Date("yyyy-mm-ddT00:00:00").getTime()/1000
121     uint public halfyearteam_trade_date = normal_trade_date + (24*60*60)/2;//(365*24*60*60)/2;
122     uint public yearteam_trade_date     = normal_trade_date + (24*60*60);//(365*24*60*60);  
123 
124     event Burn(address indexed _from, uint256 _tokenDestroyed);
125 
126     function DouDou() public 
127     {
128         totalToken   = 200000000000000000000000000;
129         yearteam     = 0x2cFD5263896aA51085FFaBF0183dA67F26e5789c;
130         halfyearteam = 0x86BEa0b293dE7975aA9Dd49b8a52c0e10BD243dC;
131         balances[msg.sender]    =  (totalToken*60) / 100; //owner 60%
132         balances[halfyearteam]  =  (totalToken*20) / 100; //team1 20%
133         balances[yearteam]      =  (totalToken*20) / 100; //team2 20%
134     }
135     
136     /* Send coins */
137     function transfer(address _to, uint256 _value) public returns (bool success) 
138     {
139         //time check
140         if (msg.sender == yearteam && now < yearteam_trade_date) 
141             revert();
142         if (msg.sender == halfyearteam && now < halfyearteam_trade_date)
143             revert();
144         if (balances[msg.sender] >= _value && _value > 0) 
145         {
146             balances[msg.sender] = balances[msg.sender].sub(_value);
147             balances[_to] = balances[_to].add(_value);
148             Transfer(msg.sender, _to, _value);
149             return true;
150         } 
151         else 
152         {
153             return false;
154         }
155     }
156 
157     function transferAnyERC20Token(address _tokenAddress, address _recipient, uint256 _amount) public onlyOwner returns (bool success) {
158         return ERC20(_tokenAddress).transfer(_recipient, _amount);
159     }
160 
161     function burn (uint256 _burntValue) public returns (bool success) 
162     {
163         require(balances[msg.sender] >= _burntValue && _burntValue > 0);
164         balances[msg.sender] = balances[msg.sender].sub(_burntValue);
165         totalToken = totalToken.sub(_burntValue);
166         tokenDestroyed = tokenDestroyed.add(_burntValue);
167         require (tokenDestroyed <= 100000000000000000000000000);
168         Transfer(address(this), 0x0, _burntValue);
169         Burn(msg.sender, _burntValue);
170         return true;
171     }
172 
173 }