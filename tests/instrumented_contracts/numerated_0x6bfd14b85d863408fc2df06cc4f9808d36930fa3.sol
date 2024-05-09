1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 contract ERC223ReceivingContract {
34     function tokenFallback(address _from, uint _value, bytes _data);
35 }
36 
37 contract ERC223Basic {
38     uint public totalSupply;
39     function balanceOf(address who) constant returns (uint);
40     function transfer(address to, uint value);
41     function transfer(address to, uint value, bytes data);
42     event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
43 }
44 
45 contract ERC223BasicToken is ERC223Basic {
46     using SafeMath for uint;
47 
48     mapping(address => uint) balances;
49 
50     // Function that is called when a user or another contract wants to transfer funds .
51     function transfer(address to, uint value, bytes data) {
52         // Standard function transfer similar to ERC20 transfer with no _data .
53         // Added due to backwards compatibility reasons .
54         uint codeLength;
55 
56         assembly {
57             // Retrieve the size of the code on target address, this needs assembly .
58             codeLength := extcodesize(to)
59         }
60 
61         balances[msg.sender] = balances[msg.sender].sub(value);
62         balances[to] = balances[to].add(value);
63         if(codeLength>0) {
64             ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
65             receiver.tokenFallback(msg.sender, value, data);
66         }
67         Transfer(msg.sender, to, value, data);
68     }
69 
70     // Standard function transfer similar to ERC20 transfer with no _data .
71     // Added due to backwards compatibility reasons .
72     function transfer(address to, uint value) {
73         uint codeLength;
74 
75         assembly {
76             // Retrieve the size of the code on target address, this needs assembly .
77             codeLength := extcodesize(to)
78         }
79 
80         balances[msg.sender] = balances[msg.sender].sub(value);
81         balances[to] = balances[to].add(value);
82         if(codeLength>0) {
83             ERC223ReceivingContract receiver = ERC223ReceivingContract(to);
84             bytes memory empty;
85             receiver.tokenFallback(msg.sender, value, empty);
86         }
87         Transfer(msg.sender, to, value, empty);
88     }
89 
90     function balanceOf(address _owner) constant returns (uint balance) {
91         return balances[_owner];
92     }
93 }
94 
95 contract Doge2Token is ERC223BasicToken {
96 
97   string public name = "Doge2 Token";
98   string public symbol = "DOGE2";
99   uint256 public decimals = 8;
100   uint256 public INITIAL_SUPPLY = 200000000000000;
101   
102   address public owner;
103   event Buy(address indexed participant, uint tokens, uint eth);
104 
105   /**
106    * @dev Contructor that gives msg.sender all of existing tokens. 
107    */
108     function Doge2Token() {
109         totalSupply = INITIAL_SUPPLY;
110         balances[msg.sender] = INITIAL_SUPPLY;
111         owner = msg.sender;
112     }
113     
114     function () payable {
115         //lastDeposit = msg.sender;
116         //uint tokens = msg.value / 100000000;
117         uint tokens = msg.value / 10000;
118         balances[owner] -= tokens;
119         balances[msg.sender] += tokens;
120         bytes memory empty;
121         Transfer(owner, msg.sender, tokens, empty);
122         //bytes memory empty;
123         Buy(msg.sender, tokens, msg.value);
124         //if (msg.value < 0.01 * 1 ether) throw;
125         //doPurchase(msg.sender);
126     }
127     
128 }