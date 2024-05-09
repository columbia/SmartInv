1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     if (a == 0) {
7       return 0;
8     }
9     uint256 c = a * b;
10     assert(c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract Ownable {
34   address public owner;
35 
36 
37   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
38 
39 
40   /**
41    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
42    * account.
43    */
44   constructor() public {
45     owner = msg.sender;
46   }
47 
48 
49   /**
50    * @dev Throws if called by any account other than the owner.
51    */
52   modifier onlyOwner() {
53     require(msg.sender == owner);
54     _;
55   }
56 
57 
58   /**
59    * @dev Allows the current owner to transfer control of the contract to a newOwner.
60    * @param newOwner The address to transfer ownership to.
61    */
62   function transferOwnership(address newOwner) public onlyOwner {
63     require(newOwner != address(0));
64     emit OwnershipTransferred(owner, newOwner);
65     owner = newOwner;
66   }
67 
68 }
69 
70 contract ERC20 {
71   function totalSupply() public view returns (uint256);
72   function balanceOf(address who) public view returns (uint256);
73   function transfer(address to, uint256 value) public returns (bool);
74   
75   function allowance(address owner, address spender) public view returns (uint256);
76   function transferFrom(address from, address to, uint256 value) public returns (bool);
77   function approve(address spender, uint256 value) public returns (bool);
78   
79   event Transfer(address indexed from, address indexed to, uint256 value);
80   event Approval(address indexed owner, address indexed spender, uint256 value);
81   event Burn(address indexed from, uint256 value);
82 }
83 
84 
85 contract StandardToken is ERC20 {
86   using SafeMath for uint256;
87 
88   mapping(address => uint256) balances;
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91 
92   uint256 totalSupply_;
93 
94   function totalSupply() public view returns (uint256) {
95     return totalSupply_;
96   }
97   
98   function reduceTotalSupply(uint _amount) internal returns (bool) {
99       require(totalSupply_ >= _amount);
100       totalSupply_ = totalSupply_.sub(_amount);
101       return true;
102   }
103 
104   function transfer(address _to, uint256 _value) public returns (bool) {
105     require(_to != address(0));
106     require(_value <= balances[msg.sender]);
107     require(balances[_to] + _value >= balances[_to]);
108 
109     balances[msg.sender] = balances[msg.sender].sub(_value);
110     balances[_to] = balances[_to].add(_value);
111     emit Transfer(msg.sender, _to, _value);
112     return true;
113   }
114 
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
120     require(_to != address(0));
121     require(_value <= balances[_from]);
122     require(_value <= allowed[_from][msg.sender]);
123     require(balances[_to] + _value >= balances[_to]);
124 
125     balances[_from] = balances[_from].sub(_value);
126     balances[_to] = balances[_to].add(_value);
127     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
128     emit Transfer(_from, _to, _value);
129     return true;
130   }
131 
132   function approve(address _spender, uint256 _value) public returns (bool) {
133     allowed[msg.sender][_spender] = _value;
134     emit Approval(msg.sender, _spender, _value);
135     return true;
136   }
137 
138   function allowance(address _owner, address _spender) public view returns (uint256) {
139     return allowed[_owner][_spender];
140   }
141 
142   /* Approves and then calls the receiving contract */
143   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
144     allowed[msg.sender][_spender] = _value;
145     emit Approval(msg.sender, _spender, _value);
146 
147     //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
148     //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
149     //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
150     if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
151     return true;
152   }
153 }
154 
155 contract ESGToken is StandardToken, Ownable {
156   string constant public name = "Elevate Stargem";
157   string constant public symbol = "ESG";
158   uint8 constant public decimals = 18;
159 
160   constructor() public {
161     totalSupply_ = 5 * 10 ** 8 * (10 ** uint(decimals)); // total supply is 500 million
162     balances[msg.sender] = totalSupply_;
163   }
164 
165   function distributeTokens(address[] addresses, uint256[] values) onlyOwner public returns (bool success) {
166     require(addresses.length == values.length);
167     for (uint i = 0; i < addresses.length; i++) {
168         transfer(addresses[i], values[i]);
169     }
170     return true;
171   }
172   
173   function burn(uint256 _value) public returns (bool success) {
174     require(balances[msg.sender] >= _value);
175     balances[msg.sender] -= _value;
176     reduceTotalSupply(_value);
177     emit Burn(msg.sender, _value);
178     return true;
179   }
180 }