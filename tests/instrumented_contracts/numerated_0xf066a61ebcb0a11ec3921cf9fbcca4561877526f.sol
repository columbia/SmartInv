1 pragma solidity ^0.4.20;
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
15     uint256 c = a / b;
16     return c;
17   }
18 
19   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20     assert(b <= a);
21     return a - b;
22   }
23 
24   function add(uint256 a, uint256 b) internal pure returns (uint256) {
25     uint256 c = a + b;
26     assert(c >= a);
27     return c;
28   }
29 }
30 
31 contract Ownable {    
32     address public owner;
33     
34     function Ownable() public {
35         owner = msg.sender;
36     }
37  
38     modifier onlyOwner() {
39         require(msg.sender == owner);
40         _;
41     }
42 }
43 
44 contract MasterNodeMining is Ownable{
45     using SafeMath for uint;
46     string public constant name = "Master Node Mining"; // Master Node Mining tokens name
47     string public constant symbol = "MNM"; // Master Node Mining tokens ticker
48     uint8 public constant decimals = 18; // Master Node Mining tokens decimals
49     uint256 public constant maximumSupply =  10000000 * (10 ** uint256(decimals)); // Maximum 10M MNM tokens can be created
50     uint256 public constant icoSupply =  9000000 * (10 ** uint256(decimals)); // Maximum 9M MNM tokens can be available for public ICO
51     uint256 public constant TokensPerEther = 1000;
52     uint256 public constant icoEnd = 1522540800;
53     uint256 public constant teamTokens = 1538352000;
54     address public multisig = 0xF33014a0A4Cf06df687c02023C032e42a4719573;
55     uint256 public totalSupply;
56 
57     function transfer(address _to, uint _value) public returns (bool success) {
58 		require( msg.data.length >= (2 * 32) + 4 );
59 		require( _value > 0 );
60 		require( balances[msg.sender] >= _value );
61 		require( balances[_to] + _value > balances[_to] );
62         balances[msg.sender] -= _value;
63         balances[_to] += _value;
64         Transfer(msg.sender, _to, _value);
65         return true;
66     }
67 
68     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
69 		require( msg.data.length >= (3 * 32) + 4 );
70 		require( _value > 0 );
71 		require( balances[_from] >= _value );
72 		require( allowed[_from][msg.sender] >= _value );
73 		require( balances[_to] + _value > balances[_to] );
74         balances[_from] -= _value;
75 		allowed[_from][msg.sender] -= _value;
76 		balances[_to] += _value;
77         Transfer(_from, _to, _value);
78         return true;
79     }
80 
81     function balanceOf(address _owner) public constant returns (uint balance) {
82         return balances[_owner];
83     }
84 
85     function approve(address _spender, uint _value) public returns (bool success) {
86         allowed[msg.sender][_spender] = _value;
87         Approval(msg.sender, _spender, _value);
88         return true;
89     }
90 
91     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
92         return allowed[_owner][_spender];
93     }
94 
95     event Transfer(address indexed _from, address indexed _to, uint _value);
96     event Approval(address indexed _owner, address indexed _spender, uint _value);
97 
98     mapping (address => uint) balances;
99     mapping (address => mapping (address => uint)) allowed;
100 
101     function ICOmint() public onlyOwner {
102       require(totalSupply == 0);
103       totalSupply = icoSupply;
104       balances[msg.sender] = icoSupply;
105       Transfer(0x0, msg.sender, icoSupply);
106     }
107 
108     function TEAMmint() public onlyOwner {
109       uint256 addSupply = maximumSupply - totalSupply;
110       uint256 currentSupply = totalSupply + addSupply;
111       require(now > teamTokens);
112       require(totalSupply > 0 && addSupply > 0);
113       require(maximumSupply >= currentSupply);
114       totalSupply += addSupply;
115       balances[owner] += addSupply;
116     }
117 
118     function() external payable {
119         uint256 tokens = msg.value.mul(TokensPerEther);
120         require(now < icoEnd && balances[owner] >= tokens && tokens >= 0);
121         balances[msg.sender] += tokens;
122         balances[owner] -= tokens;
123         Transfer(owner,msg.sender, tokens);
124         multisig.transfer(msg.value);
125     }
126 }