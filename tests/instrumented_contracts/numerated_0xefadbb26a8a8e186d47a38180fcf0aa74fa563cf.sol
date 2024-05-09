1 pragma solidity ^0.4.18;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     uint256 c = a / b;
15     return c;
16   }
17 
18   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
19     assert(b <= a);
20     return a - b;
21   }
22 
23   function add(uint256 a, uint256 b) internal pure returns (uint256) {
24     uint256 c = a + b;
25     assert(c >= a);
26     return c;
27   }
28 }
29 
30 contract Ownable {
31   address public owner;
32   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34   function Ownable() public {
35     owner = msg.sender;
36   }
37   modifier onlyOwner() {
38     require(msg.sender == owner);
39     _;
40   }
41 
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 }
48 
49 contract HasNoEther is Ownable {
50 
51   function HasNoEther() public payable {
52     require(msg.value == 0);
53   }
54 
55    function() external {
56   }
57 
58   function reclaimEther() external onlyOwner {
59     assert(owner.send(this.balance));
60   }
61 }
62 
63 contract ERC20Basic {
64   uint256 public totalSupply;
65   function balanceOf(address who) public view returns (uint256);
66   function transfer(address to, uint256 value) public returns (bool);
67   event Transfer(address indexed from, address indexed to, uint256 value);
68 }
69 
70 contract BasicToken is ERC20Basic {
71   using SafeMath for uint256;
72 
73   mapping(address => uint256) balances;
74 
75   function transfer(address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[msg.sender]);
78 
79     balances[msg.sender] = balances[msg.sender].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     Transfer(msg.sender, _to, _value);
82     return true;
83   }
84 
85   function balanceOf(address _owner) public view returns (uint256 balance) {
86     return balances[_owner];
87   }
88 }
89 
90 contract ERC20 is ERC20Basic {
91   function allowance(address owner, address spender) public view returns (uint256);
92   function transferFrom(address from, address to, uint256 value) public returns (bool);
93   function approve(address spender, uint256 value) public returns (bool);
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 contract StandardToken is ERC20, BasicToken {
98 
99   mapping (address => mapping (address => uint256)) internal allowed;
100 
101   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
102     require(_to != address(0));
103     require(_value <= balances[_from]);
104     require(_value <= allowed[_from][msg.sender]);
105 
106     balances[_from] = balances[_from].sub(_value);
107     balances[_to] = balances[_to].add(_value);
108     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
109     Transfer(_from, _to, _value);
110     return true;
111   }
112 
113   function approve(address _spender, uint256 _value) public returns (bool) {
114     allowed[msg.sender][_spender] = _value;
115     Approval(msg.sender, _spender, _value);
116     return true;
117   }
118 
119   function allowance(address _owner, address _spender) public view returns (uint256) {
120     return allowed[_owner][_spender];
121   }
122 
123   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
124     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
125     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
126     return true;
127   }
128 
129   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
130     uint oldValue = allowed[msg.sender][_spender];
131     if (_subtractedValue > oldValue) {
132       allowed[msg.sender][_spender] = 0;
133     } else {
134       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
135     }
136     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
137     return true;
138   }
139 }
140 
141 contract BurnableToken is StandardToken {
142 
143     event Burn(address indexed burner, uint256 value);
144 
145     function burn(uint256 _value) public {
146         require(_value > 0);
147         require(_value <= balances[msg.sender]);
148         address burner = msg.sender;
149         balances[burner] = balances[burner].sub(_value);
150         totalSupply = totalSupply.sub(_value);
151         Burn(burner, _value);
152     }
153 }
154 
155 contract DonatedPlayersStreaming is BurnableToken, HasNoEther {
156 
157     string public constant name = "Donated Players Streaming";
158     string public constant symbol = "DPS";
159     uint8 public constant decimals = 18;
160     uint256 constant INITIAL_SUPPLY = 30000000 * (10 ** uint256(decimals));
161 
162     function DonatedPlayersStreaming() public {
163         totalSupply = INITIAL_SUPPLY;
164         balances[msg.sender] = INITIAL_SUPPLY;
165         Transfer(address(0), msg.sender, totalSupply);
166     }
167 
168     function transfer(address _to, uint256 _value) public returns (bool) {
169         return super.transfer(_to, _value);
170     }
171 
172     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
173         return super.transferFrom(_from, _to, _value);
174     }
175 
176     function multiTransfer(address[] recipients, uint256[] amounts) public {
177         require(recipients.length == amounts.length);
178         for (uint i = 0; i < recipients.length; i++) {
179             transfer(recipients[i], amounts[i]);
180         }
181     }
182 }