1 pragma solidity >0.4.22 <0.5.0;
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
57     string public constant symbol = "EDUTEST";
58     uint8  public constant decimals = 18;
59     
60     uint256 public constant TotalSupply =  2 * (10 ** 9) * (10 ** 18); // 2 billion
61     uint256 public constant Million     =      (10 ** 6);
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
72         balances[0x21bA616f20a14bc104615Cc955F818310E725aBA] =   0*(10**6)*(10**18); //  0% ,code writer
73         balances[0x096AE211869e5DFF9d231717762640E50D53f96C] = 400*(10**6)*(10**18); // 20% ,contractOwner0
74         balances[0x9089e320B026338c2E03FCFc07e97d76ca208B00] = 400*(10**6)*(10**18); // 20% ,contractOwner1
75         balances[0xF357ab5623e828C3A535a1dc4B356E96885885f1] = 400*(10**6)*(10**18); // 20% ,contractOwner2
76         balances[0x57F8558e895Db16c45754CE48fef8ea81B71b3F3] = 400*(10**6)*(10**18); // 20% ,contractOwner3
77         balances[0x377F514196DD32A2b8b48E16065b81e61c40c5F2] = 400*(10**6)*(10**18); // 20% ,contractOwner4
78 	}
79     function() payable {
80         require(msg.value >= 0.0000001 ether);
81     }
82     function getETH(uint256 _amount) public {
83         //require(now>endTime);
84         require(msg.sender==contractOwner);
85         msg.sender.transfer(_amount);
86     }
87     function nowSupply() constant public returns(uint){
88         uint supply=TotalSupply;
89         supply=supply-balances[0x21bA616f20a14bc104615Cc955F818310E725aBA];
90         supply=supply-balances[0x096AE211869e5DFF9d231717762640E50D53f96C];
91         supply=supply-balances[0x9089e320B026338c2E03FCFc07e97d76ca208B00];
92         supply=supply-balances[0xF357ab5623e828C3A535a1dc4B356E96885885f1];
93         supply=supply-balances[0x57F8558e895Db16c45754CE48fef8ea81B71b3F3];
94         supply=supply-balances[0x377F514196DD32A2b8b48E16065b81e61c40c5F2];
95         return supply;
96     }
97     
98     /////////////////////////////////////////////////////////////////////
99     ///////////////// ERC223 Standard functions /////////////////////////
100     /////////////////////////////////////////////////////////////////////
101     function transfer(address _to, uint _value, bytes _data) public {
102         // Standard function transfer similar to ERC20 transfer with no _data .
103         // Added due to backwards compatibility reasons .
104         uint codeLength;
105         assembly {
106             // Retrieve the size of the code on target address, this needs assembly .
107             codeLength := extcodesize(_to)
108         }
109 
110         require(_value > 0);
111         require(balances[msg.sender] >= _value);
112         require(balances[_to]+_value > 0);
113         balances[msg.sender] = balances[msg.sender].sub(_value);
114         balances[_to] = balances[_to].add(_value);
115         if(codeLength>0) {
116             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
117             receiver.tokenFallback(msg.sender, _value, _data);
118         }
119         emit Transfer(msg.sender, _to, _value);
120     }
121     function transfer(address _to, uint _value) public {
122         uint codeLength;
123         bytes memory empty;
124         assembly {
125             // Retrieve the size of the code on target address, this needs assembly .
126             codeLength := extcodesize(_to)
127         }
128 
129         require(_value > 0);
130         require(balances[msg.sender] >= _value);
131         require(balances[_to]+_value > 0);
132         balances[msg.sender] = balances[msg.sender].sub(_value);
133         balances[_to] = balances[_to].add(_value);
134         if(codeLength>0) {
135             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
136             receiver.tokenFallback(msg.sender, _value, empty);
137         }
138         emit Transfer(msg.sender, _to, _value);
139     }
140     function balanceOf(address _owner) public constant returns (uint256 balance) {
141         return balances[_owner];
142     }
143     
144     function totalSupply() public view returns (uint256) {
145     return TotalSupply;
146   }
147 }