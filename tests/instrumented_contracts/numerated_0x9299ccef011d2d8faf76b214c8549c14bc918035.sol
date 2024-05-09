1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8   function add(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a + b;
10     assert(c >= a);
11     return c;
12   }
13 }
14 
15 contract Ownable {
16   address public owner;
17   event OwnershipRenounced(address indexed previousOwner);
18   event OwnershipTransferred(
19     address indexed previousOwner,
20     address indexed newOwner
21   );
22   constructor() public {
23     owner = msg.sender;
24   }
25 
26   modifier onlyOwner() {
27     require(msg.sender == owner);
28     _;
29   }
30   function transferOwnership(address newOwner) public onlyOwner {
31     require(newOwner != address(0));
32     emit OwnershipTransferred(owner, newOwner);
33     owner = newOwner;
34   }
35 }
36 
37 contract ERC20Basic  is Ownable {
38   function totalSupply() public view returns (uint256);
39   function balanceOf(address who) public view returns (uint256);
40   function transfer(address to, uint256 value) public returns (bool);
41   event Transfer(address indexed from, address indexed to, uint256 value);
42 }
43 
44 contract BasicToken is ERC20Basic {
45   using SafeMath for uint256;
46   mapping(address => uint256) balances;
47   uint256 totalSupply_;
48 
49   function totalSupply() public view returns (uint256) {
50     return totalSupply_;
51   }
52 
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56     balances[msg.sender] = balances[msg.sender].sub(_value);
57     balances[_to] = balances[_to].add(_value);
58     emit Transfer(msg.sender, _to, _value);
59     return true;
60   }
61   function balanceOf(address _owner) public view returns (uint256 balance) {
62     return balances[_owner];
63   }
64 }
65 
66 contract ERC20 is ERC20Basic {
67   function allowance(address owner, address spender) public view returns (uint256);
68   function transferFrom(address from, address to, uint256 value) public returns (bool);
69   function approve(address spender, uint256 value) public returns (bool);
70   event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 contract StandardToken is ERC20, BasicToken {
74   mapping (address => mapping (address => uint256)) internal allowed;
75   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
76     require(_to != address(0));
77     require(_value <= balances[_from]);
78     require(_value <= allowed[_from][msg.sender]);
79     balances[_from] = balances[_from].sub(_value);
80     balances[_to] = balances[_to].add(_value);
81     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
82     emit Transfer(_from, _to, _value);
83     return true;
84   }
85   function approve(address _spender, uint256 _value) public returns (bool) {
86     allowed[msg.sender][_spender] = _value;
87     emit Approval(msg.sender, _spender, _value);
88     return true;
89   }
90   function allowance(address _owner, address _spender) public view returns (uint256) {
91     return allowed[_owner][_spender];
92   }
93   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
94     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
95     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
96     return true;
97   }
98   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
99     uint oldValue = allowed[msg.sender][_spender];
100     if (_subtractedValue > oldValue) {
101       allowed[msg.sender][_spender] = 0;
102     } else {
103       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
104     }
105     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
106     return true;
107   }
108 }
109 contract ITGCToken is StandardToken {
110     string  public name = "Itgolds";
111     string  public symbol = "ITGC";
112     uint8   public decimals = 8;
113     uint    public totalSupply = (20 * 10 ** 8 + 50) * 10 ** 8;
114     constructor() public {
115         balances[msg.sender] = totalSupply;
116     }
117 
118     function setName(string _name) public onlyOwner {
119     	name = _name;
120     }
121 
122     function setSymbol(string _symbol) public onlyOwner {
123     	symbol = _symbol;
124     }
125 }