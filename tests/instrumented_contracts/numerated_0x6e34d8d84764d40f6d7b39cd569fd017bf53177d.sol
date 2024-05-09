1 pragma solidity 0.4.19;
2 
3 contract Owned {
4     address public owner;
5     address public candidate;
6 
7     function Owned() internal {
8         owner = msg.sender;
9     }
10     
11     // A functions uses the modifier can be invoked only by the owner of the contract
12     modifier onlyOwner {
13         require(owner == msg.sender);
14         _;
15     }
16 
17     // To change the owner of the contract, putting the candidate
18     function changeOwner(address _owner) onlyOwner public {
19         candidate = _owner;
20     }
21 
22     // The candidate must call this function to accept the proposal for the transfer of the rights of contract ownership
23     function acceptOwner() public {
24         require(candidate != address(0));
25         require(candidate == msg.sender);
26         owner = candidate;
27         delete candidate;
28     }
29 }
30 
31 // Functions for safe operation with input values (subtraction and addition)
32 library SafeMath {
33     function sub(uint a, uint b) internal pure returns (uint) {
34         assert(b <= a);
35         return a - b;
36     }
37 
38     function add(uint a, uint b) internal pure returns (uint) {
39         uint c = a + b;
40         assert(c >= a);
41         return c;
42     }
43 }
44 
45 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
46 contract ERC20 {
47     uint public totalSupply;
48     function balanceOf(address who) public constant returns (uint balance);
49     function allowance(address owner, address spender) public constant returns (uint remaining);
50     function transfer(address to, uint value) public returns (bool success);
51     function transferFrom(address from, address to, uint value) public returns (bool success);
52     function approve(address spender, uint value) public returns (bool success);
53 
54     event Transfer(address indexed from, address indexed to, uint value);
55     event Approval(address indexed owner, address indexed spender, uint value);
56 }
57 
58 contract Skraps is ERC20, Owned {
59     using SafeMath for uint;
60 
61     string public name = "Skraps";
62     string public symbol = "SKRP";
63     uint8 public decimals = 18;
64     uint public totalSupply;
65 
66     uint private endOfFreeze = 1518912000; // Sun, 18 Feb 2018 00:00:00 GMT
67 
68     mapping (address => uint) private balances;
69     mapping (address => mapping (address => uint)) private allowed;
70 
71     function balanceOf(address _who) public constant returns (uint) {
72         return balances[_who];
73     }
74 
75     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
76         return allowed[_owner][_spender];
77     }
78 
79     function Skraps() public {
80         totalSupply = 110000000 * 1 ether;
81         balances[msg.sender] = totalSupply;
82         Transfer(0, msg.sender, totalSupply);
83     }
84 
85     function transfer(address _to, uint _value) public returns (bool success) {
86         require(_to != address(0));
87         require(now >= endOfFreeze || msg.sender == owner);
88         require(balances[msg.sender] >= _value);
89         balances[msg.sender] = balances[msg.sender].sub(_value);
90         balances[_to] = balances[_to].add(_value);
91         Transfer(msg.sender, _to, _value);
92         return true;
93     }
94 
95     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
96         require(_to != address(0));
97         require(now >= endOfFreeze || msg.sender == owner);
98         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
99         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
100         balances[_from] = balances[_from].sub(_value);
101         balances[_to] = balances[_to].add(_value);
102         Transfer(_from, _to, _value);
103         return true;
104     }
105 
106     function approve(address _spender, uint _value) public returns (bool success) {
107         require(_spender != address(0));
108         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
109         allowed[msg.sender][_spender] = _value;
110         Approval(msg.sender, _spender, _value);
111         return true;
112     }
113 
114     // Withdraws tokens from the contract if they accidentally or on purpose was it placed there
115     function withdrawTokens(uint _value) public onlyOwner {
116         require(balances[this] > 0 && balances[this] >= _value);
117         balances[this] = balances[this].sub(_value);
118         balances[msg.sender] = balances[msg.sender].add(_value);
119         Transfer(this, msg.sender, _value);
120     }
121 }