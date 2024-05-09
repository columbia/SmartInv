1 pragma solidity 0.4.24;
2 
3 
4 contract ERC20Interface {
5 
6   event Transfer(
7     address indexed from,
8     address indexed to,
9     uint256 value
10   );
11 
12   event Approval(
13     address indexed owner,
14     address indexed spender,
15     uint256 value
16   );
17 
18   function totalSupply() public view returns (uint256);
19   function balanceOf(address _owner) public view returns (uint256);
20   function transfer(address _to, uint256 _value) public returns (bool);
21   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);
22   function approve(address _spender, uint256 _value) public returns (bool);
23   function allowance( address _owner, address _spender) public view returns (uint256);
24 
25 }
26 
27 
28 /**
29  * @title ChickenTokenDelegate
30  * @author M.H. Kang
31  */
32 interface ChickenTokenDelegate {
33 
34   function saveChickenOf(address _owner) external returns (uint256);
35   function transferChickenFrom(address _from, address _to, uint256 _value) external returns (bool);
36   function totalChicken() external view returns (uint256);
37   function chickenOf(address _owner) external view returns (uint256);
38 
39 }
40 
41 
42 /**
43  * @title ChickenTokenDelegator
44  * @author M.H. Kang
45  */
46 contract ChickenTokenDelegator is ERC20Interface {
47 
48   ChickenTokenDelegate public chickenHunt;
49   string public name = "Chicken";
50   string public symbol = "CHICKEN";
51   uint8 public decimals = 0;
52   mapping (address => mapping (address => uint256)) internal allowed;
53   address public manager;
54 
55   constructor() public {
56     manager = msg.sender;
57   }
58 
59   function transfer(address _to, uint256 _value) public returns (bool success) {
60     if (success = chickenHunt.transferChickenFrom(msg.sender, _to, _value)) {
61       emit Transfer(msg.sender, _to, _value);
62     }
63   }
64 
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66     require(_value <= allowed[_from][msg.sender]);
67     if (success = chickenHunt.transferChickenFrom(_from, _to, _value)) {
68       allowed[_from][msg.sender] -= _value;
69       emit Transfer(_from, _to, _value);
70     }
71   }
72 
73   function approve(address _spender, uint256 _value) public returns (bool) {
74     allowed[msg.sender][_spender] = _value;
75     emit Approval(msg.sender, _spender, _value);
76     return true;
77   }
78 
79   function saveChickenOf(address _owner) public returns (uint256) {
80     return chickenHunt.saveChickenOf(_owner);
81   }
82 
83   function totalSupply() public view returns (uint256) {
84     return chickenHunt.totalChicken();
85   }
86 
87   function balanceOf(address _owner) public view returns (uint256) {
88     return chickenHunt.chickenOf(_owner);
89   }
90 
91   function allowance(address _owner, address _spender) public view returns (uint256) {
92     return allowed[_owner][_spender];
93   }
94 
95   function setChickenHunt(address _chickenHunt) public onlyManager {
96     // Once set, it can not be changed.
97     require(chickenHunt == address(0));
98     chickenHunt = ChickenTokenDelegate(_chickenHunt);
99   }
100 
101   function setNameAndSymbol(string _name, string _symbol)
102     public
103     onlyManager
104   {
105     name = _name;
106     symbol = _symbol;
107   }
108 
109   /* MODIFIER */
110 
111   modifier onlyManager {
112     require(msg.sender == manager);
113     _;
114   }
115 
116 }