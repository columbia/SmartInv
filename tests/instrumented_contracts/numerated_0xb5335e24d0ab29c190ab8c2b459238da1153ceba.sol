1 pragma solidity ^0.4.18;
2 
3 contract Hexagon {
4   /* Main information */
5   string public constant name = "Hexagon";
6   string public constant symbol = "HXG";
7   uint8 public constant decimals = 4;
8   uint8 public constant burnPerTransaction = 2;
9   uint256 public constant initialSupply = 420000000000000;
10   uint256 public currentSupply = initialSupply;
11 
12   /* Create array with balances */
13   mapping (address => uint256) public balanceOf;
14   /* Create array with allowance */
15   mapping (address => mapping (address => uint256)) public allowance;
16 
17   /* Constructor */
18   function Hexagon() public {
19     /* Give creator all initial supply of tokens */
20     balanceOf[msg.sender] = initialSupply;
21   }
22 
23   /* PUBLIC */
24   /* Send tokens */
25   function transfer(address _to, uint256 _value) public returns (bool success) {
26     _transfer(msg.sender, _to, _value);
27 
28     return true;
29   }
30 
31   /* Return current supply */
32   function totalSupply() public constant returns (uint) {
33     return currentSupply;
34   }
35 
36   /* Burn tokens */
37   function burn(uint256 _value) public returns (bool success) {
38     /* Check if the sender has enough */
39     require(balanceOf[msg.sender] >= _value);
40     /* Subtract from the sender */
41     balanceOf[msg.sender] -= _value;
42     /* Send to the black hole */
43     balanceOf[0x0] += _value;
44     /* Update current supply */
45     currentSupply -= _value;
46     /* Notify network */
47     Burn(msg.sender, _value);
48 
49     return true;
50   }
51 
52   /* Allow someone to spend on your behalf */
53   function approve(address _spender, uint256 _value) public returns (bool success) {
54     /* Check if the sender has already  */
55     require(_value == 0 || allowance[msg.sender][_spender] == 0);
56     /* Add to allowance  */
57     allowance[msg.sender][_spender] = _value;
58     /* Notify network */
59     Approval(msg.sender, _spender, _value);
60 
61     return true;
62   }
63 
64   /* Transfer tokens from allowance */
65   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
66     /* Prevent transfer of not allowed tokens */
67     require(allowance[_from][msg.sender] >= _value);
68     /* Remove tokens from allowance */
69     allowance[_from][msg.sender] -= _value;
70 
71     _transfer(_from, _to, _value);
72 
73     return true;
74   }
75 
76   /* INTERNAL */
77   function _transfer(address _from, address _to, uint _value) internal {
78     /* Prevent transfer to 0x0 address. Use burn() instead  */
79     require (_to != 0x0);
80     /* Check if the sender has enough */
81     require (balanceOf[_from] >= _value + burnPerTransaction);
82     /* Check for overflows */
83     require (balanceOf[_to] + _value > balanceOf[_to]);
84     /* Subtract from the sender */
85     balanceOf[_from] -= _value + burnPerTransaction;
86     /* Add the same to the recipient */
87     balanceOf[_to] += _value;
88     /* Apply transaction fee */
89     balanceOf[0x0] += burnPerTransaction;
90     /* Update current supply */
91     currentSupply -= burnPerTransaction;
92     /* Notify network */
93     Burn(_from, burnPerTransaction);
94     /* Notify network */
95     Transfer(_from, _to, _value);
96   }
97 
98   /* Events */
99   event Transfer(address indexed from, address indexed to, uint256 value);
100   event Burn(address indexed from, uint256 value);
101   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
102 }