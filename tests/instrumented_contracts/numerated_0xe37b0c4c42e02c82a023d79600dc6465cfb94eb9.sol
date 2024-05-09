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
31   /* Burn tokens */
32   function burn(uint256 _value) public returns (bool success) {
33     /* Check if the sender has enough */
34     require(balanceOf[msg.sender] >= _value);
35     /* Subtract from the sender */
36     balanceOf[msg.sender] -= _value;
37     /* Send to the black hole */
38     balanceOf[0x0] += _value;
39     /* Update current supply */
40     currentSupply -= _value;
41     /* Notify network */
42     Burn(msg.sender, _value);
43 
44     return true;
45   }
46 
47   /* Allow someone to spend on your behalf */
48   function approve(address _spender, uint256 _value) public returns (bool success) {
49     /* Check if the sender has already  */
50     require(_value == 0 || allowance[msg.sender][_spender] == 0);
51     /* Add to allowance  */
52     allowance[msg.sender][_spender] = _value;
53     /* Notify network */
54     Approval(msg.sender, _spender, _value);
55 
56     return true;
57   }
58 
59   /* Transfer tokens from allowance */
60   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
61     /* Prevent transfer of not allowed tokens */
62     require(allowance[_from][msg.sender] >= _value);
63     /* Remove tokens from allowance */
64     allowance[_from][msg.sender] -= _value;
65 
66     _transfer(_from, _to, _value);
67 
68     return true;
69   }
70 
71   /* INTERNAL */
72   function _transfer(address _from, address _to, uint _value) internal {
73     /* Prevent transfer to 0x0 address. Use burn() instead  */
74     require (_to != 0x0);
75     /* Check if the sender has enough */
76     require (balanceOf[_from] >= _value + burnPerTransaction);
77     /* Check for overflows */
78     require (balanceOf[_to] + _value > balanceOf[_to]);
79     /* Subtract from the sender */
80     balanceOf[_from] -= _value + burnPerTransaction;
81     /* Add the same to the recipient */
82     balanceOf[_to] += _value;
83     /* Apply transaction fee */
84     balanceOf[0x0] += burnPerTransaction;
85     /* Update current supply */
86     currentSupply -= burnPerTransaction;
87     /* Notify network */
88     Burn(_from, burnPerTransaction);
89     /* Notify network */
90     Transfer(_from, _to, _value);
91   }
92 
93   /* Events */
94   event Transfer(address indexed from, address indexed to, uint256 value);
95   event Burn(address indexed from, uint256 value);
96   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
97 }