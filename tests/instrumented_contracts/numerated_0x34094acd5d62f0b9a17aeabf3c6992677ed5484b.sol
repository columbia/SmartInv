1 pragma solidity ^0.4.4;
2 
3 contract DNCAsset {
4     uint256 public totalSupply = 0;
5     //function balanceOf(address who) constant returns (uint);
6     //function transfer(address _to, uint _value) returns (bool);
7     event Transfer(address indexed from, address indexed to, uint value);
8 }
9 
10  
11 contract DNCReceivingContract {
12     function tokenFallback(address _from, uint _value, bytes _data);
13 }
14 
15 /* SafeMath for checking eror*/
16 library SafeMath {
17     
18   function mul(uint a, uint b) internal returns (uint) {
19     uint c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23   function div(uint a, uint b) internal returns (uint) {
24     assert(b > 0);
25     uint c = a / b;
26     assert(a == b * c + a % b);
27     return c;
28   }
29   function sub(uint a, uint b) internal returns (uint) {
30     assert(b <= a);
31     return a - b;
32   }
33   function add(uint a, uint b) internal returns (uint) {
34     uint c = a + b;
35     assert(c >= a);
36     return c;
37   }
38 
39   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
40     return a >= b ? a : b;
41   }
42   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
43     return a < b ? a : b;
44   }
45   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
46     return a >= b ? a : b;
47   }
48   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
49     return a < b ? a : b;
50   }
51   function assert(bool assertion) internal {
52     if (!assertion) {
53       throw;
54     }
55   }
56 
57 
58 }
59 
60 contract ERC223BasicToken is DNCAsset{
61     using SafeMath for uint256;
62 
63     mapping(address => uint256) balances;
64 
65     function transfer(address _to, uint _value) returns (bool success) {
66         uint codeLength;
67         bytes memory empty;
68 
69         assembly {
70             // Retrieve the size of the code on target address, this needs assembly .
71             codeLength := extcodesize(_to)
72         }
73         
74         balances[msg.sender] = balances[msg.sender].sub(_value);
75         balances[_to] = balances[_to].add(_value);
76         if(codeLength>0) {
77             DNCReceivingContract receiver = DNCReceivingContract(_to);
78             receiver.tokenFallback(msg.sender, _value, empty);
79         }
80         Transfer(msg.sender, _to, _value);
81         return true;
82     }
83 
84     function balanceOf(address _owner) constant returns (uint balance) {
85         return balances[_owner];
86     }
87 }
88 
89 contract DNCEQUITY is ERC223BasicToken{
90 	address admin;
91 	string public name = "DinarCoin";
92     string public symbol = "DNC";
93     uint public decimals = 18;
94 	mapping (address => bool) public mintable;
95 
96 	event Minted(address indexed recipient, uint256 value);
97 	event Burned(address indexed user, uint256 value);
98 
99 	function DNCEQUITY() {
100 		admin = msg.sender;
101 	}
102 
103 	modifier onlyadmin { if (msg.sender == admin) _; }
104 
105 	function changeAdmin(address _newAdminAddr) onlyadmin {
106 		admin = _newAdminAddr;
107 	}
108 
109 	function createNewMintableUser (address newAddr) onlyadmin {
110 		if(balances[newAddr] == 0)  
111     		mintable[newAddr] = true;
112 	}
113 	
114 	function deleteMintable (address addr) onlyadmin {
115 	    mintable[addr] = false;
116 	}
117 	
118 	function adminTransfer(address from, address to, uint256 value) onlyadmin {
119         if(mintable[from] == true) {
120     	    balances[from] = balances[from].sub(value);
121     	    balances[to] = balances[to].add(value);
122     	    Transfer(from, to, value);
123         }
124 	}
125 	
126 	function mintNewDNC(address user, uint256 quantity) onlyadmin {
127 	    uint256 correctedQuantity = quantity * (10**(decimals-1));
128         if(mintable[user] == true) {
129             totalSupply = totalSupply.add(correctedQuantity);
130             balances[user] = balances[user].add(correctedQuantity);
131             Transfer(0, user, correctedQuantity);
132             Minted(user, correctedQuantity);
133         }   
134 	}
135 	
136 	function burnDNC(address user, uint256 quantity) onlyadmin {
137 	    uint256 correctedQuantity = quantity * (10**(decimals-1));
138 	    if(mintable[user] == true) {
139             balances[user] = balances[user].sub(correctedQuantity);
140             totalSupply = totalSupply.sub(correctedQuantity);
141             Transfer(user, 0, correctedQuantity);
142             Burned(user, correctedQuantity);
143 	    }
144 	}
145 }