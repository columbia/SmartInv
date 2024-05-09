1 pragma solidity ^0.5.1;
2 
3 
4 /*
5     * Moon YFI contract is ERC20 with PolkaDot and Moonbeam swap comopatibility.
6 */
7 
8 interface ERC20 {
9     function balanceOf(address _owner) external view returns (uint256);
10     function allowance(address _owner, address _spender) external view returns (uint256);
11     function transfer(address _to, uint256 _value) external returns (bool);
12     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
13     function approve(address _spender, uint256 _value) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 /*
19     * SafeMath
20     
21 */
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28         uint256 c = a * b;
29         assert(c / a == b);
30         return c;
31     }
32 
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a / b;
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         assert(c >= a);
46         return c;
47     }
48 }
49 
50 /*
51     * Swap logic to Moonbeam PolkaDot 1:1 swap
52     
53         Create ERC20 Contract in code below with PolkaDot and Moonbeam contract comopatibility.
54         ERC20 Moon YFI token holders will receive 1:1 swap of Moonbeam Moon YFI staking tokens.  
55         Moonbeam Testnet live Q3 2020. 
56 */
57 contract MoonYFI is ERC20 {
58     using SafeMath for uint256;
59     address private deployer;
60     string public name = "Moon YFI";
61     string public symbol = "MYFI";
62     uint8 public constant decimals = 18;
63     uint256 private constant decimalFactor = 10 ** uint256(decimals);
64     uint256 public constant startingSupply = 30000 * decimalFactor;
65     uint256 public burntTokens = 0;
66     bool public minted = false;
67     bool public unlocked = false;
68     mapping (address => uint256) balances;
69     mapping (address => mapping (address => uint256)) internal allowed;
70 
71 
72     event Transfer(address indexed from, address indexed to, uint256 value);
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74     
75     modifier onlyOwner() {
76         require(deployer == msg.sender, "Caller is not the owner");
77         _;
78     }
79 
80     constructor() public {
81         deployer = msg.sender;
82     }
83 
84     function owner() public view returns (address) {
85         return deployer;
86     }
87 
88     function totalSupply() public view returns (uint256) {
89         uint256 currentTokens = startingSupply.sub(burntTokens);
90         return currentTokens;
91     }
92     
93     function mint(address _owner) public onlyOwner returns (bool) {
94         require(minted != true, "Tokens already minted");
95         balances[_owner] = startingSupply;
96         emit Transfer(address(0), _owner, startingSupply);
97         minted = true;
98         return true;
99     }
100     
101     function unlockTokens() public onlyOwner returns (bool) {
102         require(unlocked != true, "Tokens already unlocked");
103         unlocked = true;
104         return true;
105     }
106     
107     function balanceOf(address _owner) public view returns (uint256 balance) {
108         return balances[_owner];
109     }
110 
111     function allowance(address _owner, address _spender) public view returns (uint256) {
112         return allowed[_owner][_spender];
113     }
114     
115     function _burn(address account, uint256 amount) internal {
116         require(account != address(0));
117         balances[account] = balances[account].sub(amount);
118         burntTokens = burntTokens.add(amount);
119         emit Transfer(account, address(0), amount);
120     }
121 
122     function transfer(address _to, uint256 _value) public returns (bool) {
123         require(_to != address(0));
124         require(_value <= balances[msg.sender]);
125         require(unlocked == true, "Tokens not unlocked yet");
126         uint256 tokensToBurn = _value.div(100);
127         uint256 tokensToSend = _value.sub(tokensToBurn);
128         balances[msg.sender] = balances[msg.sender].sub(tokensToSend);
129         _burn(msg.sender, tokensToBurn);
130         balances[_to] = balances[_to].add(tokensToSend);
131         
132         emit Transfer(msg.sender, _to, tokensToSend);
133         return true;
134     }
135 
136     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
137         require(_to != address(0));
138         require(_value <= balances[_from]);
139         require(_value <= allowed[_from][msg.sender]);
140         require(unlocked == true, "Tokens not unlocked yet");
141         uint256 tokensToBurn = _value.div(100);
142         uint256 tokensToSend = _value.sub(tokensToBurn);
143         balances[_from] = balances[_from].sub(tokensToSend);
144         balances[_to] = balances[_to].add(tokensToSend);
145         _burn(_from, tokensToBurn);
146         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
147         emit Transfer(_from, _to, tokensToSend);
148         return true;
149     }
150 
151     function approve(address _spender, uint256 _value) public returns (bool) {
152         allowed[msg.sender][_spender] = _value;
153         emit Approval(msg.sender, _spender, _value);
154         return true;
155     }
156 
157     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
158         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
159         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
160         return true;
161     }
162 
163     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
164         uint oldValue = allowed[msg.sender][_spender];
165         if (_subtractedValue > oldValue) {
166             allowed[msg.sender][_spender] = 0;
167         } else {
168             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
169         }
170         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
171         return true;
172     }
173 }