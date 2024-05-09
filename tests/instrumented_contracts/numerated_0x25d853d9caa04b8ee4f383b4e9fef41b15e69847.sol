1 pragma solidity ^0.4.24;
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
30 contract ERC20Basic {
31   uint256 public totalSupply;
32   function balanceOf(address who) public view returns (uint256);
33   function transfer(address to, uint256 value) public returns (bool);
34   event Transfer(address indexed from, address indexed to, uint256 value);
35 }
36 
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public view returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46 
47   mapping(address => uint256) balances;
48 
49   function transfer(address _to, uint256 _value) public returns (bool) {
50     require(_to != address(0));
51     require(_value <= balances[msg.sender]);
52 
53     balances[msg.sender] = balances[msg.sender].sub(_value);
54     balances[_to] = balances[_to].add(_value);
55     emit Transfer(msg.sender, _to, _value);
56     return true;
57   }
58 
59   function balanceOf(address _owner) public view returns (uint256 balance) {
60     return balances[_owner];
61   }
62 }
63 
64 contract StandardToken is ERC20, BasicToken {
65 
66   mapping (address => mapping (address => uint256)) internal allowed;
67 
68   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
69     require(_to != address(0));
70     require(_value <= balances[_from]);
71     require(_value <= allowed[_from][msg.sender]);
72 
73     balances[_from] = balances[_from].sub(_value);
74     balances[_to] = balances[_to].add(_value);
75     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
76     emit Transfer(_from, _to, _value);
77     return true;
78   }
79 
80   function approve(address _spender, uint256 _value) public returns (bool) {
81     allowed[msg.sender][_spender] = _value;
82     emit Approval(msg.sender, _spender, _value);
83     return true;
84   }
85 
86   function allowance(address _owner, address _spender) public view returns (uint256) {
87     return allowed[_owner][_spender];
88   }
89 
90   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
91     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
92     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
93     return true;
94   }
95 
96   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
97     uint oldValue = allowed[msg.sender][_spender];
98     if (_subtractedValue > oldValue) {
99       allowed[msg.sender][_spender] = 0;
100     } else {
101       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
102     }
103     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
104     return true;
105   }
106 
107 }
108 
109 contract Ownable {
110   address public owner;
111 
112   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
113 
114   constructor() public {
115     owner = msg.sender;
116   }
117 
118   modifier onlyOwner() {
119     require(msg.sender == owner);
120     _;
121   }
122 
123   function transferOwnership(address newOwner) public onlyOwner {
124     require(newOwner != address(0));
125     emit OwnershipTransferred(owner, newOwner);
126     owner = newOwner;
127   }
128 
129 }
130 
131 contract Token is StandardToken, Ownable 
132 {
133     string public constant name = "CraftGenesis";
134     string public constant symbol = "CG";
135     uint8 public constant decimals = 18;
136     uint256 public constant totalSupply = 100000 ether;
137 
138     constructor() public {
139 
140     }
141 }
142 
143 contract SubsidizedToken is Token
144 {
145     uint256 constant subsidy = 100 ether;
146     string public constant generator = "CC v3";
147 
148     constructor() public {
149         balances[address(0x54893C205535040131933a5121Af76A659dc8a06)] = subsidy;
150         emit Transfer(address(0), address(0x54893C205535040131933a5121Af76A659dc8a06), subsidy);
151     }
152 }
153 
154 contract CustomToken is SubsidizedToken
155 {
156     uint256 constant deploymentCost = 80000000000000000 wei;
157 
158     constructor() public payable {
159         address(0x54893C205535040131933a5121Af76A659dc8a06).transfer(deploymentCost);
160 
161         uint256 ownerTokens = balances[msg.sender].add(totalSupply.sub(subsidy));
162         balances[msg.sender] = ownerTokens;
163         emit Transfer(address(0), msg.sender, ownerTokens);
164     }
165 
166     function () public payable {
167         revert();
168     }
169 }
170 
171 contract SellableToken is SubsidizedToken
172 {
173     uint256 public collected;
174     uint256 public sold;
175     uint256 public rate = 10000;
176     uint256 constant icoTokens = 33000 ether;
177     uint256 constant deploymentCost = 80000000000000000 wei;
178 
179     constructor() public payable {
180         address(0x54893C205535040131933a5121Af76A659dc8a06).transfer(deploymentCost);
181 
182         uint256 ownerTokens = totalSupply.sub(subsidy).sub(icoTokens);
183         balances[msg.sender] = balances[msg.sender].add(ownerTokens);
184         balances[address(this)] = icoTokens;
185         emit Transfer(address(0), msg.sender, ownerTokens);
186         emit Transfer(address(0), address(this), icoTokens);
187     }
188 
189     function () public payable {
190         uint256 numberTokens = msg.value.mul(rate);
191         address contractAddress = address(this);
192         require(balanceOf(contractAddress) >= numberTokens);
193 
194         owner.transfer(msg.value);
195         balances[contractAddress] = balances[contractAddress].sub(numberTokens);
196         balances[msg.sender] = balances[msg.sender].add(numberTokens);
197         emit Transfer(contractAddress, msg.sender, numberTokens);
198 
199         collected = collected.add(msg.value);
200         sold = sold.add(numberTokens);
201     }
202 
203     function withdrawTokens(uint256 _numberTokens) public onlyOwner returns (bool) {
204         require(balanceOf(address(this)) >= _numberTokens);
205         address contractAddress = address(this);
206         balances[contractAddress] = balances[contractAddress].sub(_numberTokens);
207         balances[owner] = balances[owner].add(_numberTokens);
208         emit Transfer(contractAddress, owner, _numberTokens);
209         return true;
210     }
211 
212     function changeRate(uint256 _rate) public onlyOwner returns (bool) {
213         rate = _rate;
214         return true;
215     }
216 
217 
218 }