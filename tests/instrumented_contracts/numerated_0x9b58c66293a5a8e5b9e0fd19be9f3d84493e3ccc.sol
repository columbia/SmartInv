1 pragma solidity ^0.4.18;
2 
3 
4 library SafeMath {
5     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6         if (a == 0) {
7             return 0;
8         }
9         uint256 c = a * b;
10         assert(c / a == b);
11         return c;
12     }
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         uint256 c = a / b;
15         return c;
16     }
17     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
18         assert(b <= a);
19         return a - b;
20     }
21     function add(uint256 a, uint256 b) internal pure returns (uint256) {
22         uint256 c = a + b;
23         assert(c >= a);
24         return c;
25     }
26 }
27 
28 contract Ownable {
29     address public owner;
30     function Ownable() public {
31         owner = msg.sender;
32     }
33     modifier onlyOwner() {
34         require(msg.sender == owner);
35         _;
36     }
37 }
38 
39 contract MintableToken {
40     bool public mintingFinished = false;
41 
42     modifier canMint() {
43         require(!mintingFinished);
44         _;
45     }
46 }
47 
48 contract TokenERC20 is Ownable, MintableToken {
49     using SafeMath for uint;
50     string public name;
51     string public symbol;
52     uint8 public decimals = 18;
53     address public owner;
54     uint256 public totalSupply;
55     bool public isEnabled = true;
56 
57     mapping (address => bool) public saleAgents;
58     mapping (address => mapping (address => uint256)) internal allowed;
59     mapping (address => uint256) public balanceOf;
60 
61     event Transfer(address indexed from, address indexed to, uint256 value);
62     event Approval(address indexed owner, address indexed spender, uint256 value);
63     event Burn(address indexed from, uint256 value);
64     event Mint(address indexed to, uint256 amount);
65     event MintFinished();
66 
67     function TokenERC20(string _tokenName, string _tokenSymbol) public {
68         name = _tokenName; // Записываем название токена
69         symbol = _tokenSymbol; // Записываем символ токена
70         owner = msg.sender; // Делаем создателя контракта владельцем
71     }
72 
73     function _transfer(address _from, address _to, uint256 _value) internal {
74         require(_to != 0x0);
75         require(_value <= balanceOf[_from]);
76         require(balanceOf[_to].add(_value) > balanceOf[_to]);
77         require(isEnabled);
78 
79         uint256 previousBalances = balanceOf[_from].add(balanceOf[_to]);
80         balanceOf[_from] = balanceOf[_from].sub(_value);
81         balanceOf[_to] = balanceOf[_to].add(_value);
82         emit Transfer(_from, _to, _value);
83         assert(balanceOf[_from].add(balanceOf[_to]) == previousBalances);
84     }
85 
86     function transfer(address _to, uint256 _value) public returns (bool) {
87         _transfer(msg.sender, _to, _value);
88         return true;
89     }
90 
91     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
92         require(_value <= allowed[_from][msg.sender]);
93 
94         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
95          _transfer(_from, _to, _value);
96         return true;
97     }
98 
99     function approve(address _spender, uint256 _value) public returns (bool) {
100         allowed[msg.sender][_spender] = _value;
101         emit Approval(msg.sender, _spender, _value);
102         return true;
103     }
104 
105     function allowance(address _owner, address _spender) public view returns (uint256) {
106         return allowed[_owner][_spender];
107     }
108 
109     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
110         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
111         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
112         return true;
113     }
114 
115     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
116         uint oldValue = allowed[msg.sender][_spender];
117         if (_subtractedValue > oldValue) {
118           allowed[msg.sender][_spender] = 0;
119         } else {
120           allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
121         }
122         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
123         return true;
124     }
125 
126     function mint(address _to, uint256 _amount) canMint public returns (bool) {
127         require(msg.sender == owner || saleAgents[msg.sender]);
128         totalSupply = totalSupply.add(_amount);
129         balanceOf[_to] = balanceOf[_to].add(_amount);
130         emit Mint(_to, _amount);
131         emit Transfer(address(0), _to, _amount);
132         return true;
133     }
134     
135     function finishMinting() onlyOwner canMint public returns (bool) {
136         uint256 ownerTokens = totalSupply.mul(2).div(3); // 60% * 2 / 3 = 40%
137         mint(owner, ownerTokens);
138 
139         mintingFinished = true;
140         emit MintFinished();
141         return true;
142     }
143 
144     function burn(uint256 _value) public returns (bool) {
145         require(balanceOf[msg.sender] >= _value);   // Проверяем, достаточно ли средств у сжигателя
146 
147         address burner = msg.sender;
148         balanceOf[burner] = balanceOf[burner].sub(_value);  // Списываем с баланса сжигателя
149         totalSupply = totalSupply.sub(_value);  // Обновляем общее количество токенов
150         emit Burn(burner, _value);
151         emit Transfer(burner, address(0x0), _value);
152         return true;
153     }
154 
155     function addSaleAgent (address _saleAgent) public onlyOwner {
156         saleAgents[_saleAgent] = true;
157     }
158 
159     function disable () public onlyOwner {
160         require(isEnabled);
161         isEnabled = false;
162     }
163     function enable () public onlyOwner {
164         require(!isEnabled);
165         isEnabled = true;
166     }
167 }
168 
169 contract Token is TokenERC20 {
170     function Token() public TokenERC20("Ideal Digital Memory", "IDM") {}
171 
172 }