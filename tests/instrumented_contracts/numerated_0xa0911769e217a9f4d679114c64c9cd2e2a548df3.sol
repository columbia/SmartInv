1 pragma solidity 0.4.19;
2 
3 contract Owned {
4     address public owner;
5     address public candidate;
6 
7     // The one who sent Rexpax the contract to the blockchain, will automatically become the owner of the contract
8     function Owned() internal {
9         owner = msg.sender;
10     }
11 
12     // The function containing this modifier can only call the owner of the contract
13     modifier onlyOwner {
14         require(owner == msg.sender);
15         _;
16     }
17 
18     // To change the owner of the contract, putting the candidate
19     function changeOwner(address _owner) onlyOwner public {
20         candidate = _owner;
21     }
22 
23     // The candidate must call this function to accept the proposal for the transfer of the rights of contract ownership
24     function acceptOwner() public {
25         require(candidate != address(0));
26         require(candidate == msg.sender);
27         owner = candidate;
28         delete candidate;
29     }
30 }
31 
32 // Functions for safe operation with input values (subtraction and addition)
33 library SafeMath {
34     function sub(uint a, uint b) internal pure returns (uint) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     function add(uint a, uint b) internal pure returns (uint) {
40         uint c = a + b;
41         assert(c >= a);
42         return c;
43     }
44 }
45 
46 // ERC20 interface https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
47 contract ERC20 {
48     uint public totalSupply;
49     function balanceOf(address who) public constant returns (uint balance);
50     function allowance(address owner, address spender) public constant returns (uint remaining);
51     function transfer(address to, uint value) public returns (bool success);
52     function transferFrom(address from, address to, uint value) public returns (bool success);
53     function approve(address spender, uint value) public returns (bool success);
54 
55     event Transfer(address indexed from, address indexed to, uint value);
56     event Approval(address indexed owner, address indexed spender, uint value);
57 }
58 
59 contract Skraps is ERC20, Owned {
60     using SafeMath for uint;
61 
62     string public name = "Skraps";
63     string public symbol = "SKRP";
64     uint8 public decimals = 18;
65     uint public totalSupply;
66     
67     uint private endOfFreeze = 1518912000; // Sun, 18 Feb 2018 00:00:00 GMT
68 
69     mapping (address => uint) private balances;
70     mapping (address => mapping (address => uint)) private allowed;
71 
72     function balanceOf(address _who) public constant returns (uint) {
73         return balances[_who];
74     }
75 
76     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
77         return allowed[_owner][_spender];
78     }
79 
80     function Skraps() public {
81         totalSupply = 110000000 * 1 ether;
82         balances[msg.sender] = totalSupply;
83         Transfer(0, msg.sender, totalSupply);
84     }
85 
86     function transfer(address _to, uint _value) public returns (bool success) {
87         require(_to != address(0));
88         require(now >= endOfFreeze || msg.sender == owner);
89         require(balances[msg.sender] >= _value);
90         balances[msg.sender] = balances[msg.sender].sub(_value);
91         balances[_to] = balances[_to].add(_value);
92         Transfer(msg.sender, _to, _value);
93         return true;
94     }
95 
96     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
97         require(_to != address(0));
98         require(now >= endOfFreeze || msg.sender == owner);
99         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
100         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
101         balances[_from] = balances[_from].sub(_value);
102         balances[_to] = balances[_to].add(_value);
103         Transfer(_from, _to, _value);
104         return true;
105     }
106 
107     function approve(address _spender, uint _value) public returns (bool success) {
108         require(_spender != address(0));
109         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
110         allowed[msg.sender][_spender] = _value;
111         Approval(msg.sender, _spender, _value);
112         return true;
113     }
114 
115     // Withdraws tokens from the contract if they accidentally or on purpose was it placed there
116     function withdrawTokens(uint _value) public onlyOwner {
117         require(balances[this] > 0 && balances[this] >= _value);
118         balances[this] = balances[this].sub(_value);
119         balances[msg.sender] = balances[msg.sender].add(_value);
120         Transfer(this, msg.sender, _value);
121     }
122 }