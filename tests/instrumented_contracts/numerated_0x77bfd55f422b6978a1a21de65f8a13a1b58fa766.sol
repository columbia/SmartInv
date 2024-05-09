1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4   address public owner;
5   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6   function Ownable() public {
7     owner = msg.sender;
8   }
9   modifier onlyOwner() {
10     require(msg.sender == owner);
11     _;
12   }
13   function transferOwnership(address newOwner) public onlyOwner {
14     require(newOwner != address(0));
15     OwnershipTransferred(owner, newOwner);
16     owner = newOwner;
17   }
18 }
19 
20 contract ERC20Basic {
21   uint256 public totalSupply;
22   function balanceOf(address who) public view returns (uint256);
23   function transfer(address to, uint256 value) public returns (bool);
24   event Transfer(address indexed from, address indexed to, uint256 value);
25 }
26 
27 contract BasicToken is ERC20Basic, Ownable {
28     using SafeMath for uint256;
29     mapping(address => uint256) balances;
30     bool public transfersEnabledFlag;
31     modifier transfersEnabled() {
32         require(transfersEnabledFlag);
33         _;
34     }
35     function enableTransfers() public onlyOwner {
36         transfersEnabledFlag = true;
37     }
38     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
39         require(_to != address(0));
40         require(_value <= balances[msg.sender]);
41         // SafeMath.sub will throw if there is not enough balance.
42         balances[msg.sender] = balances[msg.sender].sub(_value);
43         balances[_to] = balances[_to].add(_value);
44         Transfer(msg.sender, _to, _value);
45         return true;
46     }
47     function balanceOf(address _owner) public view returns (uint256 balance) {
48         return balances[_owner];
49     }
50 }
51 library SafeMath {
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60   function div(uint256 a, uint256 b) internal pure returns (uint256) {
61     // assert(b > 0); // Solidity automatically throws when dividing by 0
62     uint256 c = a / b;
63     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
64     return c;
65   }
66   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67     assert(b <= a);
68     return a - b;
69   }
70   function add(uint256 a, uint256 b) internal pure returns (uint256) {
71     uint256 c = a + b;
72     assert(c >= a);
73     return c;
74   }
75 }
76 contract ERC20 is ERC20Basic {
77   function allowance(address owner, address spender) public view returns (uint256);
78   function transferFrom(address from, address to, uint256 value) public returns (bool);
79   function approve(address spender, uint256 value) public returns (bool);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 contract StandardToken is ERC20, BasicToken {
83     mapping (address => mapping (address => uint256)) internal allowed;
84     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
85         require(_to != address(0));
86         require(_value <= balances[_from]);
87         require(_value <= allowed[_from][msg.sender]);
88         balances[_from] = balances[_from].sub(_value);
89         balances[_to] = balances[_to].add(_value);
90         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
91         Transfer(_from, _to, _value);
92         return true;
93     }
94     function approve(address _spender, uint256 _value) public returns (bool) {
95         allowed[msg.sender][_spender] = _value;
96         Approval(msg.sender, _spender, _value);
97         return true;
98     }
99     function allowance(address _owner, address _spender) public view returns (uint256) {
100         return allowed[_owner][_spender];
101     }
102     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
103         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
104         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
105         return true;
106     }
107     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
108         uint oldValue = allowed[msg.sender][_spender];
109         if (_subtractedValue > oldValue) {
110             allowed[msg.sender][_spender] = 0;
111         }
112         else {
113             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
114         }
115         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
116         return true;
117     }
118 }
119 
120 contract MintableToken is StandardToken {
121     event Mint(address indexed to, uint256 amount);
122     event MintFinished();
123     bool public mintingFinished = false;
124     mapping(address => bool) public minters;
125     modifier canMint() {
126         require(!mintingFinished);
127         _;
128     }
129     modifier onlyMinters() {
130         require(minters[msg.sender] || msg.sender == owner);
131         _;
132     }
133     function addMinter(address _addr) public onlyOwner {
134         minters[_addr] = true;
135     }
136     function deleteMinter(address _addr) public onlyOwner {
137         delete minters[_addr];
138     }
139     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
140         require(_to != address(0));
141         totalSupply = totalSupply.add(_amount);
142         balances[_to] = balances[_to].add(_amount);
143         Mint(_to, _amount);
144         Transfer(address(0), _to, _amount);
145         return true;
146     }
147     function finishMinting() onlyOwner canMint public returns (bool) {
148         mintingFinished = true;
149         MintFinished();
150         return true;
151     }
152 }
153 contract CappedToken is MintableToken {
154     uint256 public cap;
155     function CappedToken(uint256 _cap) public {
156         require(_cap > 0);
157         cap = _cap;
158     }
159     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
160         require(totalSupply.add(_amount) <= cap);
161         return super.mint(_to, _amount);
162     }
163 }
164 contract ParameterizedToken is CappedToken {
165     string public name;
166     string public symbol;
167     uint256 public decimals;
168     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
169         name = _name;
170         symbol = _symbol;
171         decimals = _decimals;
172     }
173 }
174 contract GameXToken is ParameterizedToken {
175     function GameXToken() public ParameterizedToken("Game-X Token", "GTK", 8, 100000000) {
176     }
177 }