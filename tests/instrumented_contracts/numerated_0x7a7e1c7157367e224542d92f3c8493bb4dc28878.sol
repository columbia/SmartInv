1 pragma solidity 0.4.24;
2 contract Ownable {
3   address public owner;
4   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
5   function Ownable() public {
6     owner = msg.sender;
7   }
8   modifier onlyOwner() {
9     require(msg.sender == owner);
10     _;
11   }
12   function transferOwnership(address newOwner) public onlyOwner {
13     require(newOwner != address(0));
14     OwnershipTransferred(owner, newOwner);
15     owner = newOwner;
16   }
17 }
18 contract ERC20Basic {
19   uint256 public totalSupply;
20   function balanceOf(address who) public view returns (uint256);
21   function transfer(address to, uint256 value) public returns (bool);
22   event Transfer(address indexed from, address indexed to, uint256 value);
23 }
24 contract BasicToken is ERC20Basic, Ownable {
25     using SafeMath for uint256;
26     mapping(address => uint256) balances;
27     bool public transfersEnabledFlag;
28     modifier transfersEnabled() {
29         require(transfersEnabledFlag);
30         _;
31     }
32     function enableTransfers() public onlyOwner {
33         transfersEnabledFlag = true;
34     }
35     function transfer(address _to, uint256 _value) transfersEnabled() public returns (bool) {
36         require(_to != address(0));
37         require(_value <= balances[msg.sender]);
38         // SafeMath.sub will throw if there is not enough balance.
39         balances[msg.sender] = balances[msg.sender].sub(_value);
40         balances[_to] = balances[_to].add(_value);
41         Transfer(msg.sender, _to, _value);
42         return true;
43     }
44     function balanceOf(address _owner) public view returns (uint256 balance) {
45         return balances[_owner];
46     }
47 }
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     if (a == 0) {
51       return 0;
52     }
53     uint256 c = a * b;
54     assert(c / a == b);
55     return c;
56   }
57   function div(uint256 a, uint256 b) internal pure returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 contract ERC20 is ERC20Basic {
74   function allowance(address owner, address spender) public view returns (uint256);
75   function transferFrom(address from, address to, uint256 value) public returns (bool);
76   function approve(address spender, uint256 value) public returns (bool);
77   event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 contract StandardToken is ERC20, BasicToken {
80     mapping (address => mapping (address => uint256)) internal allowed;
81     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
82         require(_to != address(0));
83         require(_value <= balances[_from]);
84         require(_value <= allowed[_from][msg.sender]);
85         balances[_from] = balances[_from].sub(_value);
86         balances[_to] = balances[_to].add(_value);
87         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
88         Transfer(_from, _to, _value);
89         return true;
90     }
91     function approve(address _spender, uint256 _value) public returns (bool) {
92         allowed[msg.sender][_spender] = _value;
93         Approval(msg.sender, _spender, _value);
94         return true;
95     }
96     function allowance(address _owner, address _spender) public view returns (uint256) {
97         return allowed[_owner][_spender];
98     }
99     function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
100         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
101         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
102         return true;
103     }
104     function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
105         uint oldValue = allowed[msg.sender][_spender];
106         if (_subtractedValue > oldValue) {
107             allowed[msg.sender][_spender] = 0;
108         }
109         else {
110             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
111         }
112         Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
113         return true;
114     }
115 }
116 
117 contract MintableToken is StandardToken {
118     event Mint(address indexed to, uint256 amount);
119     event MintFinished();
120     bool public mintingFinished = false;
121     mapping(address => bool) public minters;
122     modifier canMint() {
123         require(!mintingFinished);
124         _;
125     }
126     modifier onlyMinters() {
127         require(minters[msg.sender] || msg.sender == owner);
128         _;
129     }
130     function addMinter(address _addr) public onlyOwner {
131         minters[_addr] = true;
132     }
133     function deleteMinter(address _addr) public onlyOwner {
134         delete minters[_addr];
135     }
136     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
137         require(_to != address(0));
138         totalSupply = totalSupply.add(_amount);
139         balances[_to] = balances[_to].add(_amount);
140         Mint(_to, _amount);
141         Transfer(address(0), _to, _amount);
142         return true;
143     }
144     function finishMinting() onlyOwner canMint public returns (bool) {
145         mintingFinished = true;
146         MintFinished();
147         return true;
148     }
149 }
150 contract CappedToken is MintableToken {
151     uint256 public cap;
152     function CappedToken(uint256 _cap) public {
153         require(_cap > 0);
154         cap = _cap;
155     }
156     function mint(address _to, uint256 _amount) onlyMinters canMint public returns (bool) {
157         require(totalSupply.add(_amount) <= cap);
158         return super.mint(_to, _amount);
159     }
160 }
161 contract ParameterizedToken is CappedToken {
162     string public name;
163     string public symbol;
164     uint256 public decimals;
165     function ParameterizedToken(string _name, string _symbol, uint256 _decimals, uint256 _capIntPart) public CappedToken(_capIntPart * 10 ** _decimals) {
166         name = _name;
167         symbol = _symbol;
168         decimals = _decimals;
169     }
170 }
171 contract ZingToken is ParameterizedToken {
172     function ZingToken() public ParameterizedToken("Zing Token", "ZING", 8, 110000000) {
173     }
174 }