1 contract Ownable {
2   address public owner;
3   event OwnershipRenounced(address indexed previousOwner);
4   event OwnershipTransferred(
5     address indexed previousOwner,
6     address indexed newOwner
7   );
8   constructor() public {
9     owner = msg.sender;
10   }
11   modifier onlyOwner() {
12     require(msg.sender == owner);
13     _;
14   }
15 
16   function renounceOwnership() public onlyOwner {
17     emit OwnershipRenounced(owner);
18     owner = address(0);
19   }
20   function transferOwnership(address _newOwner) public onlyOwner {
21     _transferOwnership(_newOwner);
22   }
23   function _transferOwnership(address _newOwner) internal {
24     require(_newOwner != address(0));
25     emit OwnershipTransferred(owner, _newOwner);
26     owner = _newOwner;
27   }
28 }
29 
30 contract Pausable is Ownable {
31   event Pause();
32   event Unpause();
33   bool public paused = false;
34   modifier whenNotPaused() {
35     require(!paused);
36     _;
37   }
38   modifier whenPaused() {
39     require(paused);
40     _;
41   }
42   function pause() onlyOwner whenNotPaused public {
43     paused = true;
44     emit Pause();
45   }
46   function unpause() onlyOwner whenPaused public {
47     paused = false;
48     emit Unpause();
49   }
50 }
51 
52 
53 library SafeMath {
54   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
55     uint256 c = a * b;
56     assert(a == 0 || c / a == b);
57     return c;
58   }
59   function div(uint256 a, uint256 b) internal constant returns (uint256) {
60     // assert(b > 0); // Solidity automatically throws when dividing by 0
61     uint256 c = a / b;
62     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
63     return c;
64   }
65   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
66     assert(b <= a);
67     return a - b;
68   }
69   function add(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 contract ERC200Interface {
77   string public name;
78   string public symbol;
79   uint8 public  decimals;
80   uint public totalSupply;
81   address public owner;
82 
83   function transfer(address _to, uint256 _value) public returns (bool success);
84   function transferFrom(address _from, address _to, uint256 _value) public  returns (bool success);
85   function approve(address _spender, uint256 _value)  public returns (bool success);
86   function allowance(address _owner, address _spender)  public  view returns (uint256 remaining);
87 
88   event Transfer(address indexed _from, address indexed _to, uint256 _value);
89   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
90 }
91 
92 contract ERC200T is ERC200Interface, Pausable{
93   using SafeMath for uint256;
94   mapping (address => uint256) public balanceOf;
95   mapping (address => mapping (address => uint256)) internal allowed;
96   mapping(address => uint) pendingReturns;
97 
98   constructor() public {
99       totalSupply = 21000000000000;
100       name = "KKKMToken";
101       symbol = "KKKM";
102       decimals = 3;
103       owner=msg.sender;
104       balanceOf[msg.sender] = totalSupply;
105   }
106 
107   function balanceOf(address _owner)  public  view returns (uint256 balance) {
108       return balanceOf[_owner];
109   }
110 
111   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool success) {
112     require(_to != address(0));
113     require(_value <= balanceOf[msg.sender]);
114     require(balanceOf[_to] + _value >= balanceOf[_to]);
115 
116 
117     balanceOf[msg.sender] =balanceOf[msg.sender].sub(_value);
118     balanceOf[_to] =balanceOf[_to].add(_value);
119     emit Transfer(msg.sender, _to, _value);
120     return true;
121   }
122 
123 
124 
125   function transferFrom(address _from, address _to, uint256 _value)  public  whenNotPaused returns (bool success) {
126     require(_to != address(0));
127     require(_value <= balanceOf[_from]);
128     require(_value <= allowed[_from][msg.sender]);
129     require(balanceOf[_to] + _value >= balanceOf[_to]);
130 
131     balanceOf[_from] -= _value;
132     balanceOf[_to] += _value;
133 
134     allowed[_from][msg.sender] -= _value;
135     emit Transfer(_from, _to, _value);
136     return true;
137   }
138 
139   function approve(address _spender, uint256 _value) public returns (bool success) {
140         allowed[msg.sender][_spender] = _value;
141         emit Approval(msg.sender, _spender, _value);
142         return true;
143   }
144 
145   function allowance(address _owner, address _spender) public view onlyOwner returns (uint256 remaining) {
146       return allowed[_owner][_spender];
147   }
148   function () public payable {
149     pendingReturns[msg.sender] += msg.value;
150   }
151   function withdraw() public returns (bool) {
152         uint amount = pendingReturns[msg.sender];
153         if (amount > 0) {
154             pendingReturns[msg.sender] = 0;
155             if (!msg.sender.send(amount)) {
156                 pendingReturns[msg.sender] = amount;
157                 return false;
158             }
159         }
160         return true;
161     }
162 }