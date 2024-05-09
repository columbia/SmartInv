1 pragma solidity ^0.4.11;
2 
3 /**
4  * Math operations with safety checks
5  */
6 library SafeMath {
7   function mul(uint256 a, uint256 b) internal returns (uint256) {
8     uint256 c = a * b;
9     assert(a == 0 || c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 
31   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
32     return a >= b ? a : b;
33   }
34 
35   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
36     return a < b ? a : b;
37   }
38 
39   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
40     return a >= b ? a : b;
41   }
42 
43   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
44     return a < b ? a : b;
45   }
46 
47 }
48 
49 contract Token {
50     uint256 public totalSupply;
51     function balanceOf(address _owner) constant returns (uint256 balance);
52 }
53 
54 /*  ERC 20 token */
55 contract PreSaleToken is Token {
56 
57     function balanceOf(address _owner) constant returns (uint256 balance) {
58         return balances[_owner];
59     }
60     
61     mapping (address => uint256) balances;
62 }
63 
64 contract MASSTokenPreSale is PreSaleToken {
65     using SafeMath for uint256;
66 
67     uint256 public constant decimals = 18;
68     
69     bool public isEnded = false;
70     address public contractOwner;
71     address public massEthFund;
72     uint256 public presaleStartBlock;
73     uint256 public presaleEndBlock;
74     uint256 public constant tokenExchangeRate = 1300;
75     uint256 public constant tokenCap = 13 * (10**6) * 10**decimals;
76     
77     event CreatePreSale(address indexed _to, uint256 _amount);
78     
79     function MASSTokenPreSale(address _massEthFund, uint256 _presaleStartBlock, uint256 _presaleEndBlock) {
80         massEthFund = _massEthFund;
81         presaleStartBlock = _presaleStartBlock;
82         presaleEndBlock = _presaleEndBlock;
83         contractOwner = massEthFund;
84         totalSupply = 0;
85     }
86     
87     function () payable public {
88         if (isEnded) throw;
89         if (block.number < presaleStartBlock) throw;
90         if (block.number > presaleEndBlock) throw;
91         if (msg.value == 0) throw;
92         
93         uint256 tokens = msg.value.mul(tokenExchangeRate);
94         uint256 checkedSupply = totalSupply.add(tokens);
95         
96         if (tokenCap < checkedSupply) throw;
97         
98         totalSupply = checkedSupply;
99         balances[msg.sender] += tokens;
100         CreatePreSale(msg.sender, tokens);
101     }
102     
103     function endPreSale() public {
104         require (msg.sender == contractOwner);
105         if (isEnded) throw;
106         if (block.number < presaleEndBlock && totalSupply != tokenCap) throw;
107         isEnded = true;
108         if (!massEthFund.send(this.balance)) throw;
109     }
110 }