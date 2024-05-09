1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14         // benefit is lost if 'b' is also tested.
15         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16         if (a == 0) {
17             return 0;
18         }
19 
20         c = a * b;
21         assert(c / a == b);
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers, truncating the quotient.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // assert(b > 0); // Solidity automatically throws when dividing by 0
30         // uint256 c = a / b;
31         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32         return a / b;
33     }
34 
35     /**
36     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37     */
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         assert(b <= a);
40         return a - b;
41     }
42 
43     /**
44     * @dev Adds two numbers, throws on overflow.
45     */
46     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
47         c = a + b;
48         assert(c >= a);
49         return c;
50     }
51 }
52 
53 
54 contract StandardToken {
55     function totalSupply() public view returns (uint256);
56 
57     function balanceOf(address who) public view returns (uint256);
58 
59     function transfer(address to, uint256 value) public returns (bool);
60 
61     function allowance(address owner, address spender) public view returns (uint256);
62 
63     function transferFrom(address from, address to, uint256 value) public returns (bool);
64 
65     function approve(address spender, uint256 value) public returns (bool);
66 }
67 
68 contract AirDrop {
69 
70     using SafeMath for uint;
71 
72     function () payable public {}
73 
74     /**
75      * batch transfer for ERC20 token.(the same amount)
76      *
77      * @param _contractAddress ERC20 token address
78      * @param _addresses array of address to sent
79      * @param _value transfer amount
80      */
81     function batchTransferToken(address _contractAddress, address[] _addresses, uint _value) public {
82         // data validate & _addresses length limit
83         require(_addresses.length > 0);
84 
85         StandardToken token = StandardToken(_contractAddress);
86         // transfer circularly
87         for (uint i = 0; i < _addresses.length; i++) {
88             token.transferFrom(msg.sender, _addresses[i], _value);
89         }
90     }
91 
92     /**
93      * batch transfer for ERC20 token.
94      *
95      * @param _contractAddress ERC20 token address
96      * @param _addresses array of address to sent
97      * @param _value array of transfer amount
98      */
99     function batchTransferTokenS(address _contractAddress, address[] _addresses, uint[] _value) public {
100         // data validate & _addresses length limit
101         require(_addresses.length > 0);
102         require(_addresses.length == _value.length);
103 
104         StandardToken token = StandardToken(_contractAddress);
105         // transfer circularly
106         for (uint i = 0; i < _addresses.length; i++) {
107             token.transferFrom(msg.sender, _addresses[i], _value[i]);
108         }
109     }
110 
111     /**
112      * batch transfer for ETH.(the same amount)
113      *
114      * @param _addresses array of address to sent
115      */
116     function batchTransferETH(address[] _addresses) payable public {
117         // data validate & _addresses length limit
118         require(_addresses.length > 0);
119 
120         // transfer circularly
121         for (uint i = 0; i < _addresses.length; i++) {
122             _addresses[i].transfer(msg.value.div(_addresses.length));
123         }
124     }
125 
126     /**
127      * batch transfer for ETH.
128      *
129      * @param _addresses array of address to sent
130      * @param _value array of transfer amount
131      */
132     function batchTransferETHS(address[] _addresses, uint[] _value) payable public {
133         // data validate & _addresses length limit
134         require(_addresses.length > 0);
135         require(_addresses.length == _value.length);
136 
137         // transfer circularly
138         for (uint i = 0; i < _addresses.length; i++) {
139             _addresses[i].transfer(_value[i]);
140         }
141     }
142 }