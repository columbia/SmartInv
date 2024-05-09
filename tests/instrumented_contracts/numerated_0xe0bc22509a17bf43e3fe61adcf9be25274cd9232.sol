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
67     mapping (address => uint) private balances;
68     mapping (address => mapping (address => uint)) private allowed;
69 
70     function balanceOf(address _who) public constant returns (uint) {
71         return balances[_who];
72     }
73 
74     function allowance(address _owner, address _spender) public constant returns (uint remaining) {
75         return allowed[_owner][_spender];
76     }
77 
78     function Skraps() public {
79         totalSupply = 110000000 * 1 ether;
80         balances[msg.sender] = totalSupply;
81         Transfer(0, msg.sender, totalSupply);
82     }
83 
84     function transfer(address _to, uint _value) public returns (bool success) {
85         require(_to != address(0));
86         require(balances[msg.sender] >= _value);
87         balances[msg.sender] = balances[msg.sender].sub(_value);
88         balances[_to] = balances[_to].add(_value);
89         Transfer(msg.sender, _to, _value);
90         return true;
91     }
92 
93     function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
94         require(_to != address(0));
95         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
96         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
97         balances[_from] = balances[_from].sub(_value);
98         balances[_to] = balances[_to].add(_value);
99         Transfer(_from, _to, _value);
100         return true;
101     }
102 
103     function approve(address _spender, uint _value) public returns (bool success) {
104         require(_spender != address(0));
105         require((_value == 0) || (allowed[msg.sender][_spender] == 0));
106         allowed[msg.sender][_spender] = _value;
107         Approval(msg.sender, _spender, _value);
108         return true;
109     }
110 
111     // Withdraws tokens from the contract if they accidentally or on purpose was it placed there
112     function withdrawTokens(uint _value) public onlyOwner {
113         require(balances[this] > 0 && balances[this] >= _value);
114         balances[this] = balances[this].sub(_value);
115         balances[msg.sender] = balances[msg.sender].add(_value);
116         Transfer(this, msg.sender, _value);
117     }
118 }