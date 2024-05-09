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
16 contract HWGCToken {
17   using SafeMath for uint256;
18 
19   address public owner;
20   string public name = "HWG Cash";
21   string public symbol = "HWGC";
22   string public icon = "QmR2KRYCPnxrMNVt5GyBPdW3Bi3wHubonayvPPpmqdEM5b";
23   uint256 public decimals = 8;
24   uint256 public totalSupply = 0;
25   uint256 public cap = 5000000000000000000; // 500,000,000 x 10^10;
26 
27   event Transfer(address indexed from, address indexed to, uint256 value);
28   event Approval(address indexed owner, address indexed spender, uint256 value);
29   event Mint(address indexed to, uint256 amount);
30   event Burn(address indexed burner, uint256 amount);
31   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32 
33   mapping (address => uint256) balances;
34   mapping (address => mapping (address => uint256)) internal allowed;
35 
36   modifier onlyOwner() {
37     require(msg.sender == owner);
38     _;
39   }
40 
41   function HWGCToken() public {
42     owner = msg.sender;
43   }
44 
45   function mint(address _to, uint256 _amount) onlyOwner public returns (bool) {
46     require(totalSupply.add(_amount) <= cap);
47     totalSupply = totalSupply.add(_amount);
48     balances[_to] = balances[_to].add(_amount);
49     Mint(_to, _amount);
50     Transfer(address(0), _to, _amount);
51     return true;
52   }
53 
54   function burn(address _who, uint256 _value) onlyOwner public returns (bool) {
55     require(_value <= balances[_who]);
56 
57     balances[_who] = balances[_who].sub(_value);
58     totalSupply = totalSupply.sub(_value);
59     Burn(_who, _value);
60     Transfer(_who, address(0), _value);
61     return true;
62   }
63 
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     balances[msg.sender] = balances[msg.sender].sub(_value);
69     balances[_to] = balances[_to].add(_value);
70     Transfer(msg.sender, _to, _value);
71     return true;
72   }
73 
74   function balanceOf(address _owner) public view returns (uint256 balance) {
75     return balances[_owner];
76   }
77 
78   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
79     require(_to != address(0));
80     require(_value <= balances[_from]);
81     require(_value <= allowed[_from][msg.sender]);
82 
83     balances[_from] = balances[_from].sub(_value);
84     balances[_to] = balances[_to].add(_value);
85     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
86     Transfer(_from, _to, _value);
87     return true;
88   }
89 
90   function approve(address _spender, uint256 _value) public returns (bool) {
91     allowed[msg.sender][_spender] = _value;
92     Approval(msg.sender, _spender, _value);
93     return true;
94   }
95 
96   function allowance(address _owner, address _spender) public view returns (uint256) {
97     return allowed[_owner][_spender];
98   }
99 
100   function transferOwnership(address newOwner) public onlyOwner {
101     require(newOwner != address(0));
102     OwnershipTransferred(owner, newOwner);
103     owner = newOwner;
104   }
105 }