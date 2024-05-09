1 pragma solidity ^0.4.11;
2 
3 // ----------------------------------------------------------------------------
4 // 'Arteuf' (ARUF) token contract
5 // ----------------------------------------------------------------------------
6 // Symbol: ARUF
7 // Name: Arteuf
8 // Total supply: 100,000,000
9 // Decimals: 18
10 // ----------------------------------------------------------------------------
11 
12 contract Ownable {
13   address public owner;
14 
15   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
16 
17   function Ownable() public {
18     owner = msg.sender;
19   }
20 
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   function transferOwnership(address newOwner) public onlyOwner {
27     require(newOwner != address(0));
28     emit OwnershipTransferred(owner, newOwner);
29     owner = newOwner;
30   }
31 
32 }
33 
34 contract ArteufToken is Ownable{
35 
36     string public name = "Arteuf";
37     string public symbol = "ARUF";
38     uint256 public decimals = 18;
39 
40     mapping (address => uint256) public balanceOf;
41     mapping (address => mapping (address => uint256)) public allowance;
42 
43     uint256 public totalSupply = 0;
44     bool public stopped = false;
45 
46     uint256 constant valueFounder = 100000000 * 10**18;
47     address owner = 0x0;
48 
49     modifier isOwner {
50         assert(owner == msg.sender);
51         _;
52     }
53 
54     modifier isRunning {
55         assert (!stopped);
56         _;
57     }
58 
59     modifier validAddress {
60         assert(0x0 != msg.sender);
61         _;
62     }
63 
64     function ArteufToken(address _addressFounder) public {
65         owner = msg.sender;
66         totalSupply = valueFounder;
67         balanceOf[_addressFounder] = valueFounder;
68         emit Transfer(0x0, _addressFounder, valueFounder);
69     }
70 
71     function transfer(address _to, uint256 _value) public isRunning validAddress returns (bool success) {
72         require(balanceOf[msg.sender] >= _value);
73         require(balanceOf[_to] + _value >= balanceOf[_to]);
74         balanceOf[msg.sender] -= _value;
75         balanceOf[_to] += _value;
76         emit Transfer(msg.sender, _to, _value);
77         return true;
78     }
79 
80     function transferFrom(address _from, address _to, uint256 _value) public isRunning validAddress returns (bool success) {
81         require(balanceOf[_from] >= _value);
82         require(balanceOf[_to] + _value >= balanceOf[_to]);
83         require(allowance[_from][msg.sender] >= _value);
84         balanceOf[_to] += _value;
85         balanceOf[_from] -= _value;
86         allowance[_from][msg.sender] -= _value;
87         emit Transfer(_from, _to, _value);
88         return true;
89     }
90 
91     function approve(address _spender, uint256 _value) public isRunning validAddress returns (bool success) {
92         require(_value == 0 || allowance[msg.sender][_spender] == 0);
93         allowance[msg.sender][_spender] = _value;
94         emit Approval(msg.sender, _spender, _value);
95         return true;
96     }
97 
98     function stop() public isOwner {
99         stopped = true;
100     }
101 
102     function start() public isOwner {
103         stopped = false;
104     }
105 
106     function setName(string _name) public isOwner {
107         name = _name;
108     }
109 
110     function burn(uint256 _value) public {
111         require(balanceOf[msg.sender] >= _value);
112         balanceOf[msg.sender] -= _value;
113         balanceOf[0x0] += _value;
114         emit Transfer(msg.sender, 0x0, _value);
115     }
116 
117     event Transfer(address indexed _from, address indexed _to, uint256 _value);
118     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
119 }