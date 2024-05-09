1 ////////////////////////////////////////////////////////////////////////////////
2 ///////////////////////////////// ERC223 ///////////////////////////////////////
3 library SafeMath {
4   function mul(uint a, uint b) internal returns (uint) {
5     uint c = a * b;
6     assert(a == 0 || c / a == b);
7     return c;
8   }
9   function div(uint a, uint b) internal returns (uint) {
10     // assert(b > 0); // Solidity automatically throws when dividing by 0
11     uint c = a / b;
12     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13     return c;
14   }
15   function sub(uint a, uint b) internal returns (uint) {
16     assert(b <= a);
17     return a - b;
18   }
19   function add(uint a, uint b) internal returns (uint) {
20     uint c = a + b;
21     assert(c >= a);
22     return c;
23   }
24   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
25     return a >= b ? a : b;
26   }
27   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
28     return a < b ? a : b;
29   }
30   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
31     return a >= b ? a : b;
32   }
33   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
34     return a < b ? a : b;
35   }
36   function assert(bool assertion) internal {
37     if (!assertion) {
38       throw;
39     }
40   }
41 }
42 contract ERC223Interface {
43     function balanceOf(address who) public constant returns (uint);
44     function transfer(address to, uint value) public ;
45     function transfer(address to, uint value, bytes data) public ;
46     //event Transfer(address indexed from, address indexed to, uint value, bytes data);
47     event Transfer(address indexed from, address indexed to, uint value); //ERC 20 style
48 }
49 contract ERC223ReceivingContract {
50     function tokenFallback(address _from, uint _value, bytes _data) public;
51 }
52 contract EducationToken is ERC223Interface {
53     
54     using SafeMath for uint;
55     
56     string public constant name = "Education Token";
57     string public constant symbol = "KEDU";
58     uint8  public constant decimals = 18;
59     
60     uint256 public constant totalSupply =  2000 * (10 ** 6) * (10 ** 18); // 2 billion "KEDU"
61     uint256 public constant Million     =         (10 ** 6);
62     //uint256 public nowSupply = 0;
63     
64     address public constant contractOwner = 0x21bA616f20a14bc104615Cc955F818310E725aBA;
65     
66     mapping (address => uint256) balances;
67     
68     function EducationToken() {
69         preAllocation();
70     }
71 	function preAllocation() internal {
72         balances[0x21bA616f20a14bc104615Cc955F818310E725aBA] =1400*(10**6)*(10**18); //  0% ,code writer
73         balances[0x6F34740F96C76B4C228D8EFA5EC9C71205733102] =  60*(10**6)*(10**18); // 10% ,contractOwner1
74         balances[0x33fa06cD9A1451961890532bB3F2F2b6fB817976] =  60*(10**6)*(10**18); // 10% ,contractOwner2
75         balances[0x5d49508ab79A149663F036C9e1f820F2B78EC230] =  60*(10**6)*(10**18); // 10% ,contractOwner3
76         balances[0x45bC7Ac57f10b42133abf5a92861D4AA3C5EA3e8] =  60*(10**6)*(10**18); // 10% ,contractOwner4
77         balances[0xc157F7DcA6c101Cc2c63462d4E81bF5C335EFB49] =  60*(10**6)*(10**18); // 10% ,contractOwner5
78         balances[0x1306E082444370f11039b1eC19D85Bf3dF35Bb62] =  60*(10**6)*(10**18); // 10% ,contractOwner6
79         balances[0xC45E047cD81356d655D5c061311f62BBe2d2908C] =  60*(10**6)*(10**18); // 10% ,contractOwner7
80         balances[0x42b4B6BBb2619Afd619A56aeBa1533699c3A8e8d] =  60*(10**6)*(10**18); // 10% ,contractOwner8
81         balances[0xA8e5986C88556180Db85b3288CD10f383c1C04a6] =  60*(10**6)*(10**18); // 10% ,contractOwner9
82         balances[0xA6B60801869c732B75Ee980fC53458dAc75ebe7E] =  60*(10**6)*(10**18); // 10% ,contractOwner10
83 	}
84     function() payable {
85         require(msg.value >= 0.00001 ether);
86     }
87     function getETH(uint256 _amount) public {
88         //require(now>endTime);
89         require(msg.sender==contractOwner);
90         msg.sender.transfer(_amount);
91     }
92     function nowSupply() constant public returns(uint){
93         uint supply=totalSupply;
94         supply=supply-balances[0x21bA616f20a14bc104615Cc955F818310E725aBA];
95         supply=supply-balances[0x6F34740F96C76B4C228D8EFA5EC9C71205733102];
96         supply=supply-balances[0x33fa06cD9A1451961890532bB3F2F2b6fB817976];
97         supply=supply-balances[0x5d49508ab79A149663F036C9e1f820F2B78EC230];
98         supply=supply-balances[0x45bC7Ac57f10b42133abf5a92861D4AA3C5EA3e8];
99         supply=supply-balances[0xc157F7DcA6c101Cc2c63462d4E81bF5C335EFB49];
100         supply=supply-balances[0x1306E082444370f11039b1eC19D85Bf3dF35Bb62];
101         supply=supply-balances[0xC45E047cD81356d655D5c061311f62BBe2d2908C];
102         supply=supply-balances[0x42b4B6BBb2619Afd619A56aeBa1533699c3A8e8d];
103         supply=supply-balances[0xA8e5986C88556180Db85b3288CD10f383c1C04a6];
104         supply=supply-balances[0xA6B60801869c732B75Ee980fC53458dAc75ebe7E];
105         return supply;
106     }
107     
108     /////////////////////////////////////////////////////////////////////
109     ///////////////// ERC223 Standard functions /////////////////////////
110     /////////////////////////////////////////////////////////////////////
111     function transfer(address _to, uint _value, bytes _data) public {
112         // Standard function transfer similar to ERC20 transfer with no _data .
113         // Added due to backwards compatibility reasons .
114         uint codeLength;
115         assembly {
116             // Retrieve the size of the code on target address, this needs assembly .
117             codeLength := extcodesize(_to)
118         }
119 
120         require(_value > 0);
121         require(balances[msg.sender] >= _value);
122         require(balances[_to]+_value > 0);
123         balances[msg.sender] = balances[msg.sender].sub(_value);
124         balances[_to] = balances[_to].add(_value);
125         if(codeLength>0) {
126             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
127             receiver.tokenFallback(msg.sender, _value, _data);
128         }
129         emit Transfer(msg.sender, _to, _value);
130     }
131     function transfer(address _to, uint _value) public {
132         uint codeLength;
133         bytes memory empty;
134         assembly {
135             // Retrieve the size of the code on target address, this needs assembly .
136             codeLength := extcodesize(_to)
137         }
138 
139         require(_value > 0);
140         require(balances[msg.sender] >= _value);
141         require(balances[_to]+_value > 0);
142         balances[msg.sender] = balances[msg.sender].sub(_value);
143         balances[_to] = balances[_to].add(_value);
144         if(codeLength>0) {
145             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
146             receiver.tokenFallback(msg.sender, _value, empty);
147         }
148         emit Transfer(msg.sender, _to, _value);
149     }
150     function balanceOf(address _owner) public constant returns (uint256 balance) {
151         return balances[_owner];
152     }
153 }