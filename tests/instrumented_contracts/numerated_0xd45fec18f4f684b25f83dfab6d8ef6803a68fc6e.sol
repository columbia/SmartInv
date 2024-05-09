1 pragma solidity ^0.4.19;
2 
3 library SafeMath {
4   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
5     assert(b <= a);
6     return a - b;
7   }
8 
9   function add(uint256 a, uint256 b) internal pure returns (uint256) {
10     uint256 c = a + b;
11     assert(c >= a);
12     return c;
13   }
14 }
15 
16 contract DummyOVOToken {
17   using SafeMath for uint256;
18 
19   address public owner;
20   string public name = "ICOVO";
21   string public symbol = "OVO";
22   string public icon = "QmXMDG2UnMQ7rFqxRN2LVA3ad2FLNTarDXZijdrctt8vpo";
23   uint256 public decimals = 9;
24   uint256 public totalSupply = 0;
25 
26   event Transfer(address indexed from, address indexed to, uint256 value);
27   event Approval(address indexed owner, address indexed spender, uint256 value);
28   event Mint(address indexed to, uint256 amount);
29   event Burn(address indexed burner, uint256 amount);
30   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
31 
32   mapping (address => uint256) balances;
33   mapping (address => mapping (address => uint256)) internal allowed;
34 
35   modifier onlyOwner() {
36     require(msg.sender == owner);
37     _;
38   }
39 
40   function DummyOVOToken() public {
41     owner = msg.sender;
42   }
43 
44   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
45     totalSupply = totalSupply.add(_amount);
46     balances[_to] = balances[_to].add(_amount);
47     Mint(_to, _amount);
48     Transfer(address(0), _to, _amount);
49     return true;
50   }
51 
52   function burn(address _who, uint256 _value) onlyOwner public returns (bool) {
53     require(_value <= balances[_who]);
54 
55     balances[_who] = balances[_who].sub(_value);
56     totalSupply = totalSupply.sub(_value);
57     Burn(_who, _value);
58     Transfer(_who, address(0), _value);
59     return true;
60   }
61 
62   function transfer(address _to, uint256 _value) public returns (bool) {
63     require(_to != address(0));
64     require(_value <= balances[msg.sender]);
65 
66     balances[msg.sender] = balances[msg.sender].sub(_value);
67     balances[_to] = balances[_to].add(_value);
68     Transfer(msg.sender, _to, _value);
69     return true;
70   }
71 
72   function balanceOf(address _owner) public view returns (uint256 balance) {
73     return balances[_owner];
74   }
75 
76   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
77     require(_to != address(0));
78     require(_value <= balances[_from]);
79     require(_value <= allowed[_from][msg.sender]);
80 
81     balances[_from] = balances[_from].sub(_value);
82     balances[_to] = balances[_to].add(_value);
83     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
84     Transfer(_from, _to, _value);
85     return true;
86   }
87 
88   function approve(address _spender, uint256 _value) public returns (bool) {
89     allowed[msg.sender][_spender] = _value;
90     Approval(msg.sender, _spender, _value);
91     return true;
92   }
93 
94   function allowance(address _owner, address _spender) public view returns (uint256) {
95     return allowed[_owner][_spender];
96   }
97 
98   function transferOwnership(address newOwner) public onlyOwner {
99     require(newOwner != address(0));
100     OwnershipTransferred(owner, newOwner);
101     owner = newOwner;
102   }
103 }