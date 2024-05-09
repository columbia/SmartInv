1 pragma solidity ^0.4.17;
2 
3 //Based on OpenZeppelin's SafeMath
4 library SafeMath {
5   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
6     uint256 c = a * b;
7     assert(a == 0 || c / a == b);
8     return c;
9   }
10 
11   function div(uint256 a, uint256 b) internal pure returns (uint256) {
12     uint256 c = a / b;
13     return c;
14   }
15 
16   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17     assert(b <= a);
18     return a - b;
19   }
20 
21   function add(uint256 a, uint256 b) internal pure returns (uint256) {
22     uint256 c = a + b;
23     assert(c >= a);
24     return c;
25   }
26 }
27 
28 //Presearch Token (PRE)
29 contract preToken {
30   using SafeMath for uint256;
31 
32   //Vanity settings
33   string public constant name = "Presearch";
34   string public constant symbol = "PRE";
35   uint8 public constant decimals = 18;
36   uint public totalSupply = 0;
37 
38   //Maximum supply of tokens that can ever be created 1,000,000,000
39   uint256 public constant maxSupply = 1000000000e18;
40 
41   //Supply of tokens minted for presale distribution 250,000,000
42   uint256 public constant initialSupply = 250000000e18;
43 
44   //Mappings
45   mapping (address => uint256) balances;
46   mapping (address => mapping (address => uint256)) allowed;
47 
48   //Contract owner address for additional permission
49   address public owner;
50 
51   //CrowdsaleAddress to allow for token distribution to presale purchasers before the unlockDate
52   address public crowdsaleAddress;
53 
54   //Allow trades at November 30th 2017 00:00:00 AM EST
55   uint public unlockDate = 1512018000;
56 
57   //Events
58   event Transfer(address indexed _from, address indexed _to, uint256 _value);
59   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
60   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
61 
62   //Prevent short address attack
63   modifier onlyPayloadSize(uint size) {
64      assert(msg.data.length == size + 4);
65      _;
66    }
67 
68   //Checks if now is before unlock date and the msg.sender is not the contract owner or the crowdsaleAddress
69   //Allows the owner or crowdsaleAddress to transfer before the unlock date to facilitate distribution
70   modifier tradable {
71       if (now < unlockDate && msg.sender != owner && msg.sender != crowdsaleAddress) revert();
72       _;
73     }
74 
75   //Checks if msg.sender is the contract owner
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   //Sends the initial supply of 250,000,000 tokens to the creator, sets the totalSupply, sets the owner and crowdsaleAddress to the deployer
82   function preToken() public {
83     balances[msg.sender] = initialSupply;
84     totalSupply = initialSupply;
85     owner = msg.sender;
86     crowdsaleAddress = msg.sender;
87   }
88 
89   //balances
90   function balanceOf(address _owner) public view returns (uint256 balance) {
91     return balances[_owner];
92    }
93 
94   //ERC-20 transfer with SafeMath
95   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) tradable returns (bool success) {
96     require(_to != address(0));
97     balances[msg.sender] = balances[msg.sender].sub(_value);
98     balances[_to] = balances[_to].add(_value);
99     Transfer(msg.sender, _to, _value);
100     return true;
101   }
102 
103   //ERC-20 transferFrom with SafeMath
104   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(2 * 32) tradable returns (bool success) {
105     require(_from != address(0) && _to != address(0));
106     uint256 _allowance = allowed[_from][msg.sender];
107     balances[_from] = balances[_from].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     allowed[_from][msg.sender] = _allowance.sub(_value);
110     Transfer(_from, _to, _value);
111     return true;
112   }
113 
114   //ERC-20 approve spender
115   function approve(address _spender, uint256 _value) public returns (bool success) {
116     require(_spender != address(0));
117     allowed[msg.sender][_spender] = _value;
118     Approval(msg.sender, _spender, _value);
119     return true;
120   }
121 
122   //ERC-20 allowance
123   function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
124     return allowed[_owner][_spender];
125   }
126 
127   //Allows only the contract owner to transfer ownership to someone else
128   function transferOwnership(address newOwner) public onlyOwner {
129     require(newOwner != address(0));
130     OwnershipTransferred(owner, newOwner);
131     owner = newOwner;
132   }
133 
134   //Allows only the owner to create new tokens as long as the number of tokens attempting to be minted
135   //plus the current totalSupply is less than or equal to 1,000,000,000
136   //increases the totalSupply by the amount of tokens minted
137   function mint(uint256 _amount) public onlyOwner {
138     if (totalSupply.add(_amount) <= maxSupply){
139       balances[msg.sender] = balances[msg.sender].add(_amount);
140       totalSupply = totalSupply.add(_amount);
141     }else{
142       revert();
143     }
144   }
145 
146   //Allows the contract owner to burn (destroy) their own tokens
147   //Decreases the totalSupply so that tokens could be minted again at later date
148   function burn(uint256 _amount) public onlyOwner {
149     require(balances[msg.sender] >= _amount);
150     balances[msg.sender] = balances[msg.sender].sub(_amount);
151     totalSupply = totalSupply.sub(_amount);
152   }
153 
154   //Allows the owner to set the crowdsaleAddress
155   function setCrowdsaleAddress(address newCrowdsaleAddress) public onlyOwner {
156     require(newCrowdsaleAddress != address(0));
157     crowdsaleAddress = newCrowdsaleAddress;
158   }
159 
160   //Allow the owner to update the unlockDate to allow trading sooner, but not later than the original unlockDate
161   function updateUnlockDate(uint _newDate) public onlyOwner {
162     require (_newDate <= 1512018000);
163       unlockDate=_newDate;
164   }
165 
166 }