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
37 
38   modifier onlyOwner() {
39     require(msg.sender == owner);
40     _;
41   }
42 
43   function transferOwnership(address newOwner) public onlyOwner {
44     require(newOwner != address(0));
45     OwnershipTransferred(owner, newOwner);
46     owner = newOwner;
47   }
48 
49 }
50 
51 contract HasNoEther is Ownable {
52 
53   function HasNoEther() public payable {
54     require(msg.value == 0);
55   }
56 
57   function() external {
58   }
59 
60   function reclaimEther() external onlyOwner {
61     assert(owner.send(this.balance));
62   }
63 }
64 
65 contract ERC20Basic {
66   uint256 public totalSupply;
67   function balanceOf(address who) public view returns (uint256);
68   function transfer(address to, uint256 value) public returns (bool);
69   event Transfer(address indexed from, address indexed to, uint256 value);
70 }
71 
72 contract BasicToken is ERC20Basic {
73   using SafeMath for uint256;
74 
75   mapping(address => uint256) balances;
76 
77   function transfer(address _to, uint256 _value) public returns (bool) {
78     require(_to != address(0));
79     require(_value <= balances[msg.sender]);
80 
81     balances[msg.sender] = balances[msg.sender].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     Transfer(msg.sender, _to, _value);
84     return true;
85   }
86 
87   function balanceOf(address _owner) public view returns (uint256 balance) {
88     return balances[_owner];
89   }
90 
91 }
92 
93 contract ERC20 is ERC20Basic {
94   function allowance(address owner, address spender) public view returns (uint256);
95   function transferFrom(address from, address to, uint256 value) public returns (bool);
96   function approve(address spender, uint256 value) public returns (bool);
97   event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 contract StandardToken is ERC20, BasicToken {
101 
102   mapping (address => mapping (address => uint256)) internal allowed;
103 
104   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[_from]);
107     require(_value <= allowed[_from][msg.sender]);
108 
109     balances[_from] = balances[_from].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
112     Transfer(_from, _to, _value);
113     return true;
114   }
115 
116   function approve(address _spender, uint256 _value) public returns (bool) {
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   function allowance(address _owner, address _spender) public view returns (uint256) {
123     return allowed[_owner][_spender];
124   }
125 
126   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
127     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
128     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
129     return true;
130   }
131 
132   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
133     uint oldValue = allowed[msg.sender][_spender];
134     if (_subtractedValue > oldValue) {
135       allowed[msg.sender][_spender] = 0;
136     } else {
137       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
138     }
139     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
140     return true;
141   }
142 
143 }
144 
145 contract BurnableToken is StandardToken {
146 
147     event Burn(address indexed burner, uint256 value);
148 
149     function burn(uint256 _value) public {
150         require(_value > 0);
151         require(_value <= balances[msg.sender]);
152 
153         address burner = msg.sender;
154         balances[burner] = balances[burner].sub(_value);
155         totalSupply = totalSupply.sub(_value);
156         Burn(burner, _value);
157     }
158 
159 }
160 
161 contract JumboBumpToken is BurnableToken, HasNoEther {
162 
163     string public constant name = "JumboBumpToken";
164     string public constant symbol = "JBT";
165     uint8 public constant decimals = 18;
166     uint256 constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(decimals));
167 
168     function JumboBumpToken() public {
169         totalSupply = INITIAL_SUPPLY;
170         balances[msg.sender] = INITIAL_SUPPLY;
171         Transfer(address(0), msg.sender, totalSupply);
172     }
173 
174     function transfer(address _to, uint256 _value) public returns (bool) {
175         return super.transfer(_to, _value);
176     }
177 
178     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
179         return super.transferFrom(_from, _to, _value);
180     }
181 
182     function multiTransfer(address[] recipients, uint256[] amounts) public {
183         require(recipients.length == amounts.length);
184         for (uint i = 0; i < recipients.length; i++) {
185             transfer(recipients[i], amounts[i]);
186         }
187     }
188 
189     function mintToken(uint256 mintedAmount) public onlyOwner {
190 			totalSupply += mintedAmount;
191 			balances[owner] += mintedAmount;
192 			Transfer(address(0), owner, mintedAmount);
193     }
194 }