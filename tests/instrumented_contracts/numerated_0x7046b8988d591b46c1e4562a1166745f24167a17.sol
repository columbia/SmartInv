1 pragma solidity 0.4.21;
2 
3 contract Ownable {
4     address public owner;
5     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
6 
7     function Ownable() public {
8         owner = msg.sender;
9     }
10 
11     modifier onlyOwner() {
12         require(msg.sender == owner);
13         _;
14     }
15 
16     function transferOwnership(address newOwner) public onlyOwner {
17         require(newOwner != address(0) && newOwner != owner);
18         emit OwnershipTransferred(owner, newOwner);
19         owner = newOwner;
20     }
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         uint256 c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function div(uint256 a, uint256 b) internal pure returns (uint256) {
31         assert(b > 0); // Solidity automatically throws when dividing by 0
32         uint256 c = a / b;
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         assert(c >= a);
44         return c;
45     }
46 }
47 
48 contract UserTokensControl is Ownable {
49     address companyReserve;
50     address founderReserve;
51 }
52 
53 contract ERC223ReceivingContract {
54     function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
55         _from;
56         _value;
57         _data;
58     }
59 }
60 
61 contract ERC223 {
62     event Transfer(address indexed _from, address indexed _to, uint256 _value, bytes _data);
63 }
64 
65 contract ERC20 {
66     event Transfer(address indexed _from, address indexed _to, uint256 _value);
67 }
68 
69 contract BasicToken is ERC20, ERC223, UserTokensControl {
70     uint256 public totalSupply;
71     using SafeMath for uint256;
72 
73     mapping(address => uint256) balances;
74 
75     function transferToAddress(address _to, uint256 _value, bytes _data) internal returns (bool) {
76         balances[msg.sender] = balances[msg.sender].sub(_value);
77         balances[_to] = balances[_to].add(_value);
78         emit Transfer(msg.sender, _to, _value);
79         emit Transfer(msg.sender, _to, _value, _data);
80         return true;
81     }
82 
83     function transferToContract(address _to, uint256 _value, bytes _data) internal returns (bool) {
84         balances[msg.sender] = balances[msg.sender].sub(_value);
85         balances[_to] = balances[_to].add(_value);
86         ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
87         receiver.tokenFallback(msg.sender, _value, _data);
88         emit Transfer(msg.sender, _to, _value);
89         emit Transfer(msg.sender, _to, _value, _data);
90         return true;
91     }
92 
93     function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
94         require(_to != address(0));
95         require(_value <= balances[msg.sender]);
96         require(_value > 0);
97 
98         uint256 codeLength;
99         assembly {
100             codeLength := extcodesize(_to)
101         }
102     
103         if(codeLength > 0) {
104             return transferToContract(_to, _value, _data);
105         } else {
106             return transferToAddress(_to, _value, _data);
107         }
108     }
109 
110     function transfer(address _to, uint256 _value) public returns (bool) {
111         require(_to != address(0));
112         require(_value <= balances[msg.sender]);
113         require(_value > 0);
114 
115         uint256 codeLength;
116         bytes memory empty;
117         assembly {
118             codeLength := extcodesize(_to)
119         }
120 
121         if(codeLength > 0) {
122             return transferToContract(_to, _value, empty);
123         } else {
124             return transferToAddress(_to, _value, empty);
125         }
126     }
127 
128     function balanceOf(address _address) public constant returns (uint256 balance) {
129         return balances[_address];
130     }
131 }
132 
133 contract StandardToken is BasicToken {
134 
135     mapping (address => mapping (address => uint256)) internal allowed;
136 }
137 
138 contract Deedcoin is StandardToken {
139     string public constant name = "Deedcoin";
140     uint public constant decimals = 18;
141     string public constant symbol = "DEED";
142 
143     function Deedcoin() public {
144         totalSupply=29809525 *(10**decimals);
145         owner = msg.sender;
146         companyReserve = 0xbBE0805F7660aE0C4C7484dBee097398329eD5f2;
147         founderReserve = 0x63547A5423652ABaF323c5B4fae848C7686B28Bf;
148         balances[msg.sender] = 20866667 * (10**decimals);
149         balances[companyReserve] = 4471429 * (10**decimals); 
150         balances[founderReserve] = 4471429 * (10**decimals);
151     }
152 
153     function() public {
154         revert();
155     }
156 }