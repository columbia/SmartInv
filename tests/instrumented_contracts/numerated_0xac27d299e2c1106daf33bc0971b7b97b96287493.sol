1 pragma solidity ^0.4.16;
2 
3 contract ERC223Basic {
4     uint256 public totalSupply = 0;
5     function balanceOf(address who) constant returns (uint);
6     function transfer(address _to, uint _value) returns (bool);
7     event Transfer(address indexed from, address indexed to, uint value);
8 }
9 
10  /*
11  * Contract that is working with ERC223 tokens
12  */
13  
14 contract ERC223ReceivingContract {
15     function tokenFallback(address _from, uint _value, bytes _data);
16 }
17 
18 /**
19  * @title SafeMath
20  * @dev Math operations with safety checks that throw on error
21  */
22 library SafeMath {
23   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
24     uint256 c = a * b;
25     assert(a == 0 || c / a == b);
26     return c;
27   }
28  
29   function div(uint256 a, uint256 b) internal constant returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35  
36   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40  
41   function add(uint256 a, uint256 b) internal constant returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 
47 //   function assert(bool assertion) internal {
48 //     if (!assertion) revert();
49 //   }
50 }
51 
52 contract ERC223BasicToken is ERC223Basic{
53     using SafeMath for uint256;
54 
55     mapping(address => uint256) balances;
56 
57     // Standard function transfer similar to ERC20 transfer with no _data .
58     // Added due to backwards compatibility reasons .
59     function transfer(address _to, uint _value) returns (bool success) {
60         uint codeLength;
61         bytes memory empty;
62 
63         assembly {
64             // Retrieve the size of the code on target address, this needs assembly .
65             codeLength := extcodesize(_to)
66         }
67         
68         balances[msg.sender] = balances[msg.sender].sub(_value);
69         balances[_to] = balances[_to].add(_value);
70         if(codeLength>0) {
71             ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
72             receiver.tokenFallback(msg.sender, _value, empty);
73         }
74         Transfer(msg.sender, _to, _value);
75         return true;
76     }
77 
78     function balanceOf(address _owner) constant returns (uint balance) {
79         return balances[_owner];
80     }
81 }
82 
83 contract GoldBank is ERC223BasicToken{
84 	address admin;
85 	string public name = "DinarCoin";
86     string public symbol = "DNC";
87     uint public decimals = 18;
88 	mapping (address => bool) public mintable;
89 
90 	event Minted(address indexed recipient, uint256 value);
91 	event Burned(address indexed user, uint256 value);
92 
93 	function GoldBank() {
94 		admin = msg.sender;
95 	}
96 
97 	modifier onlyadmin { if (msg.sender == admin) _; }
98 
99 	function changeAdmin(address _newAdminAddr) onlyadmin {
100 		admin = _newAdminAddr;
101 	}
102 
103 	function createNewMintableUser (address newAddr) onlyadmin {
104 		if(balances[newAddr] == 0)  
105     		mintable[newAddr] = true;
106 	}
107 	
108 	function deleteMintable (address addr) onlyadmin {
109 	    mintable[addr] = false;
110 	}
111 	
112 	function adminTransfer(address from, address to, uint256 value) onlyadmin {
113         if(mintable[from] == true) {
114     	    balances[from] = balances[from].sub(value);
115     	    balances[to] = balances[to].add(value);
116     	    Transfer(from, to, value);
117         }
118 	}
119 	
120 	function mintNewDNC(address user, uint256 quantity) onlyadmin {
121 	    uint256 correctedQuantity = quantity * (10**(decimals-1));
122         if(mintable[user] == true) {
123             totalSupply = totalSupply.add(correctedQuantity);
124             balances[user] = balances[user].add(correctedQuantity);
125             Transfer(0, user, correctedQuantity);
126             Minted(user, correctedQuantity);
127         }   
128 	}
129 	
130 	function burnDNC(address user, uint256 quantity) onlyadmin {
131 	    uint256 correctedQuantity = quantity * (10**(decimals-1));
132 	    if(mintable[user] == true) {
133             balances[user] = balances[user].sub(correctedQuantity);
134             totalSupply = totalSupply.sub(correctedQuantity);
135             Transfer(user, 0, correctedQuantity);
136             Burned(user, correctedQuantity);
137 	    }
138 	}
139 }