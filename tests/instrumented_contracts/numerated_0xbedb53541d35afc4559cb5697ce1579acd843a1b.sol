1 pragma solidity ^0.4.21;
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
44   function Ownable() public {
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
81 }
82 
83 
84 contract StandardToken is ERC20 {
85   using SafeMath for uint256;
86 
87   mapping(address => uint256) balances;
88   mapping (address => mapping (address => uint256)) internal allowed;
89 
90 
91   uint256 totalSupply_;
92 
93   function totalSupply() public view returns (uint256) {
94     return totalSupply_;
95   }
96 
97   function transfer(address _to, uint256 _value) public returns (bool) {
98     require(_to != address(0));
99     require(_value <= balances[msg.sender]);
100 
101     balances[msg.sender] = balances[msg.sender].sub(_value);
102     balances[_to] = balances[_to].add(_value);
103     emit Transfer(msg.sender, _to, _value);
104     return true;
105   }
106 
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
112     require(_to != address(0));
113     require(_value <= balances[_from]);
114     require(_value <= allowed[_from][msg.sender]);
115 
116     balances[_from] = balances[_from].sub(_value);
117     balances[_to] = balances[_to].add(_value);
118     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
119     emit Transfer(_from, _to, _value);
120     return true;
121   }
122 
123   function approve(address _spender, uint256 _value) public returns (bool) {
124     allowed[msg.sender][_spender] = _value;
125     emit Approval(msg.sender, _spender, _value);
126     return true;
127   }
128 
129   function allowance(address _owner, address _spender) public view returns (uint256) {
130     return allowed[_owner][_spender];
131   }
132 
133   /* Approves and then calls the receiving contract */
134   function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
135       allowed[msg.sender][_spender] = _value;
136       emit Approval(msg.sender, _spender, _value);
137 
138       //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
139       //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
140       //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
141       if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
142       return true;
143   }
144 
145 }
146 
147 contract DCVToken is StandardToken, Ownable {
148     string constant public name = "Decentraverse Token";
149     string constant public symbol = "DCVT";
150     uint8 constant public decimals = 3;
151     uint public totalSupply = 5 * 10 ** 7 * (10 ** uint(decimals));
152 
153     function DCVToken() public {
154         balances[msg.sender] = totalSupply;
155     }
156 
157     function distributeTokens(address[] addresses, uint256[] values) onlyOwner public returns (bool success) {
158         require(addresses.length == values.length);
159         for (uint i = 0; i < addresses.length; i++) {
160             transfer(addresses[i], values[i]);
161         }
162         return true;
163     }
164 }