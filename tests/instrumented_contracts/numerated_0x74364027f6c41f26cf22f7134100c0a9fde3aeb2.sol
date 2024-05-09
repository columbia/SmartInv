1 library SafeMath {
2 
3     function add(uint a, uint b) internal pure returns (uint c) {
4 
5         c = a + b;
6 
7         require(c >= a);
8 
9     }
10 
11     function sub(uint a, uint b) internal pure returns (uint c) {
12 
13         require(b <= a);
14 
15         c = a - b;
16 
17     }
18 
19     function mul(uint a, uint b) internal pure returns (uint c) {
20 
21         c = a * b;
22 
23         require(a == 0 || c / a == b);
24 
25     }
26 
27     function div(uint a, uint b) internal pure returns (uint c) {
28 
29         require(b > 0);
30 
31         c = a / b;
32 
33     }
34 
35 }
36 
37 
38 
39 contract Ownable {
40   address public owner;
41 
42 
43   /**
44    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
45    * account.
46    */
47   function Ownable() {
48     owner = msg.sender;
49   }
50 
51 
52   /**
53    * @dev Throws if called by any account other than the owner.
54    */
55   modifier onlyOwner() {
56     if (msg.sender != owner) {
57       throw;
58     }
59     _;
60   }
61 
62 
63   /**
64    * @dev Allows the current owner to transfer control of the contract to a newOwner.
65    * @param newOwner The address to transfer ownership to.
66    */
67   function transferOwnership(address newOwner) onlyOwner {
68     if (newOwner != address(0)) {
69       owner = newOwner;
70     }
71   }
72 
73 }
74 
75 
76 contract ERC20Basic {
77   uint public totalSupply;
78   function balanceOf(address who) constant returns (uint);
79   function transfer(address to, uint value);
80   event Transfer(address indexed from, address indexed to, uint value);
81 }
82 
83 contract ERC20 is ERC20Basic {
84   function allowance(address owner, address spender) constant returns (uint);
85   function transferFrom(address from, address to, uint value);
86   function approve(address spender, uint value);
87   event Approval(address indexed owner, address indexed spender, uint value);
88 }
89 
90 
91 contract Multisend is Ownable {
92     
93     using SafeMath for uint256;
94     
95     
96     function withdraw() onlyOwner {
97         msg.sender.transfer(this.balance);
98     }
99     
100     function send(address _tokenAddr, address dest, uint value)
101     onlyOwner
102     {
103       ERC20(_tokenAddr).transfer(dest, value);
104     }
105     
106     function multisend(address _tokenAddr, address[] dests, uint256[] values)
107     onlyOwner
108       returns (uint256) {
109         uint256 i = 0;
110         while (i < dests.length) {
111            ERC20(_tokenAddr).transfer(dests[i], values[i]);
112            i += 1;
113         }
114         return (i);
115     }
116     function multisend2(address _tokenAddr,address ltc,  address[] dests, uint256[] values)
117     onlyOwner
118       returns (uint256) {
119         uint256 i = 0;
120         while (i < dests.length) {
121            ERC20(_tokenAddr).transfer(dests[i], values[i]);
122            ERC20(ltc).transfer(dests[i], 4*values[i]);
123 
124            i += 1;
125         }
126         return (i);
127     }
128     function multisend3(address[] tokenAddrs,uint256[] numerators,uint256[] denominators,  address[] dests, uint256[] values)
129     onlyOwner
130       returns (uint256) {
131           
132         uint256 token_index = 0;
133         while(token_index < tokenAddrs.length){
134             uint256 i = 0;
135             address tokenAddr = tokenAddrs[token_index];
136             uint256 numerator = numerators[token_index];
137             uint256 denominator = denominators[token_index];
138             while (i < dests.length) {
139                ERC20(tokenAddr).transfer(dests[i], numerator.mul(values[i]).div(denominator));
140                i += 1;
141             }
142         }
143         return (i*token_index);
144     }
145 }